# 350101 req01 app_log s1/s2 真机同步基准
## 结论
同一组真机 `s1/s2` 已喂给 Unidbg；开启 `alignTrueDeviceHttpRuntime=true` 后，单请求调用次数与真机对齐。
关键点：不加 `alignTrueDeviceHttpRuntime=true` 时会少一次 `exeVMInner(0x1ecaf0, lr=0xd964c)`；加上后恢复到真机路径。
## 输入向量
- s1: `/Users/freeman/project/douyin/dyidre/versions/350101/true_request_vectors/req01_app_log_true_s1.txt`
- s2: `/Users/freeman/project/douyin/dyidre/versions/350101/true_request_vectors/req01_app_log_true_s2.txt`
- s1 len/fnv: `160` / `0xee81bf8e`
- s2 len/fnv: `1277` / `0x758aefd4`
- x-ss-req-ticket: `1788148652047`
- x-ss-stub: `55B07E238D109942CF70C9B46FA98D6E`

## 固定环境
- `rootfs` = `unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930`
- `backend` = `unicorn2`
- `fixedPid` = `13556`
- `fixedTid` = `13710`
- `fixedCurrentTimeMillis` = `1788148652047`
- `fixedElapsedRealtime` = `183397757`
- `fixedElapsedRealtimeNanos` = `183397757386512`
- `fixedMonotonicNanos` = `183397708672197`
- `fixedBoottimeNanos` = `183397757386512`
- `fixedRandomSeed` = `0x350101`
- `alignTrueDeviceHttpRuntime` = `True`

## 真机 vs Unidbg 计数
| item | true | unidbg |
|---|---:|---:|
| `exeVMInner_4cc10` | 4 | 4 |
| `http_entry_149ca8` | 1 | 1 |
| `managedF13_14a588` | 1 | 1 |
| `managedF8_14a4e0` | 1 | 1 |
| `nativeStage1_14a1ac` | 1 | 1 |
| `nativeStage2_14a1fc` | 1 | 1 |
| `nativeVmpBuildMaterial_124dd4` | 1 | 1 |
| `nativeVmpSelectMaterial_12564c` | 1 | 1 |

## exeVMInner vmCode
| vmCode | true | unidbg |
|---|---:|---:|
| `0x1ec670` | 2 | 2 |
| `0x1ecaf0` | 1 | 1 |
| `0x1f7860` | 1 | 1 |

## exeVMInner LR
| LR | true | unidbg |
|---|---:|---:|
| `0x124e34` | 1 | 1 |
| `0xd95cc` | 2 | 2 |
| `0xd964c` | 1 | 1 |

## Unidbg 输出头部摘要
| header | len | sha1 | preview |
|---|---:|---|---|
| `X-Argus` | 8 | `d397ef0bebcd16a35fc32eb319041bac56807695` | `rPuUag==` |
| `X-Gorgon` | 52 | `9092fe5eafa102a6b390022ce11b2de2a7b909f8` | `8404607d0800498ff92b00819e77aaf662ba8280638401a36e57` |
| `X-Helios` | 48 | `38e18aebdaaa35c896622f419e284812e8fed090` | `mCYsIdWAgnGmqmfExII45WeIXpbRiE21VGwlubqQHfEAtdKz` |
| `X-Khronos` | 10 | `a160d77301a3d4e31116f5f8ba8cf4ff9ceb15ae` | `1788148652` |
| `X-Ladon` | 8 | `d2cb4c05547d2fef883e264a952331b448a2bae3` | `apT7rA==` |
| `X-Medusa` | 984 | `19fca4739bbe2d013545839141ec67466c8c3031` | `qfuUaoGw26Dljpkpk046Ro6WWDwKyAABPDVbaChKgQ8JGCyRnyXcqq43gHwQF12FYdyppvlIRtW+olBCpiAB/BS7nY8RcpnOI2EVKpK8JlCnw75qQFO83EYs...` |
| `X-Soter` | 120 | `c8cb4a7e8f18e34468af3c4e72d76fbb34f52115` | `AAEAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA` |

## X-Medusa 解码摘要
- `base64_len` = `984`
- `decoded_len` = `737`
- `decoded_sha1` = `7a450688cbb6702500ff4d553f1518493fed789d`
- `decoded_b18` = `0x3c`
- `decoded_first64_hex` = `a9 fb 94 6a 81 b0 db a0 e5 8e 99 29 93 4e 3a 46 8e 96 58 3c 0a c8 00 01 3c 35 5b 68 28 4a 81 0f 09 18 2c 91 9f 25 dc aa ae 37 80 7c 10 17 5d 85 61 dc a9 a6 f9 48 46 d5 be a2 50 42 a6 20 01 fc`

## 日志
- aligned dump: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_true_req01_app_log_aligned_dump_unicorn2_20260831.log`
- aligned summary JSON: `/Users/freeman/project/douyin/dyidre/versions/350101/true_request_vectors/req01_app_log_unidbg_aligned_summary.json`

## 后续使用
以后还原/升级版本时，用这组向量和环境先校验路径：`exeVMInner` 必须是 `0x1ec670 * 2 + 0x1ecaf0 + 0x1f7860`，LR 必须是 `0xd95cc * 2 + 0xd964c + 0x124e34`。
