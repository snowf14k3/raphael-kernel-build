# 0023 的 5 个 hunk：SM8150 Main10 split output

> 补丁：`patches/0023-media-venus-support-SM8150-Main10-split-output.patch`
> SHA256：`fcc48ecc83cf09c534b5cdb4a2c95fd81b97fcfe9a56e8d06bc77224df1c02c`
> 统计：1 文件、5 个 hunk、+57/-10。原厂主依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`。

| # | 当前文件 / hunk | 迁移或修正 | 原厂逐行依据 | 边界和风险控制 |
|---:|---|---|---|---|
| 001 | `vdec.c:125` | 新增按 stream bit-depth 判断 capture 格式的 helper；IRIS1 Main10 同时允许 P010 与 NV12 | `msm_vdec.c:1147-1179`：10-bit secondary mode 把 OUTPUT DPB 设为 TP10 UBWC，并启用 OUTPUT2 | 只给 IRIS1 放宽 NV12；其它代际仍要求原生 10-bit capture format；QC08C 不被误当作 10-bit output |
| 002 | `vdec.c:189` | TRY/S/G_FMT 使用上述平台感知规则，不再全局拒绝 Main10+NV12 | 同上；原厂 output mode 与 bit-depth 分开表达 | ENUM_FMT 仍保持稳定；实际 format negotiation 才按已解析 bit-depth 限制 |
| 003 | `vdec.c:892` | 启动前强制核对 `OUTPUT=TP10_UBWC`、`OUTPUT2=NV12` 的精确 HFI split pair | `msm_vdec.c:1151-1216`：10-bit DPB=TP10、启用 OUTPUT2、关闭主 output、设置 OUTPUT2 size/count | 任一格式不符立即 `-EINVAL`，不以错误的 raw layout 继续 LOAD/START；原生 P010 路径不受影响 |
| 004 | `vdec.c:1599` | FBD 返回前校验 `data_offset + bytesused <= plane length` | `msm_vidc_common.c:2612-2674`：原厂直接传递 filled length/offset，并至少检查 offset overflow | 当前实现增加完整长度边界；越界 buffer 标记 ERROR 且 payload 清零，阻止损坏的 firmware 数据传播到用户态 |
| 005 | `vdec.c:1668` | source-change 时保留 IRIS1 客户已选的 NV12；其它平台或已选 P010 仍走原生 P010 | `msm_vdec.c:1147-1179` 的 split-output 状态机；`msm_vidc.c:280-316` 的 capture fourcc/stride/size 独立报告 | NV12 是 firmware 实际写出的 8-bit OUTPUT2，不是把 10-bit P010 数据伪报为 NV12；P010 仍可由支持它的客户端显式选择 |

## 为什么这不是 FFmpeg 专用绕过

容器在进入 V4L2 前已被 demux；内核处理的是 HEVC/VP9 elementary stream。问题发生在
Main10 source-change 后的 capture ABI：旧 FFmpeg 7.1 不认识 V4L2 P010，而小米 SM8150
固件本身具备 TP10 reference DPB 到 NV12 OUTPUT2 的硬件转换路径。因此 0023 恢复的是
目标 SoC 原厂能力，而不是根据应用名称伪造格式。支持 P010 的新客户端仍可获得原生 P010。

## 有意不照搬的代码

- 较新的 Iris/HFI6“10-bit stream 必须交付 native 10-bit capture”规则不适用于本目标的
  HFI4 split-output ABI，未覆盖 IRIS2/IRIS2.1 行为。
- 原厂 Android 私有 multi-stream control UAPI 没有暴露给桌面应用；当前驱动内部根据
  IRIS1、stream bit-depth 和已选择 capture fourcc 决定等价的 DPB/OPB pair。
- 没有改写 firmware 的 `bytesused`；只增加 VB2 plane 边界验证。用户此前的首帧日志
  `bytes=245760, size=294912` 本身未越界，不支持“filled length 是唯一根因”的判断。

## 验证结果

- `tests/iris1-formats.c` 直接编译候选树的真实 `venus_helper_get_out_fmts()` 和
  `vdec_capture_fmt_matches_stream()`，验证 IRIS1 Main10 的 TP10/NV12 pair、原生 P010、
  8/10-bit 拒绝路径和 320x240/1920x1080 P010 layout。
- `scripts/test-iris1.py` 检查 split pair、source-change format 保留以及 FBD payload 边界；
  全部 IRIS1 宿主测试通过。
- `checkpatch.pl --strict --no-tree`：0 errors、0 warnings、0 checks；`git diff --check`
  通过。
- `patches/series` 0001--0023 已从固定基线在独立 index 中严格重放，tree 为
  `c6d1a5378d74f4ca3ddb4858348a9f6802d69454`；重放后的 `vdec.c` blob
  `6fe3b31449111f7fe0cfb171c3af51d225461983` 与候选树逐字一致。
- 目标机仍需以真实 HEVC Main10 MKV 和 VP9 Profile2 样本验证非空帧、像素结果、退出后
  runtime PM；在此之前状态为“已实现，待实机”，不是“已实机通过”。
