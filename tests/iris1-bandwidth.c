#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef uint32_t u32;
typedef uint64_t u64;

#define VIDEO_MAX_FRAME 32
#define VIDC_IRIS1_LLCC_NUM 2
#define VIDC_SESSION_TYPE_ENC 1
#define VIDC_SESSION_TYPE_DEC 2
#define HFI_VIDEO_CODEC_H264 0x00000002
#define HFI_VIDEO_CODEC_HEVC 0x00002000
#define HFI_VIDEO_CODEC_VP9 0x00004000
#define HFI_COLOR_FORMAT_NV12 0x00000002
#define HFI_COLOR_FORMAT_10_BIT_BASE 0x00004000
#define HFI_COLOR_FORMAT_P010 0x00004003
#define HFI_COLOR_FORMAT_NV12_UBWC 0x00008002
#define HFI_COLOR_FORMAT_YUV420_TP10_UBWC 0x0000c002
#define V4L2_PIX_FMT_NV12 1
#define V4L2_PIX_FMT_P010 2
#define V4L2_PIX_FMT_QC08C 3
#define V4L2_PIX_FMT_QC10C 4

#define BIT(n) (1U << (n))
#define BIT_ULL(n) (1ULL << (n))
#define GENMASK(h, l) ((u32)(((~0U) << (l)) & (~0U >> (31 - (h)))))
#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
#define DIV_ROUND_UP_ULL(n, d) (((u64)(n) + (d) - 1) / (d))
#define READ_ONCE(x) (x)
#define smp_load_acquire(p) (*(p))
#define min(x, y) ((x) < (y) ? (x) : (y))
#define max(x, y) ((x) > (y) ? (x) : (y))
#define min_t(t, x, y) ((t)(x) < (t)(y) ? (t)(x) : (t)(y))
#define max_t(t, x, y) ((t)(x) > (t)(y) ? (t)(x) : (t)(y))
#define clamp(v, lo, hi) min(max((v), (lo)), (hi))

static inline u64 div_u64(u64 numerator, u64 denominator)
{
	return numerator / denominator;
}

static inline u64 div64_u64(u64 numerator, u64 denominator)
{
	return numerator / denominator;
}

struct venus_format {
	u32 pixfmt;
};

struct venus_core {
	u32 iris1_llcc_mask;
};

struct venus_inst {
	struct venus_core *core;
	const struct venus_format *fmt_out;
	u32 session_type;
	u32 hfi_codec;
	u32 width;
	u32 height;
	u32 out_width;
	u32 out_height;
	u32 dpb_fmt;
	u32 opb_fmt;
	u64 fps;
	unsigned int num_input_bufs;
	unsigned long payloads[VIDEO_MAX_FRAME];
	u32 iris1_recon_cr_q16[VIDEO_MAX_FRAME];
	u32 iris1_recon_cf_q16[VIDEO_MAX_FRAME];
	u32 iris1_recon_valid_mask;
	union {
		struct {
			u32 bitrate;
			u32 num_b_frames;
		} enc;
	} controls;
};

static u32 load_per_instance(struct venus_inst *inst)
{
	return DIV_ROUND_UP(inst->width, 16) *
	       DIV_ROUND_UP(inst->height, 16) * (u32)inst->fps;
}

/* ACTUAL_DRIVER_FUNCTIONS */

static void set_stat(struct venus_inst *inst, unsigned int index,
		     u32 integer_cr, u32 hundredths_cr,
		     u32 integer_cf, u32 hundredths_cf)
{
	inst->iris1_recon_cr_q16[index] =
		(integer_cr << 16) + (((hundredths_cr << 16) + 99) / 100);
	inst->iris1_recon_cf_q16[index] =
		(integer_cf << 16) + (((hundredths_cf << 16) + 99) / 100);
	inst->iris1_recon_valid_mask |= BIT(index);
}

static void expect_vote(const char *name, struct iris1_bw_vote actual,
			u32 ddr, u32 llcc)
{
	if (actual.ddr_kbps != ddr || actual.llcc_kbps != llcc) {
		fprintf(stderr, "%s: got %u/%u, expected %u/%u\n", name,
			actual.ddr_kbps, actual.llcc_kbps, ddr, llcc);
		exit(1);
	}
}

static struct venus_inst decoder(struct venus_core *core, u32 codec,
				 u32 iw, u32 ih, u32 ow, u32 oh, u32 fps,
				 u32 dpb_fmt, u32 opb_fmt)
{
	struct venus_inst inst = { 0 };

	inst.core = core;
	inst.session_type = VIDC_SESSION_TYPE_DEC;
	inst.hfi_codec = codec;
	inst.out_width = iw;
	inst.out_height = ih;
	inst.width = ow;
	inst.height = oh;
	inst.fps = fps;
	inst.dpb_fmt = dpb_fmt;
	inst.opb_fmt = opb_fmt;
	return inst;
}

static struct venus_inst encoder(struct venus_core *core,
				 const struct venus_format *fmt, u32 codec,
				 u32 iw, u32 ih, u32 ow, u32 oh, u32 fps,
				 u32 bitrate, u32 bframes)
{
	struct venus_inst inst = { 0 };

	inst.core = core;
	inst.fmt_out = fmt;
	inst.session_type = VIDC_SESSION_TYPE_ENC;
	inst.hfi_codec = codec;
	inst.out_width = iw;
	inst.out_height = ih;
	inst.width = ow;
	inst.height = oh;
	inst.fps = fps;
	inst.controls.enc.bitrate = bitrate;
	inst.controls.enc.num_b_frames = bframes;
	return inst;
}

int main(void)
{
	const struct venus_format nv12 = { V4L2_PIX_FMT_NV12 };
	const struct venus_format p010 = { V4L2_PIX_FMT_P010 };
	const struct venus_format qc08c = { V4L2_PIX_FMT_QC08C };
	struct venus_core no_cache = { 0 };
	struct venus_core cache = { GENMASK(VIDC_IRIS1_LLCC_NUM - 1, 0) };
	struct venus_inst inst;
	struct iris1_bw_vote vote;
	u32 cr, cf;

	/* No samples has the downstream fill_dynamic_stats() fallback 5.0/1.0. */
	inst = decoder(&no_cache, HFI_VIDEO_CODEC_H264,
		       128, 96, 128, 96, 1, 0, HFI_COLOR_FORMAT_NV12);
	inst.num_input_bufs = 1;
	inst.payloads[0] = 18432;
	iris1_dynamic_stats(&inst, &cr, &cf);
	if (cr != 5U << 16 || cf != 1U << 16)
		return 2;
	if (iris1_input_payload(&inst) != 18432)
		return 4;
	iris1_calculate_bw(&inst, 18432, &vote);
	expect_vote("h264-dec-baseline", vote, 2000, 2000);

	/* Aggregation is minimum non-zero CR and maximum non-zero CF per recon. */
	set_stat(&inst, 0, 1, 80, 2, 0);
	set_stat(&inst, 1, 1, 50, 2, 50);
	iris1_dynamic_stats(&inst, &cr, &cf);
	if (cr != (1U << 16) + ((50U << 16) / 100) ||
	    cf != (2U << 16) + ((50U << 16) / 100))
		return 3;

	inst = decoder(&cache, HFI_VIDEO_CODEC_H264, 1920, 1080,
		       1920, 1080, 30, HFI_COLOR_FORMAT_NV12_UBWC,
		       HFI_COLOR_FORMAT_NV12);
	set_stat(&inst, 0, 1, 50, 2, 0);
	iris1_calculate_decoder_bw(&inst, 200000, &vote);
	expect_vote("h264-dec-1080p-cache", vote, 343000, 421000);

	inst = decoder(&cache, HFI_VIDEO_CODEC_HEVC, 1920, 1080,
		       1920, 1080, 30, HFI_COLOR_FORMAT_YUV420_TP10_UBWC,
		       HFI_COLOR_FORMAT_P010);
	set_stat(&inst, 0, 1, 30, 1, 50);
	iris1_calculate_decoder_bw(&inst, 150000, &vote);
	expect_vote("hevc10-dec-1080p-cache", vote, 468000, 501000);

	inst = decoder(&cache, HFI_VIDEO_CODEC_VP9, 3840, 2160,
		       1920, 1080, 60, HFI_COLOR_FORMAT_YUV420_TP10_UBWC,
		       HFI_COLOR_FORMAT_P010);
	set_stat(&inst, 0, 1, 22, 3, 0);
	iris1_calculate_decoder_bw(&inst, 500000, &vote);
	expect_vote("vp9p2-dec-4k60-scale", vote, 3643000, 4208000);

	inst = encoder(&no_cache, &nv12, HFI_VIDEO_CODEC_H264,
		       128, 96, 128, 96, 1, 128000, 0);
	iris1_calculate_encoder_bw(&inst, &vote);
	expect_vote("h264-enc-baseline", vote, 5000, 5000);

	inst = encoder(&cache, &nv12, HFI_VIDEO_CODEC_H264,
		       1920, 1080, 1920, 1080, 30, 20000000, 0);
	set_stat(&inst, 0, 1, 50, 1, 0);
	iris1_calculate_encoder_bw(&inst, &vote);
	expect_vote("h264-enc-1080p-cache", vote, 409000, 422000);

	inst = encoder(&cache, &p010, HFI_VIDEO_CODEC_HEVC,
		       3840, 2160, 3840, 2160, 60, 84000000, 1);
	set_stat(&inst, 0, 1, 22, 1, 0);
	iris1_calculate_encoder_bw(&inst, &vote);
	expect_vote("hevc10-enc-4k60", vote, 5825000, 6021000);

	inst = encoder(&cache, &qc08c, HFI_VIDEO_CODEC_H264,
		       3840, 2160, 1920, 1080, 30, 20000000, 0);
	set_stat(&inst, 0, 1, 26, 1, 0);
	iris1_calculate_encoder_bw(&inst, &vote);
	expect_vote("h264-enc-ubwc-downscale", vote, 608000, 622000);

	puts("PASS: SM8150 generic DDR/LLCC governor matches vendor Q16 vectors");
	return 0;
}
