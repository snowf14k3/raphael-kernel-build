# SM8150 / Raphael Venus test13

test13 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，并按 `patches/series`
依次应用十四个补丁。它保留 test12 的 Venus 编码 buffer requirements 修正，
并根据 test12 的实机结果校正 Raphael 面板运行期亮度命令的传输模式。

## 编码端状态

test12 修正了编码缓冲区协商顺序：保留固件第一次返回的 INPUT/OUTPUT 最小值，
设置实际缓冲区数量和压缩输出大小后再次查询完整需求表，再以最终快照校验并分配
scratch、persistent 等内部 DMA 缓冲区。test13 原样保留该修正。

test12 的 `iris1_encoder_dma` 会把内部 DMA、`LOAD_RESOURCES`、`START` 和两类
用户缓冲一次全部放开，实机再次卡在 0 帧并重启；这个开关无法定位致死边界，
因此 test13 将它删除。新的 `iris1_encoder_stage` 默认为 `0`，在同一个内核中
提供十个位置：`0=纯协议`，`1/2/3=scratch0/1/2`，`4=persist0`，`5=全部内部
缓冲`，`6=LOAD_RESOURCES`，`7=START`，`8=只提交 CAPTURE/FTB`，`9=再提交
OUTPUT/ETB`。每次会话在进入下一危险操作前停止，stage 1--7 会主动完成已进入
阶段的清理。这样后续实机排查无需每移动一个边界就重新编译。自动测试脚本只
运行 `stage=0` 的协议预检，不会自行推进阶段；allocator 内也有独立的 stage 0
零分配保护。

stage 6 的回滚允许 SM8150 从 `LOAD_RESOURCES_DONE` 直接发送
`RELEASE_RESOURCES`，与原厂状态机一致。旧的公共包装函数只接受已经 STOP 的
会话，会在这里返回 `-EINVAL` 后带着已加载资源断电；test13 已只对 IRIS1 开放
这一合法转换，其他 SoC 的状态约束不变。

继续逐项比较小米 Android 10 原厂路径后，本轮还修正这些差异：

- SESSION_INIT 后先发送 H.264 格式表的 INPUT/OUTPUT 4/4，再进行后续配置；
  最终队列实际数更新时，`count_min_host` 仍使用固件返回的 minimum（当前固件
  为 INPUT=3、OUTPUT=2），不把 V4L2 队列下限 4/4 混入 HFI 字段。
- 对 H.264/H.265 显式选择原厂默认的 Annex-B start codes。
- 原厂普通 linear NV12 编码不发送 plane-actual-info；IRIS1 因此不再发送可能与
  128 字节对齐 bytesperline 冲突的请求宽度，其他 SoC 行为不变。
- 原厂只在用户请求非零 LTR 数量时设置 LTRMODE；IRIS1 默认 count=0 时不再发送
  多余的 MANUAL LTR 属性。
- 原厂内部 Venus DMA 缓冲至少按 4 KiB 对齐，并把对齐后的长度而不是固件原始
  requirement 填进 SET_BUFFERS。test13 对 IRIS1 encoder 恢复这一语义；同时
  在 HFI4 的 32-bit 地址字段发生截断前拒绝过高的内部缓冲和普通帧 IOVA。
- 为 stage 8/9 增加每个 FTB/ETB 的 tag、IOVA、alloc、filled、offset 日志，
  让首次真实帧 DMA 的最后成功提交点可以从串口或持久日志中直接判断。

内部缓冲日志会打印固件最终要求、每个 SET_BUFFERS 的开始/完成，以及固件没有
要求的类型。固件 test12 返回的 type 9 是 recon bookkeeping，不做静态 DMA；
type 5 persist1 若不存在则明确跳过。

原厂通用 SM8150 v1 表最高 480 MHz，但生产版 `sm8150-v2` 表是
240/338/365/444/533 MHz，和当前主线 Raphael OPP/clock provider 完全一致。
test13 保留 533 MHz，不把正确的 v2 频率误降为 v1。LOAD/START 前的 interconnect
投票位置也已与原厂逐项核对，没有另加无依据的总线补丁。

## 亮度闪屏修正

test12 的实机结果显示，最多 10 Hz 的高频请求合并有效：50 Hz sysfs 压力测试
不再产生 DSI 错误。但 GNOME 拖动亮度时仍出现
`dsi_err_worker: status=5`，且没有 GPU fault。状态 `0x5` 是 DSI timeout 与 FIFO
错误的组合，说明剩余问题位于显示链路而非 Mesa/GPU。

进一步审查发现 test12 同时把运行期亮度 DCS 命令改成了 LP 传输，而该面板原始
驱动明确在亮度读写前选择 HS。SM8150 DSI 主机源码也注明：视频模式运行期间，
LP 命令的低速率需要额外确认能否装入 BLLP。test13 因此保留 10 Hz 合并、缓存
读回和关屏同步取消，只把实际亮度传输恢复为 HS；传输前保存完整 mode flags，
传输后无条件恢复，错误路径也不会遗留临时模式。

## 首轮实机边界

启动后先验证内核版本、H.264/HEVC 8-bit 解码和 runtime PM。随后分别执行
50 Hz sysfs 亮度压力测试与 GNOME 亮度拖动测试，确认两者均没有新的
`dsi_err_worker`、GPU fault、hangcheck、underflow 或 timeout。

`iris1_encoder` 默认保持 `N`，`iris1_encoder_stage` 默认保持 `0`。需要协议预检
时只能开启第一道开关；自动脚本不运行阶段 1--9。阶段测试必须人工逐级进行，
上一级未安全退出时不得跳到下一级，尤其不要直接设为 `9` 重复 test12 的完整
DMA 路径。首次编码样本使用 128x96，避免 96 像素宽与 NV12 128 字节 stride
对齐产生无关变量。

构建后内核版本必须为 `7.1.0-sm8150-venus-test13+`。
