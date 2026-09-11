#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Two separately requested bounded tests; never loads/unloads modules.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EXPECTED=7.1.0-sm8150-ga0ca2cbb4b3d
VERSION=iris1-swpc-ofref-hot2
MODE="${1:---decode}"
[[ $# -le 1 && ( "$MODE" == --decode || "$MODE" == --encode ) ]] || {
    echo '用法：bash test-codecs.sh --decode；解码通过后另行执行 --encode。'; exit 2;
}
fail() { echo "停止：$*" >&2; exit 1; }
[[ $EUID -eq 0 ]] || fail '请使用 sudo bash。'
for c in ffmpeg timeout flock dmesg sha256sum cmp stat grep awk tr; do
    command -v "$c" >/dev/null || fail "缺少 $c。"
done
[[ "$(uname -r)" == "$EXPECTED" && "$(uname -m)" == aarch64 ]] || fail '内核不匹配。'
(cd "$HERE" && sha256sum --status -c SHA256SUMS) || fail '测试包校验失败。'
P=/sys/bus/platform/devices/aa00000.video-codec
BOOT=$(cat /proc/sys/kernel/random/boot_id)
STATE="/run/venus-hot2-$BOOT"
[[ -s "$STATE/loaded-version" && "$(cat "$STATE/loaded-version")" == "$VERSION" ]] || fail '请先成功执行本包 load.sh --load。'
[[ "$(cat /sys/module/venus_core/version)" == "$VERSION" ]] || fail '当前不是指定修补版 core。'
[[ -L "$P/driver" && "$(cat "$P/power/control")" == on ]] || fail 'Venus 绑定或电源设置不符合本轮测试。'
exec 9>/run/venus-hot2.lock
flock -n 9 || fail '已有本包操作运行，不能并发。'
healthy() {
    local taint
    read -r taint < /proc/sys/kernel/tainted
    [[ "$taint" =~ ^[0-9]+$ ]] && (( (taint & (2|8|16|32|128|512|16384)) == 0 ))
}
healthy || fail '内核已有 WARN/Oops/异常，不再提交视频；保存日志后重启。'
OUT=$(cat "$STATE/logdir")
[[ "$OUT" == /var/tmp/venus-hot2.* && -d "$OUT" && ! -L "$OUT" ]] || fail '本轮日志目录不合法。'
[[ "$(cat "$OUT/boot-id")" == "$BOOT" ]] || fail '测试状态属于另一次启动。'
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
DIRECTION=${MODE#--}
NODE=$(node_for "qcom-venus-${DIRECTION}r") || fail "找不到唯一的 $DIRECTION 节点。"
# Both runs are single-attempt; any failure must be inspected rather than looped.
[[ ! -e "$STATE/$DIRECTION.started" ]] || fail "$DIRECTION 在本次启动已经执行，拒绝自动重试。"
if [[ "$MODE" == --encode ]]; then
    [[ -s "$STATE/decode.success" ]] || fail '必须先通过本次启动的连续解码及像素对照。'
fi
LOG="$OUT/$DIRECTION.log"
exec > >(exec 9>&-; tee -a "$LOG") 2>&1
MARK="VENUS_HOT2_${DIRECTION}_${BOOT}_$$"
PHASE=prepare
CAPTURE_STARTED=0
finish() {
    local rc=$?
    trap - EXIT INT TERM
    set +e
    dmesg > "$OUT/kernel-after-$DIRECTION.log"
    printf 'exit=%s\nphase=%s\nhardware_attempt=%s\n' "$rc" "$PHASE" "$CAPTURE_STARTED" > "$OUT/$DIRECTION-result.txt"
    echo "=== 本次内核日志（$DIRECTION） ==="
    awk -v mark="$MARK" 'index($0,mark){s=1} s' "$OUT/kernel-after-$DIRECTION.log" | tail -n 70
    echo "日志目录：$OUT"
    echo '不会卸载或换回旧模块；失败时不要继续编码/重试，先反馈日志。'
    exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
EXPECTED_BYTES=$((640*480*3/2*30))
echo "方向：$DIRECTION；节点：$NODE；640x480 / 15fps / 30帧。"
if [[ "$MODE" == --decode ]]; then
    # Generate a deterministic short stream without touching the hardware encoder.
    timeout -s INT -k 3s 20s ffmpeg -hide_banner -loglevel error -nostdin -y \
        -f lavfi -i testsrc2=size=640x480:rate=15 -frames:v 30 -an \
        -c:v libx264 -threads 2 -preset ultrafast -profile:v baseline \
        -pix_fmt yuv420p -bf 0 "$OUT/input.mp4"
    timeout -s INT -k 3s 20s ffmpeg -hide_banner -loglevel error -nostdin -y \
        -c:v h264 -i "$OUT/input.mp4" -map 0:v:0 -an -sn -dn \
        -fps_mode passthrough -pix_fmt nv12 -c:v rawvideo -threads 2 \
        -f rawvideo "$OUT/reference.nv12"
    [[ "$(stat -c %s "$OUT/reference.nv12")" == "$EXPECTED_BYTES" ]] || fail '软件参考帧数不匹配，不进行硬解。'
fi
healthy || fail '准备样片期间出现内核异常。'
PHASE=hardware
mkdir "$STATE/$DIRECTION.started"
echo "$MARK" > /dev/kmsg
grep -i venus /proc/interrupts > "$OUT/$DIRECTION-irq-before.txt" || true
CAPTURE_STARTED=1
set +e
if [[ "$MODE" == --decode ]]; then
    timeout -s INT -k 3s 15s ffmpeg -hide_banner -loglevel verbose -nostdin -y -xerror \
        -c:v h264_v4l2m2m -i "$OUT/input.mp4" -map 0:v:0 -an -sn -dn \
        -fps_mode passthrough -pix_fmt nv12 -c:v rawvideo -threads 2 \
        -f rawvideo "$OUT/decoded.nv12" > "$OUT/ffmpeg-decode.log" 2>&1
    RC=$?
else
    timeout -s INT -k 3s 15s ffmpeg -hide_banner -loglevel verbose -nostdin -y -xerror \
        -f rawvideo -pixel_format nv12 -video_size 640x480 -framerate 15 \
        -i "$OUT/reference.nv12" -map 0:v:0 -an \
        -c:v h264_v4l2m2m -b:v 1000000 -g 15 -bf 0 \
        -f h264 "$OUT/encoded.h264" > "$OUT/ffmpeg-encode.log" 2>&1
    RC=$?
fi
set -e
PHASE=verify_output
echo "=== FFmpeg $DIRECTION 退出码：$RC ==="
tail -n 30 "$OUT/ffmpeg-$DIRECTION.log"
echo '=== Venus IRQ 前 / 后 ==='
cat "$OUT/$DIRECTION-irq-before.txt"
grep -i venus /proc/interrupts || true
(( RC == 0 )) || exit "$RC"
grep -Fq "Using device $NODE" "$OUT/ffmpeg-$DIRECTION.log" || fail 'FFmpeg 未确认使用预期 Venus 节点。'
healthy || fail '测试后内核有警告/异常，不能判为通过。'
if [[ "$MODE" == --decode ]]; then
    [[ "$(stat -c %s "$OUT/decoded.nv12")" == "$EXPECTED_BYTES" ]] || fail '硬解输出不是完整30帧；请检查日志。'
    if ! cmp -s "$OUT/reference.nv12" "$OUT/decoded.nv12"; then
        echo '输出字节数正确，但与软件参考不完全一致；不自动进入编码测试。'
        sha256sum "$OUT/reference.nv12" "$OUT/decoded.nv12"
        exit 2
    fi
    echo 'PASS：H.264连续输出30帧NV12，完整退出，像素与软件参考逐字节一致。'
else
    [[ -s "$OUT/encoded.h264" ]] || fail '编码码流为空。'
    # Software decode of encoded data; lossy encoding is not expected to be bit-exact.
    timeout -s INT -k 3s 20s ffmpeg -hide_banner -loglevel error -nostdin -y -xerror \
        -c:v h264 -i "$OUT/encoded.h264" -map 0:v:0 -an \
        -fps_mode passthrough -pix_fmt nv12 -c:v rawvideo -threads 2 \
        -f rawvideo "$OUT/encoded-roundtrip.nv12"
    [[ "$(stat -c %s "$OUT/encoded-roundtrip.nv12")" == "$EXPECTED_BYTES" ]] || fail '编码后的软件回验不足30帧或尺寸不符。'
    echo 'PASS：NV12硬编H.264，软件回验得到完整30帧；未评价码率精度/画质或长期稳定性。'
fi
PHASE=success
printf '%s\n' "$VERSION" > "$STATE/$DIRECTION.success"
echo '修补版仍保持加载；没有自动恢复旧模块，也没有继续其他测试。'
