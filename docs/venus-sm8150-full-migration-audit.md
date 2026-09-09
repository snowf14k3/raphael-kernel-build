# SM8150 Venus 全量逐行审计与迁移清单

> **历史冻结文档：**本文冻结于 Test15，后续 0018 与最新全量结论统一维护在
> `venus-sm8150-migration-status.md`。本文不再是权威总账，其中 21,388 行/506 函数等
> 统计已被当前候选树的 21,670 行/510 函数取代。

> 审计冻结点：Test15；本文不是“已经修好”的宣告，而是后续所有实现、编译和
> 实机验证的历史记录。新增结论必须附代码位置或实机证据，并更新当前主报告，不能重新
> 猜测已经排除的路径。

## 1. 审计对象与完整性

### 1.1 固定源码身份

| 角色 | 仓库/目录 | 分支或提交 | 用途 |
|---|---|---|---|
| 主线基线 | `snowf14k3/linux`，`F:\linux\linux-raphael` | `raphael-7.1`，`58f3df07833f2382fe2fbc28f996c4c85817c1f6` | Linux V4L2/VB2/PM 架构基线 |
| Test15 完整树 | `F:\linux\test15-analysis` | 上述基线依次应用 `patches/series` 的 17 个补丁 | 本文实际审计对象 |
| 构建仓库 | `snowf14k3/raphael-kernel-build` | `3403ed0d17c1d9c4b9834539eab789343b9b4693` 后的工作区 | 补丁、测试、文档和 CI |
| 小米原厂 | `MiCode/Xiaomi_Kernel_OpenSource`，`F:\linux\vendor-sm8150-reference` | `cepheus-q-oss`，`192eca8550f95c2eec58a474793d1d93fc1b3b67` | SM8150/VPU5 协议、资源、顺序的主参考 |
| postmarketOS | 本地 remote `pmaports/v7.0.0-sm8150` | `8e126dbc4044ef2cec3ebe5754ddb05faa554af6` | 只作旁证；该分支并没有一套完整可工作的 SM8150 Venus 迁移 |
| 前向主线旁证 | 本地 `origin/raphael-7.2` | 本地已有分支 | 识别 7.1 之后的通用修正，不能替代原厂语义 |

小米树的实现位于 `drivers/media/platform/msm/vidc`，当前树位于
`drivers/media/platform/qcom/venus`。两者架构、对象生命周期、用户 ABI 和文件拆分
都不同，不存在可信的文件对文件直接 diff。本文采用“原厂行为 → 当前语义落点”核对，
而不是把 Android 私有驱动整目录拷进主线。

### 1.2 逐行覆盖证明

Test15 相对固定基线的最终合并差异为：

- 19 个文件；
- 173 个合并后 diff hunk；
- 2010 行新增、305 行删除；
- 完整原始 diff：`docs/venus-sm8150-test15-vs-base-full.diff`；
- diff SHA256：`207d3af2438927abd9ff3224b3828763b4558de55e775e1e9845e1c23d782aca`
  （LF 规范化，可直接 `git apply`）；
- 逐 hunk 审阅台账：`docs/venus-sm8150-test15-hunk-ledger.md`；
- 小米原厂 42 文件、39,111 个物理行、686 个 C 函数定义、5,512 个连续审阅区间：
  `docs/venus-sm8150-vendor-line-ledger.md`；
- Test15 当前 Venus 36 文件、21,388 个物理行、506 个 C 函数定义、3,014 个连续审阅区间：
  `docs/venus-sm8150-current-line-ledger.md`。

完整性反向校验也已通过：`patches/series` 的 17 个补丁在临时 Git index 中从固定基线
依次应用成功，19/19 个目标文件的最终 blob 与 `F:\linux\test15-analysis` 完全相同；
从该工作树以 `--binary --full-index` 重建的 LF diff 与本文 raw diff 字节一致；raw diff
也能在只含固定基线的临时 index 中通过 `git apply --cached --check`。

“每一条增删行”由完整 diff 保存；台账为 001--173 每个 hunk 给出语义、原厂对应面、
实机状态和遗留风险。两份文件合起来才是全量逐行 review。单看本文摘要不能替代原始
diff，也不能把补丁系列中互相覆盖的 254 个中间 hunk 误算为最终代码的 254 个 hunk。
原厂和当前两份台账都强制每个文件的覆盖行数等于实际物理行数；缺文件、缺行、重叠或
没有文件级处置策略都会使生成失败。生成器分别为
`scripts/generate-venus-vendor-line-ledger.ps1` 和
`scripts/generate-venus-current-line-ledger.ps1`。因此审计有三条闭合证据链：原厂每行向
当前映射、当前每行向原厂反查、Test15 相对基线的每条实际增删行。

### 1.3 状态词

| 状态 | 含义 |
|---|---|
| 已实机通过 | 有明确命令、输出和/或逐帧校验 |
| 静态对齐 | 线协议/字段/顺序与原厂一致，但尚未覆盖全部硬件场景 |
| 部分通过 | 一段链路已证实，不能外推到完整功能 |
| 未实现 | 原厂存在、当前无等价能力 |
| 未证实 | 是合理候选，但当前证据不足以称为根因 |
| 已排除 | 当前证据已否定为本次故障边界，不应重复测试 |

## 2. 结论先行

### 2.1 当前实际能力，不按节点枚举夸大

| 功能 | Test15 事实 | 结论 |
|---|---|---|
| H.264 8-bit 解码 | 30/30 帧，硬件与软件逐帧 MD5 完全一致 | 已实机通过 |
| HEVC Main 8-bit 解码 | MKV 样本 30/30 帧 | 已实机通过；证明 MKV 容器本身不是根因 |
| HEVC Main10 解码 | 内核识别 Main10，source-change 切到 P010，固件回收首个 P010 capture；FFmpeg/mpv 报 invalid frame、输出 0 帧 | 内核到用户态的 P010 协商/布局仍不完整 |
| VP8/VP9/MPEG2 解码 | 设备枚举与原厂能力表都支持 | 未做像素级实机矩阵，不能称可用 |
| VC1/MPEG4/H263/Xvid 解码 | 通用数组里存在，但 SM8150 原厂能力表不列这些 decoder codec | 不应按数组宣称支持；需以固件 capability 过滤结果为准 |
| H.264 编码 | Stage 0--8 通过；Stage 9 首个 ETB 后整机卡死重启，无输出帧 | 不可用，默认安全门必须保持关闭 |
| HEVC/VP8 编码 | 原厂 SM8150 能力表列出；当前尚未越过 H.264 首 ETB | 不可测试，更不能称支持 |
| TME 编码 | 原厂专有能力 | 主线无对应通用 ABI；暂不迁移 |

容器不是 Venus 的输入概念。MP4/MKV 先由 FFmpeg、mpv 或 VLC 的 demuxer 拆成 H.264、
HEVC、VP9 等压缩 packet，Venus 只看 elementary stream。现在表现为“MP4 正常、很多
MKV 不正常”的真正区分主要是：已经通过的 MP4 是 H.264 8-bit，失败的真实 MKV 是
HEVC Main10/P010；同样的 MKV 容器装 HEVC Main 8-bit 已通过。

### 2.2 两个最高优先级缺口

1. **Main10/P010 跨层协议缺口**：当前 HFI4/IRIS1 路径完全跳过
   `UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO`，而原厂对 P010 明确发送两个颜色
   plane 的 256-byte stride、32/16 scanline 和 256-byte buffer alignment 约束。
   当前又在 source-change 后强制 V4L2 CAPTURE 为单 memory-plane P010。固件输出首块
   buffer 后，FFmpeg 看到的格式/stride/有效载荷组合被判为 invalid frame。这个是
   最强的静态缺口，但仍需一次完整 `G_FMT/REQBUFS/QUERYBUF/DQBUF` 证据闭环，不能再
   简化成“FFmpeg 7.1 没有 P010 映射”。
2. **encoder 首 ETB 硬件读取边界**：内部 scratch/persist、LOAD、START、四个 FTB 均
   已通过；首个 raw NV12 ETB 入队后无任何 EBD/FBD，设备直接复位。线包字段顺序、
   route=2、VBR work-mode=2、MVS0、RC timestamp、32-bit IOVA、FTB-before-ETB 已静态
   对齐或实机排除。剩余优先检查 raw input 的 IOMMU 可见性、DMA 映射方向/同步和原厂
   精确 alloc-size 语义，而不是再随机补属性。

## 3. 原厂 42 个文件到当前主线的语义映射

下面每个原厂文件都已纳入范围。“保留 Android 专属”不等于没看，而是经过审计后不应
直接迁移到主线 ABI。

| 原厂文件 | 原厂职责 | 当前落点/迁移结论 |
|---|---|---|
| `Kconfig` | vendor driver 入口 | 当前 `qcom/venus/Kconfig`；不并存第二套驱动 |
| `Makefile` | 模块组合 | 当前 `qcom/venus/Makefile`；保持 dec/enc/core 模块化 |
| `governors/Kconfig` | 私有 governor 开关 | 主线无直接等价；只迁移可证明的带宽模型 |
| `governors/Makefile` | governor 构建 | 同上 |
| `governors/fixedpoint.h` | 定点估算辅助 | 如移植动态投票，应改为主线 helper/64-bit 算术，不整文件搬运 |
| `governors/msm_vidc_ar50_dyn_gov.c` | AR50/VPU5 带宽模型 | 当前完全缺失；`sm8150_res` 仍复用 SDM845 静态表，是明确遗留 |
| `governors/msm_vidc_dyn_gov.c` | DDR/LLCC 动态投票 | 当前 `pm_helpers.c` + interconnect，只覆盖简化路径 |
| `hfi_packetization.c` | HAL→HFI packetizer | 当前 `hfi_cmds.c`；属性 ID、payload、ETB/FTB 逐项核对 |
| `hfi_packetization.h` | packetizer API | 当前 `hfi_cmds.h` |
| `hfi_response_handler.c` | HFI 消息解析与回调 | 当前 `hfi_msgs.c`、`hfi.c`；扩展编码统计仍未消费 |
| `msm_cvp.c` | CVP 会话 | 当前 Venus 不公开 CVP；MVS1 只作为共享供电资源，不能冒充第二 codec core |
| `msm_cvp.h` | CVP API | 不迁移 Android CVP ABI |
| `msm_smem.c` | dma-buf 映射、cache sync、context bank | 当前 VB2 dma-contig + DMA API + DTS IOMMU；encoder 首 ETB 的重点复核面 |
| `msm_v4l2_private.c` | Qualcomm 私有 V4L2 控件映射 | 优先映射到标准 V4L2 控件；不批量复制私有 ABI |
| `msm_v4l2_private.h` | 私有 UAPI 常量 | 不污染主线 UAPI；只有确无标准表达且有用户时再单独设计 |
| `msm_v4l2_vidc.c` | ioctl/queue 桥接 | 当前 `vdec.c`、`venc.c`、VB2/M2M core |
| `msm_vdec.c` | decoder formats、controls、event | 当前 `vdec.c`、`vdec_ctrls.c` |
| `msm_vdec.h` | decoder 声明 | 当前 `vdec.h`/`core.h` |
| `msm_venc.c` | encoder formats、controls、启动配置 | 当前 `venc.c`、`venc_ctrls.c`；首 ETB 仍失败 |
| `msm_venc.h` | encoder 声明 | 当前 `venc.h`/`core.h` |
| `msm_vidc.c` | 设备/实例、格式与颜色映射 | 当前 `core.c`、`helpers.c`、`vdec.c`、`venc.c` |
| `msm_vidc.h` | 顶层接口 | 当前 `core.h` 及各模块头文件 |
| `msm_vidc_clocks.c` | clock/bus/DCVS/core 选择 | 当前 `pm_helpers.c`；动态 DDR/LLCC 投票未完整迁移 |
| `msm_vidc_clocks.h` | 投票接口 | 当前 `pm_helpers.h` |
| `msm_vidc_common.c` | 会话状态机、buffer 生命周期、工作模式 | 当前 `helpers.c`、`hfi.c`、`vdec.c`、`venc.c` |
| `msm_vidc_common.h` | 公共接口 | 当前 `helpers.h`、`hfi.h` |
| `msm_vidc_debug.c` | debugfs、日志、SSR 取证 | 当前 HFI dump 只补了关键诊断；完整统计/debugfs 不应作为功能前置条件 |
| `msm_vidc_debug.h` | debug 宏 | 当前 `core.h`/`hfi_venus.c` 的标准日志 |
| `msm_vidc_internal.h` | 核心/实例/format/control 数据结构 | 当前 `core.h`；字段必须按语义迁移，不能照布局复制 |
| `msm_vidc_platform.c` | SM8150 codec/能力/平台数据 | 当前 `core.c` + firmware capability parser；这里确认 SM8150 codec 真值 |
| `msm_vidc_res_parse.c` | DTS 资源解析 | 当前 DT binding、`core.c`、`pm_helpers.c` |
| `msm_vidc_res_parse.h` | 资源解析 API | 当前无需 vendor parser |
| `msm_vidc_resources.h` | clock/bus/context bank 描述 | 当前 `core.h`、DT binding、interconnect/power-domain framework |
| `venus_boot.c` | 固件装载与启动 | 当前 `firmware.c`、`hfi_venus.c`；Raphael 使用 `.mbn` 已实机启动 |
| `venus_boot.h` | boot API | 当前 `firmware.h`/HFI 层 |
| `venus_hfi.c` | queue、IRQ、power collapse、命令传输 | 当前 `hfi_venus.c`、`hfi_venus_io.h`；Test7 起补了 IRIS1 分支 |
| `venus_hfi.h` | Venus HFI 私有结构 | 当前 `hfi_venus.h` |
| `vidc_hfi.c` | HAL/HFI 设备抽象 | 当前 `hfi.c`、`hfi_venus.c` |
| `vidc_hfi.h` | 抽象接口 | 当前 `hfi.h`、`hfi_venus.h` |
| `vidc_hfi_api.h` | HAL 属性/结构定义 | 当前 `hfi_helper.h`、`core.h`、标准 V4L2 controls |
| `vidc_hfi_helper.h` | wire protocol ID/packet struct | 当前 `hfi_helper.h`；数值和 packed payload 是强对齐面 |
| `vidc_hfi_io.h` | VPU5 寄存器 | 当前 `hfi_venus_io.h`；只移植 IRIS1 确需的寄存器行为 |

### 3.1 原厂 SM8150 平台真值逐项核对

原厂 `msm_vidc_platform.c` 的 `sm8150_codec_data` 不是“可能支持”列表，而是该 BSP 给
SM8150/VPU5 的明确能力输入。当前最终仍要以固件 SYS_INIT capability 为准，但不得把
通用 `vdec_formats`/`venc_formats` 里别的 SoC codec 当成 SM8150 能力。

| 原厂项 | 原厂值 | 当前状态与迁移结论 |
|---|---:|---|
| H.264 encoder | min 10、max 675、VPP 320 cycles/MB | codec 可枚举；首 ETB 复位，功能不可用 |
| HEVC encoder | 10/675/320 | 原厂明确支持；必须等 NV12 H.264 稳定后再开 |
| VP8 encoder | 10/675/320 | 原厂明确支持；当前未越过 H.264 首 ETB |
| TME encoder | 0/540/540 | Qualcomm 私有工作流，无主线通用消费者，不迁移 |
| MPEG2 decoder | 10/200/200 | 原厂明确支持；当前尚无逐帧实机准入 |
| H.264 decoder | 10/200/200 | 30/30 且逐帧 MD5 一致，已通过 |
| HEVC decoder | 10/200/200 | Main 8-bit 已通过；Main10/P010 未通过 |
| VP8 decoder | 10/200/200 | 原厂明确支持；当前尚无逐帧实机准入 |
| VP9 decoder | 10/200/200 | 原厂明确支持；Profile 0/2、8/10-bit 均需实测 |
| VPU generation | `VPU_VERSION_5` | 当前 `VPU_VERSION_IRIS1 + HFI_VERSION_4XX`，正确；不能参考成 SDM845 VPU3 |

`sm8150_common_data` 的所有条目也逐项处理如下：

| 原厂 key | 值 | 当前等价/缺口 |
|---|---:|---|
| `never-unload-fw` | 1 | 当前 runtime suspend 不卸载 firmware image，行为基本等价 |
| `sw-power-collapse` | 1 | HFI power-collapse + runtime PM 已实现并实机回到 suspended |
| `domain-attr-non-fatal-faults` | 1 | 当前无明确等价平台策略；不能靠吞掉 IOMMU fault 模拟 |
| `max-secure-instances` | 3 | secure-session 用户 ABI/内存分类未迁移，因此此限制也未实现 |
| `max-hw-load` | 3916800 | 当前 `sm8150_res.max_load` 已对齐 |
| `max-hq-mbs-per-frame` | 8160 | 当前无同名平台门；部分由 firmware capability/control 限制，需验证 |
| `max-hq-mbs-per-sec` | 244800 | 同上；不能只靠总 `max_load` 代替质量模式限制 |
| `max-b-frame-size` | 8160 | 当前 encoder control 有 B-frame，但 SM8150 专用上限未单列 |
| `max-b-frames-per-sec` | 60 | 未单列；开放 encoder 前需 capability/负载双重校验 |
| `power-collapse-delay` | 1500 ms | 父设备已对齐 1500 ms；dec/enc 子设备仍各用通用 2000 ms，需明确生命周期意图 |
| `hw-resp-timeout` | 1000 ms | 当前 HFI 命令等待和 power-collapse 等待均为 1000 ms，等价 |
| `debug-timeout` | 0 | 当前没有同名运行时策略；debug 不应成为功能依赖 |
| `domain-cvp` | 1 | MVS1/CVP 供电资源存在，但不公开 CVP codec 会话，正确 |
| `decode-batching` | 1 | wire struct 存在，主线 decoder 没有完整 vendor batching 策略；未迁移 |
| `dcvs` | 1 | 有通用频率缩放；原厂 recon/UBWC 驱动的完整 DCVS/带宽闭环缺失 |
| `fw-cycles` | 760000 | 未作为 SM8150 专用平台常量迁移；目前频率模型使用主线简化公式 |
| `fw-vpp-cycles` | 166667 | 同上；应与实际 firmware capability/负载 trace 共同校准 |

### 3.2 原厂设备树相关行的完整处置

原厂 Venus DTS 直接来源为 `sm8150-vidc.dtsi` 1--139 行，以及 `sm8150-v2.dtsi`
367--383 的 v2 覆盖。它们按连续区间全部核对如下：

| 原厂行 | 内容 | 当前主线状态 |
|---:|---|---|
| `sm8150-vidc.dtsi:1--16` | 版权和 GIC/msm-bus/video-cc include | 构建框架差异，不迁 vendor msm-bus binding |
| `17--23` | 节点、compatible、2 MiB reg、IRQ174 | compatible/IRQ 一致；当前 reg 为 1 MiB，已有访问未越界，新增高 offset 前再扩 |
| `24--27` | LLCC VIDSC0/VIDSC1 | 当前 DT + LLCC API 已激活并交给 firmware |
| `28--32` | iris-ctl/MVS0/CVP supplies | 当前 VENUS/VCODEC0/VCODEC1/MMCX power-domain 等价表达 |
| `33--46` | AXIC/AXI0/AXI1、MVSC/MVS0/MVS1 clocks 与 proxy flags | 当前七路 clock 全部建模；hardware-control 交接由 IRIS1 PM ops 完成 |
| `47--56` | 四个 reset、hw-control flags、v1 频率 | reset 全部对齐；Raphael 用 v2 240/338/365/444/533 MHz，不用 v1 480 MHz 顶点 |
| `58--91` | CNOC、Venus-DDR、ARM9-DDR、Venus-LLCC 四条 bus | 当前仅 `video-mem`/`cpu-cfg` ICC，动态 DDR/LLCC governor 是明确缺口 |
| `93--101` | non-secure CB、SID 0x1300、0x25800000--0xe0000000 VA | v2 改 SID 0x2300；当前 DMA mask 与 non-secure 流匹配，解码已过 |
| `103--131` | 三个 secure CB、buffer type、VA pool | 当前列出 v2 SID，但 secure buffer 分类/会话/UAPI 未实现 |
| `133--139` | CDSP memory heap | 属于 CVP/私有路径，不迁普通 V4L2 codec |
| `sm8150-v2.dtsi:367--370` | v2 频率覆盖 | 当前 OPP 与 `sm8150_freq_table` 精确采用 240/338/365/444/533 MHz |
| `371--383` | v2 non-secure/secure SIDs 0x2300/01/03/04 | 当前 DT 四组 SID 数值一致；普通 encode/decode 使用 non-secure 0x2300 |

### 3.3 其他代码线的全量旁证结论

| 代码线 | 相对本基线 | 可采用 | 不能据此推断 |
|---|---|---|---|
| postmarketOS `v7.0.0-sm8150` | Venus 7 文件，+5/-115；只剩 `VPU_VERSION_IRIS1` 枚举/宏，SM8150 resource/match 被删 | 证明该 tag 不是遗漏适配的现成答案 | 不能当作“pmOS 已完整支持 SM8150 Venus” |
| 本地 `origin/raphael-7.2` | Venus 13 文件，+252/-179 | `e1c9adabb268` 去除 NV12 多余 padding；power-domain/blacklist/parser 等通用演进可回看 | 不能替代小米 VPU5/HFI4 线协议；也不能把所有 7.2 改动整包回灌 |
| Linux 7.1 当前基线 | NV12 128x96 `alloc_len=32768` | 已有稳定 decoder 与主线 VB2 ownership | 不能据此证明 encoder raw DMA 对 firmware 可见 |
| 小米原厂公式 | NV12 128x96 `alloc_len=24576` | encoder size A/B 的第一候选 | 大小差异本身还不是复位根因 |
| 本地 7.2 公式 | NV12 128x96 `alloc_len=20480` | 说明当前 7.1 确有额外 padding | 不能把“更新公式”直接等同于修好首 ETB |

## 4. Test15 最终 19 文件审计摘要

详细到每个 hunk 的结果在台账中。这里给出文件级结论和后续处置。

| 文件 | 最终增删 | Hunk | 审计结论 |
|---|---:|---:|---|
| `sm8150-xiaomi-raphael.dts` | +1/-1 | 001 | `.mbn` 与实际固件匹配，已通过；DTS 其余资源来自 SoC dtsi |
| `panel-samsung-ams639rq08.c` | +94/-21 | 002--012 | 与 Venus 无关；LP+250 ms 合并使直接 sysfs 压力通过，但 GNOME/音量仍触发 GPU fault，必须拆分维护 |
| `core.c` | +72/-13 | 013--021 | IRIS1 runtime PM、IRQ、单 codec core、固件名；解码和 idle 已通过 |
| `core.h` | +48/-0 | 022--029 | IRIS1 资源状态、bufreq cache、staged 调试状态；后续产品化要移除测试 gate 字段 |
| `helpers.c` | +453/-56 | 030--057 | codec 映射、内部 DMA、bufreq、route/mode、stage、队列；编码首 ETB 仍有未决 DMA 语义 |
| `helpers.h` | +3/-0 | 058--060 | 对应 helper 声明，静态一致 |
| `hfi.c` | +34/-38 | 061--066 | 统一 codec 映射、超时 dump、IRIS1 状态机；无新线协议缺口 |
| `hfi_cmds.c` | +67/-3 | 067--078 | LLCC、HFI4 count_min_host、WORK_ROUTE、FRAME_QP、ETB reserve；线包重点已核对 |
| `hfi_cmds.h` | +3/-0 | 079 | syscache packetizer API |
| `hfi_helper.h` | +26/-1 | 080--086 | VPU5 属性/资源/结构；仍需避免把 vendor HAL 枚举误作标准 ABI |
| `hfi_msgs.c` | +27/-18 | 087--089 | 固件版本、bufreq 越界、双长度消息；修正合理，扩展 encoder done 统计仍未解析 |
| `hfi_venus.c` | +312/-45 | 090--113 | ring 防御、诊断、LLCC、IRIS1 suspend/resume；已改善启动，但调试日志应在稳定版降噪 |
| `hfi_venus.h` | +1/-0 | 114 | dump 声明 |
| `pm_helpers.c` | +335/-9 | 115--125 | IRIS1 电源/时钟/LLCC/OPP；启动和 runtime PM 通过；带宽表仍是 SDM845 |
| `pm_helpers.h` | +1/-1 | 126 | PM selector 接收 core 以选择 IRIS1 ops |
| `vdec.c` | +92/-29 | 127--138 | P010/bit-depth/source-change；Main8 通过，Main10 仍跨层失败，枚举与当前 bit-depth 不完全一致 |
| `vdec_ctrls.c` | +12/-1 | 139--142 | HEVC Main/Main10 volatile profile；只覆盖 profile，tier/level/color/HDR 能力仍不完整 |
| `venc.c` | +389/-62 | 143--164 | 原厂顺序、属性、两次 bufreq、PM pin、stage；Stage9 首 ETB 复位，默认必须关闭 |
| `venc_ctrls.c` | +40/-7 | 165--173 | IRIS1 默认值和 all-layer bitrate；open 已修复，功能未通过 |

## 5. SM8150 资源、电源和固件差异

### 5.1 已对齐并经实机覆盖

- 固件为 `qcom/sm8150/Xiaomi/raphael/venus.mbn`，版本
  `VIDEO.IR.1.2-00045-PROD-1`；加载和 SYS_INIT 成功。
- SM8150 是 VPU5/IRIS1、HFI 4xx，不是 SDM845 的 VPU3，也不是新 Iris driver。
- MVS0 承担普通 encode/decode；MVS1 是 CVP 资源。`vcodec_num=1` 正确，不能为了
  “有两个 core clock”把普通会话路由到 MVS1。
- `iris-ctl`/MVSC、MVS0、CVP 三个 power domain 在固件启动前持有；对应 core、
  vcodec0、vcodec1 clock 都开启后，再把 MVS0/MVS1 交给硬件控制。
- LLCC VIDSC0/VIDSC1 获取、激活并通过 HFI `HFI_RESOURCE_SYSCACHE` 交给固件。
- 量产 v2 的有效频率阶梯是 240/338/365/444/533 MHz；533 MHz 与原厂
  `sm8150-v2` 一致，不是错误超频。原厂通用 v1 的 225/300/365/432/480 MHz 不能
  单独代表 Raphael 实机。
- autosuspend 1500 ms 与原厂 collapse timeout 策略一致；解码后主设备和两个
  video core 均能回到 `suspended`。

### 5.2 仍未完整迁移

- `sm8150_res.bw_tbl_enc/dec` 仍直接指向 `sdm845_bw_table_enc/dec`。这是明确的 SoC
  数据错配，而不是命名问题。原厂 SM8150 使用独立 DDR/LLCC 动态 governor，含
  codec、分辨率、帧率、work-route、UBWC/recon 统计等输入。短片能跑不代表带宽在
  1080p/4K、多实例、VP9/Main10 或 encoder 下正确。
- 主线 DTS 只提供 `video-mem` 与 `cpu-cfg` 两条 interconnect；原厂还区分 CNOC、
  Venus-DDR、ARM9-DDR 和 Venus-LLCC。迁移时应先建立可审阅的 SM8150 bandwidth
  计算和主线 interconnect 映射，不要把 vendor msm-bus API 整体搬回。
- 原厂通用节点 `reg = 0xaa00000 + 0x200000`，当前主线为 0x100000。现有访问均落在
  已映射范围且固件能启动；没有越界证据，不能只为“看起来一样”扩到 2 MiB。若后续
  移植新寄存器，必须先核对 offset 再调整 DT binding。
- 原厂有 secure/non-secure 四个 context bank 及独立 virtual address pools；当前
  DT 给父设备四个量产 v2 SID（0x2300/01/03/04）和通用 DMA mask。非安全解码正常，
  但 secure-session ABI、buffer classification 和内存保护没有迁移，不能宣称 DRM/
  protected playback。
- 原厂有 software power collapse、never-unload-fw、non-fatal domain fault、max
  secure sessions、decode batching/DCVS 等平台属性；当前只实现了启动所需子集。

## 6. HFI 4xx 线协议审计

### 6.1 已确认相同

- SESSION_INIT 的 session type 和 codec 数值；WORK_ROUTE/WORK_MODE/core usage。
- `BUFFER_COUNT_ACTUAL` 的 HFI4 payload 包含 `type/count_actual/count_min_host`；
  Test15 已不再把 host minimum 错写为 actual。
- 内部 buffer type：persist=4、persist1=5、scratch0/1/2=6/7/8、recon=9。
- SET_BUFFERS/RELEASE_BUFFERS 的 type、size、count 和 32-bit device address 布局。
- encoder ETB 的 view/timestamp/flags/mark/offset/alloc/filled/tag/packet/extradata/address
  字段顺序与宽度；FTB 的 stream/offset/alloc/filled/tag/address 字段也相同。
- LOAD_RESOURCES → START；停止路径 STOP → RELEASE_RESOURCES → internal release →
  SESSION_END 的核心约束。
- H.264/H.265 Annex-B NAL start-code 属性、VPE rotation、bitrate savings、VPU5 frame
  QP、all-layer bitrate、RC timestamp 等已补相应 packetizer。

### 6.2 仍存在的协议/消息功能缺口

- 原厂 encoder EBD 扩展尾部带 flags、recon/UBWC 统计和 sync picture type；当前只读
  公共前缀。它不是“首 ETB 完全无响应”的根因，但会影响稳定多帧、动态带宽、统计和
  某些 buffer 生命周期决策。
- decoder 的 profile/tier/level、colorimetry、HDR/extradata、interlace、concealment、
  output-order 等原厂能力只迁移了一小部分标准控制。Main10 的 profile 已有，完整
  metadata/色彩语义没有。
- HFI queue 防御性校验和 debug peek 属于健壮性增强；不能把日志增加本身当协议适配。
- `HFI_BUFFER_TYPE_MAX` 扩到覆盖 recon 是正确越界修复，但 recon 在 encoder 中是统计
  bookkeeping，不应误分配静态 DMA。

## 7. 解码全量差异

### 7.1 Codec 与像素格式

原厂 SM8150 decoder capability 明确列出 MPEG2、H.264、HEVC、VP8、VP9；当前
`vdec_formats` 的 compressed 数组还含 VC1 G/L、MPEG4、H263、Xvid。最终枚举应以
固件 `codec_caps` 为准，数组存在只代表通用驱动认识 fourcc，不能作为 SM8150 支持
证据。

原厂 capture 格式包括线性 NV12、线性 P010、NV12 UBWC、TP10 UBWC；当前公开
NV12、QC08C、QC10C、P010。名字可以不同，但要分别核对：

- HFI color format 数值；
- V4L2 memory planes 与 HFI color planes 的区别；
- bytesperline、scanline、sizeimage、data_offset、bytesused；
- modifier/压缩格式能否被桌面图形栈消费；
- source-change 时旧 buffer 的归还与新 buffer 的重新分配。

### 7.2 Main10/P010 失败链

已证实的顺序是：

1. HEVC Main10 packet 进入 `/dev/video*` 的 Venus decoder；
2. 固件报告 `bit_depth=0x20002`、profile Main10；
3. 驱动把 capture 切为 fourcc `P010`（`0x30313050`）；
4. 320x240 日志曾显示 `sizeimage=294912`、`bytesperline=768`，首个 capture 的
   `bytesused=245760`；说明固件至少已经写回并完成一个 buffer；
5. FFmpeg 7.1 的 `hevc_v4l2m2m` 请求日志仍显示 `capture=NV12/yuv420p10le`，随后
   报 `An invalid frame was output by a decoder`，0 帧；mpv 指定同一 decoder 复现。

这不是“MKV 不支持”，也不能只怪用户态。当前内核还有两个明确不一致：

- `venus_helper_set_format_constraints()` 对非 HFI6 直接返回，因此 HFI4 IRIS1 的
  P010 从未收到原厂的 plane actual constraints；
- `find_format()` 按当前 bit depth 过滤 S/TRY_FMT，`find_format_by_index()` 却取消了
  同样的 bit-depth 过滤。于是 ENUM_FMT 可以展示当前流暂不能选的格式，S_FMT 又可能
  回退成另一个格式，用户态探测顺序会影响结果。

下一次实现必须把以下变化放在同一内核中但由日志完整区分：

1. 仅当 IRIS1 + P010 时发送 HFI4 plane actual constraints：两个 HFI 颜色 plane，
   stride multiple 256、max 8192、Y height multiple 32、UV 16、alignment 256；不能对
   线性 NV12照搬。
2. 统一 ENUM_FMT、TRY_FMT、S_FMT 和 source-change 的 bit-depth/format 选择规则；在
   位深未知时可枚举 capability，位深已知后不能返回自相矛盾结果。
3. source-change 后打印并保存 G_FMT、REQBUFS count、每个 QUERYBUF length、首个 DQBUF
   bytesused/data_offset/flags；确认 userspace 是否真的重建了 P010 capture queue。
4. 分别测试 FFmpeg framemd5 和原始 `v4l2-ctl` streaming。前者失败而后者数据布局正确，
   才能把剩余责任收敛到 FFmpeg/mpv；两者都失败则继续修内核。

### 7.3 仍需覆盖的 decoder 矩阵

- H.264：Baseline/Main/High，720p/1080p/4K，B-frame、interlace、分辨率切换、flush、
  seek/reopen、损坏码流。
- HEVC：Main 8-bit 与 Main10，720p/1080p/4K，P010 与 QC10C，HDR metadata。
- VP8/VP9：Profile 0；VP9 Profile 2 10-bit 要验证 TP10/P010 输出和固件实际 profile。
- MPEG2：progressive/interlaced；原厂 route 选择对 MPEG2 与 H.264 interlace 有特殊分支。
- 多实例、长时播放、runtime suspend/resume、播放器退出、窗口缩放、GNOME 合成压力。

## 8. 编码全量差异

### 8.1 原厂可支持面与当前公开面

原厂 SM8150 codec table：encoder H.264、HEVC、VP8 和 TME；decoder MPEG2、H.264、
HEVC、VP8、VP9。当前 `venc_formats` 公开 raw input 仅 NV12，compressed output 数组为
H.264、VP8、HEVC、MPEG4、H263；固件 capability 应过滤掉 SM8150 不支持的 MPEG4/
H263 encoder。

原厂 encoder raw input 还包括 NV12 UBWC、NV21、TP10 UBWC、P010、NV12_512。为了
“尽可能多支持”不能一次把这些 fourcc 全公开：每加一个格式必须同时具备主线 fourcc/
modifier、正确 size/stride、HFI constraint、DMA mapping 和用户态可生产能力。第一阶段
应先让线性 NV12 的 H.264 单帧/多帧稳定，再扩 HEVC/VP8；10-bit raw 输入最后做。

### 8.2 原厂启动顺序与当前对齐结果

| 阶段 | 原厂 | Test15 | 结论 |
|---:|---|---|---|
| 1 | SESSION_INIT，初始 IO count 4/4 | 相同 | Stage0 通过 |
| 2 | rotation + controls/internal config | 已按顺序发送 | Stage0 通过；属性本地封包无错 |
| 3 | WORK_ROUTE、WORK_MODE、core/power | route2、VBR mode2、MVS0 | 实机对齐 |
| 4 | 第一次 GET_BUFFER_REQUIREMENTS | 有严格缓存/校验 | 通过 |
| 5 | 最终 actual/host-min + compressed output size | 有 | 通过 |
| 6 | 第二次 GET_BUFFER_REQUIREMENTS | 有，使用新鲜表 | 通过 |
| 7 | scratch0/1/2、persist0，persist1 条件跳过；recon 只建索引 | scratch/persist 对齐；recon 不分配 | Stage1--5 通过 |
| 8 | clock/bus、LOAD、START | 相同关键顺序 | Stage6--7 通过 |
| 9 | 先 FTB，再 ETB | 四个 FTB 后第一 ETB | FTB 通过；第一 ETB 导致复位 |

### 8.3 固件实际 buffer requirements

128x96 H.264 测试的最终表：

| HFI type | 含义 | size | actual/min/host | 对齐与处理 |
|---:|---|---:|---|---|
| 1 | encoder raw input | 18432 | 16/3/0 | V4L2 actual=16，host-min=3 |
| 2 | compressed output | 36864 | 4/4/0 | V4L2 实际分配 73728，是保守过量 |
| 4 | persist0 | 64768 | 1/1/0 | 原厂页对齐后 SET 65536 |
| 6 | scratch0 | 198400 | 1/1/0 | SET 200704 |
| 7 | scratch1 | 233056 | 1/1/0 | SET 233472 |
| 8 | scratch2 | 118784 | 1/1/0 | 已 4 KiB 对齐 |
| 9 | recon | 28672 | 1/1/1 | 只建统计索引，不静态 SET_BUFFERS |

Stage1--5 已证明上述四类内部 DMA 的 SET/RELEASE 安全；Stage6/7 证明 LOAD/START/
STOP/RELEASE；Stage8 证明四个 73728-byte FTB IOVA 可交给固件且不会立即复位。

### 8.4 首 ETB 证据与已排除项

最后一次完整边界证据为：

`ETB tag=0 dma=0xdf498000 alloc=32768 filled=18432 offset=0`

随后无 ETB_DONE、FTB_DONE 或正常 cleanup，整机重启。以下不再重复猜测：

- Stage0--8；
- WORK_ROUTE=2、VBR WORK_MODE=2、MVS0 core；
- RC timestamp disable（Test15 已发值 1，Stage9 仍重启）；
- HFI4 ETB/FTB 字段顺序和 packet size；
- FTB-before-ETB；
- scratch/persist SET/RELEASE、LOAD/START；
- 32-bit 截断（该 IOVA 小于 DMA mask 上限且通过上 32 位检查）；
- “recon 少分配一块静态 DMA”；原厂 recon 在这里不是静态 buffer。

### 8.5 仍必须解决的 encoder 差异，按优先级

#### P0：raw input DMA 可见性与精确大小

- 当前 7.1 的 NV12 size 公式在 128x96 得到 32768；原厂公式得到 24576；本地 7.2 的
  通用修正会得到 20480；三者 filled data 都是 18432。大 alloc_len 理论上合法，但
  它是现在最直接、仍未实机消除的 wire-visible 差异。
- 下一版只针对 IRIS1 encoder 把 alloc_len/sizeimage 与原厂或固件 requirement 建立
  明确规则，并打印 VB2 plane length、SG DMA length、DMA direction、domain、IOVA 区间。
  不得把 18432 `bytesused` 伪造为整块 alloc_len。
- 对比原厂 `msm_smem.c` 的 `DMA_BIDIRECTIONAL + explicit CLEAN_INVALIDATE` 与当前
  `DMA_TO_DEVICE + vb2_dma_contig.prepare()`。当前不是“完全没同步”，但首个 VPU read
  复位很像访问属性/映射问题。应做单一变量的诊断开关，不能把 size 和 DMA direction
  混成一个不可归因的测试。
- 记录 `iommu_group`、domain type、所有 SID 和发生复位前的 pstore/ramoops/remote
  kernel log。没有 fault 日志时不能宣称是 cache；没有 cache A/B 时也不能宣称是 IOMMU。

#### P1：encoder completion 与长序列能力

- 解析原厂扩展 EBD flags、recon/UBWC stats、sync picture type；先保持兼容较短消息，
  不得用扩展结构大小拒绝已有 firmware message。
- 把 recon index 与动态 bus/DCVS 接上，否则单帧即使通过，多帧/高码率也可能不稳定。
- output `sizeimage` 应基于最终 firmware requirement 设最小值，并允许用户分配更大；
  不能在 STREAMON 后偷偷改变已分配 buffer 的真实长度。
- 完整验证 EOS/drain/flush/STREAMOFF/error rollback，确保所有 DMA 在 firmware 停止后释放。

#### P2：扩展 codec/format

- H.264 NV12 稳定后再开 HEVC NV12、VP8 NV12；每个 codec 重新查询 capability、profile、
  level 和 buffer requirements，不能沿用 H.264 固定数值。
- P010/TP10/UBWC/NV21/NV12_512 raw input 需要各自格式约束和用户态路径；主线不能暴露
  vendor-only fourcc 后让通用程序按线性 NV12 解释。
- TME 属于 Qualcomm 私有工作流，没有主线通用消费者，优先级最低。

## 9. V4L2 controls 与原厂私有能力

当前主线 encoder 已有 bitrate/mode/peak、GOP、B-frame、H.264/HEVC QP、profile/level、
entropy、deblock、8x8 transform、header、intra refresh、multi-slice、LTR、VP8/VPX QP、
HDR10 CLL/mastering 等标准控制。decoder 有最小 capture buffers、display delay、conceal
color、H.264/HEVC/VP8/VP9/MPEG4 profile/level 的一部分。

原厂额外私有控制包含 secure/priority/operating rate/low latency/output order、各种
extradata、DPB 格式、10-bit conceal、ROI、blur、CSC、full range/primaries/transfer/
matrix、bitrate savings/type、VUI、hierarchical layers、私有 QP range、HDR10+、TME、
iframe size 等。迁移原则是：

1. 有标准 V4L2 control 的，映射标准 control 到相同 HFI 属性；
2. 有 DRM/colour/HDR 标准 metadata 的，走标准 buffer metadata 或 controls；
3. Android 私有 control 不是“支持 codec”的必要条件，不得批量塞入主线 UAPI；
4. firmware capability 必须决定 menu skip mask 和可写范围，不能只靠硬编码最大值；
5. 默认值与用户显式设置要区分。原厂很多属性只在 control 被设置时发送，主线是在
   STREAMON 汇总发送，不能仅比较命令数量判断缺失。

## 10. 当前补丁里需要产品化清理的内容

- `venus-test7/8/9/10/11/12/13/14/15` 日志标签应统一为 `sm8150-venus`，高频 packet
  日志移到 dynamic debug/tracepoint；错误摘要保留。
- `iris1_encoder` 和 0--9 stage 是防止硬复位的实验门，不是最终 ABI。编码真正通过
  长序列和错误恢复前默认 N；稳定后应删除 stage 分叉，仅保留合理的安全验证。
- `bufreq_cache` 必须有清晰的 generation/lifetime：任何改变 codec、format、count、
  size、profile 或 session 的操作都要失效；现在仅为 IRIS1 encoder 服务。
- 面板 brightness patch 与 Venus 完全独立。Venus 模块卸载后 GNOME 音量弹窗仍触发
  Adreno CCU translation fault 和 DPU hangcheck，已经证明不是 codec 资源冲突。后续应
  从 Venus 系列拆出，避免 codec review 被显示问题污染。
- Test15 文档中曾把 Main10 失败定性为“FFmpeg 7.1 缺映射”的句子必须废止。正确表述
  是内核/用户态 P010 协商与布局不一致，单边根因尚未证明。

## 11. 一次编译应包含的下一阶段实现包

为了减少 30 分钟编译次数，可以在同一内核加入多个**默认关闭、互相独立**的诊断开关，
但一次实机命令只改变一个变量：

1. Main10：HFI4 P010 constraints + 完整 format/buffer trace；这是正常功能修正，可默认开。
2. Decoder matrix：为 VP8/VP9/MPEG2/H.264/HEVC 提供统一低噪声 session summary，不改
   wire semantics。
3. Encoder size A/B：baseline、vendor-size、firmware-min 三种，只能选一种；默认安全锁。
4. Encoder DMA A/B：现有 VB2 direction 与 vendor-style diagnostic direction/sync 两种；
   与 size A/B 正交，实测时一次只切一维。
5. Persistent crash capture：在 queue ETB 前把所有关键结构写入预分配内存/trace buffer，
   并尽量配置 ramoops；普通 journal 来不及落盘，Test15 已证明这一点。
6. SM8150 bandwidth model 只先记录计算值，不立即改变 vote；确认与实际流匹配后再启用。

禁止再做：重跑 Stage0--8、把 Main10 假报 NV12、把 MVS1 当第二 codec、给 recon 分配
静态 DMA、一次同时改 ETB 布局/size/cache/route、看到 `/dev/video*` 就宣称支持。

## 12. 验证准入矩阵

每个 codec/profile 至少满足：非空输出、预期帧数、像素或可解码校验、无 HFI error、
无 IOMMU/GPU/DSI 连锁错误、退出后 runtime PM suspended。FFmpeg 返回 0 但 0 帧不算通过。

| 类别 | 最小验证 |
|---|---|
| 解码正确性 | 30 帧 framemd5 对软件参考；长片至少 10 分钟无丢帧/花屏 |
| Main10 | raw V4L2 + FFmpeg + mpv；记录四次格式 ioctl 和 buffer 元数据 |
| 动态分辨率 | 720p↔1080p source-change、capture 重建、无旧 buffer 泄漏 |
| 编码单帧 | 非空 Annex-B，ffprobe 识别，软件 decoder 解码成功 |
| 编码多帧 | 30/300/长时，IDR/GOP/bitrate，解码后帧数和尺寸正确 |
| Codec 矩阵 | H.264、HEVC、VP8 encode；H.264、HEVC Main/Main10、VP8、VP9、MPEG2 decode |
| 生命周期 | open/close、reopen、STREAMON/OFF、timeout、SIGTERM、错误 packet、suspend/resume |
| 性能 | 720p/1080p/4K、不同 fps、多实例；记录 freq/interconnect/温度/CPU |
| 桌面集成 | mpv/VLC/GStreamer；确认实际 decoder，不用“CPU 低”代替路径证据 |

## 13. 本轮明确不做的错误归因

- GNOME 亮度/音量闪屏是 Adreno/DPU/DSI 链路；卸载 Venus 后仍复现，与 UFS 速度也无
  直接证据关系。
- VA-API 是用户态 API，不是 Venus 编码器的同义词。内核 V4L2 M2M 正常也不会自动
  出现 VA-API；mpv/VLC 可以经 FFmpeg/GStreamer 的 V4L2 路径使用硬解。
- Vulkan/Adreno 640 与 Venus 是不同硬件栈；Vulkan 是否工作不能证明视频 codec。
- postmarketOS 分支相对本基线主要删除 SM8150 Venus resource/match，不是缺失实现的
  现成答案。

## 14. 审计后的固定决策

1. 先完成 Main10/P010 HFI4 constraints 与 ioctl/buffer 证据闭环。
2. encoder 不再补随机 control；下一次只围绕 raw input size 与 DMA 可见性做可区分 A/B。
3. H.264 encoder 产出有效单帧、300 帧并安全 STREAMOFF 前，不开放 HEVC/VP8 encoder。
4. 建立 SM8150 自有 bandwidth 数据，最终移除 SDM845 表复用。
5. 原厂 private ABI 只作语义参考；主线标准 ABI、VB2 ownership 和 PM lifetime 优先。
6. 所有新比较结果写回本文和 hunk 台账；已经排除的项目不再消耗实机重启。
