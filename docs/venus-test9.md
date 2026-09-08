# SM8150 / Raphael Venus test9

test9 在 test8 的基础上补齐 HEVC Main10/P010 的内核侧 V4L2 接口。源码基线
仍固定为 `58f3df07833f2382fe2fbc28f996c4c85817c1f6`，并按
`patches/series` 依次应用七个补丁。

## 已确认的基础

- H.264 硬解码 30 帧，像素哈希与软件解码完全一致。
- HEVC Main（8-bit）硬解码 30 帧成功。
- HEVC Main10 会话可以完成固件侧 LOAD_RESOURCES、START 和帧返回。
- runtime PM 可以在任务完成后恢复到 suspended。

## 本轮内核修正

- 线性 P010 的 Y/UV stride 改为 256 字节对齐，与小米 Android 10 SM8150
  原厂驱动及上游 Iris 10-bit 补丁一致。320 像素宽度的 stride 因而从 640
  修正为 768；1920 像素宽度仍为 3840。
- `ENUM_FMT` 保持稳定地列出硬件能力；实际 `TRY_FMT`/`S_FMT` 根据当前流的
  bit depth 拒绝不匹配的 NV12/P010 请求。这符合 V4L2 格式枚举语义，也避免
  10-bit 流被错误协商成 NV12。若用户态仍请求 8-bit 格式，驱动会安全回退
  到 P010，而不是留下空格式。
- QC10C 按 10-bit UBWC 的几何约束计算：高度 16 对齐，`width * 4 / 3` 的
  stride 按 256 字节对齐。
- 解码器增加标准 `V4L2_CID_MPEG_VIDEO_HEVC_PROFILE` 控件，只公开 Main 和
  Main10，并沿用现有 HFI profile 映射读取固件报告值。

宿主机测试会直接编译补丁后的真实 helper，检查 320x240 与 1920x1080 的
P010 buffer size、8/10-bit 分类、格式过滤以及 HEVC Main10 控件。

## 已知用户态限制

Debian 13 当前 FFmpeg 7.1 的 V4L2 mem2mem 格式表没有 P010 映射。因此即使
驱动正确返回 P010，`hevc_v4l2m2m` 仍可能显示 `capture=NV12/yuv420p10le`，
随后报告 `An invalid frame was output by a decoder`。这是内核完成 Main10/P010
接口后仍需单独修复的 FFmpeg 用户态问题；test9 不把它伪装成内核通过。

默认实机脚本继续安全验证 H.264 和 HEVC 8-bit，并将 Main10 标为 SKIP。
硬编码也保持默认禁用，因为 test5/test8 已有整机复位记录。

构建后内核版本必须为 `7.1.0-sm8150-venus-test9+`。
