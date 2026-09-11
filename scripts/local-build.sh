#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BUILD_REPO="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="${RAPHAEL_WORKSPACE_ROOT:-$(dirname "${BUILD_REPO}")}"
SOURCE_REPO="${RAPHAEL_SOURCE_REPO:-${WORKSPACE_ROOT}/raphael-linux}"
EXPECTED_SOURCE_COMMIT="ab4ce59a1826b18ba200b33f6a32d04d749a7ea5"
UPSTREAM_REPOSITORY="https://github.com/GengWei1997/linux.git"
UPSTREAM_BRANCH="raphael-7.1"
JOBS="${JOBS:-$(nproc)}"
KEEP_WORKTREE="${KEEP_WORKTREE:-0}"

usage() {
    cat <<USAGE
用法: $0 [选项]

选项:
  --source-repo PATH   指定本地 GengWei Linux Git 仓库
  --jobs N             并行编译线程数，默认 nproc
  --keep-worktree      构建结束后保留临时源码 worktree，便于排错
  -h, --help           显示帮助

默认不会 clone 网络仓库，而是复用:
  ${SOURCE_REPO}
USAGE
}

while (($#)); do
    case "$1" in
        --source-repo)
            SOURCE_REPO="${2:?缺少 --source-repo 参数}"
            shift 2
            ;;
        --jobs)
            JOBS="${2:?缺少 --jobs 参数}"
            shift 2
            ;;
        --keep-worktree)
            KEEP_WORKTREE=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "未知参数: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "缺少命令: $1" >&2
        return 1
    }
}

missing=0
for cmd in git patch make dpkg-buildpackage dpkg-deb clang-22 ld.lld-22 tar sha256sum bc bison flex awk sed grep; do
    need_cmd "$cmd" || missing=1
done
(( missing == 0 )) || exit 1

[[ "${JOBS}" =~ ^[1-9][0-9]*$ ]] || {
    echo "--jobs 必须是正整数" >&2
    exit 2
}

[[ -d "${SOURCE_REPO}/.git" || -f "${SOURCE_REPO}/.git" ]] || {
    echo "本地源码仓库不存在: ${SOURCE_REPO}" >&2
    exit 1
}

for f in "${BUILD_REPO}/raphael.config" "${BUILD_REPO}/builddeb.patch" "${BUILD_REPO}/patches/series"; do
    [[ -s "$f" ]] || {
        echo "缺少构建文件: $f" >&2
        exit 1
    }
done

# 构建仓库必须是已提交状态，保证 build-info 中的 commit 能完整描述本次构建。
if [[ -n "$(git -C "${BUILD_REPO}" status --porcelain)" ]]; then
    echo "构建仓库存在未提交修改，请先 commit 后再构建：" >&2
    git -C "${BUILD_REPO}" status --short >&2
    exit 1
fi

# 固定基线必须已经存在于本地 Git 对象库中。
git -C "${SOURCE_REPO}" cat-file -e "${EXPECTED_SOURCE_COMMIT}^{commit}" 2>/dev/null || {
    echo "本地源码仓库中不存在固定基线 ${EXPECTED_SOURCE_COMMIT}" >&2
    echo "请先在 ${SOURCE_REPO} 中 fetch GengWei1997/linux raphael-7.1。" >&2
    exit 1
}

BUILD_BRANCH="$(git -C "${BUILD_REPO}" branch --show-current)"
if [[ -z "${BUILD_BRANCH}" ]]; then
    BUILD_BRANCH="detached-$(git -C "${BUILD_REPO}" rev-parse --short=12 HEAD)"
fi
BUILD_BRANCH_SAFE="$(printf '%s' "${BUILD_BRANCH}" | sed 's/[^A-Za-z0-9._-]/-/g')"
BUILD_COMMIT="$(git -C "${BUILD_REPO}" rev-parse HEAD)"
BUILD_COMMIT_DATE="$(git -C "${BUILD_REPO}" show -s --format=%cI HEAD)"

OUT_ROOT="${BUILD_REPO}/out/${BUILD_BRANCH_SAFE}"
WORK_ROOT="${WORKSPACE_ROOT}/.raphael-build"
mkdir -p "${WORK_ROOT}"
rm -rf "${OUT_ROOT}"
mkdir -p "${OUT_ROOT}"
LOG_FILE="${OUT_ROOT}/build.log"

RUN_DIR="$(mktemp -d "${WORK_ROOT}/${BUILD_BRANCH_SAFE}.XXXXXX")"
SOURCE_DIR="${RUN_DIR}/linux-src"
PATCH_MANIFEST="${RUN_DIR}/patches.sha256"
WORKTREE_ADDED=0
BUILD_OK=0
BUILD_STAGE=prepare

# Keep only completed binary packages and small recovery inputs when collection
# fails. The full source tree and debug packages are still disposable.
preserve_completed_packages() {
    local saved="${OUT_ROOT}/failed-packaging" pkg have_packages=0 input
    for pkg in "${RUN_DIR}"/linux-image-*.deb "${RUN_DIR}"/linux-headers-*.deb; do
        [[ -s "$pkg" && "${pkg##*/}" != *-dbg_* ]] || continue
        dpkg-deb -f "$pkg" Package >/dev/null 2>&1 || continue
        mkdir -p "$saved" || return 1
        cp -- "$pkg" "$saved/" || return 1
        have_packages=1
    done
    (( have_packages )) || return 0

    for input in .config include/config/kernel.release \
        arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb; do
        [[ ! -s "${SOURCE_DIR}/$input" ]] ||
            cp -- "${SOURCE_DIR}/$input" "$saved/" || return 1
    done
    for input in patches.sha256 image-contents.txt; do
        [[ ! -s "${RUN_DIR}/$input" ]] ||
            cp -- "${RUN_DIR}/$input" "$saved/" || return 1
    done
    {
        printf 'build_commit=%s\nsource_commit=%s\nstage=%s\n' \
            "$BUILD_COMMIT" "$EXPECTED_SOURCE_COMMIT" "$BUILD_STAGE"
        printf 'status=UNVERIFIED_NOT_FOR_RELEASE\n'
    } > "$saved/recovery-info.txt" || return 1
    echo "已保留待复核的非 debug 包和打包输入: $saved"
}

cleanup() {

    local rc=$?
    set +e
    cd / >/dev/null 2>&1 || true

    if (( rc != 0 )) && ! preserve_completed_packages; then
        # Never discard the only packages if saving the recovery copy fails.
        KEEP_WORKTREE=1
        echo "保存恢复包失败，临时目录保留供排查: ${RUN_DIR}" >&2
    fi

    if (( KEEP_WORKTREE == 0 )); then

        if (( WORKTREE_ADDED == 1 )); then
            git -C "${SOURCE_REPO}" worktree remove --force "${SOURCE_DIR}" >/dev/null 2>&1 || true
            git -C "${SOURCE_REPO}" worktree prune >/dev/null 2>&1 || true
        fi
        rm -rf "${RUN_DIR}"
    else
        echo "临时 worktree 已保留: ${SOURCE_DIR}"
    fi

    if (( rc != 0 )); then
        echo "构建失败，日志保留在: ${LOG_FILE}" >&2
    elif (( BUILD_OK == 1 )); then
        echo "本轮临时源码与中间包已清理。"
    fi
    return "$rc"
}
trap cleanup EXIT
trap 'printf "阶段 %s，第 %s 行失败: %s\n" "$BUILD_STAGE" "$LINENO" "$BASH_COMMAND" >&2' ERR


# 终端输出同时保存到 out/<branch>/build.log。
exec > >(tee -a "${LOG_FILE}") 2>&1

echo "=== Raphael 本地构建 ==="
echo "构建分支: ${BUILD_BRANCH}"
echo "构建仓库提交: ${BUILD_COMMIT}"
echo "固定上游: ${UPSTREAM_REPOSITORY} ${UPSTREAM_BRANCH}"
echo "固定源码提交: ${EXPECTED_SOURCE_COMMIT}"
echo "复用本地源码: ${SOURCE_REPO}"
echo "临时工作区: ${RUN_DIR}"
echo "并行线程: ${JOBS}"
echo "Clang: $(clang-22 --version | head -n1)"

echo "=== 创建本地 Git worktree（不 clone） ==="
git -C "${SOURCE_REPO}" worktree add --detach "${SOURCE_DIR}" "${EXPECTED_SOURCE_COMMIT}"
WORKTREE_ADDED=1

SOURCE_COMMIT="$(git -C "${SOURCE_DIR}" rev-parse HEAD)"
[[ "${SOURCE_COMMIT}" == "${EXPECTED_SOURCE_COMMIT}" ]] || {
    echo "源码基线错误: ${SOURCE_COMMIT}" >&2
    exit 1
}

echo "=== 应用 DTB 打包调整 ==="
patch --dry-run "${SOURCE_DIR}/scripts/package/builddeb" < "${BUILD_REPO}/builddeb.patch"
patch "${SOURCE_DIR}/scripts/package/builddeb" < "${BUILD_REPO}/builddeb.patch"

echo "=== 应用当前分支 patch series ==="
mapfile -t PATCH_NAMES < <(grep -Ev '^[[:space:]]*(#|$)' "${BUILD_REPO}/patches/series")
: > "${PATCH_MANIFEST}"

for patch_name in "${PATCH_NAMES[@]}"; do
    [[ "${patch_name}" =~ ^[0-9]{4}-[A-Za-z0-9._-]+\.patch$ ]] || {
        echo "非法 patch 文件名: ${patch_name}" >&2
        exit 1
    }
    patch_path="${BUILD_REPO}/patches/${patch_name}"
    [[ -f "${patch_path}" ]] || {
        echo "patch 不存在: ${patch_path}" >&2
        exit 1
    }
    echo "APPLY ${patch_name}"
    git -C "${SOURCE_DIR}" apply --check "${patch_path}"
    git -C "${SOURCE_DIR}" apply "${patch_path}"
done

if ((${#PATCH_NAMES[@]})); then
    (cd "${BUILD_REPO}/patches" && sha256sum -- "${PATCH_NAMES[@]}") > "${PATCH_MANIFEST}"
fi

git -C "${SOURCE_DIR}" diff --check
git -C "${SOURCE_DIR}" diff --stat

# 把已审查 patch 和 builddeb 调整提交到临时源码树，获得稳定的 kernel release hash。
git -C "${SOURCE_DIR}" config user.email "60956553+snowf14k3@users.noreply.github.com"
git -C "${SOURCE_DIR}" config user.name "snowf14k3"
git -C "${SOURCE_DIR}" add -A
GIT_AUTHOR_DATE="${BUILD_COMMIT_DATE}" \
GIT_COMMITTER_DATE="${BUILD_COMMIT_DATE}" \
    git -C "${SOURCE_DIR}" commit -m "build: apply ${BUILD_BRANCH} patch series"
PATCHED_SOURCE_COMMIT="$(git -C "${SOURCE_DIR}" rev-parse HEAD)"

cd "${SOURCE_DIR}"
install -m 0644 "${BUILD_REPO}/raphael.config" arch/arm64/configs/raphael.config
MAKE_ARGS=(ARCH=arm64 LLVM=-22)

echo "=== 生成 Raphael 配置 ==="
make -j"${JOBS}" "${MAKE_ARGS[@]}" defconfig raphael.config

# 稳定基线必须具备的关键配置。
grep -qx 'CONFIG_DRM_MSM=y' .config
grep -qx 'CONFIG_DRM_PANEL_SAMSUNG_AMS639RQ08=y' .config
grep -qx 'CONFIG_QCOM_LLCC=y' .config
grep -qx 'CONFIG_SM_GPUCC_8150=y' .config
grep -qx 'CONFIG_INTERCONNECT_QCOM_SM8150=y' .config

BUILD_STAGE=kernel-packages
echo "=== AMD64 本地构建 ARM64 binary-only Debian 包 ==="
make -j"${JOBS}" "${MAKE_ARGS[@]}" DPKG_FLAGS=-d bindeb-pkg

BUILD_STAGE=collect
# kernelrelease is a no-sync-config target. Before bindeb-pkg it can use the
# stale defconfig auto.conf and omit CONFIG_LOCALVERSION from raphael.config.
# Use the release actually written by the completed build instead.
[[ -s include/config/kernel.release ]] || {
    echo "构建没有生成 include/config/kernel.release" >&2
    exit 1
}
KERNEL_RELEASE="$(< include/config/kernel.release)"
[[ "${KERNEL_RELEASE}" =~ ^[A-Za-z0-9._+-]+$ ]] || {
    echo "构建产生非法内核版本号: ${KERNEL_RELEASE}" >&2
    exit 1
}
echo "kernel_release=${KERNEL_RELEASE}"

DTB="${SOURCE_DIR}/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb"
[[ -s "${DTB}" ]] || {
    echo "Raphael DTB 未生成" >&2
    exit 1
}

IMAGE_DEB="$(find "${RUN_DIR}" -maxdepth 1 -type f -name 'linux-image-*.deb' ! -name '*dbg*' -print -quit)"
HEADERS_DEB="$(find "${RUN_DIR}" -maxdepth 1 -type f -name 'linux-headers-*.deb' -print -quit)"
[[ -n "${IMAGE_DEB}" && -s "${IMAGE_DEB}" ]] || {
    echo "没有找到 linux-image arm64 deb" >&2
    exit 1
}
[[ -n "${HEADERS_DEB}" && -s "${HEADERS_DEB}" ]] || {
    echo "没有找到 linux-headers arm64 deb" >&2
    exit 1
}

for package in "${IMAGE_DEB}" "${HEADERS_DEB}"; do
    [[ "$(dpkg-deb -f "$package" Architecture)" == "arm64" ]] || {
        echo "Debian 包不是 arm64: $package" >&2
        exit 1
    }
done
[[ "$(dpkg-deb -f "${IMAGE_DEB}" Package)" == "linux-image-${KERNEL_RELEASE}" &&
   "$(dpkg-deb -f "${HEADERS_DEB}" Package)" == "linux-headers-${KERNEL_RELEASE}" ]] || {
    echo "image/headers 包名与实际内核版本 ${KERNEL_RELEASE} 不一致" >&2
    exit 1
}

dpkg-deb --fsys-tarfile "${IMAGE_DEB}" | tar -tf - > "${RUN_DIR}/image-contents.txt"
for expected in "./boot/dtbs/qcom/sm8150-xiaomi-raphael.dtb" \
                "./boot/vmlinuz-${KERNEL_RELEASE}"; do
    grep -Fxq -- "$expected" "${RUN_DIR}/image-contents.txt" || {
        echo "image 包缺少必要文件: $expected" >&2
        exit 1
    }
done

BUNDLE_NAME="raphael-${BUILD_BRANCH_SAFE}-${KERNEL_RELEASE}"
ARTIFACT_DIR="${OUT_ROOT}/${BUNDLE_NAME}"
mkdir -p "${ARTIFACT_DIR}"

IMAGE_NAME="$(basename "${IMAGE_DEB}")"
HEADERS_NAME="$(basename "${HEADERS_DEB}")"
install -m 0644 "${IMAGE_DEB}" "${ARTIFACT_DIR}/${IMAGE_NAME}"
install -m 0644 "${HEADERS_DEB}" "${ARTIFACT_DIR}/${HEADERS_NAME}"
install -m 0644 "${DTB}" "${ARTIFACT_DIR}/sm8150-xiaomi-raphael.dtb"
install -m 0644 .config "${ARTIFACT_DIR}/kernel.config"
install -m 0644 "${PATCH_MANIFEST}" "${ARTIFACT_DIR}/patches.sha256"
install -m 0644 "${BUILD_REPO}/README.md" "${ARTIFACT_DIR}/README.md"

CLANG_VERSION="$(clang-22 --version | head -n1)"
cat > "${ARTIFACT_DIR}/build-info.txt" <<INFO
kernel_release=${KERNEL_RELEASE}
upstream_repository=${UPSTREAM_REPOSITORY}
source_branch=${UPSTREAM_BRANCH}
source_commit=${SOURCE_COMMIT}
patched_source_commit=${PATCHED_SOURCE_COMMIT}
build_repo_branch=${BUILD_BRANCH}
build_commit=${BUILD_COMMIT}
patch_count=${#PATCH_NAMES[@]}
clang=${CLANG_VERSION}
INFO

(
    cd "${ARTIFACT_DIR}"
    sha256sum \
        "${IMAGE_NAME}" \
        "${HEADERS_NAME}" \
        sm8150-xiaomi-raphael.dtb \
        kernel.config \
        patches.sha256 \
        build-info.txt \
        README.md \
        > SHA256SUMS
    sha256sum -c SHA256SUMS
)

BUILD_STAGE=bundle
ARCHIVE="${OUT_ROOT}/${BUNDLE_NAME}.tar.gz"
tar -C "${OUT_ROOT}" -czf "${ARCHIVE}" "${BUNDLE_NAME}"
(
    cd "${OUT_ROOT}"
    sha256sum "$(basename "${ARCHIVE}")" > "$(basename "${ARCHIVE}").sha256"
    sha256sum -c "$(basename "${ARCHIVE}").sha256"
)

LAST_BUILD_FILE="${OUT_ROOT}/last-build.env"
{
    printf 'BUILD_BRANCH=%q\n' "${BUILD_BRANCH}"
    printf 'BUILD_BRANCH_SAFE=%q\n' "${BUILD_BRANCH_SAFE}"
    printf 'BUILD_COMMIT=%q\n' "${BUILD_COMMIT}"
    printf 'KERNEL_RELEASE=%q\n' "${KERNEL_RELEASE}"
    printf 'SOURCE_COMMIT=%q\n' "${SOURCE_COMMIT}"
    printf 'PATCHED_SOURCE_COMMIT=%q\n' "${PATCHED_SOURCE_COMMIT}"
    printf 'ARTIFACT_DIR=%q\n' "${ARTIFACT_DIR}"
    printf 'ARCHIVE=%q\n' "${ARCHIVE}"
    printf 'ARCHIVE_SHA256=%q\n' "${ARCHIVE}.sha256"
} > "${LAST_BUILD_FILE}"

BUILD_OK=1
cd "${BUILD_REPO}"

echo "=== 构建完成 ==="
echo "内核: ${KERNEL_RELEASE}"
echo "产物目录: ${ARTIFACT_DIR}"
echo "压缩包: ${ARCHIVE}"
echo "SHA256: $(awk '{print $1}' "${ARCHIVE}.sha256")"
echo "构建信息: ${LAST_BUILD_FILE}"
