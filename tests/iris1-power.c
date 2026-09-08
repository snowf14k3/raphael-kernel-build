/* SPDX-License-Identifier: GPL-2.0-only */
/* Host-side control-flow tests. Hardware APIs are mocked, not emulated. */
#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

typedef uint32_t u32;
#define BIT(n) (1U << (n))
#define GENMASK(h, l) ((BIT((h) + 1) - 1) & ~(BIT(l) - 1))
#define POWER_ON 1
#define POWER_OFF 0
#define VIDC_CORE_ID_DEFAULT 0
#define VIDC_CORE_ID_1 1
#define VIDC_IRIS1_LLCC_NUM 2
#define HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE 42
#define IS_IRIS1(c) ((c)->iris1)
#define IS_V4(c) (true)
#define IS_V6(c) (false)
#define is_lite(c) (false)
#define IS_ERR(p) ((intptr_t)(p) < 0)
#define IS_ERR_OR_NULL(p) (!(p) || IS_ERR(p))
#define PTR_ERR(p) ((int)(intptr_t)(p))
#define __maybe_unused

struct device { int id; };
struct clk { int id; };
struct reset_control { int id; };
struct llcc_slice_desc { int id, refs; };
struct dev_pm_opp { int unused; };
struct freq_tbl { unsigned int load; unsigned long freq; };
struct venus_resources {
	const struct freq_tbl *freq_tbl;
	unsigned int freq_tbl_size, clks_num, vcodec_clks_num, resets_num;
};
struct dev_pm_domain_list { struct device *pd_devs[3]; };
struct venus_core;
struct venus_pm_ops { int (*core_power)(struct venus_core *, int); };
struct venus_core {
	bool iris1;
	struct device *dev;
	const struct venus_resources *res;
	struct clk *clks[3], *vcodec0_clks[2], *vcodec1_clks[2];
	struct reset_control *resets[4];
	struct dev_pm_domain_list *pmdomains, *opp_pmdomain;
	unsigned int iris1_pd_mask, iris1_clk_mask, iris1_hw_mask;
	struct llcc_slice_desc *iris1_llcc[VIDC_IRIS1_LLCC_NUM];
	unsigned int iris1_llcc_mask;
	bool iris1_opp_on, iris1_irq_disabled;
	unsigned long iris1_freq;
	int lock, irq;
	const struct venus_pm_ops *pm_ops;
	void *video_path, *cpucfg_path;
};
struct venus_inst {
	struct venus_core *core;
	struct { unsigned int core_id; } clk_data;
	bool core_acquired;
};
struct hfi_videocores_usage_type { unsigned int video_core_enable_mask; };

static int calls, fail_at, fail_at2, pm_refs[3], clk_refs[7], reset_asserted[4];
static bool hwmode[3], fw_suspended;
static int irq_depth, properties;
static unsigned long opp_vote, clock_rate;
static int video_vote, cpu_vote;
static struct device devices[] = { {0}, {1}, {2}, {3} };
static struct clk clocks[] = { {0}, {1}, {2}, {3}, {4}, {5}, {6} };
static struct reset_control resets[] = { {0}, {1}, {2}, {3} };
static struct llcc_slice_desc llcc_slices[] = { {2, 0}, {3, 0} };
static struct dev_pm_domain_list domains = {
	.pd_devs = { &devices[0], &devices[1], &devices[2] },
};
static const struct freq_tbl frequencies[] = { {0, 533000000}, {0, 240000000} };
static const struct venus_resources resources = {
	.freq_tbl = frequencies, .freq_tbl_size = 2,
	.clks_num = 3, .vcodec_clks_num = 2, .resets_num = 4,
};
static struct dev_pm_opp opp;
static int video_path, cpu_path;
static int core_power_iris1(struct venus_core *, int);
static const struct venus_pm_ops pm_ops = { .core_power = core_power_iris1 };

static int fault(void)
{
	calls++;
	return calls == fail_at || calls == fail_at2 ? -EIO : 0;
}
static void log_message(struct device *dev, const char *fmt, ...)
{
	(void)dev;
	(void)fmt;
}
#define dev_err log_message
#define dev_dbg log_message
#define dev_warn log_message
#define dev_info_once log_message
static void mutex_lock(int *lock) { assert(!(*lock)++); }
static void mutex_unlock(int *lock) { assert((*lock)-- == 1); }
static int pm_runtime_resume_and_get(struct device *dev)
{
	if (fault()) return -EIO;
	assert(dev->id < 3);
	pm_refs[dev->id]++;
	return 0;
}
static int pm_runtime_put_sync(struct device *dev)
{
	int ret = fault();
	assert(!hwmode[dev->id]);
	assert(pm_refs[dev->id]-- == 1);
	return ret;
}
static int dev_pm_genpd_set_hwmode(struct device *dev, bool mode)
{
	assert(dev->id == 1 || dev->id == 2);
	assert(pm_refs[dev->id] == 1);
	if (fault()) return -EIO;
	hwmode[dev->id] = mode;
	if (mode)
		for (int i = 0; i < 7; i++) assert(clk_refs[i] == 1);
	return 0;
}
static struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
						  unsigned long *freq)
{
	(void)dev;
	if (fault()) return (void *)(intptr_t)-EIO;
	if (*freq < 240000000) *freq = 240000000;
	return &opp;
}
static void dev_pm_opp_put(struct dev_pm_opp *p) { assert(p == &opp); }
static struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
						   unsigned long *freq)
{
	(void)dev;
	if (fault()) return (void *)(intptr_t)-EIO;
	*freq = 533000000;
	return &opp;
}
static int dev_pm_opp_set_rate(struct device *dev, unsigned long rate)
{
	(void)dev;
	if (fault()) return -EIO;
	opp_vote = rate;
	if (rate) clock_rate = rate;
	return 0;
}
static int clk_set_rate(struct clk *clk, unsigned long rate)
{
	(void)clk;
	if (fault()) return -EIO;
	clock_rate = rate;
	return 0;
}
static unsigned long clk_get_rate(struct clk *clk)
{
	(void)clk;
	return clock_rate;
}
static int clk_prepare_enable(struct clk *clk)
{
	if (fault()) return -EIO;
	assert(opp_vote >= 240000000);
	for (int i = 0; i < 3; i++) assert(pm_refs[i] == 1);
	assert(clk_refs[clk->id]++ == 0);
	return 0;
}
static void clk_disable_unprepare(struct clk *clk)
{
	assert(!hwmode[1] && !hwmode[2]);
	assert(clk_refs[clk->id]-- == 1);
}
static int reset_control_assert(struct reset_control *reset)
{
	if (fault()) return -EIO;
	for (int i = 0; i < 3; i++) assert(pm_refs[i] == 1);
	reset_asserted[reset->id] = 1;
	return 0;
}
static int reset_control_deassert(struct reset_control *reset)
{
	if (fault()) return -EIO;
	reset_asserted[reset->id] = 0;
	return 0;
}
static void usleep_range(int low, int high)
{
	assert(low == 150 && high == 250);
	for (int i = 0; i < 4; i++) assert(reset_asserted[i]);
}
static int hfi_session_set_property(struct venus_inst *inst, unsigned int type,
				    void *data)
{
	struct hfi_videocores_usage_type *cu = data;
	(void)inst;
	assert(type == HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE);
	assert(cu->video_core_enable_mask == 1);
	if (fault()) return -EIO;
	properties++;
	return 0;
}
/* Existing v4 policy is outside this resource-lifetime test. */
static int decide_core(struct venus_inst *inst)
{
	struct hfi_videocores_usage_type cu = { .video_core_enable_mask = 1 };
	inst->clk_data.core_id = 1;
	return hfi_session_set_property(inst, HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE, &cu);
}
static struct venus_core *active_core;
static void *dev_get_drvdata(struct device *dev)
{
	assert(dev == active_core->dev);
	return active_core;
}
#define kbps_to_icc(x) (x)
static int icc_set_bw(void *path, int avg, int peak)
{
	assert(peak == 0);
	if (fault()) return -EIO;
	if (path == &video_path) video_vote = avg;
	else { assert(path == &cpu_path); cpu_vote = avg; }
	return 0;
}
static int hfi_core_suspend(struct venus_core *core)
{
	(void)core;
	if (fault()) return -EIO;
	fw_suspended = true;
	return 0;
}
static int hfi_core_resume(struct venus_core *core, bool force)
{
	(void)force;
	assert(core->iris1_pd_mask == 7 && core->iris1_clk_mask == 7);
	if (fault()) return -EIO;
	fw_suspended = false;
	return 0;
}
static void disable_irq(int irq) { (void)irq; irq_depth++; }
static void enable_irq(int irq) { (void)irq; assert(irq_depth-- > 0); }
static int llcc_slice_activate(struct llcc_slice_desc *desc)
{
	if (fault()) return -EIO;
	assert(desc && !desc->refs);
	desc->refs = 1;
	return 0;
}
static int llcc_slice_deactivate(struct llcc_slice_desc *desc)
{
	assert(desc && desc->refs == 1);
	desc->refs = 0;
	return 0;
}
static void llcc_slice_putd(struct llcc_slice_desc *desc) { (void)desc; }

/* ACTUAL_DRIVER_FUNCTIONS */

static void setup(struct venus_core *core)
{
	memset(core, 0, sizeof(*core));
	memset(pm_refs, 0, sizeof(pm_refs));
	memset(clk_refs, 0, sizeof(clk_refs));
	memset(reset_asserted, 0, sizeof(reset_asserted));
	memset(hwmode, 0, sizeof(hwmode));
	memset(llcc_slices, 0, sizeof(llcc_slices));
	llcc_slices[0].id = 2;
	llcc_slices[1].id = 3;
	calls = fail_at = fail_at2 = properties = irq_depth = 0;
	video_vote = cpu_vote = 0;
	opp_vote = 0;
	clock_rate = 19200000;
	fw_suspended = false;
	core->iris1 = true;
	core->dev = &devices[3];
	core->res = &resources;
	core->pmdomains = &domains;
	core->opp_pmdomain = &domains;
	core->pm_ops = &pm_ops;
	core->video_path = &video_path;
	core->cpucfg_path = &cpu_path;
	for (int i = 0; i < 3; i++) core->clks[i] = &clocks[i];
	for (int i = 0; i < 2; i++) {
		core->vcodec0_clks[i] = &clocks[3 + i];
		core->vcodec1_clks[i] = &clocks[5 + i];
	}
	for (int i = 0; i < 4; i++) core->resets[i] = &resets[i];
	for (int i = 0; i < VIDC_IRIS1_LLCC_NUM; i++)
		core->iris1_llcc[i] = &llcc_slices[i];
	active_core = core;
}
static void assert_off(struct venus_core *core)
{
	assert(!core->iris1_pd_mask && !core->iris1_clk_mask);
	assert(!core->iris1_hw_mask && !core->iris1_opp_on && !opp_vote);
	for (int i = 0; i < 3; i++) assert(!pm_refs[i] && !hwmode[i]);
	for (int i = 0; i < 7; i++) assert(!clk_refs[i]);
	for (int i = 0; i < VIDC_IRIS1_LLCC_NUM; i++) assert(!llcc_slices[i].refs);
	assert(!core->iris1_llcc_mask);
}
static void assert_on(struct venus_core *core)
{
	assert(core->iris1_pd_mask == 7 && core->iris1_clk_mask == 7);
	assert(core->iris1_hw_mask == 6 && core->iris1_opp_on);
	for (int i = 0; i < 3; i++) assert(pm_refs[i] == 1);
	for (int i = 0; i < 7; i++) assert(clk_refs[i] == 1);
	for (int i = 0; i < VIDC_IRIS1_LLCC_NUM; i++) assert(llcc_slices[i].refs == 1);
	assert(core->iris1_llcc_mask == GENMASK(VIDC_IRIS1_LLCC_NUM - 1, 0));
}
int main(void)
{
	struct venus_core core;
	int startup_calls, shutdown_calls, resume_calls, suspend_calls;
	setup(&core);
	assert(!core_power_iris1(&core, POWER_ON));
	startup_calls = calls;
	assert_on(&core);
	assert(clock_rate == 533000000);
	assert(!core_power_iris1(&core, POWER_ON)); /* idempotent, no extra votes */
	assert(calls == startup_calls);
	assert(!core_clks_set_rate(&core, 444000000));
	calls = 0;
	assert(!core_power_iris1(&core, POWER_OFF));
	shutdown_calls = calls;
	assert_off(&core);
	assert(!core_power_iris1(&core, POWER_ON));
	assert(clock_rate == 444000000); /* restore streaming OPP */
	core_put_iris1(&core);
	assert_off(&core);

	for (int n = 1; n <= startup_calls; n++) {
		setup(&core);
		fail_at = n;
		int ret = core_power_iris1(&core, POWER_ON);
		fail_at = 0;
		if (!ret) assert_on(&core); /* OPP lookup has a table fallback */
		else assert_off(&core);
		assert(!iris1_power_off(&core));
		assert_off(&core);
		/* A fresh retry must work, including after a reset deassert failure. */
		assert(!core_power_iris1(&core, POWER_ON));
		assert_on(&core);
		core_put_iris1(&core);
		assert_off(&core);
	}
	for (int n = 1; n <= shutdown_calls; n++) {
		setup(&core);
		assert(!core_power_iris1(&core, POWER_ON));
		calls = 0;
		fail_at = n;
		assert(core_power_iris1(&core, POWER_OFF) < 0);
		if (n <= 2) assert(core.iris1_clk_mask == 7 && core.iris1_pd_mask == 7);
		fail_at = 0;
		core_put_iris1(&core); /* consumes only references still owned */
		assert_off(&core);
	}
	/* If handoff AND reclamation fail, retain power until teardown retries. */
	setup(&core);
	fail_at = startup_calls;
	fail_at2 = startup_calls + 1;
	assert(core_power_iris1(&core, POWER_ON) < 0);
	assert(core.iris1_pd_mask == 7 && core.iris1_clk_mask == 7);
	fail_at = fail_at2 = 0;
	core_put_iris1(&core);
	assert_off(&core);
	setup(&core);
	struct venus_inst dec = { .core = &core }, enc = { .core = &core };
	assert(!core_power_iris1(&core, POWER_ON));
	assert(!coreid_power_iris1(&dec, POWER_ON));
	assert(!coreid_power_iris1(&enc, POWER_ON));
	assert(!coreid_power_iris1(&dec, POWER_ON));
	assert(properties == 2 && dec.clk_data.core_id == 1 && enc.clk_data.core_id == 1);
	assert(!coreid_power_iris1(&dec, POWER_OFF));
	assert_on(&core); /* closing one session must not switch off CVP/MVS0 */
	assert(!coreid_power_iris1(&enc, POWER_OFF));
	fail_at = calls + 1;
	assert(coreid_power_iris1(&enc, POWER_ON) < 0);
	assert(!enc.core_acquired && !enc.clk_data.core_id);
	fail_at = 0;
	core_put_iris1(&core);
	assert_off(&core);

	setup(&core);
	assert(!venus_runtime_resume(core.dev));
	resume_calls = calls;
	calls = 0;
	assert(!venus_runtime_suspend(core.dev));
	suspend_calls = calls;
	assert_off(&core);
	assert(irq_depth == 1 && fw_suspended);
	assert(!venus_runtime_resume(core.dev));
	assert_on(&core);
	assert(!irq_depth && !fw_suspended);
	assert(!venus_runtime_suspend(core.dev));
	assert_off(&core);
	for (int n = 1; n <= resume_calls; n++) {
		setup(&core);
		fail_at = n;
		int ret = venus_runtime_resume(core.dev);
		fail_at = 0;
		if (ret) {
			assert_off(&core);
			assert(!video_vote && !cpu_vote);
		} else assert(!venus_runtime_suspend(core.dev));
		assert_off(&core);
	}
	for (int n = 1; n <= suspend_calls; n++) {
		setup(&core);
		assert(!venus_runtime_resume(core.dev));
		calls = 0;
		fail_at = n;
		assert(venus_runtime_suspend(core.dev) < 0);
		fail_at = 0;
		assert_on(&core);
		assert(!irq_depth && !fw_suspended);
		assert(!venus_runtime_suspend(core.dev));
		assert_off(&core);
	}
	setup(&core);
	fail_at = resume_calls;
	fail_at2 = resume_calls + 1;
	assert(venus_runtime_resume(core.dev) < 0);
	assert_on(&core);
	assert(video_vote && cpu_vote); /* access must remain while power is held */
	fail_at = fail_at2 = 0;
	assert(!venus_runtime_suspend(core.dev));
	assert_off(&core);
	printf("PASS: %d startup, %d shutdown, %d resume, %d suspend fault points; "
	       "OPP restore, shared sessions, retries and IRQ balance\n",
	       startup_calls, shutdown_calls, resume_calls, suspend_calls);
	return 0;
}
