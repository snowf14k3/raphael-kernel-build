# SM8150 / Raphael Venus test11

test11 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用十个补丁。前九个补丁的协议、电源、LLCC、HEVC Main10/P010 与
编码安全锁保持不变。

test10 实机已经确认 HEVC Main10 会话上报 `VIDC_BITDEPTH_10`，source-change
把 CAPTURE 切换为 `P010`，并成功回收第一块 10-bit capture buffer。Debian 13
自带 FFmpeg 7.1 的 V4L2 格式表没有 P010 映射，因此 `hevc_v4l2m2m` 会在收到
该帧后以 `frame->format < 0` 报 `An invalid frame was output by a decoder`。
这是已确认的用户态限制，不再用错误的 NV12 冒充 10-bit 输出，也不继续改动
已经正确工作的内核 P010 协商路径。

## 本轮实机定位结果

test10 能正常启动和注册 `/dev/video0`，但编码节点的 `open()` 返回
`-EINVAL`。函数图证明失败发生在 `venc_ctrl_init()` 的
`v4l2_ctrl_handler_setup()`，早于 V4L2 队列、HFI session 和任何硬件 DMA。

原因是 SM8150 按原厂语义把默认 H.264 Profile 设为 Baseline，而公共 Venus
控件仍把 `H264_8X8_TRANSFORM` 默认设为开启。Baseline 不允许 8×8 transform，
因此默认控件初始化必然自相矛盾。

test11 对 SM8150 使用 `H264_8X8_TRANSFORM=0`，并只在用户确实请求开启 8×8
且 Profile 不是 High/Constrained High 时返回 `-EINVAL`。其他 SoC 继续保持
High Profile 与 8×8 默认开启，不改变原有行为。控件默认值若仍初始化失败，
内核会输出明确的 `venus-test11` 错误日志。

## 安全边界

`iris1_encoder` 与 `iris1_encoder_dma` 仍默认都是 `N`。在此状态下，
`v4l2-ctl --all` 应能打开并枚举编码节点，但 `REQBUFS` 前的 session/协议路径
以及真正的 DMA、LOAD_RESOURCES、START 仍分别受两道锁保护。

第一次实机验证只检查启动、解码、runtime PM 和编码节点只读枚举。随后只将
`iris1_encoder` 设为 `Y`，保持 `iris1_encoder_dma=N`，验证协议预检能够在
第二道锁处可恢复地失败。只有协议日志和电源恢复均正确后，才考虑单独启用
DMA 锁；安全锁不能证明实验性硬编码绝不会触发设备复位。

构建后内核版本必须为 `7.1.0-sm8150-venus-test11+`。
