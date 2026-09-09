# SM8150 / Raphael Venus test17

Test17 使用固定 Linux 基线
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，依次应用 `patches/series` 0001--0031。

## 本轮唯一功能变化

Test16 已通过 H.264 小分辨率/720p/1080p/reopen 和 HEVC Main8，但 VP8
在 source-change 后的首批 DPB FTB 收到固件
`HFI_ERR_SESSION_BAD_POINTER (0x1003)`，输出 0 帧。0030 按小米 SM8150 原厂
split-output 合同分开广告：

- driver-owned DPB port actual = firmware minimum；
- client-facing OPB port actual = V4L2 capture queue depth；
- IRIS1 decoder INPUT/OUTPUT/OUTPUT2 host-min = firmware minimum。

Test16 已证明 encoder 在第一条 ETB 入队后、任何 EBD/FBD 前硬复位。日志同时证明
raw source 已是双向 DMA，而四个 compressed CAPTURE FTB 仍是
`bidirectional=0`。0031 按小米 SM8150 原厂“所有 video dma-buf 均双向映射”的
合同，把 IRIS1 encoder CAPTURE 队列也改为双向；`iris1_encoder=N` 仍是默认安全值。

## 一次性验证

默认运行：

```bash
sudo env VENUS_TEST_ENCODER=0 bash /home/user/venus-test17-suite.sh
```

脚本验证 H.264 320x240/720p/1080p/reopen、HEVC Main8/Main10、VP8、
VP9 Profile0/Profile2、MPEG2 与两轮 runtime suspend/resume。一个 codec 失败后
立即停止，避免重现 Test16 的固件事件/内核日志风暴。编码首帧会单独执行，
不再为了到达编码阶段而强行穿过一个已失败的 decoder 会话。

每个 PASS 都要求精确帧数和与软解一致的帧 hash；FFmpeg 返回 0 但
0 帧不算通过。报告仅保存在本机 `/var/tmp/venus-batch.*/report.tar.gz`。

## 关键日志

0030 会输出：

```text
venus-sm8150: decoder buffer roles ... output=... output2=... opb=... dpb=...
venus-sm8150: queue DPB type=... tag=... dma=... alloc=...
```

如果 VP8 仍失败，请保留报告，不要反复运行。新日志已足以区分
count contract 、具体 DPB pointer 与其他 firmware requirement，无需再编译诊断版。

构建后内核版本必须为 `7.1.0-sm8150-venus-test17+`。
