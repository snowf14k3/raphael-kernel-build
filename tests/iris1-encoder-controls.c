/* SPDX-License-Identifier: GPL-2.0-only */
/* VPU5 encoder-control policy tests using the actual patched helpers. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef uint32_t u32;

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define max(a, b) ((a) > (b) ? (a) : (b))
#define IS_IRIS1(c) ((c)->iris1)
#define EINVAL 22

#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED 0
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_1x1 1
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11 2
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_10x11 3
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_16x11 4
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_40x33 5
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_24x11 6
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_20x11 7
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_32x11 8
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_80x33 9
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_18x11 10
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_15x11 11
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_64x33 12
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_160x99 13
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_4x3 14
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_3x2 15
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1 16
#define V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED 17

#define V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE 0
#define V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB 1
#define V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES 2

#define HFI_VIDEO_CODEC_H264 1
#define HFI_VIDEO_CODEC_HEVC 2
#define HFI_VIDEO_CODEC_VP8 4
#define HFI_RATE_CONTROL_OFF 0x1000001
#define HFI_RATE_CONTROL_VBR_CFR 0x1000003
#define HFI_RATE_CONTROL_CBR_VFR 0x1000004
#define HFI_RATE_CONTROL_CBR_CFR 0x1000005
#define HFI_MULTI_SLICE_OFF 1
#define HFI_MULTI_SLICE_BY_MB_COUNT 2
#define HFI_MULTI_SLICE_BY_BYTE_COUNT 3
#define HFI_PROPERTY_PARAM_VENC_ASPECT_RATIO 0x2005017
#define HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL 0x200500e
#define HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE 0x2005022
#define HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE 0x200600d
#define HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID 0x200600f
#define VENUS_IRIS1_CBR_MB_LIMIT \
	(((1280 + 15) / 16) * ((720 + 15) / 16) * 30)

struct venus_core { bool iris1; };
struct hfi_aspect_ratio { u32 aspect_width, aspect_height; };
struct hfi_multi_slice_control { u32 multi_slice, slice_size; };
struct hfi_vbv_hdr_buf_size { u32 vbv_hdr_buf_size; };
struct hfi_enable { u32 enable; };
struct venc_controls {
	bool h264_sar_enable;
	u32 h264_sar_idc, h264_sar_width, h264_sar_height;
	u32 bitrate, multi_slice_mode, multi_slice_max_bytes;
	u32 multi_slice_max_mb, base_priority_id;
};
struct venus_inst {
	struct venus_core *core;
	struct { struct venc_controls enc; } controls;
	u32 width, height, fps, hfi_codec;
};

struct property_capture { u32 type, first, second; };
static struct property_capture properties[8];
static unsigned int property_calls;
static int fail_call;

static int hfi_session_set_property(struct venus_inst *inst, u32 type,
				    void *data)
{
	u32 *words = data;

	(void)inst;
	properties[property_calls].type = type;
	properties[property_calls].first = words[0];
	if (type == HFI_PROPERTY_PARAM_VENC_ASPECT_RATIO ||
	    type == HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL)
		properties[property_calls].second = words[1];
	property_calls++;
	return fail_call == (int)property_calls ? -5 : 0;
}

/* ACTUAL_DRIVER_FUNCTIONS */

static void reset_capture(void)
{
	property_calls = 0;
	fail_call = 0;
	for (unsigned int i = 0; i < ARRAY_SIZE(properties); i++)
		properties[i] = (struct property_capture){};
}

int main(void)
{
	struct venus_core core = { .iris1 = true };
	struct venus_inst inst = {
		.core = &core,
		.width = 320,
		.height = 240,
		.fps = 30,
		.hfi_codec = HFI_VIDEO_CODEC_H264,
	};
	struct venc_controls *ctr = &inst.controls.enc;

	assert(venc_pack_qp(0x11, 0x22, 0x33) == 0x00332211);

	reset_capture();
	assert(!venc_iris1_h264_sar(&inst) && !property_calls);
	ctr->h264_sar_enable = true;
	ctr->h264_sar_idc = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11;
	assert(!venc_iris1_h264_sar(&inst));
	assert(property_calls == 1);
	assert(properties[0].type == HFI_PROPERTY_PARAM_VENC_ASPECT_RATIO);
	assert(properties[0].first == 12 && properties[0].second == 11);

	reset_capture();
	ctr->h264_sar_idc = V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED;
	ctr->h264_sar_width = 64;
	ctr->h264_sar_height = 45;
	assert(!venc_iris1_h264_sar(&inst));
	assert(properties[0].first == 64 && properties[0].second == 45);

	ctr->h264_sar_enable = false;
	ctr->base_priority_id = 3;
	inst.fps = 0;
	reset_capture();
	assert(venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_OFF) == -22);
	assert(!property_calls);
	inst.fps = 30;

	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_OFF));
	assert(property_calls == 1);
	assert(properties[0].type == HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID);
	assert(properties[0].first == 3);

	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_CBR_CFR));
	assert(property_calls == 3);
	assert(properties[0].type == HFI_PROPERTY_CONFIG_VENC_VBV_HRD_BUF_SIZE);
	assert(properties[0].first == 500);
	assert(properties[1].type == HFI_PROPERTY_PARAM_VENC_LOW_LATENCY_MODE);
	assert(properties[1].first == 1);

	inst.width = 3840;
	inst.height = 2160;
	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_CBR_CFR));
	assert(properties[0].first == 1000);

	inst.width = 1920;
	inst.height = 1080;
	ctr->multi_slice_mode = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB;
	ctr->multi_slice_max_mb = 1;
	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_OFF));
	assert(properties[0].type == HFI_PROPERTY_PARAM_VENC_MULTI_SLICE_CONTROL);
	assert(properties[0].first == HFI_MULTI_SLICE_BY_MB_COUNT);
	assert(properties[0].second == ((1920 / 16) * (1088 / 16)) / 10);

	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_VBR_CFR));
	assert(properties[0].first == HFI_MULTI_SLICE_OFF);

	inst.width = 320;
	inst.height = 240;
	ctr->bitrate = 1000000;
	ctr->multi_slice_mode = V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES;
	ctr->multi_slice_max_bytes = 512;
	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_OFF));
	assert(properties[0].first == HFI_MULTI_SLICE_BY_BYTE_COUNT);
	assert(properties[0].second == 512);

	inst.hfi_codec = HFI_VIDEO_CODEC_VP8;
	reset_capture();
	assert(!venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_CBR_CFR));
	assert(property_calls == 1);
	assert(properties[0].type == HFI_PROPERTY_CONFIG_VENC_BASELAYER_PRIORITYID);

	inst.hfi_codec = HFI_VIDEO_CODEC_H264;
	reset_capture();
	fail_call = 1;
	assert(venc_iris1_internal_config(&inst, HFI_RATE_CONTROL_CBR_CFR) == -5);
	assert(property_calls == 1);

	puts("PASS: IRIS1 SAR, QP packing, VBV/latency and multi-slice policy");
	return 0;
}
