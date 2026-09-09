# TagsFile is an Exuberant/Universal ctags numeric-line file generated from
# the vendor .c files only with --c-kinds=+dfgstuv.  Header lines are still
# covered by fixed chunks and source-level control-flow anchors.
param(
    [Parameter(Mandatory = $true)]
    [string]$VendorExportRoot,

    [Parameter(Mandatory = $true)]
    [string]$CurrentVenusRoot,

    [Parameter(Mandatory = $true)]
    [string]$TagsFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

$ErrorActionPreference = 'Stop'

$vendorRoot = (Resolve-Path -LiteralPath $VendorExportRoot).Path.TrimEnd('\')
$currentRoot = (Resolve-Path -LiteralPath $CurrentVenusRoot).Path.TrimEnd('\')
$tagsPath = (Resolve-Path -LiteralPath $TagsFile).Path

function Get-SourceFiles {
    param([string]$Root)

    Get-ChildItem -LiteralPath $Root -Recurse -File |
        Where-Object {
            $_.Extension -in @('.c', '.h') -or
            $_.Name -in @('Kconfig', 'Makefile')
        } |
        Sort-Object FullName
}

function Get-RelativePath {
    param([string]$Root, [string]$Path)

    return $Path.Substring($Root.Length + 1).Replace('\', '/')
}

function Get-FilePolicy {
    param([string]$RelativePath)

    switch -Wildcard ($RelativePath) {
        'governors/fixedpoint.h' {
            return @('pm_helpers.c / 64-bit helper', '不直接迁移', '只在重写 SM8150 DDR/LLCC 模型时采用等价定点语义。')
        }
        'governors/*gov.c' {
            return @('pm_helpers.c + interconnect/devfreq', '缺失', '原厂动态 DDR/LLCC、UBWC、recon、codec/fps 模型当前没有等价实现。')
        }
        'governors/*' {
            return @('Kconfig/Makefile + interconnect', '缺失', 'vendor governor 构建胶水不搬运；功能需按主线框架重写。')
        }
        'hfi_packetization.c' {
            return @('hfi_cmds.c + hfi_helper.h', '部分迁移', '线包字段逐项比较；标准属性保留，Android 私有 HAL 包装不照搬。')
        }
        'hfi_packetization.h' {
            return @('hfi_cmds.h', '部分迁移', 'API 按当前 HFI ops 拆分；不复制 vendor 对象模型。')
        }
        'hfi_response_handler.c' {
            return @('hfi_msgs.c + hfi_parser.c + helpers.c', '部分迁移', '公共完成消息已有；扩展 EBD/FBD、统计、metadata/capability 仍不完整。')
        }
        'msm_cvp.c' {
            return @('无通用 Venus 用户 ABI', '不迁移', 'CVP/TME 是 Android/Qualcomm 私有工作流；MVS1 仅保留为共享资源。')
        }
        'msm_cvp.h' {
            return @('无通用 Venus 用户 ABI', '不迁移', '不把 CVP 私有接口加入主线 V4L2 ABI。')
        }
        'msm_smem.c' {
            return @('VB2 dma-contig + DMA API + IOMMU/DT', '部分迁移', '所有权由 VB2 接管；原厂 map direction/cache sync 是首 ETB 的 P0 对照面。')
        }
        'msm_v4l2_private.c' {
            return @('标准 V4L2 controls/events', '选择性迁移', '只迁有标准表达且有消费者的语义；不复制私有 ioctl 翻译层。')
        }
        'msm_v4l2_private.h' {
            return @('标准 V4L2 UAPI', '不直接迁移', '避免新增无人维护的 Android 私有 UAPI。')
        }
        'msm_v4l2_vidc.c' {
            return @('core.c + vdec.c + venc.c + V4L2 M2M/VB2', '架构替代', 'ioctl/PM/probe 由主线框架接管；逐生命周期核对行为。')
        }
        'msm_vdec.c' {
            return @('vdec.c + vdec_ctrls.c + helpers.c', '部分迁移', 'H264/Main8 已过；Main10/P010、metadata、完整矩阵仍欠。')
        }
        'msm_vdec.h' {
            return @('vdec.h + core.h', '架构替代', '声明按主线实例模型重写。')
        }
        'msm_venc.c' {
            return @('venc.c + venc_ctrls.c + helpers.c', '部分迁移', '属性/启动前缀已核对；首 raw ETB 仍导致整机复位。')
        }
        'msm_venc.h' {
            return @('venc.h + core.h', '架构替代', '声明按主线实例模型重写。')
        }
        'msm_vidc_clocks.c' {
            return @('pm_helpers.c + OPP + interconnect', '部分迁移', 'clock/core 选择已有；SM8150 动态 DDR/LLCC/DCVS 模型缺失。')
        }
        'msm_vidc_clocks.h' {
            return @('pm_helpers.h', '架构替代', '接口按主线 PM/ICC 重写。')
        }
        'msm_vidc_common.c' {
            return @('helpers.c + hfi.c + vdec.c + venc.c', '部分迁移', '状态机与 buffer 生命周期逐语义映射；私有 batching/secure/extradata 不全。')
        }
        'msm_vidc_common.h' {
            return @('helpers.h + hfi.h + core.h', '架构替代', '不保留 vendor HAL 层对象布局。')
        }
        'msm_vidc_debug.c' {
            return @('debugfs/tracepoint/dev_dbg + HFI dump', '诊断参考', '只保留低噪声、无副作用的取证；debug 不作为功能前置。')
        }
        'msm_vidc_debug.h' {
            return @('标准 dev_* / tracepoint', '诊断参考', '不复制 vendor 日志宏体系。')
        }
        'msm_vidc_internal.h' {
            return @('core.h + HFI/V4L2 标准结构', '语义拆分', '结构字段按所有权和 ABI 迁移，禁止按内存布局复制。')
        }
        'msm_vidc_platform.c' {
            return @('core.c resources + firmware capability parser', '部分迁移', 'SM8150 codec/cycles/platform flags 是真值；私有平台对象不搬。')
        }
        'msm_vidc_res_parse.c' {
            return @('DT binding + core.c + pm_helpers.c + IOMMU/ICC', '架构替代', '资源交给主线 provider；secure CB 和动态 bus 仍有功能缺口。')
        }
        'msm_vidc_res_parse.h' {
            return @('主线 DT/provider API', '架构替代', '不引入 vendor parser API。')
        }
        'msm_vidc_resources.h' {
            return @('core.h + DT binding + provider structs', '语义拆分', '资源描述按 clock/reset/pd/icc/iommu 框架拆开。')
        }
        'msm_vidc.c' {
            return @('vdec.c + venc.c + helpers.c + VB2/M2M', '部分迁移', 'open/format/queue/stream 生命周期已有；能力和异常路径逐项核对。')
        }
        'msm_vidc.h' {
            return @('core.h + module-local headers', '架构替代', '顶层接口由主线模块边界替代。')
        }
        'venus_boot.c' {
            return @('firmware.c + hfi_venus.c + remoteproc/PAS', '架构替代', '固件启动已通过；不搬旧 PIL/SCM glue。')
        }
        'venus_boot.h' {
            return @('firmware.h', '架构替代', '只保留主线 firmware 生命周期。')
        }
        'venus_hfi.c' {
            return @('hfi_venus.c + pm_helpers.c + hfi.c', '部分迁移', 'queue/IRQ/power/LLCC 已大量对齐；bandwidth、扩展消息、secure/CVP 不全。')
        }
        'venus_hfi.h' {
            return @('hfi_venus.h + core.h', '语义拆分', '设备/会话/资源状态按主线所有权拆分。')
        }
        'vidc_hfi.c' {
            return @('hfi.c', '架构替代', 'HAL 设备抽象由当前 HFI ops 替代。')
        }
        'vidc_hfi.h' {
            return @('hfi.h + hfi_venus.h', '语义拆分', 'callback/ops 只迁行为，不复制接口布局。')
        }
        'vidc_hfi_api.h' {
            return @('core.h + hfi_helper.h + 标准 V4L2 controls', '选择性迁移', 'HAL enum/结构只作协议参考；标准 ABI 优先。')
        }
        'vidc_hfi_helper.h' {
            return @('hfi_helper.h', '部分迁移', 'wire ID/packed struct 必须精确；未使用私有能力不等于应公开。')
        }
        'vidc_hfi_io.h' {
            return @('hfi_venus_io.h', '部分迁移', '只引入 IRIS1 实际访问的寄存器/bit，先核对映射范围。')
        }
        'Kconfig' {
            return @('qcom/venus/Kconfig', '架构替代', '保持单一主线 Venus 驱动。')
        }
        'Makefile' {
            return @('qcom/venus/Makefile', '架构替代', '保持 core/decoder/encoder 模块拆分。')
        }
        default {
            throw "No review policy for $RelativePath"
        }
    }
}

function Get-RegionReview {
    param(
        [string]$RelativePath,
        [string]$Labels,
        [string]$DefaultState,
        [string]$DefaultDecision
    )

    $text = "$Labels $RelativePath"

    if ($RelativePath -like 'governors/*gov.c') {
        return '缺失：纳入 SM8150 bandwidth/DCVS 重写；不能继续复用 SDM845 静态表。'
    }
    if ($RelativePath -like 'msm_cvp.*') {
        return '不迁移：CVP/TME 私有会话不属于当前通用 V4L2 codec 目标。'
    }
    if ($RelativePath -eq 'msm_smem.c') {
        if ($text -match 'map|unmap|cache|device_address|alloc|free') {
            return 'P0 对照：以 VB2 ownership 重写，但必须验证 DMA direction、sync、IOVA 与 alloc length。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -eq 'hfi_packetization.c') {
        if ($text -match 'etb|ftb|set_buffers|release_buffers') {
            return '线包已逐字段核对；ETB/FTB/SET/RELEASE 公共布局静态一致，首 ETB 故障另查 DMA 可见性。'
        }
        if ($text -match 'set_property|HAL_|HFI_PROPERTY') {
            return '逐属性选择性迁移：先找标准 control，再核对 HFI4 property ID、payload 与发送条件。'
        }
        if ($text -match 'sys_|session_(init|cmd)|get_buf_req|flush') {
            return '主会话命令已有当前落点；保持 HFI4 packet size、状态转换和错误返回精确。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -eq 'hfi_response_handler.c') {
        if ($text -match 'etb_done|ftb_done|seq_changed|prop|cap|profile') {
            return '部分迁移：公共前缀已有；扩展 EBD/FBD、profile/tier/metadata/capability 仍需按包长兼容解析。'
        }
        if ($text -match 'error|validate|msg_packet') {
            return '健壮性必需：保留包长/状态/错误校验，并兼容固件较长回复。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -eq 'msm_vdec.c') {
        if ($text -match 'frame_size|fmt|pixel|constraint') {
            return 'Main10 P0：统一 P010/QC10C 的 fourcc、stride/scanline/sizeimage、HFI constraints 和 source-change。'
        }
        return 'decoder 控制/能力按标准 V4L2 迁移；完成 codec/profile 像素级矩阵前均标记未验证。'
    }
    if ($RelativePath -eq 'msm_venc.c') {
        if ($text -match 'frame_size|fmt|csc') {
            return 'encoder 格式路径部分迁移；先稳定线性 NV12，再扩 HEVC/VP8/P010/UBWC。'
        }
        return 'encoder control 选择性迁移；不得用随机属性掩盖首 raw ETB 硬复位。'
    }
    if ($RelativePath -eq 'msm_vidc_clocks.c') {
        if ($text -match 'bus|recon|ubwc|compression|dcvs|freq') {
            return '缺口：保留算法语义并重写为 OPP/ICC；先 trace 计算值，再启用真实 vote。'
        }
        if ($text -match 'work_route|work_mode|core|power') {
            return '已部分对齐 route/mode/MVS0；多实例、codec/fps/quality 仍需实机矩阵。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -eq 'msm_vidc_common.c') {
        if ($text -match 'set_internal|scratch|persist|recon|buffer_count|bufreq') {
            return '内部 buffer/requirements 已对齐到 Stage8；保留错误回滚，recon 仅 bookkeeping。'
        }
        if ($text -match 'qbuf|ebd|fbd|cache|dma|device_plane') {
            return 'buffer 生命周期重点：VB2 ownership 不照搬；encoder 首 ETB 与扩展 EBD/FBD 尚未闭环。'
        }
        if ($text -match 'session|load_resources|start|stop|release_res|flush|state') {
            return '会话状态机已有主线等价；Stage0--8 通过，仍需异常/EOS/flush/长时压力。'
        }
        if ($text -match 'frame_size|color_format|constraint|pixel_fmt') {
            return '格式语义部分迁移；P010/UBWC/TP10/NV21/NV12_512 必须逐格式验证。'
        }
        if ($text -match 'secure|thermal|batch|overload|scaling') {
            return '平台策略未完整迁移；只在有标准 ABI/主线框架和实机需求时实现。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -eq 'msm_vidc_platform.c') {
        return '平台真值：保留 SM8150 codec/cycles/common-data 语义；资源对象按主线 core/firmware caps 表达。'
    }
    if ($RelativePath -eq 'venus_hfi.c') {
        if ($text -match 'queue|cmdq|msgq|dbgq|interrupt|isr') {
            return 'queue/IRQ 部分已迁并加边界防护；包所有权、锁和读写顺序必须保持。'
        }
        if ($text -match 'clock|bus|regulator|power|subcache|resource|suspend|resume') {
            return 'IRIS1 资源/PM 已实机通过；动态 bus/DCVS 与故障注入仍未完整。'
        }
        if ($text -match 'session_(etb|ftb|set_buffers|release_buffers|load_res|start|stop)') {
            return '命令路径静态/分阶段已过；首 ETB 后硬复位仍是边界，禁止重复 Stage0--8。'
        }
        return $DefaultDecision
    }
    if ($RelativePath -match 'debug') {
        return '诊断参考：只保留限速日志/trace/dump，不迁移私有 debug ABI。'
    }
    if ($RelativePath -match 'private') {
        return '私有 ABI 选择性迁移：有标准 V4L2 表达才实现，否则记录但不公开。'
    }

    return "$DefaultState：$DefaultDecision"
}

$sourceFiles = @(Get-SourceFiles -Root $vendorRoot)
if ($sourceFiles.Count -ne 42) {
    throw "Expected 42 vendor source files, got $($sourceFiles.Count)"
}

$currentText = (Get-SourceFiles -Root $currentRoot |
    ForEach-Object { [IO.File]::ReadAllText($_.FullName) }) -join "`n"

$tagMap = @{}
foreach ($line in [IO.File]::ReadAllLines($tagsPath)) {
    if ($line.StartsWith('!_TAG')) {
        continue
    }

    $parts = $line -split "`t"
    if ($parts.Count -lt 4 -or $parts[3] -notin @('d', 'f', 'g', 'p', 's', 't', 'u', 'v')) {
        continue
    }

    $tagPath = $parts[1].Replace('/', '\')
    $path = if ([IO.Path]::IsPathRooted($tagPath)) {
        [IO.Path]::GetFullPath($tagPath)
    } else {
        [IO.Path]::GetFullPath((Join-Path $vendorRoot $tagPath))
    }
    if (-not $path.StartsWith($vendorRoot, [StringComparison]::OrdinalIgnoreCase)) {
        continue
    }

    $relative = Get-RelativePath -Root $vendorRoot -Path $path
    $lineNumber = 0
    if ($parts[2] -match '^(\d+);"$') {
        $lineNumber = [int]$Matches[1]
    }
    if ($lineNumber -le 0) {
        continue
    }

    $key = "$relative`:$lineNumber"
    if (-not $tagMap.ContainsKey($key)) {
        $tagMap[$key] = [Collections.Generic.List[string]]::new()
    }
    $tagMap[$key].Add("$($parts[3]):$($parts[0])")
}

$output = [Collections.Generic.List[string]]::new()
$output.Add('# 小米 SM8150 原厂 VIDC 39,111 行连续覆盖台账')
$output.Add('')
$output.Add('> 原厂提交：`192eca8550f95c2eec58a474793d1d93fc1b3b67`；')
$output.Add('> `drivers/media/platform/msm/vidc` tree：`1e66319e3b0a9e1ad7f59d624b4d58f5c0c67fc4`。')
$output.Add('> 本台账覆盖 42 个文件的每一个物理源代码行。行区间以函数、宏、类型、全局变量、')
$output.Add('> switch case、label、条件编译和 designated initializer 为锚点连续分割；区间是覆盖')
$output.Add('> 单元，不声称末行恰好等于 C 函数的语法结束。原文应通过固定提交的 `git show` 核验。')
$output.Add('')
$output.Add('“同名命中”只是当前 `qcom/venus` 是否含相同 token 的机械证据；未命中不自动代表')
$output.Add('功能缺失，因为 vendor HAL 与主线命名不同。最终迁移判定以“复核结论”和总报告为准。')
$output.Add('')
$output.Add('| 状态 | 含义 |')
$output.Add('|---|---|')
$output.Add('| 架构替代/语义拆分 | 主线已有不同对象模型，迁行为而非复制代码 |')
$output.Add('| 部分/选择性迁移 | 只覆盖通用 ABI 子集，仍有明确功能缺口 |')
$output.Add('| 缺失 | 当前没有等价实现，需要按主线框架重写 |')
$output.Add('| 不迁移 | Android/CVP/私有 ABI 不属于本项目通用 codec 目标 |')
$output.Add('| 诊断参考 | 可借鉴取证，不是功能依赖 |')
$output.Add('')

$totalLines = 0
$totalRegions = 0
$totalFunctions = 0

foreach ($file in $sourceFiles) {
    $relative = Get-RelativePath -Root $vendorRoot -Path $file.FullName
    $lines = [IO.File]::ReadAllLines($file.FullName)
    $lineCount = $lines.Count
    $totalLines += $lineCount
    $policy = Get-FilePolicy -RelativePath $relative

    $anchors = @{}
    $anchors[1] = [Collections.Generic.List[string]]::new()
    $anchors[1].Add('file:start')

    for ($index = 0; $index -lt $lineCount; $index++) {
        $lineNumber = $index + 1
        if ((($lineNumber - 1) % 25) -eq 0 -and $lineNumber -ne 1) {
            if (-not $anchors.ContainsKey($lineNumber)) {
                $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
            }
            $anchors[$lineNumber].Add("chunk:$lineNumber")
        }
        $key = "$relative`:$lineNumber"
        if ($tagMap.ContainsKey($key)) {
            if (-not $anchors.ContainsKey($lineNumber)) {
                $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
            }
            foreach ($tag in $tagMap[$key]) {
                $anchors[$lineNumber].Add($tag)
                if ($tag.StartsWith('f:')) {
                    $totalFunctions++
                }
            }
        }

        $text = $lines[$index]
        $extra = $null
        if ($text -match '^\s*case\s+([^:]+):') {
            $extra = "case:$($Matches[1].Trim())"
        } elseif ($text -match '^\s*default\s*:') {
            $extra = 'case:default'
        } elseif ($text -match '^\s*([A-Za-z_]\w*)\s*:\s*(?:/\*.*\*/)?$') {
            $extra = "label:$($Matches[1])"
        } elseif ($text -match '^\s*\.([A-Za-z_]\w*)\s*=') {
            $extra = "field:$($Matches[1])"
        } elseif ($text -match '^\s*\[([^\]]+)\]\s*=') {
            $extra = "index:$($Matches[1].Trim())"
        } elseif ($text -match '^\s*#\s*(if|ifdef|ifndef|elif|else|endif)\b(.*)$') {
            $extra = "pp:$($Matches[1])$($Matches[2])".Trim()
        }

        if ($extra) {
            if (-not $anchors.ContainsKey($lineNumber)) {
                $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
            }
            if (-not $anchors[$lineNumber].Contains($extra)) {
                $anchors[$lineNumber].Add($extra)
            }
        }
    }

    $starts = @($anchors.Keys | Sort-Object)
    $covered = 0

    $output.Add("## ``$relative``")
    $output.Add('')
    $output.Add("- 原厂物理行：$lineCount；当前语义落点：``$($policy[0])``；默认判定：**$($policy[1])**。")
    $output.Add("- 文件级结论：$($policy[2])")
    $output.Add('')
    $output.Add('| 原厂行 | 锚点 | 当前同名 token | 复核结论 |')
    $output.Add('|---:|---|---|---|')

    for ($i = 0; $i -lt $starts.Count; $i++) {
        $start = [int]$starts[$i]
        $end = if ($i + 1 -lt $starts.Count) { [int]$starts[$i + 1] - 1 } else { $lineCount }
        if ($end -lt $start) {
            throw "Invalid range ${relative}:$start-$end"
        }
        $covered += $end - $start + 1
        $totalRegions++

        $labels = @($anchors[$start] | Sort-Object -Unique)
        $labelText = ($labels -join ', ').Replace('|', '\|')
        $tokens = @($labels | ForEach-Object {
            if ($_ -match '^[^:]+:(.+)$') { $Matches[1].Trim() }
        } | Where-Object {
            $_ -match '^[A-Za-z_][A-Za-z0-9_]{3,}$' -and
            $_ -notin @('default', 'start', 'endif', 'else')
        } | Sort-Object -Unique)

        $matches = @($tokens | Where-Object {
            $currentText -match "(?<![A-Za-z0-9_])$([regex]::Escape($_))(?![A-Za-z0-9_])"
        })
        $matchText = if ($matches.Count) {
            (($matches | Select-Object -First 4) -join ', ').Replace('|', '\|')
        } else {
            '—'
        }

        $review = Get-RegionReview -RelativePath $relative -Labels ($labels -join ' ') `
            -DefaultState $policy[1] -DefaultDecision $policy[2]
        $review = $review.Replace('|', '\|')
        $output.Add("| $start--$end | ``$labelText`` | ``$matchText`` | $review |")
    }

    if ($covered -ne $lineCount) {
        throw "Coverage mismatch for ${relative}: $covered != $lineCount"
    }
    $output.Add('')
    $output.Add("覆盖校验：$covered/$lineCount 行，连续、无空洞、无重叠。")
    $output.Add('')
}

if ($totalLines -ne 39111) {
    throw "Expected 39111 physical lines, got $totalLines"
}
if ($totalFunctions -ne 686) {
    throw "Expected 686 function tags, got $totalFunctions"
}

$output.Add('## 总覆盖校验')
$output.Add('')
$output.Add("- 文件：$($sourceFiles.Count)/42；")
$output.Add("- 物理源代码行：$totalLines/39111；")
$output.Add("- C 函数定义锚点：$totalFunctions/686；")
$output.Add("- 连续复核区间：$totalRegions；")
$output.Add('- 每个文件均已验证区间覆盖数等于物理行数；任何缺行、重叠或未知文件策略都会使生成失败。')
$output.Add('')
$output.Add('该校验证明审计范围完整，不等于所有 vendor 功能都应迁移。具体优先级、实机状态、')
$output.Add('Main10/P010、encoder 首 ETB 与完整迁移状态见 `venus-sm8150-migration-status.md`；0018')
$output.Add('逐 hunk 处置见 `venus-sm8150-pending-hunk-ledger.md`。')

$outputPath = [IO.Path]::GetFullPath($OutputFile)
$outputDirectory = Split-Path -Parent $outputPath
if (-not (Test-Path -LiteralPath $outputDirectory)) {
    throw "Output directory does not exist: $outputDirectory"
}
[IO.File]::WriteAllLines($outputPath, $output, [Text.UTF8Encoding]::new($false))

Write-Output "wrote=$outputPath"
Write-Output "files=$($sourceFiles.Count) lines=$totalLines functions=$totalFunctions regions=$totalRegions"
