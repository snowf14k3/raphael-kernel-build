# CF8 secure-persist phone test order

This package is an experimental full-kernel and DTB build. Software validation
has passed, but no phone has booted the new secure context and hardware encoding
is not yet proven.

Before installation:

1. Keep the currently working kernel, initramfs, Raphael DTB, and Debian
   packages as a bootable fallback.
2. Verify the bundle's `SHA256SUMS`.
3. Add these parameters to the existing persistent kernel command line without
   removing its current arguments:

   ```text
   reserve_mem=2M:4096:ramoops ramoops.mem_name=ramoops ramoops.record_size=262144 ramoops.console_size=262144 ramoops.pmsg_size=262144
   ```

4. Install the image and matching headers together and confirm that the
   packaged `sm8150-xiaomi-raphael.dtb` is the DTB used by the boot path.

On the first boot, do not run FFmpeg, `v4l2-ctl`, or any program that opens
`/dev/video0`. Run:

```bash
sudo ./first-boot-secure-gate.sh EXPECTED_KERNEL_RELEASE
```

The gate must report `result=PASS`. In particular it checks:

- the expected kernel release;
- ramoops as the active pstore backend;
- secure VMID 11;
- SID 0x2304 with flags 0x60;
- DMA aperture [0x01000000, 0x25800000);
- an attached IOMMU group;
- `QCOM_SMMU_SECURE_PGTABLE READY vmid=11`.

Reboot once without encoder activity and repeat the gate. Compare the ramoops
reservation in both logs. Do not start the encoder if either boot fails.

The next encoder gate must stop before frame submission. It should capture
`VENUS_SECURE_PERSIST ASSIGN`, a secure IOVA below 0x25800000, successful
LOAD/START completion, and `VENUS_SECURE_PERSIST RECLAIM`. Only a later gate
may submit one frame.

After any reset, copy both `/sys/fs/pstore` and
`/var/lib/systemd/pstore` before another boot can overwrite evidence.
