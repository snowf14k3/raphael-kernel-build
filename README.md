# Raphael Venus 测试内核云编译

这个仓库只做一件事：编译包含 SM8150 Venus 适配及运行修正的
Redmi K20 Pro（Raphael）Linux 测试内核。

当前版本是 **test6 VPU5 会话修正版，待实机验证**。以小米 Android 10
SM8150 实现为依据，补齐固件启动前的电源域、时钟与 MMCX 性能投票、
MVS0/CVP 控制权切换及失败回退，修正休眠/恢复和固件版本解析。
编码、解码都使用 MVS0；不把 CVP 当作第二个视频核心。
在此基础上增加 HFI 队列校验、通信/电源诊断和一次运行的实机测试脚本。
关键新增日志前缀为 `venus-test6:`；预留 dynamic debug / ftrace，默认不开启跟踪。

构建前会编译并运行实际补丁函数的宿主机故障注入和边界测试，再进行
完整 arm64 内核编译。自动检查不代表实机硬件编解码已经通过。
本轮修正范围见 [test6 说明](docs/venus-test6.md)；原厂、postmarketOS
对照依据保留在 [test4 说明](docs/venus-test4.md)。

源码仍来自 `snowf14k3/linux` 的 `raphael-7.1` 分支，构建时会应用本仓库
`patches/series` 中的四个补丁（原厂时序、队列校验、诊断、VPU5 会话配置）。
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
- `patches.sha256`：四个补丁各自的 SHA256。
- `venus-test-suite.sh`：安装并启动 test6 后，一次运行的实机测试脚本。
- `TESTING.md`：测试范围、运行方式、限制与日志说明。
- `SHA256SUMS`：文件完整性校验值。

构建过程不会创建 Release，也不会修改内核源码仓库。
