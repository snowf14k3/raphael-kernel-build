# Test21 DMA allocation failure

Test21 did not reach encoder properties, LOAD, START or any buffer command.
The persistent log ended its functional path at:

```text
WARNING: kernel/dma/mapping.c:805 at dma_alloc_noncontiguous
qcom-venus ... dma alloc of size 24576 failed
```

The public DMA wrapper allowed only `DMA_ATTR_ALLOC_SINGLE_PAGES`. Patch 0035
correctly selected VB2's streaming/non-contiguous allocation and supplied
`DMA_ATTR_IOMMU_USE_UPSTREAM_HINT`, but the wrapper rejected that new attribute
before calling `iommu_dma_alloc_noncontiguous()`.

This was a safe failure: FFmpeg reported `encode-h264-one FAIL`, remaining
tests were skipped, and the device did not reset. Test21 therefore provides no
new hardware result for the Test20 first-ETB boundary.

Patch 0036 extends only this allocator's allowlist with the upstream hint. The
IOMMU implementation already consumes it and unsupported attributes remain
rejected. The audit capture now includes `kernel/dma/mapping.c`, the DMA include
layer and a dedicated pass 16 so this wrapper cannot disappear from later
context.
