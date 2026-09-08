# SM8150 / Raphael Venus test14

test14 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用十六个补丁。它保留 test13 已由实机逐级通过的 Venus 启动、内部缓冲、
LOAD/START、FTB 和解码改动，增加按 RC mode 选择原厂工作模式的逻辑、ETB
确定性日志，并收紧面板亮度更新频率。

## Stage 9 的确定结论

test13 的 Stage 0--8 均可正常退出，runtime PM 回到 `suspended`。Stage 9 中，
scratch/persist、4 个 FTB、`LOAD_RESOURCES` 和 `START` 全部完成；首个
`OUTPUT/ETB` 为 128x96 NV12，`alloc=32768`、`filled=18432`、`offset=0`，
随后设备整机复位，未收到 ETB_DONE 或 FTB_DONE。

因此无需再重复 Stage 0--8。故障边界是固件开始处理首个编码输入帧，而不是
内部缓冲、输出缓冲或资源启动。

## 原厂工作模式核对及实机修正结论

重新按小米 SM8150 Android 10 原厂 `msm_vidc_decide_work_mode_ar50()` 核对后，
原厂编码器只对 VBR/MBR 系列使用 `WORK_MODE_2`；RC_OFF/CBR/CQ 使用
`WORK_MODE_1`，并紧接着发送 `VENC_LOW_LATENCY_MODE=1`。test14 因而让 IRIS1
按 RC mode 决策，其他 Venus SoC 保持原行为。

但实机 Stage 0 已纠正构建前的错误假设：FFmpeg 实际把会话设为
`rc_enable=1 bitrate_mode=0`，即 VBR；日志为
`mode=2 rc_enable=1 bitrate_mode=0 low_latency=0`，这正是原厂 VBR 结果。
所以 WORK_MODE 不是本次首 ETB 复位的根因，也不能因为这个补丁而直接运行
Stage 9。

test14 同时将 HFI4 encoder ETB 的保留末尾字清零，并在命令队列写入返回后打印
`venus-test14: queued ETB ... ret=...`。这不是把未知字段当成根因，而是消除
未初始化数据并让以后仍有故障时能区分“命令尚未入队”和“固件读取 DMA 后复位”；
它尚未由完整编码实机验证，不能宣称已经修复。

## 亮度更新

test13 证明 10 Hz 的 HS 亮度命令在纯 sysfs 压力测试中仍会产生
`dsi_err_worker: status=5`。test14 恢复 LP 命令传输，并把连续请求合并为最多
4 Hz（250 ms 一次）；仍保存并恢复完整 DSI mode flags。该改动不涉及 UFS。

## 实机原则

编码总开关仍默认 `N`，阶段默认 `0`。启动后先验证解码和亮度；编码只需先做
一次 Stage 0。该测试已完成并确认 VBR mode 2；现在不要在 test14 上运行 Stage 9。
需先完成原厂 VBR 属性、frame-RC/时间戳 RC 语义和首 ETB 硬件取数前置条件的
静态核对，再由下一版提供新的可区分改动。实际生成并可软件解码出一帧之前，仍
不能宣称硬编码可用。

构建后内核版本必须为 `7.1.0-sm8150-venus-test14+`。
