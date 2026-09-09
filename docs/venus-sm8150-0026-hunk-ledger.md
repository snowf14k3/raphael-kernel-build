# 0026：SM8150 解码重配置、Main10、EOS/flush 与颜色元数据迁移账本

## 1. 固定比较对象

| 角色 | 固定对象 | 用途 |
| --- | --- | --- |
| 当前补丁基线 | `replay-0025` / tree `f4eb2dc02d3257a397151a665b835479a9719c21` | 0026 只允许包含相对 0025 的变化 |
| 当前实现 | `F:\linux\test15-analysis` | 0026 的工作树 |
| 小米 SM8150 原厂 | `F:\linux\vendor-sm8150-reference` / `192eca8550f95c2eec58a474793d1d93fc1b3b67` | HFI4 包布局、颜色字段、buffer done 与重配置语义 |
| 新 Iris 参考 | Linux commits listed below | 已修复的 flush、LAST、drain 与 10-bit V4L2 语义 |

本补丁不把 Android 私有 V4L2 ABI 搬进主线 Venus。原厂代码用于确定 SM8150
固件协议；用户可见行为采用标准 V4L2 mem2mem 语义。

## 2. 逐项参考提交

### Main10 和格式几何

- `7aa4969dd9af6ad4beef6614d99b3673f42359a5`：QC10C/P010 size。
- `3ea0343c09be74ae9eda9dff9c153750a6d9b961`：Gen2 10-bit 输出配置。
- `2f2f76d43314a8ae86aedae28f908a6a03e22521`：P010/QC10C padded width、height 和 stride。
- `20c3ef4c7cae76d4e15f31c812aa7761def2207a`：8/10-bit format filtering。
- `65c06d2edded3b1e1633bf75f0f7a26b609ed5ac`：允许 10-bit client output。

### 动态重配置、flush 和 drain

- `9bf58db157139abcd60e425e5718c8e6a917f9dc`：并发异步/同步 flush
  response 计数，避免错误地提前完成 streamoff。
- `1e27e9ffce59ac41cde71673d74eb368a533cdb2`：第一次 source-change 不发送
  flush。Venus 现有状态机已经满足，不另改。
- `f15cb8652b4f49e7cd217f572b29aa64c21e8970`：DRC 的首个空 capture
  buffer 带 `LAST`，并防止重复 LAST。
- `8172f57746d68e5c3c743f725435d75c5a4db1ac`：drain response 上直接完成
  LAST，不要求用户再排一个空 buffer。
- `478c4478610d307b710e69b858243bcd78f522de`：虚拟 drain ETB 的 EBD 不能
  按用户 buffer tag 处理。

## 3. 文件与 hunk 账本

### `drivers/media/platform/qcom/venus/vdec.c`

| 函数/区域 | 参考差异 | 0026 决策 |
| --- | --- | --- |
| `vdec_try_fmt_common()` | 新 Iris 对 P010 使用 width 128、height 32 对齐；QC10C 使用 width 192、height 16 对齐 | 原样采用；P010 stride 仍为 256-byte 对齐，QC10C stride 为 `width * 4 / 3` 后按 256 对齐 |
| `vdec_get_framesz*()` | 小米 `VENUS_BUFFER_SIZE(P010)` 还保留 4 KiB 尾部 | 已由 0023 实现；0026 不重复修改 |
| `vdec_update_colorimetry()` | HFI4 sequence-change 的 packed colour word 此前只解析、不暴露 | 按 Iris HFI Gen1 的 bit 7:0 matrix、15:8 transfer、23:16 primaries、bit24 description、bit25 full-range、bit29 signal-present 解包 |
| `vdec_hfi_color_primaries()` | 原厂值与 H.273 编号一致 | 映射 1/4/5/6/7/9/11 到 REC709/470M/470BG/SMPTE170M/SMPTE240M/BT2020/DCI-P3；未知值保持 DEFAULT |
| `vdec_hfi_transfer_char()` | 同上 | 映射 1/7/13/16 到 709/SMPTE240M/sRGB/PQ；未知值保持 DEFAULT |
| `vdec_hfi_matrix_coefficients()` | 同上 | 映射 1/5/6/7/9/10 到 709/XV601/601/SMPTE240M/BT2020/BT2020 constant luminance |
| `vdec_event_change()` | 原厂把 colour、crop、profile、level、bit depth 同 source-change 一起更新 | 颜色写入标准 V4L2 format 字段；crop、bit depth、profile/level 的既有解析保留 |
| `vdec_buf_done()` | DRC flush 可能返回没有 EOS flag 的空 capture buffer | `next_buf_last` 存在且处于 DRC 时，把第一个空 capture buffer 标为 LAST |
| `vdec_buf_done()` LAST 分支 | 固件也可能自己返回 LAST | 一旦看见固件 LAST，清除 `next_buf_last`，禁止 queued-buffer fallback 再发第二次 LAST/EOS |
| `vdec_vb2_buf_queue()` | 没有任何旧序列 FBD 可供标记时仍需完成 DRC | 保留现有 fallback：下一个 capture buffer 以零 payload + LAST 返回 |
| `vdec_decoder_cmd()` | Venus firmware quirk 使用虚拟 EOS 地址；新 Iris 会过滤对应 EBD | 用具名 `HFI_DUMMY_EOS_BUFFER_ADDR`，不改变 IRIS2 旧固件的 NULL 地址例外 |

### `drivers/media/platform/qcom/venus/hfi.c` 与 `core.h`

| 函数/字段 | 原问题 | 0026 决策 |
| --- | --- | --- |
| `flush_done` | generic `done` 同时服务 LOAD/START/STOP/GET_PROPERTY 等同步命令 | 为 flush 单独建 completion |
| `flush_pending` | DRC async flush A 后紧接 streamoff blocking flush B 时，A 的 response 可能被误认作 B | 每次成功排队前先计数；只有全部 response 到达才 complete blocking waiter |
| `flush_error` | 多个 outstanding flush 需要保留批次中的首个/任一错误 | 一个 pending batch 开始时清零；任一 response error 使等待者返回 `-EIO` |
| `hfi_session_flush()` | send failure 不能留下伪 pending | send 失败立即回退计数；blocking 调用只等待 dedicated completion |

计数在写 HFI command 前增加，因而即使固件 response 极快也不会下溢。只有第一条
pending flush 开始新批次时才清 error，避免第二条 flush 覆盖第一条的失败。

### `drivers/media/platform/qcom/venus/hfi_msgs.c`

| 函数 | 校验 | 0026 行为 |
| --- | --- | --- |
| `hfi_session_flush_done()` | response 数不得小于零 | 对无 pending 的 response 发一次 warning；正常 response 原子减计数，归零时完成 `flush_done`；绝不 complete generic `done` |
| `hfi_session_etb_done()` | 虚拟 EOS 没有对应 V4L2 source buffer | 在读 `input_tag` 并调用 `buf_done` 前按 `packet_buffer` 过滤，避免误取 tag 0 |
| `hfi_session_ftb_done()` | HFI4 encoder/decoder 固定包布局已在 0024 与小米 `vidc_hfi.h` 逐字段核对 | 保留 `filled_len`/`offset`/HFI flags；边界检查在 V4L2 callback 完成，不伪造 bytesused |

### `drivers/media/platform/qcom/venus/venc.c` 与 `hfi.h`

- encoder drain 也使用同一具名虚拟 EOS 地址。
- 只有 `hfi_session_process_buf()` 成功才把 encoder 状态切到 DRAIN；发送失败后仍可
  恢复或重试，避免软件状态领先固件状态。

## 4. 动态重配置状态检查

| 场景 | Venus 状态 | flush | LAST 路径 | 结论 |
| --- | --- | --- | --- | --- |
| 首次 sequence-change | INIT → CAPTURE_SETUP | 不发 | start-capture 会清 fallback | 与 `1e27e9ffce59` 一致 |
| 解码中分辨率变化 | DECODING/DRAIN → DRC | async OUTPUT flush | 优先使用首个空 FBD；若没有 FBD，再用下一 queued capture buffer | 不丢 LAST、不重复 LAST |
| capture streamoff during DRC | DRC → CAPTURE_SETUP | blocking OUTPUT flush | dedicated pending counter 等到 async + blocking 两个 response | 不提前释放 DPB |
| output streamoff | active state → SEEK | blocking ALL flush | 所有外部 buffer 由现有 stop path 归还 | generic HFI completion 不受 flush 干扰 |
| decoder drain | DECODING → DRAIN | synthetic EOS ETB | firmware EOS FBD 直接 LAST；synthetic EBD 被过滤 | 不错误完成 source index 0 |

## 5. Main10 输出检查

SM8150 继续支持两条真实路径，不能把 10-bit 数据冒充 NV12：

1. native P010：client capture 为 P010，256-byte stride、32-line scanline，保留
   小米 4 KiB 尾部；
2. compatibility NV12：固件以 TP10 UBWC 作为 DPB，以 NV12 OUTPUT2 写 client
   buffer。这是原厂 split-output 路径，client 得到的确实是 8-bit NV12。

QC10C 是压缩 10-bit client output，使用自己的 192-pixel width 和 16-line height
几何，不套用线性 P010 公式。

## 6. 明确不迁移的 Android 私有 ABI

- mastering display、content light、HDR10+、VPX colorspace、LTR、ROI/QP 等
  Android 私有 extradata/control 没有可直接对应的通用 V4L2 Venus ABI。
- 这些能力不能通过复制私有 control number 暗中暴露；应在未来有标准 V4L2
  metadata API 或明确用户空间消费者时单独实现。
- 本补丁仍保留标准 crop、colorspace、transfer、matrix、quantization、timestamp、
  key/P/B frame、EOS 和 data-corrupt 语义。

## 7. 自动验证门槛

`scripts/test-iris1.py` 对 0026 新增以下静态不变量：

- P010/QC10C exact padded geometry；
- HFI colour packed-field 与全部已支持映射；
- source-change 必须调用 colorimetry 更新；
- synthetic EOS EBD filter 必须早于任何 `buf_done`；
- flush 必须使用独立 completion + pending counter，flush callback 不得完成
  generic `done`；
- 固件 LAST 必须在发 EOS event 前清除 queued-buffer fallback；
- encoder 仅在 EOS ETB 成功后进入 DRAIN。

当前 Windows host suite 全部通过，包括 3968 组 HFI ring round-trip、Main10 split
output、P010 layout、encoder protocol/DMA、PM fault injection 与 panel teardown。

最终封装结果：

- 补丁：`0026-media-venus-fix-SM8150-Main10-reconfigure-and-drain.patch`；
- replay commit：`ee79619554a679be4f9bf2f7fd0a134353ee8f1f`；
- replay tree：`3437cf943ddd8dd869aae5d4cc03f623b151c07b`；
- SHA-256：`2313b082c0db59e5b05f9bb0c6ad6d4b07d1d5fde2de27fec3ad7655ff1bb470`；
- 变更范围：6 个 Venus 文件，171 insertions、11 deletions；
- `git diff --check`：通过；
- `checkpatch.pl --strict --no-tree`：0 error、0 warning、0 check；
- Windows host suite：全部通过。
