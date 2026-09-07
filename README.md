# Raphael Venus 测试内核云编译

这个仓库只做一件事：编译包含 SM8150 Venus 适配及运行修正的
Redmi K20 Pro（Raphael）Linux 测试内核。

当前版本是 **test3 诊断版**，不是已验证可用的修复版。保留 test2 的运行
逻辑，增加 SM8150/IRIS1 会话初始化、属性查询、缓冲区申请及电源错误的
定位日志，并输出通信队列快照、原始固件版本和限流的固件调试消息。
日志前缀为 `venus-test3:`，无需动态调试或 tracefs。

源码仍来自 `snowf14k3/linux` 的 `raphael-7.1` 分支，构建时会应用本仓库
`patches/0001-media-venus-fix-sm8150-runtime-data.patch`。
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
- `build-info.txt`：内核版本、源码提交、构建仓库提交及补丁 SHA256。
- `SHA256SUMS`：文件完整性校验值。

构建过程不会创建 Release，也不会修改内核源码仓库。
