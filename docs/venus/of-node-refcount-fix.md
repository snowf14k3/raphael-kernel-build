# Venus 恢复模块崩溃：父设备树节点引用被查找函数错误消耗

记录日期：2026-09-12。固定内核基线 `ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`；实机原发布源码 `a0ca2cbb4b3d783c864efd14d52940867f683cc6`。本轮只修复一个 OF 节点所有权问题，不改变 HFI、电源策略或编解码数据路径。

## 1. 本轮收到的证据

用户上传 `粘贴的文本 (1)(20260911-174721).txt`，SHA256：

```
e940037d84fdc43987716c3ae679f67706070bd59de4ea40c0080414cb131ccc
```

来源是手机 `/home/user/venus-recovery.pXMfrO/kernel.log` 的最后 180 行筛选输出；文件开头已经是前一条 trace 的结尾。因此不是全部启动日志，不能声称已经看到最早的 WARN。

可见的明确事件：

- `3376.749652`：`refcount_t: underflow; use-after-free.`；进程是 `modprobe/47548`。栈经过 `kobject_put -> of_node_put -> pinctrl_dt_free_maps`。
- `3376.749917`：引用计数饱和警告，栈经过 `kobject_get -> of_node_get -> of_dma_is_coherent`。
- `3376.750295` 起：四个 genpd 虚拟设备创建 `of_node` 链接失败，错误 `-2`。
- `3376.785763`：kernel NULL pointer dereference，地址 `0x8`。
- Oops 栈：`kernfs_find_and_get_ns -> safe_name -> __of_attach_node_sysfs -> __of_attach_node -> of_changeset_apply -> venus_add_dynamic_nodes -> venus_probe`；仍处于重新加载原 `venus_core` 的 `modprobe` 上下文。
- 更晚 `3618/3708` 秒：systemd-journald 停止超时，SIGKILL 后仍有进程残留。这里只能确认后续系统已不适合继续测试，不能凭此断定与本次引用错误的全部因果细节。

这不是 FFmpeg 解码线程的 Oops，也不是文件缺失或者用户输入命令造成的 shell 语法错误。上一轮候选模块首帧出帧的证据仍单独保留；本附件本身不包含该帧测试正文。

## 2. 已核对的精确代码缺陷

固定基线和原发布版的 `drivers/media/platform/qcom/venus/core.c:306` 均为：

```c
enp = of_find_node_by_name(dev->of_node, node_name);
```

`dev->of_node` 是设备已有的父节点指针，本函数没有额外 `of_node_get()`。但固定 `drivers/of/base.c:1023-1047` 明确规定并实现：

```c
/* of_find_node_by_name(): of_node_put() will be called on @from. */
of_node_put(from);
```

所以每次查询都会消耗调用者没有取得的父节点引用，找到或没找到均如此。SM8150 在一次 probe 中分别检查 decoder/encoder，会发生两次不平衡的 put。该查找还是整个设备树后续遍历，而不是只查当前 Venus 的直接子节点，可能把另一个设备或更深层级的同名节点当作本设备子节点。

动态子设备退出、changeset revert 和释放过程中，其他合法引用退出后，该缺陷可导致父 kobject/sysfs 状态提前失效；随后重新 probe 中的 pinctrl、DMA/genpd、动态子节点创建才暴露错误。日志中 NULL 地址和 `safe_name()` 使用父 `kobj->sd` 的路径一致。这里并未宣称静态设备树节点的结构体内存必然已被 kfree，也没有计算手机每一刻的真实引用计数。

这是一个由源码所有权语义证明的真实缺陷，可以解释这条崩溃链。尚未在手机上验证修补后整个卸载/重载流程，不能把主机模型测试当作对所有生命周期错误的排除。

## 3. 独立修复

`0023-media-venus-preserve-parent-node-reference.patch`：

```diff
- enp = of_find_node_by_name(dev->of_node, node_name);
+ enp = of_get_child_by_name(dev->of_node, node_name);
```

`of_get_child_by_name()` 只搜索给定父节点的直接子节点，不消耗父引用；找到的子节点仍带引用，由原有 `of_node_put(enp)` 释放。新节点创建后的 `of_node_put(np)` 保持不变，其对应创建引用及 changeset 引用不应混淆。

仅 1 行增加、1 行删除。原 `0001`～`0022`、四份通用修复、`raphael.config`、`builddeb.patch`、构建脚本和已发布包均保持不变。错误的查找在固定 `ab4ce59` 已经存在，并非电源策略修正新引入；之前迁移审查未发现这一点，本次热替换测试暴露了它。

这不是 Android 下游协议差异。正确依据是固定 Linux OF API 与官方文档，不为每个补丁硬编 Android 依据。参考：

- 固定 `drivers/of/base.c:882-891,1023-1047`，`drivers/of/kobj.c:safe_name()`。
- 固定 `core.c:294-324,327-366,531-564`。
- `https://www.kernel.org/doc/html/v6.16/devicetree/kernel-api.html` 中两个查找 API 的引用规则。

## 4. 本轮验证及限制

`tests/venus/test-of-node-refs.sh` 从固定 Git blob 直接提取 `venus_add_video_core()`、真实 OF 名字匹配/查找/遍历函数及宏。仅 kobject 引用计数、changeset、锁及日志使用主机 stub。

两项原版负对照：

1. 查询一次后借用父节点 refcount 从模型值 8 降为 7（期望保持 8）。
2. 其他设备中的 `video-decoder` 错误阻止当前 Venus 子节点创建。

修补版两项均通过，完整用例 339 项断言通过，覆盖直接子节点、unit-address 名称、嵌套/其他设备同名节点、缺失节点、NULL 名称、分配失败、属性添加失败，以及模型中的反复 apply/revert/销毁。模型值 8 并非手机实测值。该测试不执行真正的内核 kobject/sysfs/genpd 退出，不验证实际竞态或硬件。

使用原发布内核的 headers、generated 配置和 Module.symvers，在 AMD64/Clang22 上集中编译 Venus core/decoder/encoder AArch64 模块通过；这是局部编译，不是重新执行 bindeb-pkg。没有向手机发送模块，没有创建可下载热替换包。checkpatch 为 0 errors / 0 warnings / 0 checks。

## 5. 实机与后续验证边界

旧热替换入口继续强制退出，旧测试包不能重复运行；已经损坏的设备树引用不能通过加载修补模块原地恢复。用户已保存日志、样片及第一帧；若仍停留在异常启动中，先正常重启，已重启则无需重复。

将来需在干净启动上验证：父节点及其 sysfs 链接在 probe/退出生命周期保持有效、无 refcount/kernfs Oops；保留两个节点后分别完成连续 H.264 解码、内容对照及 H.264 编码。生命周期测试应放在可恢复的受控环境，不继续在已经出现 Oops 的桌面系统反复热插拔。

本轮不绕过 refcount/kernfs 警告，不修改 pinctrl、DMA 或 genpd 来掩盖症状，不延长固件 timeout，不启动全量内核构建，不发布新 Pre-release，不操作手机。
