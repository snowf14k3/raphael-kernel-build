# IRIS1 encoder CF6：单次启动需求快照与输出 buffer 大小合同

## 结论边界

CF5 实机日志证明 H.264 profile/level property `0x1005` 已成功发送；最新外部日志停在第一次 `venc_verify_conf()` 同步 `GET_BUFFER_REQUIREMENTS` 返回并打印 7 行 requirement 之后。这个位置只是最后可见日志边界，不是已确认 PC，也不能据此把 parser、`complete()` 或第 7 行 requirement 判为根因。

CF6 修复两个已由 Android Q 固定提交 `192eca8550f95c2eec58a474793d1d93fc1b3b67` 和当前 Linux 代码共同确认的启动合同差异：

1. IRIS1 encoder 在真正启动阶段只保留一次完整 `GET_BUFFER_REQUIREMENTS`，并让同一 snapshot 同时验证两个 VB2 queue 和驱动内部 buffer。
2. 完整 snapshot 验证两侧 queue 后、注册内部 buffer 前，发送压缩输出的精确 CAPTURE extent。Android Q 将该 wire property 命名为 `BUFFER_SIZE_MINIMUM`；Venus 将同一个 `0x20100c`、同一个两个 `u32` 载荷命名为 `BUFFER_SIZE_ACTUAL`。

这两项是已确认的合同对齐，不代表已经确认了手机重启根因；实机仍未验证。

## 源码对照矩阵

| 项目 | Android Q | CF5 Linux | CF6 Linux |
| --- | --- | --- | --- |
| queue 建立阶段 | 两侧 `queue_setup` 会发送 buffer count actual | IRIS1 queue setup 只查询 requirement 和记录分配大小 | 保持不变 |
| 启动时最终 counts | 在进入 `start_streaming()` 前已发送 | `venc_verify_conf()` 两次 GET 后才发送 | 先从 VB2 收集两侧 count，再发送 |
| 启动 requirements | `msm_comm_try_get_bufreqs()` 一次完整查询并写入 `inst->buff_req` | `venc_verify_conf()` 两次按 queue 查询，内部 buffer 再查询一次 | 发送 counts 后只查询一次完整 snapshot |
| queue 验证 | 使用缓存的 `inst->buff_req` | 前两次查询各验证一个 queue，内部 snapshot 又验证一次 | 单个 post-count snapshot 验证两个 queue |
| output size property | GET 后发送 `HAL_PARAM_BUFFER_SIZE_MINIMUM` | encoder 不发送 | 用已有 `venus_helper_set_bufsize()` 发送 |
| wire property | `0x20100c` | 已定义为 `HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL` | 使用同一 ID |
| wire payload | `u32 buffer_type; u32 buffer_size` | `u32 type; u32 size` | 使用现有 packetizer，线包 28 bytes |
| internal buffers | 复用一次查询得到的 requirements | CF1 已让一次内部 snapshot 供所有 internal types 复用 | 保留该 snapshot，并作为唯一完整启动验证源 |
| RECON type 9 | bookkeeping，不单独分配 DMA | 不分配 RECON DMA | 不变 |

## 为什么没有采用旧 `out/venus-validation/encoder-contract-fix6` 草稿

服务器上已有一个未完成草稿：先在 `venc_verify_conf()` GET，再发送 size、验证 queue、发送 counts，随后从 `inst->hprop` 复用 snapshot。它正确识别了“一次 GET”和 `0x20100c`，但把下游 `queue_setup` 已提前发送 counts 的事实遗漏了，因此其 firmware 可见顺序并不等价于 Android Q。它还让内部路径在没有独立有效标记的情况下读取共享 `inst->hprop`。

本轮保留这个草稿文件作为审计材料，没有覆盖或删除。正式 0030/0031 使用局部 post-count snapshot，不引入跨阶段 cache 状态。

## 正式补丁

- `0030-media-venus-defer-iris1-encoder-buffer-validation.patch`：IRIS1 的 `venc_verify_conf()` 只做本地 VB2 count 收集；完整 requirements/count/extent 验证仍由现有内部 buffer 路径执行。非 IRIS1 路径不变。
- `0031-media-venus-set-iris1-encoder-output-buffer-size.patch`：完整 snapshot 验证后，通过已有 helper 发送 `HFI_BUFFER_OUTPUT` 和 `inst->output_buf_size`，然后才注册 internal buffers。

启动顺序变为：

```text
venc_set_properties
→ collect OUTPUT/CAPTURE VB2 counts locally
→ BUFFER_COUNT_ACTUAL
→ one complete GET_BUFFER_REQUIREMENTS
→ validate snapshot + both queues
→ property 0x20100c, HFI_BUFFER_OUTPUT, exact CAPTURE size
→ register scratch/persist internal buffers from the same snapshot
→ external buffer registration
→ clocks/ICC
→ LOAD_RESOURCES
→ START
```

## 静态和编译验证

- 固定基线 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5` 干净重放 31 个补丁通过，并与 staged CF6 formal source 逐文件一致。
- 0030、0031 `checkpatch.pl --strict` 均为 0 errors、0 warnings、0 checks。
- 主机合同测试 282 条断言通过，覆盖 `0x20100c` 的 28-byte wire packet、count 收集不触发 firmware GET、单次 post-count snapshot、两侧 extent/count 验证、duplicate type 拒绝、size property 错误传播、内部分配失败清理和 type 9 RECON 不分配。
- 使用手机完整内核 `7.1.0-sm8150-ga0ca2cbb4b3d` 对应 headers/config/generated files/`Module.symvers`，执行 `ARCH=arm64 LLVM=-22 KCFLAGS=-Werror` 的 formal 与 BROAD1 diagnostic 局部模块编译通过；构建前后输入哈希一致。
- diagnostic core/encoder 均为 AArch64，vermagic 精确匹配；依赖集合和导出符号集合与 formal 模块一致。
- CF6 已在 boot `844f7e9c-cd74-40a2-848b-6724a61e92ec` 实机执行并再次重启。它在第二次 `venc_set_properties()` 的 `0x200501e` 线包完成 TX_POST 后停止输出，尚未进入 `COLLECT_COUNTS`，因此 0030/0031 实际没有执行；这次结果不能验证或否定 CF6 功能修复。
- 同一个 session 在 REQBUFS 阶段已完整发送第一遍 property suite，并完成两次 244-byte、7-row requirements 应答。启动阶段随后重新发送同一 suite；下游 start 路径不会这样整体重放。`0x200501e` 是 H.264 VUI timing，Android Q 默认关闭，而 Linux 当前固定发送 enable=1；这是后续需要一起审查的合同差异，但最后一行仍不是根因证明。

## 持久审计

`tests/venus/contract-fix6/audit/` 保存固定 commit、下游 `git show`、Linux/Android symbol search、wire struct、启动顺序、snapshot/cache、property completion、modern Iris 参考、patch 哈希、构建日志、ABI 检查和 host test 结果。`SHA256SUMS` 用于检测审计文件变化。
