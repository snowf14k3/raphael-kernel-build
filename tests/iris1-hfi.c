/* SPDX-License-Identifier: GPL-2.0-only */
/* Bounds tests for the actual image-version and read-only debug-ring code. */
#include <assert.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

typedef uint32_t u32;
typedef uint8_t u8;
#define VER_STR_SZ 128
#define QCOM_SMEM_HOST_ANY 0
#define SMEM_IMG_VER_TBL 0
#define SMEM_IMG_OFFSET_VENUS 32
#define HFI_MSG_SYS_DEBUG 0x20001
#define IFACEQ_DBG_IDX 2
#define IFACEQ_VAR_HUGE_PKT_SIZE (12 * 1024)
#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
#define READ_ONCE(x) (x)
#define dma_rmb() ((void)0)
#define IS_ERR(p) ((intptr_t)(p) < 0)
#define IS_IRIS1(core) ((core)->iris1)
#define VDBGL ""
#define min_t(t, a, b) ((t)(a) < (t)(b) ? (t)(a) : (t)(b))
struct device { int unused; };
struct firmware_version { u32 major, minor, rev; };
struct venus_resources { bool min_fw; };
struct venus_core {
	struct device *dev;
	struct firmware_version venus_ver;
	const struct venus_resources *res;
	bool iris1;
	int done;
};
struct hfi_pkt_hdr { u32 size, pkt_type; };
struct hfi_msg_sys_property_info_pkt {
	struct hfi_pkt_hdr hdr;
	u32 num_properties, property;
	u8 data[];
};
struct hfi_msg_sys_debug_pkt {
	struct hfi_pkt_hdr hdr;
	u32 msg_type, msg_size, time_stamp_hi, time_stamp_lo;
	u8 msg_data[];
};
struct hfi_queue_header { u32 q_size, read_idx, write_idx; };
struct iface_queue {
	struct hfi_queue_header *qhdr;
	struct { void *kva; u32 size; } qmem;
};
struct venus_hfi_device {
	struct venus_core *core;
	struct iface_queue queues[3];
};
static unsigned char smem[256];
static int smem_gets, errors;
static char last_log[1024];
static void *qcom_smem_get(int host, int item, size_t *size)
{
	(void)host;
	(void)item;
	smem_gets++;
	*size = sizeof(smem);
	return smem;
}
static void complete(int *done) { (*done)++; }
static void quiet_log(struct device *dev, const char *fmt, ...)
{
	(void)dev;
	(void)fmt;
}
static void error_log(struct device *dev, const char *fmt, ...)
{
	va_list args;
	(void)dev;
	errors++;
	va_start(args, fmt);
	vsnprintf(last_log, sizeof(last_log), fmt, args);
	va_end(args);
}
#define dev_dbg quiet_log
#define dev_info quiet_log
#define dev_err error_log

/* ACTUAL_DRIVER_FUNCTIONS */

static const struct venus_resources resources = { .min_fw = true };
static struct venus_core core = { .res = &resources, .iris1 = true };
static void version_test(const char *value, bool valid, u32 major, u32 minor, u32 rev)
{
	u32 storage[(sizeof(struct hfi_msg_sys_property_info_pkt) + VER_STR_SZ) / 4];
	struct hfi_msg_sys_property_info_pkt *pkt = (void *)storage;
	memset(storage, 0, sizeof(storage));
	pkt->hdr.size = sizeof(storage);
	pkt->num_properties = 1;
	memcpy(pkt->data, value, strlen(value));
	core.venus_ver = (struct firmware_version){0};
	core.done = smem_gets = errors = 0;
	sys_get_prop_image_version(&core, pkt);
	assert(core.venus_ver.major == major && core.venus_ver.minor == minor);
	assert(core.venus_ver.rev == rev);
	assert(core.done == valid && smem_gets == valid);
	if (valid) assert(!memcmp(smem + SMEM_IMG_OFFSET_VENUS, pkt->data, VER_STR_SZ));

	/* Neither a short payload nor multiple properties may be consumed. */
	core.done = smem_gets = 0;
	pkt->hdr.size--;
	sys_get_prop_image_version(&core, pkt);
	assert(!core.done && !smem_gets);
	pkt->hdr.size++;
	pkt->num_properties = 2;
	sys_get_prop_image_version(&core, pkt);
	assert(!core.done && !smem_gets);
}
static void ring_test(void)
{
	u32 ring[64] = {0}, packet[8] = {0};
	struct hfi_msg_sys_debug_pkt *pkt = (void *)packet;
	struct hfi_queue_header hdr = { .q_size = 64, .read_idx = 60, .write_idx = 4 };
	struct venus_hfi_device hdev = { .core = &core };
	hdev.queues[2].qhdr = &hdr;
	hdev.queues[2].qmem.kva = ring;
	hdev.queues[2].qmem.size = sizeof(ring);
	pkt->hdr.size = sizeof(packet);
	pkt->hdr.pkt_type = HFI_MSG_SYS_DEBUG;
	pkt->msg_size = 8;
	memcpy(pkt->msg_data, "FW-ERROR", 8); /* deliberately not NUL-terminated */
	for (int i = 0; i < 8; i++) ring[(60 + i) % 64] = packet[i];
	errors = 0;
	venus_peek_debug_queue(&hdev);
	assert(errors == 1 && strstr(last_log, "FW-ERROR"));
	assert(hdr.read_idx == 60 && hdr.write_idx == 4); /* never consume */

	errors = 0;
	hdr.q_size = 0;
	venus_peek_debug_queue(&hdev);
	hdr.q_size = 1000;
	venus_peek_debug_queue(&hdev);
	hdr.q_size = 64;
	hdr.read_idx = 64;
	venus_peek_debug_queue(&hdev);
	hdr.read_idx = 60;
	hdr.write_idx = 64;
	venus_peek_debug_queue(&hdev);
	hdr.write_idx = 4;
	ring[60] = 31; /* unaligned */
	venus_peek_debug_queue(&hdev);
	ring[60] = 36; /* not all words published */
	venus_peek_debug_queue(&hdev);
	ring[60] = 32;
	ring[63] = 100; /* invalid msg_size */
	venus_peek_debug_queue(&hdev);
	assert(!errors);

	/* A ring with four valid messages produces at most three log lines. */
	for (int i = 0; i < 4; i++) memcpy(ring + 8 * i, packet, sizeof(packet));
	hdr.read_idx = 0;
	hdr.write_idx = 32;
	venus_peek_debug_queue(&hdev);
	assert(errors == 3 && hdr.read_idx == 0 && hdr.write_idx == 32);
}
int main(void)
{
	version_test("14:VIDEO.IR.1.2-00045-PROD-1", true, 1, 2, 45);
	version_test("14:video-firmware.5.4-51", true, 5, 4, 51);
	version_test("14:VIDEO.VPU.1.0-87", true, 1, 0, 87);
	version_test("14:VIDEO.VE.2.1-12", true, 2, 1, 12);
	version_test("14:VIDEO.IR.1", false, 0, 0, 0);
	version_test("14:VIDEO.IR.1.2-", false, 0, 0, 0);
	version_test("garbage", false, 0, 0, 0);
	char full[VER_STR_SZ + 1];
	memset(full, 'X', VER_STR_SZ);
	memcpy(full, "14:VIDEO.IR.1.2-00045-", 21);
	full[VER_STR_SZ] = 0;
	version_test(full, true, 1, 2, 45);
	core.iris1 = false;
	version_test("14:VIDEO.IR.1.2-00045-PROD-1", false, 0, 0, 0);
	ring_test();
	puts("PASS: firmware-version formats, truncation and unterminated fields; "
	     "wrapped/malformed debug rings and bounded non-consuming snapshots");
	return 0;
}
