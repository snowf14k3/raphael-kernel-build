# Raphael Venus 测试内核云编译

这个仓库只做一件事：编译包含 SM8150 Venus 适配及运行修正的
Redmi K20 Pro（Raphael）Linux 测试内核。

当前实机冻结点是 **Test21**，下一构建标识为 **Test22**，目前包含候选补丁 0001--0036。
Test16 已实机通过 H.264 小分辨率/720p/1080p/reopen 和 HEVC Main8；VP8 在
source-change 后被固件以 `HFI_ERR_SESSION_BAD_POINTER (0x1003)` 拒绝，旧脚本因此
没有执行后续 codec。Test15 的历史编码验证为：
Stage 0--8 通过，但 Stage 9 仍在首个 raw ETB 后整机复位。以小米 Android 10
SM8150 实现为依据，补齐固件启动前的电源域、时钟与 MMCX 性能投票、
MVS0/CVP 控制权切换及失败回退，并修复 VPU5 的 HFI 4xx 属性封包。
编码、解码都使用 MVS0；不把 CVP 当作第二个视频核心。
在此基础上增加 HFI 队列校验、通信/电源诊断和一次运行的实机测试脚本。
test8 让 CAPTURE 格式枚举及时跟随所选 codec，使 HEVC/VP9 能在会话创建前
暴露 P010，并修正 10-bit source-change 的格式计算顺序。test9 继续补齐原厂
SM8150 的 P010 256 字节 stride 约束、按流位深过滤实际 S/TRY_FMT，以及标准
HEVC Main/Main10 profile 控件；同时接入原厂 VIDSC0/VIDSC1 LLCC 系统缓存，
补齐 HFI 4xx FRAME_QP，并校正 H.264 Baseline/自动 level 默认参数。test10
进一步修正 all-layer 码率、VUI 和 level 封包，并让编码会话在 STREAMON 到完整
STREAMOFF 期间持续持有电源。编码属性和 buffer requirements 按原厂顺序只
设置/读取一次，HFI4 分开发送 VB2 actual 与固件 minimum，并跳过 VPU5 不支持
的 MAX_BITRATE 属性。进入硬件前还有资源完整性检查及默认关闭的协议门，
避免桌面或 RDP 误触发尚未实机确认的编码路径。test11 根据实机
函数图定位并修复 Baseline Profile 与默认 8×8 Transform 冲突导致编码节点
`open()` 返回 `-EINVAL` 的问题。test12 根据实机 DMA 硬锁结果，保留固件原始
buffer minima，并在修改缓冲区计数和大小后重新查询最终需求，避免按过期快照
分配内部 DMA 缓冲区。test13 的 Stage 0--8 均通过，但 Stage 9 在首个 ETB 后
整机复位。test14 增加按 RC mode 选择 WORK_MODE、ETB 确定性日志并继续保留
0--9 共十个检查点；其 Stage 0 随后证实 FFmpeg 实际使用 VBR，mode 2 本来就与
原厂一致。test15 补上原厂把 FRAME_RC_ENABLE 独立映射到
VENC_DISABLE_RC_TIMESTAMP 的 HFI 属性；现有驱动已有该属性的正确 ID 与封包，
但此前从未发送。Test15 已确认该属性实际发送为 1、VBR mode 仍为 2；Stage 9 依旧
复位，所以它不是根因。该结论作为历史证据保留；0027 已删除 Stage0--9，编码仍由
唯一 `iris1_encoder` 总 gate 默认关闭。
本轮还按原厂补齐 Annex-B NAL 格式，跳过原厂不会发送的 IRIS1 NV12 stride
属性和零计数 LTRMODE。0019 进一步按 SM8150 量产 DTS 实际选用的通用 governor
移植 Q16 DDR/LLCC 动态带宽、per-recon CR/CF 聚合与前16个 EBD 的最大时钟/带宽；
在当前端到端 `video-mem` ICC path 上取原厂两段动态结果的最大值。8 个精确数值向量已
通过宿主验证，真实 ICC、长时、多实例和完整编码仍待实机，不能提前称编码修复。

0024 已把 raw NV12 input 收敛到原厂 layout、compressed capture 收敛到 firmware
requirements，并固定双向 DMA。0026 补齐 Main10 geometry、colorimetry、动态
reconfigure、flush/drain。0027 重新逐行核对原厂启动函数后，纠正此前的误判：原厂确实
在最终 requirements 后发送 wire `0x20100c` 的 `BUFFER_SIZE_MINIMUM`；当前以上游同
wire 名称发送 firmware-negotiated capture size。0027 同时删除全部 staged 分叉，使
显式开启 gate 后只执行一条完整原厂顺序。0028 仅把历史 test 日志前缀统一为稳定的
`venus-sm8150`，没有改变协议行为。0029 修正三个只读 buffer-requirement getter 的
`const` 签名，解决 Test16 首次 ARM64 构建发现的 Clang `-Werror`，不改变协议或运行时行为。
0030 根据 Test16 日志和小米 SM8150 原厂 split-output 合同，分开 driver-owned
DPB 与 client-facing OPB 的 actual count，并记录每个 DPB FTB；待 Test17 实机验证。
0031 根据 Test16 首 ETB 后硬复位的最后日志，把 IRIS1 encoder CAPTURE 队列也改为
双向 DMA；Test16 只有 source 为双向，而小米原厂对所有 video dma-buf 都使用
`DMA_BIDIRECTIONAL`。完整证据和已排除项见
`docs/venus-test16-encoder-reset-analysis.md` 与
`docs/venus-sm8150-0031-hunk-ledger.md`。

0032 尝试把 encoder count 移到 REQBUFS 并减少默认属性包。Windows 外部 SSH 保存的
Test18 完整日志证明这与 mainline 的 control 生命周期不兼容：OUTPUT 先提交
`actual=4 host-min=2`，properties 后固件最终要求 `min=4`，会话收到
LOAD_RESOURCES_DONE 后在 START 内停止，尚未发送 FTB/ETB。0033 删除提前 count，改在
controls/route/mode/core 后提交 INPUT 16/3 与 OUTPUT 4/2，并恢复 Test17 已到达
START_DONE 的属性集合，同时保留 HFI 包体清零。0033 还移植原厂
`DMA_ATTR_IOMMU_USE_UPSTREAM_HINT` 到 ARM LPAE MAIR 0xf4 的链路，只用于 IRIS1 encoder
MMAP 和 internal buffers，以处理 Test17 独立的首 ETB 后复位边界。详细证据见
`docs/venus-test18-start-reset-analysis.md` 与
`docs/venus-sm8150-0033-hunk-ledger.md`。

Test19 在更早的 HFI4 `QP_RANGE_V2` 属性 `0x2005009` 后立即关机，尚未执行最终 count、
LOAD 或 START。复核发现 0022 把上下游原本固定为 7 的 I/P/B enable mask 改成从调用者
复制，但调用者从未赋值；0032 清零后它稳定变成 0。0034 恢复两个 enable mask 为 7，
并逐项复核同一 H.264 启动序列的其余 payload 字段。详细证据见
`docs/venus-test19-property-reset-analysis.md` 与
`docs/venus-sm8150-0034-hunk-ledger.md`。

Test20 已通过全部属性、count、internal buffers、LOAD、START_DONE 和四个 FTB，随后在
首个 64-byte ETB 后、EBD/FBD 前复位。逐字段审计确认 ETB、128x96 NV12 layout、IOVA、
route/mode/core、内部 buffer、时钟和带宽均对齐；剩余直接差异是 DMA coherency：0033
把 upstream-cache PTE 用在 coherent MMAP allocation 上，而原厂使用 streaming dma-buf
并在 QBUF/DQBUF 做 cache maintenance。0035 强制 IRIS1 encoder MMAP 走 VB2
non-coherent/streaming allocation 和同步，并在分配时强制检查 `bidi=1 nc=1 up=1`。
完整排除矩阵见 `docs/venus-test20-etb-reset-analysis.md` 和 0035 ledger。

Test21 没有进入硬件：公共 `dma_alloc_noncontiguous()` 入口只允许
`DMA_ATTR_ALLOC_SINGLE_PAGES`，在看到 upstream hint 后于 `kernel/dma/mapping.c:805`
WARN 并返回 NULL。0036 将该属性加入精确 allowlist，其他未知属性仍拒绝；证据包也新增
DMA wrapper/include 源码和第 16 组 current/vendor 检查，避免再次只审到底层实现而漏掉入口。

为避免终端检索结果随对话压缩丢失，`scripts/capture-venus-encoder-audit.ps1`
会固定 current index tree、Xiaomi commit、Test20 外部日志、49 份完整相关源文件和
16 组 current/vendor 双向检索。原始包保存在本机
`.audit/test20-full-chain/`，由 `.git/info/exclude` 排除，避免把原厂整文件推到公开仓库；
`REVIEW.md` 和 `SHA256SUMS` 分别保存逐批结论与每个证据文件的哈希。

同一补丁系列还限制 Raphael 面板的高频亮度更新：test14 恢复 LP 命令并将请求
合并为最多 4 Hz，直接 sysfs 压力测试已不再闪屏。GNOME 亮度/音量弹窗仍可触发
GPU IOVA fault，卸载 Venus 后同样复现，已确认是独立的 Adreno/合成器问题。

实机已确认 HEVC Main10 在内核中协商为 P010 并返回首个 CAPTURE buffer；Debian
FFmpeg 7.1 仍会拒绝该帧。0023 按小米 SM8150 原厂语义恢复 TP10 UBWC reference DPB
加 NV12 secondary output，并保留原生 P010；这里的 NV12 是 firmware 真正下转换的
8-bit OUTPUT2，不是把 10-bit 数据伪报为 NV12。该实现已通过宿主测试，仍待目标机闭环。

构建前会编译并运行实际补丁函数的宿主机故障注入和边界测试，再进行
完整 arm64 内核编译。自动检查不代表实机硬件编解码已经通过。
Actions 不再安装、恢复或保存 ccache；当前 ARM runner 的冷缓存和归档开销反而延长
这类一次性测试构建，Test17 直接使用 Clang 并行编译。
最新权威状态、完整语义差异、已完成组和剩余组见
[SM8150 Venus 全量差异与迁移矩阵](docs/venus-sm8150-full-difference-matrix.md)；此前的
[SM8150 Venus 全量迁移主报告](docs/venus-sm8150-migration-status.md)作为冻结过程记录保留。
0018 的 35 个 hunk
逐项处置见 [0018 hunk 台账](docs/venus-sm8150-pending-hunk-ledger.md)，0019 的 11 个 hunk
见 [0019 动态带宽台账](docs/venus-sm8150-0019-hunk-ledger.md)。历史修正范围见
[test15 说明](docs/venus-test15.md) 和
[SM8150 编码核对记录](docs/venus-sm8150-encoder-audit.md)；Test15 的 19 文件/173 hunk
冻结审计见 [SM8150 Venus Test15 审计](docs/venus-sm8150-full-migration-audit.md)，逐段台账见
[Test15 hunk 台账](docs/venus-sm8150-test15-hunk-ledger.md)，每一条原始增删行见
[`venus-sm8150-test15-vs-base-full.diff`](docs/venus-sm8150-test15-vs-base-full.diff)；小米
原厂 42 文件、39,111 行的连续覆盖和迁移判定见
[原厂逐行台账](docs/venus-sm8150-vendor-line-ledger.md)，当前候选 Venus 36 文件、
22,143 行、524 函数、3,079 区间的 0032 冻结反向覆盖见
[当前逐行台账](docs/venus-sm8150-current-line-ledger.md)；0033 的全部新增/回退行由独立
hunk ledger 接续覆盖；
早期原厂、postmarketOS 对照依据保留在 [test4 说明](docs/venus-test4.md)。

源码仍来自 `snowf14k3/linux` 的 `raphael-7.1` 分支，构建时会应用本仓库
`patches/series` 中的三十六个补丁（原厂时序、队列校验、诊断、VPU5 会话配置、
HFI 4xx 会话属性、两轮 10-bit 格式协商、SM8150 系统缓存/编码参数，以及
编码会话生命周期加固）。
补丁基于源码提交 `58f3df07833f2382fe2fbc28f996c4c85817c1f6`；
分支如果移动，构建会停止，避免补丁和基线悄悄错配。
因此源码提交号不变不代表补丁未生效；请同时核对内核版本、构建仓库提交
和补丁 SHA256。构建失败时不会继续打包。

## 使用方法

1. 打开仓库顶部的 **Actions**。
2. 在左侧选择 **Build Raphael Venus test kernel**。
3. 点击 **Run workflow**，再点击绿色的 **Run workflow**。
4. 等待任务变成绿色。首次编译通常需要一段时间。
5. 打开这次运行记录，在页面底部下载
   **raphael-venus-test-kernel**。

下载后先不要安装。回到当前 Codex 对话，我们再逐步备份和测试。

## 下载包内容

- `linux-image-xiaomi-raphael-venus-test.deb`：测试内核及模块。
- `sm8150-xiaomi-raphael.dtb`：包含 Venus 节点的设备树。
- `kernel.config`：本次实际使用的内核配置。
- `build-info.txt`：内核版本、源码提交、构建仓库提交及补丁清单 SHA256。
- `patches.sha256`：三十六个补丁各自的 SHA256。
- `venus-test-suite.sh`：安装并启动 test22 后，一次运行的实机测试脚本；任一 codec
  失败立即停止，避免固件事件/日志风暴；硬编码由
  唯一总 gate 默认关闭；显式设置 `VENUS_TEST_ENCODER=1` 后先测 1 帧 H.264，再测
  30 帧 H.264/HEVC/VP8，每项要求非空且可软件解码，失败即停止剩余 codec job。
- `TESTING.md`：测试范围、运行方式、限制与日志说明。
- `ENCODER-AUDIT.md`：随构建产物保存的原厂逐项核对、已排除方向和实机结论。
- `FULL-MIGRATION-AUDIT.md`：Test15 全量代码审计、原厂 42 文件语义映射和迁移路线。
- `MIGRATION-STATUS.md`：Test17 + 0001--0031 候选树的权威迁移总账和完整准入矩阵。
- `PENDING-HUNK-LEDGER.md`：0018 的 35 个 hunk 逐项原厂依据、风险和验证状态。
- `0019-HUNK-LEDGER.md`：0019 的 11 个动态带宽 hunk、精确向量和实机边界。
- `0020-HUNK-LEDGER.md`：0020 的时钟与 HQ/LP policy hunk。
- `0021-HUNK-LEDGER.md`：0021 的 encoder raw-format 15 个 hunk。
- `0022-HUNK-LEDGER.md`：0022 的 encoder controls/HFI4 34 个 hunk。
- `0023-HUNK-LEDGER.md`：0023 的 Main10 split-output 5 个 hunk。
- `0024-HUNK-LEDGER.md`：0024 的 encoder DMA contract 12 个 hunk。
- `0026-HUNK-LEDGER.md`：0026 的 Main10 reconfigure/flush/drain 迁移。
- `0027-HUNK-LEDGER.md`：0027 的 encoder 完整启动契约 17 个 hunk。
- `0028-HUNK-LEDGER.md`：0028 的稳定诊断前缀 57 个纯日志 hunk。
- `0029-HUNK-LEDGER.md`：0029 的 Clang `const` 编译修复。
- `0030-HUNK-LEDGER.md`：0030 的 VP8 BAD_POINTER、原厂 split-output count 依据和验收边界。
- `0031-HUNK-LEDGER.md`：0031 的 encoder CAPTURE 双向 DMA 依据、Test16 复位边界和排除项。
- `FULL-DIFFERENCE-MATRIX.md`：当前真值、全部语义域和剩余实机准入项。
- `TEST15-HUNK-LEDGER.md`：最终 173 个合并后 diff hunk 的逐项结论。
- `TEST15-VS-BASE-FULL.diff`：相对固定 7.1 基线的每一条原始增删行。
- `VENDOR-LINE-LEDGER.md`：小米原厂 `msm/vidc` 42 文件、39,111 行、5,512 个连续
  复核区间的逐行覆盖台账。
- `CURRENT-LINE-LEDGER.md`：0019 冻结点 `qcom/venus` 36 文件、22,143 行、3,079 个
  连续复核区间的反向逐行台账；之后的改动由 0020--0031 hunk ledger 连续覆盖。
- `SHA256SUMS`：文件完整性校验值。

构建过程不会创建 Release，也不会修改内核源码仓库。
