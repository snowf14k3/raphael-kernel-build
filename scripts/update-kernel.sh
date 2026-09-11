#!/usr/bin/env bash
set -Eeuo pipefail

# Raphael 内核一键更新脚本
# 参考 GengWei1997/kernel-deb 的固定 /boot/linux.efi + /boot/initramfs 更新方式，
# 增加 Pre-release 动态选择、双重校验、升级前备份、原子切换和成功启动后清理。

REPOSITORY="${RAPHAEL_RELEASE_REPO:-snowf14k3/raphael-kernel-build}"
API_BASE="https://api.github.com/repos/${REPOSITORY}"
TAG=""
YES=0
LIST_ONLY=0
CLEANUP_ONLY=0
KEEP_BACKUPS="${RAPHAEL_KEEP_BACKUPS:-3}"
BACKUP_ROOT="${RAPHAEL_BACKUP_ROOT:-}"
TMP_DIR=""

usage() {
    cat <<USAGE
Raphael 内核 Pre-release 更新工具

用法:
  $0                         交互选择 GitHub Pre-release 并更新
  $0 --tag TAG               安装指定 Pre-release tag
  $0 --list                  只列出可安装 Pre-release
  $0 --cleanup-only          只清理非当前运行版本的旧内核
  $0 --yes                   非交互确认；未指定 tag 时选择列表第一项
  $0 --repo OWNER/REPO       指定 Release 仓库

推荐直接运行:
  sudo bash -c "\$(curl -fsSL https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/update-kernel.sh)"

说明:
  - 当前真正启动文件固定为 /boot/linux.efi 与 /boot/initramfs。
  - 新内核完整安装并校验前不会覆盖这两个文件。
  - 当前运行内核会保留到新内核成功启动；成功启动后 systemd 自动清理旧版本。
USAGE
}

while (($#)); do
    case "$1" in
        --tag)
            TAG="${2:?缺少 --tag 参数}"
            shift 2
            ;;
        --list)
            LIST_ONLY=1
            shift
            ;;
        --cleanup-only)
            CLEANUP_ONLY=1
            shift
            ;;
        --yes|-y)
            YES=1
            shift
            ;;
        --repo)
            REPOSITORY="${2:?缺少 --repo 参数}"
            API_BASE="https://api.github.com/repos/${REPOSITORY}"
            shift 2
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
        exit 1
    }
}

for cmd in curl awk sed grep tar sha256sum sort head find uname; do
    need_cmd "$cmd"
done

API_CURL=(
    curl -fsSL
    -H "Accept: application/vnd.github+json"
    -H "X-GitHub-Api-Version: 2022-11-28"
    -H "User-Agent: raphael-kernel-updater"
)
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    API_CURL+=( -H "Authorization: Bearer ${GITHUB_TOKEN}" )
fi

api_get() {
    "${API_CURL[@]}" "$1"
}

tty_read() {
    local prompt="$1"
    local __var="$2"
    local value=""
    if [[ -r /dev/tty ]]; then
        printf '%s' "${prompt}" >/dev/tty
        IFS= read -r value </dev/tty
    else
        printf '%s' "${prompt}"
        IFS= read -r value
    fi
    printf -v "${__var}" '%s' "${value}"
}

confirm() {
    local prompt="$1"
    local answer=""
    (( YES == 1 )) && return 0
    tty_read "${prompt} [y/N]: " answer
    [[ "${answer}" =~ ^[Yy]([Ee][Ss])?$ ]]
}

# 输出: tag<TAB>name<TAB>published_at
list_prereleases() {
    local json
    json="$(api_get "${API_BASE}/releases?per_page=20")"

    if [[ "${RAPHAEL_NO_JQ:-0}" != 1 ]] && command -v jq >/dev/null 2>&1; then
        printf '%s\n' "${json}" | jq -r '
            .[]
            | select(.draft == false and .prerelease == true)
            | select(any(.assets[]?; (.name | endswith(".tar.gz"))))
            | [.tag_name, (.name // .tag_name), (.published_at // "")]
            | @tsv
        '
        return
    fi

    # GitHub API 可能返回单行 JSON。无 jq 时先从 release 列表抽取 tag，
    # 再逐个查询前 8 个 release 的元数据，避免依赖 JSON 格式化方式。
    local tag meta name published count=0
    while IFS= read -r tag; do
        [[ -n "${tag}" ]] || continue
        ((count+=1))
        (( count <= 8 )) || break

        meta="$(api_get "${API_BASE}/releases/tags/${tag}")" || true
        [[ -n "${meta}" ]] || continue
        grep -q '"prerelease":true' <<< "${meta}" || continue
        grep -q '"draft":false' <<< "${meta}" || continue
        grep -Eq '"browser_download_url":"[^"]+\.tar\.gz"' <<< "${meta}" || continue

        name="$(printf '%s\n' "${meta}" | grep -o '"name":"[^"]*"' | head -n1 | sed 's/^"name":"//;s/"$//')"
        published="$(printf '%s\n' "${meta}" | grep -o '"published_at":"[^"]*"' | head -n1 | sed 's/^"published_at":"//;s/"$//')"
        [[ -n "${name}" ]] || name="${tag}"
        printf '%s\t%s\t%s\n' "${tag}" "${name}" "${published}"
    done < <(
        printf '%s\n' "${json}" |
        grep -o '"tag_name":"[^"]*"' |
        sed 's/^"tag_name":"//;s/"$//'
    )
}

show_prereleases() {
    local -n __lines=$1
    local i line tag name published
    echo "=== 可安装的 Raphael Pre-release ==="
    if ((${#__lines[@]} == 0)); then
        echo "当前没有带 tar.gz 构建包的 Pre-release。"
        return 1
    fi
    for ((i=0; i<${#__lines[@]}; i++)); do
        line="${__lines[$i]}"
        IFS=$'\t' read -r tag name published <<< "${line}"
        printf '  %2d) %s\n      %s  %s\n' "$((i+1))" "${name}" "${tag}" "${published}"
    done
}

mapfile -t RELEASE_LINES < <(list_prereleases)
if (( LIST_ONLY == 1 )); then
    show_prereleases RELEASE_LINES || true
    exit 0
fi

if [[ -z "${TAG}" ]]; then
    show_prereleases RELEASE_LINES || exit 1
    if (( YES == 1 )); then
        IFS=$'\t' read -r TAG _ _ <<< "${RELEASE_LINES[0]}"
    else
        choice=""
        tty_read "请选择版本 [1-${#RELEASE_LINES[@]}]: " choice
        [[ "${choice}" =~ ^[0-9]+$ ]] || {
            echo "无效选项" >&2
            exit 2
        }
        (( choice >= 1 && choice <= ${#RELEASE_LINES[@]} )) || {
            echo "选项超出范围" >&2
            exit 2
        }
        IFS=$'\t' read -r TAG _ _ <<< "${RELEASE_LINES[$((choice-1))]}"
    fi
fi

RELEASE_JSON="$(api_get "${API_BASE}/releases/tags/${TAG}")"
if [[ "${RAPHAEL_NO_JQ:-0}" != 1 ]] && command -v jq >/dev/null 2>&1; then
    IS_PRE="$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.prerelease')"
    IS_DRAFT="$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.draft')"
    RELEASE_NAME="$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.name // .tag_name')"
    ARCHIVE_URL="$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.assets[]? | select(.name | endswith(".tar.gz")) | .browser_download_url' | head -n1)"
    SHA_URL="$(printf '%s\n' "${RELEASE_JSON}" | jq -r '.assets[]? | select(.name | endswith(".tar.gz.sha256")) | .browser_download_url' | head -n1)"
else
    grep -q '"prerelease":true' <<< "${RELEASE_JSON}" && IS_PRE=true || IS_PRE=false
    grep -q '"draft":true' <<< "${RELEASE_JSON}" && IS_DRAFT=true || IS_DRAFT=false
    RELEASE_NAME="$(printf '%s\n' "${RELEASE_JSON}" | grep -o '"name":"[^"]*"' | head -n1 | sed 's/^"name":"//;s/"$//' || true)"
    [[ -n "${RELEASE_NAME}" ]] || RELEASE_NAME="${TAG}"
    ARCHIVE_URL="$(printf '%s\n' "${RELEASE_JSON}" | grep -o '"browser_download_url":"[^"]*\.tar\.gz"' | head -n1 | sed 's/^"browser_download_url":"//;s/"$//' || true)"
    SHA_URL="$(printf '%s\n' "${RELEASE_JSON}" | grep -o '"browser_download_url":"[^"]*\.tar\.gz\.sha256"' | head -n1 | sed 's/^"browser_download_url":"//;s/"$//' || true)"
fi

[[ "${IS_PRE}" == "true" && "${IS_DRAFT}" != "true" ]] || {
    echo "指定 tag 不是可安装的 Pre-release: ${TAG}" >&2
    exit 1
}
[[ -n "${ARCHIVE_URL}" && "${ARCHIVE_URL}" != "null" ]] || {
    echo "Pre-release 中没有 tar.gz 内核包: ${TAG}" >&2
    exit 1
}

echo "已选择: ${RELEASE_NAME}"
echo "tag: ${TAG}"

if (( EUID != 0 )); then
    echo "安装内核需要 root，请使用 sudo 运行。" >&2
    exit 1
fi

for cmd in dpkg dpkg-query dpkg-deb update-initramfs systemctl cp mv rm mkdir sync df; do
    need_cmd "$cmd"
done

[[ "${KEEP_BACKUPS}" =~ ^[1-9][0-9]*$ ]] || KEEP_BACKUPS=3
CURRENT_KERNEL="$(uname -r)"

if [[ -z "${BACKUP_ROOT}" ]]; then
    if [[ -d /home/user ]]; then
        BACKUP_ROOT="/home/user/kernel-backups"
    else
        BACKUP_ROOT="/var/backups/raphael-kernel"
    fi
fi

cleanup_noncurrent() {
    local current="$1"
    local target="$2"
    local pkg rel f dir prefix

    echo "=== 清理非当前运行的旧 Raphael 内核 ==="
    mapfile -t old_pkgs < <(
        dpkg-query -W -f='${binary:Package}\t${db:Status-Abbrev}\n' 2>/dev/null |
        awk '$2 ~ /^ii/ && $1 ~ /^linux-(image|headers)-.*sm8150-/ {print $1}'
    )

    for pkg in "${old_pkgs[@]}"; do
        [[ "${pkg}" == *"${current}"* ]] && continue
        [[ -n "${target}" && "${pkg}" == *"${target}"* ]] && continue
        echo "purge: ${pkg}"
        dpkg -P "${pkg}" || true
    done

    for prefix in vmlinuz initrd.img config System.map; do
        for f in /boot/${prefix}-*sm8150-*; do
            [[ -e "${f}" ]] || continue
            rel="${f#/boot/${prefix}-}"
            [[ "${rel}" == "${current}" ]] && continue
            [[ -n "${target}" && "${rel}" == "${target}" ]] && continue
            echo "remove stale: ${f}"
            rm -f -- "${f}"
        done
    done

    for dir in /lib/modules/*sm8150-*; do
        [[ -d "${dir}" ]] || continue
        rel="$(basename "${dir}")"
        [[ "${rel}" == "${current}" ]] && continue
        [[ -n "${target}" && "${rel}" == "${target}" ]] && continue
        echo "remove stale modules: ${dir}"
        rm -rf -- "${dir}"
    done
}

if (( CLEANUP_ONLY == 1 )); then
    cleanup_noncurrent "${CURRENT_KERNEL}" "${CURRENT_KERNEL}"
    echo "当前运行内核已保留: ${CURRENT_KERNEL}"
    df -h /boot
    exit 0
fi

TMP_DIR="$(mktemp -d /tmp/raphael-kernel-update.XXXXXX)"
cleanup_tmp() {
    [[ -n "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}"
}
trap cleanup_tmp EXIT

ARCHIVE_NAME="$(basename "${ARCHIVE_URL%%\?*}")"
ARCHIVE_PATH="${TMP_DIR}/${ARCHIVE_NAME}"
echo "=== 下载 Pre-release ==="
curl -fL --retry 3 --retry-delay 2 -o "${ARCHIVE_PATH}" "${ARCHIVE_URL}"

if [[ -n "${SHA_URL}" && "${SHA_URL}" != "null" ]]; then
    SHA_NAME="$(basename "${SHA_URL%%\?*}")"
    curl -fL --retry 3 --retry-delay 2 -o "${TMP_DIR}/${SHA_NAME}" "${SHA_URL}"
    echo "=== 校验外层 tar.gz ==="
    (cd "${TMP_DIR}" && sha256sum -c "${SHA_NAME}")
else
    echo "警告：该旧 Pre-release 没有 tar.gz.sha256，将只验证包内 SHA256SUMS。"
fi

mkdir -p "${TMP_DIR}/extract"
tar -xzf "${ARCHIVE_PATH}" -C "${TMP_DIR}/extract"
SHA256SUMS_FILE="$(find "${TMP_DIR}/extract" -maxdepth 2 -type f -name SHA256SUMS -print -quit)"
[[ -n "${SHA256SUMS_FILE}" ]] || {
    echo "压缩包内缺少 SHA256SUMS" >&2
    exit 1
}
ARTIFACT_DIR="$(dirname "${SHA256SUMS_FILE}")"

echo "=== 校验包内文件 ==="
(cd "${ARTIFACT_DIR}" && sha256sum -c SHA256SUMS)

BUILD_INFO="${ARTIFACT_DIR}/build-info.txt"
[[ -s "${BUILD_INFO}" ]] || {
    echo "缺少 build-info.txt" >&2
    exit 1
}
TARGET_KERNEL="$(awk -F= '$1=="kernel_release" {sub(/^[^=]*=/, ""); print; exit}' "${BUILD_INFO}")"
[[ -n "${TARGET_KERNEL}" ]] || {
    echo "无法从 build-info.txt 获取 kernel_release" >&2
    exit 1
}

IMAGE_DEB="$(find "${ARTIFACT_DIR}" -maxdepth 1 -type f -name 'linux-image-*.deb' ! -name '*dbg*' -print -quit)"
HEADERS_DEB="$(find "${ARTIFACT_DIR}" -maxdepth 1 -type f -name 'linux-headers-*.deb' -print -quit)"
RELEASE_DTB="${ARTIFACT_DIR}/sm8150-xiaomi-raphael.dtb"
[[ -s "${IMAGE_DEB}" && -s "${HEADERS_DEB}" && -s "${RELEASE_DTB}" ]] || {
    echo "Release 包缺少 image/headers/Raphael DTB" >&2
    exit 1
}

IMAGE_ARCH="$(dpkg-deb -f "${IMAGE_DEB}" Architecture)"
HEADERS_ARCH="$(dpkg-deb -f "${HEADERS_DEB}" Architecture)"
[[ "${IMAGE_ARCH}" == "arm64" && "${HEADERS_ARCH}" == "arm64" ]] || {
    echo "软件包架构不是 arm64" >&2
    exit 1
}

IMAGE_PACKAGE="$(dpkg-deb -f "${IMAGE_DEB}" Package)"
HEADERS_PACKAGE="$(dpkg-deb -f "${HEADERS_DEB}" Package)"

echo "=== 更新计划 ==="
echo "当前运行: ${CURRENT_KERNEL}"
echo "目标内核: ${TARGET_KERNEL}"
echo "image: ${IMAGE_PACKAGE}"
echo "headers: ${HEADERS_PACKAGE}"
echo "boot: $(df -h /boot | tail -n1)"

if [[ "$(uname -m)" != "aarch64" && "$(uname -m)" != "arm64" ]]; then
    echo "警告：目标机当前架构是 $(uname -m)，不是预期的 ARM64。"
    confirm "仍然继续吗？" || exit 1
fi

if [[ "${CURRENT_KERNEL}" == "${TARGET_KERNEL}" ]]; then
    confirm "目标版本与当前运行版本相同，仍要重新安装吗？" || exit 0
else
    confirm "确认安装 ${TARGET_KERNEL} 并切换下次启动吗？" || exit 0
fi

mkdir -p "${BACKUP_ROOT}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${STAMP}-${CURRENT_KERNEL}"
mkdir -p "${BACKUP_DIR}/boot"

echo "=== 备份当前可启动内核 ==="
for f in /boot/linux.efi /boot/initramfs; do
    [[ -f "${f}" ]] && cp -a "${f}" "${BACKUP_DIR}/boot/"
done
for prefix in vmlinuz initrd.img config System.map; do
    f="/boot/${prefix}-${CURRENT_KERNEL}"
    [[ -f "${f}" ]] && cp -a "${f}" "${BACKUP_DIR}/boot/"
done
if [[ -d /boot/dtbs/qcom ]]; then
    cp -a /boot/dtbs/qcom "${BACKUP_DIR}/dtbs-qcom"
fi
if [[ -f /boot/loader/entries/ubuntu.conf ]]; then
    mkdir -p "${BACKUP_DIR}/loader"
    cp -a /boot/loader/entries/ubuntu.conf "${BACKUP_DIR}/loader/"
fi
if [[ -d "/lib/modules/${CURRENT_KERNEL}" ]]; then
    mkdir -p "${BACKUP_DIR}/modules"
    cp -a "/lib/modules/${CURRENT_KERNEL}" "${BACKUP_DIR}/modules/"
fi
dpkg-query -W -f='${binary:Package}\t${Version}\t${db:Status-Abbrev}\n' > "${BACKUP_DIR}/packages.txt" 2>/dev/null || true

cat > "${BACKUP_DIR}/restore-boot.sh" <<RESTORE
#!/usr/bin/env bash
set -Eeuo pipefail
[[ \${EUID} -eq 0 ]] || { echo "请使用 root 运行" >&2; exit 1; }
BACKUP="${BACKUP_DIR}"
CURRENT="${CURRENT_KERNEL}"
cp "\${BACKUP}/boot/linux.efi" /boot/linux.efi.new
cp "\${BACKUP}/boot/initramfs" /boot/initramfs.new
sync
mv -f /boot/linux.efi.new /boot/linux.efi
mv -f /boot/initramfs.new /boot/initramfs
if [[ -d "\${BACKUP}/dtbs-qcom" ]]; then
    rm -rf /boot/dtbs/qcom
    mkdir -p /boot/dtbs
    cp -a "\${BACKUP}/dtbs-qcom" /boot/dtbs/qcom
fi
if [[ -d "\${BACKUP}/modules/\${CURRENT}" ]]; then
    mkdir -p /lib/modules
    rm -rf "/lib/modules/\${CURRENT}"
    cp -a "\${BACKUP}/modules/\${CURRENT}" /lib/modules/
fi
sync
echo "已恢复启动文件到 \${CURRENT}，请重启。"
RESTORE
chmod 700 "${BACKUP_DIR}/restore-boot.sh"
echo "备份目录: ${BACKUP_DIR}"

# 更新前先清掉真正无用的历史版本，但保留当前正在运行版本作为回退。
cleanup_noncurrent "${CURRENT_KERNEL}" "${TARGET_KERNEL}"

FREE_BOOT_KB="$(df -Pk /boot | awk 'NR==2 {print $4}')"
if (( FREE_BOOT_KB < 55000 )); then
    echo "清理后 /boot 可用空间不足 55 MiB，停止安装。" >&2
    echo "当前: $(df -h /boot | tail -n1)" >&2
    exit 1
fi

# 该 /boot 文件系统不允许 dpkg 创建覆盖备份链接；先备份并移走共享 DTB 目录，
# 再用 --force-overwrite 安装新 image。
echo "=== 安装新内核包 ==="
rm -rf /boot/dtbs/qcom

if ! dpkg -i --force-overwrite "${IMAGE_DEB}"; then
    echo "image 安装失败，恢复旧 DTB。" >&2
    rm -rf /boot/dtbs/qcom
    mkdir -p /boot/dtbs
    [[ -d "${BACKUP_DIR}/dtbs-qcom" ]] && cp -a "${BACKUP_DIR}/dtbs-qcom" /boot/dtbs/qcom
    exit 1
fi

if ! dpkg -i "${HEADERS_DEB}"; then
    echo "headers 安装失败。image 已安装但尚未切换固定启动文件。" >&2
    exit 1
fi

TARGET_VMLINUZ="/boot/vmlinuz-${TARGET_KERNEL}"
TARGET_INITRD="/boot/initrd.img-${TARGET_KERNEL}"
TARGET_DTB="/boot/dtbs/qcom/sm8150-xiaomi-raphael.dtb"

[[ -s "${TARGET_VMLINUZ}" ]] || {
    echo "缺少 ${TARGET_VMLINUZ}" >&2
    exit 1
}
if [[ ! -s "${TARGET_INITRD}" ]]; then
    echo "initrd 尚未生成，手动生成 ${TARGET_KERNEL}"
    update-initramfs -c -k "${TARGET_KERNEL}"
fi
[[ -s "${TARGET_INITRD}" ]] || {
    echo "缺少 ${TARGET_INITRD}" >&2
    exit 1
}
[[ -s "${TARGET_DTB}" ]] || {
    echo "缺少 Raphael DTB: ${TARGET_DTB}" >&2
    exit 1
}

RELEASE_DTB_HASH="$(sha256sum "${RELEASE_DTB}" | awk '{print $1}')"
INSTALLED_DTB_HASH="$(sha256sum "${TARGET_DTB}" | awk '{print $1}')"
[[ "${RELEASE_DTB_HASH}" == "${INSTALLED_DTB_HASH}" ]] || {
    echo "安装后的 Raphael DTB 与 Release 不一致" >&2
    exit 1
}

AUDIT="$(dpkg --audit 2>&1 || true)"
if [[ -n "${AUDIT}" ]]; then
    echo "警告：dpkg --audit 有输出："
    echo "${AUDIT}"
fi

# 保存新包，成功启动后 finalizer purge 旧包后会用它重新确认共享 DTB 所有权。
CACHE_DIR="/var/cache/raphael-kernel-update/${TARGET_KERNEL}"
rm -rf "${CACHE_DIR}"
mkdir -p "${CACHE_DIR}"
cp -a "${IMAGE_DEB}" "${CACHE_DIR}/image.deb"
cp -a "${HEADERS_DEB}" "${CACHE_DIR}/headers.deb"
cp -a "${RELEASE_DTB}" "${CACHE_DIR}/sm8150-xiaomi-raphael.dtb"

STATE_DIR="/var/lib/raphael-kernel-update"
mkdir -p "${STATE_DIR}"
cat > "${STATE_DIR}/pending.env" <<PENDING
TARGET_KERNEL=${TARGET_KERNEL@Q}
CACHE_DIR=${CACHE_DIR@Q}
IMAGE_PACKAGE=${IMAGE_PACKAGE@Q}
HEADERS_PACKAGE=${HEADERS_PACKAGE@Q}
PENDING

cat > /usr/local/sbin/raphael-kernel-finalize <<'FINALIZER'
#!/usr/bin/env bash
set -Eeuo pipefail
STATE=/var/lib/raphael-kernel-update/pending.env
[[ -r "${STATE}" ]] || exit 0
# shellcheck disable=SC1090
source "${STATE}"
CURRENT="$(uname -r)"
if [[ "${CURRENT}" != "${TARGET_KERNEL}" ]]; then
    echo "Raphael kernel finalize: 当前 ${CURRENT}，等待目标 ${TARGET_KERNEL} 成功启动。"
    exit 0
fi

echo "Raphael kernel finalize: ${TARGET_KERNEL} 已成功启动，开始清理旧版本。"

mapfile -t pkgs < <(
    dpkg-query -W -f='${binary:Package}\t${db:Status-Abbrev}\n' 2>/dev/null |
    awk '$2 ~ /^ii/ && $1 ~ /^linux-(image|headers)-.*sm8150-/ {print $1}'
)
for pkg in "${pkgs[@]}"; do
    [[ "${pkg}" == *"${TARGET_KERNEL}"* ]] && continue
    echo "purge old: ${pkg}"
    dpkg -P "${pkg}" || true
done

for prefix in vmlinuz initrd.img config System.map; do
    for f in /boot/${prefix}-*sm8150-*; do
        [[ -e "${f}" ]] || continue
        rel="${f#/boot/${prefix}-}"
        [[ "${rel}" == "${TARGET_KERNEL}" ]] && continue
        rm -f -- "${f}"
    done
done
for dir in /lib/modules/*sm8150-*; do
    [[ -d "${dir}" ]] || continue
    [[ "$(basename "${dir}")" == "${TARGET_KERNEL}" ]] && continue
    rm -rf -- "${dir}"
done

# purge 旧包可能再次触碰共享 DTB；用缓存的新 image 重新确认目标包与 DTB。
if [[ -s "${CACHE_DIR}/image.deb" ]]; then
    dpkg -i --force-overwrite "${CACHE_DIR}/image.deb"
fi
if [[ -s "${CACHE_DIR}/headers.deb" ]]; then
    dpkg -i "${CACHE_DIR}/headers.deb" || true
fi

VMLINUZ="/boot/vmlinuz-${TARGET_KERNEL}"
INITRD="/boot/initrd.img-${TARGET_KERNEL}"
[[ -s "${INITRD}" ]] || update-initramfs -c -k "${TARGET_KERNEL}"
[[ -s "${VMLINUZ}" && -s "${INITRD}" ]] || {
    echo "finalize: 目标启动文件缺失，保留状态供人工处理" >&2
    exit 1
}

cp "${VMLINUZ}" /boot/linux.efi.new
cp "${INITRD}" /boot/initramfs.new
sync
mv -f /boot/linux.efi.new /boot/linux.efi
mv -f /boot/initramfs.new /boot/initramfs
sync

[[ "$(sha256sum /boot/linux.efi | awk '{print $1}')" == "$(sha256sum "${VMLINUZ}" | awk '{print $1}')" ]]
[[ "$(sha256sum /boot/initramfs | awk '{print $1}')" == "$(sha256sum "${INITRD}" | awk '{print $1}')" ]]

rm -rf "${CACHE_DIR}"
rm -f "${STATE}"
systemctl disable raphael-kernel-finalize.service >/dev/null 2>&1 || true

echo "Raphael kernel finalize: 旧内核清理完成。"
FINALIZER
chmod 755 /usr/local/sbin/raphael-kernel-finalize

cat > /etc/systemd/system/raphael-kernel-finalize.service <<'UNIT'
[Unit]
Description=Raphael kernel post-boot cleanup
After=local-fs.target
ConditionPathExists=/var/lib/raphael-kernel-update/pending.env

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/raphael-kernel-finalize

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable raphael-kernel-finalize.service >/dev/null

# 所有安装和校验完成后才切换固定启动文件。
echo "=== 原子切换固定启动文件 ==="
cp "${TARGET_VMLINUZ}" /boot/linux.efi.new
cp "${TARGET_INITRD}" /boot/initramfs.new
sync
mv -f /boot/linux.efi.new /boot/linux.efi
mv -f /boot/initramfs.new /boot/initramfs
sync

VMLINUX_HASH="$(sha256sum "${TARGET_VMLINUZ}" | awk '{print $1}')"
FIXED_KERNEL_HASH="$(sha256sum /boot/linux.efi | awk '{print $1}')"
INITRD_HASH="$(sha256sum "${TARGET_INITRD}" | awk '{print $1}')"
FIXED_INITRD_HASH="$(sha256sum /boot/initramfs | awk '{print $1}')"
if [[ "${VMLINUX_HASH}" != "${FIXED_KERNEL_HASH}" || "${INITRD_HASH}" != "${FIXED_INITRD_HASH}" ]]; then
    echo "固定启动文件校验失败，自动恢复更新前备份。" >&2
    cp "${BACKUP_DIR}/boot/linux.efi" /boot/linux.efi.new
    cp "${BACKUP_DIR}/boot/initramfs" /boot/initramfs.new
    sync
    mv -f /boot/linux.efi.new /boot/linux.efi
    mv -f /boot/initramfs.new /boot/initramfs
    sync
    rm -f /var/lib/raphael-kernel-update/pending.env
    systemctl disable raphael-kernel-finalize.service >/dev/null 2>&1 || true
    exit 1
fi

# 只保留最近 N 份回退备份。
mapfile -t BACKUPS < <(find "${BACKUP_ROOT}" -mindepth 1 -maxdepth 1 -type d -printf '%T@\t%p\n' | sort -rn | cut -f2-)
if ((${#BACKUPS[@]} > KEEP_BACKUPS)); then
    for ((i=KEEP_BACKUPS; i<${#BACKUPS[@]}; i++)); do
        rm -rf -- "${BACKUPS[$i]}"
    done
fi

echo
echo "=== 更新准备完成 ==="
echo "当前仍在运行: ${CURRENT_KERNEL}"
echo "下次启动目标: ${TARGET_KERNEL}"
echo "启动内核 SHA256: ${FIXED_KERNEL_HASH}"
echo "initramfs SHA256: ${FIXED_INITRD_HASH}"
echo "Raphael DTB SHA256: ${INSTALLED_DTB_HASH}"
echo "回退备份: ${BACKUP_DIR}"
echo "新内核成功启动后 raphael-kernel-finalize.service 会自动清理旧内核包和 /boot 旧版本文件。"
echo
echo "现在可以执行: sync && reboot"
