# SM8150 / Raphael Venus test7

test7 针对 test6 的实机结果修复 HFI 4xx 会话启动。源码基线仍固定为
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用五个补丁。

## Test6 已确认的状态

- 固件加载、533 MHz 启动投票、设备节点注册和 runtime PM 已正常。
- 启动阶段的 idle timeout 已消失。
- H.264 解码在正式启动前失败，没有出现 `LOAD_RESOURCES`、`START` 或
  `EMPTY_BUFFER`，因此 0 帧输出不算硬解码成功。
- test5 的硬编码曾使整机复位；test6 没有再次测试编码。

## 本轮修正

- 为 HFI 4xx 封包器实现 `HFI_PROPERTY_PARAM_WORK_ROUTE`。test6 虽计算了
  route，但 4xx 路径此前返回 `-EINVAL`，属性没有发给 SM8150 固件。
- 按原厂 VPU5 行为，在编码工作模式 1 后发送 low-latency 属性；H.264
  普通编码仍使用工作模式 2，不会额外发送该属性。
- 将 HFI 4xx buffer requirements 容量补到原厂定义的 12 项（包括 recon），
  并在复制前检查上界，避免完整回复被错误拒绝。
- 将 test6 的 SM8150 专用负载错误处理限制在 IRIS1，避免改变其他 Venus
  平台原有行为。
- 诊断日志新增具体属性号，并统一使用 `venus-test7:` 前缀；若仍失败，
  可直接判断停止在哪个属性或 HFI 阶段。
- 测试脚本默认只运行解码及 runtime PM 检查。由于已有整机复位记录，
  编码必须显式设置 `VENUS_TEST_ENCODER=1` 才会执行。

## 原厂对照后的取舍

原厂普通编码 CAPTURE bitstream 缓冲也是直接通过 `SESSION_FTB` 提交，
并不预先调用静态 `SET_BUFFERS`；静态输出注册只用于解码 secondary output
和内部缓冲，因此 test7 不加入错误的编码 CAPTURE 预注册。原厂 recon 路径
只维护索引/统计，不分配 DMA 缓冲，也不作为缺失的编码资源移植。

SM8150 目前仍沿用驱动已有的 SDM845 带宽表。这不是精确的性能模型，
但 320x240 测试也会获得最低非零带宽投票，不能解释 test6 在
`LOAD_RESOURCES` 之前的确定性失败；没有可信 SM8150 静态表时不猜测替换。

## 验证边界

宿主机测试覆盖 HFI 4xx route 封包、low-latency 条件、12 项回复边界，以及
已有的电源故障注入和队列环绕测试。它不能替代实机验证。构建后内核版本
必须为 `7.1.0-sm8150-venus-test7+`；安装前继续保留可启动内核和 `/boot`
三个启动文件的备份。
