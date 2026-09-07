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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("kernel", type=Path)
    parser.add_argument("--cc", default=os.environ.get("CC", "cc"))
    args = parser.parse_args()
    repo = Path(__file__).resolve().parent.parent
    driver = args.kernel / "drivers/media/platform/qcom/venus"
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
    for name, sources in [("power", power_sources), ("hfi", hfi_sources),
                          ("queues", queue_sources)]:
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
