# 0031 hunk ledger: SM8150 encoder CAPTURE DMA direction

## Failure boundary from Test16

The persistent Test16 log reaches all of these checkpoints successfully:

- encoder `SESSION_INIT`, final buffer requirements, and property setup;
- internal buffer types `0x6`, `0x7`, `0x8`, and `0x4` registered;
- `LOAD_RESOURCES_DONE` and `START_DONE`;
- four compressed CAPTURE FTBs queued;
- the first raw NV12 ETB queued.

The final two records before the hard reset are:

```text
queue ETB tag=0 dma=0xdfbf0000 alloc=24576 filled=18432 offset=0 bidirectional=1
queued ETB tag=0 ret=0
```

There is no EBD, FBD, HFI error, kernel panic, or orderly timeout.  The reset is
therefore after firmware begins consuming the first frame, not in session
configuration or command packet construction.

The same log exposes the remaining DMA asymmetry.  Every compressed FTB says
`bidirectional=0`; only the raw source queue says `bidirectional=1`.

## Vendor comparison

Xiaomi's SM8150 tree maps every video dma-buf attachment with
`DMA_BIDIRECTIONAL` in `drivers/media/platform/msm/vidc/msm_smem.c` and unmaps
it with the same direction.  It does not limit that rule to encoder input.

VB2's own `bidirectional` queue documentation states why this matters: firmware
may read a buffer normally classified as `DMA_FROM_DEVICE`, and a one-way IOMMU
mapping can then generate a protection fault.  Encoder CAPTURE is normally
classified as device-write-only, so Test16 did not match the downstream
contract.

## Hunk 001: `venc.c:m2m_queue_init`

For IRIS1 only, set `dst_vq->bidirectional = 1` before `vb2_queue_init()` and
log the effective value.  This makes both encoder queues match the downstream
mapping and cache-maintenance direction.  Other Venus generations are
unchanged.

## Explicitly eliminated during this review

- `type=0x8 count_min_host=2` is not an allocation count.  Xiaomi allocates
  scratch/persist memory using `buffer_count_actual`, exactly as the current
  helper does; Test16's one `type=0x8` allocation is correct.
- `type=0x9` is encoder reconstruction bookkeeping in Xiaomi's driver.  The
  vendor path creates index records but does not allocate and SET_BUFFER a
  type-9 DMA block.  Its absence from the current internal DMA list is correct.
- MVS1/CVP is not missing: the IRIS1 runtime resume path already resumes all
  three Venus/MVS0/MVS1 domains and enables both vcodec clock groups.
- The HFI4 encoder ETB structure, timestamp conversion, alloc length, filled
  length, offset, tag, and packet address match Xiaomi's packetizer.
- Test16's 24,576-byte 128x96 NV12 allocation and 18,432-byte payload match the
  downstream allocation formula and V4L2 payload semantics.

## Acceptance boundary

This patch removes a concrete IOMMU-permission mismatch.  It must not be called
proven until the next kernel produces an EBD/FBD, a non-empty H.264 stream,
clean STREAMOFF, and runtime suspend.  Until then the encoder gate remains off
by default and no further Test16 encoder run is useful.

## Host verification

- patch SHA256: `d92f33c61d8c768cc1ab3e9ea8a1cb0ab65d8a7c10342065f7419d246d252314`;
- 0001--0031 applied in order to an alternate index created from fixed base
  `58f3df07833f2382fe2fbc28f996c4c85817c1f6`;
- resulting tree: `efba4a44ab74adc132948507294d450e6f303a20`;
- `git diff --check`: pass;
- all IRIS1 source invariants and compiled C harnesses: pass, including an
  explicit assertion that both encoder queues are bidirectional on IRIS1.
