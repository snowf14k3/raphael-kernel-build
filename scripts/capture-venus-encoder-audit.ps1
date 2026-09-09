param(
    [string]$CurrentRepo = 'F:\linux\test18-verify2',
    [string]$VendorRepo = 'F:\linux\vendor-sm8150-reference',
    [string]$BuildRepo = 'F:\linux\raphael-kernel-build',
    [string]$TestLog = 'C:\Users\pengp\.codex\attachments\034c527c-9dce-49f7-9ea3-8908332d7da7\pasted-text.txt'
)

$ErrorActionPreference = 'Stop'
$outputRoot = Join-Path $BuildRepo '.audit\test20-full-chain'
$currentRoot = Join-Path $outputRoot 'current'
$vendorRoot = Join-Path $outputRoot 'vendor'
$passesRoot = Join-Path $outputRoot 'passes'

[IO.Directory]::CreateDirectory($currentRoot) | Out-Null
[IO.Directory]::CreateDirectory($vendorRoot) | Out-Null
[IO.Directory]::CreateDirectory($passesRoot) | Out-Null

function Invoke-GitText {
    param([string]$Repository, [string[]]$Arguments)

    $text = & git -C $Repository @Arguments 2>&1 | Out-String -Width 4096
    if ($LASTEXITCODE -ne 0) {
        throw "git -C $Repository $($Arguments -join ' ') failed`n$text"
    }
    return $text
}

function Write-Utf8 {
    param([string]$Path, [string]$Text)

    [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($Path)) |
        Out-Null
    [IO.File]::WriteAllText($Path, $Text, [Text.UTF8Encoding]::new($false))
}

function Save-GitFile {
    param(
        [string]$Repository,
        [string]$Revision,
        [string]$GitPath,
        [string]$DestinationRoot
    )

    $safeName = $GitPath.Replace('/', '__') + '.txt'
    $destination = Join-Path $DestinationRoot $safeName
    $spec = if ($Revision -eq ':') { ":$GitPath" } else { "${Revision}:$GitPath" }
    $text = Invoke-GitText $Repository @('show', $spec)
    Write-Utf8 $destination $text
}

function Save-GitGrep {
    param(
        [string]$Name,
        [string]$Repository,
        [string]$Revision,
        [string]$Pattern,
        [string[]]$Paths
    )

    if ($Revision -eq ':') {
        $arguments = @('grep', '--cached', '-n', '-I', '-E', $Pattern, '--') + $Paths
    } else {
        $arguments = @('grep', '-n', '-I', '-E', $Pattern, $Revision, '--') + $Paths
    }
    $text = & git -C $Repository @arguments 2>&1 | Out-String -Width 4096
    if ($LASTEXITCODE -notin 0, 1) {
        throw "git grep failed for $Name`n$text"
    }
    Write-Utf8 (Join-Path $passesRoot "${Name}.txt") $text
}

$currentFiles = @(
    'arch/arm64/boot/dts/qcom/sm8150.dtsi',
    'drivers/clk/qcom/videocc-sm8150.c',
    'drivers/iommu/dma-iommu.c',
    'drivers/iommu/io-pgtable-arm.c',
    'drivers/media/common/videobuf2/videobuf2-core.c',
    'drivers/media/common/videobuf2/videobuf2-dma-contig.c',
    'drivers/media/platform/qcom/venus/core.c',
    'drivers/media/platform/qcom/venus/core.h',
    'drivers/media/platform/qcom/venus/helpers.c',
    'drivers/media/platform/qcom/venus/helpers.h',
    'drivers/media/platform/qcom/venus/hfi.c',
    'drivers/media/platform/qcom/venus/hfi.h',
    'drivers/media/platform/qcom/venus/hfi_cmds.c',
    'drivers/media/platform/qcom/venus/hfi_cmds.h',
    'drivers/media/platform/qcom/venus/hfi_helper.h',
    'drivers/media/platform/qcom/venus/hfi_msgs.c',
    'drivers/media/platform/qcom/venus/hfi_msgs.h',
    'drivers/media/platform/qcom/venus/hfi_parser.c',
    'drivers/media/platform/qcom/venus/hfi_platform_v4.c',
    'drivers/media/platform/qcom/venus/hfi_venus.c',
    'drivers/media/platform/qcom/venus/hfi_venus.h',
    'drivers/media/platform/qcom/venus/hfi_venus_io.h',
    'drivers/media/platform/qcom/venus/pm_helpers.c',
    'drivers/media/platform/qcom/venus/pm_helpers.h',
    'drivers/media/platform/qcom/venus/venc.c',
    'drivers/media/platform/qcom/venus/venc_ctrls.c',
    'include/linux/dma-map-ops.h',
    'include/linux/dma-mapping.h',
    'include/linux/iommu.h',
    'include/media/videobuf2-core.h',
    'kernel/dma/mapping.c'
)

$vendorFiles = @(
    'arch/arm64/boot/dts/qcom/sm8150-vidc.dtsi',
    'drivers/clk/qcom/videocc-sm8150.c',
    'drivers/iommu/arm-smmu.c',
    'drivers/iommu/dma-iommu.c',
    'drivers/iommu/io-pgtable-arm.c',
    'drivers/media/platform/msm/vidc/hfi_packetization.c',
    'drivers/media/platform/msm/vidc/hfi_packetization.h',
    'drivers/media/platform/msm/vidc/hfi_response_handler.c',
    'drivers/media/platform/msm/vidc/msm_smem.c',
    'drivers/media/platform/msm/vidc/msm_venc.c',
    'drivers/media/platform/msm/vidc/msm_vidc.c',
    'drivers/media/platform/msm/vidc/msm_vidc.h',
    'drivers/media/platform/msm/vidc/msm_vidc_clocks.c',
    'drivers/media/platform/msm/vidc/msm_vidc_common.c',
    'drivers/media/platform/msm/vidc/msm_vidc_common.h',
    'drivers/media/platform/msm/vidc/msm_vidc_platform.c',
    'drivers/media/platform/msm/vidc/msm_vidc_res_parse.c',
    'drivers/media/platform/msm/vidc/msm_vidc_resources.h',
    'drivers/media/platform/msm/vidc/venus_hfi.c',
    'drivers/media/platform/msm/vidc/vidc_hfi.h',
    'drivers/media/platform/msm/vidc/vidc_hfi_api.h',
    'drivers/media/platform/msm/vidc/vidc_hfi_helper.h',
    'drivers/media/platform/msm/vidc/vidc_hfi_io.h'
)

foreach ($path in $currentFiles) {
    Save-GitFile $CurrentRepo ':' $path $currentRoot
}
foreach ($path in $vendorFiles) {
    Save-GitFile $VendorRepo 'HEAD' $path $vendorRoot
}

$currentVenusPaths = @('drivers/media/platform/qcom/venus')
$vendorVidcPaths = @('drivers/media/platform/msm/vidc')

Save-GitGrep '01-platform-probe-firmware-current' $CurrentRepo ':' `
    'sm8150|probe|firmware|SESSION_INIT|SYS_INIT|codec_supported' $currentVenusPaths
Save-GitGrep '01-platform-probe-firmware-vendor' $VendorRepo 'HEAD' `
    'sm8150|probe|firmware|SESSION_INIT|SYS_INIT|codec_supported' $vendorVidcPaths

Save-GitGrep '02-power-clock-reset-current' $CurrentRepo ':' `
    'power|runtime|clock|clk_|reset|GDSC|hwmode|OPP|533000000' $currentVenusPaths
Save-GitGrep '02-power-clock-reset-vendor' $VendorRepo 'HEAD' `
    'power|runtime|clock|clk_|reset|GDSC|regulator|480000000' $vendorVidcPaths

Save-GitGrep '03-hfi-queues-cvp-current' $CurrentRepo ':' `
    'IFACEQ|queue|VIDC_CTRL_INIT|HFI_DSP|CVP|UC_REGION' $currentVenusPaths
Save-GitGrep '03-hfi-queues-cvp-vendor' $VendorRepo 'HEAD' `
    'IFACEQ|queue|VIDC_CTRL_INIT|HFI_DSP|domain_cvp|FastCVP|UC_REGION' $vendorVidcPaths

Save-GitGrep '04-session-format-current' $CurrentRepo ':' `
    'venc_init_session|FRAME_SIZE|UNCOMPRESSED_FORMAT|PLANE_ACTUAL|NV12|stride' $currentVenusPaths
Save-GitGrep '04-session-format-vendor' $VendorRepo 'HEAD' `
    'inst_init|FRAME_SIZE|UNCOMPRESSED_FORMAT|PLANE_ACTUAL|NV12|stride' $vendorVidcPaths

Save-GitGrep '05-controls-properties-current' $CurrentRepo ':' `
    'venc_set_properties|SET_PROPERTY|QP_RANGE|RATE_CONTROL|PROFILE_LEVEL|WORK_MODE|WORK_ROUTE' $currentVenusPaths
Save-GitGrep '05-controls-properties-vendor' $VendorRepo 'HEAD' `
    's_ctrl|SET_PROPERTY|QP_RANGE|RATE_CONTROL|PROFILE_LEVEL|WORK_MODE|WORK_ROUTE' $vendorVidcPaths

Save-GitGrep '06-requirements-counts-current' $CurrentRepo ':' `
    'BUFFER_REQUIREMENTS|BUFFER_COUNT_ACTUAL|count_min|bufreq|queue_setup' $currentVenusPaths
Save-GitGrep '06-requirements-counts-vendor' $VendorRepo 'HEAD' `
    'BUFFER_REQUIREMENTS|BUFFER_COUNT_ACTUAL|count_min|bufreq|queue_setup' $vendorVidcPaths

Save-GitGrep '07-internal-buffers-current' $CurrentRepo ':' `
    'INTERNAL_SCRATCH|INTERNAL_PERSIST|INTERNAL_RECON|SET_BUFFERS|intbuf' $currentVenusPaths
Save-GitGrep '07-internal-buffers-vendor' $VendorRepo 'HEAD' `
    'INTERNAL_SCRATCH|INTERNAL_PERSIST|INTERNAL_RECON|SET_BUFFERS|reconbuf' $vendorVidcPaths

Save-GitGrep '08-dma-iommu-cache-current' $CurrentRepo ':' `
    'dma_|IOMMU|upstream|non_coherent|cache|bidirectional' @(
        'drivers/media/platform/qcom/venus',
        'drivers/media/common/videobuf2',
        'drivers/iommu')
Save-GitGrep '08-dma-iommu-cache-vendor' $VendorRepo 'HEAD' `
    'dma_|IOMMU|upstream|cache|BIDIRECTIONAL|SMEM_CACHE' @(
        'drivers/media/platform/msm/vidc',
        'drivers/iommu')

Save-GitGrep '09-load-start-ftb-etb-current' $CurrentRepo ':' `
    'LOAD_RESOURCES|START|FILL_BUFFER|EMPTY_BUFFER|session_etb|session_ftb|process_initial' $currentVenusPaths
Save-GitGrep '09-load-start-ftb-etb-vendor' $VendorRepo 'HEAD' `
    'LOAD_RESOURCES|START|FILL_BUFFER|EMPTY_BUFFER|session_etb|session_ftb|qbufs' $vendorVidcPaths

Save-GitGrep '10-ebd-fbd-parser-current' $CurrentRepo ':' `
    'EMPTY_BUFFER_DONE|FILL_BUFFER_DONE|hfi_session_etb_done|hfi_session_ftb_done|buf_done|irq' $currentVenusPaths
Save-GitGrep '10-ebd-fbd-parser-vendor' $VendorRepo 'HEAD' `
    'EMPTY_BUFFER_DONE|FILL_BUFFER_DONE|etb_done|ftb_done|buffer_done|irq' $vendorVidcPaths

Save-GitGrep '11-stop-error-recovery-current' $CurrentRepo ':' `
    'STOP|RELEASE_RESOURCES|SESSION_END|abort|timeout|sys_error|unwind|cleanup' $currentVenusPaths
Save-GitGrep '11-stop-error-recovery-vendor' $VendorRepo 'HEAD' `
    'STOP|RELEASE_RESOURCES|SESSION_END|abort|timeout|fatal|kill_session|cleanup' $vendorVidcPaths

Save-GitGrep '12-runtime-resume-concurrency-current' $CurrentRepo ':' `
    'runtime|suspend|resume|instances|core_acquired|pm_|autosuspend' $currentVenusPaths
Save-GitGrep '12-runtime-resume-concurrency-vendor' $VendorRepo 'HEAD' `
    'runtime|suspend|resume|instances|core_id|power_collapse|dcvs' $vendorVidcPaths

Save-GitGrep '13-hfi-numeric-abi-current' $CurrentRepo ':' `
    '#define HFI_(CMD|MSG|PROPERTY|BUFFER|COLOR|RATE|NAL)|struct hfi_(session|frame|buffer|quantization)' $currentVenusPaths
Save-GitGrep '13-hfi-numeric-abi-vendor' $VendorRepo 'HEAD' `
    '#define HFI_(CMD|MSG|PROPERTY|BUFFER|COLOR|RATE|NAL)|struct hfi_(cmd|msg|buffer|quantization)' $vendorVidcPaths

Save-GitGrep '14-sm8150-topology-clock-current' $CurrentRepo ':' `
    'sm8150|iommus|power-domains|clock|opp-|533000000|444000000|365000000|338000000|240000000' @(
        'arch/arm64/boot/dts/qcom/sm8150.dtsi',
        'drivers/clk/qcom/videocc-sm8150.c',
        'drivers/media/platform/qcom/venus/core.c')
Save-GitGrep '14-sm8150-topology-clock-vendor' $VendorRepo 'HEAD' `
    'sm8150|iommus|regulator|clock|allowed-clock-rates|533000000|480000000|432000000|365000000|300000000|225000000' @(
        'arch/arm64/boot/dts/qcom/sm8150-vidc.dtsi',
        'drivers/clk/qcom/videocc-sm8150.c',
        'drivers/media/platform/msm/vidc/msm_vidc_platform.c')

Save-GitGrep '15-private-deferred-current' $CurrentRepo ':' `
    'EOPNOTSUPP|ENOTSUPP|not supported|TODO|secure|CVP|TME|HEIC|extradata|metadata|DMABUF' $currentVenusPaths
Save-GitGrep '15-private-deferred-vendor' $VendorRepo 'HEAD' `
    'EOPNOTSUPP|ENOTSUPP|not supported|TODO|secure|CVP|TME|HEIC|extradata|metadata|DMABUF' $vendorVidcPaths

Save-GitGrep '16-dma-public-api-current' $CurrentRepo ':' `
    'dma_alloc_noncontiguous|DMA_ATTR_ALLOC_SINGLE_PAGES|DMA_ATTR_IOMMU_USE_UPSTREAM_HINT|WARN_ON_ONCE\(attrs' @(
        'kernel/dma/mapping.c',
        'include/linux/dma-mapping.h',
        'include/linux/dma-map-ops.h',
        'drivers/iommu/dma-iommu.c',
        'drivers/media/common/videobuf2/videobuf2-dma-contig.c')
Save-GitGrep '16-dma-public-api-vendor' $VendorRepo 'HEAD' `
    'dma_buf_map_attachment|dma_map_attrs|DMA_ATTR_IOMMU_USE_UPSTREAM_HINT|DMA_ATTR_SKIP_CPU_SYNC|cache_operations' @(
        'drivers/media/platform/msm/vidc/msm_smem.c',
        'drivers/media/platform/msm/vidc/msm_vidc_common.c',
        'drivers/iommu/dma-iommu.c')

$manifest = @(
    "captured_utc=$([DateTime]::UtcNow.ToString('o'))",
    "current_repo=$CurrentRepo",
    "current_head=$(Invoke-GitText $CurrentRepo @('rev-parse', 'HEAD'))".Trim(),
    "current_index_tree=$(Invoke-GitText $CurrentRepo @('write-tree'))".Trim(),
    "vendor_repo=$VendorRepo",
    "vendor_head=$(Invoke-GitText $VendorRepo @('rev-parse', 'HEAD'))".Trim(),
    "build_repo=$BuildRepo",
    "build_head=$(Invoke-GitText $BuildRepo @('rev-parse', 'HEAD'))".Trim(),
    "series_count=$((Get-Content (Join-Path $BuildRepo 'patches\series')).Count)",
    "test_log=$TestLog"
) -join "`n"
Write-Utf8 (Join-Path $outputRoot '00-manifest.txt') ($manifest + "`n")

if (Test-Path -LiteralPath $TestLog) {
    Write-Utf8 (Join-Path $outputRoot 'test20-external-dmesg.log') `
        ([IO.File]::ReadAllText($TestLog))
}

$currentDiff = Invoke-GitText $CurrentRepo @(
    'diff', '--cached', '--',
    'drivers/media/platform/qcom/venus',
    'drivers/media/common/videobuf2',
    'drivers/iommu',
    'include/linux/dma-mapping.h',
    'include/linux/iommu.h')
Write-Utf8 (Join-Path $outputRoot 'current-index-vs-baseline.diff') $currentDiff

$hashLines = Get-ChildItem -LiteralPath $outputRoot -File -Recurse |
    Where-Object Name -ne 'SHA256SUMS' |
    Sort-Object FullName |
    ForEach-Object {
        $relative = [IO.Path]::GetRelativePath($outputRoot, $_.FullName)
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLower()
        "$hash  $relative"
    }
Write-Utf8 (Join-Path $outputRoot 'SHA256SUMS') (($hashLines -join "`n") + "`n")

Write-Output "evidence_root=$outputRoot"
Write-Output "files=$((Get-ChildItem -LiteralPath $outputRoot -File -Recurse).Count)"
