# 350.101 X-header environment inputs

这份清单专门记录：除了 `s1/s2` 之外，哪些环境值会参与 X-header 计算。

当前 `metasec_350101_fixed_signer.c` 的定位是 deterministic baseline 复现：
`s1/s2` 仍然作为输入，但时间、随机、pid、urandom、部分 Medusa 环境 pack
被固定到 unidbg 记录值。因此它能和 unidbg 逐字节一致；要做真实泛化 signer，
这些字段不能忘。

## 总表

| 来源 | 字段/材料 | 影响 header | 当前固定值/观测值 | 证据状态 |
|---|---|---|---|---|
| `s1` URL query | `query` 原文 | `X-Gorgon`, `X-Argus`, `X-Medusa` | 当前 query len `0x2c0` | 已确认 |
| `s1` URL query | `aid` | `X-Argus`, `X-Ladon`, `X-Helios` | `"1128"` | 已确认 |
| `s1` URL query | `device_id` | `X-Argus` | `"397365608203400"` | 已确认 |
| `s1` URL query | `version_name` | `X-Argus` | `"35.1.0"` | 已确认 |
| `s2` headers | `x-ss-stub` | `X-Gorgon`, `X-Argus`, `X-Medusa` | `FDF60E82C1607606E7386BA88D06B4CA` | 已确认 |
| time/syscall/JNI | current seconds | `X-Khronos`, `X-Gorgon`, `X-Ladon`, `X-Helios`, indirect `X-Argus/X-Medusa` | `1788136882 / 0x6a94cdb2` | 已确认 |
| libc PRNG | `rand/srand/lrand48` sequence | `X-Argus`, `X-Ladon`, `X-Helios`, `X-Medusa` | seed `0x350101`, sequence见下 | 已确认 |
| random device | `/dev/urandom`, `getrandom` | mostly `X-Medusa`, also key/prefix material candidates | first32 `7084126e...9dba36a` | 已确认参与稳定性 |
| ELF auxv | `getauxval(AT_RANDOM)` | random/key/env material | deterministic 16 bytes | 已确认被读取 |
| process identity | pid/tid-like | `X-Medusa` | fixed pid `12345` | 已确认影响输出 |
| clock | elapsed realtime / monotonic nanos | `X-Medusa` env pack | `123456789`, `123456789000000` | 已确认被 stub |
| managed/JNI env | `MS.b(...)` 返回项 | `X-Argus`, `X-Medusa`, `X-Soter` | 当前多项 null/空/default | 已确认路径，字段待补全 |
| `.msdata` KV | `MS.b(0x1000022, repo, key)` -> `.msf3_<sha1(key)>` | runtime config / token / env cache | 当前 rootfs 缺文件，多数 miss | 路径已确认，内容待真机补齐 |
| runtime config | `signv5_ctrl`, `d_signv5_ctrl` | HTTP managed 分支选择 | 真机等效 `signv5=1`, `d_signv5=0` | 已确认 |
| runtime gate | `0xD952C` dynamic/global byte | 是否触发 `vmCode=0x1ECAF0` | 真机为 `0` | 已确认 |
| F8 JSON env | `cmr/cmr2/un_h/vpn/kd/fkd/pd/do` | `X-Medusa` | 见 F8 表 | 已确认进入 JSON/env |
| allocator/指针低位 | 临时 MEM_BLOCK body low16 | `X-Gorgon` | `0x76a0` | 当前向量确认 |
| config/registry | algorithm seq / psk / callType | `X-Argus` | `{2,0x1530be,0x1530be}`, `"none"`, `0x2e2` | 已确认 |

## X-Argus 里的环境字段

`X-Argus` 的第一层是 `XArgusStruct` protobuf。当前 fixed signer 中这些字段来自环境或半环境：

| proto field | 名称 | 当前值 | 来源理解 |
|---:|---|---:|---|
| `1` | `k1_sdk_date` | `0x40401252` | SDK/版本常量 |
| `2` | `k2_type` | `2` | sign type/业务类型 |
| `3` | `k3_random_value` | `0x03680206` | 随机/时间派生，当前固定 |
| `4` | `k4_aid` | `"1128"` | `s1` query |
| `5` | `k5_device_id` | `"397365608203400"` | `s1` query |
| `6` | `k6_version_string` | `"1588093228"` | SDK/app 派生版本材料 |
| `7` | `k7_app_version_name` | `"35.1.0"` | `s1` query / app 版本 |
| `8` | `k8_sdk_version_name` | `"v04.09.05-ml-android"` | SDK 常量 |
| `9` | `k9_sdk_version_code` | `0x08120a00` | SDK 常量 |
| `10` | `k10_proto_header` | `08 00 00 00 00 00 00 00` | request/proto header |
| `12` | `k12_khronos` | `0xd5299b64` | 时间/random-like 派生 |
| `13` | `k13_xssstub_sm3` | `cf03476f3b96` | `SM3(x-ss-stub)[:6]` |
| `14` | `k14_url_sm3` | `1f08578a515b` | `SM3(query)[:6]` |
| `15` | `k15_algorithm_seq` | `{2,0x1530be,0x1530be}` | managed/config 序列 |
| `17` | `k17_khronos` | `0xd5299b64` | 同 field 12 |
| `20` | `k20_pskVersion` | `"none"` | `MS.b`/环境缺省 |
| `21` | `k21_callType` | `0x2e2` | request/env 类型 |

然后还有 F5 尾部 pack 的环境材料：

```text
SIMON key32 = 8f7a33b487dd1ee782ffac6ab62be2d286ecd0c87371674bc7cfcc065bef8a7a
prefix9     = 35 b9 4e 32 39 01 cf 07 18
tail mask4  = ff fd d7 a5
suffix2     = 45 1d
AES key16   = f1593376766ea98d34f31b057a9d5be4
AES iv16    = 1fe109a4125283f418de9e051a969e12
final prefix2 = 80 88
```

这些不是从 `s1/s2` 字符串直接读出来的；要做非固定版，必须继续追它们来自
`rand/urandom/AT_RANDOM/MS.b/config` 中的哪一路。

## X-Gorgon 里的环境字段

当前 fixed signer 的模型：

```text
material20 = MD5(query)[:4]
           || x_ss_stub[0:4]
           || 00 00 00 00
           || gorgon_word_le
           || seed_be

raw26 = gorgon_transform(material20, short_code, raw_body_addr_low16)
```

当前环境/非 s1s2 字段：

```text
seed/current seconds = 0x6a94cdb2
gorgon_word          = 0x04090500
short_code           = 0x0008
raw_body_addr_low16  = 0x76a0
```

特别注意 `raw_body_addr_low16`：这是当前向量里的临时 MEM_BLOCK body 地址低
16 位。离线泛化时有两条路：

1. 固定 allocator，使低 16 位稳定；
2. 继续分析是否有可替代的业务字段来源，避免把真实指针低位当随机常量。

## X-Ladon / X-Helios 里的环境字段

两者同族：

```text
formatted = "%u-%s-%s" % (seed, version_string, aid)
formatted -> CF48/F17 -> CF49(prefix4) -> CF44(base64)
```

当前固定值：

```text
seed           = 1788136882
version_string = "1588093228"
aid            = "1128"

X-Ladon key32  = "3d7bd3017d7fa2125facd70112519853"
X-Ladon prefix = fe 12 7e 0a

X-Helios key32 = "aa5b88836c84dba78db6e0970ce33a85"
X-Helios prefix= 0a 61 24 2a
```

`aid` 来自 `s1`；`seed/version_string/key32/prefix4` 属于环境/版本/随机材料。

## MS.b / .msdata / runtime 分支

350.101 里 `MS.b(0x10003)` 只是返回 `.msdata` 根目录：

```text
/data/user/0/com.ss.android.ugc.aweme/files/.msdata
```

真正的 KV 读取是 `MS.b(0x1000022, repo, key)`：

```text
repo = d8b674543fc0b023b69f6a3f5a0f287d458ea204
file = .msf3_<sha1(key)>
path = <rootfs>/data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk/ml/<file>
return = hex(raw file bytes)
```

当前 350.101 单请求实际命中的 key：

| key | 文件名 |
|---|---|
| `1128-0-167774bf518c11948aa0784351ccf5a9` | `.msf3_6fcd8907538d237434167eb88c22ce2492e97161` |
| `1128-0-sdi` | `.msf3_18942e0a8835406640db421a854dc5eeb5cb2026` |
| `de9ecbeeb513c97d0be52260179ef0e8` | `.msf3_a2c1fbad8731da75423eb57599985db945e7c6da` |
| `ptmr` | `.msf3_2d380627968775a593c3e8b8d72b10a47c3cddbe`，当前 Pixel6 目录未见 |

同步 Pixel6 350.101 真机 `.msdata/mssdk/ml` 到 Unidbg rootfs 后，前三个
KV 已命中，`ptmr` 仍 miss。runtime 分支仍建议用显式开关归一化：

```bash
-Dmetasec.alignTrueDeviceHttpRuntime=true
```

它等价于当前真机 HTTP 请求窗口里的状态：

```text
runtimeObj+0x50 signv5_ctrl   = 1
runtimeObj+0x51 d_signv5_ctrl = 0
0xD952C runtime gate byte     = 0
```

归一化后，核心 native VMP 链已经贴近真机：

```text
0x1EC670 x2
0x1ECAF0 x1
0x1F7860 x1
```

未同步真机 `.msdata` 时，多出的 `0x201800 x1` 来自
`0x868A4 -> 0x12AC9C -> exeVMInner` 的 `.msdata/cache/env` 路径。同步
Pixel6 350.101 rootfs 后，单请求 `0x201800` 已消失：

```text
log: unidbg/unidbg-android/target/sign6_350101_rootfs_pixel6_20260831_133047.log
exeVMInner.vmCode={0x1ec670=2, 0x1ecaf0=1, 0x1f7860=1}
exeVMInner.lr={0xd95cc=2, 0xd964c=1, 0x124e34=1}
```

剩余的 `ptmr` / `.msp_*` / `.mss_*` / `.msfs_*` 探测先记为环境差异候选；
如果最终 X-header 值还有偏差，再回头追这些文件的成功/失败语义。

## X-Medusa 里的环境字段

`X-Medusa` 是环境依赖最重的一个。当前 confirmed：

- pid/tid 会影响输出。之前不固定 pid 时，两次 JVM/unidbg 运行只有
  `X-Medusa` 漂移；固定 `pid=12345` 后稳定。
- `/dev/urandom` / `getrandom` / `AT_RANDOM` 被读取。
- elapsed realtime / monotonic nanos 需要固定。
- F8 会写入 JSON/env number：

| order | key | 当前值 |
|---:|---|---:|
| 1 | `cmr` | `16777216` |
| 2 | `cmr2` | `16777216` |
| 3 | `un_h` | `4133029968` |
| 4 | `vpn` | `0` |
| 5 | `kd` | `0` |
| 6 | `fkd` | `1704349507` |
| 7 | `pd` | `-1663556466` |
| 8 | `do` | `0` |

这些字段不是 final pack 里的明文 u32/u64/double；它们进入 JSON/env 后又经过
F8/F12/source-work/bit-pack/mini-xor 等变换。当前 fixed signer 直接嵌入的是
fixed-env F8 raw pack：

```text
raw length = 709
raw sha256 = 996b8fa532f23c7d3c132ab1b4817ec4f36fa68ef074af627c7a4a03cb29b0b7
```

所以 `X-Medusa` 是 fixed baseline 复现，不是完整动态环境采集。

## X-Soter 里的环境字段

当前 unidbg 样本是 empty/default pack：

```text
00 01 00 02 || zero86
```

所以 fixed signer 里不需要额外环境。但真机或后续版本如果 `MS.b` / `.msdata`
返回非空，`X-Soter` 可能不再全零。

## 当前 fixed signer 需要保持的原则

1. `s1/s2` 只负责请求材料：query、aid、device_id、version_name、x-ss-stub。
2. 时间、随机、pid、urandom、AT_RANDOM、elapsed/monotonic 都必须作为环境输入层管理。
3. 不要把 fixed baseline 里的随机/环境值误认为版本常量。
4. 后续升级版本先对比：
   - `X-Argus` protobuf fields 是否字段号不变；
   - F5 尾部 key/prefix/mask 是否只变值不变算法；
   - F8 `CF79` key set 是否仍是 `cmr/cmr2/un_h/vpn/kd/fkd/pd/do`；
   - `X-Medusa` raw pack 长度、头部、hash 是否随环境变化。
