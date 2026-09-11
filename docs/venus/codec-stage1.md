# SM8150 Venus：基本解码与编码迁移批次

日期：2026-09-11。固定源：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`。
下游对照：MiCode `cepheus-q-oss`，`192eca8550f95c2eec58a474793d1d93fc1b3b67`。

## 范围和结论

本批次将共享 SM8150 平台依赖、HFI4/VPU5 启动和两个 codec 方向一起接入，首轮实机目标同时包括 **H.264 -> NV12 解码** 与 **NV12 -> H.264 编码**。不是只接 decoder 后要求升级，也没有恢复旧实验集。

`0001`～`0004` 的音频、DPU、DSI 修复内容保持不变。H.264/HEVC、P010、QC08C/QC10C 的原有格式代码复用，不把已有能力重复算作新移植。HEVC 和 Main10 仍需要独立实机验收。

本记录是源码集成与局部验证结果，**不能据此宣布实机编解码成功**。整包构建结果另以 `out/raphael-venus-hwaccel/build.log`、`last-build.env`、产物 `build-info.txt` 为准，未生成这些成功记录时不能宣称已有可安装包。

## 本次独立补丁和依据

以下 `U/` 指 `drivers/media/platform/qcom/venus/`，`D/` 指下游 `drivers/media/platform/msm/vidc/`。

| 补丁 | 解决的问题及依据 | 风险与验证 |
|---|---|---|
| 0005 | IRIS1 IRQ mask 保留非 CPU/WD 位；`D/venus_hfi.c:interrupt_init_vpu5()` | 原版负对照；实机观察固件应答和中断，不修改 IRQ 地址布局 |
| 0006 | DSP queue/UC-region 默认指向 CPU HFI 队列；`setup_dsp_uc_memmap_vpu5()` | 不开启 CVP session；验证冷启动和固件 resume |
| 0007 | 每次 core clocks 使能后恢复 VPU5 CPU clock config；下游 clock hook | 验证 secure 启动/恢复，不拿 no-TZ 路径替代 |
| 0008 | 将现有 WORK_ROUTE 打包下沉至 HFI4，HFI6 保持 fallback 等价 | 验证实际包长、property、session、route、HFI6 相同报文 |
| 0009 | IRIS1 decoder 选择 VPP route，保留 MPEG2/隔行 H.264 单管线例外 | 对照 `msm_vidc_decide_work_route()`；验证 sequence-change 后路径 |
| 0010 | IRIS1 encoder 的 VBR/CBR/CQ、VP8、bytes-slice route 选择 | 单独 encoder 修改；验证 720p30 边界和错误返回 |
| 0011 | 分配前查询两类 encoder 外部队列要求，STREAMON 后重新验证真实 VB2 队列 | 对照下游 `msm_venc.c`、`msm_comm_try_get_bufreqs()`；检查顺序、CREATE_BUFS、size/count、PM 引用和控件变化 |
| 0012 | 编码回包 offset/payload 越界时以空 payload/ERROR 返回 | 检查相减后比较，避免溢出；保留 bytesused 包含 data_offset 的语义 |
| 0013 | firmware boot 前应用 OPP 和电源性能票，不依赖 bootloader 遗留时钟 | 对照 PIL proxy 200 MHz 与 VPU5 时钟使能；验证 cold boot |
| 0014 | IRIS1 完成 firmware/SCM suspend 后不走 AR50 AXI halt 寄存器路径 | 保留 idle/PC_READY 和 SCM 错误处理；实机重复 idle/resume |
| 0015 | MVSC/MVS0/CVP 作为共享 firmware 周期资源，七时钟、四复位、三岛反向回收 | 下游资源及 power-on/reset 顺序；主机注入各阶段失败；暂不启用 inter-frame HW collapse |
| 0016 | SM8150 match/resource、HFI4+IRIS1、一个视频核/两个 VPP 管线、双向子节点 | MVS1 不伪装成第二编码核；带宽先用下游上限，性能/功耗未调优 |
| 0017 | SM8150 专用 binding，允许 firmware+IOVA 两个 memory-region | 新 binding 已被 MAINTAINERS 的 `media/*venus*` 范围覆盖；schema 验证结果须单独记录 |
| 0018 | SoC DT 的 V2 SID、OPP、clock/reset/genpd/ICC 与虚拟 IOVA 保留区 | codec 1 MiB MMIO 不与 videocc 重叠；SoC 默认 disabled |
| 0019 | 对固定 Raphael V2 板级配置启用 Venus，指定板级固件路径 | 固定 DTS 第 41 行已声明 `SM8150 0x20000`；固件实际存在性/版本未验证 |
| 0020 | G_FMT 报告已分配 IRIS1 encoder 队列的协商尺寸，而非只报旧通用公式 | 真实 G_FMT 包装函数旧版测试失败，修补后通过；非 IRIS1 保持原逻辑 |

补丁已连续编号，实际顺序以 `patches/series` 为准；每个 patch 正文保留独立说明。

## 避免重复或错误迁移的决定

1. **VPU5 不是 IRIS2。** 保留 CPU `0xc0000`、CPU CS `0xd2000`、CPU IC `0xdf000`、wrapper `0xe0000`，WD bit 4、CPU bit 2、host interrupt bit 15。下游 `vidc_hfi_io.h` 与直接寄存器访问实现相符。
2. **固定 Raphael 配置是 V2。** `sm8150-xiaomi-raphael.dts` 已含 `qcom,msm-id = <QCOM_ID_SM8150 0x20000>`。下游 `sm8150-v2.dtsi:367` 起将非安全 SID 改为 `0x2300`、mask `0x60`，并提供与本树 videocc 相符的频率。此结论针对选定的板级配置，不是对所有生产设备修订的统计断言。
3. **只保留一种 IOVA 下界约束。** 使用 `venus-iova` 的通用 `iommu-addresses` 排除 `[0, 0x25800000)`，不占用物理 RAM；配合 DMA mask `0xdfffffff`。临时试写的 SMMU driver aperture quirk 已移除，不在最终 series 中。`drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c` 相对固定基线无变化。
4. **LLCC slice 暂不启用。** 不是删掉 `CONFIG_QCOM_LLCC`；只是没有向 Venus 宣告未完整管理的 slice。初始 DDR/ICC 票采用下游 bus ceiling `6533000 kB/s`，功耗偏保守，需要后续实测调整，不作为吞吐量承诺。
5. **不猜固件已安装。** 板级要求 `qcom/sm8150/Xiaomi/raphael/venus.mbn`，大小需适配既有 `0x97600000`、5 MiB carveout。该大小写目录与本板其他固件路径一致，但文件内容、版本、MDT/分片布局和实际安装均属于目标机检查，不能由服务器内核编译证明。

## 已执行的局部验证

- `ARCH=arm64 LLVM=-22` 对 Venus 驱动目录和 Raphael DTB 的集中目标构建通过。`venus-core.o`、`venus-dec.o`、`venus-enc.o` 经 `file` 确认为 ARM aarch64 ELF relocatable，不是 host x86 编译冒充。
- DTC 成功，已读取实际 DTB：Venus `status=okay`、IRQ 174、`0x2300/0x60`、七时钟、四复位、三个功能电源域+MMCX、两个 memory-region 和六个 OPP 均生成；firmware path 与板级一致。
- 从固定 Git 对象重放全部 series 后，与审查源码 tree 逐字节相同；临时生成的 `raphael.config` 不混入 patch。
- IRQ 真实函数 host MMIO：1,069 个用例通过，保留原版预期失败的负对照。
- 实际完整 HFI packetizer 与 codec 函数：136 项断言通过，涵盖 HFI4/HFI6 parity、两种 route、队列 count/size、异常/PM 引用、G_FMT。使用 host PM/VB2/固件回复 stub，**不模拟真实固件**。
- IRIS1 实际 PM/reset 函数：535 项断言通过，涵盖每个 domain、hwmode、reset assert/deassert、clock 和关断失败回收。不能由 stub 测试推导硬件电源时序已经正确。
- 所有新源码 patch checkpatch 无 ERROR；0011 的三处缩进 CHECK 已在未提交草稿中修正。新增 binding 的 MAINTAINERS 提醒已人工核对现有通配范围，未为消除提示而虚构维护者。

测试入口：`tests/venus/test-iris1-irq-mask.sh`、`tests/venus/test-codec-contracts.sh`、`tests/venus/test-iris1-power-contracts.sh`。

## 整包构建门槛与实机验收

本阶段以两条基本链路同时具备源码和局部编译基础为门槛；不为单个补丁全量打包。构建必须通过原 `scripts/local-build.sh`，仍固定 `ab4ce59`、LLVM22、`bindeb-pkg DPKG_FLAGS=-d`。image/headers/DTB/config 及双层 SHA256 校验通过后才有可安装测试包；需要发布时只允许 Pre-release。

实机应先确认固件文件及实际 live DT、驱动绑定、SYS_INIT_DONE、两个 codec 节点，再分别验证：

- 解码：逐行 8-bit H.264 -> NV12，检查 SOURCE_CHANGE、CAPTURE 格式、有效帧、帧数与内容、EOS/drain、关闭并重开；不能只看格式枚举。
- 编码：正确对齐的 NV12、匹配 crop -> H.264，检查 G_FMT/REQBUFS/QUERYBUF 一致性、输入消费、输出有效码流、软件解码回验、LAST/drain，以及 fresh-session 重开。保留旧队列不释放的 STREAMOFF/STREAMON、动态控件、并发多实例尚未实机验证。
- HEVC Main、HEVC Main10/P010、HEVC 编码分别记录结果。H.264 测试不替代它们；Main10 输入能输出 NV12，也不等于原精度 10-bit 输出已通过。

接口参考：Linux 官方 `userspace-api/media/v4l/dev-encoder.html` 和 `dev-decoder.html`。本批次尚没有上述实机结果，不改目标机 `/boot`、不声称性能/稳定性、也不发布正式 Release。
