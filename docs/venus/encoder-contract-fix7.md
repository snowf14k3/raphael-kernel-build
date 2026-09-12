# IRIS1 encoder CF7：跳过未变更属性重放并保持 VUI timing 默认关闭

## CF6 实机结果

CF6 在 boot `844f7e9c-cd74-40a2-848b-6724a61e92ec` 加载了
`iris1-startcontract6-20260912` core/encoder，单帧 probe PID 为
`56168`。Windows 日志有 921 行，SHA-256 为
`58E0C8CD474D387499D0AC2DD36077A247129980629F9530C2D7C6F286E48BA1`；
手机终端输出 SHA-256 为
`B4DF6BB5C60E905518CB2E4F2E3D2288FAE3BB16EF25922F8320F8E04453D335`。

已确认：

- CF6 模块身份、绑定、640x480 H.264 的 230400-byte CAPTURE 合同正常。
- 4 个 CAPTURE buffer 和 1 个填充后的 OUTPUT buffer 已入队。
- CAPTURE STREAMON 返回；OUTPUT STREAMON 进入两侧均开启的
  `venc_start_streaming()`。
- REQBUFS 阶段第一遍完整 property suite 成功，最后到 `0x2005016`。
- 两次 queue-setup `GET_BUFFER_REQUIREMENTS` 均收到 244-byte、7-row
  完整响应并完成 waiter。
- 启动阶段 PM/core acquire 和 `0x2002` 成功，然后开始第二遍完整属性发送。
- 第二遍依次看到 `0x1015 AFTER`、`0x1017 AFTER`、`0x2001 AFTER`，
  接着 `0x200501e BEFORE`。该 32-byte `0x11001` packet 已到
  `TX_COPY AFTER`、`TX_NOTIFY AFTER` 和 `TX_POST`，随后外部日志停止。
- 手机 stdout 最后停在 probe step 108 `STREAMON_OUTPUT_SECOND_BEFORE`。

没有看到第二个 `0x200501e` 的 SET_PROPERTY AFTER、PROPERTIES AFTER、
CF6 count/snapshot/size 标记、内部 buffer、LOAD、START、FTB 或 ETB，也没有
捕获 RPMh、SMMU、NoC、watchdog、Oops 或 panic 文本。

因此，本次重启发生在 CF6 两项功能改动之前。它不能验证或否定 0030/0031。
`0x200501e` 是 H.264 VUI timing，但同一 session 约 85 ms 前已成功发送过
相同属性；最后可见日志只是边界，不能证明 VUI timing 是根因。

## 固定源码对照

Android Q 固定提交
`192eca8550f95c2eec58a474793d1d93fc1b3b67` 有两项与当前 Venus 不同：

1. Android Q 的 start 路径配置 internal/work route/work mode/core 后直接进入
   requirements/count/size/internal buffer/load/start，不会在 STREAMON 再重放
   整套 encoder properties。
2. Android Q 的 VUI timing control 默认值是
   `V4L2_MPEG_MSM_VIDC_DISABLE`。它的通用 control init 只创建和 cluster
   controls，没有调用 `v4l2_ctrl_handler_setup()`；只有 userspace 设置该
   control 时，s_ctrl 路径才发送 VUI timing。禁用载荷的 `enable` 为 0。

当前 Venus 则在 queue setup 创建 session 时调用一次
`venc_set_properties()`，实际 start 又调用一次，并对所有 H.264 session
固定发送 `enable=1`、`fixed_framerate=1`、`time_scale=NSEC_PER_SEC`。

Modern Iris 驱动架构不同；在本次固定源码搜索范围内没有 VUI timing 发送点，
所以它只作为旁证，不作为可直接移植实现。

## 正式补丁

### 0032：避免未变更的 IRIS1 属性重放

新增尾部枚举值 `VENUS_ENC_STATE_CONFIGURED = 5`，不改变现有枚举值或
`struct venus_inst` 布局。

`venc_set_properties_if_needed()` 的规则是：

- 非 IRIS1 保持原行为，每次调用都发送属性。
- IRIS1 首次成功发送后记为 CONFIGURED。
- CONFIGURED 且配置未变化时直接复用，不在第二次 STREAMON 重放。
- 成功的 control、S_FMT、S_SELECTION 或 S_PARM 会调用
  `venc_mark_config_dirty()`，将 CONFIGURED 恢复为 INIT。
- 变脏后 start 会重新发送一次；发送失败时不会标成 CONFIGURED。

该状态只缓存“当前 session 的整套属性是否已成功发送”，不缓存 firmware
响应，也不绕过 CF6 的最终 count、requirements、extent 和 internal-buffer
验证。

### 0033：IRIS1 不强制发送 H.264 VUI timing

IRIS1 的 H.264 property suite 跳过
`HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO`；其他 VPU generation
保留原行为。这对齐 Android Q 的默认未启用行为，但本补丁不宣称
`0x200501e` 已被证明为重启根因。

诊断模块保留 BROAD1 和 CF5/CF6 标记，并增加：

- `CF7_PROPERTIES APPLY`
- `CF7_PROPERTIES APPLIED`
- `CF7_PROPERTIES REUSE`
- `CF7_VUI OMIT IRIS1`

## 验证

- 从固定 Linux 基线
  `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5` 独立重放 33 个补丁通过；
  staged tree 与正式源码 tree 都是
  `faf3de269729fffeb28ddf9d9fce166a96a7dae5`。
- 0032、0033 严格 checkpatch 均为 0 errors、0 warnings、0 checks。
- 主机合同测试 300 条断言通过，包含 IRIS1 首次 APPLY、未变更 REUSE、
  变脏后重新 APPLY、失败不缓存、非 IRIS1 行为保持，以及四类配置入口和
  VUI guard 的 staged-source 接线检查。
- 包内一次性加载/日志/单帧脚本通过 447 条 mock safety 断言；不会接触硬件。
- 正式版和 BROAD1/CF7 诊断版均使用手机内核
  `7.1.0-sm8150-ga0ca2cbb4b3d` 的 headers/config/`Module.symvers`，
  以 `ARCH=arm64 LLVM=-22 KCFLAGS=-Werror` 编译通过。
- 构建前后四项输入哈希一致；模块为 AArch64，vermagic 精确匹配；诊断版与
  正式版的依赖和全局定义符号集合一致。

## 当前边界

CF7 已在 boot `611f97fa-0790-4977-bf77-354bb301f9a9` 执行并再次导致整机
重启。它成功打印 `CF7_VUI OMIT IRIS1`，第二次 STREAMON 打印
`CF7_PROPERTIES REUSE state=5`，随后完成 4/4 counts、单次 7-row
requirements snapshot、两侧 queue 验证、`0x20100c`、scratch 6/7/8、
persist 4、200 MHz OPP/clock 和 6533000 ICC vote。

`HFI_CMD_SESSION_LOAD_RESOURCES (0x211001)` 已发送，固件返回
`HFI_MSG_SESSION_LOAD_RESOURCES (0x221001)` 且 `fw_error=0`，同步 waiter
成功返回。最后一条日志是：

```text
venus_helper_vb2_start_streaming state=4 HELPER_START LOAD_RES AFTER rc=0
```

紧接着的源码标记 `LOAD_RESOURCES AFTER` 和
`HELPER_START HFI_START BEFORE` 均未出现；没有 START packet、START_DONE、
FTB、ETB 或第二次 STREAMON 返回。外部日志也没有 RPMh、SMMU/IOMMU、NoC、
watchdog、Oops、panic 或 HFI error。

因此 CF7 已排除 VUI timing 和未变更 property replay 作为当前直接边界，并
实际走过 CF6 的 buffer 合同。现阶段故障集中在固件确认 LOAD_RESOURCES 后、
主机记录发送 START 前的 encoder resource-activation 窗口。优先排查
encoder internal-buffer IOVA 首次访问，以及 IRIS1 codec island/bridge/power
切换；仅凭最后一条日志还不能在两者中定案，不据此直接制作下一候选。
