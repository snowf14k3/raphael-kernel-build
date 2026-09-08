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

    if "#define HFI_BUFFER_TYPE_MAX\t\t\t12" not in helper or \
       "internal recon requirement" not in helper:
        raise RuntimeError("HFI 4xx buffer-requirement capacity is incomplete")
    parser = function(messages, "session_get_prop_buf_req")
    bounds = parser.find("if (idx >= HFI_BUFFER_TYPE_MAX)")
    copy = parser.find("memcpy(&bufreq[idx]")
    if bounds < 0 or copy < 0 or bounds > copy:
        raise RuntimeError("Buffer-requirement bounds check must precede memcpy")
    print("PASS: HFI 4xx WORK_ROUTE/low-latency packets and 12-entry parser invariants")


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
    pm = (driver / "pm_helpers.c").read_text(encoding="utf-8")
    commands = (driver / "hfi_cmds.c").read_text(encoding="utf-8")
    command_header = (driver / "hfi_cmds.h").read_text(encoding="utf-8")
    helper = (driver / "hfi_helper.h").read_text(encoding="utf-8")
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

    profile_level = function(helpers, "venus_helper_set_profile_level")
    for required in ("IS_IRIS1(inst->core)", "HFI_VIDEO_CODEC_H264",
                     "V4L2_MPEG_VIDEO_H264_LEVEL_5_1", "pl.level = 0"):
        if required not in profile_level:
            raise RuntimeError(f"SM8150 automatic H.264 level is incomplete: {required}")
    properties = function(encoder, "venc_set_properties")
    for required in ("!ctr->rc_enable", "HFI_PROPERTY_CONFIG_VENC_FRAME_QP",
                     "IS_IRIS1(inst->core) ? 0xff : 0"):
        if required not in properties:
            raise RuntimeError(f"SM8150 encoder property setup is incomplete: {required}")
    for required in ("V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE",
                     "V4L2_MPEG_VIDEO_H264_LEVEL_5_1"):
        if required not in controls:
            raise RuntimeError(f"SM8150 encoder defaults are incomplete: {required}")

    print("PASS: SM8150 LLCC/HFI system-cache and H.264 encoder invariants")


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
