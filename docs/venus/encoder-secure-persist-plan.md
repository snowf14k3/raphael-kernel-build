# SM8150 IRIS1 encoder secure-persist implementation and test gate

## Diagnosis

CF7 completed the post-count requirements snapshot, registered scratch 6/7/8
and encoder INTERNAL_PERSIST, received LOAD_RESOURCES_DONE with firmware error
zero, and reset before the first recorded HFI START packet. Its persist buffer
was a normal non-secure allocation at IOVA 0xdeff0000.

The fixed Android Q source requires encoder INTERNAL_PERSIST to be secure even
for a non-secure userspace session. It selects CP_NON_PIXEL, SM8150 V2 SID
0x2304, and IOVA range [0x01000000, 0x25800000). The CF7 IOVA is outside that
range. This is the strongest source mismatch that is encoder-only and aligns
with the observed resource-activation boundary.

No secure-world reset record was captured, so this remains a high-confidence
root cause rather than a completed hardware post-mortem.

## Implemented patch series

Patches 0034 through 0038 implement the missing path:

1. **0034 fail-closed guard**
   - Reject an IRIS1 encoder start with `-EOPNOTSUPP` before buffer
     registration or LOAD_RESOURCES when firmware requires
     INTERNAL_PERSIST but no secure device is attached.

2. **0035 Qualcomm ARM SMMU secure page tables**
   - Opt in only for a consumer with `qcom,secure-vmid`.
   - Accept only `QCOM_SCM_VMID_CP_NON_PIXEL`.
   - Track page-table allocations made by io-pgtable and round SCM
     ownership extents to full pages, including a small top-level table.
   - Share new page tables as HLOS read/write plus CP_NON_PIXEL read.
   - Return released page tables to HLOS after the IOTLB invalidation.
   - Poison and retain state when ownership rollback fails.
   - Serialize SCM transitions and avoid using a tracking object after a
     racing synchronization may free it.

3. **0036 DT binding**
   - Describe the secure non-pixel child, IOMMU stream, VMID, reserved IOVA
     region, and child DMA aperture.

4. **0037 SM8150 DT and Venus device lifecycle**
   - Add V2 SID 0x2304 beside non-secure SID 0x2300.
   - Constrain secure DMA to [0x01000000, 0x25800000).
   - Reserve [0, 0x01000000) from that domain.
   - Populate the auxiliary device and retain it only with an attached IOMMU
     domain. If an older DT lacks the child, keep decode available and let the
     0034 guard reject encoder start.

5. **0038 secure encoder-persist allocation**
   - Allocate through the secure child with
     `DMA_ATTR_FORCE_CONTIGUOUS | DMA_ATTR_NO_KERNEL_MAPPING`.
   - Verify every 4 KiB IOVA-to-PA step is one physically contiguous,
     page-aligned extent.
   - Verify every IOVA is inside the CP_NON_PIXEL aperture.
   - Transfer data ownership HLOS -> CP_NON_PIXEL read/write before
     HFI_SET_BUFFERS.
   - On teardown, issue HFI_UNSET_BUFFERS, transfer ownership back to HLOS,
     then unmap and free.
   - Retain the buffer when HFI unregister or SCM rollback fails.
   - Leave scratch and all other internal types on the existing non-secure
     Venus DMA path.

## Completed software gates

- All 38 patches replay independently from fixed source
  `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`.
- Replayed and staged trees both equal
  `3745d717722fc591fb49d39f8878431fab8b85e7`.
- Checkpatch reports zero errors and zero warnings for 0034–0038.
- The host contract test passes 535 assertions against the real staged HFI
  packetizer and extracted codec functions.
- The staged-source test passes 66 SMMU, page-granularity, DT,
  forced-contiguity, IOVA-to-PA, ordering, rollback, decoder-fallback, and
  evidence-marker assertions.
- ARM SMMU and Venus components compile with
  `ARCH=arm64 LLVM=-22 KCFLAGS=-Werror`.
- `dt-doc-validate`, the binding check, Raphael DTB compilation/decompilation,
  and `dtbs_check` pass for the new binding and board data.
- The full arm64 Debian image/headers build completed as
  `7.1.0-sm8150-gaa4f267dd65c`; reverse package inspection verified arm64
  metadata, matching vermagic, both packaged DTB copies, and all three secure
  runtime markers.

None of these gates proves that secure firmware accepts the mapping on the
phone.

## Persistent reset capture

The current phone mounts pstorefs but has no backend: ramoops has no memory,
platform device, or DT node. Do not borrow a fixed physical address from
another SM8150 board.

The fixed 7.1 source supports a named dynamic reservation. Add this to the
persistent kernel command line before an encoder test:

```text
reserve_mem=2M:4096:ramoops ramoops.mem_name=ramoops ramoops.record_size=262144 ramoops.console_size=262144 ramoops.pmsg_size=262144
```

Record the chosen address from `/proc/iomem` and boot messages because a
dynamic reservation is best effort and may move.

## First hardware gates

1. Install the complete kernel and matching Raphael DTB, retaining the current
   working kernel as the boot fallback.
2. Boot without opening `/dev/video0`. Verify the kernel release, SID 0x2304
   child, IOMMU attachment, SCM availability, and non-null pstore backend.
3. Reboot once without encoder activity and confirm the new kernel and pstore
   recover normally.
4. Run one controlled encoder start with no frame submission. Confirm that
   persist IOVA lies below 0x25800000, secure assignment succeeds, LOAD and
   START both return, and teardown returns ownership to HLOS.
5. Only after that gate, queue one frame. Preserve pstore and external logs
   immediately if the phone resets.

A module-only hot swap cannot validate this fix because SID 0x2304, the secure
DMA domain, and page-table ownership are established by the booted kernel and
DTB.

## Shortcuts that remain rejected

- Rewriting only the HFI address.
- Mapping CP_NON_PIXEL memory through SID 0x2300.
- Adding SID 0x2304 to the ordinary non-secure domain.
- Disabling the secure firewall.
- Sharing persist data with HLOS after transfer without a verified firmware
  contract.
- Re-running the CF7 module against the old kernel.
