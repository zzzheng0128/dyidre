# 350.101 true-device multi-request `exeVMInner` baseline

Date: 2026-08-31

Purpose: verify the real-device HTTP signing path across multiple requests, so
Unidbg replay and recovered C code follow the device environment rather than a
single accidental branch.

## Capture

Script:

```text
dyidre/probes/350101/metasec_probe_350101.js mode=counter-multi
```

Device run:

```text
Pixel 6 / Android 15
rustFrida spawn as root
package: com.ss.android.ugc.aweme
module: libmetasec_ml.so
base: 0x7104e1e000
```

Raw summary:

```text
dyidre/versions/350101/multi_request_compare_350101/true_device_metamulti_8req_20260831_121946.json
```

The captured `s1/s2` inputs were also split into:

```text
true_req_01_s1.txt / true_req_01_s2.txt
...
true_req_08_s1.txt / true_req_08_s2.txt
```

## Result

Across the first 8 real-device HTTP signing callbacks, the hot path is stable:

```text
per request:
  http_callback_14dbf4       1
  http_entry_149ca8          1
  branch_helper_ret_149f60   1, returns 1
  branch_f5f7_gate_14a250    1, bit0=1
  nativeStage1_14a1ac        1
  nativeStage2_14a1fc        1
  managedF8_14a4e0           1
  managedF13_14a588          1
  exeVMInner_4cc10           4
```

`managedF5_14a38c` and `managedF7_14a3ec` did not execute in these true-device
requests. The branch at `0x14A250` consistently takes the "skip F5/F7, go to
F8" path.

Global counts for 8 requests:

```text
http_callback_14dbf4              8
http_entry_149ca8                 8
branch_helper_ret_149f60          8
branch_f5f7_gate_14a250           8
nativeStage1_14a1ac               8
nativeStage2_14a1fc               8
managedF8_14a4e0                  8
managedF13_14a588                 8
native_binding_smallA_15281c      8
native_binding_runtimeGate_152840 8
native_binding_smallB_152864      8
nativeVmpSelectMaterial_12564c    8
nativeVmpBuildMaterial_124dd4     8
exeVMInner_4cc10                  32
```

Global native VMP histogram:

```text
vmCode:
  0x1EC670  16
  0x1ECAF0   8
  0x1F7860   8

LR:
  0x0D95CC  16
  0x0D964C   8
  0x124E34   8
```

Importantly, true device did not call the `0x201800` env/cache native VMP program
inside these 8 HTTP signing windows.

## Per-request table

| # | host/path | s1/s2 | gate | runtimeGate | exeVMInner vmCode | LR |
|---:|---|---:|---|---|---|---|
| 1 | `vcs-lf.zijieapi.com/vc/setting` | 195/902 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 2 | `api5-core-hl.amemv.com/aweme/v2/feed/` | 1918/1791 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 3 | `api5-social-m-hl.amemv.com/aweme/v1/im/platform/config/global/` | 927/1078 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 4 | `log0-misc-lf.amemv.com/service/2/app_log/` | 160/1276 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 5 | `api5-normal-lf.amemv.com/hwm/v1/wm_img` | 834/1070 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 6 | `saveu5-normal-hl.zijieapi.com/api/plugin/config/v3/` | 903/1214 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 7 | `api5-social-m-zjg.amemv.com/aweme/v1/im/conversation/floating_bar/configs` | 869/1078 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |
| 8 | `api5-platform-lf.amemv.com/aweme/v1/addiction/info/` | 881/1078 | `149F60=1`, `bit0=1` | dynamic/global `(0,0)` | `1EC670*2 + 1ECAF0 + 1F7860` | `D95CC*2 + D964C + 124E34` |

## Unidbg comparison

Selected logs:

```text
unidbg/unidbg-android/target/sign6_350101_true_req_01_plain_env_20260831_122100.log
unidbg/unidbg-android/target/sign6_350101_true_req_01_force_env_20260831_122044.log
unidbg/unidbg-android/target/sign6_350101_true_req_02_force_env_20260831_122047.log
unidbg/unidbg-android/target/sign6_350101_true_req_04_force_env_20260831_122049.log
```

Plain Unidbg environment for request #1:

```text
0x149F60 returns 0
0x14A250 bit0 = 0
=> wrongly runs F5/F7

0xD952C dynamic/global byte = 1/1
=> runtimeGate returns 1, smallB/0x1ECAF0 path is skipped

exeVMInner.vmCode = 0x201800 + 0x1F7860*2 + 0x1EC670*2
```

With the current true-device branch normalization:

```text
-Dmetasec.forceRuntimeBranchFlags=true   // makes 0x1503AC/0x149F60 return 1
-Dmetasec.forceRuntimeGateByte=true      // makes 0xD952C return 0
```

Unidbg request #1/#2/#4 all reach the true-device core chain:

```text
0x1EC670*2 + 0x1ECAF0 + 0x1F7860
```

but still has one extra pre-stage env/cache call:

```text
0x12AC9C -> exeVMInner(vmCode=0x201800, data1=0x2706C0, data2=0x2706E0)
```

This extra `0x201800` is not request-content dependent in the tested set. It is
an Unidbg environment/cache artifact and should be chased through the caller
`0x868A4` / `.msdata` / `MS.b` path before treating it as part of the X-header
algorithm.

## Current conclusion for algorithm recovery

For 350.101, the real-device per-request core native VMP chain for HTTP signed
headers is:

```text
F8 managed program
  -> native binding 0x15281C
  -> 0xD9574
  -> exeVMInner(vmCode=0x1EC670)

  -> native binding 0x152840
  -> 0xD9044 / 0xD952C
  -> returns 0 on device

  -> native binding 0x152864
  -> 0xD95F4
  -> exeVMInner(vmCode=0x1ECAF0)

  -> later 0x16FE10
  -> 0xD9574
  -> exeVMInner(vmCode=0x1EC670)

  -> CF/native material path
  -> 0x12564C -> 0x124DD4
  -> exeVMInner(vmCode=0x1F7860)

F13 managed program
```

Environment fields that must match device before validating recovered C:

```text
runtime object +0x50/+0x51: 0x1503AC OR check, device result = 1
runtime gate byte at 0xD952C / dynamic x23+0x70: device result = 0
MS.b/.msdata/cache path around caller 0x868A4: should avoid extra 0x201800
```

Do not validate final X-header C against plain Unidbg until these environment
differences are normalized.
