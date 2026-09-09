# 0024 的 12 个 hunk：SM8150 encoder DMA contract

> 补丁：`patches/0024-media-venus-harden-SM8150-encoder-DMA-contract.patch`
> SHA256：`6eff1ad2ec54a5ca03ce53a93567ff28498edd00dd1413f19a82e34732e837e4`
> 统计：2 文件、12 个 hunk、+127/-22。原厂主依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`。

| # | 当前文件 / hunk | 迁移或修正 | 原厂逐行依据 | 风险控制 |
|---:|---|---|---|---|
| 001 | `helpers.c:581` | ETB/FTB 拒绝零长度、64-bit 地址和跨越 32-bit HFI 边界的 DMA range | 原厂 `populate_frame_data()` 只把 32-bit IOVA 写入 HFI frame packet | 在固件接触地址前返回 `-ERANGE` |
| 002 | `helpers.c:627` | 验证 payload 的 `offset + filled_len <= alloc_len` | 原厂 frame-data 分别传 `alloc_len`、`filled_len`、`offset` | 防止下溢/越界 payload 进入 VPU5 |
| 003 | `helpers.c:649` | 编码外部缓冲按固件 requirement 复核 size/alignment | 原厂 S_FMT/REQBUFS 使用 `HAL_BUFFER_INPUT/OUTPUT` requirement | 非法 import 在 ETB/FTB 前失败 |
| 004 | `venc.c:1468` | 新增外部 requirement 的 type/size/count/alignment 完整验证 | 原厂 `msm_comm_try_get_bufreqs()` 返回并缓存整个 contract | 拒绝空、倒置、超范围和非 2 次幂对齐 |
| 005 | `venc.c:1501` | queue setup 保存 IRIS1 requirement 和 HFI version | 同上 | 只影响 IRIS1 encoder |
| 006 | `venc.c:1538` | 两个 V4L2 queue 在分配前向固件查询对应 contract | 原厂 `msm_venc_s_fmt()` 在格式确定后刷新 bufreq | 查询发生在 session 有电且持锁期间 |
| 007 | `venc.c:1561` | raw OUTPUT queue count 取 firmware actual/min/host 最大值 | 原厂 queue count 受 firmware requirement 驱动 | 仍保留至少 4 个 host buffer |
| 008 | `venc.c:1584` | compressed CAPTURE queue 使用 firmware 精确 size/count | 原厂直接把 `HAL_BUFFER_OUTPUT.buffer_size` 作为 sizeimage | 修正 Stage9 的 73728 host estimate 与 36864 firmware size 分歧 |
| 009 | `venc.c:1708` | STREAMON 再核对已分配 buffer size 与最终 requirement | 原厂在 start 前做 buffer count/size 校验 | requirement 在 count property 后改变也会被发现 |
| 010 | `venc.c:1958` | 删除旧 host-estimated `BUFFER_SIZE_ACTUAL` 发送 | 当时用于避免以 73728 覆盖 firmware 的 36864 requirement | **已由 0027 纠正**：原厂确实发送同 wire `0x20100c`，但值应为 firmware-negotiated capture size |
| 011 | `venc.c:2078` | FBD 越界时将 capture buffer 标记 ERROR | 原厂 FBD 分开返回 filled length 与 offset | 损坏返回不传播给 userspace |
| 012 | `venc.c:2096` | `bytesused` 不再错误叠加 `data_offset` | 原厂 V4L2 payload 语义为 encoded bytes，offset 单独保存 | FFmpeg/mmap 得到一致的 plane payload |

## Stage9 证据与本组结论

Test13/15 Stage9 的最后日志都停在首个 ETB；Test13 同时记录 firmware OUTPUT requirement
为 36,864 bytes，而实际 FTB allocation 是 73,728 bytes，raw ETB allocation 是 32,768
bytes。0018 已把 128x96 NV12 改为原厂 24,576-byte layout，并恢复 source queue 的
bidirectional DMA mapping；0024 再把 compressed allocation、property 顺序和 frame range
校验闭合。因此下一次实机不必重跑 Stage0--8，只需在其余审计组完成后做一次 Stage9。

> 后续纠正：对原厂 `msm_vidc.c::start_streaming()` 的逐行复核确认，它在最终
> `msm_comm_try_get_bufreqs()` 后发送 `HAL_PARAM_BUFFER_SIZE_MINIMUM`。该属性与当前
> `HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL` 具有相同 wire ID `0x20100c` 和相同 payload。
> 0027 已按原厂顺序补回，发送值使用 0024 收敛后的 36864 firmware contract。

## 验证结果

- 全部 IRIS1 宿主测试通过，包括 queue requirement、DMA range、payload 和 FBD 断言。
- `checkpatch.pl --strict --no-tree`：0 errors、0 warnings、0 checks。
- 0001--0024 从固定基线在独立 Git index 严格重放，tree 为
  `5525b4900c0a27d2e3596eeabd9357d88115c98f`。
- 重放后的 `helpers.c` blob 为 `cb0307e163360213ae19eda6ff0e438ba2705c4c`，`venc.c`
  blob 为 `89ec1ea48c65043266e55957099c7f7cccaaeb07`，与候选工作树逐字一致。
- 这仍是宿主证明；首 ETB 后是否得到 EBD/FBD 必须由最终合并构建的唯一一次 Stage9 验证。
