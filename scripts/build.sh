#!/usr/bin/env bash
set -euo pipefail

build_root="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is not set}"
source_dir="${build_root}/linux-src"
artifact_dir="${build_root}/artifacts"
config_fragment="${build_root}/raphael.config"
patch_dir="${build_root}/patches"
patch_manifest="${build_root}/patches.sha256"
expected_source_commit="ab4ce59a1826b18ba200b33f6a32d04d749a7ea5"
build_commit="$(git -C "${build_root}" rev-parse HEAD)"

rm -rf "${source_dir}" "${artifact_dir}"

git clone --depth 1 --branch "${KERNEL_BRANCH}" \
    "${KERNEL_REPOSITORY}" "${source_dir}"

source_commit="$(git -C "${source_dir}" rev-parse HEAD)"
if [[ "${source_commit}" != "${expected_source_commit}" ]]; then
    echo "Kernel branch moved: expected ${expected_source_commit}, got ${source_commit}." >&2
    exit 1
fi

mapfile -t patch_names < <(grep -Ev '^[[:space:]]*(#|$)' "${patch_dir}/series")
: > "${patch_manifest}"

for patch_name in "${patch_names[@]}"; do
    [[ "${patch_name}" =~ ^[0-9]{4}-[A-Za-z0-9._-]+\.patch$ ]] || {
        echo "Invalid patch name in series: ${patch_name}" >&2
        exit 1
    }
    test -f "${patch_dir}/${patch_name}"
    git -C "${source_dir}" apply --check "${patch_dir}/${patch_name}"
    git -C "${source_dir}" apply "${patch_dir}/${patch_name}"
done

if ((${#patch_names[@]})); then
    (cd "${patch_dir}" && sha256sum -- "${patch_names[@]}") > "${patch_manifest}"
fi

git -C "${source_dir}" diff --check
git -C "${source_dir}" diff --stat

curl --fail --location --silent --show-error \
    -o "${config_fragment}" \
    "https://raw.githubusercontent.com/GengWei1997/kernel-deb/b509d24efb86fea0842f940138be8bf2301626ff/uboot-raphael.config"

cd "${source_dir}"
make_args=(ARCH=arm64 LLVM=1 CC=clang)

make "${make_args[@]}" defconfig
scripts/kconfig/merge_config.sh -m .config \
    "${config_fragment}" \
    arch/arm64/configs/sm8150.config

scripts/config --set-str LOCALVERSION "-raphael-dsi-flicker-test"
scripts/config --disable LOCALVERSION_AUTO
scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
scripts/config --set-str SYSTEM_REVOCATION_KEYS ""
make "${make_args[@]}" olddefconfig

make -j"$(nproc)" "${make_args[@]}" bindeb-pkg

dtb="${source_dir}/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb"
test -s "${dtb}"

image_deb="$(find "${build_root}" -maxdepth 1 -type f \
    -name 'linux-image-*.deb' ! -name '*dbg*' -print -quit)"
test -n "${image_deb}"
test -s "${image_deb}"

mkdir -p "${artifact_dir}"
install -m 0644 "${image_deb}" \
    "${artifact_dir}/linux-image-xiaomi-raphael-dsi-flicker-test.deb"
install -m 0644 "${dtb}" \
    "${artifact_dir}/sm8150-xiaomi-raphael.dtb"
install -m 0644 .config "${artifact_dir}/kernel.config"
install -m 0644 "${patch_manifest}" "${artifact_dir}/patches.sha256"

kernel_release="$(make -s "${make_args[@]}" kernelrelease)"
printf 'kernel_release=%s\nsource_commit=%s\nsource_branch=%s\nbuild_commit=%s\npatch_count=%s\n' \
    "${kernel_release}" "${source_commit}" "${KERNEL_BRANCH}" \
    "${build_commit}" "${#patch_names[@]}" \
    > "${artifact_dir}/build-info.txt"

cd "${artifact_dir}"
sha256sum \
    linux-image-xiaomi-raphael-dsi-flicker-test.deb \
    sm8150-xiaomi-raphael.dtb \
    kernel.config \
    build-info.txt \
    patches.sha256 \
    > SHA256SUMS
