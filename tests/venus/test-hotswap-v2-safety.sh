#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Sandbox fixtures replace paths/root check in COPIES only. Every module command
# and ffmpeg is a stub. No real hardware, driver or root filesystem is touched.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TMP=$(mktemp -d /tmp/venus-hot2-safety.XXXXXX)
trap 'rm -rf -- "$TMP"' EXIT
ORIGINAL_PATH=$PATH
ASSERTIONS=0
check() { ASSERTIONS=$((ASSERTIONS+1)); "$@" || { echo "FAIL: $*" >&2; exit 1; }; }
new_fixture() {
    F=$(mktemp -d "$TMP/case.XXXXXX")
    export F
    mkdir -p "$F/bin" "$F/pkg" "$F/run" "$F/var/tmp" "$F/dev" \
        "$F/sys/platform/power" "$F/sys/device-tree" "$F/sys/video4linux" \
        "$F/proc/sys/kernel/random" "$F/sys/driver"
    ln -s "$F/sys/device-tree" "$F/sys/platform/of_node"
    printf 'qcom,sm8150-venus\0' > "$F/sys/device-tree/compatible"
    echo auto > "$F/sys/platform/power/control"
    echo suspended > "$F/sys/platform/power/runtime_status"
    echo 00000000-1111-2222-3333-444444444444 > "$F/proc/sys/kernel/random/boot_id"
    echo 0 > "$F/proc/sys/kernel/tainted"
    echo '209: 5 0 0 venus' > "$F/proc/interrupts"
    mkdir -p "$F/sys/driver/qcom-venus"
    : > "$F/calls"
    : > "$F/kmsg"
    cat > "$F/kernel.log" <<'EOF'
[4.240560] qcom-venus aa00000.video-codec: non legacy binding
[4.462446] qcom-venus aa00000.video-codec: probe with driver qcom-venus failed with error -110
EOF
    : > "$F/pkg/original-modules.sha256"
    for m in venus_core venus_dec venus_enc; do
        mkdir -p "$F/sys/module/$m"
        : > "$F/sys/module/$m/taint"
        echo "original-$m" > "$F/$m.ko"
        printf '%s %s\n' "$(sha256sum "$F/$m.ko" | cut -d' ' -f1)" "$m" >> "$F/pkg/original-modules.sha256"
    done
    echo candidate > "$F/pkg/venus-core.ko"
    cp "$HERE/hotswap-v2-load.sh" "$F/pkg/load.sh"
    cp "$HERE/hotswap-v2-codecs.sh" "$F/pkg/test-codecs.sh"
    # Only these test copies accept the mock root and regular video-node files.
    perl -0pi -e '
      my $f=$ENV{F};
      s/\[\[ \$EUID -eq 0 \]\]/[[ 0 -eq 0 ]]/g;
      s|/sys/bus/platform/devices/aa00000.video-codec|$f/sys/platform|g;
      s|/sys/class/video4linux|$f/sys/video4linux|g;
      s|/sys/module|$f/sys/module|g;
      s|/proc/sys/kernel|$f/proc/sys/kernel|g;
      s|/proc/interrupts|$f/proc/interrupts|g;
      s|/var/tmp|$f/var/tmp|g;
      s|(?<!=)/run/|$f/run/|g;
      s|^RUN_ROOT=/run$|RUN_ROOT=$f/run|m;
      s|/dev/kmsg|$f/kmsg|g;
      s|node="/dev/|node="$f/dev/|g;
      s|-c "\$node"|-e "\$node"|g;
    ' "$F/pkg/load.sh" "$F/pkg/test-codecs.sh"
    cat > "$F/bin/stub" <<'STUB'
#!/usr/bin/env bash
set -eu
name=${0##*/}
case "$name" in
 uname)
   if [[ "$1" == -r ]]; then
     [[ "${CASE:-}" == wrong_kernel ]] && echo wrong || echo 7.1.0-sm8150-ga0ca2cbb4b3d
   else echo aarch64; fi;;
 dmesg) cat "$F/kernel.log"; cat "$F/kmsg";;
 modinfo)
   if [[ "$1" == -n ]]; then echo "$F/$2.ko";
   elif [[ "$2" == version ]]; then echo iris1-swpc-ofref-hot2;
   elif [[ "$2" == vermagic ]]; then echo '7.1.0-sm8150-ga0ca2cbb4b3d SMP preempt mod_unload aarch64';
   else exit 90; fi;;
 rmmod)
   echo "rmmod $*" >> "$F/calls"
   if [[ "${CASE:-}" == remove_fail && "$1" == venus_enc ]]; then exit 1; fi
   rm -rf -- "$F/sys/module/$1";;
 insmod)
   echo 'insmod candidate' >> "$F/calls"
   [[ "${CASE:-}" != insert_fail ]] || exit 1
   mkdir -p "$F/sys/module/venus_core"
   echo iris1-swpc-ofref-hot2 > "$F/sys/module/venus_core/version"
   echo O > "$F/sys/module/venus_core/taint"
   [[ "${CASE:-}" != unbound_new ]] || exit 0
   ln -s "$F/sys/driver/qcom-venus" "$F/sys/platform/driver"
   echo active > "$F/sys/platform/power/runtime_status"
   [[ "${CASE:-}" != warning_new ]] || echo 512 > "$F/proc/sys/kernel/tainted";;
 modprobe)
   echo "modprobe $*" >> "$F/calls"
   [[ "$*" == '-a venus_dec venus_enc' ]] || exit 91
   [[ "${CASE:-}" != codec_load_fail ]] || exit 1
   mkdir -p "$F/sys/module/venus_dec" "$F/sys/module/venus_enc" \
       "$F/sys/video4linux/video0" "$F/sys/video4linux/video1"
   echo qcom-venus-encoder > "$F/sys/video4linux/video0/name"
   echo qcom-venus-decoder > "$F/sys/video4linux/video1/name"
   touch "$F/dev/video0" "$F/dev/video1";;
 ffmpeg)
   output=${!#}
   if [[ " $* " == *' h264_v4l2m2m '* ]]; then
     if [[ "$output" == */encoded.h264 ]]; then
       echo 'ffmpeg hardware encode' >> "$F/calls"
       [[ "${CASE:-}" != encode_fail ]] || exit 9
       printf 'Using device %s/dev/video0\n' "$F"
       echo stub-stream > "$output"
     else
       echo 'ffmpeg hardware decode' >> "$F/calls"
       [[ "${CASE:-}" != decode_fail ]] || exit 9
       printf 'Using device %s/dev/video1\n' "$F"
       truncate -s 13824000 "$output"
       [[ "${CASE:-}" != short_frame ]] || truncate -s 460800 "$output"
       [[ "${CASE:-}" != pixel_diff ]] || printf X | dd of="$output" conv=notrunc status=none
     fi
   elif [[ "$output" == *.nv12 ]]; then
     truncate -s 13824000 "$output"
   else echo stub-input > "$output"; fi;;
 *) exit 92;;
esac
STUB
    chmod +x "$F/bin/stub"
    for c in uname dmesg modinfo rmmod insmod modprobe ffmpeg; do ln -s stub "$F/bin/$c"; done
    (cd "$F/pkg"; sha256sum load.sh test-codecs.sh original-modules.sha256 venus-core.ko > SHA256SUMS)
    export PATH="$F/bin:$ORIGINAL_PATH"
    CASE=''; export CASE
}
run_load() { set +e; bash "$F/pkg/load.sh" "$1" > "$F/load-output" 2>&1; RC=$?; set -e; }
run_codec() { set +e; bash "$F/pkg/test-codecs.sh" "$1" > "$F/test-output" 2>&1; RC=$?; set -e; }
STATE_SUFFIX=venus-hot2-00000000-1111-2222-3333-444444444444
new_fixture
run_load --check
check test "$RC" -eq 0; check test ! -s "$F/calls"
for scenario in wrong_kernel dirty_oops dirty_warn bound duplicate_probe missing_parent wrong_hash; do
    new_fixture; CASE=$scenario
    case "$scenario" in
      dirty_oops) echo 128 > "$F/proc/sys/kernel/tainted";;
      dirty_warn) echo 'refcount_t: underflow; use-after-free.' >> "$F/kernel.log";;
      bound) ln -s "$F/sys/driver/qcom-venus" "$F/sys/platform/driver";;
      duplicate_probe) echo 'qcom-venus aa00000.video-codec: non legacy binding' >> "$F/kernel.log";;
      missing_parent) rm "$F/sys/platform/of_node";;
      wrong_hash) echo changed >> "$F/venus_core.ko";;
    esac
    run_load --load
    check test "$RC" -ne 0; check test ! -s "$F/calls"
    echo "PASS: $scenario stops before all module actions"
done
for scenario in remove_fail insert_fail unbound_new codec_load_fail warning_new; do
    new_fixture; CASE=$scenario
    run_load --load
    check test "$RC" -ne 0
    check test -d "$F/run/$STATE_SUFFIX"
    check test "$(grep -c '^rmmod venus_core' "$F/calls" || true)" -le 1
    check test "$(grep -c '^insmod' "$F/calls" || true)" -le 1
    check bash -c '! grep -Eq "^modprobe .*venus_core|rmmod.*-f|insmod.*-f" "$1"' _ "$F/calls"
    [[ "$scenario" != remove_fail ]] || check bash -c '! grep -q "^insmod" "$1"' _ "$F/calls"
    cp "$F/calls" "$F/calls-before-second"
    run_load --load
    check test "$RC" -ne 0; check cmp -s "$F/calls" "$F/calls-before-second"
    echo "PASS: $scenario never restores the original core or retries"
done
new_fixture
run_load --load
check test "$RC" -eq 0
check test -s "$F/run/$STATE_SUFFIX/loaded-version"
check test "$(cat "$F/sys/module/venus_core/version")" = iris1-swpc-ofref-hot2
check test "$(grep -c '^rmmod' "$F/calls")" -eq 3
check test "$(grep -c '^insmod' "$F/calls")" -eq 1
cp "$F/calls" "$F/load-calls"
run_codec --encode
check test "$RC" -ne 0; check cmp -s "$F/calls" "$F/load-calls"
run_codec --decode
check test "$RC" -eq 0
check test -s "$F/run/$STATE_SUFFIX/decode.success"
run_codec --encode
check test "$RC" -eq 0
check test -s "$F/run/$STATE_SUFFIX/encode.success"
check test "$(grep -c '^rmmod' "$F/calls")" -eq 3
check test "$(grep -c '^insmod' "$F/calls")" -eq 1
cp "$F/calls" "$F/after-tests"
run_codec --decode
check test "$RC" -ne 0; check cmp -s "$F/calls" "$F/after-tests"
echo 'PASS: ordered separate decode/encode tests leave fixed core loaded; no automatic extra attempts'
for scenario in decode_fail short_frame pixel_diff encode_fail; do
    new_fixture
    run_load --load; check test "$RC" -eq 0
    CASE=$scenario
    if [[ "$scenario" == encode_fail ]]; then
        run_codec --decode; check test "$RC" -eq 0
        run_codec --encode
    else run_codec --decode; fi
    check test "$RC" -ne 0
    check test "$(cat "$F/sys/module/venus_core/version")" = iris1-swpc-ofref-hot2
    check test "$(grep -c '^rmmod' "$F/calls")" -eq 3
    check test ! -s "$F/run/$STATE_SUFFIX/encode.success"
    echo "PASS: $scenario records failure without unloading or restoring modules"
done
printf 'PASS: %s host safety assertions; mock paths/module commands/FFmpeg only, no hardware testing\n' "$ASSERTIONS"
