# Raphael IRIS1 session-init 超时：策略修正候选与单次模块测试

## 实机证据与结论边界

运行内核 `7.1.0-sm8150-ga0ca2cbb4b3d`，发布源码 `a0ca2cbb4b3d783c864efd14d52940867f683cc6`，其父提交固定为 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`。

用户先以 `power/control=on` 成功重新绑定：video0 为 encoder，video1 为 decoder。640x480 H.264 软件样片的硬解在 OUTPUT REQBUFS 超时。随后用户采集的关键线程栈为：

```
hfi_session_init+0x1e8/0x20c
venus_helper_session_init+0x4c/0xc8
vdec_queue_setup+0xc4/0x4ac
vb2_core_reqbufs+0x344/0x53c
vb2_reqbufs+0xe4/0xf4
```

Venus IRQ 209（GIC SPI 174 对应硬件 INTID 206）在测试前后均为 5。此次没有新的 kernel error。由发布 `hfi.c:191-225` 可把等待点定位为 session-init 应答，而不是 buffer requirements 查询、实际帧 DMA 或帧解码。IRQ 未增加只说明没有新中断被 Linux 记录；不能据此单独证明固件完全没运行或消息队列为空。

## 确认的策略不一致，尚未确认是此次挂起根因

发布 `pm_helpers.c:1072-1122` 的 `core_power_iris1()` 明确通过 `dev_pm_genpd_set_hwmode(..., false)` 保持 video/CVP 为软件控制；但 `hfi_venus.c:957-986` 仍以全局默认 true 发送 `HFI_PROPERTY_SYS_CODEC_POWER_PLANE_CTRL`。

Android Q `192eca8550f95c2eec58a474793d1d93fc1b3b67` 的 `venus_hfi.c:2476-2481` 和 `4448-4462` 使用同一个 `msm_vidc_fw_low_power_mode` 决定固件 property 与 regulator hardware handoff，支持让两端保持一致。

`0021` 只让 IRIS1 发送 disable，保留其他 VPU 的原选择、报文格式、PC_PREP、WFI/idle 和 SCM 挂起握手。不改 DMA、队列尺寸、IRQ 地址，不延长 timeout，不吞错误。可能增加功耗；实际是否能解除此次 session-init 阻塞仍待测试。

用户态的 `power/control=on` 只改变 Linux runtime PM 策略，不会代替上述 HFI property。这也是不能把此前的临时 `on` 绕过当成完整电源修复的原因。

## 独立的最小诊断

`0022` 在 IRIS1 session-init 超时后，在 HFI transport lock 内打印 powered/suspended 状态；仅在主机标记为上电时读取 ctrl、CPU、IRQ status/mask 四个寄存器，并打印 CMD/MSG 两个队列的索引和请求位。没有后台轮询，不写寄存器，不转储码流/地址/整队列，保留原错误码。

固件仍可并发更新共享队列，日志不是原子快照。诊断还会限长打印此前无法解析的 IRIS1 固件版本串，不修改版本验证或 completion。此诊断可在故障定位后单独移除。

## 服务器验证

- 完整 HFI packetizer 与 codec/power policy 函数 223 项 host 断言通过；原发布源码作为负对照会失败于 IRIS1 property 与软件模式不匹配。它证明策略变化，不证明固件接受或硬解成功。
- IRQ 原有 1069 项回归保持通过；原有 PM/reset 回归独立执行。
- `0021/0022` 通过 checkpatch；原有20补丁、配置和构建脚本未修改。
- 从已发布 ARM64 headers 包取出 auto.conf、generated headers、Module.symvers；配置规范化后与发布 kernel.config 一致。使用 LLVM22 的 Kbuild external-module 路径在 AMD64 上仅编译 Venus 模块，没有运行 bindeb-pkg，没有强改 vermagic。
- 新 core 模块为 AArch64，vermagic/depends 与已发布模块一致，59个导出符号名不变，公开结构/接口未改。手机运行验证尚未执行。
- 测试产物额外在 core.c 加 `MODULE_VERSION("iris1-swpc-sessiondiag-1")`，仅用于防止测试叠加和确认加载身份，不进入正式补丁序列。

## 手机单次测试

专用包不是内核升级包，不应交给 update-kernel.sh，也不发布到供升级脚本自动选择的 Pre-release 列表。

包内 `test-once.sh` 源于 `tests/venus/test-session-module-once.sh`。它严格检查内核/架构、模块版本字符串、原 core 文件哈希、无占用设备和现有 power/control=on；然后正常卸载 Venus 三个模块，临时 insmod 测试 core，重新加载磁盘上的 decoder/encoder。不会使用强制卸载/强制加载，不写 /boot、/lib/modules 或开机规则。

只复用 `/tmp/venus-dec.M9IIJu/input.mp4` 解一帧到临时 NV12 文件，记录 FFmpeg 输出、中断计数和新诊断。正常结束或命令报错后尝试恢复磁盘上的原模块。若模块仍被占用而不能卸载，脚本停止且明确报告，不强制处理；此时重启会回到磁盘上的原版。

这仍然是会重新初始化固件并提交短视频任务的实验，可能超时、卡住或触发设备重启；内核不可中断等待和系统崩溃不能靠 shell trap 保证回退。保留已有回退备份，只执行一次并反馈日志，不进行编码或并发压力测试。
