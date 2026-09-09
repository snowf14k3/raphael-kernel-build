# 0020 的 4 个 hunk：SM8150 时钟与 HQ/LP 策略

> 补丁：`patches/0020-media-venus-port-SM8150-clock-and-HQ-policy.patch`。
> SHA256：`0718903d4a78b87552115d342575b47fa49cfc3cbcf53fa9080eee95d5275d56`。
> 统计：3 文件、4 个 hunk、+75/-0。原厂主依据固定为
> `MiCode/Xiaomi_Kernel_OpenSource@192eca8550f95c2eec58a474793d1d93fc1b3b67`，
> `msm_vidc_platform.c:358--433`、`msm_vidc_clocks.c:632--739,1444--1490`。

| # | 文件/候选行 | 变化 | 原厂逐行依据 | 边界与回归面 | 验证 |
|---:|---|---|---|---|---|
| 001 | `core.c:984` | 给 `sm8150_res` 填入 8160 MB/帧、244800 MB/s、760000 fw cycles、166667 fw-VPP cycles | `sm8150_common_data` 的四个精确常量 | 只设置 SM8150；其他资源表为 0，保持原行为 | 静态常量校验 |
| 002 | `core.h:95` | 在主线资源对象增加四个被实际执行路径消费的平台字段 | 原厂 `msm_vidc_resources` + common-data parser | 不复制 vendor parser/DTS 私有键，只保存等价语义 | 编译型宿主测试 |
| 003 | `pm_helpers.c:999` | 在发送 PERF_MODE 前按 HQ 上限强制 LP，并让 CQ 最后覆盖为 HQ | 原厂 `msm_vidc_power_save_mode_enable():1460--1476` | 阈值为 0 的其他 SoC 不触发；CQ 次序严格与原厂一致 | source invariant |
| 004 | `pm_helpers.c:1844` | IRIS1 使用原厂通用频率模型：fw/fwvpp、route、bitrate/input VSP、SW overhead、encode 1.014 与 decode 1.059 pipeline overhead | 原厂 `msm_vidc_calc_freq():632--721` | 非 IRIS1 继续使用既有公式；当前无 vendor 私有 Q16 operating-rate ABI，按正常 operating-rate=fps 路径计算 | 7 个精确向量 |

## 精确行为核对

- encoder：`VPP = MB/s * (HQ 或 LP cycles) / route`；VSP 加 `bitrate * 10/5`；
  software overhead 为 `VSP * fw_vpp / VPP`；双 route 再加 1.4%。
- decoder：VSP 加 `fps * max_input_bytes * 8 * 10/5`；双 route VPP 再加
  `VPP/17`。
- 两类路径都把 `max(VPP/20, fps*166667)` 纳入 VPP，并最终取
  `max(VPP,VSP,fps*760000)`。
- 当前主线没有 Qualcomm `OPERATING_RATE` 私有 Q16 控件，不能凭空新增私有 ABI。
  0020 精确覆盖标准 V4L2 正常播放/编码的 `operating_rate == configured fps` 分支；
  额外 operating-rate 需求单列为 ABI 设计项。

## 验证结果

- `scripts/test-iris1.py` 直接抽取候选树中的 `calculate_inst_freq()` 编译运行；
- 7 个数值向量覆盖 H.264 小帧 decode/encode、1080p decode、1080p HQ/LP encode、
  route-1 encode、VP9 4K60 decode，另验证非 START 会话返回 0；
- `checkpatch.pl --strict --no-tree`：0 errors、0 warnings、0 checks；
- patch `git diff --check` 通过；最终仍需 arm64 全量构建和实机 OPP/首 ETB 证据。
