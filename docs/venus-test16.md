# SM8150 / Raphael Venus test16

Test16 使用固定 Linux 基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，当前依次应用 `patches/series` 的 29 个补丁。
它不宣称 Venus 已完整适配；这是全量审计后用于一次实机闭环的候选构建。

Test16 首次云构建在 `venc_iris1_validate_external_req()` 被 Clang `-Werror` 截停：
只读 requirement 指针是 `const`，旧 getter 签名却要求可写指针。0029 将三个纯 getter
改为 `const` 参数，不改变 HFI、DMA 或运行时行为。重跑同时移除 ccache，避免当前
ARM runner 的冷缓存恢复/保存开销。

权威范围、逐文件处置、全部已知差异和准入矩阵见
`MIGRATION-STATUS.md`。Test15 的历史 173-hunk、0018 的 35-hunk 与 0019 的 11-hunk 台账
都随产物保存。

## 0018 的功能变化

- HFI4/IRIS1 为 P010 发送原厂两颜色 plane constraints：256-byte stride、Y/UV
  32/16 scanlines、256-byte buffer alignment；
- IRIS1 P010 allocation 按小米 SM8150 公式保留 4 KiB tail padding；320x240 预期
  `stride=768`、`sizeimage=299008`；
- ENUM_FMT 保持 capability 稳定，TRY/S/G_FMT 按当前 stream bit depth 严格选择；
- 修正 HFI capability parser 的 payload 长度和 mixed raw-plane 计算；
- IRIS1 encoder NV12 使用原厂 allocation 公式；128x96 预期 24,576 bytes，而不是
  Test15 Stage9 的 32,768 bytes；
- encoder raw source VB2 queue 使用原厂对应的 bidirectional DMA mapping；
- 兼容解析 VPU5 80/84-byte EBD 尾部，保存 recon/UBWC CR/complexity；
- format/lifecycle 改变会使 bufreq cache 失效，mapping 失败会 rollback，stream 统计清零；
- RECON 仍只做 metadata/index，不向固件静态登记 type 9 DMA。

## 0019 的功能变化

- 按 SM8150 量产 DTS 实际选用的 `msm_vidc_dyn_gov` 移植完整 decoder/encoder Q16
  DDR/LLCC 公式，而不是使用非目标 AR50 模型；
- VPU5 EBD tail 的 CR/CF 同时服务 decoder 和 encoder，并按 recon index 保存，投票时
  取最小有效 CR、最大有效 CF，fallback 为原厂 CR=5、CF=1；
- EBD 完成会清除对应在飞 input payload并递增原厂语义的 buffer counter；
- 前 16 个 EBD 前同时保持 533 MHz 与 6,533,000 最大带宽票，避免首 ETB 仍落在
  SDM845 小分辨率静态票；
- 原厂动态 `VideoP0 -> LLCC` 与 `LLCC -> EBI` 两段结果，在当前端到端 `video-mem`
  path 上取 `max(DDR, LLCC)`；多实例求和后饱和；
- 8 个 H.264/HEVC/VP9、8/10-bit、decode/encode、cache/downscale 精确向量已在宿主通过。

动态投票仍是待实机候选。必须观察 ICC、频率、EBD/FBD、PM 和长序列；宿主数值一致不等于
provider 单位与硬件稳定性已经通过。

## 0023 的 Main10 兼容变化

- IRIS1 10-bit stream 允许原厂的 TP10 UBWC reference DPB + NV12 secondary client output；
- 支持 P010 的客户端仍可显式选择 native P010，非 IRIS1 行为不变；
- source-change 不再强制覆盖客户端已选择的 NV12；启动前严格验证 TP10/NV12 HFI pair；
- firmware FBD 的 offset/bytesused 越界会把 buffer 标记为 error，不再传播无效 payload；
- NV12 路径是硬件实际下转换后的 8-bit OUTPUT2，不是把 P010 数据错误标记为 NV12。

## 0024 的 encoder DMA contract 变化

- REQBUFS 直接采用 firmware 的 INPUT/OUTPUT size、count 和 alignment contract；
- compressed CAPTURE 不再使用 73,728-byte host estimate 覆盖 firmware 的 36,864-byte size；
- 不再以 73,728-byte host estimate 发送 output-size property；0027 按原厂发送同 wire
  `0x20100c`，值为 firmware-negotiated 36,864-byte capture size；
- ETB/FTB 前验证 32-bit DMA range、allocation、payload 和 alignment；
- FBD 的 bytesused/data_offset 分离，并在返回 userspace 前做 plane 边界检查。

## 安全边界

`iris1_encoder=N` 仍是默认值，也是唯一 encoder 安全 gate。Stage0--9 以及可关闭原厂
NV12 size / bidirectional DMA 的实验参数已经删除；总 gate 关闭时不会启动 encoder
session，总 gate 明确设为 Y 后只执行一条完整、固定的原厂顺序。

Test13--15 已证明 Stage0--8，无需重复。唯一新的高风险 encoder 测试必须先开持久远程
`dmesg -w`，确认 24,576-byte raw allocation、bidirectional=1、前16 EBD 的 533 MHz/
6,533,000 带宽、FTB/LOAD/START 后，仅提交一次最小 ETB。若重启，重启本身即为失败
结果；不要连续重试。

## 自动回归范围

`venus-test-suite.sh` 默认验证：

- H.264 320x240、720p、1080p 与 reopen，逐帧对软件 hash；
- HEVC Main8 MKV 与 Main10 MKV，各 30 帧逐帧对软件 hash；
- VP8、VP9 Profile0、MPEG2 各 30 帧；工具齐全且 Main10 通过后再测 VP9 Profile2；
- runtime PM 两轮 suspend/resume；
- 所有错误会停止后续 codec job，并保存本机 report archive；
- encoder 只在显式 `VENUS_TEST_ENCODER=1` 时启用；先测试 1 帧 H.264，再测试 30 帧
  H.264、HEVC、VP8，每项都要求非空码流且可以由软件解码出精确帧数。

H.264/Main8 回归失败时不要进入 Main10。Main10 必须非空 30 帧、hash 相同并在退出后回
`suspended` 才算通过。FFmpeg exit 0 但 0 帧不算通过。

构建后内核版本必须为 `7.1.0-sm8150-venus-test16+`。

## 实机结果（2026-09-09）

| 项目 | 结果 |
|---|---|
| H.264 small/720p/1080p/reopen | PASS |
| HEVC Main8 MKV | PASS |
| VP8 MKV | FAIL；0 帧，`POLLERR/EIO` |
| VP9p0/MPEG2/Main10/VP9p2 | 旧脚本在 VP8 失败后提前停止，未测 |
| encoder | 默认 gate 为 N，该次未测 |

VP8 不是容器问题：固件已完成 session init、internal buffers、LOAD/START
和 source-change，随后在 DPB FTB 阶段返回 event `0x1003`。小米原厂定义该值为
`HFI_ERR_SESSION_BAD_POINTER`。对比原厂后确认当前 Venus 把 OUTPUT 与 OUTPUT2
都广告为 `VB2_MAX_FRAME`，但实际只分配 firmware-minimum 数量的内部 DPB。
修复候选及逐 hunk 依据见 `venus-sm8150-0030-hunk-ledger.md`。
