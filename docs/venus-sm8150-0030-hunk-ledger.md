# 0030：SM8150 split-output buffer count 合同

> 补丁：`patches/0030-media-venus-match-SM8150-split-output-buffer-counts.patch`
> 目标：修复 Test16 VP8 在 source-change 后首批 DPB FTB 被固件以
> `HFI_ERR_SESSION_BAD_POINTER (0x1003)` 拒绝的问题。

## 1. Test16 实机证据

- H.264 320x240/720p/1080p/reopen 全部通过，HEVC Main8 30/30 通过；
- VP8 已成功完成 `SESSION_INIT`、属性设置、internal `SET_BUFFERS`、
  `LOAD_RESOURCES`、`START` 和 source-change；
- source-change 为 320x240/NV12，会话继续后固件对 FTB 连续返回
  event `0x1003`，FFmpeg 收到 `POLLERR/EIO`且输出 0 帧；
- 小米原厂 `vidc_hfi_helper.h` 定义 `0x1003` 为
  `HFI_ERR_SESSION_BAD_POINTER`。因此已排除 MKV demux、VP8 profile 和会话启动时序。

## 2. 原厂对应逻辑

| 原厂位置 | 原厂行为 | 迁移结论 |
|---|---|---|
| `msm_vidc_common.c:3683-3685` | driver-owned DPB 的 `buffer_count_actual/min_host/min` 统一为 firmware minimum | DPB port 不得写成 userspace capture queue 深度 |
| `msm_vidc_common.c:2007-2055` | 先把内部 DPB 按真实数量以 FTB 交给固件 | 内部分配数与 HFI actual 必须一致 |
| `msm_vdec.c:1146-1238` | secondary output 是独立的 client-facing pool | split-output 下 OUTPUT/OUTPUT2 不能共用一个 count |

原厂 `SET_BUFFERS` 和 FTB 的 wire 包与当前 Venus 已核对等价，本轮不改
packet layout、DMA address 宽度或调用顺序。

## 3. 当前偏差

`vdec_start_output()` 和 reconfigure 旧路径为 OUTPUT 与 OUTPUT2 都发送
`VB2_MAX_FRAME`。但 `venus_helper_alloc_dpb_bufs()` 只分配 firmware minimum：
Test16 VP8 为 6 个 DPB，client capture 约 20 个。固件看到的 actual count
与实际可访问的 DPB 池不一致，正好与首批 FTB 时的 BAD_POINTER 吻合。
H.264/HEVC 能容忍这个偏差，不能证明合同正确。

## 4. 0030 的两个 hunk 组

1. `vdec.c`
   - 按 `opb_buftype/dpb_buftype` 解析 OUTPUT/OUTPUT2 归属；
   - driver-owned DPB port 的 actual 使用 firmware minimum；
   - client-facing OPB port 的 actual 使用 `inst->num_output_bufs`；
   - initial start 和 source-change reconfigure 共用同一 helper，避免两处再次分叉。
2. `helpers.c`
   - IRIS1 decoder 的 INPUT/OUTPUT/OUTPUT2 `count_min_host` 使用固件返回的
     minimum，不再复制 actual；
   - 记录每个内部 DPB 的 type/tag/DMA/allocation，如果仍被拒绝，
     下一份实机日志就能直接对应具体 FTB，不需要再编译纯诊断内核。

## 5. 风险边界与验收

- 只影响 IRIS1 decoder 的 buffer-count property；encoder gate、DMA 和启动时序未改。
- H.264、HEVC Main8/Main10、VP8、VP9p0/p2、MPEG2 都必须重跑；不能用 VP8
  单一通过替代回归。
- 每项需要非空输出、精确帧数、软硬 hash 一致，退出后 runtime PM
  回到 `suspended`。
- 0030 是依据原厂语义得出的候选修复，在 Test17 实机通过前不标记为已修复。

## 6. 静态验证

- 对 0029 后完整候选树反向 `git apply --check`：通过；
- 0001--0030 从固定基线严格顺序重放：通过，tree
  `a6293044c84fe13c2c1868717c1957e4a694c64c`；
- `git diff --check`：通过；
- 差异范围：2 文件，60 insertions，6 deletions。
