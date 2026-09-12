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
#define IS_ALIGNED(n,a) (!((n) & ((a) - 1)))
#define SZ_4K 4096
#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
#define TEST_HFI_BUFFER_INTERNAL_RECON 9
#ifndef V4L2_TYPE_IS_OUTPUT
#define V4L2_TYPE_IS_OUTPUT(t) ((t) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
#endif
struct venus_resources { enum vpu_version vpu_version; enum hfi_version hfi_version; u8 num_vpp_pipes; void *ubwc_conf; u32 cp_nonpixel_start, cp_nonpixel_size; };
struct venus_core { struct venus_resources *res; struct device *dev; void *secure_nonpixel_dev; };
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
typedef u64 dma_addr_t;
typedef u64 phys_addr_t;
struct qcom_scm_vmperm { int vmid, perm; };
struct iommu_domain { int unused; };
struct intbuf {
    size_t size;
    void *va;
    dma_addr_t da;
    phys_addr_t pa;
    struct device *dma_dev;
    unsigned long attrs;
    bool secure;
    bool secure_alloc;
    bool hfi_registered;
};

struct venus_inst {
    struct venus_core *core;
    struct { struct venc_controls enc; } controls;
    struct venus_format *fmt_out, *fmt_cap;
    u32 colorspace, ycbcr_enc, quantization, xfer_func;
    struct queues *m2m_ctx;
    unsigned int width, height, out_width, out_height, fps;
    u32 hfi_codec, pic_struct, input_buf_size, output_buf_size;
    unsigned int num_input_bufs, num_output_bufs;
    enum venus_enc_state enc_state;
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
static unsigned int set_properties_calls;
static int set_properties_error;
static int venc_set_properties(struct venus_inst *inst)
{
    (void)inst;
    set_properties_calls++;
    return set_properties_error;
}
#include "venc_mark_config_dirty.h"
#include "venc_set_properties_if_needed.h"

static struct hfi_buffer_requirements requirements;
static int pm_refs, get_error, put_error, init_error, query_error;
static unsigned int bufreq_calls;
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
{ (void)inst; queried_type = type; bufreq_calls++; *r = requirements; return query_error; }

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
    /* Firmware-authoritative encoder CAPTURE may be smaller than the generic
     * compressed-frame heuristic; an allocated queue must report it exactly. */
    i->output_buf_size = 2048;
    struct vb2_queue *capq = v4l2_m2m_get_vq(i->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
    memset(&fmt, 0, sizeof(fmt));
    fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
    capq->count = 4;
    CHECK(venc_g_fmt(&file, NULL, &fmt) == 0);
    CHECK(fmt.fmt.pix_mp.plane_fmt[0].sizeimage == 2048);
    capq->count = 0;

    /* Raw OUTPUT remains conservative when the Venus layout exceeds FW min. */
    i->input_buf_size = 2048;
    struct vb2_queue *outq = v4l2_m2m_get_vq(i->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
    memset(&fmt, 0, sizeof(fmt));
    fmt.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
    outq->count = 4;
    CHECK(venc_g_fmt(&file, NULL, &fmt) == 0);
    CHECK(fmt.fmt.pix_mp.plane_fmt[0].sizeimage == 4096);
    outq->count = 0;

    memset(&fmt, 0, sizeof(fmt));
    CHECK(venc_g_fmt(&file, NULL, &fmt) == -EINVAL);
}

#include "vdec_set_work_route.h"
#include "venc_set_work_route.h"
#include "venc_queue_setup_iris1.h"
#include "venc_set_queue_count_iris1.h"

static const unsigned int intbuf_types_4xx[] = {
    HFI_BUFFER_INTERNAL_SCRATCH(HFI_VERSION_4XX),
    HFI_BUFFER_INTERNAL_SCRATCH_1(HFI_VERSION_4XX),
    HFI_BUFFER_INTERNAL_SCRATCH_2(HFI_VERSION_4XX),
    HFI_BUFFER_INTERNAL_PERSIST,
    HFI_BUFFER_INTERNAL_PERSIST_1,
};
static union hfi_get_property fw_snapshot;
static unsigned int snapshot_queries, size_calls, intbuf_calls, unset_calls;
static unsigned int dev_errors, dev_infos;
#define dev_err(dev, fmt, ...) do { (void)(dev); dev_errors++; } while (0)
#define dev_info(dev, fmt, ...) do { (void)(dev); dev_infos++; } while (0)

#define QCOM_SCM_VMID_HLOS 3
#define QCOM_SCM_VMID_CP_NON_PIXEL 11
#define QCOM_SCM_PERM_READ 4
#define QCOM_SCM_PERM_WRITE 2
#define QCOM_SCM_PERM_EXEC 1
#define QCOM_SCM_PERM_RW (QCOM_SCM_PERM_READ | QCOM_SCM_PERM_WRITE)
#define QCOM_SCM_PERM_RWX (QCOM_SCM_PERM_RW | QCOM_SCM_PERM_EXEC)
#define BIT_ULL(n) (1ULL << (n))
#define DMA_ATTR_NO_KERNEL_MAPPING (1UL << 4)
#define DMA_ATTR_FORCE_CONTIGUOUS (1UL << 6)
#define GFP_KERNEL 0
#define __GFP_ZERO 0

static struct iommu_domain secure_domain;
static dma_addr_t secure_iova;
static phys_addr_t secure_pa;
static size_t discontinuity_offset;
static unsigned int secure_alloc_calls, secure_free_calls, normal_free_calls;
static unsigned int scm_assign_calls, scm_unassign_calls;
static int secure_alloc_error, secure_domain_error;
static int scm_assign_error, scm_unassign_error;

static struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
{
    (void)dev;
    return secure_domain_error ? NULL : &secure_domain;
}
static phys_addr_t iommu_iova_to_phys(
    struct iommu_domain *domain, dma_addr_t iova)
{
    size_t offset;

    CHECK(domain == &secure_domain);
    CHECK(iova >= secure_iova);
    offset = iova - secure_iova;
    if (offset == discontinuity_offset)
        return secure_pa + offset + SZ_4K;
    return secure_pa + offset;
}
static void *dma_alloc_attrs(struct device *dev, size_t size,
                             dma_addr_t *da, int gfp, unsigned long attrs)
{
    (void)dev; (void)size; (void)gfp;
    secure_alloc_calls++;
    CHECK(attrs == (DMA_ATTR_FORCE_CONTIGUOUS |
                    DMA_ATTR_NO_KERNEL_MAPPING));
    *da = secure_iova;
    return secure_alloc_error ? NULL : (void *)(uintptr_t)0x1234;
}
static void dma_free_attrs(struct device *dev, size_t size, void *va,
                           dma_addr_t da, unsigned long attrs)
{
    (void)dev; (void)size; (void)va; (void)da;
    if (attrs & DMA_ATTR_FORCE_CONTIGUOUS)
        secure_free_calls++;
    else
        normal_free_calls++;
}
static int qcom_scm_assign_mem(
    phys_addr_t pa, size_t size, u64 *src,
    const struct qcom_scm_vmperm *perm, unsigned int count)
{
    CHECK(pa == secure_pa);
    CHECK(size == 65536);
    CHECK(count == 1);
    if (*src == BIT_ULL(QCOM_SCM_VMID_HLOS)) {
        CHECK(perm->vmid == QCOM_SCM_VMID_CP_NON_PIXEL);
        CHECK(perm->perm == QCOM_SCM_PERM_RW);
        scm_assign_calls++;
        return scm_assign_error;
    }
    CHECK(*src == BIT_ULL(QCOM_SCM_VMID_CP_NON_PIXEL));
    CHECK(perm->vmid == QCOM_SCM_VMID_HLOS);
    CHECK(perm->perm == QCOM_SCM_PERM_RWX);
    scm_unassign_calls++;
    return scm_unassign_error;
}
#include "intbuf_secure_assign.h"
#include "intbuf_secure_unassign.h"
#include "intbuf_alloc_secure_persist.h"
#include "intbuf_free_memory.h"
static unsigned int intbuf_types_seen, start_step;
static int snapshot_error, size_error, intbuf_error;
int hfi_session_get_property(struct venus_inst *inst, u32 type,
                                    union hfi_get_property *out)
{
    (void)inst;
    CHECK(type == HFI_PROPERTY_CONFIG_BUFFER_REQUIREMENTS);
    CHECK(start_step == 0);
    snapshot_queries++;
    start_step = 1;
    if (snapshot_error)
        return snapshot_error;
    *out = fw_snapshot;
    return 0;
}
static int venus_helper_set_bufsize(struct venus_inst *inst, u32 size, u32 type)
{
    CHECK(inst->output_buf_size == size);
    CHECK(type == HFI_BUFFER_OUTPUT);
    CHECK(start_step == 1);
    size_calls++;
    start_step = 2;
    return size_error;
}
static int intbufs_set_buffer_req(struct venus_inst *inst,
                                  const struct hfi_buffer_requirements *req)
{
    (void)inst;
    CHECK(start_step >= 2);
    intbuf_calls++;
    intbuf_types_seen |= BIT(req->type);
    start_step = 3;
    return intbuf_error;
}
static int intbufs_unset_buffers(struct venus_inst *inst)
{
    (void)inst;
    unset_calls++;
    return 0;
}
#include "intbufs_find_req.h"
#include "intbufs_validate_queue.h"
#include "intbufs_validate_snapshot.h"
#include "intbufs_alloc_iris1_encoder.h"

static void secure_persist_tests(struct venus_inst *i)
{
    struct intbuf buf;

    i->core->res->cp_nonpixel_start = 0x01000000;
    i->core->res->cp_nonpixel_size = 0x24800000;
    i->core->secure_nonpixel_dev = (void *)(uintptr_t)1;
    secure_pa = 0x90000000;
    secure_iova = 0x02000000;
    discontinuity_offset = SIZE_MAX;
    secure_alloc_calls = secure_free_calls = normal_free_calls = 0;
    scm_assign_calls = scm_unassign_calls = 0;
    secure_alloc_error = secure_domain_error = 0;
    scm_assign_error = scm_unassign_error = 0;
    dev_infos = 0;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == 0);
    CHECK(buf.va && buf.secure_alloc && buf.secure);
    CHECK(buf.pa == 0x90000000 && buf.da == 0x02000000);
    CHECK(secure_alloc_calls == 1 && scm_assign_calls == 1);
    CHECK(dev_infos == 1);
    CHECK(intbuf_free_memory(i, &buf) == 0);
    CHECK(!buf.va && !buf.secure_alloc && !buf.secure);
    CHECK(secure_free_calls == 1 && scm_unassign_calls == 1);
    CHECK(dev_infos == 2);

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == 0);
    CHECK(dev_infos == 3);
    scm_unassign_error = -EIO;
    CHECK(intbuf_free_memory(i, &buf) == -EIO);
    CHECK(buf.va && buf.secure_alloc && buf.secure);
    CHECK(secure_free_calls == 1 && dev_infos == 3);
    scm_unassign_error = 0;
    CHECK(intbuf_free_memory(i, &buf) == 0);
    CHECK(secure_free_calls == 2 && dev_infos == 4);

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    scm_assign_error = -EIO;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -EIO);
    CHECK(!buf.va && !buf.secure_alloc && !buf.secure);
    CHECK(secure_free_calls == 3);
    scm_assign_error = 0;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    secure_iova = 0x25800000;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -ERANGE);
    CHECK(!buf.va && !buf.secure_alloc && secure_free_calls == 4);
    secure_iova = 0x02000000;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    discontinuity_offset = SZ_4K;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -EINVAL);
    CHECK(!buf.va && !buf.secure_alloc && secure_free_calls == 5);
    discontinuity_offset = SIZE_MAX;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    secure_pa = 0x90000001;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -EINVAL);
    CHECK(!buf.va && !buf.secure_alloc && secure_free_calls == 6);
    secure_pa = 0x90000000;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    secure_domain_error = 1;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -ENODEV);
    CHECK(!buf.va && !buf.secure_alloc && secure_alloc_calls == 6);
    secure_domain_error = 0;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    secure_alloc_error = 1;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -ENOMEM);
    CHECK(!buf.va && !buf.secure_alloc && secure_alloc_calls == 7);
    secure_alloc_error = 0;

    memset(&buf, 0, sizeof(buf));
    buf.size = 65536;
    i->core->secure_nonpixel_dev = NULL;
    CHECK(intbuf_alloc_secure_persist(i, &buf) == -EOPNOTSUPP);
    CHECK(secure_alloc_calls == 7);

    memset(&buf, 0, sizeof(buf));
    buf.size = 4096;
    buf.dma_dev = (void *)(uintptr_t)1;
    CHECK(intbuf_free_memory(i, &buf) == 0);
    CHECK(normal_free_calls == 1);
}

static void property_replay_tests(struct venus_inst *i)
{
    i->core->res->vpu_version = VPU_VERSION_IRIS1;
    i->enc_state = VENUS_ENC_STATE_INIT;
    set_properties_calls = 0;
    set_properties_error = 0;

    CHECK(venc_set_properties_if_needed(i) == 0);
    CHECK(set_properties_calls == 1);
    CHECK(i->enc_state == VENUS_ENC_STATE_CONFIGURED);

    CHECK(venc_set_properties_if_needed(i) == 0);
    CHECK(set_properties_calls == 1);
    CHECK(i->enc_state == VENUS_ENC_STATE_CONFIGURED);

    venc_mark_config_dirty(i);
    CHECK(i->enc_state == VENUS_ENC_STATE_INIT);
    CHECK(venc_set_properties_if_needed(i) == 0);
    CHECK(set_properties_calls == 2);
    CHECK(i->enc_state == VENUS_ENC_STATE_CONFIGURED);

    venc_mark_config_dirty(i);
    set_properties_error = -EIO;
    CHECK(venc_set_properties_if_needed(i) == -EIO);
    CHECK(set_properties_calls == 3);
    CHECK(i->enc_state == VENUS_ENC_STATE_INIT);

    i->core->res->vpu_version = VPU_VERSION_AR50;
    i->enc_state = VENUS_ENC_STATE_CONFIGURED;
    set_properties_error = 0;
    venc_mark_config_dirty(i);
    CHECK(i->enc_state == VENUS_ENC_STATE_CONFIGURED);
    CHECK(venc_set_properties_if_needed(i) == 0);
    CHECK(venc_set_properties_if_needed(i) == 0);
    CHECK(set_properties_calls == 5);
    CHECK(i->enc_state == VENUS_ENC_STATE_CONFIGURED);
}

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

    /* Downstream BUFFER_SIZE_MINIMUM is Venus BUFFER_SIZE_ACTUAL on wire. */
    {
        struct hfi_buffer_size_actual size = {
            .type = HFI_BUFFER_OUTPUT,
            .size = 230400,
        };
        memset(packet, 0x5a, sizeof(packet));
        CHECK(pkt_session_set_property(p, cookie,
                                       HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL,
                                       &size) == 0);
        CHECK(packet[0] == 28 && packet[1] == HFI_CMD_SESSION_SET_PROPERTY);
        CHECK(packet[4] == 0x20100c);
        CHECK(packet[5] == HFI_BUFFER_OUTPUT && packet[6] == 230400);
        CHECK(packet[7] == 0x5a5a5a5a);
    }

    /* Generic zero level keeps the historical fallback to H.264 Level 1. */
    {
        struct hfi_profile_level pl = {
            .profile = HFI_H264_PROFILE_HIGH,
            .level = 0,
        };
        memset(packet, 0x5a, sizeof(packet));
        CHECK(pkt_session_set_property(p, cookie,
                                       HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT,
                                       &pl) == 0);
        CHECK(packet[0] == 28 && packet[1] == HFI_CMD_SESSION_SET_PROPERTY);
        CHECK(packet[4] == HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT);
        CHECK(packet[5] == HFI_H264_PROFILE_HIGH);
        CHECK(packet[6] == HFI_H264_LEVEL_1);
    }

    /* CF5 host-only marker is converted to firmware AUTO/UNKNOWN on wire. */
    {
        struct hfi_profile_level pl = {
            .profile = HFI_H264_PROFILE_HIGH,
            .level = ~0U,
        };
        memset(packet, 0x5a, sizeof(packet));
        CHECK(pkt_session_set_property(p, cookie,
                                       HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT,
                                       &pl) == 0);
        CHECK(packet[0] == 28 && packet[1] == HFI_CMD_SESSION_SET_PROPERTY);
        CHECK(packet[4] == HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT);
        CHECK(packet[5] == HFI_H264_PROFILE_HIGH);
        CHECK(packet[6] == 0);
    }

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
    q->count=0;
    unsigned int calls = bufreq_calls;
    CHECK(venc_set_queue_count_iris1(i, q->type) == -EINVAL);
    CHECK(bufreq_calls == calls);
    q->count=5;
    query_error=-EIO;
    CHECK(venc_set_queue_count_iris1(i, q->type) == 0);
    CHECK((input ? i->num_input_bufs : i->num_output_bufs) == 5);
    CHECK(bufreq_calls == calls);
    query_error=0;
    CHECK(pm_refs == 0 && !i->lock);
}

static void reset_start_snapshot(struct venus_inst *i)
{
    static struct vb2_buffer raw = { .size = 475136 };
    static struct vb2_buffer compressed = { .size = 230400 };

    raw.size = 475136;
    compressed.size = 230400;
    memset(&fw_snapshot, 0, sizeof(fw_snapshot));
    fw_snapshot.bufreq[0] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_INPUT, .size = 460800,
        .hold_count = 3, .count_min = 3, .count_actual = 4,
    };
    fw_snapshot.bufreq[1] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_OUTPUT, .size = 230400,
        .hold_count = 2, .count_min = 2, .count_actual = 4,
    };
    fw_snapshot.bufreq[2] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_INTERNAL_PERSIST, .size = 64768,
        .hold_count = 1, .count_min = 1, .count_actual = 1,
    };
    fw_snapshot.bufreq[3] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_INTERNAL_SCRATCH(HFI_VERSION_4XX), .size = 1307392,
        .hold_count = 1, .count_min = 1, .count_actual = 1,
    };
    fw_snapshot.bufreq[4] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_INTERNAL_SCRATCH_1(HFI_VERSION_4XX), .size = 694624,
        .hold_count = 1, .count_min = 1, .count_actual = 1,
    };
    fw_snapshot.bufreq[5] = (struct hfi_buffer_requirements) {
        .type = HFI_BUFFER_INTERNAL_SCRATCH_2(HFI_VERSION_4XX), .size = 2523136,
        .hold_count = 1, .count_min = 1, .count_actual = 1,
    };
    fw_snapshot.bufreq[6] = (struct hfi_buffer_requirements) {
        .type = TEST_HFI_BUFFER_INTERNAL_RECON, .size = 479232,
        .hold_count = 1, .count_min = 1, .count_actual = 2,
    };

    i->m2m_ctx->input.count = i->m2m_ctx->output.count = 4;
    i->m2m_ctx->input.max_num_buffers = i->m2m_ctx->output.max_num_buffers = 16;
    memset(i->m2m_ctx->input.bufs, 0, sizeof(i->m2m_ctx->input.bufs));
    memset(i->m2m_ctx->output.bufs, 0, sizeof(i->m2m_ctx->output.bufs));
    for (unsigned int n = 0; n < 4; n++) {
        i->m2m_ctx->input.bufs[n] = &raw;
        i->m2m_ctx->output.bufs[n] = &compressed;
    }
    i->output_buf_size = 230400;
    snapshot_queries = size_calls = intbuf_calls = unset_calls = 0;
    intbuf_types_seen = start_step = 0;
    snapshot_error = size_error = intbuf_error = 0;
}

static void start_contract_tests(struct venus_inst *i)
{
    /* Real SM8150 requirements include encoder PERSIST. Until the secure
     * CP_NON_PIXEL path exists, reject before size or buffer registration.
     */
    reset_start_snapshot(i);
    dev_errors = 0;
    CHECK(intbufs_alloc_iris1_encoder(i) == -EOPNOTSUPP);
    CHECK(snapshot_queries == 1 && !size_calls && !intbuf_calls);
    CHECK(unset_calls == 0 && start_step == 1);
    CHECK(dev_errors == 1);

    reset_start_snapshot(i);
    i->core->secure_nonpixel_dev = (void *)(uintptr_t)1;
    CHECK(intbufs_alloc_iris1_encoder(i) == 0);
    CHECK(snapshot_queries == 1 && size_calls == 1 && intbuf_calls == 4);
    CHECK(unset_calls == 0 && start_step == 3);
    CHECK(intbuf_types_seen & BIT(HFI_BUFFER_INTERNAL_PERSIST));
    i->core->secure_nonpixel_dev = NULL;

    /* Keep testing the remaining CF6 machinery with an artificial snapshot
     * in which firmware declares no PERSIST requirement.
     */
    reset_start_snapshot(i);
    fw_snapshot.bufreq[2] = (struct hfi_buffer_requirements) {};
    CHECK(intbufs_alloc_iris1_encoder(i) == 0);
    CHECK(snapshot_queries == 1 && size_calls == 1 && intbuf_calls == 3);
    CHECK(unset_calls == 0 && start_step == 3);
    CHECK(intbuf_types_seen == (
        BIT(HFI_BUFFER_INTERNAL_SCRATCH(HFI_VERSION_4XX)) |
        BIT(HFI_BUFFER_INTERNAL_SCRATCH_1(HFI_VERSION_4XX)) |
        BIT(HFI_BUFFER_INTERNAL_SCRATCH_2(HFI_VERSION_4XX))));
    CHECK(!(intbuf_types_seen & BIT(TEST_HFI_BUFFER_INTERNAL_RECON)));

    reset_start_snapshot(i);
    snapshot_error = -EIO;
    CHECK(intbufs_alloc_iris1_encoder(i) == -EIO);
    CHECK(snapshot_queries == 1 && !size_calls && !intbuf_calls);

    reset_start_snapshot(i);
    i->m2m_ctx->output.bufs[3]->size = 230399;
    CHECK(intbufs_alloc_iris1_encoder(i) == -EINVAL);
    CHECK(snapshot_queries == 1 && !size_calls && !intbuf_calls);

    reset_start_snapshot(i);
    fw_snapshot.bufreq[6].type = HFI_BUFFER_INPUT;
    CHECK(intbufs_alloc_iris1_encoder(i) == -EINVAL);
    CHECK(snapshot_queries == 1 && !size_calls && !intbuf_calls);

    reset_start_snapshot(i);
    fw_snapshot.bufreq[2] = (struct hfi_buffer_requirements) {};
    size_error = -EIO;
    CHECK(intbufs_alloc_iris1_encoder(i) == -EIO);
    CHECK(snapshot_queries == 1 && size_calls == 1 && !intbuf_calls);

    reset_start_snapshot(i);
    fw_snapshot.bufreq[2] = (struct hfi_buffer_requirements) {};
    intbuf_error = -ENOMEM;
    CHECK(intbufs_alloc_iris1_encoder(i) == -ENOMEM);
    CHECK(snapshot_queries == 1 && size_calls == 1 && intbuf_calls == 1);
    CHECK(unset_calls == 1);
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
    property_replay_tests(&inst); secure_persist_tests(&inst);
    queue_tests(&inst, &queues.input); queue_tests(&inst, &queues.output);
    start_contract_tests(&inst);
    power_policy_tests(&core);
    printf("PASS: %u assertions against real HFI packetizer and codec functions (host mocks, no hardware)\n", assertions);
    return 0;
}
