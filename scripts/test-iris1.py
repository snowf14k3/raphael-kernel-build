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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kernel", type=Path)
    parser.add_argument("--cc", default=os.environ.get("CC", "cc"))
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent
    driver = args.kernel / "drivers/media/platform/qcom/venus"
    validate_protocol_sources(driver)
    power_sources = {
        "pm_helpers.c": [
            "core_clks_enable", "core_clks_disable", "core_clks_set_rate",
            "vcodec_clks_enable", "vcodec_clks_disable", "core_resets_reset",
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
    for name, sources in [("power", power_sources), ("hfi", hfi_sources),
                          ("queues", queue_sources),
                          ("session", session_sources)]:
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
