#!/usr/bin/env bash
# Local, synthetic-video tests only. No installation, flashing or uploading.
set -euo pipefail
umask 077

frame_hashes() {
	awk -F, '!/^#/ && NF >= 6 { gsub(/^[ \t]+|[ \t\r]+$/, "", $NF); print $NF }' "$1"
}
if [[ "${1:-}" == --plan ]]; then
	printf '%s\n' \
		'Preflight: test19 kernel, SM8150 Venus nodes, idle devices, tools, free space.' \
		'A: PM held on; H.264, HEVC Main8, VP8, VP9 Profile0 and MPEG2 decode.' \
		'B: HEVC Main10 and VP9 Profile2 P010 paths are compared to software hashes.' \
		'C: PM auto; observe suspended, decode, repeat for two cycles.' \
		'Compare decode frame hashes with software and check exact frame counts.' \
		'Use VENUS_TEST_SCOPE=encoder plus VENUS_TEST_ENCODER=1 to skip decoder cases.' \
		'When enabled, one H.264 frame is tested first, then H.264/HEVC/VP8 short streams.' \
		'Restore original PM/debug settings; save local logs and report.tar.gz.' \
		'Stop immediately after a codec failure to avoid a firmware event/log storm.'
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
[[ "$(uname -r)" == *sm8150-venus-test19* ]] || {
	echo '当前不是 test19 内核，未开始测试，也未修改设备设置。' >&2; exit 2;
}
scope="${VENUS_TEST_SCOPE:-decoder}"
[[ "$scope" == decoder || "$scope" == encoder || "$scope" == all ]] || {
	echo 'VENUS_TEST_SCOPE 只能是 decoder、encoder 或 all；未开始测试。' >&2; exit 2;
}
[[ "${VENUS_TEST_ENCODER:-0}" == 0 || "${VENUS_TEST_ENCODER:-0}" == 1 ]] || {
	echo 'VENUS_TEST_ENCODER 只能是 0 或 1；未开始测试。' >&2; exit 2;
}
for command in ffmpeg timeout tar awk diff cmp sha256sum fuser dmesg logger readlink sync; do
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
encoder_protocol_gate=/sys/module/venus_enc/parameters/iris1_encoder
original_power="$(< "$control")"
original_trace=
original_encoder_protocol_gate=
[[ ! -r "$trace" ]] || original_trace="$(< "$trace")"
[[ ! -r "$encoder_protocol_gate" ]] || original_encoder_protocol_gate="$(< "$encoder_protocol_gate")"
power_changed=0
trace_changed=0
encoder_protocol_gate_changed=0
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
	if (( encoder_protocol_gate_changed )); then
		set_knob "$encoder_protocol_gate" "$original_encoder_protocol_gate" || { record restore-encoder-protocol-gate FAIL 'restore manually'; rc=1; }
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
	local reference_format="${4:-$pixel_format}"
	run_ffmpeg "$label.generate" -f lavfi -i testsrc2=size=320x240:rate=30 \
		-frames:v "$frames" -c:v libx265 -threads 2 -pix_fmt "$pixel_format" \
		-x265-params pools=2:frame-threads=1:log-level=error "$run_root/$label.mkv" || return 1
	run_ffmpeg "$label.reference" -xerror -c:v hevc -threads 2 -i "$run_root/$label.mkv" \
		-map 0:v:0 -an -pix_fmt "$reference_format" \
		-f framemd5 "$run_root/$label.reference.framemd5" || return 1
	frame_hashes "$run_root/$label.reference.framemd5" > "$run_root/$label.reference.hashes"
	[[ "$(wc -l < "$run_root/$label.reference.hashes")" -eq "$frames" ]]
}
prepare_codec_sample() {
	local label="$1" encoder_name="$2" pixel_format="$3" extension="$4" frames="$5"
	shift 5
	run_ffmpeg "$label.generate" -f lavfi -i testsrc2=size=320x240:rate=30 \
		-frames:v "$frames" -c:v "$encoder_name" -threads 2 -pix_fmt "$pixel_format" \
		"$@" "$run_root/$label.$extension" || return 1
	run_ffmpeg "$label.reference" -xerror -threads 2 -i "$run_root/$label.$extension" \
		-map 0:v:0 -an -pix_fmt "$pixel_format" \
		-f framemd5 "$run_root/$label.reference.framemd5" || return 1
	frame_hashes "$run_root/$label.reference.framemd5" > "$run_root/$label.reference.hashes"
	[[ "$(wc -l < "$run_root/$label.reference.hashes")" -eq "$frames" ]]
}
encode_codec_case() {
	local label="$1" encoder_name="$2" decoder_name="$3"
	local mux="$4" extension="$5" frames="$6" size="$7"
	local output="$run_root/$label.$extension"
	local framemd5="$run_root/$label.verify.framemd5"

	rm -f -- "$output" "$framemd5"
	if ! run_ffmpeg "$label" -y -f lavfi -i "testsrc2=size=$size:rate=30" \
		-frames:v "$frames" -pix_fmt nv12 -c:v "$encoder_name" \
		-g 1 -b:v 512k -f "$mux" "$output"; then
		record "$label" FAIL 'hardware encoder returned an error'; return 1
	fi
	if [[ ! -s "$output" ]]; then
		record "$label" FAIL 'hardware encoder produced an empty stream'; return 1
	fi
	if ! run_ffmpeg "$label.verify" -xerror -c:v "$decoder_name" -i "$output" \
		-map 0:v:0 -an -frames:v "$frames" -f framemd5 "$framemd5"; then
		record "$label" FAIL 'encoded stream cannot be decoded in software'; return 1
	fi
	if [[ "$(awk '!/^#/ {n++} END {print n + 0}' "$framemd5")" -ne "$frames" ]]; then
		record "$label" FAIL 'software decoder returned the wrong frame count'; return 1
	fi
	record "$label" PASS "$frames frames; non-empty stream; software decode passed"
}
stop_batch() {
	record remaining SKIP 'stopped after failure; no module reload or reboot attempted'
	exit 1
}
if [[ "$scope" != encoder ]]; then
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
for spec in 'hevc8 yuv420p'; do
	read -r label pixel_format <<< "$spec"
	prepare_hevc_sample "$label" "$pixel_format" 30 || {
		record prepare FAIL "$label software generation failed"; exit 1;
	}
	decode_codec_case "on-$label" "$label.mkv" 30 hevc_v4l2m2m "$pixel_format" || stop_batch
done

if grep -q 'libvpx ' "$run_root/encoders.txt" && grep -q 'vp8_v4l2m2m' "$run_root/decoders.txt"; then
	prepare_codec_sample vp8 libvpx yuv420p mkv 30 -deadline realtime -cpu-used 8 || {
		record prepare FAIL 'VP8 software generation failed'; exit 1;
	}
	decode_codec_case on-vp8 vp8.mkv 30 vp8_v4l2m2m yuv420p || stop_batch
else
	record on-vp8 SKIP 'FFmpeg lacks libvpx encoder or vp8_v4l2m2m decoder'
fi

if grep -q 'libvpx-vp9 ' "$run_root/encoders.txt" && grep -q 'vp9_v4l2m2m' "$run_root/decoders.txt"; then
	prepare_codec_sample vp9p0 libvpx-vp9 yuv420p mkv 30 -deadline realtime -cpu-used 8 || {
		record prepare FAIL 'VP9 Profile0 software generation failed'; exit 1;
	}
	decode_codec_case on-vp9p0 vp9p0.mkv 30 vp9_v4l2m2m yuv420p || stop_batch
else
	record on-vp9p0 SKIP 'FFmpeg lacks libvpx-vp9 encoder or vp9_v4l2m2m decoder'
fi

if grep -q 'mpeg2video ' "$run_root/encoders.txt" && grep -q 'mpeg2_v4l2m2m' "$run_root/decoders.txt"; then
	prepare_codec_sample mpeg2 mpeg2video yuv420p m2v 30 || {
		record prepare FAIL 'MPEG2 software generation failed'; exit 1;
	}
	decode_codec_case on-mpeg2 mpeg2.m2v 30 mpeg2_v4l2m2m yuv420p || stop_batch
else
	record on-mpeg2 SKIP 'FFmpeg lacks MPEG2 encoder or mpeg2_v4l2m2m decoder'
fi

prepare_hevc_sample hevc10 yuv420p10le 30 yuv420p || {
	record prepare FAIL 'HEVC Main10 software generation failed'; exit 1;
}
decode_codec_case on-hevc10-nv12 hevc10.mkv 30 hevc_v4l2m2m yuv420p || stop_batch

if grep -q 'libvpx-vp9 ' "$run_root/encoders.txt" && grep -q 'vp9_v4l2m2m' "$run_root/decoders.txt"; then
	prepare_codec_sample vp9p2 libvpx-vp9 yuv420p10le mkv 30 \
		-profile:v 2 -deadline realtime -cpu-used 8 || {
		record prepare FAIL 'VP9 Profile2 software generation failed'; exit 1;
	}
	decode_codec_case on-vp9p2 vp9p2.mkv 30 vp9_v4l2m2m yuv420p10le || stop_batch
else
	record on-vp9p2 SKIP 'FFmpeg lacks libvpx-vp9 encoder or vp9_v4l2m2m decoder'
fi

fi
if [[ "$scope" == decoder ]]; then
	record hw-encode SKIP 'decoder-only scope; encoder gate kept off'
elif [[ "${VENUS_TEST_ENCODER:-0}" != 1 ]]; then
	record hw-encode SKIP 'encoder gate kept off; set VENUS_TEST_ENCODER=1 explicitly'
elif grep -q 'h264_v4l2m2m' "$run_root/encoders.txt"; then
	[[ -w "$encoder_protocol_gate" ]] || {
		record hw-encode FAIL 'kernel encoder gate is unavailable'; stop_batch;
	}
	encoder_protocol_gate_changed=1
	set_knob "$encoder_protocol_gate" Y || {
		record hw-encode FAIL 'cannot unlock encoder gate'; stop_batch;
	}
	printf '<6>TEST19_ENCODER_FULL_BEGIN\n' > /dev/kmsg
	logger -t venus-test19-host 'ENCODER_FULL_BEGIN'
	sync
	encode_codec_case encode-h264-one h264_v4l2m2m h264 h264 h264 1 128x96 || stop_batch
	encode_codec_case encode-h264 h264_v4l2m2m h264 h264 h264 30 320x240 || stop_batch
	if grep -q 'hevc_v4l2m2m' "$run_root/encoders.txt"; then
		encode_codec_case encode-hevc hevc_v4l2m2m hevc hevc hevc 30 320x240 || stop_batch
	else
		record encode-hevc SKIP 'FFmpeg lacks hevc_v4l2m2m encoder'
	fi
	if grep -q 'vp8_v4l2m2m' "$run_root/encoders.txt"; then
		encode_codec_case encode-vp8 vp8_v4l2m2m vp8 ivf ivf 30 320x240 || stop_batch
	else
		record encode-vp8 SKIP 'FFmpeg lacks vp8_v4l2m2m encoder'
	fi
	snapshot encoder-full
else
	record hw-encode SKIP 'FFmpeg lacks h264_v4l2m2m encoder'
fi
snapshot encoded
if (( power_changed )); then
	set_knob "$control" auto || { record power-auto FAIL 'cannot enable runtime PM'; exit 1; }
fi
if [[ "$scope" != encoder ]]; then
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
else
	suspended=0
	for attempt in {1..20}; do
		current_status="$(timeout -k 2s 2s cat "$status")"
		[[ "$current_status" != error ]] || { record encoder-pm FAIL 'runtime PM error'; stop_batch; }
		if [[ "$current_status" == suspended ]]; then suspended=1; break; fi
		sleep 0.5
	done
	(( suspended )) || { record encoder-pm FAIL 'did not suspend within 10 seconds'; stop_batch; }
	record encoder-pm PASS 'encoder closed and runtime_status=suspended'
fi
record suite PASS 'all executed checks passed; SKIP entries are not passes'
