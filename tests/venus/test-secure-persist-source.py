#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
"""Static integration checks for the staged SM8150 secure-persist source."""

from pathlib import Path
import sys

root = Path(sys.argv[1] if len(sys.argv) > 1 else ".").resolve()
checks = 0


def check(value: bool, message: str) -> None:
    global checks
    checks += 1
    if not value:
        raise AssertionError(message)


def ordered(text: str, *needles: str) -> None:
    pos = -1
    for needle in needles:
        new_pos = text.find(needle, pos + 1)
        check(new_pos >= 0, f"missing: {needle}")
        check(new_pos > pos, f"out of order: {needle}")
        pos = new_pos


smmu = (root / "drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c").read_text()
smmu_core = (root / "drivers/iommu/arm/arm-smmu/arm-smmu.c").read_text()
smmu_header = (root / "drivers/iommu/arm/arm-smmu/arm-smmu.h").read_text()
venus_core = (root / "drivers/media/platform/qcom/venus/core.c").read_text()
venus_header = (root / "drivers/media/platform/qcom/venus/core.h").read_text()
helpers = (root / "drivers/media/platform/qcom/venus/helpers.c").read_text()
dts = (root / "arch/arm64/boot/dts/qcom/sm8150.dtsi").read_text()
binding = (
    root / "Documentation/devicetree/bindings/media/qcom,sm8150-venus.yaml"
).read_text()

check('"qcom,secure-vmid"' in smmu, "SMMU property lookup")
check("vmid != QCOM_SCM_VMID_CP_NON_PIXEL" in smmu, "VMID allowlist")
check("pgtbl_cfg->alloc = qcom_smmu_secure_pgtable_alloc;" in smmu,
      "secure page-table allocator")
check("size_t alloc_size = PAGE_ALIGN(size);" in smmu and
      "page->size = alloc_size;" in smmu,
      "SCM page-table extent is page aligned")
check("pgtbl_cfg->free = qcom_smmu_secure_pgtable_free;" in smmu,
      "secure page-table free")
check("QCOM_SCM_VMID_HLOS, QCOM_SCM_PERM_RW" in smmu,
      "HLOS page-table permission")
check("secure->vmid, QCOM_SCM_PERM_READ" in smmu,
      "CP page-table read permission")
check("BIT_ULL(QCOM_SCM_VMID_HLOS) | BIT_ULL(secure->vmid)" in smmu,
      "page-table rollback owners")
check("leaking secure page tables after ownership rollback failure" in smmu,
      "fail-safe page-table leak")
check("free_pages_exact(addr, alloc_size);" in smmu,
      "page-table free uses size captured under lock")
check("WARN_ON(!found || size > found->size)" not in smmu,
      "page-table free avoids unlocked object dereference")
check("QCOM_SMMU_SECURE_PGTABLE READY" in smmu,
      "secure page-table ready marker")
check("sync_pgtable" in smmu_header and "destroy_context" in smmu_header,
      "implementation lifecycle hooks")
ordered(
    smmu_core,
    "pgtbl_ops = alloc_io_pgtable_ops",
    "smmu->impl->sync_pgtable(smmu_domain)",
    "arm_smmu_init_context_bank",
)
check(smmu_core.count("smmu->impl->sync_pgtable") >= 4,
      "page-table sync call sites")
check("smmu->impl->destroy_context" in smmu_core, "domain destroy hook")

check("secure_nonpixel_dev" in venus_header, "Venus secure device field")
ordered(
    venus_core,
    "of_platform_populate",
    "venus_get_secure_nonpixel_device(core)",
    "venus_enumerate_codecs(core, VIDC_SESSION_TYPE_ENC)",
)
check("secure non-pixel context absent; IRIS1 encoder disabled" in venus_core,
      "decoder-preserving missing-context fallback")
check("iommu_get_domain_for_dev(&pdev->dev)" in venus_core,
      "secure device IOMMU attachment check")
check("venus_put_secure_nonpixel_device(core);" in venus_core,
      "secure device reference release")

check("iommus = <&apps_smmu 0x2304 0x60>;" in dts, "V2 secure SID")
check("qcom,secure-vmid = <QCOM_SCM_VMID_CP_NON_PIXEL>;" in dts,
      "DT secure VMID")
check("dma-ranges = <0 0x01000000 0 0x01000000" in dts,
      "secure IOVA DMA base")
check("0 0x24800000>;" in dts, "secure IOVA DMA size")
check("iommu-addresses = <&venus_secure_nonpixel 0 0 0 0x1000000>;" in dts,
      "low secure IOVA reservation")
check("secure-non-pixel:" in binding, "binding secure child")
check("const: 11" in binding, "binding CP_NON_PIXEL VMID")
check("secure-non-pixel" in binding.split("required:", 1)[1],
      "binding requires secure child")

check("VENUS_SECURE_PERSIST ASSIGN" in helpers,
      "secure persist assignment marker")
check("VENUS_SECURE_PERSIST RECLAIM" in helpers,
      "secure persist reclaim marker")
check("DMA_ATTR_FORCE_CONTIGUOUS" in helpers,
      "physical-contiguous DMA allocation")
check("DMA_ATTR_NO_KERNEL_MAPPING" in helpers,
      "no-kernel-map allocation hint")
check("domain = iommu_get_domain_for_dev(buf->dma_dev);" in helpers,
      "secure DMA domain lookup")
check("iommu_iova_to_phys(domain, buf->da + offset) != expected_pa" in helpers,
      "page-by-page physical contiguity gate")
check("dma_alloc_noncontiguous" not in helpers,
      "noncontiguous allocation is rejected")
check("buf->da < core->res->cp_nonpixel_start" in helpers,
      "secure IOVA lower bound")
check("buffer_end > range_end" in helpers, "secure IOVA upper bound")
ordered(
    helpers,
    "ret = intbuf_secure_assign(buf);",
    "ret = hfi_session_set_buffers(inst, &bd);",
    "buf->hfi_registered = true;",
)
ordered(
    helpers,
    "ret = hfi_session_unset_buffers(inst, &bd);",
    "ret = intbuf_free_memory(inst, buf);",
    "list_del_init(&buf->list);",
)
ordered(
    helpers,
    "ret = intbuf_secure_unassign(buf);",
    "dma_free_attrs",
)
check("!inst->core->secure_nonpixel_dev" in helpers, "fail-closed guard")
check("return -EOPNOTSUPP;" in helpers, "unsupported secure path error")

print(f"PASS: {checks} secure-persist staged-source assertions")
