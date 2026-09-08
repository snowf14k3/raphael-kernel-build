/* SPDX-License-Identifier: GPL-2.0-only */
/* Codec/capture-format negotiation tests using the actual patched helpers. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

typedef uint32_t u32;

#define EXPORT_SYMBOL_GPL(symbol)
#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define SZ_4K 4096U
#define VIDC_SESSION_TYPE_DEC 1
#define VIDC_SESSION_TYPE_ENC 2

#define V4L2_PIX_FMT_H264 0x34363248
#define V4L2_PIX_FMT_H264_NO_SC 0x31435641
#define V4L2_PIX_FMT_H263 0x33363248
#define V4L2_PIX_FMT_MPEG1 0x3147504d
#define V4L2_PIX_FMT_MPEG2 0x3247504d
#define V4L2_PIX_FMT_MPEG4 0x34504d46
#define V4L2_PIX_FMT_VC1_ANNEX_G 0x47314356
#define V4L2_PIX_FMT_VC1_ANNEX_L 0x4c314356
#define V4L2_PIX_FMT_VP8 0x30385056
#define V4L2_PIX_FMT_VP9 0x30395056
#define V4L2_PIX_FMT_XVID 0x44495658
#define V4L2_PIX_FMT_HEVC 0x43564548
#define V4L2_PIX_FMT_NV12 0x3231564e
#define V4L2_PIX_FMT_NV21 0x3132564e
#define V4L2_PIX_FMT_QC08C 0x38433051
#define V4L2_PIX_FMT_QC10C 0x30433151
#define V4L2_PIX_FMT_P010 0x30313050

#define HFI_VIDEO_CODEC_H264 (1U << 0)
#define HFI_VIDEO_CODEC_H263 (1U << 1)
#define HFI_VIDEO_CODEC_MPEG1 (1U << 2)
#define HFI_VIDEO_CODEC_MPEG2 (1U << 3)
#define HFI_VIDEO_CODEC_MPEG4 (1U << 4)
#define HFI_VIDEO_CODEC_VC1 (1U << 5)
#define HFI_VIDEO_CODEC_VP8 (1U << 6)
#define HFI_VIDEO_CODEC_VP9 (1U << 7)
#define HFI_VIDEO_CODEC_DIVX (1U << 8)
#define HFI_VIDEO_CODEC_HEVC (1U << 9)

#define HFI_BUFFER_OUTPUT 1
#define HFI_BUFFER_OUTPUT2 2
#define HFI_COLOR_FORMAT_NV12 0x1
#define HFI_COLOR_FORMAT_NV21 0x2
#define HFI_COLOR_FORMAT_NV12_UBWC 0x80000001
#define HFI_COLOR_FORMAT_YUV420_TP10_UBWC 0xC0000002
#define HFI_COLOR_FORMAT_P010 0x3

struct hfi_plat_caps_fmt {
	u32 buftype;
	u32 fmt;
};

struct hfi_plat_caps {
	u32 codec;
	u32 domain;
	struct hfi_plat_caps_fmt fmts[8];
	u32 num_fmts;
};

struct venus_core {
	u32 enc_codecs;
	u32 dec_codecs;
	struct hfi_plat_caps caps[2];
};

struct venus_inst {
	struct venus_core *core;
	u32 session_type;
	u32 hfi_codec;
};

static struct hfi_plat_caps *venus_caps_by_codec(struct venus_core *core,
						  u32 codec, u32 domain)
{
	for (unsigned int i = 0; i < 2; i++)
		if (core->caps[i].codec == codec && core->caps[i].domain == domain)
			return &core->caps[i];
	return NULL;
}

/* ACTUAL_DRIVER_FUNCTIONS */

int main(void)
{
	struct venus_core core = {
		.dec_codecs = HFI_VIDEO_CODEC_H264 | HFI_VIDEO_CODEC_HEVC,
		.caps = {
			{
				.codec = HFI_VIDEO_CODEC_H264,
				.domain = VIDC_SESSION_TYPE_DEC,
				.fmts = {{HFI_BUFFER_OUTPUT2, HFI_COLOR_FORMAT_NV12}},
				.num_fmts = 1,
			}, {
				.codec = HFI_VIDEO_CODEC_HEVC,
				.domain = VIDC_SESSION_TYPE_DEC,
				.fmts = {
					{HFI_BUFFER_OUTPUT2, HFI_COLOR_FORMAT_NV12},
					{HFI_BUFFER_OUTPUT2, HFI_COLOR_FORMAT_P010},
				},
				.num_fmts = 2,
			},
		},
	};
	struct venus_inst inst = {
		.core = &core,
		.session_type = VIDC_SESSION_TYPE_DEC,
		.hfi_codec = HFI_VIDEO_CODEC_H264,
	};

	assert(venus_helper_get_codec(V4L2_PIX_FMT_HEVC) == HFI_VIDEO_CODEC_HEVC);
	assert(venus_helper_get_codec(V4L2_PIX_FMT_H264_NO_SC) == HFI_VIDEO_CODEC_H264);
	assert(!venus_helper_get_codec(0xdeadbeef));
	assert(venus_helper_check_codec(&inst, V4L2_PIX_FMT_HEVC));
	assert(!venus_helper_check_codec(&inst, V4L2_PIX_FMT_VP9));

	assert(venus_helper_check_format(&inst, V4L2_PIX_FMT_NV12));
	assert(!venus_helper_check_format(&inst, V4L2_PIX_FMT_P010));
	inst.hfi_codec = venus_helper_get_codec(V4L2_PIX_FMT_HEVC);
	assert(venus_helper_check_format(&inst, V4L2_PIX_FMT_P010));
	assert(vdec_fmt_is_8bit(V4L2_PIX_FMT_NV12));
	assert(vdec_fmt_is_8bit(V4L2_PIX_FMT_QC08C));
	assert(!vdec_fmt_is_8bit(V4L2_PIX_FMT_P010));
	assert(vdec_fmt_is_10bit(V4L2_PIX_FMT_P010));
	assert(vdec_fmt_is_10bit(V4L2_PIX_FMT_QC10C));
	assert(!vdec_fmt_is_10bit(V4L2_PIX_FMT_NV12));
	assert(get_framesize_raw_p010(320, 240) == 294912);
	assert(get_framesize_raw_p010(1920, 1080) == 6266880);

	puts("PASS: HEVC exposes P010 with depth helpers and 256-byte stride");
	return 0;
}
