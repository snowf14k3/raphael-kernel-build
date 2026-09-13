# IRIS1 legacy decoder buffer contract

本阶段修复 SM8150 / IRIS1 上 VP8、VP9 和 MPEG2 解码器与 HFI4 固件之间的 buffer contract。最终代码来自 Raphael Android Q `msm/vidc` 内核实现与 SM8150 OMX 客户端的完整对照，并由 `cf10-msmvidc-omx1` 热替换模块完成实机验证。

## 根因

主线 Venus 会为线性 NV12 自动启用 UBWC DPB + OUTPUT2 OPB，但普通 V4L2 客户端只提供一个 NV12 capture plane。SM8150 Android OMX 默认启用 interlace、output crop、VPX display information 和 UBWC compression statistics extradata，并为每个 OUTPUT2 buffer 附带独立的 16 KiB DMA extradata plane。

缺少该 DMA 地址时，固件接受并归还内部 OUTPUT DPB，却对每个 OUTPUT2 FTB 返回 `HFI_ERR_SESSION_BAD_POINTER` (`0x1003`)。DS1 日志中 6 个 DPB 均成功，20 个 OUTPUT2 buffer 恰好对应 20 个 `0x1003`，把故障边界确定在客户端 OPB 描述符。

## 实现

- 使用实际输入分辨率初始化 legacy decoder session。
- 按下游顺序配置 UBWC DPB、OUTPUT2、线性 NV12 OPB、work mode 和 work route。
- 使用固件 DPB 大小及下游 NV12 OPB 大小。
- 分别发送 HFI4 `count_actual` 和 `count_min_host`，正确映射 OUTPUT DPB 与 OUTPUT2 OPB 数量。
- 解析 HFI4 `DPB_COUNTS` 属性 `0x100300b` 的三字段 payload。
- 启用 Android 默认的四类 decoder extradata。
- 为每个 V4L2 capture buffer 内部分配 16 KiB 非安全 DMA extradata；该缓冲区不作为额外 V4L2 plane 暴露给用户态。
- 按固件 requirement 为 DPB 分配并提交 extradata。
- legacy decoder 使用下游的零 output tag，并根据 FBD `packet_buffer` DMA 地址回收用户 buffer、DPB ownership 和 release-reference。
- 完整释放额外 DMA allocation，并处理 vb2 buffer 初始化失败。

H.264、HEVC 及 encoder 的现有 tag 和 buffer 路径保持不变。诊断用 HFI trace 与 `MODULE_VERSION` 标记未进入正式补丁。

## 实机结果

目标设备：Xiaomi Redmi K20 Pro / Mi 9T Pro (`raphael`)

运行内核：

```text
7.1.0-sm8150-g05f914827158
```

验证模块：

```text
cf10-msmvidc-omx1
```

VP8 测试输入为 640x480、15 fps、连续 30 帧。结果：

```text
FFmpeg exit: 0
software decode: 13824000 bytes
hardware decode: 13824000 bytes
byte-for-byte comparison: PASS
```

固件报告 OUTPUT2 extradata requirement 为 500 字节；驱动按照 Android OMX 合同为每个 capture buffer 提供 16 KiB，对 requirement 留有余量。完整内核重新构建及长期、并发、休眠恢复稳定性仍需单独验证。

## 来源

- Raphael Android Q kernel: `drivers/media/platform/msm/vidc/`, commit `192eca8550f9`。
- Android SM8150 media OMX: `mm-video-v4l2/vidc/vdec/src/omx_vdec_v4l2.cpp`, commit `748f3f05bde7a465ace3eae7d8fbef3087032070`。
- 实机日志：`cf10-msmvidc-ds1` 与 `cf10-msmvidc-omx1` 测试记录。
