# Raphael kernel build

Patch-based Linux kernel build workspace for Xiaomi Redmi K20 Pro / Mi 9T Pro (`raphael`, SM8150).

This branch contains the validated Raphael fixes used for the production kernel build. The temporary DSI/DPU diagnostic instrumentation used during bring-up has been removed.

## Kernel baseline

The build uses GengWei1997's Linux tree directly:

- Repository: `https://github.com/GengWei1997/linux.git`
- Branch: `raphael-7.1`
- Pinned commit: `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

`scripts/build.sh` verifies the pinned source commit before applying any local patch, so an upstream branch move cannot silently change the build baseline.

## Validated patch series

The production series is intentionally small:

1. Restore the validated Raphael microphone routing.
2. Raise the SM8150 DPU clock inefficiency factor from 105 to 186 for additional command-mode clock headroom.
3. Serialize DCS transfers against an in-flight command-mode burst with a bounded wait.
4. Preserve already-active DSI link clocks during DCS transfers instead of retuning/re-enabling/disabling them while the powered command-mode display owns the link.

The fourth change was the final change under test when brightness flicker stopped reproducing on the physical Raphael device. The prior `DSIERR#`, `DPUERR#`, `DPUCMD#`, FIFO and timeout diagnostic patches are not part of this production series.

Patch order is defined by `patches/series`.

## Build

GitHub Actions can be started manually from `.github/workflows/build.yml`. The workflow uses `ubuntu-24.04-arm`, LLVM/Clang 22 and the same `raphael.config` used by the known-good GengWei 7.1 build.

The build script:

1. Clones the pinned `raphael-7.1` source.
2. Applies the SM8150 DTB packaging adjustment.
3. Checks and applies every patch in `patches/series`.
4. Runs `git diff --check`.
5. Builds Debian packages with LLVM/Clang 22.
6. Verifies the image package contains `sm8150-xiaomi-raphael.dtb`.
7. Collects the image package, matching headers, Raphael DTB, final config, build metadata, patch hashes and `SHA256SUMS`.

The uploaded Actions artifact is named:

```text
raphael-kernel-arm64
```

## Local workspace

The development checkouts on the build host are:

```text
/home/snowflake/linux/raphael-linux
/home/snowflake/linux/raphael-kernel-build
```

Kernel source experiments happen in `raphael-linux`; only reviewed patches and reproducible build files belong in this repository.
