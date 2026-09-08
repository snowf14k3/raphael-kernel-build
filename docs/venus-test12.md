# SM8150 / Raphael Venus test12

test12 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，并按 `patches/series`
依次应用十二个补丁。test11 已确认编码节点可以打开、HFI session 初始化和
属性协商成功；打开第二道 DMA 锁、进入内部缓冲区/LOAD/START 区段后设备硬锁。
上一启动周期的持久日志只留下 `TEST11_ENCODER_DMA_BEGIN` 标记，没有任何后续
内核消息，因此 test12 不再要求复现这次硬锁。

## 编码端修正

test10/test11 在第一次读取固件 buffer requirements 后，把固件返回的 INPUT、
OUTPUT `count_actual`、`count_min` 和 `count_min_host` 改写成 V4L2 队列值 4。
随后又向固件设置新的实际缓冲区数量，却继续使用设置前的旧需求表分配 scratch
和 persistent DMA 缓冲区。这既丢失了实机返回的 INPUT min=3、OUTPUT min=2，
也可能按过期的大小和数量向固件登记内部缓冲区。

test12 保留固件返回的最小值，不再修改需求表；先用第一次查询的真实最小值发送
BUFFER_COUNT_ACTUAL，再发送压缩输出大小，然后重新查询完整需求表。最终校验、
内部 DMA 分配和 LOAD_RESOURCES/START 只使用第二次、协商后的快照。该顺序与小米
Android 10 驱动的有效顺序一致，也恢复了上游 Venus 在改动缓冲区计数后重新查询
内部需求的安全条件。

`iris1_encoder` 和 `iris1_encoder_dma` 仍默认都是 `N`。自动测试脚本最多执行第一道
协议预检，并明确拒绝 `VENUS_TEST_ENCODER_DMA=1`；test12 尚未经过实机硬编码验证，
不能把代码审查结果当成硬件通过结论。

## 亮度闪屏修正

实机已经把故障缩小到面板亮度 DCS 写入：空闲不触发，10 Hz 的 sysfs 更新不触发，
约 50 Hz 的 sysfs 更新和 GNOME 亮度拖动都会产生 `dsi_err_worker: status=5`。
音量拖动产生的 GPU IOVA fault 已随 Mesa 26.1.2 消失，是另一条用户态问题。

原面板驱动每次亮度更新都会临时清除 `MIPI_DSI_MODE_LPM`，失败时还会提前返回，
使 mode flags 无法恢复。test12 将运行期亮度命令固定在面板使用的 DSI LP 模式，
用 delayed work 合并高频请求，并把实际发送频率限制为最多 10 Hz；最后一次请求值
不会丢失。关屏和驱动移除前会同步取消待处理任务，亮度读取返回已成功写入的缓存值，
不再额外发起 DCS read。

## 首轮实机边界

启动后先验证内核版本、H.264/HEVC 8-bit 解码、runtime PM 和亮度快速拖动。
编码两道开关都保持 `N`。即使设置 `VENUS_TEST_ENCODER=1`，随包脚本也只会运行
不提交 DMA 的协议预检；它不会打开第二道锁。

构建后内核版本必须为 `7.1.0-sm8150-venus-test12+`。
