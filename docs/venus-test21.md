# SM8150 / Raphael Venus Test21

Test21 uses Linux baseline
`58f3df07833f2382fe2fbc28f996c4c85817c1f6` and applies `patches/series`
0001--0035. The expected release is `7.1.0-sm8150-venus-test21+`.

Test20 reached START_DONE and submitted four FTBs plus the first 64-byte ETB,
then reset before any EBD/FBD. Patch 0035 corrects the remaining mapping
contract at that boundary: FFmpeg MMAP buffers now use VB2 streaming DMA with
explicit ownership synchronization instead of combining a cacheable upstream
PTE with a coherent allocation.

The Test20 audit also corrects the expected count sequence: INPUT 16/3 and
OUTPUT 4/2 are the Xiaomi-equivalent wire requests. The subsequent firmware
table reports output 4/4 but Xiaomi preserves external host counts and does not
send a second count command.

## Safety

The encoder gate remains `N` by default. Test21 adds a hard admission guard:
an IRIS1 MMAP buffer is rejected before STREAMON unless both `nc=1` and `up=1`
are active. Do not run Test20 again.

## Required boot checks

```bash
uname -r
v4l2-ctl --list-devices
grep -H . /sys/module/venus_enc/parameters/iris1_encoder
cat /sys/bus/platform/devices/aa00000.video-codec/power/runtime_status
```

Expected: `test21+`, both nodes, gate `N`, and runtime PM `suspended` after
the enumeration wakeup settles.

## Persistent capture

In a dedicated Windows PowerShell terminal:

```powershell
ssh -tt user@192.168.10.139 "sudo dmesg -w" |
  Tee-Object -FilePath "$HOME\Desktop\test21-encoder-live.log"
```

Only after boot checks pass, run encoder scope once in a second terminal:

```bash
sudo env VENUS_TEST_SCOPE=encoder VENUS_TEST_ENCODER=1 \
  bash /home/user/venus-test21-suite.sh
```

Before the first ETB, every input and bitstream allocation must show
`bidi=1 nc=1 up=1`. The count requests must show 16/3 and 4/2, followed by the
post-count firmware table, internal buffers, LOAD_DONE and START_DONE.

Success still requires an EBD, non-empty FBD, software-decodable H.264, clean
STOP/RELEASE/END and runtime PM returning to suspended. A reset remains a
failure; do not repeat it.
