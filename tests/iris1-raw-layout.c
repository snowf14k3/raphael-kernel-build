/* SPDX-License-Identifier: GPL-2.0-only */
/* SM8150 encoder raw-layout vectors using the actual patched functions. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef uint32_t u32;

#define ALIGN(x, a) (((x) + (a) - 1) & ~((a) - 1))
#define roundup(x, y) ((((x) + (y) - 1) / (y)) * (y))
#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
#define SZ_4K 4096U

#define V4L2_PIX_FMT_NV12  0x3231564eU
#define V4L2_PIX_FMT_NV21  0x3132564eU
#define V4L2_PIX_FMT_QC08C 0x38433051U
#define V4L2_PIX_FMT_QC10C 0x30433151U
#define V4L2_PIX_FMT_P010  0x30313050U

struct venus_core {
	bool iris1;
};

struct venus_inst {
	struct venus_core *core;
};

#define IS_IRIS1(core) ((core)->iris1)

static u32 venus_helper_get_framesz(u32 pixfmt, u32 width, u32 height)
{
	(void)pixfmt;
	(void)width;
	(void)height;
	return 0xdeadbeefU;
}

/* ACTUAL_DRIVER_FUNCTIONS */

struct vector {
	u32 width;
	u32 height;
	u32 nv12;
	u32 p010;
	u32 qc08c;
	u32 qc10c;
};

static void expect(const char *name, u32 width, u32 height,
		   u32 actual, u32 expected)
{
	if (actual == expected)
		return;

	fprintf(stderr, "%s %ux%u: got %u, expected %u\n",
		name, width, height, actual, expected);
	exit(1);
}

int main(void)
{
	static const struct vector vectors[] = {
		{ 96, 96, 24576, 40960, 40960, 45056 },
		{ 128, 96, 24576, 40960, 40960, 45056 },
		{ 320, 240, 151552, 299008, 163840, 196608 },
		{ 1919, 1079, 3137536, 6270976, 3219456, 4210688 },
		{ 1920, 1080, 3137536, 6270976, 3219456, 4210688 },
		{ 4096, 4096, 25169920, 50335744, 25264128, 34799616 },
	};
	struct venus_core core = { .iris1 = true };
	struct venus_inst inst = { .core = &core };
	unsigned int i;

	for (i = 0; i < sizeof(vectors) / sizeof(vectors[0]); i++) {
		const struct vector *v = &vectors[i];

		expect("NV12", v->width, v->height,
		       venc_get_framesz(&inst, V4L2_PIX_FMT_NV12,
					v->width, v->height), v->nv12);
		expect("NV21", v->width, v->height,
		       venc_get_framesz(&inst, V4L2_PIX_FMT_NV21,
					v->width, v->height), v->nv12);
		expect("P010", v->width, v->height,
		       venc_get_framesz(&inst, V4L2_PIX_FMT_P010,
					v->width, v->height), v->p010);
		expect("QC08C", v->width, v->height,
		       venc_get_framesz(&inst, V4L2_PIX_FMT_QC08C,
					v->width, v->height), v->qc08c);
		expect("QC10C", v->width, v->height,
		       venc_get_framesz(&inst, V4L2_PIX_FMT_QC10C,
					v->width, v->height), v->qc10c);
	}

	assert(venc_get_stride(V4L2_PIX_FMT_NV12, 1919) == 1920);
	assert(venc_get_stride(V4L2_PIX_FMT_NV21, 1919) == 1920);
	assert(venc_get_stride(V4L2_PIX_FMT_QC08C, 1919) == 1920);
	assert(venc_get_stride(V4L2_PIX_FMT_P010, 1919) == 3840);
	assert(venc_get_stride(V4L2_PIX_FMT_QC10C, 1919) == 2560);

	core.iris1 = false;
	assert(venc_get_framesz(&inst, V4L2_PIX_FMT_NV12, 96, 96) ==
	       0xdeadbeefU);

	puts("PASS: SM8150 encoder raw layouts match downstream vectors");
	return 0;
}
