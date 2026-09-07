# SM8150 / Raphael Venus test8

test8 针对 test7 的 HEVC Main10 实机结果修正 V4L2 CAPTURE 格式协商。源码
基线仍固定为 `58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按
`patches/series` 依次应用六个补丁。

## Test7 已确认的状态

- H.264 硬解码 30 帧，明确使用 `qcom-venus`，像素哈希与软件解码完全一致。
- WORK_ROUTE、LOAD_RESOURCES、START、输入/输出缓冲完成及 runtime PM 均正常。
- HEVC Main10 会话也完成 LOAD_RESOURCES 和 START；固件持续返回
  FILL_BUFFER_DONE，结束时正常释放资源并休眠，但 FFmpeg 报 invalid frame，
  输出 0 帧。

因此 HEVC 的失败点不在固件、时钟、电源或 HFI 会话启动，而在固件返回帧
之后的 V4L2/FFmpeg 格式交接。

## 本轮修正

- 把 V4L2 compressed fourcc 到 HFI codec 的映射收敛为一个公共函数，避免
  `hfi.c` 与格式枚举代码维护两份映射。
- OUTPUT `S_FMT` 选择 HEVC/VP9 等 codec 后立即同步 `inst->hfi_codec`。
  原代码要等到 HFI session init 才同步，因此会话创建前的 CAPTURE
  `ENUM_FMT` 仍按默认 H.264 能力过滤，错误隐藏 P010。
- 收到 10-bit source-change 时，先切换 CAPTURE 为 P010，再计算 stride、
  sizeimage 和对齐值，避免用旧 NV12 格式规范化新流。
- 在 SM8150 上每次 source-change 和首个 CAPTURE buffer 各记录一条低噪声
  日志，包含 bit depth、profile、fourcc、大小、stride、bytesused 与 HFI flags。
  若仍失败，可以直接分辨是格式描述还是返回缓冲异常。

小米 Android 10 原厂驱动会枚举 P010 capture 格式；主线 HFI v4 能力表也明确
声明 HEVC Main10、TP10 UBWC DPB 与 P010 OUTPUT2。本修正保留主线按 codec
能力过滤的设计，只修复所选 codec 状态不同步，不向不支持的 codec 虚假暴露
P010。

## 自动与实机验证

宿主机测试会编译实际 codec/format helper，验证 H.264 不暴露 P010、切换到
HEVC 后暴露 P010，同时检查 source-change 顺序。实机脚本增加 8-bit HEVC 与
10-bit HEVC 小样本，并继续以软件解码的逐帧哈希作为真值。

构建后内核版本必须为 `7.1.0-sm8150-venus-test8+`。硬编码仍默认禁用；已有
test5 整机复位记录，在专门修复编码路径前不要启用。
