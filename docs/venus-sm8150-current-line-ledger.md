# 当前 Venus 22,143 行反向逐行迁移台账

> 当前树：`F:\linux\test15-analysis\drivers\media\platform\qcom\venus`，由固定基线
> `58f3df07833f2382fe2fbc28f996c4c85817c1f6` 应用 `patches/series` 19 个补丁得到。
> 本台账覆盖当前 Venus 36 个文件的每一个物理行；按函数/宏/类型/全局变量、控制流
> 锚点及最多 25 行连续区间分割。它回答“当前每段代码在原厂哪里、保留还是欠迁”，
> 与原厂 39,111 行台账、Test15 173-hunk 台账、0018 35-hunk、0019 11-hunk 台账和
> `venus-sm8150-migration-status.md` 合用。

“原厂同名 token”只表示标识符机械命中；两套驱动命名/架构不同，未命中不自动等于
缺功能，命中也不证明语义相同。最终结论由本列策略和总报告给出。
覆盖汇总：36/36 文件，22143/22143 行，524/524 个 C 函数定义，3079 个连续审阅区间。


## `core.c`

- 当前物理行：1252；原厂语义域：`msm_vidc_platform.c + msm_vidc_res_parse.c + venus_hfi.c`；默认判定：**部分迁移**。
- 文件级结论：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--25 | `chunk:1, file:start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 26--30 | `chunk:26` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 31--50 | `f:venus_coredump` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 51--57 | `chunk:51` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 58--62 | `f:venus_event_notify` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 63--63 | `switch:case EVT_SYS_WATCHDOG_TIMEOUT` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 64--65 | `switch:case EVT_SYS_ERROR` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 66--75 | `switch:default` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 76--80 | `chunk:76` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 81--81 | `v:venus_core_ops` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 82--84 | `field:event_notify` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 85--86 | `d:RPM_WAIT_FOR_IDLE_MAX_ATTEMPTS` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 87--100 | `f:venus_sys_error_handler` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 101--125 | `chunk:101` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 126--150 | `chunk:126` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 151--175 | `chunk:151` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 176--177 | `chunk:176` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 178--180 | `f:to_v4l2_codec_type` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 181--182 | `switch:case HFI_VIDEO_CODEC_H264` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 183--184 | `switch:case HFI_VIDEO_CODEC_H263` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 185--186 | `switch:case HFI_VIDEO_CODEC_MPEG1` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 187--188 | `switch:case HFI_VIDEO_CODEC_MPEG2` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 189--190 | `switch:case HFI_VIDEO_CODEC_MPEG4` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 191--192 | `switch:case HFI_VIDEO_CODEC_VC1` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 193--194 | `switch:case HFI_VIDEO_CODEC_VP8` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 195--196 | `switch:case HFI_VIDEO_CODEC_VP9` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 197--197 | `switch:case HFI_VIDEO_CODEC_DIVX` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 198--199 | `switch:case HFI_VIDEO_CODEC_DIVX_311` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 200--200 | `switch:default` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 201--204 | `chunk:201` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 205--225 | `f:venus_enumerate_codecs` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 226--245 | `chunk:226` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 246--247 | `label:done` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 248--250 | `label:err` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 251--254 | `chunk:251` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 255--275 | `f:venus_assign_register_offsets` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 276--280 | `chunk:276` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 281--293 | `f:venus_isr_thread` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 294--294 | `pp:if` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 295--300 | `f:venus_add_video_core` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 301--325 | `chunk:301` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 326--326 | `chunk:326` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 327--350 | `f:venus_add_dynamic_nodes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 351--352 | `chunk:351` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 353--359 | `label:err` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 360--367 | `f:venus_remove_dynamic_nodes` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 368--368 | `pp:else` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 369--373 | `f:venus_add_dynamic_nodes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 374--374 | `f:venus_remove_dynamic_nodes` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 375--375 | `pp:endif` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 376--376 | `chunk:376` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 377--400 | `f:venus_probe` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 401--425 | `chunk:401` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 426--450 | `chunk:426` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 451--475 | `chunk:451` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 476--500 | `chunk:476` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 501--518 | `chunk:501` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 519--520 | `label:err_of_depopulate` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 521--522 | `label:err_remove_dynamic_nodes` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 523--524 | `label:err_core_deinit` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 525--525 | `label:err_venus_shutdown` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 526--526 | `chunk:526` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 527--528 | `label:err_firmware_deinit` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 529--533 | `label:err_runtime_disable` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 534--535 | `label:err_hfi_destroy` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 536--541 | `label:err_core_put` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 542--550 | `f:venus_remove` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 551--575 | `chunk:551` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 576--577 | `chunk:576` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 578--587 | `f:venus_core_shutdown` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 588--600 | `f:venus_runtime_suspend` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 601--622 | `chunk:601` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 623--624 | `label:err_video_path` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 625--625 | `label:err_cpucfg_path` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 626--642 | `chunk:626` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 643--650 | `f:venus_close_common` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 651--660 | `chunk:651` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 661--662 | `v:venus_close_common` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 663--675 | `f:venus_runtime_resume` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 676--699 | `chunk:676` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 700--700 | `label:err_cpucfg_path` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 701--704 | `chunk:701` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 705--710 | `label:err_video_path` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 711--716 | `v:venus_pm_ops` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 717--722 | `v:msm8916_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 723--725 | `v:msm8916_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 726--728 | `chunk:726` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 729--729 | `v:msm8916_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 730--730 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 731--731 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 732--732 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 733--733 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 734--734 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 735--735 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 736--736 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 737--737 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 738--738 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 739--739 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 740--740 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 741--741 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 742--742 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 743--743 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 744--746 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 747--750 | `v:msm8996_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 751--754 | `chunk:751` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 755--760 | `v:msm8996_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 761--761 | `v:msm8996_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 762--762 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 763--763 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 764--764 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 765--765 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 766--766 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 767--767 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 768--768 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 769--769 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 770--770 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 771--771 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 772--772 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 773--773 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 774--774 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 775--775 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 776--776 | `chunk:776, field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 777--779 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 780--787 | `v:msm8998_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 788--798 | `v:msm8998_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 799--799 | `v:msm8998_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 800--800 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 801--801 | `chunk:801, field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 802--802 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 803--803 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 804--804 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 805--805 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 806--806 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 807--807 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 808--808 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 809--809 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 810--810 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 811--811 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 812--812 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 813--813 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 814--814 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 815--817 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 818--825 | `v:sdm660_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 826--826 | `chunk:826` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 827--832 | `v:sdm660_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 833--842 | `v:sdm660_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 843--850 | `v:sdm660_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 851--852 | `chunk:851` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 853--853 | `v:sdm660_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 854--854 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 855--855 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 856--856 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 857--857 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 858--858 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 859--859 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 860--860 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 861--861 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 862--862 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 863--863 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 864--864 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 865--865 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 866--866 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 867--867 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 868--868 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 869--869 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 870--870 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 871--871 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 872--872 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 873--873 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 874--874 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 875--875 | `field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 876--876 | `chunk:876, field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 877--877 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 878--880 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 881--889 | `v:sdm845_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 890--896 | `v:sdm845_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 897--900 | `v:sdm845_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 901--903 | `chunk:901` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 904--904 | `v:sdm845_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 905--905 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 906--906 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 907--907 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 908--908 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 909--909 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 910--910 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 911--911 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 912--912 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 913--913 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 914--914 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 915--915 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 916--916 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 917--917 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 918--918 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 919--919 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 920--920 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 921--921 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 922--922 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 923--925 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 926--926 | `chunk:926, v:sdm845_res_v2` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 927--927 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 928--928 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 929--929 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 930--930 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 931--931 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 932--932 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 933--933 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 934--934 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 935--935 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 936--936 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 937--937 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 938--938 | `field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 939--939 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 940--940 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 941--941 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 942--942 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 943--943 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 944--944 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 945--945 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 946--946 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 947--947 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 948--948 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 949--949 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 950--950 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 951--951 | `chunk:951, field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 952--952 | `field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 953--953 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 954--954 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 955--957 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 958--965 | `v:sm8150_freq_table` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 966--966 | `v:sm8150_res` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 967--967 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 968--968 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 969--969 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 970--970 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 971--971 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 972--972 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 973--973 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 974--974 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 975--975 | `field:resets` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 976--976 | `chunk:976, field:resets_num` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 977--977 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 978--978 | `field:vcodec1_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 979--979 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 980--980 | `field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 981--981 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 982--983 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 984--984 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 985--985 | `field:num_vpp_pipes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 986--986 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 987--987 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 988--988 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 989--989 | `field:autosuspend_delay_ms` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 990--990 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 991--991 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 992--992 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 993--993 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 994--994 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 995--995 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 996--996 | `field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 997--997 | `field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 998--998 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 999--999 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1000--1000 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1001--1002 | `chunk:1001` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1003--1010 | `v:sc7180_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1011--1016 | `v:sc7180_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1017--1022 | `v:sc7180_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1023--1023 | `v:sc7180_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1024--1024 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1025--1025 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1026--1026 | `chunk:1026, field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1027--1027 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1028--1028 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1029--1029 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1030--1030 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1031--1031 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1032--1032 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1033--1033 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1034--1034 | `field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1035--1035 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1036--1036 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1037--1037 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1038--1038 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1039--1039 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1040--1040 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1041--1041 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1042--1042 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1043--1043 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1044--1044 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1045--1045 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1046--1046 | `field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1047--1047 | `field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1048--1048 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1049--1049 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1050--1050 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1051--1052 | `chunk:1051` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1053--1059 | `v:sm8250_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1060--1066 | `v:sm8250_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1067--1073 | `v:sm8250_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1074--1075 | `v:sm8250_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 1076--1077 | `chunk:1076` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1078--1078 | `v:sm8250_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1079--1079 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1080--1080 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1081--1081 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1082--1082 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1083--1083 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1084--1084 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1085--1085 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1086--1086 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1087--1087 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1088--1088 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1089--1089 | `field:resets` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 1090--1090 | `field:resets_num` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 1091--1091 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1092--1092 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1093--1093 | `field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1094--1094 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1095--1095 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1096--1096 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1097--1097 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1098--1098 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1099--1099 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1100--1100 | `field:num_vpp_pipes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1101--1101 | `chunk:1101, field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1102--1102 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1103--1103 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1104--1104 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1105--1105 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1106--1106 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1107--1109 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1110--1117 | `v:sc7280_freq_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1118--1124 | `v:sc7280_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1125--1125 | `v:sc7280_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1126--1131 | `chunk:1126` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1132--1135 | `v:sm7280_reg_preset` | `—` | SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。 |
| 1136--1139 | `v:sc7280_ubwc_config` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1140--1140 | `v:sc7280_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1141--1141 | `field:freq_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1142--1142 | `field:freq_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1143--1143 | `field:reg_tbl` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1144--1144 | `field:reg_tbl_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1145--1145 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1146--1146 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1147--1147 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1148--1148 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1149--1149 | `field:ubwc_conf` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1150--1150 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1151--1151 | `chunk:1151, field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1152--1152 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1153--1153 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1154--1154 | `field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1155--1155 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1156--1156 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1157--1157 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1158--1158 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1159--1159 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1160--1160 | `field:num_vpp_pipes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1161--1161 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1162--1162 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1163--1163 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1164--1164 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1165--1165 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1166--1166 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1167--1167 | `field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1168--1168 | `field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1169--1169 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1170--1170 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1171--1173 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1174--1175 | `v:qcm2290_bw_table_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1176--1180 | `chunk:1176` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1181--1187 | `v:qcm2290_bw_table_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1188--1188 | `v:min_fw` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1189--1191 | `field:major` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1192--1192 | `v:qcm2290_res` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1193--1193 | `field:bw_tbl_dec` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1194--1194 | `field:bw_tbl_dec_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1195--1195 | `field:bw_tbl_enc` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1196--1196 | `field:bw_tbl_enc_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1197--1197 | `field:clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1198--1198 | `field:clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1199--1199 | `field:vcodec0_clks` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1200--1200 | `field:vcodec_clks_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1201--1201 | `chunk:1201, field:vcodec_pmdomains` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1202--1202 | `field:vcodec_pmdomains_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1203--1203 | `field:opp_pmdomain` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1204--1204 | `field:vcodec_num` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1205--1205 | `field:hfi_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1206--1206 | `field:vpu_version` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1207--1207 | `field:max_load` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1208--1208 | `field:num_vpp_pipes` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1209--1209 | `field:vmem_id` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1210--1210 | `field:vmem_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1211--1211 | `field:vmem_addr` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1212--1212 | `field:cp_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1213--1213 | `field:cp_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1214--1214 | `field:cp_nonpixel_start` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1215--1215 | `field:cp_nonpixel_size` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1216--1216 | `field:dma_mask` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1217--1217 | `field:fwname` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1218--1218 | `field:dec_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1219--1219 | `field:enc_nodename` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1220--1222 | `field:min_fw` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1223--1225 | `v:venus_dt_match` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1226--1238 | `chunk:1226` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1239--1239 | `v:qcom_venus_driver` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1240--1240 | `field:probe` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 1241--1241 | `field:remove` | `—` | 设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。 |
| 1242--1242 | `field:driver` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1243--1243 | `field:name` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1244--1244 | `field:of_match_table` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1245--1246 | `field:pm` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1247--1248 | `field:shutdown` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1249--1250 | `v:qcom_venus_driver` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |
| 1251--1252 | `chunk:1251` | `—` | 部分迁移：SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。 |

覆盖校验：1252/1252 行，连续、无空洞、无重叠。

## `core.h`

- 当前物理行：655；原厂语义域：`msm_vidc_internal.h + msm_vidc_resources.h`；默认判定：**语义拆分**。
- 文件级结论：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--6 | `chunk:1, file:start` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 7--25 | `pp:ifndef` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 276--300 | `chunk:276` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 301--325 | `chunk:301` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 326--350 | `chunk:326` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 351--375 | `chunk:351` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 376--400 | `chunk:376` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 401--425 | `chunk:401` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 426--450 | `chunk:426` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 451--475 | `chunk:451` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 476--500 | `chunk:476` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 501--525 | `chunk:501` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 526--550 | `chunk:526` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 551--575 | `chunk:551` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 576--600 | `chunk:576` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 601--625 | `chunk:601` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 626--650 | `chunk:626` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 651--654 | `chunk:651` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |
| 655--655 | `pp:endif` | `—` | 语义拆分：按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。 |

覆盖校验：655/655 行，连续、无空洞、无重叠。

## `dbgfs.c`

- 当前物理行：28；原厂语义域：`msm_vidc_debug.c`；默认判定：**主线替代**。
- 文件级结论：只保留低噪声诊断；vendor 私有 debug ABI 不迁。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--10 | `chunk:1, file:start` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 11--11 | `pp:ifdef` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 12--12 | `v:venus_ssr_attr` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 13--14 | `pp:endif` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 15--19 | `f:venus_dbgfs_init` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 20--21 | `pp:ifdef` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 22--24 | `pp:endif` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 25--25 | `f:venus_dbgfs_deinit` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |
| 26--28 | `chunk:26` | `—` | 主线替代：只保留低噪声诊断；vendor 私有 debug ABI 不迁。 |

覆盖校验：28/28 行，连续、无空洞、无重叠。

## `dbgfs.h`

- 当前物理行：25；原厂语义域：`msm_vidc_debug.h`；默认判定：**主线替代**。
- 文件级结论：标准 debugfs/dev_dbg 接口。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--3 | `chunk:1, file:start` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |
| 4--10 | `pp:ifndef` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |
| 11--16 | `pp:ifdef` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |
| 17--18 | `pp:else` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |
| 19--24 | `pp:endif` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |
| 25--25 | `pp:endif` | `—` | 主线替代：标准 debugfs/dev_dbg 接口。 |

覆盖校验：25/25 行，连续、无空洞、无重叠。

## `firmware.c`

- 当前物理行：384；原厂语义域：`venus_boot.c + venus_hfi.c`；默认判定：**主线替代**。
- 文件级结论：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--22 | `chunk:1, file:start` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 23--23 | `d:VENUS_PAS_ID` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 24--24 | `d:VENUS_FW_MEM_SIZE` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 25--25 | `d:VENUS_FW_START_ADDR` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 26--26 | `chunk:26` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 27--50 | `f:venus_reset_cpu` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 51--55 | `chunk:51` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 56--75 | `f:venus_set_hw_state` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 76--80 | `chunk:76` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 81--100 | `f:venus_load_fw` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 101--125 | `chunk:101` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 126--133 | `chunk:126` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 134--138 | `label:err_release_fw` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 139--150 | `f:venus_boot_no_tz` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 151--164 | `chunk:151` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 165--175 | `f:venus_shutdown_no_tz` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 176--200 | `chunk:176` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 201--210 | `chunk:201, f:venus_firmware_cfg` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 211--225 | `f:venus_boot` | `venus_boot` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 226--250 | `chunk:226` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 251--271 | `chunk:251` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 272--275 | `f:venus_shutdown` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 276--283 | `chunk:276` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 284--295 | `f:venus_firmware_check` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 296--300 | `label:error` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 301--303 | `chunk:301` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 304--325 | `f:venus_firmware_init` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 326--350 | `chunk:326` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 351--358 | `chunk:351` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 359--360 | `label:err_iommu_free` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 361--366 | `label:err_unregister` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 367--375 | `f:venus_firmware_deinit` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |
| 376--384 | `chunk:376` | `—` | 主线替代：firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。 |

覆盖校验：384/384 行，连续、无空洞、无重叠。

## `firmware.h`

- 当前物理行：28；原厂语义域：`venus_boot.h`；默认判定：**主线替代**。
- 文件级结论：固件接口按主线抽象。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--4 | `chunk:1, file:start` | `—` | 主线替代：固件接口按主线抽象。 |
| 5--25 | `pp:ifndef` | `—` | 主线替代：固件接口按主线抽象。 |
| 26--27 | `chunk:26` | `—` | 主线替代：固件接口按主线抽象。 |
| 28--28 | `pp:endif` | `—` | 主线替代：固件接口按主线抽象。 |

覆盖校验：28/28 行，连续、无空洞、无重叠。

## `helpers.c`

- 当前物理行：2274；原厂语义域：`msm_vidc_common.c + hfi_packetization.c + msm_smem.c`；默认判定：**部分迁移**。
- 文件级结论：会话、内部 buffer、队列和 HFI 属性的核心对照面。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--22 | `chunk:1, file:start` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 23--23 | `d:NUM_MBS_720P` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 24--24 | `d:NUM_MBS_4K` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 25--25 | `d:CBR_MBS_720P_30` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 26--26 | `chunk:26` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 27--31 | `g:dpb_buf_owner` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 32--42 | `s:intbuf` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 43--45 | `f:venus_helper_get_codec` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 46--46 | `switch:case V4L2_PIX_FMT_H264` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 47--48 | `switch:case V4L2_PIX_FMT_H264_NO_SC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 49--50 | `switch:case V4L2_PIX_FMT_H263` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 51--52 | `chunk:51, switch:case V4L2_PIX_FMT_MPEG1` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 53--54 | `switch:case V4L2_PIX_FMT_MPEG2` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 55--56 | `switch:case V4L2_PIX_FMT_MPEG4` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 57--57 | `switch:case V4L2_PIX_FMT_VC1_ANNEX_G` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 58--59 | `switch:case V4L2_PIX_FMT_VC1_ANNEX_L` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 60--61 | `switch:case V4L2_PIX_FMT_VP8` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 62--63 | `switch:case V4L2_PIX_FMT_VP9` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 64--65 | `switch:case V4L2_PIX_FMT_XVID` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 66--67 | `switch:case V4L2_PIX_FMT_HEVC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 68--71 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 72--73 | `v:venus_helper_get_codec` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 74--75 | `f:venus_helper_check_codec` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 76--90 | `chunk:76` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 91--92 | `v:venus_helper_check_codec` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 93--100 | `f:free_dpb_buf` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 101--102 | `chunk:101` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 103--125 | `f:venus_helper_queue_dpb_bufs` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 126--139 | `chunk:126` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 140--142 | `label:fail` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 143--144 | `v:venus_helper_queue_dpb_bufs` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 145--150 | `f:venus_helper_free_dpb_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 151--159 | `chunk:151` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 160--161 | `v:venus_helper_free_dpb_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 162--175 | `f:venus_helper_alloc_dpb_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 176--200 | `chunk:176` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 201--225 | `chunk:201` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 226--230 | `chunk:226, label:fail` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 231--232 | `v:venus_helper_alloc_dpb_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 233--250 | `f:intbufs_set_buffer` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 251--275 | `chunk:251` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 276--300 | `chunk:276` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 301--325 | `chunk:301` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 326--331 | `chunk:326` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 332--333 | `label:dma_free` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 334--338 | `label:fail` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 339--350 | `f:intbufs_unset_buffers` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 351--375 | `chunk:351` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 376--383 | `chunk:376, v:intbuf_types_1xx` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 384--391 | `v:intbuf_types_4xx` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 392--399 | `v:intbuf_types_6xx` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 400--400 | `f:venus_helper_intbufs_alloc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 401--425 | `chunk:401` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 426--443 | `chunk:426` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 444--447 | `label:error` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 448--449 | `v:venus_helper_intbufs_alloc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 450--450 | `f:venus_helper_intbufs_free` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 451--453 | `chunk:451` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 454--455 | `v:venus_helper_intbufs_free` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 456--475 | `f:venus_helper_intbufs_realloc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 476--496 | `chunk:476` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 497--499 | `label:err` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 500--500 | `v:venus_helper_intbufs_realloc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 501--501 | `chunk:501` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 502--512 | `f:fill_buffer_desc` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 513--525 | `f:return_buf_error` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 526--526 | `chunk:526` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 527--550 | `f:put_ts_metadata` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 551--554 | `chunk:551` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 555--574 | `f:venus_helper_get_ts_metadata` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 575--575 | `v:venus_helper_get_ts_metadata` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 576--577 | `chunk:576` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 578--600 | `f:session_process_buf` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 601--625 | `chunk:601` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 626--642 | `chunk:626` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 643--650 | `f:is_dynamic_bufmode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 651--661 | `chunk:651` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 662--675 | `f:venus_helper_unregister_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 676--678 | `chunk:676` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 679--680 | `v:venus_helper_unregister_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 681--700 | `f:session_register_bufs` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 701--703 | `chunk:701` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 704--706 | `f:to_hfi_raw_fmt` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 707--708 | `switch:case V4L2_PIX_FMT_NV12` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 709--710 | `switch:case V4L2_PIX_FMT_NV21` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 711--712 | `switch:case V4L2_PIX_FMT_QC08C` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 713--714 | `switch:case V4L2_PIX_FMT_QC10C` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 715--716 | `switch:case V4L2_PIX_FMT_P010` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 717--723 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 724--725 | `f:platform_get_bufreq` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 726--750 | `chunk:726` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 751--771 | `chunk:751` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 772--775 | `f:venus_helper_get_bufreq` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 776--800 | `chunk:776` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 801--817 | `chunk:801` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 818--819 | `v:venus_helper_get_bufreq` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 820--825 | `f:venus_helper_cache_bufreqs` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 826--850 | `chunk:826` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 851--875 | `chunk:851` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 876--893 | `chunk:876` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 894--895 | `v:venus_helper_cache_bufreqs` | `—` | buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。 |
| 896--900 | `s:id_mapping` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 901--905 | `chunk:901, v:mpeg4_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 906--915 | `v:mpeg4_levels` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 916--923 | `v:mpeg2_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 924--925 | `v:mpeg2_levels` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 926--930 | `chunk:926` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 931--940 | `v:h264_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 941--950 | `v:h264_levels` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 951--960 | `chunk:951` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 961--966 | `v:hevc_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 967--975 | `v:hevc_levels` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 976--982 | `chunk:976` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 983--989 | `v:vp8_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 990--994 | `v:vp9_profiles` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 995--1000 | `v:vp9_levels` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1001--1009 | `chunk:1001` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1010--1023 | `f:find_v4l2_id` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1024--1025 | `f:find_hfi_id` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1026--1038 | `chunk:1026` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1039--1044 | `f:v4l2_id_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1045--1048 | `switch:case HFI_VIDEO_CODEC_H264` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1049--1050 | `switch:case HFI_VIDEO_CODEC_MPEG2` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1051--1052 | `chunk:1051` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1053--1056 | `switch:case HFI_VIDEO_CODEC_MPEG4` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1057--1060 | `switch:case HFI_VIDEO_CODEC_VP8` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1061--1064 | `switch:case HFI_VIDEO_CODEC_VP9` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1065--1068 | `switch:case HFI_VIDEO_CODEC_HEVC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1069--1074 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1075--1075 | `f:hfi_id_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1076--1077 | `chunk:1076` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1078--1081 | `switch:case HFI_VIDEO_CODEC_H264` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1082--1085 | `switch:case HFI_VIDEO_CODEC_MPEG2` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1086--1089 | `switch:case HFI_VIDEO_CODEC_MPEG4` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1090--1093 | `switch:case HFI_VIDEO_CODEC_VP8` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1094--1097 | `switch:case HFI_VIDEO_CODEC_VP9` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1098--1100 | `switch:case HFI_VIDEO_CODEC_HEVC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1101--1101 | `chunk:1101` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1102--1106 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1107--1120 | `f:venus_helper_get_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1121--1122 | `v:venus_helper_get_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1123--1125 | `f:venus_helper_set_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1126--1141 | `chunk:1126` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1142--1143 | `v:venus_helper_set_profile_level` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1144--1150 | `f:get_framesize_raw_nv12` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1151--1161 | `chunk:1151` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1162--1175 | `f:get_framesize_raw_nv12_ubwc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1176--1187 | `chunk:1176` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1188--1200 | `f:get_framesize_raw_p010` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1201--1205 | `chunk:1201` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1206--1225 | `f:get_framesize_raw_p010_ubwc` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1226--1233 | `chunk:1226` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1234--1250 | `f:get_framesize_raw_yuv420_tp10_ubwc` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1251--1263 | `chunk:1251` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1264--1266 | `f:venus_helper_get_framesz_raw` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1267--1267 | `switch:case HFI_COLOR_FORMAT_NV12` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1268--1269 | `switch:case HFI_COLOR_FORMAT_NV21` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1270--1271 | `switch:case HFI_COLOR_FORMAT_NV12_UBWC` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1272--1273 | `switch:case HFI_COLOR_FORMAT_P010` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1274--1275 | `switch:case HFI_COLOR_FORMAT_P010_UBWC` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1276--1277 | `chunk:1276, switch:case HFI_COLOR_FORMAT_YUV420_TP10_UBWC` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1278--1281 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1282--1283 | `v:venus_helper_get_framesz_raw` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1284--1289 | `f:venus_helper_get_framesz` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1290--1290 | `switch:case V4L2_PIX_FMT_MPEG` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1291--1291 | `switch:case V4L2_PIX_FMT_H264` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1292--1292 | `switch:case V4L2_PIX_FMT_H264_NO_SC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1293--1293 | `switch:case V4L2_PIX_FMT_H264_MVC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1294--1294 | `switch:case V4L2_PIX_FMT_H263` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1295--1295 | `switch:case V4L2_PIX_FMT_MPEG1` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1296--1296 | `switch:case V4L2_PIX_FMT_MPEG2` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1297--1297 | `switch:case V4L2_PIX_FMT_MPEG4` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1298--1298 | `switch:case V4L2_PIX_FMT_XVID` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1299--1299 | `switch:case V4L2_PIX_FMT_VC1_ANNEX_G` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1300--1300 | `switch:case V4L2_PIX_FMT_VC1_ANNEX_L` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1301--1301 | `chunk:1301, switch:case V4L2_PIX_FMT_VP8` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1302--1302 | `switch:case V4L2_PIX_FMT_VP9` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1303--1305 | `switch:case V4L2_PIX_FMT_HEVC` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1306--1323 | `switch:default` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1324--1325 | `v:venus_helper_get_framesz` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1326--1337 | `chunk:1326, f:venus_helper_set_input_resolution` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1338--1339 | `v:venus_helper_set_input_resolution` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1340--1350 | `f:venus_helper_set_output_resolution` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1351--1352 | `chunk:1351` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1353--1354 | `v:venus_helper_set_output_resolution` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1355--1375 | `f:venus_helper_get_work_mode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1376--1387 | `chunk:1376` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1388--1400 | `f:venus_helper_set_work_mode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1401--1419 | `chunk:1401` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1420--1421 | `v:venus_helper_set_work_mode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1422--1425 | `f:venus_helper_set_work_route` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1426--1450 | `chunk:1426` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1451--1469 | `chunk:1451` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1470--1471 | `v:venus_helper_set_work_route` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1472--1475 | `f:venus_helper_set_format_constraints` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1476--1500 | `chunk:1476` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1501--1511 | `chunk:1501` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1512--1513 | `v:venus_helper_set_format_constraints` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1514--1525 | `f:venus_helper_set_num_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1526--1550 | `chunk:1526` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1551--1575 | `chunk:1551` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1576--1577 | `chunk:1576` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1578--1579 | `v:venus_helper_set_num_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1580--1590 | `f:venus_helper_set_raw_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1591--1592 | `v:venus_helper_set_raw_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1593--1600 | `f:venus_helper_set_color_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1601--1609 | `chunk:1601` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1610--1611 | `v:venus_helper_set_color_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 1612--1625 | `f:venus_helper_set_multistream` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1626--1630 | `chunk:1626` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1631--1632 | `v:venus_helper_set_multistream` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1633--1650 | `f:venus_helper_set_dyn_bufmode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1651--1652 | `chunk:1651` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1653--1654 | `v:venus_helper_set_dyn_bufmode` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1655--1664 | `f:venus_helper_set_bufsize` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1665--1666 | `v:venus_helper_set_bufsize` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1667--1675 | `f:venus_helper_get_opb_size` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1676--1679 | `chunk:1676` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1680--1681 | `v:venus_helper_get_opb_size` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1682--1700 | `f:delayed_process_buf_func` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1701--1704 | `chunk:1701` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1705--1708 | `label:unlock` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1709--1720 | `f:venus_helper_release_buf_ref` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1721--1722 | `v:venus_helper_release_buf_ref` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1723--1725 | `f:venus_helper_acquire_buf_ref` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1726--1728 | `chunk:1726` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1729--1730 | `v:venus_helper_acquire_buf_ref` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1731--1744 | `f:is_buf_refed` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1745--1750 | `f:venus_helper_find_buf` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1751--1753 | `chunk:1751` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1754--1755 | `v:venus_helper_find_buf` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1756--1771 | `f:venus_helper_change_dpb_owner` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1772--1773 | `v:venus_helper_change_dpb_owner` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1774--1775 | `f:venus_helper_vb2_buf_init` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1776--1787 | `chunk:1776` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1788--1789 | `v:venus_helper_vb2_buf_init` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1790--1800 | `f:venus_helper_vb2_buf_prepare` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1801--1814 | `chunk:1801` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1815--1816 | `v:venus_helper_vb2_buf_prepare` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1817--1825 | `f:cache_payload` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1826--1850 | `chunk:1826, f:venus_helper_vb2_buf_queue` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1851--1863 | `chunk:1851` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1864--1865 | `v:venus_helper_vb2_buf_queue` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1866--1875 | `f:venus_helper_buffers_done` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1876--1878 | `chunk:1876` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1879--1880 | `v:venus_helper_buffers_done` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1881--1900 | `f:venus_helper_vb2_stop_streaming` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1901--1923 | `chunk:1901` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1924--1925 | `v:venus_helper_vb2_stop_streaming` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1926--1935 | `chunk:1926, f:venus_helper_vb2_queue_error` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1936--1937 | `v:venus_helper_vb2_queue_error` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 1938--1950 | `f:venus_helper_process_initial_cap_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1951--1953 | `chunk:1951` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1954--1955 | `v:venus_helper_process_initial_cap_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1956--1971 | `f:venus_helper_process_initial_out_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1972--1973 | `v:venus_helper_process_initial_out_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 1974--1975 | `f:venus_helper_vb2_start_streaming` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 1976--2000 | `chunk:1976` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2001--2025 | `chunk:2001` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2026--2034 | `chunk:2026` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2035--2044 | `label:err_stop` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 2045--2050 | `label:err_unload_res` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 2051--2054 | `chunk:2051` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2055--2060 | `label:err_unreg_bufs` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2061--2072 | `label:err_bufs_free` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2073--2074 | `v:venus_helper_vb2_start_streaming` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 2075--2075 | `f:venus_helper_m2m_device_run` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 2076--2100 | `chunk:2076` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2101--2105 | `chunk:2101` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2106--2107 | `v:venus_helper_m2m_device_run` | `—` | P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。 |
| 2108--2113 | `f:venus_helper_m2m_job_abort` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2114--2115 | `v:venus_helper_m2m_job_abort` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2116--2125 | `f:venus_helper_session_init` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 2126--2144 | `chunk:2126` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2145--2146 | `v:venus_helper_session_init` | `—` | 状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。 |
| 2147--2150 | `f:venus_helper_init_instance` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2151--2154 | `chunk:2151` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2155--2156 | `v:venus_helper_init_instance` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2157--2169 | `f:find_fmt_from_caps` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2170--2175 | `f:venus_helper_get_out_fmts` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2176--2200 | `chunk:2176` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2201--2225 | `chunk:2201` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2226--2231 | `chunk:2226` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2232--2233 | `v:venus_helper_get_out_fmts` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2234--2250 | `f:venus_helper_check_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 2251--2252 | `chunk:2251` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2253--2255 | `label:done` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2256--2257 | `v:venus_helper_check_format` | `—` | Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。 |
| 2258--2273 | `f:venus_helper_set_stride` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |
| 2274--2274 | `v:venus_helper_set_stride` | `—` | 部分迁移：会话、内部 buffer、队列和 HFI 属性的核心对照面。 |

覆盖校验：2274/2274 行，连续、无空洞、无重叠。

## `helpers.h`

- 当前物理行：77；原厂语义域：`msm_vidc_common.h`；默认判定：**语义拆分**。
- 文件级结论：helper API 按主线实例模型保留。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：helper API 按主线实例模型保留。 |
| 6--25 | `pp:ifndef` | `—` | 语义拆分：helper API 按主线实例模型保留。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：helper API 按主线实例模型保留。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：helper API 按主线实例模型保留。 |
| 76--76 | `chunk:76` | `—` | 语义拆分：helper API 按主线实例模型保留。 |
| 77--77 | `pp:endif` | `—` | 语义拆分：helper API 按主线实例模型保留。 |

覆盖校验：77/77 行，连续、无空洞、无重叠。

## `hfi_cmds.c`

- 当前物理行：1458；原厂语义域：`hfi_packetization.c`；默认判定：**逐包核对**。
- 文件级结论：HFI4 packet ID、payload、长度和发送条件必须精确。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--12 | `chunk:1, file:start` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 13--14 | `v:hfi_ver` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 15--21 | `f:pkt_sys_init` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 22--25 | `f:pkt_sys_pc_prep` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 26--27 | `chunk:26` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 28--38 | `f:pkt_sys_idle_indicator` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 39--50 | `f:pkt_sys_debug_config` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 51--52 | `chunk:51` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 53--61 | `f:pkt_sys_coverage_config` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 62--70 | `f:pkt_sys_ubwc_config` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 71--75 | `f:pkt_sys_set_resource` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 76--78 | `chunk:76` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 79--79 | `switch:case VIDC_RESOURCE_OCMEM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 80--89 | `switch:case VIDC_RESOURCE_VMEM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 90--90 | `switch:case VIDC_RESOURCE_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 91--97 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 98--100 | `f:pkt_sys_set_resource_syscache` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 101--119 | `chunk:101` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 120--125 | `f:pkt_sys_unset_resource` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 126--127 | `chunk:126` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 128--128 | `switch:case VIDC_RESOURCE_OCMEM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 129--131 | `switch:case VIDC_RESOURCE_VMEM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 132--133 | `switch:case VIDC_RESOURCE_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 134--140 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 141--147 | `f:pkt_sys_ping` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 148--150 | `f:pkt_sys_power_control` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 151--158 | `chunk:151` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 159--161 | `f:pkt_sys_ssr_cmd` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 162--162 | `switch:case HFI_TEST_SSR_SW_ERR_FATAL` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 163--163 | `switch:case HFI_TEST_SSR_SW_DIV_BY_ZERO` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 164--165 | `switch:case HFI_TEST_SSR_HW_WDOG_IRQ` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 166--175 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 176--176 | `chunk:176` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 177--184 | `f:pkt_sys_image_version` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 185--199 | `f:pkt_session_init` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 200--200 | `f:pkt_session_cmd` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 201--206 | `chunk:201` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 207--225 | `f:pkt_session_set_buffers` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 226--245 | `chunk:226` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 246--250 | `f:pkt_session_unset_buffers` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 251--275 | `chunk:251` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 276--286 | `chunk:276` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 287--300 | `f:pkt_session_etb_decoder` | `—` | 强核对：HFI4 ETB/FTB 公共字段已与原厂一致；Test15 首 ETB 后复位，继续查 DMA 可见性/size。 |
| 301--309 | `chunk:301` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 310--325 | `f:pkt_session_etb_encoder` | `—` | 强核对：HFI4 ETB/FTB 公共字段已与原厂一致；Test15 首 ETB 后复位，继续查 DMA 可见性/size。 |
| 326--337 | `chunk:326` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 338--350 | `f:pkt_session_ftb` | `—` | 强核对：HFI4 ETB/FTB 公共字段已与原厂一致；Test15 首 ETB 后复位，继续查 DMA 可见性/size。 |
| 351--363 | `chunk:351` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 364--375 | `f:pkt_session_parse_seq_header` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 376--379 | `chunk:376` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 380--394 | `f:pkt_session_get_seq_hdr` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 395--397 | `f:pkt_session_flush` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 398--398 | `switch:case HFI_FLUSH_INPUT` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 399--399 | `switch:case HFI_FLUSH_OUTPUT` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 400--400 | `switch:case HFI_FLUSH_OUTPUT2` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 401--402 | `chunk:401, switch:case HFI_FLUSH_ALL` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 403--414 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 415--418 | `f:pkt_session_get_property_1x` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 419--419 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 420--421 | `switch:case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 422--425 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 426--434 | `chunk:426` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 435--450 | `f:pkt_session_set_property_1x` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 451--452 | `chunk:451` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 453--460 | `switch:case HFI_PROPERTY_CONFIG_FRAME_RATE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 461--469 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 470--475 | `switch:case HFI_PROPERTY_PARAM_FRAME_SIZE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 476--478 | `chunk:476` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 479--485 | `switch:case HFI_PROPERTY_CONFIG_REALTIME` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 486--494 | `switch:case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 495--500 | `switch:case HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 501--502 | `chunk:501` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 503--511 | `switch:case HFI_PROPERTY_PARAM_BUFFER_DISPLAY_HOLD_COUNT_ACTUAL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 512--519 | `switch:case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 520--523 | `switch:case HFI_PROPERTY_PARAM_VDEC_OUTPUT_ORDER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 524--524 | `switch:case HFI_OUTPUT_ORDER_DECODE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 525--525 | `switch:case HFI_OUTPUT_ORDER_DISPLAY` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 526--526 | `chunk:526` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 527--535 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 536--542 | `switch:case HFI_PROPERTY_PARAM_VDEC_PICTURE_TYPE_DECODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 543--549 | `switch:case HFI_PROPERTY_PARAM_VDEC_OUTPUT2_KEEP_ASPECT_RATIO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 550--550 | `switch:case HFI_PROPERTY_PARAM_VDEC_ENABLE_SUFFICIENT_SEQCHANGE_EVENT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 551--558 | `chunk:551, switch:case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 559--568 | `switch:case HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 569--575 | `switch:case HFI_PROPERTY_PARAM_VDEC_DISPLAY_PICTURE_BUFFER_COUNT` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 576--577 | `chunk:576` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 578--581 | `switch:case HFI_PROPERTY_PARAM_DIVX_FORMAT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 582--582 | `switch:case HFI_DIVX_FORMAT_4` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 583--583 | `switch:case HFI_DIVX_FORMAT_5` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 584--585 | `switch:case HFI_DIVX_FORMAT_6` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 586--594 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 595--600 | `switch:case HFI_PROPERTY_CONFIG_VDEC_MB_ERROR_MAP_REPORTING` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 601--601 | `chunk:601` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 602--608 | `switch:case HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 609--615 | `switch:case HFI_PROPERTY_PARAM_VDEC_THUMBNAIL_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 616--622 | `switch:case HFI_PROPERTY_CONFIG_VENC_SYNC_FRAME_SEQUENCE_HEADER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 623--625 | `switch:case HFI_PROPERTY_CONFIG_VENC_REQUEST_SYNC_FRAME` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 626--627 | `chunk:626, switch:case HFI_PROPERTY_PARAM_VENC_MPEG4_SHORT_HEADER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 628--629 | `switch:case HFI_PROPERTY_PARAM_VENC_MPEG4_AC_PREDICTION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 630--637 | `switch:case HFI_PROPERTY_CONFIG_VENC_TARGET_BITRATE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 638--645 | `switch:case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 646--650 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 651--662 | `chunk:651` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 663--671 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_ENTROPY_CONTROL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 672--675 | `switch:case HFI_PROPERTY_PARAM_VENC_RATE_CONTROL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 676--676 | `chunk:676, switch:case HFI_RATE_CONTROL_OFF` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 677--677 | `switch:case HFI_RATE_CONTROL_CBR_CFR` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 678--678 | `switch:case HFI_RATE_CONTROL_CBR_VFR` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 679--679 | `switch:case HFI_RATE_CONTROL_VBR_CFR` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 680--680 | `switch:case HFI_RATE_CONTROL_VBR_VFR` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 681--682 | `switch:case HFI_RATE_CONTROL_CQ` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 683--691 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 692--698 | `switch:case HFI_PROPERTY_PARAM_VENC_MPEG4_TIME_RESOLUTION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 699--700 | `switch:case HFI_PROPERTY_PARAM_VENC_MPEG4_HEADER_EXTENSION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 701--705 | `chunk:701` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 706--709 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_DEBLOCK_CONTROL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 710--710 | `switch:case HFI_H264_DB_MODE_DISABLE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 711--711 | `switch:case HFI_H264_DB_MODE_SKIP_SLICE_BOUNDARY` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 712--713 | `switch:case HFI_H264_DB_MODE_ALL_BOUNDARY` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 714--724 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 725--725 | `switch:case HFI_PROPERTY_PARAM_VENC_SESSION_QP` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 726--734 | `chunk:726` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 735--750 | `switch:case HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 751--760 | `chunk:751` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 761--773 | `switch:case HFI_PROPERTY_PARAM_VENC_VC1_PERF_CFG` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 774--775 | `switch:case HFI_PROPERTY_PARAM_VENC_MAX_NUM_B_FRAMES` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 776--781 | `chunk:776` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 782--789 | `switch:case HFI_PROPERTY_CONFIG_VENC_INTRA_PERIOD` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 790--796 | `switch:case HFI_PROPERTY_CONFIG_VENC_IDR_PERIOD` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 797--800 | `switch:case HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 801--806 | `chunk:801` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 807--807 | `switch:case HFI_PROPERTY_PARAM_VPE_ROTATION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 808--811 | `switch:case HFI_PROPERTY_CONFIG_VPE_OPERATIONS` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 812--812 | `switch:case HFI_ROTATE_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 813--813 | `switch:case HFI_ROTATE_90` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 814--814 | `switch:case HFI_ROTATE_180` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 815--816 | `switch:case HFI_ROTATE_270` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 817--822 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 823--823 | `switch:case HFI_FLIP_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 824--824 | `switch:case HFI_FLIP_HORIZONTAL` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 825--825 | `switch:case HFI_FLIP_VERTICAL` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 826--826 | `chunk:826` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 827--836 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 837--840 | `switch:case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 841--841 | `switch:case HFI_INTRA_REFRESH_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 842--842 | `switch:case HFI_INTRA_REFRESH_ADAPTIVE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 843--843 | `switch:case HFI_INTRA_REFRESH_CYCLIC` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 844--844 | `switch:case HFI_INTRA_REFRESH_CYCLIC_ADAPTIVE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 845--846 | `switch:case HFI_INTRA_REFRESH_RANDOM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 847--850 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 851--858 | `chunk:851` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 859--862 | `switch:case HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 863--863 | `switch:case HFI_MULTI_SLICE_OFF` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 864--864 | `switch:case HFI_MULTI_SLICE_GOB` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 865--865 | `switch:case HFI_MULTI_SLICE_BY_MB_COUNT` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 866--867 | `switch:case HFI_MULTI_SLICE_BY_BYTE_COUNT` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 868--875 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 876--877 | `chunk:876` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 878--884 | `switch:case HFI_PROPERTY_PARAM_VENC_SLICE_DELIVERY_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 885--893 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_VUI_TIMING_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 894--900 | `switch:case HFI_PROPERTY_CONFIG_VPE_DEINTERLACE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 901--907 | `chunk:901, switch:case HFI_PROPERTY_PARAM_VENC_H264_GENERATE_AUDNAL` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 908--915 | `switch:case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 916--922 | `switch:case HFI_PROPERTY_PARAM_VDEC_FRAME_ASSEMBLY` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 923--925 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_VUI_BITSTREAM_RESTRC` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 926--929 | `chunk:926` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 930--936 | `switch:case HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 937--943 | `switch:case HFI_PROPERTY_PARAM_VENC_PRESERVE_TEXT_QUALITY` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 944--950 | `switch:case HFI_PROPERTY_PARAM_VDEC_SCS_THRESHOLD` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 951--951 | `chunk:951` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 952--956 | `switch:case HFI_PROPERTY_PARAM_MVC_BUFFER_LAYOUT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 957--957 | `switch:case HFI_MVC_BUFFER_LAYOUT_TOP_BOTTOM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 958--959 | `switch:case HFI_MVC_BUFFER_LAYOUT_SEQ` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 960--970 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 971--974 | `switch:case HFI_PROPERTY_PARAM_VENC_LTRMODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 975--975 | `switch:case HFI_LTR_MODE_DISABLE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 976--976 | `chunk:976, switch:case HFI_LTR_MODE_MANUAL` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 977--978 | `switch:case HFI_LTR_MODE_PERIODIC` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 979--989 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 990--998 | `switch:case HFI_PROPERTY_CONFIG_VENC_USELTRFRAME` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 999--1000 | `switch:case HFI_PROPERTY_CONFIG_VENC_MARKLTRFRAME` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1001--1005 | `chunk:1001` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1006--1012 | `switch:case HFI_PROPERTY_PARAM_VENC_HIER_P_MAX_NUM_ENH_LAYER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1013--1019 | `switch:case HFI_PROPERTY_CONFIG_VENC_HIER_P_ENH_LAYER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1020--1025 | `switch:case HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1026--1026 | `chunk:1026` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1027--1033 | `switch:case HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1034--1043 | `switch:case HFI_PROPERTY_PARAM_VENC_INITIAL_QP` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1044--1050 | `switch:case HFI_PROPERTY_PARAM_VPE_COLOR_SPACE_CONVERSION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1051--1054 | `chunk:1051` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1055--1061 | `switch:case HFI_PROPERTY_PARAM_VENC_VPX_ERROR_RESILIENCE_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1062--1068 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_NAL_SVC_EXT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1069--1075 | `switch:case HFI_PROPERTY_CONFIG_VENC_PERF_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1076--1082 | `chunk:1076, switch:case HFI_PROPERTY_PARAM_VENC_HIER_B_MAX_NUM_ENH_LAYER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1083--1089 | `switch:case HFI_PROPERTY_PARAM_VDEC_NONCP_OUTPUT2` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1090--1096 | `switch:case HFI_PROPERTY_PARAM_VENC_HIER_P_HYBRID_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1097--1100 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1101--1108 | `chunk:1101` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1109--1112 | `switch:case HFI_PROPERTY_PARAM_VENC_HDR10_PQ_SEI` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1113--1113 | `switch:case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1114--1114 | `switch:case HFI_PROPERTY_CONFIG_PRIORITY` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1115--1115 | `switch:case HFI_PROPERTY_CONFIG_BATCH_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1116--1116 | `switch:case HFI_PROPERTY_SYS_IDLE_INDICATOR` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1117--1117 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1118--1118 | `switch:case HFI_PROPERTY_PARAM_INTERLACE_FORMAT_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1119--1119 | `switch:case HFI_PROPERTY_PARAM_CHROMA_SITE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1120--1120 | `switch:case HFI_PROPERTY_PARAM_PROPERTIES_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1121--1121 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1122--1122 | `switch:case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1123--1123 | `switch:case HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1124--1124 | `switch:case HFI_PROPERTY_PARAM_MULTI_VIEW_FORMAT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1125--1125 | `switch:case HFI_PROPERTY_PARAM_MAX_SEQUENCE_HEADER_SIZE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1126--1126 | `chunk:1126, switch:case HFI_PROPERTY_PARAM_CODEC_SUPPORTED` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1127--1127 | `switch:case HFI_PROPERTY_PARAM_VDEC_MULTI_VIEW_SELECT` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1128--1128 | `switch:case HFI_PROPERTY_PARAM_VDEC_MB_QUANTIZATION` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1129--1129 | `switch:case HFI_PROPERTY_PARAM_VDEC_NUM_CONCEALED_MB` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1130--1130 | `switch:case HFI_PROPERTY_PARAM_VDEC_H264_ENTROPY_SWITCHING` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1131--1131 | `switch:case HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1132--1139 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1140--1150 | `f:pkt_session_get_property_3xx` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1151--1153 | `chunk:1151` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1154--1156 | `switch:case HFI_PROPERTY_CONFIG_VDEC_ENTROPY` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1157--1165 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1166--1175 | `f:pkt_session_set_property_3xx` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1176--1188 | `chunk:1176` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1189--1197 | `switch:case HFI_PROPERTY_PARAM_VDEC_MULTI_STREAM` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1198--1200 | `switch:case HFI_PROPERTY_PARAM_VENC_INTRA_REFRESH` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1201--1202 | `chunk:1201` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1203--1203 | `switch:case HFI_INTRA_REFRESH_NONE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1204--1204 | `switch:case HFI_INTRA_REFRESH_ADAPTIVE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1205--1205 | `switch:case HFI_INTRA_REFRESH_CYCLIC` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1206--1206 | `switch:case HFI_INTRA_REFRESH_CYCLIC_ADAPTIVE` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1207--1208 | `switch:case HFI_INTRA_REFRESH_RANDOM` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1209--1218 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1219--1221 | `switch:case HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1222--1225 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1226--1230 | `chunk:1226` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1231--1250 | `f:pkt_session_set_property_4xx` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1251--1252 | `chunk:1251` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1253--1268 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1269--1275 | `switch:case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL` | `—` | 强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。 |
| 1276--1278 | `chunk:1276` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1279--1285 | `switch:case HFI_PROPERTY_PARAM_WORK_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1286--1292 | `switch:case HFI_PROPERTY_PARAM_WORK_ROUTE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1293--1299 | `switch:case HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1300--1300 | `switch:case HFI_PROPERTY_PARAM_VENC_HDR10_PQ_SEI` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1301--1306 | `chunk:1301` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1307--1318 | `switch:case HFI_PROPERTY_PARAM_VDEC_CONCEAL_COLOR` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1319--1325 | `switch:case HFI_PROPERTY_PARAM_VENC_H264_TRANSFORM_8X8` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1326--1340 | `chunk:1326, switch:case HFI_PROPERTY_CONFIG_VENC_FRAME_QP` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1341--1350 | `switch:case HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE_V2` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1351--1364 | `chunk:1351` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1365--1365 | `switch:case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1366--1366 | `switch:case HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1367--1367 | `switch:case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1368--1368 | `switch:case HFI_PROPERTY_PARAM_VENC_SESSION_QP` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1369--1371 | `switch:case HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1372--1375 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1376--1379 | `chunk:1376` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1380--1396 | `f:pkt_session_set_property_6xx` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1397--1400 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1401--1409 | `chunk:1401` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1410--1416 | `switch:case HFI_PROPERTY_CONFIG_HEIC_FRAME_QUALITY` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1417--1423 | `switch:case HFI_PROPERTY_PARAM_WORK_ROUTE` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1424--1425 | `switch:default` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1426--1430 | `chunk:1426` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1431--1439 | `f:pkt_session_get_property` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1440--1450 | `f:pkt_session_set_property` | `—` | 选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。 |
| 1451--1454 | `chunk:1451` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |
| 1455--1458 | `f:pkt_set_version` | `—` | 逐包核对：HFI4 packet ID、payload、长度和发送条件必须精确。 |

覆盖校验：1458/1458 行，连续、无空洞、无重叠。

## `hfi_cmds.h`

- 当前物理行：299；原厂语义域：`hfi_packetization.h`；默认判定：**语义拆分**。
- 文件级结论：命令 API 按当前 HFI ops 拆分。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 6--25 | `pp:ifndef` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 276--298 | `chunk:276` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |
| 299--299 | `pp:endif` | `—` | 语义拆分：命令 API 按当前 HFI ops 拆分。 |

覆盖校验：299/299 行，连续、无空洞、无重叠。

## `hfi_helper.h`

- 当前物理行：1327；原厂语义域：`vidc_hfi_helper.h + vidc_hfi_api.h`；默认判定：**逐字段核对**。
- 文件级结论：wire enum/packed struct 是强一致面；新增字段必须兼容包长。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 6--25 | `pp:ifndef` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 26--50 | `chunk:26` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 51--75 | `chunk:51` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 76--100 | `chunk:76` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 101--125 | `chunk:101` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 126--150 | `chunk:126` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 151--175 | `chunk:151` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 176--200 | `chunk:176` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 201--225 | `chunk:201` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 226--250 | `chunk:226` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 251--275 | `chunk:251` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 276--300 | `chunk:276` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 301--325 | `chunk:301` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 326--350 | `chunk:326` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 351--375 | `chunk:351` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 376--400 | `chunk:376` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 401--425 | `chunk:401` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 426--450 | `chunk:426` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 451--475 | `chunk:451` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 476--500 | `chunk:476` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 501--525 | `chunk:501` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 526--550 | `chunk:526` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 551--575 | `chunk:551` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 576--600 | `chunk:576` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 601--625 | `chunk:601` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 626--650 | `chunk:626` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 651--675 | `chunk:651` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 676--700 | `chunk:676` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 701--725 | `chunk:701` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 726--750 | `chunk:726` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 751--775 | `chunk:751` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 776--800 | `chunk:776` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 801--825 | `chunk:801` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 826--850 | `chunk:826` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 851--875 | `chunk:851` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 876--900 | `chunk:876` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 901--925 | `chunk:901` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 926--950 | `chunk:926` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 951--975 | `chunk:951` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 976--1000 | `chunk:976` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1001--1025 | `chunk:1001` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1026--1050 | `chunk:1026` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1051--1075 | `chunk:1051` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1076--1100 | `chunk:1076` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1101--1125 | `chunk:1101` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1126--1150 | `chunk:1126` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1151--1175 | `chunk:1151` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1176--1200 | `chunk:1176` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1201--1225 | `chunk:1201` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1226--1250 | `chunk:1226` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1251--1275 | `chunk:1251` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1276--1300 | `chunk:1276` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1301--1325 | `chunk:1301` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1326--1326 | `chunk:1326` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |
| 1327--1327 | `pp:endif` | `—` | 逐字段核对：wire enum/packed struct 是强一致面；新增字段必须兼容包长。 |

覆盖校验：1327/1327 行，连续、无空洞、无重叠。

## `hfi_msgs.c`

- 当前物理行：943；原厂语义域：`hfi_response_handler.c + msm_vidc_clocks.c`；默认判定：**部分迁移**。
- 文件级结论：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--18 | `chunk:1, file:start` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 19--19 | `d:SMEM_IMG_VER_TBL` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 20--20 | `d:VER_STR_SZ` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 21--22 | `d:SMEM_IMG_OFFSET_VENUS` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 23--25 | `f:event_seq_changed` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 26--43 | `chunk:26` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 44--44 | `switch:case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 45--46 | `switch:case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 47--50 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 51--70 | `chunk:51` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 71--75 | `switch:case HFI_PROPERTY_PARAM_FRAME_SIZE` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 76--79 | `chunk:76` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 80--88 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 89--96 | `switch:case HFI_PROPERTY_PARAM_VDEC_PIXEL_BITDEPTH` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 97--100 | `switch:case HFI_PROPERTY_PARAM_VDEC_PIC_STRUCT` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 101--104 | `chunk:101` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 105--112 | `switch:case HFI_PROPERTY_PARAM_VDEC_COLOUR_SPACE` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 113--119 | `switch:case HFI_PROPERTY_CONFIG_VDEC_ENTROPY` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 120--125 | `switch:case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 126--127 | `chunk:126` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 128--138 | `switch:case HFI_INDEX_EXTRADATA_INPUT_CROP` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 139--146 | `switch:case HFI_PROPERTY_PARAM_VDEC_DPB_COUNTS` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 147--150 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 151--158 | `chunk:151` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 159--163 | `label:error` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 164--175 | `f:event_release_buffer_ref` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 176--182 | `chunk:176` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 183--195 | `f:event_sys_error` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 196--200 | `f:event_session_error` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 201--208 | `chunk:201` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 209--209 | `switch:case HFI_ERR_SESSION_INVALID_SCALE_FACTOR` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 210--210 | `switch:case HFI_ERR_SESSION_UNSUPPORT_BUFFERTYPE` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 211--211 | `switch:case HFI_ERR_SESSION_UNSUPPORTED_SETTING` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 212--214 | `switch:case HFI_ERR_SESSION_UPSCALE_NOT_SUPPORTED` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 215--225 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 226--234 | `chunk:226, f:hfi_event_notify` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 235--237 | `switch:case HFI_EVENT_SYS_ERROR` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 238--240 | `switch:case HFI_EVENT_SESSION_ERROR` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 241--243 | `switch:case HFI_EVENT_SESSION_SEQUENCE_CHANGED` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 244--246 | `switch:case HFI_EVENT_RELEASE_BUFFER_REFERENCE` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 247--248 | `switch:case HFI_EVENT_SESSION_PROPERTY_CHANGED` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 249--250 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 251--253 | `chunk:251` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 254--275 | `f:hfi_sys_init_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 276--278 | `chunk:276` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 279--289 | `label:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 290--300 | `f:sys_get_prop_image_version` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 301--325 | `chunk:301` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 326--335 | `chunk:326` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 336--350 | `label:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 351--351 | `chunk:351` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 352--363 | `f:hfi_sys_property_info` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 364--366 | `switch:case HFI_PROPERTY_SYS_IMAGE_VERSION` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 367--372 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 373--375 | `f:hfi_sys_rel_resource_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 376--382 | `chunk:376` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 383--395 | `f:hfi_sys_ping_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 396--400 | `f:hfi_sys_idle_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 401--401 | `chunk:401` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 402--411 | `f:hfi_sys_pc_prepare_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 412--425 | `f:session_get_prop_profile_level` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 426--431 | `chunk:426` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 432--450 | `f:session_get_prop_buf_req` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 451--462 | `chunk:451` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 463--475 | `f:hfi_session_prop_info` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 476--477 | `chunk:476` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 478--481 | `switch:case HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 482--486 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 487--488 | `switch:case HFI_PROPERTY_CONFIG_VDEC_ENTROPY` | `—` | response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。 |
| 489--493 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 494--498 | `label:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 499--500 | `f:hfi_session_init_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 501--519 | `chunk:501` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 520--524 | `label:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 525--525 | `f:hfi_session_load_res_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 526--533 | `chunk:526` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 534--544 | `f:hfi_session_flush_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 545--550 | `f:hfi_session_etb_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 551--575 | `chunk:551` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 576--600 | `chunk:576` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 601--625 | `chunk:601` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 626--650 | `chunk:626, f:hfi_session_ftb_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 651--675 | `chunk:651` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 676--678 | `chunk:676` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 679--679 | `switch:case HFI_PICTURE_IDR` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 680--682 | `switch:case HFI_PICTURE_I` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 683--685 | `switch:case HFI_PICTURE_P` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 686--688 | `switch:case HFI_PICTURE_B` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 689--689 | `switch:case HFI_FRAME_NOTCODED` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 690--690 | `switch:case HFI_UNUSED_PICT` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 691--691 | `switch:case HFI_FRAME_YUV` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 692--700 | `switch:default` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 701--706 | `chunk:701, label:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 707--715 | `f:hfi_session_start_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 716--724 | `f:hfi_session_stop_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 725--725 | `f:hfi_session_rel_res_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 726--733 | `chunk:726` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 734--742 | `f:hfi_session_rel_buf_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 743--750 | `f:hfi_session_end_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 751--751 | `chunk:751` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 752--760 | `f:hfi_session_abort_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 761--769 | `f:hfi_session_get_seq_hdr_done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 770--775 | `s:hfi_done_handler` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 776--777 | `chunk:776` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 778--779 | `v:handlers` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 780--780 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 781--783 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 784--784 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 785--785 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 786--788 | `field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 789--789 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 790--790 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 791--793 | `field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 794--794 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 795--795 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 796--798 | `field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 799--799 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 800--800 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 801--803 | `chunk:801, field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 804--804 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 805--805 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 806--808 | `field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 809--809 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 810--810 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 811--813 | `field:is_sys_pkt` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 814--814 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 815--817 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 818--818 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 819--821 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 822--822 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 823--825 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 826--826 | `chunk:826, field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 827--829 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 830--830 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 831--833 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 834--834 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 835--837 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 838--838 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 839--841 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 842--842 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 843--843 | `field:pkt_sz2` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 844--846 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 847--847 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 848--850 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 851--851 | `chunk:851, field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 852--854 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 855--855 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 856--858 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 859--859 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 860--862 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 863--863 | `field:pkt_sz` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 864--867 | `field:done` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 868--872 | `f:hfi_process_watchdog_timeout` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 873--875 | `f:to_instance` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 876--887 | `chunk:876` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 888--900 | `f:hfi_process_msg_packet` | `hfi_process_msg_packet` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 901--925 | `chunk:901` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 926--940 | `chunk:926` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |
| 941--943 | `label:invalid_session` | `—` | 部分迁移：公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。 |

覆盖校验：943/943 行，连续、无空洞、无重叠。

## `hfi_msgs.h`

- 当前物理行：298；原厂语义域：`hfi_response_handler.c + vidc_hfi_helper.h`；默认判定：**语义拆分**。
- 文件级结论：消息结构按公共前缀和主线回调表达。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 6--25 | `pp:ifndef` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 176--200 | `chunk:176` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 201--225 | `chunk:201` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 226--250 | `chunk:226` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 251--275 | `chunk:251` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 276--297 | `chunk:276` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |
| 298--298 | `pp:endif` | `—` | 语义拆分：消息结构按公共前缀和主线回调表达。 |

覆盖校验：298/298 行，连续、无空洞、无重叠。

## `hfi_parser.c`

- 当前物理行：403；原厂语义域：`hfi_response_handler.c + msm_vidc_platform.c`；默认判定：**部分迁移**。
- 文件级结论：固件 capability 决定真实 codec/profile/range。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--13 | `chunk:1, file:start` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 14--16 | `t:func` | `func` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 17--25 | `f:init_codecs` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 26--41 | `chunk:26` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 42--50 | `f:for_each_codec` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 51--58 | `chunk:51` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 59--67 | `f:fill_buf_mode` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 68--75 | `f:parse_alloc_mode` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 76--90 | `chunk:76` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 91--100 | `f:fill_profile_level` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 101--103 | `chunk:101` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 104--121 | `f:parse_profile_level` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 122--125 | `f:fill_caps` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 126--133 | `chunk:126` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 134--150 | `f:parse_caps` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 151--151 | `chunk:151` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 152--164 | `f:fill_raw_fmts` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 165--175 | `f:parse_raw_formats` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 176--199 | `chunk:176` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 200--200 | `f:parse_codecs` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 201--215 | `chunk:201` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 216--224 | `f:parse_max_sessions` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 225--225 | `f:parse_codecs_mask` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 226--234 | `chunk:226` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 235--243 | `f:parser_init` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 244--250 | `f:parser_fini` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 251--262 | `chunk:251` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 263--275 | `f:hfi_platform_parser` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 276--297 | `chunk:276` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 298--300 | `f:hfi_parser` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 301--325 | `chunk:301` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 326--338 | `chunk:326` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 339--348 | `switch:case HFI_PROPERTY_PARAM_CODEC_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 349--350 | `switch:case HFI_PROPERTY_PARAM_MAX_SESSIONS_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 351--354 | `chunk:351` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 355--360 | `switch:case HFI_PROPERTY_PARAM_CODEC_MASK_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 361--366 | `switch:case HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 367--372 | `switch:case HFI_PROPERTY_PARAM_CAPABILITY_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 373--375 | `switch:case HFI_PROPERTY_PARAM_PROFILE_LEVEL_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 376--378 | `chunk:376` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 379--384 | `switch:case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 385--400 | `switch:default` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |
| 401--403 | `chunk:401` | `—` | capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。 |

覆盖校验：403/403 行，连续、无空洞、无重叠。

## `hfi_parser.h`

- 当前物理行：120；原厂语义域：`vidc_hfi_api.h`；默认判定：**语义拆分**。
- 文件级结论：capability helper 按主线模型保留。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--2 | `chunk:1, file:start` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 3--25 | `pp:ifndef` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 26--36 | `chunk:26` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 37--38 | `switch:case WHICH_CAP_MIN` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 39--40 | `switch:case WHICH_CAP_MAX` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 41--42 | `switch:case WHICH_CAP_STEP` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 43--50 | `switch:default` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 101--119 | `chunk:101` | `—` | 语义拆分：capability helper 按主线模型保留。 |
| 120--120 | `pp:endif` | `—` | 语义拆分：capability helper 按主线模型保留。 |

覆盖校验：120/120 行，连续、无空洞、无重叠。

## `hfi_plat_bufs_v6.c`

- 当前物理行：1334；原厂语义域：`无 IRIS1 等价；vendor VPU5 requirements 来自固件`；默认判定：**非本机执行路径**。
- 文件级结论：HFI6 计算器不能误用于 SM8150 HFI4；保留上游供其他 SoC。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--12 | `chunk:1, file:start` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 13--13 | `d:MIN_INPUT_BUFFERS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 14--15 | `d:MIN_ENC_OUTPUT_BUFFERS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 16--16 | `d:NV12_UBWC_Y_TILE_WIDTH` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 17--17 | `d:NV12_UBWC_Y_TILE_HEIGHT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 18--18 | `d:NV12_UBWC_UV_TILE_WIDTH` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 19--19 | `d:NV12_UBWC_UV_TILE_HEIGHT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 20--20 | `d:TP10_UBWC_Y_TILE_WIDTH` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 21--21 | `d:TP10_UBWC_Y_TILE_HEIGHT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 22--22 | `d:METADATA_STRIDE_MULTIPLE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 23--23 | `d:METADATA_HEIGHT_MULTIPLE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 24--25 | `d:HFI_DMA_ALIGNMENT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 26--26 | `chunk:26, d:MAX_FE_NBR_CTRL_LCU64_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 27--27 | `d:MAX_FE_NBR_CTRL_LCU32_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 28--28 | `d:MAX_FE_NBR_CTRL_LCU16_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 29--29 | `d:MAX_FE_NBR_DATA_LUMA_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 30--30 | `d:MAX_FE_NBR_DATA_CB_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 31--32 | `d:MAX_FE_NBR_DATA_CR_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 33--33 | `d:MAX_SE_NBR_CTRL_LCU64_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 34--34 | `d:MAX_SE_NBR_CTRL_LCU32_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 35--36 | `d:MAX_SE_NBR_CTRL_LCU16_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 37--37 | `d:MAX_PE_NBR_DATA_LCU64_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 38--38 | `d:MAX_PE_NBR_DATA_LCU32_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 39--40 | `d:MAX_PE_NBR_DATA_LCU16_LINE_BUFFER_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 41--42 | `d:MAX_TILE_COLUMNS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 43--43 | `d:VPP_CMD_MAX_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 44--44 | `d:NUM_HW_PIC_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 45--45 | `d:BIN_BUFFER_THRESHOLD` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 46--47 | `d:H264D_MAX_SLICE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 48--49 | `d:SIZE_H264D_BUFTAB_T` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 50--50 | `d:SIZE_H264D_HW_PIC_T` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 51--51 | `chunk:51, d:SIZE_H264D_BSE_CMD_PER_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 52--54 | `d:SIZE_H264D_VPP_CMD_PER_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 55--57 | `d:SIZE_H264D_LB_FE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 58--60 | `d:SIZE_H264D_LB_FE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 61--63 | `d:SIZE_H264D_LB_FE_LEFT_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 64--66 | `d:SIZE_H264D_LB_SE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 67--69 | `d:SIZE_H264D_LB_SE_LEFT_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 70--72 | `d:SIZE_H264D_LB_PE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 73--74 | `d:SIZE_H264D_LB_VSP_TOP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 75--75 | `d:SIZE_H264D_LB_RECON_DMA_METADATA_WR` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 76--77 | `chunk:76` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 78--80 | `d:SIZE_H264D_QP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 81--82 | `d:SIZE_HW_PIC` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 83--83 | `d:H264_CABAC_HDR_RATIO_HD_TOT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 84--89 | `d:H264_CABAC_RES_RATIO_HD_TOT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 90--90 | `d:NUM_SLIST_BUF_H264` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 91--91 | `d:SIZE_SLIST_BUF_H264` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 92--92 | `d:LCU_MAX_SIZE_PELS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 93--93 | `d:LCU_MIN_SIZE_PELS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 94--95 | `d:SIZE_SEI_USERDATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 96--96 | `d:H265D_MAX_SLICE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 97--97 | `d:SIZE_H265D_HW_PIC_T` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 98--98 | `d:SIZE_H265D_BSE_CMD_PER_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 99--100 | `d:SIZE_H265D_VPP_CMD_PER_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 101--103 | `chunk:101, d:SIZE_H265D_LB_FE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 104--107 | `d:SIZE_H265D_LB_FE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 108--111 | `d:SIZE_H265D_LB_FE_LEFT_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 112--114 | `d:SIZE_H265D_LB_SE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 115--125 | `f:size_h265d_lb_se_left_ctrl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 126--129 | `chunk:126, d:SIZE_H265D_LB_PE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 130--131 | `d:SIZE_H265D_LB_VSP_TOP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 132--133 | `d:SIZE_H265D_LB_VSP_LEFT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 134--136 | `d:SIZE_H265D_LB_RECON_DMA_METADATA_WR` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 137--138 | `d:SIZE_H265D_QP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 139--139 | `d:H265_CABAC_HDR_RATIO_HD_TOT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 140--145 | `d:H265_CABAC_RES_RATIO_HD_TOT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 146--146 | `d:SIZE_SLIST_BUF_H265` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 147--147 | `d:NUM_SLIST_BUF_H265` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 148--148 | `d:H265_NUM_TILE_COL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 149--149 | `d:H265_NUM_TILE_ROW` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 150--150 | `d:H265_NUM_TILE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 151--151 | `chunk:151` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 152--162 | `f:size_vpxd_lb_fe_left_ctrl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 163--164 | `d:SIZE_VPXD_LB_FE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 165--167 | `d:SIZE_VPXD_LB_SE_TOP_CTRL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 168--175 | `f:size_vpxd_lb_se_left_ctrl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 176--178 | `chunk:176` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 179--180 | `d:SIZE_VPXD_LB_RECON_DMA_METADATA_WR` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 181--182 | `d:SIZE_VP8D_LB_FE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 183--184 | `d:SIZE_VP9D_LB_FE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 185--186 | `d:SIZE_VP8D_LB_PE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 187--188 | `d:SIZE_VP9D_LB_PE_TOP_DATA` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 189--190 | `d:SIZE_VP8D_LB_VSP_TOP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 191--193 | `d:SIZE_VP9D_LB_VSP_TOP` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 194--196 | `d:HFI_IRIS2_VP9D_COMV_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 197--197 | `d:VPX_DECODER_FRAME_CONCURENCY_LVL` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 198--198 | `d:VPX_DECODER_FRAME_BIN_HDR_BUDGET_RATIO_NUM` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 199--199 | `d:VPX_DECODER_FRAME_BIN_HDR_BUDGET_RATIO_DEN` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 200--200 | `d:VPX_DECODER_FRAME_BIN_RES_BUDGET_RATIO_NUM` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 201--202 | `chunk:201, d:VPX_DECODER_FRAME_BIN_RES_BUDGET_RATIO_DEN` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 203--203 | `d:VP8_NUM_FRAME_INFO_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 204--204 | `d:VP9_NUM_FRAME_INFO_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 205--205 | `d:VP8_NUM_PROBABILITY_TABLE_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 206--206 | `d:VP9_NUM_PROBABILITY_TABLE_BUF` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 207--207 | `d:VP8_PROB_TABLE_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 208--209 | `d:VP9_PROB_TABLE_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 210--210 | `d:VP9_UDC_HEADER_BUF_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 211--211 | `d:MAX_SUPERFRAME_HEADER_LEN` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 212--213 | `d:CCE_TILE_OFFSET_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 214--214 | `d:QMATRIX_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 215--215 | `d:MP2D_QPDUMP_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 216--216 | `d:HFI_IRIS2_ENC_PERSIST_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 217--217 | `d:HFI_MAX_COL_FRAME` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 218--218 | `d:HFI_VENUS_VENC_TRE_WB_BUFF_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 219--219 | `d:HFI_VENUS_VENC_DB_LINE_BUFF_PER_MB` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 220--220 | `d:HFI_VENUS_VPPSG_MAX_REGISTERS` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 221--221 | `d:HFI_VENUS_WIDTH_ALIGNMENT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 222--222 | `d:HFI_VENUS_WIDTH_TEN_BIT_ALIGNMENT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 223--224 | `d:HFI_VENUS_HEIGHT_ALIGNMENT` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 225--225 | `d:SYSTEM_LAL_TILE10` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 226--226 | `chunk:226, d:NUM_MBS_720P` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 227--227 | `d:NUM_MBS_4K` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 228--228 | `d:MB_SIZE_IN_PIXEL` | `MB_SIZE_IN_PIXEL` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 229--229 | `d:HDR10PLUS_PAYLOAD_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 230--231 | `d:HDR10_HIST_EXTRADATA_SIZE` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 232--250 | `f:size_vpss_lb` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 251--267 | `chunk:251` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 268--275 | `f:size_h264d_hw_bin_buffer` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 276--286 | `chunk:276` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 287--298 | `f:h264d_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 299--300 | `f:size_h265d_hw_bin_buffer` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 301--316 | `chunk:301` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 317--325 | `f:h265d_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 326--328 | `chunk:326` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 329--350 | `f:vpxd_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 351--355 | `chunk:351` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 356--360 | `f:mpeg2d_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 361--375 | `f:calculate_enc_output_frame_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 376--400 | `chunk:376` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 401--402 | `chunk:401` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 403--425 | `f:calculate_enc_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 426--445 | `chunk:426` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 446--450 | `f:h264e_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 451--452 | `chunk:451` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 453--459 | `f:h265e_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 460--466 | `f:vp8e_scratch_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 467--475 | `f:hfi_iris2_h264d_comv_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 476--493 | `chunk:476` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 494--500 | `f:size_h264d_bse_cmd_buf` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 501--501 | `chunk:501` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 502--514 | `f:size_h264d_vpp_cmd_buf` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 515--525 | `f:hfi_iris2_h264d_non_comv_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 526--545 | `chunk:526` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 546--550 | `f:size_h265d_bse_cmd_buf` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 551--558 | `chunk:551` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 559--575 | `f:size_h265d_vpp_cmd_buf` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 576--587 | `chunk:576, f:hfi_iris2_h265d_comv_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 588--600 | `f:hfi_iris2_h265d_non_comv_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 601--625 | `chunk:601` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 626--626 | `chunk:626` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 627--632 | `f:hfi_iris2_vp8d_comv_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 633--646 | `f:h264d_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 647--650 | `f:h265d_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 651--661 | `chunk:651` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 662--675 | `f:vp8d_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 676--690 | `chunk:676` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 691--700 | `f:vp9d_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 701--721 | `chunk:701` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 722--725 | `f:mpeg2d_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 726--750 | `chunk:726` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 751--753 | `chunk:751` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 754--775 | `f:calculate_enc_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 776--800 | `chunk:776` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 801--825 | `chunk:801` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 826--850 | `chunk:826` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 851--875 | `chunk:851` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 876--900 | `chunk:876` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 901--906 | `chunk:901` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 907--913 | `f:h264e_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 914--920 | `f:h265e_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 921--925 | `f:vp8e_scratch1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 926--927 | `chunk:926` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 928--934 | `f:ubwc_metadata_plane_stride` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 935--941 | `f:ubwc_metadata_plane_bufheight` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 942--947 | `f:ubwc_metadata_plane_buffer_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 948--950 | `f:enc_scratch2_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 951--975 | `chunk:951` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 976--1000 | `chunk:976` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1001--1009 | `chunk:1001` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1010--1014 | `f:enc_persist_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1015--1020 | `f:h264d_persist1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1021--1025 | `f:h265d_persist1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1026--1026 | `chunk:1026` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1027--1032 | `f:vp8d_persist1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1033--1044 | `f:vp9d_persist1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1045--1049 | `f:mpeg2d_persist1_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1050--1050 | `s:dec_bufsize_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1051--1056 | `chunk:1051` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1057--1065 | `s:enc_bufsize_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1066--1066 | `v:dec_h264_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1067--1067 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1068--1068 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1069--1071 | `field:persist1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1072--1072 | `v:dec_h265_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1073--1073 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1074--1074 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1075--1075 | `field:persist1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1076--1077 | `chunk:1076` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1078--1078 | `v:dec_vp8_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1079--1079 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1080--1080 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1081--1083 | `field:persist1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1084--1084 | `v:dec_vp9_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1085--1085 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1086--1086 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1087--1089 | `field:persist1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1090--1090 | `v:dec_mpeg2_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1091--1091 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1092--1092 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1093--1095 | `field:persist1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1096--1096 | `v:enc_h264_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1097--1097 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1098--1098 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1099--1099 | `field:scratch2` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1100--1100 | `field:persist` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1101--1102 | `chunk:1101` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1103--1103 | `v:enc_h265_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1104--1104 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1105--1105 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1106--1106 | `field:scratch2` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1107--1109 | `field:persist` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1110--1110 | `v:enc_vp8_ops` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1111--1111 | `field:scratch` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1112--1112 | `field:scratch1` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1113--1113 | `field:scratch2` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1114--1117 | `field:persist` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1118--1125 | `f:calculate_dec_input_frame_size` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1126--1150 | `chunk:1126` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1151--1155 | `chunk:1151` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1156--1161 | `f:output_buffer_count` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1162--1162 | `switch:case V4L2_PIX_FMT_MPEG2` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1163--1165 | `switch:case V4L2_PIX_FMT_VP8` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1166--1168 | `switch:case V4L2_PIX_FMT_VP9` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1169--1169 | `switch:case V4L2_PIX_FMT_H264` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1170--1170 | `switch:case V4L2_PIX_FMT_HEVC` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1171--1175 | `switch:default` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1176--1181 | `chunk:1176` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1182--1196 | `f:bufreq_dec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1197--1199 | `switch:case V4L2_PIX_FMT_H264` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1200--1200 | `switch:case V4L2_PIX_FMT_HEVC` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1201--1202 | `chunk:1201` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1203--1205 | `switch:case V4L2_PIX_FMT_VP8` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1206--1208 | `switch:case V4L2_PIX_FMT_VP9` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1209--1211 | `switch:case V4L2_PIX_FMT_MPEG2` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1212--1225 | `switch:default` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1226--1250 | `chunk:1226` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1251--1258 | `chunk:1251` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1259--1274 | `f:bufreq_enc` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1275--1275 | `switch:case V4L2_PIX_FMT_H264` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1276--1277 | `chunk:1276` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1278--1280 | `switch:case V4L2_PIX_FMT_HEVC` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1281--1283 | `switch:case V4L2_PIX_FMT_VP8` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1284--1300 | `switch:default` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1301--1325 | `chunk:1301` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1326--1326 | `chunk:1326` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 1327--1334 | `f:hfi_plat_bufreq_v6` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |

覆盖校验：1334/1334 行，连续、无空洞、无重叠。

## `hfi_plat_bufs.h`

- 当前物理行：41；原厂语义域：`msm_vidc_common.c buffer requirements`；默认判定：**共享接口**。
- 文件级结论：IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 共享接口：IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。 |
| 6--25 | `pp:ifndef` | `—` | 共享接口：IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。 |
| 26--40 | `chunk:26` | `—` | 共享接口：IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。 |
| 41--41 | `pp:endif` | `—` | 共享接口：IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。 |

覆盖校验：41/41 行，连续、无空洞、无重叠。

## `hfi_platform_v4.c`

- 当前物理行：481；原厂语义域：`msm_vidc_platform.c + vidc_hfi_helper.h`；默认判定：**关键迁移面**。
- 文件级结论：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--7 | `chunk:1, file:start` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 8--9 | `v:caps` | `caps` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 10--10 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 11--11 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 12--22 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 23--25 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 26--28 | `chunk:26` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 29--33 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 34--35 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 36--36 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 37--37 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 38--48 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 49--50 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 51--51 | `chunk:51` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 52--59 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 60--61 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 62--62 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 63--63 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 64--74 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 75--75 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 76--79 | `chunk:76` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 80--84 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 85--86 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 87--87 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 88--88 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 89--99 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 100--100 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 101--102 | `chunk:101` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 103--110 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 111--112 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 113--113 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 114--114 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 115--125 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 126--128 | `chunk:126, field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 129--133 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 134--135 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 136--136 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 137--137 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 138--150 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 151--159 | `chunk:151` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 160--165 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 166--170 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 171--172 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 173--173 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 174--174 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 175--175 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 176--199 | `chunk:176` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 200--200 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 201--202 | `chunk:201` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 203--207 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 208--209 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 210--210 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 211--211 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 212--225 | `field:cap_bufs_mode_dynamic` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 226--235 | `chunk:226` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 236--240 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 241--245 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 246--248 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 249--250 | `v:caps_lite` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 251--251 | `chunk:251, field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 252--259 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 260--265 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 266--270 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 271--272 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 273--273 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 274--275 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 276--281 | `chunk:276` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 282--284 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 285--289 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 290--291 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 292--292 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 293--300 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 301--303 | `chunk:301, field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 304--308 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 309--310 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 311--311 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 312--325 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 326--327 | `chunk:326` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 328--333 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 334--336 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 337--338 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 339--339 | `field:codec` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 340--350 | `field:domain` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 351--355 | `chunk:351` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 356--358 | `field:num_caps` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 359--361 | `field:num_pl` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 362--364 | `field:num_fmts` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 365--372 | `f:get_capabilities` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 373--375 | `f:get_codecs` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 376--394 | `chunk:376` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 395--400 | `v:codec_freq_data` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 401--405 | `chunk:401` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 406--414 | `v:codec_freq_data_lite` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 415--425 | `f:get_codec_freq_data` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 426--438 | `chunk:426` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 439--450 | `f:codec_vpp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 451--462 | `chunk:451, f:codec_vsp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 463--474 | `f:codec_lp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 475--475 | `v:hfi_plat_v4` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 476--476 | `chunk:476, field:codec_vpp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 477--477 | `field:codec_vsp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 478--478 | `field:codec_lp_freq` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 479--479 | `field:codecs` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |
| 480--481 | `field:capabilities` | `—` | 关键迁移面：HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。 |

覆盖校验：481/481 行，连续、无空洞、无重叠。

## `hfi_platform_v6.c`

- 当前物理行：347；原厂语义域：`无 IRIS1 等价`；默认判定：**非本机执行路径**。
- 文件级结论：HFI6 平台映射不能作为 SM8150 证据。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--7 | `chunk:1, file:start` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 8--9 | `v:caps` | `caps` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 10--10 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 11--11 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 12--22 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 23--25 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 26--28 | `chunk:26` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 29--33 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 34--35 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 36--36 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 37--37 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 38--48 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 49--50 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 51--51 | `chunk:51` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 52--59 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 60--61 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 62--62 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 63--63 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 64--74 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 75--75 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 76--79 | `chunk:76` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 80--84 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 85--86 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 87--87 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 88--88 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 89--99 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 100--100 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 101--102 | `chunk:101` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 103--110 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 111--112 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 113--113 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 114--114 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 115--125 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 126--128 | `chunk:126, field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 129--133 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 134--135 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 136--136 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 137--137 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 138--150 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 151--159 | `chunk:151` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 160--165 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 166--170 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 171--172 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 173--173 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 174--174 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 175--175 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 176--199 | `chunk:176` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 200--200 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 201--202 | `chunk:201` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 203--207 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 208--209 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 210--210 | `field:codec` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 211--211 | `field:domain` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 212--225 | `field:cap_bufs_mode_dynamic` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 226--235 | `chunk:226` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 236--240 | `field:num_caps` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 241--245 | `field:num_pl` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 246--248 | `field:num_fmts` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 249--250 | `f:get_capabilities` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 251--258 | `chunk:251` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 259--272 | `f:get_codecs` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 273--275 | `v:codec_freq_data` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 276--284 | `chunk:276` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 285--300 | `f:get_codec_freq_data` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 301--303 | `chunk:301` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 304--315 | `f:codec_vpp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 316--325 | `f:codec_vsp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 326--327 | `chunk:326` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 328--339 | `f:codec_lp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 340--340 | `v:hfi_plat_v6` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 341--341 | `field:codec_vpp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 342--342 | `field:codec_vsp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 343--343 | `field:codec_lp_freq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 344--344 | `field:codecs` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 345--345 | `field:capabilities` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |
| 346--347 | `field:bufreq` | `—` | 非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。 |

覆盖校验：347/347 行，连续、无空洞、无重叠。

## `hfi_platform.c`

- 当前物理行：97；原厂语义域：`msm_vidc_platform.c`；默认判定：**主线替代**。
- 文件级结论：按 HFI generation 选择 platform ops。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--8 | `chunk:1, file:start` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 9--11 | `f:hfi_platform_get` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 12--13 | `switch:case HFI_VERSION_4XX` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 14--15 | `switch:case HFI_VERSION_6XX` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 16--23 | `switch:default` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 24--25 | `f:hfi_platform_get_codec_vpp_freq` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 26--41 | `chunk:26` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 42--50 | `f:hfi_platform_get_codec_vsp_freq` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 51--59 | `chunk:51` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 60--75 | `f:hfi_platform_get_codec_lp_freq` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 76--77 | `chunk:76` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |
| 78--97 | `f:hfi_platform_get_codecs` | `—` | 主线替代：按 HFI generation 选择 platform ops。 |

覆盖校验：97/97 行，连续、无空洞、无重叠。

## `hfi_platform.h`

- 当前物理行：79；原厂语义域：`msm_vidc_platform.c + vidc_hfi_api.h`；默认判定：**语义拆分**。
- 文件级结论：platform ops 按主线接口表达。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：platform ops 按主线接口表达。 |
| 6--25 | `pp:ifndef` | `—` | 语义拆分：platform ops 按主线接口表达。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：platform ops 按主线接口表达。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：platform ops 按主线接口表达。 |
| 76--78 | `chunk:76` | `—` | 语义拆分：platform ops 按主线接口表达。 |
| 79--79 | `pp:endif` | `—` | 语义拆分：platform ops 按主线接口表达。 |

覆盖校验：79/79 行，连续、无空洞、无重叠。

## `hfi_venus_io.h`

- 当前物理行：173；原厂语义域：`vidc_hfi_io.h`；默认判定：**逐寄存器核对**。
- 文件级结论：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 6--25 | `pp:ifndef` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 26--50 | `chunk:26` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 51--75 | `chunk:51` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 76--100 | `chunk:76` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 101--125 | `chunk:101` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 126--150 | `chunk:126` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 151--172 | `chunk:151` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |
| 173--173 | `pp:endif` | `—` | 逐寄存器核对：只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。 |

覆盖校验：173/173 行，连续、无空洞、无重叠。

## `hfi_venus.c`

- 当前物理行：2063；原厂语义域：`venus_hfi.c + msm_vidc_clocks.c + msm_smem.c`；默认判定：**部分迁移**。
- 文件级结论：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--24 | `chunk:1, file:start` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 25--25 | `d:HFI_MASK_QHDR_TX_TYPE` | `HFI_MASK_QHDR_TX_TYPE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 26--26 | `chunk:26, d:HFI_MASK_QHDR_RX_TYPE` | `HFI_MASK_QHDR_RX_TYPE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 27--27 | `d:HFI_MASK_QHDR_PRI_TYPE` | `HFI_MASK_QHDR_PRI_TYPE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 28--29 | `d:HFI_MASK_QHDR_ID_TYPE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 30--30 | `d:HFI_HOST_TO_CTRL_CMD_Q` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 31--31 | `d:HFI_CTRL_TO_HOST_MSG_Q` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 32--32 | `d:HFI_CTRL_TO_HOST_DBG_Q` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 33--34 | `d:HFI_MASK_QHDR_STATUS` | `HFI_MASK_QHDR_STATUS` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 35--35 | `d:IFACEQ_NUM` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 36--36 | `d:IFACEQ_CMD_IDX` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 37--37 | `d:IFACEQ_MSG_IDX` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 38--38 | `d:IFACEQ_DBG_IDX` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 39--39 | `d:IFACEQ_MAX_BUF_COUNT` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 40--40 | `d:IFACEQ_MAX_PARALLEL_CLNTS` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 41--42 | `d:IFACEQ_DFLT_QHDR` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 43--44 | `d:POLL_INTERVAL_US` | `POLL_INTERVAL_US` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 45--45 | `d:IFACEQ_MAX_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 46--46 | `d:IFACEQ_MED_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 47--47 | `d:IFACEQ_MIN_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 48--48 | `d:IFACEQ_VAR_SMALL_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 49--49 | `d:IFACEQ_VAR_LARGE_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 50--50 | `d:IFACEQ_VAR_HUGE_PKT_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 51--51 | `chunk:51` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 52--60 | `s:hfi_queue_table_header` | `hfi_queue_table_header` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 61--75 | `s:hfi_queue_header` | `hfi_queue_header` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 76--77 | `chunk:76` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 78--81 | `d:IFACEQ_TABLE_SIZE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 82--84 | `d:IFACEQ_QUEUE_SIZE` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 85--88 | `d:IFACEQ_GET_QHDR_START_ADDR` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 89--89 | `d:QDSS_SIZE` | `QDSS_SIZE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 90--90 | `d:SFR_SIZE` | `SFR_SIZE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 91--93 | `d:QUEUE_SIZE` | `QUEUE_SIZE` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 94--94 | `d:ALIGNED_QDSS_SIZE` | `ALIGNED_QDSS_SIZE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 95--95 | `d:ALIGNED_SFR_SIZE` | `ALIGNED_SFR_SIZE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 96--96 | `d:ALIGNED_QUEUE_SIZE` | `ALIGNED_QUEUE_SIZE` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 97--99 | `d:SHARED_QSIZE` | `SHARED_QSIZE` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 100--100 | `s:mem_desc` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 101--106 | `chunk:101` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 107--111 | `s:iface_queue` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 112--116 | `g:venus_state` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 117--125 | `s:venus_hfi_device` | `venus_hfi_device` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 126--137 | `chunk:126` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 138--138 | `v:venus_pkt_debug` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 139--139 | `v:venus_fw_debug` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 140--140 | `v:venus_fw_low_power_mode` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 141--141 | `v:venus_hw_rsp_timeout` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 142--142 | `v:venus_fw_coverage` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 143--146 | `v:venus_iris1_debug` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 147--150 | `f:venus_hfi_iris1_debug_enabled` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 151--151 | `chunk:151` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 152--154 | `f:venus_packet_name` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 155--156 | `switch:case HFI_CMD_SESSION_LOAD_RESOURCES` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 157--158 | `switch:case HFI_CMD_SESSION_START` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 159--160 | `switch:case HFI_CMD_SESSION_EMPTY_BUFFER` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 161--162 | `switch:case HFI_CMD_SESSION_FILL_BUFFER` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 163--164 | `switch:case HFI_CMD_SESSION_SET_PROPERTY` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 165--166 | `switch:case HFI_CMD_SESSION_GET_PROPERTY` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 167--168 | `switch:case HFI_CMD_SESSION_SET_BUFFERS` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 169--170 | `switch:case HFI_CMD_SESSION_RELEASE_BUFFERS` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 171--172 | `switch:case HFI_MSG_SESSION_LOAD_RESOURCES` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 173--174 | `switch:case HFI_MSG_SESSION_START` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 175--175 | `switch:case HFI_MSG_SESSION_EMPTY_BUFFER` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 176--176 | `chunk:176` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 177--178 | `switch:case HFI_MSG_SESSION_FILL_BUFFER` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 179--180 | `switch:case HFI_MSG_SESSION_PROPERTY_INFO` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 181--182 | `switch:case HFI_MSG_SESSION_RELEASE_BUFFERS` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 183--184 | `switch:case HFI_MSG_EVENT_NOTIFY` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 185--189 | `switch:default` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 190--200 | `f:venus_trace_packet` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 201--214 | `chunk:201` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 215--222 | `f:venus_set_state` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 223--225 | `f:venus_is_valid_state` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 226--228 | `chunk:226` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 229--250 | `f:venus_peek_debug_queue` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 251--272 | `chunk:251` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 273--275 | `f:venus_hfi_dump_state` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 276--300 | `chunk:276` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 301--314 | `chunk:301` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 315--325 | `f:venus_dump_packet` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 326--350 | `chunk:326, f:venus_write_queue` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 351--375 | `chunk:351` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 376--400 | `chunk:376` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 401--406 | `chunk:401` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 407--425 | `f:venus_read_queue` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 426--450 | `chunk:426` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 451--475 | `chunk:451` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 476--500 | `chunk:476` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 501--517 | `chunk:501` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 518--525 | `f:venus_alloc` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 526--533 | `chunk:526` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 534--540 | `f:venus_free` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 541--550 | `f:venus_set_registers` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 551--551 | `chunk:551` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 552--564 | `f:venus_soft_int` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 565--575 | `f:venus_iface_cmdq_write_nolock` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 576--600 | `chunk:576` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 601--609 | `chunk:601` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 610--620 | `f:venus_iface_cmdq_write` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 621--625 | `f:venus_hfi_core_set_resource` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 626--644 | `chunk:626` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 645--650 | `f:venus_hfi_core_set_syscache` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 651--675 | `chunk:651` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 676--678 | `chunk:676` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 679--700 | `f:venus_boot_core` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 701--725 | `chunk:701` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 726--730 | `chunk:726` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 731--749 | `f:venus_hwversion` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 750--750 | `f:venus_run` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 751--775 | `chunk:751` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 776--793 | `chunk:776` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 794--800 | `f:venus_halt_axi` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 801--823 | `chunk:801` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 824--825 | `label:skip_aon_mvp_noc` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 826--850 | `chunk:826` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 851--875 | `chunk:851` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 876--877 | `chunk:876` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 878--897 | `f:venus_power_off` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 898--900 | `f:venus_power_on` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 901--916 | `chunk:901` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 917--918 | `label:err_suspend` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 919--923 | `label:err` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 924--925 | `f:venus_iface_msgq_read_nolock` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 926--950 | `chunk:926` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 951--953 | `chunk:951` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 954--964 | `f:venus_iface_msgq_read` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 965--975 | `f:venus_iface_dbgq_read_nolock` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 976--987 | `chunk:976` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 988--1000 | `f:venus_set_qhdr_defaults` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1001--1003 | `chunk:1001` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1004--1017 | `f:venus_interface_queues_release` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1018--1025 | `f:venus_interface_queues_init` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1026--1050 | `chunk:1026` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1051--1075 | `chunk:1051` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1076--1085 | `chunk:1076` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1086--1097 | `f:venus_sys_set_debug` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1098--1100 | `f:venus_sys_set_coverage` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1101--1109 | `chunk:1101` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1110--1125 | `f:venus_sys_set_idle_message` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1126--1138 | `chunk:1126, f:venus_sys_set_power_control` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1139--1150 | `f:venus_sys_set_ubwc_config` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1151--1156 | `chunk:1151` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1157--1171 | `f:venus_get_queue_size` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1172--1175 | `f:venus_sys_set_default_properties` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1176--1200 | `chunk:1176` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1201--1205 | `chunk:1201` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1206--1215 | `f:venus_session_cmd` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1216--1225 | `f:venus_flush_debug_queue` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1226--1249 | `chunk:1226` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1250--1250 | `f:venus_prepare_power_collapse` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1251--1275 | `chunk:1251` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1276--1276 | `chunk:1276` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1277--1294 | `f:venus_are_queues_empty` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1295--1300 | `f:venus_sfr_print` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1301--1322 | `chunk:1301` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1323--1325 | `f:venus_process_msg_sys_error` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1326--1335 | `chunk:1326` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1336--1350 | `f:venus_isr_thread` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1351--1352 | `chunk:1351` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1353--1355 | `switch:case HFI_MSG_EVENT_NOTIFY` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1356--1361 | `switch:case HFI_MSG_SYS_INIT` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1362--1364 | `switch:case HFI_MSG_SYS_RELEASE_RESOURCE` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1365--1367 | `switch:case HFI_MSG_SYS_PC_PREP` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1368--1375 | `switch:default` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1376--1377 | `chunk:1376` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1378--1400 | `f:venus_isr` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1401--1418 | `chunk:1401` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1419--1425 | `f:venus_core_init` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1426--1450 | `chunk:1426` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1451--1453 | `chunk:1451` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1454--1464 | `f:venus_core_deinit` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1465--1475 | `f:venus_core_trigger_ssr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1476--1477 | `chunk:1476` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1478--1500 | `f:venus_session_init` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1501--1504 | `chunk:1501` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1505--1509 | `label:err` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1510--1522 | `f:venus_session_end` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1523--1525 | `f:venus_session_abort` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1526--1531 | `chunk:1526` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1532--1544 | `f:venus_session_flush` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1545--1549 | `f:venus_session_start` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1550--1550 | `f:venus_session_stop` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1551--1554 | `chunk:1551` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1555--1559 | `f:venus_session_continue` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1560--1575 | `f:venus_session_etb` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1576--1589 | `chunk:1576` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1590--1600 | `f:venus_session_ftb` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1601--1603 | `chunk:1601` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1604--1623 | `f:venus_session_set_buffers` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1624--1625 | `f:venus_session_unset_buffers` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1626--1643 | `chunk:1626` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1644--1648 | `f:venus_session_load_res` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1649--1650 | `f:venus_session_release_res` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1651--1653 | `chunk:1651` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1654--1674 | `f:venus_session_parse_seq_hdr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1675--1675 | `f:venus_session_get_seq_hdr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1676--1691 | `chunk:1676` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1692--1700 | `f:venus_session_set_property` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1701--1710 | `chunk:1701` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1711--1723 | `f:venus_session_get_property` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1724--1725 | `f:venus_resume` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1726--1735 | `chunk:1726` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1736--1749 | `label:unlock` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1750--1750 | `f:venus_suspend_1xx` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1751--1775 | `chunk:1751` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1776--1800 | `chunk:1776` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1801--1807 | `chunk:1801` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1808--1825 | `f:venus_cpu_and_video_core_idle` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1826--1827 | `chunk:1826` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1828--1847 | `f:venus_cpu_idle_and_pc_ready` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1848--1850 | `f:venus_suspend_3xx` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1851--1875 | `chunk:1851` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1876--1900 | `chunk:1876` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1901--1911 | `chunk:1901` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1912--1925 | `label:power_off` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1926--1931 | `chunk:1926` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1932--1939 | `f:venus_suspend` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1940--1940 | `v:venus_hfi_ops` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1941--1941 | `field:core_init` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1942--1942 | `field:core_deinit` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1943--1944 | `field:core_trigger_ssr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1945--1945 | `field:session_init` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1946--1946 | `field:session_end` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1947--1947 | `field:session_abort` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1948--1948 | `field:session_flush` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1949--1949 | `field:session_start` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1950--1950 | `field:session_stop` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1951--1951 | `chunk:1951, field:session_continue` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1952--1952 | `field:session_etb` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1953--1953 | `field:session_ftb` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1954--1954 | `field:session_set_buffers` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1955--1955 | `field:session_unset_buffers` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1956--1956 | `field:session_load_res` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1957--1957 | `field:session_release_res` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1958--1958 | `field:session_parse_seq_hdr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1959--1959 | `field:session_get_seq_hdr` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1960--1960 | `field:session_set_property` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1961--1962 | `field:session_get_property` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1963--1963 | `field:resume` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1964--1965 | `field:suspend` | `—` | IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。 |
| 1966--1966 | `field:isr` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1967--1969 | `field:isr_thread` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 1970--1975 | `f:venus_hfi_destroy` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1976--1981 | `chunk:1976` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 1982--2000 | `f:venus_hfi_create` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 2001--2006 | `chunk:2001` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 2007--2013 | `label:err_kfree` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 2014--2025 | `f:venus_hfi_queues_reinit` | `—` | queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。 |
| 2026--2050 | `chunk:2026` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |
| 2051--2063 | `chunk:2051` | `—` | 部分迁移：queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。 |

覆盖校验：2063/2063 行，连续、无空洞、无重叠。

## `hfi_venus.h`

- 当前物理行：16；原厂语义域：`venus_hfi.h`；默认判定：**语义拆分**。
- 文件级结论：设备/HFI 状态按主线 ownership 表达。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：设备/HFI 状态按主线 ownership 表达。 |
| 6--15 | `pp:ifndef` | `—` | 语义拆分：设备/HFI 状态按主线 ownership 表达。 |
| 16--16 | `pp:endif` | `—` | 语义拆分：设备/HFI 状态按主线 ownership 表达。 |

覆盖校验：16/16 行，连续、无空洞、无重叠。

## `hfi.c`

- 当前物理行：565；原厂语义域：`vidc_hfi.c + venus_hfi.c`；默认判定：**主线替代**。
- 文件级结论：HFI ops、状态机和 timeout；保持严格错误传播。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--18 | `chunk:1, file:start` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 19--20 | `d:TIMEOUT` | `TIMEOUT` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 21--25 | `f:hfi_core_init` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 26--49 | `chunk:26` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 50--50 | `label:unlock` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 51--54 | `chunk:51` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 55--75 | `f:hfi_core_deinit` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 76--85 | `chunk:76` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 86--90 | `label:unlock` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 91--98 | `f:hfi_core_suspend` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 99--100 | `f:hfi_core_resume` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 101--106 | `chunk:101` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 107--111 | `f:hfi_core_trigger_ssr` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 112--125 | `f:wait_session_msg` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 126--127 | `chunk:126` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 128--150 | `f:hfi_session_create` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 151--156 | `chunk:151` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 157--161 | `label:unlock` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 162--163 | `v:hfi_session_create` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 164--175 | `f:hfi_session_init` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 176--200 | `chunk:176` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 201--206 | `chunk:201` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 207--208 | `v:hfi_session_init` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 209--218 | `f:hfi_session_destroy` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 219--220 | `v:hfi_session_destroy` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 221--225 | `f:hfi_session_deinit` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 226--244 | `chunk:226` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 245--249 | `label:done` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 250--250 | `v:hfi_session_deinit` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 251--251 | `chunk:251` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 252--275 | `f:hfi_session_start` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 276--276 | `chunk:276` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 277--278 | `v:hfi_session_start` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 279--300 | `f:hfi_session_stop` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 301--303 | `chunk:301` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 304--305 | `v:hfi_session_stop` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 306--317 | `f:hfi_session_continue` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 318--319 | `v:hfi_session_continue` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 320--325 | `f:hfi_session_abort` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 326--339 | `chunk:326` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 340--341 | `v:hfi_session_abort` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 342--350 | `f:hfi_session_load_res` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 351--367 | `chunk:351` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 368--375 | `f:hfi_session_unload_res` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 376--399 | `chunk:376` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 400--400 | `v:hfi_session_unload_res` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 401--401 | `chunk:401` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 402--423 | `f:hfi_session_flush` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 424--425 | `v:hfi_session_flush` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 426--435 | `chunk:426, f:hfi_session_set_buffers` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 436--450 | `f:hfi_session_unset_buffers` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 451--460 | `chunk:451` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 461--475 | `f:hfi_session_get_property` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 476--495 | `chunk:476` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 496--497 | `v:hfi_session_get_property` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 498--500 | `f:hfi_session_set_property` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 501--509 | `chunk:501` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 510--511 | `v:hfi_session_set_property` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 512--525 | `f:hfi_session_process_buf` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 526--526 | `chunk:526` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 527--528 | `v:hfi_session_process_buf` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 529--535 | `f:hfi_isr_thread` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 536--542 | `f:hfi_isr` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 543--550 | `f:hfi_create` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 551--556 | `chunk:551` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 557--561 | `f:hfi_destroy` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |
| 562--565 | `f:hfi_reinit` | `—` | 主线替代：HFI ops、状态机和 timeout；保持严格错误传播。 |

覆盖校验：565/565 行，连续、无空洞、无重叠。

## `hfi.h`

- 当前物理行：176；原厂语义域：`vidc_hfi.h`；默认判定：**语义拆分**。
- 文件级结论：HFI ops/callback 按主线边界表达。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 6--25 | `pp:ifndef` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 26--50 | `chunk:26` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 51--75 | `chunk:51` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 76--100 | `chunk:76` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 101--125 | `chunk:101` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 126--150 | `chunk:126` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 151--175 | `chunk:151` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |
| 176--176 | `chunk:176, pp:endif` | `—` | 语义拆分：HFI ops/callback 按主线边界表达。 |

覆盖校验：176/176 行，连续、无空洞、无重叠。

## `Kconfig`

- 当前物理行：15；原厂语义域：`Kconfig/Makefile`；默认判定：**保留**。
- 文件级结论：主线驱动入口；不并存 Android 私有驱动。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--15 | `chunk:1, file:start` | `—` | 保留：主线驱动入口；不并存 Android 私有驱动。 |

覆盖校验：15/15 行，连续、无空洞、无重叠。

## `Makefile`

- 当前物理行：15；原厂语义域：`Kconfig/Makefile`；默认判定：**保留**。
- 文件级结论：主线 core/decoder/encoder 模块边界。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--15 | `chunk:1, file:start` | `—` | 保留：主线 core/decoder/encoder 模块边界。 |

覆盖校验：15/15 行，连续、无空洞、无重叠。

## `pm_helpers.c`

- 当前物理行：1996；原厂语义域：`msm_vidc_clocks.c + governors/msm_vidc_dyn_gov.c + governors/fixedpoint.h`；默认判定：**已实现、待实机**。
- 文件级结论：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--25 | `chunk:1, file:start` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 26--27 | `chunk:26, v:legacy_binding` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 28--42 | `f:core_clks_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 43--50 | `f:core_clks_enable` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 51--75 | `chunk:51` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 76--82 | `chunk:76, label:err` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 83--91 | `f:core_clks_disable` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 92--100 | `f:core_clks_set_rate` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 101--116 | `chunk:101` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 117--125 | `f:vcodec_clks_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 126--133 | `chunk:126` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 134--146 | `f:vcodec_clks_enable` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 147--150 | `label:err` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 151--153 | `chunk:151` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 154--162 | `f:vcodec_clks_disable` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 163--174 | `f:load_per_instance` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 175--175 | `f:load_per_type` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 176--189 | `chunk:176` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 190--200 | `f:mbs_to_bw` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 201--225 | `chunk:201` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 226--235 | `chunk:226` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 236--236 | `d:IRIS1_BW_MAX_KBPS` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 237--237 | `d:IRIS1_FP_SHIFT` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 238--238 | `d:IRIS1_FP_ONE` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 239--239 | `d:IRIS1_FP_INT` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 240--241 | `d:IRIS1_FP_CONST` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 242--246 | `s:iris1_bw_vote` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 247--250 | `s:iris1_bw_lut` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 251--254 | `chunk:251` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 255--269 | `v:iris1_bw_lut` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 270--274 | `f:iris1_fp_mul` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 275--275 | `f:iris1_fp_div` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 276--282 | `chunk:276` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 283--291 | `f:iris1_fp_ratio` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 292--300 | `f:iris1_fp_from_fw_q16` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 301--303 | `chunk:301` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 304--314 | `f:iris1_fp_mbps_to_kbps` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 315--325 | `f:iris1_find_bw_lut` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 326--328 | `chunk:326` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 329--334 | `f:iris1_fmt_ubwc` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 335--341 | `f:iris1_fmt_10bit` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 342--347 | `f:iris1_encoder_input_fmt` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 348--349 | `switch:case V4L2_PIX_FMT_P010` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 350--350 | `switch:case V4L2_PIX_FMT_QC08C` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 351--351 | `chunk:351` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 352--353 | `switch:case V4L2_PIX_FMT_QC10C` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 354--359 | `switch:default` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 360--375 | `f:iris1_dynamic_stats` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 376--391 | `chunk:376` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 392--400 | `f:iris1_input_payload` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 401--405 | `chunk:401` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 406--425 | `f:iris1_calculate_decoder_bw` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 426--450 | `chunk:426` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 451--475 | `chunk:451` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 476--497 | `chunk:476` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 498--500 | `f:iris1_calculate_encoder_bw` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 501--525 | `chunk:501` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 526--550 | `chunk:526` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 551--575 | `chunk:551` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 576--600 | `chunk:576` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 601--619 | `chunk:601` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 620--625 | `f:iris1_calculate_bw` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 626--629 | `chunk:626` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 630--650 | `f:load_scale_bw` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 651--675 | `chunk:651` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 676--700 | `chunk:676` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 701--704 | `chunk:701` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 705--725 | `f:load_scale_v1` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 726--734 | `chunk:726` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 735--750 | `label:set_freq` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 751--755 | `chunk:751, label:exit` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 756--770 | `f:core_get_v1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 771--774 | `f:core_put_v1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 775--775 | `f:core_power_v1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 776--786 | `chunk:776` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 787--787 | `v:pm_ops_v1` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 788--788 | `field:core_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 789--789 | `field:core_put` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 790--790 | `field:core_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 791--794 | `field:load_scale` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 795--800 | `f:vcodec_control_v3` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 801--809 | `chunk:801` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 810--817 | `f:vdec_get_v3` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 818--825 | `f:vdec_power_v3` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 826--834 | `chunk:826` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 835--842 | `f:venc_get_v3` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 843--850 | `f:venc_power_v3` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 851--859 | `chunk:851` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 860--860 | `v:pm_ops_v3` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 861--861 | `field:core_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 862--862 | `field:core_put` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 863--863 | `field:core_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 864--864 | `field:vdec_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 865--865 | `field:vdec_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 866--866 | `field:venc_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 867--867 | `field:venc_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 868--870 | `field:load_scale` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 871--875 | `f:vcodec_control_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 876--885 | `chunk:876` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 886--900 | `label:legacy` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 901--911 | `chunk:901` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 912--925 | `f:poweroff_coreid` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 926--950 | `chunk:926` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 951--954 | `chunk:951` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 955--975 | `f:poweron_coreid` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 976--997 | `chunk:976` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 998--1000 | `f:power_save_mode_enable` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1001--1024 | `chunk:1001` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1025--1025 | `f:move_core_to_power_save_mode` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1026--1040 | `chunk:1026` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1041--1050 | `f:min_loaded_core` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1051--1075 | `chunk:1051` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1076--1096 | `chunk:1076` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1097--1100 | `f:decide_core` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1101--1125 | `chunk:1101` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1126--1150 | `chunk:1126` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1151--1163 | `chunk:1151` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1164--1171 | `label:done` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1172--1175 | `f:acquire_core` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1176--1198 | `chunk:1176` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1199--1200 | `f:release_core` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1201--1225 | `chunk:1201` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1226--1231 | `chunk:1226, label:done` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1232--1250 | `f:coreid_power_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1251--1256 | `chunk:1251` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1257--1267 | `f:vdec_get_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1268--1275 | `f:vdec_put_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1276--1279 | `chunk:1276` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1280--1300 | `f:vdec_power_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1301--1301 | `chunk:1301` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1302--1312 | `f:venc_get_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1313--1324 | `f:venc_put_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1325--1325 | `f:venc_power_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1326--1346 | `chunk:1326` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1347--1350 | `f:vcodec_domains_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1351--1352 | `chunk:1351` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1353--1353 | `field:pd_names` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1354--1354 | `field:num_pd_names` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1355--1357 | `field:pd_flags` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1358--1358 | `field:pd_names` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1359--1359 | `field:num_pd_names` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1360--1369 | `field:pd_flags` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1370--1375 | `label:skip_pmdomains` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1376--1381 | `chunk:1376` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1382--1400 | `f:core_resets_reset` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1401--1420 | `chunk:1401` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1421--1423 | `label:err` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1424--1425 | `label:err_deassert` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1426--1430 | `chunk:1426` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1431--1450 | `f:core_resets_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1451--1452 | `chunk:1451` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1453--1475 | `f:core_get_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1476--1500 | `chunk:1476` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1501--1512 | `chunk:1501` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1513--1525 | `f:iris1_llcc_disable` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1526--1531 | `chunk:1526` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1532--1550 | `f:iris1_llcc_enable` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1551--1562 | `chunk:1551, f:iris1_llcc_put` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1563--1575 | `f:core_get_iris1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1576--1592 | `chunk:1576` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1593--1598 | `label:err_llcc` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1599--1600 | `f:core_put_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1601--1602 | `chunk:1601` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1603--1625 | `f:core_power_v4` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1626--1649 | `chunk:1626` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1650--1650 | `f:iris1_power_off` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1651--1675 | `chunk:1651` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1676--1696 | `chunk:1676` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1697--1700 | `f:core_power_iris1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1701--1725 | `chunk:1701` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1726--1750 | `chunk:1726` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1751--1775 | `chunk:1751` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1776--1784 | `chunk:1776` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1785--1791 | `label:err` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1792--1800 | `f:core_put_iris1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1801--1803 | `chunk:1801` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1804--1825 | `f:coreid_power_iris1` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1826--1832 | `chunk:1826` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1833--1850 | `f:calculate_inst_freq` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1851--1869 | `chunk:1851` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1870--1875 | `f:load_scale_v4` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1876--1900 | `chunk:1876` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1901--1925 | `chunk:1901` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1926--1935 | `chunk:1926` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1936--1950 | `label:set_freq` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1951--1951 | `chunk:1951` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1952--1956 | `label:exit` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1957--1957 | `v:pm_ops_v4` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1958--1958 | `field:core_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1959--1959 | `field:core_put` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1960--1960 | `field:core_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1961--1961 | `field:vdec_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1962--1962 | `field:vdec_put` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1963--1963 | `field:vdec_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1964--1964 | `field:venc_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1965--1965 | `field:venc_put` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1966--1966 | `field:venc_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1967--1967 | `field:coreid_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1968--1970 | `field:load_scale` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1971--1971 | `v:pm_ops_iris1` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1972--1972 | `field:core_get` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1973--1973 | `field:core_put` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1974--1974 | `field:core_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1975--1975 | `field:coreid_power` | `—` | PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。 |
| 1976--1978 | `chunk:1976, field:load_scale` | `—` | 资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。 |
| 1979--1984 | `f:venus_pm_get` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1985--1985 | `switch:case HFI_VERSION_1XX` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1986--1987 | `switch:default` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1988--1989 | `switch:case HFI_VERSION_3XX` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1990--1990 | `switch:case HFI_VERSION_4XX` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |
| 1991--1996 | `switch:case HFI_VERSION_6XX` | `—` | 已实现、待实机：0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。 |

覆盖校验：1996/1996 行，连续、无空洞、无重叠。

## `pm_helpers.h`

- 当前物理行：66；原厂语义域：`msm_vidc_clocks.h`；默认判定：**主线替代**。
- 文件级结论：PM 接口按 clock/reset/pd/icc 框架。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--2 | `chunk:1, file:start` | `—` | 主线替代：PM 接口按 clock/reset/pd/icc 框架。 |
| 3--25 | `pp:ifndef` | `—` | 主线替代：PM 接口按 clock/reset/pd/icc 框架。 |
| 26--50 | `chunk:26` | `—` | 主线替代：PM 接口按 clock/reset/pd/icc 框架。 |
| 51--65 | `chunk:51` | `—` | 主线替代：PM 接口按 clock/reset/pd/icc 框架。 |
| 66--66 | `pp:endif` | `—` | 主线替代：PM 接口按 clock/reset/pd/icc 框架。 |

覆盖校验：66/66 行，连续、无空洞、无重叠。

## `vdec_ctrls.c`

- 当前物理行：200；原厂语义域：`msm_vdec.c + msm_v4l2_private.c`；默认判定：**选择性迁移**。
- 文件级结论：标准 controls 优先；能力必须由 firmware 过滤。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--12 | `chunk:1, file:start` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 13--18 | `f:vdec_op_s_ctrl` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 19--21 | `switch:case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 22--22 | `switch:case V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 23--23 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 24--24 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 25--25 | `switch:case V4L2_CID_MPEG_VIDEO_VP8_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 26--28 | `chunk:26, switch:case V4L2_CID_MPEG_VIDEO_VP9_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 29--29 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 30--30 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 31--33 | `switch:case V4L2_CID_MPEG_VIDEO_VP9_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 34--36 | `switch:case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 37--39 | `switch:case V4L2_CID_MPEG_VIDEO_DEC_DISPLAY_DELAY_ENABLE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 40--42 | `switch:case V4L2_CID_MPEG_VIDEO_DEC_CONCEAL_COLOR` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 43--49 | `switch:default` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 50--50 | `f:vdec_op_g_volatile_ctrl` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 51--59 | `chunk:51` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 60--60 | `switch:case V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 61--61 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 62--62 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 63--63 | `switch:case V4L2_CID_MPEG_VIDEO_VP8_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 64--69 | `switch:case V4L2_CID_MPEG_VIDEO_VP9_PROFILE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 70--70 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 71--71 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 72--75 | `switch:case V4L2_CID_MPEG_VIDEO_VP9_LEVEL` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 76--77 | `chunk:76` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 78--80 | `switch:case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 81--85 | `switch:case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 86--92 | `switch:default` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 93--93 | `v:vdec_ctrl_ops` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 94--94 | `field:s_ctrl` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 95--97 | `field:g_volatile_ctrl` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 98--100 | `f:vdec_ctrl_init` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 101--125 | `chunk:101` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 126--150 | `chunk:126` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 151--175 | `chunk:151` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |
| 176--200 | `chunk:176` | `—` | decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。 |

覆盖校验：200/200 行，连续、无空洞、无重叠。

## `vdec.c`

- 当前物理行：2041；原厂语义域：`msm_vdec.c + msm_vidc_common.c`；默认判定：**部分迁移**。
- 文件级结论：H264/Main8 已过；Main10/P010 约束与协商已静态补齐、待实机闭环，其余矩阵/metadata 未覆盖。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--25 | `chunk:1, file:start` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 26--31 | `chunk:26` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 32--33 | `v:vdec_formats` | `vdec_formats` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 34--34 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 35--35 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 36--38 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 39--39 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 40--40 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 41--43 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 44--44 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 45--45 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 46--48 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 49--49 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 50--50 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 51--53 | `chunk:51, field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 54--54 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 55--55 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 56--56 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 57--59 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 60--60 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 61--61 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 62--62 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 63--65 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 66--66 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 67--67 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 68--68 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 69--71 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 72--72 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 73--73 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 74--74 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 75--75 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 76--77 | `chunk:76` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 78--78 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 79--79 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 80--80 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 81--83 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 84--84 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 85--85 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 86--86 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 87--89 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 90--90 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 91--91 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 92--92 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 93--95 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 96--96 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 97--97 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 98--98 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 99--100 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 101--101 | `chunk:101` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 102--102 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 103--103 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 104--104 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 105--107 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 108--108 | `field:pixfmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 109--109 | `field:num_planes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 110--110 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 111--115 | `field:flags` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 116--121 | `f:vdec_fmt_is_8bit` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 122--125 | `f:vdec_fmt_is_10bit` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 126--127 | `chunk:126` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 128--139 | `f:vdec_get_framesz` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 140--150 | `f:vdec_get_framesz_raw` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 151--175 | `chunk:151, f:vdec_format_is_valid` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 176--184 | `chunk:176` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 185--200 | `f:find_format` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 201--202 | `chunk:201` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 203--225 | `f:find_format_by_index` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 226--227 | `chunk:226` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 228--250 | `f:vdec_try_fmt_common` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 251--275 | `chunk:251` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 276--297 | `chunk:276` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 298--300 | `f:vdec_try_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 301--316 | `chunk:301` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 317--325 | `f:vdec_check_src_change` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 326--346 | `chunk:326` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 347--350 | `label:done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 351--375 | `chunk:351, f:vdec_g_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 376--397 | `chunk:376` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 398--400 | `f:vdec_s_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 401--425 | `chunk:401` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 426--450 | `chunk:426` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 451--475 | `chunk:451` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 476--485 | `chunk:476` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 486--497 | `f:vdec_g_selection` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 498--498 | `switch:case V4L2_SEL_TGT_CROP_BOUNDS` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 499--499 | `switch:case V4L2_SEL_TGT_CROP_DEFAULT` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 500--500 | `switch:case V4L2_SEL_TGT_CROP` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 501--505 | `chunk:501` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 506--506 | `switch:case V4L2_SEL_TGT_COMPOSE_BOUNDS` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 507--512 | `switch:case V4L2_SEL_TGT_COMPOSE_PADDED` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 513--513 | `switch:case V4L2_SEL_TGT_COMPOSE_DEFAULT` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 514--518 | `switch:case V4L2_SEL_TGT_COMPOSE` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 519--525 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 526--526 | `chunk:526` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 527--539 | `f:vdec_querycap` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 540--550 | `f:vdec_enum_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 551--556 | `chunk:551` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 557--575 | `f:vdec_s_parm` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 576--588 | `chunk:576` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 589--600 | `f:vdec_enum_framesizes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 601--618 | `chunk:601` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 619--625 | `f:vdec_subscribe_event` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 626--627 | `chunk:626, switch:case V4L2_EVENT_EOS` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 628--633 | `switch:case V4L2_EVENT_SOURCE_CHANGE` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 634--635 | `switch:case V4L2_EVENT_CTRL` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 636--641 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 642--650 | `f:vdec_decoder_cmd` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 651--675 | `chunk:651` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 676--690 | `chunk:676` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 691--695 | `label:unlock` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 696--696 | `v:vdec_ioctl_ops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 697--697 | `field:vidioc_querycap` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 698--698 | `field:vidioc_enum_fmt_vid_cap` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 699--699 | `field:vidioc_enum_fmt_vid_out` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 700--700 | `field:vidioc_s_fmt_vid_cap_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 701--701 | `chunk:701, field:vidioc_s_fmt_vid_out_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 702--702 | `field:vidioc_g_fmt_vid_cap_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 703--703 | `field:vidioc_g_fmt_vid_out_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 704--704 | `field:vidioc_try_fmt_vid_cap_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 705--705 | `field:vidioc_try_fmt_vid_out_mplane` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 706--706 | `field:vidioc_g_selection` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 707--707 | `field:vidioc_reqbufs` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 708--708 | `field:vidioc_querybuf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 709--709 | `field:vidioc_create_bufs` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 710--710 | `field:vidioc_prepare_buf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 711--711 | `field:vidioc_qbuf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 712--712 | `field:vidioc_expbuf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 713--713 | `field:vidioc_dqbuf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 714--714 | `field:vidioc_streamon` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 715--715 | `field:vidioc_streamoff` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 716--716 | `field:vidioc_s_parm` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 717--717 | `field:vidioc_enum_framesizes` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 718--718 | `field:vidioc_subscribe_event` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 719--719 | `field:vidioc_unsubscribe_event` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 720--720 | `field:vidioc_try_decoder_cmd` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 721--723 | `field:vidioc_decoder_cmd` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 724--725 | `f:vdec_pm_get` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 726--736 | `chunk:726` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 737--750 | `f:vdec_pm_put` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 751--754 | `chunk:751` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 755--770 | `f:vdec_pm_get_put` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 771--775 | `label:error` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 776--776 | `chunk:776` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 777--781 | `f:vdec_pm_touch` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 782--800 | `f:vdec_set_properties` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 801--823 | `chunk:801` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 824--825 | `f:vdec_set_work_route` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 826--839 | `chunk:826` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 840--840 | `d:is_ubwc_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 841--844 | `d:is_10bit_ubwc_fmt` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 845--850 | `f:vdec_output_conf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 851--875 | `chunk:851` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 876--900 | `chunk:876` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 901--925 | `chunk:901` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 926--950 | `chunk:926` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 951--968 | `chunk:951` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 969--975 | `f:vdec_session_init` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 976--984 | `chunk:976` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 985--989 | `label:deinit` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 990--1000 | `f:vdec_num_buffers` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1001--1013 | `chunk:1001` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1014--1025 | `f:vdec_queue_setup` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1026--1050 | `chunk:1026` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1051--1075 | `chunk:1051` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1076--1083 | `chunk:1076` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1084--1093 | `switch:case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1094--1100 | `switch:case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1101--1111 | `chunk:1101` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1112--1118 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1119--1123 | `label:put_power` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1124--1125 | `f:vdec_verify_conf` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1126--1150 | `chunk:1126` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1151--1170 | `chunk:1151, f:vdec_start_capture` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1171--1175 | `label:reconfigure` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1176--1200 | `chunk:1176` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1201--1216 | `chunk:1201` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1217--1218 | `label:free_dpb_bufs` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1219--1222 | `label:err` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1223--1225 | `f:vdec_start_output` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1226--1250 | `chunk:1226` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1251--1275 | `chunk:1251` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1276--1300 | `chunk:1276` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1301--1301 | `chunk:1301` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1302--1306 | `label:done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1307--1325 | `f:vdec_start_streaming` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1326--1337 | `chunk:1326` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1338--1339 | `label:put_power` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1340--1345 | `label:error` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1346--1350 | `f:vdec_cancel_dst_buffers` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1351--1353 | `chunk:1351` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1354--1358 | `f:vdec_stop_capture` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1359--1361 | `switch:case VENUS_DEC_STATE_DECODING` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1362--1365 | `switch:case VENUS_DEC_STATE_DRAIN` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1366--1368 | `switch:case VENUS_DEC_STATE_SEEK` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1369--1373 | `switch:case VENUS_DEC_STATE_DRC` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1374--1375 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1376--1380 | `chunk:1376` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1381--1385 | `f:vdec_stop_output` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1386--1386 | `switch:case VENUS_DEC_STATE_DECODING` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1387--1387 | `switch:case VENUS_DEC_STATE_DRAIN` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1388--1388 | `switch:case VENUS_DEC_STATE_STOPPED` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1389--1392 | `switch:case VENUS_DEC_STATE_DRC` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1393--1393 | `switch:case VENUS_DEC_STATE_INIT` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1394--1396 | `switch:case VENUS_DEC_STATE_CAPTURE_SETUP` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1397--1400 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1401--1403 | `chunk:1401` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1404--1425 | `f:vdec_stop_streaming` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1426--1429 | `chunk:1426` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1430--1433 | `label:unlock` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1434--1450 | `f:vdec_session_release` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1451--1469 | `chunk:1451` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1470--1475 | `f:vdec_buf_init` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1476--1493 | `chunk:1476` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1494--1500 | `f:vdec_buf_cleanup` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1501--1510 | `chunk:1501` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1511--1525 | `f:vdec_vb2_buf_queue` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1526--1537 | `chunk:1526` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1538--1538 | `v:vdec_vb2_ops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1539--1539 | `field:queue_setup` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1540--1540 | `field:buf_init` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1541--1541 | `field:buf_cleanup` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1542--1542 | `field:buf_prepare` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1543--1543 | `field:start_streaming` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1544--1544 | `field:stop_streaming` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1545--1547 | `field:buf_queue` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1548--1550 | `f:vdec_buf_done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1551--1575 | `chunk:1551` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1576--1600 | `chunk:1576` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1601--1619 | `chunk:1601` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1620--1623 | `f:vdec_event_change` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1624--1625 | `field:type` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1626--1650 | `chunk:1626` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1651--1675 | `chunk:1651` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1676--1686 | `chunk:1676` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1687--1689 | `switch:case VENUS_DEC_STATE_INIT` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1690--1690 | `switch:case VENUS_DEC_STATE_DECODING` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1691--1693 | `switch:case VENUS_DEC_STATE_DRAIN` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1694--1700 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1701--1721 | `chunk:1701` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1722--1725 | `f:vdec_event_notify` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1726--1730 | `chunk:1726` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1731--1735 | `switch:case EVT_SESSION_ERROR` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1736--1737 | `switch:case EVT_SYS_EVENT_CHANGE` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1738--1740 | `switch:case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1741--1743 | `switch:case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1744--1746 | `switch:case HFI_EVENT_RELEASE_BUFFER_REFERENCE` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1747--1750 | `switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1751--1755 | `chunk:1751, switch:default` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1756--1760 | `f:vdec_flush_done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1761--1761 | `v:vdec_hfi_ops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1762--1762 | `field:buf_done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1763--1763 | `field:event_notify` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1764--1766 | `field:flush_done` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1767--1775 | `f:vdec_inst_init` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1776--1786 | `chunk:1776` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1787--1790 | `f:vdec_m2m_device_run` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1791--1791 | `v:vdec_m2m_ops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1792--1792 | `field:device_run` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1793--1795 | `field:job_abort` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1796--1800 | `f:m2m_queue_init` | `—` | decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。 |
| 1801--1825 | `chunk:1801` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1826--1830 | `chunk:1826` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1831--1850 | `f:vdec_open` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1851--1875 | `chunk:1851` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1876--1897 | `chunk:1876` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1898--1899 | `label:err_m2m_ctx_release` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1900--1900 | `label:err_m2m_dev_release` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1901--1901 | `chunk:1901` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1902--1903 | `label:err_ctrl_deinit` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1904--1908 | `label:err_free` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1909--1922 | `f:vdec_close` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1923--1923 | `v:vdec_fops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1924--1924 | `field:owner` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1925--1925 | `field:open` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1926--1926 | `chunk:1926, field:release` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1927--1927 | `field:unlocked_ioctl` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1928--1928 | `field:poll` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1929--1931 | `field:mmap` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1932--1950 | `f:vdec_probe` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1951--1975 | `chunk:1951` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1976--1976 | `chunk:1976` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1977--1981 | `label:err_vdev_release` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1982--1992 | `f:vdec_remove` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 1993--2000 | `f:vdec_runtime_suspend` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2001--2004 | `chunk:2001` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2005--2016 | `f:vdec_runtime_resume` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2017--2022 | `v:vdec_pm_ops` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2023--2025 | `v:vdec_dt_match` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2026--2028 | `chunk:2026` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2029--2029 | `v:qcom_venus_dec_driver` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2030--2030 | `field:probe` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2031--2031 | `field:remove` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2032--2032 | `field:driver` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2033--2033 | `field:name` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2034--2034 | `field:of_match_table` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2035--2037 | `field:pm` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |
| 2038--2041 | `v:qcom_venus_dec_driver` | `—` | decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。 |

覆盖校验：2041/2041 行，连续、无空洞、无重叠。

## `vdec.h`

- 当前物理行：13；原厂语义域：`msm_vdec.h`；默认判定：**主线替代**。
- 文件级结论：decoder 声明按 V4L2 M2M。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 主线替代：decoder 声明按 V4L2 M2M。 |
| 6--12 | `pp:ifndef` | `—` | 主线替代：decoder 声明按 V4L2 M2M。 |
| 13--13 | `pp:endif` | `—` | 主线替代：decoder 声明按 V4L2 M2M。 |

覆盖校验：13/13 行，连续、无空洞、无重叠。

## `venc_ctrls.c`

- 当前物理行：773；原厂语义域：`msm_venc.c + msm_v4l2_private.c`；默认判定：**选择性迁移**。
- 文件级结论：标准 encoder controls 与 HFI4 属性逐项映射。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--12 | `chunk:1, file:start` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 13--13 | `d:BITRATE_MIN` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 14--14 | `d:BITRATE_MAX` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 15--15 | `d:BITRATE_DEFAULT` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 16--16 | `d:BITRATE_DEFAULT_PEAK` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 17--17 | `d:BITRATE_STEP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 18--18 | `d:SLICE_BYTE_SIZE_MAX` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 19--19 | `d:SLICE_BYTE_SIZE_MIN` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 20--20 | `d:SLICE_MB_SIZE_MAX` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 21--22 | `d:AT_SLICE_BOUNDARY` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 23--24 | `d:MAX_LTR_FRAME_COUNT` | `MAX_LTR_FRAME_COUNT` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 25--25 | `f:venc_calc_bpframes` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 26--50 | `chunk:26` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 51--69 | `chunk:51` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 70--75 | `f:dynamic_bitrate_update` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 76--86 | `chunk:76` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 87--98 | `f:venc_op_s_ctrl` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 99--100 | `switch:case V4L2_CID_MPEG_VIDEO_BITRATE_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 101--101 | `chunk:101` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 102--109 | `switch:case V4L2_CID_MPEG_VIDEO_BITRATE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 110--112 | `switch:case V4L2_CID_MPEG_VIDEO_BITRATE_PEAK` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 113--115 | `switch:case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 116--118 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 119--121 | `switch:case V4L2_CID_MPEG_VIDEO_H264_PROFILE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 122--124 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_PROFILE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 125--125 | `switch:case V4L2_CID_MPEG_VIDEO_VP8_PROFILE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 126--127 | `chunk:126` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 128--130 | `switch:case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 131--133 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LEVEL` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 134--136 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 137--139 | `switch:case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 140--142 | `switch:case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 143--145 | `switch:case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 146--148 | `switch:case V4L2_CID_MPEG_VIDEO_H264_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 149--150 | `switch:case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 151--151 | `chunk:151` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 152--154 | `switch:case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 155--157 | `switch:case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 158--160 | `switch:case V4L2_CID_MPEG_VIDEO_H264_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 161--163 | `switch:case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 164--166 | `switch:case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 167--169 | `switch:case V4L2_CID_MPEG_VIDEO_H264_B_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 170--172 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 173--175 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 176--178 | `chunk:176, switch:case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 179--181 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 182--184 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 185--187 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 188--190 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 191--193 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 194--196 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 197--199 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 200--200 | `switch:case V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 201--202 | `chunk:201` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 203--205 | `switch:case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 206--208 | `switch:case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 209--211 | `switch:case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 212--214 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 215--217 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 218--220 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 221--225 | `switch:case V4L2_CID_MPEG_VIDEO_HEADER_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 226--237 | `chunk:226` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 238--245 | `switch:case V4L2_CID_MPEG_VIDEO_GOP_SIZE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 246--248 | `switch:case V4L2_CID_MPEG_VIDEO_H264_I_PERIOD` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 249--250 | `switch:case V4L2_CID_MPEG_VIDEO_VPX_MIN_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 251--251 | `chunk:251` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 252--254 | `switch:case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 255--262 | `switch:case V4L2_CID_MPEG_VIDEO_B_FRAMES` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 263--275 | `switch:case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 276--278 | `chunk:276, switch:case V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 279--281 | `switch:case V4L2_CID_MPEG_VIDEO_CONSTANT_QUALITY` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 282--284 | `switch:case V4L2_CID_MPEG_VIDEO_FRAME_SKIP_MODE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 285--287 | `switch:case V4L2_CID_MPEG_VIDEO_BASELAYER_PRIORITY_ID` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 288--290 | `switch:case V4L2_CID_MPEG_VIDEO_AU_DELIMITER` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 291--293 | `switch:case V4L2_CID_MPEG_VIDEO_LTR_COUNT` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 294--300 | `switch:case V4L2_CID_MPEG_VIDEO_FRAME_LTR_INDEX` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 301--306 | `chunk:301` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 307--321 | `switch:case V4L2_CID_MPEG_VIDEO_USE_LTR_FRAMES` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 322--324 | `switch:case V4L2_CID_COLORIMETRY_HDR10_CLL_INFO` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 325--325 | `switch:case V4L2_CID_COLORIMETRY_HDR10_MASTERING_DISPLAY` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 326--327 | `chunk:326` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 328--330 | `switch:case V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD_TYPE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 331--333 | `switch:case V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_PERIOD` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 334--350 | `switch:case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 351--351 | `chunk:351` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 352--355 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 356--358 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 359--363 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 364--369 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L0_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 370--375 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L1_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 376--381 | `chunk:376, switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L2_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 382--387 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L3_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 388--393 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L4_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 394--400 | `switch:case V4L2_CID_MPEG_VIDEO_H264_HIER_CODING_L5_BR` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 401--407 | `chunk:401, switch:default` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 408--415 | `f:venc_op_g_volatile_ctrl` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 416--425 | `switch:case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 426--429 | `chunk:426` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 430--436 | `switch:default` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 437--437 | `v:venc_ctrl_ops` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 438--438 | `field:s_ctrl` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 439--441 | `field:g_volatile_ctrl` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 442--450 | `f:venc_ctrl_init` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 451--475 | `chunk:451` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 476--500 | `chunk:476` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 501--525 | `chunk:501` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 526--550 | `chunk:526` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 551--575 | `chunk:551` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 576--600 | `chunk:576` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 601--625 | `chunk:601` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 626--650 | `chunk:626` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 651--675 | `chunk:651` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 676--700 | `chunk:676` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 701--725 | `chunk:701` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 726--750 | `chunk:726` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 751--769 | `chunk:751` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |
| 770--773 | `label:err` | `—` | encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。 |

覆盖校验：773/773 行，连续、无空洞、无重叠。

## `venc.c`

- 当前物理行：2068；原厂语义域：`msm_venc.c + msm_vidc_common.c + msm_smem.c`；默认判定：**部分迁移**。
- 文件级结论：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--24 | `chunk:1, file:start` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 25--25 | `d:NUM_B_FRAMES_MAX` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 26--27 | `chunk:26, d:VENUS_IRIS1_AUTO_QP` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 28--32 | `v:venus_iris1_encoder_enable` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 33--37 | `v:venus_iris1_encoder_stage` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 38--43 | `v:venus_iris1_encoder_vendor_nv12` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 44--50 | `v:venus_iris1_encoder_bidirectional` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 51--56 | `chunk:51` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 57--58 | `v:venc_formats` | `venc_formats` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 59--59 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 60--60 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 61--63 | `field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 64--64 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 65--65 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 66--68 | `field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 69--69 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 70--70 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 71--73 | `field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 74--74 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 75--75 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 76--78 | `chunk:76, field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 79--79 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 80--80 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 81--83 | `field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 84--84 | `field:pixfmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 85--85 | `field:num_planes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 86--90 | `field:type` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 91--100 | `f:find_format` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 101--112 | `chunk:101` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 113--125 | `f:find_format_by_index` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 126--140 | `chunk:126` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 141--143 | `f:venc_v4l2_to_hfi` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 144--145 | `switch:case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 146--146 | `switch:case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 147--148 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 149--150 | `switch:case V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 151--151 | `chunk:151` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 152--153 | `switch:case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 154--154 | `switch:case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 155--156 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 157--158 | `switch:case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 159--167 | `switch:case V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 168--175 | `f:venc_querycap` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 176--180 | `chunk:176` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 181--197 | `f:venc_enum_fmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 198--200 | `f:venc_get_framesz` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 201--218 | `chunk:201` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 219--225 | `f:venc_try_fmt_common` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 226--250 | `chunk:226` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 251--269 | `chunk:251` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 270--275 | `f:venc_try_fmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 276--278 | `chunk:276` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 279--300 | `f:venc_s_fmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 301--325 | `chunk:301` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 326--348 | `chunk:326` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 349--350 | `f:venc_g_fmt` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 351--375 | `chunk:351` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 376--381 | `chunk:376` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 382--389 | `f:venc_g_selection` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 390--390 | `switch:case V4L2_SEL_TGT_CROP_DEFAULT` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 391--394 | `switch:case V4L2_SEL_TGT_CROP_BOUNDS` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 395--398 | `switch:case V4L2_SEL_TGT_CROP` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 399--400 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 401--409 | `chunk:401` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 410--424 | `f:venc_s_selection` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 425--425 | `switch:case V4L2_SEL_TGT_CROP` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 426--430 | `chunk:426` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 431--437 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 438--450 | `f:venc_s_parm` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 451--470 | `chunk:451` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 471--475 | `f:venc_g_parm` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 476--484 | `chunk:476` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 485--500 | `f:venc_enum_framesizes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 501--514 | `chunk:501` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 515--525 | `f:venc_enum_frameintervals` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 526--550 | `chunk:526` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 551--559 | `chunk:551` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 560--563 | `f:venc_subscribe_event` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 564--565 | `switch:case V4L2_EVENT_EOS` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 566--567 | `switch:case V4L2_EVENT_CTRL` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 568--573 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 574--575 | `f:venc_encoder_cmd` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 576--600 | `chunk:576` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 601--612 | `chunk:601` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 613--617 | `label:unlock` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 618--618 | `v:venc_ioctl_ops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 619--619 | `field:vidioc_querycap` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 620--620 | `field:vidioc_enum_fmt_vid_cap` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 621--621 | `field:vidioc_enum_fmt_vid_out` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 622--622 | `field:vidioc_s_fmt_vid_cap_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 623--623 | `field:vidioc_s_fmt_vid_out_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 624--624 | `field:vidioc_g_fmt_vid_cap_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 625--625 | `field:vidioc_g_fmt_vid_out_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 626--626 | `chunk:626, field:vidioc_try_fmt_vid_cap_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 627--627 | `field:vidioc_try_fmt_vid_out_mplane` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 628--628 | `field:vidioc_g_selection` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 629--629 | `field:vidioc_s_selection` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 630--630 | `field:vidioc_reqbufs` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 631--631 | `field:vidioc_querybuf` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 632--632 | `field:vidioc_create_bufs` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 633--633 | `field:vidioc_prepare_buf` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 634--634 | `field:vidioc_qbuf` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 635--635 | `field:vidioc_expbuf` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 636--636 | `field:vidioc_dqbuf` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 637--637 | `field:vidioc_streamon` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 638--638 | `field:vidioc_streamoff` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 639--639 | `field:vidioc_s_parm` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 640--640 | `field:vidioc_g_parm` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 641--641 | `field:vidioc_enum_framesizes` | `—` | encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。 |
| 642--642 | `field:vidioc_enum_frameintervals` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 643--643 | `field:vidioc_subscribe_event` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 644--644 | `field:vidioc_unsubscribe_event` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 645--645 | `field:vidioc_try_encoder_cmd` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 646--648 | `field:vidioc_encoder_cmd` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 649--650 | `f:venc_pm_get` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 651--661 | `chunk:651` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 662--675 | `f:venc_pm_put` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 676--679 | `chunk:676` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 680--695 | `f:venc_pm_get_put` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 696--700 | `label:error` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 701--701 | `chunk:701` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 702--706 | `f:venc_pm_touch` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 707--725 | `f:venc_set_properties` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 726--750 | `chunk:726` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 751--775 | `chunk:751` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 776--800 | `chunk:776` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 801--825 | `chunk:801` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 826--850 | `chunk:826` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 851--875 | `chunk:851` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 876--900 | `chunk:876` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 901--925 | `chunk:901` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 926--950 | `chunk:926` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 951--975 | `chunk:951` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 976--1000 | `chunk:976` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1001--1025 | `chunk:1001` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1026--1050 | `chunk:1026` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1051--1063 | `chunk:1051` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1064--1067 | `switch:case HFI_VIDEO_CODEC_H264` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1068--1071 | `switch:case HFI_VIDEO_CODEC_MPEG4` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1072--1075 | `switch:case HFI_VIDEO_CODEC_VP8` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1076--1079 | `chunk:1076, switch:case HFI_VIDEO_CODEC_VP9` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1080--1083 | `switch:case HFI_VIDEO_CODEC_HEVC` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1084--1084 | `switch:case HFI_VIDEO_CODEC_MPEG2` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1085--1100 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1101--1125 | `chunk:1101` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1126--1140 | `chunk:1126` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1141--1150 | `f:venc_init_session` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1151--1175 | `chunk:1151` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1176--1194 | `chunk:1176` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1195--1199 | `label:deinit` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1200--1200 | `f:venc_out_num_buffers` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1201--1213 | `chunk:1201` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1214--1225 | `f:venc_queue_setup` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1226--1250 | `chunk:1226` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1251--1268 | `chunk:1251` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1269--1275 | `switch:case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1276--1292 | `chunk:1276` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1293--1300 | `switch:case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1301--1302 | `chunk:1301` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1303--1308 | `switch:default` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1309--1313 | `label:put_power` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1314--1325 | `f:venc_buf_init` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1326--1337 | `chunk:1326` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1338--1350 | `f:venc_release_session` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1351--1365 | `chunk:1351` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1366--1371 | `label:release_core` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1372--1375 | `f:venc_buf_cleanup` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1376--1388 | `chunk:1376` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1389--1400 | `f:venc_verify_conf` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1401--1416 | `chunk:1401` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1417--1425 | `f:venc_iris1_preflight` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1426--1450 | `chunk:1426` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1451--1456 | `chunk:1451` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1457--1459 | `f:venc_iris1_set_rotation` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1460--1460 | `field:rotation` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1461--1475 | `field:flip` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1476--1476 | `chunk:1476` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1477--1500 | `f:venc_iris1_stage_preflight` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1501--1502 | `chunk:1501` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1503--1525 | `f:venc_start_streaming` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1526--1550 | `chunk:1526` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1551--1575 | `chunk:1551` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1576--1600 | `chunk:1576` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1601--1625 | `chunk:1601` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1626--1650 | `chunk:1626` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1651--1651 | `chunk:1651` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1652--1666 | `label:error` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1667--1675 | `f:venc_stop_streaming` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1676--1696 | `chunk:1676` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1697--1700 | `f:venc_vb2_buf_queue` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1701--1718 | `chunk:1701` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1719--1719 | `v:venc_vb2_ops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1720--1720 | `field:queue_setup` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1721--1721 | `field:buf_init` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1722--1722 | `field:buf_cleanup` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1723--1723 | `field:buf_prepare` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1724--1724 | `field:start_streaming` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1725--1725 | `field:stop_streaming` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1726--1728 | `chunk:1726, field:buf_queue` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1729--1750 | `f:venc_buf_done` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1751--1766 | `chunk:1751` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1767--1775 | `f:venc_event_notify` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1776--1780 | `chunk:1776` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1781--1781 | `v:venc_hfi_ops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1782--1782 | `field:buf_done` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1783--1785 | `field:event_notify` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1786--1786 | `v:venc_m2m_ops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1787--1787 | `field:device_run` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1788--1790 | `field:job_abort` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1791--1800 | `f:m2m_queue_init` | `—` | encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。 |
| 1801--1825 | `chunk:1801` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1826--1832 | `chunk:1826` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1833--1846 | `f:venc_inst_init` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1847--1850 | `f:venc_open` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1851--1875 | `chunk:1851` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1876--1900 | `chunk:1876` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1901--1914 | `chunk:1901` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1915--1916 | `label:err_m2m_ctx_release` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1917--1918 | `label:err_m2m_dev_release` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1919--1920 | `label:err_ctrl_deinit` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1921--1925 | `label:err_free` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1926--1949 | `chunk:1926, f:venc_close` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1950--1950 | `v:venc_fops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1951--1951 | `chunk:1951, field:owner` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1952--1952 | `field:open` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1953--1953 | `field:release` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1954--1954 | `field:unlocked_ioctl` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1955--1955 | `field:poll` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1956--1958 | `field:mmap` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1959--1975 | `f:venc_probe` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 1976--2000 | `chunk:1976` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2001--2003 | `chunk:2001` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2004--2008 | `label:err_vdev_release` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2009--2019 | `f:venc_remove` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2020--2025 | `f:venc_runtime_suspend` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2026--2031 | `chunk:2026` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2032--2043 | `f:venc_runtime_resume` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2044--2049 | `v:venc_pm_ops` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2050--2050 | `v:venc_dt_match` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2051--2055 | `chunk:2051` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2056--2056 | `v:qcom_venus_enc_driver` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2057--2057 | `field:probe` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2058--2058 | `field:remove` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2059--2059 | `field:driver` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2060--2060 | `field:name` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2061--2061 | `field:of_match_table` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2062--2064 | `field:pm` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |
| 2065--2068 | `v:qcom_venus_enc_driver` | `—` | 部分迁移：Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。 |

覆盖校验：2068/2068 行，连续、无空洞、无重叠。

## `venc.h`

- 当前物理行：13；原厂语义域：`msm_venc.h`；默认判定：**主线替代**。
- 文件级结论：encoder 声明按 V4L2 M2M。

| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |
|---:|---|---|---|
| 1--5 | `chunk:1, file:start` | `—` | 主线替代：encoder 声明按 V4L2 M2M。 |
| 6--12 | `pp:ifndef` | `—` | 主线替代：encoder 声明按 V4L2 M2M。 |
| 13--13 | `pp:endif` | `—` | 主线替代：encoder 声明按 V4L2 M2M。 |

覆盖校验：13/13 行，连续、无空洞、无重叠。
