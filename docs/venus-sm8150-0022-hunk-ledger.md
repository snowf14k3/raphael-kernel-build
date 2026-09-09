# 0022 的 34 个 hunk：SM8150 encoder controls 与 HFI 属性

> 补丁：`patches/0022-media-venus-align-SM8150-encoder-controls.patch`
> SHA256：`e7ec9ce3c7cb6c679f0451011a7210346b5bbdacef05a2013709a7d36aef4603`
> 统计：7 文件、34 个 hunk、+354/-48。原厂主依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`。

| # | 当前文件 / hunk | 迁移或修正 | 原厂逐行依据 | 边界和风险控制 |
|---:|---|---|---|---|
| 001 | `core.h:280` | 保存 rotation、horizontal flip、vertical flip | `msm_venc.c:545,1645`；`msm_vidc.c:1029-1078` | 仅 IRIS1 暴露 controls |
| 002 | `core.h:311` | 保存 H.264 SAR enable/idc/extended width/height | `msm_venc.c:826-845,2240-2426` | 用标准 V4L2 SAR controls 代替 vendor 私有 controls |
| 003 | `core.h:329` | 保存 HEVC tier | `msm_venc.c:473,1601-1616` | 与 profile/level 同包发送 |
| 004 | `helpers.c:1120` | profile-level helper 增加 tier 参数 | `msm_venc.c:1601-1616` | 调用者显式提供，避免全局隐式状态 |
| 005 | `helpers.c:1137` | IRIS1 HEVC tier 编入 level 高 4 bit | `vidc_hfi_helper.h:153-154`；原厂 HEVC tier packetization | 限制为 IRIS1 encoder，其他 SoC wire ABI 不变 |
| 006 | `helpers.c:1394` | work-mode helper不再推导 low-latency | `msm_vidc.c:902-1027` 与 start order | 修正早期错误假设：work mode 和 low latency 是独立属性 |
| 007 | `helpers.c:1402` | 仅发送 WORK_MODE，并收窄日志字段 | 同上 | low latency 改由 internal-config 严格按 RC/codec 条件发送 |
| 008 | `helpers.h:72` | 同步 profile-level helper 原型 | 对应 hunk 004 | 内部 API 编译一致性 |
| 009 | `hfi_cmds.c:823` | rotation packetizer 接受 horizontal+vertical 的组合值 | `hfi_packetization.c:1537-1551` | 组合值必须是 bitwise `2|4=6` |
| 010 | `hfi_cmds.c:876` | 增加 ASPECT_RATIO、VBV_HRD、BASELAYER_PRIORITY packet payload | `hfi_packetization.c:1817-1836,2021-2034` | 属性 ID、结构大小和 payload 长度逐项固定 |
| 011 | `hfi_cmds.c:1368` | HFI4 QP range 接受已打包的 `0x00bbppii` 并保留 layer/enable | `hfi_packetization.c:1422-1448` | 修复原实现把单个 QP 复制到 I/P/B、覆盖 layer 的错误 |
| 012 | `hfi_helper.h:544` | 增加 config namespace 的 VBV 与 base-layer property ID | `vidc_hfi_helper.h:364-369` | 避免误用 param namespace 的旧 VBV ID |
| 013 | `hfi_helper.h:824` | 定义单字段 VBV payload | `hfi_packetization.c:2021-2034` | wire size 为 4 byte |
| 014 | `hfi_helper.h:1076` | 修正 vertical flip `3→4`，定义 BOTH=`2|4` | `vidc_hfi_helper.h:783-784` | 原值 3 与原厂 wire ABI 不符 |
| 015 | `venc.c:24` | 定义原厂 720p30 CBR 宏块阈值 | `msm_vidc.c:941-963` | 阈值只服务 IRIS1 internal config |
| 016 | `venc.c:796` | 新增 QP 打包、H.264 SAR 映射和完整 internal-config helper | `hfi_packetization.c:1422-1448,1825-1836,2021-2034`；`msm_vidc.c:902-1027` | fps=0 立即 `-EINVAL`；每次 HFI 失败立即停止，避免半配置继续启动 |
| 017 | `venc.c:928` | QP range v2 清零初始化 | 原厂结构只填明确字段 | 防止 reserved/enable 未初始化进入固件 |
| 018 | `venc.c:1004` | H.264 属性序列加入 SAR | `msm_venc.c:2417-2426` | 未启用或 IDC unspecified 时不发包 |
| 019 | `venc.c:1233` | H.264/HEVC/VP8 分别按 I/P/B 打包 min/max QP，并用 all-layer | `hfi_packetization.c:1422-1448`；`msm_venc.c:2324-2354` | RC-off auto QP 同样按三字节打包 |
| 020 | `venc.c:1331` | profile-level 调用携带 HEVC tier | `msm_venc.c:1601-1616` | 非 HEVC tier 不进入 wire level |
| 021 | `venc.c:1345` | AUD property 失败立即返回 | 原厂 start property error propagation | 防止失败后继续 LOAD/START |
| 022 | `venc.c:1380` | encoder 普通属性末尾执行 IRIS1 internal config | `msm_vidc.c:1093-1140` | 保持 rotation→properties/internal→route→mode→core 的原厂相对顺序 |
| 023 | `venc.c:1710` | rotation/flip 映射并在 90/270 度交换 output frame size | `msm_vidc.c:1029-1078` | 非法角度在任何 DMA/START 前失败 |
| 024 | `venc_ctrls.c:15` | multi-slice control 范围改为原厂有效上限 | `msm_venc.c:555-589`；`msm_vidc.c:978-1018` | 真正可用值仍由 runtime 分辨率/fps/RC policy收窄 |
| 025 | `venc_ctrls.c:96` | s_ctrl 保存 rotate/hflip/vflip | `msm_venc.c:1645-1658` | layout-changing rotation 标志见 hunk 032 |
| 026 | `venc_ctrls.c:143` | s_ctrl 保存 HEVC tier 和 H.264 SAR 四项 | `msm_venc.c:1601-1616,2240-2426` | 标准 controls 到 vendor semantics 的显式映射 |
| 027 | `venc_ctrls.c:169` | H.264 generic min QP 同步 I/P/B min | `msm_venc.c:2324-2354` | 后续 per-frame control 可分别覆盖 |
| 028 | `venc_ctrls.c:184` | H.264 generic max QP 同步 I/P/B max | 同上 | 同上 |
| 029 | `venc_ctrls.c:208` | HEVC generic min QP 同步 I/P/B min | 同上 | 同上 |
| 030 | `venc_ctrls.c:223` | HEVC generic max QP 同步 I/P/B max | 同上 | 同上 |
| 031 | `venc_ctrls.c:477` | 为新 controls 保留 rotate 指针 | V4L2 `MODIFY_LAYOUT` 约束 | 只用于设置 control flag |
| 032 | `venc_ctrls.c:499` | control handler capacity 从 59 增至 67 | 新增 8 个标准 controls | 避免 handler 动态扩容/遗漏 |
| 033 | `venc_ctrls.c:541` | IRIS1 创建 rotate/flip、SAR、HEVC tier 标准 controls | 对应原厂 controls 和标准 V4L2 等价项 | 其他 SoC 不增加未审能力 |
| 034 | `venc_ctrls.c:717` | IRIS1 不再暴露没有精确原厂等价语义的 `H264_I_PERIOD` | 原厂提供 IDR_PERIOD 与 P-frame count；没有标准 open-GOP I-period 等价项 | 保留非 IRIS1 既有 control，避免目标平台接受后静默无效 |

## internal-config 精确规则

- 非 VP8 且 CBR/CBR-VFR：宏块率不高于 1280×720×30 时 VBV=500，否则 1000；
  随后独立发送 low-latency=1。
- multi-slice 仅适用于 H.264/HEVC 与 RC_OFF/CBR/CBR-VFR；其它 RC 发送 OFF。
- MB slice 上限：宽高各不超过 3840、每帧不超过 3840×2160 宏块、fps≤60；
  slice size 至少是每帧宏块数的 1/10。
- byte slice 上限：宽高各不超过 1920、每帧不超过 1920×1088 宏块、fps≤30；
  slice size 至少是平均帧字节数的 1/10。
- base-layer priority 最后发送；任一属性失败都不继续后续启动。

## 验证结果

- `tests/iris1-encoder-controls.c` 直接编译候选树中的三个真实 helper，覆盖 SAR、QP
  pack、fps=0、防错短路、VBV 500/1000、VP8 排除、RC 条件、两种 slice policy。
- `scripts/test-iris1.py` 另外检查 packetizer property ID/长度、tier 位、flip wire 值、
  control 创建/消费，以及 IRIS1 不暴露假 `H264_I_PERIOD`。
- 全部现有 IRIS1 宿主测试通过；`checkpatch.pl --strict --no-tree` 为
  0 errors、0 warnings、0 checks；`git diff --check` 通过。
- 本组只修正“启动前控制与 HFI payload”；不声称解决 Stage9 首 ETB 后硬复位。
