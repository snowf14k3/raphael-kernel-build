# 0032 SM8150 encoder command-sequence hunk ledger

Patch: `patches/0032-media-venus-align-SM8150-encoder-command-sequence.patch`

SHA256: `17ef6c9008c0b34f956f361f337410d37c7a914c4758e6d46b1db2b5a53e6662`

Scope: 4 files, 36 hunks, +209/-156. The parent state is patches 0001--0031.
All rows below were compared against Xiaomi Android 10 SM8150 commit
`192eca8550f95c2eec58a474793d1d93fc1b3b67` and the captured Test17 boundary.

| # | File / area | Disposition and reason |
|---:|---|---|
| 1 | `helpers.c` work mode | Normal H.264/HEVC remains mode 2; VP8 and effective CBR low-latency use mode 1. This matches VPU5 plus its preceding internal-config step. |
| 2 | `helpers.c` input count | Removes dead IRIS1 encoder handling from the generic dual-queue helper; encoder now owns per-REQBUFS timing. Decoder behavior is unchanged. |
| 3 | `helpers.c` output count | Same separation for OUTPUT/OUTPUT2; preserves the already-fixed decoder split-output minimum. |
| 4 | `hfi_cmds.c` entropy | Writes `cabac_model` for CAVLC as well as CABAC. Xiaomi always initializes this 32-bit word. |
| 5 | `hfi_venus.c` decoder ETB | Zero-initializes the shared compressed ETB packet; wire fields filled by the packetizer are unchanged. |
| 6 | `hfi_venus.c` encoder ETB | Zero-initializes the VPU5 uncompressed ETB packet, including reserved/extension storage. |
| 7 | `hfi_venus.c` FTB | Zero-initializes the shared FTB packet before all documented fields are assigned. |
| 8 | `hfi_venus.c` SET_BUFFERS | Zeroes the variable packet array so unused slots/reserved words cannot contain stack data. |
| 9 | `hfi_venus.c` RELEASE_BUFFERS | Applies the same rule to the symmetric release packet. |
| 10 | `hfi_venus.c` SET_PROPERTY | Zeroes the packet backing every encoder property. This is the principal containment for short payload/reserved fields. |
| 11 | `venc.c` default GOP marker | Names the IRIS1 fresh-session default of 29 P frames, derived from standard GOP default 30 with zero B frames. |
| 12 | `venc.c` default detectors | Adds exact H.264/HEVC/VP8 tests for frame QP, QP ranges and profile/level defaults. They gate emission only; they do not change public control values. |
| 13 | `venc.c` base-layer priority | Sends the optional property only for a non-zero standard control, matching Xiaomi's control-triggered behavior. |
| 14 | `venc.c` local payloads | Zero-initializes encoder property structs before populating documented members. |
| 15 | `venc.c` VUI timing | Stops sending a disabled/default VUI timing packet on IRIS1. Xiaomi sends this only through its explicit control. |
| 16 | `venc.c` H.264 entropy | Leaves default CAVLC to the fresh session; non-default CABAC still emits the property. |
| 17 | `venc.c` H.264 deblock | Leaves disabled/zero offsets at default; any enabled mode or non-zero offset still emits. |
| 18 | `venc.c` H.264 8x8 | Leaves disabled transform at default; valid High-profile enable still emits. |
| 19 | `venc.c` IDR period | Removes the unconditional IRIS1 zero packet. The non-equivalent standard I-period control remains unadvertised on IRIS1. |
| 20 | `venc.c` HEVC HDR | Keeps automatic default HDR payload off the IRIS1 admission path. Explicit standard metadata needs a later dirty/lifetime mapping. |
| 21 | `venc.c` intra period | Sends only when GOP/B-frame values differ from the fresh-session default; Test17 `-g 1` still sends P=0/B=0. |
| 22 | `venc.c` rate control | Leaves RC_OFF at firmware default; active VBR/CBR/CQ still emits. RC timestamp disable is sent only with frame RC enabled. |
| 23 | `venc.c` default private properties | Removes unconditional bitrate-savings and Annex-B selection. Xiaomi's default controls rely on firmware defaults; no standard control is lost. |
| 24 | `venc.c` target bitrate | Suppresses meaningless target bitrate in RC_OFF; active rate control and hierarchical layers retain their bitrate packets. |
| 25 | `venc.c` sequence header | Leaves the default joined header untouched; explicit separate-header mode still emits the sync-header property. |
| 26 | `venc.c` frame QP | Removes the invented QP=127 sentinel. RC_OFF sends actual I/P/B QPs only when the standard values changed. |
| 27 | `venc.c` QP range | Leaves codec-default ranges untouched and retains packed per-frame ranges for non-default H.264/HEVC/VP8 controls. |
| 28 | `venc.c` profile/level | Leaves Baseline+automatic-level and HEVC Main defaults to firmware; non-default profile/tier/level remains mapped. |
| 29 | `venc.c` AUD | Leaves default disabled; an enabled standard AU-delimiter control still sends. |
| 30 | `venc.c` intra refresh | Leaves zero period disabled; valid CBR cyclic/random refresh still sends. |
| 31 | `venc.c` session init | Removes the speculative IRIS1 4/4 pair that Xiaomi does not send at SESSION_INIT. |
| 32 | `venc.c` per-queue count helper | Builds one HFI4 count packet with actual and firmware minimum, invalidates the requirements snapshot, and logs the committed type/count. |
| 33 | `venc.c` queue PM result | Keeps the runtime-PM reference until count programming finishes and preserves the first operation error over a later PM-put result. |
| 34 | `venc.c` queue setup lifetime | Removes the old early PM put, so the HFI GET/count transaction cannot race autosuspend. |
| 35 | `venc.c` queue count commit | Sends INPUT or OUTPUT count after VB2 finalizes that queue's number, under the instance lock, then releases PM. |
| 36 | `venc.c` STREAMON requirements | Performs one final requirements query after route/mode/core selection, removes the second count/query cycle, preserves output-minimum, and zeroes rotation frame-size payload. |

## Rejected changes recorded by the audit

- No resume-time HFI syscache resend: Xiaomi's `sys_cache_res_set` survives ordinary suspend, so
  `__set_subcaches()` is a no-op after LLCC reactivation.
- No third DMA-direction change: Test17 already proved both queues bidirectional.
- No static registration of encoder CAPTURE buffers: Xiaomi sends ordinary bitstream buffers by FTB.
- No host allocation for recon type 0x9: it is metadata/bookkeeping, not SET_BUFFERS DMA.
- No fabricated CDSP queue: the generic non-CVP V4L2 target uses the CPU queue fallback.
- No IOMMU fault suppression: it would hide an invalid access and Linux 7.1 has no equivalent vendor
  non-fatal domain attribute.

## Verification

- strict application against the staged 0001--0031 tree: PASS;
- `git diff --check`: PASS;
- `checkpatch.pl --strict`: 0 errors, 0 warnings, 0 checks;
- `scripts/test-iris1.py`: all numeric, packet, PM, lifecycle and source invariants PASS;
- `scripts/build.sh` and `scripts/venus-test-suite.sh`: `bash -n` PASS;
- suite `--self-test`: PASS;
- ARM64 kernel build and target hardware: pending.
