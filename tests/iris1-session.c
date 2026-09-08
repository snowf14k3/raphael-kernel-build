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
#define IS_V4(c) ((c)->is_v4)
#define IS_V6(c) ((c)->is_v6)
#define VIDC_SESSION_TYPE_DEC 1
#define VIDC_SESSION_TYPE_ENC 2
#define VIDC_WORK_MODE_1 1
#define VIDC_WORK_MODE_2 2
#define HFI_VIDEO_CODEC_MPEG2 10
#define HFI_VIDEO_CODEC_H264 11
#define HFI_VIDEO_CODEC_VP8 12
#define HFI_INTERLACE_FRAME_PROGRESSIVE 1
#define V4L2_MPEG_VIDEO_BITRATE_MODE_VBR 0
#define V4L2_MPEG_VIDEO_BITRATE_MODE_CBR 1
#define V4L2_MPEG_VIDEO_BITRATE_MODE_CQ 2
#define V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES 3
#define HFI_PROPERTY_PARAM_WORK_ROUTE 0x1017
#define HFI_PROPERTY_PARAM_WORK_MODE 0x1015
#define HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE 0x2005022
#define NUM_MBS_720P (((1280 + 15) / 16) * ((720 + 15) / 16))
#define NUM_MBS_4K (((4096 + 15) / 16) * ((2304 + 15) / 16))
#define CBR_MBS_720P_30 (((1280 + 15) / 16) * ((720 + 15) / 16) * 30)

struct device { int unused; };
struct venus_resources { u32 num_vpp_pipes; };
struct venus_core {
	bool iris1, is_v4, is_v6;
	struct device *dev;
	const struct venus_resources *res;
};
struct venc_controls {
	u32 bitrate_mode;
	u32 multi_slice_mode;
	u32 rc_enable;
};
struct hfi_video_work_route { u32 video_work_route; };
struct hfi_video_work_mode { u32 video_work_mode; };
struct hfi_enable { u32 enable; };
struct venus_inst {
	struct venus_core *core;
	u32 session_type, hfi_codec, pic_struct;
	u32 width, height, out_width, out_height, fps;
	struct { struct venc_controls enc; } controls;
	struct { u32 work_route; } clk_data;
};

static int property_calls, property_error, fail_call;
static u32 property_type[32], property_value[32];
static int hfi_session_set_property(struct venus_inst *inst, u32 type,
				    void *data)
{
	(void)inst;
	property_type[property_calls] = type;
	property_value[property_calls] = *(u32 *)data;
	property_calls++;
	if (fail_call && property_calls == fail_call)
		return property_error;
	return 0;
}
#define dev_info(...) ((void)0)

/* ACTUAL_DRIVER_FUNCTIONS */

static void reset_capture(void)
{
	property_calls = property_error = fail_call = 0;
	for (unsigned int i = 0; i < 32; i++) {
		property_type[i] = 0;
		property_value[i] = 0;
	}
}

int main(void)
{
	static struct device dev;
	static struct venus_resources resources = { .num_vpp_pipes = 2 };
	struct venus_core core = {
		.iris1 = true, .is_v4 = true, .dev = &dev, .res = &resources,
	};
	struct venus_inst inst = {
		.core = &core, .session_type = VIDC_SESSION_TYPE_ENC,
		.hfi_codec = HFI_VIDEO_CODEC_H264, .out_width = 320,
		.out_height = 240, .fps = 30,
		.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,
	};

	reset_capture();
	assert(!venus_helper_set_work_route(&inst));
	assert(property_calls == 1 && property_type[0] == HFI_PROPERTY_PARAM_WORK_ROUTE);
	assert(property_value[0] == 2 && inst.clk_data.work_route == 2);

	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);
	inst.out_width = 1920;
	inst.out_height = 1080;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 2);

	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CQ;
	inst.controls.enc.multi_slice_mode =
		V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 2);
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);
	inst.hfi_codec = HFI_VIDEO_CODEC_VP8;
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CQ;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);

	inst.session_type = VIDC_SESSION_TYPE_DEC;
	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	inst.pic_struct = HFI_INTERLACE_FRAME_PROGRESSIVE;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 2);
	inst.pic_struct = 2;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);
	inst.hfi_codec = HFI_VIDEO_CODEC_MPEG2;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);

	resources.num_vpp_pipes = 1;
	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	inst.pic_struct = HFI_INTERLACE_FRAME_PROGRESSIVE;
	assert(!venus_helper_set_work_route(&inst) && property_value[property_calls - 1] == 1);
	resources.num_vpp_pipes = 0;
	reset_capture();
	assert(venus_helper_set_work_route(&inst) == -EINVAL && !property_calls);

	resources.num_vpp_pipes = 2;
	inst.clk_data.work_route = 99;
	property_error = -5;
	fail_call = 1;
	assert(venus_helper_set_work_route(&inst) == -5);
	assert(inst.clk_data.work_route == 99);

	core.iris1 = false;
	reset_capture();
	assert(!venus_helper_set_work_route(&inst) && !property_calls);

	/* Downstream SM8150 RC_OFF uses mode 1 plus low latency. */
	core.iris1 = true;
	inst.session_type = VIDC_SESSION_TYPE_ENC;
	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	inst.out_width = 320;
	inst.out_height = 240;
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR;
	inst.controls.enc.rc_enable = 0;
	reset_capture();
	assert(!venus_helper_set_work_mode(&inst));
	assert(property_calls == 2 && property_type[0] == HFI_PROPERTY_PARAM_WORK_MODE);
	assert(property_value[0] == VIDC_WORK_MODE_1);
	assert(property_type[1] == HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE);
	assert(property_value[1] == 1);

	/* VBR is the only supported public mode that selects mode 2. */
	inst.controls.enc.rc_enable = 1;
	reset_capture();
	assert(!venus_helper_set_work_mode(&inst));
	assert(property_calls == 1 && property_type[0] == HFI_PROPERTY_PARAM_WORK_MODE);
	assert(property_value[0] == VIDC_WORK_MODE_2);

	/* CBR returns to mode 1 and must carry the low-latency property. */
	inst.controls.enc.bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
	reset_capture();
	assert(!venus_helper_set_work_mode(&inst));
	assert(property_calls == 2);
	assert(property_type[0] == HFI_PROPERTY_PARAM_WORK_MODE);
	assert(property_value[0] == VIDC_WORK_MODE_1);
	assert(property_type[1] == HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE);
	assert(property_value[1] == 1);

	/* The low-latency follow-up is VPU5-specific and obeys first-error exit. */
	inst.hfi_codec = HFI_VIDEO_CODEC_VP8;
	core.iris1 = false;
	reset_capture();
	assert(!venus_helper_set_work_mode(&inst) && property_calls == 1);
	core.iris1 = true;
	reset_capture();
	property_error = -5;
	fail_call = 1;
	assert(venus_helper_set_work_mode(&inst) == -5 && property_calls == 1);
	reset_capture();
	property_error = -7;
	fail_call = 2;
	assert(venus_helper_set_work_mode(&inst) == -7 && property_calls == 2);

	puts("PASS: IRIS1 VPU5 work-route/work-mode policy and error handling");
	return 0;
}
