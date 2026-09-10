# Raphael kernel build

Patch-based kernel build workspace for Xiaomi Redmi K20 Pro / Mi 9T Pro (`raphael`, SM8150).

This branch is dedicated to investigating and fixing microphone capture/recording on Raphael.

## Kernel baseline

The build uses GengWei1997's Linux tree directly:

- Repository: `https://github.com/GengWei1997/linux.git`
- Branch: `raphael-7.1`
- Pinned commit: `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

The pinned commit is checked by `scripts/build.sh` before any patch is applied. If the upstream branch moves, the build stops instead of silently building against an unreviewed baseline.

## Workspace layout

Two repositories are used locally:

```text
/home/snowflake/linux/raphael-linux
/home/snowflake/linux/raphael-kernel-build
```

`raphael-linux` is the local development checkout of `GengWei1997/linux:raphael-7.1`. Kernel changes are developed and tested there.

`raphael-kernel-build` contains only the build workflow and the patches that should be applied to the clean upstream baseline.

## Patch workflow

Make kernel changes in:

```text
/home/snowflake/linux/raphael-linux
```

Then export the finished change as a numbered patch into:

```text
patches/0001-*.patch
patches/0002-*.patch
...
```

List the patch filenames in `patches/series` in the exact order they must be applied. Blank lines and lines beginning with `#` are ignored.

During a CI build, `scripts/build.sh` performs the following sequence:

1. Clone `GengWei1997/linux` branch `raphael-7.1`.
2. Verify that the source is still at the pinned commit.
3. Run `git apply --check` for every entry in `patches/series`.
4. Apply the patches in series order.
5. Run `git diff --check` on the patched source tree.
6. Merge the Raphael kernel configuration.
7. Build Debian kernel packages with LLVM/Clang.
8. Collect the kernel package, Raphael DTB, final config, patch hashes and build metadata.

## GitHub Actions

The workflow is located at:

```text
.github/workflows/build.yml
```

It currently runs manually with `workflow_dispatch` and builds on `ubuntu-24.04-arm`.

The uploaded artifact is named:

```text
raphael-microphone-test-kernel
```

It contains:

```text
linux-image-xiaomi-raphael-mic-test.deb
sm8150-xiaomi-raphael.dtb
kernel.config
build-info.txt
patches.sha256
SHA256SUMS
```

## Current target

The current work focuses on the microphone capture path, including the Raphael sound-card device tree, WCD9340 codec routing, SLIMBus capture, Qualcomm QDSP6/AFE routing and the SM8150 ASoC machine driver.

Keep unrelated kernel adaptations out of this branch unless they are required for microphone recording to work.
