# SM8150 / Raphael Venus Test20

Test20 uses Linux baseline
`58f3df07833f2382fe2fbc28f996c4c85817c1f6` and applies `patches/series`
0001--0034. The expected release is `7.1.0-sm8150-venus-test20+`.

Test19 reset before final counts, LOAD or START. Its final line was HFI4
`QP_RANGE_V2` (`0x2005009`, 84 bytes). Patch 0034 restores both I/P/B enable
masks to 7; they had incorrectly been copied from caller members that were
never assigned and became deterministic zero after packet hardening.

Test20 retains the Test19 final-count and upstream-cache fixes. It additionally
logs the full QP range immediately before property submission.

## Boot checks

```bash
uname -r
v4l2-ctl --list-devices
grep -H . /sys/module/venus_enc/parameters/iris1_encoder
cat /sys/bus/platform/devices/aa00000.video-codec/power/runtime_status
```

Expected: `test20+`, both nodes present, gate `N`, runtime PM `suspended`.

## External capture and encoder-only run

In a dedicated Windows PowerShell terminal:

```powershell
ssh -tt user@192.168.10.139 "sudo dmesg -w" |
  Tee-Object -FilePath "$HOME\Desktop\test20-encoder-live.log"
```

In a second phone terminal:

```bash
sudo env VENUS_TEST_SCOPE=encoder VENUS_TEST_ENCODER=1 \
  bash /home/user/venus-test20-suite.sh
```

The script writes `TEST20_ENCODER_FULL_BEGIN` directly to `/dev/kmsg`. Do not
repeat the run after a reset.

## Required progression

The capture must contain, in order:

1. `encoder QP range ... enable=7`;
2. property `0x2005009` followed by later commands;
3. final count INPUT 16/3 and OUTPUT 4/4;
4. internal buffers with `upstream-hint=1`;
5. LOAD_RESOURCES_DONE and START_DONE;
6. FTB/ETB, EBD and a non-empty FBD;
7. software-decodable H.264 and runtime PM `suspended`.

A reset at any earlier point remains a failure and the external log is the
authoritative boundary.
