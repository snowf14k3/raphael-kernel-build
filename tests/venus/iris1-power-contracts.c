/* SPDX-License-Identifier: GPL-2.0-only */
/* Actual IRIS1 PM functions with host resource stubs; no hardware emulation. */
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define POWER_ON 1
struct device { unsigned int id; };
struct reset_control { unsigned int id; };
struct venus_resources { unsigned int vcodec_pmdomains_num, resets_num; };
struct dev_pm_domain_list { struct device *pd_devs[3]; };
struct venus_core {
    struct device *dev;
    const struct venus_resources *res;
    struct dev_pm_domain_list *pmdomains;
    struct reset_control *resets[4];
};
static int refs[3], assertion[4], assert_attempts, deassert_attempts, delays;
static int fail_domain, fail_mode, fail_assert, fail_deassert, fail_clocks;
static int fail_vote, fail_put, clocks, votes, releases[3], release_count;
static unsigned int checks;
#define CHECK(x) do { checks++; if (!(x)) { fprintf(stderr,"FAIL %d: %s\n",__LINE__,#x); exit(1); } } while (0)
static int pm_runtime_resume_and_get(struct device *d)
{
    if ((int)d->id == fail_domain) return -EIO;
    refs[d->id]++;
    return 0;
}
static int pm_runtime_put_sync(struct device *d)
{
    CHECK(refs[d->id] == 1);
    refs[d->id]--;
    CHECK(release_count < 3);
    releases[release_count++] = d->id;
    return (int)d->id == fail_put ? -EIO : 0;
}
static int dev_pm_genpd_set_hwmode(struct device *d, bool hardware)
{
    CHECK(!hardware);
    CHECK(refs[d->id] == 1);
    return (int)d->id == fail_mode ? -EIO : 0;
}
static int dev_pm_opp_set_rate(struct device *d, unsigned long rate)
{
    (void)d; CHECK(rate == 0); votes++;
    return fail_vote ? -EIO : 0;
}
static int reset_control_assert(struct reset_control *r)
{
    assert_attempts++;
    if ((int)r->id == fail_assert) return -EIO;
    assertion[r->id] = 1;
    return 0;
}
static int reset_control_deassert(struct reset_control *r)
{
    deassert_attempts++;
    CHECK(assertion[r->id] == 1);
    assertion[r->id] = 0;
    return (int)r->id == fail_deassert ? -EIO : 0;
}
static void usleep_range(unsigned long low, unsigned long high)
{ CHECK(low == 150 && high == 250); delays++; }
static int core_clks_enable(struct venus_core *c)
{
    (void)c;
    for (unsigned int i = 0; i < 3; i++) CHECK(refs[i] == 1);
    for (unsigned int i = 0; i < 4; i++) CHECK(!assertion[i]);
    CHECK(assert_attempts == 4 && deassert_attempts == 4 && delays == 1);
    if (fail_clocks) return -EIO;
    clocks = 1;
    return 0;
}
static void core_clks_disable(struct venus_core *c)
{ (void)c; CHECK(clocks == 1); clocks = 0; }
#include "iris1-pm-functions.h"
static void clear_state(void)
{
    memset(refs, 0, sizeof(refs)); memset(assertion, 0, sizeof(assertion));
    memset(releases, -1, sizeof(releases));
    assert_attempts=deassert_attempts=delays=release_count=clocks=votes=0;
    fail_domain=fail_mode=fail_assert=fail_deassert=fail_put=-1;
    fail_clocks=fail_vote=0;
}
static void check_released(void)
{
    for (unsigned int i=0; i<3; i++) CHECK(refs[i] == 0);
    for (unsigned int i=0; i<4; i++) CHECK(assertion[i] == 0);
    CHECK(clocks == 0);
    for (int i=1; i<release_count; i++) CHECK(releases[i-1] > releases[i]);
}
int main(void)
{
    struct device dev[3]={{0},{1},{2}};
    struct reset_control rst[4]={{0},{1},{2},{3}};
    struct venus_resources res={3,4};
    struct dev_pm_domain_list domains={{&dev[0],&dev[1],&dev[2]}};
    struct venus_core core={.dev=&dev[0],.res=&res,.pmdomains=&domains,
        .resets={&rst[0],&rst[1],&rst[2],&rst[3]}};
    clear_state();
    CHECK(core_power_iris1(&core,POWER_ON) == 0 && clocks == 1);
    CHECK(core_power_iris1(&core,0) == 0);
    check_released(); CHECK(votes == 1);
    for (int i=0;i<3;i++) {
        clear_state(); fail_domain=i;
        CHECK(core_power_iris1(&core,POWER_ON) == -EIO);
        CHECK(assert_attempts == 0); check_released();
    }
    for (int i=1;i<3;i++) {
        clear_state(); fail_mode=i;
        CHECK(core_power_iris1(&core,POWER_ON) == -EIO);
        CHECK(assert_attempts == 0); check_released();
    }
    for (int i=0;i<4;i++) {
        clear_state(); fail_assert=i;
        CHECK(core_power_iris1(&core,POWER_ON) == -EIO);
        CHECK(deassert_attempts == i && delays == (i != 0)); check_released();
        clear_state(); fail_deassert=i;
        CHECK(core_power_iris1(&core,POWER_ON) == -EIO);
        CHECK(deassert_attempts == 4); check_released();
    }
    clear_state(); fail_clocks=1;
    CHECK(core_power_iris1(&core,POWER_ON) == -EIO); check_released();
    for (int i=0;i<3;i++) {
        clear_state(); CHECK(core_power_iris1(&core,POWER_ON) == 0); fail_put=i;
        CHECK(core_power_iris1(&core,0) == -EIO); check_released();
    }
    clear_state(); CHECK(core_power_iris1(&core,POWER_ON) == 0); fail_vote=1;
    CHECK(core_power_iris1(&core,0) == -EIO); check_released();
    clear_state(); core.pmdomains=NULL;
    CHECK(core_power_iris1(&core,POWER_ON) == -EINVAL); check_released();
    core.pmdomains=&domains; res.vcodec_pmdomains_num=2;
    CHECK(core_power_iris1(&core,POWER_ON) == -EINVAL); check_released();
    printf("PASS: %u assertions on real IRIS1 PM/reset functions with host stubs\n",checks);
    return 0;
}
