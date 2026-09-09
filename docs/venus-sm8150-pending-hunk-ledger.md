# 0018 的 35 个 hunk 逐项审阅台账

> 补丁：`patches/0018-media-venus-close-SM8150-Main10-and-encoder-DMA-gaps.patch`。
> SHA256：`19257ec9aed57cd801704dd31b6371c724bf7a5a8de64b97aefb629a8b6acb52`。
> 统计：9 文件、35 个 hunk、+350/-68。本文逐 hunk 记录原厂依据、行为、回归面和
> 验证状态；“通过”均指宿主/静态验证，Main10 与 encoder ETB 仍待实机。

| # | 文件/候选行 | 变化 | 原厂/上游依据 | 风险边界 | 状态 |
|---:|---|---|---|---|---|
| 001 | `core.h:491` | 为 8 个 encoder snapshot/统计字段补 kerneldoc | 原厂实例持有 buffer/CR/CF/recon 生命周期 | 仅文档，无 wire 变化 | 已审 |
| 002 | `core.h:574` | 增加 vendor NV12、双向 DMA、EBD/recon/CR/CF 字段 | `msm_smem.c`、`msm_vidc_clocks.c` | per-instance，避免全局参数中途改变 | 宿主验证 |
| 003 | `helpers.c:623` | queue 日志打印 VB2 bidirectional | 原厂 DMA_BIDIRECTIONAL | 仅 IRIS1 encoder 低频诊断 | 宿主验证 |
| 004 | `helpers.c:1472` | IRIS1 P010 生成 2-plane 256/32/16/256 constraints | `msm_vdec.c:549--560` | 只对 P010；不污染 NV12/其他 SoC | payload 测试通过 |
| 005 | `hfi_cmds.c:1250` | HFI4 可变长 plane constraints packetizer | `hfi_packetization.c:1054--1080` | 校验 plane count；包长按实际 planes | payload 测试通过 |
| 006 | `hfi_msgs.c:5` | 引入 64-bit 除法 helper | 原厂 CR 定点公式 | 无协议变化 | 编译测试通过 |
| 007 | `hfi_msgs.c:546` | 解析可选 VPU5 EBD tail、CR/CF/recon/sync | `vidc_hfi.h:588--613`、response handler | 36-byte prefix 仍兼容；80/84 才读尾部 | packet 测试通过 |
| 008 | `hfi_msgs.h:159` | 定义 7-bucket stats、frame stats、EBD tail | 同上 | 作为 tail，不替换通用 prefix | layout 测试通过 |
| 009 | `hfi_parser.c:85` | alloc-mode payload 按正确 entry size 前进 | 后续主线 parser 修正 | 防下一个 property 错位 | invariant 通过 |
| 010 | `hfi_parser.c:146` | capability payload 使用正确结构长度 | 后续主线 parser 修正 | 防 SYS_INIT desync | invariant 通过 |
| 011 | `hfi_parser.c:171` | 每个 raw format 初始化 plane payload size | 后续主线 raw-format 修正 | 防继承上一格式长度 | invariant 通过 |
| 012 | `hfi_parser.c:186` | 每个 plane 正确累加 constraint size | 同上 | mixed plane count 安全 | invariant 通过 |
| 013 | `hfi_parser.c:194` | 删除用最后一个 plane 重算总长的错误公式 | 同上 | 防越读/漏读 | invariant 通过 |
| 014 | `pm_helpers.c:235` | EBD 后记录 table vote 与 CR/CF | 原厂 dynamic governor 输入 | 明确 `vote unchanged`，不改变 ICC | 宿主验证 |
| 015 | `vdec.c:125` | 新增 stream bit-depth filter、IRIS1 P010 size wrapper | 原厂 P010 formula | 只给 IRIS1 P010 +4 KiB | exact-size 测试通过 |
| 016 | `vdec.c:193` | `find_format` 统一 capability + strict stream filter | 原厂 formats/caps | 位深未知允许协商，已知严格 | format 测试通过 |
| 017 | `vdec.c:210` | `find_format_by_index` 稳定按 capability 枚举 | V4L2 ENUM 稳定性 | 不随动态 source-change 改 index | enumeration 测试通过 |
| 018 | `vdec.c:269` | TRY_FMT 使用 IRIS1 P010 vendor size | 原厂 `VENUS_BUFFER_SIZE(P010)` | 不修改用户请求的 bit depth | exact-size 通过 |
| 019 | `vdec.c:298` | TRY_FMT fallback/strict-selection 诊断 | 当前 ioctl 协商缺证据 | 低频日志；无静默错误格式 | 宿主验证 |
| 020 | `vdec.c:380` | G_FMT 严格验证并打印最终布局 | Main10 userspace 交界 | 失败显式返回，不假报 NV12 | 宿主验证 |
| 021 | `vdec.c:413` | S_FMT 防 null format | 通用 V4L2 防御 | 无协议变化 | 宿主验证 |
| 022 | `vdec.c:468` | capture S_FMT 使用 vendor size并记录 | 原厂 P010 size | 只在 capture/P010/IRIS1 | exact-size 通过 |
| 023 | `vdec.c:878` | output config 的 OPB size 采用实例 wrapper | source-change 后实际 fmt | NV12/其他 SoC 保持旧公式 | 宿主验证 |
| 024 | `vdec.c:1083` | output queue setup 使用实例 format size | 同上 | 不改变 compressed packet bytesused | 宿主验证 |
| 025 | `vdec.c:1093` | capture queue size/count 和 P010 layout 诊断 | Main10 REQBUFS/QUERYBUF 证据需要 | 低频、首配置 | 宿主验证 |
| 026 | `vdec.c:1459` | buffer init 失败时撤销映射/计数并打印首 capture | 原厂明确 ownership | 防 stale count/list | fault-injection 通过 |
| 027 | `venc.c:35` | 新增 vendor-size 与 bidirectional 参数，默认 on但受 encoder gate | `VENUS_BUFFER_SIZE`、`msm_smem.c` | encoder 总 gate 默认 N；instance 快照 | 宿主验证 |
| 028 | `venc.c:195` | 精确实现 SM8150 linear NV12 公式 | `msm_vidc_common.c:6101` + media info macros | 仅 IRIS1 encoder NV12 | 128x96=24576 通过 |
| 029 | `venc.c:255` | encoder TRY_FMT 应用 vendor size下限 | 原厂 raw allocation | 不改 filled_len，不小于已有请求 | 宿主验证 |
| 030 | `venc.c:340` | S_FMT 成功后使旧 bufreq cache 失效 | 原厂按 session/format 重查 | 防跨格式 stale requirements | lifecycle 测试通过 |
| 031 | `venc.c:1282` | queue_setup 精确 size/count 并记录 policy | 原厂 two-stage requirements | allocation 与 firmware minimum 分离 | 宿主验证 |
| 032 | `venc.c:1314` | raw buffer mapping 失败 rollback，打印 length/IOVA/direction | 原厂 smem ownership | 防计数泄漏；不打印高32丢失 | fault-injection 通过 |
| 033 | `venc.c:1527` | 每次 STREAMON 清空 EBD/recon/CR/CF/BW 统计 | 原厂 session lifecycle | 防前次会话污染 | lifecycle 测试通过 |
| 034 | `venc.c:1800` | encoder source VB2 queue 设置 bidirectional | `msm_smem.c:92/127/156/430/448/473` | 只在 IRIS1 encoder policy；capture 不变 | 宿主验证、ETB待实机 |
| 035 | `venc.c:1861` | open 时快照 vendor size 与 DMA direction | 活跃 mapping 不可变 | 参数只影响新 instance | shared-session 测试通过 |

## 覆盖与重放结论

- 35/35 个 hunk 均有语义、原厂依据、风险边界和状态；
- HFI4 constraints、P010 size、parser payload、EBD length、NV12 size、DMA direction、
  rollback 和 lifecycle 均被宿主测试覆盖；
- 使用独立临时 Git index 从固定基线依次重放 001--0018，全部通过
  `git apply --check --whitespace=error-all`；
- 重放 tree 为 `a0bf124d02fba53c28a622a9ca91b9ca4a7fef0d`，001--0018 涉及的全部 21 个
  最终源码 blob 与 `F:\linux\test15-analysis` 完全一致；
- 这不等于实机功能通过。Main10 仍需 30 帧/布局闭环，encoder 仍需唯一一次新的首 ETB。
