#!/usr/bin/env bash
set -Eeuo pipefail

# Raphael 内核镜像更新入口。
# 只负责选择 GitHub 下载代理，然后调用同仓库的 update-kernel.sh。

RAW_URL="https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/update-kernel.sh"
ROUTE=""
PASSTHROUGH=()
TMP_SCRIPT=""

usage() {
    cat <<'USAGE'
Raphael 内核镜像更新入口

用法:
  ghproxy-update-kernel.sh
  ghproxy-update-kernel.sh --route ghfast [update-kernel.sh 参数...]
  ghproxy-update-kernel.sh --route koishi [update-kernel.sh 参数...]

镜像线路:
  1) ghfast.top
  2) proxy.koishi.asia

其余参数会原样传递给 update-kernel.sh，例如：
  --list
  --tag TAG
  --yes
  --cleanup-only
USAGE
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

while (($#)); do
    case "$1" in
        --route)
            ROUTE="${2:?缺少 --route 参数}"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            PASSTHROUGH+=("$1")
            shift
            ;;
    esac
done

if [[ -z "${ROUTE}" ]]; then
    echo "=== Raphael GitHub 镜像线路 ==="
    echo "  1) ghfast.top"
    echo "  2) proxy.koishi.asia"
    choice=""
    tty_read "请选择线路 [1-2]: " choice
    case "${choice}" in
        1) ROUTE="ghfast" ;;
        2) ROUTE="koishi" ;;
        *)
            echo "无效选项: ${choice}" >&2
            exit 2
            ;;
    esac
fi

case "${ROUTE}" in
    ghfast)
        PROXY_PREFIX="https://ghfast.top/"
        ;;
    koishi)
        PROXY_PREFIX="https://proxy.koishi.asia/"
        ;;
    *)
        echo "未知镜像线路: ${ROUTE}" >&2
        echo "可选: ghfast / koishi" >&2
        exit 2
        ;;
esac

command -v curl >/dev/null 2>&1 || {
    echo "缺少 curl" >&2
    exit 1
}

TMP_SCRIPT="$(mktemp /tmp/raphael-update-kernel.XXXXXX.sh)"
cleanup() {
    [[ -n "${TMP_SCRIPT}" ]] && rm -f "${TMP_SCRIPT}"
}
trap cleanup EXIT

echo "使用镜像线路: ${ROUTE}"
echo "获取更新脚本..."
curl -fL --retry 3 --retry-delay 2 \
    -o "${TMP_SCRIPT}" \
    "${PROXY_PREFIX}${RAW_URL}"

chmod 700 "${TMP_SCRIPT}"
bash "${TMP_SCRIPT}" --mirror "${ROUTE}" "${PASSTHROUGH[@]}"
