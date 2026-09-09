# SM8150 Venus 全量迁移主报告

> 本文是 `Test19 + 0001--0033` 候选树的权威总账。旧的 `venus-sm8150-full-migration-audit.md`
> 和 `venus-sm8150-encoder-audit.md` 保留历史过程，但不得用其中的阶段性判断覆盖本文。
> “已实现”只表示代码已进入候选补丁；没有实机证据时一律写成“待实机”，不宣称修复。
> 0027 已删除 Stage0--9，补回原厂 output-size minimum，并固定原厂 raw layout 与 DMA
> 方向；下文描述 Stage9 的段落是 Test13--15 历史证据，不代表当前仍有 stage 参数。

## 1. 目标、范围与审阅规则

本轮目标不是只修 H.264 单个样本，而是把小米 SM8150 Android 10 原厂 VIDC 的所有
硬件相关语义逐项映射到当前 Linux V4L2 Venus 架构，在不复制 Android 私有 ABI 的前提
下，尽可能完整地支持 SM8150 固件实际提供的编解码能力。当前优先阻断项是：

1. HEVC Main10/P010 已到达首个 capture completion，但 FFmpeg/mpv 判定为 invalid frame；
2. Test18 encoder 在 LOAD_DONE 后发出 START 但没有 START_DONE；日志证明 OUTPUT 提前提交 host-min=2、最终固件要求 min=4。0033 已改为 controls 后提交最终 count，并补原厂 upstream-cache mapping，待 Test19；
3. 0019 已移植 SM8150 动态 DDR/LLCC 模型，但尚未用实机 ICC/长序列/多实例验证；
4. Test16 VP8 在 source-change 后因 split-output count 契约偏差收到
   `HFI_ERR_SESSION_BAD_POINTER`；0030 已按原厂语义修正，待 Test17。
5. VP9、MPEG2 decoder 与 H.264/HEVC/VP8 encoder 尚无完整实机准入矩阵。

### 1.1 固定源码身份

| 角色 | 路径/提交 | 本报告用途 |
|---|---|---|
| Linux 固定基线 | `F:\linux\linux-raphael`，`58f3df07833f2382fe2fbc28f996c4c85817c1f6` | 主线 V4L2/VB2/PM 架构基线 |
| 当前候选源码 | `F:\linux\test15-analysis`，基线 + `patches/series` 0001--0033 | 本报告逐行反查对象 |
| 构建与证据库 | `F:\linux\raphael-kernel-build`，基准提交 `3403ed0d17c1d9c4b9834539eab789343b9b4693` 后工作区 | 补丁、生成器、测试和报告 |
| 小米原厂 | `F:\linux\vendor-sm8150-reference`，`192eca8550f95c2eec58a474793d1d93fc1b3b67` | SM8150/VPU5/HFI4 主参考 |
| 原厂源码树 | `drivers/media/platform/msm/vidc`，tree `1e66319e3b0a9e1ad7f59d624b4d58f5c0c67fc4` | 42 文件完整覆盖 |
| 后续主线旁证 | 本地 `origin/raphael-7.2` 和基线已有后续提交 | 只采通用修正，不替代原厂语义 |
| postmarketOS 旁证 | 本地 `v7.0.0-sm8150` 对应代码 | 已确认不是完整 SM8150 Venus 适配来源 |

原厂是 `msm/vidc`，当前是 `qcom/venus`。对象模型、文件拆分、buffer ownership、PM 和
UAPI 均不同，因此“逐行 review”是每一个连续代码区间都有语义处置，而不是把两个目录
按同一行号硬 diff。原厂原文、当前原文和实际补丁分别由三类台账闭合。

### 1.2 全量覆盖证明

| 证据 | 数量 | 文件 |
|---|---:|---|
| 原厂 VIDC 物理文件 | 42 | `venus-sm8150-vendor-line-ledger.md` |
| 原厂物理行 | 39,111/39,111 | 同上；无空洞、无重叠 |
| 原厂 C 函数定义 | 686/686 | 同上 |
| 原厂连续审阅区间 | 5,512 | 同上 |
| 当前 Venus 物理文件 | 36 | `venus-sm8150-current-line-ledger.md` |
| 当前物理行 | 22,143/22,143 | 同上；无空洞、无重叠 |
| 当前 C 函数定义 | 524/524 | 同上 |
| 当前连续审阅区间 | 3,079 | 同上 |
| Test15 相对基线最终差异 | 19 文件、173 hunk、+2010/-305 | `venus-sm8150-test15-vs-base-full.diff` 与 hunk 台账 |
| 0018 候选差异 | 9 文件、35 hunk、+350/-68 | `venus-sm8150-pending-hunk-ledger.md` |
| 0019 动态带宽差异 | 5 文件、11 hunk、+515/-42 | `venus-sm8150-0019-hunk-ledger.md` |
| 001--0019 从基线重放 | 21 文件 | 临时 Git index 严格重放并与候选 blob 校验通过 |

Test15 原始 diff 的 SHA256 是
`207d3af2438927abd9ff3224b3828763b4558de55e775e1e9845e1c23d782aca`。0018 的 SHA256
是 `19257ec9aed57cd801704dd31b6371c724bf7a5a8de64b97aefb629a8b6acb52`。0019 的 SHA256
是 `1ba6547133836f1822003fa08b99c9c39f14525d8f4c49d75c4b6903024ccdcd`。001--0019 已在
干净临时 index 上依次通过 apply/check；0019 所改五个最终 blob 与当前候选源码逐个
完全一致。0018 时代的冻结重放 tree `a0bf124d02fba53c28a622a9ca91b9ca4a7fef0d` 仅作
历史证据，不再代表最新候选。

因此“每行审阅”不是口头保证：39,111 行原厂正向台账、22,143 行当前反向台账、173 个
Test15 hunk、35 个 0018 hunk、11 个 0019 hunk和可重放补丁共同构成闭环。本文只做
语义总览，不能替代
两份几十万字的逐行台账。

### 1.3 状态词只能这样使用

| 状态 | 含义 |
|---|---|
| 已实机通过 | 有非空输出、预期帧数、内容校验以及退出后 PM 状态证据 |
| 已实机到达 | 指定协议阶段有日志证据，但后续失败，不能称功能通过 |
| 已实现、宿主验证 | 代码已进 0018/0019，静态/模拟测试通过，尚未在 SM8150 实机验证 |
| 静态对齐 | 数值、字段、包长、顺序或公式与原厂一致，但无实机功能证据 |
| 部分迁移 | 主链可用，但 codec/profile/metadata/lifecycle 尚未覆盖 |
| 未实现 | 原厂存在且对目标有意义，当前无等价能力 |
| 有意排除 | Android/CVP/secure/private ABI 不属于当前通用 V4L2 目标 |
| 已排除为根因 | 已有证据否定本次具体故障假设，不表示该功能永远无需测试 |

## 2. 当前能力真值

| 功能 | 实机证据 | 当前判定 |
|---|---|---|
| H.264 8-bit decode | 30/30，硬件与软件逐帧 MD5 一致 | 已实机通过 |
| HEVC Main 8-bit decode | MKV 30/30 | 已实机通过；MKV 容器本身无问题 |
| HEVC Main10/P010 decode | source-change=P010、首 capture completion；用户态 0 帧 | 已实机到达，未通过；0018 待测 |
| VP8 decode | Test16 到达 START/source-change，随后报 `HFI_ERR_SESSION_BAD_POINTER` 且 0 帧 | 未通过；0030 已按原厂 DPB/OPB count 契约修正，待 Test17 |
| VP9 Profile 0/2 decode | 原厂和固件能力路径存在 | 未做 8/10-bit 逐帧准入 |
| MPEG2 decode | 原厂和固件能力路径存在 | 未做 progressive/interlace 准入 |
| VC1/MPEG4/H263/Xvid decode | 通用数组有条目，SM8150 原厂 capability 不列 | 不宣称支持 |
| H.264 encode | Test13--15 Stage0--8 安全、旧 Stage9 复位；0027 完整路径待测 | gate 默认 N；明确开启后先做 1 帧准入 |
| HEVC encode | 原厂 SM8150 支持，0027 共用完整启动契约 | H.264 通过后同轮测试 |
| VP8 encode | 原厂 SM8150 支持，0027 共用完整启动契约 | H.264/HEVC 通过后同轮测试 |
| TME encode | 原厂私有能力 | 有意排除，无通用 V4L2 用户 |
| runtime PM | decode/预检退出后父设备和两个 core 均 suspended | 已实机通过 |
| protected/secure playback | 原厂有 secure context bank；当前无完整 session/UAPI | 未实现，不宣称 |

MP4、MKV、WebM 是用户态 demux 容器，不是 Venus 输入格式。播放器把容器拆成 H.264、
HEVC、VP8/9 等 elementary packets 后才送 V4L2 M2M。当前“MP4 能播、某些 MKV 不能播”
实际是已过的样本为 H.264 8-bit/HEVC Main8，而失败样本是 HEVC Main10/P010。不能再把
容器扩展名当内核 codec 能力。

## 3. 原厂 42 文件逐文件处置

下表覆盖原厂目录中的全部文件。行数和函数数来自固定提交的物理源码；每一个文件内部
更细的连续区间在原厂逐行台账中。

| 原厂文件 | 行/函数 | 语义域 | 当前处置 |
|---|---:|---|---|
| `governors/fixedpoint.h` | 72/0 | 定点算术 | 0019 用内核 64-bit helper 实现等价 Q16/截断/舍入语义 |
| `governors/Kconfig` | 6/0 | vendor governor 配置 | 构建胶水不搬；功能直接集成 Venus PM helper |
| `governors/Makefile` | 9/0 | vendor governor 构建 | 同上 |
| `governors/msm_vidc_ar50_dyn_gov.c` | 980/13 | AR50 专用动态模型 | 非 SM8150 量产 DTS 选项；只作对比，不迁其特有公式 |
| `governors/msm_vidc_dyn_gov.c` | 1022/14 | SM8150 选用的通用动态带宽模型 | 0019 按主线 ICC 重写，Q16 数值向量已宿主验证 |
| `hfi_packetization.c` | 2198/38 | HAL→HFI 命令封包 | 映射 `hfi_cmds.c`；所有当前使用属性需核对 wire 值/长度 |
| `hfi_packetization.h` | 103/0 | packetizer API | 映射 `hfi_cmds.h` |
| `hfi_response_handler.c` | 2150/37 | HFI 响应/事件解析 | 映射 `hfi_msgs.c`/`hfi.c`；0018 补 VPU5 EBD 尾部 |
| `Kconfig` | 10/0 | 驱动入口 | 当前 Venus Kconfig 替代 |
| `Makefile` | 23/0 | 模块组成 | 当前 core/dec/enc 模块替代 |
| `msm_cvp.c` | 635/18 | CVP 会话 | 有意排除；MVS1 仅保留共享资源，不伪装 codec core |
| `msm_cvp.h` | 33/0 | CVP API | 有意排除 |
| `msm_smem.c` | 606/13 | dma-buf、IOMMU、cache sync | 原厂所有 video dma-buf 均双向；0018 只补 raw source，0031 补 compressed CAPTURE |
| `msm_v4l2_private.c` | 234/3 | 私有 controls 映射 | 标准 control 优先；不批量复制私有 ABI |
| `msm_v4l2_private.h` | 22/0 | 私有 UAPI 常量 | 有意排除，除非以后有标准化消费者 |
| `msm_v4l2_vidc.c` | 928/50 | ioctl/VB2 桥接 | 映射 `vdec.c`/`venc.c`/V4L2 M2M |
| `msm_vdec.c` | 1422/11 | decoder 格式/控制/事件 | 映射 `vdec.c`/`vdec_ctrls.c`；0018 补 IRIS1 P010 |
| `msm_vdec.h` | 29/0 | decoder 声明 | 映射 `vdec.h`/`core.h` |
| `msm_venc.c` | 2926/10 | encoder 格式/controls/start | 映射 `venc.c`/`venc_ctrls.c`；首 ETB 仍待实机闭环 |
| `msm_venc.h` | 28/0 | encoder 声明 | 映射 `venc.h`/`core.h` |
| `msm_vidc_clocks.c` | 1735/34 | clocks、DCVS、bus、core route | 0019 补齐 EBD counter、动态统计汇总、前16帧 Turbo 和 vote |
| `msm_vidc_clocks.h` | 48/0 | 投票接口 | 映射 `pm_helpers.h` |
| `msm_vidc_common.c` | 7240/178 | 会话状态机和 buffer 生命周期 | 拆到 helpers/HFI/dec/enc；逐阶段审计 |
| `msm_vidc_common.h` | 268/0 | 公共 API | 映射 `helpers.h`/`hfi.h` |
| `msm_vidc_debug.c` | 546/16 | debugfs/SSR/统计 | 仅迁必要取证；不是功能依赖 |
| `msm_vidc_debug.h` | 216/0 | debug 宏 | 用标准 dev_*、dynamic debug/trace 替代 |
| `msm_vidc_internal.h` | 567/0 | core/instance/format/control 数据 | 逐字段语义映射 `core.h`，不复制内存布局 |
| `msm_vidc_platform.c` | 997/2 | SM8150 codec/platform 真值 | 映射 `core.c` + firmware capability parser |
| `msm_vidc_res_parse.c` | 1427/37 | DTS 资源解析 | 映射 DT binding、core、PM helpers |
| `msm_vidc_res_parse.h` | 39/0 | 资源解析 API | 主线框架替代 |
| `msm_vidc_resources.h` | 250/0 | clocks/bus/context bank 描述 | 映射 DT/power-domain/ICC/DMA mask |
| `msm_vidc.c` | 2218/53 | probe、实例、格式映射 | 映射 core/helpers/dec/enc |
| `msm_vidc.h` | 136/0 | 顶层接口 | 当前各模块头替代 |
| `venus_boot.c` | 470/10 | firmware boot | 映射 `firmware.c`/`hfi_venus.c`；`.mbn` 已实机启动 |
| `venus_boot.h` | 22/0 | boot API | 映射 `firmware.h`/HFI API |
| `venus_hfi.c` | 5369/147 | queues、IRQ、PC、命令传输 | 映射 `hfi_venus.c`；IRIS1 路径已迁主链 |
| `venus_hfi.h` | 296/0 | HFI 私有结构 | 映射 `hfi_venus.h` |
| `vidc_hfi_api.h` | 1524/0 | HAL 属性/结构 | 映射 HFI helpers + 标准 controls；私有 HAL 不做 UAPI |
| `vidc_hfi_helper.h` | 1169/0 | wire IDs/packet structs | 映射 `hfi_helper.h`；数值/包长是强一致边界 |
| `vidc_hfi_io.h` | 196/0 | VPU5 寄存器 | 映射 `hfi_venus_io.h`；仅迁实际需要的 offset |
| `vidc_hfi.c` | 73/2 | HAL/HFI 设备抽象 | 映射 `hfi.c`/`hfi_venus.c` |
| `vidc_hfi.h` | 869/0 | HFI 抽象和完成消息 | 映射 `hfi.h`/`hfi_msgs.h`；0018 补 EBD 扩展尾部 |

合计：42 文件、39,111 行、686 个函数，全部有文件级处置；每行区间证据见原厂台账。

## 4. 当前 36 文件逐文件反向处置

这张表回答相反的问题：当前 Venus 的每个文件为什么保留、哪些只服务别的 SoC、哪些
承载 SM8150 迁移、哪些仍有明确债务。详细到每个连续区间的 3,079 条记录见当前台账。

| 当前文件 | 行/函数 | SM8150 处置与未决项 |
|---|---:|---|
| `core.c` | 1252/18 | probe、resources、firmware caps；静态 SDM845 表仍存在但 0019 的 IRIS1 分支不再使用 |
| `core.h` | 655/0 | 通用结构 + IRIS1 状态；0019 增加 per-recon 动态统计，实验字段最终需产品化 |
| `dbgfs.c` | 28/2 | 通用最小 debugfs，保留；不追求 vendor debug ABI |
| `dbgfs.h` | 25/0 | 通用声明，保留 |
| `firmware.c` | 384/11 | remoteproc/firmware lifecycle；Raphael `.mbn` 已通过 |
| `firmware.h` | 28/0 | 通用声明 |
| `helpers.c` | 2274/73 | format/size/buffer/internal/start helpers；HFI4 P010 constraints 与 staged encoder 核心 |
| `helpers.h` | 77/0 | 公共 helper 声明 |
| `hfi_cmds.c` | 1458/32 | HFI 命令 packetizer；0018 加 HFI4 可变长 P010 constraints |
| `hfi_cmds.h` | 299/0 | packet API；wire ABI 要保持架构中立 |
| `hfi_helper.h` | 1327/0 | HFI IDs/structs；通用及多 SoC 定义不能误算成 SM8150 capability |
| `hfi_msgs.c` | 943/30 | responses/events；0018/0019 兼容解析 VPU5 扩展 EBD并发布通用动态统计 |
| `hfi_msgs.h` | 298/0 | response wire structs；扩展尾部必须可选，不能抬高最小包长 |
| `hfi_parser.c` | 403/17 | SYS_INIT capability parser；0018 回移 payload-size/raw-format 修复 |
| `hfi_parser.h` | 120/0 | parser API/状态，保留 |
| `hfi_plat_bufs_v6.c` | 1334/48 | HFI6 平台 buffer 公式；不是 IRIS1/HFI4 encoder 内存真值，保留给其他 SoC |
| `hfi_plat_bufs.h` | 41/0 | HFI6 API，SM8150 不直接使用 |
| `hfi_platform_v4.c` | 481/6 | HFI4 codec frequency/cycles/caps；SM8150 关键静态 capability |
| `hfi_platform_v6.c` | 347/6 | HFI6 数据，保留给其他 SoC，不向 SM8150套用 |
| `hfi_platform.c` | 97/5 | HFI version dispatch，IRIS1 必须走 4xx |
| `hfi_platform.h` | 79/0 | dispatch API |
| `hfi_venus_io.h` | 173/0 | VPU register offsets；IRIS1 寄存器分支已补 |
| `hfi_venus.c` | 2063/74 | queue/IRQ/power-collapse/syscache；已通过 firmware boot/PM，日志待降噪 |
| `hfi_venus.h` | 16/0 | 内部声明 |
| `hfi.c` | 565/27 | HFI wrapper/state；route/work-mode/session timeout 主链已审 |
| `hfi.h` | 176/0 | HFI API |
| `Kconfig` | 15/0 | 当前模块配置；不并存 vendor msm_vidc |
| `Makefile` | 15/0 | core/dec/enc 模块化，保留 |
| `pm_helpers.c` | 1996/67 | clocks/PD/ICC/OPP；0019 已迁 SM8150 Q16 DDR/LLCC 模型，实机性能/稳定性待验 |
| `pm_helpers.h` | 66/0 | PM API |
| `vdec_ctrls.c` | 200/3 | 标准 decoder controls；缺完整 metadata/色彩/HDR/private 子集 |
| `vdec.c` | 2041/54 | decoder ioctls/queues/source-change；0018 补稳定枚举、P010 size/trace，0019 重置动态统计 |
| `vdec.h` | 13/0 | decoder 声明 |
| `venc_ctrls.c` | 773/5 | 标准 encoder controls；多数常用能力已有，范围需受 firmware caps 约束 |
| `venc.c` | 2068/46 | encoder V4L2/VB2/start；0018 补 vendor NV12 size、双向 DMA、回滚，0019 重置动态统计 |
| `venc.h` | 13/0 | encoder 声明 |

合计：36 文件、22,143 行、524 个函数，全部有反向处置；没有因为文件“与 SM8150
无关”就漏审，HFI6 等代码明确标为其他 SoC 保留。

## 5. SM8150 平台、固件、时钟、电源和 IOMMU

### 5.1 已对齐且有实机证据

| ID | 原厂真值 | 当前实现 | 状态 |
|---|---|---|---|
| PLAT-01 | VPU5，HFI4 | `VPU_VERSION_IRIS1 + HFI_VERSION_4XX` | 已实机启动 |
| PLAT-02 | 普通 codec 使用 MVS0；MVS1 是 CVP | `vcodec_num=1`，MVS1 只作共享资源 | 已实机启动 |
| FW-01 | Raphael firmware `.mbn` | `qcom/sm8150/Xiaomi/raphael/venus.mbn` | SYS_INIT 成功 |
| FW-02 | `VIDEO.IR.1.2-00045-PROD-1` | raw version 正确读取 | 已实机观察 |
| CLK-01 | v2 240/338/365/444/533 MHz | OPP/frequency table 精确对齐 | 533 MHz 已实机 |
| CLK-02 | MVSC、MVS0、MVS1/CVP clocks | 七路 clock/PD + hw-control handoff | 已实机启动 |
| LLCC-01 | VIDSC0/VIDSC1 各 512 KiB | LLCC slice 获取、激活、HFI syscache resource | 已实机供给 firmware |
| PM-01 | software PC、1500 ms collapse delay | parent autosuspend + HFI PC | decode 后 suspended |
| PM-02 | HFI response timeout 1000 ms | command/PC waits 1000 ms | 静态对齐 |
| IOMMU-01 | v2 non-secure SID 0x2300 | 当前 DT non-secure stream | decode 已证明可访问 |
| IOMMU-02 | secure SIDs 0x2301/03/04 | DT 有 SID，但无 secure-session 完整语义 | 部分存在，不宣称 secure |

### 5.2 原厂 `sm8150_common_data` 全条目处置

| key | 原厂值 | 处置 |
|---|---:|---|
| `never-unload-fw` | 1 | runtime suspend 不卸 firmware image，基本等价 |
| `sw-power-collapse` | 1 | 已实现并实机 idle |
| `domain-attr-non-fatal-faults` | 1 | 无明确等价；不得通过吞 IOMMU fault 模拟 |
| `max-secure-instances` | 3 | secure UAPI 未迁，因此限制亦未实现 |
| `max-hw-load` | 3916800 | `sm8150_res.max_load` 已对齐 |
| `max-hq-mbs-per-frame` | 8160 | 未单列；需要 capability/质量模式约束 |
| `max-hq-mbs-per-sec` | 244800 | 未单列 |
| `max-b-frame-size` | 8160 | B-frame control 有，SM8150 专用上限未单列 |
| `max-b-frames-per-sec` | 60 | 未单列 |
| `power-collapse-delay` | 1500 ms | parent 已对齐；dec/enc 子设备通用 2000 ms 需产品化确认 |
| `hw-resp-timeout` | 1000 ms | 已对齐 |
| `debug-timeout` | 0 | 无同名策略；非功能前置 |
| `domain-cvp` | 1 | 资源存在，不公开 CVP session |
| `decode-batching` | 1 | wire 定义存在，完整策略未迁 |
| `dcvs` | 1 | 通用频率缩放有；统计驱动的完整闭环未迁 |
| `fw-cycles` | 760000 | 未建专用常量；当前用主线简化模型 |
| `fw-vpp-cycles` | 166667 | 同上 |

### 5.3 设备树所有原厂区间处置

| 原厂范围 | 内容 | 当前结论 |
|---|---|---|
| `sm8150-vidc.dtsi:1--16` | headers/msm-bus include | 架构胶水不迁 |
| `:17--23` | node、compatible、2 MiB reg、IRQ174 | compatible/IRQ 对齐；当前 reg 1 MiB，现有访问无越界证据 |
| `:24--27` | LLCC VIDSC0/1 | 已迁且激活 |
| `:28--32` | iris-ctl/MVS0/CVP supplies | 以 power domains 等价表达 |
| `:33--46` | clocks 与 proxy/hw-control | 七路 clock 和 handoff 已迁 |
| `:47--56` | resets 与 v1 freq | resets 已迁；Raphael 应用 v2 频率，不误用 480 MHz |
| `:58--91` | CNOC、Venus-DDR、ARM9-DDR、Venus-LLCC | 当前 `video-mem`/`cpu-cfg` 是框架等价；0019 把 DDR/LLCC 动态结果折叠到端到端 path |
| `:93--101` | non-secure CB/SID/VA | v2 SID 0x2300；decode 已过 |
| `:103--131` | secure CB/buffer types/VA pools | DTS SID 有，secure buffer/session 未迁 |
| `:133--139` | CDSP heap | CVP/私有路径，不迁普通 codec |
| `sm8150-v2.dtsi:367--370` | 240--533 MHz override | 精确对齐 |
| `:371--383` | v2 SIDs | 数值对齐 |

### 5.4 0019 的 SM8150 动态带宽映射与剩余硬件边界

- 原厂 SM8150 量产 DTS 选择通用 `msm-vidc-ddr` 和 `msm-vidc-llcc` governor；AR50 文件是
  另一平台模型，不能拿来当 SM8150 真值。0019 移植的是 `msm_vidc_dyn_gov.c` 与
  `fixedpoint.h` 的 Q16 运算、LUT、decoder/encoder 公式和动态 CR/CF 汇总。
- 原厂四条 bus 中 CNOC 与 ARM9-DDR 是固定 1000；动态的 `VideoP0 -> LLCC` 和
  `LLCC -> EBI` 最大值均为 6,533,000。当前 DT 的 `video-mem` 是贯穿这两段的端到端 ICC
  path，所以 0019 采用 `max(ddr,llcc)`，而不是复制 Android `msm-bus` client 或把两段
  相加造成重复投票。
- 原厂 `buffer_counter` 在 EBD 清除输入频率项时递增。0019 因而使用 EBD count，而不是
  FBD/输出序号：任何有在飞输入且 EBD 少于 16 的 IRIS1 会话都保持最大 533 MHz 与最大
  6,533,000 带宽；之后才使用动态公式。多实例动态票求和后饱和到同一最大值。
- 静态 `sdm845_bw_table_enc/dec` 仍保留给其他 SoC；`IS_IRIS1()` 已在 0019 分流，不再
  使用它们。8 个原厂等价精确数值向量已宿主通过，但真实 ICC 单位、provider 行为、
  10-bit、长序列和多实例仍待实机验证，故状态只能是“已实现、宿主验证”。
- 当前寄存器窗口 1 MiB 与原厂 2 MiB 不同，但无访问越界。只有当要用的 VPU5 offset
  超过窗口时才改 DT，不能为外观一致盲扩。

## 6. HFI4 线协议全量差异

### 6.1 已逐项对齐的主链

| 协议面 | 核对结果 |
|---|---|
| SYS_INIT/capability | session domain、codec bit、capability/property payload 由 HFI4 parser 处理；0018 回移长度修复 |
| SESSION_INIT | encoder/decoder type 与 codec 数值一致，实机成功 |
| WORK_ROUTE | HFI4 专用 packetizer 已有；SM8150 实机 route=2 |
| WORK_MODE | HFI4 payload/数值已对齐；VBR 常规路径 mode=2 |
| VIDEOCORES_USAGE | 普通 codec 使用 MVS0 mask，不路由 MVS1 |
| BUFFER_COUNT_ACTUAL | HFI4 为 `type/count_actual/count_min_host`；Test15 已纠正 host-min |
| GET_BUFFER_REQUIREMENTS | 两次查询、table cache、最终 count 回写顺序已对齐 |
| SET/RELEASE_BUFFERS | type、size、count、32-bit IOVA 布局与原厂一致 |
| LOAD/START | internal buffers 后 LOAD_RESOURCES → START；Stage6/7 到达 |
| STOP/RELEASE/END | STOP → RELEASE_RESOURCES → internal release → SESSION_END；staged 回滚已过 |
| FTB | 四个 compressed capture FTB 在首 ETB 前入队；Stage8 到达 |
| ETB | view/time/flags/mark/offset/alloc/filled/tag/packet/extra/address 字段顺序已核对 |
| SYSCACHE | LLCC 两 slice 通过 HFI resource 交给 firmware |
| P010 constraints | 原厂 HFI4 可变长 plane packet；0018 已实现，待实机 |
| encoder EBD | common prefix 保持最小兼容；0018 可选解析 VPU5 尾部，待实机 |

内部 buffer type 的 wire 真值为 persist0=4、persist1=5、scratch0/1/2=6/7/8、recon=9。
这里最重要的纠错是：**RECON=9 是索引/统计 metadata，不是一块要由 host 静态分配并
SET_BUFFERS 的 DMA。**原厂 `msm_vidc_common.c:5170--7205` 的会话初始化只为 recon 建立
bookkeeping，EBD 再用 `frame_index` 回写对应统计。给 RECON 额外分配 DMA 是错误迁移，
已经明确禁止。

### 6.2 VPU5 encoder EBD 精确布局

原厂 `vidc_hfi.h:588--613` 的 EBD 是：

- 36-byte 公共前缀：header/session/error/offset/filled/tag/packet/extra；
- 4-byte flags；
- 36-byte recon stats：frame index、7 个 UBWC bucket、complexity number；
- 4-byte `rgData[0]`，表示是否附有 sync picture type；
- 若该值非零，再有 4-byte picture type。

所以 VPU5 固定最小总包长是 80 bytes，可选 picture type 后为 84 bytes。0018 把扩展内容
建成 tail，只有 `packet_size >= 80` 才读统计，只有 `>=84` 且 sync 才读 picture type；短
固件消息仍按旧 36-byte prefix 完成 buffer，不能把 `sizeof(extended)` 设成所有固件的
最低准入。

UBWC 权重必须精确为 `{32, 64, 96, 128, 160, 192, 256}`。曾经的等差生成会把最后一项
误算成 224；0018 已改为显式常量。CR 是 `((256 * sum) << 16) / weighted_sum`，CF 使用
原厂 macroblock-derived frame size。当前仅缓存/打印这些 Q16 数据，尚未驱动 bandwidth。

### 6.3 HFI property 名称集合的完整分类

在固定原厂与当前候选源码中，去重后的 `HFI_PROPERTY_*` token：原厂 150、当前 162、
同名 119、仅原厂 31、仅当前 43。名称差异不能直接等于 wire 功能差异；下面把所有
非交集 token 全部列出并分类。

#### 6.3.1 仅原厂的 31 个 token

| 类别 | token | 处置 |
|---|---|---|
| 同 wire 改名 | `HFI_PROPERTY_PARAM_BUFFER_SIZE_MINIMUM` | 当前 `...BUFFER_SIZE_ACTUAL`，同 ID/payload 语义族；不是漏包 |
| 同 wire 改名 | `HFI_PROPERTY_PARAM_VENC_GENERATE_AUDNAL` | 当前 `...VENC_H264_GENERATE_AUDNAL`；同一 H.264 offset |
| 同 wire 改名 | `HFI_PROPERTY_PARAM_VENC_H264_8X8_TRANSFORM` | 当前 `...H264_TRANSFORM_8X8`；同一 offset |
| 同 wire 改名 | `HFI_PROPERTY_PARAM_VENC_VUI_TIMING_INFO` | 当前 `...H264_VUI_TIMING_INFO`；同一 offset |
| 配置命名差异 | `HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID` | 对应层级编码 config 族；需按 ID 而非名字核对 |
| 标准能力候选 | `HFI_PROPERTY_CONFIG_OPERATING_RATE` | 主线有帧率/负载语义，但没有完整 vendor operating-rate 控制；后续标准化 |
| 标准能力候选 | `HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE` | HRD/VBV 精细控制未迁；非基础 codec 启动前置 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_ADAPTIVE_B` | 自适应 B 策略未迁 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_BITRATE_TYPE` | 当前 bitrate mode 有标准控制；需核对是否需要额外 vendor property |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_DTS_INFO` | DTS metadata 未迁 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_FRAME_QP_EXTRADATA` | per-frame QP metadata 未迁 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_IFRAMESIZE` | iframe-size 策略未迁 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_SEND_OUTPUT_FOR_SKIPPED_FRAMES` | skipped-frame output 策略未迁 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_VIDEO_SIGNAL_INFO` | colour/video-signal metadata 需标准 V4L2 表达 |
| 标准能力候选 | `HFI_PROPERTY_PARAM_VENC_VUI_TIMING_INFO` | 见同 wire 改名；非 H.264 泛化部分另审 |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_COLOUR_REMAPPING_INFO_SEI_EXTRADATA` | 未迁，需标准 metadata |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_CONTENT_LIGHT_LEVEL_SEI_EXTRADATA` | 未迁，需 HDR CLL 标准路径 |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_MASTERING_DISPLAY_COLOUR_SEI_EXTRADATA` | 未迁，需 HDR mastering 标准路径 |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_UBWC_CR_STAT_INFO_EXTRADATA` | vendor 统计，不是线性 decode 基础功能 |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_VPX_COLORSPACE_EXTRADATA` | VPx colorspace metadata 未迁 |
| decoder metadata | `HFI_PROPERTY_PARAM_VDEC_VQZIP_SEI_EXTRADATA` | vendor 私有，不直接迁 |
| decoder feature | `HFI_PROPERTY_PARAM_VDEC_DOWN_SCALAR` | 内置 downscale 私有路径，主线无等价 ABI |
| encoder metadata | `HFI_PROPERTY_PARAM_VENC_HDR10PLUS_METADATA_EXTRADATA` | 动态 HDR10+ per-frame metadata 未迁 |
| encoder metadata | `HFI_PROPERTY_PARAM_VENC_ROI_QP_EXTRADATA` | ROI QP per-frame metadata 未迁 |
| encoder feature | `HFI_PROPERTY_CONFIG_HEIC_FRAME_CROP_INFO` | HEIC 私有工作流，当前 codec 目标外 |
| encoder feature | `HFI_PROPERTY_CONFIG_HEIC_GRID_ENABLE` | HEIC 私有工作流，当前 codec 目标外 |
| encoder feature | `HFI_PROPERTY_CONFIG_VENC_BLUR_FRAME_SIZE` | vendor blur，当前目标外 |
| secure/private | `HFI_PROPERTY_PARAM_SECURE_SESSION` | secure session 栈未迁，不能只发属性假装支持 |
| interrupt policy | `HFI_PROPERTY_PARAM_SYNC_BASED_INTERRUPT` | vendor interrupt tuning，非基础功能前置 |
| system namespace | `HFI_PROPERTY_SYS_OX_START` | 命名空间/版本常量，不是漏功能 |
| private codec | `HFI_PROPERTY_TME_VERSION_SUPPORTED` | TME 私有，明确排除 |

#### 6.3.2 仅当前的 43 个 token

| 分组 | token | 处置 |
|---|---|---|
| HFI 通用/其他 SoC | `HFI_PROPERTY_CONFIG_BATCH_INFO`, `HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER`, `HFI_PROPERTY_CONFIG_VPE_DEINTERLACE`, `HFI_PROPERTY_CONFIG_VPE_OPERATIONS` | 保留通用代码；不代表 SM8150 主动使用 |
| buffer/capability | `HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE`, `HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED`, `HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL`, `HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL`, `HFI_PROPERTY_PARAM_INTERLACE_FORMAT_SUPPORTED`, `HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE` | HFI parser/通用 capability；`BUFFER_SIZE_ACTUAL` 与 vendor minimum 同 wire 族 |
| raw/format | `HFI_PROPERTY_PARAM_CHROMA_SITE`, `HFI_PROPERTY_PARAM_DIVX_FORMAT`, `HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT`, `HFI_PROPERTY_PARAM_EXTRA_DATA_HEADER_CONFIG` | 多 SoC/legacy；受 firmware capability 过滤 |
| decoder | `HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT`, `HFI_PROPERTY_PARAM_VDEC_ENABLE_SUFFICIENT_SEQCHANGE_EVENT`, `HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY`, `HFI_PROPERTY_PARAM_VDEC_H264_ENTROPY_SWITCHING`, `HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2`, `HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD`, `HFI_PROPERTY_PARAM_VDEC_VC1_FRAMEDISP_EXTRADATA`, `HFI_PROPERTY_PARAM_VDEC_VC1_SEQDISP_EXTRADATA` | 通用/legacy decoder；不得据此宣称 SM8150 VC1/MVC |
| extradata | `HFI_PROPERTY_PARAM_ERR_DETECTION_CODE_EXTRADATA` | 通用 extradata，非 SM8150 特有 |
| H.264 encoder | `HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL`, `HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT`, `HFI_PROPERTY_PARAM_VENC_H264_PICORDER_CNT_TYPE`, `HFI_PROPERTY_PARAM_VENC_H264_TRANSFORM_8X8`, `HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC`, `HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO` | 部分是 vendor 同 wire 改名；其余受 control/capability 决定 |
| MPEG4/VC1 encoder | `HFI_PROPERTY_PARAM_VENC_MPEG4_AC_PREDICTION`, `HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION`, `HFI_PROPERTY_PARAM_VENC_MPEG4_SHORT_HEADER`, `HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION`, `HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG` | 通用 legacy；SM8150 原厂不列相应 encoder codec |
| rate/QP/reference | `HFI_PROPERTY_CONFIG_VENC_LTRPERIOD`, `HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE`, `HFI_PROPERTY_PARAM_VENC_ADVANCED`, `HFI_PROPERTY_PARAM_VENC_INITIAL_QP`, `HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES`, `HFI_PROPERTY_PARAM_VENC_MULTIREF_P`, `HFI_PROPERTY_PARAM_VENC_SESSION_QP`, `HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE_V2`, `HFI_PROPERTY_PARAM_VENC_VIDEO_FULL_RANGE` | 标准 encoder control 语义；是否发送由用户设置和 firmware caps 限制 |

上面的分组逐个包含全部 43 个 token。119 个同名 token 的存在不等于已全部激活：静态
定义、packetizer case、control 调用和 SM8150 firmware capability 四层必须同时成立。
基础启动链使用的属性已逐项核对；secure、CVP、private extradata 和其他 SoC 的定义
保留但不纳入当前支持承诺。

### 6.4 capability parser 的真实差异

0018 回移了后续主线已经证明的三类 parser 修正：

1. allocation-mode payload size 以实际条目长度前进；
2. capability payload size 使用正确结构大小，避免下一个 property 起点错位；
3. raw format 的 plane constraints 对每个 format 正确初始化/累加，不能用最后一个 plane
   或错误公式覆盖总长度。

这类错误会让一个 malformed/多 plane property 把后续 SYS_INIT 数据整体错读，影响 codec
枚举和格式约束。宿主 payload-invariant 测试已通过；仍要在实机确认 capability 表内容。

## 7. Decoder 全量迁移审计

### 7.1 codec 与 raw format 真值

原厂 `msm_vidc_platform.c` 的 SM8150 codec data 明确给出 decoder MPEG2、H.264、HEVC、
VP8、VP9；当前 HFI4 静态 capability 表也有这五类。当前通用 `vdec_formats` 还列出 VC1、
MPEG4、H263、Xvid 等，这是 Venus 多 SoC 共用数组，必须经 `venus_helper_check_codec()` 和
固件 SYS_INIT capability 过滤，不能凭 `ffmpeg -decoders` 或数组条目宣称 SM8150 支持。

原厂 raw output 能力包含线性 NV12、线性 P010、NV12 UBWC 和 TP10 UBWC。当前对外 fourcc
为 NV12、P010、QC08C、QC10C；需要分别验证：

- V4L2 memory-plane 数量与 HFI color-plane 数量不能混用；P010 对用户态仍可是一块连续
  memory buffer，但 HFI constraints 内是 Y/UV 两个颜色 plane；
- `bytesperline`、Y/UV scanlines、plane gap、`sizeimage`、`bytesused`、`data_offset`；
- source-change 后旧 capture buffers 归还、新格式协商、REQBUFS/QUERYBUF 和 STREAMON；
- UBWC/TP10 必须有用户态可解释的 modifier/fourcc，不能当普通线性 NV12/P010 输出。

### 7.2 Main10/P010 已知失败链与数值闭环

已有 Test8/Test10 实机证据：

1. HEVC Main10 elementary stream 进入 Venus；
2. 固件报告 `bit_depth=0x20002`、profile `0x2`；
3. source-change 选择 V4L2 `P010`，fourcc `0x30313050`；
4. 320x240 当时报告 `stride=768`、`sizeimage=294912`；
5. 第一个 capture completion 为 `bytesused=245760`、offset=0；
6. FFmpeg 7.1.5 `hevc_v4l2m2m` 和 mpv 都报 invalid frame，输出 0 帧。

旧 294,912 字节来自当前通用 P010 公式，缺少小米 Venus linear P010 的 UV 之前 4 KiB
保留区。原厂 `include/uapi/media/msm_media_info.h:918--1070,1333--1370` 的公式是：

```text
y_stride     = align(width * 2, 256)
uv_stride    = align(width * 2, 256)
y_scanlines  = align(height, 32)
uv_scanlines = align(height / 2, 16)
y_plane      = y_stride * y_scanlines
uv_plane     = uv_stride * uv_scanlines + 4096
size         = align(y_plane + uv_plane, 4096)
```

对 320x240：stride=768、Y scanlines=256、UV scanlines=128，最终 299,008 bytes。0018 仅在
IRIS1 + P010 capture 路径增加这 4 KiB；其他 SoC 和 NV12 不受影响。这里的 245,760
`bytesused` 是固件实际有效载荷，不应被强行改成 `sizeimage`。

原厂 `msm_vdec.c:549--560` 与 `hfi_packetization.c:1054--1080` 还要求 HFI4 发送：

| HFI color plane | stride multiple | max stride | scanline multiple | buffer alignment |
|---:|---:|---:|---:|---:|
| Y | 256 | 8192 | 32 | 256 |
| UV | 256 | 8192 | 16 | 256 |

0018 在 `helpers.c` 构造两 plane 约束，并在 `hfi_cmds.c` 的 HFI4 packetizer 按实际 plane
数生成可变包长。它只对 IRIS1 P010 生效，避免把 P010 约束误发给线性 NV12。

### 7.3 格式枚举与协商修正

旧逻辑让 `find_format()` 按当前 bit depth 过滤，却让 `find_format_by_index()` 的枚举行为
不一致；用户态可能枚举到格式，但 TRY/S_FMT 又回退，随后 G_FMT 与 source-change 自相矛盾。
0018 的规则是：

1. ENUM_FMT 只回答设备稳定 capability，不随某个未开始/已变化会话的 bit depth 抖动；
2. TRY_FMT、S_FMT、G_FMT 必须按当前会话 bit depth 严格检查；open 初始值为 8-bit，
   source-change 确认 Main10 后才允许 P010，不能把“尚未解析 header”误写成第三种位深；
3. source-change 之前用户态仍可通过稳定 ENUM_FMT 得知 P010 capability，但 capture S_FMT
   的最终选择应在解析 header、收到 source-change 后完成；
4. source-change 一旦确认 10-bit，不得静默回退 NV12；8-bit 不得静默回 P010；
5. 所有 fallback 都打印低频摘要，便于区分 kernel 选择与 userspace 请求。

该修正已通过宿主枚举稳定性、strict selection 和 exact Main10/P010 单元测试，但尚未得到
实机 `G_FMT/QUERYBUF/DQBUF` 闭环，所以状态仍是“已实现、宿主验证”。

### 7.4 decoder buffer/lifecycle 差异

| ID | 原厂行为 | 当前候选 | 状态 |
|---|---|---|---|
| DEC-BUF-01 | source-change 后重新计算 raw layout | 当前已有重配置；0018 强化 P010 size | 待实机 Main10 |
| DEC-BUF-02 | output/capture requirements 分离 | 当前 V4L2 queue + HFI req | H.264/Main8 已过 |
| DEC-BUF-03 | output/capture count 按 firmware minimum | 当前 helper/cache | 静态对齐，需多 codec |
| DEC-BUF-04 | UBWC/TP10 plane/layout | 当前有 QC08C/QC10C helper | 无桌面用户态准入 |
| DEC-BUF-05 | buf_init 映射失败回滚 | 0018 修正计数/状态 rollback | 宿主验证 |
| DEC-BUF-06 | EOS/flush/drain/source-change | 当前通用状态机 | H.264 短片不覆盖全部 |
| DEC-META-01 | HDR/color/interlace/extradata | 只迁一部分标准 controls | 未完整迁移 |
| DEC-META-02 | secure/output-order/batching | Android 私有或无标准 ABI | 有意排除/以后设计 |

### 7.5 decoder 全准入矩阵

| codec | profile/format | 最小正确性 | 压力与生命周期 | 当前状态 |
|---|---|---|---|---|
| H.264 | Baseline/Main/High 8-bit NV12 | 30 帧 MD5 | 720p/1080p/4K、B-frame、seek/reopen、10 min | 仅小样本已过 |
| H.264 | interlaced | 软件参考 + field 顺序 | 1080i、route 特例 | 未测 |
| HEVC | Main 8-bit NV12 | 30 帧 MD5 | 1080p/4K、seek、source-change、10 min | 320x240 已过 |
| HEVC | Main10 P010 | raw V4L2 + FFmpeg framemd5 + mpv | 1080p/4K、HDR、source-change | 0018 待测 |
| HEVC | Main10 QC10C/TP10 | modifier/layout 正确 | 桌面 import、长片 | 未准入 |
| VP8 | Profile 0 NV12 | 30 帧 MD5 | 720p/1080p、seek、10 min | 未测 |
| VP9 | Profile 0 NV12 | 30 帧 MD5 | 1080p/4K、superframe、10 min | 未测 |
| VP9 | Profile 2 P010/QC10C | 30 帧 MD5 | 1080p/4K、HDR | 未测 |
| MPEG2 | progressive NV12 | 30 帧 MD5 | 720p/1080p、seek | 未测 |
| MPEG2 | interlaced | field/帧序正确 | 1080i、route 特例 | 未测 |
| 所有已准入 codec | dynamic resolution | 两段像素校验 | capture queue 重建、无泄漏 | 未系统测 |
| 所有已准入 codec | error handling | 损坏 packet 不挂死 | STREAMOFF、SIGTERM、PM resume | 未系统测 |

每项必须同时满足：输出非空、帧数正确、像素/软件解码校验、无 HFI/IOMMU 错误、退出后
runtime PM 回 `suspended`。FFmpeg 返回 0 但输出 0 帧仍然是失败。

## 8. Encoder 全量迁移审计

### 8.1 原厂支持面与当前公开面

原厂 SM8150 encoder codec 明确为 H.264、HEVC、VP8、TME。当前通用压缩格式数组还包含
MPEG4/H263，但 SM8150 firmware capability 不支持时必须过滤。TME 没有主线通用消费者，
明确排除。

当前 encoder raw input 只公开 NV12。原厂还认识 NV21、NV12 UBWC、TP10 UBWC、P010、
NV12_512。为了“尽可能多支持”，扩格式的准入顺序必须是：线性 NV12 H.264 稳定 →
HEVC/VP8 NV12 → 有标准用户态表达的 P010 → UBWC/TP10。任何 raw fourcc 都必须同时有
正确 size/stride、HFI constraints、DMA direction/sync 和实际用户态生产者。

### 8.2 原厂 start 顺序与 Test13--15 逐阶段证据

| 阶段 | 原厂动作 | 当前实机证据 | 判定 |
|---:|---|---|---|
| 0 | SESSION_INIT、initial count 4/4、controls、route/mode、两次 bufreq | Stage0 到 protocol preflight，退出 suspended | 已到达 |
| 1 | internal prefix 第一类 | 安全返回 | 已到达 |
| 2 | scratch0(6)、scratch1(7) SET/RELEASE | 两类 IOVA queued/done，退出 suspended | 已到达 |
| 3 | 再加 scratch2(8) | 三类 SET/RELEASE，退出 suspended | 已到达 |
| 4 | 再加 persist0(4) | 四类 SET/RELEASE，退出 suspended | 已到达 |
| 5 | persist1(5) 按 req 条件 | firmware 未请求，正确 skip | 已到达 |
| 6 | LOAD_RESOURCES | command/done，安全回滚 | 已到达 |
| 7 | START | command/done，STOP/RELEASE 安全 | 已到达 |
| 8 | queue compressed capture FTB | 4 个 FTB 安全 | 已到达 |
| 9 | queue 第一块 raw NV12 ETB | ETB 后无 EBD/FBD，整机硬复位 | 失败边界 |

Stage0--8 已经给出排除证据，不应再浪费实机重跑。Test15 新增独立
`DISABLE_RC_TIMESTAMP=1` 后 Stage9 仍复位，说明 RC timestamp 不是根因。WORK_ROUTE=2、
VBR WORK_MODE=2、MVS0、FTB-before-ETB、32-bit IOVA、高频533 MHz、LOAD/START、内部四类
DMA 和 packet field 顺序也已排除为本次首 ETB 的直接缺口。

### 8.3 firmware buffer requirements 真值

128x96 H.264 VBR 样本两次查询后的最终值：

| type | 含义 | size | actual/min/host | host 行为 |
|---:|---|---:|---|---|
| 1 | raw input | 18,432 | 16/3/0 | V4L2 actual 16，bytesused 18,432 |
| 2 | compressed output | 36,864 | 4/4/0 | V4L2 capture 4；可分配更大但不能小于 req |
| 4 | persist0 | 64,768 | 1/1/0 | 页对齐 SET 65,536 |
| 5 | persist1 | 未请求 | 0 | 正确跳过 |
| 6 | scratch0 | 198,400 | 1/1/0 | 页对齐 SET 200,704 |
| 7 | scratch1 | 233,056 | 1/1/0 | 页对齐 SET 233,472 |
| 8 | scratch2 | 118,784 | 1/1/0 | 已 4 KiB 对齐 |
| 9 | recon metadata | 28,672 | 1/1/1 | 只建索引，不分配静态 DMA |

初始 4/4 与最终 16/4 是两个不同阶段；不能因为第一次 req 显示 input actual=4 就覆盖
第二次 firmware 要求的 16，也不能把 host minimum 当 actual。0018 对 format/lifecycle
改变增加 bufreq cache invalidation，对 mapping failure 增加 count rollback，并在每次
STREAMON 前清空统计，避免上一会话污染。

### 8.4 第一 ETB 的已知 wire 证据

Test15 最后可见：

```text
ETB tag=0 dma=0xdf498000 alloc=32768 filled=18432 offset=0
```

随后无 EBD、无 FBD、无正常 cleanup，机器复位。IOVA 小于 32-bit mask 上限，因此不是
简单的高 32 位截断。`filled_len=18432` 是真实 NV12 图像字节数，不能伪造为 allocation
length。现在剩余最强差异是 allocation layout 与 DMA mapping/sync 语义。

### 8.5 0018 对首 ETB 的两项成组修正

#### ENC-DMA-01：原厂精确 NV12 allocation size

同一 128x96 raw buffer：

| 实现 | alloc size | 说明 |
|---|---:|---|
| 当前 7.1 旧公式 | 32,768 | 带额外通用 padding；Stage9 用的就是该长度 |
| 小米 SM8150 `VENUS_BUFFER_SIZE(NV12)` | 24,576 | Y/UV layout + 4 KiB UV gap + 总体页对齐 |
| 本地后续主线通用公式 | 20,480 | 移除了额外 padding，但不是 Xiaomi VPU5 精确公式 |
| firmware minimum payload | 18,432 | 最低有效数据，不等于 host allocation layout |

0018 只在 IRIS1 encoder + NV12 使用原厂 24,576 公式，并在 instance open 时快照，防止
模块参数在活跃 VB2 mappings 下改变。它没有把 `filled_len` 改成 24,576。

#### ENC-DMA-02：raw source queue 双向 DMA

原厂 `msm_smem.c:92,127,156,430,448,473` 对 dma-buf attachment、unmap 和 CPU access
统一使用 `DMA_BIDIRECTIONAL`。旧 VB2 source queue按设备只读使用 TO_DEVICE；该方向在
正常 DMA API 理论上可行，但与固件/VPU5 对 buffer metadata/cache 的行为不一致。0018
对 IRIS1 encoder source queue 设置 `bidirectional=1`，让 vb2-dma-contig 采用双向映射；
Test16 证明 CAPTURE 仍为 `bidirectional=0` 且复位发生在首 ETB 后。0031 继续把 IRIS1
encoder CAPTURE queue 设置为双向，与原厂所有 video dma-buf 的映射方式一致，
并在 open 时快照。这是原厂语义迁移，不是对所有 decoder/其他 SoC 全局改方向。

两项修正在同一构建中存在，是因为每次编译代价高；日志仍分别输出 size 和 direction，
能在实机归因。**它们尚未实机验证，绝不能提前写成“编码已修好”。**安全 gate 默认 N，
stage 默认 0，保持不能意外越过 ETB。

### 8.6 EBD、recon 与 bandwidth 的后续链

若第一 ETB 不再复位，下一准入点不是立刻开放 codec，而是确认：

1. 收到 tag 匹配的 EBD，公共 prefix 正确完成 raw VB2 buffer；
2. 若包长 80/84，解析 flags、recon index、7-bucket UBWC CR、complexity、sync picture；
3. 至少一个 FBD 返回非空 Annex-B H.264，tag/filled/offset 在 allocation 内；
4. STOP/RELEASE 后再释放所有 VB2/internal DMA，设备回 suspended；
5. 30、300 帧无 tag 重用、double completion、泄漏或 stale bufreq；
6. 统计只作为动态 bandwidth 的输入，未验证公式前不更改 ICC vote。

原厂 recon list 的作用是把 `frame_index` 对应到 CR/CF bookkeeping；再次强调，它不要求
host 向 firmware SET 一块 type=9 静态 DMA。

### 8.7 encoder controls 全面处置

当前标准 V4L2 controls 已覆盖 bitrate/mode/peak/CQ、frame RC、force-key/GOP、B frames、
H.264/HEVC profiles/levels/QP、entropy/deblock/8x8、AUD/header、multi-slice、hierarchical
layers/layer bitrate、LTR、intra-refresh、HDR10 CLL/mastering、VP8/VPX QP 等常用语义。
原厂私有 controls 中：

- 有标准 V4L2 等价的，必须映射标准 control，不复制 Qualcomm private ID；
- ROI QP、HDR10+、per-frame QP、DTS 等需要标准 per-buffer metadata 才能迁；
- secure、priority、operating-rate、low-latency、output-order 等需先证明标准 API 和用户；
- blur/HEIC/TME/VQZIP/CVP 等 Android 私有工作流不作为通用 codec 启动前置；
- menu range/default/skip mask 必须来自 SM8150 firmware capability，不能因通用 control
  存在就开放固件不支持的 profile/level。

### 8.8 encoder 准入矩阵

| 阶段 | 必须验证 | 通过标准 |
|---|---|---|
| 安全默认 | reboot 后 gate=N、stage=0 | 仅节点枚举，不会意外启动 encoder |
| 单帧 H.264 NV12 | 24,576 allocation、bidirectional、EBD、FBD | 非空 Annex-B，可被软件 decoder 解码，安全退出 |
| 30 帧 H.264 | tag 顺序、IDR/GOP、EBD/FBD count | 输出 30 帧，无 HFI/IOMMU 错误 |
| 300 帧 H.264 | buffer reuse、runtime counters | 可软件解码，STREAMOFF/close 后 suspended |
| H.264 压力 | 720p/1080p/4K、不同 fps/bitrate、10 min | 无复位/超时，合理频率/带宽 |
| H.264 controls | CBR/VBR、GOP、B、QP、profile/level | bitstream metadata/行为符合请求 |
| HEVC NV12 | Main、profile/level/QP | H.264 全准入后再开；同样单帧→300帧 |
| VP8 NV12 | profile/QP/rate | H.264 全准入后再开 |
| raw P010/UBWC | layout/constraints/modifier/DMA | 有实际用户态生产路径后再公开 |
| 生命周期 | repeated open/close、SIGTERM、timeout、suspend/resume | 无泄漏、stale completion、double free |
| 多实例 | dec+enc、enc+enc | SM8150 load/ICC 限制内稳定 |

## 9. 全语义域差异登记表

这是迁移的可执行 backlog。每一项都给出当前状态，避免后续重新比较同一问题或把已排除
项当新发现。

| ID | 语义域 | 原厂行为/真值 | 当前候选 | 状态/下一动作 |
|---|---|---|---|---|
| PLAT-01 | VPU generation | VPU5/HFI4 | IRIS1/HFI4 | 已实机 |
| PLAT-02 | codec core | MVS0 普通 codec，MVS1 CVP | 单 codec core | 已实机 |
| PLAT-03 | register window | 2 MiB | 1 MiB | 无越界证据；需要高 offset 时再改 |
| FW-01 | firmware name | Raphael `.mbn` | 相同 | 已实机 |
| FW-02 | version response | 变长/字符串 | raw 读取兼容 | 已实机 |
| PM-01 | PD/clock sequence | MVSC/MVS0/CVP + hw control | IRIS1 ops | 已实机 |
| PM-02 | software collapse | 1500 ms | parent 1500 ms | 已实机 |
| PM-03 | child autosuspend | vendor 单策略 | dec/enc 通用 2000 ms | 产品化确认，不是当前故障 |
| CLK-01 | v2 OPP | 240/338/365/444/533 MHz | 相同 | 已实机 |
| CLK-02 | firmware cycles | 760000/166667 | 通用公式 | 未完整迁；性能校准 |
| LLCC-01 | VIDSC0/1 | 2×512 KiB 给 firmware | syscache resource | 已实机 |
| ICC-01 | bus topology | CNOC固定、VideoP0→LLCC与LLCC→EBI动态、ARM9固定 | `cpu-cfg` + 端到端 `video-mem` | 框架等价；实机待验 |
| ICC-02 | bandwidth model | 通用 `msm_vidc_dyn_gov` | 0019 Q16 DDR/LLCC，单 path 取最大 | 宿主8向量通过；实机待验 |
| ICC-03 | startup Turbo | 前16个 EBD 前最大票 | 0019 EBD count 驱动 533MHz/6533000 | 宿主验证；Stage9关键待验 |
| IOMMU-01 | non-secure SID | v2 0x2300 | DT 对齐 | decode 已实机 |
| IOMMU-02 | secure CB | 三 secure SID/VA pool | SID 有，session/buffer policy 无 | secure 未实现 |
| IOMMU-03 | non-fatal fault attr | vendor domain attr | 无等价 | 不吞 fault；另行设计 |
| HFI-SYS-01 | capability parser | 多 payload 精确推进 | 0018 修 parser | 宿主验证、待实机 |
| HFI-SYS-02 | codec caps | SM8150 五解码/三通用编码 | 静态+firmware filter | 枚举需实机矩阵 |
| HFI-CMD-01 | WORK_ROUTE | HFI4 packet | 已迁 | decode 实机 |
| HFI-CMD-02 | WORK_MODE | VBR mode2 等 | 已迁 | encoder Stage0 |
| HFI-CMD-03 | buffer actual | actual + host-min | 已迁 | encoder Stage0 |
| HFI-CMD-04 | P010 constraints | HFI4 variable two-plane | 0018 已迁 | Main10 待实机 |
| HFI-CMD-05 | secure/private props | 多私有属性 | 未批量迁 | 有意排除/标准化 |
| HFI-MSG-01 | common EBD | 36-byte prefix | 已有 | decode/通用可用 |
| HFI-MSG-02 | VPU5 EBD tail | 80/84 bytes | 0018可选解析，0019两类session发布动态统计 | encoder 待实机 |
| HFI-MSG-03 | FBD variants | compressed/uncompressed | 当前已有 | H.264 decode 已过；encode 未到 |
| HFI-Q-01 | queue layout | shared queues/ring | IRIS1 queue/IRQ 修正 | firmware boot 已过 |
| HFI-Q-02 | queue corruption | vendor defensive logging | 当前边界校验/dump | 宿主 + 启动实机 |
| HFI-LIFE-01 | LOAD/START | internal 后执行 | Test13 Stage6/7 | 已到达 |
| HFI-LIFE-02 | STOP/RELEASE | 固件停后释放 DMA | staged 回滚 | Stage6/7 已到达 |
| DEC-FMT-01 | stable ENUM | capability 列表 | 0018 稳定枚举 | 宿主验证 |
| DEC-FMT-02 | strict TRY/S/G | 根据已知 bit depth | 0018 严格选择 | 宿主验证 |
| DEC-FMT-03 | P010 layout | 256/32/16 + 4KiB gap | 0018 已迁 | Main10 待实机 |
| DEC-FMT-04 | UBWC formats | NV12/TP10 UBWC | QC08C/QC10C | 用户态 import 未准入 |
| DEC-EVT-01 | source change | 更新格式并重建 capture | 当前已有，0018 强化日志/size | Main10 待实机 |
| DEC-BUF-01 | counts/requirements | firmware min/actual | 当前 helper/cache | 多 codec 待测 |
| DEC-BUF-02 | mapping rollback | 失败撤销 ownership | 0018 修复 | 宿主验证 |
| DEC-META-01 | HDR/color | vendor extradata | 标准 controls 只覆盖部分 | 未完整迁 |
| DEC-META-02 | interlace/conceal | vendor controls/events | 部分标准控制 | 未完整实测 |
| DEC-CODEC-01 | H.264 | 支持 | 30/30 MD5 | 已实机小样本 |
| DEC-CODEC-02 | HEVC Main | 支持 | MKV 30/30 | 已实机小样本 |
| DEC-CODEC-03 | HEVC Main10 | 支持 P010/TP10 | 旧路径 0 帧，0018 待测 | 阻断 |
| DEC-CODEC-04 | VP8 | 支持 | 能力路径存在 | 未实机准入 |
| DEC-CODEC-05 | VP9 | 支持 | 能力路径存在 | P0/P2 未实机 |
| DEC-CODEC-06 | MPEG2 | 支持 | 能力路径存在 | progressive/interlace 未实机 |
| ENC-CTRL-01 | standard controls | vendor 私有映射 | 当前标准 V4L2 覆盖常用项 | 范围/default 继续核 capability |
| ENC-CTRL-02 | RC timestamp | 独立 disable | Test15 已迁 | Stage9 仍复位，已排除根因 |
| ENC-CTRL-03 | work mode | VBR mode2 | Test14 已迁/验证 | 已排除根因 |
| ENC-BUF-01 | initial/final counts | 4/4 → 16/4 | 已迁 | Stage0 到达 |
| ENC-BUF-02 | scratch/persist | 6/7/8/4，5 条件 | 已迁 | Stage1--5 到达 |
| ENC-BUF-03 | recon | metadata/index | 当前不分配 static DMA | 正确；禁止回退 |
| ENC-BUF-04 | raw NV12 size | vendor 24,576@128x96 | 0018 vendor 公式 | 待实机 |
| ENC-DMA-01 | raw DMA direction | bidirectional | 0018 source queue 双向 | 待实机，首 ETB 关键 |
| ENC-DMA-02 | DMA snapshot | active mappings 不变 | 0018 open 时快照 | 宿主验证 |
| ENC-LIFE-01 | bufreq invalidation | format/session 改变失效 | 0018 增强 | 宿主验证 |
| ENC-LIFE-02 | map failure rollback | 恢复 count/list | 0018 增强 | 宿主验证 |
| ENC-LIFE-03 | stream stats reset | 每次 stream 清零 | 0018/0019 清 latest/recon/位图 | 宿主验证 |
| ENC-MSG-01 | EBD stats | recon/UBWC/complexity | 0018 解析，0019按recon聚合 | 等第一 EBD |
| ENC-BW-01 | CR/CF vote input | EBD 更新动态 vote | 0019 已接入通用动态模型 | 宿主验证；实机待验 |
| ENC-CODEC-01 | H.264 | 支持 | 首 ETB 复位 | 阻断，0018 待测 |
| ENC-CODEC-02 | HEVC | 支持 | 不开放 | H.264 稳定后 |
| ENC-CODEC-03 | VP8 | 支持 | 不开放 | H.264 稳定后 |
| ENC-CODEC-04 | TME | 私有 | 无 ABI | 有意排除 |
| ENC-FMT-01 | NV12 | 原厂 linear layout | 0018 修 size/DMA | 待实机 |
| ENC-FMT-02 | NV21/P010/UBWC/TP10/NV12_512 | 原厂认识 | 当前未公开/不完整 | 后续标准化 |
| UAPI-01 | private controls | Qualcomm Android UAPI | 不复制 | 有意排除 |
| UAPI-02 | secure sessions | private/DRM stack | 未实现 | 不宣称 |
| UAPI-03 | CVP | private compute video | 不迁 | 有意排除 |
| PROD-01 | experiment gates | 原厂量产无 stage gate | 当前默认 N/0 | 功能稳定前保留安全门 |
| PROD-02 | verbose logs | vendor debug 可配置 | 多代 test 标签 | 稳定后统一 dynamic debug |
| PROD-03 | stale cache/state | 原厂按 session 生命周期 | 0018 部分修正 | 长序列/多实例验证 |
| PANEL-01 | GNOME flicker | 非 Venus 语义 | 卸 Venus 后仍 GPU fault | 从 Venus 补丁拆分 |

## 10. 0018 的 35 个 hunk：已做与没做

0018 不是“完成适配”补丁，它只关闭当前证据最强的 Main10 与首 ETB 差异，并补齐这些
变化必需的 parser、rollback 和诊断。35 个 hunk 的逐项位置、行为、原厂对应和验证状态
见 `venus-sm8150-pending-hunk-ledger.md`。文件级统计如下：

| 文件 | + / - | 核心变化 | 状态 |
|---|---:|---|---|
| `core.h` | +16/-0 | per-instance size/DMA snapshot、EBD/recon/CR/CF counters | 宿主验证 |
| `helpers.c` | +23/-8 | queue direction 日志、IRIS1 P010 constraints | 宿主验证 |
| `hfi_cmds.c` | +16/-0 | HFI4 可变 plane constraints packet | payload 测试通过 |
| `hfi_msgs.c` | +59/-1 | VPU5 EBD tail、精确 UBWC/CF | packet-size 测试通过 |
| `hfi_msgs.h` | +22/-0 | 可选 tail structs | layout 测试通过 |
| `hfi_parser.c` | +4/-6 | capability payload/raw plane 修复 | parser invariant 通过 |
| `pm_helpers.c` | +12/-0 | EBD-derived BW 诊断，vote 不变 | 宿主验证 |
| `vdec.c` | +121/-45 | P010 vendor gap、稳定 ENUM、strict fmt、buffer trace/rollback | Main10 待实机 |
| `venc.c` | +77/-8 | vendor NV12 size、双向 DMA、cache/rollback/stats | 首 ETB 待实机 |

0018 明确没有做：

- 没有把 Main10 假报成 NV12；
- 没有修改 H.264/HEVC payload 内容或 userspace FFmpeg；
- 没有给 recon 分配 static DMA；
- 没有启用 SDM845 之外的新 bandwidth vote；
- 没有默认打开 encoder gate 或自动越过 Stage9；
- 没有开放 HEVC/VP8 encoder 或新 raw formats；
- 没有搬 Android private controls、secure/CVP/TME；
- 没有把 GNOME/Adreno/DSI 问题归因到 Venus。

### 10.1 0019 的 11 个 hunk：SM8150 动态带宽闭环

0019 把 0018 仅记录的 VPU5 EBD CR/CF/recon 统计接入 SM8150 实际选择的通用动态
governor。逐 hunk 依据、风险和验证见 `venus-sm8150-0019-hunk-ledger.md`。文件级统计：

| 文件 | + / - | 核心变化 | 状态 |
|---|---:|---|---|
| `core.h` | +18/-12 | IRIS1通用EBD/latest/per-recon动态统计 | 宿主验证 |
| `hfi_msgs.c` | +25/-11 | 两类session解析/聚合统计、EBD计数和input payload清理 | 宿主验证 |
| `pm_helpers.c` | +450/-13 | 完整Q16 DDR/LLCC公式、单ICC映射、前16 EBD Turbo | 8向量通过、实机待验 |
| `vdec.c` | +11/-0 | 新stream清空动态统计 | lifecycle通过 |
| `venc.c` | +11/-6 | 同步改名并清空per-recon状态 | lifecycle通过 |

0019 明确没有做：不复制 `msm-bus` ABI，不使用非目标 AR50 特有模型，不新增 DT bus
client，不解除 encoder 安全门，不假定单帧不复位等于编码稳定，也不替代 Main10/codec
矩阵、长时和多实例实机准入。

## 11. 宿主验证与仍缺的硬件证据

当前候选已运行 `scripts/test-iris1.py`，通过：

- 27 个 startup、6 个 shutdown、30 个 resume、9 个 suspend fault-injection 点；
- OPP restore、共享 session、重试、IRQ balance；
- firmware version 多格式和 debug rings；
- 3,968 次 HFI ring round-trip；
- HFI4 work route/mode；
- HEVC P010 helpers、plane constraints 和 exact SM8150 layout；
- HFI4 extended EBD 12-entry/payload invariants；
- SM8150 通用 DDR/LLCC Q16 governor 的 8 个精确数值向量；
- stable enumeration、strict selection、Main10 profile/P010 mapping；
- LLCC syscache、encoder protocol/DMA/EBD/PM/safety；
- panel LP brightness 的独立静态测试。

这只是 host/static verification。它不能模拟 VPU 对 IOVA 的真实读取、固件完成消息、
cache coherency、真实 ICC provider、DSI/GPU 并发或长期 bandwidth，因此 Main10、动态投票
和 encoder 都仍是待实机。

## 12. 下一次单构建、单轮实机验证计划

### 12.1 启动与回归，先确认没有破坏已通过能力

1. 确认 kernel release、firmware version、两 video 节点和唯一 encoder gate=N；
2. H.264 30 帧硬解与软件 MD5；
3. HEVC Main8 MKV 30 帧硬解与软件 MD5；
4. 等 10 秒，父设备、decoder、encoder core 全部 `suspended`；
5. 上述任一失败即停止，不进入 Main10/encoder。

### 12.2 Main10 一次性闭环

同一轮同时记录：ENUM_FMT、TRY_FMT、S_FMT、source-change 后 G_FMT、REQBUFS count、所有
QUERYBUF length、首个 DQBUF `bytesused/data_offset/flags`。预期 320x240 P010：stride 768、
allocation 299,008、有效载荷可为 245,760。然后依次：

1. 30 帧 FFmpeg framemd5 对软件参考；
2. 原始 V4L2 streaming 验证，排除 FFmpeg frame wrapper；
3. mpv 强制 `hevc_v4l2m2m`；
4. 1080p Main10 真实 MKV；
5. 若 FFmpeg/mpv 仍失败但 raw V4L2 布局正确，才把剩余责任定位到用户态；若 raw 也错，
   继续内核，不再泛称“FFmpeg 7.1 缺支持”。

### 12.3 decoder codec 矩阵

在一个脚本内生成/准备 H.264 Baseline/Main/High、HEVC Main/Main10、VP8、VP9 Profile0/2、
MPEG2 progressive/interlaced 样本。每个输出独立 framemd5、dmesg slice 和 PM 状态，不能
只看 FFmpeg exit code。动态分辨率、reopen/seek、10 分钟长片排在小矩阵之后。

### 12.4 encoder 在同一轮按失败即停顺序准入

不再跑 Stage0--8。先确认日志显示：raw allocation 24,576、source queue
bidirectional=1、四个 FTB、内部 buffers、LOAD/START 全部正确；使用持久远程 `dmesg -w`
和 `/dev/kmsg` marker，再只执行一次最小 H.264 NV12 ETB。机器重启本身就是失败结果。

若收到 EBD/FBD，自动脚本继续 30 帧 H.264，并验证 Annex-B 非空、可软件解码、
tag/count/offset、STREAMOFF 和 suspended；通过后在同一次构建中继续 30 帧 HEVC、VP8。
300 帧和长时压力属于基础三 codec 准入后的稳定性矩阵，不再要求为每个 codec 重编内核。

### 12.5 长时、性能和多实例

基础正确性全部通过后，才测 720p/1080p/4K、不同 fps/bitrate、10 分钟、多实例 dec+enc，
同步记录 clocks、ICC votes、temperature、CPU 和 EBD CR/CF。0019 已迁动态模型，但实机
验证前其票值只能作为候选数据，不能把一次短片成功外推为稳定支持。

## 13. 明确分离的非 Venus 问题

GNOME 拖动亮度或音量触发 Adreno 640 CCU translation fault、DPU hangcheck 和 DSI status=5；
在卸载 `venus_core/dec/enc`、移除 video 节点后仍能复现，因此与 Venus、UFS 速度和 encoder
gate 无因果证据。直接 sysfs brightness 压力可不闪，GNOME overlay 才触发，根因域是
GNOME/Mutter/Mesa/Adreno/DPU/DSI 合成。面板 patch 应从 Venus series 拆开独立维护。

VA-API 也是用户态 API，不等于 Venus。mpv/VLC 可经 FFmpeg 或 GStreamer V4L2 M2M 路径
使用硬解，内核 Venus 可用不会自动生成 VA-API driver。Vulkan/Adreno 与 Venus 是不同
硬件栈，不能互相作为支持证据。

## 14. 产品化边界和固定决策

1. 0028 已把所有 `venus-test7...15`/`venus-migrate` 日志统一为 `venus-sm8150`；
2. encoder 真正通过短流、STREAMOFF、错误恢复和 PM 前，唯一总 gate 默认 N；
3. 0027 已删除 0--9 staged 试验分叉和两个可选平台策略参数；
4. `bufreq_cache` 必须按 codec/format/count/profile/session generation 失效；
5. 原厂私有 ABI 只作语义参考，标准 V4L2/VB2/DRM metadata 优先；
6. H.264 encoder 稳定后再开 HEVC、VP8，10-bit/UBWC raw input 最后；
7. Main10 不得假报 NV12，RECON 不得静态分配，MVS1 不得当第二 codec core；
8. 0019 已实现独立 SM8150 ICC/bandwidth 模型；实机通过前保留回退证据，不退回 SDM845表；
9. 已排除的 Stage0--8、route/mode/RC timestamp/FTB 顺序不再重复消耗实机；
10. 每次新补丁必须更新独立 hunk 台账、当前逐行台账和本报告状态，不再靠聊天记忆。

## 15. 当前最终结论

全量审阅没有证明“只差一行”。它证明了两个最靠近现有故障边界、且有原厂逐行依据的
候选修正已经成组进入 0018/0019：Main10 的 HFI4 P010 constraints/4KiB layout、encoder
首 ETB 的 vendor NV12 allocation/bidirectional DMA，以及 SM8150 通用 DDR/LLCC Q16 动态
带宽、EBD 驱动的前16帧 Turbo 与 per-recon 统计。相关 parser、rollback 和生命周期测试
一起通过宿主验证。

但这份报告同样明确：Main10 尚未实机闭环，encoder 尚未收到第一 EBD，0019 动态
bandwidth 尚未实机验证，完整 metadata、VP8/VP9/MPEG2 实测、HEVC/VP8 encode 和长时
生命周期仍未完成。
在这些准入项通过前，不能宣称 Venus 已完整适配；后续迁移必须按本总账更新状态，而非
再次从零比较或凭节点枚举下结论。

## 16. Test17 结果与 0032 覆盖更新（2026-09-10）

Test17 已推翻第 15 节中“bidirectional DMA 是最后已知差异”的阶段性判断：source 和
capture 两个队列均为双向映射，地址均在原厂 non-secure IOVA 窗口内，仍在首个 ETB 后、
任何 EBD/FBD 前整机复位。DMA direction、FTB 顺序、internal types、route=2、mode=2、
533 MHz 与 runtime power pin 不再重复修改。

完整复核记录固定在 `venus-sm8150-encoder-full-path-audit-test17.md`。0032 一次性修正：

- CAVLC `cabac_model` 未初始化和 encoder 邻接 HFI packet/payload 栈垃圾；
- 默认 VUI/entropy/deblock/8x8/IDR/QP/profile/AUD/header/base-priority 的无条件重放；
- SESSION_INIT 的伪 4/4 count、STREAMON 的双 count 与二次 requirements query；
- RC_OFF/normal H.264/HEVC、VP8、CBR low-latency 的 VPU5 work-mode 策略。

原厂 resume 中的 `__set_subcaches()` 经完整状态调用图确认是 no-op：普通 suspend 不清
`sys_cache_res_set`。因此不加入重复 HFI syscache resource。单独 CDSP queue、secure CB、
TME/HEIC/CVP、vendor non-fatal fault attr 与 per-map upstream hint 也已分类为私有/框架差异，
不是 Test18 H.264 首帧前置修改。

0001--0032 的重放 tree 为 `065f0998c8b669e8c69db87d3947145834e95b9e`；0032 严格
checkpatch 0/0/0，宿主数值、HFI packet、PM、生命周期和 source invariant 全部通过。
ARM64 构建与第一 EBD/FBD 仍待实机，不能提前宣称编码已修复。

## 17. Test18 外部日志纠正与 0033（2026-09-10）

Windows 外部 SSH 保存的完整 `dmesg -w` 推翻了“Test18 又死于首 ETB”的未经证据判断。
实际最后边界是：SESSION_INIT、properties、internal SET_BUFFERS 和
LOAD_RESOURCES_DONE 均成功；驱动发出 START command 36 后不再收到任何消息。日志中没有
START_DONE、FTB、ETB、EBD 或 FBD。因此 Test18 死于固件处理 START，尚未进入首帧。

日志还给出直接矛盾：REQBUFS 时 OUTPUT `actual=4 host-min=2` 已提交；设置 properties、
route、mode 和 core 后，最终 firmware table 对同一 OUTPUT 要求 `min=4`。原厂在 REQBUFS
提交 count，但它的 controls 生命周期也在此前完成；mainline Venus 把 controls 延后到
STREAMON。0032 只移动 count 而没有移动整套生命周期，造成 Test18 回归。

0033 的处置是：

1. 删除 `venc_queue_setup()` 的 count HFI 命令；
2. 在 STREAMON 完成 controls/route/mode/core 后查询最终表；
3. 按该表提交 INPUT 16/host-min 3、OUTPUT 4/host-min 4；
4. 再查询一次，供 internal buffer 分配和 START 使用；
5. 恢复 Test17 已实机到达 START_DONE 的属性集合，但保留 0032 的 packet/payload 清零；
6. 移植原厂 `DMA_ATTR_IOMMU_USE_UPSTREAM_HINT` 到 `IOMMU_USE_UPSTREAM_HINT`，再到
   ARM LPAE MAIR 0xf4，仅应用到 IRIS1 encoder MMAP 与内部缓冲。

原厂的独立 CVP/CDSP queue、FastCVPD handoff 和 VIDC_CTRL_INIT bit 1 仍然一起排除，不能
只开一个 bit。现代 mainline VB2 的 imported DMABUF 路径也不能携带 queue-local allocation
attribute，因此 0033 的 cache mapping 准入范围明确是当前 FFmpeg MMAP 测试，不声称已完成
所有 DMABUF consumer。Test19 仍必须用外部日志证明 START_DONE、EBD、非空 FBD、可软解
输出和完整 teardown；静态验证不能代替实机结果。

0001--0033 从固定基线重放后的 tree 为
`ff4095f00d7995c4ac0adb5797663c4796c5982f`。0033 已通过严格 checkpatch
0/0/0、apply check、diff check、测试脚本语法/self-test 和全部 IRIS1 宿主测试。
