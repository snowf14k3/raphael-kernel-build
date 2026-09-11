#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Copies use fake proc/sys/dev paths and command stubs. No hardware or modules.
set -Eeuo pipefail
HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TMP=$(mktemp -d /tmp/venus-encode-safety.XXXXXX)
trap 'rm -rf -- "$TMP"' EXIT
ORIGINAL_PATH=$PATH
checks=0
check() { checks=$((checks+1)); "$@" || { echo "FAIL: $*"; exit 1; }; }
fixture() {
    F=$(mktemp -d "$TMP/case.XXXXXX"); export F
    mkdir -p "$F/bin" "$F/run/venus-hot2-testboot" "$F/var/tmp/venus-hot2.test/gfmt-paced.test" \
        "$F/sys/module/venus_core" "$F/proc/sys/kernel/random" "$F/dev" \
        "$F/sys/bus/platform/devices/aa00000.video-codec/power" \
        "$F/sys/class/video4linux/video0" "$F/sys/class/video4linux/video1"
    D="$F/var/tmp/venus-hot2.test"; S="$F/run/venus-hot2-testboot"; P="$D/gfmt-paced.test"
    printf 'testboot\n' > "$F/proc/sys/kernel/random/boot_id"
    printf '4096\n' > "$F/proc/sys/kernel/tainted"
    printf 'testboot\n' > "$D/boot-id"
    printf '%s\n' "$D" > "$S/logdir"
    printf 'iris1-swpc-ofref-hot2\n' | tee "$S/loaded-version" > "$F/sys/module/venus_core/version"
    printf 'on\n' > "$F/sys/bus/platform/devices/aa00000.video-codec/power/control"
    ln -s /nonexistent-fixture-driver "$F/sys/bus/platform/devices/aa00000.video-codec/driver"
    printf 'qcom-venus-encoder\n' > "$F/sys/class/video4linux/video0/name"
    printf 'qcom-venus-decoder\n' > "$F/sys/class/video4linux/video1/name"
    touch "$F/dev/video0" "$F/dev/video1" "$F/dev/kmsg" "$F/proc/interrupts"
    printf 'exit=0\ninput_pacing=-re\n' > "$P/result.txt"
    printf 'VENUS_GFMT_PACED_testboot_123\n' > "$P/kernel.log"
    printf 'Using device %s/dev/video1\n' "$F" > "$P/ffmpeg.log"
    truncate -s 13824000 "$D/reference.nv12" "$P/decoded.nv12"
    : > "$F/actions"
    perl -pe 's{/(var/tmp|sys|proc|run|dev)/}{$ENV{F}/$1/}g; s/EUID -eq 0/EUID -ge 0/; s/-c "\$node"/-f "\$node"/' \
        "$HERE/encode-after-paced.sh" > "$F/test.sh"
    cat > "$F/bin/uname" <<'EOF'
#!/usr/bin/env bash
case "$1" in -r) echo 7.1.0-sm8150-ga0ca2cbb4b3d;; -m) echo aarch64;; esac
EOF
    cat > "$F/bin/fuser" <<'EOF'
#!/usr/bin/env bash
[[ ${SCENARIO:-} == busy ]]
EOF
    cat > "$F/bin/dmesg" <<'EOF'
#!/usr/bin/env bash
cat "$F/dev/kmsg"
EOF
    cat > "$F/bin/timeout" <<'EOF'
#!/usr/bin/env bash
# The real command has a wall-clock guard; fixtures run only instant stubs.
[[ "$1 $2 $3 $4 $5" == '-s INT -k 3s 15s' || "$1 $2 $3 $4 $5" == '-s INT -k 3s 20s' ]] || exit 98
shift 5
exec "$@"
EOF
    cat > "$F/bin/ffmpeg" <<'EOF'
#!/usr/bin/env bash
set -eu
out=${!#}
if [[ " $* " == *' h264_v4l2m2m '* ]]; then
    echo hardware >> "$F/actions"
    [[ " $* " == *' -pixel_format nv12 '* && " $* " == *' -video_size 640x480 '* ]] || exit 98
    [[ " $* " == *' -b:v 1000000 '* && " $* " == *' -bf 0 '* ]] || exit 98
    echo "Using device $F/dev/video0"
    case "${SCENARIO:-}" in
        hw_fail) exit 146;;
        timeout) exit 124;;
        empty) : > "$out"; exit 0;;
        warn) echo 4608 > "$F/proc/sys/kernel/tainted";;
    esac
    printf 'FAKE-H264-for-control-flow-test' > "$out"
else
    echo software >> "$F/actions"
    [[ " $* " == *' -c:v h264 '* ]] || exit 98
    [[ ${SCENARIO:-} != sw_fail ]] || exit 1
    if [[ ${SCENARIO:-} == short ]]; then truncate -s 460800 "$out"; else truncate -s 13824000 "$out"; fi
fi
EOF
    for cmd in modprobe rmmod insmod reboot; do
        printf '#!/usr/bin/env bash\necho FORBIDDEN >> "$F/actions"\nexit 99\n' > "$F/bin/$cmd"
    done
    chmod +x "$F/bin/"*
}
run_test() {
    set +e
    PATH="$F/bin:$ORIGINAL_PATH" SCENARIO="$SCENARIO" bash "$F/test.sh" "$P" > "$F/output.log" 2>&1
    RC=$?
    set -e
}
for SCENARIO in wrong_version dirty stale_boot bad_result wrong_marker wrong_node pixel_diff short_evidence repeated busy; do
    fixture
    case "$SCENARIO" in
        wrong_version) echo other > "$F/sys/module/venus_core/version";;
        dirty) echo 512 > "$F/proc/sys/kernel/tainted";;
        stale_boot) echo oldboot > "$D/boot-id";;
        bad_result) echo exit=146 > "$P/result.txt";;
        wrong_marker) echo oldboot > "$P/kernel.log";;
        wrong_node) echo /dev/video42 > "$P/ffmpeg.log";;
        pixel_diff) printf X | dd of="$P/decoded.nv12" bs=1 count=1 conv=notrunc status=none;;
        short_evidence) truncate -s 1 "$P/decoded.nv12";;
        repeated) mkdir "$S/encode.started";;
    esac
    run_test
    check test "$RC" -ne 0
    check test ! -s "$F/actions"
    check test ! -e "$S/decode.success"
    echo "PASS: $SCENARIO rejected before any hardware attempt"
done
for SCENARIO in good hw_fail timeout empty warn sw_fail short; do
    fixture
    run_test
    if [[ "$SCENARIO" == good ]]; then
        if [[ $RC != 0 ]]; then cat "$F/output.log"; exit 1; fi
        check test -s "$S/encode-after-paced.success"
        check test "$(grep -c '^software$' "$F/actions")" -eq 1
    else
        check test "$RC" -ne 0
        check test ! -e "$S/encode-after-paced.success"
    fi
    check test "$(grep -c '^hardware$' "$F/actions")" -eq 1
    check test -d "$S/encode.started"
    check test ! -e "$S/decode.success"
    check test "$(cat "$F/sys/module/venus_core/version")" = iris1-swpc-ofref-hot2
    check test "$(stat -c %s "$D/reference.nv12")" = 13824000
    check cmp -s "$D/reference.nv12" "$P/decoded.nv12"
    if grep -q FORBIDDEN "$F/actions"; then exit 1; fi
    if [[ "$SCENARIO" =~ ^(hw_fail|timeout|empty|warn)$ ]]; then
        check test "$(wc -l < "$F/actions")" -eq 1
    fi
    result=("$D"/encode-after-paced.*/result.txt)
    check test -s "${result[0]}"
    check grep -Fxq unpaced_decoder=UNRESOLVED "${result[0]}"
    echo "PASS: $SCENARIO preserves module/evidence and independent decoder-failure status"
done
printf 'PASS: %s host safety assertions; fake files and command stubs only, no hardware used\n' "$checks"
