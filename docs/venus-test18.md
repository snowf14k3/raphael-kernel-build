# SM8150 / Raphael Venus Test18

Test18 uses Linux baseline
`58f3df07833f2382fe2fbc28f996c4c85817c1f6` and applies `patches/series`
0001--0032. The kernel release must be
`7.1.0-sm8150-venus-test18+`.

## Why this is a bundle

Test17 proved that both encoder queues were mapped bidirectionally and that the
firmware accepted SESSION_INIT, properties, internal buffers, LOAD, START, four
FTBs and one ETB. The device reset before the first EBD/FBD. Therefore Test18
does not change DMA direction again. It closes the remaining pre-ETB differences
found by the complete Xiaomi SM8150 review:

- zero every encoder-adjacent HFI packet and local property payload;
- always initialize the CAVLC packet's CABAC-model word, as Xiaomi does;
- do not replay default VUI/entropy/deblock/8x8/IDR/QP/profile/AUD/header and
  base-layer properties that Xiaomi leaves at fresh-session defaults;
- retain non-default standard V4L2 controls;
- use the VPU5 work-mode policy for normal H.264/HEVC, VP8 and CBR low latency;
- send each encoder buffer count from its own REQBUFS/queue setup, remove the
  speculative SESSION_INIT 4/4 pair, invalidate the cached requirements after
  a count change, and perform one final requirements query at STREAMON.

The audit also verified that Xiaomi does **not** resend the HFI syscache resource
after ordinary power collapse: its persistent `sys_cache_res_set` flag makes the
resume call a no-op. Test18 deliberately keeps the existing one-time post-SYS_INIT
resource packet.

Full evidence and deferred differences are in
`venus-sm8150-encoder-full-path-audit-test17.md`.

## Safe checks after boot

Do not enable the encoder gate until these pass:

```bash
uname -r
v4l2-ctl --list-devices
grep -H . /sys/module/venus_enc/parameters/iris1_encoder
sudo dmesg | grep -iE 'venus-sm8150|qcom-venus|video-codec' | tail -n 80
```

Expected gate value is `N`. To run only the already-proven decoder smoke tests:

```bash
sudo env VENUS_TEST_SCOPE=decoder VENUS_TEST_ENCODER=0 \
  bash /home/user/venus-test18-suite.sh
```

## Encoder-only admission

This skips VP8/VP9/MPEG2 decoder cases, so a decoder failure cannot prevent the
encoder test from running. Start a persistent remote kernel log first. Then run:

```bash
sudo env VENUS_TEST_SCOPE=encoder VENUS_TEST_ENCODER=1 \
  bash /home/user/venus-test18-suite.sh
```

The script stops after the first failed encoder case. A one-frame PASS requires a
non-empty H.264 stream and successful software decode. Kernel success additionally
requires a matching EBD and non-empty FBD, orderly STOP/RELEASE/END, and runtime
PM returning to `suspended`. A reset or an empty file is a failure even if an
earlier HFI command returned zero.

If the one-frame case passes, the same run proceeds to 30-frame H.264, then HEVC
and VP8 only when FFmpeg exposes those V4L2 M2M encoders. The global encoder gate
is restored to its original value by the exit trap.
