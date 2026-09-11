# IRIS1 首帧解码通过；恢复原版模块失败

> 后续已收到恢复阶段的引用计数/NULL pointer Oops，并定位到父节点查找的引用所有权错误。独立 `0023` 修复、证据和局部验证见 [父设备树节点引用修复](of-node-refcount-fix.md)。旧热替换入口继续停用；未在手机上验证生命周期修复。

记录日期：2026-09-12。本文依据用户粘贴的手机输出，不是编译服务器直接采集。

## 测试身份

- 运行内核：`7.1.0-sm8150-ga0ca2cbb4b3d`。
- 原发布源码：`a0ca2cbb4b3d783c864efd14d52940867f683cc6`，父提交固定 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`。
- 候选构建仓库提交：`a7cb15c`，新增独立 `0021` 电源策略一致性修正和 `0022` 最小诊断。
- 临时模块 version：`iris1-swpc-sessiondiag-1`。
- 用户下载包 SHA256：`51693ba51286f4d75329c411544276c02c12f4e68ad2021627677bba9f163005`，用户显示外层和内部文件校验通过。
- 手机测试目录：`/tmp/venus-session-once.fcOTt6`。
- 手机下载目录：`/tmp/venus-session-test.2esZ3W/venus-session-test-1`。
- 本次内核标记：`VENUS_SESSION_ONCE_1789148475_47402`。

## 能确认的成功范围

用户日志显示硬件 decoder 为 `h264_v4l2m2m`，FFmpeg 退出码 0，输出 `frame.nv12` 为 640×480 NV12，460800 bytes，等于 640×480×3/2。输出限制为一帧。Venus IRQ 从 8 增至 89。FFmpeg 统计内部解码 10 帧、0 decode errors，但只写出一帧，不能将其表述为 30 帧完整连续解码或 EOS/drain 压力验证完成。

这是第一次获得实际硬解输出的证据。其结果支持软件 GDSC 模式与 firmware power-control 禁用配套的候选方案能够越过先前 session-init 阻塞；不是严格隔离重初始化等所有变量的因果实验，也不证明全部电源或 session 问题已解决。像素内容尚未与软件输出比较，编码、HEVC/Main10、休眠恢复、并发和长期稳定性仍未验证。

日志中 `rawvideo` 的 `1 frames encoded` 是输出原始帧的写出统计，不是 Venus 硬编码器的验收结果。

已获得原始固件版本串：`14:VIDEO.IR.1.2-00045-PROD-1`。此前警告是模板未识别；该警告与此次成功出帧并存，不应据此让用户盲目更换固件。

## 恢复失败：不能把测试整体判为成功

关键用户输出：

```text
=== 恢复已安装的原版 Venus 模块 ===
.../test-once.sh: 第 50 行：47548 段错误               exit "$RC"
原版模块重新加载失败，停止测试并保留日志；未修改磁盘上的模块或启动文件。
```

已复核 `a7cb15c:tests/venus/test-session-module-once.sh`：

- 第 50 行是 `restore_original()` 定义，不能把 Bash 显示的行号及 `exit "$RC"` 当成内核故障位置。
- 第 58 行在 version 匹配时尝试正常卸载测试模块；失败会打印另一条提示并立即退出。当前粘贴未出现那条卸载失败提示。
- 第 63–65 行执行 `modprobe -a venus_core venus_dec venus_enc`；当前提示对应重新加载命令失败的分支。尚不能仅凭 Shell 输出确定具体哪个进程或驱动回调触发 SIGSEGV。
- 第 119–121 行在 EXIT trap 开始之前保存并打印 `kernel.log`；第 123 行退出后才执行恢复。因此用户当前粘贴的内核日志没有覆盖恢复阶段的崩溃，也不能据此认定不存在 Oops。
- 加载 out-of-tree 模块产生 taint 标记本身不等于崩溃；必须查看后续是否有独立 Oops/BUG/Call trace。官方说明：`https://docs.kernel.org/admin-guide/tainted-kernels.html`。

可能需要调查卸载/重新绑定中的资源与异步回调生命周期，但在拿到完整崩溃栈之前，不指定 UAF、IRQ、DMA、固件或某个 remove 函数为根因，不发送猜测性的内核修补包。

## 立即边界与下一步

1. 停止热替换、反复 modprobe/rmmod、编码或压力测试。
2. 已在编译仓库暂停 `tests/venus/test-session-module-once.sh`：在任何目标机检查、模块操作和 trap 注册前退出；保留后续原始代码供复核。这不会远程修改用户已经下载的旧包；原签名下载地址也不因此被撤销。旧包不得再次使用。
3. 用户先把本次标记之后的完整内核日志保存到持久路径并提供后半段，包括恢复期间的 PC/LR/Call trace。不要只重复已有 `kernel.log`，它停在恢复之前。
4. 保存日志后进行正常重启，不强制卸载卡住的模块。原测试脚本没有写 `/boot`、`/lib/modules` 或持久加载规则，正常启动预期加载磁盘上的原版，候选修正不会自动保留。不能在尚未检查时宣称已恢复。

本轮不修改 `patches/series` 或驱动源码、不重编译、不推送、不重新发布测试包、不操作手机。下一阶段的修复范围由真实恢复崩溃栈确定。
