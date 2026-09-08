# Raphael Venus 测试内核云编译

这个仓库只做一件事：编译包含 SM8150 Venus 适配及运行修正的
Redmi K20 Pro（Raphael）Linux 测试内核。

当前版本是 **test15 SM8150 编码时间戳 RC 属性修正版，待实机验证**。以小米 Android 10
SM8150 实现为依据，补齐固件启动前的电源域、时钟与 MMCX 性能投票、
MVS0/CVP 控制权切换及失败回退，并修复 VPU5 的 HFI 4xx 属性封包。
编码、解码都使用 MVS0；不把 CVP 当作第二个视频核心。
在此基础上增加 HFI 队列校验、通信/电源诊断和一次运行的实机测试脚本。
test8 让 CAPTURE 格式枚举及时跟随所选 codec，使 HEVC/VP9 能在会话创建前
暴露 P010，并修正 10-bit source-change 的格式计算顺序。test9 继续补齐原厂
SM8150 的 P010 256 字节 stride 约束、按流位深过滤实际 S/TRY_FMT，以及标准
HEVC Main/Main10 profile 控件；同时接入原厂 VIDSC0/VIDSC1 LLCC 系统缓存，
补齐 HFI 4xx FRAME_QP，并校正 H.264 Baseline/自动 level 默认参数。test10
进一步修正 all-layer 码率、VUI 和 level 封包，并让编码会话在 STREAMON 到完整
STREAMOFF 期间持续持有电源。编码属性和 buffer requirements 按原厂顺序只
设置/读取一次，HFI4 分开发送 VB2 actual 与原厂 host-min=4，并跳过 VPU5 不支持
的 MAX_BITRATE 属性。进入硬件前还有资源完整性检查及默认关闭的协议门，
避免桌面或 RDP 误触发尚未实机确认的编码路径。test11 根据实机
函数图定位并修复 Baseline Profile 与默认 8×8 Transform 冲突导致编码节点
`open()` 返回 `-EINVAL` 的问题。test12 根据实机 DMA 硬锁结果，保留固件原始
buffer minima，并在修改缓冲区计数和大小后重新查询最终需求，避免按过期快照
分配内部 DMA 缓冲区。test13 的 Stage 0--8 均通过，但 Stage 9 在首个 ETB 后
整机复位。test14 增加按 RC mode 选择 WORK_MODE、ETB 确定性日志并继续保留
0--9 共十个检查点；其 Stage 0 随后证实 FFmpeg 实际使用 VBR，mode 2 本来就与
原厂一致。test15 补上原厂把 FRAME_RC_ENABLE 独立映射到
VENC_DISABLE_RC_TIMESTAMP 的 HFI 属性；现有驱动已有该属性的正确 ID 与封包，
但此前从未发送。这个属性在固件首次消费 ETB 时间戳时生效，正对 test13 的复位
边界。默认仍停在不提交 DMA 的 stage 0。
本轮还按原厂补齐 Annex-B NAL 格式，跳过原厂不会发送的 IRIS1 NV12 stride
属性和零计数 LTRMODE。

同一补丁系列还限制 Raphael 面板的高频亮度更新：test14 恢复 LP 命令并将请求
合并为最多 4 Hz，直接 sysfs 压力测试已不再闪屏。GNOME 亮度/音量弹窗仍可触发
GPU IOVA fault，卸载 Venus 后同样复现，已确认是独立的 Adreno/合成器问题。

实机已确认 HEVC Main10 在内核中协商为 P010 并返回首帧；Debian FFmpeg 7.1
因缺少 V4L2 P010 映射仍会拒绝该帧。这个用户态兼容问题不通过伪报 NV12 在
内核中规避。

构建前会编译并运行实际补丁函数的宿主机故障注入和边界测试，再进行
完整 arm64 内核编译。自动检查不代表实机硬件编解码已经通过。
本轮修正范围见 [test15 说明](docs/venus-test15.md)；持续更新的原厂逐项核对、
排除项和实机结论见 [SM8150 编码核对记录](docs/venus-sm8150-encoder-audit.md)；
早期原厂、postmarketOS 对照依据保留在 [test4 说明](docs/venus-test4.md)。

源码仍来自 `snowf14k3/linux` 的 `raphael-7.1` 分支，构建时会应用本仓库
`patches/series` 中的十七个补丁（原厂时序、队列校验、诊断、VPU5 会话配置、
HFI 4xx 会话属性、两轮 10-bit 格式协商、SM8150 系统缓存/编码参数，以及
编码会话生命周期加固）。
补丁基于源码提交 `58f3df07833f2382fe2fbc28f996c4c85817c1f6`；
分支如果移动，构建会停止，避免补丁和基线悄悄错配。
因此源码提交号不变不代表补丁未生效；请同时核对内核版本、构建仓库提交
和补丁 SHA256。构建失败时不会继续打包。

## 使用方法

1. 打开仓库顶部的 **Actions**。
2. 在左侧选择 **Build Raphael Venus test kernel**。
3. 点击 **Run workflow**，再点击绿色的 **Run workflow**。
4. 等待任务变成绿色。首次编译通常需要一段时间。
5. 打开这次运行记录，在页面底部下载
   **raphael-venus-test-kernel**。

下载后先不要安装。回到当前 Codex 对话，我们再逐步备份和测试。

## 下载包内容

- `linux-image-xiaomi-raphael-venus-test.deb`：测试内核及模块。
- `sm8150-xiaomi-raphael.dtb`：包含 Venus 节点的设备树。
- `kernel.config`：本次实际使用的内核配置。
- `build-info.txt`：内核版本、源码提交、构建仓库提交及补丁清单 SHA256。
- `patches.sha256`：十七个补丁各自的 SHA256。
- `venus-test-suite.sh`：安装并启动 test15 后，一次运行的实机测试脚本；
  硬编码受协议门和分阶段检查点保护，默认不会运行；单独设置
  `VENUS_TEST_ENCODER=1` 也只做 stage 0 协议预检，不会推进硬件阶段。
- `TESTING.md`：测试范围、运行方式、限制与日志说明。
- `ENCODER-AUDIT.md`：随构建产物保存的原厂逐项核对、已排除方向和实机结论。
- `SHA256SUMS`：文件完整性校验值。

构建过程不会创建 Release，也不会修改内核源码仓库。
