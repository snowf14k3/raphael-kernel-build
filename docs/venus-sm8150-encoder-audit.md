# SM8150 Venus 编码适配核对记录

> **历史编码专项记录：**截至 Test15 的逐步排查保留在这里；0018 的 NV12 allocation、
> bidirectional DMA、VPU5 EBD/recon/CR/CF 以及最新状态以
> `venus-sm8150-migration-status.md` 和 `venus-sm8150-pending-hunk-ledger.md` 为准。

这份文件是 Raphael / SM8150 Venus 编码适配的唯一持续核对记录。每次代码
对比、实机测试和结论变化都应先更新这里，避免反复检查同一项或把推测当成
已验证事实。

## 对照源码身份

- 当前上游内核基线：`snowf14k3/linux` 的 `raphael-7.1`，提交
  `58f3df07833f2382fe2fbc28f996c4c85817c1f6`。
- 小米 Android 10 原厂参考：
  `https://github.com/MiCode/Xiaomi_Kernel_OpenSource`，分支
  `cepheus-q-oss`，提交
  `192eca8550f95c2eec58a474793d1d93fc1b3b67`。
- 本地只读原厂参考目录：`F:\linux\vendor-sm8150-reference`。
- test12/test13 的一次性展开与复核目录已按用户要求清理；可重放的规范来源是
  本仓库 `patches/series`、对应补丁和本记录，不再引用已删除目录。

原厂参考虽然以 `cepheus` 命名，但采用 SM8150/VPU5 Venus 实现。本记录只把
它作为协议、资源和启动顺序的依据，不直接搬运 Android 专属框架代码。

## 已有实机事实

### 已通过

- test7 起 H.264 硬解码能输出 30/30 帧，且与软件解码逐帧 MD5 一致。
- HEVC Main 8-bit 能输出 30/30 帧。
- test10/test12 能正确协商 HEVC Main10、上报 10-bit source change，并把
  CAPTURE 切换为 `P010`；第一块 10-bit capture buffer 也已由固件回收。
- Venus 固件 `VIDEO.IR.1.2-00045-PROD-1` 能启动，解码后 runtime PM 能回到
  `suspended`。
- test11 修正默认 Profile 与 8x8 transform 冲突后，编码节点能够正常
  `open()` 和枚举。
- test12 在 `iris1_encoder=Y`、DMA 锁关闭时，SESSION_INIT、属性设置和两次
  buffer requirements 查询能完成，退出后 runtime PM 能回到 `suspended`。

### 未通过

- test11 和 test12 一旦开放真实编码 DMA，FFmpeg 停在 `frame=0`，随后整机
  卡死并重启。持久日志只留下测试开始标记，无法证明死在内部缓冲、LOAD、
  START、FTB 还是 ETB 中的哪一步。
- HEVC Main10 经 Debian 13 的 FFmpeg 7.1 `hevc_v4l2m2m` 输出 0 帧并报
  `An invalid frame was output by a decoder`。内核已识别 Main10、切换 P010，且固件
  回收了首个 P010 CAPTURE buffer；但 HFI4 IRIS1 尚未发送原厂 P010 plane actual
  constraints，ENUM/TRY/S_FMT 的位深过滤也不完全一致。因此当前只能定位为
  “内核到用户态的 P010 协商/布局不一致”，不能再武断定性为 FFmpeg 7.1 单方面
  缺少映射；仍然不应把 10-bit 数据伪报为 NV12。
- 编码从未产出过一个有效 H.264 帧，所以当前不能宣称编码可用。

### test13 实机新增事实

- test13 正确启动为 `7.1.0-sm8150-venus-test13+`；H.264 硬解码输出
  30/30 帧，退出十秒后 Venus 主设备和两个 video core 均回到 `suspended`。
- test13 把运行期亮度 DCS 从 test12 的 LP 恢复为 HS 后，亮度问题没有修好，
  反而让纯 sysfs 50 Hz 输入（驱动内部合并为最多 10 Hz）也稳定触发
  `dsi_err_worker: status=5`。该状态是 DSI timeout（bit 0）与 FIFO 错误
  （bit 2）的组合；随后出现 Adreno CCU translation fault 和 DPU
  `hangcheck recover`，属于显示链路错误后的连锁故障。
- 因此 test13 的 HS 假设已被实机否定。下一版至少应恢复 LP；test12 的
  LP+10 Hz 在纯 sysfs 压力下通过、但 GNOME 拖动仍会报错，所以不能只回退
  传输模式，还需要降低更新频率或把 DCS 提交同步到安全显示时段。该问题留到
  test13 编码分阶段结果收齐后与编码修正合并，避免单独再编译一次内核。
- test13 encoder stage 0 通过：128x96 H.264 会话完成初始 4/4 数量、属性、
  两次 buffer requirements 查询和最终缓存；固件最终返回 INPUT actual=16 / min=3、
  OUTPUT actual=4 / min=4。门禁按预期以 `-EACCES` 拒绝 STREAMON，没有分配或
  登记内部 DMA，退出十秒后 runtime PM 回到 `suspended`。
- test13 encoder stage 1 通过：scratch0 requirement 198400 字节按原厂语义
  对齐为 200704 字节，DMA IOVA `0xdf980000` 可无损放入 HFI4 的 32-bit 地址字段；
  SET_BUFFERS 成功入队，随后 RELEASE_BUFFERS 返回 0，staged cleanup 返回 0，
  十秒后 runtime PM 为 `suspended`。第一类内部 DMA/登记/撤销边界已排除。
- test13 encoder stage 2 通过：scratch0 与 scratch1 均成功登记和撤销；scratch1
  requirement 233056 字节对齐为 233472 字节，IOVA `0xdf840000`；两次
  RELEASE_BUFFERS 均返回 0，cleanup 返回 0，runtime PM 为 `suspended`。
- test13 encoder stage 3 通过：新增 scratch2 requirement/登记长度均为
  118784 字节，IOVA `0xdf720000`；三类 scratch 的 SET_BUFFERS 均成功入队，
  三次 RELEASE_BUFFERS 均返回 0，cleanup 返回 0，runtime PM 为 `suspended`。
- test13 encoder stage 4 通过：新增 persist0 requirement 64768 字节并对齐为
  65536 字节，IOVA `0xdf3f0000`；三类 scratch 与 persist0 均成功登记和撤销，
  四次 RELEASE_BUFFERS 及 cleanup 返回 0，runtime PM 为 `suspended`。
- test13 encoder stage 5 通过：完整内部缓冲前缀安全；scratch0/1/2 与 persist0
  均成功登记和撤销，persist1(type 0x5) 按固件最终表明确显示 `not requested` 并
  合法跳过。四次 RELEASE_BUFFERS、staged cleanup 返回 0，runtime PM 为
  `suspended`。静态内部 DMA 段可整体排除为 test12 复位边界。
- test13 encoder stage 6 通过：完整内部缓冲后 LOAD_RESOURCES 成功，随后从
  LOAD_RESOURCES_DONE 直接执行 staged RELEASE_RESOURCES，返回 0、状态 7；
  四类内部缓冲均成功撤销，cleanup 返回 0，runtime PM 为 `suspended`。
  LOAD 与其特殊回滚状态转换已排除为复位边界。
- test13 encoder stage 7 通过：LOAD_RESOURCES 与 START 均完成，随后 staged
  STOP 返回 0（状态 6）、RELEASE_RESOURCES 返回 0（状态 7）；四类内部缓冲
  全部成功撤销，cleanup 返回 0，runtime PM 为 `suspended`。会话启动和停止闭环
  已排除，test12 的致死边界进一步缩小到普通 CAPTURE/FTB 或 OUTPUT/ETB DMA。
- test13 encoder stage 8 通过：START 后向固件提交 4 个 CAPTURE/FTB，tag 0--3，
  每块 alloc=73728、filled=0、offset=0，IOVA 均在 32-bit 范围；未提交 ETB 的
  会话按设计不产出码流，5 秒超时后 SIGKILL 返回 137，但设备未复位，四类内部
  缓冲仍成功撤销且 runtime PM 回到 `suspended`。CAPTURE/FTB DMA 可排除，
  test12 致死边界现已唯一缩小到首次 OUTPUT/ETB 或其后的固件硬件访问。

## 原厂启动顺序

原厂 SM8150 普通 H.264 编码会话的有效顺序为：

1. SESSION_INIT 后先发送初始 INPUT/OUTPUT 缓冲数量，原厂格式表默认均为 4。
2. 设置编码控件和旋转属性。
3. 设置 bitrate savings、WORK_ROUTE、WORK_MODE 和 core/power 选择。
4. 查询 buffer requirements。
5. 设置客户端最终缓冲数量及压缩输出最小尺寸。
6. 再次查询最终 buffer requirements，并验证结果。
7. 按 scratch、scratch1、scratch2、persist、persist1 的顺序分配并通过
   SET_BUFFERS 登记内部 DMA 缓冲；recon 只保存索引 bookkeeping，不做静态
   DMA SET_BUFFERS。
8. 配置时钟/总线，依次执行 LOAD_RESOURCES 和 START。
9. 提交 CAPTURE 码流缓冲 FTB，之后提交 OUTPUT 原始帧 ETB。

test13 的目标是保持这个顺序，并把每个危险边界拆成可单独停止的阶段。

## 已逐项核对

| 项目 | 原厂 SM8150 | 当前结论 | 状态 |
|---|---|---|---|
| HFI 版本 | VPU5 / HFI 4xx | 当前使用 HFI 4xx | 对齐 |
| WORK_ROUTE | 普通 H.264 VBR 使用 route 2 | test14 实机为 route 2 | 对齐 |
| WORK_MODE | VBR/MBR 使用 mode 2；RC_OFF/CBR/CQ 使用 mode 1 并开启 low-latency | test14 Stage 0 实测 FFmpeg 把会话配置为 VBR：`rc_enable=1 bitrate_mode=0 low_latency=0`，因此 mode 2 正确 | 已由实机确认 |
| video core | MVS0；MVS1 属于 CVP | 当前选择 MVS0，不能改到 MVS1 | 对齐 |
| 初始 IO 数量 | SESSION_INIT 后按 H.264 格式表发 4/4 | test13 仅在 requirements 缓存无效的初始阶段发 4/4；Stage 0 日志确认 initial 4/4 | 已实机通过（Stage 0） |
| 最终 IO 数量 | actual 为客户端实际数，`count_min_host` 为固件 minimum | test12 原本正确；test13 一度误改 4/4，现已恢复为固件返回的 3/2 | 静态对齐 |
| RC 默认值 | 原厂 bitrate mode 默认 RC_OFF；vendor 的 FRAME_RC_ENABLE 另映射到时间戳 RC 属性 | test13 将 IRIS1 的 frame-RC control 默认改为 0；本次 FFmpeg 在 STREAMON 前把 frame RC 设为 1，同时当前标准 bitrate mode 为 VBR，实际 HFI RC 因而是 VBR | 默认与本次实际会话必须分开记录 |
| 时间戳 RC | FRAME_RC_ENABLE 原样发送为 `VENC_DISABLE_RC_TIMESTAMP` | test15 对 IRIS1 补发同一 `0x2005027` enable 属性；Stage 0 日志确认值为 1，Stage 9 仍复位 | 已实机确认发送；已排除为复位根因 |
| 固定 QP | I/P/B 和范围默认 127 | test13 使用 127；HFI4 封包结果与原厂一致 | 静态对齐 |
| bitrate savings | 默认启用，属性 `0x2005038` | test13 已补封包；本次有效 RC 是 VBR，按原厂条件不发送 | 本次 VBR 不触发；封包静态对齐 |
| rotation | 原厂即使不旋转也发 NONE/NONE，属性 `0x3007001` | test13 已补；Stage 0 日志确认 rotation=none、flip=none | 已实机通过（Stage 0） |
| BUFFER_SIZE | 原厂名为 MINIMUM，当前名为 ACTUAL | 二者都是 `0x20100c` 且 payload 相同，仅命名差异 | 已排除 |
| 缓冲类型 | 4=persist，5=persist1，6/7/8=scratch0/1/2，9=recon | 当前 HFI4 数值一致 | 对齐 |
| recon | 只分配索引信息，不 SET_BUFFERS | 当前不把 type 9 当静态 DMA | 对齐 |
| SET_BUFFERS 包 | type/size/count/device address | 当前 HFI4 布局与原厂一致 | 静态对齐 |
| 内部缓冲登记粒度 | 每块 scratch/persist 各发一个 SET_BUFFERS | 当前同样逐块发送；`queued` 仅表示命令入队，释放路径等待应答 | 静态对齐 |
| LOAD 后回滚 | 可从 LOAD_RESOURCES_DONE 直接 RELEASE_RESOURCES | 旧包装函数只允许 STOP，stage 6 会失败后带资源断电；test13 已仅对 IRIS1 放开该转换 | 已实机通过（Stage 6） |
| ETB/FTB 包 | 标准 VPU5 输入/输出帧包 | 当前布局与原厂一致 | 静态对齐 |
| ETB_DONE/FTB_DONE | 编码 FTB_DONE 固定字段一致；原厂 ETB_DONE 末尾另带 flags 与 recon/UBWC 统计 | 当前会读取的 ETB_DONE 前缀字段偏移完全一致，只忽略末尾统计；包长检查允许更长消息 | 已排除为首帧 DMA 根因 |
| 普通 CAPTURE 注册 | 不预先静态 SET_BUFFERS | 当前 HFI4 对普通 capture 注册为 no-op | 对齐 |
| 线性 NV12 输入 | 原厂格式表明确支持，HFI color format 为 `0x2` | 当前公开 NV12 且发送相同 HFI 值；UBWC 只是原厂默认，不是唯一输入 | 已排除 |
| ETB 长度 | 原厂 `alloc_len=plane.length`、`filled_len=plane.bytesused` | 当前同样使用分配长度和 V4L2 payload，不能把 `filled_len` 粗暴改成 `sizeimage` | 对齐 |
| ETB/FTB 提交顺序 | 原厂按 deferred 注册表顺序提交；正常客户端必须先提供 CAPTURE，才能安全接收码流 | 当前 `m2m_device_run()` 明确先提交 CAPTURE/FTB，再提交 OUTPUT/ETB；比依赖注册顺序更确定 | 对齐且更保守 |
| V4L2 DMA 方向 | 原厂编码输入 clean+invalidate、编码输出 invalidate | 当前 vb2 OUTPUT 队列为 `DMA_TO_DEVICE`，CAPTURE 队列为 `DMA_FROM_DEVICE`；MMAP coherent 无需额外同步，USERPTR 由 `vb2_dma_contig` prepare/finish 同步，DMABUF 由 attachment/exporter 处理 | 静态对齐 |
| 压缩输出分配尺寸 | 原厂把固件返回的 output requirement 作为最小 `sizeimage` | 当前 128x96 的通用保守公式分配 73728，固件 minimum 为 36864；FTB 传真实 73728 `alloc_len`，大于固件最小值 | 安全过量分配，保留 |
| bitrate savings | 原厂只对非 VBR 强制开启 | test13 已按有效 HFI RC mode 排除 VBR_CFR/VBR_VFR | 静态对齐 |
| rotation 顺序 | rotation/flip 在 start 中先于 bitrate savings、route、mode、core | test13 已改为 rotation → properties → route → mode → core | 静态对齐 |
| 电源域 | MVSC、MVS0、CVP | 当前三个电源域齐全 | 静态对齐 |
| 时钟/复位 | AXIC/AXI0/AXI1、MVSC/MVS0/MVS1、4 组 reset | 当前资源齐全且 test12 preflight 通过 | 静态对齐 |
| LOAD 前总线投票 | `scale_clocks_and_bus` 在 LOAD/START 前执行 | 当前在相同位置调用 `venus_pm_load_scale`；已排队首帧的 payload 使其同时执行 OPP 与 interconnect vote | 静态对齐 |
| LLCC | VIDSC0、VIDSC1 两块 slice | test9 起发现并交给固件 | 已通过启动 |
| 时钟策略 | v1 最高 480 MHz；量产 v2 最高 533 MHz | 当前 240/338/365/444/533 MHz 与原厂 `sm8150-v2` 表完全一致 | 已排除 |
| IOMMU SID | 原厂通用 DTS 是 `0x1300`，但量产 `sm8150-v2.dtsi` 覆盖为 `0x2300` | 当前上游 DT 同为 `0x2300`，且本机使用量产 v2 时钟/固件配置、解码 DMA 正常 | 与量产 v2 对齐 |
| HFI DMA 地址宽度 | 原厂映射后拒绝任何不能无损转为 32-bit 的 IOVA | test13 已在内部 DMA 和普通帧 DMA 进入 HFI 前增加上 32 位检查 | 已补安全门禁 |
| 内部 DMA 分配长度 | 原厂统一向上对齐 4 KiB，并把对齐值作为 SET_BUFFERS 的 `buffer_size` | test12 只上报固件原始 size；test13 已仅对 IRIS1 encoder 改为原厂 4 KiB 语义 | 已实机通过（Stage 1--5） |

## test13 新发现和待修项

### 1. NAL 格式没有显式对齐

原厂 H.264/H.265 默认输出 Annex-B start codes，并通过 NAL stream format
属性告诉固件。test12 没有显式发送。test13 已对 IRIS1 的 H.264/H.265 明确
发送 `HFI_NAL_FORMAT_STARTCODES`，然后再进入缓冲协商。

### 2. IRIS1 不应发送 NV12 plane actual stride 属性

当前公共 Venus 在 `venc_init_session()` 中用请求宽高发送
`UNCOMPRESSED_PLANE_ACTUAL_INFO`。96x96 测试的 V4L2 bytesperline 实际对齐为
128，但属性可能仍携带 96，存在 stride 自相矛盾。原厂普通 NV12 编码路径不会
发送这个属性；原厂封包器对该属性也是空处理。test13 已只对 IRIS1 跳过它，
其他 SoC 不变；实机测试尺寸改为 128x96，消除额外歧义。

### 3. LTR count 为 0 时不应主动发送 LTRMODE

当前公共 `venc_set_properties()` 无条件发送 MANUAL、trust=1、count=0 的
LTRMODE。原厂只在用户显式提交 `V4L2_CID_MPEG_VIDC_VIDEO_LTRCOUNT` 时发送，
默认值 0 本身不会构成启动必需属性。test13 已在 IRIS1 的 count=0 情况下跳过
LTRMODE，非 IRIS1 行为保持不变。

### 4. 缺失内部需求不能继续静默跳过

固件的 test12 最终表返回 type 4、6、7、8、9，没有 type 5。type 5
persist1 因需求不存在可合法不分配；但当前 helper 对任意查询失败都静默返回成功，
不利于判断到底是“固件没要求”还是“缓存表损坏”。test13 已打印每类最终需求和
明确的 skip 原因；IRIS1 编码查询走已校验的最终缓存表，表中缺项和零大小分别
记录为合法跳过。

### 5. 原厂 internal config 没有遗漏当前冒烟用例所需属性

原厂 `msm_vidc_set_internal_config()` 只在 CBR、低延迟或非 single-slice 等条件下
附加 VBV、低延迟和 multi-slice 属性。test14 Stage 0 已证明当前 FFmpeg 冒烟
实际为 VBR、single-slice，而不是此前误判的 RC_OFF；这些附加条件仍不成立。
原厂 `FRAME_RC_ENABLE` 映射到独立的时间戳 RC 属性，而当前公共 Venus 又用
`rc_enable` 参与选择 RC mode，两者语义不能直接画等号。test15 保持 VBR mode
选择不变，并另行补发原厂 `VENC_DISABLE_RC_TIMESTAMP` 属性。

### 6. 初始数量和最终固件 minimum 必须分两个阶段

原厂 SESSION_INIT 后先用 H.264 格式表的 4/4 初始化数量；第一次 GET 之后，
queue setup 再把客户端 actual 与固件返回的 `buffer_count_min` 一起发回。test13
一度让同一个 helper 无条件读取 requirements 缓存，导致初始 4/4 在缓存建立前
直接失败；现已改成缓存无效时使用调用者传入的 4/4，缓存有效后使用固件 3/2，
日志用 `source=initial` 与 `source=firmware` 明确区分。

### 7. 96x96 不是有效的最终 DMA 验证样本

test11/12 的 96x96 请求被当前 V4L2 驱动对齐为 128x96，但首帧日志仍显示
`payload=13824`，即 96x96 的紧凑 NV12 字节数；固件返回的 input requirement
则是 18432 字节，对应 128x96。原厂与当前驱动的 ETB 都把 V4L2
`bytesused` 原样放入 `filled_len`，所以不能通过伪造整块长度修复布局问题。
test13 的唯一编码冒烟尺寸固定为 128x96，使可见宽度、128 字节 stride 和
18432 字节有效像素数据一致。这个结论只说明旧样本不可靠，不把它冒充成已经
找到整机重启的唯一根因。

### 8. staged 回滚必须能从日志证明完成

原厂状态机允许从 LOAD_RESOURCES_DONE 直接进入 RELEASE_RESOURCES，也允许从
START_DONE 经 STOP 再 RELEASE_RESOURCES。test13 现在逐项打印 staged STOP、
RELEASE_RESOURCES 和内部 RELEASE_BUFFERS 的返回值；释放多块内部缓冲时保留
第一个错误码，避免最后一块成功把前面的失败覆盖。这样任何一级返回到 runtime
PM 前是否完整回滚，都能由一次实机日志直接判断。

### 9. core 选择并没有错到 MVS1

原厂 `msm_vidc_decide_core_and_power_mode()` 最终发送
`HAL_PARAM_VIDEO_CORES_USAGE`；当固件只报告一个 video core 时会强制选择
`VIDC_CORE_ID_1`。SM8150 的第二块 MVS1 电源/时钟属于 CVP，不是应当给普通
encoder 选择的第二个 Venus core。当前资源表以 `vcodec_num=1` 把
`decide_core()` 固定到 ID 1，并通过相同的 HFI 4xx
`VIDEOCORES_USAGE` 属性提交。不能通过把 encoder 改去 MVS1 来修卡死。

### 10. FTB/ETB 包和队列方向已排除

原厂和当前 HFI4 的 encoder ETB 都包含 view、timestamp、flags、offset、
`alloc_len`、`filled_len`、input tag、packet address 和 extradata address；FTB
也都包含 stream id、offset、分配/有效长度、output tag 和地址。字段顺序与包长
一致。当前首次运行明确先遍历 CAPTURE 队列发送 FTB，再遍历 OUTPUT 队列发送
ETB，满足固件在接收原始帧前先拿到码流输出缓冲的要求。

缓存同步也不是一个已证实缺口：当前 `vb2_dma_contig` 会把编码 OUTPUT 队列设置
为 `DMA_TO_DEVICE`，CAPTURE 队列设置为 `DMA_FROM_DEVICE`。本次 FFmpeg 冒烟
使用的 MMAP 缓冲来自 coherent DMA 分配；USERPTR/DMABUF 则由 vb2/DMA-BUF
框架按队列方向处理。没有证据时不重复添加手工 sync，避免双重 ownership 转换。

### 11. output buffer 比原厂最小值大，但不是越界

test12 的 V4L2 capture 分配尺寸为 73728，而固件最终 output requirement 是
36864。原厂用户态在 S_FMT 阶段直接采用固件 minimum；当前上游驱动使用适配多
codec 的保守公式，因此多分配了一倍。FTB 的 `alloc_len` 仍是实际分配的 73728，
没有把较小缓冲谎报为较大缓冲，固件也在第二次 GET 中继续接受并返回要求。
这是可优化的差异，但不是内存越界证据；test13 暂不为了“看起来一样”缩小已分配
缓冲。

### 12. 当前仍比原厂主动发送更多默认编码属性

原厂驱动只在用户态实际设置某项 control 时立即发送对应 HFI 属性；当前上游 Venus
在 STREAMON 时把保存的标准 control 值集中发送。对 128x96 H.264 VBR
冒烟用例，额外默认项主要是关闭的 VUI/AUD、CAVLC、deblock、transform、IDR、
intra period、joined header、自动 QP/范围和 profile/level。所有这些封包均能在
test12 进入两次 buffer requirements 查询，说明不存在本地 packetizer 拒绝；
但 HFI SET_PROPERTY 没有逐项固件 ACK，因此还不能仅凭 GET 成功宣布固件完全
接受。test13 先用 stage 1--7 判断故障是否早于普通帧 DMA；若某一 stage 在
ETB/FTB 前仍复位，再按该阶段最后一条命令缩小属性集合，而不是无依据地一次删光。

### 13. 原厂内部缓冲不是按固件原始字节数直接登记

这是本轮找到的首个直接落在真实 encoder DMA 边界上的静态偏差。原厂
`alloc_dma_mem()` 无论固件返回的 alignment 是多少，都会先把申请大小和对齐值
至少提升到 4 KiB；`msm_smem.size` 保存这个页对齐值，随后 SET_BUFFERS 也把它
作为 `buffer_size` 发送。test12 则把 DMA allocator 收到的原始 requirement 原样
发送，尽管底层页分配实际更大，固件看到的合法范围仍然偏小。

test12 实机表中的具体差异包括：

- persist：64768 → 65536
- scratch0：198400 → 200704
- scratch1：233056 → 233472
- scratch2：118784 已经是 4 KiB 对齐

test13 已只对 IRIS1 encoder 采用 `ALIGN(size, SZ_4K)`，分配、SET_BUFFERS、
RELEASE_BUFFERS 和释放都使用同一个对齐后长度；日志同时打印 requirement、最终
长度和 DMA 地址。其他 SoC 的公共路径不变。

同时补上原厂已有而当前缺少的 32-bit IOVA 防护。HFI4 的 packet address 字段只有
32 位，test13 会在截断前返回 `-ERANGE`，不允许一个异常高地址变成错误 DMA。

### 14. STOP/RELEASE/SESSION_END 顺序及 staged 回滚状态合法

原厂 STREAMOFF 先把会话推进到 STOP_DONE、RELEASE_RESOURCES_DONE；关闭实例时
再释放 scratch/recon/persist 等登记，随后 SESSION_END。当前正常 STREAMOFF 的
顺序是 STOP → RELEASE_RESOURCES → RELEASE_BUFFERS/free internal → SESSION_END，
核心约束相同：必须先让硬件停止并释放资源，再撤销 DMA，最后结束 session。

test13 stage 6 在 LOAD_RESOURCES_DONE 直接 RELEASE_RESOURCES；stage 7 在
START_DONE 执行 STOP 后再 RELEASE_RESOURCES。当前 HFI 状态机的 SESSION_END
允许这些状态，且 staged 释放完成后后续 vb2 cleanup/close 仍可结束 session。
因此 stage 6/7 的设计不是非法倒序；每条 cleanup 返回值仍需由实机日志确认。

### 15. 首帧完成消息的固定字段没有错位

原厂 encoder FTB_DONE 与当前 `hfi_msg_session_fbd_compressed_pkt` 的时间戳、错误、
flags、offset、alloc/filled length、input/output tag、picture type 和两个地址字段
顺序一致。原厂 ETB_DONE 在公共前缀之后多出 flags 与 recon/UBWC 统计；当前只
消费共同前缀，消息分发允许实际包长大于最低结构长度，所以不会把末尾统计错当成
下一条消息。test13 仍会在提交端打印每个 FTB/ETB 的 tag、IOVA、alloc、filled
和 offset，便于 stage 8/9 判断最后成功入队的是哪一个缓冲。

### 16. 533 MHz 不是高于原厂规格的误设

原厂 `sm8150-vidc.dtsi` 的通用 v1 表确实只列出 225/300/365/432/480 MHz，
但同一原厂提交的 `videocc-sm8150.c` 还包含生产版 `sm8150-v2` 修正：频率表
切换为 200/240/338/365/444/533 MHz，并把最高电压档对应到 533 MHz。
`sm8150-v2.dtsi` 通过 `qcom,videocc-sm8150-v2` 明确选择这套表；Raphael 的
原厂 overlay 可以搭配 v1 或 v2 base DTB，量产硬件由底层 DTB 版本决定。

当前主线 SM8150 clock provider、Venus OPP 表和 `sm8150_freq_table` 三处都使用
240/338/365/444/533 MHz；test7--test12 的实机 clock framework 也确实将请求
舍入到约 533000097 Hz，且已完成稳定解码。这个数值与原厂 v2 对齐，不是从其他
SoC 误抄来的超频。test13 保留 533 MHz，不用降频掩盖 DMA/协议问题。

### 17. LOAD/START 前并未漏掉总线投票

原厂 `start_streaming()` 在登记内部缓冲之后、`LOAD_RESOURCES` 之前调用
`msm_comm_scale_clocks_and_bus()`。原厂的时钟函数在还没有有效输入地址时可以
保持原来的 turbo 时钟，但 bus vote 仍会执行。

当前 `venus_helper_vb2_start_streaming()` 也在 `LOAD_RESOURCES` 前调用
`venus_pm_load_scale()`。V4L2 M2M 缓冲在 STREAMON 前已经经过 `buf_queue`，当前
驱动会把 OUTPUT 队列的 `bytesused` 缓存在 `inst->payloads[]`；因此 FFmpeg 已经
排队的首帧使这次调用不会走“无输入直接返回”，而会设置 OPP 并执行
`load_scale_bw()` 的 interconnect vote。test7/test12 的 `first-input clock` 日志也
证明该分支在会话启动时实际运行。总线投票的相对位置与原厂一致，不作为下一轮
补丁项；test13 保留提交前的时钟/地址日志用于实机复核。

### 18. recon 需求不代表还缺一块静态 DMA

固件的最终 requirements 含 type 9 recon，但原厂 `msm_comm_set_recon_buffers()`
只按 `buffer_count_actual` 建立若干索引项，不分配内存，也不发送 SET_BUFFERS。
这些索引只用于把 encoder ETB_DONE 末尾的 recon/UBWC 统计对应到动态总线投票；
首帧前没有统计时使用保守默认值。当前公共 Venus 忽略这组可选动态统计，但不会
因此少给固件一块 recon 内存。继续把 type 9 排除在 test13 的静态 DMA 阶段之外。

## test13 分阶段安全边界

`iris1_encoder` 仍是总开关，默认 `N`。`iris1_encoder_stage` 默认 `0`，规划如下：

| stage | 最远执行位置 | 预期用途 |
|---:|---|---|
| 0 | 协议和最终 requirements，DMA 前返回 | 安全基线 |
| 1 | scratch0 | 判断第一类内部 DMA/SET_BUFFERS |
| 2 | scratch1 | 继续缩小内部缓冲边界 |
| 3 | scratch2 | 继续缩小内部缓冲边界 |
| 4 | persist0 | 检查持久缓冲 |
| 5 | 全部内部缓冲（persist1 若未要求则明确跳过） | 完成内部缓冲区段 |
| 6 | LOAD_RESOURCES 完成后停止并清理 | 验证资源加载 |
| 7 | START 完成后停止并清理 | 验证固件启动 |
| 8 | 只提交 CAPTURE/FTB，不提交输入帧 | 验证码流输出缓冲 DMA |
| 9 | 再提交 OUTPUT/ETB | 完整编码，最高风险 |

不得跳级。每一级只有在设备不重启、日志符合预期且 runtime PM 最终回到
`suspended` 后，才进入下一级。stage 9 通过并产出可解码、像素正确的 H.264
之前，不推送“编码已修复”的结论。

stage 0 当前已经由 `venc_iris1_stage_preflight()` 在调用内部 allocator 前拦截。
test13 仍在 allocator 内将 stage 0 的待分配数量强制为 0，作为防御性第二道
门禁，避免以后调整调用顺序时意外开放 DMA。

## 静态验证状态

- `0015`--`0017` 已在应用了 test13 全部改动的 `F:\linux\test13-verify` 上分别
  通过正向与反向 `git apply --check --whitespace=error-all`；补丁重新应用后
  `git diff --check` 通过。
- 宿主测试覆盖 HFI ring、故障注入、工作路由/模式、Main10/P010、requirements、
  分阶段门禁、ETB 保留字/返回日志和面板 LP/250 ms 合并；全部通过。
- 已使用 Git for Windows 的 Bash 执行 `bash -n` 和测试脚本 `--self-test`，两项
  均通过；CI 仍会在正式编译前重复执行。

## test13 实机分阶段结果

- stage 0：协议、属性和最终 requirements 通过；预期以 `-EACCES` 停止，PM 回到
  `suspended`。
- stage 1--5：scratch0/1/2、persist0 的 SET/RELEASE 均通过；persist1 未被固件
  请求并正确跳过，PM 均回到 `suspended`。
- stage 6：`LOAD_RESOURCES` 完成，随后 `RELEASE_RESOURCES` 和清理通过。
- stage 7：`START` 完成，随后 `STOP`、`RELEASE_RESOURCES` 和清理通过。
- stage 8：4 个 CAPTURE/FTB 缓冲全部成功入队，地址位于 32-bit IOVA 范围；没有
  提交输入帧，超时退出后设备未重启且 PM 回到 `suspended`。
- stage 9：内部缓冲、`LOAD_RESOURCES`、`START` 和 4 个 FTB 再次全部通过；第一笔
  OUTPUT/ETB 为 `tag=0 dma=0xdf498000 alloc=32768 filled=18432 offset=0`。日志在该条
  `queue ETB` 后立即停止，设备整机重启，没有 ETB_DONE、FTB_DONE 或正常清理。

因此 test13 已把复位边界锁定到固件/硬件首次读取编码输入缓冲。下一轮不得重复
stage 0--8；重点只核对 HFI4 ETB packet 字段、输入 NV12 的实际 plane/stride/scanline
布局、DMA 映射方向和缓存同步，以及原厂 SM8150 在首次 ETB 前设置的输入缓冲属性。

### Test14 Stage 0 推翻了 WORK_MODE 根因假设

原厂 `msm_vidc_decide_work_mode_ar50()` 确实按 rate-control mode 决策：VBR/MBR
系列选 mode 2；RC_OFF、CBR 和 CQ 选 mode 1，且 encoder 的 mode 1 紧接
`VENC_LOW_LATENCY_MODE=1`。但是 test14 Stage 0 的实机日志已经证明，本次 FFmpeg
命令在 STREAMON 前把会话设成了 `rc_enable=1 bitrate_mode=0`，也就是 VBR；内核
最终得到 `mode=2 low_latency=0`。这与原厂 VBR 路径完全一致。

因此“test13 首个 ETB 复位是因为把 RC_OFF 错发为 mode 2”的假设已被排除，不能
再拿它作为运行 Stage 9 的依据。test14 对工作模式的条件化实现本身可保留，因为
它使不同 RC mode 与原厂一致；ETB 尾部保留字清零也可作为确定性加固保留，但尚无
证据表明两者修复了复位。下一轮继续只对比首个 ETB 前的 VBR 属性语义、输入 DMA
可见性和 IRIS1 硬件取数前置条件；在出现新的可区分改动前，不运行 test14 Stage 9。

### Test15：原厂独立发送 DISABLE_RC_TIMESTAMP

继续逐项检查小米 Android 10 原厂 `msm_venc_s_ctrl()` 后发现一个直接落在首个
ETB 边界上的遗漏。原厂对 `V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE` 的处理不是只
选择 VBR/CBR/OFF：它还把控件值原样写入 `HAL_PARAM_VENC_DISABLE_RC_TIMESTAMP`；
HFI packetizer 再将其封装为
`HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP`（`0x2005027`）和一个
`hfi_enable`。

当前 Venus 的 `hfi_helper.h` 已定义完全相同的属性 ID，`hfi_cmds.c` 也已有正确的
通用 enable 封包，因此协议定义本身没有缺失；真正的偏差是
`venc_set_properties()` 从未发送该属性。Test14 Stage 0 又确认本次 FFmpeg 会话的
`FRAME_RC_ENABLE` 实际为 1，所以原厂会发送 `DISABLE_RC_TIMESTAMP=1`，当前却
什么都不发。

这条属性与 rate-control mode 是两条独立命令：VBR 仍保持 WORK_MODE_2；新增属性
只让固件不要依据每个输入帧的时间戳执行 RC。时间戳第一次随 ETB 被固件消费，
与 Test13“首个 ETB 成功入队后立即整机复位”的边界严格吻合。Test15 因而仅对
IRIS1 补发该属性，值取 `ctr->rc_enable`，并打印
`venus-test15: encoder rc timestamp disable=...`。其他 Venus 版本不变。

这条候选已经完成实机验证并被排除：Test15 Stage 0 确认值为 1、VBR mode 2 不变，
Stage 9 仍在首个 raw ETB 后卡死重启。因此属性对齐本身保留，但不再把它列为根因，
也不再重复运行 Stage 0--8 或 Test15 Stage 9。

## 已完成的 Test15 验证边界

1. Stage 0 已确认 VBR `mode=2`、`encoder rc timestamp disable=1`，退出后 PM 回到
   `suspended`。
2. Test13 Stage 1--8 的内部 DMA、LOAD/START 和 FTB 结论继续有效，不再重复。
3. Test15 Stage 9 已执行且整机卡死重启，没有非空 H.264、EBD 或 FBD。
4. 后续只围绕首 raw ETB 的 alloc-size、DMA direction/sync、IOMMU 可见性做可区分
   A/B；任何编码“通过”仍必须满足非空码流、ffprobe 识别和软件解码成功。

## Test15 编译期间继续比对记录

本节只记录 Test13 已锁定的“第一个 encoder ETB 入队后整机复位”边界，不重复
Stage 0--8。比较对象固定为当前 Test15 完整补丁树与小米 Android 10 SM8150
原厂树；后续排查先查本节，避免重复检查。

### 已核对并排除

1. **HFI4 ETB/FTB 包布局**：原厂与当前 encoder ETB 的 session、view、timestamp、
   flags、mark、offset、alloc/filled length、tag、packet/extradata address 字段顺序和
   宽度一致；FTB 同样一致。Test14 将 ETB 最后一个 VPU5 保留字置零属于确定性
   加固，但不是已证实根因。
2. **首帧 tag 与 timestamp 单位**：tag 0 在原厂合法；两边都把 V4L2 纳秒时间戳
   转成 HFI 微秒。没有 tag 起始值或高低 32 位错位。
3. **输入颜色格式**：两边给线性 NV12 使用的 HFI 值均为 `0x2`。原厂只给 P010
   或 NV12_512 发送 plane constraints；当前 IRIS1 对线性 NV12 跳过该属性，与
   原厂一致。
4. **工作路由、工作模式和核心选择**：本次 FFmpeg 实际是 VBR，原厂应为
   route 2、WORK_MODE_2、单 video core；当前实机日志也是 route 2/mode 2，并把
   MVS0 作为 codec core。MVS1 是 CVP，不应当当作第二 codec core。
5. **启动顺序**：两边的关键顺序均为属性/内部配置、route/mode/core、最终
   requirements、内部缓冲、时钟和带宽、LOAD_RESOURCES、START，最后才提交
   FTB/ETB。原厂 `msm_vidc_set_internal_config()` 对当前普通 VBR、非低延迟、
   单 slice 用例没有额外动作。
6. **静态内部 DMA 与 recon**：scratch0/1/2、persist0 的分配、SET_BUFFERS 和
   RELEASE_BUFFERS 已由 Stage 1--5 逐项通过；persist1 未被固件请求；recon type 9
   只建立统计索引，不是漏分配的静态 DMA。
7. **电源与时钟的时点**：当前 IRIS1 在固件启动前已经拉起 MVSC、MVS0、CVP 的
   power domain 和 clock，并完成硬件控制交接；原厂的寄存器恢复、IRQ 和 hardware
   power-collapse 交接也发生在固件启动/恢复阶段，不是首个 ETB 才发生。Stage 7/8
   已经过相同电源状态，因此暂不把“首帧漏开电源”作为候选。
8. **总线投票时点**：原厂与当前都在 LOAD_RESOURCES 前按负载投票，当前还会在
   第一个输入提交时再次 scale。533 MHz 与 SM8150 v2 原厂表一致，不是误用其他
   SoC 的超频值。
9. **VB2 cache 同步基本语义**：原厂把 dma-buf 以 `DMA_BIDIRECTIONAL` 映射，并在
   encoder input qbuf 时显式 clean/invalidate 有效载荷；当前 VB2 OUTPUT 队列自动
   使用 `DMA_TO_DEVICE`，`vb2_dma_contig` 的 `prepare()` 会在 qbuf 后、硬件取数前
   执行 `dma_sync_sgtable_for_device()`。实现方式不同，但当前并非完全没有输入缓存
   清理；单凭这项不能解释复位。
10. **DMA 设备和非安全 IOMMU SID**：当前 encoder 和已稳定工作的 decoder 都使用
    Venus 父设备及 `vb2_dma_contig`，不是 encoder 子节点误挂到另一个普通 Linux
    device。原厂普通非安全 `venus_ns` 使用 `iommus = <&apps_smmu 0x2300 0x60>`，
    `buffer-types = <0xfff>`，也就是同一 context bank 覆盖 input、output 和内部缓冲，
    并没有给非安全 pixel/bitstream 分开 SID。当前 DTS 已包含完全相同的
    `0x2300/0x60`；另外的 0x2301/0x2303/0x2304 对应原厂三个 secure context，
    不是本次普通 VBR 首帧所缺的映射。因此“首个 ETB 缺非安全 pixel SID”排除。

### 已确认的真实差异

1. **RC timestamp 属性**：原厂在 FRAME_RC_ENABLE 控件处理中独立发送
   `HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP`；Test14 证明本次值为 1，而
   Test14 以前当前完全没发。Test15 已补齐，这是与首个 ETB 消费 timestamp 高度
   相关、且当前最优先的实机候选。
2. **线性 NV12 input size 策略**：128x96 时当前 VB2 plane/ETB `alloc_len=32768`，
   原厂公式为 24576；两边 `filled_len=18432`。本地较新的上游提交甚至将多余 padding
   进一步减到 20480，说明当前确有额外 over-allocation。大 buffer 通常合法，所以
   这是实际差异但不是确定根因。
3. **编码码流 output size 策略**：当前小分辨率公式得到 73728，并把该值通过
   `0x20100c` 发给固件且用于 FTB；固件最终 requirement 是 36864，原厂在 S_FMT 后
   倾向采用固件 requirement。Test15 已复位，后续诊断版应优先尝试在 IRIS1 encoder
   使用最终 firmware bufreq，而不是继续猜测无关属性。
4. **原厂专有 bitrate-type 属性**：原厂还有 `VENC_BITRATE_TYPE`（`0x2005031`，
   `hfi_enable`，默认 enabled），当前没有。但原厂只在 userspace 显式设置对应私有
   control 时发送，尚无证据 Android 普通 VBR 会话一定发送；暂不盲补。
5. **DMA 方向实现**：原厂把 dma-buf 统一以 `DMA_BIDIRECTIONAL` 映射，再显式对
   encoder input 有效区间做 clean/invalidate；当前按 VB2 队列语义把 input 映射为
   `DMA_TO_DEVICE` 并由 VB2 自动同步。两种做法都保证设备读前可见，暂时只能算实现
   差异。Test15 已失败，可用只改变 mapping/sync 方式的诊断补丁单独验证，但优先级
   低于已确认的 size 策略差异。

### 已纠正的误判

1. VPU5 QP-range 包虽然有 10 个 reserved word，但原厂与当前 packetizer 都只填写
   有效字段，而且两边调用者都使用未整体清零的栈 packet；因此它不是两棵树之间的
   差异。后续可以统一清零加固，但不能当作当前根因。
2. 原厂把属性 `0x20100c` 命名为 `BUFFER_SIZE_MINIMUM`，当前上游命名为
   `BUFFER_SIZE_ACTUAL`；两边 wire ID 和 `{buffer_type, buffer_size}` payload 完全
   相同。真正差异包括发送的 size 数值以及当前是否在最终 requirements 后发送；
   0027 已按原厂顺序补回，并使用 firmware-negotiated capture size。

### Test15 结果后的固定决策

- Test15 Stage 0 实机已通过：日志确认
  `encoder rc timestamp disable=1`、VBR `work mode=2`，随后按 staged 门禁预期以
  `-EACCES` 返回；10 秒后 runtime PM 为 `suspended`。这证明新增属性已实际封包并
  被当前启动路径发送，同时没有破坏既有 VBR 模式或释放流程。
- Test15 Stage 9 实机失败并导致整机卡死重启。实时日志确认
  `encoder rc timestamp disable=1` 确实在本次会话发送，因此该遗漏不是复位根因。
  本次远程日志最后成功显示 persist0 的 `SET_BUFFERS queued`，但 Stage 4/5 已在同一
  内核路径独立证明该操作及释放安全；日志在突然复位前没有完整送出，不能据此把
  persist0 误判为新的边界。Test13 已捕获到首个 ETB 入队后中断，Stage 0--8 仍然
  有效，禁止再次重复。
- Test15 已在首个 ETB 后复位：不要重跑 Stage 0--8；下一步只在以下两项之间做
  可区分诊断：先将 IRIS1 encoder input/output alloc_len 收敛到原厂/firmware
  requirements，并逐项打印实际 IOMMU domain、SG DMA 地址和长度；如果仍失败，
  再单独试验原厂的双向 DMA mapping 与显式 partial cache sync，不能把两类变化混在
  同一次编译里。

## 0027：阶段诊断结束后的产品路径

0024 已把 raw input 收敛为原厂 layout、compressed capture 收敛为 firmware
requirement；0018/0024 已把 IRIS1 source DMA 固定为双向并在 ETB/FTB 前验证完整
32-bit IOVA range、alignment 和 payload。重新逐行核对原厂
`msm_vidc.c::start_streaming()` 后，确认此前“原厂不发送 0x20100c”的判断错误：原厂
在最终 `GET_BUFFER_REQUIREMENTS` 后明确发送 `HAL_PARAM_BUFFER_SIZE_MINIMUM`，值取
CAPTURE plane size，然后才 verify、登记 internal buffers、LOAD/START 和 qbuf。

0027 因此完成以下收口：

1. 最终 requirements 后发送同 wire `0x20100c`，type 为 OUTPUT，值为已收敛的
   firmware capture requirement；
2. 删除 Stage0--9 以及 `enc_test_stage`，完整路径固定为 internal buffers →
   LOAD_RESOURCES → START → FTB → ETB；
3. 删除可关闭的 vendor NV12 和 bidirectional 参数，使两项原厂平台契约在 IRIS1
   上无条件生效；
4. 保留唯一 `iris1_encoder` 总 gate 且默认 N，实机 Test16 明确开启后才运行完整路径；
5. 自动测试先用 1 帧 H.264 探测，成功后才继续 H.264/HEVC/VP8 短流，任何失败立即
   停止剩余 codec job。

原厂 CAPTURE `static` alloc-mode 字段也已追完全部 set-buffer 调用：它没有导致普通
encoder userspace capture DMA 逐个静态登记，FTB 仍直接携带 IOVA。因此当前没有仅凭
该字段盲加重复 `SET_BUFFERS`。这项以后除非取得新的 wire 日志，不再重复检查。
