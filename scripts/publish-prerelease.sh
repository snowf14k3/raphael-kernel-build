#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_REPO="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
REPOSITORY="${RAPHAEL_GITHUB_REPO:-snowf14k3/raphael-kernel-build}"
REPLACE=0
CUSTOM_TAG=""
CUSTOM_TITLE=""
ARCHIVE_ARG=""

usage() {
    cat <<USAGE
用法: $0 [选项] [archive.tar.gz]

默认读取当前分支最近一次 scripts/local-build.sh 的构建结果并发布 GitHub Pre-release。

选项:
  --tag TAG        自定义 Release tag
  --title TITLE    自定义 Release 标题
  --replace        如果同名 tag/release 已存在则删除后重建
  --repo OWNER/REPO
                   GitHub 仓库，默认 ${REPOSITORY}
  -h, --help       显示帮助
USAGE
}

while (($#)); do
    case "$1" in
        --tag)
            CUSTOM_TAG="${2:?缺少 --tag 参数}"
            shift 2
            ;;
        --title)
            CUSTOM_TITLE="${2:?缺少 --title 参数}"
            shift 2
            ;;
        --replace)
            REPLACE=1
            shift
            ;;
        --repo)
            REPOSITORY="${2:?缺少 --repo 参数}"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -* )
            echo "未知参数: $1" >&2
            exit 2
            ;;
        *)
            if [[ -n "${ARCHIVE_ARG}" ]]; then
                echo "只能指定一个 tar.gz" >&2
                exit 2
            fi
            ARCHIVE_ARG="$1"
            shift
            ;;
    esac
done

for cmd in git gh sha256sum mktemp awk sed; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "缺少命令: $cmd" >&2
        exit 1
    }
done

gh auth status >/dev/null 2>&1 || {
    echo "gh 尚未登录 GitHub，请先执行 gh auth login" >&2
    exit 1
}

BUILD_BRANCH="$(git -C "${BUILD_REPO}" branch --show-current)"
if [[ -z "${BUILD_BRANCH}" ]]; then
    BUILD_BRANCH="detached-$(git -C "${BUILD_REPO}" rev-parse --short=12 HEAD)"
fi
BUILD_BRANCH_SAFE="$(printf '%s' "${BUILD_BRANCH}" | sed 's/[^A-Za-z0-9._-]/-/g')"
OUT_ROOT="${BUILD_REPO}/out/${BUILD_BRANCH_SAFE}"
LAST_BUILD_FILE="${OUT_ROOT}/last-build.env"

[[ -s "${LAST_BUILD_FILE}" ]] || {
    echo "没有找到当前分支的本地构建信息: ${LAST_BUILD_FILE}" >&2
    echo "请先执行 ./scripts/local-build.sh" >&2
    exit 1
}
# shellcheck disable=SC1090
source "${LAST_BUILD_FILE}"

if [[ -n "${ARCHIVE_ARG}" ]]; then
    ARCHIVE="$(readlink -f "${ARCHIVE_ARG}")"
    ARCHIVE_SHA256="${ARCHIVE}.sha256"
fi

: "${ARCHIVE:?缺少 ARCHIVE}"
: "${ARCHIVE_SHA256:=${ARCHIVE}.sha256}"
: "${KERNEL_RELEASE:?缺少 KERNEL_RELEASE，请先使用 local-build.sh 构建}"
: "${BUILD_COMMIT:?缺少 BUILD_COMMIT，请先使用 local-build.sh 构建}"
: "${SOURCE_COMMIT:=ab4ce59a1826b18ba200b33f6a32d04d749a7ea5}"

[[ -s "${ARCHIVE}" ]] || {
    echo "压缩包不存在: ${ARCHIVE}" >&2
    exit 1
}
[[ -s "${ARCHIVE_SHA256}" ]] || {
    echo "压缩包校验文件不存在: ${ARCHIVE_SHA256}" >&2
    exit 1
}

(
    cd "$(dirname "${ARCHIVE}")"
    sha256sum -c "$(basename "${ARCHIVE_SHA256}")"
)

CURRENT_HEAD="$(git -C "${BUILD_REPO}" rev-parse HEAD)"
if [[ "${CURRENT_HEAD}" != "${BUILD_COMMIT}" ]]; then
    echo "当前分支 HEAD (${CURRENT_HEAD}) 与构建时提交 (${BUILD_COMMIT}) 不一致。" >&2
    echo "为避免发布错版本，请重新构建后再发布。" >&2
    exit 1
fi

git -C "${BUILD_REPO}" fetch origin --prune >/dev/null 2>&1 || true
REMOTE_HEAD="$(git -C "${BUILD_REPO}" rev-parse --verify "origin/${BUILD_BRANCH}" 2>/dev/null || true)"
if [[ "${REMOTE_HEAD}" != "${BUILD_COMMIT}" ]]; then
    echo "远端 origin/${BUILD_BRANCH} 尚未指向构建提交 ${BUILD_COMMIT}" >&2
    echo "请先 push 当前分支，再发布 Pre-release。" >&2
    exit 1
fi

DEFAULT_TAG="test-${BUILD_BRANCH_SAFE}-${KERNEL_RELEASE}"
TAG="${CUSTOM_TAG:-${DEFAULT_TAG}}"
TITLE="${CUSTOM_TITLE:-Raphael ${BUILD_BRANCH} 测试内核 (${KERNEL_RELEASE})}"

if gh release view "${TAG}" -R "${REPOSITORY}" >/dev/null 2>&1 || \
   git -C "${BUILD_REPO}" ls-remote --exit-code --tags origin "refs/tags/${TAG}" >/dev/null 2>&1; then
    if (( REPLACE == 0 )); then
        echo "Release/tag 已存在: ${TAG}" >&2
        echo "如确认需要覆盖，请添加 --replace" >&2
        exit 1
    fi
    echo "删除旧 Release/tag: ${TAG}"
    gh release delete "${TAG}" -R "${REPOSITORY}" --cleanup-tag -y >/dev/null 2>&1 || true
fi

NOTES_FILE="$(mktemp)"
VERIFY_DIR="$(mktemp -d)"
cleanup() {
    rm -f "${NOTES_FILE}"
    rm -rf "${VERIFY_DIR}"
}
trap cleanup EXIT

PATCH_LIST="$(grep -Ev '^[[:space:]]*(#|$)' "${BUILD_REPO}/patches/series" || true)"
ARCHIVE_HASH="$(awk 'NR==1 {print $1}' "${ARCHIVE_SHA256}")"

{
    printf '这是 `%s` 分支的本地测试构建，发布为 Pre-release 供 Raphael 实机验证。\n\n' "${BUILD_BRANCH}"
    printf -- '- 内核版本：`%s`\n' "${KERNEL_RELEASE}"
    printf -- '- 构建分支：`%s`\n' "${BUILD_BRANCH}"
    printf -- '- 构建仓库提交：`%s`\n' "${BUILD_COMMIT}"
    printf -- '- 上游基线：`GengWei1997/linux:raphael-7.1`\n'
    printf -- '- 固定源码提交：`%s`\n' "${SOURCE_COMMIT}"
    printf -- '- 编译方式：AMD64 本地构建 ARM64，LLVM/Clang 22，`bindeb-pkg DPKG_FLAGS=-d`\n'
    printf -- '- 压缩包 SHA256：`%s`\n\n' "${ARCHIVE_HASH}"
    printf '当前 patch 顺序：\n\n```text\n%s\n```\n\n' "${PATCH_LIST}"
    printf '目标机可以通过仓库 `main` 分支的 `scripts/update-kernel.sh` 动态选择该 Pre-release 进行升级。\n'
} > "${NOTES_FILE}"

echo "=== 发布 GitHub Pre-release ==="
echo "repo=${REPOSITORY}"
echo "tag=${TAG}"
echo "target=${BUILD_COMMIT}"
echo "archive=$(basename "${ARCHIVE}")"

gh release create "${TAG}" \
    -R "${REPOSITORY}" \
    --target "${BUILD_COMMIT}" \
    --title "${TITLE}" \
    --notes-file "${NOTES_FILE}" \
    --prerelease \
    "${ARCHIVE}" \
    "${ARCHIVE_SHA256}"

echo "=== 回下载校验 ==="
gh release download "${TAG}" \
    -R "${REPOSITORY}" \
    --dir "${VERIFY_DIR}" \
    --pattern "$(basename "${ARCHIVE}")" \
    --pattern "$(basename "${ARCHIVE_SHA256}")"

(
    cd "${VERIFY_DIR}"
    sha256sum -c "$(basename "${ARCHIVE_SHA256}")"
)

echo "=== Release 信息 ==="
gh release view "${TAG}" -R "${REPOSITORY}" \
    --json url,name,tagName,isPrerelease,targetCommitish,assets

echo "Pre-release 发布并回下载校验完成: ${TAG}"
