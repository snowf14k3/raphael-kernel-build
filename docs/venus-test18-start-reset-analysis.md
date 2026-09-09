# Test18 SM8150 encoder START reset analysis

## Captured boundary

The authoritative evidence is the full `dmesg -w` stream captured over an
external Windows SSH session. Test18 (`7.1.0-sm8150-venus-test18+`) reached:

- HFI resume and H.264 encoder SESSION_INIT;
- INPUT REQBUFS count `actual=16 host-min=3`;
- OUTPUT REQBUFS count `actual=4 host-min=2`;
- the encoder property set, route 2, mode 2, max-quality and core selection;
- a final BUFFER_REQUIREMENTS response;
- internal types 0x6, 0x7, 0x8 and 0x4 SET_BUFFERS;
- LOAD_RESOURCES_DONE.

The final line was:

```text
[603.052916] ... command type=0x211002(START) ... cmd=36 msg=7 irq=11
```

There was no START_DONE, FTB, ETB, EBD, FBD, SMMU fault, NoC report, watchdog
message or kernel panic after it. Test18 therefore reset/hung while firmware was
processing START. It did **not** reach the first frame.

## Initial diagnosis corrected by Test20

Test18 moved BUFFER_COUNT_ACTUAL from STREAMON to REQBUFS and also suppressed
several property packets. The first analysis blamed the following count change.

The external OUTPUT count was committed early as:

```text
type=0x2 actual=4 host-min=2
```

After properties, route, mode and core selection, firmware reported:

```text
type=0x2 size=36864 actual=4 min=4 host=0 align=256
```

Test20 later proved that this was not an invalid wire request. Xiaomi also sends
OUTPUT actual 4/host-min 2, then preserves driver-owned external counts when a
later firmware table reports min 4. It does not send a second 4/4 count. The
original conclusion that this mismatch caused Test18 START failure was wrong.

Test20 reached START_DONE after restoring the fuller property set and fixing its
QP-range enable mask. The property suppression combination, rather than the
vendor-style 4/2 count, remains the supported explanation for Test18's START
regression.

## Original post-START problem still open

Correcting the Test18 regression alone would return to the Test17 boundary:
START_DONE, four FTBs, first ETB, then reset before EBD/FBD. The next build must
also address a difference that is first exercised by codec buffer traffic.

Xiaomi maps every Venus dma-buf with `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT`. Its DMA
layer translates that to `IOMMU_USE_UPSTREAM_HINT`, and the ARM LPAE mapper uses
MAIR value 0xf4. Linux 7.1 already defines the same 0xf4 value as
`ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE`, but has no DMA/IOMMU flag that selects it;
all current Venus allocations therefore use the ordinary non-cacheable MAIR
entry instead.

The next patch ports this mapping contract for IRIS1 encoder external and
internal buffers only. It deliberately leaves the already-working HFI queue and
decoder mappings unchanged. This is a source-supported candidate for the
Test17 post-ETB reset, not a hardware success claim.

Patch 0033 attached that attribute to mainline VB2 coherent MMAP allocations.
Test20 proved this still reset at the first ETB. The later ownership audit found
that this was not equivalent to Xiaomi: the vendor uses streaming dma-bufs and
explicit cache maintenance, while VB2 intentionally skips prepare/finish sync
for coherent allocations. Patch 0035 corrects that distinction.

## Deliberately excluded

- Do not set VIDC_CTRL_INIT bit 1 without also implementing Xiaomi's separate
  CDSP queue allocation and FastCVPD handoff. That half-port would be unsafe.
- Do not enable vendor non-fatal SMMU faults merely to suppress a reset; it would
  hide the invalid access rather than fix it.
- Do not alter DMA direction again. VB2 confirmed both encoder queues use
  DMA_BIDIRECTIONAL, and coherent MMAP allocation already creates read/write
  IOMMU permissions.
- Do not resend syscache on resume. Xiaomi retains `sys_cache_res_set` across
  ordinary power collapse.

## Next candidate acceptance

Before frame submission, logs must show count requests INPUT 16/host-min 3 and
OUTPUT 4/host-min 2, followed by the post-count table and START_DONE. Test21
external MMAP buffers must report `bidi=1 nc=1 up=1`.
Functional success still requires EBD, non-empty FBD, software-decodable H.264,
orderly STOP/RELEASE/END and runtime PM returning to suspended.

The resulting fix is patch 0033. Its fixed-baseline replay tree is
`ff4095f00d7995c4ac0adb5797663c4796c5982f`; see the 0033 hunk ledger for the
complete file/hunk disposition and validation record.
