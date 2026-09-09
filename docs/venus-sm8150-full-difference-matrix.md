# SM8150 Venus 全量差异与迁移矩阵（持续更新）

> 这是当前唯一的“活”总账，状态基于 `patches/series` 0001--0033。
> `venus-sm8150-full-migration-audit.md`、`venus-sm8150-encoder-audit.md` 和各 Test 文档
> 是冻结的历史证据；其中与本文冲突的阶段性判断，以本文和对应 patch hunk ledger 为准。

## 1. 固定比较对象

| 角色 | 固定身份 | 用途 |
|---|---|---|
| Linux 基线 | `F:\linux\linux-raphael` @ `58f3df07833f2382fe2fbc28f996c4c85817c1f6` | 所有迁移补丁的共同父状态 |
| 当前候选 | `F:\linux\test15-analysis` + 0001--0033 | 实际修改和宿主测试对象 |
| 小米 Android 10 原厂 | `F:\linux\vendor-sm8150-reference` @ `192eca8550f95c2eec58a474793d1d93fc1b3b67` | SM8150/VPU5/HFI4 主语义来源 |
| 证据与发布仓 | `F:\linux\raphael-kernel-build` | series、patch、测试、逐行和逐 hunk 台账 |

原厂是 `drivers/media/platform/msm/vidc`，当前内核是
`drivers/media/platform/qcom/venus`。两者对象模型和文件拆分不同，因此逐行 review 的闭环由：

1. `venus-sm8150-vendor-line-ledger.md`：原厂 42 文件、39,111/39,111 行、686/686
   个函数的正向处置；
2. `venus-sm8150-current-line-ledger.md`：当前 Venus 36 文件的反向处置；
3. 0018--0033 的逐 hunk ledger：覆盖逐行台账冻结后新增的每个实际修改；
4. 可从固定基线严格重放的 `patches/series`。

0001--0029 的冻结重放 tree 为 `d9941d094f9b306f4cfe5d65f4a69c7076d5d414`。
0001--0032 的 Test18 重放 tree 为
`065f0998c8b669e8c69db87d3947145834e95b9e`。Test18 实机失败后新增 0033；其
最终严格重放 tree 为 `ff4095f00d7995c4ac0adb5797663c4796c5982f`，patch SHA 与
完整验证见 0033 hunk ledger。未把 panel、netfilter、litmus 等用户
改动纳入 Venus 编码修复。

## 2. 状态词

| 状态 | 含义 |
|---|---|
| 已实机通过 | 有目标内核、非空输出/预期帧数、内容或协议证据，并确认退出后 PM |
| 已实现，待实机 | 已进入可重放 patch，宿主/静态测试通过，但尚无目标机功能证据 |
| 部分迁移 | 主链已存在，仍有明确 codec/profile/buffer/lifecycle 缺口 |
| 未迁移 | 原厂存在、对通用 V4L2 目标有意义、当前无等价实现 |
| 有意排除 | Android 私有/CVP/secure 等不属于当前通用非安全 V4L2 目标 |

## 3. 全量语义差异矩阵

| 域 | 原厂 SM8150 语义 | 当前 0001--0033 状态 | 证据/补丁 | 后续组 |
|---|---|---|---|---:|
| 平台代际 | VPU5/IRIS1、HFI4 | 已对齐 | 0001、0004、0005；固件已启动 | — |
| firmware | Raphael `.mbn`，VIDEO.IR.1.2 | 已实机加载并读出版本 | Test7+ 日志 | — |
| codec core | MVS0 为 codec，MVS1/CVP 共享资源 | 已对齐，不把 CVP 伪装成第二 codec core | 0001、DT/PM hunk ledger | — |
| clocks/OPP | 240/338/365/444/533 MHz，MVSC/MVS0/CVP | 已迁移频率与 HQ/LP policy，待长压测 | 0020 | 6 |
| LLCC | VIDSC0/VIDSC1 各 512 KiB并通知 firmware | 已实现且 firmware 接受 | 0008/0009、Test10+ | 6 |
| ICC bandwidth | Q16 动态 DDR/LLCC governor、首 16 EBD turbo | 已实现并按原厂向量验证，待实机负载矩阵 | 0019 | 6 |
| runtime PM | shared session、电源域、software PC、超时与回滚 | 基本迁移，decode 后可 suspended；异常恢复仍待压力验证 | 0001--0005、0018 | 6 |
| HFI queues | ring index/长度/发布顺序 | 已加边界检查并完成 3968 次宿主 round-trip | 0002、0003 | 7 |
| HFI4 work route | session route 必须真实封包 | 已对齐；decode route=2 实机通过 | 0005 | — |
| HFI4 work mode | 独立于 low-latency | 0022 已纠正，不再由 mode=1 伪造 low latency | 0022 hunk 006--007 | — |
| HFI properties | property ID、payload size、4xx fallback | 常用主链已迁；剩余 metadata/lifecycle 属性继续逐项审 | 0005、0018、0022 | 5 |
| decoder codec input | H264/HEVC/VP8/VP9/MPEG2 | Test16：H264/Main8 通过；VP8/VP9 失败并可能刷日志，暂从 encoder 主目标移出 | Test16 报告、0030 | 4 |
| H264 decode | 8-bit profiles/levels | 30/30 帧、软硬 MD5 一致 | Test7 | — |
| HEVC Main8 decode | NV12 output | MKV 30/30 已实机通过 | Test8 | — |
| HEVC Main10 | TP10 UBWC DPB，可选 NV12 OUTPUT2 或原生 P010 client output | 0023 已恢复原厂 split-output 并保留 P010，宿主通过、待目标 MKV 逐帧闭环 | 0006/0007/0018/0023 | 4 |
| VP9 10-bit | profile2 与 HEVC 共享 raw layout/split output、不同 profile/caps | 0023 共享格式路径已实现；profile2 能力和目标逐帧仍待验证 | 0023 部分 | 4 |
| decoder visible size | coded/visible/stride/scanline 分离 | P010 layout、NV12 split output 和 payload 边界已对齐；动态 reconfigure 仍待组 5 | 0018/0023 | 5 |
| decoder source change | event、capture teardown/reallocation、resume | 0023 保留 IRIS1 NV12 client choice；连续分辨率变化尚未闭环 | 0018/0023 | 5 |
| decoder capture format | NV12、UBWC、P010 | Main10 可走真实 TP10-DPB/NV12-OPB 或原生 P010；待实机 | 0018/0023 | 4 |
| encoder codec output | H264/HEVC/VP8 | 原厂支持三者；当前安全 gate 下只推进 H264 bring-up | capability 路径 | 3、4 |
| encoder raw input | NV12/NV21/NV12 UBWC/TP10 UBWC/P010 | 已完整枚举、过滤、计算 layout 和约束；待首 ETB 实机 | 0021 | 3 |
| encoder raw/capture DMA | 原厂对所有 video dma-buf 使用双向映射，并在 syscache 存在时使用 upstream hint/MAIR 0xf4 | 双向方向已实机证明；0033 为 IRIS1 encoder MMAP/internal buffer 增加原厂 cache mapping，待 Test19 | 0018、0024、0027、0031、0033、Test17/18 | 3 |
| encoder internal buffers | scratch/persist/recon 按 firmware bufreq 顺序注册 | Stage0--8 已分段证明；0027 删除实验 stage，产品路径完整执行 | 0010--0018、0027 | — |
| encoder load/start | final count、final bufreq、output minimum、internal SET_BUFFER、LOAD/START、FTB/ETB | Test18 证实 REQBUFS 提交 OUTPUT host-min=2、最终固件 min=4，死于 START；0033 改为 controls 后提交最终 16/3、4/4 | Test17/18、0032/0033、完整 encoder audit | 3 |
| encoder controls | rotation/flip/SAR/tier/QP/VBV/latency/slice/base priority | 0022 映射标准 controls；0033 撤销尚未证明安全的默认包抑制，恢复 Test17 已到 START_DONE 的属性集合，同时保留包体清零 | 0022、0032/0033 | 7 |
| encoder QP | I/P/B 各自范围打包为 `0x00bbppii` | 已修复旧单 byte 复制错误，保留 layer/enable | 0022 hunk 011/019 | — |
| rotation/flip | flip bits 1/2/4/6；90/270 交换 output size | 已迁移；vertical 原错误值 3 已修为 4 | 0022 hunk 009/014/023 | — |
| H264 SAR | vendor width/height → aspect-ratio property | 用标准 V4L2 SAR controls 映射全部 IDC 与 extended SAR | 0022 hunk 002/010/016/018/026/033 | — |
| HEVC tier | main/high 写入 level 高四位 | 已迁移且限制为 IRIS1 HEVC encoder | 0022 hunk 003--005/020/026/033 | — |
| VBV/low latency | 非 VP8 CBR/CBR-VFR，720p30 阈值 500/1000 | 已迁移；不再错误绑定 work mode | 0022 hunk 015--016 | — |
| multi-slice | codec/RC/尺寸/fps/最小 slice 联合策略 | 已逐条件迁移并以真实 helper 编译测试 | 0022 hunk 016/024 | — |
| H264 I-period | 原厂是 IDR period + P-frame count，没有标准 open-GOP 等价项 | IRIS1 有意不暴露，避免接受后静默无效；其它 SoC 保持原行为 | 0022 hunk 034 | — |
| capability matrix | profile/level/bit-depth/尺寸/fps/codec 的交叉限制 | parser/静态 caps 存在，但尚未形成目标机准入真值表 | 当前枚举只属弱证据 | 4 |
| EOS/drain/flush | 原厂有精确状态迁移与 buffer completion | 当前通用路径存在，VPU5异常/EOS/重开尚未全覆盖 | helpers/vdec/venc | 5 |
| metadata/extradata | crop、color、HDR、timestamp、LTR等 | 只迁主链必需子集；标准等价项需逐个映射 | vendor line ledger | 5 |
| error recovery | session abort、SSR、timeout、buffer return | 已有局部回滚；硬复位前无持久日志，仍需边界和顺序审计 | Test11--15 | 3、6 |
| multi-instance | 原厂按 core/load/route/vote 管理并发 | 未做 decode+decode、decode+encode、重复 open/close 实机矩阵 | PM/clock/bw paths | 6 |
| secure sessions | secure context banks、私有 session/control | 有意排除：当前没有完整标准 UAPI/DRM consumer | vendor resource/DTS | — |
| CVP/TME/HEIC私有路径 | Android 专用 compute/tiling/private ABI | 有意排除，不伪装为通用 V4L2 能力 | vendor line ledger | — |
| 用户态容器 | Android/FFmpeg 先 demux，再给 Venus elementary stream | MP4/MKV/WebM 不是内核 codec；0023 为旧客户端恢复原厂 Main10→NV12 输出 | H264 MP4 与 HEVC Main8 MKV 已通过；Main10 待测 | 4 |

## 4. 已完成的迁移组

| 组 | patch | 结论 |
|---:|---|---|
| A | 0019 | SM8150 动态 bandwidth governor |
| B | 0020 | SM8150 clock 与 HQ/LP policy |
| C | 0021 | encoder raw format、layout、constraint |
| D | 0022 | encoder standard controls、HFI4 payload、internal config |
| E | 0023 | Main10 native P010 与 TP10-DPB/NV12-OPB split output |
| F | 0024 | encoder external queue contract、DMA/payload 边界与 FBD 语义 |
| G | 0025 | codec/profile/level/bit-depth capability matrix 与 HFI4 枚举语义 |
| H | 0026 | Main10 精确 geometry、colorimetry、reconfigure、flush/drain |
| I | 0027 | encoder output minimum、完整启动路径与实验 stage 收口 |
| J | 0028 | test 编号日志统一为稳定 `venus-sm8150` 诊断前缀 |
| K | 0029 | buffer-requirement getter `const` 编译契约；无运行时变化 |
| L | 0030 | decoder split-output DPB/OPB actual 与 host-min 契约；针对 VP8 BAD_POINTER |
| M | 0031 | encoder CAPTURE 双向 DMA；针对 Test16 首 ETB 后硬复位 |
| N | 0032 | Test17 全链审计：HFI 零初始化、默认属性发送模型、逐 REQBUFS count 和单次 final bufreq |
| O | 0033 | Test18 START 边界修正：controls 后最终 count、恢复已知 START 属性集、IRIS1 encoder upstream-cache mapping |

0024 验证：2 文件、12 hunk、+127/-22；SHA256
`6eff1ad2ec54a5ca03ce53a93567ff28498edd00dd1413f19a82e34732e837e4`；严格
checkpatch 为 0/0/0；全部 IRIS1 宿主测试通过；完整重放 tree 为
`5525b4900c0a27d2e3596eeabd9357d88115c98f`。

0025 验证：5 文件、+238/-39；SHA256
`9b671ca3e82b9eb67b8eac9ced4c2c071d7c15af6ed882085c7c2fb23ae91803`；严格
checkpatch 为 0/0/0；全部 IRIS1 宿主测试通过；完整重放 tree 为
`f4eb2dc02d3257a397151a665b835479a9719c21`。

## 5. 剩余工作组

Test18 已证明 0032 的 per-REQBUFS count 生命周期不适用于 mainline：OUTPUT 先提交
host-min=2，最终表却要求 min=4，并在 START 后无响应。0033 纠正该回归并补齐原厂
upstream-cache 映射；当前主目标改为 Test19 H.264 encoder 准入：

| 顺序 | 验证 | 完成判据 |
|---:|---|---|
| 1 | Test19 ARM64 构建 | 33 个 patch 应用、完整内核和模块构建、产物清单一致 |
| 2 | 已通过解码回归 | H.264 与 HEVC Main8 精确帧数/hash，PM 回 suspended |
| 3 | H.264 encoder 实机准入 | 先确认最终 count=16/3、4/4 与 upstream-hint=1，再要求 START_DONE、EBD/FBD/非空/软解/PM |
| 4 | 其他 codec | H.264 稳定后再执行 HEVC/VP8 encode；VP8/VP9/MPEG2 decode 单独修复 |
| 5 | 最终默认策略 | 只有编码通过后，才决定删除总 gate 或改为默认 Y |

## 6. 明确禁止的错误结论

- `/dev/video*` 存在、格式可枚举或 FFmpeg 返回 0，均不能单独证明硬件功能通过。
- “MP4 正常、MKV 异常”不能直接归因于容器；必须先记录 codec/profile/bit-depth、
  capture fourcc、plane/bytesused 和实际帧数。
- Stage0--8 安全不证明 encoder 可用；0027 已删除 stage 并收敛已知静态偏差，仍须一次完整实机闭环。
- 0023 的宿主测试不等于 ARM64 编译或实机通过；它只证明被抽取 helper 的数值、分支和
  source invariants 与报告一致。
