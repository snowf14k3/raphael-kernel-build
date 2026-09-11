# Raphael 麦克风录音修复

这是 `raphael-kernel-build` 中专门用于 Xiaomi Redmi K20 Pro / Mi 9T Pro（`raphael`，SM8150）麦克风采集与录音路径修复的分支。

## 内核基线

- 上游仓库：`https://github.com/GengWei1997/linux.git`
- 上游分支：`raphael-7.1`
- 固定提交：`ab4ce59a1826b18ba200b33f6a32d04d749a7ea5`

构建前会检查固定 commit，防止上游分支移动后静默改变测试基线。

## 修复内容

当前分支只保留麦克风相关设备树修复：

```text
0001-arm64-dts-qcom-raphael-restore-microphone-routing.patch
```

修改文件：

```text
arch/arm64/boot/dts/qcom/sm8150-xiaomi-raphael.dts
```

修复后的模拟麦克风路由为：

```dts
audio-routing = "RX_BIAS", "MCLK",
        "AMIC1", "MIC BIAS1",
        "AMIC2", "MIC BIAS2",
        "AMIC3", "MIC BIAS3",
        "AMIC4", "MIC BIAS1",
        "AMIC5", "MIC BIAS4";
```

该修改负责描述 Raphael 板级的 MIC BIAS 与 AMIC 物理连接关系。

## 实际录音链路

内核设备树只负责物理音频路由。完整录音仍需要用户空间 / ALSA mixer 建立 WCD934x 到 Q6DSP 的 capture path，大致链路如下：

```text
物理麦克风
  ↓
MIC BIAS / AMIC
  ↓
WCD934x ADC
  ↓
DEC0 / DEC1
  ↓
CDC_IF TX0 / TX1
  ↓
SLIM TX0 / TX1
  ↓
AIF1_CAP
  ↓
SLIMBUS_0_TX
  ↓
MultiMedia1
  ↓
ALSA PCM
```

实机手动验证时使用的 mixer 路由包括：

```bash
amixer -c 0 cset name='MultiMedia1 Mixer SLIMBUS_0_TX' 1
amixer -c 0 cset name='AIF1_CAP Mixer SLIM TX0' 1
amixer -c 0 cset name='AIF1_CAP Mixer SLIM TX1' 1
amixer -c 0 cset name='CDC_IF TX0 MUX' DEC0
amixer -c 0 cset name='CDC_IF TX1 MUX' DEC1
amixer -c 0 cset name='ADC MUX0' AMIC
amixer -c 0 cset name='ADC MUX1' AMIC
amixer -c 0 cset name='AMIC MUX0' ADC1
amixer -c 0 cset name='AMIC MUX1' ADC1
```

然后可以直接使用 ALSA 录音测试：

```bash
arecord -D hw:0,0 -f S16_LE -r 48000 -c 2 -d 5 /tmp/mic-test.wav
```

这些 `amixer` 配置用于手动验证完整录音链路，并不属于 DTS patch 本身。

## 构建

GitHub Actions 工作流位于：

```text
.github/workflows/build.yml
```

补丁应用顺序由：

```text
patches/series
```

定义。这个分支只处理麦克风相关内容，不混入显示、DSI 或 Venus 视频编解码适配。
