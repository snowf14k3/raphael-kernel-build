# 0034 SM8150 HFI4 QP-range enable hunk ledger

Patch: `patches/0034-media-venus-fix-SM8150-HFI4-QP-range-enable.patch`

SHA256: `284722589750e74bd50af90c085d6f383d2bf6fd69e0cca4d7f010466e9c6ee5`

Scope: 2 source files, 2 hunks, 9 insertions and 2 deletions. Parent state is
patches 0001--0033.

| # | File / area | Disposition and reason |
|---:|---|---|
| 1 | `hfi_cmds.c`, HFI4 QP_RANGE_V2 | Restores `min_qp.enable=7` and `max_qp.enable=7`; public min/max controls apply to I/P/B and have no separate enable-mask input. |
| 2 | `venc.c`, QP-range submission | Logs packed min/max QP, all-layer ID and effective enable mask before property 0x2005009. |

This corrects an error introduced by 0022. Its old hunk 011 claimed that the
packetizer preserved an input enable value, but the `venc.c` caller never set
that value. Once 0032 correctly zeroed packet and local storage, the effective
mask became zero and Test19 reset on this property.

The complete adjacent H.264 property sequence is recorded in
`venus-test19-property-reset-analysis.md`. No other property in that sequence
copies an uninitialized caller field. Patch 0034 does not modify count timing,
DMA direction, upstream cache, internal buffers, PM or decoder behavior.

Validation fields:

- apply check: pass against the staged 0001--0033 parent
- checkpatch strict: 0 errors, 0 warnings, 0 checks across 23 checked lines
- host/source tests: all IRIS1 numeric, HFI, PM, format, encoder and panel invariants pass
- replay tree: `8d686dfc4db955497790cda1db53aed60602677e`
