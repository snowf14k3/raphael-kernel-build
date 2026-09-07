/* SPDX-License-Identifier: GPL-2.0-only */
/* VPU5 work-route tests using the actual patched helper. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef uint32_t u32;
#define EINVAL 22
#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define min_t(t, a, b) ((t)(a) < (t)(b) ? (t)(a) : (t)(b))
#define IS_IRIS1(c) ((c)->iris1)
#define VIDC_SESSION_TYPE_DEC 1
#define VIDC_SESSION_TYPE_ENC 2
#define HFI_VIDEO_CODEC_MPEG2 10
#define HFI_VIDEO_CODEC_H264 11
#define HFI_VIDEO_CODEC_VP8 12
#define HFI_INTERLACE_FRAME_PROGRESSIVE 1
#define V4L2_MPEG_VIDEO_BITRATE_MODE_VBR 0
#define V4L2_MPEG_VIDEO_BITRATE_MODE_CBR 1
#define V4L2_MPEG_VIDEO_BITRATE_MODE_CQ 2
#define V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES 3
#define HFI_PROPERTY_PARAM_WORK_ROUTE 0x1017
#define CBR_MBS_720P_30 (((1280 + 15) / 16) * ((720 + 15) / 16) * 30)

struct device { int unused; };
struct venus_resources { u32 num_vpp_pipes; };
struct venus_core {
	bool iris1;
	struct device *dev;
	const struct venus_resources *res;
};
struct venc_controls {
	u32 bitrate_mode;
	u32 multi_slice_mode;
};
struct hfi_video_work_route { u32 video_work_route; };
struct venus_inst {
	struct venus_core *core;
	u32 session_type, hfi_codec, pic_struct;
	u32 out_width, out_height, fps;
	struct { struct venc_controls enc; } controls;
	struct { u32 work_route; } clk_data;
};

static int property_calls, property_error;
static u32 property_type, property_route;
static int hfi_session_set_property(struct venus_inst *inst, u32 type,
				    struct hfi_video_work_route *wr)
{
	(void)inst;
	property_calls++;
	property_type = type;
	property_route = wr->video_work_route;
	return property_error;
}
#define dev_info(...) ((void)0)

/* ACTUAL_DRIVER_FUNCTIONS */

static void reset_capture(void)
{
	property_calls = property_error = 0;
	property_type = property_route = 0;
}

int main(void)
{
	static struct device dev;
	static struct venus_resources resources = { .num_vpp_pipes = 2 };
	struct venus_core core = { .iris1 = true, .dev = &dev, .res = &resources };
	struct venus_inst inst = {
		.core = &core, .session_type = VIDC_SESSION_TYPE_ENC,
		.hfi_codec = HFI_VIDEO_CODEC_H264, .out_width = 320,
		.out_height = 240, .fps = 30,
		.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
	};

	reset_capture();
	assert(!venus_helper_set_work_route(&inst));
	assert(property_calls == 1 && property_type == HFI_PROPERTY_PARAM_WORK_ROUTE);
	assert(property_route == 2 && inst.clk_data.work_route == 2);

	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);
	inst.out_width = 1920;
	inst.out_height = 1080;
	assert(!venus_helper_set_work_route(&inst) && property_route == 2);

	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CQ;
	inst.controls.enc.multi_slice_mode =
		V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES;
	assert(!venus_helper_set_work_route(&inst) && property_route == 2);
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);
	inst.hfi_codec = HFI_VIDEO_CODEC_VP8;
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CQ;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);

	inst.session_type = VIDC_SESSION_TYPE_DEC;
	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	inst.pic_struct = HFI_INTERLACE_FRAME_PROGRESSIVE;
	assert(!venus_helper_set_work_route(&inst) && property_route == 2);
	inst.pic_struct = 2;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);
	inst.hfi_codec = HFI_VIDEO_CODEC_MPEG2;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);

	resources.num_vpp_pipes = 1;
	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	inst.pic_struct = HFI_INTERLACE_FRAME_PROGRESSIVE;
	assert(!venus_helper_set_work_route(&inst) && property_route == 1);
	resources.num_vpp_pipes = 0;
	reset_capture();
	assert(venus_helper_set_work_route(&inst) == -EINVAL && !property_calls);

	resources.num_vpp_pipes = 2;
	inst.clk_data.work_route = 99;
	property_error = -5;
	assert(venus_helper_set_work_route(&inst) == -5);
	assert(inst.clk_data.work_route == 99);

	core.iris1 = false;
	reset_capture();
	assert(!venus_helper_set_work_route(&inst) && !property_calls);
	puts("PASS: IRIS1 VPU5 work-route policy, pipe clamping and error handling");
	return 0;
}
