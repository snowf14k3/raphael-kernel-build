# hot2：限速条件下完整30帧H.264硬解通过，编码单独回验

记录日期：2026-09-12。结果来自用户粘贴的手机日志，不是编译服务器执行。

## 已取得的实机证据

运行内核 `7.1.0-sm8150-ga0ca2cbb4b3d`，当前 core 为 `iris1-swpc-ofref-hot2`，测试期间保留 `power/control=on`。同一原样片位于 `/var/tmp/venus-hot2.FRRtCm/input.mp4`；本轮诊断目录为 `/var/tmp/venus-hot2.FRRtCm/gfmt-paced.QQPG7J`。

- FFmpeg 明确以 `h264_v4l2m2m` 打开 `/dev/video1`，驱动 `qcom-venus`。
- 样片 H.264 Constrained Baseline、逐行、640x480、15fps、30帧；输入增加 `-re`。
- 初期仍出现7次 `VIDIOC_G_FMT ioctl` 警告（第一条加6次重复），随后CAPTURE输出成功。
- FFmpeg退出0，输入30包、解码30帧、0 decode errors，输出NV12 13824000字节。
- 脚本检查 `640*480*3/2*30` 字节，并执行实际 `cmp -s`，用户显示像素与软件参考逐字节相同。
- Venus IRQ 196 的计数43->139；本轮kernel.log打印窗口只有标记，无新增错误。
- 标记 `VENUS_GFMT_PACED_78e8aa28-c71f-413f-8f63-8fe3698c5fa1_14797`，时间993.382625。

**支持的结论：上述样片在限速条件下完成连续硬解、像素对照和本次进程退出。** 不只是设备枚举或单帧成功。

**不支持的结论：全速初始化问题已修复、所有片源/HEVC/Main10可用、编码已通过、runtime PM/冷启动/模块卸载生命周期无问题或性能已达标。** 日志中的 `rawvideo (native)` 和 `frames encoded` 是将解码帧输出为NV12原始数据，不是Venus H.264硬编码成功。受 `-re` 影响的speed值也不是最大吞吐量测试。

## 全速缺陷仍然保留

前一次不带 `-re` 的相同样片在CAPTURE G_FMT尚未成功时已达到输入EOF，30包、0帧、0字节。源码核对与主机控制流测试保存在 `out/venus-validation/gfmt-zero-frame/`：FFmpeg n7.1.1有在CAPTURE尚未分配时进入draining并直接EOF的路径。

本次结果更支持“输入进度与异步初始格式协商的时序”方向，排除了当前样片在现有硬件链路上完全不能解码的说法。但没有实测精确ioctl errno/源码事件时序，不能只凭改变输入速度就认定全部根因仅在FFmpeg或宣布驱动完全正确。后续全速修复应处理就绪等待/事件和EOF顺序，不以强制所有应用使用 `-re` 代替正式修复，也不盲目修改DMA、固件或增长timeout。

官方参考：`https://www.ffmpeg.org/ffmpeg.html` 的 `-re` 为输入读取限速；`https://docs.kernel.org/userspace-api/media/v4l/dev-encoder.html` 区分raw OUTPUT与压缩CAPTURE及完整排空。现有手机FFmpeg相关源对照版本为n7.1.1，不因在线文档变化而改写既有证据。

## 独立编码入口，不篡改解码验收标记

新增 `tests/venus/encode-after-paced.sh`，参数为已成功限速实验的目录。它不加载/卸载任何模块，不写启动文件、不改23份内核patch，不创建 `decode.success` 或删除原 `decode.started`。

在提交一次编码前，重新核对当前内核、模块版本、绑定、电源状态、同一boot的hot2记录、限速成功日志、两份NV12大小和实际逐字节一致性。没有这些证据就停止。节点按名称查找，拒绝已占用视频设备、已有WARN/Oops、并发操作和同次启动的重复编码。

只执行一次640x480、15fps、30帧NV12 -> H.264（1 Mbps、GOP15、B帧0）硬编码，将完整原始输入复制到新的诊断目录，保存详细FFmpeg日志和中断计数。输出需非空、FFmpeg退出0并明确选择Venus encoder，再用软件 `h264` 解码回NV12，检查完整30帧尺寸。本阶段不把有损编码与原始NV12做bit-exact比较，不宣称码率控制、画质、长期稳定性已通过。

失败时保留原模块、原日志及本轮日志，不回装旧core、不重试。成功也只写独立 `encode-after-paced.success`，保留 `unpaced_decoder=UNRESOLVED`。脚本使用进程超时，但不能保证回收内核不可中断等待或避免硬件/固件崩溃。

## 服务器验证与交付边界

`tests/venus/test-encode-after-paced-safety.sh` 在临时目录模拟proc/sys/dev以及FFmpeg，覆盖错误模块、异常taint、旧boot、错误日志/节点、参考像素不符、重复/占用、硬编失败或超时、空码流、新警告、软件回验失败/短输出及通过路径。它只验证脚本控制逻辑，不代表真实编码通过。结果保留 `out/venus-validation/encode-after-paced/safety.log`。

本轮只更新结果文档和用户态测试脚本；不重新编译任何内核或模块，不直接在手机运行视频、不发布新的内核Pre-release。编码实际结果待用户下一次反馈。
