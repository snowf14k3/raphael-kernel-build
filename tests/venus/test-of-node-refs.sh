#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Compile actual fixed-baseline OF lookups and Venus helper with host stubs.
# Never loads/unloads a kernel module or creates a full kernel source tree.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$(cd -- "$HERE/../.." && pwd)"
SOURCE="${RAPHAEL_SOURCE_REPO:-$(dirname "$BUILD")/raphael-linux}"
BASE=ab4ce59a1826b18ba200b33f6a32d04d749a7ea5
CC="${HOST_CC:-clang-22}"
for t in git awk grep mktemp "$CC"; do command -v "$t" >/dev/null; done
T="$(mktemp -d "${TMPDIR:-/tmp}/venus-of-refs.XXXXXX")"
trap 'rm -rf -- "$T"' EXIT
git -C "$SOURCE" show "$BASE:drivers/of/base.c" > "$T/of-base.c"
git -C "$SOURCE" show "$BASE:include/linux/of.h" > "$T/of.h"
git -C "$SOURCE" show "$BASE:drivers/media/platform/qcom/venus/core.c" > "$T/old-core.c"
export GIT_INDEX_FILE="$T/index"
git -C "$SOURCE" read-tree "$BASE"
cp "$BUILD/patches/series" "$T/series"
while IFS= read -r p; do
    [[ -n "$p" && "$p" != \#* ]] || continue
    git -C "$SOURCE" apply --cached --check "$BUILD/patches/$p"
    git -C "$SOURCE" apply --cached "$BUILD/patches/$p"
done < "$T/series"
git -C "$SOURCE" diff --cached --check
git -C "$SOURCE" show :drivers/media/platform/qcom/venus/core.c > "$T/new-core.c"
unset GIT_INDEX_FILE
extract() {
    awk -v fn="$2" '
        $0 !~ /^[[:space:]]/ && $0 ~ ("(^|[^[:alnum:]_])" fn "\\(") {copy=1; found=1}
        copy {print}
        copy && /^}$/ {done=1; exit}
        END {if (!found || !done) exit 1}
    ' "$1"
}
: > "$T/of-lookup-functions.h"
for macro in for_each_of_allnodes_from for_each_child_of_node; do
    awk -v n="$macro" '
        $0 ~ ("^#define " n "\\(") {copy=1; found=1}
        copy {print}
        copy && !/\\$/ {done=1; exit}
        END {if (!found || !done) exit 1}
    ' "$T/of.h" >> "$T/of-lookup-functions.h"
done
for fn in of_node_name_eq __of_find_all_nodes __of_get_next_child of_get_next_child of_get_child_by_name of_find_node_by_name; do
    extract "$T/of-base.c" "$fn" >> "$T/of-lookup-functions.h"
done
compile() {
    extract "$1" venus_add_video_core > "$T/venus-node-function.h"
    "$CC" -std=gnu11 -Wall -Wextra -Werror -O1 -fsanitize=undefined \
        -I "$T" "$HERE/of-node-refs.c" -o "$2"
}
compile "$T/old-core.c" "$T/old"
for mode in parent foreign; do
    set +e
    "$T/old" "$mode" > "$T/negative-$mode.log" 2>&1
    rc=$?
    set -e
    [[ "$rc" == 1 ]] || { cat "$T/negative-$mode.log"; echo "Bad negative control: $mode" >&2; exit 1; }
done
grep -Fx 'FAIL borrowed parent refcount: got 7 expected 8' "$T/negative-parent.log"
grep -Fx 'FAIL unrelated device child incorrectly suppresses Venus child creation' "$T/negative-foreign.log"
echo 'PASS: both fixed-baseline negative controls fail for the expected reason'
compile "$T/new-core.c" "$T/new"
"$T/new" parent
"$T/new" foreign
"$T/new" all
printf 'source_commit=%s\n' "$BASE"
sha256sum "$BUILD/patches/0023-media-venus-preserve-parent-node-reference.patch"
