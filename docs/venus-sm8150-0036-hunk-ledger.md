# 0036 non-contiguous DMA attribute hunk ledger

Patch: `patches/0036-dma-allow-upstream-hint-for-noncontiguous-allocations.patch`

SHA256: `c301c8ae079db279d9c360cc922068a2975a6b6864ca1a003de9611cb34aa3c9`

Scope: one source file and one hunk. Parent state is patches 0001--0035.

| File / area | Change | Reason |
|---|---|---|
| `kernel/dma/mapping.c`, `dma_alloc_noncontiguous()` | Allows `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT` alongside `DMA_ATTR_ALLOC_SINGLE_PAGES` | Test21 proved the public wrapper rejected the attribute before iommu-dma could consume it. |

The downstream mapping semantics, IOMMU flag, MAIR 0xf4 selection, VB2
ownership synchronization and pre-hardware guard remain in patches 0033/0035.
No hardware command was reached in Test21.

Validation:

- apply check: pass against staged patches 0001--0035
- checkpatch strict: 0 errors, 0 warnings, 0 checks across 9 checked lines
- host/source tests: all IRIS1 and script tests pass, including public DMA allowlist assertion
- replay tree: `6b1605c9fce99ee6550c6f9b44aba66335d88a07`
