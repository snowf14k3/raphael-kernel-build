#!/usr/bin/env bash
set -euo pipefail

build_root="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is not set}"
source_dir="${build_root}/linux-src"
artifact_dir="${build_root}/artifacts"
config_fragment="${build_root}/raphael.config"
patch_file="${build_root}/patches/0001-media-venus-fix-sm8150-runtime-data.patch"
build_commit="$(git -C "${build_root}" rev-parse HEAD)"
patch_sha256="$(sha256sum "${patch_file}" | cut -d ' ' -f 1)"

git clone --depth 1 --branch "${KERNEL_BRANCH}" \
	"${KERNEL_REPOSITORY}" "${source_dir}"

git -C "${source_dir}" apply --check "${patch_file}"
git -C "${source_dir}" apply "${patch_file}"
git -C "${source_dir}" diff --check
git -C "${source_dir}" diff --stat

curl --fail --location --silent --show-error \
	-o "${config_fragment}" \
	"https://raw.githubusercontent.com/GengWei1997/kernel-deb/b509d24efb86fea0842f940138be8bf2301626ff/uboot-raphael.config"

cd "${source_dir}"

make ARCH=arm64 LLVM=1 defconfig

# Keep GengWei's Debian feature set, then let the configuration shipped with
# this kernel branch override options that became incompatible with Linux 7.1.
scripts/kconfig/merge_config.sh -m .config \
	"${config_fragment}" \
	arch/arm64/configs/sm8150.config

scripts/config --set-str LOCALVERSION "-sm8150-venus-test3"
scripts/config --disable LOCALVERSION_AUTO
scripts/config --module VIDEO_QCOM_VENUS
scripts/config --enable SM_GCC_8150
scripts/config --enable SM_VIDEOCC_8150
scripts/config --enable INTERCONNECT_QCOM_SM8150
scripts/config --enable ARM_SMMU
scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
scripts/config --set-str SYSTEM_REVOCATION_KEYS ""

make ARCH=arm64 LLVM=1 olddefconfig

grep -E \
	'CONFIG_VIDEO_QCOM_VENUS|CONFIG_SM_GCC_8150|CONFIG_SM_VIDEOCC_8150|CONFIG_INTERCONNECT_QCOM_SM8150|CONFIG_ARM_SMMU' \
	.config

make -j"$(nproc)" ARCH=arm64 LLVM=1 bindeb-pkg

dtb="${source_dir}/arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dtb"
test -s "${dtb}"

strings "${dtb}" | grep -Fq 'qcom,sm8150-venus'
strings "${dtb}" | grep -Fq 'qcom/sm8150/Xiaomi/raphael/venus.mbn'

image_deb="$(find "${build_root}" -maxdepth 1 -type f \
	-name 'linux-image-*.deb' ! -name '*dbg*' -print -quit)"
test -n "${image_deb}"
test -s "${image_deb}"

mkdir -p "${artifact_dir}"
install -m 0644 "${image_deb}" \
	"${artifact_dir}/linux-image-xiaomi-raphael-venus-test.deb"
install -m 0644 "${dtb}" \
	"${artifact_dir}/sm8150-xiaomi-raphael.dtb"
install -m 0644 .config "${artifact_dir}/kernel.config"

kernel_release="$(make -s ARCH=arm64 LLVM=1 kernelrelease)"
commit="$(git rev-parse HEAD)"

printf 'kernel_release=%s\nsource_commit=%s\nsource_branch=%s\n' \
	"${kernel_release}" "${commit}" "${KERNEL_BRANCH}" \
	> "${artifact_dir}/build-info.txt"
printf 'build_commit=%s\npatch_sha256=%s\n' \
	"${build_commit}" "${patch_sha256}" \
	>> "${artifact_dir}/build-info.txt"

cd "${artifact_dir}"
sha256sum \
	linux-image-xiaomi-raphael-venus-test.deb \
	sm8150-xiaomi-raphael.dtb \
	kernel.config \
	build-info.txt \
	> SHA256SUMS
