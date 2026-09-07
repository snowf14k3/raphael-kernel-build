/* SPDX-License-Identifier: GPL-2.0-only */
/* Actual HFI ring-copy functions, tested across every wrap position. */
#include <assert.h>
#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
typedef uint32_t u32;
#define READ_ONCE(x) (x)
#define rmb() ((void)0)
#define wmb() ((void)0)
#define mb() ((void)0)
#define IFACEQ_QUEUE_SIZE (1024 * 50 * 16)
#define IFACEQ_VAR_HUGE_PKT_SIZE (12 * 1024)
#define HFI_CTRL_TO_HOST_MSG_Q 1
struct hfi_pkt_hdr { u32 size, pkt_type; };
struct hfi_queue_header { u32 read_idx, write_idx, q_size, type, tx_req, rx_req; };
struct iface_queue {
	struct hfi_queue_header *qhdr;
	struct { void *kva; u32 size; } qmem;
};
struct venus_hfi_device { int unused; };
static unsigned int dumps;
static void venus_dump_packet(struct venus_hfi_device *dev, const void *pkt)
{
	(void)dev;
	(void)pkt;
	dumps++;
}

/* ACTUAL_DRIVER_FUNCTIONS */

int main(void)
{
	struct venus_hfi_device dev = {0};
	struct { u32 pre, ring[64], post; } memory;
	struct hfi_queue_header hdr;
	struct iface_queue queue = {
		.qhdr = &hdr, .qmem = { .kva = memory.ring, .size = sizeof(memory.ring) },
	};
	u32 packet[64], output[64], request;
	unsigned int cases = 0;
	for (u32 start = 0; start < 64; start++) {
		for (u32 words = 2; words < 64; words++) {
			memset(&memory, 0xa5, sizeof(memory));
			memset(output, 0, sizeof(output));
			hdr = (struct hfi_queue_header){
				.q_size = 64, .read_idx = start, .write_idx = start,
				.type = 1, .rx_req = 1,
			};
			packet[0] = words * 4;
			for (u32 j = 1; j < words; j++) packet[j] = 0xabc00000 + j;
			assert(!venus_write_queue(&dev, &queue, packet, &request));
			assert(request == 1 && hdr.write_idx == (start + words) % 64);
			assert(!venus_read_queue(&dev, &queue, output, &request));
			assert(!memcmp(packet, output, words * 4));
			assert(hdr.read_idx == hdr.write_idx && hdr.rx_req == 1);
			assert(memory.pre == 0xa5a5a5a5 && memory.post == 0xa5a5a5a5);
			assert(venus_read_queue(&dev, &queue, output, &request) == -ENODATA);
			cases++;
		}
	}
	hdr = (struct hfi_queue_header){ .q_size = 64, .read_idx = 0, .write_idx = 63 };
	packet[0] = 8;
	assert(venus_write_queue(&dev, &queue, packet, &request) == -ENOSPC);
	assert(hdr.tx_req && hdr.write_idx == 63);
	for (unsigned int n = 0; n < 7; n++) {
		hdr = (struct hfi_queue_header){ .q_size = 64 };
		packet[0] = 8;
		switch (n) {
		case 0: hdr.q_size = 0; break;
		case 1: hdr.q_size = 65; break;
		case 2: hdr.read_idx = 64; break;
		case 3: hdr.write_idx = 64; break;
		case 4: packet[0] = 4; break;
		case 5: packet[0] = 9; break;
		case 6: packet[0] = IFACEQ_VAR_HUGE_PKT_SIZE + 4; break;
		}
		u32 rd = hdr.read_idx, wr = hdr.write_idx;
		assert(venus_write_queue(&dev, &queue, packet, &request) < 0);
		assert(hdr.read_idx == rd && hdr.write_idx == wr);
		if (n < 4) assert(venus_read_queue(&dev, &queue, output, &request) < 0);
	}
	for (unsigned int n = 0; n < 4; n++) {
		hdr = (struct hfi_queue_header){ .q_size = 64, .write_idx = 4 };
		const u32 sizes[] = { 0, 4, 9, 20 };
		memory.ring[0] = sizes[n];
		memset(output, 0xa5, sizeof(output));
		assert(venus_read_queue(&dev, &queue, output, &request) == -EBADMSG);
		assert(hdr.read_idx == 0 && hdr.write_idx == 4 && output[0] == 0xa5a5a5a5);
	}
	/* A published but oversized response is dropped, never copied or dumped. */
	u32 large_ring[IFACEQ_VAR_HUGE_PKT_SIZE / 4 + 2] = {0};
	u32 old_dumps = dumps;
	queue.qmem.kva = large_ring;
	queue.qmem.size = sizeof(large_ring);
	hdr = (struct hfi_queue_header){
		.q_size = sizeof(large_ring) / 4,
		.write_idx = IFACEQ_VAR_HUGE_PKT_SIZE / 4 + 1,
	};
	large_ring[0] = IFACEQ_VAR_HUGE_PKT_SIZE + 4;
	memset(output, 0xa5, sizeof(output));
	assert(venus_read_queue(&dev, &queue, output, &request) == -EBADMSG);
	assert(hdr.read_idx == hdr.write_idx);
	assert(output[0] == 0xa5a5a5a5 && dumps == old_dumps);
	printf("PASS: %u HFI ring round-trips, empty/full rings, invalid indices "
	       "and unpublished/truncated/unaligned/oversized packet lengths\n", cases);
	return 0;
}
