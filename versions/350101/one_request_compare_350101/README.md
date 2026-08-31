# 350.101 one-request `exeVMInner` count compare

Date: 2026-08-31

Purpose: compare one true-device HTTP signing call with unidbg using the same captured `s1/s2`.

## Artifacts

- True-device counter script: `dyidre/probes/350101/metasec_probe_350101.js mode=counter-one`
- True-device latest JSON: `dyidre/versions/350101/true_device_one_request_count_350101_latest.json`
- Captured true input:
  - `true_s1.txt`
  - `true_s2.txt`
- unidbg log using the same `s1/s2`:
  - `unidbg/unidbg-android/target/sign6_350101_one_req_count_trueinput_20260831_115749.main.log`

## True device result

Captured outer callback:

```text
http callback: libmetasec_ml.so + 0x14DBF4
s1 len: 160
s1 fnv1a: 0xee81bf8e
s2 len: 1277
s2 fnv1a: 0x758aefd4
```

The request was:

```text
https://log0-misc-lf.amemv.com/service/2/app_log/?version_code=350100&device_platform=android&device_id=4087336283154583&aid=1128&iid=3313280560987770&tt_data=a
```

Count inside this outer HTTP callback / inner `0x149CA8` window:

```text
http_entry_149ca8                 1
nativeStage1_14a1ac               1
nativeStage2_14a1fc               1
managedF8_14a4e0                  1
managedF13_14a588                 1
nativeVmpSelectMaterial_12564c    1
nativeVmpBuildMaterial_124dd4     1
exeVMInner_4cc10                  4
```

`exeVMInner` program histogram:

```text
0x1ec670    2
0x1ecaf0    1
0x1f7860    1
```

`exeVMInner` caller/LR histogram:

```text
0xd95cc     2
0xd964c     1
0x124e34    1
```

## unidbg result with same `s1/s2`

Count for one `signByCallback()`:

```text
http_entry_149ca8                 1
nativeStage1_14a1ac               1
nativeStage2_14a1fc               1
managedF5_14a38c                  1
managedF7_14a3ec                  1
managedF8_14a4e0                  1
managedF13_14a588                 1
nativeVmpSelectMaterial_12564c    2
nativeVmpBuildMaterial_124dd4     2
exeVMInner_4cc10                  5
```

`exeVMInner` program histogram:

```text
0x201800    1
0x1f7860    2
0x1ec670    2
```

`exeVMInner` caller/LR histogram:

```text
0x12acf8    1
0x124e34    2
0xd95cc     2
```

## Current conclusion

The counts are not identical yet.

For the captured app-log request, true device does not enter the `F5/F7` callsites we track and runs:

```text
exeVMInner = 4
```

unidbg, even with the same `s1/s2`, still runs:

```text
exeVMInner = 5
F5 = 1
F7 = 1
```

The concrete mismatches are:

1. unidbg has one extra `vmCode=0x201800` call from LR `0x12acf8`;
2. unidbg calls `vmCode=0x1f7860` twice, true device calls it once inside this HTTP callback;
3. unidbg goes through `managedF5_14a38c` and `managedF7_14a3ec`, true device app-log request does not.

Next useful probe: dump the branch conditions around `0x14A35x..0x14A4xx` and `0x12ACxx` on both sides. The first likely decides whether F5/F7 are needed; the second explains the extra `0x201800` VM program in unidbg.
