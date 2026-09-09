# 小米 SM8150 原厂 VIDC 39,111 行连续覆盖台账

> 原厂提交：`192eca8550f95c2eec58a474793d1d93fc1b3b67`；
> `drivers/media/platform/msm/vidc` tree：`1e66319e3b0a9e1ad7f59d624b4d58f5c0c67fc4`。
> 本台账覆盖 42 个文件的每一个物理源代码行。行区间以函数、宏、类型、全局变量、
> switch case、label、条件编译和 designated initializer 为锚点连续分割；区间是覆盖
> 单元，不声称末行恰好等于 C 函数的语法结束。原文应通过固定提交的 `git show` 核验。

“同名命中”只是当前 `qcom/venus` 是否含相同 token 的机械证据；未命中不自动代表
功能缺失，因为 vendor HAL 与主线命名不同。最终迁移判定以“复核结论”和总报告为准。

| 状态 | 含义 |
|---|---|
| 架构替代/语义拆分 | 主线已有不同对象模型，迁行为而非复制代码 |
| 部分/选择性迁移 | 只覆盖通用 ABI 子集，仍有明确功能缺口 |
| 缺失 | 当前没有等价实现，需要按主线框架重写 |
| 不迁移 | Android/CVP/私有 ABI 不属于本项目通用 codec 目标 |
| 诊断参考 | 可借鉴取证，不是功能依赖 |

## `governors/fixedpoint.h`

- 原厂物理行：72；当前语义落点：`pm_helpers.c / 64-bit helper`；默认判定：**不直接迁移**。
- 文件级结论：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 13--14 | `pp:ifdef _FIXP_ARITH_H` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 15--16 | `pp:endif` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 17--25 | `pp:ifndef __FP_H__` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 26--50 | `chunk:26` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 51--71 | `chunk:51` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |
| 72--72 | `pp:endif` | `—` | 不直接迁移：只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。 |

覆盖校验：72/72 行，连续、无空洞、无重叠。

## `governors/Kconfig`

- 原厂物理行：6；当前语义落点：`Kconfig/Makefile + interconnect`；默认判定：**缺失**。
- 文件级结论：vendor governor 构建胶水不搬运；功能需按主线框架重写。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--6 | `file:start` | `—` | 缺失：vendor governor 构建胶水不搬运；功能需按主线框架重写。 |

覆盖校验：6/6 行，连续、无空洞、无重叠。

## `governors/Makefile`

- 原厂物理行：9；当前语义落点：`Kconfig/Makefile + interconnect`；默认判定：**缺失**。
- 文件级结论：vendor governor 构建胶水不搬运；功能需按主线框架重写。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--9 | `file:start` | `—` | 缺失：vendor governor 构建胶水不搬运；功能需按主线框架重写。 |

覆盖校验：9/9 行，连续、无空洞、无重叠。

## `governors/msm_vidc_ar50_dyn_gov.c`

- 原厂物理行：980；当前语义落点：`pm_helpers.c + interconnect/devfreq`；默认判定：**缺失**。
- 文件级结论：原厂动态 DDR/LLCC、UBWC、recon、codec/fps 模型当前没有等价实现。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--18 | `file:start` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 19--20 | `d:COMPRESSION_RATIO_MAX` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 21--23 | `v:debug` | `debug` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 24--25 | `g:governor_mode` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 26--28 | `chunk:26` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 29--40 | `s:governor` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 41--41 | `v:BASELINE_DIMENSIONS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 42--42 | `field:width` | `width` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 43--50 | `field:height` | `height` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 51--51 | `chunk:51` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 52--52 | `v:NOMINAL_BW_MBPS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 53--55 | `v:SVS_BW_MBPS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 56--56 | `d:kbps` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 57--58 | `d:bps` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 59--59 | `d:GENERATE_COMPRESSION_PROFILE` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 60--60 | `field:bpp` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 61--75 | `field:ratio` | `ratio` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 76--83 | `chunk:76, s:lut` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 84--85 | `v:LUT` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 86--86 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 87--87 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 88--88 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 89--96 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 97--97 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 98--98 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 99--99 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 100--100 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 101--107 | `chunk:101` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 108--108 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 109--109 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 110--110 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 111--118 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 119--119 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 120--120 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 121--121 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 122--125 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 126--129 | `chunk:126` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 130--130 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 131--131 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 132--132 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 133--140 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 141--141 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 142--142 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 143--143 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 144--150 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 151--151 | `chunk:151` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 152--152 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 153--153 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 154--154 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 155--162 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 163--163 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 164--164 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 165--165 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 166--173 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 174--174 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 175--175 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 176--176 | `chunk:176, field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 177--184 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 185--185 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 186--186 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 187--187 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 188--195 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 196--196 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 197--197 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 198--198 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 199--200 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 201--206 | `chunk:201` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 207--207 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 208--208 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 209--209 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 210--218 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 219--225 | `f:__lut` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 226--230 | `chunk:226` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 231--243 | `f:__compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 244--244 | `d:DUMP_HEADER_MAGIC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 245--245 | `d:DUMP_FP_FMT` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 246--250 | `s:dump` | `dump` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 251--251 | `chunk:251` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 252--275 | `f:__dump` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 276--289 | `chunk:276` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 290--295 | `f:__calculate_vpe` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 296--298 | `f:__ubwc` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 299--299 | `case:HAL_COLOR_FORMAT_NV12_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 300--300 | `case:HAL_COLOR_FORMAT_NV12_TP10_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 301--301 | `chunk:301` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 302--306 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 307--309 | `f:__bpp` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 310--310 | `case:HAL_COLOR_FORMAT_NV12` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 311--311 | `case:HAL_COLOR_FORMAT_NV21` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 312--313 | `case:HAL_COLOR_FORMAT_NV12_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 314--314 | `case:HAL_COLOR_FORMAT_NV12_TP10_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 315--316 | `case:HAL_COLOR_FORMAT_P010` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 317--324 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 325--325 | `f:__calculate_decoder` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 326--350 | `chunk:326` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 351--375 | `chunk:351` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 376--400 | `chunk:376` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 401--425 | `chunk:401` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 426--450 | `chunk:426` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 451--475 | `chunk:451` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 476--500 | `chunk:476` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 501--525 | `chunk:501` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 526--550 | `chunk:526` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 551--571 | `chunk:551` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 572--574 | `case:GOVERNOR_DDR` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 575--575 | `case:GOVERNOR_LLCC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 576--577 | `chunk:576` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 578--584 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 585--600 | `f:__calculate_encoder` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 601--625 | `chunk:601` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 626--650 | `chunk:626` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 651--675 | `chunk:651` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 676--700 | `chunk:676` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 701--725 | `chunk:701` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 726--750 | `chunk:726` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 751--775 | `chunk:751` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 776--800 | `chunk:776` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 801--825 | `chunk:801` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 826--842 | `chunk:826` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 843--845 | `case:GOVERNOR_DDR` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 846--848 | `case:GOVERNOR_LLCC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 849--850 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 851--855 | `chunk:851` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 856--860 | `f:__calculate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 861--861 | `index:HAL_VIDEO_DOMAIN_VPE` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 862--862 | `index:HAL_VIDEO_DOMAIN_ENCODER` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 863--874 | `index:HAL_VIDEO_DOMAIN_DECODER` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 875--875 | `f:__get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 876--900 | `chunk:876` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 901--902 | `chunk:901` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 903--908 | `label:exit` | `exit` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 909--917 | `f:__event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 918--918 | `case:DEVFREQ_GOV_START` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 919--919 | `case:DEVFREQ_GOV_RESUME` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 920--925 | `case:DEVFREQ_GOV_SUSPEND` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 926--929 | `chunk:926` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 930--931 | `v:governors` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 932--932 | `field:mode` | `mode` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 933--933 | `field:devfreq_gov` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 934--934 | `field:name` | `name` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 935--935 | `field:get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 936--939 | `field:event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 940--940 | `field:mode` | `mode` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 941--941 | `field:devfreq_gov` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 942--942 | `field:name` | `name` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 943--943 | `field:get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 944--948 | `field:event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 949--950 | `f:msm_vidc_ar50_bw_gov_init` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 951--966 | `chunk:951` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 967--968 | `v:msm_vidc_ar50_bw_gov_init` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 969--975 | `f:msm_vidc_ar50_bw_gov_exit` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 976--978 | `chunk:976` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 979--980 | `v:msm_vidc_ar50_bw_gov_exit` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |

覆盖校验：980/980 行，连续、无空洞、无重叠。

## `governors/msm_vidc_dyn_gov.c`

- 原厂物理行：1022；当前语义落点：`pm_helpers.c + interconnect/devfreq`；默认判定：**缺失**。
- 文件级结论：原厂动态 DDR/LLCC、UBWC、recon、codec/fps 模型当前没有等价实现。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--18 | `file:start` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 19--20 | `d:COMPRESSION_RATIO_MAX` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 21--23 | `v:debug` | `debug` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 24--25 | `g:governor_mode` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 26--28 | `chunk:26` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 29--40 | `s:governor` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 41--41 | `v:BASELINE_DIMENSIONS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 42--42 | `field:width` | `width` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 43--50 | `field:height` | `height` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 51--51 | `chunk:51` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 52--52 | `v:NOMINAL_BW_MBPS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 53--55 | `v:SVS_BW_MBPS` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 56--56 | `d:kbps` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 57--58 | `d:bps` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 59--59 | `d:GENERATE_COMPRESSION_PROFILE` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 60--60 | `field:bpp` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 61--75 | `field:ratio` | `ratio` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 76--83 | `chunk:76, s:lut` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 84--85 | `v:LUT` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 86--86 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 87--87 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 88--88 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 89--96 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 97--97 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 98--98 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 99--99 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 100--100 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 101--107 | `chunk:101` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 108--108 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 109--109 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 110--110 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 111--118 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 119--119 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 120--120 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 121--121 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 122--125 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 126--129 | `chunk:126` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 130--130 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 131--131 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 132--132 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 133--140 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 141--141 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 142--142 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 143--143 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 144--150 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 151--151 | `chunk:151` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 152--152 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 153--153 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 154--154 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 155--162 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 163--163 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 164--164 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 165--165 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 166--173 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 174--174 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 175--175 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 176--176 | `chunk:176, field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 177--184 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 185--185 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 186--186 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 187--187 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 188--195 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 196--196 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 197--197 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 198--198 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 199--200 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 201--206 | `chunk:201` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 207--207 | `field:frame_size` | `frame_size` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 208--208 | `field:frame_rate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 209--209 | `field:bitrate` | `bitrate` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 210--218 | `field:compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 219--225 | `f:__lut` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 226--230 | `chunk:226` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 231--243 | `f:__compression_ratio` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 244--244 | `d:DUMP_HEADER_MAGIC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 245--245 | `d:DUMP_FP_FMT` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 246--250 | `s:dump` | `dump` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 251--251 | `chunk:251` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 252--275 | `f:__dump` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 276--289 | `chunk:276` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 290--295 | `f:__calculate_vpe` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 296--300 | `f:__calculate_cvp` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 301--301 | `chunk:301` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 302--304 | `case:GOVERNOR_DDR` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 305--307 | `case:GOVERNOR_LLCC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 308--315 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 316--318 | `f:__ubwc` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 319--319 | `case:HAL_COLOR_FORMAT_NV12_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 320--321 | `case:HAL_COLOR_FORMAT_NV12_TP10_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 322--325 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 326--326 | `chunk:326` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 327--329 | `f:__bpp` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 330--330 | `case:HAL_COLOR_FORMAT_NV12` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 331--331 | `case:HAL_COLOR_FORMAT_NV21` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 332--333 | `case:HAL_COLOR_FORMAT_NV12_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 334--334 | `case:HAL_COLOR_FORMAT_NV12_TP10_UBWC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 335--336 | `case:HAL_COLOR_FORMAT_P010` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 337--344 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 345--350 | `f:__calculate_decoder` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 351--375 | `chunk:351` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 376--400 | `chunk:376` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 401--425 | `chunk:401` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 426--450 | `chunk:426` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 451--475 | `chunk:451` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 476--500 | `chunk:476` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 501--525 | `chunk:501` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 526--550 | `chunk:526` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 551--575 | `chunk:551` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 576--586 | `chunk:576` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 587--589 | `case:GOVERNOR_DDR` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 590--592 | `case:GOVERNOR_LLCC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 593--599 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 600--600 | `f:__calculate_encoder` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 601--625 | `chunk:601` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 626--650 | `chunk:626` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 651--675 | `chunk:651` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 676--700 | `chunk:676` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 701--725 | `chunk:701` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 726--750 | `chunk:726` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 751--775 | `chunk:751` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 776--800 | `chunk:776` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 801--825 | `chunk:801` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 826--850 | `chunk:826` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 851--875 | `chunk:851` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 876--883 | `chunk:876` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 884--886 | `case:GOVERNOR_DDR` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 887--889 | `case:GOVERNOR_LLCC` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 890--896 | `case:default` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 897--900 | `f:__calculate` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 901--901 | `chunk:901` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 902--902 | `index:HAL_VIDEO_DOMAIN_VPE` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 903--903 | `index:HAL_VIDEO_DOMAIN_ENCODER` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 904--904 | `index:HAL_VIDEO_DOMAIN_DECODER` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 905--916 | `index:HAL_VIDEO_DOMAIN_CVP` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 917--925 | `f:__get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 926--944 | `chunk:926` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 945--950 | `label:exit` | `exit` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 951--959 | `chunk:951, f:__event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 960--960 | `case:DEVFREQ_GOV_START` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 961--961 | `case:DEVFREQ_GOV_RESUME` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 962--971 | `case:DEVFREQ_GOV_SUSPEND` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 972--973 | `v:governors` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 974--974 | `field:mode` | `mode` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 975--975 | `field:devfreq_gov` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 976--976 | `chunk:976, field:name` | `name` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 977--977 | `field:get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 978--981 | `field:event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 982--982 | `field:mode` | `mode` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 983--983 | `field:devfreq_gov` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 984--984 | `field:name` | `name` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 985--985 | `field:get_target_freq` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 986--990 | `field:event_handler` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 991--1000 | `f:msm_vidc_bw_gov_init` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 1001--1008 | `chunk:1001` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 1009--1010 | `v:msm_vidc_bw_gov_init` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 1011--1020 | `f:msm_vidc_bw_gov_exit` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |
| 1021--1022 | `v:msm_vidc_bw_gov_exit` | `—` | 缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。 |

覆盖校验：1022/1022 行，连续、无空洞、无重叠。

## `hfi_packetization.c`

- 原厂物理行：2198；当前语义落点：`hfi_cmds.c + hfi_helper.h`；默认判定：**部分迁移**。
- 文件级结论：线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--24 | `file:start` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 25--25 | `v:entropy_mode` | `entropy_mode` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 26--26 | `chunk:26, index:ilog2(HAL_H264_ENTROPY_CAVLC)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 27--29 | `index:ilog2(HAL_H264_ENTROPY_CABAC)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 30--30 | `v:statistics_mode` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 31--31 | `index:ilog2(HAL_STATISTICS_MODE_DEFAULT)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 32--32 | `index:ilog2(HAL_STATISTICS_MODE_1)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 33--33 | `index:ilog2(HAL_STATISTICS_MODE_2)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 34--36 | `index:ilog2(HAL_STATISTICS_MODE_3)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 37--37 | `v:color_format` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 38--38 | `index:ilog2(HAL_COLOR_FORMAT_MONOCHROME)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 39--39 | `index:ilog2(HAL_COLOR_FORMAT_NV12)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 40--40 | `index:ilog2(HAL_COLOR_FORMAT_NV21)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 41--41 | `index:ilog2(HAL_COLOR_FORMAT_NV12_4x4TILE)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 42--42 | `index:ilog2(HAL_COLOR_FORMAT_NV21_4x4TILE)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 43--43 | `index:ilog2(HAL_COLOR_FORMAT_YUYV)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 44--44 | `index:ilog2(HAL_COLOR_FORMAT_YVYU)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 45--45 | `index:ilog2(HAL_COLOR_FORMAT_UYVY)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 46--46 | `index:ilog2(HAL_COLOR_FORMAT_VYUY)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 47--47 | `index:ilog2(HAL_COLOR_FORMAT_RGB565)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 48--48 | `index:ilog2(HAL_COLOR_FORMAT_BGR565)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 49--49 | `index:ilog2(HAL_COLOR_FORMAT_RGB888)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 50--50 | `index:ilog2(HAL_COLOR_FORMAT_BGR888)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 51--51 | `chunk:51` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 52--52 | `index:ilog2(HAL_COLOR_FORMAT_NV12_UBWC)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 53--55 | `index:ilog2(HAL_COLOR_FORMAT_NV12_TP10_UBWC)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 56--56 | `index:ilog2(HAL_COLOR_FORMAT_P010)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 57--59 | `index:ilog2(HAL_COLOR_FORMAT_NV12_512)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 60--60 | `v:nal_type` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 61--61 | `index:ilog2(HAL_NAL_FORMAT_STARTCODES)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 62--63 | `index:ilog2(HAL_NAL_FORMAT_ONE_NAL_PER_BUFFER)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 64--65 | `index:ilog2(HAL_NAL_FORMAT_ONE_BYTE_LENGTH)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 66--67 | `index:ilog2(HAL_NAL_FORMAT_TWO_BYTE_LENGTH)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 68--71 | `index:ilog2(HAL_NAL_FORMAT_FOUR_BYTE_LENGTH)` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 72--75 | `f:hal_to_hfi_type` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 76--85 | `chunk:76` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 86--88 | `case:HAL_PARAM_VENC_H264_ENTROPY_CONTROL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 89--91 | `case:HAL_PARAM_UNCOMPRESSED_FORMAT_SELECT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 92--94 | `case:HAL_PARAM_NAL_STREAM_FORMAT_SELECT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 95--97 | `case:HAL_PARAM_VENC_MBI_STATISTICS_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 98--100 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 101--102 | `chunk:101` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 103--107 | `f:vidc_get_hal_domain` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 108--110 | `case:HFI_VIDEO_DOMAIN_VPE` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 111--113 | `case:HFI_VIDEO_DOMAIN_ENCODER` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 114--116 | `case:HFI_VIDEO_DOMAIN_DECODER` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 117--119 | `case:HFI_VIDEO_DOMAIN_CVP` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 120--125 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 126--128 | `chunk:126` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 129--133 | `f:vidc_get_hal_codec` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 134--136 | `case:HFI_VIDEO_CODEC_H264` | `HFI_VIDEO_CODEC_H264` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 137--139 | `case:HFI_VIDEO_CODEC_MPEG1` | `HFI_VIDEO_CODEC_MPEG1` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 140--142 | `case:HFI_VIDEO_CODEC_MPEG2` | `HFI_VIDEO_CODEC_MPEG2` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 143--145 | `case:HFI_VIDEO_CODEC_VP8` | `HFI_VIDEO_CODEC_VP8` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 146--148 | `case:HFI_VIDEO_CODEC_HEVC` | `HFI_VIDEO_CODEC_HEVC` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 149--150 | `case:HFI_VIDEO_CODEC_VP9` | `HFI_VIDEO_CODEC_VP9` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 151--151 | `chunk:151` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 152--154 | `case:HFI_VIDEO_CODEC_TME` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 155--157 | `case:HFI_VIDEO_CODEC_CVP` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 158--167 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 168--172 | `f:vidc_get_hfi_domain` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 173--175 | `case:HAL_VIDEO_DOMAIN_VPE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 176--178 | `case:HAL_VIDEO_DOMAIN_ENCODER, chunk:176` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 179--181 | `case:HAL_VIDEO_DOMAIN_DECODER` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 182--184 | `case:HAL_VIDEO_DOMAIN_CVP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 185--193 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 194--198 | `f:vidc_get_hfi_codec` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 199--200 | `case:HAL_VIDEO_CODEC_H264` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 201--201 | `chunk:201` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 202--204 | `case:HAL_VIDEO_CODEC_MPEG1` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 205--207 | `case:HAL_VIDEO_CODEC_MPEG2` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 208--210 | `case:HAL_VIDEO_CODEC_VP8` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 211--213 | `case:HAL_VIDEO_CODEC_HEVC` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 214--216 | `case:HAL_VIDEO_CODEC_VP9` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 217--219 | `case:HAL_VIDEO_CODEC_TME` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 220--222 | `case:HAL_VIDEO_CODEC_CVP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 223--225 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 226--231 | `chunk:226` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 232--241 | `f:create_pkt_enable` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 242--250 | `f:create_pkt_cmd_sys_init` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 251--255 | `chunk:251` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 256--267 | `f:create_pkt_cmd_sys_pc_prep` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 268--275 | `f:create_pkt_cmd_sys_debug_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 276--290 | `chunk:276` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 291--300 | `f:create_pkt_cmd_sys_coverage_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 301--310 | `chunk:301` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 311--325 | `f:create_pkt_cmd_sys_set_resource` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 326--330 | `chunk:326` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 331--350 | `case:VIDC_RESOURCE_SYSCACHE` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 351--359 | `chunk:351` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 360--368 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 369--375 | `f:create_pkt_cmd_sys_release_resource` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 376--386 | `chunk:376` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 387--389 | `case:VIDC_RESOURCE_SYSCACHE` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 390--400 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 401--402 | `chunk:401` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 403--415 | `f:create_pkt_cmd_sys_ping` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 416--425 | `f:create_pkt_cmd_sys_session_init` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 426--436 | `chunk:426` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 437--450 | `f:create_pkt_cmd_session_cmd` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 451--451 | `chunk:451` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 452--471 | `f:create_pkt_cmd_sys_power_control` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 472--475 | `f:get_hfi_buffer` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 476--476 | `chunk:476` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 477--479 | `case:HAL_BUFFER_INPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 480--482 | `case:HAL_BUFFER_OUTPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 483--485 | `case:HAL_BUFFER_OUTPUT2` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 486--488 | `case:HAL_BUFFER_EXTRADATA_INPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 489--491 | `case:HAL_BUFFER_EXTRADATA_OUTPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 492--494 | `case:HAL_BUFFER_EXTRADATA_OUTPUT2` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 495--497 | `case:HAL_BUFFER_INTERNAL_SCRATCH` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 498--500 | `case:HAL_BUFFER_INTERNAL_SCRATCH_1` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 501--503 | `case:HAL_BUFFER_INTERNAL_SCRATCH_2, chunk:501` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 504--506 | `case:HAL_BUFFER_INTERNAL_PERSIST` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 507--509 | `case:HAL_BUFFER_INTERNAL_PERSIST_1` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 510--518 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 519--523 | `f:get_hfi_extradata_index` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 524--525 | `case:HAL_EXTRADATA_INTERLACE_VIDEO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 526--526 | `chunk:526` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 527--529 | `case:HAL_EXTRADATA_TIMESTAMP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 530--532 | `case:HAL_EXTRADATA_S3D_FRAME_PACKING` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 533--535 | `case:HAL_EXTRADATA_FRAME_RATE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 536--538 | `case:HAL_EXTRADATA_PANSCAN_WINDOW` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 539--541 | `case:HAL_EXTRADATA_RECOVERY_POINT_SEI` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 542--544 | `case:HAL_EXTRADATA_NUM_CONCEALED_MB` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 545--545 | `case:HAL_EXTRADATA_ASPECT_RATIO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 546--546 | `case:HAL_EXTRADATA_OUTPUT_CROP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 547--549 | `case:HAL_EXTRADATA_INPUT_CROP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 550--550 | `case:HAL_EXTRADATA_MPEG2_SEQDISP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 551--552 | `chunk:551` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 553--555 | `case:HAL_EXTRADATA_STREAM_USERDATA` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 556--558 | `case:HAL_EXTRADATA_DEC_FRAME_QP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 559--561 | `case:HAL_EXTRADATA_ENC_FRAME_QP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 562--564 | `case:HAL_EXTRADATA_LTR_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 565--567 | `case:HAL_EXTRADATA_ROI_QP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 568--571 | `case:HAL_EXTRADATA_MASTERING_DISPLAY_COLOUR_SEI` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 572--574 | `case:HAL_EXTRADATA_CONTENT_LIGHT_LEVEL_SEI` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 575--575 | `case:HAL_EXTRADATA_VUI_DISPLAY_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 576--577 | `chunk:576` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 578--580 | `case:HAL_EXTRADATA_VPX_COLORSPACE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 581--583 | `case:HAL_EXTRADATA_UBWC_CR_STATS_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 584--586 | `case:HAL_EXTRADATA_HDR10PLUS_METADATA` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 587--589 | `case:HAL_EXTRADATA_ENC_DTS_METADATA` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 590--596 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 597--600 | `f:get_hfi_extradata_id` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 601--601 | `chunk:601` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 602--604 | `case:HAL_EXTRADATA_ASPECT_RATIO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 605--607 | `case:HAL_EXTRADATA_OUTPUT_CROP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 608--610 | `case:HAL_EXTRADATA_INPUT_CROP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 611--617 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 618--622 | `f:get_hfi_ltr_mode` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 623--625 | `case:HAL_LTR_MODE_DISABLE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 626--628 | `case:HAL_LTR_MODE_MANUAL, chunk:626` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 629--637 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 638--642 | `f:get_hfi_work_mode` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 643--645 | `case:VIDC_WORK_MODE_1` | `VIDC_WORK_MODE_1` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 646--648 | `case:VIDC_WORK_MODE_2` | `VIDC_WORK_MODE_2` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 649--650 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 651--657 | `chunk:651` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 658--675 | `f:create_pkt_cmd_session_set_buffers` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 676--700 | `chunk:676` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 701--707 | `chunk:701` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 708--725 | `f:create_pkt_cmd_session_release_buffers` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 726--750 | `chunk:726` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 751--753 | `chunk:751` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 754--775 | `f:create_pkt_cmd_session_register_buffer` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 776--786 | `chunk:776` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 787--800 | `f:create_pkt_cmd_session_unregister_buffer` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 801--819 | `chunk:801` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 820--825 | `f:create_pkt_cmd_session_etb_decoder` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 826--850 | `chunk:826` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 851--853 | `chunk:851` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 854--875 | `f:create_pkt_cmd_session_etb_encoder` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 876--889 | `chunk:876` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 890--900 | `f:create_pkt_cmd_session_ftb` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 901--925 | `chunk:901` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 926--926 | `chunk:926` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 927--944 | `f:create_pkt_cmd_session_get_buf_req` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 945--950 | `f:create_pkt_cmd_session_flush` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 951--956 | `chunk:951` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 957--959 | `case:HAL_FLUSH_INPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 960--962 | `case:HAL_FLUSH_OUTPUT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 963--965 | `case:HAL_FLUSH_ALL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 966--972 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 973--975 | `f:create_pkt_cmd_session_get_property` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 976--982 | `chunk:976` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 983--1000 | `f:create_pkt_cmd_session_set_property` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1001--1018 | `case:HAL_CONFIG_FRAME_RATE, chunk:1001` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1019--1025 | `case:HAL_CONFIG_OPERATING_RATE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1026--1030 | `chunk:1026` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1031--1050 | `case:HAL_PARAM_UNCOMPRESSED_FORMAT_SELECT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1051--1053 | `chunk:1051` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1054--1075 | `case:HAL_PARAM_UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1076--1083 | `chunk:1076` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1084--1085 | `case:HAL_PARAM_UNCOMPRESSED_PLANE_ACTUAL_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1086--1100 | `case:HAL_PARAM_FRAME_SIZE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1101--1104 | `chunk:1101` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1105--1112 | `case:HAL_CONFIG_REALTIME` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1113--1125 | `case:HAL_PARAM_BUFFER_COUNT_ACTUAL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1126--1136 | `chunk:1126` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1137--1150 | `case:HAL_PARAM_NAL_STREAM_FORMAT_SELECT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1151--1154 | `chunk:1151` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1155--1161 | `case:HAL_PARAM_VDEC_OUTPUT_ORDER` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1162--1164 | `case:HAL_OUTPUT_ORDER_DECODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1165--1167 | `case:HAL_OUTPUT_ORDER_DISPLAY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1168--1175 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1176--1187 | `case:HAL_PARAM_VDEC_PICTURE_TYPE_DECODE, chunk:1176` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1188--1195 | `case:HAL_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1196--1200 | `case:HAL_PARAM_VDEC_MULTI_STREAM` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1201--1215 | `chunk:1201` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1216--1223 | `case:HAL_CONFIG_VDEC_MB_ERROR_MAP_REPORTING` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1224--1225 | `case:HAL_PARAM_VDEC_SYNC_FRAME_DECODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1226--1231 | `chunk:1226` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1232--1239 | `case:HAL_PARAM_SECURE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1240--1247 | `case:HAL_PARAM_VENC_SYNC_FRAME_SEQUENCE_HEADER` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1248--1250 | `case:HAL_CONFIG_VENC_REQUEST_IFRAME` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1251--1251 | `chunk:1251` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1252--1265 | `case:HAL_CONFIG_HEIC_FRAME_QUALITY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1266--1275 | `case:HAL_CONFIG_HEIC_GRID_ENABLE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1276--1277 | `chunk:1276` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1278--1289 | `case:HAL_CONFIG_VENC_TARGET_BITRATE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1290--1300 | `case:HAL_PARAM_PROFILE_LEVEL_CURRENT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1301--1315 | `chunk:1301` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1316--1325 | `case:HAL_PARAM_VENC_H264_ENTROPY_CONTROL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1326--1332 | `chunk:1326` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1333--1340 | `case:HAL_PARAM_VENC_RATE_CONTROL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1341--1343 | `case:HAL_RATE_CONTROL_OFF` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1344--1346 | `case:HAL_RATE_CONTROL_CBR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1347--1349 | `case:HAL_RATE_CONTROL_VBR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1350--1350 | `case:HAL_RATE_CONTROL_MBR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1351--1352 | `chunk:1351` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1353--1355 | `case:HAL_RATE_CONTROL_CBR_VFR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1356--1358 | `case:HAL_RATE_CONTROL_MBR_VFR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1359--1361 | `case:HAL_RATE_CONTROL_CQ` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1362--1370 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1371--1375 | `case:HAL_PARAM_VENC_BITRATE_SAVINGS` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1376--1378 | `chunk:1376` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1379--1387 | `case:HAL_PARAM_VENC_H264_DEBLOCK_CONTROL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1388--1390 | `case:HAL_H264_DB_MODE_DISABLE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1391--1393 | `case:HAL_H264_DB_MODE_SKIP_SLICE_BOUNDARY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1394--1396 | `case:HAL_H264_DB_MODE_ALL_BOUNDARY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1397--1400 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1401--1406 | `chunk:1401` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1407--1421 | `case:HAL_CONFIG_VENC_FRAME_QP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1422--1425 | `case:HAL_PARAM_VENC_SESSION_QP_RANGE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1426--1449 | `chunk:1426` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1450--1450 | `case:HAL_CONFIG_VENC_INTRA_PERIOD` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1451--1474 | `chunk:1451` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1475--1475 | `case:HAL_CONFIG_VENC_IDR_PERIOD` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1476--1484 | `chunk:1476` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1485--1492 | `case:HAL_PARAM_VENC_ADAPTIVE_B` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1493--1500 | `case:HAL_PARAM_VDEC_CONCEAL_COLOR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1501--1510 | `chunk:1501` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1511--1518 | `case:HAL_PARAM_VPE_ROTATION` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1519--1521 | `case:0` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1522--1524 | `case:90` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1525--1525 | `case:180` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1526--1527 | `chunk:1526` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1528--1530 | `case:270` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1531--1537 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1538--1540 | `case:HAL_FLIP_NONE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1541--1543 | `case:HAL_FLIP_HORIZONTAL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1544--1546 | `case:HAL_FLIP_VERTICAL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1547--1549 | `case:HAL_FLIP_BOTH` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1550--1550 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1551--1558 | `chunk:1551` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1559--1568 | `case:HAL_PARAM_VENC_INTRA_REFRESH` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1569--1571 | `case:HAL_INTRA_REFRESH_NONE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1572--1575 | `case:HAL_INTRA_REFRESH_CYCLIC` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1576--1579 | `case:HAL_INTRA_REFRESH_RANDOM, chunk:1576` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1580--1588 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1589--1598 | `case:HAL_PARAM_VENC_MULTI_SLICE_CONTROL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1599--1600 | `case:HAL_MULTI_SLICE_OFF` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1601--1601 | `chunk:1601` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1602--1604 | `case:HAL_MULTI_SLICE_BY_MB_COUNT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1605--1607 | `case:HAL_MULTI_SLICE_BY_BYTE_COUNT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1608--1617 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1618--1625 | `case:HAL_PARAM_INDEX_EXTRADATA` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1626--1640 | `chunk:1626` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1641--1648 | `case:HAL_PARAM_VENC_SLICE_DELIVERY_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1649--1650 | `case:HAL_PARAM_VENC_VUI_TIMING_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1651--1664 | `chunk:1651` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1665--1672 | `case:HAL_PARAM_VENC_GENERATE_AUDNAL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1673--1675 | `case:HAL_PARAM_VENC_PRESERVE_TEXT_QUALITY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1676--1680 | `chunk:1676` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1681--1694 | `case:HAL_PARAM_VENC_LTRMODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1695--1700 | `case:HAL_CONFIG_VENC_USELTRFRAME` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1701--1708 | `chunk:1701` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1709--1720 | `case:HAL_CONFIG_VENC_MARKLTRFRAME` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1721--1725 | `case:HAL_PARAM_VENC_HIER_P_MAX_ENH_LAYERS` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1726--1728 | `chunk:1726` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1729--1736 | `case:HAL_CONFIG_VENC_HIER_P_NUM_FRAMES` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1737--1744 | `case:HAL_PARAM_VENC_DISABLE_RC_TIMESTAMP` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1745--1750 | `case:HAL_PARAM_VPE_COLOR_SPACE_CONVERSION` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1751--1767 | `chunk:1751` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1768--1775 | `case:HAL_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1776--1781 | `case:HAL_CONFIG_VENC_PERF_MODE, chunk:1776` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1782--1784 | `case:HAL_PERF_MODE_POWER_SAVE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1785--1787 | `case:HAL_PERF_MODE_POWER_MAX_QUALITY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1788--1796 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1797--1800 | `case:HAL_PARAM_VENC_HIER_P_HYBRID_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1801--1806 | `chunk:1801` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1807--1816 | `case:HAL_PARAM_VENC_MBI_STATISTICS_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1817--1824 | `case:HAL_CONFIG_VENC_BASELAYER_PRIORITYID` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1825--1825 | `case:HAL_PROPERTY_PARAM_VENC_ASPECT_RATIO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1826--1838 | `chunk:1826` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1839--1846 | `case:HAL_PARAM_VENC_BITRATE_TYPE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1847--1850 | `case:HAL_PARAM_VENC_H264_TRANSFORM_8x8` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1851--1854 | `chunk:1851` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1855--1874 | `case:HAL_PARAM_VENC_VIDEO_SIGNAL_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1875--1875 | `case:HAL_PARAM_VENC_IFRAMESIZE_TYPE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1876--1882 | `chunk:1876` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1883--1885 | `case:HAL_IFRAMESIZE_TYPE_DEFAULT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1886--1888 | `case:HAL_IFRAMESIZE_TYPE_MEDIUM` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1889--1891 | `case:HAL_IFRAMESIZE_TYPE_HUGE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1892--1894 | `case:HAL_IFRAMESIZE_TYPE_UNLIMITED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1895--1900 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1901--1901 | `chunk:1901` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1902--1924 | `case:HAL_PARAM_BUFFER_SIZE_MINIMUM` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1925--1925 | `case:HAL_PARAM_SYNC_BASED_INTERRUPT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1926--1932 | `chunk:1926` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1933--1943 | `case:HAL_PARAM_VENC_LOW_LATENCY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1944--1950 | `case:HAL_CONFIG_VENC_BLUR_RESOLUTION` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1951--1963 | `chunk:1951` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1964--1975 | `case:HAL_PARAM_VIDEO_CORES_USAGE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1976--1977 | `chunk:1976` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 1978--1992 | `case:HAL_PARAM_VIDEO_WORK_MODE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 1993--2000 | `case:HAL_PARAM_VIDEO_WORK_ROUTE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2001--2005 | `chunk:2001` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2006--2020 | `case:HAL_PARAM_VENC_HDR10_PQ_SEI` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2021--2025 | `case:HAL_CONFIG_VENC_VBV_HRD_BUF_SIZE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2026--2036 | `chunk:2026` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2037--2037 | `case:HAL_CONFIG_BUFFER_REQUIREMENTS` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2038--2038 | `case:HAL_CONFIG_PRIORITY` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2039--2039 | `case:HAL_CONFIG_BATCH_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2040--2040 | `case:HAL_PARAM_METADATA_PASS_THROUGH` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2041--2041 | `case:HAL_SYS_IDLE_INDICATOR` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2042--2042 | `case:HAL_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2043--2043 | `case:HAL_PARAM_INTERLACE_FORMAT_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2044--2044 | `case:HAL_PARAM_CHROMA_SITE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2045--2045 | `case:HAL_PARAM_PROPERTIES_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2046--2046 | `case:HAL_PARAM_PROFILE_LEVEL_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2047--2047 | `case:HAL_PARAM_CAPABILITY_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2048--2048 | `case:HAL_PARAM_NAL_STREAM_FORMAT_SUPPORTED` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2049--2049 | `case:HAL_PARAM_MULTI_VIEW_FORMAT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2050--2050 | `case:HAL_PARAM_MAX_SEQUENCE_HEADER_SIZE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2051--2051 | `case:HAL_PARAM_CODEC_SUPPORTED, chunk:2051` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2052--2052 | `case:HAL_PARAM_VDEC_MULTI_VIEW_SELECT` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2053--2053 | `case:HAL_PARAM_VDEC_MB_QUANTIZATION` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2054--2054 | `case:HAL_PARAM_VDEC_NUM_CONCEALED_MB` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2055--2055 | `case:HAL_PARAM_VDEC_H264_ENTROPY_SWITCHING` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2056--2056 | `case:HAL_CONFIG_BUFFER_COUNT_ACTUAL` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2057--2057 | `case:HAL_CONFIG_VDEC_MULTI_STREAM` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2058--2058 | `case:HAL_PARAM_VENC_MULTI_SLICE_INFO` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2059--2059 | `case:HAL_CONFIG_VENC_TIMESTAMP_SCALE` | `—` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2060--2067 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2068--2072 | `f:get_hfi_ssr_type` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2073--2075 | `case:SSR_ERR_FATAL` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2076--2078 | `case:SSR_SW_DIV_BY_ZERO, chunk:2076` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2079--2081 | `case:SSR_HW_WDOG_IRQ` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2082--2088 | `case:default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2089--2100 | `f:create_pkt_ssr_cmd` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2101--2101 | `chunk:2101` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2102--2115 | `f:create_pkt_cmd_sys_image_version` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2116--2125 | `f:create_pkt_cmd_sys_ubwc_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2126--2141 | `chunk:2126` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2142--2150 | `f:create_pkt_cmd_session_sync_process` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2151--2157 | `chunk:2151` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2158--2158 | `v:hfi_default` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2159--2159 | `field:sys_init` | `sys_init` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2160--2160 | `field:sys_pc_prep` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2161--2161 | `field:sys_power_control` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2162--2162 | `field:sys_set_resource` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2163--2163 | `field:sys_debug_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2164--2164 | `field:sys_coverage_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2165--2165 | `field:sys_release_resource` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2166--2166 | `field:sys_ping` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2167--2167 | `field:sys_image_version` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2168--2168 | `field:ssr_cmd` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2169--2169 | `field:sys_ubwc_config` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2170--2170 | `field:session_init` | `session_init` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2171--2171 | `field:session_cmd` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2172--2172 | `field:session_set_buffers` | `session_set_buffers` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 2173--2173 | `field:session_release_buffers` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 2174--2174 | `field:session_register_buffer` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2175--2175 | `field:session_unregister_buffer` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2176--2176 | `chunk:2176, field:session_etb_decoder` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 2177--2177 | `field:session_etb_encoder` | `—` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 2178--2178 | `field:session_ftb` | `session_ftb` | 线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。 |
| 2179--2179 | `field:session_get_buf_req` | `—` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2180--2180 | `field:session_flush` | `session_flush` | 主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。 |
| 2181--2181 | `field:session_get_property` | `session_get_property` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2182--2184 | `field:session_set_property` | `session_set_property` | 逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。 |
| 2185--2192 | `f:hfi_get_pkt_ops_handle` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |
| 2193--2198 | `case:HFI_PACKETIZATION_4XX` | `—` | 线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。 |

覆盖校验：2198/2198 行，连续、无空洞、无重叠。

## `hfi_packetization.h`

- 原厂物理行：103；当前语义落点：`hfi_cmds.h`；默认判定：**部分迁移**。
- 文件级结论：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 13--25 | `pp:ifndef __HFI_PACKETIZATION__` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 26--50 | `chunk:26` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 51--75 | `chunk:51` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 76--100 | `chunk:76` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 101--102 | `chunk:101` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |
| 103--103 | `pp:endif` | `—` | 部分迁移：API 按当前 HFI ops 拆分；不复制 vendor 对象模型。 |

覆盖校验：103/103 行，连续、无空洞、无重叠。

## `hfi_response_handler.c`

- 原厂物理行：2150；当前语义落点：`hfi_msgs.c + hfi_parser.c + helpers.c`；默认判定：**部分迁移**。
- 文件级结论：公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 26--30 | `chunk:26` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 31--35 | `f:hfi_map_err_status` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 36--36 | `case:HFI_ERR_NONE` | `HFI_ERR_NONE` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 37--39 | `case:HFI_ERR_SESSION_SAME_STATE_OPERATION` | `HFI_ERR_SESSION_SAME_STATE_OPERATION` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 40--42 | `case:HFI_ERR_SYS_FATAL` | `HFI_ERR_SYS_FATAL` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 43--45 | `case:HFI_ERR_SYS_NOC_ERROR` | `—` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 46--46 | `case:HFI_ERR_SYS_VERSION_MISMATCH` | `HFI_ERR_SYS_VERSION_MISMATCH` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 47--47 | `case:HFI_ERR_SYS_INVALID_PARAMETER` | `HFI_ERR_SYS_INVALID_PARAMETER` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 48--48 | `case:HFI_ERR_SYS_SESSION_ID_OUT_OF_RANGE` | `HFI_ERR_SYS_SESSION_ID_OUT_OF_RANGE` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 49--49 | `case:HFI_ERR_SESSION_INVALID_PARAMETER` | `HFI_ERR_SESSION_INVALID_PARAMETER` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 50--50 | `case:HFI_ERR_SESSION_INVALID_SESSION_ID` | `HFI_ERR_SESSION_INVALID_SESSION_ID` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 51--53 | `case:HFI_ERR_SESSION_INVALID_STREAM_ID, chunk:51` | `HFI_ERR_SESSION_INVALID_STREAM_ID` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 54--54 | `case:HFI_ERR_SYS_INSUFFICIENT_RESOURCES` | `HFI_ERR_SYS_INSUFFICIENT_RESOURCES` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 55--55 | `case:HFI_ERR_SYS_UNSUPPORTED_DOMAIN` | `HFI_ERR_SYS_UNSUPPORTED_DOMAIN` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 56--56 | `case:HFI_ERR_SYS_UNSUPPORTED_CODEC` | `HFI_ERR_SYS_UNSUPPORTED_CODEC` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 57--57 | `case:HFI_ERR_SESSION_UNSUPPORTED_PROPERTY` | `HFI_ERR_SESSION_UNSUPPORTED_PROPERTY` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 58--58 | `case:HFI_ERR_SESSION_UNSUPPORTED_SETTING` | `HFI_ERR_SESSION_UNSUPPORTED_SETTING` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 59--59 | `case:HFI_ERR_SESSION_INSUFFICIENT_RESOURCES` | `HFI_ERR_SESSION_INSUFFICIENT_RESOURCES` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 60--62 | `case:HFI_ERR_SESSION_UNSUPPORTED_STREAM` | `HFI_ERR_SESSION_UNSUPPORTED_STREAM` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 63--65 | `case:HFI_ERR_SYS_MAX_SESSIONS_REACHED` | `HFI_ERR_SYS_MAX_SESSIONS_REACHED` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 66--68 | `case:HFI_ERR_SYS_SESSION_IN_USE` | `HFI_ERR_SYS_SESSION_IN_USE` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 69--71 | `case:HFI_ERR_SESSION_FATAL` | `HFI_ERR_SESSION_FATAL` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 72--74 | `case:HFI_ERR_SESSION_BAD_POINTER` | `HFI_ERR_SESSION_BAD_POINTER` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 75--75 | `case:HFI_ERR_SESSION_INCORRECT_STATE_OPERATION` | `HFI_ERR_SESSION_INCORRECT_STATE_OPERATION` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 76--77 | `chunk:76` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 78--78 | `case:HFI_ERR_SESSION_STREAM_CORRUPT` | `HFI_ERR_SESSION_STREAM_CORRUPT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 79--81 | `case:HFI_ERR_SESSION_STREAM_CORRUPT_OUTPUT_STALLED` | `HFI_ERR_SESSION_STREAM_CORRUPT_OUTPUT_STALLED` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 82--84 | `case:HFI_ERR_SESSION_SYNC_FRAME_NOT_DETECTED` | `HFI_ERR_SESSION_SYNC_FRAME_NOT_DETECTED` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 85--87 | `case:HFI_ERR_SESSION_START_CODE_NOT_FOUND` | `HFI_ERR_SESSION_START_CODE_NOT_FOUND` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 88--88 | `case:HFI_ERR_SESSION_EMPTY_BUFFER_DONE_OUTPUT_PENDING` | `HFI_ERR_SESSION_EMPTY_BUFFER_DONE_OUTPUT_PENDING` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 89--95 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 96--98 | `f:get_hal_pixel_depth` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 99--99 | `case:HFI_BITDEPTH_8` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 100--100 | `case:HFI_BITDEPTH_9` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 101--106 | `case:HFI_BITDEPTH_10, chunk:101` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 107--116 | `f:validate_pkt_size` | `—` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 117--125 | `f:hfi_process_sess_evt_seq_changed` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 126--144 | `chunk:126` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 145--148 | `case:HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUFFER_RESOURCES` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 149--150 | `case:HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUFFER_RESOURCES` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 151--152 | `chunk:151` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 153--166 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 167--175 | `case:HFI_PROPERTY_PARAM_FRAME_SIZE` | `HFI_PROPERTY_PARAM_FRAME_SIZE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 176--181 | `chunk:176` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 182--197 | `case:HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | `HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 198--200 | `case:HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH` | `HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 201--225 | `chunk:201` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 226--233 | `chunk:226` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 234--248 | `case:HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT` | `HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 249--250 | `case:HFI_PROPERTY_PARAM_VDEC_DPB_COUNTS` | `HFI_PROPERTY_PARAM_VDEC_DPB_COUNTS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 251--269 | `chunk:251` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 270--275 | `case:HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE` | `HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 276--285 | `chunk:276` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 286--297 | `case:HFI_PROPERTY_CONFIG_VDEC_ENTROPY` | `HFI_PROPERTY_CONFIG_VDEC_ENTROPY` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 298--300 | `case:HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 301--315 | `chunk:301` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 316--325 | `case:HFI_INDEX_EXTRADATA_INPUT_CROP` | `HFI_INDEX_EXTRADATA_INPUT_CROP` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 326--342 | `chunk:326` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 343--350 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 351--358 | `chunk:351` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 359--375 | `f:hfi_process_evt_release_buffer_ref` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 376--397 | `chunk:376` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 398--400 | `f:hfi_process_sys_error` | `—` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 401--412 | `chunk:401` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 413--425 | `f:hfi_process_session_error` | `—` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 426--426 | `chunk:426` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 427--427 | `case:HFI_ERR_SESSION_INVALID_SCALE_FACTOR` | `HFI_ERR_SESSION_INVALID_SCALE_FACTOR` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 428--431 | `case:HFI_ERR_SESSION_UPSCALE_NOT_SUPPORTED` | `HFI_ERR_SESSION_UPSCALE_NOT_SUPPORTED` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 432--442 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 443--450 | `f:hfi_process_event_notify` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 451--455 | `chunk:451` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 456--459 | `case:HFI_EVENT_SYS_ERROR` | `HFI_EVENT_SYS_ERROR` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 460--464 | `case:HFI_EVENT_SESSION_ERROR` | `HFI_EVENT_SESSION_ERROR` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 465--469 | `case:HFI_EVENT_SESSION_SEQUENCE_CHANGED` | `HFI_EVENT_SESSION_SEQUENCE_CHANGED` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 470--474 | `case:HFI_EVENT_RELEASE_BUFFER_REFERENCE` | `HFI_EVENT_RELEASE_BUFFER_REFERENCE` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 475--475 | `case:HFI_EVENT_SESSION_PROPERTY_CHANGED` | `HFI_EVENT_SESSION_PROPERTY_CHANGED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 476--477 | `case:default, chunk:476` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 478--484 | `field:response_type` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 485--500 | `f:hfi_process_sys_init_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 501--512 | `chunk:501` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 513--524 | `label:err_no_prop` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 525--525 | `f:hfi_process_sys_rel_resource_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 526--550 | `chunk:526` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 551--554 | `chunk:551` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 555--559 | `f:get_hal_cap_type` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 560--562 | `case:HFI_CAPABILITY_FRAME_WIDTH` | `HFI_CAPABILITY_FRAME_WIDTH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 563--565 | `case:HFI_CAPABILITY_FRAME_HEIGHT` | `HFI_CAPABILITY_FRAME_HEIGHT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 566--568 | `case:HFI_CAPABILITY_MBS_PER_FRAME` | `HFI_CAPABILITY_MBS_PER_FRAME` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 569--571 | `case:HFI_CAPABILITY_MBS_PER_SECOND` | `HFI_CAPABILITY_MBS_PER_SECOND` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 572--574 | `case:HFI_CAPABILITY_FRAMERATE` | `HFI_CAPABILITY_FRAMERATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 575--575 | `case:HFI_CAPABILITY_SCALE_X` | `HFI_CAPABILITY_SCALE_X` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 576--577 | `chunk:576` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 578--580 | `case:HFI_CAPABILITY_SCALE_Y` | `HFI_CAPABILITY_SCALE_Y` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 581--583 | `case:HFI_CAPABILITY_BITRATE` | `HFI_CAPABILITY_BITRATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 584--586 | `case:HFI_CAPABILITY_BFRAME` | `HFI_CAPABILITY_BFRAME` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 587--589 | `case:HFI_CAPABILITY_PEAKBITRATE` | `HFI_CAPABILITY_PEAKBITRATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 590--592 | `case:HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 593--595 | `case:HFI_CAPABILITY_ENC_LTR_COUNT` | `HFI_CAPABILITY_ENC_LTR_COUNT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 596--598 | `case:HFI_CAPABILITY_CP_OUTPUT2_THRESH` | `HFI_CAPABILITY_CP_OUTPUT2_THRESH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 599--600 | `case:HFI_CAPABILITY_HIER_B_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_B_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 601--601 | `chunk:601` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 602--604 | `case:HFI_CAPABILITY_LCU_SIZE` | `HFI_CAPABILITY_LCU_SIZE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 605--607 | `case:HFI_CAPABILITY_HIER_P_HYBRID_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_P_HYBRID_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 608--610 | `case:HFI_CAPABILITY_MBS_PER_SECOND_POWERSAVE` | `HFI_CAPABILITY_MBS_PER_SECOND_POWERSAVE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 611--613 | `case:HFI_CAPABILITY_EXTRADATA` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 614--616 | `case:HFI_CAPABILITY_PROFILE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 617--619 | `case:HFI_CAPABILITY_LEVEL` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 620--622 | `case:HFI_CAPABILITY_I_FRAME_QP` | `HFI_CAPABILITY_I_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 623--625 | `case:HFI_CAPABILITY_P_FRAME_QP` | `HFI_CAPABILITY_P_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 626--628 | `case:HFI_CAPABILITY_B_FRAME_QP, chunk:626` | `HFI_CAPABILITY_B_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 629--631 | `case:HFI_CAPABILITY_RATE_CONTROL_MODES` | `HFI_CAPABILITY_RATE_CONTROL_MODES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 632--634 | `case:HFI_CAPABILITY_BLUR_WIDTH` | `HFI_CAPABILITY_BLUR_WIDTH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 635--637 | `case:HFI_CAPABILITY_BLUR_HEIGHT` | `HFI_CAPABILITY_BLUR_HEIGHT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 638--640 | `case:HFI_CAPABILITY_ROTATION` | `HFI_CAPABILITY_ROTATION` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 641--643 | `case:HFI_CAPABILITY_COLOR_SPACE_CONVERSION` | `HFI_CAPABILITY_COLOR_SPACE_CONVERSION` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 644--646 | `case:HFI_CAPABILITY_SLICE_DELIVERY_MODES` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 647--649 | `case:HFI_CAPABILITY_SLICE_BYTE` | `HFI_CAPABILITY_SLICE_BYTE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 650--650 | `case:HFI_CAPABILITY_SLICE_MB` | `HFI_CAPABILITY_SLICE_MB` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 651--652 | `chunk:651` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 653--655 | `case:HFI_CAPABILITY_SECURE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 656--658 | `case:HFI_CAPABILITY_MAX_NUM_B_FRAMES` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 659--661 | `case:HFI_CAPABILITY_MAX_VIDEOCORES` | `HFI_CAPABILITY_MAX_VIDEOCORES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 662--664 | `case:HFI_CAPABILITY_MAX_WORKMODES` | `HFI_CAPABILITY_MAX_WORKMODES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 665--667 | `case:HFI_CAPABILITY_UBWC_CR_STATS` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 668--675 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 676--676 | `chunk:676` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 677--689 | `f:copy_cap_prop` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 690--692 | `case:HFI_CAPABILITY_FRAME_WIDTH` | `HFI_CAPABILITY_FRAME_WIDTH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 693--695 | `case:HFI_CAPABILITY_FRAME_HEIGHT` | `HFI_CAPABILITY_FRAME_HEIGHT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 696--698 | `case:HFI_CAPABILITY_MBS_PER_FRAME` | `HFI_CAPABILITY_MBS_PER_FRAME` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 699--700 | `case:HFI_CAPABILITY_MBS_PER_SECOND` | `HFI_CAPABILITY_MBS_PER_SECOND` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 701--701 | `chunk:701` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 702--704 | `case:HFI_CAPABILITY_FRAMERATE` | `HFI_CAPABILITY_FRAMERATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 705--707 | `case:HFI_CAPABILITY_SCALE_X` | `HFI_CAPABILITY_SCALE_X` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 708--710 | `case:HFI_CAPABILITY_SCALE_Y` | `HFI_CAPABILITY_SCALE_Y` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 711--713 | `case:HFI_CAPABILITY_BITRATE` | `HFI_CAPABILITY_BITRATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 714--716 | `case:HFI_CAPABILITY_BFRAME` | `HFI_CAPABILITY_BFRAME` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 717--719 | `case:HFI_CAPABILITY_PEAKBITRATE` | `HFI_CAPABILITY_PEAKBITRATE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 720--722 | `case:HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_P_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 723--725 | `case:HFI_CAPABILITY_ENC_LTR_COUNT` | `HFI_CAPABILITY_ENC_LTR_COUNT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 726--728 | `case:HFI_CAPABILITY_CP_OUTPUT2_THRESH, chunk:726` | `HFI_CAPABILITY_CP_OUTPUT2_THRESH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 729--731 | `case:HFI_CAPABILITY_HIER_B_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_B_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 732--734 | `case:HFI_CAPABILITY_LCU_SIZE` | `HFI_CAPABILITY_LCU_SIZE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 735--737 | `case:HFI_CAPABILITY_HIER_P_HYBRID_NUM_ENH_LAYERS` | `HFI_CAPABILITY_HIER_P_HYBRID_NUM_ENH_LAYERS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 738--740 | `case:HFI_CAPABILITY_MBS_PER_SECOND_POWERSAVE` | `HFI_CAPABILITY_MBS_PER_SECOND_POWERSAVE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 741--743 | `case:HFI_CAPABILITY_EXTRADATA` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 744--746 | `case:HFI_CAPABILITY_PROFILE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 747--749 | `case:HFI_CAPABILITY_LEVEL` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 750--750 | `case:HFI_CAPABILITY_I_FRAME_QP` | `HFI_CAPABILITY_I_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 751--752 | `chunk:751` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 753--755 | `case:HFI_CAPABILITY_P_FRAME_QP` | `HFI_CAPABILITY_P_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 756--758 | `case:HFI_CAPABILITY_B_FRAME_QP` | `HFI_CAPABILITY_B_FRAME_QP` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 759--761 | `case:HFI_CAPABILITY_RATE_CONTROL_MODES` | `HFI_CAPABILITY_RATE_CONTROL_MODES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 762--764 | `case:HFI_CAPABILITY_BLUR_WIDTH` | `HFI_CAPABILITY_BLUR_WIDTH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 765--767 | `case:HFI_CAPABILITY_BLUR_HEIGHT` | `HFI_CAPABILITY_BLUR_HEIGHT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 768--770 | `case:HFI_CAPABILITY_ROTATION` | `HFI_CAPABILITY_ROTATION` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 771--773 | `case:HFI_CAPABILITY_COLOR_SPACE_CONVERSION` | `HFI_CAPABILITY_COLOR_SPACE_CONVERSION` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 774--775 | `case:HFI_CAPABILITY_SLICE_DELIVERY_MODES` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 776--776 | `chunk:776` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 777--779 | `case:HFI_CAPABILITY_SLICE_BYTE` | `HFI_CAPABILITY_SLICE_BYTE` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 780--782 | `case:HFI_CAPABILITY_SLICE_MB` | `HFI_CAPABILITY_SLICE_MB` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 783--785 | `case:HFI_CAPABILITY_SECURE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 786--788 | `case:HFI_CAPABILITY_MAX_NUM_B_FRAMES` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 789--791 | `case:HFI_CAPABILITY_MAX_VIDEOCORES` | `HFI_CAPABILITY_MAX_VIDEOCORES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 792--794 | `case:HFI_CAPABILITY_MAX_WORKMODES` | `HFI_CAPABILITY_MAX_WORKMODES` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 795--797 | `case:HFI_CAPABILITY_UBWC_CR_STATS` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 798--800 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 801--811 | `chunk:801` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 812--825 | `f:hfi_fill_codec_info` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 826--850 | `chunk:826` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 851--875 | `chunk:851` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 876--897 | `chunk:876` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 898--900 | `f:copy_profile_caps_to_sessions` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 901--925 | `chunk:901` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 926--938 | `chunk:926` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 939--950 | `f:copy_caps_to_sessions` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 951--973 | `chunk:951` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 974--975 | `f:copy_nal_stream_format_caps_to_sessions` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 976--1000 | `chunk:976` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1001--1004 | `chunk:1001` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1005--1013 | `f:hfi_parse_init_done_properties` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1014--1020 | `d:VALIDATE_PROPERTY_STRUCTURE_SIZE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1021--1025 | `d:VALIDATE_PROPERTY_PAYLOAD_SIZE` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1026--1035 | `chunk:1026` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1036--1050 | `case:HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED` | `HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1051--1051 | `chunk:1051` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1052--1075 | `case:HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED` | `HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1076--1076 | `chunk:1076` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1077--1100 | `case:HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED` | `HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1101--1121 | `chunk:1101` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1122--1125 | `case:HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED` | `HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1126--1140 | `chunk:1126` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1141--1150 | `case:HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED` | `HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1151--1173 | `chunk:1151` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1174--1175 | `case:HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED` | `HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1176--1193 | `chunk:1176` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1194--1200 | `case:HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT` | `HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1201--1202 | `chunk:1201` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1203--1212 | `case:HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH` | `HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1213--1224 | `case:HFI_PROPERTY_TME_VERSION_SUPPORTED` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1225--1225 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1226--1242 | `chunk:1226` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1243--1250 | `f:hfi_process_sys_init_done_prop_read` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1251--1275 | `chunk:1251` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1276--1300 | `chunk:1276` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1301--1308 | `chunk:1301` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1309--1325 | `f:hfi_process_sess_get_prop_buf_req` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1326--1345 | `chunk:1326` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1346--1350 | `case:HFI_BUFFER_INPUT` | `HFI_BUFFER_INPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1351--1355 | `case:HFI_BUFFER_OUTPUT, chunk:1351` | `HFI_BUFFER_OUTPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1356--1360 | `case:HFI_BUFFER_OUTPUT2` | `HFI_BUFFER_OUTPUT2` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1361--1366 | `case:HFI_BUFFER_EXTRADATA_INPUT` | `HFI_BUFFER_EXTRADATA_INPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1367--1372 | `case:HFI_BUFFER_EXTRADATA_OUTPUT` | `HFI_BUFFER_EXTRADATA_OUTPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1373--1375 | `case:HFI_BUFFER_EXTRADATA_OUTPUT2` | `HFI_BUFFER_EXTRADATA_OUTPUT2` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1376--1378 | `chunk:1376` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1379--1384 | `case:HFI_BUFFER_COMMON_INTERNAL_SCRATCH` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1385--1390 | `case:HFI_BUFFER_COMMON_INTERNAL_SCRATCH_1` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1391--1396 | `case:HFI_BUFFER_COMMON_INTERNAL_SCRATCH_2` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1397--1400 | `case:HFI_BUFFER_INTERNAL_PERSIST` | `HFI_BUFFER_INTERNAL_PERSIST` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1401--1402 | `chunk:1401` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1403--1408 | `case:HFI_BUFFER_INTERNAL_PERSIST_1` | `HFI_BUFFER_INTERNAL_PERSIST_1` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1409--1414 | `case:HFI_BUFFER_COMMON_INTERNAL_RECON` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1415--1425 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1426--1447 | `chunk:1426, f:hfi_process_session_prop_info` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1448--1450 | `case:HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1451--1459 | `chunk:1451` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1460--1467 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1468--1475 | `f:hfi_process_session_init_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1476--1495 | `chunk:1476` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1496--1500 | `f:hfi_process_session_load_res_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1501--1524 | `chunk:1501` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1525--1525 | `f:hfi_process_session_flush_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1526--1547 | `chunk:1526` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1548--1550 | `case:HFI_FLUSH_OUTPUT` | `HFI_FLUSH_OUTPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1551--1553 | `case:HFI_FLUSH_INPUT, chunk:1551` | `HFI_FLUSH_INPUT` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1554--1556 | `case:HFI_FLUSH_ALL` | `HFI_FLUSH_ALL` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1557--1568 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1569--1575 | `f:hfi_process_session_etb_done` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1576--1600 | `chunk:1576` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1601--1624 | `chunk:1601` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1625--1625 | `label:bad_packet_size` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1626--1630 | `chunk:1626` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1631--1650 | `f:hfi_process_session_ftb_done` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 1651--1675 | `chunk:1651` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1676--1700 | `chunk:1676` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1701--1725 | `chunk:1701` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1726--1750 | `chunk:1726` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1751--1759 | `chunk:1751` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1760--1775 | `f:hfi_process_session_start_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1776--1786 | `chunk:1776` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1787--1800 | `f:hfi_process_session_stop_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1801--1814 | `chunk:1801` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1815--1825 | `f:hfi_process_session_rel_res_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1826--1842 | `chunk:1826` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1843--1850 | `f:hfi_process_session_rel_buf_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1851--1871 | `chunk:1851` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1872--1875 | `f:hfi_process_session_register_buffer_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1876--1899 | `chunk:1876` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1900--1900 | `f:hfi_process_session_unregister_buffer_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1901--1925 | `chunk:1901` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1926--1927 | `chunk:1926` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1928--1950 | `f:hfi_process_session_end_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1951--1953 | `chunk:1951` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1954--1975 | `f:hfi_process_session_abort_done` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1976--1980 | `chunk:1976` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 1981--2000 | `f:hfi_process_sys_get_prop_image_version` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 2001--2022 | `chunk:2001` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2023--2025 | `f:hfi_process_sys_property_info` | `—` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 2026--2041 | `chunk:2026` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2042--2045 | `case:HFI_PROPERTY_SYS_IMAGE_VERSION` | `HFI_PROPERTY_SYS_IMAGE_VERSION` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 2046--2048 | `field:response_type` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2049--2050 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2051--2057 | `chunk:2051` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2058--2062 | `f:hfi_process_ignore` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2063--2068 | `field:response_type` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2069--2075 | `f:hfi_process_msg_packet` | `hfi_process_msg_packet` | 健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。 |
| 2076--2082 | `chunk:2076` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2083--2085 | `case:HFI_MSG_EVENT_NOTIFY` | `HFI_MSG_EVENT_NOTIFY` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2086--2088 | `case:HFI_MSG_SYS_INIT_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2089--2091 | `case:HFI_MSG_SYS_SESSION_INIT_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2092--2094 | `case:HFI_MSG_SYS_PROPERTY_INFO` | `HFI_MSG_SYS_PROPERTY_INFO` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 2095--2097 | `case:HFI_MSG_SYS_SESSION_END_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2098--2100 | `case:HFI_MSG_SESSION_LOAD_RESOURCES_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2101--2103 | `case:HFI_MSG_SESSION_START_DONE, chunk:2101` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2104--2106 | `case:HFI_MSG_SESSION_STOP_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2107--2109 | `case:HFI_MSG_SESSION_EMPTY_BUFFER_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2110--2112 | `case:HFI_MSG_SESSION_FILL_BUFFER_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2113--2115 | `case:HFI_MSG_SESSION_FLUSH_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2116--2118 | `case:HFI_MSG_SESSION_PROPERTY_INFO` | `HFI_MSG_SESSION_PROPERTY_INFO` | 部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。 |
| 2119--2121 | `case:HFI_MSG_SESSION_RELEASE_RESOURCES_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2122--2124 | `case:HFI_MSG_SYS_RELEASE_RESOURCE` | `HFI_MSG_SYS_RELEASE_RESOURCE` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2125--2125 | `case:HFI_MSG_SESSION_RELEASE_BUFFERS_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2126--2127 | `chunk:2126` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2128--2131 | `case:HFI_MSG_SESSION_REGISTER_BUFFERS_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2132--2135 | `case:HFI_MSG_SESSION_UNREGISTER_BUFFERS_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2136--2138 | `case:HFI_MSG_SYS_SESSION_ABORT_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2139--2141 | `case:HFI_MSG_SESSION_SYNC_DONE` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |
| 2142--2150 | `case:default` | `—` | 公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。 |

覆盖校验：2150/2150 行，连续、无空洞、无重叠。

## `Kconfig`

- 原厂物理行：10；当前语义落点：`qcom/venus/Kconfig`；默认判定：**架构替代**。
- 文件级结论：保持单一主线 Venus 驱动。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--10 | `file:start` | `—` | 架构替代：保持单一主线 Venus 驱动。 |

覆盖校验：10/10 行，连续、无空洞、无重叠。

## `Makefile`

- 原厂物理行：23；当前语义落点：`qcom/venus/Makefile`；默认判定：**架构替代**。
- 文件级结论：保持 core/decoder/encoder 模块拆分。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--23 | `file:start` | `—` | 架构替代：保持 core/decoder/encoder 模块拆分。 |

覆盖校验：23/23 行，连续、无空洞、无重叠。

## `msm_cvp.c`

- 原厂物理行：635；当前语义落点：`无通用 Venus 用户 ABI`；默认判定：**不迁移**。
- 文件级结论：CVP/TME 是 Android/Qualcomm 私有工作流；MVS1 仅保留为共享资源。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--15 | `file:start` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 16--16 | `d:MSM_VIDC_NOMINAL_CYCLES` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 17--17 | `d:MSM_VIDC_UHD60E_VPSS_CYCLES` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 18--18 | `d:MSM_VIDC_UHD60E_ISE_CYCLES` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 19--20 | `d:MAX_CVP_VPSS_CYCLES` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 21--23 | `d:MAX_CVP_ISE_CYCLES` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 24--25 | `f:print_client_buffer` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 26--35 | `chunk:26` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 36--48 | `f:print_cvp_buffer` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 49--50 | `f:get_hal_buftype` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 51--67 | `chunk:51` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 68--75 | `f:handle_session_register_buffer_done` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 76--100 | `chunk:76` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 101--114 | `chunk:101` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 115--118 | `label:exit` | `exit` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 119--125 | `f:handle_session_unregister_buffer_done` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 126--150 | `chunk:126` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 151--175 | `chunk:151` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 176--177 | `chunk:176` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 178--181 | `label:exit` | `exit` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 182--200 | `f:print_cvp_cycles` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 201--202 | `chunk:201` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 203--225 | `f:msm_cvp_check_session_supported` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 226--232 | `chunk:226` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 233--250 | `f:msm_cvp_scale_clocks_and_bus` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 251--257 | `chunk:251` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 258--261 | `label:exit` | `exit` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 262--275 | `f:msm_cvp_get_session_info` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 276--277 | `chunk:276` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 278--300 | `f:msm_cvp_request_power` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 301--325 | `chunk:301` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 326--336 | `chunk:326` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 337--340 | `label:exit` | `exit` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 341--350 | `f:msm_cvp_register_buffer` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 351--375 | `chunk:351` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 376--400 | `chunk:376` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 401--407 | `chunk:401` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 408--419 | `label:exit` | `exit` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 420--425 | `f:msm_cvp_unregister_buffer` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 426--450 | `chunk:426` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 451--466 | `chunk:451` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 467--475 | `f:msm_vidc_cvp` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 476--476 | `chunk:476` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 477--484 | `case:MSM_CVP_GET_SESSION_INFO` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 485--492 | `case:MSM_CVP_REQUEST_POWER` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 493--500 | `case:MSM_CVP_REGISTER_BUFFER` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 501--508 | `case:MSM_CVP_UNREGISTER_BUFFER, chunk:501` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 509--518 | `case:default` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 519--520 | `v:msm_cvp_ctrls` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 521--521 | `field:id` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 522--522 | `field:name` | `name` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 523--523 | `field:type` | `type` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 524--524 | `field:minimum` | `minimum` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 525--525 | `field:maximum` | `maximum` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 526--526 | `chunk:526, field:default_value` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 527--527 | `field:step` | `step` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 528--528 | `field:menu_skip_mask` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 529--532 | `field:qmenu` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 533--539 | `f:msm_cvp_ctrl_init` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 540--550 | `f:msm_cvp_inst_pause` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 551--558 | `chunk:551` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 559--575 | `f:msm_cvp_inst_resume` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 576--577 | `chunk:576` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 578--600 | `f:msm_cvp_inst_deinit` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 601--615 | `chunk:601` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 616--625 | `f:msm_cvp_inst_init` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 626--635 | `chunk:626` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |

覆盖校验：635/635 行，连续、无空洞、无重叠。

## `msm_cvp.h`

- 原厂物理行：33；当前语义落点：`无通用 Venus 用户 ABI`；默认判定：**不迁移**。
- 文件级结论：不把 CVP 私有接口加入主线 V4L2 ABI。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 14--25 | `pp:ifndef _MSM_VIDC_CVP_H_` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 26--32 | `chunk:26` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |
| 33--33 | `pp:endif` | `—` | 不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。 |

覆盖校验：33/33 行，连续、无空洞、无重叠。

## `msm_smem.c`

- 原厂物理行：606；当前语义落点：`VB2 dma-contig + DMA API + IOMMU/DT`；默认判定：**部分迁移**。
- 文件级结论：所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 26--27 | `chunk:26` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 28--50 | `f:msm_dma_get_device_address` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 51--75 | `chunk:51` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 76--100 | `chunk:76` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 101--125 | `chunk:101` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 126--127 | `chunk:126, label:mem_map_sg_failed` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 128--129 | `label:mem_map_table_failed` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 130--130 | `label:mem_buf_size_mismatch` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 131--131 | `label:mem_buf_attach_failed` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 132--135 | `label:mem_map_failed` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 136--150 | `f:msm_dma_put_device_address` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 151--170 | `chunk:151` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 171--175 | `f:msm_smem_get_dma_buf` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 176--184 | `chunk:176` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 185--196 | `f:msm_smem_put_dma_buf` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 197--200 | `f:msm_smem_map_dma_buf` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 201--225 | `chunk:201` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 226--250 | `chunk:226` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 251--257 | `chunk:251` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 258--261 | `label:exit` | `exit` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 262--275 | `f:msm_smem_unmap_dma_buf` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 276--295 | `chunk:276` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 296--299 | `label:exit` | `exit` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 300--300 | `f:get_secure_flag_for_buffer_type` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 301--303 | `chunk:301` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 304--308 | `case:HAL_BUFFER_INPUT` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 309--309 | `case:HAL_BUFFER_OUTPUT` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 310--314 | `case:HAL_BUFFER_OUTPUT2` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 315--316 | `case:HAL_BUFFER_INTERNAL_SCRATCH` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 317--318 | `case:HAL_BUFFER_INTERNAL_SCRATCH_1` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 319--320 | `case:HAL_BUFFER_INTERNAL_SCRATCH_2` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 321--325 | `case:HAL_BUFFER_INTERNAL_PERSIST` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 326--327 | `case:HAL_BUFFER_INTERNAL_PERSIST_1, chunk:326` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 328--334 | `case:default` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 335--350 | `f:alloc_dma_mem` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 351--375 | `chunk:351` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 376--400 | `chunk:376` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 401--425 | `chunk:401` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 426--445 | `chunk:426` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 446--448 | `label:fail_map` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 449--450 | `label:fail_device_address` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 451--454 | `chunk:451, label:fail_shared_mem_alloc` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 455--475 | `f:free_dma_mem` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 476--488 | `chunk:476` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 489--500 | `f:msm_smem_alloc` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 501--507 | `chunk:501` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 508--520 | `f:msm_smem_free` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 521--525 | `f:msm_smem_cache_operations` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 526--542 | `chunk:526` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 543--543 | `case:SMEM_CACHE_CLEAN` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 544--550 | `case:SMEM_CACHE_CLEAN_INVALIDATE` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 551--551 | `chunk:551` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 552--559 | `case:SMEM_CACHE_INVALIDATE` | `—` | P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。 |
| 560--569 | `case:default` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 570--575 | `f:msm_smem_get_context_bank` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 576--600 | `chunk:576` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |
| 601--606 | `chunk:601` | `—` | 所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。 |

覆盖校验：606/606 行，连续、无空洞、无重叠。

## `msm_v4l2_private.c`

- 原厂物理行：234；当前语义落点：`标准 V4L2 controls/events`；默认判定：**选择性迁移**。
- 文件级结论：只迁有标准表达且有消费者的语义；不复制私有 ioctl 翻译层。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--15 | `file:start` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 16--25 | `f:convert_from_user` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 26--30 | `chunk:26` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 31--43 | `case:MSM_CVP_GET_SESSION_INFO` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 44--50 | `case:MSM_CVP_REQUEST_POWER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 51--59 | `chunk:51` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 60--75 | `case:MSM_CVP_REGISTER_BUFFER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 76--78 | `chunk:76` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 79--97 | `case:MSM_CVP_UNREGISTER_BUFFER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 98--100 | `case:default` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 101--107 | `chunk:101` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 108--122 | `f:convert_to_user` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 123--125 | `case:MSM_CVP_GET_SESSION_INFO` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 126--135 | `chunk:126` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 136--150 | `case:MSM_CVP_REQUEST_POWER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 151--151 | `chunk:151` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 152--170 | `case:MSM_CVP_REGISTER_BUFFER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 171--175 | `case:MSM_CVP_UNREGISTER_BUFFER` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 176--189 | `chunk:176` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 190--199 | `case:default` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 200--200 | `f:msm_v4l2_private` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 201--225 | `chunk:201` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 226--234 | `chunk:226` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |

覆盖校验：234/234 行，连续、无空洞、无重叠。

## `msm_v4l2_private.h`

- 原厂物理行：22；当前语义落点：`标准 V4L2 UAPI`；默认判定：**不直接迁移**。
- 文件级结论：避免新增无人维护的 Android 私有 UAPI。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 14--21 | `pp:ifndef _MSM_V4L2_PRIVATE_H_` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |
| 22--22 | `pp:endif` | `—` | 私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。 |

覆盖校验：22/22 行，连续、无空洞、无重叠。

## `msm_v4l2_vidc.c`

- 原厂物理行：928；当前语义落点：`core.c + vdec.c + venc.c + V4L2 M2M/VB2`；默认判定：**架构替代**。
- 文件级结论：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 26--37 | `chunk:26` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 38--39 | `d:BASE_DEVICE_NUMBER` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 40--42 | `v:vidc_driver` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 43--50 | `f:get_vidc_inst` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 51--72 | `chunk:51, f:msm_v4l2_open` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 73--75 | `f:msm_v4l2_close` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 76--86 | `chunk:76` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 87--94 | `f:msm_v4l2_querycap` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 95--100 | `f:msm_v4l2_enum_fmt` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 101--102 | `chunk:101` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 103--110 | `f:msm_v4l2_s_fmt` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 111--118 | `f:msm_v4l2_g_fmt` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 119--125 | `f:msm_v4l2_s_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 126--126 | `chunk:126` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 127--134 | `f:msm_v4l2_g_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 135--142 | `f:msm_v4l2_s_ext_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 143--150 | `f:msm_v4l2_g_ext_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 151--158 | `chunk:151, f:msm_v4l2_reqbufs` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 159--164 | `f:msm_v4l2_qbuf` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 165--170 | `f:msm_v4l2_dqbuf` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 171--175 | `f:msm_v4l2_streamon` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 176--178 | `chunk:176` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 179--186 | `f:msm_v4l2_streamoff` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 187--195 | `f:msm_v4l2_subscribe_event` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 196--200 | `f:msm_v4l2_unsubscribe_event` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 201--204 | `chunk:201` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 205--212 | `f:msm_v4l2_decoder_cmd` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 213--219 | `f:msm_v4l2_encoder_cmd` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 220--225 | `f:msm_v4l2_s_parm` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 226--226 | `chunk:226` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 227--232 | `f:msm_v4l2_g_parm` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 233--240 | `f:msm_v4l2_g_crop` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 241--248 | `f:msm_v4l2_enum_framesizes` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 249--250 | `f:msm_v4l2_queryctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 251--256 | `chunk:251` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 257--264 | `f:msm_v4l2_default` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 265--265 | `v:msm_v4l2_ioctl_ops` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 266--266 | `field:vidioc_querycap` | `vidioc_querycap` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 267--267 | `field:vidioc_enum_fmt_vid_cap_mplane` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 268--268 | `field:vidioc_enum_fmt_vid_out_mplane` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 269--269 | `field:vidioc_s_fmt_vid_cap_mplane` | `vidioc_s_fmt_vid_cap_mplane` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 270--270 | `field:vidioc_s_fmt_vid_out_mplane` | `vidioc_s_fmt_vid_out_mplane` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 271--271 | `field:vidioc_g_fmt_vid_cap_mplane` | `vidioc_g_fmt_vid_cap_mplane` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 272--272 | `field:vidioc_g_fmt_vid_out_mplane` | `vidioc_g_fmt_vid_out_mplane` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 273--273 | `field:vidioc_reqbufs` | `vidioc_reqbufs` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 274--274 | `field:vidioc_qbuf` | `vidioc_qbuf` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 275--275 | `field:vidioc_dqbuf` | `vidioc_dqbuf` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 276--276 | `chunk:276, field:vidioc_streamon` | `vidioc_streamon` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 277--277 | `field:vidioc_streamoff` | `vidioc_streamoff` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 278--278 | `field:vidioc_s_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 279--279 | `field:vidioc_g_ctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 280--280 | `field:vidioc_queryctrl` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 281--281 | `field:vidioc_s_ext_ctrls` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 282--282 | `field:vidioc_g_ext_ctrls` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 283--283 | `field:vidioc_subscribe_event` | `vidioc_subscribe_event` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 284--284 | `field:vidioc_unsubscribe_event` | `vidioc_unsubscribe_event` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 285--285 | `field:vidioc_decoder_cmd` | `vidioc_decoder_cmd` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 286--286 | `field:vidioc_encoder_cmd` | `vidioc_encoder_cmd` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 287--287 | `field:vidioc_s_parm` | `vidioc_s_parm` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 288--288 | `field:vidioc_g_parm` | `vidioc_g_parm` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 289--289 | `field:vidioc_g_crop` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 290--290 | `field:vidioc_enum_framesizes` | `vidioc_enum_framesizes` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 291--293 | `field:vidioc_default` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 294--296 | `v:msm_v4l2_enc_ioctl_ops` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 297--300 | `f:msm_v4l2_poll` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 301--304 | `chunk:301` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 305--305 | `v:msm_v4l2_vidc_fops` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 306--306 | `field:owner` | `owner` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 307--307 | `field:open` | `open` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 308--308 | `field:release` | `release` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 309--309 | `field:unlocked_ioctl` | `unlocked_ioctl` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 310--310 | `field:compat_ioctl32` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 311--313 | `field:poll` | `poll` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 314--317 | `f:msm_vidc_release_video_device` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 318--325 | `f:read_platform_resources` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 326--341 | `chunk:326` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 342--350 | `f:msm_vidc_initialize_core` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 351--371 | `chunk:351` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 372--375 | `f:msm_vidc_link_name_show` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 376--392 | `chunk:376` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 393--400 | `f:store_pwr_collapse_delay` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 401--413 | `chunk:401` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 414--425 | `f:show_pwr_collapse_delay` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 426--430 | `chunk:426` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 431--437 | `f:show_thermal_level` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 438--450 | `f:store_thermal_level` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 451--463 | `chunk:451` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 464--470 | `f:show_sku_version` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 471--475 | `f:store_sku_version` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 476--481 | `chunk:476` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 482--488 | `v:msm_vidc_core_attrs` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 489--489 | `v:msm_vidc_core_attr_group` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 490--492 | `field:attrs` | `attrs` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 493--499 | `v:msm_vidc_dt_match` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 500--500 | `f:msm_vidc_register_video_device` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 501--525 | `chunk:501` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 526--527 | `chunk:526` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 528--550 | `f:msm_vidc_probe_vidc_device` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 551--575 | `chunk:551` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 576--600 | `chunk:576` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 601--625 | `chunk:601` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 626--643 | `chunk:626` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 644--645 | `label:err_fail_sub_device_probe` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 646--650 | `label:err_cores_exceeded` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 651--651 | `chunk:651` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 652--655 | `label:err_cvp` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 656--659 | `label:err_enc` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 660--661 | `label:err_dec` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 662--663 | `label:err_v4l2_register` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 664--669 | `label:err_core_init` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 670--674 | `f:msm_vidc_probe_mem_cdsp` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 675--675 | `f:msm_vidc_probe_context_bank` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 676--679 | `chunk:676` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 680--684 | `f:msm_vidc_probe_bus` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 685--700 | `f:msm_vidc_probe` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 701--709 | `chunk:701` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 710--725 | `f:msm_vidc_remove` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 726--750 | `chunk:726` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 751--775 | `chunk:751, f:msm_vidc_pm_suspend` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 776--781 | `chunk:776` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 782--788 | `f:msm_vidc_pm_resume` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 789--800 | `f:msm_vidc_freeze_core` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 801--825 | `chunk:801` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 826--840 | `chunk:826` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 841--850 | `f:msm_vidc_pm_freeze` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 851--865 | `chunk:851` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 866--866 | `v:msm_vidc_pm_ops` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 867--867 | `field:suspend` | `suspend` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 868--868 | `field:resume` | `resume` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 869--873 | `field:freeze` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 874--874 | `v:msm_vidc_driver` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 875--875 | `field:probe` | `probe` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 876--876 | `chunk:876, field:remove` | `remove` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 877--877 | `field:driver` | `driver` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 878--878 | `field:name` | `name` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 879--879 | `field:owner` | `owner` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 880--880 | `field:of_match_table` | `of_match_table` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 881--884 | `field:pm` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 885--900 | `f:msm_vidc_init` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 901--915 | `chunk:901` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 916--924 | `f:msm_vidc_exit` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 925--925 | `v:msm_vidc_init` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |
| 926--928 | `chunk:926, v:msm_vidc_exit` | `—` | 架构替代：ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。 |

覆盖校验：928/928 行，连续、无空洞、无重叠。

## `msm_vdec.c`

- 原厂物理行：1422；当前语义落点：`vdec.c + vdec_ctrls.c + helpers.c`；默认判定：**部分迁移**。
- 文件级结论：H264/Main8 已过；Main10/P010、metadata、完整矩阵仍欠。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--21 | `file:start` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 22--22 | `d:MSM_VDEC_DVC_NAME` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 23--23 | `d:MIN_NUM_THUMBNAIL_MODE_OUTPUT_BUFFERS` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 24--24 | `d:MIN_NUM_THUMBNAIL_MODE_CAPTURE_BUFFERS` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 25--25 | `d:MIN_NUM_DEC_OUTPUT_BUFFERS` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 26--27 | `chunk:26, d:MIN_NUM_DEC_CAPTURE_BUFFERS` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 28--28 | `d:DEFAULT_VIDEO_CONCEAL_COLOR_BLACK` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 29--29 | `d:MB_SIZE_IN_PIXEL` | `MB_SIZE_IN_PIXEL` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 30--30 | `d:OPERATING_FRAME_RATE_STEP` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 31--31 | `d:MAX_VP9D_INST_COUNT` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 32--33 | `d:MAX_4K_MBPF` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 34--41 | `v:mpeg_video_stream_format` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 42--46 | `v:mpeg_video_output_order` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 47--50 | `v:mpeg_vidc_video_alloc_mode_type` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 51--51 | `chunk:51` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 52--57 | `v:perf_level` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 58--65 | `v:vp8_profile_level` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 66--71 | `v:vp9_profile` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 72--75 | `v:vp9_level` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 76--87 | `chunk:76` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 88--93 | `v:mpeg2_profile` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 94--99 | `v:mpeg2_level` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 100--100 | `v:mpeg_vidc_video_entropy_mode` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 101--104 | `chunk:101` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 105--110 | `v:mpeg_vidc_video_dpb_color_format` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 111--112 | `v:msm_vdec_ctrls` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 113--113 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 114--114 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 115--115 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 116--116 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 117--117 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 118--118 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 119--122 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 123--125 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 126--126 | `chunk:126, field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 127--127 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 128--128 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 129--129 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 130--132 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 133--135 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 136--136 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 137--137 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 138--140 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 141--141 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 142--142 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 143--143 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 144--144 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 145--145 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 146--146 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 147--149 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 150--150 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 151--151 | `chunk:151, field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 152--152 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 153--153 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 154--154 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 155--155 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 156--156 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 157--157 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 158--160 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 161--161 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 162--162 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 163--163 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 164--164 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 165--165 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 166--166 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 167--175 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 176--187 | `chunk:176` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 188--190 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 191--191 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 192--192 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 193--193 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 194--195 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 196--197 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 198--199 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 200--200 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 201--201 | `chunk:201, field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 202--204 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 205--205 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 206--206 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 207--207 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 208--208 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 209--209 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 210--210 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 211--211 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 212--214 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 215--215 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 216--216 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 217--217 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 218--218 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 219--219 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 220--222 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 223--223 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 224--225 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 226--226 | `chunk:226` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 227--227 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 228--228 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 229--229 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 230--230 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 231--231 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 232--232 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 233--233 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 234--234 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 235--237 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 238--238 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 239--239 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 240--240 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 241--241 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 242--242 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 243--243 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 244--244 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 245--245 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 246--248 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 249--249 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 250--250 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 251--251 | `chunk:251, field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 252--252 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 253--253 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 254--254 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 255--255 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 256--256 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 257--259 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 260--260 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 261--261 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 262--262 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 263--263 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 264--264 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 265--265 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 266--270 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 271--271 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 272--274 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 275--275 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 276--276 | `chunk:276, field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 277--277 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 278--278 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 279--279 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 280--280 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 281--286 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 287--287 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 288--290 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 291--291 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 292--292 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 293--293 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 294--294 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 295--295 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 296--296 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 297--299 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 300--300 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 301--301 | `chunk:301, field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 302--302 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 303--303 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 304--304 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 305--305 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 306--308 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 309--309 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 310--310 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 311--311 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 312--312 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 313--313 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 314--314 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 315--315 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 316--316 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 317--319 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 320--320 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 321--321 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 322--322 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 323--323 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 324--324 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 325--325 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 326--326 | `chunk:326, field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 327--327 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 328--328 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 329--331 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 332--332 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 333--333 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 334--334 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 335--335 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 336--336 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 337--337 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 338--338 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 339--339 | `field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 340--340 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 341--343 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 344--344 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 345--345 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 346--346 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 347--347 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 348--348 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 349--349 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 350--350 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 351--354 | `chunk:351, field:menu_skip_mask` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 355--355 | `field:qmenu` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 356--358 | `field:flags` | `flags` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 359--359 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 360--360 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 361--361 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 362--362 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 363--363 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 364--364 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 365--367 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 368--368 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 369--369 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 370--370 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 371--371 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 372--372 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 373--373 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 374--375 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 376--376 | `chunk:376` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 377--377 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 378--378 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 379--379 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 380--380 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 381--381 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 382--382 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 383--385 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 386--386 | `field:id` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 387--387 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 388--388 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 389--389 | `field:minimum` | `minimum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 390--390 | `field:maximum` | `maximum` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 391--391 | `field:default_value` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 392--395 | `field:step` | `step` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 396--397 | `d:NUM_CTRLS` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 398--400 | `f:get_frame_size_compressed_full_yuv` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 401--413 | `chunk:401` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 414--425 | `f:get_frame_size_compressed` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 426--429 | `chunk:426` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 430--450 | `f:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 451--467 | `chunk:451` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 468--469 | `v:vdec_formats` | `vdec_formats` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 470--470 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 471--471 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 472--472 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 473--473 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 474--475 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 476--476 | `chunk:476` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 477--477 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 478--478 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 479--479 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 480--480 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 481--483 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 484--484 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 485--485 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 486--486 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 487--487 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 488--490 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 491--491 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 492--492 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 493--493 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 494--494 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 495--497 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 498--498 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 499--499 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 500--500 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 501--501 | `chunk:501, field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 502--502 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 503--503 | `field:defer_outputs` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 504--504 | `field:input_min_count` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 505--507 | `field:output_min_count` | `output_min_count` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 508--508 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 509--509 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 510--510 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 511--511 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 512--512 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 513--513 | `field:defer_outputs` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 514--514 | `field:input_min_count` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 515--517 | `field:output_min_count` | `output_min_count` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 518--518 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 519--519 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 520--520 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 521--521 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 522--522 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 523--523 | `field:defer_outputs` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 524--524 | `field:input_min_count` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 525--525 | `field:output_min_count` | `output_min_count` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 526--527 | `chunk:526` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 528--528 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 529--529 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 530--530 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 531--531 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 532--532 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 533--533 | `field:defer_outputs` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 534--534 | `field:input_min_count` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 535--537 | `field:output_min_count` | `output_min_count` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 538--538 | `field:name` | `name` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 539--539 | `field:description` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 540--540 | `field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 541--541 | `field:get_frame_size` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 542--542 | `field:type` | `type` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 543--543 | `field:defer_outputs` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 544--544 | `field:input_min_count` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 545--548 | `field:output_min_count` | `output_min_count` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 549--550 | `v:dec_pix_format_constraints` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 551--551 | `chunk:551, field:fourcc` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 552--552 | `field:num_planes` | `num_planes` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 553--553 | `field:y_stride_multiples` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 554--554 | `field:y_max_stride` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 555--555 | `field:y_min_plane_buffer_height_multiple` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 556--556 | `field:y_buffer_alignment` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 557--557 | `field:uv_stride_multiples` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 558--558 | `field:uv_max_stride` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 559--559 | `field:uv_min_plane_buffer_height_multiple` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 560--563 | `field:uv_buffer_alignment` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 564--575 | `f:msm_vidc_check_for_vp9d_overload` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 576--581 | `chunk:576` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 582--600 | `f:msm_vdec_s_fmt` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 601--625 | `chunk:601` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 626--650 | `chunk:626` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 651--675 | `chunk:651` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 676--700 | `chunk:676` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 701--725 | `chunk:701` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 726--750 | `chunk:726` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 751--754 | `chunk:751` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 755--758 | `label:err_invalid_fmt` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 759--775 | `f:msm_vdec_enum_fmt` | `—` | Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。 |
| 776--789 | `chunk:776` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 790--800 | `f:msm_vdec_inst_init` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 801--825 | `chunk:801` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 826--850 | `chunk:826` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 851--875 | `chunk:851` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 876--889 | `chunk:876` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 890--900 | `f:get_ctrl_from_cluster` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 901--924 | `chunk:901, f:msm_vdec_s_ctrl` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 925--925 | `d:TRY_GET_CTRL` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 926--942 | `chunk:926` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 943--947 | `case:V4L2_CID_MPEG_VIDC_VIDEO_OUTPUT_ORDER` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 948--950 | `case:V4L2_CID_MPEG_VIDC_VIDEO_PICTYPE_DEC_MODE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 951--952 | `chunk:951` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 953--954 | `case:V4L2_CID_MPEG_VIDC_VIDEO_SYNC_FRAME_DECODE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 955--957 | `case:V4L2_MPEG_MSM_VIDC_DISABLE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 958--975 | `case:V4L2_MPEG_MSM_VIDC_ENABLE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 976--1000 | `chunk:976` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1001--1025 | `chunk:1001` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1026--1037 | `chunk:1026` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1038--1050 | `case:V4L2_CID_MPEG_VIDC_VIDEO_SECURE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1051--1054 | `case:V4L2_CID_MPEG_VIDC_VIDEO_EXTRADATA, chunk:1051` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1055--1055 | `case:V4L2_MPEG_VIDC_EXTRADATA_INTERLACE_VIDEO` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1056--1056 | `case:V4L2_MPEG_VIDC_EXTRADATA_TIMESTAMP` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1057--1057 | `case:V4L2_MPEG_VIDC_EXTRADATA_S3D_FRAME_PACKING` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1058--1058 | `case:V4L2_MPEG_VIDC_EXTRADATA_FRAME_RATE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1059--1059 | `case:V4L2_MPEG_VIDC_EXTRADATA_PANSCAN_WINDOW` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1060--1060 | `case:V4L2_MPEG_VIDC_EXTRADATA_RECOVERY_POINT_SEI` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1061--1061 | `case:V4L2_MPEG_VIDC_EXTRADATA_NUM_CONCEALED_MB` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1062--1062 | `case:V4L2_MPEG_VIDC_EXTRADATA_ASPECT_RATIO` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1063--1063 | `case:V4L2_MPEG_VIDC_EXTRADATA_MPEG2_SEQDISP` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1064--1064 | `case:V4L2_MPEG_VIDC_EXTRADATA_STREAM_USERDATA` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1065--1065 | `case:V4L2_MPEG_VIDC_EXTRADATA_FRAME_QP` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1066--1066 | `case:V4L2_MPEG_VIDC_EXTRADATA_OUTPUT_CROP` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1067--1067 | `case:V4L2_MPEG_VIDC_EXTRADATA_DISPLAY_COLOUR_SEI` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1068--1068 | `case:V4L2_MPEG_VIDC_EXTRADATA_CONTENT_LIGHT_LEVEL_SEI` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1069--1069 | `case:V4L2_MPEG_VIDC_EXTRADATA_VUI_DISPLAY` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1070--1070 | `case:V4L2_MPEG_VIDC_EXTRADATA_VPX_COLORSPACE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1071--1075 | `case:V4L2_MPEG_VIDC_EXTRADATA_UBWC_CR_STATS_INFO` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1076--1077 | `chunk:1076` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1078--1084 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1085--1093 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_OUTPUT_MODE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1094--1100 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_OUTPUT_PRIMARY` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1101--1125 | `chunk:1101` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1126--1145 | `chunk:1126` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1146--1147 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_OUTPUT_SECONDARY` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1148--1150 | `case:MSM_VIDC_BIT_DEPTH_8` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1151--1153 | `case:MSM_VIDC_BIT_DEPTH_10, chunk:1151` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1154--1175 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1176--1200 | `chunk:1176` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1201--1225 | `chunk:1201` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1226--1239 | `chunk:1226` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1240--1246 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1247--1250 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1251--1257 | `chunk:1251` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1258--1268 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1269--1274 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BUFFER_SIZE_LIMIT` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1275--1275 | `case:V4L2_CID_MPEG_VIDC_VIDEO_PRIORITY` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1276--1279 | `chunk:1276` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1280--1282 | `case:V4L2_MPEG_MSM_VIDC_DISABLE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1283--1285 | `case:V4L2_MPEG_MSM_VIDC_ENABLE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1286--1292 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1293--1300 | `case:V4L2_CID_MPEG_VIDC_VIDEO_OPERATING_RATE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1301--1315 | `chunk:1301` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1316--1322 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LOWLATENCY_MODE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1323--1325 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1326--1327 | `chunk:1326` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1328--1341 | `d:TRY_GET_CTRL` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1342--1350 | `f:msm_vdec_s_ext_ctrl` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1351--1364 | `chunk:1351` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1365--1374 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_OUTPUT_MODE` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1375--1375 | `case:V4L2_CID_MPEG_VIDC_VIDEO_CONCEAL_COLOR_8BIT` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1376--1378 | `chunk:1376` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1379--1395 | `case:V4L2_CID_MPEG_VIDC_VIDEO_CONCEAL_COLOR_10BIT` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1396--1400 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1401--1404 | `chunk:1401` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1405--1416 | `case:default` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |
| 1417--1422 | `f:msm_vdec_ctrl_init` | `—` | decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。 |

覆盖校验：1422/1422 行，连续、无空洞、无重叠。

## `msm_vdec.h`

- 原厂物理行：29；当前语义落点：`vdec.h + core.h`；默认判定：**架构替代**。
- 文件级结论：声明按主线实例模型重写。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 架构替代：声明按主线实例模型重写。 |
| 13--25 | `pp:ifndef _MSM_VDEC_H_` | `—` | 架构替代：声明按主线实例模型重写。 |
| 26--28 | `chunk:26` | `—` | 架构替代：声明按主线实例模型重写。 |
| 29--29 | `pp:endif` | `—` | 架构替代：声明按主线实例模型重写。 |

覆盖校验：29/29 行，连续、无空洞、无重叠。

## `msm_venc.c`

- 原厂物理行：2926；当前语义落点：`venc.c + venc_ctrls.c + helpers.c`；默认判定：**部分迁移**。
- 文件级结论：属性/启动前缀已核对；首 raw ETB 仍导致整机复位。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--19 | `file:start` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 20--20 | `d:MSM_VENC_DVC_NAME` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 21--21 | `d:MIN_BIT_RATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 22--22 | `d:MAX_BIT_RATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 23--23 | `d:DEFAULT_BIT_RATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 24--24 | `d:BIT_RATE_STEP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 25--25 | `d:DEFAULT_FRAME_RATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 26--26 | `chunk:26, d:OPERATING_FRAME_RATE_STEP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 27--27 | `d:MAX_SLICE_BYTE_SIZE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 28--28 | `d:MIN_SLICE_BYTE_SIZE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 29--29 | `d:MAX_SLICE_MB_SIZE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 30--30 | `d:I_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 31--31 | `d:P_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 32--32 | `d:B_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 33--33 | `d:MAX_INTRA_REFRESH_MBS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 34--34 | `d:MAX_NUM_B_FRAMES` | `MAX_NUM_B_FRAMES` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 35--35 | `d:MAX_LTR_FRAME_COUNT` | `MAX_LTR_FRAME_COUNT` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 36--37 | `d:MAX_HYBRID_HIER_P_LAYERS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 38--38 | `d:L_MODE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 39--39 | `d:MIN_TIME_RESOLUTION` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 40--40 | `d:MAX_TIME_RESOLUTION` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 41--41 | `d:DEFAULT_TIME_RESOLUTION` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 42--42 | `d:MIN_NUM_ENC_OUTPUT_BUFFERS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 43--44 | `d:MIN_NUM_ENC_CAPTURE_BUFFERS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 45--50 | `v:mpeg_video_rate_control` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 51--55 | `chunk:51` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 56--63 | `v:mpeg_video_flip` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 64--70 | `v:h264_video_entropy_cabac_model` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 71--75 | `v:hevc_tier_level` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 76--100 | `chunk:76` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 101--107 | `chunk:101, v:tme_profile` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 108--111 | `v:tme_level` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 112--117 | `v:hevc_profile` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 118--125 | `v:vp8_profile_level` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 126--131 | `chunk:126, v:perf_level` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 132--138 | `v:mbi_statistics` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 139--143 | `v:timestamp_mode` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 144--150 | `v:iframe_sizes` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 151--159 | `chunk:151, v:mpeg_video_stream_format` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 160--165 | `v:roi_map_type` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 166--167 | `v:msm_venc_ctrls` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 168--168 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 169--169 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 170--170 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 171--171 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 172--172 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 173--173 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 174--174 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 175--175 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 176--178 | `chunk:176, field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 179--179 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 180--180 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 181--181 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 182--182 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 183--183 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 184--184 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 185--185 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 186--186 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 187--189 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 190--190 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 191--191 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 192--192 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 193--193 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 194--194 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 195--195 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 196--196 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 197--197 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 198--200 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 201--201 | `chunk:201, field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 202--202 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 203--203 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 204--204 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 205--205 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 206--206 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 207--207 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 208--208 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 209--211 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 212--212 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 213--213 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 214--214 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 215--215 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 216--216 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 217--217 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 218--218 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 219--219 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 220--222 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 223--223 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 224--224 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 225--225 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 226--226 | `chunk:226, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 227--227 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 228--228 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 229--229 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 230--230 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 231--233 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 234--234 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 235--235 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 236--236 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 237--237 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 238--238 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 239--239 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 240--240 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 241--241 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 242--244 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 245--245 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 246--246 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 247--247 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 248--248 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 249--249 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 250--250 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 251--251 | `chunk:251, field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 252--252 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 253--255 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 256--256 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 257--257 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 258--258 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 259--259 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 260--260 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 261--261 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 262--262 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 263--263 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 264--266 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 267--267 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 268--268 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 269--269 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 270--270 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 271--271 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 272--272 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 273--273 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 274--274 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 275--275 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 276--277 | `chunk:276` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 278--278 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 279--279 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 280--280 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 281--281 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 282--282 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 283--283 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 284--284 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 285--285 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 286--288 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 289--289 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 290--290 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 291--291 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 292--292 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 293--293 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 294--294 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 295--295 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 296--296 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 297--299 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 300--300 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 301--301 | `chunk:301, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 302--302 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 303--303 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 304--304 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 305--305 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 306--306 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 307--307 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 308--310 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 311--311 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 312--312 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 313--313 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 314--314 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 315--315 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 316--316 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 317--319 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 320--320 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 321--321 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 322--322 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 323--323 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 324--324 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 325--325 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 326--326 | `chunk:326, field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 327--327 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 328--328 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 329--331 | `field:flags` | `flags` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 332--332 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 333--333 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 334--334 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 335--335 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 336--336 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 337--337 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 338--338 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 339--339 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 340--340 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 341--344 | `field:flags` | `flags` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 345--345 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 346--346 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 347--347 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 348--348 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 349--349 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 350--350 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 351--351 | `chunk:351, field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 352--352 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 353--355 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 356--356 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 357--357 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 358--358 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 359--359 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 360--360 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 361--361 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 362--362 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 363--371 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 372--374 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 375--375 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 376--376 | `chunk:376, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 377--377 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 378--378 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 379--379 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 380--380 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 381--381 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 382--382 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 383--385 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 386--386 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 387--387 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 388--388 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 389--389 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 390--390 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 391--391 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 392--392 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 393--393 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 394--396 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 397--397 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 398--398 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 399--399 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 400--400 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 401--401 | `chunk:401, field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 402--402 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 403--403 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 404--404 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 405--407 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 408--408 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 409--409 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 410--410 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 411--411 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 412--412 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 413--413 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 414--414 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 415--415 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 416--418 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 419--419 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 420--420 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 421--421 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 422--422 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 423--423 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 424--424 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 425--425 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 426--430 | `chunk:426` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 431--431 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 432--432 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 433--433 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 434--434 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 435--435 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 436--436 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 437--439 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 440--440 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 441--441 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 442--442 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 443--443 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 444--444 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 445--445 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 446--448 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 449--449 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 450--450 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 451--451 | `chunk:451, field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 452--452 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 453--453 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 454--454 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 455--455 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 456--458 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 459--459 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 460--460 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 461--461 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 462--462 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 463--463 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 464--464 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 465--469 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 470--472 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 473--473 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 474--474 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 475--475 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 476--476 | `chunk:476, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 477--477 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 478--479 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 480--500 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 501--501 | `chunk:501` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 502--504 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 505--505 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 506--506 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 507--507 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 508--508 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 509--509 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 510--511 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 512--517 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 518--520 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 521--521 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 522--522 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 523--523 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 524--524 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 525--525 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 526--526 | `chunk:526, field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 527--529 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 530--532 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 533--533 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 534--534 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 535--535 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 536--536 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 537--537 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 538--538 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 539--539 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 540--540 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 541--541 | `field:flags` | `flags` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 542--544 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 545--545 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 546--546 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 547--547 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 548--548 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 549--549 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 550--550 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 551--551 | `chunk:551, field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 552--554 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 555--555 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 556--556 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 557--557 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 558--558 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 559--559 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 560--560 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 561--567 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 568--568 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 569--569 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 570--570 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 571--571 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 572--572 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 573--573 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 574--574 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 575--575 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 576--578 | `chunk:576, field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 579--579 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 580--580 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 581--581 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 582--582 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 583--583 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 584--584 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 585--585 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 586--586 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 587--589 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 590--590 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 591--591 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 592--592 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 593--593 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 594--594 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 595--595 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 596--596 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 597--597 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 598--600 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 601--601 | `chunk:601, field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 602--602 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 603--603 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 604--604 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 605--605 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 606--606 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 607--607 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 608--608 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 609--611 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 612--612 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 613--613 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 614--614 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 615--615 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 616--616 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 617--617 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 618--618 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 619--619 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 620--622 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 623--623 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 624--624 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 625--625 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 626--626 | `chunk:626, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 627--627 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 628--628 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 629--629 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 630--630 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 631--633 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 634--634 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 635--635 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 636--636 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 637--637 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 638--638 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 639--639 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 640--640 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 641--641 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 642--644 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 645--645 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 646--646 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 647--647 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 648--648 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 649--649 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 650--650 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 651--657 | `chunk:651, field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 658--658 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 659--659 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 660--660 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 661--661 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 662--662 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 663--664 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 665--670 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 671--671 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 672--672 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 673--673 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 674--674 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 675--675 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 676--676 | `chunk:676, field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 677--677 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 678--678 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 679--681 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 682--682 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 683--683 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 684--684 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 685--685 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 686--686 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 687--687 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 688--700 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 701--704 | `chunk:701` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 705--707 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 708--708 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 709--709 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 710--710 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 711--711 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 712--712 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 713--713 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 714--716 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 717--717 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 718--718 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 719--719 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 720--720 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 721--721 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 722--722 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 723--725 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 726--726 | `chunk:726, field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 727--727 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 728--728 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 729--729 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 730--730 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 731--731 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 732--732 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 733--735 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 736--736 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 737--737 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 738--738 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 739--739 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 740--740 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 741--741 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 742--742 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 743--745 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 746--746 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 747--747 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 748--748 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 749--749 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 750--750 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 751--751 | `chunk:751, field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 752--752 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 753--755 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 756--756 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 757--757 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 758--758 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 759--759 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 760--760 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 761--761 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 762--762 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 763--765 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 766--766 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 767--767 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 768--768 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 769--769 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 770--770 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 771--771 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 772--772 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 773--775 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 776--776 | `chunk:776, field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 777--777 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 778--778 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 779--779 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 780--780 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 781--781 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 782--782 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 783--785 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 786--786 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 787--787 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 788--788 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 789--789 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 790--790 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 791--791 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 792--792 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 793--795 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 796--796 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 797--797 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 798--798 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 799--799 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 800--800 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 801--801 | `chunk:801, field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 802--802 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 803--805 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 806--806 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 807--807 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 808--808 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 809--809 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 810--810 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 811--811 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 812--812 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 813--815 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 816--816 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 817--817 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 818--818 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 819--819 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 820--820 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 821--821 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 822--822 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 823--825 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 826--826 | `chunk:826, field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 827--827 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 828--828 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 829--829 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 830--830 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 831--831 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 832--832 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 833--835 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 836--836 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 837--837 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 838--838 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 839--839 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 840--840 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 841--841 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 842--842 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 843--845 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 846--846 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 847--847 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 848--848 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 849--849 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 850--850 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 851--851 | `chunk:851, field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 852--854 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 855--855 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 856--856 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 857--857 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 858--858 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 859--859 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 860--860 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 861--861 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 862--862 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 863--865 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 866--866 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 867--867 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 868--868 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 869--869 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 870--870 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 871--871 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 872--874 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 875--875 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 876--876 | `chunk:876, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 877--877 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 878--878 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 879--879 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 880--880 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 881--883 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 884--884 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 885--885 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 886--886 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 887--887 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 888--888 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 889--889 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 890--892 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 893--893 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 894--894 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 895--895 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 896--896 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 897--897 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 898--898 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 899--900 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 901--901 | `chunk:901` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 902--902 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 903--903 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 904--904 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 905--905 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 906--906 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 907--907 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 908--910 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 911--911 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 912--912 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 913--913 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 914--914 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 915--915 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 916--916 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 917--919 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 920--920 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 921--921 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 922--922 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 923--923 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 924--924 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 925--925 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 926--928 | `chunk:926, field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 929--929 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 930--930 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 931--931 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 932--932 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 933--933 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 934--934 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 935--937 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 938--938 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 939--939 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 940--940 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 941--941 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 942--942 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 943--943 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 944--944 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 945--947 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 948--948 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 949--949 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 950--950 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 951--951 | `chunk:951, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 952--952 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 953--953 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 954--956 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 957--957 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 958--958 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 959--959 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 960--960 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 961--961 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 962--962 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 963--963 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 964--966 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 967--967 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 968--968 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 969--969 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 970--970 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 971--971 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 972--972 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 973--973 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 974--975 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 976--976 | `chunk:976` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 977--977 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 978--978 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 979--979 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 980--980 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 981--981 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 982--982 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 983--987 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 988--990 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 991--991 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 992--992 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 993--993 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 994--994 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 995--995 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 996--996 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 997--999 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1000--1000 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1001--1001 | `chunk:1001, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1002--1002 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1003--1003 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1004--1004 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1005--1005 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1006--1008 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1009--1009 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1010--1010 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1011--1011 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1012--1012 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1013--1013 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1014--1014 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1015--1020 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1021--1023 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1024--1024 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1025--1025 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1026--1026 | `chunk:1026, field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1027--1027 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1028--1028 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1029--1029 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1030--1032 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1033--1033 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1034--1034 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1035--1035 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1036--1036 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1037--1037 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1038--1038 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1039--1039 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1040--1042 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1043--1043 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1044--1044 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1045--1045 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1046--1046 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1047--1047 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1048--1048 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1049--1049 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1050--1050 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1051--1052 | `chunk:1051` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1053--1053 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1054--1054 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1055--1055 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1056--1056 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1057--1057 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1058--1058 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1059--1059 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1060--1062 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1063--1063 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1064--1064 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1065--1065 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1066--1066 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1067--1067 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1068--1068 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1069--1069 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1070--1072 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1073--1073 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1074--1074 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1075--1075 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1076--1076 | `chunk:1076, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1077--1077 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1078--1078 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1079--1079 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1080--1082 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1083--1083 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1084--1084 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1085--1085 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1086--1086 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1087--1087 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1088--1088 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1089--1089 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1090--1092 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1093--1093 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1094--1094 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1095--1095 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1096--1096 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1097--1097 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1098--1098 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1099--1099 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1100--1100 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1101--1102 | `chunk:1101` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1103--1103 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1104--1104 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1105--1105 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1106--1106 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1107--1107 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1108--1108 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1109--1109 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1110--1112 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1113--1113 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1114--1114 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1115--1115 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1116--1116 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1117--1117 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1118--1118 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1119--1119 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1120--1122 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1123--1123 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1124--1124 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1125--1125 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1126--1126 | `chunk:1126, field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1127--1127 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1128--1128 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1129--1129 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1130--1132 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1133--1133 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1134--1134 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1135--1135 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1136--1136 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1137--1137 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1138--1138 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1139--1139 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1140--1142 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1143--1143 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1144--1144 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1145--1145 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1146--1146 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1147--1147 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1148--1148 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1149--1149 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1150--1150 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1151--1152 | `chunk:1151` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1153--1153 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1154--1154 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1155--1155 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1156--1156 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1157--1157 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1158--1158 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1159--1162 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1163--1165 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1166--1166 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1167--1167 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1168--1168 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1169--1169 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1170--1170 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1171--1171 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1172--1174 | `field:step` | `step` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1175--1175 | `field:id` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1176--1176 | `chunk:1176, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1177--1177 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1178--1178 | `field:minimum` | `minimum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1179--1179 | `field:maximum` | `maximum` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1180--1180 | `field:default_value` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1181--1185 | `field:menu_skip_mask` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1186--1189 | `field:qmenu` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1190--1191 | `d:NUM_CTRLS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1192--1198 | `f:get_frame_size_compressed` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1199--1200 | `v:venc_formats` | `venc_formats` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1201--1201 | `chunk:1201, field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1202--1202 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1203--1203 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1204--1204 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1205--1207 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1208--1208 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1209--1209 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1210--1210 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1211--1211 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1212--1214 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1215--1215 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1216--1216 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1217--1217 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1218--1218 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1219--1219 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1220--1220 | `field:input_min_count` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1221--1223 | `field:output_min_count` | `output_min_count` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1224--1224 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1225--1225 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1226--1226 | `chunk:1226, field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1227--1227 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1228--1228 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1229--1229 | `field:input_min_count` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1230--1232 | `field:output_min_count` | `output_min_count` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1233--1233 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1234--1234 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1235--1235 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1236--1236 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1237--1237 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1238--1238 | `field:input_min_count` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1239--1241 | `field:output_min_count` | `output_min_count` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1242--1242 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1243--1243 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1244--1244 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1245--1245 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1246--1248 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1249--1249 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1250--1250 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1251--1251 | `chunk:1251, field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1252--1252 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1253--1255 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1256--1256 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1257--1257 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1258--1258 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1259--1259 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1260--1260 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1261--1261 | `field:input_min_count` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1262--1264 | `field:output_min_count` | `output_min_count` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1265--1265 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1266--1266 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1267--1267 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1268--1268 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1269--1271 | `field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1272--1272 | `field:name` | `name` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1273--1273 | `field:description` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1274--1274 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1275--1275 | `field:get_frame_size` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 1276--1279 | `chunk:1276, field:type` | `type` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1280--1281 | `v:enc_pix_format_constraints` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1282--1282 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1283--1283 | `field:num_planes` | `num_planes` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1284--1284 | `field:y_stride_multiples` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1285--1285 | `field:y_max_stride` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1286--1286 | `field:y_min_plane_buffer_height_multiple` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1287--1287 | `field:y_buffer_alignment` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1288--1288 | `field:uv_stride_multiples` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1289--1289 | `field:uv_max_stride` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1290--1290 | `field:uv_min_plane_buffer_height_multiple` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1291--1293 | `field:uv_buffer_alignment` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1294--1294 | `field:fourcc` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1295--1295 | `field:num_planes` | `num_planes` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1296--1296 | `field:y_stride_multiples` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1297--1297 | `field:y_max_stride` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1298--1298 | `field:y_min_plane_buffer_height_multiple` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1299--1299 | `field:y_buffer_alignment` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1300--1300 | `field:uv_stride_multiples` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1301--1301 | `chunk:1301, field:uv_max_stride` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1302--1302 | `field:uv_min_plane_buffer_height_multiple` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1303--1310 | `field:uv_buffer_alignment` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1311--1321 | `f:get_ctrl_from_cluster` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1322--1325 | `f:msm_venc_s_ctrl` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1326--1350 | `chunk:1326` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1351--1362 | `chunk:1351` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1363--1375 | `d:TRY_GET_CTRL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1376--1385 | `chunk:1376` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1386--1400 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IDR_PERIOD` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1401--1402 | `chunk:1401` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1403--1403 | `case:V4L2_CID_MPEG_VIDC_VIDEO_NUM_B_FRAMES` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1404--1425 | `case:V4L2_CID_MPEG_VIDC_VIDEO_NUM_P_FRAMES` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1426--1435 | `chunk:1426` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1436--1440 | `case:V4L2_CID_MPEG_VIDC_VIDEO_ADAPTIVE_B` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1441--1445 | `case:V4L2_CID_MPEG_VIDC_VIDEO_REQUEST_IFRAME` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1446--1450 | `case:V4L2_CID_MPEG_VIDEO_BITRATE_MODE` | `V4L2_CID_MPEG_VIDEO_BITRATE_MODE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1451--1475 | `chunk:1451` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1476--1500 | `chunk:1476` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1501--1502 | `chunk:1501` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1503--1518 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FRAME_QUALITY` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1519--1525 | `case:V4L2_CID_MPEG_VIDC_IMG_GRID_ENABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1526--1526 | `chunk:1526` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1527--1535 | `case:V4L2_CID_MPEG_VIDEO_BITRATE` | `V4L2_CID_MPEG_VIDEO_BITRATE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1536--1550 | `case:V4L2_CID_MPEG_VIDEO_BITRATE_PEAK` | `V4L2_CID_MPEG_VIDEO_BITRATE_PEAK` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1551--1558 | `chunk:1551` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1559--1564 | `case:V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1565--1575 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1576--1577 | `chunk:1576` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1578--1590 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1591--1598 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP8_PROFILE_LEVEL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1599--1600 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_PROFILE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1601--1610 | `chunk:1601` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1611--1621 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_TIER_LEVEL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1622--1625 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TME_PROFILE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1626--1633 | `chunk:1626` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1634--1644 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TME_LEVEL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1645--1650 | `case:V4L2_CID_ROTATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1651--1654 | `chunk:1651` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1655--1659 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1660--1666 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE` | `V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1667--1669 | `case:V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1670--1672 | `case:V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1673--1673 | `case:V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE` | `V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1674--1675 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1676--1688 | `chunk:1676` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1689--1689 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES` | `V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1690--1700 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB` | `V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1701--1701 | `chunk:1701` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1702--1721 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_DELIVERY_MODE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1722--1725 | `case:V4L2_CID_MPEG_VIDC_VIDEO_INTRA_REFRESH_MODE_CYCLIC` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1726--1731 | `chunk:1726` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1732--1741 | `case:V4L2_CID_MPEG_VIDC_VIDEO_INTRA_REFRESH_RANDOM` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1742--1750 | `case:V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | `V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1751--1759 | `chunk:1751` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1760--1775 | `case:V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA` | `V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1776--1777 | `chunk:1776` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1778--1794 | `case:V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA` | `V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1795--1798 | `case:V4L2_CID_MPEG_VIDEO_HEADER_MODE` | `V4L2_CID_MPEG_VIDEO_HEADER_MODE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1799--1800 | `case:V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE` | `V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1801--1801 | `chunk:1801` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1802--1804 | `case:V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME` | `V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1805--1810 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1811--1818 | `case:V4L2_CID_MPEG_VIDC_VIDEO_SECURE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1819--1825 | `case:V4L2_CID_MPEG_VIDC_VIDEO_EXTRADATA` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1826--1827 | `chunk:1826` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1828--1828 | `case:V4L2_MPEG_VIDC_EXTRADATA_ASPECT_RATIO` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1829--1829 | `case:V4L2_MPEG_VIDC_EXTRADATA_ROI_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1830--1830 | `case:V4L2_MPEG_VIDC_EXTRADATA_HDR10PLUS_METADATA` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1831--1833 | `case:V4L2_MPEG_VIDC_EXTRADATA_INPUT_CROP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1834--1834 | `case:V4L2_MPEG_VIDC_EXTRADATA_LTR` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1835--1835 | `case:V4L2_MPEG_VIDC_EXTRADATA_ENC_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1836--1838 | `case:V4L2_MPEG_VIDC_EXTRADATA_ENC_DTS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1839--1850 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1851--1875 | `chunk:1851` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1876--1876 | `chunk:1876` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1877--1880 | `case:V4L2_CID_MPEG_VIDC_VIDEO_AU_DELIMITER` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1881--1883 | `case:V4L2_MPEG_MSM_VIDC_DISABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1884--1886 | `case:V4L2_MPEG_MSM_VIDC_ENABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1887--1893 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1894--1900 | `case:V4L2_CID_MPEG_VIDC_VIDEO_USELTRFRAME` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1901--1905 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MARKLTRFRAME, chunk:1901` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1906--1917 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HIER_P_NUM_LAYERS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1918--1922 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VPX_ERROR_RESILIENCE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1923--1925 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HYBRID_HIERP_MODE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1926--1940 | `chunk:1926` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1941--1950 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MAX_HIERP_LAYERS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1951--1952 | `chunk:1951` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1953--1957 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BASELAYER_ID` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1958--1973 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1974--1975 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1976--1989 | `chunk:1976` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 1990--2000 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2001--2005 | `chunk:2001` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2006--2021 | `case:V4L2_CID_MPEG_VIDC_VIDEO_QP_MASK` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2022--2025 | `case:V4L2_CID_MPEG_VIDC_VIDEO_PRIORITY` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2026--2026 | `chunk:2026` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2027--2029 | `case:V4L2_MPEG_MSM_VIDC_DISABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2030--2032 | `case:V4L2_MPEG_MSM_VIDC_ENABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2033--2039 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2040--2050 | `case:V4L2_CID_MPEG_VIDC_VIDEO_OPERATING_RATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2051--2066 | `chunk:2051` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2067--2073 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VENC_BITRATE_TYPE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2074--2075 | `case:V4L2_CID_MPEG_VIDC_VIDEO_COLOR_SPACE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2076--2088 | `chunk:2076` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2089--2100 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FULL_RANGE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2101--2103 | `chunk:2101` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2104--2117 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TRANSFER_CHARS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2118--2125 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MATRIX_COEFFS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2126--2131 | `chunk:2126` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2132--2143 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VPE_CSC` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2144--2150 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VPE_CSC_CUSTOM_MATRIX` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2151--2162 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LOWLATENCY_MODE, chunk:2151` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2163--2165 | `case:V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM` | `V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2166--2168 | `case:V4L2_MPEG_MSM_VIDC_ENABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2169--2171 | `case:V4L2_MPEG_MSM_VIDC_DISABLE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2172--2175 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2176--2180 | `chunk:2176` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2181--2187 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_TYPE` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2188--2194 | `case:V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE` | `V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2195--2200 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VUI_TIMING_INFO` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2201--2210 | `chunk:2201` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2211--2211 | `case:V4L2_MPEG_VIDEO_BITRATE_MODE_VBR` | `V4L2_MPEG_VIDEO_BITRATE_MODE_VBR` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2212--2212 | `case:V4L2_MPEG_VIDEO_BITRATE_MODE_CBR` | `V4L2_MPEG_VIDEO_BITRATE_MODE_CBR` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2213--2215 | `case:V4L2_MPEG_VIDEO_BITRATE_MODE_MBR` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2216--2224 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2225--2225 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_FORMAT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2226--2231 | `chunk:2226` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2232--2238 | `case:V4L2_CID_MPEG_VIDC_VENC_BITRATE_SAVINGS` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2239--2239 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LTRCOUNT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2240--2240 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_SAR_WIDTH` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2241--2241 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_SAR_HEIGHT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2242--2242 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_WIDTH` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2243--2243 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_HEIGHT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2244--2244 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LAYER_ID` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2245--2245 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_LAYER_BITRATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2246--2246 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2247--2247 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2248--2248 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2249--2249 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP_MAX` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2250--2250 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP_MAX` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2251--2251 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP_MAX, chunk:2251` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2252--2252 | `case:V4L2_CID_MPEG_VIDC_VENC_HDR_INFO` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2253--2253 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_00` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2254--2254 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_01` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2255--2255 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_10` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2256--2256 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_11` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2257--2257 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_20` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2258--2258 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_21` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2259--2259 | `case:V4L2_CID_MPEG_VIDC_VENC_WHITEPOINT_X` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2260--2260 | `case:V4L2_CID_MPEG_VIDC_VENC_WHITEPOINT_Y` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2261--2261 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_DISP_LUM` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2262--2262 | `case:V4L2_CID_MPEG_VIDC_VENC_MIN_DISP_LUM` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2263--2263 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_CLL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2264--2267 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_FLL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2268--2274 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2275--2275 | `d:TRY_GET_CTRL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2276--2288 | `chunk:2276` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2289--2296 | `f:msm_venc_ext_layer_id_update` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2297--2300 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2301--2302 | `chunk:2301` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2303--2308 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2309--2314 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2315--2320 | `case:V4L2_CID_MPEG_VIDC_VIDEO_QP_MASK` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2321--2325 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2326--2326 | `chunk:2326` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2327--2332 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2333--2338 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP_MIN` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2339--2344 | `case:V4L2_CID_MPEG_VIDC_VIDEO_I_FRAME_QP_MAX` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2345--2350 | `case:V4L2_CID_MPEG_VIDC_VIDEO_P_FRAME_QP_MAX` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2351--2356 | `case:V4L2_CID_MPEG_VIDC_VIDEO_B_FRAME_QP_MAX, chunk:2351` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2357--2366 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_LAYER_BITRATE` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2367--2375 | `f:msm_venc_s_ext_ctrl` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2376--2400 | `chunk:2376` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2401--2402 | `chunk:2401` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2403--2416 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LTRCOUNT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2417--2421 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_SAR_WIDTH` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2422--2425 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_SAR_HEIGHT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2426--2426 | `chunk:2426` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2427--2433 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_WIDTH` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2434--2439 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_HEIGHT` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2440--2450 | `case:V4L2_CID_MPEG_VIDC_VIDEO_LAYER_ID` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2451--2457 | `chunk:2451` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2458--2465 | `case:V4L2_CID_MPEG_VIDC_VENC_HDR_INFO` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2466--2469 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_00` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2470--2473 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_01` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2474--2475 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_10` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2476--2477 | `chunk:2476` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2478--2481 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_11` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2482--2485 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_20` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2486--2489 | `case:V4L2_CID_MPEG_VIDC_VENC_RGB_PRIMARY_21` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2490--2493 | `case:V4L2_CID_MPEG_VIDC_VENC_WHITEPOINT_X` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2494--2497 | `case:V4L2_CID_MPEG_VIDC_VENC_WHITEPOINT_Y` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2498--2500 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_DISP_LUM` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2501--2501 | `chunk:2501` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2502--2505 | `case:V4L2_CID_MPEG_VIDC_VENC_MIN_DISP_LUM` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2506--2509 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_CLL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2510--2513 | `case:V4L2_CID_MPEG_VIDC_VENC_MAX_FLL` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2514--2524 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2525--2525 | `case:default` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2526--2542 | `chunk:2526` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2543--2550 | `f:msm_venc_inst_init` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2551--2575 | `chunk:2551` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2576--2600 | `chunk:2576` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2601--2620 | `chunk:2601` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2621--2625 | `f:msm_venc_enum_fmt` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2626--2650 | `chunk:2626` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2651--2651 | `chunk:2651` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2652--2675 | `f:msm_venc_set_csc` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2676--2696 | `chunk:2676` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2697--2700 | `f:msm_venc_s_fmt` | `—` | encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。 |
| 2701--2725 | `chunk:2701` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2726--2750 | `chunk:2726` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2751--2775 | `chunk:2751` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2776--2800 | `chunk:2776` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2801--2825 | `chunk:2801` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2826--2850 | `chunk:2826` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2851--2875 | `chunk:2851` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2876--2900 | `chunk:2876` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2901--2916 | `chunk:2901` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2917--2920 | `label:exit` | `exit` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2921--2925 | `f:msm_venc_ctrl_init` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |
| 2926--2926 | `chunk:2926` | `—` | encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。 |

覆盖校验：2926/2926 行，连续、无空洞、无重叠。

## `msm_venc.h`

- 原厂物理行：28；当前语义落点：`venc.h + core.h`；默认判定：**架构替代**。
- 文件级结论：声明按主线实例模型重写。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 架构替代：声明按主线实例模型重写。 |
| 13--25 | `pp:ifndef _MSM_VENC_H_` | `—` | 架构替代：声明按主线实例模型重写。 |
| 26--27 | `chunk:26` | `—` | 架构替代：声明按主线实例模型重写。 |
| 28--28 | `pp:endif` | `—` | 架构替代：声明按主线实例模型重写。 |

覆盖校验：28/28 行，连续、无空洞、无重叠。

## `msm_vidc_clocks.c`

- 原厂物理行：1735；当前语义落点：`pm_helpers.c + OPP + interconnect`；默认判定：**部分迁移**。
- 文件级结论：clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--18 | `file:start` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 19--19 | `d:MSM_VIDC_MIN_UBWC_COMPLEXITY_FACTOR` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 20--21 | `d:MSM_VIDC_MAX_UBWC_COMPLEXITY_FACTOR` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 22--22 | `d:MSM_VIDC_MIN_UBWC_COMPRESSION_RATIO` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 23--25 | `d:MSM_VIDC_MAX_UBWC_COMPRESSION_RATIO` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 26--30 | `chunk:26` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 31--31 | `v:core_ops_vpu4` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 32--32 | `field:calc_freq` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 33--33 | `field:decide_work_route` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 34--36 | `field:decide_work_mode` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 37--37 | `v:core_ops_vpu5` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 38--38 | `field:calc_freq` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 39--39 | `field:decide_work_route` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 40--42 | `field:decide_work_mode` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 43--50 | `f:msm_dcvs_print_dcvs_stats` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 51--55 | `chunk:51` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 56--75 | `f:get_ubwc_compression_ratio` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 76--85 | `chunk:76` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 86--100 | `f:msm_vidc_get_mbs_per_frame` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 101--102 | `chunk:101` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 103--115 | `f:msm_vidc_get_fps` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 116--125 | `f:update_recon_stats` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 126--142 | `chunk:126` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 143--150 | `f:fill_dynamic_stats` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 151--175 | `chunk:151` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 176--195 | `chunk:176` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 196--200 | `f:msm_comm_vote_bus` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 201--225 | `chunk:201` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 226--250 | `chunk:226` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 251--264 | `chunk:251` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 265--267 | `case:MSM_VIDC_DECODER` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 268--270 | `case:MSM_VIDC_ENCODER` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 271--273 | `case:MSM_VIDC_CVP` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 274--275 | `case:default` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 276--300 | `chunk:276` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 301--325 | `chunk:301` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 326--350 | `chunk:326` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 351--356 | `chunk:351` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 357--375 | `f:msm_dcvs_scale_clocks` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 376--400 | `chunk:376` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 401--425 | `chunk:401` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 426--437 | `chunk:426` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 438--450 | `f:msm_vidc_update_freq_entry` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 451--463 | `chunk:451` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 464--467 | `label:exit` | `exit` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 468--475 | `f:msm_vidc_clear_freq_entry` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 476--482 | `chunk:476` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 483--493 | `f:msm_vidc_max_freq` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 494--500 | `f:msm_comm_free_freq_table` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 501--506 | `chunk:501` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 507--519 | `f:msm_comm_free_input_cr_table` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 520--525 | `f:msm_comm_update_input_cr` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 526--544 | `chunk:526` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 545--548 | `label:exit` | `exit` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 549--550 | `f:msm_vidc_calc_freq_ar50` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 551--575 | `chunk:551` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 576--600 | `chunk:576` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 601--625 | `chunk:601` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 626--631 | `chunk:626` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 632--650 | `f:msm_vidc_calc_freq` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 651--675 | `chunk:651` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 676--700 | `chunk:676` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 701--725 | `chunk:701` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 726--741 | `chunk:726` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 742--750 | `f:msm_vidc_set_clocks` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 751--775 | `chunk:751` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 776--800 | `chunk:776` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 801--825 | `chunk:801` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 826--850 | `chunk:826` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 851--851 | `chunk:851` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 852--875 | `f:msm_vidc_validate_operating_rate` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 876--900 | `chunk:876` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 901--925 | `chunk:901` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 926--936 | `chunk:926` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 937--950 | `f:msm_comm_scale_clocks` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 951--975 | `chunk:951` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 976--990 | `chunk:976` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 991--1000 | `f:msm_comm_scale_clocks_and_bus` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 1001--1013 | `chunk:1001` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1014--1025 | `f:msm_dcvs_try_enable` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 1026--1034 | `chunk:1026` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1035--1050 | `f:msm_comm_init_clocks_and_bus_data` | `—` | 缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。 |
| 1051--1074 | `chunk:1051` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1075--1075 | `f:msm_clock_data_reset` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1076--1100 | `chunk:1076` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1101--1125 | `chunk:1101` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1126--1150 | `chunk:1126` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1151--1161 | `chunk:1151` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1162--1172 | `f:is_output_buffer` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1173--1175 | `f:msm_vidc_get_extra_buff_count` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1176--1200 | `chunk:1176` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1201--1212 | `chunk:1201` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1213--1225 | `f:msm_vidc_decide_work_route` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1226--1230 | `chunk:1226` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1231--1233 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1234--1245 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1246--1246 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1247--1250 | `case:V4L2_PIX_FMT_TME` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1251--1275 | `chunk:1251` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1276--1277 | `chunk:1276` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1278--1290 | `label:decision_done` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1291--1300 | `f:msm_vidc_decide_work_mode_ar50` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1301--1313 | `chunk:1301` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1314--1316 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1317--1317 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1318--1325 | `case:V4L2_PIX_FMT_HEVC` | `V4L2_PIX_FMT_HEVC` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1326--1338 | `chunk:1326` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1339--1350 | `label:decision_done` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1351--1363 | `chunk:1351` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1364--1375 | `f:msm_vidc_decide_work_mode` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1376--1389 | `chunk:1376` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1390--1392 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1393--1393 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1394--1394 | `case:V4L2_PIX_FMT_HEVC` | `V4L2_PIX_FMT_HEVC` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1395--1395 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1396--1400 | `case:V4L2_PIX_FMT_VP9` | `V4L2_PIX_FMT_VP9` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1401--1410 | `chunk:1401` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1411--1411 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1412--1420 | `case:V4L2_PIX_FMT_TME` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1421--1425 | `label:decision_done` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1426--1443 | `chunk:1426` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1444--1450 | `f:msm_vidc_power_save_mode_enable` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1451--1475 | `chunk:1451` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1476--1491 | `chunk:1476` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1492--1495 | `label:fail_power_mode_set` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1496--1500 | `f:msm_vidc_move_core_to_power_save_mode` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1501--1512 | `chunk:1501` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1513--1525 | `f:get_core_load` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1526--1548 | `chunk:1526` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1549--1550 | `f:msm_vidc_decide_core_and_power_mode` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1551--1575 | `chunk:1551` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1576--1600 | `chunk:1576` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1601--1625 | `chunk:1601` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1626--1650 | `chunk:1626` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1651--1675 | `chunk:1651` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1676--1695 | `chunk:1676, label:decision_done` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1696--1700 | `f:msm_vidc_init_core_clk_ops` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1701--1706 | `chunk:1701` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |
| 1707--1725 | `f:msm_print_core_status` | `—` | 已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。 |
| 1726--1735 | `chunk:1726` | `—` | clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。 |

覆盖校验：1735/1735 行，连续、无空洞、无重叠。

## `msm_vidc_clocks.h`

- 原厂物理行：48；当前语义落点：`pm_helpers.h`；默认判定：**架构替代**。
- 文件级结论：接口按主线 PM/ICC 重写。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 架构替代：接口按主线 PM/ICC 重写。 |
| 14--25 | `pp:ifndef _MSM_VIDC_CLOCKS_H_` | `—` | 架构替代：接口按主线 PM/ICC 重写。 |
| 26--47 | `chunk:26` | `—` | 架构替代：接口按主线 PM/ICC 重写。 |
| 48--48 | `pp:endif` | `—` | 架构替代：接口按主线 PM/ICC 重写。 |

覆盖校验：48/48 行，连续、无空洞、无重叠。

## `msm_vidc_common.c`

- 原厂物理行：7240；当前语义落点：`helpers.c + hfi.c + vdec.c + venc.c`；默认判定：**部分迁移**。
- 文件级结论：状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 26--26 | `chunk:26` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 27--27 | `d:MSM_VIDC_QBUF_BATCH_TIMEOUT` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 28--31 | `d:IS_ALREADY_IN_STATE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 32--33 | `d:V4L2_EVENT_SEQ_CHANGED_SUFFICIENT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 34--35 | `d:V4L2_EVENT_SEQ_CHANGED_INSUFFICIENT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 36--37 | `d:V4L2_EVENT_RELEASE_BUFFER_REFERENCE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 38--39 | `d:L_MODE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 40--50 | `v:mpeg_video_vidc_extradata` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 51--75 | `chunk:51` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 76--78 | `chunk:76` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 79--82 | `f:msm_comm_g_ctrl_for_id` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 83--89 | `field:id` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 90--100 | `f:get_super_cluster` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 101--107 | `chunk:101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 108--111 | `f:msm_comm_hal_to_v4l2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 112--113 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 114--115 | `case:HAL_H264_PROFILE_BASELINE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 116--118 | `case:HAL_H264_PROFILE_CONSTRAINED_BASE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 119--120 | `case:HAL_H264_PROFILE_MAIN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 121--122 | `case:HAL_H264_PROFILE_HIGH` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 123--124 | `case:HAL_H264_PROFILE_STEREO_HIGH` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 125--125 | `case:HAL_H264_PROFILE_MULTIVIEW_HIGH` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 126--126 | `chunk:126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 127--128 | `case:HAL_H264_PROFILE_CONSTRAINED_HIGH` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 129--131 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 132--133 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 134--135 | `case:HAL_H264_LEVEL_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 136--137 | `case:HAL_H264_LEVEL_1b` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 138--139 | `case:HAL_H264_LEVEL_11` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 140--141 | `case:HAL_H264_LEVEL_12` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 142--143 | `case:HAL_H264_LEVEL_13` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 144--145 | `case:HAL_H264_LEVEL_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 146--147 | `case:HAL_H264_LEVEL_21` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 148--149 | `case:HAL_H264_LEVEL_22` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 150--150 | `case:HAL_H264_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 151--151 | `chunk:151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 152--153 | `case:HAL_H264_LEVEL_31` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 154--155 | `case:HAL_H264_LEVEL_32` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 156--157 | `case:HAL_H264_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 158--159 | `case:HAL_H264_LEVEL_41` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 160--161 | `case:HAL_H264_LEVEL_42` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 162--163 | `case:HAL_H264_LEVEL_5` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 164--165 | `case:HAL_H264_LEVEL_51` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 166--167 | `case:HAL_H264_LEVEL_52` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 168--169 | `case:HAL_H264_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 170--171 | `case:HAL_H264_LEVEL_61` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 172--173 | `case:HAL_H264_LEVEL_62` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 174--175 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 176--177 | `chunk:176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 178--179 | `case:V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 180--181 | `case:HAL_H264_ENTROPY_CAVLC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 182--183 | `case:HAL_H264_ENTROPY_CABAC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 184--186 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 187--188 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_PROFILE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 189--190 | `case:HAL_HEVC_PROFILE_MAIN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 191--192 | `case:HAL_HEVC_PROFILE_MAIN10` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 193--194 | `case:HAL_HEVC_PROFILE_MAIN_STILL_PIC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 195--197 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 198--199 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_TIER_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 200--200 | `case:HAL_HEVC_MAIN_TIER_LEVEL_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 201--201 | `chunk:201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 202--203 | `case:HAL_HEVC_MAIN_TIER_LEVEL_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 204--205 | `case:HAL_HEVC_MAIN_TIER_LEVEL_2_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 206--207 | `case:HAL_HEVC_MAIN_TIER_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 208--209 | `case:HAL_HEVC_MAIN_TIER_LEVEL_3_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 210--211 | `case:HAL_HEVC_MAIN_TIER_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 212--213 | `case:HAL_HEVC_MAIN_TIER_LEVEL_4_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 214--215 | `case:HAL_HEVC_MAIN_TIER_LEVEL_5` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 216--217 | `case:HAL_HEVC_MAIN_TIER_LEVEL_5_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 218--219 | `case:HAL_HEVC_MAIN_TIER_LEVEL_5_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 220--221 | `case:HAL_HEVC_MAIN_TIER_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 222--223 | `case:HAL_HEVC_MAIN_TIER_LEVEL_6_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 224--225 | `case:HAL_HEVC_MAIN_TIER_LEVEL_6_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 226--227 | `case:HAL_HEVC_HIGH_TIER_LEVEL_1, chunk:226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 228--229 | `case:HAL_HEVC_HIGH_TIER_LEVEL_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 230--231 | `case:HAL_HEVC_HIGH_TIER_LEVEL_2_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 232--233 | `case:HAL_HEVC_HIGH_TIER_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 234--235 | `case:HAL_HEVC_HIGH_TIER_LEVEL_3_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 236--237 | `case:HAL_HEVC_HIGH_TIER_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 238--239 | `case:HAL_HEVC_HIGH_TIER_LEVEL_4_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 240--241 | `case:HAL_HEVC_HIGH_TIER_LEVEL_5` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 242--243 | `case:HAL_HEVC_HIGH_TIER_LEVEL_5_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 244--245 | `case:HAL_HEVC_HIGH_TIER_LEVEL_5_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 246--247 | `case:HAL_HEVC_HIGH_TIER_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 248--249 | `case:HAL_HEVC_HIGH_TIER_LEVEL_6_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 250--250 | `case:HAL_HEVC_HIGH_TIER_LEVEL_6_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 251--251 | `chunk:251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 252--253 | `case:HAL_HEVC_TIER_LEVEL_UNKNOWN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 254--256 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 257--258 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP8_PROFILE_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 259--260 | `case:HAL_VP8_LEVEL_VERSION_0` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 261--262 | `case:HAL_VP8_LEVEL_VERSION_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 263--264 | `case:HAL_VP8_LEVEL_VERSION_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 265--266 | `case:HAL_VP8_LEVEL_VERSION_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 267--268 | `case:HAL_VP8_LEVEL_UNUSED` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 269--271 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 272--273 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP9_PROFILE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 274--275 | `case:HAL_VP9_PROFILE_P0` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 276--277 | `case:HAL_VP9_PROFILE_P2_10, chunk:276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 278--279 | `case:HAL_VP9_PROFILE_UNUSED` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 280--282 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 283--284 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP9_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 285--286 | `case:HAL_VP9_LEVEL_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 287--288 | `case:HAL_VP9_LEVEL_11` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 289--290 | `case:HAL_VP9_LEVEL_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 291--292 | `case:HAL_VP9_LEVEL_21` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 293--294 | `case:HAL_VP9_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 295--296 | `case:HAL_VP9_LEVEL_31` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 297--298 | `case:HAL_VP9_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 299--300 | `case:HAL_VP9_LEVEL_41` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 301--302 | `case:HAL_VP9_LEVEL_5, chunk:301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 303--304 | `case:HAL_VP9_LEVEL_51` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 305--306 | `case:HAL_VP9_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 307--308 | `case:HAL_VP9_LEVEL_61` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 309--310 | `case:HAL_VP9_LEVEL_UNUSED` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 311--313 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 314--315 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MPEG2_PROFILE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 316--317 | `case:HAL_MPEG2_PROFILE_SIMPLE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 318--319 | `case:HAL_MPEG2_PROFILE_MAIN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 320--322 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 323--325 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MPEG2_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 326--327 | `case:HAL_MPEG2_LEVEL_LL, chunk:326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 328--329 | `case:HAL_MPEG2_LEVEL_ML` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 330--331 | `case:HAL_MPEG2_LEVEL_HL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 332--336 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 337--341 | `label:unknown_value` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 342--345 | `f:msm_comm_v4l2_to_hal` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 346--347 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 348--349 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE` | `V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 350--350 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE` | `V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 351--351 | `chunk:351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 352--353 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_MAIN` | `V4L2_MPEG_VIDEO_H264_PROFILE_MAIN` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 354--355 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_HIGH` | `V4L2_MPEG_VIDEO_H264_PROFILE_HIGH` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 356--357 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH` | `V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 358--359 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH` | `V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 360--361 | `case:V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH` | `V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_HIGH` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 362--364 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 365--366 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 367--368 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_1_0` | `V4L2_MPEG_VIDEO_H264_LEVEL_1_0` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 369--370 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_1B` | `V4L2_MPEG_VIDEO_H264_LEVEL_1B` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 371--372 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_1_1` | `V4L2_MPEG_VIDEO_H264_LEVEL_1_1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 373--374 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_1_2` | `V4L2_MPEG_VIDEO_H264_LEVEL_1_2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 375--375 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_1_3` | `V4L2_MPEG_VIDEO_H264_LEVEL_1_3` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 376--376 | `chunk:376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 377--378 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_2_0` | `V4L2_MPEG_VIDEO_H264_LEVEL_2_0` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 379--380 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_2_1` | `V4L2_MPEG_VIDEO_H264_LEVEL_2_1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 381--382 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_2_2` | `V4L2_MPEG_VIDEO_H264_LEVEL_2_2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 383--384 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_3_0` | `V4L2_MPEG_VIDEO_H264_LEVEL_3_0` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 385--386 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_3_1` | `V4L2_MPEG_VIDEO_H264_LEVEL_3_1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 387--388 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_3_2` | `V4L2_MPEG_VIDEO_H264_LEVEL_3_2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 389--390 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_4_0` | `V4L2_MPEG_VIDEO_H264_LEVEL_4_0` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 391--392 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_4_1` | `V4L2_MPEG_VIDEO_H264_LEVEL_4_1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 393--394 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_4_2` | `V4L2_MPEG_VIDEO_H264_LEVEL_4_2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 395--396 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_5_0` | `V4L2_MPEG_VIDEO_H264_LEVEL_5_0` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 397--398 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_5_1` | `V4L2_MPEG_VIDEO_H264_LEVEL_5_1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 399--400 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_5_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 401--402 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_6_0, chunk:401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 403--404 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_6_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 405--406 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_6_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 407--408 | `case:V4L2_MPEG_VIDEO_H264_LEVEL_UNKNOWN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 409--411 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 412--413 | `case:V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 414--415 | `case:V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC` | `V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 416--417 | `case:V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC` | `V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 418--420 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 421--422 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP8_PROFILE_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 423--424 | `case:V4L2_MPEG_VIDC_VIDEO_VP8_VERSION_0` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 425--425 | `case:V4L2_MPEG_VIDC_VIDEO_VP8_VERSION_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 426--426 | `chunk:426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 427--428 | `case:V4L2_MPEG_VIDC_VIDEO_VP8_VERSION_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 429--430 | `case:V4L2_MPEG_VIDC_VIDEO_VP8_VERSION_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 431--432 | `case:V4L2_MPEG_VIDC_VIDEO_VP8_UNUSED` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 433--435 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 436--437 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_PROFILE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 438--439 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_PROFILE_MAIN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 440--441 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_PROFILE_MAIN10` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 442--443 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_PROFILE_MAIN_STILL_PIC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 444--446 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 447--448 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_TIER_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 449--450 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 451--452 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_2, chunk:451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 453--454 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_2_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 455--456 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 457--458 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_3_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 459--460 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 461--462 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_4_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 463--464 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_5` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 465--466 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_5_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 467--468 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_5_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 469--470 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 471--472 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_6_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 473--474 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_MAIN_TIER_LEVEL_6_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 475--475 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 476--476 | `chunk:476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 477--478 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 479--480 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_2_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 481--482 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 483--484 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_3_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 485--486 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_4` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 487--488 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_4_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 489--490 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_5` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 491--492 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_5_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 493--494 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_5_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 495--496 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_6` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 497--498 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_6_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 499--500 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_HIGH_TIER_LEVEL_6_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 501--502 | `case:V4L2_MPEG_VIDC_VIDEO_HEVC_LEVEL_UNKNOWN, chunk:501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 503--505 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 506--507 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TME_PROFILE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 508--509 | `case:V4L2_MPEG_VIDC_VIDEO_TME_PROFILE_0` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 510--511 | `case:V4L2_MPEG_VIDC_VIDEO_TME_PROFILE_1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 512--513 | `case:V4L2_MPEG_VIDC_VIDEO_TME_PROFILE_2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 514--515 | `case:V4L2_MPEG_VIDC_VIDEO_TME_PROFILE_3` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 516--518 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 519--520 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TME_LEVEL` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 521--522 | `case:V4L2_MPEG_VIDC_VIDEO_TME_LEVEL_INTEGER` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 523--525 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 526--527 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP, chunk:526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 528--529 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP_NONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 530--531 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP_HORI` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 532--533 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP_VERT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 534--535 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FLIP_BOTH` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 536--538 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 539--540 | `case:V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | `V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 541--542 | `case:V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED` | `V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 543--544 | `case:V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED` | `V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 545--546 | `case:L_MODE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 547--549 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 550--550 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_TYPE` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 551--551 | `chunk:551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 552--553 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_DEFAULT` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 554--555 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_MEDIUM` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 556--557 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_HUGE` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 558--559 | `case:V4L2_CID_MPEG_VIDC_VIDEO_IFRAME_SIZE_UNLIMITED` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 560--564 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 565--569 | `label:unknown_value` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 570--572 | `f:msm_comm_get_v4l2_profile` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 573--575 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 576--576 | `chunk:576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 577--580 | `case:V4L2_PIX_FMT_HEVC` | `V4L2_PIX_FMT_HEVC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 581--581 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 582--582 | `case:V4L2_PIX_FMT_VP9` | `V4L2_PIX_FMT_VP9` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 583--584 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 585--590 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 591--593 | `f:msm_comm_get_v4l2_level` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 594--597 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 598--600 | `case:V4L2_PIX_FMT_HEVC` | `V4L2_PIX_FMT_HEVC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 601--601 | `chunk:601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 602--605 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 606--606 | `case:V4L2_PIX_FMT_VP9` | `V4L2_PIX_FMT_VP9` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 607--608 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 609--614 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 615--625 | `f:msm_comm_ctrl_init` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 626--650 | `chunk:626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 651--675 | `chunk:651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 676--700 | `chunk:676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 701--713 | `chunk:701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 714--725 | `f:msm_comm_ctrl_deinit` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 726--727 | `chunk:726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 728--749 | `f:msm_comm_set_stream_output_mode` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 750--750 | `f:msm_comm_get_stream_output_mode` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 751--766 | `chunk:751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 767--775 | `f:msm_comm_get_mbs_per_sec` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 776--789 | `chunk:776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 790--800 | `f:msm_comm_get_inst_load` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 801--825 | `chunk:801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 826--835 | `chunk:826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 836--840 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 841--850 | `f:msm_comm_get_inst_load_per_core` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 851--851 | `chunk:851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 852--874 | `f:msm_comm_get_load` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 875--875 | `f:get_hal_domain` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 876--879 | `chunk:876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 880--882 | `case:MSM_VIDC_ENCODER` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 883--885 | `case:MSM_VIDC_DECODER` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 886--888 | `case:MSM_VIDC_CVP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 889--897 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 898--900 | `f:get_hal_codec` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 901--902 | `chunk:901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 903--903 | `case:V4L2_PIX_FMT_H264` | `V4L2_PIX_FMT_H264` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 904--906 | `case:V4L2_PIX_FMT_H264_NO_SC` | `V4L2_PIX_FMT_H264_NO_SC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 907--909 | `case:V4L2_PIX_FMT_H264_MVC` | `V4L2_PIX_FMT_H264_MVC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 910--912 | `case:V4L2_PIX_FMT_MPEG1` | `V4L2_PIX_FMT_MPEG1` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 913--915 | `case:V4L2_PIX_FMT_MPEG2` | `V4L2_PIX_FMT_MPEG2` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 916--918 | `case:V4L2_PIX_FMT_VP8` | `V4L2_PIX_FMT_VP8` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 919--921 | `case:V4L2_PIX_FMT_VP9` | `V4L2_PIX_FMT_VP9` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 922--924 | `case:V4L2_PIX_FMT_HEVC` | `V4L2_PIX_FMT_HEVC` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 925--925 | `case:V4L2_PIX_FMT_TME` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 926--927 | `chunk:926` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 928--930 | `case:V4L2_PIX_FMT_CVP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 931--939 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 940--944 | `f:msm_comm_get_hal_uncompressed` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 945--947 | `case:V4L2_PIX_FMT_NV12` | `V4L2_PIX_FMT_NV12` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 948--950 | `case:V4L2_PIX_FMT_NV12_512` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 951--953 | `case:V4L2_PIX_FMT_NV21, chunk:951` | `V4L2_PIX_FMT_NV21` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 954--956 | `case:V4L2_PIX_FMT_NV12_UBWC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 957--959 | `case:V4L2_PIX_FMT_NV12_TP10_UBWC` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 960--962 | `case:V4L2_PIX_FMT_SDE_Y_CBCR_H2V2_P010_VENUS` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 963--970 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 971--975 | `f:get_vidc_core` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 976--993 | `chunk:976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 994--1000 | `f:msm_comm_get_pixel_fmt_index` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 1001--1016 | `chunk:1001` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1017--1025 | `f:msm_comm_get_pixel_fmt_fourcc` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 1026--1036 | `chunk:1026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1037--1050 | `f:msm_comm_get_pixel_fmt_constraints` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 1051--1056 | `chunk:1051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1057--1066 | `f:msm_comm_get_vb2q` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1067--1075 | `f:handle_sys_init_done` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1076--1100 | `chunk:1076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1101--1125 | `chunk:1101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1126--1127 | `chunk:1126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1128--1135 | `f:put_inst_helper` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1136--1143 | `f:put_inst` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1144--1150 | `f:get_inst` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1151--1175 | `chunk:1151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1176--1182 | `chunk:1176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1183--1200 | `f:handle_session_release_buf_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1201--1225 | `chunk:1201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1226--1240 | `chunk:1226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1241--1250 | `f:handle_sys_release_res_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1251--1260 | `chunk:1251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1261--1275 | `f:change_inst_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1276--1276 | `chunk:1276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1277--1280 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1281--1296 | `f:signal_session_msg_receipt` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1297--1300 | `f:wait_for_sess_signal_receipt` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1301--1322 | `chunk:1301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1323--1325 | `f:wait_for_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1326--1338 | `chunk:1326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1339--1342 | `label:err_same_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1343--1349 | `f:msm_vidc_queue_v4l2_event` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1350--1350 | `f:msm_comm_generate_max_clients_error` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1351--1364 | `chunk:1351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1365--1372 | `f:print_cap` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1373--1375 | `f:msm_vidc_comm_update_ctrl` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1376--1396 | `chunk:1376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1397--1400 | `f:msm_vidc_comm_update_ctrl_limits` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1401--1425 | `chunk:1401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1426--1450 | `chunk:1426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1451--1470 | `chunk:1451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1471--1475 | `f:handle_session_init_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1476--1500 | `chunk:1476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1501--1525 | `chunk:1501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1526--1550 | `chunk:1526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1551--1575 | `chunk:1551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1576--1600 | `chunk:1576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1601--1610 | `chunk:1601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1611--1625 | `f:msm_vidc_queue_rbr_event` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1626--1650 | `chunk:1626, f:handle_event_change` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1651--1651 | `chunk:1651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1652--1654 | `case:HAL_EVENT_SEQ_CHANGED_SUFFICIENT_RESOURCES` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1655--1657 | `case:HAL_EVENT_SEQ_CHANGED_INSUFFICIENT_RESOURCES` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1658--1675 | `case:HAL_EVENT_RELEASE_BUFFER_REFERENCE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1676--1682 | `chunk:1676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1683--1700 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1701--1719 | `chunk:1701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1720--1725 | `label:MSM_VIDC_PIC_STRUCT_PROGRESSIVE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1726--1750 | `chunk:1726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1751--1775 | `chunk:1751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1776--1800 | `chunk:1776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1801--1825 | `chunk:1801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1826--1827 | `chunk:1826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1828--1831 | `label:err_bad_event` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1832--1850 | `f:handle_session_prop_info` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1851--1869 | `chunk:1851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1870--1873 | `label:err_prop_info` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1874--1875 | `f:handle_load_resource_done` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1876--1900 | `chunk:1876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1901--1901 | `chunk:1901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1902--1922 | `f:handle_start_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1923--1925 | `f:handle_stop_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1926--1943 | `chunk:1926` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1944--1950 | `f:handle_release_res_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 1951--1965 | `chunk:1951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1966--1975 | `f:msm_comm_validate_output_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 1976--2000 | `chunk:1976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2001--2006 | `chunk:2001` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2007--2025 | `f:msm_comm_queue_output_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2026--2050 | `chunk:2026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2051--2060 | `chunk:2051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2061--2075 | `f:handle_session_flush` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2076--2100 | `chunk:2076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2101--2104 | `chunk:2101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2105--2107 | `case:HAL_FLUSH_INPUT` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2108--2110 | `case:HAL_FLUSH_OUTPUT` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2111--2114 | `case:HAL_FLUSH_ALL` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2115--2123 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2124--2125 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2126--2128 | `chunk:2126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2129--2150 | `f:handle_session_error` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2151--2175 | `chunk:2151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2176--2179 | `chunk:2176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2180--2200 | `f:msm_comm_clean_notify_client` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2201--2203 | `chunk:2201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2204--2225 | `f:handle_sys_error` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2226--2250 | `chunk:2226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2251--2263 | `chunk:2251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2264--2275 | `f:msm_comm_session_clean` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2276--2291 | `chunk:2276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2292--2300 | `f:handle_session_close` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2301--2314 | `chunk:2301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2315--2325 | `f:msm_comm_get_vb_using_vidc_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2326--2348 | `chunk:2326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2349--2350 | `label:unlock` | `unlock` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2351--2358 | `chunk:2351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2359--2375 | `f:msm_comm_vb2_buffer_done` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2376--2400 | `chunk:2376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2401--2410 | `chunk:2401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2411--2425 | `f:heic_encode_session_supported` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2426--2450 | `chunk:2426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2451--2454 | `chunk:2451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2455--2474 | `f:is_eos_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2475--2475 | `f:handle_ebd` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 2476--2500 | `chunk:2476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2501--2525 | `chunk:2501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2526--2550 | `chunk:2526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2551--2565 | `chunk:2551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2566--2569 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2570--2575 | `f:handle_multi_stream_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2576--2600 | `chunk:2576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2601--2602 | `chunk:2601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2603--2611 | `f:msm_comm_get_hal_output_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2612--2625 | `f:handle_fbd` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 2626--2650 | `chunk:2626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2651--2675 | `chunk:2651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2676--2700 | `chunk:2676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2701--2715 | `chunk:2701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2716--2718 | `case:HAL_PICTURE_P` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2719--2721 | `case:HAL_PICTURE_B` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2722--2722 | `case:HAL_FRAME_NOTCODED` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2723--2724 | `case:HAL_UNUSED_PICT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2725--2725 | `case:HAL_FRAME_YUV` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2726--2726 | `chunk:2726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2727--2745 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2746--2749 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2750--2750 | `f:handle_cmd_response` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2751--2753 | `chunk:2751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2754--2756 | `case:HAL_SYS_INIT_DONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2757--2759 | `case:HAL_SYS_RELEASE_RESOURCE_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2760--2762 | `case:HAL_SESSION_INIT_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2763--2765 | `case:HAL_SESSION_PROPERTY_INFO` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2766--2768 | `case:HAL_SESSION_LOAD_RESOURCE_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2769--2771 | `case:HAL_SESSION_START_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2772--2774 | `case:HAL_SESSION_ETB_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2775--2775 | `case:HAL_SESSION_FTB_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2776--2777 | `chunk:2776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2778--2780 | `case:HAL_SESSION_STOP_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2781--2783 | `case:HAL_SESSION_RELEASE_RESOURCE_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2784--2784 | `case:HAL_SESSION_END_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2785--2787 | `case:HAL_SESSION_ABORT_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2788--2790 | `case:HAL_SESSION_EVENT_CHANGE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2791--2793 | `case:HAL_SESSION_FLUSH_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2794--2794 | `case:HAL_SYS_WATCHDOG_TIMEOUT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2795--2797 | `case:HAL_SYS_ERROR` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2798--2800 | `case:HAL_SESSION_ERROR` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2801--2803 | `case:HAL_SESSION_RELEASE_BUFFER_DONE, chunk:2801` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2804--2806 | `case:HAL_SESSION_REGISTER_BUFFER_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2807--2809 | `case:HAL_SESSION_UNREGISTER_BUFFER_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2810--2815 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2816--2818 | `f:msm_comm_vidc_thermal_level` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 2819--2820 | `case:0` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2821--2822 | `case:1` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2823--2824 | `case:2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2825--2825 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2826--2829 | `chunk:2826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2830--2843 | `f:is_core_turbo` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2844--2850 | `f:is_thermal_permissible` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 2851--2875 | `chunk:2851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2876--2876 | `chunk:2876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2877--2900 | `f:is_batching_allowed` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 2901--2907 | `chunk:2901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2908--2925 | `f:msm_comm_session_abort` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 2926--2939 | `chunk:2926` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2940--2943 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2944--2950 | `f:handle_thermal_event` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 2951--2975 | `chunk:2951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2976--2983 | `chunk:2976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2984--2987 | `label:err_sess_abort` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 2988--3000 | `f:msm_comm_handle_thermal_event` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 3001--3024 | `chunk:3001, f:msm_comm_check_core_init` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3025--3025 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3026--3029 | `chunk:3026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3030--3043 | `f:msm_comm_init_core_done` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3044--3050 | `f:msm_comm_init_core` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3051--3075 | `chunk:3051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3076--3086 | `chunk:3076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3087--3093 | `label:core_already_inited` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3094--3095 | `label:fail_core_init` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3096--3100 | `label:fail_cap_alloc` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3101--3102 | `chunk:3101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3103--3125 | `f:msm_vidc_deinit_core` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3126--3145 | `chunk:3126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3146--3150 | `label:core_already_uninited` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3151--3151 | `chunk:3151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3152--3157 | `f:msm_comm_force_cleanup` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3158--3174 | `f:msm_comm_session_init_done` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3175--3175 | `f:msm_comm_init_buffer_count` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3176--3200 | `chunk:3176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3201--3225 | `chunk:3201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3226--3250 | `chunk:3226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3251--3264 | `chunk:3251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3265--3275 | `f:msm_comm_session_init` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3276--3300 | `chunk:3276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3301--3321 | `chunk:3301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3322--3325 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3326--3350 | `chunk:3326, f:msm_vidc_print_running_insts` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3351--3366 | `chunk:3351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3367--3375 | `f:msm_vidc_load_resources` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3376--3400 | `chunk:3376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3401--3417 | `chunk:3401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3418--3421 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3422--3425 | `f:msm_vidc_start` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3426--3450 | `chunk:3426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3451--3454 | `chunk:3451, label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3455--3475 | `f:msm_vidc_stop` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3476--3483 | `chunk:3476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3484--3487 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3488--3500 | `f:msm_vidc_release_res` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3501--3516 | `chunk:3501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3517--3520 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3521--3525 | `f:msm_comm_session_close` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3526--3545 | `chunk:3526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3546--3549 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3550--3550 | `f:msm_comm_suspend` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3551--3575 | `chunk:3551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3576--3576 | `chunk:3576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3577--3596 | `f:get_flipped_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3597--3600 | `f:msm_comm_reset_bufreqs` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3601--3619 | `chunk:3601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3620--3625 | `f:msm_comm_copy_bufreqs` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3626--3648 | `chunk:3626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3649--3650 | `f:get_buff_req_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3651--3661 | `chunk:3651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3662--3675 | `f:set_output_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3676--3700 | `chunk:3676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3701--3725 | `chunk:3701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3726--3750 | `chunk:3726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3751--3767 | `chunk:3751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3768--3769 | `label:fail_set_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3770--3771 | `label:err_no_mem` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3772--3775 | `label:fail_kzalloc` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3776--3778 | `chunk:3776, f:get_buffer_name` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3779--3779 | `case:HAL_BUFFER_INPUT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3780--3780 | `case:HAL_BUFFER_OUTPUT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3781--3781 | `case:HAL_BUFFER_OUTPUT2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3782--3782 | `case:HAL_BUFFER_EXTRADATA_INPUT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3783--3783 | `case:HAL_BUFFER_EXTRADATA_OUTPUT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3784--3784 | `case:HAL_BUFFER_EXTRADATA_OUTPUT2` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3785--3785 | `case:HAL_BUFFER_INTERNAL_SCRATCH` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3786--3786 | `case:HAL_BUFFER_INTERNAL_SCRATCH_1` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3787--3787 | `case:HAL_BUFFER_INTERNAL_SCRATCH_2` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3788--3788 | `case:HAL_BUFFER_INTERNAL_PERSIST` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3789--3789 | `case:HAL_BUFFER_INTERNAL_PERSIST_1` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3790--3790 | `case:HAL_BUFFER_INTERNAL_CMD_QUEUE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3791--3794 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3795--3800 | `f:set_internal_buf_on_fw` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3801--3825 | `chunk:3801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3826--3828 | `chunk:3826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3829--3850 | `f:reuse_internal_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3851--3874 | `chunk:3851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3875--3875 | `f:allocate_and_set_internal_bufs` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3876--3900 | `chunk:3876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3901--3921 | `chunk:3901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3922--3923 | `label:fail_set_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3924--3925 | `label:err_no_mem` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3926--3930 | `chunk:3926, label:fail_kzalloc` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3931--3950 | `f:set_internal_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 3951--3958 | `chunk:3951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3959--3975 | `f:msm_comm_try_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 3976--3984 | `chunk:3976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3985--3985 | `case:MSM_VIDC_CORE_UNINIT_DONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3986--3989 | `case:MSM_VIDC_CORE_INIT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3990--3993 | `case:MSM_VIDC_CORE_INIT_DONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3994--3997 | `case:MSM_VIDC_OPEN` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 3998--4000 | `case:MSM_VIDC_OPEN_DONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4001--4001 | `chunk:4001` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4002--4005 | `case:MSM_VIDC_LOAD_RESOURCES` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4006--4006 | `case:MSM_VIDC_LOAD_RESOURCES_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4007--4010 | `case:MSM_VIDC_START` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4011--4015 | `case:MSM_VIDC_START_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4016--4019 | `case:MSM_VIDC_STOP` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4020--4025 | `case:MSM_VIDC_STOP_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4026--4029 | `case:MSM_VIDC_RELEASE_RESOURCES, chunk:4026` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4030--4037 | `case:MSM_VIDC_RELEASE_RESOURCES_DONE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4038--4041 | `case:MSM_VIDC_CLOSE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4042--4047 | `case:MSM_VIDC_CLOSE_DONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4048--4048 | `case:MSM_VIDC_CORE_UNINIT` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4049--4050 | `case:MSM_VIDC_CORE_INVALID` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4051--4053 | `chunk:4051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4054--4059 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4060--4074 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4075--4075 | `f:msm_vidc_send_pending_eos_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4076--4100 | `chunk:4076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4101--4109 | `chunk:4101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4110--4125 | `f:msm_vidc_comm_cmd` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4126--4134 | `chunk:4126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4135--4141 | `case:V4L2_QCOM_CMD_FLUSH` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4142--4147 | `case:V4L2_QCOM_CMD_SESSION_CONTINUE` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4148--4150 | `case:V4L2_DEC_CMD_STOP` | `V4L2_DEC_CMD_STOP` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 4151--4175 | `chunk:4151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4176--4193 | `chunk:4176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4194--4200 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4201--4201 | `chunk:4201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4202--4225 | `f:populate_frame_data` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4226--4250 | `chunk:4226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4251--4263 | `chunk:4251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4264--4275 | `f:get_hal_buffer_type` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4276--4281 | `chunk:4276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4282--4300 | `f:msm_comm_num_queued_bufs` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4301--4304 | `chunk:4301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4305--4325 | `f:num_pending_qbufs` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4326--4328 | `chunk:4326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4329--4350 | `f:msm_comm_qbuf_to_hfi` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4351--4365 | `chunk:4351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4366--4369 | `label:err_bad_input` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4370--4375 | `f:msm_vidc_batch_handler` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 4376--4400 | `chunk:4376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4401--4404 | `chunk:4401, label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4405--4425 | `f:msm_comm_qbuf_in_rbr` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4426--4431 | `chunk:4426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4432--4450 | `f:msm_comm_qbuf` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4451--4463 | `chunk:4451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4464--4475 | `f:msm_comm_qbufs` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4476--4500 | `chunk:4476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4501--4501 | `chunk:4501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4502--4525 | `f:msm_comm_qbufs_batch` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4526--4527 | `chunk:4526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4528--4544 | `label:loop_end` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4545--4550 | `f:msm_comm_qbuf_decode_batch` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 4551--4575 | `chunk:4551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4576--4595 | `chunk:4576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4596--4600 | `f:msm_comm_try_get_bufreqs` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 4601--4625 | `chunk:4601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4626--4650 | `chunk:4626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4651--4675 | `chunk:4651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4676--4678 | `chunk:4676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4679--4700 | `f:msm_comm_try_get_prop` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4701--4711 | `chunk:4701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4712--4714 | `case:HAL_PARAM_GET_BUFFER_REQUIREMENTS` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4715--4725 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4726--4750 | `chunk:4726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4751--4755 | `chunk:4751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4756--4759 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4760--4775 | `f:msm_comm_release_output_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4776--4800 | `chunk:4776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4801--4825 | `chunk:4801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4826--4835 | `chunk:4826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4836--4850 | `f:scratch_buf_sufficient` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 4851--4870 | `chunk:4851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4871--4874 | `label:not_sufficient` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4875--4875 | `f:msm_comm_release_scratch_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 4876--4900 | `chunk:4876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4901--4925 | `chunk:4901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4926--4950 | `chunk:4926` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4951--4952 | `chunk:4951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4953--4973 | `f:msm_comm_release_eos_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4974--4975 | `f:msm_comm_release_recon_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 4976--4994 | `chunk:4976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 4995--5000 | `f:msm_comm_release_persist_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 5001--5025 | `chunk:5001` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5026--5050 | `chunk:5026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5051--5055 | `chunk:5051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5056--5075 | `f:msm_comm_try_set_prop` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5076--5082 | `chunk:5076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5083--5087 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5088--5100 | `f:msm_comm_set_buffer_count` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 5101--5111 | `chunk:5101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5112--5125 | `f:msm_comm_set_output_buffers` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5126--5131 | `chunk:5126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5132--5136 | `label:error` | `error` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5137--5150 | `f:msm_comm_set_scratch_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 5151--5164 | `chunk:5151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5165--5169 | `label:error` | `error` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5170--5175 | `f:msm_comm_set_recon_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 5176--5200 | `chunk:5176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5201--5212 | `chunk:5201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5213--5216 | `label:fail_kzalloc` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5217--5225 | `f:msm_comm_set_persist_buffers` | `—` | 内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。 |
| 5226--5235 | `chunk:5226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5236--5240 | `label:error` | `error` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5241--5250 | `f:msm_comm_flush_in_invalid_state` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 5251--5273 | `chunk:5251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5274--5275 | `f:msm_comm_flush` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 5276--5300 | `chunk:5276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5301--5325 | `chunk:5301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5326--5350 | `chunk:5326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5351--5375 | `chunk:5351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5376--5384 | `chunk:5376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5385--5390 | `f:msm_comm_get_hal_extradata_index` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5391--5393 | `case:V4L2_MPEG_VIDC_EXTRADATA_NONE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5394--5396 | `case:V4L2_MPEG_VIDC_EXTRADATA_INTERLACE_VIDEO` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5397--5399 | `case:V4L2_MPEG_VIDC_EXTRADATA_TIMESTAMP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5400--5400 | `case:V4L2_MPEG_VIDC_EXTRADATA_S3D_FRAME_PACKING` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5401--5402 | `chunk:5401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5403--5405 | `case:V4L2_MPEG_VIDC_EXTRADATA_FRAME_RATE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5406--5408 | `case:V4L2_MPEG_VIDC_EXTRADATA_PANSCAN_WINDOW` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5409--5411 | `case:V4L2_MPEG_VIDC_EXTRADATA_RECOVERY_POINT_SEI` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5412--5414 | `case:V4L2_MPEG_VIDC_EXTRADATA_NUM_CONCEALED_MB` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5415--5417 | `case:V4L2_MPEG_VIDC_EXTRADATA_ASPECT_RATIO` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5418--5420 | `case:V4L2_MPEG_VIDC_EXTRADATA_MPEG2_SEQDISP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5421--5423 | `case:V4L2_MPEG_VIDC_EXTRADATA_STREAM_USERDATA` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5424--5425 | `case:V4L2_MPEG_VIDC_EXTRADATA_FRAME_QP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5426--5426 | `chunk:5426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5427--5429 | `case:V4L2_MPEG_VIDC_EXTRADATA_ENC_FRAME_QP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5430--5432 | `case:V4L2_MPEG_VIDC_EXTRADATA_LTR` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5433--5435 | `case:V4L2_MPEG_VIDC_EXTRADATA_ROI_QP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5436--5438 | `case:V4L2_MPEG_VIDC_EXTRADATA_OUTPUT_CROP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5439--5441 | `case:V4L2_MPEG_VIDC_EXTRADATA_DISPLAY_COLOUR_SEI` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5442--5444 | `case:V4L2_MPEG_VIDC_EXTRADATA_CONTENT_LIGHT_LEVEL_SEI` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5445--5447 | `case:V4L2_MPEG_VIDC_EXTRADATA_VUI_DISPLAY` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5448--5450 | `case:V4L2_MPEG_VIDC_EXTRADATA_VPX_COLORSPACE` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5451--5453 | `case:V4L2_MPEG_VIDC_EXTRADATA_UBWC_CR_STATS_INFO, chunk:5451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5454--5456 | `case:V4L2_MPEG_VIDC_EXTRADATA_HDR10PLUS_METADATA` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5457--5459 | `case:V4L2_MPEG_VIDC_EXTRADATA_ENC_DTS` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5460--5462 | `case:V4L2_MPEG_VIDC_EXTRADATA_INPUT_CROP` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5463--5469 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5470--5475 | `f:msm_vidc_noc_error_info` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5476--5491 | `chunk:5476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5492--5500 | `f:msm_vidc_trigger_ssr` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5501--5503 | `chunk:5501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5504--5525 | `f:msm_vidc_ssr_handler` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5526--5541 | `chunk:5526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5542--5550 | `f:msm_vidc_load_supported` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5551--5566 | `chunk:5551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5567--5575 | `f:msm_vidc_check_scaling_supported` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 5576--5600 | `chunk:5576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5601--5625 | `chunk:5601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5626--5648 | `chunk:5626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5649--5650 | `f:msm_vidc_check_session_supported` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 5651--5675 | `chunk:5651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5676--5700 | `chunk:5676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5701--5725 | `chunk:5701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5726--5731 | `chunk:5726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5732--5746 | `f:msm_comm_generate_session_error` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 5747--5750 | `f:msm_comm_generate_sys_error` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5751--5763 | `chunk:5751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5764--5775 | `f:msm_comm_kill_session` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 5776--5800 | `chunk:5776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5801--5803 | `chunk:5801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5804--5819 | `f:msm_comm_smem_alloc` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5820--5825 | `f:msm_comm_smem_free` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5826--5829 | `chunk:5826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5830--5850 | `f:msm_vidc_fw_unload_handler` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5851--5866 | `chunk:5851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5867--5875 | `f:msm_comm_set_color_format` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 5876--5900 | `chunk:5876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5901--5901 | `chunk:5901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5902--5905 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5906--5924 | `f:msm_vidc_comm_s_parm` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5925--5925 | `case:V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5926--5931 | `case:V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, chunk:5926` | `V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5932--5950 | `case:default` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5951--5975 | `chunk:5951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5976--5979 | `chunk:5976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5980--5983 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 5984--6000 | `f:msm_comm_print_inst_info` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6001--6025 | `chunk:6001` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6026--6043 | `chunk:6026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6044--6050 | `f:msm_comm_session_continue` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 6051--6075 | `chunk:6051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6076--6093 | `chunk:6076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6094--6098 | `label:sess_continue_fail` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6099--6100 | `f:get_frame_size_nv12` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6101--6103 | `chunk:6101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6104--6108 | `f:get_frame_size_nv12_ubwc` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6109--6113 | `f:get_frame_size_rgba` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6114--6118 | `f:get_frame_size_nv21` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6119--6123 | `f:get_frame_size_tp10_ubwc` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6124--6125 | `f:get_frame_size_p010` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6126--6128 | `chunk:6126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6129--6133 | `f:get_frame_size_nv12_512` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 6134--6150 | `f:print_vidc_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6151--6168 | `chunk:6151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6169--6175 | `f:print_vb2_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6176--6194 | `chunk:6176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6195--6200 | `f:print_v4l2_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6201--6224 | `chunk:6201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6225--6225 | `f:msm_comm_compare_vb2_plane` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6226--6244 | `chunk:6226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6245--6250 | `f:msm_comm_compare_vb2_planes` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6251--6269 | `chunk:6251` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6270--6275 | `f:msm_comm_compare_dma_plane` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6276--6284 | `chunk:6276` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6285--6300 | `f:msm_comm_compare_dma_planes` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6301--6306 | `chunk:6301` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6307--6322 | `f:msm_comm_compare_device_plane` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6323--6325 | `f:msm_comm_compare_device_planes` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6326--6338 | `chunk:6326` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6339--6350 | `f:msm_comm_get_buffer_using_device_planes` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6351--6363 | `chunk:6351` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6364--6375 | `f:msm_comm_flush_vidc_buffer` | `—` | 会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。 |
| 6376--6400 | `chunk:6376` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6401--6404 | `chunk:6401` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6405--6425 | `f:msm_comm_qbuf_cache_operations` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6426--6450 | `chunk:6426` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6451--6475 | `chunk:6451` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6476--6476 | `chunk:6476` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6477--6500 | `f:msm_comm_dqbuf_cache_operations` | `—` | buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。 |
| 6501--6525 | `chunk:6501` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6526--6540 | `chunk:6526` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6541--6550 | `f:msm_comm_get_vidc_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6551--6575 | `chunk:6551` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6576--6600 | `chunk:6576` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6601--6625 | `chunk:6601` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6626--6650 | `chunk:6626` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6651--6675 | `chunk:6651` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6676--6681 | `chunk:6676` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6682--6691 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6692--6700 | `f:msm_comm_put_vidc_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6701--6725 | `chunk:6701` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6726--6743 | `chunk:6726` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6744--6747 | `label:unlock` | `unlock` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6748--6750 | `f:handle_release_buffer_reference` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6751--6775 | `chunk:6751` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6776--6800 | `chunk:6776` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6801--6825 | `chunk:6801` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6826--6836 | `chunk:6826` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6837--6848 | `label:unlock` | `unlock` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6849--6850 | `f:msm_comm_unmap_vidc_buffer` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6851--6875 | `chunk:6851` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6876--6878 | `chunk:6876` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6879--6886 | `f:kref_free_mbuf` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6887--6894 | `f:kref_put_mbuf` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6895--6900 | `f:kref_get_mbuf` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6901--6916 | `chunk:6901` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6917--6925 | `f:msm_comm_free_buffer_tags` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6926--6935 | `chunk:6926` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6936--6950 | `f:msm_comm_store_tags` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6951--6974 | `chunk:6951` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6975--6975 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6976--6978 | `chunk:6976` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 6979--7000 | `f:msm_comm_fetch_tags` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7001--7025 | `chunk:7001, f:msm_comm_store_filled_length` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7026--7032 | `chunk:7026` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7033--7036 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7037--7050 | `f:msm_comm_fetch_filled_length` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7051--7057 | `chunk:7051` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7058--7075 | `f:msm_comm_store_mark_data` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7076--7091 | `chunk:7076` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7092--7095 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7096--7100 | `f:msm_comm_fetch_mark_data` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7101--7120 | `chunk:7101` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7121--7125 | `f:msm_comm_release_mark_data` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7126--7147 | `chunk:7126` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7148--7150 | `f:msm_comm_set_color_format_constraints` | `—` | 格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。 |
| 7151--7175 | `chunk:7151` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7176--7200 | `chunk:7176` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7201--7212 | `chunk:7201` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7213--7218 | `label:exit` | `exit` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |
| 7219--7225 | `f:msm_comm_check_for_inst_overload` | `—` | 平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。 |
| 7226--7240 | `chunk:7226` | `—` | 状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。 |

覆盖校验：7240/7240 行，连续、无空洞、无重叠。

## `msm_vidc_common.h`

- 原厂物理行：268；当前语义落点：`helpers.h + hfi.h + core.h`；默认判定：**架构替代**。
- 文件级结论：不保留 vendor HAL 层对象布局。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 14--25 | `pp:ifndef _MSM_VIDC_COMMON_H_` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 26--50 | `chunk:26` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 51--75 | `chunk:51` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 76--100 | `chunk:76` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 101--125 | `chunk:101` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 126--150 | `chunk:126` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 151--175 | `chunk:151` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 176--200 | `chunk:176` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 201--225 | `chunk:201` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 226--250 | `chunk:226` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 251--267 | `chunk:251` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |
| 268--268 | `pp:endif` | `—` | 架构替代：不保留 vendor HAL 层对象布局。 |

覆盖校验：268/268 行，连续、无空洞、无重叠。

## `msm_vidc_debug.c`

- 原厂物理行：546；当前语义落点：`debugfs/tracepoint/dev_dbg + HFI dump`；默认判定：**诊断参考**。
- 文件级结论：只保留低噪声、无副作用的取证；debug 不作为功能前置。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 14--14 | `d:CREATE_TRACE_POINTS` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 15--18 | `d:MAX_SSR_STRING_LEN` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 19--19 | `v:msm_vidc_debug` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 20--21 | `v:msm_vidc_debug` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 22--22 | `v:msm_vidc_debug_out` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 23--25 | `v:msm_vidc_debug_out` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 26--26 | `chunk:26, v:msm_vidc_fw_debug` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 27--27 | `v:msm_vidc_fw_debug_mode` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 28--28 | `v:msm_vidc_fw_low_power_mode` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 29--29 | `v:msm_vidc_fw_coverage` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 30--30 | `v:msm_vidc_thermal_mitigation_disabled` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 31--31 | `v:msm_vidc_clock_voting` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 32--33 | `v:msm_vidc_syscache_disable` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 34--35 | `d:MAX_DBG_BUF_SIZE` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 36--39 | `d:DYNAMIC_BUF_OWNER` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 40--44 | `s:core_inst_pair` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 45--50 | `f:core_info_open` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 51--62 | `chunk:51, f:write_str` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 63--75 | `f:core_info_read` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 76--100 | `chunk:76` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 101--106 | `chunk:101` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 107--119 | `label:err_fw_info` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 120--120 | `v:core_info_fops` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 121--121 | `field:open` | `open` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 122--124 | `field:read` | `read` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 125--125 | `f:trigger_ssr_open` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 126--130 | `chunk:126` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 131--150 | `f:trigger_ssr_write` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 151--162 | `chunk:151` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 163--166 | `label:exit` | `exit` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 167--167 | `v:ssr_fops` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 168--168 | `field:open` | `open` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 169--171 | `field:write` | `write` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 172--175 | `f:msm_vidc_debugfs_init_drv` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 176--182 | `chunk:176` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 183--200 | `d:__debugfs_create` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 201--208 | `chunk:201` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 209--215 | `d:__debugfs_create` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 216--222 | `label:failed_create_dir` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 223--225 | `f:msm_vidc_debugfs_init_core` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 226--248 | `chunk:226` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 249--250 | `label:failed_create_dir` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 251--252 | `chunk:251` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 253--259 | `f:inst_info_open` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 260--275 | `f:publish_unreleased_reference` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 276--293 | `chunk:276` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 294--300 | `f:put_inst_helper` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 301--301 | `chunk:301` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 302--325 | `f:inst_info_read` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 326--350 | `chunk:326` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 351--367 | `chunk:351` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 368--371 | `case:HAL_BUFFER_MODE_STATIC` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 372--375 | `case:HAL_BUFFER_MODE_DYNAMIC` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 376--400 | `case:default, chunk:376` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 401--407 | `chunk:401` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 408--412 | `label:failed_alloc` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 413--419 | `f:inst_info_release` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 420--420 | `v:inst_info_fops` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 421--421 | `field:open` | `open` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 422--422 | `field:read` | `read` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 423--425 | `field:release` | `release` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 426--450 | `chunk:426, f:msm_vidc_debugfs_init_inst` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 451--464 | `chunk:451` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 465--467 | `label:failed_create_file` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 468--469 | `label:failed_create_dir` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 470--473 | `label:exit` | `exit` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 474--475 | `f:msm_vidc_debugfs_deinit_inst` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 476--490 | `chunk:476` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 491--497 | `f:msm_vidc_debugfs_update` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 498--500 | `case:MSM_VIDC_DEBUGFS_EVENT_ETB` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 501--504 | `chunk:501` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 505--513 | `case:MSM_VIDC_DEBUGFS_EVENT_EBD` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 514--521 | `case:MSM_VIDC_DEBUGFS_EVENT_FTB` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 522--525 | `case:MSM_VIDC_DEBUGFS_EVENT_FBD` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 526--532 | `chunk:526` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 533--538 | `case:default` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 539--546 | `f:msm_vidc_check_ratelimit` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |

覆盖校验：546/546 行，连续、无空洞、无重叠。

## `msm_vidc_debug.h`

- 原厂物理行：216；当前语义落点：`标准 dev_* / tracepoint`；默认判定：**诊断参考**。
- 文件级结论：不复制 vendor 日志宏体系。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 14--20 | `pp:ifndef __MSM_VIDC_DEBUG__` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 21--22 | `pp:ifndef VIDC_DBG_LABEL` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 23--25 | `pp:endif` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 26--50 | `chunk:26` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 51--75 | `chunk:51` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 76--100 | `chunk:76` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 101--114 | `chunk:101` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 115--116 | `case:VIDC_ERR` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 117--118 | `case:VIDC_WARN` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 119--120 | `case:VIDC_INFO` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 121--122 | `case:VIDC_DBG` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 123--124 | `case:VIDC_PROF` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 125--125 | `case:VIDC_PKT` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 126--126 | `chunk:126` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 127--128 | `case:VIDC_FW` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 129--150 | `case:default` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 151--175 | `chunk:151` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 176--200 | `chunk:176` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 201--215 | `chunk:201` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |
| 216--216 | `pp:endif` | `—` | 诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。 |

覆盖校验：216/216 行，连续、无空洞、无重叠。

## `msm_vidc_internal.h`

- 原厂物理行：567；当前语义落点：`core.h + HFI/V4L2 标准结构`；默认判定：**语义拆分**。
- 文件级结论：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 14--25 | `pp:ifndef _MSM_VIDC_INTERNAL_H_` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 276--300 | `chunk:276` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 301--325 | `chunk:301` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 326--350 | `chunk:326` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 351--375 | `chunk:351` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 376--400 | `chunk:376` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 401--425 | `chunk:401` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 426--450 | `chunk:426` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 451--475 | `chunk:451` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 476--500 | `chunk:476` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 501--525 | `chunk:501` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 526--550 | `chunk:526` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 551--566 | `chunk:551` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |
| 567--567 | `pp:endif` | `—` | 语义拆分：结构字段按所有权和 ABI 迁移，禁止按内存布局复制。 |

覆盖校验：567/567 行，连续、无空洞、无重叠。

## `msm_vidc_platform.c`

- 原厂物理行：997；当前语义落点：`core.c resources + firmware capability parser`；默认判定：**部分迁移**。
- 文件级结论：SM8150 codec/cycles/platform flags 是真值；私有平台对象不搬。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 26--29 | `chunk:26` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 30--31 | `d:CODEC_ENTRY` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 32--32 | `field:fourcc` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 33--33 | `field:session_type` | `session_type` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 34--34 | `field:vsp_cycles` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 35--35 | `field:vpp_cycles` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 36--38 | `field:low_power_cycles` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 39--44 | `d:UBWC_CONFIG` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 45--45 | `field:nMaxChannels` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 46--46 | `field:nMalLength` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 47--47 | `field:nHighestBankBit` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 48--50 | `field:reserved2` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 51--51 | `chunk:51` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 52--53 | `d:EFUSE_ENTRY` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 54--54 | `field:start_address` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 55--55 | `field:size` | `size` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 56--56 | `field:mask` | `mask` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 57--57 | `field:shift` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 58--60 | `field:purpose` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 61--66 | `v:default_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 67--75 | `v:atoll_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 76--79 | `chunk:76` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 80--92 | `v:sm6150_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 93--100 | `v:trinket_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 101--105 | `chunk:101` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 106--117 | `v:sm8150_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 118--125 | `v:sdmmagpie_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 126--129 | `chunk:126` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 130--141 | `v:sdm845_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 142--150 | `v:sdm670_codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 151--159 | `chunk:151` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 160--164 | `v:vpe_csc_custom_matrix_coeff` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 165--169 | `v:vpe_csc_custom_bias_coeff` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 170--173 | `v:vpe_csc_custom_limit_coeff` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 174--175 | `v:default_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 176--176 | `chunk:176, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 177--180 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 181--182 | `v:atoll_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 183--183 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 184--186 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 187--187 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 188--190 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 191--191 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 192--194 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 195--195 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 196--198 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 199--199 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 200--200 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 201--202 | `chunk:201` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 203--203 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 204--206 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 207--207 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 208--210 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 211--211 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 212--214 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 215--215 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 216--218 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 219--219 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 220--222 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 223--223 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 224--225 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 226--226 | `chunk:226` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 227--227 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 228--230 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 231--231 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 232--234 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 235--235 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 236--239 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 240--241 | `v:sm6150_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 242--242 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 243--245 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 246--246 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 247--249 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 250--250 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 251--253 | `chunk:251, field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 254--254 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 255--257 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 258--258 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 259--261 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 262--262 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 263--265 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 266--266 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 267--269 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 270--270 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 271--273 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 274--274 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 275--275 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 276--277 | `chunk:276` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 278--278 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 279--281 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 282--282 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 283--285 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 286--286 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 287--289 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 290--290 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 291--293 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 294--294 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 295--298 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 299--300 | `v:trinket_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 301--301 | `chunk:301, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 302--304 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 305--305 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 306--308 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 309--309 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 310--312 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 313--313 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 314--316 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 317--317 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 318--320 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 321--321 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 322--324 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 325--325 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 326--328 | `chunk:326, field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 329--329 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 330--332 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 333--333 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 334--336 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 337--337 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 338--340 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 341--341 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 342--344 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 345--345 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 346--348 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 349--349 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 350--350 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 351--352 | `chunk:351` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 353--353 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 354--357 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 358--359 | `v:sm8150_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 360--360 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 361--363 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 364--364 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 365--367 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 368--368 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 369--371 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 372--372 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 373--375 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 376--376 | `chunk:376, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 377--384 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 385--385 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 386--388 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 389--389 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 390--392 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 393--393 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 394--396 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 397--397 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 398--400 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 401--401 | `chunk:401, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 402--404 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 405--405 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 406--408 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 409--409 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 410--412 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 413--413 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 414--416 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 417--417 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 418--420 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 421--421 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 422--424 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 425--425 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 426--428 | `chunk:426, field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 429--429 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 430--433 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 434--435 | `v:sdmmagpie_common_data_v0` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 436--436 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 437--439 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 440--440 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 441--443 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 444--444 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 445--447 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 448--448 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 449--450 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 451--451 | `chunk:451` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 452--452 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 453--455 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 456--456 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 457--459 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 460--460 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 461--463 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 464--464 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 465--467 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 468--468 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 469--471 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 472--472 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 473--475 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 476--476 | `chunk:476, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 477--479 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 480--480 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 481--483 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 484--484 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 485--487 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 488--488 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 489--491 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 492--492 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 493--495 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 496--496 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 497--499 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 500--500 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 501--504 | `chunk:501, field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 505--506 | `v:sdmmagpie_common_data_v1` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 507--507 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 508--510 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 511--511 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 512--514 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 515--515 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 516--518 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 519--519 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 520--522 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 523--523 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 524--525 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 526--526 | `chunk:526` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 527--527 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 528--530 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 531--531 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 532--534 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 535--535 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 536--538 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 539--539 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 540--542 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 543--543 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 544--546 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 547--547 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 548--550 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 551--551 | `chunk:551, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 552--554 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 555--555 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 556--558 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 559--559 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 560--562 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 563--563 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 564--566 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 567--567 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 568--570 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 571--571 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 572--575 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 576--577 | `chunk:576, v:sdm845_common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 578--578 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 579--581 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 582--582 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 583--585 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 586--586 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 587--589 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 590--590 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 591--593 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 594--594 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 595--597 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 598--598 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 599--600 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 601--601 | `chunk:601` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 602--602 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 603--605 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 606--606 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 607--609 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 610--610 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 611--613 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 614--614 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 615--617 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 618--618 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 619--621 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 622--622 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 623--625 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 626--626 | `chunk:626, field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 627--629 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 630--630 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 631--634 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 635--636 | `v:sdm670_common_data_v0` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 637--637 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 638--640 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 641--641 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 642--644 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 645--645 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 646--648 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 649--649 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 650--650 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 651--652 | `chunk:651` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 653--653 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 654--656 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 657--657 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 658--660 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 661--661 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 662--664 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 665--665 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 666--668 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 669--669 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 670--672 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 673--673 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 674--675 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 676--676 | `chunk:676` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 677--677 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 678--680 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 681--681 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 682--685 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 686--687 | `v:sdm670_common_data_v1` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 688--688 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 689--691 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 692--692 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 693--695 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 696--696 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 697--699 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 700--700 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 701--703 | `chunk:701, field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 704--704 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 705--707 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 708--708 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 709--711 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 712--712 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 713--715 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 716--716 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 717--719 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 720--720 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 721--723 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 724--724 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 725--725 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 726--727 | `chunk:726` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 728--728 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 729--731 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 732--732 | `field:key` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 733--736 | `field:value` | `value` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 737--740 | `v:sdm670_efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 741--744 | `v:sdmmagpie_efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 745--748 | `v:trinket_ubwc_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 749--749 | `v:default_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 750--750 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 751--751 | `chunk:751, field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 752--752 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 753--753 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 754--754 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 755--758 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 759--759 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 760--760 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 761--761 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 762--764 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 765--765 | `v:atoll_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 766--766 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 767--767 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 768--768 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 769--769 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 770--770 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 771--774 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 775--775 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 776--776 | `chunk:776, field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 777--777 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 778--780 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 781--781 | `v:sm6150_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 782--782 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 783--783 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 784--784 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 785--785 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 786--786 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 787--790 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 791--791 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 792--792 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 793--793 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 794--796 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 797--797 | `v:trinket_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 798--798 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 799--799 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 800--800 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 801--801 | `chunk:801, field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 802--802 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 803--806 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 807--807 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 808--808 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 809--809 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 810--812 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 813--813 | `v:sm8150_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 814--814 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 815--815 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 816--816 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 817--817 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 818--818 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 819--822 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 823--823 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 824--824 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 825--825 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 826--828 | `chunk:826, field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 829--829 | `v:sdmmagpie_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 830--830 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 831--831 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 832--832 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 833--833 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 834--834 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 835--838 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 839--839 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 840--840 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 841--841 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 842--844 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 845--845 | `v:sdm845_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 846--846 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 847--847 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 848--848 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 849--849 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 850--850 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 851--854 | `chunk:851, field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 855--855 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 856--856 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 857--857 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 858--860 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 861--861 | `v:sdm670_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 862--862 | `field:codec_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 863--863 | `field:codec_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 864--864 | `field:common_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 865--865 | `field:common_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 866--866 | `field:ubwc_config` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 867--870 | `field:ubwc_config_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 871--871 | `field:efuse_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 872--872 | `field:efuse_data_length` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 873--873 | `field:sku_version` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 874--875 | `field:vpu_ver` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 876--876 | `chunk:876` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 877--878 | `v:msm_vidc_dt_match` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 879--879 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 880--882 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 883--883 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 884--886 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 887--887 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 888--890 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 891--891 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 892--894 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 895--895 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 896--898 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 899--899 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 900--900 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 901--902 | `chunk:901` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 903--903 | `field:compatible` | `compatible` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 904--910 | `field:data` | `data` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 911--922 | `f:msm_vidc_read_efuse` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 923--925 | `case:SKU_VERSION` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 926--946 | `chunk:926` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 947--950 | `case:default` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 951--953 | `chunk:951` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 954--975 | `f:vidc_get_drv_data` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 976--994 | `chunk:976` | `—` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |
| 995--997 | `label:exit` | `exit` | 平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。 |

覆盖校验：997/997 行，连续、无空洞、无重叠。

## `msm_vidc_res_parse.c`

- 原厂物理行：1427；当前语义落点：`DT binding + core.c + pm_helpers.c + IOMMU/ICC`；默认判定：**架构替代**。
- 文件级结论：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--24 | `file:start` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 25--25 | `g:clock_properties` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 26--29 | `chunk:26` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 30--31 | `d:PERF_GOV` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 32--39 | `f:msm_iommu_get_ctx` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 40--50 | `f:get_u32_array_num_elements` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 51--59 | `chunk:51` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 60--63 | `label:fail_read` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 64--69 | `f:msm_vidc_free_allowed_clocks_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 70--75 | `f:msm_vidc_free_cycles_per_mb_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 76--81 | `chunk:76, f:msm_vidc_free_reg_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 82--87 | `f:msm_vidc_free_qdss_addr_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 88--95 | `f:msm_vidc_free_bus_vectors` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 96--100 | `f:msm_vidc_free_buffer_usage_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 101--101 | `chunk:101` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 102--117 | `f:msm_vidc_free_regulator_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 118--124 | `f:msm_vidc_free_clock_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 125--125 | `f:msm_vidc_free_cx_ipeak_context` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 126--131 | `chunk:126` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 132--144 | `f:msm_vidc_free_platform_resources` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 145--150 | `f:msm_vidc_load_reg_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 151--175 | `chunk:151` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 176--193 | `chunk:176` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 194--200 | `f:msm_vidc_load_qdss_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 201--225 | `chunk:201` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 226--243 | `chunk:226` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 244--247 | `label:err_qdss_addr_tbl` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 248--250 | `f:msm_vidc_load_subcache_info` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 251--275 | `chunk:251` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 276--283 | `chunk:276` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 284--300 | `label:err_load_subcache_table_fail` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 301--308 | `chunk:301` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 309--325 | `f:msm_vidc_load_u32_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 326--345 | `chunk:326` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 346--348 | `v:msm_vidc_load_u32_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 349--350 | `f:cmp` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 351--355 | `chunk:351` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 356--375 | `f:msm_vidc_load_allowed_clocks_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 376--384 | `chunk:376` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 385--392 | `f:msm_vidc_populate_mem_cdsp` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 393--400 | `f:msm_vidc_populate_bus` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 401--425 | `chunk:401` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 426--450 | `chunk:426` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 451--468 | `chunk:451` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 469--472 | `label:err_bus` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 473--475 | `f:msm_vidc_load_buffer_usage_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 476--500 | `chunk:476` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 501--521 | `chunk:501` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 522--525 | `label:err_load_buf_usage` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 526--526 | `chunk:526` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 527--550 | `f:msm_vidc_load_regulator_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 551--575 | `chunk:551` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 576--600 | `chunk:576` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 601--616 | `chunk:601` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 617--617 | `label:err_reg_name_alloc` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 618--622 | `label:err_reg_tbl_alloc` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 623--625 | `f:msm_vidc_load_clock_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 626--650 | `chunk:626` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 651--675 | `chunk:651` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 676--691 | `chunk:676` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 692--692 | `label:err_load_clk_prop_fail` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 693--696 | `label:err_load_clk_table_fail` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 697--700 | `f:msm_vidc_load_reset_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 701--725 | `chunk:701` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 726--729 | `chunk:726` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 730--750 | `f:msm_decide_dt_node` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 751--753 | `chunk:751` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 754--767 | `f:find_key_value` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 768--775 | `f:read_platform_resources_from_drv_data` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 776--800 | `chunk:776` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 801--825 | `chunk:801` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 826--850 | `chunk:826` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 851--875 | `chunk:851, f:msm_vidc_populate_cx_ipeak_context` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 876--888 | `chunk:876` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 889--892 | `label:err_cx_ipeak` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 893--900 | `f:read_platform_resources_from_dt` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 901--925 | `chunk:901` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 926--950 | `chunk:926` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 951--975 | `chunk:951` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 976--996 | `chunk:976` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 997--997 | `label:err_load_reset_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 998--998 | `label:err_register_cx_ipeak` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 999--1000 | `label:err_setup_legacy_cb` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1001--1002 | `chunk:1001, label:err_load_allowed_clocks_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1003--1004 | `label:err_load_clock_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1005--1006 | `label:err_load_regulator_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1007--1008 | `label:err_load_buffer_usage_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1009--1012 | `label:err_load_reg_table` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1013--1025 | `f:get_secure_vmid` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1026--1026 | `chunk:1026` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1027--1050 | `f:msm_vidc_setup_context_bank` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1051--1075 | `chunk:1051` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1076--1100 | `chunk:1076` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1101--1106 | `chunk:1101` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1107--1108 | `label:release_mapping` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1109--1112 | `label:remove_cb` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1113--1125 | `f:msm_vidc_smmu_fault_handler` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1126--1150 | `chunk:1126` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1151--1175 | `chunk:1151, f:msm_vidc_populate_context_bank` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1176--1200 | `chunk:1176` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1201--1225 | `chunk:1201` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1226--1231 | `chunk:1226` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1232--1236 | `label:err_setup_cb` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1237--1250 | `f:msm_vidc_populate_legacy_context_bank` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1251--1275 | `chunk:1251` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1276--1300 | `chunk:1276` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1301--1325 | `chunk:1301` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1326--1329 | `chunk:1326` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1330--1334 | `label:err_setup_cb` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1335--1350 | `f:read_context_bank_resources_from_dt` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1351--1375 | `chunk:1351` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1376--1382 | `chunk:1376` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1383--1400 | `f:read_bus_resources_from_dt` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1401--1405 | `chunk:1401` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1406--1425 | `f:read_mem_cdsp_resources_from_dt` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |
| 1426--1427 | `chunk:1426` | `—` | 架构替代：资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。 |

覆盖校验：1427/1427 行，连续、无空洞、无重叠。

## `msm_vidc_res_parse.h`

- 原厂物理行：39；当前语义落点：`主线 DT/provider API`；默认判定：**架构替代**。
- 文件级结论：不引入 vendor parser API。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--14 | `file:start` | `—` | 架构替代：不引入 vendor parser API。 |
| 15--25 | `pp:ifndef DT_PARSE` | `—` | 架构替代：不引入 vendor parser API。 |
| 26--38 | `chunk:26` | `—` | 架构替代：不引入 vendor parser API。 |
| 39--39 | `pp:endif` | `—` | 架构替代：不引入 vendor parser API。 |

覆盖校验：39/39 行，连续、无空洞、无重叠。

## `msm_vidc_resources.h`

- 原厂物理行：250；当前语义落点：`core.h + DT binding + provider structs`；默认判定：**语义拆分**。
- 文件级结论：资源描述按 clock/reset/pd/icc/iommu 框架拆开。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 14--25 | `pp:ifndef __MSM_VIDC_RESOURCES_H__` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 226--248 | `chunk:226` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |
| 249--250 | `pp:endif` | `—` | 语义拆分：资源描述按 clock/reset/pd/icc/iommu 框架拆开。 |

覆盖校验：250/250 行，连续、无空洞、无重叠。

## `msm_vidc.c`

- 原厂物理行：2218；当前语义落点：`vdec.c + venc.c + helpers.c + VB2/M2M`；默认判定：**部分迁移**。
- 文件级结论：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 26--28 | `chunk:26` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 29--33 | `d:MAX_EVENTS` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 34--50 | `f:get_poll_flags` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 51--67 | `chunk:51` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 68--75 | `f:msm_vidc_poll` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 76--85 | `chunk:76` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 86--87 | `v:msm_vidc_poll` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 88--100 | `f:msm_vidc_querycap` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 101--113 | `chunk:101` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 114--115 | `v:msm_vidc_querycap` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 116--125 | `f:msm_vidc_enum_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 126--128 | `chunk:126` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 129--130 | `v:msm_vidc_enum_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 131--138 | `f:msm_vidc_ctrl_get_range` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 139--149 | `f:msm_vidc_query_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 150--150 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HYBRID_HIERP_MODE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 151--153 | `chunk:151` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 154--156 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HIER_B_NUM_LAYERS` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 157--159 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HIER_P_NUM_LAYERS` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 160--160 | `case:V4L2_CID_MPEG_VIDC_VENC_PARAM_LAYER_BITRATE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 161--163 | `case:V4L2_CID_MPEG_VIDEO_BITRATE` | `V4L2_CID_MPEG_VIDEO_BITRATE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 164--166 | `case:V4L2_CID_MPEG_VIDEO_BITRATE_PEAK` | `V4L2_CID_MPEG_VIDEO_BITRATE_PEAK` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 167--169 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_WIDTH` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 170--172 | `case:V4L2_CID_MPEG_VIDC_VIDEO_BLUR_HEIGHT` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 173--175 | `case:V4L2_CID_MPEG_VIDC_VIDEO_NUM_B_FRAMES` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 176--178 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, chunk:176` | `V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 179--181 | `case:V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES` | `V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 182--185 | `case:V4L2_CID_MPEG_VIDC_VIDEO_COLOR_SPACE_CAPS` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 186--188 | `case:V4L2_CID_MPEG_VIDC_VIDEO_ROTATION_CAPS` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 189--189 | `case:V4L2_CID_MPEG_VIDC_VIDEO_FRAME_RATE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 190--192 | `case:V4L2_CID_MPEG_VIDC_VIDEO_OPERATING_RATE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 193--193 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 194--194 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_PROFILE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 195--195 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MPEG2_PROFILE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 196--200 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP9_PROFILE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 201--210 | `chunk:201` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 211--211 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 212--212 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP8_PROFILE_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 213--213 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_TIER_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 214--214 | `case:V4L2_CID_MPEG_VIDC_VIDEO_MPEG2_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 215--225 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP9_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 226--229 | `chunk:226` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 230--234 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 235--236 | `v:msm_vidc_query_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 237--250 | `f:msm_vidc_s_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 251--258 | `chunk:251` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 259--260 | `v:msm_vidc_s_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 261--275 | `f:msm_vidc_g_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 276--288 | `chunk:276` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 289--291 | `case:V4L2_PIX_FMT_NV12` | `V4L2_PIX_FMT_NV12` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 292--294 | `case:V4L2_PIX_FMT_NV12_512` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 295--297 | `case:V4L2_PIX_FMT_NV12_UBWC` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 298--300 | `case:V4L2_PIX_FMT_NV12_TP10_UBWC` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 301--303 | `case:V4L2_PIX_FMT_SDE_Y_CBCR_H2V2_P010_VENUS, chunk:301` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 304--325 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 326--328 | `chunk:326, label:exit` | `exit` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 329--330 | `v:msm_vidc_g_fmt` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 331--339 | `f:msm_vidc_s_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 340--341 | `v:msm_vidc_s_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 342--350 | `f:msm_vidc_g_crop` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 351--362 | `chunk:351` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 363--364 | `v:msm_vidc_g_crop` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 365--375 | `f:msm_vidc_g_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 376--382 | `chunk:376` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 383--384 | `v:msm_vidc_g_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 385--397 | `f:msm_vidc_g_ext_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 398--400 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 401--406 | `chunk:401` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 407--408 | `v:msm_vidc_g_ext_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 409--421 | `f:msm_vidc_s_ext_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 422--423 | `v:msm_vidc_s_ext_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 424--425 | `f:msm_vidc_reqbufs` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 426--447 | `chunk:426` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 448--449 | `v:msm_vidc_reqbufs` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 450--450 | `f:valid_v4l2_buffer` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 451--462 | `chunk:451` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 463--475 | `f:msm_vidc_release_buffer` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 476--500 | `chunk:476` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 501--507 | `chunk:501` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 508--509 | `v:msm_vidc_release_buffer` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 510--525 | `f:msm_vidc_qbuf` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 526--550 | `chunk:526` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 551--562 | `chunk:551` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 563--564 | `v:msm_vidc_qbuf` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 565--575 | `f:msm_vidc_dqbuf` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 576--600 | `chunk:576` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 601--615 | `chunk:601` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 616--617 | `v:msm_vidc_dqbuf` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 618--625 | `f:msm_vidc_streamon` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 626--642 | `chunk:626` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 643--644 | `v:msm_vidc_streamon` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 645--650 | `f:msm_vidc_streamoff` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 651--675 | `chunk:651` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 676--678 | `chunk:676` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 679--680 | `v:msm_vidc_streamoff` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 681--700 | `f:msm_vidc_enum_framesizes` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 701--703 | `chunk:701` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 704--705 | `v:msm_vidc_enum_framesizes` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 706--711 | `f:vidc_get_userptr` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 712--715 | `f:vidc_put_userptr` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 716--716 | `v:msm_vidc_vb2_mem_ops` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 717--717 | `field:get_userptr` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 718--720 | `field:put_userptr` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 721--725 | `f:msm_vidc_cleanup_buffer` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 726--750 | `chunk:726` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 751--759 | `chunk:751` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 760--775 | `f:msm_vidc_queue_setup` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 776--782 | `chunk:776` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 783--800 | `case:V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | `V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 801--810 | `chunk:801` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 811--825 | `case:V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 826--844 | `chunk:826` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 845--850 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 851--857 | `chunk:851` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 858--875 | `f:msm_vidc_verify_buffer_counts` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 876--900 | `chunk:876` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 901--901 | `chunk:901` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 902--925 | `f:msm_vidc_set_internal_config` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 926--950 | `chunk:926` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 951--975 | `chunk:951` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 976--1000 | `chunk:976` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1001--1025 | `chunk:1001` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1026--1028 | `chunk:1026` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1029--1050 | `f:msm_vidc_set_rotation` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1051--1075 | `chunk:1051` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1076--1079 | `chunk:1076` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1080--1100 | `f:start_streaming` | `start_streaming` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1101--1125 | `chunk:1101` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1126--1150 | `chunk:1126` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1151--1175 | `chunk:1151` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1176--1200 | `chunk:1176` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1201--1225 | `chunk:1201` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1226--1250 | `chunk:1226` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1251--1265 | `chunk:1251` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1266--1272 | `label:fail_start` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1273--1275 | `f:msm_vidc_start_streaming` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1276--1291 | `chunk:1276` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1292--1295 | `case:V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | `V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1296--1299 | `case:V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1300--1300 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1301--1325 | `chunk:1301` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1326--1327 | `chunk:1326` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1328--1350 | `label:stream_start_failed` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1351--1360 | `chunk:1351` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1361--1375 | `f:stop_streaming` | `stop_streaming` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1376--1378 | `chunk:1376` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1379--1391 | `f:msm_vidc_stop_streaming` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1392--1395 | `case:V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | `V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1396--1399 | `case:V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1400--1400 | `case:default` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1401--1414 | `chunk:1401` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1415--1425 | `f:msm_vidc_queue_buf` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1426--1449 | `chunk:1426` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1450--1450 | `f:msm_vidc_queue_buf_decode_batch` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1451--1475 | `chunk:1451` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1476--1481 | `chunk:1476` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1482--1500 | `f:msm_vidc_queue_buf_batch` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1501--1521 | `chunk:1501, f:msm_vidc_buf_queue` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1522--1522 | `v:msm_vidc_vb2q_ops` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1523--1523 | `field:queue_setup` | `queue_setup` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1524--1524 | `field:start_streaming` | `start_streaming` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1525--1525 | `field:buf_queue` | `buf_queue` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1526--1526 | `chunk:1526, field:buf_cleanup` | `buf_cleanup` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1527--1529 | `field:stop_streaming` | `stop_streaming` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1530--1550 | `f:vb2_bufq_init` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1551--1555 | `chunk:1551` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1556--1567 | `f:setup_event_queue` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1568--1575 | `f:msm_vidc_subscribe_event` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1576--1580 | `chunk:1576` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1581--1582 | `v:msm_vidc_subscribe_event` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1583--1594 | `f:msm_vidc_unsubscribe_event` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1595--1596 | `v:msm_vidc_unsubscribe_event` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1597--1600 | `f:msm_vidc_dqevent` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1601--1607 | `chunk:1601` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1608--1609 | `v:msm_vidc_dqevent` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1610--1625 | `f:msm_vidc_private` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1626--1637 | `chunk:1626` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1638--1638 | `v:msm_vidc_private` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1639--1649 | `f:msm_vidc_try_set_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1650--1650 | `f:msm_vidc_op_s_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1651--1675 | `chunk:1651` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1676--1682 | `chunk:1676` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1683--1690 | `f:try_get_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1691--1695 | `case:V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `V4L2_CID_MPEG_VIDEO_H264_PROFILE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1696--1700 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_PROFILE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1701--1703 | `case:V4L2_CID_MPEG_VIDC_IMG_GRID_ENABLE, chunk:1701` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1704--1708 | `case:V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `V4L2_CID_MPEG_VIDEO_H264_LEVEL` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1709--1713 | `case:V4L2_CID_MPEG_VIDC_VIDEO_VP8_PROFILE_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1714--1719 | `case:V4L2_CID_MPEG_VIDC_VIDEO_HEVC_TIER_LEVEL` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1720--1723 | `case:V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1724--1725 | `case:V4L2_CID_MIN_BUFFERS_FOR_CAPTURE` | `V4L2_CID_MIN_BUFFERS_FOR_CAPTURE` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1726--1737 | `chunk:1726` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1738--1750 | `case:V4L2_CID_MIN_BUFFERS_FOR_OUTPUT` | `V4L2_CID_MIN_BUFFERS_FOR_OUTPUT` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1751--1759 | `chunk:1751` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1760--1762 | `case:V4L2_CID_MPEG_VIDC_VIDEO_TME_PAYLOAD_VERSION` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1763--1766 | `case:V4L2_CID_MPEG_VIDC_VIDEO_STREAM_FORMAT` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1767--1772 | `case:V4L2_CID_MPEG_VIDC_VIDEO_ROI_TYPE` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1773--1775 | `label:V4L2_CID_MPEG_VIDC_VIDEO_ROI_TYPE_2BIT` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1776--1786 | `case:default, chunk:1776` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1787--1800 | `f:msm_vidc_op_g_volatile_ctrl` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1801--1825 | `chunk:1801` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1826--1826 | `chunk:1826` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1827--1828 | `v:msm_vidc_ctrl_ops` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1829--1829 | `field:s_ctrl` | `s_ctrl` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1830--1832 | `field:g_volatile_ctrl` | `g_volatile_ctrl` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1833--1842 | `f:batch_timer_callback` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1843--1850 | `f:msm_vidc_open` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1851--1875 | `chunk:1851` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1876--1900 | `chunk:1876` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1901--1925 | `chunk:1901` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1926--1950 | `chunk:1926` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1951--1975 | `chunk:1951` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1976--1983 | `chunk:1976` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1984--1991 | `label:fail_init` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1992--1993 | `label:fail_bufq_output` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 1994--2000 | `label:fail_bufq_capture` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2001--2016 | `chunk:2001` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2017--2019 | `label:err_invalid_core` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2020--2021 | `v:msm_vidc_open` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2022--2025 | `f:msm_vidc_cleanup_instance` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2026--2050 | `chunk:2026` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2051--2075 | `chunk:2051` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2076--2100 | `chunk:2076` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2101--2110 | `chunk:2101` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2111--2125 | `f:msm_vidc_destroy` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2126--2150 | `chunk:2126` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2151--2161 | `chunk:2151` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2162--2169 | `f:close_helper` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2170--2175 | `f:msm_vidc_close` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2176--2200 | `chunk:2176` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2201--2210 | `chunk:2201` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2211--2212 | `v:msm_vidc_close` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2213--2216 | `f:msm_vidc_suspend` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |
| 2217--2218 | `v:msm_vidc_suspend` | `—` | 部分迁移：open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。 |

覆盖校验：2218/2218 行，连续、无空洞、无重叠。

## `msm_vidc.h`

- 原厂物理行：136；当前语义落点：`core.h + module-local headers`；默认判定：**架构替代**。
- 文件级结论：顶层接口由主线模块边界替代。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 14--25 | `pp:ifndef _MSM_VIDC_H_` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 26--50 | `chunk:26` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 51--75 | `chunk:51` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 76--100 | `chunk:76` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 101--125 | `chunk:101` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 126--135 | `chunk:126` | `—` | 架构替代：顶层接口由主线模块边界替代。 |
| 136--136 | `pp:endif` | `—` | 架构替代：顶层接口由主线模块边界替代。 |

覆盖校验：136/136 行，连续、无空洞、无重叠。

## `venus_boot.c`

- 原厂物理行：470；当前语义落点：`firmware.c + hfi_venus.c + remoteproc/PAS`；默认判定：**架构替代**。
- 文件级结论：固件启动已通过；不搬旧 PIL/SCM glue。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 13--25 | `d:VIDC_DBG_LABEL` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 26--37 | `chunk:26` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 38--39 | `d:VENUS_WRAPPER_SEC_CPA_START_ADDR` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 40--41 | `d:VENUS_WRAPPER_SEC_CPA_END_ADDR` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 42--43 | `d:VENUS_WRAPPER_SEC_FW_START_ADDR` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 44--46 | `d:VENUS_WRAPPER_SEC_FW_END_ADDR` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 47--49 | `d:VENUS_WRAPPER_A9SS_SW_RESET` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 50--50 | `d:VENUS_VBIF_CLKON_FORCE_ON` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 51--51 | `chunk:51` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 52--52 | `d:VENUS_VBIF_ADDR_TRANS_EN` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 53--53 | `d:VENUS_VBIF_AT_OLD_BASE` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 54--54 | `d:VENUS_VBIF_AT_OLD_HIGH` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 55--55 | `d:VENUS_VBIF_AT_NEW_BASE` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 56--59 | `d:VENUS_VBIF_AT_NEW_HIGH` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 60--61 | `d:POLL_INTERVAL_US` | `POLL_INTERVAL_US` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 62--75 | `d:VENUS_REGION_SIZE` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 76--77 | `chunk:76` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 78--80 | `v:venus_data` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 81--100 | `f:venus_clock_setup` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 101--105 | `chunk:101` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 106--125 | `f:venus_clock_prepare_enable` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 126--127 | `chunk:126` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 128--139 | `f:venus_clock_disable_unprepare` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 140--150 | `f:venus_setup_cb` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 151--158 | `chunk:151` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 159--175 | `f:pil_venus_mem_setup` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 176--178 | `chunk:176` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 179--200 | `f:pil_venus_auth_and_reset` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 201--225 | `chunk:201` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 226--250 | `chunk:226` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 251--275 | `chunk:251` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 276--289 | `chunk:276` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 290--292 | `label:err_iommu_map` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 293--295 | `label:release_mapping` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 296--299 | `label:err` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 300--300 | `f:pil_venus_shutdown` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 301--325 | `chunk:301` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 326--350 | `chunk:326` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 351--351 | `chunk:351` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 352--375 | `f:venus_notifier_cb` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 376--400 | `chunk:376` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 401--407 | `chunk:401` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 408--412 | `label:err_clks` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 413--413 | `v:venus_notifier` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 414--416 | `field:notifier_call` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 417--425 | `f:venus_boot_init` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 426--450 | `chunk:426` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 451--457 | `chunk:451` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 458--458 | `label:err_subsys_notif` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 459--463 | `label:err_ioremap_fail` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |
| 464--470 | `f:venus_boot_deinit` | `—` | 架构替代：固件启动已通过；不搬旧 PIL/SCM glue。 |

覆盖校验：470/470 行，连续、无空洞、无重叠。

## `venus_boot.h`

- 原厂物理行：22；当前语义落点：`firmware.h`；默认判定：**架构替代**。
- 文件级结论：只保留主线 firmware 生命周期。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 架构替代：只保留主线 firmware 生命周期。 |
| 14--21 | `pp:ifndef __VENUS_BOOT_H__` | `—` | 架构替代：只保留主线 firmware 生命周期。 |
| 22--22 | `pp:endif /* __VENUS_BOOT_H__ */` | `—` | 架构替代：只保留主线 firmware 生命周期。 |

覆盖校验：22/22 行，连续、无空洞、无重叠。

## `venus_hfi.c`

- 原厂物理行：5369；当前语义落点：`hfi_venus.c + pm_helpers.c + hfi.c`；默认判定：**部分迁移**。
- 文件级结论：queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--25 | `file:start` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 26--44 | `chunk:26` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 45--45 | `d:FIRMWARE_SIZE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 46--46 | `d:REG_ADDR_OFFSET_BITMASK` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 47--47 | `d:QDSS_IOVA_START` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 48--49 | `d:MIN_PAYLOAD_SIZE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 50--50 | `d:VERSION_HANA` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 51--51 | `chunk:51` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 52--53 | `v:hal_ctxt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 54--54 | `d:TZBSP_MEM_PROTECT_VIDEO_VAR` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 55--61 | `s:tzbsp_memprot` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 62--65 | `s:tzbsp_resp` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 66--68 | `d:TZBSP_VIDEO_SET_STATE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 69--70 | `d:POLL_INTERVAL_US` | `POLL_INTERVAL_US` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 71--75 | `g:tzbsp_video_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 76--76 | `chunk:76` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 77--81 | `s:tzbsp_video_set_state_req` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 82--82 | `v:DEFAULT_BUS_VOTE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 83--83 | `field:data` | `data` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 84--86 | `field:data_count` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 87--100 | `v:max_packets` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 101--120 | `chunk:101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 121--121 | `v:vpu4_ops` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 122--122 | `field:interrupt_init` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 123--123 | `field:setup_dsp_uc_memmap` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 124--125 | `field:clock_config_on_enable` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 126--126 | `chunk:126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 127--127 | `v:vpu5_ops` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 128--128 | `field:interrupt_init` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 129--129 | `field:setup_dsp_uc_memmap` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 130--136 | `field:clock_config_on_enable` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 137--142 | `f:__strict_check` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 143--148 | `f:__set_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 149--150 | `f:__core_in_valid_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 151--153 | `chunk:151` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 154--158 | `f:is_sys_cache_present` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 159--175 | `f:__dump_packet` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 176--177 | `chunk:176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 178--200 | `f:__sim_modify_cmd_packet` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 201--203 | `chunk:201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 204--219 | `case:HFI_CMD_SESSION_EMPTY_BUFFER` | `HFI_CMD_SESSION_EMPTY_BUFFER` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 220--225 | `case:HFI_CMD_SESSION_FILL_BUFFER` | `HFI_CMD_SESSION_FILL_BUFFER` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 226--226 | `chunk:226` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 227--244 | `case:HFI_CMD_SESSION_SET_BUFFERS` | `HFI_CMD_SESSION_SET_BUFFERS` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 245--250 | `case:HFI_CMD_SESSION_RELEASE_BUFFERS` | `HFI_CMD_SESSION_RELEASE_BUFFERS` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 251--262 | `chunk:251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 263--273 | `case:HFI_CMD_SESSION_REGISTER_BUFFERS` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 274--275 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 276--278 | `chunk:276` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 279--300 | `f:__dsp_send_hfi_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 301--311 | `chunk:301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 312--325 | `f:__dsp_suspend` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 326--350 | `chunk:326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 351--353 | `chunk:351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 354--375 | `f:__dsp_resume` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 376--379 | `chunk:376` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 380--400 | `f:__dsp_shutdown` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 401--405 | `chunk:401` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 406--421 | `f:__session_pause` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 422--425 | `f:__session_resume` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 426--446 | `chunk:426` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 447--450 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 451--469 | `chunk:451, f:venus_hfi_session_pause` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 470--475 | `f:venus_hfi_session_resume` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 476--488 | `chunk:476` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 489--500 | `f:__acquire_regulator` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 501--523 | `chunk:501` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 524--525 | `f:__hand_off_regulator` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 526--544 | `chunk:526` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 545--550 | `f:__hand_off_regulators` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 551--561 | `chunk:551` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 562--568 | `label:err_reg_handoff_failed` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 569--575 | `f:__write_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 576--600 | `chunk:576` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 601--625 | `chunk:601` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 626--650 | `chunk:626` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 651--654 | `chunk:651` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 655--675 | `f:__hal_sim_modify_msg_packet` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 676--680 | `chunk:676` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 681--697 | `case:HFI_MSG_SESSION_FILL_BUFFER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 698--700 | `case:HFI_MSG_SESSION_EMPTY_BUFFER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 701--704 | `chunk:701` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 705--714 | `case:HFI_MSG_SESSION_GET_SEQUENCE_HEADER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 715--719 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 720--725 | `f:__read_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 726--750 | `chunk:726` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 751--775 | `chunk:751` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 776--800 | `chunk:776` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 801--825 | `chunk:801` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 826--841 | `chunk:826` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 842--850 | `f:__smem_alloc` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 851--871 | `chunk:851` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 872--875 | `label:fail_smem_alloc` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 876--885 | `chunk:876, f:__smem_free` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 886--900 | `f:__write_register` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 901--917 | `chunk:901` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 918--925 | `f:__read_register` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 926--950 | `chunk:926` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 951--975 | `chunk:951, f:__set_registers` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 976--987 | `chunk:976, f:__set_threshold_registers` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 988--1000 | `f:__iommu_detach` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1001--1004 | `chunk:1001` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1005--1025 | `f:__devfreq_target` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1026--1045 | `chunk:1026` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1046--1049 | `label:err_unknown_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1050--1050 | `f:__devfreq_get_status` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1051--1069 | `chunk:1051` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1070--1075 | `field:private_data` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1076--1076 | `chunk:1076` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1077--1077 | `field:total_time` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1078--1078 | `field:busy_time` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1079--1081 | `field:current_frequency` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1082--1085 | `label:err_unknown_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1086--1100 | `f:__unvote_buses` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1101--1106 | `chunk:1101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1107--1110 | `label:err_unknown_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1111--1125 | `f:__vote_buses` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1126--1132 | `chunk:1126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1133--1150 | `label:no_data_count` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1151--1154 | `chunk:1151, label:err_no_mem` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1155--1169 | `f:venus_hfi_vote_buses` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1170--1175 | `f:__core_set_resource` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1176--1194 | `chunk:1176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1195--1198 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1199--1200 | `f:__core_release_resource` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1201--1224 | `chunk:1201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1225--1225 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1226--1228 | `chunk:1226` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1229--1250 | `f:__tzbsp_set_video_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1251--1259 | `chunk:1251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1260--1275 | `f:__boot_firmware` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1276--1287 | `chunk:1276` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1288--1300 | `f:venus_hfi_suspend` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1301--1315 | `chunk:1301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1316--1325 | `f:venus_hfi_flush_debug_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1326--1333 | `chunk:1326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1334--1338 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1339--1350 | `f:venus_hfi_get_default_properties` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1351--1356 | `chunk:1351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1357--1375 | `f:__set_clk_rate` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1376--1400 | `chunk:1376` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1401--1420 | `chunk:1401, f:__set_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1421--1425 | `f:venus_hfi_scale_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1426--1439 | `chunk:1426` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1440--1445 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1446--1450 | `f:__scale_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 1451--1462 | `chunk:1451` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1463--1475 | `f:__iface_cmdq_write_relaxed` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1476--1500 | `chunk:1476` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1501--1520 | `chunk:1501` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1521--1521 | `label:err_q_write` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1522--1525 | `label:err_q_null` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1526--1540 | `chunk:1526, f:__iface_cmdq_write` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1541--1550 | `f:__iface_msgq_read` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1551--1575 | `chunk:1551` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1576--1579 | `chunk:1576, label:read_error_null` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1580--1600 | `f:__iface_dbgq_read` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1601--1607 | `chunk:1601` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1608--1611 | `label:dbg_error_null` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1612--1625 | `f:__set_queue_hdr_defaults` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1626--1627 | `chunk:1626` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1628--1650 | `f:__interface_dsp_queues_release` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1651--1652 | `chunk:1651` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1653--1675 | `f:__interface_dsp_queues_init` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1676--1700 | `chunk:1676` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1701--1725 | `chunk:1701` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1726--1750 | `chunk:1726` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1751--1754 | `chunk:1751` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1755--1756 | `label:fail_dma_map` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1757--1760 | `label:fail_dma_alloc` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1761--1775 | `f:__interface_queues_release` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1776--1800 | `chunk:1776` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1801--1823 | `chunk:1801` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1824--1825 | `f:__get_qdss_iommu_virtual_addr` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1826--1850 | `chunk:1826` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1851--1875 | `chunk:1851` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1876--1892 | `chunk:1876, f:__setup_ucregion_memory_map` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1893--1900 | `f:__interface_queues_init` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 1901--1925 | `chunk:1901` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1926--1950 | `chunk:1926` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1951--1975 | `chunk:1951` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 1976--2000 | `chunk:1976` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2001--2025 | `chunk:2001` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2026--2043 | `chunk:2026` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2044--2047 | `label:fail_alloc_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 2048--2050 | `f:__sys_set_debug` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2051--2066 | `chunk:2051` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2067--2075 | `f:__sys_set_ubwc_config` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2076--2090 | `chunk:2076` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2091--2100 | `f:__sys_set_coverage` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2101--2113 | `chunk:2101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2114--2125 | `f:__sys_set_power_control` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 2126--2138 | `chunk:2126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2139--2150 | `f:venus_hfi_core_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2151--2175 | `chunk:2151` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2176--2200 | `chunk:2176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2201--2222 | `chunk:2201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2223--2225 | `pp:ifdef CONFIG_SMP` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2226--2232 | `chunk:2226, pp:endif` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2233--2235 | `label:err_core_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2236--2236 | `label:err_load_fw` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2237--2242 | `label:err_no_mem` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2243--2250 | `f:venus_hfi_core_release` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2251--2275 | `chunk:2251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2276--2300 | `chunk:2276, f:__get_q_size` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2301--2303 | `chunk:2301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2304--2325 | `f:__core_clear_interrupt` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 2326--2331 | `chunk:2326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2332--2350 | `f:venus_hfi_core_ping` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2351--2354 | `chunk:2351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2355--2359 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2360--2375 | `f:venus_hfi_core_trigger_ssr` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2376--2383 | `chunk:2376` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2384--2388 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2389--2400 | `f:venus_hfi_session_set_property` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2401--2425 | `chunk:2401` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2426--2431 | `chunk:2426` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2432--2436 | `label:err_set_prop` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2437--2450 | `f:venus_hfi_session_get_property` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2451--2470 | `chunk:2451` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2471--2475 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2476--2483 | `chunk:2476, f:__set_default_sys_properties` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2484--2500 | `f:__session_clean` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2501--2509 | `chunk:2501` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2510--2525 | `f:venus_hfi_session_clean` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2526--2535 | `chunk:2526` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2536--2550 | `f:venus_hfi_session_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2551--2575 | `chunk:2551` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2576--2583 | `chunk:2576` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2584--2591 | `label:err_session_init_fail` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2592--2600 | `f:__send_session_cmd` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2601--2613 | `chunk:2601` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2614--2617 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2618--2625 | `f:venus_hfi_session_end` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2626--2645 | `chunk:2626` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2646--2650 | `f:venus_hfi_session_abort` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2651--2668 | `chunk:2651` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2669--2675 | `f:venus_hfi_session_set_buffers` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2676--2700 | `chunk:2676` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2701--2711 | `chunk:2701` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2712--2716 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2717--2725 | `f:venus_hfi_session_release_buffers` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2726--2750 | `chunk:2726` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2751--2755 | `chunk:2751` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2756--2760 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2761--2775 | `f:venus_hfi_session_register_buffer` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2776--2789 | `chunk:2776` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2790--2795 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2796--2800 | `f:venus_hfi_session_unregister_buffer` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2801--2824 | `chunk:2801` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2825--2825 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2826--2830 | `chunk:2826` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2831--2850 | `f:venus_hfi_session_load_res` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2851--2851 | `chunk:2851` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2852--2872 | `f:venus_hfi_session_release_res` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2873--2875 | `f:venus_hfi_session_start` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2876--2893 | `chunk:2876` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2894--2900 | `f:venus_hfi_session_continue` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2901--2914 | `chunk:2901` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2915--2925 | `f:venus_hfi_session_stop` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2926--2935 | `chunk:2926` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2936--2950 | `f:__session_etb` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 2951--2975 | `chunk:2951` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2976--2983 | `chunk:2976` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2984--2987 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 2988--3000 | `f:venus_hfi_session_etb` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3001--3006 | `chunk:3001` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3007--3025 | `f:__session_ftb` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3026--3029 | `chunk:3026` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3030--3033 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3034--3050 | `f:venus_hfi_session_ftb` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3051--3052 | `chunk:3051` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3053--3075 | `f:venus_hfi_session_process_batch` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3076--3100 | `chunk:3076` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3101--3102 | `chunk:3101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3103--3107 | `label:err_etbs_and_ftbs` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3108--3125 | `f:venus_hfi_session_get_buf_req` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3126--3136 | `chunk:3126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3137--3141 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3142--3150 | `f:venus_hfi_session_flush` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3151--3169 | `chunk:3151` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3170--3174 | `label:err_create_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3175--3175 | `f:__check_core_registered` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3176--3200 | `chunk:3176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3201--3220 | `chunk:3201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3221--3225 | `f:__process_fatal_error` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3226--3229 | `chunk:3226` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3230--3244 | `f:__prepare_pc` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3245--3248 | `label:err_pc_prep` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3249--3250 | `f:venus_hfi_pm_handler` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3251--3275 | `chunk:3251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3276--3277 | `chunk:3276` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3278--3284 | `case:0` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3285--3291 | `case:-EBUSY` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3292--3299 | `case:-EAGAIN` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3300--3300 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3301--3305 | `chunk:3301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3306--3325 | `f:__power_collapse` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3326--3350 | `chunk:3326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3351--3375 | `chunk:3351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3376--3388 | `chunk:3376` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3389--3391 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3392--3398 | `label:skip_power_off` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3399--3400 | `f:__process_sys_error` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3401--3418 | `chunk:3401` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3419--3425 | `f:__flush_debug_queue` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 3426--3446 | `chunk:3426` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3447--3450 | `d:SKIP_INVALID_PKT` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3451--3475 | `chunk:3451` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3476--3500 | `chunk:3476` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3501--3501 | `chunk:3501` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3502--3507 | `d:SKIP_INVALID_PKT` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3508--3519 | `f:__is_session_valid` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3520--3525 | `label:invalid` | `invalid` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3526--3538 | `chunk:3526, f:__get_session` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3539--3550 | `f:__response_handler` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3551--3563 | `chunk:3551` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3564--3565 | `field:response_type` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3566--3575 | `field:device_id` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3576--3596 | `chunk:3576` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3597--3599 | `case:HAL_SYS_ERROR` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3600--3600 | `case:HAL_SYS_RELEASE_RESOURCE_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3601--3602 | `chunk:3601` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3603--3612 | `case:HAL_SYS_INIT_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3613--3622 | `case:HAL_SESSION_LOAD_RESOURCE_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3623--3625 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3626--3628 | `chunk:3626` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3629--3629 | `case:HAL_SESSION_LOAD_RESOURCE_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3630--3630 | `case:HAL_SESSION_INIT_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3631--3631 | `case:HAL_SESSION_END_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3632--3632 | `case:HAL_SESSION_ABORT_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3633--3633 | `case:HAL_SESSION_START_DONE` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3634--3634 | `case:HAL_SESSION_STOP_DONE` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3635--3635 | `case:HAL_SESSION_FLUSH_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3636--3636 | `case:HAL_SESSION_SUSPEND_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3637--3637 | `case:HAL_SESSION_RESUME_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3638--3638 | `case:HAL_SESSION_SET_PROP_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3639--3639 | `case:HAL_SESSION_GET_PROP_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3640--3640 | `case:HAL_SESSION_RELEASE_BUFFER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3641--3641 | `case:HAL_SESSION_REGISTER_BUFFER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3642--3642 | `case:HAL_SESSION_UNREGISTER_BUFFER_DONE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3643--3643 | `case:HAL_SESSION_RELEASE_RESOURCE_DONE` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3644--3646 | `case:HAL_SESSION_PROPERTY_INFO` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3647--3647 | `case:HAL_SESSION_ERROR` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3648--3648 | `case:HAL_SESSION_ETB_DONE` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3649--3650 | `case:HAL_SESSION_FTB_DONE` | `—` | 命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。 |
| 3651--3651 | `chunk:3651` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3652--3654 | `case:HAL_SESSION_EVENT_CHANGE` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3655--3655 | `case:HAL_RESPONSE_UNUSED` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3656--3675 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3676--3700 | `chunk:3676` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3701--3711 | `chunk:3701` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3712--3717 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3718--3725 | `f:venus_hfi_core_work_handler` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3726--3745 | `chunk:3726` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3746--3750 | `label:err_no_work` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3751--3775 | `chunk:3751` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3776--3783 | `chunk:3776` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3784--3792 | `f:venus_hfi_isr` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 3793--3800 | `f:__init_regs_and_interrupts` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 3801--3825 | `chunk:3801` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3826--3844 | `chunk:3826` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3845--3846 | `label:error_irq_fail` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3847--3850 | `label:err_core_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3851--3851 | `chunk:3851` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3852--3864 | `f:__deinit_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3865--3875 | `f:__init_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 3876--3895 | `chunk:3876` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3896--3900 | `label:err_clk_get` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3901--3915 | `chunk:3901, f:__handle_reset_clk` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3916--3925 | `case:INIT` | `INIT` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3926--3926 | `chunk:3926` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3927--3932 | `case:ASSERT` | `ASSERT` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3933--3938 | `case:DEASSERT` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3939--3946 | `case:default` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3947--3950 | `label:no_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3951--3952 | `chunk:3951` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3953--3975 | `f:__disable_unprepare_clks` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3976--3981 | `chunk:3976` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 3982--4000 | `f:__prepare_ahb2axi_bridge` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4001--4011 | `chunk:4001` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4012--4025 | `f:__unprepare_ahb2axi_bridge` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4026--4047 | `chunk:4026` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4048--4050 | `f:__prepare_enable_clks` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4051--4075 | `chunk:4051` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4076--4093 | `chunk:4076` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4094--4100 | `label:fail_clk_enable` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4101--4103 | `chunk:4101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4104--4123 | `f:__deinit_bus` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4124--4125 | `f:__init_bus` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4126--4133 | `chunk:4126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4134--4134 | `field:initial_freq` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4135--4135 | `field:polling_ms` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4136--4136 | `field:freq_table` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4137--4137 | `field:max_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4138--4138 | `field:target` | `target` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4139--4139 | `field:get_dev_status` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4140--4150 | `field:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4151--4175 | `chunk:4151` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4176--4190 | `chunk:4176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4191--4195 | `label:err_add_dev` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4196--4200 | `f:__deinit_regulators` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4201--4207 | `chunk:4201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4208--4225 | `f:__init_regulators` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4226--4226 | `chunk:4226` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4227--4231 | `label:err_reg_get` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4232--4250 | `f:__deinit_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4251--4253 | `chunk:4251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4254--4257 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4258--4275 | `f:__init_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4276--4288 | `chunk:4276` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4289--4293 | `label:err_subcache_get` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4294--4300 | `f:__init_resources` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4301--4325 | `chunk:4301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4326--4334 | `chunk:4326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4335--4335 | `label:err_init_reset_clk` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4336--4337 | `label:err_init_bus` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4338--4342 | `label:err_init_clocks` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4343--4350 | `f:__deinit_resources` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4351--4352 | `chunk:4351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4353--4375 | `f:__protect_cp_mem` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4376--4400 | `chunk:4376` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4401--4404 | `chunk:4401` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4405--4425 | `f:__disable_regulator` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4426--4440 | `chunk:4426` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4441--4447 | `label:disable_regulator_failed` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4448--4450 | `f:__enable_hw_power_collapse` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4451--4464 | `chunk:4451` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4465--4475 | `f:__enable_regulators` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4476--4487 | `chunk:4476` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4488--4494 | `label:err_reg_enable_failed` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4495--4500 | `f:__disable_regulators` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4501--4507 | `chunk:4501` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4508--4525 | `f:__enable_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4526--4534 | `chunk:4526` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4535--4540 | `label:err_activate_fail` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4541--4550 | `f:__set_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4551--4575 | `chunk:4551` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4576--4594 | `chunk:4576` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4595--4600 | `label:err_fail_set_subacaches` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4601--4625 | `chunk:4601, f:__release_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4626--4645 | `chunk:4626` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4646--4650 | `f:__disable_subcaches` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4651--4671 | `chunk:4651` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4672--4675 | `f:interrupt_init_vpu5` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 4676--4684 | `chunk:4676` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4685--4690 | `f:interrupt_init_vpu4` | `—` | queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。 |
| 4691--4700 | `f:setup_dsp_uc_memmap_vpu5` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4701--4708 | `chunk:4701` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4709--4714 | `f:clock_config_on_enable_vpu5` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4715--4725 | `f:__venus_power_on` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4726--4750 | `chunk:4726` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4751--4775 | `chunk:4751` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4776--4777 | `chunk:4776` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4778--4779 | `label:fail_enable_clks` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4780--4781 | `label:fail_enable_gdsc` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4782--4786 | `label:fail_vote_buses` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4787--4800 | `f:__venus_power_off` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4801--4813 | `chunk:4801` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4814--4825 | `f:__suspend` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4826--4843 | `chunk:4826` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4844--4847 | `label:err_tzbsp_suspend` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4848--4850 | `f:__resume` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4851--4875 | `chunk:4851` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4876--4891 | `chunk:4876` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4892--4894 | `pp:ifdef CONFIG_SMP` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4895--4900 | `pp:endif` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4901--4906 | `chunk:4901` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4907--4911 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4912--4913 | `label:err_reset_core` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4914--4915 | `label:err_set_video_state` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4916--4920 | `label:err_venus_power_on` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4921--4925 | `f:__load_fw` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4926--4950 | `chunk:4926` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4951--4968 | `chunk:4951` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4969--4972 | `label:fail_protect_mem` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4973--4974 | `label:fail_load_fw` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4975--4975 | `label:fail_venus_power_on` | `—` | IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。 |
| 4976--4977 | `chunk:4976, label:fail_init_pkt` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4978--4982 | `label:fail_init_res` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 4983--5000 | `f:__unload_fw` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5001--5001 | `chunk:5001` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5002--5025 | `f:venus_hfi_get_fw_info` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5026--5041 | `chunk:5026` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5042--5050 | `label:fail_version_string` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5051--5052 | `chunk:5051` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5053--5072 | `f:venus_hfi_get_core_capabilities` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5073--5075 | `f:__noc_error_info` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5076--5100 | `chunk:5076` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5101--5125 | `chunk:5101` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5126--5127 | `chunk:5126` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5128--5150 | `f:venus_hfi_noc_error_info` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5151--5154 | `chunk:5151` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5155--5174 | `f:__initialize_packetization` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5175--5175 | `f:__init_venus_ops` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5176--5182 | `chunk:5176` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5183--5200 | `f:__add_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5201--5225 | `chunk:5201` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5226--5250 | `chunk:5226` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5251--5252 | `chunk:5251` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5253--5258 | `label:err_cleanup` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5259--5262 | `label:exit` | `exit` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5263--5274 | `f:__get_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5275--5275 | `f:venus_hfi_delete_device` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5276--5300 | `chunk:5276` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5301--5305 | `chunk:5301` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5306--5325 | `f:venus_init_hfi_callbacks` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5326--5343 | `chunk:5326` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5344--5350 | `f:venus_hfi_initialize` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5351--5365 | `chunk:5351` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |
| 5366--5369 | `label:err_venus_hfi_init` | `—` | queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。 |

覆盖校验：5369/5369 行，连续、无空洞、无重叠。

## `venus_hfi.h`

- 原厂物理行：296；当前语义落点：`hfi_venus.h + core.h`；默认判定：**语义拆分**。
- 文件级结论：设备/会话/资源状态按主线所有权拆分。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 14--25 | `pp:ifndef __H_VENUS_HFI_H__` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 276--295 | `chunk:276` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |
| 296--296 | `pp:endif` | `—` | 语义拆分：设备/会话/资源状态按主线所有权拆分。 |

覆盖校验：296/296 行，连续、无空洞、无重叠。

## `vidc_hfi_api.h`

- 原厂物理行：1524；当前语义落点：`core.h + hfi_helper.h + 标准 V4L2 controls`；默认判定：**选择性迁移**。
- 文件级结论：HAL enum/结构只作协议参考；标准 ABI 优先。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 14--25 | `pp:ifndef __VIDC_HFI_API_H__` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 26--50 | `chunk:26` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 51--75 | `chunk:51` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 76--100 | `chunk:76` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 101--125 | `chunk:101` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 126--150 | `chunk:126` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 151--175 | `chunk:151` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 176--200 | `chunk:176` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 201--225 | `chunk:201` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 226--250 | `chunk:226` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 251--275 | `chunk:251` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 276--300 | `chunk:276` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 301--325 | `chunk:301` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 326--350 | `chunk:326` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 351--375 | `chunk:351` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 376--400 | `chunk:376` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 401--425 | `chunk:401` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 426--450 | `chunk:426` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 451--475 | `chunk:451` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 476--500 | `chunk:476` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 501--525 | `chunk:501` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 526--550 | `chunk:526` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 551--575 | `chunk:551` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 576--600 | `chunk:576` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 601--625 | `chunk:601` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 626--650 | `chunk:626` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 651--675 | `chunk:651` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 676--700 | `chunk:676` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 701--725 | `chunk:701` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 726--750 | `chunk:726` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 751--775 | `chunk:751` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 776--800 | `chunk:776` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 801--825 | `chunk:801` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 826--850 | `chunk:826` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 851--875 | `chunk:851` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 876--900 | `chunk:876` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 901--925 | `chunk:901` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 926--950 | `chunk:926` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 951--975 | `chunk:951` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 976--1000 | `chunk:976` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1001--1025 | `chunk:1001` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1026--1050 | `chunk:1026` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1051--1075 | `chunk:1051` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1076--1100 | `chunk:1076` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1101--1125 | `chunk:1101` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1126--1150 | `chunk:1126` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1151--1175 | `chunk:1151` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1176--1200 | `chunk:1176` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1201--1225 | `chunk:1201` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1226--1250 | `chunk:1226` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1251--1275 | `chunk:1251` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1276--1300 | `chunk:1276` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1301--1325 | `chunk:1301` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1326--1350 | `chunk:1326` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1351--1375 | `chunk:1351` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1376--1400 | `chunk:1376` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1401--1425 | `chunk:1401` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1426--1450 | `chunk:1426` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1451--1475 | `chunk:1451` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1476--1500 | `chunk:1476` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1501--1523 | `chunk:1501` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |
| 1524--1524 | `pp:endif /*__VIDC_HFI_API_H__ */` | `—` | 选择性迁移：HAL enum/结构只作协议参考；标准 ABI 优先。 |

覆盖校验：1524/1524 行，连续、无空洞、无重叠。

## `vidc_hfi_helper.h`

- 原厂物理行：1169；当前语义落点：`hfi_helper.h`；默认判定：**部分迁移**。
- 文件级结论：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 14--25 | `pp:ifndef __H_VIDC_HFI_HELPER_H__` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 26--50 | `chunk:26` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 51--75 | `chunk:51` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 76--100 | `chunk:76` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 101--125 | `chunk:101` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 126--150 | `chunk:126` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 151--175 | `chunk:151` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 176--200 | `chunk:176` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 201--225 | `chunk:201` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 226--250 | `chunk:226` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 251--275 | `chunk:251` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 276--300 | `chunk:276` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 301--325 | `chunk:301` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 326--350 | `chunk:326` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 351--375 | `chunk:351` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 376--400 | `chunk:376` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 401--425 | `chunk:401` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 426--450 | `chunk:426` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 451--475 | `chunk:451` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 476--500 | `chunk:476` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 501--525 | `chunk:501` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 526--550 | `chunk:526` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 551--575 | `chunk:551` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 576--600 | `chunk:576` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 601--625 | `chunk:601` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 626--650 | `chunk:626` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 651--675 | `chunk:651` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 676--700 | `chunk:676` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 701--725 | `chunk:701` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 726--750 | `chunk:726` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 751--775 | `chunk:751` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 776--800 | `chunk:776` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 801--825 | `chunk:801` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 826--850 | `chunk:826` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 851--875 | `chunk:851` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 876--900 | `chunk:876` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 901--925 | `chunk:901` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 926--950 | `chunk:926` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 951--975 | `chunk:951` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 976--1000 | `chunk:976` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1001--1025 | `chunk:1001` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1026--1050 | `chunk:1026` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1051--1075 | `chunk:1051` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1076--1100 | `chunk:1076` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1101--1125 | `chunk:1101` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1126--1150 | `chunk:1126` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1151--1168 | `chunk:1151` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |
| 1169--1169 | `pp:endif` | `—` | 部分迁移：wire ID/packed struct 必须精确；未使用私有能力不等于应公开。 |

覆盖校验：1169/1169 行，连续、无空洞、无重叠。

## `vidc_hfi_io.h`

- 原厂物理行：196；当前语义落点：`hfi_venus_io.h`；默认判定：**部分迁移**。
- 文件级结论：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--13 | `file:start` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 14--25 | `pp:ifndef __VIDC_HFI_IO_H__` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 26--50 | `chunk:26` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 51--75 | `chunk:51` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 76--100 | `chunk:76` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 101--125 | `chunk:101` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 126--150 | `chunk:126` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 151--175 | `chunk:151` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 176--195 | `chunk:176` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |
| 196--196 | `pp:endif` | `—` | 部分迁移：只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。 |

覆盖校验：196/196 行，连续、无空洞、无重叠。

## `vidc_hfi.c`

- 原厂物理行：73；当前语义落点：`hfi.c`；默认判定：**架构替代**。
- 文件级结论：HAL 设备抽象由当前 HFI ops 替代。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--17 | `file:start` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 18--25 | `f:vidc_hfi_initialize` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 26--32 | `chunk:26` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 33--35 | `case:VIDC_HFI_VENUS` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 36--49 | `case:default` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 50--50 | `label:err_hfi_init` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 51--54 | `chunk:51` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 55--63 | `f:vidc_hfi_deinitialize` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 64--66 | `case:VIDC_HFI_VENUS` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |
| 67--73 | `case:default` | `—` | 架构替代：HAL 设备抽象由当前 HFI ops 替代。 |

覆盖校验：73/73 行，连续、无空洞、无重叠。

## `vidc_hfi.h`

- 原厂物理行：869；当前语义落点：`hfi.h + hfi_venus.h`；默认判定：**语义拆分**。
- 文件级结论：callback/ops 只迁行为，不复制接口布局。

| 原厂行 | 锚点 | 当前同名 token | 复核结论 |
|---:|---|---|---|
| 1--12 | `file:start` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 13--25 | `pp:ifndef __H_VIDC_HFI_H__` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 276--300 | `chunk:276` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 301--325 | `chunk:301` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 326--350 | `chunk:326` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 351--375 | `chunk:351` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 376--400 | `chunk:376` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 401--425 | `chunk:401` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 426--450 | `chunk:426` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 451--475 | `chunk:451` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 476--500 | `chunk:476` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 501--525 | `chunk:501` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 526--550 | `chunk:526` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 551--575 | `chunk:551` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 576--600 | `chunk:576` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 601--625 | `chunk:601` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 626--650 | `chunk:626` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 651--675 | `chunk:651` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 676--700 | `chunk:676` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 701--725 | `chunk:701` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 726--750 | `chunk:726` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 751--775 | `chunk:751` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 776--800 | `chunk:776` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 801--825 | `chunk:801` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 826--850 | `chunk:826` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 851--867 | `chunk:851` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |
| 868--869 | `pp:endif` | `—` | 语义拆分：callback/ops 只迁行为，不复制接口布局。 |

覆盖校验：869/869 行，连续、无空洞、无重叠。

## 总覆盖校验

- 文件：42/42；
- 物理源代码行：39111/39111；
- C 函数定义锚点：686/686；
- 连续复核区间：5512；
- 每个文件均已验证区间覆盖数等于物理行数；任何缺行、重叠或未知文件策略都会使生成失败。

该校验证明审计范围完整，不等于所有 vendor 功能都应迁移。具体优先级、实机状态、
Main10/P010、encoder 首 ETB 与完整迁移状态见 `venus-sm8150-migration-status.md`；0018
逐 hunk 处置见 `venus-sm8150-pending-hunk-ledger.md`。
