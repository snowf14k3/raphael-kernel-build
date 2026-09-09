# 0027 的 17 个 hunk：SM8150 encoder 完整启动契约

> 补丁：`patches/0027-media-venus-complete-SM8150-encoder-startup-contract.patch`
> SHA256：`6f1d11ecee2fe55ee4def18a132a947ea8c36497e98a13d2adec7178f1b094bc`
> Commit：`f4fd6db203f92b630db43016d2135f3cb61f0e8b`
> Tree：`88598d640bccf82678aa39ed072855a5fed96787`
> 统计：3 文件、17 个 hunk、+29/-171。原厂依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`。

| # | 当前文件 / hunk | 迁移或修正 | 原厂逐行依据 | 风险控制 |
|---:|---|---|---|---|
| 001 | `core.h:403` | 删除 Stage0--9 enum | 原厂没有阶段式产品状态 | 已由 Test13 Stage0--8 分段证明的路径合并成唯一启动链 |
| 002 | `core.h:488` | 删除三个实验字段的文档 | 同上 | 防止文档继续暗示可选协议语义 |
| 003 | `core.h:574` | 删除 `enc_test_stage`、可选 NV12 和可选 DMA 字段 | 原厂尺寸和映射是平台契约，不是实例偏好 | 只影响 IRIS1 encoder |
| 004 | `helpers.c:414` | 内部缓冲总是按 HFI4 顺序完整分配 | 原厂顺序为 scratch0/1/2、persist0/1；recon 仅索引 | Test13 Stage1--5 已逐项 SET/RELEASE 通过 |
| 005 | `helpers.c:2046` | 删除 queued-buffer 的 Stage8/9 分流 | 原厂 START 后提交全部预排 FTB/ETB | 仍受总 `iris1_encoder` gate 控制 |
| 006 | `helpers.c:2168` | 删除 staged encoder 局部状态 | 原厂没有人工 checkpoint | 简化实际失败路径 |
| 007 | `helpers.c:2178` | 删除内部缓冲前缀停止点 | 原厂完成内部缓冲后继续 LOAD | 内部分配失败仍立即回滚 |
| 008 | `helpers.c:2192` | 删除 LOAD/START 人工停止点，并保留实际 unwind | 原厂完整执行 LOAD、START | unload/unregister/free 的每个失败现在都独立报错 |
| 009 | `helpers.c:2232` | M2M device-run 无条件提交 capture 后 input | 原厂 `msm_comm_qbufs()` 在 START 后提交两个队列 | 保持 FTB 先于 ETB，避免固件没有输出缓冲 |
| 010 | `venc.c:32` | 删除 stage、可选 vendor-size、可选 bidirectional 三组 module 参数 | 原厂这些不是运行时可选项 | 保留唯一总 gate，默认 N，便于首次实机验证 |
| 011 | `venc.c:213` | IRIS1 无条件使用原厂 raw layout | 原厂 `VENUS_BUFFER_SIZE`/UBWC/TP10 宏 | 128x96 NV12 从 32768 收敛为 24576 |
| 012 | `venc.c:1559` | raw-size 日志不再打印已删除的实验值 | 同上 | 行为不变 |
| 013 | `venc.c:1804` | 删除 `venc_iris1_stage_preflight()` | 原厂没有 `-EACCES` checkpoint | 总 gate 关闭时仍在 session init 前返回 `-EOPNOTSUPP` |
| 014 | `venc.c:1915` | 纠正旧注释：最终 requirements 后仍需 output-size property | 原厂 `start_streaming()` 明确发送 `HAL_PARAM_BUFFER_SIZE_MINIMUM` | 不再沿用 0024 的错误排除结论 |
| 015 | `venc.c:1922` | 发送 HFI wire `0x20100c`、type OUTPUT、size 为 firmware-negotiated capture size | 原厂 `msm_comm_try_get_bufreqs()` 后以 capture `plane_sizes[0]` 发送 minimum | 当前上游名字虽为 `BUFFER_SIZE_ACTUAL`，wire ID 与 payload 完全相同；128x96 发送 36864 而非旧 73728 |
| 016 | `venc.c:2124` | IRIS1 source queue 无条件 `bidirectional=1` | 原厂非安全 context bank 统一双向映射并显式同步 | 0018/0024 已有 32-bit range、payload、alignment 验证 |
| 017 | `venc.c:2184` | `venc_open()` 不再快照两个实验参数 | 原厂策略固定于平台 | 新旧 instance 行为不再因运行时参数变化而分叉 |

## 专门复核后未迁移的项目

- 原厂 `msm_venc_inst_init()` 把 CAPTURE 标成 static，而当前 HFI4 helper 把外部缓冲
  作为 dynamic。继续追踪全部 `session_set_buffers()` 调用后，原厂 encoder 并不会把
  userspace bitstream CAPTURE DMA 预先逐个 `SET_BUFFERS`；该 static 标记主要属于
  Android buffer-framework bookkeeping。当前 FTB 直接携带 capture IOVA，与 HFI4
  packet 格式一致，因此没有凭字段名盲加一套重复注册。
- 原厂 recon requirement 只建立 index/statistics 列表，不分配或登记 type 9 DMA；
  当前扩展 EBD 的 recon/CR/CF 数组是等价用途。
- secure context、CVP/TME/HEIC 私有 ABI 不属于当前通用非安全 V4L2 目标。

## 验证

- `test-iris1.py` 全部宿主测试通过；新增断言保证 stage 痕迹清零、IRIS1 layout/DMA
  不可关闭、`0x20100c` 位于最终 requirements 与 verify/LOAD 之间。
- `venus-test-suite.sh --self-test`、`bash -n`、`--plan` 全部通过；显式
  `VENUS_TEST_ENCODER=1` 时先测 1 帧 H.264，再测 30 帧 H.264/HEVC/VP8，每项要求
  非空码流和软件解码帧数正确。
- `checkpatch.pl --strict --no-tree`：0 errors、0 warnings、0 checks。
- 从 `replay-0026` 独立 index 严格应用 0027 后得到 tree
  `88598d640bccf82678aa39ed072855a5fed96787`，与候选 Venus 工作树一致。
- 宿主验证不等于实机通过。总 gate 默认 N；Test16 只有在用户明确启用后才提交首 ETB。
