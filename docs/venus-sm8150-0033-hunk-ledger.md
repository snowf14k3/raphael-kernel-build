# 0033 SM8150 final-count and upstream-cache hunk ledger

Patch:
`patches/0033-media-venus-fix-SM8150-final-counts-and-cache-mappings.patch`

SHA256: `bff22f4f803aad9b664cdf062f25881bea7e2be56238586d15440d7ad5713af8`

Scope: 8 files, 33 hunks, 148 insertions and 152 deletions. Parent state is patches
0001--0032. The large `venc.c` deletion count is mostly a deliberate rollback
of Test18 property suppression and premature REQBUFS count submission.

| # | File / area | Disposition and reason |
|---:|---|---|
| 1 | `dma-attributes.rst` | Documents the imported upstream-interconnect cacheability contract. |
| 2 | `dma-mapping.h` | Adds the exact downstream-named `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT` on the first free mainline bit. |
| 3 | `iommu.h` | Adds `IOMMU_USE_UPSTREAM_HINT`; bit 6 is unused in the Linux 7.1 parent. |
| 4 | `dma-iommu.c` | Translates the DMA attribute into the IOMMU mapping protection flag. |
| 5 | `io-pgtable-arm.c` | Selects the already-defined index 3 MAIR value 0xf4 for stage-1 non-coherent mappings, matching Xiaomi's upstream attribute. |
| 6 | DMA trace formatting | Makes the new mapping attribute observable in standard DMA trace events. |
| 7 | encoder VB2 MMAP queues | Adds the attribute to both IRIS1 source and capture queues; preserves the proven bidirectional directions. |
| 8 | encoder internal buffers | Adds the same attribute to IRIS1 encoder scratch/persistent/recon allocations and logs the active state. |
| 9 | HFI and decoder exclusion | Does not change HFI ring or decoder allocations, protecting the already-working boot/H.264/Main8 paths. |
| 10 | `venc_queue_setup()` | Removes Test18 per-REQBUFS count commands because mainline controls are not final at that point. |
| 11 | `venc_start_streaming()` | Queries the post-control table, commits INPUT and OUTPUT with their final minima, invalidates and refreshes the table before internal allocation. |
| 12 | property sequence | Restores the Test17 packet set that reached START_DONE; keeps Test18 zero-initialized local/HFI packet storage and the CAVLC word fix. |
| 13 | CVP exclusion | Does not set VIDC_CTRL_INIT bit 1 without Xiaomi's separate CDSP queue and FastCVPD handoff. |
| 14 | DMABUF exclusion | Does not claim imported DMABUF support: modern vb2 attachment mapping cannot carry the queue-local allocation attribute. Test19 targets MMAP. |

Test18 evidence: `LOAD_RESOURCES_DONE` was followed by START command 36 and no
START_DONE. Its OUTPUT count was first committed with host-min 2, while the
post-control table required min 4. Test17 separately reached START_DONE and
then reset after its first ETB. Patch 0033 addresses both boundaries without
combining decoder or CVP experiments.

Validation fields are filled after strict replay:

- apply check: pass against the staged 0001--0032 parent
- checkpatch strict: 0 errors, 0 warnings, 0 checks across 525 checked lines
- host/source tests: all IRIS1 numeric, HFI, PM, format, encoder and panel invariants pass
- replay tree: `ff4095f00d7995c4ac0adb5797663c4796c5982f`
