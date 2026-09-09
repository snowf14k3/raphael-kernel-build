# 0021 的 15 个 hunk：SM8150 encoder raw formats

> 补丁：`patches/0021-media-venus-expose-SM8150-encoder-raw-formats.patch`
> SHA256：`536f4a5754330e9957e5092cfa1694d1ad5204d27a25a9d1406ce4836c49bcc9`
> 统计：4 文件、15 个 hunk、+164/-29。原厂主依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`。

| # | 当前文件 / hunk | 迁移内容 | 原厂逐行依据 | 边界和验证 |
|---:|---|---|---|---|
| 001 | `core.h:127` | 增加内部 `VENUS_FMT_NV21`，使 V4L2 NV21 能映射到 HFI NV21 | `hfi_packetization.c:39-57`；`msm_vidc_common.c:945-961` | 只增加内部枚举，不新增私有 UAPI |
| 002 | `core.h:496` | 把 `enc_vendor_nv12` 注释扩展为所有 SM8150 raw-input layout | `msm_venc.c:1203-1294` | 仅修正文档语义，无行为变化 |
| 003 | `helpers.c:1469` | 输入约束接受所有已由 capability 验证的 encoder raw format | `msm_venc.c:1203-1294` | 未通过 `venus_helper_check_format()` 的格式仍拒绝 |
| 004 | `helpers.c:1509` | 根据 NV12/NV21/UBWC/TP10/P010 发送匹配 HFI format constraint；P010 发送双平面约束 | `hfi_packetization.c:39-57`；`msm_vidc.c:289-316` | HFI4 包长由既有可变长约束路径验证 |
| 005 | `helpers.c:2275` | encoder 额外保留原厂 NV21 capability，并让其它 raw format 走固件 input capability | `msm_vidc_common.c:945-961` | 不把 decoder output capability误作 encoder input capability |
| 006 | `helpers.h:41` | 导出 format capability 检查，供 encoder 枚举/选择共用 | 原厂格式表和 capability 检查在 `msm_venc.c` 中共用 | 纯内部 API |
| 007 | `venc.c:39` | module 参数说明从 NV12 单格式改为 vendor raw layout 总开关 | `msm_venc.c:1203-1294` | 安全 gate 不变，默认仍不开放真正编码 DMA |
| 008 | `venc.c:60` | 枚举 NV21、NV12 UBWC、TP10 UBWC、P010 标准 V4L2 fourcc | `msm_venc.c:1203-1294` | 只用内核已有标准 fourcc，不复制 Android 私有 ABI |
| 009 | `venc.c:125` | `find_format()` 对 raw output 同时要求固件/平台支持 | `msm_vidc_common.c:945-961` | 用户指定不支持格式时不会静默回退成 NV12 |
| 010 | `venc.c:147` | `ENUM_FMT` 跳过当前 instance 不支持的 raw format | `msm_venc.c:2596` 及其格式表过滤 | 枚举索引保持连续、稳定 |
| 011 | `venc.c:224` | 移植 NV12/NV21/P010/UBWC/TP10 的 stride、scanline、metadata 和 size 公式 | `msm_vidc.c:289-316`；`msm_vidc_common.c:6101-6126` | 宿主数值向量覆盖各格式、奇数尺寸和 4 KiB 对齐 |
| 012 | `venc.c:344` | TRY_FMT 使用所选 raw format 的真实 sizeimage | 同上 | 不再把所有格式按 linear NV12 估算 |
| 013 | `venc.c:417` | S_FMT 保存 raw format、bit depth、stride 和 input buffer size | `msm_vidc.c:289-316` | 8/10-bit 状态和实际 buffer layout 同步 |
| 014 | `venc.c:1274` | session 初始化把 input bit depth 与 raw format 一并带入 HFI | `hfi_packetization.c:39-57`；`vidc_hfi_api.h` raw-format 定义 | P010/TP10 不再按 8-bit 初始化 |
| 015 | `venc.c:1538` | preflight 接受所有已验证的原厂 raw input，不再硬编码仅 NV12 | `msm_venc.c:1203-1294` | 格式、size、fps 任一无效仍在触碰 DMA 前失败 |

## 宿主验证

- `tests/iris1-raw-layout.c` 直接编译抽取候选树中的 `venc_get_framesz()` 与
  `venc_get_stride()`，按原厂公式验证 NV12、NV21、NV12 UBWC、TP10 UBWC、P010。
- `scripts/test-iris1.py` 检查格式枚举稳定性、严格 selection、bit-depth 传播、HFI
  constraint 和 preflight gate。
- patch `git diff --check` 与 `checkpatch.pl --strict --no-tree` 均通过。
- 这些证据只证明代码和原厂公式一致；各 raw format 的真实 encoder ETB/FBD 仍属于后续
  Stage9 生命周期组的实机门槛。
