# 0029：buffer-requirement getter 的 const 编译契约

> 补丁：`patches/0029-media-venus-make-buffer-requirement-getters-const.patch`
> SHA256：`2c41de5f3bc8d563c6f8e60a64c59bb9875dfc354aec08556308298968ec7346`
> Commit：`90fdd58f0f51569a8fb7a8f29719ea1c422088dc`
> Tree：`d9941d094f9b306f4cfe5d65f4a69c7076d5d414`

## 触发证据

Test16 首次 ARM64 Clang 构建在 `venc_iris1_validate_external_req()` 失败：该函数正确地
接收 `const struct hfi_buffer_requirements *`，但三个只读 getter 仍要求可写指针；Clang
在内核 `-Werror` 下把丢弃限定符判为错误。

## 修改

仅给以下 getter 的 `req` 参数增加 `const`：

- `hfi_bufreq_get_hold_count()`；
- `hfi_bufreq_get_count_min()`；
- `hfi_bufreq_get_count_min_host()`。

三个函数只读取字段，没有写入、封包、DMA、PM 或生命周期变化。所有现有可写指针调用
仍可隐式转换为只读指针。本补丁因此是编译契约修复，不是新的硬件行为实验。

## 验证要求

- 0029 必须在 0028 后严格应用；
- Clang 对 `venc.c` 不再报告 `discards qualifiers`；
- 完整 ARM64 `bindeb-pkg` 必须通过；
- 原有宿主协议、格式、DMA、PM 与面板检查必须全部保持通过。
