# Raphael Venus 硬件编解码适配

这是 `raphael-kernel-build` 中用于 Xiaomi Redmi K20 Pro / Mi 9T Pro（`raphael`，SM8150）Qualcomm Venus 硬件编解码适配的独立开发分支。

本分支是从当前最新 `main` **全新创建**的，不恢复、复用或直接继承之前 Venus bring-up 阶段的实验补丁、测试脚本和诊断代码。后续 Venus 修改会重新从干净基线开始整理，并按功能拆分为可审查、可回退的独立 patch。

## 分支基线

本分支继承 `main` 中已经验证的 Raphael 通用修复，包括：

- 麦克风模拟路由修复；
- SM8150 DPU command-mode 时钟余量调整；
- DCS 与 command-mode burst 的串行化处理；
- active DSI link clock 保持，修复部分设备亮度调节闪屏。

内核源码仍固定基于：

- 上游仓库：`https://github.com/GengWei1997/linux.git`
- 上游分支：`raphael-7.1`
- 固定提交：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

## Venus 适配目标

目标是在 SM8150 / Raphael 上逐步完善 Qualcomm Venus VPU 的硬件视频编解码支持，重点包括：

- 硬件 H.264 解码；
- 硬件 HEVC / H.265 解码；
- 对应编码路径的可用性验证；
- V4L2 M2M buffer / DMA contract；
- HFI4 / VPU5 session 初始化与属性协商；
- firmware buffer requirement 与 userspace queue 的一致性；
- runtime PM、时钟、电源域、IOMMU 和 system cache 等 SM8150 相关依赖；
- FFmpeg、mpv、VLC 等用户空间通过 V4L2 硬件编解码路径进行实机验证。

## 当前状态

已完成固定 `ab4ce59` 与 Xiaomi Android Q 下游的首轮源码审计，详见 [六类缺口清单与验证边界](docs/venus/audit-ab4ce59.md)。

已加入一个前置补丁 `0005-media-venus-preserve-iris1-interrupt-mask.patch`：仅修正 IRIS1 启动时的 interrupt mask 保留语义。补丁通过 checkpatch，并通过真实函数提取后的 1,069 项 host MMIO 模拟检查；原始基线作为负对照可复现差异。

**尚未加入 SM8150 Venus resource / DTS 接入，尚未进行本基线的实机硬解验证。此补丁不会单独启用 H.264 / HEVC 解码，不应据此发布可用性声明。**

回归入口：`tests/venus/test-iris1-irq-mask.sh`。测试不会操作硬件，也不会往内核加入 diagnostic 代码。

之前仓库历史中存在过一系列 Venus 测试和 bring-up 提交，但这些旧实验不会直接带入本分支。需要使用的逻辑会重新核对上游、下游 Android 内核和实机行为后，再整理成新的补丁。

## 开发原则

1. 每个阶段只引入必要的 Venus 修改；
2. 不混入与视频编解码无关的调试代码；
3. 每个 patch 都要求能够单独说明目的和行为变化；
4. 优先保留完整的 kernel / dmesg / V4L2 测试证据；
5. 解码与编码分开验证，避免一次引入过多变量；
6. 经过实机验证后再进入稳定补丁集。

## 补丁组织

Venus 相关修改后续会继续使用编号 patch，并在 `patches/series` 中按顺序列出，例如：

```text
0005-media-venus-....patch
0006-media-venus-....patch
```

现有 `0001`～`0004` 为 `main` 继承的 Raphael 通用修复，不属于 Venus 本身。

## 构建

优先使用本地构建：

```bash
./scripts/local-build.sh
```

该脚本复用 `raphael-linux` 的 Git 对象，从固定提交创建临时 worktree，使用 `ARCH=arm64 LLVM=-22 DPKG_FLAGS=-d bindeb-pkg`，并清理本轮中间产物。编译结果不等于实机解码通过。

`.github/workflows/build.yml` / `scripts/build.sh` 仅作为备用 CI；需要实机发布时使用 `scripts/publish-prerelease.sh`，只发布 Pre-release。

构建环境使用 LLVM/Clang 22，输出 ARM64 Debian kernel image、headers、Raphael DTB、最终 config、补丁哈希和 `SHA256SUMS`。

Venus 适配阶段的测试构建与正式稳定构建应使用不同的 Release / tag 命名，避免和 `main` 的稳定版本混淆。

## 本地构建与 Pre-release

本分支优先在编译服务器本地构建，避免频繁占用 GitHub Actions：

```bash
cd /home/snowflake/linux/raphael-kernel-venus
./scripts/local-build.sh
```

脚本会复用 `/home/snowflake/linux/raphael-linux` 的 Git 对象，从固定基线 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5` 创建临时 worktree，再应用本分支当前 `patches/series`。构建结束后自动清理临时源码和中间产物。

实机测试前可以发布 Pre-release：

```bash
./scripts/publish-prerelease.sh
```

目标 Raphael 可以通过 `main` 分支的一键更新脚本动态选择测试版本：

```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/update-kernel.sh)"
```

Venus 的每一轮迁移建议保持“小 patch、单变量验证”，本地构建 → Pre-release → 实机验证 → 清理上一轮垃圾，再进入下一阶段。
