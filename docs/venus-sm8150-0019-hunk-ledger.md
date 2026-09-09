# 0019 的 11 个 hunk 逐项审阅台账

> 补丁：`patches/0019-media-venus-port-SM8150-dynamic-bandwidth-governor.patch`。
> SHA256：`1ba6547133836f1822003fa08b99c9c39f14525d8f4c49d75c4b6903024ccdcd`。
> 统计：5 文件、11 个 hunk、+515/-42。本文逐 hunk 记录原厂依据、当前架构映射、
> 风险边界和验证状态。所有“通过”均为宿主/静态验证；真实 ICC、长序列、并发和
> Stage9 仍必须在 SM8150 实机上验证。

## 迁移基准

- 原厂公式：`drivers/media/platform/msm/vidc/governors/msm_vidc_dyn_gov.c`。
- 原厂定点语义：`drivers/media/platform/msm/vidc/governors/fixedpoint.h`。
- 原厂动态统计、前 16 帧 Turbo 和总线调用：
  `drivers/media/platform/msm/vidc/msm_vidc_clocks.c`。
- 原厂 SM8150 总线拓扑：`arch/arm64/boot/dts/qcom/sm8150-vidc.dtsi`，普通 codec 的
  动态路径是 `VideoP0 -> LLCC` 与 `LLCC -> EBI`；`msm_vidc_ar50_dyn_gov.c` 不是
  SM8150 量产 DTS 选用的 governor，只保留作非目标平台旁证。
- 当前主线式 DT 只给 Venus 一个端到端 `video-mem` ICC path，因此 0019 不能复制
  `msm-bus` client，而是把原厂 DDR/LLCC 两个动态结果取最大值后投给该端到端路径。

## 逐 hunk 台账

| # | 文件/候选行 | 变化 | 原厂依据与等价关系 | 风险边界 | 状态 |
|---:|---|---|---|---|---|
| 001 | `core.h:493` | 把 0018 的 encoder-only EBD/CR/CF 字段文档改成 IRIS1/VPU5 通用统计，并补 recon 数组/有效位图说明 | 原厂 `msm_vidc_clocks.c:update_recon_stats()` 对 decoder 与 encoder 都维护动态统计 | 只改 kerneldoc，不改 ABI/wire | 已审 |
| 002 | `core.h:579` | 实例字段改名为 `iris1_*`，增加每个 recon slot 的 CR/CF 与有效位图 | 原厂 `recon_stats[]` + `fill_dynamic_stats()`；当前按 `VIDEO_MAX_FRAME` 保存，不复制 vendor 对象布局 | per-instance；不新增 UAPI；位图只在 EBD 发布后可见 | 宿主编译/源不变量通过 |
| 003 | `hfi_msgs.c:547` | 每个 IRIS1 EBD 预计算新的返回输入计数；扩展尾部解析不再错误限制为 encoder | 原厂 common EBD handler 对两类 session 更新统计并清除输入频率项 | 非 IRIS1 完全不变；短 common EBD 仍可解析 | packet 长度不变量通过 |
| 004 | `hfi_msgs.c:562` | 删除旧 encoder 局部计数声明 | 配合 hunk 003 的通用计数作用域 | 无行为独立变化 | 已审 |
| 005 | `hfi_msgs.c:585` | 使用 7 个精确 bucket 权重算 Q16 CR、按 macroblock frame size 算 CF；写 latest 值和 recon-indexed 值，以 release-store 发布有效位 | 原厂 `update_recon_stats()` 与 `fill_dynamic_stats()`；权重为 32/64/96/128/160/192/256 | 只有 80/84-byte VPU5 tail 才读取；frame index 越界不写数组；common prefix 不抬高最小包长 | 结构/公式测试通过 |
| 006 | `hfi_msgs.c:607` | 日志加入 session type；所有 IRIS1 EBD 更新计数；按 input tag 清零已返回 payload | 原厂 `msm_vidc_clear_freq_entry()` 在 EBD 后清除相应输入、递增 `buffer_counter` | tag 越界不清数组；先完成统计再交还 VB2 buffer | lifecycle/source invariant 通过 |
| 007 | `pm_helpers.c:8` | 引入 `linux/math64.h` | Q16 乘除使用内核 64-bit division helper | 无运行策略变化 | 编译测试通过 |
| 008 | `pm_helpers.c:226` | 完整移植 SM8150 通用 DDR/LLCC governor：Q16 运算、LUT、format/bit-depth、动态 CR/CF 汇总、decoder/encoder 公式、多实例求和、前 16 EBD Turbo、单 ICC 映射和饱和 | `msm_vidc_dyn_gov.c`、`fixedpoint.h`、`msm_vidc_clocks.c` 逐表达式映射；LUT、1.03 overhead、system-cache 分流、P010 2 Bpp、10-bit 256/192、MESE 运算顺序保持一致 | 仅 `IS_IRIS1()` 走新模型；其他 SoC 保留旧 table；没有在飞 input 时不投动态负载；任一前 16 EBD session 强制 6,533,000；单 path 取 `max(ddr,llcc)`，总和饱和 | 8 个精确数值向量通过；实机待测 |
| 009 | `pm_helpers.c:1894` | IRIS1 前 16 帧最大时钟判定从输出序列号改为 EBD 返回输入计数 | 原厂 `clk_data.buffer_counter` 只在 EBD/输入完成清理时递增；不是 FBD 输出序列 | 只改 IRIS1；第 17 个 EBD 后恢复计算频率 | 源不变量通过；实机待测 |
| 010 | `vdec.c:1254` | decoder 每次新 stream 清空 EBD/recon/CR/CF/位图/诊断计数 | 原厂统计属于 session generation，不跨 STREAMON | 清零发生在提交输入前；不影响格式/队列 | lifecycle 测试通过 |
| 011 | `venc.c:1527` | encoder stream reset 同步改为通用字段并清空 recon 数组/有效位图 | 同 hunk 010；防止前一会话 CR/CF 污染新带宽票 | 保留现有安全 gate/stage；不会默认启动编码 | lifecycle 测试通过 |

## 精确数值向量

`tests/iris1-bandwidth.c` 直接编译从候选 `pm_helpers.c` 抽出的公式区间，而不是复制一套
独立实现。当前固定的原厂等价值如下：

| 会话 | 条件 | DDR / LLCC（kB/s） |
|---|---|---:|
| H.264 decode | 1280x720 baseline/fallback stats | 2,000 / 2,000 |
| H.264 decode | 1920x1080、system cache | 343,000 / 421,000 |
| HEVC Main10 decode | 1920x1080、P010、system cache | 468,000 / 501,000 |
| VP9 Profile2 decode | 4K60、10-bit、system cache | 3,643,000 / 4,208,000 |
| H.264 encode | 1280x720 baseline | 5,000 / 5,000 |
| H.264 encode | 1920x1080、system cache | 409,000 / 422,000 |
| HEVC Main10 encode | 4K60、linear P010 | 5,825,000 / 6,021,000 |
| H.264 encode | UBWC input + downscale | 608,000 / 622,000 |

## 重放与质量门

- 在固定基线 index 上先严格重放 001--0018，再应用 0019；`git apply --check` 和
  `git diff --cached --check` 均通过。
- 重放后 0019 所改五个 blob 与 `F:\linux\test15-analysis` 工作树逐个 hash 一致。
- `checkpatch.pl --strict`：0 errors、0 warnings；21 个 continuation alignment/line-break
  CHECK 属于公式为保持原厂运算分组而保留的非阻断格式提示，不涉及 wire 或算术语义。
- `scripts/test-iris1.py F:\linux\test15-analysis --cc F:\gcc\mingw64\bin\clang.exe`
  全部通过，包含 8 个动态带宽精确向量以及既有 startup/PM/HFI/P010/encoder/panel 回归。

## 实机边界

0019 不是“已经稳定”的证据。它改变了 IRIS1 的实时 ICC vote，并使首 16 个已返回输入
保持最大 clock/bandwidth；因此下一次实机必须先跑 H.264、HEVC Main8、Main10 和 runtime
PM 回归，再观察 `/sys/kernel/debug/interconnect`/clock 与 dmesg。只有这些都通过后才执行
一次 Stage9。若 Stage9 仍整机复位，0019 已排除“首 ETB 前仍使用 SDM845 低带宽票”这一
大类根因；若不再复位，必须继续验证 EBD/FBD、30/300 帧、STREAMOFF 和多实例，不能只
以单帧不重启宣布编码完成。
