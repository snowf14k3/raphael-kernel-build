/* SPDX-License-Identifier: GPL-2.0-only */
/* Host control-flow test, not a model of the Venus device or firmware.
 * The shell runner extracts the real function, enums, masks and predicates.
 */
#include <errno.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef uint32_t u32;
#define __iomem
#define BIT(n) (UINT32_C(1) << (n))
#include "venus-test-types.h"
#include "hfi_venus_io.h"

struct device { unsigned int unused; };
struct venus_resources {
	enum hfi_version hfi_version;
	enum vpu_version vpu_version;
};
struct venus_core {
	struct device *dev;
	const struct venus_resources *res;
	void *cpu_cs_base;
	void *wrapper_base;
};
struct venus_hfi_device { struct venus_core *core; };

static u32 readl(const void *address)
{
	return *(const u32 *)address;
}

static void writel(u32 value, void *address)
{
	*(u32 *)address = value;
}

static void usleep_range(unsigned int minimum, unsigned int maximum)
{
	(void)minimum;
	(void)maximum;
}

#define dev_err(dev, ...) ((void)(dev))
#include "venus-boot-under-test.h"

static unsigned int cases;

static int check_value(const char *name, const char *field, u32 got, u32 want)
{
	if (got == want)
		return 0;
	fprintf(stderr, "FAIL %s %s: got 0x%x, expected 0x%x\n",
		name, field, got, want);
	return 1;
}

static int run_case(const char *name, enum vpu_version vpu,
		    enum hfi_version hfi, u32 initial, u32 expected,
		    u32 status, int expected_ret)
{
	u32 cpu_regs[256] = {0}, wrapper_regs[32] = {0};
	struct device device = {0};
	struct venus_resources resource = { .vpu_version = vpu, .hfi_version = hfi };
	struct venus_core core = {
		.dev = &device, .res = &resource,
		.cpu_cs_base = cpu_regs, .wrapper_base = wrapper_regs,
	};
	struct venus_hfi_device hdev = { .core = &core };
	const u32 untouched = 0xa5a5a5a5;
	const bool iris2 = vpu == VPU_VERSION_IRIS2 || vpu == VPU_VERSION_IRIS2_1;
	const bool lite = vpu == VPU_VERSION_AR50_LITE;
	int ret;

	wrapper_regs[WRAPPER_INTR_MASK / 4] = initial;
	cpu_regs[CPU_CS_SCIACMDARG0 / 4] = status;
	cpu_regs[CPU_CS_H2XSOFTINTEN_V6 / 4] = untouched;
	cpu_regs[CPU_CS_X2RPMH_V6 / 4] = untouched;
	ret = venus_boot_core(&hdev);
	cases++;

	if (check_value(name, "mask", wrapper_regs[WRAPPER_INTR_MASK / 4], expected) ||
	    check_value(name, "return", (u32)ret, (u32)expected_ret) ||
	    check_value(name, "CTRL_INIT", cpu_regs[VIDC_CTRL_INIT / 4], 1) ||
	    check_value(name, "ARG3", cpu_regs[CPU_CS_SCIACMDARG3 / 4],
			hfi == HFI_VERSION_1XX ? 1 : 0) ||
	    check_value(name, "H2X", cpu_regs[CPU_CS_H2XSOFTINTEN_V6 / 4],
			iris2 || lite ? 1 : untouched) ||
	    check_value(name, "RPMH", cpu_regs[CPU_CS_X2RPMH_V6 / 4],
			iris2 ? 0 : untouched))
		return 1;
	return 0;
}

int main(void)
{
	u32 seed = 0x8150;
	unsigned int i;
	const enum vpu_version old_vpus[] = {
		VPU_VERSION_AR50, VPU_VERSION_AR50_LITE,
		VPU_VERSION_IRIS2, VPU_VERSION_IRIS2_1,
	};

	/* Red test on the fixed baseline; green test with this patch. */
	if (run_case("IRIS1 reset", VPU_VERSION_IRIS1, HFI_VERSION_4XX,
		     0x1f6, 0x1e2, 1, 0))
		return 1;

	/* Random masks check that all bits other than 2 and 4 are preserved. */
	for (i = 0; i < 1024; i++) {
		seed = seed * 1664525U + 1013904223U;
		if (run_case("IRIS1 preserved bits", VPU_VERSION_IRIS1,
			     HFI_VERSION_4XX, seed, seed & ~UINT32_C(0x14), 1, 0))
			return 1;
	}
	for (i = 0; i < 32; i++) {
		u32 mask = BIT(i);
		if (run_case("IRIS1 single bit", VPU_VERSION_IRIS1,
			     HFI_VERSION_4XX, mask, mask & ~UINT32_C(0x14), 1, 0))
			return 1;
	}
	for (i = 0; i < sizeof(old_vpus) / sizeof(old_vpus[0]); i++) {
		enum vpu_version vpu = old_vpus[i];
		bool iris2 = vpu == VPU_VERSION_IRIS2 || vpu == VPU_VERSION_IRIS2_1;
		u32 expected = iris2 ? 0x1f2 : 0x8;
		if (run_case("existing VPU", vpu, iris2 ? HFI_VERSION_6XX : HFI_VERSION_4XX,
			     0x1fe, expected, 1, 0) ||
		    run_case("existing VPU timeout", vpu,
			     iris2 ? HFI_VERSION_6XX : HFI_VERSION_4XX,
			     0x1fe, expected, 0, -ETIMEDOUT))
			return 1;
	}
	if (run_case("legacy HFI1", VPU_VERSION_AR50, HFI_VERSION_1XX,
		     0x1f6, 0x8, 1, 0) ||
	    run_case("legacy HFI3", VPU_VERSION_AR50, HFI_VERSION_3XX,
		     0x1f6, 0x8, 1, 0) ||
	    run_case("IRIS1 invalid UC", VPU_VERSION_IRIS1, HFI_VERSION_4XX,
		     0x1f6, 0x1e2, 4, -EINVAL) ||
	    run_case("IRIS1 timeout", VPU_VERSION_IRIS1, HFI_VERSION_4XX,
		     0x1f6, 0x1e2, 0, -ETIMEDOUT))
		return 1;

	printf("PASS: %u host MMIO control-flow cases; no hardware exercised\n", cases);
	return 0;
}
