# 小米 Raphael Linux 内核构建项目

本仓库提供面向 Xiaomi Redmi K20 Pro / Mi 9T Pro（Raphael / SM8150） 的 Linux 7.1 内核增强版本。

如需直接安装已经构建好的内核，请前往仓库的 Pre-Release 页面，并按照发布说明执行 一键内核更新脚本。

## Venus硬件加速

目前 Qualcomm Venus 视频编解码器已经可以在 Raphael 上正常工作。

| 格式          | 硬件编码 | 硬件解码 |
| --------------- | ----------------- | ----------------- |
| H.264           | ✅    | ✅ |
| HEVC Main 8-bit | ✅    | ✅ |
| HEVC Main10     | ✅    | ✅ |
| VP8             | ✅    | ✅ |
| VP9             | ❌    | ✅ |

内核侧通过 V4L2 M2M 接口驱动 Qualcomm Venus 硬件编解码器。

用户态推荐搭配独立的 Venus VA-API Driver：

**[snowf14k3/venus-vaapi-driver](https://github.com/snowf14k3/venus-vaapi-driver)**

## 整体硬件支持


| 分类 | 支持项目 | 状态 |
| :---: | :--- | :---: |
| **Wi-Fi** | 2.4 GHz / 5 GHz 双频 Wi-Fi | ✅ |
| **蓝牙** | 蓝牙连接 · 文件传输 · 音频输出 | ✅ |
| **蜂窝网络** | 移动数据 / Modem | ❌ |
| **USB** | USB OTG · NCM 网络共享 | ✅ |
| **显示** | DSI 屏幕输出 · DRM/KMS | ✅ |
| **GPU** | Adreno GPU 硬件渲染 | ✅ |
| **音频** | 扬声器 · 有线耳机输出 | ✅ |
| **触摸** | 触摸屏输入 | ✅ |
| **外设** | 闪光灯 / 手电筒 | ✅ |
| **电源** | 电池状态检测 · USB 供电 / 充电 | ✅ |
| **系统** | RTC 实时时钟 | ✅ |
| **存储** | FDE 全盘加密 | ✅ |
