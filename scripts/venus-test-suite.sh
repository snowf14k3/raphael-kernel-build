#!/usr/bin/env bash
# Local, synthetic-video tests only. No installation, flashing or uploading.
set -euo pipefail
umask 077

frame_hashes() {
	awk -F, '!/^#/ && NF >= 6 { gsub(/^[ \t]+|[ \t\r]+$/, "", $NF); print $NF }' "$1"
}
if [[ "${1:-}" == --plan ]]; then
	printf '%s\n' \
		'Preflight: test8 kernel, SM8150 Venus nodes, idle devices, tools, free space.' \
		'A: PM held on; H.264 320x240/720p/1080p plus HEVC 8/10-bit decode.' \
		'B: PM auto; observe suspended, decode, repeat for two cycles.' \
		'Compare decode frame hashes with software and check exact frame counts.' \
		'Hardware encode stays disabled unless VENUS_TEST_ENCODER=1 is explicitly set.' \
		'Restore original PM/debug settings; save local logs and report.tar.gz.' \
		'Stop issuing codec jobs after a timeout or functional failure.'
	exit 0
fi
if [[ "${1:-}" == --self-test ]]; then
	test_dir="$(mktemp -d)"
	trap 'rm -f -- "$test_dir/a" "$test_dir/b" "$test_dir/ha" "$test_dir/hb"; rmdir -- "$test_dir"' EXIT
	printf '# comment\n0, 0, 0, 1, 115200, abcd\n0, 1, 1, 1, 115200, ef01\n' > "$test_dir/a"
	printf '# other timestamps\n0, 9, 9, 1, 115200, abcd\n0, 10, 10, 1, 115200, ef01\n' > "$test_dir/b"
	frame_hashes "$test_dir/a" > "$test_dir/ha"
	frame_hashes "$test_dir/b" > "$test_dir/hb"
	diff -u "$test_dir/ha" "$test_dir/hb"
	[[ "$(wc -l < "$test_dir/ha")" -eq 2 ]]
	printf '0, 11, 11, 1, 115200, wrong\n' >> "$test_dir/b"
	frame_hashes "$test_dir/b" > "$test_dir/hb"
	if cmp -s "$test_dir/ha" "$test_dir/hb"; then exit 1; fi
	echo 'PASS: timestamp-independent frame hashes detect extra/different frames.'
	exit 0
fi
[[ $# -eq 0 ]] || { echo 'Usage: sudo bash venus-test-suite.sh [--plan|--self-test]' >&2; exit 2; }
[[ $EUID -eq 0 ]] || { echo '请使用 sudo bash venus-test-suite.sh。' >&2; exit 2; }
[[ "$(uname -r)" == *sm8150-venus-test8* ]] || {
	echo '当前不是 test8 内核，未开始测试，也未修改设备设置。' >&2; exit 2;
}
[[ "${VENUS_TEST_ENCODER:-0}" == 0 || "${VENUS_TEST_ENCODER:-0}" == 1 ]] || {
	echo 'VENUS_TEST_ENCODER 只能是 0 或 1；未开始测试。' >&2; exit 2;
}
for command in ffmpeg timeout tar awk diff cmp sha256sum fuser dmesg readlink sync; do
	command -v "$command" >/dev/null || { echo "缺少命令：$command；未开始测试。" >&2; exit 2; }
done
dev=/sys/bus/platform/devices/aa00000.video-codec
control="$dev/power/control"
status="$dev/power/runtime_status"
[[ -r "$dev/of_node/compatible" && -w "$control" ]] || {
	echo '没有可用的 SM8150 Venus 设备。' >&2; exit 2;
}
compatible="$(tr '\0' '\n' < "$dev/of_node/compatible")"
[[ "$compatible" == *qcom,sm8150-venus* ]] || { echo '设备型号不匹配。' >&2; exit 2; }
decoder= encoder=
for node in /sys/class/video4linux/video*; do
	[[ -r "$node/name" ]] || continue
	[[ "$(readlink -f "$node/device")" == "$(readlink -f "$dev")" ]] || continue
	name="$(< "$node/name")"
	case "${name,,}" in
		*venus*decoder*) decoder="/dev/${node##*/}" ;;
		*venus*encoder*) encoder="/dev/${node##*/}" ;;
	esac
done
[[ -n "$decoder" && -n "$encoder" ]] || { echo 'Venus 编码/解码节点不齐，未开始测试。' >&2; exit 2; }
if fuser "$decoder" "$encoder" >/dev/null 2>&1; then
	echo '视频设备正在使用，请先关闭播放器或已有 FFmpeg 测试。' >&2; exit 2;
fi
[[ "$(df -Pk /var/tmp | awk 'NR == 2 { print $4 }')" -ge 65536 ]] || {
	echo '/var/tmp 至少需要 64 MiB 空间；不会使用 /boot。' >&2; exit 2;
}
run_root="$(mktemp -d /var/tmp/venus-batch.XXXXXX)"
trace=/sys/module/venus_core/parameters/iris1_debug
original_power="$(< "$control")"
original_trace=
[[ ! -r "$trace" ]] || original_trace="$(< "$trace")"
power_changed=0
trace_changed=0
summary="$run_root/summary.tsv"
printf 'test\tresult\tdetail\n' > "$summary"
record() {
	printf '%s\t%s\t%s\n' "$1" "$2" "$3" >> "$summary"
	sync -f "$summary"
	printf '%-24s %s\n' "$1" "$2"
}
set_knob() {
	timeout -k 2s 5s bash -c 'printf "%s\n" "$1" > "$2"' _ "$2" "$1"
}
snapshot() {
	local label="$1"
	timeout -k 2s 5s dmesg > "$run_root/$label.dmesg.log" 2>&1 || true
	{
		date --iso-8601=seconds
		for path in "$dev"/power/runtime_{status,active_time,suspended_time} \
			"$dev"/*/power/runtime_status; do
			[[ ! -r "$path" ]] || { printf '%s: ' "$path"; timeout -k 2s 2s cat "$path" || true; }
		done
		grep -iE 'CPU|venus|aa00000' /proc/interrupts || true
		if [[ -r /sys/kernel/debug/clk/clk_summary ]]; then
			timeout -k 2s 5s grep -E 'clock|enable|video_cc_|gcc_video_' /sys/kernel/debug/clk/clk_summary || true
		fi
		if [[ -r /sys/kernel/debug/pm_genpd/pm_genpd_summary ]]; then
			timeout -k 2s 5s cat /sys/kernel/debug/pm_genpd/pm_genpd_summary || true
		fi
	} > "$run_root/$label.power.log" 2>&1
}
finish() {
	local rc=$?
	trap - EXIT
	set +e
	if (( trace_changed )); then
		set_knob "$trace" "$original_trace" || { record restore-debug FAIL 'restore manually'; rc=1; }
	fi
	if (( power_changed )); then
		set_knob "$control" "$original_power" || { record restore-power FAIL 'restore manually'; rc=1; }
	fi
	snapshot final
	printf 'exit_code=%s\noriginal_power=%s\n' "$rc" "$original_power" > "$run_root/result.txt"
	local archive="$run_root/report.tar.gz"
	: > "$archive"
	if tar -C "$run_root" --exclude='./report.tar.gz' -czf "$archive" .; then
		if [[ "${SUDO_UID:-}" =~ ^[0-9]+$ && "${SUDO_GID:-}" =~ ^[0-9]+$ ]]; then
			chown "$SUDO_UID:$SUDO_GID" "$run_root" "$archive"
		fi
		printf '\n报告：%s\n' "$archive"
	else
		printf '\n打包失败，原始日志保留在：%s\n' "$run_root"
		rc=1
	fi
	echo '日志仅保存在本机，没有上传；发给别人前可检查其中的设备信息。'
	exit "$rc"
}
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
uname -a > "$run_root/uname.txt"
ffmpeg -version > "$run_root/ffmpeg-version.txt" 2>&1
ffmpeg -hide_banner -decoders > "$run_root/decoders.txt" 2>&1
ffmpeg -hide_banner -encoders > "$run_root/encoders.txt" 2>&1
snapshot before
[[ "$(< "$status")" != error ]] || {
	record preflight FAIL 'runtime PM already in error; no codec jobs issued'; exit 1;
}
grep -q 'h264_v4l2m2m' "$run_root/decoders.txt" || {
	record preflight FAIL 'FFmpeg lacks h264_v4l2m2m'; exit 1;
}
grep -q 'hevc_v4l2m2m' "$run_root/decoders.txt" || {
	record preflight FAIL 'FFmpeg lacks hevc_v4l2m2m'; exit 1;
}
grep -q 'libx265' "$run_root/encoders.txt" || {
	record preflight FAIL 'FFmpeg lacks libx265 for local HEVC samples'; exit 1;
}
if [[ -w "$trace" ]]; then
	trace_changed=1
	set_knob "$trace" Y
fi
run_ffmpeg() {
	local label="$1"; shift
	local rc
	if timeout -k 5s 25s ffmpeg -nostdin -hide_banner -loglevel info "$@" \
		> "$run_root/$label.ffmpeg.log" 2>&1; then rc=0; else rc=$?; fi
	printf '\ncommand_exit=%s\n' "$rc" >> "$run_root/$label.ffmpeg.log"
	sync -f "$run_root"
	return "$rc"
}
decode_codec_case() {
	local label="$1" sample="$2" frames="$3" decoder_name="$4" pixel_format="$5"
	local sample_key="${sample%.*}"
	if ! run_ffmpeg "$label" -xerror -c:v "$decoder_name" -i "$run_root/$sample" \
		-map 0:v:0 -an -pix_fmt "$pixel_format" \
		-f framemd5 "$run_root/$label.framemd5"; then
		record "$label" FAIL 'hardware decode failed/timed out; see ffmpeg log'
		snapshot "$label"
		return 1
	fi
	if ! grep -q "driver 'qcom-venus'" "$run_root/$label.ffmpeg.log"; then
		record "$label" FAIL 'qcom-venus use was not confirmed'; return 1;
	fi
	frame_hashes "$run_root/$label.framemd5" > "$run_root/$label.hashes"
	if [[ "$(wc -l < "$run_root/$label.hashes")" -ne "$frames" ]] || \
		! diff -u "$run_root/$sample_key.reference.hashes" "$run_root/$label.hashes" \
		> "$run_root/$label.diff"; then
		record "$label" FAIL 'frame count or pixels differ from software'
		snapshot "$label"
		return 1
	fi
	record "$label" PASS "$frames frames; hardware confirmed; software hashes match"
	snapshot "$label"
}
decode_case() {
	decode_codec_case "$1" "$2.mp4" "$3" h264_v4l2m2m yuv420p
}
prepare_sample() {
	local label="$1" size="$2" frames="$3"
	run_ffmpeg "$label.generate" -f lavfi -i "testsrc2=size=$size:rate=30" \
		-frames:v "$frames" -c:v libx264 -threads 2 -pix_fmt yuv420p "$run_root/$label.mp4" || return 1
	run_ffmpeg "$label.reference" -xerror -c:v h264 -threads 2 -i "$run_root/$label.mp4" \
		-map 0:v:0 -an -pix_fmt yuv420p -f framemd5 "$run_root/$label.reference.framemd5" || return 1
	frame_hashes "$run_root/$label.reference.framemd5" > "$run_root/$label.reference.hashes"
	[[ "$(wc -l < "$run_root/$label.reference.hashes")" -eq "$frames" ]]
}
prepare_hevc_sample() {
	local label="$1" pixel_format="$2" frames="$3"
	run_ffmpeg "$label.generate" -f lavfi -i testsrc2=size=320x240:rate=30 \
		-frames:v "$frames" -c:v libx265 -threads 2 -pix_fmt "$pixel_format" \
		-x265-params pools=2:frame-threads=1:log-level=error "$run_root/$label.mkv" || return 1
	run_ffmpeg "$label.reference" -xerror -c:v hevc -threads 2 -i "$run_root/$label.mkv" \
		-map 0:v:0 -an -pix_fmt "$pixel_format" \
		-f framemd5 "$run_root/$label.reference.framemd5" || return 1
	frame_hashes "$run_root/$label.reference.framemd5" > "$run_root/$label.reference.hashes"
	[[ "$(wc -l < "$run_root/$label.reference.hashes")" -eq "$frames" ]]
}
stop_batch() {
	record remaining SKIP 'stopped after failure; no module reload or reboot attempted'
	exit 1
}
prepare_sample small 320x240 90 || { record prepare FAIL 'software sample generation failed'; exit 1; }
power_changed=1
set_knob "$control" on || { record power-on FAIL 'cannot hold runtime power'; exit 1; }
decode_case on-small small 90 || stop_batch
for spec in '720p 1280x720' '1080p 1920x1080'; do
	read -r label size <<< "$spec"
	prepare_sample "$label" "$size" 30 || { record prepare FAIL "$label generation failed"; exit 1; }
	decode_case "on-$label" "$label" 30 || stop_batch
done
decode_case on-reopen small 90 || stop_batch
for spec in 'hevc8 yuv420p' 'hevc10 yuv420p10le'; do
	read -r label pixel_format <<< "$spec"
	prepare_hevc_sample "$label" "$pixel_format" 30 || {
		record prepare FAIL "$label software generation failed"; exit 1;
	}
	decode_codec_case "on-$label" "$label.mkv" 30 hevc_v4l2m2m "$pixel_format" || stop_batch
done
if [[ "${VENUS_TEST_ENCODER:-0}" != 1 ]]; then
	record hw-encode SKIP 'disabled by default after the test5 reboot; opt in with VENUS_TEST_ENCODER=1'
elif grep -q 'h264_v4l2m2m' "$run_root/encoders.txt"; then
	if ! run_ffmpeg hw-encode -f lavfi -i testsrc2=size=320x240:rate=30 \
		-frames:v 30 -pix_fmt nv12 -c:v h264_v4l2m2m -b:v 1000k "$run_root/encoded.h264"; then
		record hw-encode FAIL 'encoder failed/timed out'; stop_batch;
	fi
	if ! grep -q "driver 'qcom-venus'" "$run_root/hw-encode.ffmpeg.log" || \
		! run_ffmpeg encoded-check -xerror -c:v h264 -threads 2 -i "$run_root/encoded.h264" \
		-pix_fmt yuv420p -f framemd5 "$run_root/encoded-check.framemd5"; then
		record hw-encode FAIL 'hardware use or software decode validation failed'; stop_batch;
	fi
	frame_hashes "$run_root/encoded-check.framemd5" > "$run_root/encoded-check.hashes"
	[[ "$(wc -l < "$run_root/encoded-check.hashes")" -eq 30 ]] || {
		record hw-encode FAIL 'encoded frame count differs'; stop_batch;
	}
	record hw-encode PASS '30 hardware-encoded frames decoded successfully in software'
else
	record hw-encode SKIP 'FFmpeg lacks h264_v4l2m2m encoder'
fi
snapshot encoded
set_knob "$control" auto || { record power-auto FAIL 'cannot enable runtime PM'; exit 1; }
for cycle in 1 2; do
	suspended=0
	for attempt in {1..20}; do
		current_status="$(timeout -k 2s 2s cat "$status")"
		[[ "$current_status" != error ]] || { record "auto-$cycle" FAIL 'runtime PM error'; stop_batch; }
		if [[ "$current_status" == suspended ]]; then suspended=1; break; fi
		sleep 0.5
	done
	if (( !suspended )); then
		record "auto-$cycle" FAIL 'did not observe suspend within 10 seconds'; stop_batch;
	fi
	record "suspend-$cycle" PASS 'observed runtime_status=suspended'
	snapshot "suspended-$cycle"
	decode_case "resume-$cycle" small 90 || stop_batch
done
record suite PASS 'all executed checks passed; SKIP entries are not passes'
