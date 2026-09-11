#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# One separate encoder experiment after verified paced decode. No module actions.
# Never create decode.success: the unpaced decoder initialization bug is OPEN.
set -Eeuo pipefail
fail() { echo "停止：$*" >&2; exit 1; }
[[ $# -eq 1 ]] || fail '用法：bash encode-after-paced.sh /var/tmp/venus-hot2.*/gfmt-paced.*'
[[ $EUID -eq 0 ]] || fail '请使用 sudo bash。'
for c in ffmpeg timeout flock dmesg cmp stat grep awk sha256sum realpath fuser cp tee; do
    command -v "$c" >/dev/null || fail "缺少 $c，未提交硬件任务。"
done
EXPECTED=7.1.0-sm8150-ga0ca2cbb4b3d
VERSION=iris1-swpc-ofref-hot2
P=/sys/bus/platform/devices/aa00000.video-codec
[[ "$(uname -r)" == "$EXPECTED" && "$(uname -m)" == aarch64 ]] || fail '内核/架构不匹配。'
[[ -d "$1" && ! -L "$1" ]] || fail '限速日志目录不存在或是符号链接。'
PACED=$(realpath -e -- "$1")
D=$(dirname -- "$PACED")
[[ "$D" == /var/tmp/venus-hot2.* && "$(basename -- "$PACED")" == gfmt-paced.* ]] || fail '不是指定的hot2限速诊断目录。'
BOOT=$(cat /proc/sys/kernel/random/boot_id)
STATE=/run/venus-hot2-$BOOT
[[ -d "$STATE" && ! -L "$STATE" ]] || fail '本次启动没有hot2加载记录。'
[[ "$(cat "$STATE/loaded-version")" == "$VERSION" && "$(cat "$STATE/logdir")" == "$D" ]] || fail 'hot2状态与日志目录不对应。'
[[ "$(cat "$D/boot-id")" == "$BOOT" ]] || fail '样片证据来自其他启动。'
exec 9>/run/venus-hot2.lock
flock -n 9 || fail '有其他Venus测试运行，不能并发。'
healthy() {
    local taint
    read -r taint < /proc/sys/kernel/tainted
    [[ "$taint" =~ ^[0-9]+$ ]] && (( (taint & (2|8|16|32|128|512|16384)) == 0 ))
}
healthy || fail '内核已有WARN/Oops等异常，不提交编码。'
[[ "$(cat /sys/module/venus_core/version)" == "$VERSION" ]] || fail '当前不是hot2修补版。'
[[ -L "$P/driver" && "$(cat "$P/power/control")" == on ]] || fail 'Venus绑定/电源状态不符。'
node_for() {
    local name="$1" f node='' count=0
    for f in /sys/class/video4linux/video*/name; do
        [[ -f "$f" ]] || continue
        if [[ "$(cat "$f")" == "$name" ]]; then
            node="/dev/$(basename "$(dirname "$f")")"; count=$((count+1))
        fi
    done
    [[ $count -eq 1 && -c "$node" ]] || return 1
    printf '%s\n' "$node"
}
DECODER=$(node_for qcom-venus-decoder) || fail '没有唯一解码节点。'
ENCODER=$(node_for qcom-venus-encoder) || fail '没有唯一编码节点。'
for node in "$DECODER" "$ENCODER"; do
    if fuser "$node" >/dev/null 2>&1; then fail "$node 被其他应用占用。"; fi
done
for f in "$PACED/result.txt" "$PACED/kernel.log" "$PACED/ffmpeg.log" "$PACED/decoded.nv12" "$D/reference.nv12"; do
    [[ -f "$f" && ! -L "$f" ]] || fail "缺少普通文件：$f"
done
grep -Fxq 'exit=0' "$PACED/result.txt" || fail '限速测试没有正常退出。'
grep -Fxq 'input_pacing=-re' "$PACED/result.txt" || fail '缺少限速实验标记。'
grep -Fq "VENUS_GFMT_PACED_${BOOT}_" "$PACED/kernel.log" || fail '限速内核日志不属于本次启动。'
grep -Fq "Using device $DECODER" "$PACED/ffmpeg.log" || fail '限速日志未确认使用本机Venus解码器。'
BYTES=$((640*480*3/2*30))
[[ "$(stat -c %s "$D/reference.nv12")" == "$BYTES" && "$(stat -c %s "$PACED/decoded.nv12")" == "$BYTES" ]] || fail '参考或限速输出不是30帧NV12。'
cmp -s "$D/reference.nv12" "$PACED/decoded.nv12" || fail '限速像素对照不通过，停止。'
[[ ! -e "$STATE/encode.started" ]] || fail '本次启动已执行过编码，拒绝重复。'
OUT=$(mktemp -d "$D/encode-after-paced.XXXXXX")
exec > >(exec 9>&-; tee "$OUT/run.log") 2>&1
MARK=VENUS_ENCODE_AFTER_PACED_${BOOT}_$$
PHASE=prepare
HARDWARE_ATTEMPT=0
finish() {
    local rc=$?
    trap - EXIT INT TERM
    set +e
    dmesg > "$OUT/kernel.log"
    printf 'exit=%s\nphase=%s\nhardware_attempt=%s\nunpaced_decoder=UNRESOLVED\n' "$rc" "$PHASE" "$HARDWARE_ATTEMPT" > "$OUT/result.txt"
    echo '=== 本次内核日志 ==='
    awk -v m="$MARK" 'index($0,m){s=1} s' "$OUT/kernel.log" | tail -n 70
    echo "日志目录：$OUT"
    echo '保留hot2模块；不卸载、不回装旧版、不自动重试，不把全速解码标成通过。'
    exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
# A private immutable-for-this-test input; never overwrite any prior evidence.
cp -- "$D/reference.nv12" "$OUT/input.nv12"
sha256sum "$D/reference.nv12" "$PACED/decoded.nv12" "$OUT/input.nv12" > "$OUT/input-sha256.txt"
printf 'decoder_evidence=%s\ncondition=input_pacing_-re\nencoder=%s\n' "$PACED" "$ENCODER" > "$OUT/preflight.txt"
healthy || fail '准备期间出现内核异常。'
mkdir "$STATE/encode.started" || fail '编码已启动过，停止。'
echo "$MARK" > /dev/kmsg
grep -i venus /proc/interrupts > "$OUT/irq-before.txt" || true
PHASE=hardware
HARDWARE_ATTEMPT=1
set +e
timeout -s INT -k 3s 15s ffmpeg -hide_banner -loglevel verbose -nostdin -y -xerror \
    -f rawvideo -pixel_format nv12 -video_size 640x480 -framerate 15 \
    -i "$OUT/input.nv12" -map 0:v:0 -an \
    -c:v h264_v4l2m2m -pix_fmt nv12 -b:v 1000000 -g 15 -bf 0 \
    -f h264 "$OUT/encoded.h264" > "$OUT/ffmpeg-encode.log" 2>&1
RC=$?
set -e
echo "=== 硬编码 FFmpeg 退出码：$RC ==="
cat "$OUT/ffmpeg-encode.log"
echo '=== Venus IRQ 前 / 后 ==='
cat "$OUT/irq-before.txt"
grep -i venus /proc/interrupts || true
(( RC == 0 )) || exit "$RC"
healthy || fail '编码期间出现内核异常，不进入软件回验。'
grep -Fq "Using device $ENCODER" "$OUT/ffmpeg-encode.log" || fail '未确认选择了预期硬编码设备。'
[[ -s "$OUT/encoded.h264" ]] || fail '编码输出为空。'
PHASE=software_verify
set +e
timeout -s INT -k 3s 20s ffmpeg -hide_banner -loglevel verbose -nostdin -y -xerror \
    -c:v h264 -i "$OUT/encoded.h264" -map 0:v:0 -an -sn -dn \
    -fps_mode passthrough -pix_fmt nv12 -c:v rawvideo -threads 2 \
    -f rawvideo "$OUT/roundtrip.nv12" > "$OUT/ffmpeg-roundtrip.log" 2>&1
RC=$?
set -e
echo "=== 软件解码回验退出码：$RC ==="
tail -n 22 "$OUT/ffmpeg-roundtrip.log"
(( RC == 0 )) || exit "$RC"
ACTUAL=$(stat -c %s "$OUT/roundtrip.nv12")
echo "回验NV12字节数：$ACTUAL；应为$BYTES。"
[[ "$ACTUAL" == "$BYTES" ]] || fail '编码后的回验帧数或尺寸不符。'
healthy || fail '测试后内核状态异常。'
PHASE=success
printf '%s\n' "$VERSION" > "$STATE/encode-after-paced.success"
echo 'PASS：NV12硬编H.264，软件回验得到30帧；画质、码率精度和长期稳定性尚未验收。'
