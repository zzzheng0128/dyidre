# 350.101 C 代码还原基线

这份基线把已经证实的 managed VM / CF 语义收拢成可编译 C 代码。

它的边界要说清楚：这里完成的是 **核心算法和 VM helper 语义的 C 还原**，
不是伪造一个脱离 App/JNI/TreeMap 运行环境的完整在线 signer。外层
`buildSignedHttpHeadersInner_350` 仍依赖运行时对象、引用计数、输入树和
`MS.b`/环境项，因此保留为可读伪 C；已经被 runtime vector 咬死的 CF/F
算法都落成 standalone oracle。

## 一键自测

```bash
dyidre/versions/350101/run_recovered_c_oracles_350101.sh
```

这个脚本会：

1. 分别编译并运行每个 standalone oracle；
2. 用 `METASEC_350101_NO_MAIN` 把它们编译成对象文件；
3. 链接 `metasec_350101_recovered_c_suite.c`，确认这些 C 模块可以作为库一起使用；
4. 链接 `metasec_350101_fixed_signer.c`，用固定随机/时间/环境，只输入 `s1/s2` 复现 deterministic unidbg 的完整 X-header 输出。

## 已落成的 C 模块

| 文件 | 对应 VM/CF | 业务位置 | 验证状态 |
|---|---|---|---|
| `cf61_sm3_recovered_350101.c` | CF61 + F15 IV | query / x-ss-stub / pack digest | 4 组 runtime vector，`failures=0` |
| `cf48_f17_recovered_350101.c` | CF48/F17 + CF49 + CF44 | X-Ladon / X-Helios 短头 | F7/F13 两组 runtime vector，`failures=0` |
| `cf41_simon128_256_recovered_350101.c` | CF41 + F16 | X-Argus tail 加密块 | `0x92 -> 0xa0` runtime vector，`failures=0` |
| `cf43_aes128_cbc_recovered_350101.c` | CF43 type1 | X-Argus tail AES 分支 | body/key/iv/out/final pack，`failures=0` |
| `f8_medusa_mini_xor_recovered_350101.c` | F8 ST8 mini mutation | X-Medusa mini 20 bytes | 2 组 runtime vector，`failures=0` |
| `f12_medusa_subpack_recovered_350101.c` | F12 ST64 bit-pack | X-Medusa sub-work | 31 条 old/new qword，`failures=0` |
| `f20_f21_medusa_source_transform_recovered.c` | F18/F19/F20/F21 families | F12 source-work 上游 | 被 `source_work_vector_selfcheck_350101.c` 回归 |
| `source_work_vector_selfcheck_350101.c` | source-work 四族向量 | X-Medusa nested transform | F22/F23、F31/F32、F39/F40、F47/F48，`failures=0` |
| `x_headers_algorithms_350101.c` | header-level wrapper | X-Gorgon / Khronos / Ladon / Helios / Argus / Medusa / Soter | X-header suite，`failures=0` |
| `metasec_350101_fixed_signer.c` | fixed-env signer | `s1/s2 -> X-*` | deterministic unidbg baseline，`failures=0` |

## 公共接口

公共声明集中在：

```text
dyidre/versions/350101/metasec_350101_recovered_c.h
```

目前稳定接口包括：

```c
metasec_cf61_sm3_oneshot_350(...);
cf48_transform_text_key32_350101(...);
cf49_pack_prefix4_transform32_350101(...);
cf44_base64_encode_350101(...);
metasec_cf41_simon128_256_pkcs7_encrypt_350101(...);
metasec_cf43_aes128_cbc_pkcs7_encrypt_350101(...);
medusa_f8_mutate_mini_xor_u32_350101(...);
medusa_f12_mutate_sub_prefix_350(...);
metasec_350101_source_work_vector_selfcheck();
metasec_build_x_gorgon_value_350101(...);
metasec_build_x_khronos_value_350101(...);
metasec_build_x_ladon_value_350101(...);
metasec_build_x_helios_value_350101(...);
metasec_build_x_argus_plain_350101(...);
metasec_build_x_argus_tail_value_350101(...);
metasec_build_x_medusa_value_from_pack_350101(...);
metasec_build_x_soter_empty_value_350101(...);
metasec_build_headers_from_s1_s2_fixed_350101(...);
metasec_build_http_reqsign_text_fixed_350101(...);
```

## 请求到签名成功的还原状态

`0x149CA8 buildSignedHttpHeadersInner_350` 当前可以按下面的层级理解：

```text
HTTP 参数 / TREE_MAP
  -> native stage1/stage2
  -> managed F5  -> CF61/CF41/CF42/CF43/CF44/CF98 -> X-Argus
  -> managed F7  -> CF48/CF49/CF44/CF98           -> X-Ladon
  -> managed F8  -> CF61/F12/source-work/F8 mini  -> X-Medusa
  -> managed F13 -> CF48/CF49/CF44/CF98           -> X-Helios
  -> direct/side paths                            -> X-Gorgon/X-Khronos/X-Soter
```

已经能用 C byte-exact 表达的是右侧的算法/pack 层；左侧的 Android runtime
对象层仍以 `build_signed_http_headers_350_recovered.c` 和结构体快照记录。

当前 X-header 级自测输出：

```text
X-Gorgon match=true len=0x34
X-Khronos match=true len=0xa
X-Ladon match=true len=0x30
X-Helios match=true len=0x30
X-Argus protobuf plain match=true len=0x92
X-Argus CF41 SIMON match=true len=0xa0
X-Argus reverse-xor mask match=true len=0x4
X-Argus mutated tailA8 match=true len=0xa8
X-Argus full-from-plain match=true len=0x104
X-Argus tail match=true len=0x104
X-Medusa final-pack match=true len=0x3b8
X-Soter empty-pack match=true len=0x78
x-header algorithm failures=0
```

`X-Argus` 的边界：protobuf 明文字段、CF41/SIMON、F5 `reverse_xor`
work-area 改写、CF43/AES/base64 tail 都已经完成。当前 full-from-plain API
仍要求调用方提供动态材料，例如 random、khronos、SM3 摘要、SIMON key、
AES key/iv、tail mask seed/mask。

固定环境完整 signer 自测输出：

```text
X-Argus match=true len=0x104
X-Gorgon match=true len=0x34
X-Helios match=true len=0x30
X-Khronos match=true len=0xa
X-Ladon match=true len=0x30
X-Medusa match=true len=0x3b4
X-Soter match=true len=0x78
http_reqsign text len=0x620
fixed s1/s2 signer failures=0
```

这里的边界更进一步：`s1/s2` 里会动态取 query、`aid`、`device_id`、
`version_name`、`x-ss-stub`；时间、随机、pid、urandom、F8 raw pack 固定到
`deterministic_replay_350101.md` 的 baseline，因此输出能逐字节对齐 unidbg。

## 后续版本升级用法

升级到新 `libmetasec_ml.so` 时先做三步：

1. 用 `metasec-so-recognizer` 对齐入口、F 表、CF 表；
2. dump 新版本同类 runtime vector；
3. 把新 vector 喂给这套 C baseline。

如果这套 C 代码仍然 `failures=0`，说明算法没变，只需要更新入口/结构偏移。
如果某个 oracle 失败，就从对应 CF/F 程序开始 diff，不要从整个 HTTP 函数重新拆。
