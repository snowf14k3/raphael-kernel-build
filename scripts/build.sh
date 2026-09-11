#!/usr/bin/env bash
set -euo pipefail

build_root="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is not set}"
source_dir="${build_root}/linux-src"
artifact_dir="${build_root}/artifacts"
config_file="${build_root}/raphael.config"
builddeb_patch="${build_root}/builddeb.patch"
patch_dir="${build_root}/patches"
patch_manifest="${build_root}/patches.sha256"
expected_source_commit="ab4ce59a1826b18ba200b33f6a32d04d749a7ea5"
upstream_build_config_commit="0b47a293ed6d4eaa74848bac5b8b4a37bd6f31c6"
build_commit="$(git -C "${build_root}" rev-parse HEAD)"

rm -rf "${source_dir}" "${artifact_dir}"

test -s "${config_file}"
test -s "${builddeb_patch}"

git clone --depth 1 --branch "${KERNEL_BRANCH}" \
    "${KERNEL_REPOSITORY}" "${source_dir}"

source_commit="$(git -C "${source_dir}" rev-parse HEAD)"
if [[ "${source_commit}" != "${expected_source_commit}" ]]; then
    echo "Kernel branch moved: expected ${expected_source_commit}, got ${source_commit}." >&2
    exit 1
fi

# Match GengWei1997/kernel-deb 7.1 packaging: install SM8150 DTBs into /boot.
patch --dry-run "${source_dir}/scripts/package/builddeb" < "${builddeb_patch}"
patch "${source_dir}/scripts/package/builddeb" < "${builddeb_patch}"

# Apply the validated Raphael patch series on top of the known-good 7.1 source.
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

# Keep the source tree clean, like the upstream kernel-deb build does before
# generating the kernel release string.
git -C "${source_dir}" config user.email "gw19970326@gmail.com"
git -C "${source_dir}" config user.name "GengWei1997"
git -C "${source_dir}" add -A
git -C "${source_dir}" commit -m "build: apply validated Raphael patches and SM8150 DTB packaging"
patched_source_commit="$(git -C "${source_dir}" rev-parse HEAD)"

cd "${source_dir}"

# Reproduce the known-good GengWei 7.1 configuration path. Do not merge
# uboot-raphael.config or sm8150.config here: the released 7.1 kernel used
# kernel-deb/7.1/raphael.config directly.
install -m 0644 "${config_file}" arch/arm64/configs/raphael.config
make_args=(ARCH=arm64 LLVM=-22)
make -j"$(nproc)" "${make_args[@]}" defconfig raphael.config

# Sanity checks for the display/GPU configuration we specifically want to
# reproduce from the working 7.1 build.
grep -qx 'CONFIG_DRM_MSM=y' .config
grep -qx 'CONFIG_DRM_PANEL_SAMSUNG_AMS639RQ08=y' .config
grep -qx 'CONFIG_QCOM_LLCC=y' .config
grep -qx 'CONFIG_SM_GPUCC_8150=y' .config
grep -qx 'CONFIG_INTERCONNECT_QCOM_SM8150=y' .config

make -j"$(nproc)" "${make_args[@]}" deb-pkg

dtb="${source_dir}/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb"
test -s "${dtb}"
image_deb="$(find "${build_root}" -maxdepth 1 -type f \
    -name 'linux-image-*.deb' ! -name '*dbg*' -print -quit)"
headers_deb="$(find "${build_root}" -maxdepth 1 -type f \
    -name 'linux-headers-*.deb' -print -quit)"
test -n "${image_deb}"
test -s "${image_deb}"
test -n "${headers_deb}"
test -s "${headers_deb}"

# Verify the image package contains the Raphael DTB in the same /boot tree
# expected by the rootfs/boot-image build.
dpkg-deb -c "${image_deb}" | grep -q '/boot/dtbs/qcom/sm8150-xiaomi-raphael.dtb$'

mkdir -p "${artifact_dir}"
image_name="$(basename "${image_deb}")"
headers_name="$(basename "${headers_deb}")"
install -m 0644 "${image_deb}" "${artifact_dir}/${image_name}"
install -m 0644 "${headers_deb}" "${artifact_dir}/${headers_name}"
install -m 0644 "${dtb}" "${artifact_dir}/sm8150-xiaomi-raphael.dtb"
install -m 0644 .config "${artifact_dir}/kernel.config"
install -m 0644 "${patch_manifest}" "${artifact_dir}/patches.sha256"

kernel_release="$(make -s "${make_args[@]}" kernelrelease)"
clang_version="$(clang-22 --version | head -n1)"
printf 'kernel_release=%s\nsource_commit=%s\npatched_source_commit=%s\nsource_branch=%s\nbuild_commit=%s\nupstream_build_config_commit=%s\npatch_count=%s\nclang=%s\n' \
    "${kernel_release}" "${source_commit}" "${patched_source_commit}" \
    "${KERNEL_BRANCH}" "${build_commit}" "${upstream_build_config_commit}" \
    "${#patch_names[@]}" "${clang_version}" \
    > "${artifact_dir}/build-info.txt"

cd "${artifact_dir}"
sha256sum \
    "${image_name}" \
    "${headers_name}" \
    sm8150-xiaomi-raphael.dtb \
    kernel.config \
    build-info.txt \
    patches.sha256 \
    > SHA256SUMS
