#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Read-only first-boot gate for the SM8150 Venus secure-persist kernel.
# This script never opens a V4L2 device and never submits work to Venus.
set -Eeuo pipefail

EXPECTED_RELEASE="${1:-}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT_DIR="${OUT_DIR:-/var/tmp/venus-secure-first-boot.${STAMP}}"
LOG="${OUT_DIR}/gate.log"
mkdir -p -- "${OUT_DIR}"

hex_property() {
    od -An -v -tx1 "$1" | tr -d ' \n'
}

gate() {
    local backend node node_real dev dev_node group
    local vmid_hex iommus_hex dma_ranges_hex
    local failures=0

    fail() {
        printf 'FAIL: %s\n' "$*"
        failures=$((failures + 1))
    }

    printf 'VENUS_SECURE_FIRST_BOOT timestamp_utc=%s\n' "${STAMP}"
    printf 'boot_id='
    cat /proc/sys/kernel/random/boot_id
    uname -a
    printf 'kernel_release=%s\n' "$(uname -r)"
    printf 'cmdline='
    cat /proc/cmdline

    if [[ -n "${EXPECTED_RELEASE}" && "$(uname -r)" != "${EXPECTED_RELEASE}" ]]; then
        fail "kernel release does not match ${EXPECTED_RELEASE}"
    fi

    if ! grep -qw 'reserve_mem=.*:ramoops' /proc/cmdline; then
        fail 'ramoops reserve_mem parameter is absent'
    fi
    if ! grep -qw 'ramoops.mem_name=ramoops' /proc/cmdline; then
        fail 'ramoops.mem_name parameter is absent'
    fi

    backend="$(cat /sys/module/pstore/parameters/backend 2>/dev/null || true)"
    printf 'pstore_backend=%s\n' "${backend}"
    [[ "${backend}" == "ramoops" ]] || fail "pstore backend is ${backend:-missing}"

    printf '%s\n' '--- ramoops parameters ---'
    for f in /sys/module/ramoops/parameters/*; do
        [[ -f "${f}" ]] || continue
        printf '%s=' "${f##*/}"
        cat "${f}"
    done
    printf '%s\n' '--- ramoops iomem ---'
    grep -i ramoops /proc/iomem || fail 'no ramoops reservation in /proc/iomem'
    printf '%s\n' '--- pstore files ---'
    find /sys/fs/pstore /var/lib/systemd/pstore -maxdepth 1 -type f         -printf '%p %s bytes\n' 2>/dev/null | sort || true

    mapfile -t nodes < <(
        find /sys/firmware/devicetree/base -type d \
            -name secure-non-pixel -print 2>/dev/null
    )
    if (( ${#nodes[@]} != 1 )); then
        fail "expected one secure-non-pixel DT node, found ${#nodes[@]}"
    else
        node="${nodes[0]}"
        node_real="$(readlink -f "${node}")"
        printf 'secure_dt_node=%s\n' "${node_real}"

        vmid_hex="$(hex_property "${node}/qcom,secure-vmid")"
        iommus_hex="$(hex_property "${node}/iommus")"
        dma_ranges_hex="$(hex_property "${node}/../dma-ranges")"
        printf 'secure_vmid_hex=%s\n' "${vmid_hex}"
        printf 'secure_iommus_hex=%s\n' "${iommus_hex}"
        printf 'secure_dma_ranges_hex=%s\n' "${dma_ranges_hex}"

        [[ "${vmid_hex}" == "0000000b" ]] ||
            fail "secure VMID is not CP_NON_PIXEL (11)"
        [[ "${iommus_hex}" == *"0000230400000060" ]] ||
            fail "secure IOMMU tuple does not contain SID 0x2304 flags 0x60"
        [[ "${dma_ranges_hex}" == "000000000100000000000000010000000000000024800000" ]] ||
            fail "secure DMA aperture is not [0x01000000,0x25800000)"

        group=""
        for dev in /sys/bus/platform/devices/*; do
            [[ -L "${dev}/of_node" ]] || continue
            dev_node="$(readlink -f "${dev}/of_node")"
            [[ "${dev_node}" == "${node_real}" ]] || continue
            printf 'secure_platform_device=%s\n' "${dev}"
            group="$(readlink -f "${dev}/iommu_group" 2>/dev/null || true)"
            break
        done
        printf 'secure_iommu_group=%s\n' "${group}"
        [[ -n "${group}" ]] || fail 'secure platform device has no IOMMU group'
    fi

    printf '%s\n' '--- required kernel markers ---'
    if dmesg | grep -F 'QCOM_SMMU_SECURE_PGTABLE READY vmid=11'; then
        :
    else
        fail 'secure page-table READY marker is absent'
    fi

    printf '%s\n' '--- relevant boot messages ---'
    dmesg | grep -iE \
        'venus|qcom_smmu_secure|secure.page.table|ramoops|pstore|iommu' |
        tail -n 300 || true

    if (( failures )); then
        printf 'VENUS_SECURE_FIRST_BOOT result=FAIL failures=%u\n' "${failures}"
        return 1
    fi

    printf 'VENUS_SECURE_FIRST_BOOT result=PASS failures=0\n'
}

set +e
gate 2>&1 | tee "${LOG}"
rc=${PIPESTATUS[0]}
set -e
sha256sum "${LOG}" | tee "${OUT_DIR}/SHA256SUMS"
printf 'log_dir=%s\n' "${OUT_DIR}"
exit "${rc}"
