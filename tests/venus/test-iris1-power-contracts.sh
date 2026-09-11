#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Build only host tests of the real batched IRIS1 PM helpers, never a kernel.
set -Eeuo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$(cd -- "$HERE/../.." && pwd)"
SOURCE="${RAPHAEL_SOURCE_REPO:-$(dirname "$BUILD")/raphael-linux}"
BASE=ab4ce59a1826b18ba200b33f6a32d04d749a7ea5
CC="${HOST_CC:-clang-22}"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/venus-pm-contracts.XXXXXX")"
trap 'rm -rf -- "$TMP"' EXIT
export GIT_INDEX_FILE="$TMP/index"
git -C "$SOURCE" read-tree "$BASE"
cp "$BUILD/patches/series" "$TMP/series"
while IFS= read -r name; do
    [[ -n "$name" && "$name" != \#* ]] || continue
    git -C "$SOURCE" apply --cached --check "$BUILD/patches/$name"
    git -C "$SOURCE" apply --cached "$BUILD/patches/$name"
done < "$TMP/series"
git -C "$SOURCE" show :drivers/media/platform/qcom/venus/pm_helpers.c > "$TMP/pm_helpers.c"
unset GIT_INDEX_FILE
: > "$TMP/iris1-pm-functions.h"
for fn in iris1_reset_bridge core_power_iris1; do
    awk -v fn="$fn" '
        $0 ~ "^static int " fn "\\(" {copy=1; found=1}
        copy {print}
        copy && /^}$/ {done=1; exit}
        END {if (!found || !done) exit 1}
    ' "$TMP/pm_helpers.c" >> "$TMP/iris1-pm-functions.h"
done
"$CC" -std=gnu11 -Wall -Wextra -Werror -O1 -fsanitize=undefined \
    -I "$TMP" "$HERE/iris1-power-contracts.c" -o "$TMP/test"
"$TMP/test"
printf 'source_commit=%s\n' "$BASE"
