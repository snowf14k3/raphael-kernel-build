# Raphael 内核构建

这是一个面向 Xiaomi Redmi K20 Pro / Mi 9T Pro（`raphael`，Qualcomm SM8150）的 Linux 内核补丁与构建仓库。

仓库采用“固定上游基线 + 独立补丁集 + 可复现构建”的方式维护 Raphael 适配。`main` 分支只保留已经整理并验证过的修复，不包含 bring-up 阶段使用的临时诊断补丁。

## 内核基线

当前构建基于 GengWei1997 的 Raphael Linux 7.1 内核：

- 上游仓库：`https://github.com/GengWei1997/linux.git`
- 上游分支：`raphael-7.1`
- 固定提交：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

`scripts/build.sh` 会在应用补丁前检查源码提交，避免上游分支移动后静默改变构建基线。

## 当前已完成的修复

### 1. Raphael 麦克风路由

恢复设备树中的模拟麦克风路由，将 Raphael 的 AMIC 与对应 MIC BIAS 正确关联，修复部分环境下麦克风无法正常采集的问题。

对应补丁：

```text
0001-arm64-dts-qcom-raphael-restore-microphone-routing.patch
```

### 2. 亮度调节时的 DSI 闪屏

针对部分 Raphael 设备在快速调节屏幕亮度时出现闪屏、DSI 错误或 FIFO underflow 的问题，当前正式补丁集包含以下处理：

1. 将 SM8150 DPU 的 command-mode 时钟冗余系数从 `105` 提高到 `186`，增加时钟余量；
2. 在 DCS 传输前对正在进行的 command-mode burst 做有界等待，避免并发访问；
3. 当 DSI 显示链路已经处于 active 状态时，不再在每次 DCS 传输中重复调整、启用和关闭 link clock。

其中第 3 项是实机测试中消除亮度调节闪屏的关键变化。

对应补丁：

```text
0002-drm-msm-dpu-raise-sm8150-cmd-panel-clk-inefficiency.patch
0003-drm-msm-dsi-serialize-dcs-with-cmd-mode-bursts.patch
0004-drm-msm-dsi-preserve-active-link-clocks-during-xfer.patch
```

之前调试阶段使用过的 `DSIERR#`、`DPUERR#`、`DPUCMD#`、FIFO 状态和 timeout 诊断补丁已经从正式补丁集中移除。

> 亮度闪屏可能只在部分设备、面板批次或特定时序条件下出现，并非所有 Raphael 都一定能够复现。

## 当前正式补丁顺序

补丁应用顺序由 `patches/series` 定义：

```text
0001-arm64-dts-qcom-raphael-restore-microphone-routing.patch
0002-drm-msm-dpu-raise-sm8150-cmd-panel-clk-inefficiency.patch
0003-drm-msm-dsi-serialize-dcs-with-cmd-mode-bursts.patch
0004-drm-msm-dsi-preserve-active-link-clocks-during-xfer.patch
```

## 构建与打包

GitHub Actions 工作流位于：

```text
.github/workflows/build.yml
```

当前构建环境使用 LLVM/Clang 22，并沿用已验证的 Raphael 7.1 配置。

构建流程会：

1. 获取固定的 `raphael-7.1` 内核源码；
2. 验证源码 commit；
3. 应用 SM8150 DTB 打包调整；
4. 按 `patches/series` 顺序检查并应用补丁；
5. 执行 `git diff --check`；
6. 生成 ARM64 Debian 内核包；
7. 校验并收集 kernel image、headers、Raphael DTB、最终 config、补丁哈希和 `SHA256SUMS`。

Actions 构建产物名称：

```text
raphael-kernel-arm64
```

## 分支用途

- `main`：当前已整理、已验证的 Raphael 通用修复与正式构建基线；
- `raphael-dsi-brightness-flicker-fix`：DSI / 亮度闪屏修复开发与验证分支；
- `raphael-mic-recording-fix`：麦克风采集与路由修复分支；
- `raphael-venus-hwaccel`：全新的 Qualcomm Venus 硬件编解码适配分支。

## 本地开发目录

编译服务器上的主要工作目录：

```text
/home/snowflake/linux/raphael-linux
/home/snowflake/linux/raphael-kernel-build
```

内核源码实验优先在 `raphael-linux` 中完成；确认后的修改再整理为独立 patch 放入本仓库，以保持构建过程可复现。

## 本地构建与测试发布

为了减少 GitHub Actions 的使用，仓库提供可复用的本地构建流程。

在当前分支直接执行：

```bash
./scripts/local-build.sh
```

脚本默认复用同级目录中的：

```text
/home/snowflake/linux/raphael-linux
```

从固定提交 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5` 创建临时 Git worktree，不会每次重新 clone 上游源码。构建结束后临时源码、debug 包和中间文件会自动清理。

本地测试成功后可发布 GitHub Pre-release：

```bash
./scripts/publish-prerelease.sh
```

发布内容包含 `.tar.gz` 和对应 `.tar.gz.sha256`，并在发布后自动回下载校验。

## Raphael 一键更新内核

目标机可以直接动态读取本仓库的 Pre-release 并选择版本升级。

### GitHub 直连

```bash
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/update-kernel.sh)"
```

### GitHub 镜像线路

参考 `GengWei1997/kernel-deb` 的 ghproxy 更新方式，仓库另外提供：

```text
scripts/ghproxy-update-kernel.sh
```

镜像入口支持两条线路：

```text
1. ghfast.top
2. proxy.koishi.asia
```

可以通过任意一条镜像获取入口脚本，随后交互选择下载线路：

```bash
# 通过 ghfast.top 获取镜像更新入口
sudo bash -c "$(curl -fsSL https://ghfast.top/https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/ghproxy-update-kernel.sh)"

# 通过 proxy.koishi.asia 获取镜像更新入口
sudo bash -c "$(curl -fsSL https://proxy.koishi.asia/https://raw.githubusercontent.com/snowf14k3/raphael-kernel-build/main/scripts/ghproxy-update-kernel.sh)"
```

也可以直接指定线路：

```bash
./scripts/update-kernel.sh --mirror ghfast
./scripts/update-kernel.sh --mirror koishi
```

GitHub API 的版本列表请求仍使用直连，仅 Release 的大文件资产下载走镜像，减少代理 API 兼容性问题。

更新脚本参考 `GengWei1997/kernel-deb` 的固定启动文件更新方式，但额外加入：

- 只选择 GitHub Pre-release 测试内核；
- tar.gz 外层 SHA256 与包内 `SHA256SUMS` 双重验证；
- 更新前备份当前 `linux.efi`、`initramfs`、DTB、versioned kernel 和 modules；
- 新内核验证成功后才原子切换 `/boot/linux.efi` 与 `/boot/initramfs`；
- 当前运行内核保留为一次回退；
- 新内核成功启动后自动清理旧 kernel package、`/boot` 旧版本文件和旧 modules。

编译服务器完整工作流说明见：

```text
/home/snowflake/linux/WORKSPACE.md
```
