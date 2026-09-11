#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Run only on the target phone. No persistent module install or /boot writes.
set -Eeuo pipefail

# Quarantined after the first-frame test crashed during original-module reload.
# Keep the former body below for review; never reach its unload/load commands.
printf '%s\n' '此热替换测试已暂停：首帧解码成功，但恢复原版模块时出现段错误。' >&2
printf '%s\n' '不要再次执行热替换；先保存恢复阶段的内核日志，不要继续编解码。' >&2
exit 1

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EXPECTED=7.1.0-sm8150-ga0ca2cbb4b3d
TEST_VERSION=iris1-swpc-sessiondiag-1
P=/sys/bus/platform/devices/aa00000.video-codec
INPUT="${1:-/tmp/venus-dec.M9IIJu/input.mp4}"
MODULE="$HERE/venus-core.ko"
[[ $EUID -eq 0 ]] || { echo '请在手机上使用 sudo bash 执行。'; exit 1; }
[[ "$(uname -r)" == "$EXPECTED" && "$(uname -m)" == aarch64 ]] || {
    echo "只适用于 ARM64 $EXPECTED，停止。"; exit 1;
}
for c in modprobe modinfo insmod fuser ffmpeg timeout sha256sum mktemp dmesg; do
    command -v "$c" >/dev/null || { echo "缺少 $c，未改动模块。"; exit 1; }
done
[[ -s "$INPUT" && -s "$MODULE" && -f "$HERE/SHA256SUMS" ]] || {
    echo '测试样片或测试包不完整，未改动模块。'; exit 1;
}
(cd "$HERE" && sha256sum -c SHA256SUMS)
[[ "$(modinfo -F version "$MODULE")" == "$TEST_VERSION" ]] || exit 1
[[ "$(modinfo -F vermagic "$MODULE")" == "$(modinfo -F vermagic venus_core)" ]] || {
    echo '模块 vermagic 不匹配；不会强制加载。'; exit 1;
}
BASE_MODULE="$(modinfo -n venus_core)"
read -r BASE_HASH < "$HERE/original-core.sha256"
[[ "$(sha256sum "$BASE_MODULE" | cut -d' ' -f1)" == "$BASE_HASH" ]] || {
    echo '已安装的 Venus core 与本测试基线不一致，停止。'; exit 1;
}
[[ -L "$P/driver" && "$(cat "$P/power/control")" == on ]] || {
    echo '请保持上次已成功绑定且 power/control=on 的状态；未改动模块。'; exit 1;
}
[[ ! -e /sys/module/venus_core/version ]] || {
    echo '检测到带版本标记的 Venus core，停止，避免叠加测试模块。'; exit 1;
}
for f in /sys/class/video4linux/video*/name; do
    [[ -f "$f" ]] || continue
    case "$(cat "$f")" in
        qcom-venus-encoder|qcom-venus-decoder)
            node="/dev/$(basename "$(dirname "$f")")"
            if fuser "$node" >/dev/null 2>&1; then
                echo "$node 正在使用，先关闭相关应用；未改动模块。"; exit 1;
            fi ;;
    esac
done
OUT="$(mktemp -d /tmp/venus-session-once.XXXXXX)"
exec > >(tee "$OUT/run.log") 2>&1
MUTATED=0
restore_original() {
    local rc=$? current=''
    trap - EXIT INT TERM
    set +e
    if (( MUTATED )); then
        echo '=== 恢复已安装的原版 Venus 模块 ==='
        current=$(cat /sys/module/venus_core/version 2>/dev/null)
        if [[ "$current" == "$TEST_VERSION" ]]; then
            if ! modprobe -r venus_dec venus_enc venus_core; then
                echo '测试模块仍被占用，未强制卸载。停止测试；重启会加载磁盘上的原版。'
                echo "日志：$OUT"; exit 1;
            fi
        fi
        if ! modprobe -a venus_core venus_dec venus_enc; then
            echo '原版模块重新加载失败，停止测试并保留日志；未修改磁盘上的模块或启动文件。'
            rc=1
        elif [[ -e /sys/module/venus_core/version ]]; then
            echo '模块版本标记仍存在，不能确认恢复完成。'; rc=1
        else
            echo '原版模块已重新加载；power/control 保持 on。'
        fi
    fi
    echo "日志目录：$OUT"
    exit "$rc"
}
trap restore_original EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
MARK="VENUS_SESSION_ONCE_$(date +%s)_$$"
echo "$MARK" > /dev/kmsg
printf '测试模块：%s\n目标版本：%s\n' "$TEST_VERSION" "$EXPECTED"
MUTATED=1
# Without force: any active reference makes unloading fail rather than bypassing it.
modprobe -r venus_dec venus_enc venus_core
insmod "$MODULE"
modprobe -a venus_dec venus_enc
[[ "$(cat /sys/module/venus_core/version)" == "$TEST_VERSION" && -L "$P/driver" ]] || {
    echo '测试模块未成功绑定，不提交视频。'; exit 1;
}
DECODER=''
for n in {1..20}; do
    for f in /sys/class/video4linux/video*/name; do
        [[ -f "$f" ]] || continue
        if [[ "$(cat "$f")" == qcom-venus-decoder ]]; then
            DECODER="/dev/$(basename "$(dirname "$f")")"
        fi
    done
    [[ -n "$DECODER" && -c "$DECODER" ]] && break
    sleep 0.1
done
[[ -n "$DECODER" && -c "$DECODER" ]] || { echo '解码节点未出现。'; exit 1; }
echo "解码节点：$DECODER"
grep -i venus /proc/interrupts > "$OUT/irq-before.txt" || true
set +e
timeout -s INT -k 3s 8s \
    ffmpeg -hide_banner -loglevel verbose -nostdin -xerror \
    -c:v h264_v4l2m2m -i "$INPUT" -map 0:v:0 -an -sn -dn \
    -frames:v 1 -fps_mode passthrough -pix_fmt nv12 -f rawvideo "$OUT/frame.nv12" \
    > "$OUT/ffmpeg.log" 2>&1
RC=$?
set -e
echo "=== FFmpeg 退出码：$RC ==="
tail -n 24 "$OUT/ffmpeg.log"
echo '=== 中断计数：前 / 后 ==='
cat "$OUT/irq-before.txt"
grep -i venus /proc/interrupts || true
if [[ -f "$OUT/frame.nv12" ]]; then
    echo "输出文件字节数：$(stat -c %s "$OUT/frame.nv12")"
fi
echo '=== 本次内核日志 ==='
dmesg | awk -v mark="$MARK" 'index($0,mark){show=1} show' > "$OUT/kernel.log"
tail -n 50 "$OUT/kernel.log"
echo '单次测试结束，不会继续编码、压力测试或自动重试。'
exit "$RC"
