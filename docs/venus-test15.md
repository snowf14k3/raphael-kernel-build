# SM8150 / Raphael Venus test15

test15 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用十七个补丁。它保留 test13 已由实机逐级通过的内部缓冲、
LOAD/START、FTB 和解码路径，以及 test14 的确定性 ETB、按 RC mode 选择工作模式
和面板更新限制。

## Test14 Stage 0 的纠正结论

Test14 实机日志是
`mode=2 rc_enable=1 bitrate_mode=0 low_latency=0`。本次 FFmpeg 冒烟测试实际启用
VBR，因此原厂 SM8150 同样应使用 WORK_MODE_2；WORK_MODE 不是首个 ETB 后整机
复位的根因。Test15 不再沿用“该会话是 RC_OFF”的错误假设。

## 原厂遗漏的独立时间戳 RC 属性

小米 Android 10 SM8150 原厂驱动对
`V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE` 做了两件彼此独立的事：rate-control mode
仍决定 OFF/VBR/CBR，而这个布尔控件还直接发送
`HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP`。当前 Venus 已有正确的
`0x2005027` 属性 ID 和 HFI enable 封包，却从未在 encoder 属性设置中发送它。

Test15 仅对 IRIS1 补上这条原厂 HFI 属性，值严格取自 `ctr->rc_enable`。本次
FFmpeg 会话预期发送 `disable=1`。这个差异与首个 ETB 直接相关：固件在消费第一帧
输入时才开始使用该帧的时间戳；Test13 正是在首个 ETB 入队后、任何完成消息返回前
复位。

这是一条有原厂代码依据的修正，不代表未经实机便宣称编码已经可用。

## 安全验证顺序

编码总开关仍默认 `N`，阶段默认 `0`。首次启动只运行 Stage 0，确认同时出现：

- `venus-test14: encoder work mode=2 rc_enable=1 bitrate_mode=0 low_latency=0`
- `venus-test15: encoder rc timestamp disable=1`
- `protocol preflight passed`
- runtime PM 最终回到 `suspended`

Stage 0 仍会以 `Permission denied` 拒绝 STREAMON，这是安全门按预期工作，不是新的
编码故障。只有上述四项全部成立，才有依据在带远程实时内核日志的条件下运行一次
Stage 9。有效 H.264 文件能被软件解码前，硬编码仍不能标记为通过。

构建后内核版本必须为 `7.1.0-sm8150-venus-test15+`。
