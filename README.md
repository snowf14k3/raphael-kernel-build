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

已从固定 `ab4ce59` 连续迁移共享 SM8150/VPU5/HFI4 平台依赖、基本 decoder 和基本 encoder。Raphael V2 设备树已启用 Venus，两个 codec 子节点由驱动创建；详见 [本批次改动、依据与验收边界](docs/venus/codec-stage1.md)。[首次缺口审计](docs/venus/audit-ab4ce59.md) 保留为迁移前快照，不代表这些接入项仍然缺失。

Venus core/decoder/encoder 的 ARM64 目标编译和 Raphael DTB 编译通过。主机回归包括 IRQ 1,069 个用例、实际 HFI packetizer/codec 函数 136 项断言、PM/reset 535 项断言；这些不是实机测试。

**尚未进行本批次实机编解码验证。固件路径要求为 `qcom/sm8150/Xiaomi/raphael/venus.mbn`，文件实际存在性及版本必须在目标机核实。不能把模块、格式枚举或主机测试通过写成硬解/硬编已可用。**

回归入口在 `tests/venus/`，不会操作硬件，也不往内核加入 diagnostic 代码。完整包是否生成，以当前 `out/raphael-venus-hwaccel/last-build.env` 和 `build-info.txt` 为准。

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

**按功能里程碑集中构建，不按单个 patch 构建。** 用户最新要求：下一次完整构建必须同时具备基本解码和基本编码。连续整理独立补丁，中间执行应用/静态检查和必要局部测试；共享 SM8150 平台/DTS、VPU5/HFI4 启动、PM/时钟/IOMMU，以及两条 session/work-route/buffer/format 路径在源码层面均具备实机验证条件后，再统一 `local-build.sh`。首轮同时验证 H.264 -> NV12 与 NV12 -> H.264，不能仅完成 decoder 就打包；HEVC/Main10 另记实际结果。

2026-09-11 针对 `0005` 前置补丁启动的全量构建已按用户要求中止，没有生成可安装测试包；补丁及已有局部测试结果保留。

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
