# SM8150 / Raphael Venus test4

状态：代码与宿主机控制流测试完成；完整 arm64 编译、手机硬解/硬编及
反复休眠/唤醒仍需验证。不能把“出现 /dev/videoX”作为硬件解码成功。
本补丁不修改 Adreno 640 GPU、面板亮度、显示时钟或启动分区布局。

## 依据

原厂优先：MiCode `cepheus-q-oss`，读取时分支提交为
`192eca8550f95c2eec58a474793d1d93fc1b3b67`。
本次读取指定仓库的源码，没有搜索所谓“现成 Venus 适配”。

- [原厂 venus_hfi.c](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/drivers/media/platform/msm/vidc/venus_hfi.c)：`__venus_power_on`、`__prepare_enable_clks`、`__scale_clocks`、`__suspend`、`__power_collapse`、`venus_hfi_core_init`、`venus_hfi_session_init`。
- [原厂 SM8150 视频设备树](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/arch/arm64/boot/dts/qcom/sm8150-vidc.dtsi)：三个供电域、六个视频时钟、复位、地址空间。
- [原厂 SM8150 主设备树](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/arch/arm64/boot/dts/qcom/sm8150.dtsi)：MVS0/MVS1 的 `qcom,support-hw-trigger` 在这里补上，不能只看 `sm8150-gdsc.dtsi` 就判断为不支持。
- [原厂 SM8150 v2 覆盖](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/arch/arm64/boot/dts/qcom/sm8150-v2.dtsi)：240/338/365/444/533 MHz 和 SMMU SID 覆盖。
- [原厂资源解析](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/drivers/media/platform/msm/vidc/msm_vidc_res_parse.c)：频率表降序排列，硬件电源塌缩标志来自供电节点。
- [原厂平台数据](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/blob/192eca8550f95c2eec58a474793d1d93fc1b3b67/drivers/media/platform/msm/vidc/msm_vidc_platform.c)：SM8150 1500 ms 延迟、3916800 最大负载、编解码频率系数。

用户另提供的 [postmarketOS v7.0.0-sm8150](https://gitlab.postmarketos.org/soc/qualcomm-sm8150/linux/-/tree/v7.0.0-sm8150/drivers/media/platform/qcom/venus)
已通过 Git 读取，提交为 `8e126dbc4044ef2cec3ebe5754ddb05faa554af6`。
此标签的 Venus 匹配表没有 `qcom,sm8150-venus`，`sm8150.dtsi` 没有
Venus 节点，`pm_helpers.c` / `hfi_venus.c` 没有 IRIS1 专用路径。
`videocc-sm8150.c` 与本地基线的 Git blob 完全相同
（`3024f6fc89c8b374f2ef13debc283998cb136f6b`）。
因此它可用于 Linux API 交叉核对，不能作为 SM8150 Venus 已可用的证据。

## 为什么修改

test3 真机已经收到 `14:VIDEO.IR.1.2-00045-PROD-1`，因此不能把问题
简单归结为固件文件不存在。但后续 SESSION_INIT 超时，命令队列
`rd=18, wr=29`，表示新命令没有被消费。时钟快照中 MVSC 为 19.2 MHz，
MVS0/MVS1 和对应 AXI 时钟未开启。它们指向启动阶段资源准备的缺口，
尚不足以单独证明全部根因。

| 项目 | 原厂依据及本轮处理 |
| --- | --- |
| 上电 | 独立 IRIS1 PM 路径；MVSC、MVS0、MVS1/CVP 全部在固件启动和 SESSION_INIT 前上电，父设备持有引用。 |
| 复位 | 保留基线已有的四路同时 assert、150–250 µs、逐路 deassert；测试覆盖各失败位置与重试。不使用其他 VPU 的 wrapper 电源寄存器。 |
| 性能投票 | 通过 OPP 同时设置视频时钟与 MMCX，不仅修改裸时钟。原厂降序频率表第一个条目用于初始启动；本机 v2 为 533 MHz。后续保留主线负载调频，恢复时使用上次频率。不是把 GPU 调到这个频率。 |
| 时钟 | 启动前开启 MVSC、MVS0、CVP 和 AXIC/AXI0/AXI1。Linux 的 iface 引用也保留：原厂 PIL 固件加载侧另有 AHB 引用，不能机械删除。 |
| 硬件控制 | 时钟准备完成后把 MVS0/MVS1 交给 GDSC 硬件模式；下电前收回控制权。收回失败时保留电源/时钟并报错，不强行断电。 |
| 视频核心 | `vcodec_num=1`，编码和解码使用 MVS0，MVS1 按原厂 CVP 资源处理。保留 v4 负载准入和编码低功耗选择，不进行 SDM845 式双视频核心分配。 |
| HFI 系统属性 | 与原厂顺序一致，SYS_INIT 不提前发送电源控制属性；在会话默认属性中发送，然后 SESSION_INIT。 |
| 休眠 | 检查 WFI/IDLE，发送 PC_PREP，确认 PC_READY 后才 SCM suspend。未发 PC_PREP 前的非空闲返回 EAGAIN，不让暂时忙永久锁死 runtime PM。PC_PREP 后超时仍报错，不伪装成功。 |
| 下电/恢复 | 不执行原厂 SM8150 未使用的通用 v4 AXI HALT 操作；资源关闭前同步 IRQ，恢复后平衡自己的 IRQ 禁用引用；休眠回退会恢复固件而非只恢复时钟。 |
| 失败释放 | 记录实际持有的域、时钟和硬件控制权。probe/resume 失败和 remove 均有释放入口；即使回退再次失败，也保留必要资源/互联访问并报错。硬件 API 的持续失败不能保证自动恢复。 |
| 固件版本 | 支持 VIDEO.IR，固定宽度字段先复制并终止字符串，三个数字完整解析后才更新版本。保留旧格式兼容。 |
| 异常诊断 | 保留队列快照并增加最多三个待处理 debug 包的只读窥视；校验环形队列边界，不改读写指针，也不在掉电错误路径新增寄存器读取。 |
| 其他资源 | 保留已符合原厂 v2 的频率表、复位、CPU/中断偏移、SMMU SID 与非安全地址范围；最大负载恢复为原厂的 3916800。 |

## 明确的范围与剩余验证

这不是将整个 Android msm_vidc 子系统移植到 Debian：CVP/CDSP 用户接口、
Android 安全视频用户态、厂商 LLCC/DCVS 策略不在现有 Linux V4L2
解码/编码接口范围内。MVS1 的启动资源仍按原厂准备，不能因此声称支持 CVP。
能力表和带宽投票仍使用现有 HFI v4 框架；支持的编解码位图与固件返回值取交集。
没有依据擅自扩大发布 8K、高帧率或所有编码格式的可用性。

宿主机测试直接提取修改后的驱动函数，以模拟 API 检查 C 控制流程：

- 25 个上电、6 个下电、28 个 runtime resume、9 个 runtime suspend
  API 调用位置的单次故障；上电/回退双重故障和恢复/回退双重故障。
- 引用和 IRQ 配平、重复调用、两会话资源共享、OPP 保留及失败后重试。
- 固件版本旧/新格式、截断/不完整字段、无 NUL 的 128 字节字段。
- debug 环回绕、非法长度/下标、三条日志限额、不修改读写指针。

模拟测试不覆盖硬件寄存器效果、真实 genpd/OPP 后端错误状态、并发压力、
实际固件协议兼容性，也不代替完整内核编译。CI 会先跑测试，再编译整个
arm64 内核；本次本地检查不能提前声称 CI 已通过。

真机验收按次序进行，每一步拿到结果再继续：

1. 核对 test4 包信息和散列、/boot 空间、既有原系统备份；暂不删除已用的 test3。
2. 启动版本为 test4，设备绑定成功；日志中确认 IRIS1 资源准备与固件版本，
   没有新增 IOMMU fault、固件崩溃或 runtime PM error。
3. 已有 320×240 / 30 fps / 3 秒 H.264 样例强制 `h264_v4l2m2m`
   解码完成 90 帧，而非仅成功打开节点。
4. 重复解码并跨过自动休眠间隔，验证冷启动与恢复；比较软/硬解输出、
   检查画面及退出后的 PM 状态。
5. 硬件编码并用软件解码验证输出；随后逐个验证设备宣称支持的格式、
   更高分辨率和并发会话。未测项目仍标为未测。

保持当前原厂启动链，不因 Venus 测试额外刷 cache 镜像。具体手机命令
继续在对话中一步一步提供，不把整套升级动作自动执行。
