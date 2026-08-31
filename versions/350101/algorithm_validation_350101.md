# 350.101 X-header algorithm validation

这份记录只回答一个问题：当前 C 还原是不是算法真的对，而不是碰巧把最终字符串写死。

结论先放前面：

- `X-Gorgon`、`X-Khronos`、`X-Ladon`、`X-Helios`、`X-Argus`、当前 empty/default `X-Soter`：算法链条已经闭环。
- `X-Medusa`：final pack 到 base64 已闭环；完整环境采集/JSON/source pack 的动态生成还没有完全泛化，目前 fixed signer 嵌入 deterministic raw pack。
- `metasec_350101_fixed_signer.c` 不是简单返回硬编码 header。除了 `X-Medusa` fixed raw pack，它会重新计算 query MD5、SM3、protobuf、SIMON、reverse-xor、AES、base64 等步骤。

## 验收时间

```text
2026-08-31 09:47 Asia/Shanghai
```

## 1. C primitive / helper oracle

命令：

```bash
dyidre/versions/350101/run_recovered_c_oracles_350101.sh \
  | tee dyidre/versions/350101/c_recovery_suite_350101_validation_latest.log
```

结果日志：

```text
dyidre/versions/350101/c_recovery_suite_350101_validation_latest.log
```

关键结果：

```text
query/F5+F8 len=0x2c0 match=true
x-ss-stub/F5 len=0x10 match=true
pack44/F5 len=0x44 match=true
pack44/F8 len=0x44 match=true
failures=0

F7/X-Ladon ... out_match=true b64_match=true
F13/X-Helios ... out_match=true b64_match=true
failures=0

actual_fnv=29b26846 expected_fnv=29b26846 match=true
cf41 SIMON128/256 oracle failures=0

cf43 AES-128-CBC oracle failures=0

watch/ST8 ... match=true
rawCF/final-pack ... match=true
failures=0

idx=00..30 F12 bit-pack all match=true
failures=0

source_work_vector_selfcheck failures=0
```

覆盖的算法层：

| 模块 | 验证内容 | 结论 |
|---|---|---|
| `CF61` | SM3 标准/运行时向量 | 对 |
| `CF48/F17` | 短头 transform，覆盖 Ladon/Helios | 对 |
| `CF41/F16` | SIMON128/256 + PKCS#7，`0x92 -> 0xa0` | 对 |
| `CF43` | AES-128-CBC + PKCS#7 | 对 |
| `CF44` | base64 | 对 |
| `F8 mini` | 20-byte mini XOR | 对 |
| `F12` | subpack bit-pack 31 条 ST64 | 对 |
| `source-work` | F18/F19/F20/F21 四族上游 transform | 对 |

## 2. Header-level C oracle

同一条脚本里会跑 `x_headers_algorithms_350101.c`。

结果：

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

这层证明的不是单个最终字符串，而是各 header 的组合链条：

```text
X-Gorgon:
  MD5/query digest + x-ss-stub + seed -> gorgon transform -> hex

X-Ladon / X-Helios:
  "%u-%s-%s" -> CF48/F17 -> CF49(prefix||body) -> CF44

X-Argus:
  XArgusStruct protobuf -> CF41/SIMON
  -> reverse-xor tail -> CF43/AES-CBC -> CF44

X-Medusa:
  final raw pack -> CF44

X-Soter:
  empty/default pack -> CF44
```

## 3. Fixed s1/s2 signer oracle

固定环境 signer：

```text
dyidre/versions/350101/metasec_350101_fixed_signer.c
```

结果：

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

这里证明：

- 输入只给 `s1/s2`。
- C 会从 `s1` 提取 query、`aid`、`device_id`、`version_name`。
- C 会从 `s2` 提取 `x-ss-stub`。
- C 会重新算 `MD5(query)`、`SM3(query)`、`SM3(x-ss-stub)`。
- C 会重新跑 Argus 的 protobuf、SIMON、AES、base64。
- 最终完整文本长度 `0x620`。

## 4. unidbg 真 SO deterministic replay

命令：

```bash
cd unidbg
./mvnw -pl unidbg-android -am \
  -DfailIfNoTests=false \
  -Dmaven.test.skip=false \
  '-Dtest=Sign6_350101#testMetasec' \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.deterministic=true \
  -Dmetasec.fixedPid=12345 \
  -Dmetasec.fixedCurrentTimeMillis=1788136882000 \
  -Dmetasec.fixedElapsedRealtime=123456789 \
  -Dmetasec.fixedElapsedRealtimeNanos=123456789000000 \
  -Dmetasec.fixedMonotonicNanos=123456789000000 \
  -Dmetasec.fixedRandomSeed=0x350101 \
  -Dmetasec.traceDeterministicRandom=true \
  test
```

结果日志：

```text
unidbg/unidbg-android/target/sign6_350101_algorithm_validation_20260831.log
```

unidbg 结果：

```text
Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

## 5. C fixed signer vs unidbg output

从 `sign6_350101_algorithm_validation_20260831.log` 抽取最终返回的 7 个
header，与 C fixed signer baseline 常量逐项比对：

| header | match | len | sha1 |
|---|---:|---:|---|
| `X-Argus` | true | 260 | `849d4c9732348c2e1f5d790424f348c1c91a2946` |
| `X-Gorgon` | true | 52 | `c99432f3c6831c3042dcc4925087a2133f513e3d` |
| `X-Helios` | true | 48 | `cc37d4982a8f16517113bb46114a8c95cc77f711` |
| `X-Khronos` | true | 10 | `675a79fb3d8a3507710581fa9527b87860652c3f` |
| `X-Ladon` | true | 48 | `007904b16135e458d95aea912e2b12e2a7032bd6` |
| `X-Medusa` | true | 948 | `7f39cf9e238f266cb7b548bfc7b16b3aafcac262` |
| `X-Soter` | true | 120 | `c8cb4a7e8f18e34468af3c4e72d76fbb34f52115` |

```text
failures=0
```

unidbg 原始返回文本长度：

```text
0x620 bytes, 14 CRLF
```

C fixed signer 返回文本长度：

```text
0x620 bytes
```

## 判定

当前可以认为“算法对”的部分：

```text
X-Gorgon transform
X-Khronos
X-Ladon / X-Helios short-header transform
X-Argus protobuf + SIMON + reverse-xor + AES + base64
X-Soter empty/default pack
X-Medusa final raw pack -> base64
F8 mini xor
F12 bit-pack
source-work 四族 transform
```

还不能说“完全动态环境算法已对”的部分：

```text
X-Medusa raw pack 的完整环境采集与序列化
X-Argus key/prefix/mask/suffix 的动态来源
X-Gorgon raw_body_addr_low16 的泛化来源
X-Soter 非 empty 环境字段
MS.b / .msdata 非空场景
```

也就是说，当前 fixed baseline 的算法验证是闭环的；下一阶段如果要做泛化，
不要重拆已验证的加密/编码算法，优先追环境材料的动态来源。
