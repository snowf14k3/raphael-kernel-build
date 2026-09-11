# Raphael DSI 亮度闪屏修复

这是 `raphael-kernel-build` 中用于 Xiaomi Redmi K20 Pro / Mi 9T Pro（`raphael`，SM8150）DSI / 亮度闪屏问题验证与正式构建的分支。

## 内核基线

- 上游仓库：`https://github.com/GengWei1997/linux.git`
- 上游分支：`raphael-7.1`
- 固定提交：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

构建脚本会在应用补丁前验证固定 commit，避免上游分支变化导致构建内容漂移。

## 当前补丁

本分支保留最终验证后的 Raphael 修复：

```text
0001-arm64-dts-qcom-raphael-restore-microphone-routing.patch
0002-drm-msm-dpu-raise-sm8150-cmd-panel-clk-inefficiency.patch
0003-drm-msm-dsi-serialize-dcs-with-cmd-mode-bursts.patch
0004-drm-msm-dsi-preserve-active-link-clocks-during-xfer.patch
```

其中显示相关修复包括：

1. 提高 SM8150 DPU command-mode 时钟余量；
2. DCS 传输前对正在进行的 command-mode burst 做有界等待；
3. 显示链路已经 active 时，不再在每次 DCS 传输期间重复调整、启用和关闭 DSI link clock。

第 3 项是实机测试中亮度调节闪屏停止复现时的关键变化。

之前 bring-up 阶段加入的 `DSIERR#`、`DPUERR#`、`DPUCMD#`、FIFO 和 timeout 诊断代码已经从正式补丁集中移除。

> 该闪屏问题可能只影响部分 Raphael 设备、面板批次或特定时序条件，并非所有设备都一定能够复现。

## 实机验证

在可稳定复现问题的 Raphael 实机上，修复前快速拖动亮度会出现闪屏以及 DSI 相关异常；应用最终补丁集后，连续快速改变亮度不再复现此前的闪屏问题。

## 构建

构建入口：

```text
.github/workflows/build.yml
scripts/build.sh
```

当前使用 LLVM/Clang 22，生成 ARM64 Debian kernel image 和 matching headers，并同时收集 Raphael DTB、最终 config、补丁哈希、构建信息和 `SHA256SUMS`。

本地 AMD64 主机进行 ARM64 打包时使用 binary-only Debian package 流程：

```text
bindeb-pkg
DPKG_FLAGS=-d
```

## 正式构建

当前该补丁集已经用于正式构建：

```text
7.1.0-sm8150-g9230127ee0e4
```

对应 Release tag：

```text
raphael-7.1.0-sm8150-g9230127ee0e4
```
