# 350.101 fixed s1/s2 C signer

目标：只输入 `s1` 和 `s2`，固定随机/时间/环境值，生成与 deterministic unidbg baseline 一样的 7 个 X-header。

代码入口：

```c
typedef struct MetaSecHeaders350 {
    char x_argus[0x180];
    char x_gorgon[0x40];
    char x_helios[0x40];
    char x_khronos[0x20];
    char x_ladon[0x40];
    char x_medusa[0x400];
    char x_soter[0x100];
} MetaSecHeaders350;

int metasec_build_headers_from_s1_s2_fixed_350101(
    const char *s1,
    const char *s2,
    MetaSecHeaders350 *out);

size_t metasec_build_http_reqsign_text_fixed_350101(
    const char *s1,
    const char *s2,
    char *out,
    size_t out_cap);
```

实现文件：

- `metasec_350101_fixed_signer.c`
- `metasec_350101_recovered_c.h`
- 依赖 `x_headers_algorithms_350101.c` 和底层 `CF/F` recovered C modules。

## 固定环境

这版对应 deterministic unidbg 参数：

```text
fixedPid=12345
fixedCurrentTimeMillis=1788136882000
fixedElapsedRealtime=123456789
fixedElapsedRealtimeNanos=123456789000000
fixedMonotonicNanos=123456789000000
fixedRandomSeed=0x350101
```

核心固定值：

```text
seed/currentTimeSec = 1788136882 = 0x6a94cdb2
rand#0 = 0x01b40103
rand#1 = 0x1d458880
rand#2 = 0x39324eb9
rand#3 = 0x0a7e12fe
rand#4 = 0x0febaa5f
rand#5 = 0x79baacac
rand#6 = 0x6e201d75
rand#7 = 0x2a24610a
rand#8 = 0x1eca8d7b
/dev/urandom first32 = 7084126e1388878dd6e860a3be07f60057fd4e1abbc86335e959200ff9dba36a
```

这些值来自：

- `deterministic_replay_350101.md`
- `unidbg/unidbg-android/target/sign6_350101_deterministic_cf_unicorn2_20260831_092213.log`
- `environment_inputs_350101.md`：按 header 归类哪些值属于环境输入。

## 从 s1/s2 动态提取的材料

`s1`：

- query string：用于 `MD5(query)[:4] -> X-Gorgon`。
- query string：用于 `SM3(query)[:6] -> X-Argus.k14_url_sm3`。
- `aid`：进入 `X-Argus.k4_aid`，也参与 `X-Ladon/X-Helios` 的短文本。
- `device_id`：进入 `X-Argus.k5_device_id`。
- `version_name`：进入 `X-Argus.k7_app_version_name`。

`s2`：

- `x-ss-stub`：16 字节 hex。
- `x-ss-stub` 原始 16 字节进入 `X-Gorgon`。
- `SM3(x-ss-stub)[:6]` 进入 `X-Argus.k13_xssstub_sm3`。

当前固定测试向量：

```text
MD5(query)[:4] = ec8a33e2
SM3(x-ss-stub)[:6] = cf03476f3b96
SM3(query)[:6] = 1f08578a515b
aid = 1128
device_id = 397365608203400
version_name = 35.1.0
```

## Header 生成边界

已用 C 算法还原并参与固定 signer：

| header | 当前 C 路径 |
|---|---|
| `X-Gorgon` | `MD5(query)[:4] + x-ss-stub + seed + gorgon_word -> recovered gorgon transform` |
| `X-Khronos` | `snprintf("%u", fixed_sec)` |
| `X-Ladon` | `"%u-%s-%s" -> CF48/F17 -> CF49 -> CF44` |
| `X-Helios` | 同 `X-Ladon`，换 key/prefix |
| `X-Argus` | `XArgusStruct protobuf -> CF41/SIMON128-256 -> reverse-xor tail -> CF43/AES-CBC -> CF44` |
| `X-Medusa` | fixed-env F8 raw pack -> CF44 |
| `X-Soter` | empty/default pack -> CF44 |

注意：`X-Medusa` 的 final pack/base64 已还原，但完整环境采集仍绑定 deterministic baseline。这里嵌入的是固定环境下的 F8 raw pack，目的就是稳定复现 unidbg 输出。

## 当前 unidbg baseline 输出

```text
X-Argus
gIg4OPu+fDHyJFBL+tgcdzrilcMdNJN9AUlg0kLoL08YXGkNOS3J7Xy2mteu88qUZPA15KQjQPPxauzBaPAQ3U/6dPVja1qHCWL9mvL1G9V7qqjzH3JnZ57Qj9g3U673LGkk4kB+iCUBIB7TeByhNz92jfbl4i1uwK6yInVGtfLAMqoZkhq27SnDWjVnbY/Xt/mljDMWBmSr9ujeM2x0tG+1lAuIpLLkLhlaBxVIoKwAjTJU3aAlFiMQKQJRZtTMFIo=
X-Gorgon
8404a0760800c59a3e796fca0c3941ef51f3bb7e71993d7d6e6a
X-Helios
CmEkKl/keEnDw5US+ehQr8rpMEeOBpoqjJ3PGsWqhENGslC/
X-Khronos
1788136882
X-Ladon
/hJ+ChFIoxjTKVPcg5bj5OFP3hx14whKj3/RgYAkiArUsNHF
X-Medusa
t82Uap+G26D7uJkpjXg6RpCgWDysrAABqnV1HSBqgdQHWAYAOHjN3dBN6M9aFNW8ejQJVUdh4ShuvUjGu0ZJqd/D/WPbOxm7ms7IQSvTFG+cCsHeidLz2/1Jh+79zpNQc7sbaTfuQExAElZCDt2C9tbskkTVXPyr9oIObp8W9CqfAyOh7yGXYKPmXZ4PYzm3win9nxyGmlnFKb+DwmdhnCmgdWgQhtdqifPBBKeIohX4R3IwNfH3wDl+IzBTpQdvjYo7kCcnKKLxM8RFe4mlfKi66E0px0bTChNEQ0a3vEjXV9OEReOkDsnFGppoPFTL0RvxzsUACWugSGd0pY+unk4/WVXQwHGvnwoa0NbyWtx85mYw7uCRnpP5NdGzzYs2JOB8Lc5Inis4P5YFoQsvfxEzgvUIJtwhgG6d11lWFTWsa8Tl1IM/MMk9lFo3DJdjy3CXGcHEAT8IXJkE6Pm3Cd583NJUZRoKrV15dDpyzSjWTRkZhI8gt5rg/EcARLfsTRrLqhcs03+IsfFUMdSB95uaDXYsq/ZlVD5UvvcszDsVL85Hjp0x2k2DX/Uc1PZcRk0vwpxmJ5i1y2UwbDlAiSflPpYnyurUqagCcYoKqiO97b7cGM3aOVEOCMEukYyCwpRD+B1OKu5NDindYqL89womNxrwWsrGf1qfgUFKTCD9BI5h2xwRF4mocb+dUL+V0XPc1rQNbUkSqEbAy8NV5RA+Pecy9WZ8kxsJmfXfef5vIpQGpfn+tXXjdl6LnJpS5lQMlcg1cRwsKYYguZhVqMcD5BeR+y4gYKdWBLiMxChgjiGPqpEFM+EHbx+vgataixQ1NXXEfmf+vCE1SdKY9ASP+LtMYAr6wgQEps/p1T2rLIHILhD7Nb+MH+dIINJjX+swuaUMm3IVGrobwRBE4OCE/NJKmw6VKgDo+i85//ovOfe6eQ==
X-Soter
AAEAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

## 验证命令

```bash
dyidre/versions/350101/run_recovered_c_oracles_350101.sh \
  | tee dyidre/versions/350101/c_recovery_suite_350101_run.log
```

当前结果：

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
