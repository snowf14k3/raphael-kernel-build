# Test15 相对基线的 173 个 hunk 逐项审阅台账

配套原始文件：`venus-sm8150-test15-vs-base-full.diff`。该 diff 相对基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，SHA256 为
`207d3af2438927abd9ff3224b3828763b4558de55e775e1e9845e1c23d782aca`（LF 规范化）。

本台账中的“通过”只指该段覆盖的边界，不外推整个 codec。`诊断`表示有助于定位但不
是功能适配；`实验门`表示最终产品必须移除或默认关闭；`遗留`表示审阅发现仍要修。

## 001：Raphael DTS

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 001 | `&venus` firmware-name | `.mdt` 改 `.mbn`，同时与 core resource 名称一致 | 固件已实机加载；保留 |

## 002--012：Samsung AMS639RQ08 面板

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 002 | includes | 为 jiffies、mutex、delayed_work 加头文件 | 编译依赖；保留于独立面板补丁 |
| 003 | `struct ams639rq08` | 加 250 ms 间隔、pending/cache/prepared 状态和锁 | 合并亮度请求；与 Venus 无关 |
| 004 | `prepare()` locals | 保存准备阶段要恢复的 brightness | 正确 |
| 005 | `prepare()` tail | 标记 prepared，并立即调度缓存亮度 | 生命周期合理；需防止 panel enable 前 DCS 时序风险 |
| 006 | `unprepare()` | 先清 prepared，再同步取消 work | 避免关屏后 DCS；正确 |
| 007 | brightness worker/update/get | DCS 改由 LP delayed work，update 只合并，get 返回缓存 | 直接 sysfs 压力通过；GNOME 仍触发独立 GPU/DPU fault，不能称闪屏已修 |
| 008 | create helper signature | backlight 私有数据由 dsi 改为 panel ctx | 与新 worker 状态匹配 |
| 009 | register backlight | `bl_get_data()` 保存 ctx | 与 008 配套 |
| 010 | probe init | 初始化 mutex/work/默认亮度 | 正确；默认 1023 应最终从 panel/boot state 同步 |
| 011 | probe call | 传 ctx 创建 backlight | 与 008/009 配套 |
| 012 | remove | 清 prepared 并取消 delayed work | 防 UAF；正确 |

## 013--021：Venus core 与 SM8150 resource

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 013 | `venus_probe()` PM ops | selector 从 HFI version 改接收 core，以区分 IRIS1 | 必须；让 HFI4 的 SM8150 不再误走泛型 v4 PM |
| 014 | probe runtime PM | 从 resource 配置 autosuspend delay | 1500 ms 与原厂策略对齐 |
| 015 | probe 首次 put | 有 delay 时 mark-busy + autosuspend；修正只把负值当错误 | runtime PM 已实机通过 |
| 016 | runtime suspend 前半 | HFI suspend 后先 drain/disable IRQ，再下电；IRIS1 失败走统一回滚 | 避免掉电后 IRQ 访问寄存器；通过 |
| 017 | runtime suspend rollback | 重上电、HFI resume、IRQ balance，并报告 rollback 失败 | 错误路径增强；通过普通 idle，故障注入仍需长期覆盖 |
| 018 | runtime resume locals | 为分层 rollback 增加 error | 结构性配套 |
| 019 | runtime resume | video/cpucfg/power/HFI 分段回滚，成功后恢复 IRQ | 已消除旧 idle timeout；保留 |
| 020 | `sm8150_res` | codec core 2→1、VPP pipes=2、max load 注释、autosuspend=1500 | MVS0 是 codec、MVS1 是 CVP；正确 |
| 021 | `sm8150_res.fwname` | `.mdt`→`.mbn` | 与 001 一致；已通过 |

## 022--029：核心状态结构

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 022 | constants/forward declaration | 两个 LLCC slice、encoder min=4、LLCC type | 原厂平台数据对应；保留 |
| 023 | `venus_resources` | per-SoC autosuspend delay | 通用化合理 |
| 024 | `venus_core` kernel-doc | 记录 IRIS1 ownership 字段语义 | 与 025 一致 |
| 025 | `venus_core` fields | PD/clock/hwmode/OPP/IRQ/LLCC ownership | 回滚需要；稳定后可收敛为专用 state struct |
| 026 | `clock_data` | 保存 work_route 供 load/freq 除 pipe | 原厂负载语义；正确 |
| 027 | encoder stage enum | 0--9 分离 protocol/internal/load/start/FTB/ETB | 实验门；Stage0--8 已通过，产品化删除 |
| 028 | `venus_inst` kernel-doc | bufreq cache、PM pin、stage 注释 | 配套 |
| 029 | `venus_inst` fields | 完整 bufreq 快照、valid、PM ownership、stage | cache lifetime 仍需 generation 化；stage 最终删除 |

## 030--057：公共 helper、buffer 与 staged 生命周期

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 030 | includes | 使用 `SZ_4K` | 编译依赖 |
| 031 | CBR threshold | 原厂 route 决策用 720p30 macroblock/s | 静态对齐 |
| 032 | codec mapping | 提取 `venus_helper_get_codec()`，补 H264_NO_SC，并复用 capability 检查 | 避免 HFI/S_FMT 两套映射漂移；正确 |
| 033 | `intbufs_set_buffer()` query | 区分固件未请求、零 size，并记录实际 req | 诊断；缺必需类型时不能总是静默，按类型严格化仍是遗留 |
| 034 | internal alloc size | IRIS1 encoder 将固件 requirement 向上对齐 4 KiB并用同一 size 登记 | 与原厂 `msm_smem` 对齐；Stage1--5 通过 |
| 035 | internal IOVA | HFI4 地址截断前拒绝高 32 位 | 安全门；正确 |
| 036 | internal SET logs | 记录 type/index/req/rounded size/IOVA 和 queued | 诊断；稳定版转 tracepoint |
| 037 | unset accumulator | 增加 `first_err`，不让后一次成功覆盖前一错误 | 正确 |
| 038 | RELEASE logs/error | 每块释放前后记录并保留首错 | Stage1--5 通过；日志降级 |
| 039 | unset return | 返回 first error | 正确 |
| 040 | internal stage prefix | Stage0 禁 DMA，Stage1--5 只分配前缀 | 实验门；边界已完成，不能继续留作产品逻辑 |
| 041 | frame IOVA | 普通 ETB/FTB 也拒绝高 32 位 | 正确；首 ETB 地址已通过此检查 |
| 042 | per-buffer scaling | IRIS1 不再忽略 `venus_pm_load_scale()` 错误 | 正确；频率/ICC 必须共同验证 |
| 043 | ETB/FTB logs | 入队前打印 wire 参数，入队后打印 ret | 诊断；首 ETB 边界证据来源 |
| 044 | get-bufreq local | 抽象选择 cache 或即时 reply | 045 配套 |
| 045 | `venus_helper_get_bufreq()` | IRIS1 encoder 在 valid 时只读最终快照 | 避免每类内部 buffer 重复 GET；正确但 cache 失效条件要完善 |
| 046 | cache all bufreqs | 校验 type/重复/count/min/alignment，要求 IO 项，保存完整表 | Stage0 通过；应增加 generation 和 per-codec size 上限校验 |
| 047 | profile level | IRIS1 H.264 UI 默认 5.1 映射 wire level 0/UNKNOWN | 解决主线无 UNKNOWN menu；静态对齐 |
| 048 | P010 frame size | stride 从 128 调整到 256 bytes | 与原厂 P010 对齐；Main10 仍缺 HFI4 plane constraints |
| 049 | work-mode locals | 引入 encoder controls | 050 配套 |
| 050 | `get_work_mode()` | IRIS1 RC_OFF/CBR/CQ→1，VBR→2 | Test14 证实当前 VBR mode2 与原厂一致 |
| 051 | set work mode/route | mode1 补 low-latency；新增 decoder/encoder route2/route1 决策、pipe clamp、保存 route | HFI4 WORK_ROUTE 是 Test7 解码关键修复；已通过 H264/Main8 |
| 052 | input count | HFI4 分离 actual 与 firmware min-host，并标明 initial/final | Stage0 日志确认 4→16/3 |
| 053 | output count | 同样分离 compressed output actual/host-min | Stage0 确认 4/4 |
| 054 | output2 count | 初始化 count_min_host，避免栈/旧字段 | 防御性正确 |
| 055 | post-STREAMON buf queue | Stage8 只放 FTB，低 stage 都不下普通 DMA | 实验门 |
| 056 | common stream prepare | 检查 internal/load/start 各 stage，PM scale 错误传播，完整 staged rollback 日志 | Stage1--8 逐级通过；稳定版移除分叉但保留错误传播 |
| 057 | M2M run order | Stage8 仅 destination/FTB，Stage9 才 source/ETB；正常路径保持 FTB→ETB | 证明 first-ETB 边界；实验门 |

## 058--060：helper API

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 058 | `helpers.h` | 声明统一 codec mapping | 与 032 配套 |
| 059 | `helpers.h` | 声明 bufreq cache | 与 046 配套 |
| 060 | `helpers.h` | 声明 work route | 与 051 配套 |

## 061--066：HFI wrapper 与状态机

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 061 | `hfi.c` codec mapper | 删除本地 `to_codec_type()`，改 include/reuse helper | 消除重复映射；正确 |
| 062 | wait session reply | timeout 时 dump HFI state | 诊断；无协议变化 |
| 063 | session init | 使用统一 codec；send/response 失败 dump；成功日志 | 固件 session init 已通过 |
| 064 | unload resources state | IRIS1 允许 LOAD_RESOURCES_DONE 直接 release | 原厂 rollback 状态；Stage6 通过 |
| 065 | unset buffers locals | 显式取得 core/ops | 仅配套重构，无行为风险 |
| 066 | get property | 请求/应答失败 dump，记录 IRIS1 query | 诊断；bufreq 两次查询已通过 |

## 067--079：HFI 命令封包

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 067 | includes | packetizer 访问 `IS_IRIS1`/core | 编译依赖 |
| 068 | syscache packet | 构造 HFI resource id=2、多 subcache entry、hash handle | 与原厂 wire struct 对齐；启动已通过 |
| 069 | encoder ETB | 显式清零 VPU5 最后一保留字 | 确定性加固；Test15 仍复位，已排除为根因 |
| 070 | HFI1 count locals | 把 generic 输入与 1xx wire struct 分型 | 避免类型混用；正确 |
| 071 | HFI1 property | 取得 inst 用于 IRIS1 level 特例 | 072 配套 |
| 072 | profile/level check | IRIS1 允许 level=0/UNKNOWN | 与原厂默认对齐 |
| 073 | rotation property alias | VPU5 parameter namespace走现有 rotation payload | 静态对齐；Stage0 packetizer 接受 |
| 074 | low-latency property | `hfi_enable` payload | 与 mode1 配套；当前 VBR 不触发 |
| 075 | bitrate-savings property | `hfi_enable` payload | 原厂非 VBR 路径；当前 VBR 不触发 |
| 076 | HFI4 buffer count | wire `count_min_host` 使用调用者字段，不再复制 actual | 关键修正；Stage0 通过 |
| 077 | HFI4 WORK_ROUTE | 补 `{video_work_route}` payload | Test7 解码从 timeout 到成功的关键项 |
| 078 | HFI4 FRAME_QP | 校验 8-bit QP、清零 packed v2、layer/enable | 原厂格式对齐；当前 VBR 自动 QP 时不发送 |
| 079 | command header | 声明 syscache packetizer | 068 配套 |

## 080--086：HFI 常量与 wire structs

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 080 | `HFI_BUFFER_TYPE_MAX` | 11→12，索引可覆盖 type9 recon 及完整数组 | 修复 parser 越界边界；正确 |
| 081 | property ID | `VENC_LOW_LATENCY_MODE=0x2005022` | 与原厂一致 |
| 082 | property ID | `VENC_BITRATE_SAVINGS=0x2005038` | 与原厂一致 |
| 083 | property ID | `PARAM_VPE_ROTATION=0x3007001` | 与原厂 VPU5 namespace 一致 |
| 084 | layer ID | all-layer `0xff` | 原厂 VPU5 bitrate/QP 语义 |
| 085 | syscache structs | resource 2、subcache size/id、flex array | 与原厂 SYS_SET_RESOURCE payload 对齐 |
| 086 | count struct | generic count 加 host-min；另保留 1xx 两字段 wire struct | 防止改变旧 HFI wire layout；正确 |

## 087--089：HFI 消息解析

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 087 | firmware version | 固定宽度安全复制、边界检查、原始/解析日志 | 避免未 NUL 终止；固件版本已读取 |
| 088 | buffer requirement loop | 在 memcpy 前检查 index，消除最后一项越界写 | 明确安全修复 |
| 089 | packet size alternatives | `pkt_sz2=0` 时不能让第二比较恒真，从而漏报短包 | 明确 parser 修复；保持较长扩展包兼容 |

## 090--114：Venus HFI queue、IRQ、LLCC 与 suspend

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 090 | includes | atomic/module/LLCC | 配套 |
| 091 | HFI device counters | command/message/IRQ 计数 | 诊断 |
| 092 | debug option/packet names/state dump | 可选完整 header 日志、命令名称、状态摘要 | 诊断；默认低噪声，稳定版保留 dynamic debug |
| 093 | debug queue peek/dump | 不消费 ring 地快照 debug queue，输出 q0/q1/q2/counters | 取证；注意锁和 ring 边界由 094--099 保护 |
| 094 | queue write validation | 校验 packet size/alignment、qsize、indexes、free words，READ_ONCE | 明确健壮性修复；不能修复错误上层 packet 内容 |
| 095 | queue read locals | 增加 type/bytes/available | 096/097 配套 |
| 096 | queue header read | READ_ONCE + qsize/index 上下界 | 防 firmware/corruption 造成越界 |
| 097 | packet read | 校验最小 header、word alignment、packet 不超过 available | 明确安全修复 |
| 098 | queue empty re-read | indexes 使用 READ_ONCE | 并发稳健性 |
| 099 | packet dump | 只在 read 成功后 dump | 避免输出无效 buffer |
| 100 | command queue write | 增 command counter/trace header | 诊断 |
| 101 | set syscache | 从两个 LLCC descriptor 取 size/id，构包并排队 | 原厂 SYS_INIT 后资源；已通过启动 |
| 102 | halt AXI | IRIS1 像原厂 VPU5 一样跳过 legacy v4 AXI HALT | 防错误寄存器序列；runtime PM 通过 |
| 103 | message queue read | 非 ENODATA 错误限速报告，计数/trace response | 诊断 |
| 104 | debug queue wrapper | 删除重复锁 wrapper，统一使用 `_nolock` | 与 106 显式锁配套 |
| 105 | SYS defaults | IRIS1 不在 SYS_INIT 发 power-collapse property | 原厂在 session 默认阶段发送；109 配套 |
| 106 | flush debug queue | 在同一 mutex 下读取，严格 packet/msg_size 边界并安全打印 | 明确安全修复 |
| 107 | ISR | IRIS1 IRQ counter | 诊断 |
| 108 | core init | SYS_INIT 后立即 supply syscache | 与原厂顺序一致；已通过 |
| 109 | session init | IRIS1 每个 session 前发 power-control default | 与 105 配套；解码 session 已通过 |
| 110 | HFI resume | 可选成功日志，失败统一 dump | 诊断；resume 已通过 |
| 111 | suspend3xx | IRIS1 打 CPU/control status；PC_PREP 前 idle fail 不破坏状态 | 修复旧启动 idle -110；已通过 |
| 112 | suspend success | 可选日志 | 诊断 |
| 113 | HFI create | counters 初始化 | 配套 |
| 114 | header | 声明 state dump | 配套 |

## 115--126：IRIS1 PM、clock、LLCC、load scaling

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 115 | includes | LLCC API | 配套 |
| 116 | core clock rate | IRIS1 保存目标 freq，实际 shared IRIS source 由 OPP/clock path处理 | 533 MHz 已实机；仍需审查错误返回是否可能被掩盖 |
| 117 | loaded-core load | 按 work_route 除以 pipe 数 | 原厂计算语义 |
| 118 | decide core load | 当前实例 active/LP load 同样按 route 分摊 | 原厂计算语义 |
| 119 | decide core quality | IRIS1 普通 encode 显式 max-quality/non-power-save | 与原厂 core/power mode 对齐；Stage0 接受 |
| 120 | LLCC lifecycle | get/activate/deactivate/put VIDSC0/1，位图回滚 | 启动日志确认两 slice；保留 |
| 121 | IRIS1 power lifecycle | 三 PD、reset、MMCX OPP、三 clock group、hwmode、LLCC、回滚、coreid | Test7 起启动/runtime PM 通过；复杂回滚需继续故障注入 |
| 122 | per-instance freq | VPP freq 按 work_route 分摊 | 与 117/118 一致 |
| 123 | load scale | 无真实 payload 保持 boot vote；前16个 input turbo；首 input 诊断 | 533 MHz 解码通过；策略偏保守，需 SM8150 带宽模型替换 |
| 124 | max freq lookup | IRIS1 已在前段取得 max，不重复覆盖 | 配套 |
| 125 | PM ops | 新增专用 iris1 ops，selector 看 core/vpu 而非只看 HFI4 | 架构关键修复 |
| 126 | header | PM selector signature 更新 | 配套 |

## 127--138：decoder format、source-change 与诊断

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 127 | format classifiers | NV12/QC08C 归 8-bit，P010/QC10C 归 10-bit | 正确；只表示 capture format class |
| 128 | exact format lookup | bit-depth 已知时拒绝 8/10-bit 交叉选择 | S/TRY_FMT 语义改善 |
| 129 | enum-by-index | 删除仅对 QC10C 的 bit-depth 过滤 | **遗留不一致**：ENUM 可显示当前 S_FMT 会拒绝的格式；需统一 unknown/known depth 规则 |
| 130 | try format fallback | 10-bit capture 默认 P010，8-bit 默认 NV12 | Main10 正确选到 P010；不能假报 NV12 |
| 131 | capture height alignment | QC10C 16，其余 32 | 与压缩/线性布局区分；静态合理 |
| 132 | capture stride | P010 256；QC10C 4/3 后 256；NV12 128 | P010 与原厂对齐；完整 size/constraint 仍欠 |
| 133 | output S_FMT | 选择 compressed codec 时立即更新 `hfi_codec` | 使后续 capture enum 使用正确 capability；必要 |
| 134 | decoder route | IRIS1 使用原厂 route helper | H.264/Main8 已通过 |
| 135 | queue setup | PM/session/count/put 每个失败点单独日志 | 诊断；曾定位 SESSION_INIT timeout |
| 136 | first capture | 记录 type/tag/bytes/offset/fourcc/flags | Main10 证明固件回收 P010 buffer |
| 137 | source change 前置格式 | 在计算新 format 前先更新 bit depth 与 fmt_cap | 修复原先按旧深度算 size/stride |
| 138 | source change tail | 删除重复的晚更新，增加完整格式日志 | 正确；仍需 ioctl/QUERYBUF userspace 证据 |

## 139--142：decoder controls

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 139 | set-control cache | HEVC profile 写入 `profile` | 配套 |
| 140 | volatile get | HEVC profile 返回 firmware/event 值 | 配套 |
| 141 | handler capacity | 12→13 | 与新增 control 匹配 |
| 142 | HEVC profile menu | 公开 Main/Main10 volatile menu | Main10 识别通过；tier/level仍不完整 |

## 143--164：encoder 属性、会话、PM 与 staged 启动

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 143 | module params | encoder enable 默认 N、stage 0--9、auto QP sentinel | 安全实验门；编码稳定前必须默认关闭 |
| 144 | property function | 增 `set_work` 避免 IRIS1重复/错序发送 route/mode | 原厂顺序配套 |
| 145 | property locals | NAL format payload | 148 配套 |
| 146 | property prologue | 非 IRIS1 可在函数内发 route/mode，IRIS1 由 start 顺序控制 | 保持其他 SoC 行为 |
| 147 | H.264 VUI | IRIS1 默认 disable/zero，其他 SoC 保持 enable+timescale | 原厂默认对齐；用户显式 VUI 语义仍需标准化 |
| 148 | IRIS1 properties | RC timestamp、非 VBR bitrate-savings、H264/HEVC Annex-B | Test15 Stage0 确认 timestamp=1；Stage9仍重启，timestamp 已排除为根因 |
| 149 | bitrate | IRIS1 使用 all-layer id，跳过 VPU5 无封包的 MAX_BITRATE | 静态对齐；峰值策略需 per-codec capability |
| 150 | QP/QP range | RC 开时让固件自动；RC off 用 127 sentinel；HFI4 frame-QP/all-layer | 原厂语义；Stage0 packetizer通过 |
| 151 | LTR mode | IRIS1 仅 nonzero count 时发送 | 避免原厂不会发的零 LTR 属性 |
| 152 | session init | 安全锁；先发4/4；IRIS1线性 NV12跳过 plane-actual stride | open/Stage0通过；只适用于 NV12，未来 P010不能跳过 constraints |
| 153 | session init properties | IRIS1 延迟到最终 STREAMON，其他 SoC保持原路径 | 避免属性重复和错序 |
| 154 | queue min constant | 魔数4改命名常量 | 无行为变化 |
| 155 | queue setup | IRIS1 枚举阶段不提前查询不完整 firmware req，先用4 | 修复 open/queue时序；最终 req 在 STREAMON查询 |
| 156 | session release PM | resume 失败不向掉电 firmware 发 SESSION_END；cache失效 | 安全；错误时可能遗留 firmware state，只能靠 core recovery，需长期验证 |
| 157 | release fallback | cache/list/core cleanup label | 与 156 配套 |
| 158 | preflight/rotation/stage | 校验全部 PD/clock/hwmode/LLCC/OPP/core和NV12配置；stage snapshot | Stage0安全；实验门最终删除，resource invariant可保留 |
| 159 | start diagnostics | 打 codec/尺寸/input/output size/buffer count，并先失效 cache | 诊断 |
| 160 | start main sequence | PM pin、rotation→properties→route→mode→core、两次 req、actual/size、final cache | Stage0证实，原厂顺序基本对齐；首 ETB仍失败 |
| 161 | start success/error | 成功把 PM ref交给 stream；错误释放 core/cache/ref | PM 退出已通过 Stage0--8 |
| 162 | custom stop | STOP/UNLOAD/END 完成后才释放 stream-long PM ref | 生命周期关键；Stage7/8 cleanup通过 |
| 163 | VB2 ops | 使用 custom stop wrapper | 与 162 配套 |
| 164 | close | 处理 resume失败和异常遗留 `enc_pm_active` | 防 ref 泄漏；需并发 close/error压力测试 |

## 165--173：encoder controls/defaults

| ID | 位置 | 逐段结论 | 状态/后续 |
|---:|---|---|---|
| 165 | dynamic bitrate | IRIS1 使用 all-layer id 0xff | 与 149 一致 |
| 166 | H.264 8x8 validation | 只有开启 8x8 才要求 High profile | 修复 Baseline+disabled 被错误拒绝；encoder open 已通过 |
| 167 | volatile min buffers | IRIS1 枚举时直接返回4，不提前 GET firmware | 与 155 时序一致 |
| 168 | init locals | profile/level/8x8/frame-RC 默认可按 SoC选择 | 配套 |
| 169 | IRIS1 defaults | Baseline、8x8 off、frame-RC off、UI level5.1→wire unknown | 与原厂 open 默认对齐；FFmpeg随后显式改成VBR/RC on |
| 170 | profile/level controls | 使用 per-SoC默认变量 | 配套 |
| 171 | 8x8 control | 使用 IRIS1 default 0 | 修复 open -EINVAL 的一半 |
| 172 | frame RC control | 使用 IRIS1 default 0 | 原厂默认；实际 FFmpeg值由 control override |
| 173 | handler setup error | IRIS1 打具体 control defaults error | 诊断；Test11据此确认 open修复 |

## 覆盖结论

- 编号必须是 001--173 连续且各出现一次；完整增删文本以配套 raw diff 为准。
- 173 个 hunk 中，最危险的未决功能不在已经通过的内部 buffer/LOAD/START/FTB，而在
  encoder 首个 raw ETB 的硬件读取，以及 decoder Main10 source-change 后的 P010 跨层
  布局。
- 面板 002--012 虽在同一 Test15 diff 中，但已经用“卸载全部 Venus 后仍复现”排除为
  codec 关联；后续应拆成独立补丁和独立审计。
