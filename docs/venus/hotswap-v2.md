# Venus hot2：从未绑定旧驱动单向热替换，不自动恢复旧版

## 目的与边界

用户明确要求继续采用模块热替换，避免重新编译整个内核。此方案不重新启用已暂停的 `test-session-module-once.sh`；提供新的、约束更严格的加载入口。

已知事故日志显示父 OF 引用下溢、重新绑定原模块时的 kernfs NULL dereference，以及随后 journald 停止异常。原错误状态无法通过新模块自动修复。**发生该事故后必须正常重启；单纯退出脚本、清空 dmesg 或再次 insmod 不是恢复。**

固定 Linux 基线：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`。手机现有完整内核：`7.1.0-sm8150-ga0ca2cbb4b3d`，发布源码 `a0ca2cbb4b3d783c864efd14d52940867f683cc6`，构建仓库发布提交 `8696e96d67d52cc3e5796598f8c2eed3ed2fd13c`。

新 core 包含当前 23 项 series，重点为 `0021` 的 IRIS1 固件/主机电源策略一致性、`0022` 的有界超时诊断和 `0023` 的父节点引用修复。此轮未修改任何内核补丁、配置、DTB 或完整构建脚本。测试 core 单独增加 `MODULE_VERSION("iris1-swpc-ofref-hot2")` 身份标记，不影响接口，不编入正式 patch。

## 为什么要求旧驱动未绑定

旧 core 的子节点查找已被证明会消耗借用的父节点引用。即使新模块已修好该问题，直接对一个可能已损坏的旧绑定执行 remove/unbind 仍有风险。

新入口只接受本次启动的**首次旧 probe 以 -110 结束、当前未绑定、无残留 codec 子节点**的状态。它不在旧驱动已绑定的情况下执行热卸载，也不替旧驱动修正任何内存引用计数。用户应在干净重启后直接运行本包，不再手工 `power/control=on` 后 bind 旧 core。

这些检查是保守准入条件，不是对真实 kobject/refcount 健康状态的数学证明。若正常重启后旧驱动意外绑定成功，本入口仍会拒绝；不提供 force 绕过。

## 加载入口

源码：`tests/venus/hotswap-v2-load.sh`；打包名 `load.sh`。

- 默认 `--check`，仅核对内核/架构、三份原磁盘模块哈希、候选版本/vermagic、旧模块状态、设备树父链接、首次 probe 日志和 taint。会打开 `/run` 中的测试锁，但不操作模块。
- `--load` 必须显式传入。检查 WARN/Oops/bad-page/lockup 等 taint、refcount/NULL pointer 日志并拒绝异常启动；不清除警告，不篡改引用计数。
- 使用正常 `rmmod` 依次卸载未绑定的原 decoder/encoder/core，不带 `-f`，不递归移除其他依赖。
- 仅将 Venus 父设备置 `power/control=on`，`insmod` 新 core；确认绑定与版本后加载原磁盘 decoder/encoder。其源码与公开结构相对原发布版未变，前述驱动原文件均需通过哈希校验。新 core 已加载，显式 modprobe 列表不包含 core。
- 每次启动只允许一次加载尝试，通过 `/run/venus-hot2-<boot-id>` 标记与锁避免并发或叠加。
- **EXIT/INT/TERM 路径只记录日志，不执行卸载或原版恢复。** 任何失败均停住，保存当前状态，由正常重启回到磁盘原版。不写 `/boot`、`/lib/modules`、initramfs、modprobe 配置或开机服务。

加载成功后修补版留在内存，runtime PM 保持 on。本方案不测试自动休眠，也不将耗电偏高的临时策略当作长期电源修复。

## 解码与编码分阶段

源码：`tests/venus/hotswap-v2-codecs.sh`；打包名 `test-codecs.sh`。两个方向分开调用，不自动串联。

`--decode` 在加载成功的同一 boot 中，用 libx264 软件生成 640×480、15 fps、30 帧短片。先以软件解码生成 NV12 参考，再显式用 h264_v4l2m2m 完整解码。只有 FFmpeg rc=0、实际选择期望 Venus 节点、输出 13824000 字节、所有像素与软件参考逐字节相同、无新增内核 WARN/Oops 时，记录本样片 decode.success。不设置一帧输出上限，也不故意提前截断硬解结果。

`--encode` 仅在以上 decode.success 后允许，使用同一批 NV12 原始帧硬编码 H.264（目标 1 Mb/s，GOP 15，无 B 帧）。软件解码新 H.264 并检查完整 30 帧和尺寸，**不要求有损编码与输入逐字节相同**，不将帧数检查误称为画质/码率验收。

两项硬件命令均有 15 秒 timeout 和 3 秒强制终止进程宽限；它们不能保证打断内核不可中断等待或芯片硬复位。每方向只尝试一次，失败后不自动继续下一项、不 unload/reload。

日志和样片保存在 `/var/tmp/venus-hot2.*`，比 `/tmp` 更适合重启后保留；如果该系统特别配置为易失文件系统，用户应再复制到 home。旧的 `/home/user/venus-recovery.pXMfrO` 和原测试样片不改动。

## 编译、测试与验收限制

构建仅使用已发布 headers 包的 generated 配置、kernel.release 和 Module.symvers，在 AMD64 上执行 LLVM22/Kbuild external-module build。原 headers 内的 x86-64 fixdep/modpost 用于当前 AMD64 编译主机，不在手机上运行。不重建完整源码树，不运行 bindeb-pkg，不强改 vermagic。

验证包括：三个新模块 AArch64，vermagic/depends 与原模块一致；导出符号名与已发布 Module.symvers 一致；公开结构、vdec/venc 源码与发布版相同。只分发需要替换的 core，保留对应完整 Venus 源码和 GPL 许可证以复现构建。

新脚本测试在临时目录改写**测试副本**的路径与 root 判断，module commands 和 FFmpeg 都由 host stubs 替代。测试覆盖错误内核、原版哈希不符、Oops/WARN、重复 probe、旧驱动仍绑定、卸载/插入/绑定失败、禁止自动恢复原 core、编码前置门槛、短帧/像素不一致及单次限制。没有给正式脚本增加可用环境变量绕过检查。

主机测试证明的是控制流，不证明真实硬件生命周期已安全。以前候选的单帧成功不能替代本新包的连续解码、编码或卸载验证。本包只发布为临时模块测试 artifact，不放入 update-kernel.sh 的内核 Pre-release 列表。

接口参考：`https://docs.kernel.org/kbuild/modules.html`；`https://docs.kernel.org/admin-guide/tainted-kernels.html`。具体实现以固定源码和本包脚本为准。
