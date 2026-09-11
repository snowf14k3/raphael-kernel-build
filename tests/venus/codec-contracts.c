/* SPDX-License-Identifier: GPL-2.0-only */
/* The tested packetizer and codec functions are extracted from the real series.
 * PM, firmware responses and VB2 storage are mocks, not a hardware model.
 */
#include <stdio.h>
#include <stdlib.h>
#include <linux/videodev2.h>
#include "hfi_cmds.h"
#include "vpu-types.h"

#define max(a,b) ((a) > (b) ? (a) : (b))
#define max3(a,b,c) max(max(a,b),c)
#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
#ifndef V4L2_TYPE_IS_OUTPUT
#define V4L2_TYPE_IS_OUTPUT(t) ((t) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
#endif
struct venus_resources { enum vpu_version vpu_version; enum hfi_version hfi_version; u8 num_vpp_pipes; void *ubwc_conf; };
struct venus_core { struct venus_resources *res; struct device *dev; };
struct venc_controls { int bitrate_mode, multi_slice_mode; };
struct venus_format { u32 pixfmt; };
struct vb2_buffer { unsigned int size; };
struct vb2_queue {
    u32 type;
    unsigned int count, max_num_buffers;
    void *drv_priv;
    struct vb2_buffer *bufs[16];
};
struct queues { struct vb2_queue input, output; };
struct venus_inst {
    struct venus_core *core;
    struct { struct venc_controls enc; } controls;
    struct venus_format *fmt_out, *fmt_cap;
    u32 colorspace, ycbcr_enc, quantization, xfer_func;
    struct queues *m2m_ctx;
    unsigned int width, height, out_width, out_height, fps;
    u32 hfi_codec, pic_struct, input_buf_size, output_buf_size;
    unsigned int num_input_bufs, num_output_bufs;
    int lock;
};

static unsigned int assertions;
#define CHECK(x) do { assertions++; if (!(x)) { \
    fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #x); exit(1); } } while (0)
static u32 last_property, last_route;
static unsigned int property_calls;
static int property_error;
int hfi_session_set_property(struct venus_inst *inst, u32 type, void *data)
{
    (void)inst;
    last_property = type;
    last_route = ((struct hfi_video_work_route *)data)->video_work_route;
    property_calls++;
    return property_error;
}
static struct hfi_buffer_requirements requirements;
static int pm_refs, get_error, put_error, init_error, query_error;
static u32 queried_type;
static void *vb2_get_drv_priv(struct vb2_queue *q) { return q->drv_priv; }
static unsigned int vb2_get_num_buffers(struct vb2_queue *q) { return q->count; }
static struct vb2_buffer *vb2_get_buffer(struct vb2_queue *q, unsigned int i) { return i < 16 ? q->bufs[i] : NULL; }
static unsigned int vb2_plane_size(struct vb2_buffer *b, unsigned int plane) { (void)plane; return b->size; }
static struct vb2_queue *v4l2_m2m_get_vq(struct queues *q, u32 type) { return V4L2_TYPE_IS_OUTPUT(type) ? &q->input : &q->output; }
static void mutex_lock(int *lock) { CHECK(!*lock); *lock = 1; }
static void mutex_unlock(int *lock) { CHECK(*lock == 1); *lock = 0; }
static int venc_pm_get(struct venus_inst *inst) { (void)inst; if (get_error) return get_error; pm_refs++; return 0; }
static int venc_pm_put(struct venus_inst *inst, bool autosuspend) { (void)inst; (void)autosuspend; pm_refs--; return put_error; }
static int venc_init_session(struct venus_inst *inst) { (void)inst; return init_error; }
static unsigned int venus_helper_get_framesz(u32 fmt, unsigned int w, unsigned int h) { (void)fmt; return w * h * 3 / 2; }
static int venus_helper_get_bufreq(struct venus_inst *inst, u32 type, struct hfi_buffer_requirements *r)
{ (void)inst; queried_type = type; *r = requirements; return query_error; }

struct file { struct venus_inst *inst; };
static struct venus_inst *to_inst(struct file *file) { return file->inst; }
static inline bool vb2_is_busy(struct vb2_queue *q) { return q->count != 0; }
/* Mock the old generic size formula; test the real G_FMT wrapper's contract. */
static const struct venus_format *venc_try_fmt_common(struct venus_inst *i, struct v4l2_format *f)
{
    f->fmt.pix_mp.plane_fmt[0].sizeimage = max(f->fmt.pix_mp.plane_fmt[0].sizeimage, 4096U);
    return i->fmt_out;
}
#include "venc_g_fmt.h"

static void format_tests(struct venus_inst *i)
{
    struct file file = { .inst = i };
    struct v4l2_format fmt;
    const u32 types[] = { V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE };
    i->core->res->vpu_version = VPU_VERSION_IRIS1;
    i->input_buf_size = 8192; i->output_buf_size = 16384;
    i->fmt_cap = i->fmt_out;
    for (unsigned int n = 0; n < 2; n++) {
        struct vb2_queue *q = v4l2_m2m_get_vq(i->m2m_ctx, types[n]);
        memset(&fmt, 0, sizeof(fmt)); fmt.type = types[n];
        fmt.fmt.pix_mp.plane_fmt[0].sizeimage = 1048576;
        q->count = 5; CHECK(vb2_is_busy(q));
        CHECK(venc_g_fmt(&file, NULL, &fmt) == 0);
        CHECK(fmt.fmt.pix_mp.plane_fmt[0].sizeimage == (n ? 16384U : 8192U));
        q->count = 0;
        CHECK(venc_g_fmt(&file, NULL, &fmt) == 0);
        CHECK(fmt.fmt.pix_mp.plane_fmt[0].sizeimage == 4096);
    }
    memset(&fmt, 0, sizeof(fmt));
    CHECK(venc_g_fmt(&file, NULL, &fmt) == -EINVAL);
}

#include "vdec_set_work_route.h"
#include "venc_set_work_route.h"
#include "venc_queue_setup_iris1.h"
#include "venc_verify_queue_iris1.h"

static void packet_tests(void)
{
    u32 packet[128], reference[128];
    struct hfi_session_set_property_pkt *p = (void *)packet;
    struct hfi_video_work_route wr;
    void *cookie = (void *)(uintptr_t)0x11223344;
    unsigned int route;
    for (route = 1; route <= 4; route++) {
        wr.video_work_route = route;
        memset(packet, 0x5a, sizeof(packet));
        pkt_set_version(HFI_VERSION_4XX);
        CHECK(pkt_session_set_property(p, cookie, HFI_PROPERTY_PARAM_WORK_ROUTE, &wr) == 0);
        CHECK(packet[0] == 24 && packet[1] == HFI_CMD_SESSION_SET_PROPERTY);
        CHECK(packet[2] == 0x11223344 && packet[3] == 1);
        CHECK(packet[4] == HFI_PROPERTY_PARAM_WORK_ROUTE && packet[5] == route);
        CHECK(packet[6] == 0x5a5a5a5a);
        memcpy(reference, packet, sizeof(reference));
        pkt_set_version(HFI_VERSION_6XX);
        memset(packet, 0x5a, sizeof(packet));
        CHECK(pkt_session_set_property(p, cookie, HFI_PROPERTY_PARAM_WORK_ROUTE, &wr) == 0);
        CHECK(!memcmp(packet, reference, sizeof(packet)));
    }
    pkt_set_version(HFI_VERSION_4XX);
    CHECK(pkt_session_set_property(NULL, cookie, HFI_PROPERTY_PARAM_WORK_ROUTE, &wr) == -EINVAL);
    CHECK(pkt_session_set_property(p, NULL, HFI_PROPERTY_PARAM_WORK_ROUTE, &wr) == -EINVAL);
    CHECK(pkt_session_set_property(p, cookie, HFI_PROPERTY_PARAM_WORK_ROUTE, NULL) == -EINVAL);
    pkt_set_version(HFI_VERSION_3XX);
    CHECK(pkt_session_set_property(p, cookie, HFI_PROPERTY_PARAM_WORK_ROUTE, &wr) < 0);
}

static void route_tests(struct venus_inst *i)
{
    const int modes[] = { V4L2_MPEG_VIDEO_BITRATE_MODE_VBR, V4L2_MPEG_VIDEO_BITRATE_MODE_CBR, V4L2_MPEG_VIDEO_BITRATE_MODE_CQ };
    unsigned int m;
    i->core->res->vpu_version = VPU_VERSION_IRIS1;
    i->core->res->num_vpp_pipes = 2;
    i->pic_struct = HFI_INTERLACE_FRAME_PROGRESSIVE;
    i->hfi_codec = HFI_VIDEO_CODEC_H264;
    CHECK(vdec_set_work_route(i) == 0 && last_route == 2);
    CHECK(last_property == HFI_PROPERTY_PARAM_WORK_ROUTE);
    i->pic_struct = 0;
    CHECK(vdec_set_work_route(i) == 0 && last_route == 1);
    i->hfi_codec = HFI_VIDEO_CODEC_MPEG2;
    CHECK(vdec_set_work_route(i) == 0 && last_route == 1);
    i->hfi_codec = HFI_VIDEO_CODEC_HEVC;
    CHECK(vdec_set_work_route(i) == 0 && last_route == 2);
    for (m = 0; m < sizeof(modes)/sizeof(modes[0]); m++) {
        i->controls.enc.bitrate_mode = modes[m];
        i->controls.enc.multi_slice_mode = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE;
        i->hfi_codec = HFI_VIDEO_CODEC_H264;
        i->width = 1280; i->height = 720; i->fps = 30;
        CHECK(venc_set_work_route(i) == 0);
        CHECK(last_route == (modes[m] == V4L2_MPEG_VIDEO_BITRATE_MODE_CBR ? 1U : 2U));
        i->height = 1080; i->width = 1920;
        CHECK(venc_set_work_route(i) == 0 && last_route == 2);
        i->controls.enc.multi_slice_mode = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES;
        CHECK(venc_set_work_route(i) == 0);
        CHECK(last_route == (modes[m] == V4L2_MPEG_VIDEO_BITRATE_MODE_CQ ? 2U : 1U));
        i->hfi_codec = HFI_VIDEO_CODEC_VP8;
        CHECK(venc_set_work_route(i) == 0 && last_route == 1);
    }
    property_error = -EIO;
    CHECK(venc_set_work_route(i) == -EIO && vdec_set_work_route(i) == -EIO);
    property_error = 0;
    i->core->res->vpu_version = VPU_VERSION_AR50;
    property_calls = 0;
    CHECK(venc_set_work_route(i) == 0 && vdec_set_work_route(i) == 0 && property_calls == 0);
    i->core->res->vpu_version = VPU_VERSION_IRIS2;
    i->core->res->num_vpp_pipes = 4;
    CHECK(vdec_set_work_route(i) == 0 && last_route == 4);
    property_calls = 0;
    CHECK(venc_set_work_route(i) == 0 && property_calls == 0);
}

static void queue_tests(struct venus_inst *i, struct vb2_queue *q)
{
    unsigned int n, planes, sizes[1];
    const bool input = V4L2_TYPE_IS_OUTPUT(q->type);
    struct vb2_buffer small = { .size = 8191 }, large = { .size = 32768 };
    requirements = (struct hfi_buffer_requirements){ .size=8192, .count_actual=3, .hold_count=2, .count_min=5 };
    i->out_width = 64; i->out_height = 64;
    i->output_buf_size = 4096;
    q->max_num_buffers = 16; q->count = 0;
    n=1; planes=0; sizes[0]=0;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == 0);
    CHECK(n == 5 && planes == 1 && sizes[0] == 8192);
    CHECK(queried_type == (input ? HFI_BUFFER_INPUT : HFI_BUFFER_OUTPUT));
    CHECK(pm_refs == 0 && !i->lock);
    q->count=3; n=1; planes=1; sizes[0]=8192;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == 0 && n == 2);
    n=1; planes=1; sizes[0]=8191;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EINVAL);
    planes=2;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EINVAL);
    planes=0; get_error=-EIO;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EIO && pm_refs == 0);
    get_error=0; init_error=-ETIMEDOUT;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -ETIMEDOUT && pm_refs == 0);
    init_error=0; query_error=-EIO;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EIO && pm_refs == 0);
    query_error=0; requirements.size=0;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EINVAL);
    requirements.size=8192; requirements.count_min=17;
    CHECK(venc_queue_setup_iris1(q, &n, &planes, sizes) == -EINVAL);
    requirements.count_min=5;
    q->count=4;
    CHECK(venc_verify_queue_iris1(i, q->type) == -EINVAL);
    q->count=5;
    for (unsigned int idx=0; idx<5; idx++) q->bufs[idx]=&large;
    CHECK(venc_verify_queue_iris1(i, q->type) == 0);
    CHECK((input ? i->num_input_bufs : i->num_output_bufs) == 5);
    q->bufs[4]=&small;
    CHECK(venc_verify_queue_iris1(i, q->type) == -EINVAL);
    q->bufs[4]=NULL; q->bufs[15]=&large;
    CHECK(venc_verify_queue_iris1(i, q->type) == 0);
    requirements.size=65536;
    CHECK(venc_verify_queue_iris1(i, q->type) == -EINVAL);
    memset(q->bufs, 0, sizeof(q->bufs));
    CHECK(pm_refs == 0 && !i->lock);
}

struct device { int unused; };
struct venus_hfi_device { struct venus_core *core; };
static int venus_fw_debug = 3;
static bool venus_fw_low_power_mode = true;
static unsigned int policy_debug, policy_idle, policy_calls, policy_ubwc;
static u32 policy_value;
static int policy_error;
#define dev_warn(dev, ...) ((void)(dev))
static int venus_sys_set_debug(struct venus_hfi_device *h, int level)
{ (void)h; CHECK(level == venus_fw_debug); policy_debug++; return 0; }
static int venus_sys_set_idle_message(struct venus_hfi_device *h, bool enable)
{ (void)h; CHECK(!enable); policy_idle++; return 0; }
static int venus_sys_set_power_control(struct venus_hfi_device *h, bool enable)
{
    union { u32 words[16]; struct hfi_sys_set_property_pkt pkt; } data = {0};
    (void)h;
    pkt_sys_power_control(&data.pkt, enable);
    CHECK(data.pkt.hdr.pkt_type == HFI_CMD_SYS_SET_PROPERTY);
    CHECK(data.pkt.hdr.size == 20 && data.pkt.num_properties == 1);
    CHECK(data.pkt.data[0] == HFI_PROPERTY_SYS_CODEC_POWER_PLANE_CTRL);
    policy_value = data.pkt.data[1]; policy_calls++;
    return policy_error;
}
static int venus_sys_set_ubwc_config(struct venus_hfi_device *h)
{ CHECK(h->core->res->ubwc_conf); policy_ubwc++; return 0; }
#include "venus_sys_set_default_properties.h"
static void power_policy_tests(struct venus_core *core)
{
    struct device dev = {0};
    struct venus_hfi_device h = { .core = core };
    enum vpu_version vpus[] = {VPU_VERSION_IRIS1, VPU_VERSION_AR50,
        VPU_VERSION_AR50_LITE, VPU_VERSION_IRIS2, VPU_VERSION_IRIS2_1};
    core->dev = &dev;
    for (unsigned int v = 0; v < sizeof(vpus)/sizeof(vpus[0]); v++) {
        for (unsigned int low = 0; low < 2; low++) {
            core->res->vpu_version = vpus[v];
            core->res->hfi_version = HFI_VERSION_4XX;
            core->res->ubwc_conf = NULL;
            venus_fw_low_power_mode = low;
            policy_calls=policy_debug=policy_idle=policy_ubwc=0;
            policy_error=0;
            CHECK(venus_sys_set_default_properties(&h) == 0);
            CHECK(policy_value == (low && vpus[v] != VPU_VERSION_IRIS1));
            CHECK(policy_calls == 1 && policy_debug == 1 && policy_idle == 0 && policy_ubwc == 0);
        }
    }
    core->res->vpu_version=VPU_VERSION_IRIS1;
    policy_error=-EIO;
    CHECK(venus_sys_set_default_properties(&h) == -EIO);
    policy_error=0;
    core->res->vpu_version=VPU_VERSION_AR50;
    core->res->hfi_version=HFI_VERSION_1XX;
    policy_idle=0;
    CHECK(venus_sys_set_default_properties(&h) == 0 && policy_idle == 1);
    core->res->vpu_version=VPU_VERSION_IRIS2;
    core->res->hfi_version=HFI_VERSION_6XX;
    core->res->ubwc_conf=&dev;
    policy_ubwc=0;
    CHECK(venus_sys_set_default_properties(&h) == 0 && policy_ubwc == 1);
    core->res->ubwc_conf=NULL;
}

int main(void)
{
    struct venus_resources res={ .vpu_version=VPU_VERSION_IRIS1, .hfi_version=HFI_VERSION_4XX, .num_vpp_pipes=2 };
    struct venus_core core={ .res=&res };
    struct venus_format fmt={ .pixfmt=V4L2_PIX_FMT_NV12 };
    struct queues queues={0};
    struct venus_inst inst={ .core=&core, .fmt_out=&fmt, .m2m_ctx=&queues };
    queues.input=(struct vb2_queue){ .type=V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, .drv_priv=&inst };
    queues.output=(struct vb2_queue){ .type=V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, .drv_priv=&inst };
    packet_tests(); route_tests(&inst); format_tests(&inst);
    queue_tests(&inst, &queues.input); queue_tests(&inst, &queues.output);
    power_policy_tests(&core);
    printf("PASS: %u assertions against real HFI packetizer and codec functions (host mocks, no hardware)\n", assertions);
    return 0;
}
