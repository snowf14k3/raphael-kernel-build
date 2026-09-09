/* SPDX-License-Identifier: GPL-2.0-only */
/* Compile the actual encoder ETB packetizer against an exact VPU5 vector. */
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef uint32_t u32;
typedef uint64_t u64;

#define EINVAL 22
#define HFI_CMD_SESSION_EMPTY_BUFFER 0x211004U
#define upper_32_bits(n) ((u32)((n) >> 32))
#define lower_32_bits(n) ((u32)(n))

struct hfi_pkt_hdr {
	u32 size;
	u32 pkt_type;
};

struct hfi_session_hdr_pkt {
	struct hfi_pkt_hdr hdr;
	u32 session_id;
};

struct hfi_frame_data {
	u32 buffer_type;
	u32 device_addr;
	u32 extradata_addr;
	u64 timestamp;
	u32 flags;
	u32 offset;
	u32 alloc_len;
	u32 filled_len;
	u32 mark_target;
	u32 mark_data;
	u32 clnt_data;
	u32 extradata_size;
};

struct hfi_session_empty_buffer_uncompressed_plane0_pkt {
	struct hfi_session_hdr_pkt shdr;
	u32 view_id;
	u32 time_stamp_hi;
	u32 time_stamp_lo;
	u32 flags;
	u32 mark_target;
	u32 mark_data;
	u32 alloc_len;
	u32 filled_len;
	u32 offset;
	u32 input_tag;
	u32 packet_buffer;
	u32 extradata_buffer;
	u32 data;
};

static u32 hash32_ptr(const void *cookie)
{
	(void)cookie;
	return 0x10203040U;
}

/* ACTUAL_DRIVER_FUNCTION */

int main(void)
{
	struct hfi_session_empty_buffer_uncompressed_plane0_pkt pkt;
	struct hfi_frame_data frame = {
		.device_addr = 0xdfbf0000U,
		.extradata_addr = 0,
		.timestamp = 0x0123456789abcdefULL,
		.flags = 0x55aa55aaU,
		.offset = 0,
		.alloc_len = 24576,
		.filled_len = 18432,
		.mark_target = 0x11111111U,
		.mark_data = 0x22222222U,
		.clnt_data = 7,
	};
	const u32 expected[] = {
		64, 0x211004U, 0x10203040U, 0,
		0x01234567U, 0x89abcdefU, 0x55aa55aaU,
		0x11111111U, 0x22222222U, 24576, 18432, 0, 7,
		0xdfbf0000U, 0, 0,
	};

	memset(&pkt, 0xa5, sizeof(pkt));
	assert(pkt_session_etb_encoder(&pkt, &frame, &frame) == 0);
	assert(sizeof(pkt) == 64);
	assert(memcmp(&pkt, expected, sizeof(expected)) == 0);
	frame.device_addr = 0;
	assert(pkt_session_etb_encoder(&pkt, &frame, &frame) == -EINVAL);

	puts("PASS: SM8150 encoder ETB is the exact 64-byte VPU5 packet");
	return 0;
}
