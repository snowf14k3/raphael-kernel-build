# Test19 SM8150 encoder property reset analysis

## Captured boundary

The persistent Windows SSH capture contains 55 lines after
`TEST19_ENCODER_FULL_BEGIN`. Test19 (`7.1.0-sm8150-venus-test19+`) completed
HFI resume, SESSION_INIT and both queue allocations. Both encoder queues
reported `bidirectional=1 upstream-hint=1`.

The final line was:

```text
[147.011539] ... SET_PROPERTY property=0x2005009 bytes=84 cmd=29 msg=5 irq=9
```

There was no final requirements query, final count, internal SET_BUFFERS,
LOAD_RESOURCES, START, FTB or ETB. Test19 therefore did not exercise the
0033 count correction or any codec-buffer access through the new cache
mapping. Its reset boundary is the HFI4 QP range property.

## Deterministic payload defect

`0x2005009` is `HFI_PROPERTY_PARAM_VENC_SESSION_QP_RANGE_V2`. Its 84-byte
packet length is correct: session-property header, property ID and the full
64-byte HFI4 min/max quantization-range structure.

The Linux parent packetizer sets both `min_qp.enable` and `max_qp.enable` to
7, selecting I, P and B frame classes. Patch 0022 changed both fields to copy
the caller's `hfi_quantization_range_v2` enable members. That caller assigns
packed QP values and layer IDs but never assigns either enable member.

Before 0032, both the caller structure and the command packet contained stack
garbage, so Test17 could pass this point accidentally. Patch 0032 correctly
zeroed both objects. Test18 suppressed the default QP range packet and did not
exercise the defect. Patch 0033 restored the Test17 property set, so Test19
sent deterministic zero enable masks and reset at that command.

Patch 0034 restores the wire invariant in the packetizer: both masks are 7.
It also logs packed min/max, layer and enable immediately before submission.

## Remaining property audit

The complete H.264 admission sequence before and after `0x2005009` was checked
again, rather than stopping at the last log line:

| Property | Payload state | Result |
|---|---|---|
| VPE rotation/flip | operations struct initialized, both fields assigned | complete |
| frame rate | buffer type and Q16 rate assigned | complete |
| H.264 VUI | structure zeroed; disabled default is intentional | complete |
| entropy | mode and CABAC model assigned | complete |
| deblock | mode and both offsets assigned | complete |
| transform 8x8 | enable field assigned | complete |
| IDR/intra period | local structures zeroed and active fields assigned | complete |
| rate control | scalar assigned from V4L2 bitrate mode | complete |
| RC timestamp | enable scalar assigned | complete |
| NAL format | Annex-B selector assigned | complete |
| target bitrate | bitrate and layer assigned | complete |
| sequence header | enable scalar assigned | complete |
| QP range v2 | packed QP/layer assigned; enable fixed to 7 by 0034 | corrected |
| profile/level | both fields assigned; IRIS1 automatic level 0 retained | complete |
| AUD | zeroed enable structure | complete |
| base priority/internal config | scalar or fully initialized structures | complete |
| work route/mode/core | scalar selectors assigned | complete |

No other restored default H.264 property copies an unset caller member. The
0033 final-count lifecycle and upstream-cache mapping remain in place, but
neither has yet received Test19 hardware evidence beyond queue allocation.

## Test20 acceptance

The next capture must show the new QP diagnostic with `enable=7`, then advance
past property `0x2005009`. It must subsequently show final INPUT 16/3 and
OUTPUT 4/4 counts, refreshed requirements, internal upstream-hint buffers,
LOAD_RESOURCES_DONE and START_DONE before any FTB/ETB claim is made.

Functional encoding still requires EBD, a non-empty FBD, software-decodable
Annex-B output, clean STOP/RELEASE/END and runtime PM returning to suspended.
