# 350.101 req01 X-Medusa value-diff / fixedPid conclusion

## Conclusion

The true-device vs Unidbg managed VM semantic path is already aligned. The
remaining `X-Medusa` drift is value-level, not a CF/VM branch mismatch.

The missing deterministic input for the current req01 replay was process
identity:

```text
metasec.fixedPid=12345
metasec.deterministic=true
metasec.fixedMonotonicNanos=123456789000000
```

Without a fixed emulated pid, Unidbg uses the host JVM pid. F8/X-Medusa observes
pid/tid-like state, so separate JVM runs change the large Medusa pack even when
time, random seed, `.msdata`, and rootfs are fixed.

## Baseline request

```text
s1 = dyidre/versions/350101/multi_request_compare_350101/true_req_01_s1.txt
s2 = dyidre/versions/350101/multi_request_compare_350101/true_req_01_s2.txt
rootfs = unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930
currentTimeMillis = 1788159560000
elapsedRealtime = 123456789
elapsedRealtimeNanos = 123456789000000
fixedMonotonicNanos = 123456789000000
randomSeed = 0x350101
fixedPid = 12345
```

## What was compared

Previous semantic-path comparison:

```text
managed_native_blr_15454c = 311
prefix_match = 311
first_diff = none
X-Khronos = 1788159560
```

Raw PC traces still have helper-level differences such as malloc/new/shared-ref
helpers, but `no_resync=0`; they resynchronize and do not indicate the managed
VM branch ran away.

## New X-Medusa watch

`Sign6MetaSecBase` now has a focused watch:

```text
-Dmetasec.watchXMedusaValue=true
-Dmetasec.xMedusaWatchMaxEvents=2
-Dmetasec.xMedusaWatchMaxBytes=0x100
```

It hooks:

```text
0x14A4E0  F8 enter: save full pack + out_key/out_value char**
0x14A53C  before treeMapPut(X-Medusa): dump emitted MEM_BLOCK
```

Output format:

```text
[xmedusa-watch] lastF8.out_value.decoded base64_len=... decoded_len=... sha1=... b18=... first64=...
[xmedusa-watch] emit.value.decoded       base64_len=... decoded_len=... sha1=... b18=... first64=...
```

This proves whether the difference is already present at F8 return or introduced
later by `treeMapPut` / output-map emission.

## Evidence before fixing pid

Three fixed-time/rootfs/random runs, without `fixedPid`, produced different
`X-Medusa` decoded values:

| log | decoded len | decoded sha1 prefix | `decoded[0x18]` |
|---|---:|---|---:|
| `sign6_350101_f8_value_watch_20260831_212144.log` | `737` | `4030b6d96c784141` | `0xe5` |
| `sign6_350101_xmedusa_watch_req01_20260831.log` | `737` | `782922a4d50c64e0` | `0x35` |
| `sign6_350101_xmedusa_watch_req01_20260831_v2.log` | `737` | `59c8426cc127b353` | `0x14` |

The first 0x18 bytes match; the first drift begins exactly at offset `0x18`.
That shape matches an environment/process-identity field entering the F8 raw
pack, not a wrong VM opcode implementation.

## Evidence after fixing pid

Two separate JVM runs with `fixedPid=12345` are byte-identical:

| log | X-Medusa b64 len | X-Medusa b64 sha1 prefix | decoded len | decoded sha1 prefix | `decoded[0x18]` |
|---|---:|---|---:|---|---:|
| `sign6_350101_xmedusa_fixedpid_req01_run1_20260831.log` | `984` | `e8e43d39b7ea0bb7` | `737` | `a701f794f3a9d14e` | `0x10` |
| `sign6_350101_xmedusa_fixedpid_req01_run2_20260831.log` | `984` | `e8e43d39b7ea0bb7` | `737` | `a701f794f3a9d14e` | `0x10` |

All emitted headers are stable across the two runs:

| header | same |
|---|---|
| `X-Gorgon` | true |
| `X-Khronos` | true |
| `X-Argus` | true |
| `X-Ladon` | true |
| `X-Medusa` | true |
| `X-Helios` | true |
| `X-Soter` | true |

Important watch lines:

```text
[xmedusa-watch] F8.enter pack=0xe4ffea70 seed=0x6a952648 type=369 mode=0 final=1 out_key_ptr_ptr=0xe4ffe998 out_value_ptr_ptr=0xe4ffe990
[xmedusa-watch] lastF8.out_value.decoded base64_len=0x3d8 decoded_len=0x2e1 sha1=a701f794f3a9d14e15764b0e83466975dfea64bc b18=0x10
[xmedusa-watch] emit.value.decoded       base64_len=0x3d8 decoded_len=0x2e1 sha1=a701f794f3a9d14e15764b0e83466975dfea64bc b18=0x10
```

`lastF8.out_value` and `emit.value` are identical. So if a later true-device
comparison still differs, the divergence is inside F8 input/environment pack,
not the header emit step.

## Upgrade checklist

For future versions, always keep these fixed together before comparing
X-Medusa:

```text
-Dmetasec.deterministic=true
-Dmetasec.fixedPid=<captured-or-baseline-pid>
-Dmetasec.fixedCurrentTimeMillis=<fixed>
-Dmetasec.fixedElapsedRealtime=<fixed>
-Dmetasec.fixedElapsedRealtimeNanos=<fixed>
-Dmetasec.fixedMonotonicNanos=<fixed>
-Dmetasec.fixedRandomSeed=<fixed>
-Dmetasec.rootfs=<synced-rootfs-with-.msdata>
```

If matching a real device request byte-for-byte, use the true device's
pid/tid-like values as the Unidbg fixed pid baseline, or treat `fixedPid=12345`
as a deterministic harness baseline and do not expect live-device X-Medusa to
equal it byte-for-byte.

Current true-device multi-request JSON is path-level only for this question:

```text
dyidre/versions/350101/multi_request_compare_350101/true_device_metamulti_8req_20260831_121946.json
```

It records `tid=19771` for the completed requests, but not the process pid and
not the final `X-Medusa` value. For a byte-exact true-device replay, the true
script should additionally log:

```text
pid/tid-like values
F8 out_key/out_value
0x14A53C X-Medusa value decoded_len/sha1/decoded[0x18]/first64
```
