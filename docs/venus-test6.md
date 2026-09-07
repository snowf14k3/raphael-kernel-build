# SM8150 / Raphael Venus test6

test6 针对 test5 已经定位到的“硬件编码第一帧前整机复位”补齐 VPU5
会话配置。源码基线仍固定为
`58f3df07833f2382fe2fbc28f996c4c85817c1f6`，按 `patches/series`
依次应用四个补丁。

## 本轮修正

- 按小米 `sm8150-v2` 原厂实现声明 2 条 VPP 管线；IOMMU Stream ID
  保持 v2 的 `0x2300/0x2301/0x2303/0x2304`。
- 在编码/解码会话中设置 VPU5 `WORK_ROUTE`，并在负载计算中按 route
  分摊 VPP 周期。
- 普通编码明确选择 Max Quality；为固件设置实际压缩输出缓冲大小。
- 无有效输入时不降低启动频率，最初 16 个返回的输入缓冲保持最高 OPP，
  对齐原厂 DCVS 启动窗口。
- 时钟或带宽投票失败时不再继续向固件提交视频帧。
- `iris1_debug=Y` 时不再受内核默认 10 条 ratelimit 限制，并给关键 HFI
  数据包标记 `LOAD_RESOURCES`、`START`、`EMPTY_BUFFER`、`FILL_BUFFER`。
- 测试脚本在每个已完成阶段执行 `sync -f`，意外复位后不再把此前日志
  全部丢成 0 字节。

## 边界

原厂 LLCC VIDSC0/VIDSC1 是可关闭的缓存加速项，不是会话正确性的前置条件，
本轮没有把旧版下游 LLCC 资源协议硬移植进主线 HFI。原厂 recon buffer
路径只维护固件返回引用的索引，不分配或提交 DMA 缓冲，也不应伪装成主线
内部缓冲类型。

构建后内核版本必须为 `7.1.0-sm8150-venus-test6+`。安装前继续保留当前
可启动内核和 `/boot/linux.efi`、`/boot/initramfs`、Raphael DTB 的备份。
