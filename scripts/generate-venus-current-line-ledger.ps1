# TagsFile is an Exuberant/Universal ctags numeric-line file generated from
# the current .c files only with --c-kinds=+dfgstuv.  Header lines are still
# covered by fixed chunks and source-level control-flow anchors.
param(
    [Parameter(Mandatory = $true)]
    [string]$CurrentVenusRoot,

    [Parameter(Mandatory = $true)]
    [string]$VendorVidcRoot,

    [Parameter(Mandatory = $true)]
    [string]$TagsFile,

    [Parameter(Mandatory = $true)]
    [string]$OutputFile
)

$ErrorActionPreference = 'Stop'

$currentRoot = (Resolve-Path -LiteralPath $CurrentVenusRoot).Path.TrimEnd('\')
$vendorRoot = (Resolve-Path -LiteralPath $VendorVidcRoot).Path.TrimEnd('\')
$tagsPath = (Resolve-Path -LiteralPath $TagsFile).Path

function Get-SourceFiles {
    param([string]$Root)

    Get-ChildItem -LiteralPath $Root -File |
        Where-Object {
            $_.Extension -in @('.c', '.h') -or
            $_.Name -in @('Kconfig', 'Makefile')
        } |
        Sort-Object Name
}

function Get-CurrentPolicy {
    param([string]$Name)

    switch ($Name) {
        'Kconfig' { return @('Kconfig/Makefile', '保留', '主线驱动入口；不并存 Android 私有驱动。') }
        'Makefile' { return @('Kconfig/Makefile', '保留', '主线 core/decoder/encoder 模块边界。') }
        'core.c' { return @('msm_vidc_platform.c + msm_vidc_res_parse.c + venus_hfi.c', '部分迁移', 'SM8150 资源、probe、capability 与 IRIS1 生命周期；实验字段需产品化。') }
        'core.h' { return @('msm_vidc_internal.h + msm_vidc_resources.h', '语义拆分', '按主线 ownership 表达实例、资源和 buffer；不复制 vendor struct 布局。') }
        'dbgfs.c' { return @('msm_vidc_debug.c', '主线替代', '只保留低噪声诊断；vendor 私有 debug ABI 不迁。') }
        'dbgfs.h' { return @('msm_vidc_debug.h', '主线替代', '标准 debugfs/dev_dbg 接口。') }
        'firmware.c' { return @('venus_boot.c + venus_hfi.c', '主线替代', 'firmware/PAS 生命周期已启动通过；不搬 PIL/SCM glue。') }
        'firmware.h' { return @('venus_boot.h', '主线替代', '固件接口按主线抽象。') }
        'helpers.c' { return @('msm_vidc_common.c + hfi_packetization.c + msm_smem.c', '部分迁移', '会话、内部 buffer、队列和 HFI 属性的核心对照面。') }
        'helpers.h' { return @('msm_vidc_common.h', '语义拆分', 'helper API 按主线实例模型保留。') }
        'hfi.c' { return @('vidc_hfi.c + venus_hfi.c', '主线替代', 'HFI ops、状态机和 timeout；保持严格错误传播。') }
        'hfi.h' { return @('vidc_hfi.h', '语义拆分', 'HFI ops/callback 按主线边界表达。') }
        'hfi_cmds.c' { return @('hfi_packetization.c', '逐包核对', 'HFI4 packet ID、payload、长度和发送条件必须精确。') }
        'hfi_cmds.h' { return @('hfi_packetization.h', '语义拆分', '命令 API 按当前 HFI ops 拆分。') }
        'hfi_helper.h' { return @('vidc_hfi_helper.h + vidc_hfi_api.h', '逐字段核对', 'wire enum/packed struct 是强一致面；新增字段必须兼容包长。') }
        'hfi_msgs.c' { return @('hfi_response_handler.c + msm_vidc_clocks.c', '部分迁移', '公共 response 已有；VPU5 EBD/recon/UBWC 尾部已兼容解析并发布通用动态统计，其他 metadata 仍不全。') }
        'hfi_msgs.h' { return @('hfi_response_handler.c + vidc_hfi_helper.h', '语义拆分', '消息结构按公共前缀和主线回调表达。') }
        'hfi_parser.c' { return @('hfi_response_handler.c + msm_vidc_platform.c', '部分迁移', '固件 capability 决定真实 codec/profile/range。') }
        'hfi_parser.h' { return @('vidc_hfi_api.h', '语义拆分', 'capability helper 按主线模型保留。') }
        'hfi_plat_bufs_v6.c' { return @('无 IRIS1 等价；vendor VPU5 requirements 来自固件', '非本机执行路径', 'HFI6 计算器不能误用于 SM8150 HFI4；保留上游供其他 SoC。') }
        'hfi_plat_bufs.h' { return @('msm_vidc_common.c buffer requirements', '共享接口', 'IRIS1 依赖 firmware requirements，不套 HFI6 固定公式。') }
        'hfi_platform_v4.c' { return @('msm_vidc_platform.c + vidc_hfi_helper.h', '关键迁移面', 'HFI4 codec/profile/pixfmt/cycles 映射必须按 SM8150 固件能力。') }
        'hfi_platform_v6.c' { return @('无 IRIS1 等价', '非本机执行路径', 'HFI6 平台映射不能作为 SM8150 证据。') }
        'hfi_platform.c' { return @('msm_vidc_platform.c', '主线替代', '按 HFI generation 选择 platform ops。') }
        'hfi_platform.h' { return @('msm_vidc_platform.c + vidc_hfi_api.h', '语义拆分', 'platform ops 按主线接口表达。') }
        'hfi_venus_io.h' { return @('vidc_hfi_io.h', '逐寄存器核对', '只保留 IRIS1 实际寄存器/bit，访问前核对 reg window。') }
        'hfi_venus.c' { return @('venus_hfi.c + msm_vidc_clocks.c + msm_smem.c', '部分迁移', 'queue/IRQ/PM/LLCC 已过；secure 和故障恢复不全。') }
        'hfi_venus.h' { return @('venus_hfi.h', '语义拆分', '设备/HFI 状态按主线 ownership 表达。') }
        'pm_helpers.c' { return @('msm_vidc_clocks.c + governors/msm_vidc_dyn_gov.c + governors/fixedpoint.h', '已实现、待实机', '0019 已按单 ICC 架构迁入 SM8150 Q16 DDR/LLCC、动态 CR/CF、前16 EBD Turbo 和多实例饱和；性能/稳定性待实机。') }
        'pm_helpers.h' { return @('msm_vidc_clocks.h', '主线替代', 'PM 接口按 clock/reset/pd/icc 框架。') }
        'vdec.c' { return @('msm_vdec.c + msm_vidc_common.c', '部分迁移', 'H264/Main8 已过；Main10/P010 约束与协商已静态补齐、待实机闭环，其余矩阵/metadata 未覆盖。') }
        'vdec.h' { return @('msm_vdec.h', '主线替代', 'decoder 声明按 V4L2 M2M。') }
        'vdec_ctrls.c' { return @('msm_vdec.c + msm_v4l2_private.c', '选择性迁移', '标准 controls 优先；能力必须由 firmware 过滤。') }
        'venc.c' { return @('msm_venc.c + msm_vidc_common.c + msm_smem.c', '部分迁移', 'Stage0--8 已过；已补原厂 NV12 大小与双向 DMA，首 ETB 修复尚待实机验证。') }
        'venc.h' { return @('msm_venc.h', '主线替代', 'encoder 声明按 V4L2 M2M。') }
        'venc_ctrls.c' { return @('msm_venc.c + msm_v4l2_private.c', '选择性迁移', '标准 encoder controls 与 HFI4 属性逐项映射。') }
        default { throw "No current-side review policy for $Name" }
    }
}

function Get-RegionDecision {
    param([string]$Name, [string]$Labels, [string]$DefaultState, [string]$DefaultDecision)

    $text = "$Name $Labels"

    if ($Name -in @('hfi_plat_bufs_v6.c', 'hfi_platform_v6.c')) {
        return '非 IRIS1 路径：保留上游实现，但不得据此宣称 SM8150 已适配。'
    }
    if ($Name -eq 'hfi_cmds.c') {
        if ($text -match 'etb|ftb|empty_buffer|fill_buffer') {
            return '强核对：HFI4 ETB/FTB 公共字段已与原厂一致；Test15 首 ETB 后复位，继续查 DMA 可见性/size。'
        }
        if ($text -match 'set_buffers|release_buffers|buffer_count|buffer_size') {
            return '强核对：buffer type/count/size/address wire layout 已对齐；Stage1--8 实机通过相应前缀。'
        }
        if ($text -match 'property|work_route|work_mode|timestamp|qp|nal') {
            return '选择性迁移：核对 HFI4 property ID、payload 和发送条件；已排除项不得重复猜测。'
        }
    }
    if ($Name -eq 'hfi_helper.h') {
        if ($text -match 'packet|buffer|property|session|event|error') {
            return 'wire ABI：按原厂 VPU5 数值/字段宽度核对，并允许 firmware 返回兼容的扩展尾部。'
        }
    }
    if ($Name -in @('hfi_msgs.c', 'hfi_msgs.h')) {
        if ($text -match 'empty|fill|ebd|fbd|sequence|event|property|cap') {
            return 'response 对照：公共完成路径保留；VPU5 EBD 尾部已按包长兼容解析并驱动 IRIS1 动态统计，其他 metadata 仍需选择性迁移。'
        }
    }
    if ($Name -eq 'helpers.c') {
        if ($text -match 'internal|scratch|persist|recon|set_buffers|release_buffers|bufreq|requirement') {
            return 'buffer 生命周期：Stage1--8 已验证前缀；recon 仅 bookkeeping，错误回滚必须先停 firmware 再释放 DMA。'
        }
        if ($text -match 'queue|device_run|process_buf|empty_buf|fill_buf|dma|payload') {
            return 'P0：保持 VB2 ownership；encoder FTB-before-ETB 已过，首 raw ETB 的 direction/sync/IOVA/alloc_len 未闭环。'
        }
        if ($text -match 'load|start|stop|release|session|stream') {
            return '状态机：LOAD/START/STOP/RELEASE 的 Stage6--8 前缀已过；仍需 EOS/flush/异常/长时验证。'
        }
        if ($text -match 'format|constraint|p010|bit_depth|plane') {
            return 'Main10 P0：HFI4 P010 plane constraints 与严格格式选择已实现；mplane/bytesused 用户态闭环待实机验证。'
        }
    }
    if ($Name -eq 'venc.c') {
        if ($text -match 'start_stream|start|stop|queue|buf|device_run|dma') {
            return 'encoder 关键面：启动前缀已过；原厂 NV12 size 和双向 DMA 已实现但未过实机，默认 gate 必须保持关闭。'
        }
        if ($text -match 'fmt|format|size|stride|plane') {
            return 'encoder 格式面：先稳定线性 NV12/H264，再扩 HEVC、VP8 与 10-bit/UBWC。'
        }
    }
    if ($Name -eq 'venc_ctrls.c') {
        return 'encoder control：只映射标准 V4L2 语义；逐项核对默认值、条件和 HFI4 payload。'
    }
    if ($Name -eq 'vdec.c') {
        if ($text -match 'source|event|format|fmt|p010|bit_depth|size|plane|queue') {
            return 'decoder 关键面：统一 ENUM/TRY/S_FMT/source-change；Main10 P010 stride/size/payload 仍失败。'
        }
        return 'decoder 主线生命周期保留；未做像素级矩阵的 codec/profile 一律不标可用。'
    }
    if ($Name -eq 'vdec_ctrls.c') {
        return 'decoder control：firmware capability 决定 menu/range；Android 私有 control 不直接复制。'
    }
    if ($Name -eq 'pm_helpers.c') {
        if ($text -match 'sm8150|bandwidth|bw|icc|bus|freq|clock|scale|load') {
            return '资源/性能：0019 已迁 SM8150 通用 Q16 DDR/LLCC governor，并把两段动态结果映射为单端到端 ICC vote；实机/长时/多实例待验。'
        }
        if ($text -match 'power|resume|suspend|reset|core') {
            return 'PM 对照：父设备 1500 ms 与原厂一致；子设备 2000 ms 及故障回滚仍需生命周期验证。'
        }
    }
    if ($Name -eq 'core.c') {
        if ($text -match 'sm8150|iris1|resource|clock|power|reset|llcc|firmware') {
            return 'SM8150 平台面：固件/LLCC/MVS0/MVSC/CVP/533 MHz 已启动通过；缺口见 bandwidth/secure。'
        }
        if ($text -match 'probe|remove|runtime|suspend|resume') {
            return '设备生命周期：主线 probe/runtime PM 保留；实机 idle 可回 suspended。'
        }
    }
    if ($Name -eq 'hfi_venus.c') {
        if ($text -match 'queue|interrupt|isr|cmdq|msgq|dbgq') {
            return 'queue/IRQ：主线 ownership 与锁保留；Test7 后 IRIS1 固件通讯已通过。'
        }
        if ($text -match 'power|resume|suspend|clock|llcc|register|reset') {
            return 'IRIS1 PM/资源已部分实机通过；secure/CVP/动态 bandwidth 不完整。'
        }
    }
    if ($Name -eq 'hfi_parser.c') {
        return 'capability 真值：SM8150 最终枚举和 control 范围必须来自 firmware，不以通用数组代替。'
    }

    return "$DefaultState：$DefaultDecision"
}

$currentFiles = @(Get-SourceFiles -Root $currentRoot)
if ($currentFiles.Count -ne 36) {
    throw "Expected 36 Test15 Venus files, got $($currentFiles.Count)"
}

$vendorText = (Get-ChildItem -LiteralPath $vendorRoot -Recurse -File |
    Where-Object { $_.Extension -in @('.c', '.h') -or $_.Name -in @('Kconfig', 'Makefile') } |
    ForEach-Object { [IO.File]::ReadAllText($_.FullName) }) -join "`n"

$tagMap = @{}
foreach ($line in [IO.File]::ReadAllLines($tagsPath)) {
    if ($line.StartsWith('!_TAG')) { continue }
    $parts = $line -split "`t"
    if ($parts.Count -lt 4 -or $parts[3] -notin @('d', 'f', 'g', 's', 't', 'u', 'v')) { continue }

    $tagPath = $parts[1].Replace('/', '\')
    $fullTagPath = if ([IO.Path]::IsPathRooted($tagPath)) {
        [IO.Path]::GetFullPath($tagPath)
    } else {
        [IO.Path]::GetFullPath((Join-Path $currentRoot $tagPath))
    }
    if (-not $fullTagPath.StartsWith($currentRoot, [StringComparison]::OrdinalIgnoreCase)) { continue }
    if ($parts[2] -notmatch '^(\d+);"$') { continue }

    $name = [IO.Path]::GetFileName($fullTagPath)
    $lineNumber = [int]$Matches[1]
    $key = "$name`:$lineNumber"
    if (-not $tagMap.ContainsKey($key)) {
        $tagMap[$key] = [Collections.Generic.List[string]]::new()
    }
    $tagMap[$key].Add("$($parts[3]):$($parts[0])")
}

$output = [Collections.Generic.List[string]]::new()
$output.Add('# 当前 Venus 22,143 行反向逐行迁移台账')
$output.Add('')
$output.Add('> 当前树：`F:\linux\test15-analysis\drivers\media\platform\qcom\venus`，由固定基线')
$output.Add('> `58f3df07833f2382fe2fbc28f996c4c85817c1f6` 应用 `patches/series` 19 个补丁得到。')
$output.Add('> 本台账覆盖当前 Venus 36 个文件的每一个物理行；按函数/宏/类型/全局变量、控制流')
$output.Add('> 锚点及最多 25 行连续区间分割。它回答“当前每段代码在原厂哪里、保留还是欠迁”，')
$output.Add('> 与原厂 39,111 行台账、Test15 173-hunk 台账、0018 35-hunk、0019 11-hunk 台账和')
$output.Add('> `venus-sm8150-migration-status.md` 合用。')
$output.Add('')
$output.Add('“原厂同名 token”只表示标识符机械命中；两套驱动命名/架构不同，未命中不自动等于')
$output.Add('缺功能，命中也不证明语义相同。最终结论由本列策略和总报告给出。')
$output.Add('')

$totalLines = 0
$totalFunctions = 0
$totalRegions = 0

foreach ($file in $currentFiles) {
    $name = $file.Name
    $lines = [IO.File]::ReadAllLines($file.FullName)
    $lineCount = $lines.Count
    $policy = Get-CurrentPolicy -Name $name
    $anchors = @{}
    $anchors[1] = [Collections.Generic.List[string]]::new()
    $anchors[1].Add('file:start')

    for ($lineNumber = 1; $lineNumber -le $lineCount; $lineNumber += 25) {
        if (-not $anchors.ContainsKey($lineNumber)) {
            $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
        }
        $anchors[$lineNumber].Add("chunk:$lineNumber")
    }

    for ($lineNumber = 1; $lineNumber -le $lineCount; $lineNumber++) {
        $key = "$name`:$lineNumber"
        if ($tagMap.ContainsKey($key)) {
            if (-not $anchors.ContainsKey($lineNumber)) {
                $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
            }
            foreach ($tag in $tagMap[$key]) {
                $anchors[$lineNumber].Add($tag)
                if ($tag.StartsWith('f:')) { $totalFunctions++ }
            }
        }

        $source = $lines[$lineNumber - 1]
        $extra = $null
        if ($source -match '^\s*#\s*(if|ifdef|ifndef|else|elif|endif)\b') { $extra = "pp:$($Matches[1])" }
        elseif ($source -match '^\s*(case\s+[^:]+|default)\s*:') { $extra = "switch:$($Matches[1].Trim())" }
        elseif ($source -match '^\s*([A-Za-z_]\w*)\s*:\s*(/\*.*\*/)?\s*$') { $extra = "label:$($Matches[1])" }
        elseif ($source -match '^\s*\.([A-Za-z_]\w*)\s*=') { $extra = "field:$($Matches[1])" }

        if ($extra) {
            if (-not $anchors.ContainsKey($lineNumber)) {
                $anchors[$lineNumber] = [Collections.Generic.List[string]]::new()
            }
            if (-not $anchors[$lineNumber].Contains($extra)) { $anchors[$lineNumber].Add($extra) }
        }
    }

    $starts = @($anchors.Keys | Sort-Object)
    $covered = 0

    $output.Add("## ``$name``")
    $output.Add('')
    $output.Add("- 当前物理行：$lineCount；原厂语义域：``$($policy[0])``；默认判定：**$($policy[1])**。")
    $output.Add("- 文件级结论：$($policy[2])")
    $output.Add('')
    $output.Add('| 当前行 | 锚点 | 原厂同名 token | 反向复核结论 |')
    $output.Add('|---:|---|---|---|')

    for ($index = 0; $index -lt $starts.Count; $index++) {
        $start = [int]$starts[$index]
        $end = if ($index + 1 -lt $starts.Count) { [int]$starts[$index + 1] - 1 } else { $lineCount }
        if ($end -lt $start) { continue }

        $labels = @($anchors[$start] | Sort-Object -Unique)
        $labelText = ($labels -join ', ')
        $tokens = @($labels | ForEach-Object {
            if ($_ -match '^[dfgstuv]:([A-Za-z_]\w*)$') { $Matches[1] }
        } | Sort-Object -Unique)
        $matches = @($tokens | Where-Object {
            $escaped = [Regex]::Escape($_)
            $vendorText -match "(?<![A-Za-z0-9_])$escaped(?![A-Za-z0-9_])"
        })
        $matchText = if ($matches.Count) { ($matches -join ', ') } else { '—' }
        $decision = Get-RegionDecision -Name $name -Labels $labelText -DefaultState $policy[1] -DefaultDecision $policy[2]
        $safeLabels = $labelText.Replace('|', '\|')
        $safeMatches = $matchText.Replace('|', '\|')
        $safeDecision = $decision.Replace('|', '\|')
        $output.Add("| $start--$end | ``$safeLabels`` | ``$safeMatches`` | $safeDecision |")
        $covered += $end - $start + 1
        $totalRegions++
    }

    if ($covered -ne $lineCount) { throw "Coverage mismatch for ${name}: $covered/$lineCount" }
    $output.Add('')
    $output.Add("覆盖校验：$covered/$lineCount 行，连续、无空洞、无重叠。")
    $output.Add('')
    $totalLines += $lineCount
}

if ($totalLines -ne 22143) { throw "Expected 22143 current lines, got $totalLines" }
if ($totalFunctions -ne 524) { throw "Expected 524 current C function tags, got $totalFunctions" }

$output.Insert(11, "覆盖汇总：36/36 文件，$totalLines/$totalLines 行，$totalFunctions/$totalFunctions 个 C 函数定义，$totalRegions 个连续审阅区间。")
$output.Insert(12, '')

$outputPath = if ([IO.Path]::IsPathRooted($OutputFile)) {
    [IO.Path]::GetFullPath($OutputFile)
} else {
    [IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputFile))
}
[IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($outputPath)) | Out-Null
[IO.File]::WriteAllLines($outputPath, $output, [Text.UTF8Encoding]::new($false))

Write-Output "files=$($currentFiles.Count) lines=$totalLines functions=$totalFunctions regions=$totalRegions"
