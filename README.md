# Raphael Venus 测试内核云编译

这个仓库只做一件事：编译包含 SM8150 Venus 适配及运行修正的
Redmi K20 Pro（Raphael）Linux 测试内核。

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
- `build-info.txt`：内核版本及源码提交。
- `SHA256SUMS`：文件完整性校验值。

构建过程不会创建 Release，也不会修改内核源码仓库。
