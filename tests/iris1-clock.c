#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef uint32_t u32;
typedef uint64_t u64;

#define VIDC_SESSION_TYPE_ENC 1
#define VIDC_SESSION_TYPE_DEC 2
#define VENUS_LOW_POWER (1U << 0)
#define INST_START 2

#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
#define max(x, y) ((x) > (y) ? (x) : (y))
#define max_t(t, x, y) ((t)(x) > (t)(y) ? (t)(x) : (t)(y))
#define min_t(t, x, y) ((t)(x) < (t)(y) ? (t)(x) : (t)(y))
#define max3(x, y, z) max(max((x), (y)), (z))
#define IS_IRIS1(core) ((core)->iris1)

static inline u64 div_u64(u64 numerator, u64 denominator)
{
	return numerator / denominator;
}

static inline u64 div64_u64(u64 numerator, u64 denominator)
{
	return numerator / denominator;
}

struct venus_resources {
	u32 fw_cycles;
	u32 fw_vpp_cycles;
};

struct venus_core {
	const struct venus_resources *res;
	bool iris1;
};

struct clock_data {
	u32 work_route;
	unsigned long vpp_freq;
	unsigned long vsp_freq;
	unsigned long low_power_freq;
};

struct venus_inst {
	struct venus_core *core;
	struct clock_data clk_data;
	u32 width;
	u32 height;
	u64 fps;
	u32 state;
	u32 session_type;
	u32 flags;
	union {
		struct {
			u32 bitrate;
		} enc;
	} controls;
};

static u32 load_per_instance(struct venus_inst *inst)
{
	u32 mbs;

	mbs = (ALIGN(inst->width, 16) / 16) *
	      (ALIGN(inst->height, 16) / 16);
	return mbs * (u32)inst->fps;
}

/* ACTUAL_DRIVER_FUNCTION */

static void expect_freq(const char *name, unsigned long actual,
			unsigned long expected)
{
	if (actual != expected) {
		fprintf(stderr, "%s: got %lu, expected %lu\n",
			name, actual, expected);
		exit(1);
	}
}

static struct venus_inst instance(struct venus_core *core, u32 session,
				  u32 width, u32 height, u32 fps,
				  u32 route, unsigned long vpp,
				  unsigned long vsp, unsigned long lp,
				  u32 bitrate, bool low_power)
{
	struct venus_inst inst = { 0 };

	inst.core = core;
	inst.session_type = session;
	inst.width = width;
	inst.height = height;
	inst.fps = fps;
	inst.state = INST_START;
	inst.clk_data.work_route = route;
	inst.clk_data.vpp_freq = vpp;
	inst.clk_data.vsp_freq = vsp;
	inst.clk_data.low_power_freq = lp;
	inst.controls.enc.bitrate = bitrate;
	if (low_power)
		inst.flags |= VENUS_LOW_POWER;
	return inst;
}

int main(void)
{
	const struct venus_resources res = {
		.fw_cycles = 760000,
		.fw_vpp_cycles = 166667,
	};
	struct venus_core core = { .res = &res, .iris1 = true };
	struct venus_inst inst;

	inst = instance(&core, VIDC_SESSION_TYPE_DEC, 128, 96, 1,
			2, 200, 10, 200, 0, false);
	expect_freq("h264-dec-small",
		    calculate_inst_freq(&inst, 18432), 10552079);

	inst = instance(&core, VIDC_SESSION_TYPE_DEC, 1920, 1080, 30,
			2, 200, 10, 200, 0, false);
	expect_freq("h264-dec-1080p",
		    calculate_inst_freq(&inst, 200000), 118555883);

	inst = instance(&core, VIDC_SESSION_TYPE_ENC, 128, 96, 1,
			2, 675, 10, 320, 128000, false);
	expect_freq("h264-enc-small",
		    calculate_inst_freq(&inst, 18432), 2895168);

	inst = instance(&core, VIDC_SESSION_TYPE_ENC, 1920, 1080, 30,
			2, 675, 10, 320, 20000000, false);
	expect_freq("h264-enc-1080p-hq",
		    calculate_inst_freq(&inst, 3110400), 88846690);

	inst.flags |= VENUS_LOW_POWER;
	expect_freq("h264-enc-1080p-lp",
		    calculate_inst_freq(&inst, 3110400), 47866719);

	inst = instance(&core, VIDC_SESSION_TYPE_ENC, 1280, 720, 30,
			1, 675, 10, 320, 10000000, false);
	expect_freq("vp8-enc-route1",
		    calculate_inst_freq(&inst, 1382400), 77900010);

	inst = instance(&core, VIDC_SESSION_TYPE_DEC, 3840, 2160, 60,
			2, 200, 10, 200, 0, false);
	expect_freq("vp9-dec-4k60",
		    calculate_inst_freq(&inst, 500000), 525131409);

	inst.state = 0;
	expect_freq("inactive", calculate_inst_freq(&inst, 500000), 0);

	puts("PASS: SM8150 firmware/VPP cycle clock model matches vendor vectors");
	return 0;
}
