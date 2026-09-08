#!/usr/bin/env python3
"""Compile selected *actual patched functions* against fault-injecting host mocks.

This checks C control flow/resource ownership, not kernel ABI or real hardware.
Run after git apply and before the full arm64 kernel build.
"""
import argparse
import os
from pathlib import Path
import re
import subprocess
import tempfile


def function(source, name):
    start = re.search(
        r"^static [^{;]*?\b" + re.escape(name) + r"\([^;{]*\)\s*\{",
        source, re.MULTILINE,
    )
    if not start:
        start = re.search(
            r"^[A-Za-z_][A-Za-z0-9_ \t*]*\b" + re.escape(name) +
            r"\([^;{]*\)\s*\{",
            source, re.MULTILINE,
        )
    if not start:
        raise RuntimeError(f"Function not found: {name}")
    opening = source.index("{", start.start())
    depth = 0
    tokens = re.finditer(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|'
                         r"'(?:\\.|[^'\\])*'|[{}]", source[opening:], re.DOTALL)
    for token in tokens:
        if token.group() == "{":
            depth += 1
        elif token.group() == "}":
            depth -= 1
            if depth == 0:
                return source[start.start():opening + token.end()]
    raise RuntimeError(f"Unterminated function: {name}")


def validate_protocol_sources(driver):
    cmds = (driver / "hfi_cmds.c").read_text(encoding="utf-8")
    helper = (driver / "hfi_helper.h").read_text(encoding="utf-8")
    messages = (driver / "hfi_msgs.c").read_text(encoding="utf-8")

    packetizer = function(cmds, "pkt_session_set_property_4xx")
    route_case = packetizer.find("case HFI_PROPERTY_PARAM_WORK_ROUTE:")
    fallback = packetizer.find("default:")
    if route_case < 0 or fallback < route_case:
        raise RuntimeError("HFI 4xx WORK_ROUTE is not handled before fallback")
    route_body = packetizer[route_case:fallback]
    for required in ("wr->video_work_route = in->video_work_route",
                     "sizeof(u32) + sizeof(*wr)"):
        if required not in route_body:
            raise RuntimeError(f"Incomplete HFI 4xx WORK_ROUTE packet: {required}")

    legacy = function(cmds, "pkt_session_set_property_1x")
    if "case HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE:" not in legacy:
        raise RuntimeError("VENC low-latency property has no generic packetizer")

    encoder_etb = function(cmds, "pkt_session_etb_encoder")
    if "pkt->data = 0" not in encoder_etb:
        raise RuntimeError("VPU5 encoder ETB leaves its reserved word uninitialized")

    if "#define HFI_BUFFER_TYPE_MAX\t\t\t12" not in helper or \
       "internal recon requirement" not in helper:
        raise RuntimeError("HFI 4xx buffer-requirement capacity is incomplete")
    parser = function(messages, "session_get_prop_buf_req")
    bounds = parser.find("if (idx >= HFI_BUFFER_TYPE_MAX)")
    copy = parser.find("memcpy(&bufreq[idx]")
    if bounds < 0 or copy < 0 or bounds > copy:
        raise RuntimeError("Buffer-requirement bounds check must precede memcpy")

    dispatcher = function(messages, "hfi_process_msg_packet")
    if "(!handler->pkt_sz2 || hdr->size < handler->pkt_sz2)" not in dispatcher:
        raise RuntimeError("HFI response dispatcher accepts undersized fixed packets")
    print("PASS: HFI 4xx packets, 12-entry parser and response-size invariants")


def validate_format_sources(driver):
    decoder = (driver / "vdec.c").read_text(encoding="utf-8")
    controls = (driver / "vdec_ctrls.c").read_text(encoding="utf-8")
    helpers = (driver / "helpers.c").read_text(encoding="utf-8")
    hfi = (driver / "hfi.c").read_text(encoding="utf-8")
    s_fmt = function(decoder, "vdec_s_fmt")
    source_change = function(decoder, "vdec_event_change")
    session_init = function(hfi, "hfi_session_init")
    p010_size = function(helpers, "get_framesize_raw_p010")
    try_fmt = function(decoder, "vdec_try_fmt_common")
    find_fmt = function(decoder, "find_format")
    enum_fmt = function(decoder, "find_format_by_index")

    codec_sync = "inst->hfi_codec = venus_helper_get_codec(fmt->pixfmt);"
    if codec_sync not in s_fmt:
        raise RuntimeError("decoder S_FMT does not synchronize the selected HFI codec")
    if "inst->hfi_codec = venus_helper_get_codec(pixfmt);" not in session_init:
        raise RuntimeError("HFI session init is not using the shared codec mapping")

    depth = source_change.find("if (inst->bit_depth != ev_data->bit_depth)")
    select = source_change.find("format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt")
    normalize = source_change.find("vdec_try_fmt_common(inst, &format)")
    if min(depth, select, normalize) < 0 or not depth < select < normalize:
        raise RuntimeError("10-bit capture format must be selected before normalization")

    if "ALIGN(width * 2, 256)" not in p010_size or \
       "ALIGN(stride, 256)" not in try_fmt:
        raise RuntimeError("linear P010 does not use the required 256-byte stride")
    for required in ("pixmp->pixelformat = V4L2_PIX_FMT_P010",
                     "pixmp->pixelformat == V4L2_PIX_FMT_QC10C",
                     "stride = stride * 4 / 3",
                     "pixmp->height = ALIGN(pixmp->height, 16)"):
        if required not in try_fmt:
            raise RuntimeError(f"10-bit fallback/format geometry is incomplete: {required}")
    if "vdec_fmt_is_8bit" not in find_fmt or "vdec_fmt_is_10bit" not in find_fmt:
        raise RuntimeError("capture TRY/S_FMT does not enforce stream bit depth")
    if "inst->bit_depth" in enum_fmt:
        raise RuntimeError("ENUM_FMT must stay stable across stream bit-depth changes")
    for required in ("V4L2_CID_MPEG_VIDEO_HEVC_PROFILE",
                     "V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10"):
        if required not in controls:
            raise RuntimeError(f"decoder HEVC profile control is incomplete: {required}")

    print("PASS: codec, Main10/P010 negotiation and 256-byte stride invariants")


def validate_encoder_sources(driver):
    core_header = (driver / "core.h").read_text(encoding="utf-8")
    pm = (driver / "pm_helpers.c").read_text(encoding="utf-8")
    commands = (driver / "hfi_cmds.c").read_text(encoding="utf-8")
    command_header = (driver / "hfi_cmds.h").read_text(encoding="utf-8")
    helper = (driver / "hfi_helper.h").read_text(encoding="utf-8")
    hfi = (driver / "hfi.c").read_text(encoding="utf-8")
    venus = (driver / "hfi_venus.c").read_text(encoding="utf-8")
    helpers = (driver / "helpers.c").read_text(encoding="utf-8")
    encoder = (driver / "venc.c").read_text(encoding="utf-8")
    controls = (driver / "venc_ctrls.c").read_text(encoding="utf-8")

    core_get = function(pm, "core_get_iris1")
    llcc_enable = function(pm, "iris1_llcc_enable")
    llcc_disable = function(pm, "iris1_llcc_disable")
    core_power = function(pm, "core_power_iris1")
    power_off = function(pm, "iris1_power_off")
    for required in ("LLCC_VIDSC0", "LLCC_VIDSC1", "llcc_slice_getd"):
        if required not in core_get:
            raise RuntimeError(f"SM8150 LLCC acquisition is incomplete: {required}")
    if "llcc_slice_activate" not in llcc_enable or \
       "llcc_slice_deactivate" not in llcc_disable:
        raise RuntimeError("SM8150 LLCC power-collapse lifetime is incomplete")
    if "iris1_llcc_enable(core)" not in core_power or \
       "iris1_llcc_disable(core)" not in power_off:
        raise RuntimeError("IRIS1 runtime power does not own both LLCC slices")

    for required in ("#define HFI_RESOURCE_SYSCACHE\t0x2",
                     "struct hfi_resource_subcache",
                     "struct hfi_resource_syscache"):
        if required not in helper:
            raise RuntimeError(f"HFI system-cache ABI is incomplete: {required}")
    if "pkt_sys_set_resource_syscache" not in command_header:
        raise RuntimeError("HFI system-cache packetizer is not declared")
    resource = function(commands, "pkt_sys_set_resource_syscache")
    for required in ("HFI_CMD_SYS_SET_RESOURCE", "HFI_RESOURCE_SYSCACHE",
                     "res->num_entries = num_entries", "memcpy(res->entries"):
        if required not in resource:
            raise RuntimeError(f"HFI system-cache packet is incomplete: {required}")

    set_syscache = function(venus, "venus_hfi_core_set_syscache")
    for required in ("llcc_get_slice_size", "llcc_get_slice_id",
                     "pkt_sys_set_resource_syscache", "venus_iface_cmdq_write"):
        if required not in set_syscache:
            raise RuntimeError(f"Venus system-cache setup is incomplete: {required}")
    core_init = function(venus, "venus_core_init")
    system_init = core_init.find("pkt_sys_init(&pkt")
    cache_init = core_init.find("venus_hfi_core_set_syscache(core)")
    if min(system_init, cache_init) < 0 or system_init > cache_init:
        raise RuntimeError("HFI system cache must be queued after SYS_INIT")

    packetizer = function(commands, "pkt_session_set_property_4xx")
    frame_qp = packetizer.find("case HFI_PROPERTY_CONFIG_VENC_FRAME_QP:")
    fallback = packetizer.find("default:")
    if frame_qp < 0 or fallback < frame_qp:
        raise RuntimeError("HFI 4xx FRAME_QP is not handled before fallback")
    frame_qp_body = packetizer[frame_qp:fallback]
    for required in ("in->qp_i | (in->qp_p << 8)", "in->qp_b << 16",
                     "quant->enable = 7", "sizeof(u32) + sizeof(*quant)"):
        if required not in frame_qp_body:
            raise RuntimeError(f"HFI 4xx FRAME_QP packet is incomplete: {required}")

    legacy_packetizer = function(commands, "pkt_session_set_property_1x")
    # VPU5 falls through the 4xx/3xx packetizers to these common cases.
    for property_name in ("HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS",
                          "HFI_PROPERTY_PARAM_VPE_ROTATION",
                          "HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT"):
        if f"case {property_name}:" not in legacy_packetizer:
            raise RuntimeError(
                f"VPU5 property has no common packetizer: {property_name}")
    property_ids = {
        "HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS": "0x2005038",
        "HFI_PROPERTY_PARAM_VPE_ROTATION": "0x3007001",
    }
    for property_name, expected_id in property_ids.items():
        match = re.search(r"^#define\s+" + re.escape(property_name) +
                          r"\s+(0x[0-9a-fA-F]+)$", helper, re.MULTILINE)
        if not match or match.group(1).lower() != expected_id.lower():
            raise RuntimeError(
                f"VPU5 property ID differs from downstream: {property_name}")
    profile_case = legacy_packetizer.find("case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:")
    next_case = legacy_packetizer.find("case ", profile_case + 5)
    profile_body = legacy_packetizer[profile_case:next_case]
    if "!pl->level && !IS_IRIS1(inst->core)" not in profile_body:
        raise RuntimeError("HFI packetizer overwrites VPU5 automatic H.264 level zero")

    profile_level = function(helpers, "venus_helper_set_profile_level")
    for required in ("IS_IRIS1(inst->core)", "HFI_VIDEO_CODEC_H264",
                     "V4L2_MPEG_VIDEO_H264_LEVEL_5_1", "pl.level = 0"):
        if required not in profile_level:
            raise RuntimeError(f"SM8150 automatic H.264 level is incomplete: {required}")
    properties = function(encoder, "venc_set_properties")
    for required in ("!ctr->rc_enable", "HFI_PROPERTY_CONFIG_VENC_FRAME_QP",
                     "IS_IRIS1(inst->core) ? HFI_LAYER_ID_ALL : 0",
                     "HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS",
                     "HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT",
                     "HFI_NAL_FORMAT_STARTCODES",
                     "!IS_IRIS1(inst->core) || ctr->ltr_count",
                     "ltr_mode.ltr_mode = HFI_LTR_MODE_MANUAL",
                     "ltr_mode.trust_mode = 1",
                     "VPU5 downstream leaves VUI timing disabled"):
        if required not in properties:
            raise RuntimeError(f"SM8150 encoder property setup is incomplete: {required}")

    max_bitrate_guard = properties.find("if (!IS_IRIS1(inst->core))")
    max_bitrate = properties.find("HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE")
    if min(max_bitrate_guard, max_bitrate) < 0 or max_bitrate_guard > max_bitrate:
        raise RuntimeError("VPU5 must not receive unsupported CONFIG_VENC_MAX_BITRATE")

    if "#define HFI_LAYER_ID_ALL\t0xff" not in helper:
        raise RuntimeError("VPU5 all-layer identifier is missing")

    preflight = function(encoder, "venc_iris1_preflight")
    for required in ("iris1_pd_mask != GENMASK(2, 0)",
                     "iris1_clk_mask != GENMASK(2, 0)",
                     "iris1_hw_mask != GENMASK(2, 1)",
                     "iris1_llcc_mask != GENMASK(VIDC_IRIS1_LLCC_NUM - 1, 0)",
                     "venus_iris1_encoder_enable"):
        if required not in preflight:
            raise RuntimeError(f"SM8150 encoder fail-closed preflight is incomplete: {required}")

    init_session = function(encoder, "venc_init_session")
    gate = init_session.find("!READ_ONCE(venus_iris1_encoder_enable)")
    hfi_init = init_session.find("venus_helper_session_init(inst)")
    if min(gate, hfi_init) < 0 or gate > hfi_init:
        raise RuntimeError("SM8150 encoder safety lock is checked after HFI session init")
    if "if (!IS_IRIS1(inst->core))" not in init_session or \
       "venc_set_properties(inst, true)" not in init_session:
        raise RuntimeError("VPU5 properties are still duplicated during queue setup")
    initial_counts = init_session.find("VENUS_IRIS1_ENC_MIN_BUFFERS")
    input_resolution = init_session.find("venus_helper_set_input_resolution")
    stride_guard = init_session.find("if (!IS_IRIS1(inst->core))")
    stride_property = init_session.find("venus_helper_set_stride")
    if min(initial_counts, input_resolution, stride_guard, stride_property) < 0 or \
       initial_counts > input_resolution or stride_guard > stride_property:
        raise RuntimeError("VPU5 initial 4/4 counts or linear-NV12 stride omission is incomplete")

    if "bufreq_cache[HFI_BUFFER_TYPE_MAX]" not in core_header or \
       "bufreq_cache_valid" not in core_header:
        raise RuntimeError("VPU5 buffer-requirements snapshot is missing")
    if "#define VENUS_IRIS1_ENC_MIN_BUFFERS\t4" not in core_header:
        raise RuntimeError("VPU5 encoder V4L2 queue minimum is incomplete")
    cache_bufreqs = function(helpers, "venus_helper_cache_bufreqs")
    if cache_bufreqs.count("hfi_session_get_property(inst, ptype, &hprop)") != 1:
        raise RuntimeError("VPU5 requirements snapshot must issue exactly one HFI GET")
    for required in ("seen & BIT(req->type)",
                     "count_actual > VIDEO_MAX_FRAME",
                     "count_min > VIDEO_MAX_FRAME",
                     "count_min_host > VIDEO_MAX_FRAME",
                     "!is_power_of_2(req->alignment)",
                     "count_actual < count_min",
                     "inst->bufreq_cache_valid = true"):
        if required not in cache_bufreqs:
            raise RuntimeError(f"VPU5 requirements validation is incomplete: {required}")
    for forbidden in ("req->count_actual =",
                      "hfi_bufreq_set_count_min(req",
                      "hfi_bufreq_set_count_min_host(req"):
        if forbidden in cache_bufreqs:
            raise RuntimeError(
                f"Firmware buffer requirements are mutated in the cache: {forbidden}")

    get_bufreq = function(helpers, "venus_helper_get_bufreq")
    for required in ("IS_IRIS1(inst->core)",
                     "inst->session_type == VIDC_SESSION_TYPE_ENC",
                     "inst->bufreq_cache_valid", "inst->bufreq_cache"):
        if required not in get_bufreq:
            raise RuntimeError(f"VPU5 requirements cache use is incomplete: {required}")

    queue_setup = function(encoder, "venc_queue_setup")
    iris_queue = queue_setup.find("if (IS_IRIS1(core))")
    legacy_query = queue_setup.find("venc_out_num_buffers(inst, &num)")
    if min(iris_queue, legacy_query) < 0 or iris_queue > legacy_query:
        raise RuntimeError("VPU5 queue setup still performs an early firmware GET")

    volatile_ctrl = function(controls, "venc_op_g_volatile_ctrl")
    iris_ctrl = volatile_ctrl.find("if (IS_IRIS1(inst->core))")
    ctrl_query = volatile_ctrl.find("venus_helper_get_bufreq")
    if min(iris_ctrl, ctrl_query) < 0 or iris_ctrl > ctrl_query:
        raise RuntimeError("VPU5 control enumeration still performs an early firmware GET")

    count_packet = packetizer[packetizer.find(
        "case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL:"):
        packetizer.find("case HFI_PROPERTY_PARAM_WORK_MODE:")]
    if "count->count_min_host = in->count_min_host" not in count_packet:
        raise RuntimeError("HFI4 BUFFER_COUNT_ACTUAL drops the firmware host minimum")
    legacy_count = legacy_packetizer[legacy_packetizer.find(
        "case HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL:"):
        legacy_packetizer.find("case HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL:")]
    if "struct hfi_buffer_count_actual_1xx *count" not in legacy_count:
        raise RuntimeError("HFI1 BUFFER_COUNT_ACTUAL wire size was not preserved")
    set_num_bufs = function(helpers, "venus_helper_set_num_bufs")
    for required in ("buf_count.count_min_host = input_bufs",
                     "buf_count.count_min_host = output_bufs",
                     "venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT",
                     "venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT"):
        if required not in set_num_bufs:
            raise RuntimeError(f"HFI4 host buffer count is incomplete: {required}")
    if set_num_bufs.count("hfi_bufreq_get_count_min(&bufreq, ver)") != 2:
        raise RuntimeError(
            "IRIS1 final count_min_host must use both firmware minima")
    if set_num_bufs.count("iris1_encoder && inst->bufreq_cache_valid") != 2:
        raise RuntimeError(
            "IRIS1 initial 4/4 must not consult the unavailable requirements cache")
    for required in ('source=%s', '"firmware" : "initial"'):
        if required not in set_num_bufs:
            raise RuntimeError(
                f"IRIS1 buffer-count phase diagnostics are incomplete: {required}")

    intbufs = function(helpers, "intbufs_set_buffer")
    for required in ("i < bufreq.count_actual",
                     "SET_BUFFERS begin", "SET_BUFFERS queued",
                     "not requested by firmware, skip"):
        if required not in intbufs:
            raise RuntimeError(f"Internal-buffer diagnostics are incomplete: {required}")
    for required in ("ALIGN(bufreq.size, SZ_4K)",
                     "upper_32_bits(buf->da)",
                     "bd.buffer_size = buf->size",
                     "bd.device_addr = buf->da"):
        if required not in intbufs:
            raise RuntimeError(
                f"IRIS1 internal DMA size/address guard is incomplete: {required}")

    process_buf = function(helpers, "session_process_buf")
    address_guard = process_buf.find("upper_32_bits(buf->dma_addr)")
    address_copy = process_buf.find("fdata.device_addr = buf->dma_addr")
    if min(address_guard, address_copy) < 0 or address_guard > address_copy:
        raise RuntimeError(
            "Frame IOVA is truncated into the HFI field before validation")
    for required in ("queue %s tag=%u", "alloc=%u filled=%u offset=%u"):
        if required not in process_buf:
            raise RuntimeError(
                f"Encoder FTB/ETB submit diagnostics are incomplete: {required}")
    for required in ("queued %s tag=%u ret=%d",
                     "ret = hfi_session_process_buf(inst, &fdata)"):
        if required not in process_buf:
            raise RuntimeError(
                f"Encoder post-submit diagnostics are incomplete: {required}")

    work_mode = function(helpers, "venus_helper_get_work_mode")
    for required in ("IS_IRIS1(inst->core)", "ctr->rc_enable",
                     "V4L2_MPEG_VIDEO_BITRATE_MODE_VBR",
                     "mode = VIDC_WORK_MODE_1"):
        if required not in work_mode:
            raise RuntimeError(
                f"SM8150 RC-dependent work-mode policy is incomplete: {required}")

    intbuf_free = function(helpers, "intbufs_unset_buffers")
    for required in ("RELEASE_BUFFERS begin", "RELEASE_BUFFERS done",
                     "bd.response_required = true", "first_err"):
        if required not in intbuf_free:
            raise RuntimeError(f"Internal-buffer cleanup diagnostics are incomplete: {required}")

    intbuf_alloc = function(helpers, "venus_helper_intbufs_alloc")
    protocol_gate = intbuf_alloc.find(
        "inst->enc_test_stage == VENUS_IRIS1_ENC_STAGE_PROTOCOL")
    zero_buffers = intbuf_alloc.find("arr_sz = 0", protocol_gate)
    prefix_gate = intbuf_alloc.find(
        "inst->enc_test_stage <= VENUS_IRIS1_ENC_STAGE_INTERNAL")
    if min(protocol_gate, zero_buffers, prefix_gate) < 0 or \
       not protocol_gate < zero_buffers < prefix_gate:
        raise RuntimeError("Stage 0 is not independently protected from internal DMA")

    start = function(encoder, "venc_start_streaming")
    stop = function(encoder, "venc_stop_streaming")
    start_get = start.find("venc_pm_get(inst)")
    start_properties = start.find("venc_set_properties(inst, false)")
    start_rotation = start.find("venc_iris1_set_rotation(inst)")
    start_route = start.find("venus_helper_set_work_route(inst)")
    start_mode = start.find("venus_helper_set_work_mode(inst)")
    start_core = start.find("venus_pm_acquire_core(inst)")
    start_preflight = start.find("venc_iris1_preflight(inst)")
    start_requirements = start.find("venus_helper_cache_bufreqs(inst)")
    start_counts = start.find("venus_helper_set_num_bufs")
    start_bufsize = start.find("venus_helper_set_bufsize")
    final_requirements = start.find("venus_helper_cache_bufreqs(inst)",
                                    start_requirements + 1)
    start_verify = start.find("venc_verify_conf(inst)")
    start_stage_gate = start.find("venc_iris1_stage_preflight(inst)")
    start_hw = start.find("venus_helper_vb2_start_streaming(inst)")
    start_pin = start.find("inst->enc_pm_active = true")
    ordered = (start_get, start_rotation, start_properties, start_route,
               start_mode, start_core, start_preflight, start_requirements, start_counts,
               start_bufsize, final_requirements, start_verify,
               start_stage_gate, start_hw, start_pin)
    if min(ordered) < 0 or list(ordered) != sorted(ordered):
        raise RuntimeError("IRIS1 encoder setup/DMA/PM ordering differs from audited sequence")
    release_core = start.find("venus_pm_release_core(inst)", start.find("error:"))
    error_pm_put = start.find("venc_pm_put(inst, false)", start.find("error:"))
    if min(release_core, error_pm_put) < 0 or release_core > error_pm_put:
        raise RuntimeError("IRIS1 start error suspends power before releasing core ownership")

    stage_preflight = function(encoder, "venc_iris1_stage_preflight")
    for required in ("venus_iris1_encoder_stage",
                     "VENUS_IRIS1_ENC_STAGE_FULL", "return -EACCES",
                     "inst->enc_test_stage = stage"):
        if required not in stage_preflight:
            raise RuntimeError(f"Encoder stage gate is incomplete: {required}")
    for required in ("VENUS_IRIS1_ENC_STAGE_PROTOCOL",
                     "VENUS_IRIS1_ENC_STAGE_INTERNAL",
                     "VENUS_IRIS1_ENC_STAGE_LOAD",
                     "VENUS_IRIS1_ENC_STAGE_START",
                     "VENUS_IRIS1_ENC_STAGE_CAPTURE",
                     "VENUS_IRIS1_ENC_STAGE_FULL",
                     "u8 enc_test_stage"):
        if required not in core_header:
            raise RuntimeError(f"Encoder checkpoint state is incomplete: {required}")

    helper_start = function(helpers, "venus_helper_vb2_start_streaming")
    internal = helper_start.find("venus_helper_intbufs_alloc(inst)")
    internal_stop = helper_start.find("VENUS_IRIS1_ENC_STAGE_INTERNAL")
    load = helper_start.find("hfi_session_load_res(inst)")
    load_stop = helper_start.find("VENUS_IRIS1_ENC_STAGE_LOAD")
    hw_start = helper_start.find("hfi_session_start(inst)")
    start_stop = helper_start.find("VENUS_IRIS1_ENC_STAGE_START")
    checkpoints = (internal, internal_stop, load, load_stop,
                   hw_start, start_stop)
    if min(checkpoints) < 0 or list(checkpoints) != sorted(checkpoints):
        raise RuntimeError("Encoder internal/LOAD/START checkpoints are out of order")
    for required in ("staged STOP ret=%d", "staged RELEASE_RESOURCES ret=%d",
                     "staged internal cleanup ret=%d"):
        if required not in helper_start:
            raise RuntimeError(
                f"Encoder staged rollback diagnostics are incomplete: {required}")

    unload = function(hfi, "hfi_session_unload_res")
    for required in ("IS_IRIS1(inst->core)", "INST_LOAD_RESOURCES",
                     "inst->state != INST_STOP"):
        if required not in unload:
            raise RuntimeError(
                f"IRIS1 LOAD-only rollback is not permitted safely: {required}")
    load_rollback = helper_start.find("hfi_session_unload_res(inst)", load_stop)
    free_after_unload = helper_start.find("venus_helper_intbufs_free(inst)",
                                          load_rollback)
    if min(load_rollback, free_after_unload) < 0 or load_rollback > free_after_unload:
        raise RuntimeError(
            "LOAD-only rollback frees internal DMA before releasing firmware resources")

    device_run = function(helpers, "venus_helper_m2m_device_run")
    for required in ("VENUS_IRIS1_ENC_STAGE_CAPTURE",
                     "VENUS_IRIS1_ENC_STAGE_FULL"):
        if required not in device_run:
            raise RuntimeError(f"Encoder user-DMA checkpoint is missing: {required}")
    stop_hw = stop.find("venus_helper_vb2_stop_streaming(q)")
    stop_put = stop.find("venc_pm_put(inst, true)")
    if min(stop_hw, stop_put) < 0 or stop_hw > stop_put:
        raise RuntimeError("IRIS1 encoder power is released before STOP/UNLOAD")

    release = function(encoder, "venc_release_session")
    get_power = release.find("ret = venc_pm_get(inst)")
    skip = release.find("goto release_core")
    session_end = release.find("hfi_session_deinit(inst)")
    if min(get_power, skip, session_end) < 0 or not get_power < skip < session_end:
        raise RuntimeError("SESSION_END may still be sent when encoder power is unavailable")

    dynamic = function(controls, "venc_op_s_ctrl")
    if "IS_IRIS1(inst->core) ?\n\t\t\t\t\t     HFI_LAYER_ID_ALL : 0" not in dynamic:
        raise RuntimeError("Dynamic VPU5 bitrate update does not address all layers")
    for required in ("V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE",
                     "V4L2_MPEG_VIDEO_H264_LEVEL_5_1"):
        if required not in controls:
            raise RuntimeError(f"SM8150 encoder defaults are incomplete: {required}")

    transform_case = dynamic[dynamic.find(
        "case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:"):]
    transform_case = transform_case[:transform_case.find("case ", 5)]
    if "if (ctrl->val &&" not in transform_case:
        raise RuntimeError("Disabled H.264 8x8 transform is rejected for Baseline")

    control_init = function(controls, "venc_ctrl_init")
    for required in ("u32 h264_8x8_default = 1",
                     "h264_8x8_default = 0",
                     "h264_8x8_default);",
                     "venus-test11: encoder control defaults failed"):
        if required not in control_init:
            raise RuntimeError(f"SM8150 8x8 control default fix is incomplete: {required}")

    created_controls = set(re.findall(
        r"v4l2_ctrl_new_std(?:_menu|_compound)?\s*\("
        r"[^;]*?\b(V4L2_CID_[A-Z0-9_]+)\b[^;]*?\);",
        control_init, re.DOTALL))
    handled_controls = set(re.findall(
        r"case\s+(V4L2_CID_[A-Z0-9_]+)\s*:", dynamic))
    volatile_controls = set(re.findall(
        r"case\s+(V4L2_CID_[A-Z0-9_]+)\s*:", volatile_ctrl))
    missing_controls = created_controls - handled_controls - volatile_controls
    if missing_controls:
        raise RuntimeError(
            "Encoder defaults call an unhandled s_ctrl: " +
            ", ".join(sorted(missing_controls)))

    print("PASS: SM8150 syscache, encoder protocol, PM pin and safety-gate invariants")


def validate_panel_sources(kernel):
    panel_source = (kernel / "drivers/gpu/drm/panel/"
                    "panel-samsung-ams639rq08.c").read_text(encoding="utf-8")
    update = function(panel_source, "ams639rq08_bl_update_status")
    get_brightness = function(panel_source, "ams639rq08_bl_get_brightness")
    worker = function(panel_source, "ams639rq08_brightness_work")
    unprepare = function(panel_source, "ams639rq08_unprepare")

    for required in ("struct delayed_work brightness_work",
                     "struct mutex brightness_lock",
                     "AMS639RQ08_BRIGHTNESS_INTERVAL_MS\t250"):
        if required not in panel_source:
            raise RuntimeError(f"Raphael brightness coalescing is incomplete: {required}")
    for required in ("ctx->pending_brightness = brightness",
                     "mod_delayed_work(system_wq, &ctx->brightness_work, delay)"):
        if required not in update:
            raise RuntimeError(f"Brightness update is not coalesced: {required}")
    if "mipi_dsi_dcs_set_display_brightness_large" not in worker:
        raise RuntimeError("Brightness worker does not send the final DCS value")
    if "ctx->brightness" not in get_brightness or \
       "mipi_dsi_dcs_get_display_brightness_large" in get_brightness:
        raise RuntimeError("Brightness readback still adds a DSI transaction")
    if "mode_flags" in update or "mode_flags" in get_brightness:
        raise RuntimeError("Backlight callbacks change DSI mode outside the worker")
    for required in ("mode_flags = ctx->dsi->mode_flags",
                     "ctx->dsi->mode_flags |= MIPI_DSI_MODE_LPM",
                     "ctx->dsi->mode_flags = mode_flags"):
        if required not in worker:
            raise RuntimeError(f"Brightness worker does not preserve LP mode: {required}")
    select_lp = worker.find("ctx->dsi->mode_flags |= MIPI_DSI_MODE_LPM")
    transfer = worker.find("mipi_dsi_dcs_set_display_brightness_large")
    restore = worker.find("ctx->dsi->mode_flags = mode_flags")
    if min(select_lp, transfer, restore) < 0 or \
       not select_lp < transfer < restore:
        raise RuntimeError("Brightness worker does not bracket DCS transfer with LP mode")

    mark_unprepared = unprepare.find("ctx->prepared = false")
    cancel = unprepare.find("cancel_delayed_work_sync")
    panel_off = unprepare.find("ams639rq08_off(ctx)")
    ordered = (mark_unprepared, cancel, panel_off)
    if min(ordered) < 0 or list(ordered) != sorted(ordered):
        raise RuntimeError("Brightness work is not cancelled before panel power-off")

    print("PASS: AMS639RQ08 LP-mode brightness coalescing and teardown invariants")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kernel", type=Path)
    parser.add_argument("--cc", default=os.environ.get("CC", "cc"))
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent
    driver = args.kernel / "drivers/media/platform/qcom/venus"
    validate_protocol_sources(driver)
    validate_format_sources(driver)
    validate_encoder_sources(driver)
    validate_panel_sources(args.kernel)
    power_sources = {
        "pm_helpers.c": [
            "core_clks_enable", "core_clks_disable", "core_clks_set_rate",
            "vcodec_clks_enable", "vcodec_clks_disable", "core_resets_reset",
            "iris1_llcc_disable", "iris1_llcc_enable", "iris1_llcc_put",
            "iris1_power_off", "core_power_iris1", "core_put_iris1",
            "coreid_power_iris1",
        ],
        "core.c": ["venus_runtime_suspend", "venus_runtime_resume"],
    }
    hfi_sources = {
        "hfi_msgs.c": ["sys_get_prop_image_version"],
        "hfi_venus.c": ["venus_peek_debug_queue"],
    }
    queue_sources = {
        "hfi_venus.c": ["venus_write_queue", "venus_read_queue"],
    }
    session_sources = {
        "helpers.c": [
            "venus_helper_get_work_mode", "venus_helper_set_work_mode",
            "venus_helper_set_work_route",
        ],
    }
    format_sources = {
        "helpers.c": [
            "venus_helper_get_codec", "venus_helper_check_codec",
            "to_hfi_raw_fmt", "find_fmt_from_caps",
            "venus_helper_check_format", "get_framesize_raw_p010",
        ],
        "vdec.c": ["vdec_fmt_is_8bit", "vdec_fmt_is_10bit"],
    }
    for name, sources in [("power", power_sources), ("hfi", hfi_sources),
                          ("queues", queue_sources),
                          ("session", session_sources),
                          ("formats", format_sources)]:
        extracted = []
        for filename, names in sources.items():
            source = (driver / filename).read_text(encoding="utf-8")
            for entry in names:
                extracted.append(function(source, entry))
        harness = (repo / f"tests/iris1-{name}.c").read_text(encoding="utf-8")
        harness = harness.replace("/* ACTUAL_DRIVER_FUNCTIONS */", "\n\n".join(extracted))
        with tempfile.TemporaryDirectory(prefix="venus-iris1-test-") as directory:
            target = Path(directory)
            source = target / "iris1-test.c"
            executable = target / ("iris1-test.exe" if os.name == "nt" else "iris1-test")
            source.write_text(harness, encoding="utf-8")
            subprocess.run([args.cc, "-std=gnu11", "-O1", "-g", "-Wall", "-Wextra",
                            "-Werror", str(source), "-o", str(executable)], check=True)
            subprocess.run([str(executable)], check=True)


if __name__ == "__main__":
    main()
