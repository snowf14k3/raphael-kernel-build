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
    message_header = (driver / "hfi_msgs.h").read_text(encoding="utf-8")
    parser_source = (driver / "hfi_parser.c").read_text(encoding="utf-8")
    hfi_source = (driver / "hfi.c").read_text(encoding="utf-8")

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

    constraints_case = packetizer.find(
        "case HFI_PROPERTY_PARAM_UNCOMPRESSED_PLANE_ACTUAL_CONSTRAINTS_INFO:")
    constraints_next = packetizer.find("case ", constraints_case + 5)
    if constraints_case < 0 or constraints_next < constraints_case:
        raise RuntimeError("HFI 4xx P010 constraints property is missing")
    constraints_body = packetizer[constraints_case:constraints_next]
    for required in ("!in->num_planes",
                     "in->num_planes > ARRAY_SIZE(info->plane_format)",
                     "in->num_planes * sizeof(info->plane_format[0])",
                     "sizeof(info->buffer_type)", "sizeof(info->num_planes)"):
        if required not in constraints_body:
            raise RuntimeError(
                f"HFI 4xx P010 constraints packet is incomplete: {required}")

    legacy = function(cmds, "pkt_session_set_property_1x")
    if "case HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE:" not in legacy:
        raise RuntimeError("VENC low-latency property has no generic packetizer")
    for required in (
            "case HFI_PROPERTY_PARAM_VENC_ASPECT_RATIO:",
            "case HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE:",
            "case HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID:",
            "case HFI_FLIP_BOTH:"):
        if required not in legacy:
            raise RuntimeError(
                f"SM8150 encoder control packetizer is incomplete: {required}")
    for required in (
            "#define HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE\t\t0x200600d",
            "#define HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID\t\t0x200600f",
            "#define HFI_FLIP_VERTICAL\t0x4",
            "#define HFI_FLIP_BOTH"):
        if required not in helper:
            raise RuntimeError(f"SM8150 encoder HFI ABI is incomplete: {required}")

    qp_range = packetizer.find(
        "case HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE_V2:")
    qp_range_end = packetizer.find("case ", qp_range + 5)
    if qp_range < 0 or qp_range_end < qp_range:
        raise RuntimeError("HFI4 packed QP-range property is missing")
    qp_range_body = packetizer[qp_range:qp_range_end]
    for required in ("min_qp > 0xffffff", "range->min_qp.qp_packed = min_qp",
                     "in->min_qp.layer_id", "in->min_qp.enable"):
        if required not in qp_range_body:
            raise RuntimeError(
                f"HFI4 packed QP-range packet is incomplete: {required}")
    if "(min_qp & 0xFF) << 8" in qp_range_body:
        raise RuntimeError("HFI4 packetizer still replicates one QP across I/P/B")

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

    for required in ("struct hfi_msg_session_empty_buffer_done_v4_tail",
                     "struct hfi_frame_cr_stats", "u32 info[7]", "u32 data[]"):
        if required not in message_header:
            raise RuntimeError(f"VPU5 extended EBD ABI is incomplete: {required}")
    ebd = function(messages, "hfi_session_etb_done")
    flush = function(hfi_source, "hfi_session_flush")
    flush_done = function(messages, "hfi_session_flush_done")
    for required in ("pkt->shdr.hdr.size >= sizeof(*pkt)",
                     "sizeof(struct hfi_msg_session_empty_buffer_done_v4_tail)",
                     "32, 64, 96, 128, 160, 192, 256",
                     "weighted_sum += ubwc_bucket_weights[i] * samples",
                     "div64_u64(numerator, weighted_sum)",
                     "tail->recon.complexity_number / frame_size",
                     "inst->iris1_ebd_count", "tail->is_sync_frame"):
        if required not in ebd:
            raise RuntimeError(f"VPU5 extended EBD parser is incomplete: {required}")
    if "inst->ops->buf_done" not in ebd:
        raise RuntimeError("Common short EBD completion path was lost")
    eos_filter = ebd.find("pkt->packet_buffer == HFI_DUMMY_EOS_BUFFER_ADDR")
    ebd_complete = ebd.find("inst->ops->buf_done")
    if eos_filter < 0 or ebd_complete < 0 or eos_filter > ebd_complete:
        raise RuntimeError("Synthetic EOS EBD can consume a userspace buffer tag")

    for required in ("atomic_inc_return(&inst->flush_pending)",
                     "reinit_completion(&inst->flush_done)",
                     "wait_session_flush(inst)"):
        if required not in flush:
            raise RuntimeError(f"Flush response tracking is incomplete: {required}")
    for required in ("atomic_dec_return(&inst->flush_pending)",
                     "complete(&inst->flush_done)",
                     "WRITE_ONCE(inst->flush_error"):
        if required not in flush_done:
            raise RuntimeError(f"Flush completion accounting is incomplete: {required}")
    if "complete(&inst->done)" in flush_done:
        raise RuntimeError("Flush response still completes an unrelated HFI command")

    alloc_mode = function(parser_source, "parse_alloc_mode")
    caps = function(parser_source, "parse_caps")
    raw_formats = function(parser_source, "parse_raw_formats")
    if "mode->num_entries * sizeof(u32) + sizeof(*mode)" not in alloc_mode:
        raise RuntimeError("parse_alloc_mode omits its property header size")
    if "num_caps * sizeof(*cap) + sizeof(u32)" not in caps:
        raise RuntimeError("parse_caps omits its capability-count header size")
    if "size += sizeof(*constr) * num_planes + 2 * sizeof(u32)" not in raw_formats:
        raise RuntimeError("parse_raw_formats does not account for each entry's planes")
    if "i * num_planes" in raw_formats:
        raise RuntimeError("parse_raw_formats still uses the last entry's plane count")

    print("PASS: HFI4 route/P010, extended EBD, 12-entry and payload-size invariants")


def validate_format_sources(driver):
    decoder = (driver / "vdec.c").read_text(encoding="utf-8")
    controls = (driver / "vdec_ctrls.c").read_text(encoding="utf-8")
    helpers = (driver / "helpers.c").read_text(encoding="utf-8")
    hfi = (driver / "hfi.c").read_text(encoding="utf-8")
    s_fmt = function(decoder, "vdec_s_fmt")
    source_change = function(decoder, "vdec_event_change")
    session_init = function(hfi, "hfi_session_init")
    p010_size = function(helpers, "get_framesize_raw_p010")
    sm8150_p010_size = function(decoder, "vdec_get_framesz")
    sm8150_p010_raw_size = function(decoder, "vdec_get_framesz_raw")
    try_fmt = function(decoder, "vdec_try_fmt_common")
    find_fmt = function(decoder, "find_format")
    enum_fmt = function(decoder, "find_format_by_index")
    valid_fmt = function(decoder, "vdec_format_is_valid")
    stream_fmt = function(decoder, "vdec_capture_fmt_matches_stream")
    output_conf = function(decoder, "vdec_output_conf")
    buf_done = function(decoder, "vdec_buf_done")
    colorimetry = function(decoder, "vdec_update_colorimetry")
    color_primaries = function(decoder, "vdec_hfi_color_primaries")
    transfer_char = function(decoder, "vdec_hfi_transfer_char")
    matrix_coefficients = function(decoder, "vdec_hfi_matrix_coefficients")
    constraints = function(helpers, "venus_helper_set_format_constraints")
    constraints_common = function(
        helpers, "venus_helper_set_format_constraints_for_type")

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
    for body in (sm8150_p010_size, sm8150_p010_raw_size):
        if "IS_IRIS1(inst->core)" not in body or "size += SZ_4K" not in body:
            raise RuntimeError("SM8150 P010 size omits the downstream 4 KiB tail padding")
    for required in ("pixmp->pixelformat = V4L2_PIX_FMT_P010",
                     "pixmp->pixelformat == V4L2_PIX_FMT_QC10C",
                     "pixmp->width = ALIGN(pixmp->width, 128)",
                     "pixmp->width = roundup(pixmp->width, 192)",
                     "stride = stride * 4 / 3",
                     "pixmp->height = ALIGN(pixmp->height, 16)"):
        if required not in try_fmt:
            raise RuntimeError(f"10-bit fallback/format geometry is incomplete: {required}")
    if "vdec_format_is_valid(inst, &fmt[i], type, true)" not in find_fmt:
        raise RuntimeError("capture TRY/S_FMT does not enforce stream bit depth")
    if "vdec_format_is_valid(inst, &fmt[i], type, false)" not in enum_fmt:
        raise RuntimeError("ENUM_FMT does not use stable capability-only filtering")
    if "inst->bit_depth" in enum_fmt:
        raise RuntimeError("ENUM_FMT must stay stable across stream bit-depth changes")
    for required in ("venus_helper_check_codec", "match_bit_depth",
                     "vdec_capture_fmt_matches_stream"):
        if required not in valid_fmt:
            raise RuntimeError(f"Shared decoder format filter is incomplete: {required}")
    for required in ("IS_IRIS1(inst->core)", "VIDC_BITDEPTH_10",
                     "pixfmt == V4L2_PIX_FMT_NV12",
                     "vdec_fmt_is_10bit", "vdec_fmt_is_8bit"):
        if required not in stream_fmt:
            raise RuntimeError(
                f"SM8150 Main10 output compatibility is incomplete: {required}")
    for required in ("HFI_COLOR_FORMAT_YUV420_TP10_UBWC",
                     "HFI_COLOR_FORMAT_NV12",
                     "10-bit NV12 output requires TP10 DPB split mode"):
        if required not in output_conf:
            raise RuntimeError(
                f"SM8150 Main10 NV12 split-output check is missing: {required}")
    keep_nv12 = source_change.find(
        "inst->fmt_cap->pixfmt != V4L2_PIX_FMT_NV12")
    choose_p010 = source_change.find(
        "inst->fmt_cap = &vdec_formats[VENUS_FMT_P010]")
    if keep_nv12 < 0 or choose_p010 < keep_nv12:
        raise RuntimeError(
            "IRIS1 source change does not preserve the NV12 compatibility output")
    for required in ("data_offset > length",
                     "bytesused > length - data_offset",
                     "VB2_BUF_STATE_ERROR"):
        if required not in buf_done:
            raise RuntimeError(f"Decoder payload bounds check is incomplete: {required}")
    last_branch = buf_done.find("if (vbuf->flags & V4L2_BUF_FLAG_LAST)")
    clear_fallback = buf_done.find("inst->next_buf_last = false", last_branch)
    queue_eos = buf_done.find("v4l2_event_queue_fh", last_branch)
    if min(last_branch, clear_fallback, queue_eos) < 0 or not \
       last_branch < clear_fallback < queue_eos:
        raise RuntimeError("Firmware LAST does not suppress the fallback LAST buffer")
    for required in ("FIELD_GET(BIT(29), colour_space)",
                     "FIELD_GET(BIT(25), colour_space)",
                     "FIELD_GET(BIT(24), colour_space)",
                     "FIELD_GET(GENMASK(23, 16), colour_space)",
                     "FIELD_GET(GENMASK(15, 8), colour_space)",
                     "FIELD_GET(GENMASK(7, 0), colour_space)",
                     "V4L2_QUANTIZATION_FULL_RANGE",
                     "V4L2_QUANTIZATION_LIM_RANGE"):
        if required not in colorimetry:
            raise RuntimeError(f"HFI colorimetry unpacking is incomplete: {required}")
    for required in ("case 1:", "case 4:", "case 5:", "case 6:",
                     "case 7:", "case 9:", "case 11:",
                     "V4L2_COLORSPACE_DCI_P3"):
        if required not in color_primaries:
            raise RuntimeError(f"HFI color-primary mapping is incomplete: {required}")
    for required in ("case 1:", "case 7:", "case 13:", "case 16:",
                     "V4L2_XFER_FUNC_SMPTE2084"):
        if required not in transfer_char:
            raise RuntimeError(f"HFI transfer-characteristic mapping is incomplete: {required}")
    for required in ("case 1:", "case 5:", "case 6:", "case 7:",
                     "case 9:", "case 10:",
                     "V4L2_YCBCR_ENC_BT2020_CONST_LUM"):
        if required not in matrix_coefficients:
            raise RuntimeError(f"HFI matrix-coefficient mapping is incomplete: {required}")
    if "vdec_update_colorimetry(inst, ev_data->colour_space)" not in source_change:
        raise RuntimeError("decoder source change drops firmware colorimetry")
    for required in ("IS_IRIS1(inst->core)",
                     "inst->opb_fmt != HFI_COLOR_FORMAT_P010",
                     "stride_multiple = IS_IRIS1(inst->core) ? 256 : 128",
                     "venus_helper_set_format_constraints_for_type"):
        if required not in constraints:
            raise RuntimeError(f"SM8150 linear-P010 constraints are incomplete: {required}")
    for required in ("pconstraint.buffer_type = buffer_type",
                     "pconstraint.num_planes = 2", ".max_stride = 8192",
                     ".min_plane_buffer_height_multiple = 32",
                     ".min_plane_buffer_height_multiple = 16",
                     ".buffer_alignment = 256"):
        if required not in constraints_common:
            raise RuntimeError(f"Shared linear-P010 constraints are incomplete: {required}")
    for required in ("V4L2_CID_MPEG_VIDEO_HEVC_PROFILE",
                     "V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN_10"):
        if required not in controls:
            raise RuntimeError(f"decoder HEVC profile control is incomplete: {required}")

    print("PASS: native P010, Main10 split output, colorimetry and bounded payload ABI")


def validate_encoder_sources(driver):
    core_header = (driver / "core.h").read_text(encoding="utf-8")
    core_source = (driver / "core.c").read_text(encoding="utf-8")
    pm = (driver / "pm_helpers.c").read_text(encoding="utf-8")
    commands = (driver / "hfi_cmds.c").read_text(encoding="utf-8")
    command_header = (driver / "hfi_cmds.h").read_text(encoding="utf-8")
    helper = (driver / "hfi_helper.h").read_text(encoding="utf-8")
    hfi = (driver / "hfi.c").read_text(encoding="utf-8")
    venus = (driver / "hfi_venus.c").read_text(encoding="utf-8")
    helpers = (driver / "helpers.c").read_text(encoding="utf-8")
    encoder = (driver / "venc.c").read_text(encoding="utf-8")
    controls = (driver / "venc_ctrls.c").read_text(encoding="utf-8")
    decoder_controls = (driver / "vdec_ctrls.c").read_text(encoding="utf-8")
    hfi4_caps = (driver / "hfi_platform_v4.c").read_text(encoding="utf-8")

    for required in (
            "V4L2_CID_ROTATE", "V4L2_CID_HFLIP", "V4L2_CID_VFLIP",
            "V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE",
            "V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC",
            "V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH",
            "V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT",
            "V4L2_CID_MPEG_VIDEO_HEVC_TIER"):
        if required not in controls:
            raise RuntimeError(f"SM8150 standard encoder control is missing: {required}")
    for required in (
            "ctr->h264_i_min_qp = ctrl->val",
            "ctr->h264_p_min_qp = ctrl->val",
            "ctr->h264_b_min_qp = ctrl->val",
            "ctr->hevc_i_max_qp = ctrl->val",
            "ctr->hevc_p_max_qp = ctrl->val",
            "ctr->hevc_b_max_qp = ctrl->val"):
        if required not in controls:
            raise RuntimeError(f"Generic/per-frame QP synchronization is missing: {required}")

    internal_config = function(encoder, "venc_iris1_internal_config")
    for required in (
            "HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE",
            "HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE",
            "HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL",
            "HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID",
            "VENUS_IRIS1_CBR_MB_LIMIT", "mbs_per_frame / 10",
            "max_avg_slice"):
        if required not in internal_config:
            raise RuntimeError(
                f"SM8150 encoder internal config is incomplete: {required}")
    set_work_mode = function(helpers, "venus_helper_set_work_mode")
    if "HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE" in set_work_mode:
        raise RuntimeError("Low latency is still incorrectly coupled to work mode")

    qp_setup = function(encoder, "venc_set_properties")
    for required in (
            "venc_pack_qp(ctr->h264_i_min_qp",
            "venc_pack_qp(ctr->h264_i_max_qp",
            "venc_pack_qp(ctr->hevc_i_min_qp",
            "venc_pack_qp(ctr->hevc_i_max_qp",
            "quant_range_v2.min_qp.layer_id",
            "venc_iris1_internal_config(inst, rate_control)"):
        if required not in qp_setup:
            raise RuntimeError(f"Encoder property setup is incomplete: {required}")

    rotation = function(encoder, "venc_iris1_set_rotation")
    for required in ("HFI_FLIP_BOTH", "HFI_ROTATE_90", "HFI_ROTATE_270",
                     "HFI_PROPERTY_PARAM_FRAME_SIZE", "inst->height",
                     "inst->width"):
        if required not in rotation:
            raise RuntimeError(f"SM8150 rotation/flip setup is incomplete: {required}")

    profile_level = function(helpers, "venus_helper_set_profile_level")
    for required in ("V4L2_MPEG_VIDEO_HEVC_TIER_HIGH",
                     "HFI_HEVC_TIER_HIGH0", "HFI_HEVC_TIER_MAIN", "<< 28"):
        if required not in profile_level:
            raise RuntimeError(f"SM8150 HEVC tier packing is incomplete: {required}")

    encoder_formats = encoder[encoder.find(
        "static const struct venus_format venc_formats[]"):
        encoder.find("static int venc_v4l2_to_hfi")]
    for required in ("V4L2_PIX_FMT_NV12", "V4L2_PIX_FMT_NV21",
                     "V4L2_PIX_FMT_QC08C", "V4L2_PIX_FMT_QC10C",
                     "V4L2_PIX_FMT_P010"):
        if required not in encoder_formats:
            raise RuntimeError(
                f"SM8150 encoder raw-format table is incomplete: {required}")

    check_format = function(helpers, "venus_helper_check_format")
    encoder_input = check_format.find(
        "inst->session_type == VIDC_SESSION_TYPE_ENC")
    input_caps = check_format.find("HFI_BUFFER_INPUT", encoder_input)
    nv21_fallback = check_format.find("HFI_COLOR_FORMAT_NV21", input_caps)
    decoder_output = check_format.find("HFI_BUFFER_OUTPUT", nv21_fallback)
    if min(encoder_input, input_caps, nv21_fallback, decoder_output) < 0 or \
       not encoder_input < input_caps < nv21_fallback < decoder_output:
        raise RuntimeError(
            "Raw-format capability filtering does not distinguish encoder input from decoder output")

    find_encoder_fmt = function(encoder, "find_format")
    enum_encoder_fmt = function(encoder, "find_format_by_index")
    for body in (find_encoder_fmt, enum_encoder_fmt):
        if "venus_helper_check_format" not in body:
            raise RuntimeError("Encoder raw format enumeration bypasses HFI capabilities")

    framesz = function(encoder, "venc_get_framesz")
    for required in ("V4L2_PIX_FMT_NV21", "V4L2_PIX_FMT_QC08C",
                     "V4L2_PIX_FMT_QC10C", "V4L2_PIX_FMT_P010",
                     "ALIGN(roundup(width, 192) * 4 / 3, 256)",
                     "DIV_ROUND_UP(width, 48)",
                     "uv_stride * uv_scanlines + SZ_4K"):
        if required not in framesz:
            raise RuntimeError(
                f"SM8150 encoder raw layout is incomplete: {required}")

    try_encoder_fmt = function(encoder, "venc_try_fmt_common")
    if "venc_get_stride(pixmp->pixelformat" not in try_encoder_fmt:
        raise RuntimeError("Encoder bytesperline is not selected by raw format")

    set_encoder_fmt = function(encoder, "venc_s_fmt")
    for required in ("inst->bit_depth = VIDC_BITDEPTH_10",
                     "inst->bit_depth = VIDC_BITDEPTH_8",
                     "inst->hfi_codec = venus_helper_get_codec(fmt->pixfmt)"):
        if required not in set_encoder_fmt:
            raise RuntimeError(f"Encoder format state is incomplete: {required}")

    input_constraints = function(
        helpers, "venus_helper_set_input_format_constraints")
    for required in ("VIDC_SESSION_TYPE_ENC", "V4L2_PIX_FMT_P010",
                     "HFI_BUFFER_INPUT, 256"):
        if required not in input_constraints:
            raise RuntimeError(
                f"SM8150 encoder P010 constraints are incomplete: {required}")

    init_encoder = function(encoder, "venc_init_session")
    color = init_encoder.find("venus_helper_set_color_format")
    constraints = init_encoder.find(
        "venus_helper_set_input_format_constraints", color)
    properties = init_encoder.find("venc_set_properties", constraints)
    if min(color, constraints, properties) < 0 or not color < constraints < properties:
        raise RuntimeError(
            "SM8150 encoder input constraints are not sent after color selection")

    encoder_cmd = function(encoder, "venc_encoder_cmd")
    drain_send = encoder_cmd.find("hfi_session_process_buf(inst, &fdata)")
    drain_state = encoder_cmd.find("inst->enc_state = VENUS_ENC_STATE_DRAIN", drain_send)
    success_guard = encoder_cmd.rfind("if (!ret)", drain_send, drain_state)
    if min(drain_send, drain_state, success_guard) < 0 or not drain_send < success_guard < drain_state:
        raise RuntimeError("Encoder enters DRAIN after a failed synthetic EOS ETB")

    for required in ("u32 max_hq_mbs_per_frame;", "u32 max_hq_mbs_per_sec;",
                     "u32 fw_cycles;", "u32 fw_vpp_cycles;"):
        if required not in core_header:
            raise RuntimeError(f"SM8150 clock resource is missing: {required}")
    sm8150_res = core_source[core_source.find(
        "static const struct venus_resources sm8150_res"):
        core_source.find("static const struct freq_tbl sc7180_freq_table")]
    for required in (".max_hq_mbs_per_frame = 8160",
                     ".max_hq_mbs_per_sec = 244800",
                     ".fw_cycles = 760000", ".fw_vpp_cycles = 166667"):
        if required not in sm8150_res:
            raise RuntimeError(f"SM8150 downstream clock constant differs: {required}")

    power_save = function(pm, "power_save_mode_enable")
    for required in ("mbs_per_frame > res->max_hq_mbs_per_frame",
                     "mbs_per_sec > res->max_hq_mbs_per_sec",
                     "V4L2_MPEG_VIDEO_BITRATE_MODE_CQ"):
        if required not in power_save:
            raise RuntimeError(f"SM8150 HQ/LP selection is incomplete: {required}")
    hq_limit = power_save.find("mbs_per_frame > res->max_hq_mbs_per_frame")
    cq_override = power_save.find("V4L2_MPEG_VIDEO_BITRATE_MODE_CQ")
    if hq_limit < 0 or cq_override < hq_limit:
        raise RuntimeError("CQ must override the SM8150 forced low-power threshold")

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
    for property_name in ("HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP",
                          "HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS",
                          "HFI_PROPERTY_PARAM_VPE_ROTATION",
                          "HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT"):
        if f"case {property_name}:" not in legacy_packetizer:
            raise RuntimeError(
                f"VPU5 property has no common packetizer: {property_name}")
    property_ids = {
        "HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP": "0x2005027",
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
                     "HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP",
                     "en.enable = ctr->rc_enable",
                     "venus-sm8150: encoder rc timestamp disable=%u",
                     "HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS",
                     "HFI_PROPERTY_PARAM_NAL_STREAM_FORMAT_SELECT",
                     "HFI_NAL_FORMAT_STARTCODES",
                     "!IS_IRIS1(inst->core) || ctr->ltr_count",
                     "ltr_mode.ltr_mode = HFI_LTR_MODE_MANUAL",
                     "ltr_mode.trust_mode = 1",
                     "VPU5 downstream leaves VUI timing disabled"):
        if required not in properties:
            raise RuntimeError(f"SM8150 encoder property setup is incomplete: {required}")

    rate_control = properties.find("HFI_PROPERTY_PARAM_VENC_RATE_CONTROL")
    timestamp_control = properties.find(
        "HFI_PROPERTY_PARAM_VENC_DISABLE_RC_TIMESTAMP")
    bitrate_savings = properties.find("HFI_PROPERTY_PARAM_VENC_BITRATE_SAVINGS")
    if min(rate_control, timestamp_control, bitrate_savings) < 0 or not \
       rate_control < timestamp_control < bitrate_savings:
        raise RuntimeError(
            "VPU5 timestamp RC must follow rate control before bitrate savings")

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

    s_fmt = function(encoder, "venc_s_fmt")
    if "inst->bufreq_cache_valid = false" not in s_fmt:
        raise RuntimeError("Encoder S_FMT does not invalidate cached requirements")

    get_bufreq = function(helpers, "venus_helper_get_bufreq")
    for required in ("IS_IRIS1(inst->core)",
                     "inst->session_type == VIDC_SESSION_TYPE_ENC",
                     "inst->bufreq_cache_valid", "inst->bufreq_cache"):
        if required not in get_bufreq:
            raise RuntimeError(f"VPU5 requirements cache use is incomplete: {required}")

    queue_setup = function(encoder, "venc_queue_setup")
    for required in ("venus_helper_get_bufreq(inst, type, &iris1_req)",
                     "sizes[0] = iris1_req.size",
                     "hfi_bufreq_get_count_min(&iris1_req, ver)",
                     "hfi_bufreq_get_count_min_host(&iris1_req, ver)",
                     "firmware-defined"):
        if required not in queue_setup:
            raise RuntimeError(
                f"VPU5 external queue contract is incomplete: {required}")
    external_req = function(encoder, "venc_iris1_validate_external_req")
    for required in ("req->type != type", "!req->size",
                     "!req->count_actual", "!count_min",
                     "req->count_actual < count_min",
                     "req->count_actual > VIDEO_MAX_FRAME",
                     "count_host > VIDEO_MAX_FRAME",
                     "!is_power_of_2(req->alignment)"):
        if required not in external_req:
            raise RuntimeError(
                f"VPU5 external requirement validation is incomplete: {required}")

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

    intbuf_4xx_match = re.search(
        r"static const unsigned int intbuf_types_4xx\[\]\s*=\s*\{(.*?)\};",
        helpers, re.DOTALL)
    if not intbuf_4xx_match:
        raise RuntimeError("HFI4 internal-buffer type list is missing")
    if "HFI_BUFFER_INTERNAL_RECON" in intbuf_4xx_match.group(1):
        raise RuntimeError(
            "RECON is vendor metadata, not a host DMA internal buffer")

    process_buf = function(helpers, "session_process_buf")
    address_guard = process_buf.find("upper_32_bits(buf->dma_addr)")
    address_copy = process_buf.find("fdata.device_addr = dma_addr")
    if min(address_guard, address_copy) < 0 or address_guard > address_copy:
        raise RuntimeError(
            "Frame IOVA is truncated into the HFI field before validation")
    for required in ("dma_addr > U32_MAX - (buf->size - 1)",
                     "fdata.offset > fdata.alloc_len",
                     "fdata.filled_len > fdata.alloc_len - fdata.offset",
                     "venus_helper_get_bufreq(inst, fdata.buffer_type, &req)",
                     "fdata.alloc_len < req.size",
                     "!IS_ALIGNED(fdata.device_addr, req.alignment)"):
        if required not in process_buf:
            raise RuntimeError(
                f"Encoder frame DMA validation is incomplete: {required}")
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
    for forbidden in ("enc_test_stage", "VENUS_IRIS1_ENC_STAGE"):
        if forbidden in intbuf_alloc:
            raise RuntimeError(
                f"Product encoder allocator still contains a checkpoint gate: {forbidden}")

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
    final_requirements = start.find("venus_helper_cache_bufreqs(inst)",
                                    start_requirements + 1)
    output_size = start.find("venus_helper_set_bufsize(inst, inst->output_buf_size")
    output_type = start.find("HFI_BUFFER_OUTPUT", output_size)
    start_verify = start.find("venc_verify_conf(inst)")
    start_hw = start.find("venus_helper_vb2_start_streaming(inst)")
    start_pin = start.find("inst->enc_pm_active = true")
    ordered = (start_get, start_rotation, start_properties, start_route,
               start_mode, start_core, start_preflight, start_requirements, start_counts,
               final_requirements, output_size, output_type, start_verify,
               start_hw, start_pin)
    if min(ordered) < 0 or list(ordered) != sorted(ordered):
        raise RuntimeError("IRIS1 encoder setup/DMA/PM ordering differs from audited sequence")
    if "0x20100c" not in start and "BUFFER_SIZE_MINIMUM" not in start:
        raise RuntimeError(
            "Encoder output-size property is not tied to the audited vendor wire contract")
    verify_conf = function(encoder, "venc_verify_conf")
    for required in ("inst->output_buf_size < bufreq.size",
                     "inst->input_buf_size < bufreq.size"):
        if required not in verify_conf:
            raise RuntimeError(
                f"Encoder final buffer requirement is not enforced: {required}")
    release_core = start.find("venus_pm_release_core(inst)", start.find("error:"))
    error_pm_put = start.find("venc_pm_put(inst, false)", start.find("error:"))
    if min(release_core, error_pm_put) < 0 or release_core > error_pm_put:
        raise RuntimeError("IRIS1 start error suspends power before releasing core ownership")
    for required in ("inst->iris1_ebd_count = 0",
                     "inst->iris1_recon_index = 0",
                     "inst->iris1_ubwc_cr_q16 = 0",
                     "inst->iris1_complexity_factor_q16 = 0",
                     "inst->iris1_complexity_number = 0",
                     "inst->iris1_bw_diag_ebd_count = 0"):
        if required not in start:
            raise RuntimeError(f"Encoder per-stream statistics are not reset: {required}")

    buf_done = function(encoder, "venc_buf_done")
    for required in ("data_offset > length",
                     "bytesused > length - data_offset",
                     "vb2_set_plane_payload(vb, 0, bytesused)",
                     "VB2_BUF_STATE_ERROR"):
        if required not in buf_done:
            raise RuntimeError(
                f"Encoder FBD payload validation is incomplete: {required}")

    for forbidden in ("venus_iris1_encoder_stage", "iris1_encoder_stage",
                      "VENUS_IRIS1_ENC_STAGE", "enc_test_stage",
                      "venc_iris1_stage_preflight"):
        if forbidden in encoder or forbidden in helpers or forbidden in core_header:
            raise RuntimeError(
                f"Product encoder path still contains a checkpoint artifact: {forbidden}")

    helper_start = function(helpers, "venus_helper_vb2_start_streaming")
    internal = helper_start.find("venus_helper_intbufs_alloc(inst)")
    load = helper_start.find("hfi_session_load_res(inst)")
    hw_start = helper_start.find("hfi_session_start(inst)")
    checkpoints = (internal, load, hw_start)
    if min(checkpoints) < 0 or list(checkpoints) != sorted(checkpoints):
        raise RuntimeError("Encoder internal/LOAD/START sequence is out of order")
    for required in ("failed to unload session during stream-start unwind",
                     "failed to unregister buffers during stream-start unwind",
                     "failed to free internal buffers during stream-start unwind"):
        if required not in helper_start:
            raise RuntimeError(
                f"Encoder rollback diagnostics are incomplete: {required}")

    unload = function(hfi, "hfi_session_unload_res")
    for required in ("IS_IRIS1(inst->core)", "INST_LOAD_RESOURCES",
                     "inst->state != INST_STOP"):
        if required not in unload:
            raise RuntimeError(
                f"IRIS1 LOAD-only rollback is not permitted safely: {required}")
    load_rollback = helper_start.find("hfi_session_unload_res(inst)", load)
    free_after_unload = helper_start.find("venus_helper_intbufs_free(inst)",
                                          load_rollback)
    if min(load_rollback, free_after_unload) < 0 or load_rollback > free_after_unload:
        raise RuntimeError(
            "LOAD-only rollback frees internal DMA before releasing firmware resources")

    device_run = function(helpers, "venus_helper_m2m_device_run")
    for required in ("v4l2_m2m_for_each_dst_buf_safe",
                     "v4l2_m2m_for_each_src_buf_safe"):
        if required not in device_run:
            raise RuntimeError(f"Encoder user-DMA submission is missing: {required}")
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

    for required in ("IS_IRIS1(inst->core)", "ALIGN(width, 128)",
                     "ALIGN(height, 32)",
                     "ALIGN((height + 1) >> 1, 16)",
                     "+ SZ_4K", "SZ_4K"):
        if required not in framesz:
            raise RuntimeError(f"Vendor-exact SM8150 NV12 sizing is incomplete: {required}")

    queue_init = function(encoder, "m2m_queue_init")
    for required in ("IS_IRIS1(inst->core)",
                     "src_vq->bidirectional = 1"):
        if required not in queue_init:
            raise RuntimeError(f"SM8150 encoder DMA direction is incomplete: {required}")
    for forbidden in ("iris1_encoder_vendor_nv12",
                      "iris1_encoder_bidirectional",
                      "enc_vendor_nv12", "enc_dma_bidirectional"):
        if forbidden in encoder or forbidden in core_header:
            raise RuntimeError(
                f"Required SM8150 DMA/layout policy is still optional: {forbidden}")

    for required in ("iris1_ebd_count", "iris1_recon_index",
                     "iris1_ubwc_cr_q16", "iris1_complexity_factor_q16",
                     "iris1_complexity_number", "iris1_recon_cr_q16",
                     "iris1_recon_cf_q16", "iris1_recon_valid_mask",
                     "iris1_bw_diag_ebd_count"):
        if required not in core_header:
            raise RuntimeError(f"VPU5 EBD/BW instance state is missing: {required}")
    load_bw = function(pm, "load_scale_bw")
    for required in ("IRIS1_BW_MAX_KBPS",
                     "READ_ONCE(inst->iris1_ebd_count) < 16",
                     "iris1_calculate_bw(inst, payload, &vote)",
                     "max(vote.ddr_kbps, vote.llcc_kbps)",
                     "READ_ONCE(inst->iris1_ebd_count)"):
        if required not in load_bw:
            raise RuntimeError(f"SM8150 dynamic BW path is incomplete: {required}")
    decoder_bw = function(pm, "iris1_calculate_decoder_bw")
    encoder_bw = function(pm, "iris1_calculate_encoder_bw")
    for required in ("HFI_VIDEO_CODEC_HEVC", "HFI_VIDEO_CODEC_VP9",
                     "iris1_dynamic_stats(inst, &cr_q16, &cf_q16)",
                     "IRIS1_FP_CONST(1, 3, 100)"):
        if required not in decoder_bw:
            raise RuntimeError(f"SM8150 decoder BW model is incomplete: {required}")
    for required in ("controls.enc.bitrate", "controls.enc.num_b_frames",
                     "iris1_dynamic_stats(inst, &cr_q16, NULL)",
                     "original_base", "mese_read", "mese_write",
                     "IRIS1_FP_CONST(1, 3, 100)"):
        if required not in encoder_bw:
            raise RuntimeError(f"SM8150 encoder BW model is incomplete: {required}")

    dynamic = function(controls, "venc_op_s_ctrl")
    if "IS_IRIS1(inst->core) ?\n\t\t\t\t\t     HFI_LAYER_ID_ALL : 0" not in dynamic:
        raise RuntimeError("Dynamic VPU5 bitrate update does not address all layers")
    for required in ("V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE",
                     "V4L2_MPEG_VIDEO_H264_LEVEL_5_1"):
        if required not in controls:
            raise RuntimeError(f"SM8150 encoder defaults are incomplete: {required}")

    for required in (
            "{ HFI_H264_LEVEL_52, V4L2_MPEG_VIDEO_H264_LEVEL_5_2 }",
            "vp8_levels", "HFI_VPX_PROFILE_MAIN",
            "venus_helper_get_profile_mask",
            "venus_helper_get_max_level"):
        if required not in helpers:
            raise RuntimeError(
                f"SM8150 profile/level translation is incomplete: {required}")
    vp8_get = function(helpers, "v4l2_id_profile_level")
    for required in ("case HFI_VIDEO_CODEC_VP8:", "if (iris1)",
                     "find_v4l2_id(hfi_lvl, vp8_levels"):
        if required not in vp8_get:
            raise RuntimeError(
                f"SM8150 VP8 version decode is incomplete: {required}")
    set_profile = function(helpers, "venus_helper_set_profile_level")
    for required in ("inst->hfi_codec == HFI_VIDEO_CODEC_VP8",
                     "pl.profile = HFI_VPX_PROFILE_MAIN",
                     "pl.level = find_hfi_id(profile, vp8_levels"):
        if required not in set_profile:
            raise RuntimeError(
                f"SM8150 VP8 version encode is incomplete: {required}")
    if "{HFI_VP9_PROFILE_P0, 200}" in hfi4_caps or \
            "{HFI_VP9_PROFILE_P2_10B, 200}" in hfi4_caps:
        raise RuntimeError("HFI4 VP9 still advertises an unmappable literal level")
    if hfi4_caps.count("HFI_VP9_LEVEL_61") < 4:
        raise RuntimeError("HFI4 VP9 level 6.1 is missing from full/lite caps")
    for source_name, source in (("encoder", controls),
                                ("decoder", decoder_controls)):
        for required in ("venus_helper_get_profile_mask",
                         "venus_helper_get_max_level"):
            if required not in source:
                raise RuntimeError(
                    f"{source_name} controls ignore firmware capability {required}")

    transform_case = dynamic[dynamic.find(
        "case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:"):]
    transform_case = transform_case[:transform_case.find("case ", 5)]
    if "if (ctrl->val &&" not in transform_case:
        raise RuntimeError("Disabled H.264 8x8 transform is rejected for Baseline")

    control_init = function(controls, "venc_ctrl_init")
    for required in ("u32 h264_8x8_default = 1",
                     "h264_8x8_default = 0",
                     "h264_8x8_default);",
                     "venus-sm8150: encoder control defaults failed"):
        if required not in control_init:
            raise RuntimeError(f"SM8150 8x8 control default fix is incomplete: {required}")

    i_period = control_init.find("V4L2_CID_MPEG_VIDEO_H264_I_PERIOD")
    if i_period < 0:
        raise RuntimeError("Non-IRIS1 H.264 I-period compatibility control is missing")
    i_period_guard = control_init.rfind("if (!IS_IRIS1(inst->core))", 0, i_period)
    if i_period_guard < 0 or i_period - i_period_guard > 256:
        raise RuntimeError("IRIS1 still advertises the unsupported H.264 I-period control")

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

    print("PASS: SM8150 syscache, encoder protocol/DMA/EBD, PM and safety invariants")


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
            "venus_helper_check_format", "venus_helper_get_out_fmts",
            "get_framesize_raw_p010",
        ],
        "vdec.c": [
            "vdec_fmt_is_8bit", "vdec_fmt_is_10bit",
            "vdec_capture_fmt_matches_stream",
        ],
    }
    bandwidth_source = (driver / "pm_helpers.c").read_text(encoding="utf-8")
    bandwidth_start = bandwidth_source.find("#define IRIS1_BW_MAX_KBPS")
    bandwidth_end = bandwidth_source.find("static int load_scale_bw",
                                          bandwidth_start)
    if bandwidth_start < 0 or bandwidth_end < bandwidth_start:
        raise RuntimeError("SM8150 dynamic bandwidth implementation is missing")
    bandwidth_functions = bandwidth_source[bandwidth_start:bandwidth_end]
    bandwidth_harness = (repo / "tests/iris1-bandwidth.c").read_text(
        encoding="utf-8")
    bandwidth_harness = bandwidth_harness.replace(
        "/* ACTUAL_DRIVER_FUNCTIONS */", bandwidth_functions)
    with tempfile.TemporaryDirectory(prefix="venus-iris1-bandwidth-") as directory:
        target = Path(directory)
        source = target / "iris1-bandwidth.c"
        executable = target / (
            "iris1-bandwidth.exe" if os.name == "nt" else "iris1-bandwidth")
        source.write_text(bandwidth_harness, encoding="utf-8")
        subprocess.run([args.cc, "-std=gnu11", "-O1", "-g", "-Wall", "-Wextra",
                        "-Werror", str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True)

    clock_function = function(bandwidth_source, "calculate_inst_freq")
    clock_harness = (repo / "tests/iris1-clock.c").read_text(encoding="utf-8")
    clock_harness = clock_harness.replace(
        "/* ACTUAL_DRIVER_FUNCTION */", clock_function)
    with tempfile.TemporaryDirectory(prefix="venus-iris1-clock-") as directory:
        target = Path(directory)
        source = target / "iris1-clock.c"
        executable = target / (
            "iris1-clock.exe" if os.name == "nt" else "iris1-clock")
        source.write_text(clock_harness, encoding="utf-8")
        subprocess.run([args.cc, "-std=gnu11", "-O1", "-g", "-Wall", "-Wextra",
                        "-Werror", str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True)

    encoder_source = (driver / "venc.c").read_text(encoding="utf-8")
    raw_layout_functions = "\n\n".join((
        function(encoder_source, "venc_get_framesz"),
        function(encoder_source, "venc_get_stride"),
    ))
    raw_layout_harness = (repo / "tests/iris1-raw-layout.c").read_text(
        encoding="utf-8")
    raw_layout_harness = raw_layout_harness.replace(
        "/* ACTUAL_DRIVER_FUNCTIONS */", raw_layout_functions)
    with tempfile.TemporaryDirectory(prefix="venus-iris1-raw-layout-") as directory:
        target = Path(directory)
        source = target / "iris1-raw-layout.c"
        executable = target / (
            "iris1-raw-layout.exe" if os.name == "nt" else "iris1-raw-layout")
        source.write_text(raw_layout_harness, encoding="utf-8")
        subprocess.run([args.cc, "-std=gnu11", "-O1", "-g", "-Wall", "-Wextra",
                        "-Werror", str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True)

    encoder_control_functions = "\n\n".join((
        function(encoder_source, "venc_pack_qp"),
        function(encoder_source, "venc_iris1_h264_sar"),
        function(encoder_source, "venc_iris1_internal_config"),
    ))
    encoder_control_harness = (
        repo / "tests/iris1-encoder-controls.c").read_text(encoding="utf-8")
    encoder_control_harness = encoder_control_harness.replace(
        "/* ACTUAL_DRIVER_FUNCTIONS */", encoder_control_functions)
    with tempfile.TemporaryDirectory(prefix="venus-iris1-encoder-controls-") as directory:
        target = Path(directory)
        source = target / "iris1-encoder-controls.c"
        executable = target / (
            "iris1-encoder-controls.exe" if os.name == "nt" else
            "iris1-encoder-controls")
        source.write_text(encoder_control_harness, encoding="utf-8")
        subprocess.run([args.cc, "-std=gnu11", "-O1", "-g", "-Wall", "-Wextra",
                        "-Werror", str(source), "-o", str(executable)], check=True)
        subprocess.run([str(executable)], check=True)

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
