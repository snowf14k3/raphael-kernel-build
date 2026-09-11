#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Compile the real pinned venus_boot_core() before and after patch 0005.
# Only MMIO and sleeping/logging are mocked. No hardware is accessed.
set -Eeuo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_REPO="$(cd -- "${HERE}/../.." && pwd)"
SOURCE_REPO="${RAPHAEL_SOURCE_REPO:-$(dirname "${BUILD_REPO}")/raphael-linux}"
BASE=ab4ce59a1826b18ba200b33f6a32d04d749a7ea5
VENUS=drivers/media/platform/qcom/venus
PATCH="${BUILD_REPO}/patches/0005-media-venus-preserve-iris1-interrupt-mask.patch"
CC="${HOST_CC:-clang-22}"
for tool in git patch awk grep mktemp "${CC}"; do
    command -v "${tool}" >/dev/null || { echo "Missing tool: ${tool}" >&2; exit 1; }
done
git -C "${SOURCE_REPO}" cat-file -e "${BASE}^{commit}"
[[ -s "${PATCH}" ]] || { echo "Missing patch: ${PATCH}" >&2; exit 1; }
TMP="$(mktemp -d "${TMPDIR:-/tmp}/venus-irq-test.XXXXXX")"
trap 'rm -rf -- "${TMP}"' EXIT
mkdir -p "${TMP}/patched/${VENUS}"

git -C "${SOURCE_REPO}" show "${BASE}:${VENUS}/hfi_venus.c" > "${TMP}/baseline.c"
git -C "${SOURCE_REPO}" show "${BASE}:${VENUS}/core.h" > "${TMP}/core.h"
git -C "${SOURCE_REPO}" show "${BASE}:${VENUS}/hfi_helper.h" > "${TMP}/hfi_helper.h"
git -C "${SOURCE_REPO}" show "${BASE}:${VENUS}/hfi_venus_io.h" > "${TMP}/hfi_venus_io.h"
cp "${TMP}/baseline.c" "${TMP}/patched/${VENUS}/hfi_venus.c"
patch --batch --fuzz=0 -p1 -d "${TMP}/patched" < "${PATCH}"
{
    awk '/^enum vpu_version \{/{copy=1} copy{print} copy && /^};$/{exit}' "${TMP}/core.h"
    awk '/^enum hfi_version \{/{copy=1} copy{print} copy && /^};$/{exit}' "${TMP}/hfi_helper.h"
    grep -E '^#define IS_(V1|IRIS1|IRIS2|IRIS2_1|AR50_LITE)\(' "${TMP}/core.h"
} > "${TMP}/venus-test-types.h"

build_case() {
    local source="$1" output="$2"
    awk '
        /^static int venus_boot_core\(/{copy=1; found=1}
        copy {print}
        copy && /^}$/ {done=1; exit}
        END {if (!found || !done) exit 1}
    ' "${source}" > "${TMP}/venus-boot-under-test.h"
    "${CC}" -std=gnu11 -Wall -Wextra -Werror -O2 -I "${TMP}" \
        "${HERE}/iris1-irq-mask.c" -o "${output}"
}

build_case "${TMP}/baseline.c" "${TMP}/baseline"
set +e
"${TMP}/baseline" > "${TMP}/baseline.log" 2>&1
rc=$?
set -e
[[ "${rc}" == 1 ]] || { cat "${TMP}/baseline.log"; echo "Baseline did not fail as expected" >&2; exit 1; }
grep -Fx 'FAIL IRIS1 reset mask: got 0x8, expected 0x1e2' "${TMP}/baseline.log"
echo 'PASS: negative control reproduced the pinned baseline mismatch'

build_case "${TMP}/patched/${VENUS}/hfi_venus.c" "${TMP}/patched-test"
"${TMP}/patched-test"
printf 'source_commit=%s\n' "${BASE}"
sha256sum "${PATCH}"
