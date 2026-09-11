# Raphael SM8150 Venus：干净基线审计与第一步

审计日期：2026-09-11。本文描述源码审计，不代表实机验证通过。

## 0. 范围、基线与当前状态

- 工作区约束：`/home/snowflake/linux/WORKSPACE.md`，已完整读取。
- 构建工作树：`/home/snowflake/linux/raphael-kernel-venus`。
- 构建分支：`raphael-venus-hwaccel`；开始审计时 HEAD 为 `e24ff99`，工作树干净。
- 固定上游：`GengWei1997/linux`，`raphael-7.1`，`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`。
- 下游参考：`MiCode/Xiaomi_Kernel_OpenSource`，`cepheus-q-oss`，本地 HEAD `192eca8550f95c2eec58a474793d1d93fc1b3b67`，工作树干净。
- `raphael-linux` 本身仍在 `mic-routing-test1`；没有切换或修改它。已核实其 Venus 目录与固定上游提交没有差异。设备树依据仍直接读取固定提交。
- 没有恢复、应用或 cherry-pick 任何旧 Venus 实验补丁。旧实验成功与失败不能算作本基线的测试结果。

本轮必须保留并保持内容不变的通用补丁：

```
0001-arm64-dts-qcom-raphael-restore-microphone-routing.patch
0002-drm-msm-dpu-raise-sm8150-cmd-panel-clk-inefficiency.patch
0003-drm-msm-dsi-serialize-dcs-with-cmd-mode-bursts.patch
0004-drm-msm-dsi-preserve-active-link-clocks-during-xfer.patch
```

### 状态用语

- **确认缺失**：固定源码中没有对应平台接入或行为。
- **确认差异**：上下游行为不同；不等于已经证明它导致硬件故障。
- **待实机验证**：静态代码不能确定目标固件/硬件是否接受。
- **已有基础**：不应重新搬一套同类实现。

## 1. 解码启动

**确认缺失：SM8150 平台接入。**

上游 `core.c:1122-1134` 的 `venus_dt_match` 没有 SM8150，也没有 `sm8150_res`。`core.h:53-60` 虽有 `VPU_VERSION_IRIS1`，但固定基线没有为 SM8150 实例选择它。`sm8150.dtsi` 已有 `videocc` 和 `venus_mem`，Raphael DTS 也保留了位于 `0x97600000` 的固件预留区，但没有 Venus codec 节点及板级启用。

因此，这个干净基线不是“已有可运行的 SM8150 decoder，只差 HEVC”，而是尚未把设备绑定到 Venus 驱动。编译出模块不等于设备已经存在。

下游 `sm8150-vidc.dtsi:18-56` 给出的参考资源：

- codec MMIO `0x0aa00000`，下游窗口大小 `0x200000`；IRQ 174，level-high。
- MVSC 控制域、MVS0 video codec 域、MVS1 CVP 域；不能把它们简单当成 SDM845 的两个视频 codec 核。
- 六路时钟、四路复位及 225/300/365/432/480 MHz 档位。

这些是待转换为 Linux 7.1 binding、resource、genpd、interconnect 描述的依据，不是直接复制下游 DTS 的理由。尤其不能让新的 codec 窗口与独立 videocc 资源声明产生未经检查的重叠。

已有基础：V4L2 M2M、session 初始化、压缩 OUTPUT / 原始 CAPTURE 双队列、动态分辨率处理均已存在于 `vdec.c`。第一项真正的硬解验收应是非安全、单会话、逐行 H.264 -> NV12 解码到内存，不先叠加显示合成器、零拷贝或编码。

## 2. firmware / HFI

### 2.1 版本和寄存器：已有基础，不能错移植

下游 `msm_vidc_platform.c:813-827` 选择 `VPU_VERSION_5`；`venus_hfi.c:5153-5170` 选择 `HFI_PACKETIZATION_4XX`。也就是本次目标的 VPU5 / IRIS1 + HFI4，而不是 SM8250 的 IRIS2 + HFI6。

下游 `vidc_hfi_io.h:19-31,73-110` 与 `venus_hfi.c:886-950` 的直接 MMIO 访问确认：

| 项目 | 本次下游值 | 上游现有路径 |
|---|---|---|
| CPU 基址偏移 | `0xc0000` | legacy |
| CPU CS 偏移 | `0xd2000` | legacy |
| CPU IC 偏移 | `0xdf000` | legacy |
| wrapper 偏移 | `0xe0000` | legacy |
| host -> firmware soft interrupt | bit 15 | 非 V6 / 非 lite 路径 |
| wrapper watchdog / CPU interrupt | bit 4 / bit 2 | legacy masks |

`core.c:254-282` 现有寄存器分支让 IRIS1 走 legacy 地址是符合这份下游的。**不要把 IRIS1 改成 IRIS2 的 `0xa0000/0xb0000` 地址，也不要把 watchdog 改成 bit 3。**

### 2.2 确认的启动差异

1. **IRQ mask 初始化**：下游 `interrupt_init_vpu5()` 读取当前 mask，只清 CPU 与 watchdog 的 mask；上游 `venus_boot_core()` 的 IRIS1 路径原本会直接写 `0x8`。这是本轮唯一修改。
2. **DSP queue fallback**：下游 `setup_dsp_uc_memmap_vpu5()`（`venus_hfi.c:4691-4707`）即使不启用 CVP，也先用 CPU HFI queue 初始化 DSP queue / UC-region 三个寄存器。上游 `venus_run()` 只初始化 CPU queue 与 SFR。此项需要单独审查和验证，不能把 CVP 整套搬进 decoder。
3. **CPU 时钟配置**：下游 VPU5 的 `clock_config_on_enable_vpu5()`（`venus_hfi.c:4709-4713`）在电源/时钟使能流程中清 `WRAPPER_CPU_CGC_DIS` 和 `WRAPPER_CPU_CLOCK_CONFIG`。上游正常 secure runtime 路径没有对应 IRIS1 hook。上游 no-TZ CPU reset 路径中的相似写操作不能代替 secure resume 审计。
4. **decoder work route**：上游 `vdec_set_work_route()`（`vdec.c:731-742`）只给 IRIS2 / IRIS2_1 发送 property；下游 VPU5 的 `msm_vidc_decide_work_route()`（`msm_vidc_clocks.c:1213` 起）对一般逐行 H.264 / HEVC 选择 route 2，另有 MPEG2 / 隔行等例外。更进一步，`hfi_cmds.c:1337-1343` 的 WORK_ROUTE 序列化仅位于 `pkt_session_set_property_6xx()`；HFI4 dispatch 不会进入它。因此后续需要同时审查 HFI4 property 打包与 IRIS1 decoder 的 route 选择，不能只放宽 `vdec_set_work_route()` 的条件。

### 2.3 待核实的固件合约

Linux 7.1 已有 MDT 加载、预留区检查和 SCM/PAS 启动，不需要重写整套 loader。但当前还没有 SM8150 `fwname`、板级 `firmware-name` 和资源接入，目标机实际 Venus 文件名、文件完整性、固件版本及启动应答尚未读取。

上游 HFI4 capabilities 主要来自 `hfi_platform_v4.c` 静态表；`hfi_parser.c:266-310` 会优先采用平台表，不能把格式枚举视为固件已实测支持。MAX_VIDEOCORES、分辨率/load 限制、work route 与固件返回内容需要分别核对。

## 3. buffer / DMA / IOMMU / cache

### 已有基础：不要重复移植

- `hfi_plat_v4` 没有 host-side `.bufreq` 回调。`helpers.c:619-705` 的 `venus_helper_get_bufreq()` 已经回退到 `HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` 向固件查询，不是缺少查询机制。
- HFI4 scratch / scratch1 / scratch2 / persist / persist1 的分配路径已在 `helpers.c:234-360` 存在。
- 内部 DMA buffer、DPB、VB2 DMA-contig 外部队列均已有实现；不能把 Android ION / msm_smem API 直接覆盖到 Linux 7.1。
- 下游 `msm_comm_try_get_prop()`（`msm_vidc_common.c:4679` 起）也查询固件。其外部 decoder buffer count 处理并非简单照抄固件所有 count：`4620-4654` 明确对部分外部队列保留 host count，仅更新 size/alignment 等。因此不能宣称“所有 external count 都必须无条件等于固件值”。

### 确认缺失 / 待验证

- SM8150 非安全 SMMU 接入、DMA mask、IOVA aperture 尚未由平台配置落实。下游参考为 SID `0x1300` / mask `0x60`、起点 `0x25800000`、长度 `0xba800000`，结束地址为 `0xe0000000`（不包含）。实际 Linux IOMMU 描述需独立核实，不能仅设置一个大 DMA mask 就宣称合约正确。
- Vulkan/GPU 的 LLCC 或 `CONFIG_QCOM_LLCC=y` 不等于 Venus 已配置 cache。下游有 vidsc0 / vidsc1 两个 slice（`sm8150-vidc.dtsi:24-26`），并实现 activate、HFI `VIDC_RESOURCE_SYSCACHE` 通知、release、deactivate；上游 Venus 没有这套生命周期。
- 下游允许 `msm_vidc_syscache_disable` 并可跳过 slice，因此 **尚不能证明 LLCC 是最小解码的硬性前置条件**。初期应明确是否完全不启用 cache，不做“启用了一半”的状态。
- 上游内部 buffer 查询失败会在 `intbufs_set_buffer()` 中返回成功；需后续区分“该 buffer 类型不存在”和真实 timeout/协议错误。这是审计风险，不是本轮已观测到的故障。
- size、alignment、min_host、min_fw、actual、DPB 与 OUTPUT2 的分配，以及分辨率改变后的重分配需要实机应答验证。没有依据一次性移植 HFI6 host buffer calculator 或大批 DMA diagnostic patch。

## 4. 电源 / 时钟 / runtime PM

确认需要平台审计，而非“Linux 没有 PM”：现有 `pm_helpers.c` 已有 genpd、OPP、clock/reset、runtime PM 框架。

重点差异：

- 下游 VPU5 `__prepare_ahb2axi_bridge()`（`venus_hfi.c:3982-4009`）有单独 reset assert / delay / deassert。需对照上游 core reset 顺序与可用 reset binding。
- `vcodec_control_v4()`（`pm_helpers.c:415` 起）先尝试 genpd hardware mode，失败后落入旧 wrapper power 寄存器路径。固定 `videocc-sm8150.c` 的 `vcodec0_gdsc` / `vcodec1_gdsc` 已设置 `HW_CTRL_TRIGGER`，因此不能宣称缺少基础 hardware-mode 支持；后续应优先验证已有 genpd 路径，不能默认为 SDM845 wrapper fallback 适用。
- `core.h:26-28` 当前限制 core clocks 最多 4 路、每组 vcodec clocks 最多 2 路、resets 最多 2 路。下游六时钟/四复位不能原样塞进同一资源数组；需要分别映射依赖并论证 decoder-first 的必要集合。
- 下游 MVS1 对应 CVP。decoder-first 不开启 CVP，但也不能未经核实就推断启动固件永远不需要该域；需要单独确认 firmware boot 与 session 的依赖。
- `core_clks_enable()` 是否在首次 boot 前设置正确频率、secure resume 的 CPU clock config、AXI halt / runtime suspend / resume 的顺序均需核对，不在一个补丁里同时修改。
- 对照 `msm_vidc_platform.c:106-116` 的宏参数顺序，H.264 / HEVC 的基本 VPP/VSP cycle 值与现有 HFI4 表相符；不是缺一个全新的频率计算器。不过下游还有 work-route 分摊和固件开销，OPP、带宽与总负载限制不能直接照搬其他 SoC。

## 5. format：H.264 / HEVC / 10-bit

已有：`vdec.c:32-122` 的 H.264、HEVC、NV12、QC08C、QC10C、P010；HFI4 HEVC 静态表也已有 Main / Main10 与 TP10 UBWC / P010。**不需要为了“支持 HEVC”先加已有 fourcc。**

待验证的是实际链路：

1. 逐行 H.264、8-bit -> NV12，先以低负载、单会话解码到内存，确认有效 CAPTURE DQBUF、帧数、图像内容和 EOS/drain。
2. HEVC Main 8-bit，确认 source-change 后的 buffer requirements、DPB / OUTPUT2 路由和连续解码。
3. HEVC Main10：区分压缩输入的 10-bit 与输出像素是否仍为 10-bit；确认 TP10 UBWC DPB、P010 输出的 stride / sizeimage / bit-depth。不能仅看到 HEVC 枚举，或仅输出 NV12，就宣布 10-bit 原精度链路成功。

stateful decoder 的 OUTPUT/CAPTURE 队列并非逐 buffer 一一对应；验证应包含 source-change、返回的格式/尺寸、所需 buffer 数、drain/EOS，而非只看进程没有退出。

外部接口参考（补充流程说明，不作为固定源码内容的证据）：

- Linux V4L2 stateful decoder 文档：`https://docs.kernel.org/userspace-api/media/v4l/dev-decoder.html`
- Linux YUV/P010 格式文档：`https://docs.kernel.org/userspace-api/media/v4l/pixfmt-yuv-planar.html`

## 6. 编码

通用 `venc.c` 和控制项存在，但 SM8150 encoder session、work route、外部 buffer requirements、码率/质量、ETB/FTB 以及输出 payload 未在本干净基线上验证。

本轮不修改 `venc.c`、encoder controls、编码 buffer 算法，也不以旧实验编码 reset 结果推导新代码。先通过 decoder 的最小链路，再另起编码阶段。共享固件启动代码天然位于 encoder/decoder 之前，但不代表本补丁包含编码适配。

## 7. 本轮唯一补丁：保留 IRIS1 启动中断 mask

文件：`0005-media-venus-preserve-iris1-interrupt-mask.patch`。

### 解决什么

仅在 `venus_boot_core()` 中添加 `IS_IRIS1()` 分支：读取 wrapper interrupt mask，清 CPU bit 2 与 watchdog bit 4 的屏蔽，保留其他所有位。

下游注释记录的 reset mask 为 `0x1f6`，按此操作得到 `0x1e2`。原上游 IRIS1 fallback 写 `0x8`，不能保持其他中断的屏蔽状态。这是确定的控制逻辑差异，尚无本干净基线的实机 IRQ storm 或 hang 证据。

### 下游依据

- `msm_vidc_platform.c:813-827`：SM8150 选择 VPU5。
- `venus_hfi.c:127-131,5175-5181`：VPU5 dispatch。
- `venus_hfi.c:4672-4683`：`interrupt_init_vpu5()`。
- `vidc_hfi_io.h:105-110`：旧布局 watchdog / CPU masks。

### 为什么固定 Linux 7.1 需要

基线有 IRIS1 枚举但没有专用 mask 语义。后续新增 SM8150 resource 时，不应自动继承 VPU4 的常量写入。先把这个单一前置差异修正，后续平台接入无需夹带这项 HFI 改动。

### 不包含什么 / 风险

- 不改变 IRQ 清除、soft interrupt bit、MMIO offset、queue、DMA、PM、时钟、format 或 encoder。
- 不新增 SM8150 resource / DTS，不会自行创建可工作的 `/dev/video*`。
- 现有已绑定平台不选择 IRIS1，行为保持不变。本补丁目前是未接入硬件的前置修正。
- 实际硬件 reset mask 和固件行为尚未测量；保留当前 mask 与下游一致，但不能以 host 测试代替硅片验证。

### 如何验证

`tests/venus/test-iris1-irq-mask.sh` 从固定 Git blob 提取真实函数和寄存器定义，比较原始版与应用本补丁后的版。使用 host MMIO mock 验证 mask 保留和其他 VPU 路径不变；这是控制逻辑测试，不模拟真实 Venus firmware。

本地完整内核构建使用原有 `scripts/local-build.sh`，保持 `ARCH=arm64 LLVM=-22 DPKG_FLAGS=-d bindeb-pkg`。构建、包校验和清理结果记录在该轮 `out/raphael-venus-hwaccel/`，不把“编译通过”写成“解码成功”。

将来平台接入完成后的实机验收：确认驱动绑定、固件 `SYS_INIT_DONE`、H.264 session 初始化应答、无持续空中断/IRQ flood、能完成启动/停止/重新打开。只在必要时加入限于相关寄存器的最小诊断。之后才进入 CAPTURE 帧内容和 EOS 验证。

## 8. 下一步边界

下一轮先审查 VPU5 firmware boot 剩余依赖（DSP queue fallback、CPU clock 初始化），每次只实现一个有证据的差异。再以独立补丁接入 SM8150 resource / binding / DTS 和已核实的 PM 路径，才有条件发布面向手机的 decoder bring-up Pre-release。

本轮 IRQ 前置补丁本身没有独立可观察的硬解收益，不应为了凑一次测试而发布它、要求用户升级手机，或宣称已经达到 H.264/HEVC 解码目标。
