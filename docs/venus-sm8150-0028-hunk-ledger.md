# 0028 的 57 个 hunk：SM8150 稳定诊断前缀

> 补丁：`patches/0028-media-venus-normalize-SM8150-diagnostics.patch`
> SHA256：`5f9486d0d2f4cd5439a91f9999aed4bf7fdcd4b2b4ca19bc4e97af77f8665d3d`
> Commit：`77121d1fe823d7441b793b2a642a3c3d6129ba68`
> Tree：`15524a19bb2bf46dfb6478646576e9f93c262909`
> 统计：8 文件、57 个 hunk、+62/-62。

## 唯一行为

本补丁只替换日志字符串，不改变条件、控制流、数据、HFI packet、DMA、PM、codec
能力或编译配置。历史的：

- `venus-test7:`、`venus-test8:`、`venus-test9:`；
- `venus-test10:` 至 `venus-test15:`；
- `venus-migrate:`；

全部统一为 `venus-sm8150:`。涉及的 8 个文件是：

| 文件 | 诊断域 |
|---|---|
| `hfi.c` | session init/property |
| `hfi_msgs.c` | firmware version |
| `hfi_venus.c` | packet、queue、firmware debug、resume/suspend、LLCC |
| `helpers.c` | internal buffers、ETB/FTB、requirements、route/mode、LOAD/START |
| `pm_helpers.c` | syscache、resource-ready、first-input vote |
| `vdec.c` | format、REQBUFS、source-change、first capture |
| `venc.c` | encoder controls、sizes、DMA、gate、PM |
| `venc_ctrls.c` | control-default validation |

保留这些字段诊断是有意的：Test16 若在首帧或 reconfigure 处失败，需要从持久
`dmesg` 判断最后成功的 HFI/DMA/PM 边界。最终准入后可以把高频 `dev_info` 单独降为
`dev_dbg`，但不能在首个完整功能构建里同时消除证据。

## 验证

- Venus 源码中不再含 `venus-test[0-9]+` 或 `venus-migrate`。
- `test-iris1.py` 全部通过；`venus-test-suite.sh` 通过 `bash -n`、`--self-test` 和
  `--plan`。
- `checkpatch.pl --strict --no-tree`：0 errors、0 warnings、0 checks。
- 0001--0028 从固定基线在独立 index 顺序应用，共 28 个 patch，最终 tree
  `15524a19bb2bf46dfb6478646576e9f93c262909`；候选 Venus 目录与该 tree 一致。
