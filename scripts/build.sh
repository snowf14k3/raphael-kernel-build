#!/usr/bin/env bash
set -euo pipefail

build_root="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is not set}"
source_dir="${build_root}/linux-src"
artifact_dir="${build_root}/artifacts"
config_fragment="${build_root}/raphael.config"
patch_file="${build_root}/patches/0001-media-venus-fix-sm8150-runtime-data.patch"
patch_dir="${build_root}/patches"
patch_manifest="${build_root}/patches.sha256"
expected_source_commit="58f3df07833f2382fe2fbc28f996c4c85817c1f6"
build_commit="$(git -C "${build_root}" rev-parse HEAD)"
patch_sha256="$(sha256sum "${patch_file}" | cut -d ' ' -f 1)"

git clone --depth 1 --branch "${KERNEL_BRANCH}" \
	"${KERNEL_REPOSITORY}" "${source_dir}"

if [[ "$(git -C "${source_dir}" rev-parse HEAD)" != "${expected_source_commit}" ]]; then
	echo "Kernel branch moved: rebase and verify the Venus patch before building." >&2
	exit 1
fi

mapfile -t patch_names < "${patch_dir}/series"
[[ ${#patch_names[@]} -gt 0 ]]
for patch_name in "${patch_names[@]}"; do
	[[ "$patch_name" =~ ^[0-9]{4}-[A-Za-z0-9_-]+\.patch$ ]] || {
		echo "Invalid patch name in series: $patch_name" >&2
		exit 1
	}
	git -C "${source_dir}" apply --check "${patch_dir}/${patch_name}"
	git -C "${source_dir}" apply "${patch_dir}/${patch_name}"
done
(cd "${patch_dir}" && sha256sum -- "${patch_names[@]}") > "${patch_manifest}"
patch_series_sha256="$(sha256sum "${patch_manifest}" | cut -d ' ' -f 1)"
git -C "${source_dir}" diff --check
git -C "${source_dir}" diff --stat
python3 "${build_root}/scripts/test-iris1.py" "${source_dir}" --cc clang
bash -n "${build_root}/scripts/venus-test-suite.sh"
bash "${build_root}/scripts/venus-test-suite.sh" --self-test

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

scripts/config --set-str LOCALVERSION "-sm8150-venus-test10"
scripts/config --disable LOCALVERSION_AUTO
scripts/config --module VIDEO_QCOM_VENUS
scripts/config --enable SM_GCC_8150
scripts/config --enable SM_VIDEOCC_8150
scripts/config --enable INTERCONNECT_QCOM_SM8150
scripts/config --enable ARM_SMMU
# Keep optional diagnostics available without another full kernel build.
# Neither dynamic-debug callsites nor a function tracer are enabled at boot.
scripts/config --enable DEBUG_FS
scripts/config --enable DYNAMIC_DEBUG
scripts/config --enable FTRACE
scripts/config --enable FUNCTION_TRACER
scripts/config --enable DYNAMIC_FTRACE
scripts/config --set-str SYSTEM_TRUSTED_KEYS ""
scripts/config --set-str SYSTEM_REVOCATION_KEYS ""

make ARCH=arm64 LLVM=1 olddefconfig

for required in DEBUG_FS DYNAMIC_DEBUG FTRACE FUNCTION_TRACER DYNAMIC_FTRACE; do
	grep -qx "CONFIG_${required}=y" .config || {
		echo "Required diagnostic option CONFIG_${required} was not enabled." >&2
		exit 1
	}
done

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
install -m 0644 "${patch_manifest}" "${artifact_dir}/patches.sha256"
install -m 0644 "${build_root}/scripts/venus-test-suite.sh" "${artifact_dir}/venus-test-suite.sh"
install -m 0644 "${build_root}/docs/venus-test10.md" "${artifact_dir}/TESTING.md"

kernel_release="$(make -s ARCH=arm64 LLVM=1 kernelrelease)"
commit="$(git rev-parse HEAD)"

printf 'kernel_release=%s\nsource_commit=%s\nsource_branch=%s\n' \
	"${kernel_release}" "${commit}" "${KERNEL_BRANCH}" \
	> "${artifact_dir}/build-info.txt"
printf 'build_commit=%s\npatch_sha256=%s\n' \
	"${build_commit}" "${patch_sha256}" \
	>> "${artifact_dir}/build-info.txt"
printf 'patch_series_sha256=%s\npatch_count=%s\n' \
	"${patch_series_sha256}" "${#patch_names[@]}" \
	>> "${artifact_dir}/build-info.txt"

cd "${artifact_dir}"
sha256sum \
	linux-image-xiaomi-raphael-venus-test.deb \
	sm8150-xiaomi-raphael.dtb \
	kernel.config \
	build-info.txt \
	patches.sha256 \
	venus-test-suite.sh \
	TESTING.md \
	> SHA256SUMS
