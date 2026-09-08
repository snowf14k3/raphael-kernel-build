# SM8150 / Raphael Venus test10

test10 继续使用固定源码基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用九个补丁。本轮不扩大解码功能范围，重点是把 SM8150/VPU5 编码
路径与小米 Android 10 原厂驱动重新逐项对齐，并在进入硬件 DMA 前失败关闭。

## 重新核对的编码路径

- 普通 H.264 编码使用 `WORK_ROUTE=2`、`WORK_MODE=2`，与原厂一致。
- scratch、scratch1、scratch2、persist、persist1 继续按固件返回的 buffer
  requirements 分配并登记。原厂 recon 结构仅保存统计信息，不是需要额外
  DMA 分配或 `SET_BUFFERS` 的静态缓冲。
- VPU5 普通目标码率使用 all-layer ID `0xff`；分层编码仍保留各层 ID。
- 不再向 HFI 4xx 发送其封包器明确不支持的 `CONFIG_VENC_MAX_BITRATE`；
  普通目标码率只发送原厂存在的 `TARGET_BITRATE`。
- H.264 默认 VUI timing 改成原厂的禁用状态；LTR 继续保持原厂的
  `MANUAL + trust=1` 封包，不臆测改变固件协议。
- 原厂的 H.264 `LEVEL_UNKNOWN`（零）不再被公共 HFI 封包代码悄悄改成
  Level 1，由固件根据分辨率、帧率和码率选择有效 level。
- 过短的固定 HFI 回复包会被拒绝，不再交给回复处理函数越界解释。
- `WORK_ROUTE`、`WORK_MODE`、core 选择和全部编码属性只设置一次，然后只
  获取一次完整 buffer-requirements 表。控件枚举和 `REQBUFS` 不再提前、
  重复查询固件。
- HFI 4xx 的 `BUFFER_COUNT_ACTUAL` 现在分别发送 VB2 实际数量和原厂定义的
  host 最小数量 4。与原厂一样，输入/输出只采用固件返回的 size/alignment，
  不让固件回复覆盖驱动的 IO 数量；固件表中的重复类型、越界数量、非二次幂
  对齐及矛盾的 `actual/min` 会在任何 DMA 分配前被拒绝。

## 电源与系统缓存修正

- 初次 `SYS_INIT` 后仍发送 VIDSC0/VIDSC1 的 `HFI_RESOURCE_SYSCACHE`。
- 每次从 Venus power collapse 恢复时，继续由电源路径重新激活两块 LLCC
  slice。原厂普通 power collapse 不清除 `sys_cache_res_set`，因此不重复发送
  system-cache resource；本轮也严格保持这一语义。
- SM8150 编码从双队列 STREAMON 成功开始，到 STOP、UNLOAD、SESSION_END
  和 STREAMOFF 全部完成为止，持续持有 runtime-PM 引用。解码路径不变。
- LOAD_RESOURCES 前检查三个电源域、三组时钟、MVS0/CVP hardware-control、
  MMCX OPP、VIDSC0/VIDSC1 和 core ownership；状态不完整时返回错误，不向
  编码硬件提交任务。

## 两级安全锁

SM8150 硬编码默认由两个独立内核参数锁住，以免桌面、RDP 或 FFmpeg 自动
选择编码器再次触发整机复位：

```text
/sys/module/venus_enc/parameters/iris1_encoder
/sys/module/venus_enc/parameters/iris1_encoder_dma
```

两者默认都是 `N`。第一个只允许 session、属性和 buffer requirements 协议
预检；即使它为 `Y`，驱动仍会在内部 DMA buffer 分配、SET_BUFFERS、
LOAD_RESOURCES、START 和 ETB/FTB 之前返回错误。第二个参数也显式写入 `Y`
后才可能提交真实编码任务。这不影响 H.264、HEVC Main 或 HEVC Main10 解码，
也不影响编码节点和控件枚举。

测试脚本默认两个阶段都不执行。设置 `VENUS_TEST_ENCODER=1` 只执行预期失败
的协议预检，并验证日志明确停在第二道锁；只有再同时设置
`VENUS_TEST_ENCODER_DMA=1` 才执行真实硬编码。脚本退出时按 DMA 锁、协议锁
的顺序恢复原值。

安全锁能够防止误触发，但不能在没有实机运行的情况下证明固件和硬件绝不会
复位。因此 test10 编译、安装后的第一次运行不要设置任何编码环境变量；
先确认启动、解码、LLCC 恢复和 runtime PM。后续也先只做协议预检，不直接
开启第二道 DMA 锁。

## 构建前检查

宿主机检查会直接抽取并编译补丁后的真实函数，覆盖电源开启/回滚、HFI 队列
边界、work route/mode、10-bit 格式，并额外静态确认：system-cache 初始登记、
HFI level/码率/LTR/VUI 封包、回复包最小长度、编码 PM 引用取得与释放
顺序、单次 buffer-requirements 快照、HFI4 host 最小缓冲数量，以及两级
安全锁和资源 preflight 都位于 DMA/LOAD_RESOURCES 之前。

构建后内核版本必须为 `7.1.0-sm8150-venus-test10+`。
