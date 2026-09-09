# SM8150 Venus encoder full-path audit after Test17

Status: **SOURCE AUDIT COMPLETE — Test18 bundle prepared, hardware result pending**

This is the authoritative audit for the Test17 encoder hard reset.  It supersedes
any earlier statement that a single DMA-direction change completed the encoder
port. Every source group below now has an `ALIGNED`, `INTENTIONAL`, `CORRECTED`
or explicitly deferred disposition. This closes the source-comparison phase; it
does not claim that encoder hardware works until a Test18 EBD/FBD is observed.

## Test17 observed boundary

The one-frame H.264 run reached all of the following successfully:

- encoder V4L2 node open and both vb2 queues configured bidirectional;
- HFI `SESSION_INIT` for encoder/H.264;
- encoder property programming and final buffer-requirement query;
- internal buffers 0x6, 0x7, 0x8 and 0x4 allocated and registered;
- `LOAD_RESOURCES_DONE` and `START_DONE`;
- four output bitstream buffers submitted with FTB;
- one 128x96 NV12 input submitted with ETB.

The machine reset immediately after the first ETB.  There was no EBD, FBD,
session-error event, HFI timeout, or orderly cleanup in the captured log.  Test16
failed at the same boundary with capture DMA unidirectional, while Test17 failed
with both queues bidirectional.  Therefore DMA direction alone is disproved as
the root cause.

## Audit rule

For every row, compare all four things rather than matching names only:

1. Xiaomi SM8150 Android 10 implementation and DTS;
2. the current Test17 implementation and DTS;
3. the exact HFI 4xx packet bytes/order and runtime value;
4. lifetime/order relative to buffer query, LOAD, START, FTB and ETB.

Finding one mismatch does not end the audit.

## Confirmed aligned behavior

| Area | Result | Evidence / qualification |
|---|---|---|
| HFI SET_BUFFERS packet sizing | ALIGNED | Flexible-array sizing is equivalent for output and non-output buffer forms. |
| HFI encoder ETB/FTB field order | ALIGNED | Command size, session id, timestamp, flags, alloc/filled/offset and device address order match the vendor HFI4 layout. |
| IOVA bias | ALIGNED | Vendor applies firmware bias only without an IOMMU; this device uses an IOMMU. |
| Internal-buffer count 0x8 | ALIGNED | Vendor allocates `count_actual` (1 here), not `count_min_host` (2). |
| Reconstruction bookkeeping 0x9 | ALIGNED | Vendor creates host records only; it does not DMA-allocate or SET_BUFFERS this type. |
| Internal buffer allocation size | ALIGNED | Both round to page size and pass the allocated size/address to firmware. |
| Encoder session-continue step | ALIGNED | Vendor continuation is decoder-only; omission for encoder is expected. |
| Linear NV12 plane constraints | ALIGNED | Neither path sends UBWC plane constraints for the tested linear NV12 input. |
| Frame-rate buffer selector | ALIGNED | Both program frame rate against HFI output/input-to-codec semantics used by the encoder API. |
| First-frame buffer counts | ALIGNED VALUES | Test17 final values are input actual 16/min 3 and output actual/min 4, matching firmware requirements and queued buffers. Timing is still audited separately. |
| FTB-before-ETB submission | PROVISIONALLY ALIGNED | Vendor queues already-registered buffers after START; normal userspace capture-first ordering produces the same observable order. |
| Encoder CAPTURE static registration | ALIGNED WIRE BEHAVIOR | Xiaomi labels encoder CAPTURE `HAL_BUFFER_MODE_STATIC`, but its complete call graph does **not** issue SESSION_SET_BUFFERS for userspace bitstream buffers. Those buffers go directly through FTB, as in Test17. SESSION_SET_BUFFERS is used for internal buffers and driver-owned decoder output buffers. Do not add external encoder registration based only on the local mode label. |
| Tested H.264 VBR work mode | ALIGNED | Vendor selects mode 2 for normal H.264 encoder sessions; Test17 selected mode 2. Current non-VBR selection remains a compatibility difference below. |
| Linear NV12 allocation contract | ALIGNED | Both use the vendor `VENUS_BUFFER_SIZE`: 128x96 allocates 24576 bytes (including UV safety padding/page alignment) while the active image payload is 18432 bytes. |
| Linear NV12 plane constraints | ALIGNED | The vendor constraint table contains P010 and NV12-512, not ordinary NV12; Test17 correctly sends no constraint packet for NV12. |
| SM8150 system UBWC override | ALIGNED | Xiaomi `sm8150_data` sets `ubwc_config = 0`; both implementations omit the optional SYS_UBWC_CONFIG packet. |
| SM8150 register presets | ALIGNED | Xiaomi SM8150 DTS has no `qcom,reg-presets`; the empty current SM8150 preset table is not an omission. |
| Active MMIO offsets | ALIGNED WITH SMALLER WINDOW | Current IRIS1 accesses remain below 0x100000, so its 1 MiB mapping covers the active offsets even though Xiaomi reserves 2 MiB. Keep the larger-window difference documented for future features. |
| SM8150 v2 clock table | ALIGNED | Raphael uses the v2 silicon table. Xiaomi v2 overrides both VideoCC and allowed rates to 240/338/365/444/533 MHz; Test17's 533 MHz first-frame turbo is valid, not an overclock. |
| Threshold-restore workaround | NOT APPLICABLE TO SM8150 | Xiaomi calls a helper on resume, but that helper performs SCM state 2 only for wrapper HW 3.43 (the documented older-HW workaround). It is not evidence for a SM8150 encoder fix. |
| DSP queue table | INTENTIONAL EXCLUSION | Xiaomi allocates a second queue table from CDSP memory because `domain_cvp=1`. The generic V4L2 port does not expose CVP/TME and programs the documented CPU queue fallback into the VPU5 DSP registers. Decoder boot and traffic prove that fallback is valid; fabricating a CDSP mapping from the Venus DMA domain would be incorrect. |
| Runtime syscache handling | ALIGNED | Xiaomi reactivates LLCC slices on resume, but `sys_cache_res_set` remains true across ordinary suspend, so `__set_subcaches()` returns without another HFI resource packet. Current code likewise activates slices in PM and sends the HFI syscache resource once after SYS_INIT. A proposed resume-time resend was rejected during this audit. |
| DMA cache maintenance | ALIGNED SEMANTICS | Xiaomi maps all video dma-bufs bidirectionally and performs explicit clean/invalidate ranges. VB2 dma-contig with `bidirectional=1` supplies the corresponding DMA API synchronization. Test17 proved both queues had that policy; direction alone is not the reset cause. |

## High-risk differences still open

| Area | Xiaomi Android 10 | Test17 | Risk / work remaining |
|---|---|---|---|
| Interconnect topology | Separate CPU-config, Venus-DDR, ARM9-DDR and Venus-LLCC bus clients/votes | one composite `video-mem` ICC path plus `cpu-cfg` | HIGH. Prove whether the Linux ICC graph propagates the required LLCC and DDR votes and whether the firmware/ARM9 path is omitted. |
| Device register range | 0x200000 | 0x100000 | LOW for the present path: all active IRIS1 offsets are below 1 MiB. Preserve as a future-extension difference, not a Test17 root-cause claim. |
| Encoder level default | vendor H.264 level UNKNOWN/auto | current default is H.264 level 5.1 | MEDIUM. Compare the exact packet sent by the tested FFmpeg invocation and vendor default-control sequence. |
| Property programming time/order | vendor control callbacks program properties throughout session setup | current code batches many properties in encoder start | HIGH until the complete ordered packet transcript is matched. |
| Buffer-count property timing | vendor programs one count for the queue currently executing REQBUFS, invalidates requirements, then queries the final table once at STREAMON | Test17 sent speculative 4/4 at SESSION_INIT and later sent 16/4 together at STREAMON, with two requirements queries | CORRECTED for Test18: per-queue count at queue setup, no speculative pair, cache invalidated after each count, one final query. |
| IOMMU SID/domain topology | vendor v2 uses non-secure SID 0x2300 with downstream vendor mapping policy | current DTS lists 0x2300, 0x2301, 0x2303 and 0x2304 | HIGH. Map every SID to firmware/client use and compare domain attributes/aperture. |
| LLCC/system-cache setup | VIDSC0/VIDSC1 are activated on power-up; one HFI resource description is retained across ordinary power collapse | same slice IDs/sizes and one post-SYS_INIT resource packet | ALIGNED for non-CVP video. Resume-time resend is specifically forbidden by the verified vendor state machine. |
| Encoder work mode for non-VBR | VPU5 uses mode 2 for normal H.264/HEVC; VP8 and the CBR path that internal config makes low-latency use mode 1 | old code treated RC_OFF as mode 1 | CORRECTED. Test17 VBR was already mode 2, so this is compatibility rather than its direct reset cause. |
| Default/property emission model | vendor sends most optional properties only when their V4L2/private control is applied; start adds rotation, conditional internal config, route, mode and core selection | Test17 replayed disabled/default VUI, entropy, deblock, 8x8, IDR, QP, profile, AUD, header and base-layer packets | CORRECTED for Test18 with a default-value allowlist. Non-default standard controls remain functional; unsupported Android-only controls remain excluded. |
| Upstream-cache mapping hint | vendor adds `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT` when syscache exists | Linux 7.1 DMA API has no equivalent attribute; Qualcomm SMMU TCR2 still selects upstream SEP | DEFERRED PERFORMANCE DIFFERENCE. It changes cache routing, not IOVA validity or read/write permission, and cannot explain the captured valid-address reset by itself. |
| Non-secure IOVA lower bound | vendor non-secure pool is exactly 0x25800000..0xdfffffff | current DMA mask enforces only the upper bound | HIGH for long-term safety. Test17's captured external/internal IOVAs were all near 0xdfxxxxxx and therefore valid, so this does not by itself explain that reset. Reserve 0..0x257fffff through the IOMMU reserved-region mechanism. |

## Tested H.264 property ledger

This table distinguishes packet correctness from whether a packet should have
been emitted at all.  Test17 used FFmpeg with 128x96 NV12, 30 fps, one frame,
GOP 1 and 512 kbit/s.

| Wire property | Test17 value | Xiaomi behavior | Test18 disposition |
|---|---:|---|---|
| VPE rotation/flip | none/none | always set at stream start | ALIGNED |
| FRAME_RATE | 30 << 16, encoder input buffer semantic | sent when frame-rate/s_parm is configured | Packet/value aligned; current emission is unconditional. |
| H264 VUI timing | disabled | only when its control is set | Default packet suppressed. |
| H264 entropy | CAVLC; intended model 0 but packet word was uninitialized | only when its control is set; model word always initialized | Default packet suppressed; packetizer fixed for non-default CABAC/CAVLC callers. |
| H264 deblock | disabled, offsets 0/0 | only when its control is set | Default suppressed; non-default retained. |
| H264 8x8 transform | disabled for Baseline | only when its control is set | Default suppressed; valid High-profile enable retained. |
| IDR period | 0 | only when private IDR-period control is set | Unconditional packet removed. |
| INTRA_PERIOD | P=0, B=0 for GOP 1 | sent when the P/B-frame control cluster is set | Still sent because Test17 explicitly requested GOP 1. |
| RATE_CONTROL | VBR_CFR for the tested FFmpeg run | standard VBR maps to the same HFI value | ALIGNED for Test17. |
| DISABLE_RC_TIMESTAMP | 1 | FRAME_RC_ENABLE maps directly to the same enable payload | Retained only when frame RC is enabled. |
| NAL stream format | Annex-B/start codes | vendor default is start codes; packet only on control set | Unconditional packet removed; firmware default retained. |
| TARGET_BITRATE | 512000, layer 0xff/all | same target-bitrate payload and all-layer id | ALIGNED for Test17. |
| Joined sequence header | enabled | vendor default joined; packet only on control set | Default suppressed; explicit separate mode retained. |
| QP range v2 | I/P/B min 1, max 51, layer all | packet only when extended QP-range controls are set | Default suppressed; non-default packed ranges retained and packet storage zeroed. |
| PROFILE_LEVEL | Baseline, level 0/automatic on wire | vendor default Baseline + UNKNOWN/0 | Default suppressed; non-default profile/level retained. |
| AUD NAL | disabled | only when control is set | Default suppressed; enabled control retained. |
| BASELAYER_PRIORITYID | 0 | only when its control is set | Default suppressed; non-zero control retained. |
| WORK_ROUTE | 2 | normal H.264 VBR selects 2 | ALIGNED |
| WORK_MODE | 2 | normal H.264 encoder selects 2 | ALIGNED for Test17 |
| VENC_PERF_MODE | max quality | vendor core selection explicitly sets max quality for this load | ALIGNED |
| VIDEOCORES_USAGE | core 1/MVS0 | SM8150 exposes one video codec core; same mask | ALIGNED |
| BUFFER_COUNT_ACTUAL | speculative 4/4, then input 16/min-host 3 and output 4/min-host 4 | each queue setup passes its firmware min and userspace actual | Speculative pair removed; final values now committed per REQBUFS. |
| BUFFER_SIZE_MINIMUM | output bitstream 36864 | same wire id and firmware-sized capture buffer | ALIGNED |

The property path has both an emission-model defect and one concrete malformed
field. Test18 uses a minimal/default-aware allowlist: a default control is left to
the fresh firmware session, while a non-default standard control is still sent.
This avoids inventing Android private control IDs and avoids disabling supported
standard V4L2 controls.

One concrete malformed-field exception was found: in the Test17 generic
packetizer, CAVLC copies `entropy_mode` but leaves the destination
`cabac_model` word untouched in an uninitialized stack packet. Xiaomi always
writes `HFI_H264_CABAC_MODEL_0` for that word. Test18 corrects it together with
zero-initialization of packet storage and the unsolicited-property fix.

## Full-path checklist and disposition

- [x] V4L2 controls: all current controls and all Xiaomi control cases reviewed. Standard equivalents
  are retained; private ROI/HDR10+/secure/CVP/TME metadata is deliberately not copied.
- [x] Format negotiation: H.264+linear NV12 is aligned for dimensions, stride, scanlines, sizeimage
  and payload. NV21/P010/UBWC remain capability-gated and require later hardware tests.
- [x] REQBUFS: Test18 uses Xiaomi's per-queue actual/min timing and one final requirements query.
- [x] HFI properties: every property emitted by the Test17 H.264 command was checked for ID, size,
  value and order. Unsolicited defaults are suppressed; non-default standard controls remain mapped.
- [x] HFI packetization: SESSION_INIT, GET/SET_PROPERTY, SET/RELEASE_BUFFERS, LOAD/START,
  FTB/ETB, STOP/RELEASE/END and abort/error layouts were compared. Encoder-adjacent packet storage
  is zero-initialized in Test18.
- [x] Internal buffers: types 0x6/0x7/0x8/0x4, conditional 0x5 and host-only recon 0x9 have explicit
  count, alignment, address, ownership and cleanup dispositions.
- [x] Client ETB/FTB: alloc/filled/offset/tag/timestamp/flags and FTB-before-ETB order align; both
  mappings are bidirectional. Test18 does not change direction again.
- [x] IOMMU: v2 SIDs match Xiaomi; captured Test17 IOVAs fit the non-secure vendor aperture. Missing
  low-aperture reservation and non-fatal fault policy are documented framework gaps, not silently fixed.
- [x] LLCC: acquisition, activation, SCID/size packet, suspend deactivation and resume reactivation
  reviewed. No duplicate HFI resource packet is added.
- [x] Clocks/OPPs/regulators/power domains: v2 rate table, MVSC/MVS0/CVP order, hwmode handoff and
  rollback reviewed; preflight masks proved present before Test17 LOAD/START.
- [x] Interconnect votes: CNOC and end-to-end video-memory paths plus first-16-frame turbo reviewed.
  Separate Android bus clients are represented by Linux ICC; long-load values await hardware.
- [x] IRIS1 registers: active offsets, CPU/DSP queue fallback, reset, interrupt, idle and barriers
  reviewed. The mainline 1 MiB resource cannot expand because it would overlap VideoCC.
- [x] Runtime PM: power stays pinned from pre-LOAD through STREAMOFF; decoder returns to suspended.
  Encoder post-EBD and error unwind still require hardware evidence.
- [x] Stop/abort/close: all partial-start unwind ordering reviewed; actual post-frame STOP/END cannot be
  declared passed before firmware returns EBD/FBD.
- [x] Codec matrix: source support is recorded, but H.264 is the only encoder allowed into first-frame
  admission. HEVC and VP8 follow after H.264 short/long lifecycle tests.
- [x] Decoder regressions: Test18 changes are encoder-specific except zeroing shared HFI packet storage;
  H.264 and HEVC Main8 decode remain mandatory prechecks.

## Test18 bundled corrections

Test18 is intentionally one bundle, not another one-line experiment:

1. Always initialize the H.264 entropy `cabac_model` word, including CAVLC, matching Xiaomi.
2. Zero all encoder-adjacent HFI property, buffer-registration, ETB and FTB packet storage.
3. Zero local encoder property payload structs so reserved words cannot inherit stack data.
4. Stop replaying optional default properties that Xiaomi sends only when a control is applied.
5. Keep non-default standard V4L2 control values mapped, including entropy, deblock, 8x8, GOP,
   RC, bitrate, QP/range, profile/level, AUD, LTR, slice and base-layer priority.
6. Restore VPU5 work-mode policy for normal H.264/HEVC, VP8 and CBR low-latency sessions.
7. Remove speculative SESSION_INIT 4/4 counts.
8. Commit one buffer-count property per REQBUFS queue, use firmware `count_min` as host-min,
   invalidate the requirements snapshot, and query the final table exactly once at STREAMON.
9. Preserve the proven bidirectional mappings, internal buffer sequence, FTB-before-ETB order,
   power pin, OPP/ICC turbo and fail-closed encoder gate.

The strongest direct Test17 root-cause candidate is malformed/unsolicited property state consumed only
when the first input frame arrives. The count-order mismatch is the second candidate because it changes
the final internal requirements state. DMA direction, work route/mode, raw allocation size, internal
SET_BUFFERS order and FTB order are excluded by Test17 evidence and are not changed again.

## Explicitly deferred differences

These are recorded so they are not rediscovered and misrepresented in another cycle:

- Linux 7.1 has no equivalent of Xiaomi's per-mapping `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT`;
- the Linux default domain does not enforce Xiaomi's 0x25800000 lower IOVA bound, although every
  Test17 address was inside it;
- Xiaomi's non-fatal page-fault domain attribute has no upstream equivalent; a fault suppressor would
  hide a bad access rather than correct it;
- separate CDSP queues, secure context banks, TME, HEIC and CVP are Android-private paths and not
  prerequisites for ordinary non-secure H.264 encoding;
- HDR10 encoder metadata needs an explicit standard-control dirty/lifetime design before enabling it on
  IRIS1; it is not part of the 8-bit H.264 admission test;
- the single Linux ICC path is conservative and needs performance measurements after correctness, not
  more changes before the first EBD.

## Release gate for the next kernel

The next kernel must bundle all nine corrections above. Its test plan must first prove H.264/HEVC
Main8 decode and idle PM, then open the encoder with the global gate still off, then enable it for exactly
one 128x96 H.264 frame while a remote kernel log is already running. Required success evidence is not
FFmpeg's exit code alone: at least one matching EBD, one non-empty FBD, a software-decodable Annex-B
output, orderly STOP/RELEASE/END, and parent/child runtime PM returning to `suspended`. A reset remains
a failed Test18, not permission to claim stability.
