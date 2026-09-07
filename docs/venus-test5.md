# SM8150 / Raphael Venus test5 批量测试

状态：仍是实验内核，尚未通过本机硬件验收。不要把宿主机测试通过、
编译成功、出现 video 节点当作硬件编解码已经成功。

## 一次编译包含什么

源码基线：`58f3df07833f2382fe2fbc28f996c4c85817c1f6`。
按 `patches/series` 顺序应用三个补丁，不能跳过或乱序：

1. `0001-media-venus-fix-sm8150-runtime-data.patch`：保留 test4 的完整
   SM8150 原厂时序修正，包括电源域、时钟、OPP、控制权交接、失败回退、
   休眠/恢复及固件版本解析。此文件与 test4 相同。
2. `0002-media-venus-validate-hfi-rings.patch`：校验 HFI 环的大小、下标、
   包长度和已发布数据范围；串行处理共享 debug 缓冲区，限制打印长度。
   它是队列健壮性修正，不代表已经证实 test3 超时由队列越界引起。
3. `0003-media-venus-add-batch-diagnostics.patch`：命令/响应/中断累计计数，
   会话命令及电源转换超时现场、资源引用掩码和缓存频率。诊断不新增
   错误路径中的 MMIO 读取，不改固件包内容或硬件频率。

启动版本应为 `7.1.0-sm8150-venus-test5+`，日志前缀 `venus-test5:`。
`build-info.txt` 同时记录源码和构建仓库提交、补丁数和清单散列；
`patches.sha256` 给出每个补丁的散列。源码提交号不变不等于未应用补丁。

保留 GengWei 的配置合并顺序，另启用 DEBUG_FS、DYNAMIC_DEBUG、FTRACE、
FUNCTION_TRACER 和 DYNAMIC_FTRACE；构建前检查实际配置，避免选项被依赖
静默关闭。跟踪默认不开启，批量脚本也不会全局开启 ftrace 或 dynamic debug。
这些能力供后续定向诊断，不必为补一个调试开关再次编译。

原厂依据及尚未移植的功能边界见构建仓库 `docs/venus-test4.md`。
未修改 Adreno 640、屏幕亮度或分区布局；不额外刷 cache 镜像。

## 安装之后只运行一次

下载后先核对 SHA256SUMS、包版本、/boot 空间和原系统备份，并通过当前
对话完成 test5 安装与启动。脚本不会替你安装内核；不要在 test3 上运行。
将下载包内脚本放到手机 `/home/user/venus-test-suite.sh`，关闭播放器和
其他硬件编解码程序后执行：

```sh
sudo bash /home/user/venus-test-suite.sh
```

无需执行权限。想先看范围可用 `bash venus-test-suite.sh --plan`，不需要 root。
手机需要 FFmpeg（libx264、H.264 软件解码及 h264_v4l2m2m）、常规 Debian
命令，以及 `fuser`（psmisc 包）。脚本缺工具时会停止，不会自动联网安装。
测试数据仅占用 `/var/tmp`，启动前要求至少 64 MiB 空闲，不占用 /boot。

## 一轮覆盖的项目

- 保持 Venus runtime 电源开启：H.264 320×240/90 帧、720p/30 帧、
  1080p/30 帧硬解，以及重复打开会话。检查日志确实使用 qcom-venus，
  将每帧解码像素散列与软件解码结果比较，不只看 FFmpeg 返回成功。
- H.264 硬编 30 帧，再软件解码并核对帧数。有损编码不与输入逐像素比较；
  FFmpeg 缺少硬编接口时标记 SKIP，不算通过。
- 允许自动休眠：确实观察到 runtime_status=suspended 后再次硬解，
  重复两轮并校验输出。这是 runtime PM，不是整机 suspend-to-RAM。
- 收集每阶段 FFmpeg、内核日志、电源状态、时钟及中断快照。临时打开
  `venus_core.iris1_debug` 元数据日志，结束时恢复原始开关及 power/control。

保持上电与自动休眠是同一内核的标准 runtime PM 对照，不是几个未知寄存器
改法混在一起试。后续确需不同实现时再依据这一轮完整日志决定。

遇到第一个硬件超时、像素不符或电源错误，就停止后续编解码请求并保留
现场；未执行的项目标记 SKIP。错误状态下继续跑后续项目不能说明那些
功能各自有问题。FFmpeg 单项通常限制 25 秒并在额外 5 秒后强制终止；
内核不可中断等待、设备完全卡死或断电仍无法靠用户态超时保证恢复。
脚本不会卸载模块、重启、清空 dmesg、刷机或上传日志。

## 看结果

结束时打印 `/var/tmp/venus-batch.XXXXXX/report.tar.gz` 的实际位置。
用普通用户 sudo 运行时，该压缩包会交还给调用用户，便于 SCP 下载。
解包后主要看 `summary.tsv`、`result.txt` 和各阶段日志。恢复开关失败也会
记录 FAIL；此时不要继续测试，先带报告回到对话处理。

日志可能含设备信息，发送前可以检查。全部已执行项目通过仍不等于所有
Venus 功能稳定：HEVC/VP9 等格式、长期压力、并发编解码、4K、安全视频、
整机休眠和应用集成尚未覆盖。

## 编译前自动检查

CI 先运行实际驱动函数提取出的宿主机测试，再编译 arm64 内核：

- 25/6 个上下电、28/9 个 runtime 恢复/休眠 API 单次失败位置，双重回退
  失败、资源/IRQ 配平、会话共享与重试。
- 固件版本格式及固定宽度边界、debug 环只读窥视边界。
- 3968 组环形队列回绕读写、满/空队列、非法下标和截断/未发布/非对齐包。
- 批量脚本 Bash 语法、逐帧散列比较的自检。

宿主机测试使用模拟硬件 API，不覆盖真实并发、寄存器、电源后端和固件；
本地 Windows 检查不代替完整 arm64 编译，更不代替手机验收。
