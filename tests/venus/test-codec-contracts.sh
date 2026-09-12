#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Snapshot the actual series in a temporary index, then test its real packetizer
# and selected codec functions with host-only PM/VB2 mocks. Never touches a VPU.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$(cd -- "$HERE/../.." && pwd)"
SOURCE="${RAPHAEL_SOURCE_REPO:-$(dirname "$BUILD")/raphael-linux}"
BASE="${VENUS_TEST_REF:-ab4ce59a1826b18ba200b33f6a32d04d749a7ea5}"
V=drivers/media/platform/qcom/venus
CC="${HOST_CC:-clang-22}"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/venus-codec-contracts.XXXXXX")"
trap 'rm -rf -- "$TMP"' EXIT
mkdir -p "$TMP/linux" "$TMP/src"
export GIT_INDEX_FILE="$TMP/index"
git -C "$SOURCE" read-tree "$BASE"
cp "$BUILD/patches/series" "$TMP/series"
if [[ -n "${VENUS_TEST_REF:-}" ]]; then : > "$TMP/series"; fi
while IFS= read -r name; do
    [[ -n "$name" && "$name" != \#* ]] || continue
    git -C "$SOURCE" apply --cached --check "$BUILD/patches/$name"
    git -C "$SOURCE" apply --cached "$BUILD/patches/$name"
done < "$TMP/series"
git -C "$SOURCE" diff --cached --check
for f in hfi_venus.c hfi_cmds.c hfi_cmds.h hfi_helper.h hfi.h core.h helpers.c vdec.c venc.c venc_ctrls.c; do
    git -C "$SOURCE" show ":$V/$f" > "$TMP/src/$f"
done
unset GIT_INDEX_FILE
cat > "$TMP/host.h" <<'EOF'
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>
typedef uint32_t u32;
typedef uint64_t u64;
typedef uint8_t u8;
typedef int32_t s32;
#define __counted_by(member)
#define __packed __attribute__((packed))
#define upper_32_bits(n) ((u32)(((u64)(n)) >> 32))
#define lower_32_bits(n) ((u32)(n))
#define BIT(n) (1U << (n))
#ifndef ENOTSUPP
#define ENOTSUPP 524
#endif
#define struct_size(p,m,n) (sizeof(*(p)) + sizeof((p)->m[0]) * (n))
#define struct_size_t(t,m,n) (sizeof(t) + sizeof(((t *)0)->m[0]) * (n))
EOF
printf '#include <asm-generic/errno.h>\n' > "$TMP/linux/errno.h"
printf 'typedef int irqreturn_t;\n' > "$TMP/linux/interrupt.h"
printf '#include "host.h"\n' > "$TMP/linux/overflow.h"
printf 'static inline u32 hash32_ptr(const void *p) { return (u32)(uintptr_t)p; }\n' > "$TMP/linux/hash.h"
# Guards prevent repeated typedef/macro definitions through packetizer includes.
sed -i '1i#ifndef VENUS_TEST_HOST_H\n#define VENUS_TEST_HOST_H' "$TMP/host.h"
printf '\n#endif\n' >> "$TMP/host.h"
awk '/^enum vpu_version \{/{p=1} p{print} p && /^};$/{exit}' "$TMP/src/core.h" > "$TMP/vpu-types.h"
awk '/^enum venus_enc_state \{/{p=1} p{print} p && /^};$/{exit}' "$TMP/src/core.h" >> "$TMP/vpu-types.h"
grep -E '^#define IS_(V1|IRIS1|IRIS2|IRIS2_1)\(' "$TMP/src/core.h" >> "$TMP/vpu-types.h"
extract() {
    awk -v fn="$2" '
        $0 ~ "^static int " fn "\\(" {p=1; found=1}
        p {print}
        p && /^}$/ {done=1; exit}
        END {if (!found || !done) exit 1}
    ' "$TMP/src/$1" > "$TMP/$2.h"
}
extract hfi_venus.c venus_sys_set_default_properties
extract vdec.c vdec_set_work_route
extract venc.c venc_set_work_route
extract venc.c venc_queue_setup_iris1
extract venc.c venc_set_queue_count_iris1
extract venc.c venc_set_properties_if_needed
awk '
    /^void venc_mark_config_dirty\(/ {p=1; found=1}
    p {print}
    p && /^}$/ {done=1; exit}
    END {if (!found || !done) exit 1}
' "$TMP/src/venc.c" > "$TMP/venc_mark_config_dirty.h"
extract helpers.c intbuf_secure_assign
extract helpers.c intbuf_secure_unassign
extract helpers.c intbuf_alloc_secure_persist
extract helpers.c intbuf_free_memory
extract helpers.c intbufs_validate_queue
extract helpers.c intbufs_validate_snapshot
extract helpers.c intbufs_alloc_iris1_encoder
awk '
    /^intbufs_find_req\(/ {print prev; p=1; found=1}
    p {print}
    p && /^}$/ {done=1; exit}
    {prev=$0}
    END {if (!found || !done) exit 1}
' "$TMP/src/helpers.c" > "$TMP/intbufs_find_req.h"
extract venc.c venc_g_fmt
python3 - "$TMP/src/venc.c" <<'PY'
import sys

source = open(sys.argv[1], encoding="utf-8").read()

def function_body(name):
    pos = source.index(name + "(")
    start = source.index("{", pos)
    depth = 0
    for end in range(start, len(source)):
        if source[end] == "{":
            depth += 1
        elif source[end] == "}":
            depth -= 1
            if depth == 0:
                return source[start:end + 1]
    raise AssertionError(f"unterminated function: {name}")

for name in ("venc_s_fmt", "venc_s_selection", "venc_s_parm", "venc_op_s_ctrl"):
    target = source if name != "venc_op_s_ctrl" else open(
        sys.argv[1].replace("venc.c", "venc_ctrls.c"), encoding="utf-8").read()
    old_source = source
    source = target
    assert "venc_mark_config_dirty(inst);" in function_body(name), name
    source = old_source

assert function_body("venc_init_session").count(
    "venc_set_properties_if_needed(inst)") == 1
assert function_body("venc_start_streaming").count(
    "venc_set_properties_if_needed(inst)") == 1
assert "if (!IS_IRIS1(inst->core)) {\n\t\t\tptype = " \
       "HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO;" in function_body(
           "venc_set_properties")
print("PASS: replay, VUI, and secure-persist policy are wired into the staged source")
PY
"$CC" -std=gnu11 -Wall -Wextra -Werror -Wno-unused-parameter -O1 \
    -fsanitize=undefined -I "$TMP" -I "$TMP/src" -include "$TMP/host.h" \
    "$TMP/src/hfi_cmds.c" "$HERE/codec-contracts.c" -o "$TMP/test"
"$TMP/test"
printf 'source_commit=%s\nseries_sha256=' "$BASE"
sha256sum "$TMP/series" | cut -d' ' -f1
