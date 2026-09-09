# SM8150 / Raphael Venus Test19

Test19 uses Linux baseline
`58f3df07833f2382fe2fbc28f996c4c85817c1f6` and applies `patches/series`
0001--0033. The expected kernel release is
`7.1.0-sm8150-venus-test19+`.

## What changed after the Test18 reset

The complete external `dmesg -w` capture proves Test18 stopped while firmware
was processing `START`: it received `LOAD_RESOURCES_DONE`, emitted `START`, and
never received `START_DONE`. No FTB or ETB had been submitted.

The same log proves Test18 committed OUTPUT count too early with
`actual=4 host-min=2`; after properties the final firmware table required
`actual=4 min=4`. Test19 therefore:

- removes encoder count commits from mainline `REQBUFS`;
- queries requirements after controls, route, work mode and core selection;
- commits vendor-style INPUT 16/3 and OUTPUT 4/2 count requests at STREAMON;
- refreshes internal requirements before SET_BUFFERS and LOAD/START;
- restores the Test17 property sequence already observed to reach START_DONE;
- retains Test18 HFI packet zeroing and the fixed CAVLC payload;
- ports Xiaomi's upstream-cache IOMMU mapping contract for IRIS1 encoder MMAP
  and internal buffers, selecting the existing ARM LPAE MAIR value 0xf4.

The upstream-cache change is deliberately not applied to HFI queues or decoder
buffers. Imported DMABUFs also remain outside this first test; FFmpeg's V4L2
M2M MMAP path is the admission target.

## Boot checks

Do not enable the encoder gate yet:

```bash
uname -r
v4l2-ctl --list-devices
grep -H . /sys/module/venus_enc/parameters/iris1_encoder
sudo dmesg | grep -iE 'venus-sm8150|qcom-venus|video-codec' | tail -n 100
```

Expected release is `test19+`, both video nodes must exist, and the gate must
be `N`.

## Persistent external log

On Windows, open a dedicated PowerShell terminal and leave it running:

```powershell
ssh -tt user@192.168.10.139 "sudo dmesg -w" |
  Tee-Object -FilePath "$HOME\Desktop\test19-encoder-live.log"
```

Then use a second terminal on the phone. Run encoder scope only; do not spend
time on the deferred VP8/VP9/MPEG2 decoder failures:

```bash
sudo env VENUS_TEST_SCOPE=encoder VENUS_TEST_ENCODER=1 \
  bash /home/user/venus-test19-suite.sh
```

The script writes `TEST19_ENCODER_FULL_BEGIN` directly to `/dev/kmsg` before
the attempt, so the Windows log retains the exact last kernel event if the
phone resets.

## Acceptance boundary

Before `START`, required logs are:

```text
encoder count request type=0x1 actual=16 host-min=3 committed
encoder count request type=0x2 actual=4 host-min=2 committed
upstream-hint=1
```

Functional success requires `START_DONE`, EBD, a non-empty FBD, a non-empty
Annex-B H.264 file that software FFmpeg can decode, orderly teardown, and
runtime PM returning to `suspended`. A reset, timeout, empty file, or FFmpeg
exit code without those events is a failure.
