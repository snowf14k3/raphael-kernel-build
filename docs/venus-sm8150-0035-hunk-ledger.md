# 0035 SM8150 streaming-DMA hunk ledger

Patch: `patches/0035-media-venus-match-SM8150-streaming-DMA-contract.patch`

SHA256: `83a95fcc79a7e925f59ae582dcdf72af791d0128d0578e2b623bcb800cd40503`

Scope: 3 source files, 7 hunks, 35 insertions and 9 deletions. Parent state is
patches 0001--0034.

| # | File / area | Disposition and reason |
|---:|---|---|
| 1 | DMA attribute documentation | States explicitly that upstream cacheability does not create coherence and still requires streaming ownership synchronization. |
| 2 | HFI4 encoder ETB assignment order | Matches the 64-byte structure and Xiaomi packetizer order; packet bytes are unchanged. |
| 3 | encoder count diagnostics | Renames “final count” to “count request”; Test20 proves vendor-equivalent wire requests are INPUT 16/3 and OUTPUT 4/2. |
| 4 | `venc_queue_setup()` | Forces IRIS1 MMAP buffers through VB2 non-coherent allocation after VB2 establishes the memory type and before allocation. |
| 5 | `venc_buf_init()` safety guard | Rejects IRIS1 MMAP if non-coherent streaming allocation or the upstream hint is absent. |
| 6 | allocation diagnostics | Logs input and bitstream buffers with actual direction, non-coherent state and upstream state. |
| 7 | post-count diagnostics | Separates the later firmware table from the earlier vendor-style wire count requests. |

The companion host changes add a compiled 16-dword ETB vector, a 128x96 raw
layout vector, source assertions for VB2 sync calls, and an admission-guard
check. CVP, non-fatal SMMU faults, clock caps and RECON DMA were reviewed and
intentionally not changed for the reasons recorded in the Test20 analysis.

Validation fields:

- source patch stats: 3 files, 7 hunks, +35/-9
- apply check: pass against the staged 0001--0034 parent
- checkpatch strict: 0 errors, 0 warnings, 0 checks across 89 checked lines
- host/source tests: all IRIS1 tests pass, including compiled 64-byte ETB and 128x96 layout vectors
- replay tree: `ba695d2fed72c98f1b792c28ae5c0ebc1043e63d`
