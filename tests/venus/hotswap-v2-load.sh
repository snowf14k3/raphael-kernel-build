#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# One-way, volatile replacement from an unbound ORIGINAL Venus driver.
# NEVER attempt restoration to the known-bad old core in an EXIT trap.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EXPECTED=7.1.0-sm8150-ga0ca2cbb4b3d
VERSION=iris1-swpc-ofref-hot2
P=/sys/bus/platform/devices/aa00000.video-codec
SYS_MODULE=/sys/module
VIDEO_CLASS=/sys/class/video4linux
BOOT_ID_FILE=/proc/sys/kernel/random/boot_id
TAINT_FILE=/proc/sys/kernel/tainted
RUN_ROOT=/run
LOG_ROOT=/var/tmp
MODE="${1:---check}"
case "$MODE" in
    --check|--load) ;;
    *) echo '用法：bash load.sh --check 或 bash load.sh --load'; exit 2;;
esac
[[ $# -le 1 ]] || exit 2
fail() { printf '停止：%s\n' "$*" >&2; exit 1; }
[[ $EUID -eq 0 ]] || fail '请使用 sudo bash。'
for c in uname modinfo insmod rmmod modprobe sha256sum dmesg grep tr cat readlink mktemp flock tee awk basename dirname chmod mkdir sleep; do
    command -v "$c" >/dev/null || fail "缺少 $c；未改动模块。"
done
[[ "$(uname -r)" == "$EXPECTED" && "$(uname -m)" == aarch64 ]] || fail "只适用于 ARM64 $EXPECTED。"
[[ -r "$TAINT_FILE" && -r "$BOOT_ID_FILE" ]] || fail '不能核实当前启动状态。'
read -r BOOT < "$BOOT_ID_FILE"
[[ "$BOOT" =~ ^[0-9a-f-]{36}$ ]] || fail '异常 boot ID。'
STATE="$RUN_ROOT/venus-hot2-$BOOT"
# This lock is transient and only serializes this test package's operations.
exec 9>"$RUN_ROOT/venus-hot2.lock"
flock -n 9 || fail '已有本测试包操作在运行。'
[[ ! -e "$STATE" ]] || fail '本次启动已尝试过此替换，不能叠加或自动重试；保留日志后重启。'
[[ -s "$HERE/venus-core.ko" && -s "$HERE/SHA256SUMS" && -s "$HERE/original-modules.sha256" ]] || fail '测试包不完整。'
(cd "$HERE" && sha256sum --status -c SHA256SUMS) || fail '测试包校验失败。'
[[ "$(modinfo -F version "$HERE/venus-core.ko")" == "$VERSION" ]] || fail '候选模块标记错误。'
# Verify all three installed disk modules. Do not infer loaded identity from vermagic alone.
for m in venus_core venus_dec venus_enc; do
    [[ -d "$SYS_MODULE/$m" ]] || fail "原版 $m 未加载；请从正常重启后的状态开始，不手工重绑。"
    [[ ! -e "$SYS_MODULE/$m/version" ]] || fail "检测到带版本标记的 $m；不接受前一次测试状态。"
    mt=$(cat "$SYS_MODULE/$m/taint") || fail '无法检查模块 taint。'
    [[ ! "$mt" =~ [OPFE] ]] || fail "$m 不是本轮接受的原版加载状态。"
    path=$(modinfo -n "$m")
    hash=$(sha256sum "$path"); hash=${hash%% *}
    expected_hash=$(awk -v m="$m" '$2==m {print $1}' "$HERE/original-modules.sha256")
    [[ "$hash" =~ ^[0-9a-f]{64}$ && "$hash" == "$expected_hash" ]] || fail "$m 的磁盘文件不匹配已发布版本。"
done
[[ "$(modinfo -F vermagic "$HERE/venus-core.ko")" == "$(modinfo -F vermagic venus_core)" ]] || fail 'vermagic 不匹配；不会强制加载。'
[[ -d "$P" && -r "$P/power/control" && -r "$P/of_node/compatible" ]] || fail 'Venus 父设备或设备树链接异常，请重启。'
tr '\0' '\n' < "$P/of_node/compatible" | grep -Fxq 'qcom,sm8150-venus' || fail '设备不匹配。'
# Do not run the known-buggy original driver's remove callback on a bound instance.
[[ ! -L "$P/driver" ]] || fail '旧 Venus 已绑定。请先正常重启；重启后不要再执行 power/control=on + bind，直接运行本包。'
for child in video-decoder video-encoder; do
    [[ ! -e "$P/of_node/$child" ]] || fail '设备树残留 codec 子节点，拒绝热替换。'
done
for f in "$VIDEO_CLASS"/video*/name; do
    [[ -f "$f" ]] || continue
    case "$(cat "$f")" in qcom-venus-*) fail '仍有 Venus 视频节点，拒绝卸载。';; esac
done
safe_boot() {
    local taint count bootlog
    read -r taint < "$TAINT_FILE"
    [[ "$taint" =~ ^[0-9]+$ ]] || return 1
    # F/R/M/B/D/W/L: forced module operations, machine/page errors, Oops/WARN/lockup.
    (( (taint & (2|8|16|32|128|512|16384)) == 0 )) || return 1
    bootlog=$(dmesg) || return 1
    if grep -Eq 'refcount_t:|Unable to handle kernel|Internal error:|Oops:|BUG:|Kernel panic|Error .*creating of_node link' <<< "$bootlog"; then return 1; fi
    count=$(grep -c 'qcom-venus aa00000.video-codec: non legacy binding' <<< "$bootlog" || true)
    # Accept only the untouched boot-time failed probe; no retry in this boot.
    [[ "$count" == 1 ]] || return 1
    grep -q 'qcom-venus aa00000.video-codec: probe with driver qcom-venus failed with error -110' <<< "$bootlog"
}
safe_boot || fail '当前不是可接受的干净首次 probe 状态（可能有 WARN/Oops/重复绑定）。保存日志后正常重启，再直接运行本包。'
printf '预检查通过：%s；旧驱动未绑定；不强制卸载、不写磁盘模块。\n' "$EXPECTED"
[[ "$MODE" == --load ]] || { echo '这里只完成检查；尚未改动模块。'; exit 0; }
OUT=$(mktemp -d "$LOG_ROOT/venus-hot2.XXXXXX")
chmod 700 "$OUT"
exec > >(exec 9>&-; tee -a "$OUT/load.log") 2>&1
MARK="VENUS_HOT2_LOAD_${BOOT}_$$"
PHASE=preflight
MUTATED=0
finish() {
    local rc=$?
    trap - EXIT INT TERM
    set +e
    dmesg > "$OUT/kernel-after-load.log"
    printf 'exit=%s\nphase=%s\nmutated=%s\n' "$rc" "$PHASE" "$MUTATED" > "$OUT/load-result.txt"
    echo "加载日志：$OUT"
    if (( rc != 0 )); then
        echo '已停止；不会回装旧模块，也不会再次加载候选模块。先保存日志，之后正常重启。'
    else
        echo '修补版保留在本次启动内存中，power/control=on；不会自动换回旧版。'
    fi
    exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
safe_boot || fail '预检查后启动状态发生变化。'
[[ ! -L "$P/driver" ]] || fail '旧驱动在预检查后绑定，停止。'
mkdir -m 700 "$STATE" || fail '本次启动已存在替换记录。'
printf '%s\n' "$OUT" > "$STATE/logdir"
printf '%s\n' "$BOOT" > "$OUT/boot-id"
dmesg > "$OUT/kernel-before-load.log"
echo "$MARK" > /dev/kmsg
MUTATED=1
PHASE=remove_unbound_original
# rmmod has no dependency-pruning or automatic reload behavior, and no -f is used.
rmmod venus_dec
rmmod venus_enc
rmmod venus_core
[[ ! -d "$SYS_MODULE/venus_core" ]] || fail '旧 core 未退出。'
PHASE=pin_runtime_power
printf 'on\n' > "$P/power/control"
PHASE=load_fixed_core
insmod "$HERE/venus-core.ko"
[[ "$(cat "$SYS_MODULE/venus_core/version")" == "$VERSION" && -L "$P/driver" ]] || fail '候选 core 未成功绑定，不加载其他 codec。'
[[ "$(basename "$(readlink -f "$P/driver")")" == qcom-venus ]] || fail '驱动绑定不匹配。'
PHASE=load_unchanged_codecs
# These are byte-identical published decoder/encoder drivers; the fixed core is already loaded.
modprobe -a venus_dec venus_enc
PHASE=verify_nodes
found=0
for ((i=0;i<20;i++)); do
    found=0
    for f in "$VIDEO_CLASS"/video*/name; do
        [[ -f "$f" ]] || continue
        case "$(cat "$f")" in
            qcom-venus-decoder) found=$((found|1));;
            qcom-venus-encoder) found=$((found|2));;
        esac
    done
    (( found == 3 )) && break
    sleep 0.1
done
(( found == 3 )) || fail '两个 codec 节点未就绪。'
read -r taint < "$TAINT_FILE"
(( (taint & (2|8|16|32|128|512|16384)) == 0 )) || fail '加载后发现新的警告或内核异常，停止测试。'
[[ "$(cat "$P/power/control")" == on && "$(cat "$P/power/runtime_status")" == active ]] || fail '电源状态不符合预期。'
PHASE=loaded
printf '%s\n' "$VERSION" > "$STATE/loaded-version"
echo "测试 core：$(cat "$SYS_MODULE/venus_core/version")"
for f in "$VIDEO_CLASS"/video*/name; do
    [[ -f "$f" ]] || continue
    printf '%s: ' "$f"; cat "$f"
done
echo '加载完成；尚未提交视频帧。先执行本包 test-codecs.sh --decode，编码是单独的 --encode 步骤。'
