# Test16 encoder reset: frozen evidence

This file is the durable record for the Test16 hard reset.  Do not repeat the
already completed comparisons without new evidence.

## Exact last successful protocol steps

1. H.264 encoder session initialized.
2. Raw NV12 input buffers: 16 buffers, 24,576 bytes each, bidirectional DMA.
3. Compressed output buffers: 4 buffers, 36,864 bytes each.
4. Firmware buffer requirements cached twice, with final input actual count 16
   and output actual count 4.
5. Internal buffers 0x6/0x7/0x8/0x4 allocated and registered.
6. LOAD_RESOURCES and START completed.
7. Runtime power was pinned through STREAMOFF.
8. Four FTBs were queued with `bidirectional=0`.
9. First ETB was queued with `bidirectional=1`.
10. The machine hard-reset before any EBD/FBD or error response.

## Current diagnosis

The first post-START operation that exercises a still-non-vendor DMA contract
is firmware access to the compressed CAPTURE buffers.  Xiaomi maps both sides
DMA_BIDIRECTIONAL; Test16 maps only source that way.  Patch 0031 fixes the
CAPTURE side for IRIS1.

## Ruled out

- missing LOAD/START;
- raw source allocation too small;
- source DMA mapped in only one direction;
- output buffer smaller than firmware minimum;
- missing scratch/persist types 0x4/0x6/0x7/0x8;
- treating count_min_host as an internal allocation count;
- allocating type 0x9 as a DMA buffer;
- missing MVS0/MVS1/CVP power or clocks;
- work route 2, work mode 2, RC timestamp-disable, ETB packet layout, or
  timestamp unit conversion.

## Still to prove on hardware

- first EBD and FBD after 0031;
- pixel correctness of the linear NV12 layout;
- clean STOP/RELEASE and runtime suspend;
- multi-frame H.264 before HEVC/VP8 encoder admission.
