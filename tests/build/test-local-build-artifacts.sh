#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Exercise the real collection/cleanup code with tiny Debian package fixtures.
# No kernel compilation, installation, GitHub access or source worktree needed.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$(cd -- "$HERE/../.." && pwd)"
SCRIPT="$BUILD/scripts/local-build.sh"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/raphael-artifact-test.XXXXXX")"
trap 'rm -rf -- "$TMP"' EXIT
export RUN_DIR="$TMP/run" SOURCE_DIR="$TMP/run/linux-src" OUT_ROOT="$TMP/out"
export BUILD_COMMIT=test EXPECTED_SOURCE_COMMIT=ab4ce59a1826b18ba200b33f6a32d04d749a7ea5
export BUILD_STAGE=collect
REAL_RELEASE=7.1.0-sm8150-g30680a89d863
OLD_RELEASE=7.1.0-g30680a89d863
export REAL_RELEASE
mkdir -p "$SOURCE_DIR/include/config" "$SOURCE_DIR/arch/arm64/boot/dts/qcom" "$OUT_ROOT" "$TMP/good"
printf '%s\n' "$REAL_RELEASE" > "$SOURCE_DIR/include/config/kernel.release"
printf 'CONFIG_LOCALVERSION="-sm8150"\n' > "$SOURCE_DIR/.config"
printf 'DTB fixture, not bootable\n' > "$SOURCE_DIR/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb"
printf 'test manifest\n' > "$RUN_DIR/patches.sha256"

# Extract the actual code; a copied reimplementation would miss regressions.
awk '/^BUILD_STAGE=collect$/{p=1} /^BUNDLE_NAME=/{p=0} p' "$SCRIPT" > "$TMP/collect.sh"
for function in preserve_completed_packages cleanup; do
    awk -v fn="$function" '$0 == fn "() {" {p=1;found=1} p{print} p && /^}$/ {done=1;exit} END{if(!found||!done)exit 1}' \
        "$SCRIPT" >> "$TMP/functions.sh"
done
test -s "$TMP/collect.sh"

make_package() {
    local name=$1 architecture=$2 destination=$3 root="$TMP/package"
    rm -rf -- "$root"
    mkdir -p "$root/DEBIAN"
    cat > "$root/DEBIAN/control" <<EOF
Package: $name
Version: 1
Architecture: $architecture
Maintainer: Test <test@example.invalid>
Description: Local artifact collector test fixture, not an installable kernel
EOF
    if [[ "$name" == linux-image-* ]]; then
        mkdir -p "$root/boot/dtbs/qcom"
        printf 'image fixture\n' > "$root/boot/vmlinuz-$REAL_RELEASE"
        cp "$SOURCE_DIR/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb" "$root/boot/dtbs/qcom/"
    fi
    dpkg-deb --build --root-owner-group "$root" "$destination" >/dev/null
}
IMAGE="$RUN_DIR/linux-image-fixture_1_arm64.deb"
HEADERS="$RUN_DIR/linux-headers-fixture_1_arm64.deb"
make_package "linux-image-$REAL_RELEASE" arm64 "$IMAGE"
make_package "linux-headers-$REAL_RELEASE" arm64 "$HEADERS"
cp "$IMAGE" "$TMP/good/image.deb"
cp "$HEADERS" "$TMP/good/headers.deb"

collect() {
    KERNEL_RELEASE="$OLD_RELEASE" bash -c '
        set -Eeuo pipefail
        cd "$SOURCE_DIR"
        source "$1"
        [[ "$KERNEL_RELEASE" == "$REAL_RELEASE" ]]
    ' bash "$TMP/collect.sh" > "$TMP/result.log" 2>&1
}
expect_failure() {
    local text=$1
    if collect; then echo 'FAIL: expected collection failure' >&2; exit 1; fi
    grep -Fq -- "$text" "$TMP/result.log"
}

# Reproduce the old post-build check against the wrong kernel release.
dpkg-deb -c "$IMAGE" > "$TMP/old-contents.txt"
if grep -q "/boot/vmlinuz-${OLD_RELEASE}$" "$TMP/old-contents.txt"; then
    echo 'FAIL: negative control did not reproduce stale-release mismatch' >&2; exit 1
fi
echo 'PASS: negative control reproduces missing -sm8150 release mismatch'
collect
echo 'PASS: collector reads completed kernel.release and accepts matching packages'
make_package "linux-image-$REAL_RELEASE" amd64 "$IMAGE"
expect_failure 'Debian 包不是 arm64'
cp "$TMP/good/image.deb" "$IMAGE"
echo 'PASS: collector rejects wrong package architecture'
make_package "linux-headers-$OLD_RELEASE" arm64 "$HEADERS"
expect_failure 'image/headers 包名与实际内核版本'
cp "$TMP/good/headers.deb" "$HEADERS"
echo 'PASS: collector rejects a mismatched headers release'
mv "$SOURCE_DIR/include/config/kernel.release" "$TMP/kernel.release"
expect_failure '构建没有生成 include/config/kernel.release'
mv "$TMP/kernel.release" "$SOURCE_DIR/include/config/kernel.release"
echo 'PASS: collector refuses missing final build identity'

# The cleanup must preserve only the small useful artifacts, not a debug .deb.
cp "$IMAGE" "$RUN_DIR/linux-image-${REAL_RELEASE}-dbg_1_arm64.deb"
printf 'large disposable source output fixture\n' > "$SOURCE_DIR/vmlinux"
collect
export LOG_FILE="$OUT_ROOT/test.log" KEEP_WORKTREE=0 WORKTREE_ADDED=0
set +e
bash -c 'source "$1"; trap cleanup EXIT; exit 1' bash "$TMP/functions.sh" > "$TMP/cleanup.log" 2>&1
rc=$?
set -e
[[ "$rc" == 1 && ! -e "$RUN_DIR" ]]
[[ -s "$OUT_ROOT/failed-packaging/${IMAGE##*/}" && -s "$OUT_ROOT/failed-packaging/${HEADERS##*/}" ]]
[[ -s "$OUT_ROOT/failed-packaging/.config" && -s "$OUT_ROOT/failed-packaging/kernel.release" ]]
[[ -s "$OUT_ROOT/failed-packaging/sm8150-xiaomi-raphael.dtb" && -s "$OUT_ROOT/failed-packaging/patches.sha256" ]]
[[ ! -e "$OUT_ROOT/failed-packaging/linux-image-${REAL_RELEASE}-dbg_1_arm64.deb" && ! -e "$OUT_ROOT/failed-packaging/vmlinux" ]]
grep -Fxq 'status=UNVERIFIED_NOT_FOR_RELEASE' "$OUT_ROOT/failed-packaging/recovery-info.txt"
echo 'PASS: collection failure retains non-debug packages and inputs, removes temporary sources'

mkdir -p "$RUN_DIR"
set +e
bash -c 'source "$1"; preserve_completed_packages() { return 1; }; trap cleanup EXIT; exit 2' \
    bash "$TMP/functions.sh" > "$TMP/copy-failure.log" 2>&1
rc=$?
set -e
[[ "$rc" == 2 && -d "$RUN_DIR" ]]
grep -Fq '保存恢复包失败' "$TMP/copy-failure.log"
echo 'PASS: a failed recovery copy does not discard the only artifacts'
echo 'PASS: 7 artifact-collection regression cases; no kernel built or installed'
