# 350.101 deterministic replay baseline

Purpose: make the unidbg native simulation produce byte-stable X-header values for the fixed `s1/s2` test vector, so recovered C code can compare against one stable oracle.

## Fixed inputs

| input | value | reason |
|---|---:|---|
| `metasec.fixedPid` | `12345` | fixes emulator pid/tid; this was the remaining `X-Medusa` drift source |
| `metasec.fixedCurrentTimeMillis` | `1788136882000` | fixes Java/System and syscall realtime |
| `metasec.fixedElapsedRealtime` | `123456789` | fixes Java elapsedRealtime |
| `metasec.fixedElapsedRealtimeNanos` | `123456789000000` | fixes Java elapsedRealtimeNanos and `/dev/alarm` elapsed time |
| `metasec.fixedMonotonicNanos` | `123456789000000` | fixes syscall `clock_gettime(CLOCK_MONOTONIC*)` |
| `metasec.fixedRandomSeed` | `0x350101` | fixes `/dev/urandom`, `getrandom`, libc `rand/srand/lrand48` hook seed |

## Command

```bash
./mvnw -pl unidbg-android -am -DfailIfNoTests=false -Dmaven.test.skip=false '-Dtest=Sign6_350101#testMetasec' \
  -Dmetasec.deterministic=true \
  -Dmetasec.fixedPid=12345 \
  -Dmetasec.fixedCurrentTimeMillis=1788136882000 \
  -Dmetasec.fixedElapsedRealtime=123456789 \
  -Dmetasec.fixedElapsedRealtimeNanos=123456789000000 \
  -Dmetasec.fixedMonotonicNanos=123456789000000 \
  -Dmetasec.fixedRandomSeed=0x350101 \
  -Dmetasec.traceDeterministicRandom=true test
```

Wrapper for day-to-day replay:

```bash
dyidre/versions/350101/run_sign6_350101_deterministic.sh
dyidre/versions/350101/run_sign6_350101_deterministic.sh s1.txt s2.txt
```

The wrapper keeps all deterministic knobs together. With two arguments it only
overrides `s1/s2` via `-Dmetasec.s1File` and `-Dmetasec.s2File`; the APK/version
environment remains the 350.101 baseline.

## Deterministic check

- run1: `unidbg/unidbg-android/target/sign6_350101_det_fixedpid_run1.log`
- run2: `unidbg/unidbg-android/target/sign6_350101_det_fixedpid_run2.log`
- result: all seven emitted headers are identical across two separate Maven/JVM processes.

| header | len | sha1 | same across run1/run2 |
|---|---:|---|---|
| `X-Argus` | `260` | `849d4c9732348c2e1f5d790424f348c1c91a2946` | `True` |
| `X-Gorgon` | `52` | `c99432f3c6831c3042dcc4925087a2133f513e3d` | `True` |
| `X-Helios` | `48` | `cc37d4982a8f16517113bb46114a8c95cc77f711` | `True` |
| `X-Khronos` | `10` | `675a79fb3d8a3507710581fa9527b87860652c3f` | `True` |
| `X-Ladon` | `48` | `007904b16135e458d95aea912e2b12e2a7032bd6` | `True` |
| `X-Medusa` | `948` | `7f39cf9e238f266cb7b548bfc7b16b3aafcac262` | `True` |
| `X-Soter` | `120` | `c8cb4a7e8f18e34468af3c4e72d76fbb34f52115` | `True` |

## Native PRNG evidence

### sign6_350101_det_fixedpid_run1.log

```text
[350101] deterministic=true currentTimeMillis=1788136882000 elapsedRealtime=123456789 elapsedRealtimeNanos=123456789000000 randomSeed=0x350101
[350101] deterministic libc PRNG import hooks registered target=.*libmetasec_ml\.so$ seed=0x350101
[350101] deterministic libc PRNG import hooks refreshed
[350101][metasec-libc-prng] srand => 0x6a94cdb2 (1788136882)
[350101][metasec-libc-prng] rand#0 => 0x1b40103 (28573955)
[350101][metasec-libc-prng] rand#1 => 0x1d458880 (491096192)
[350101][metasec-libc-prng] rand#2 => 0x39324eb9 (959598265)
[350101][metasec-libc-prng] rand#3 => 0xa7e12fe (176034558)
[350101][metasec-libc-prng] rand#4 => 0xfebaa5f (267102815)
[metasec-random] path=/dev/urandom read#0 len=0x1000 seed=0x7572613d4a5f83 first32=7084126e1388878dd6e860a3be07f60057fd4e1abbc86335e959200ff9dba36a
[350101][metasec-libc-prng] rand#5 => 0x79baacac (2042277036)
[350101][metasec-libc-prng] rand#6 => 0x6e201d75 (1847598453)
[350101][metasec-libc-prng] rand#7 => 0x2a24610a (707027210)
[350101][metasec-libc-prng] rand#8 => 0x1eca8d7b (516590971)
```

### sign6_350101_det_fixedpid_run2.log

```text
[350101] deterministic=true currentTimeMillis=1788136882000 elapsedRealtime=123456789 elapsedRealtimeNanos=123456789000000 randomSeed=0x350101
[350101] deterministic libc PRNG import hooks registered target=.*libmetasec_ml\.so$ seed=0x350101
[350101] deterministic libc PRNG import hooks refreshed
[350101][metasec-libc-prng] srand => 0x6a94cdb2 (1788136882)
[350101][metasec-libc-prng] rand#0 => 0x1b40103 (28573955)
[350101][metasec-libc-prng] rand#1 => 0x1d458880 (491096192)
[350101][metasec-libc-prng] rand#2 => 0x39324eb9 (959598265)
[350101][metasec-libc-prng] rand#3 => 0xa7e12fe (176034558)
[350101][metasec-libc-prng] rand#4 => 0xfebaa5f (267102815)
[metasec-random] path=/dev/urandom read#0 len=0x1000 seed=0x7572613d4a5f83 first32=7084126e1388878dd6e860a3be07f60057fd4e1abbc86335e959200ff9dba36a
[350101][metasec-libc-prng] rand#5 => 0x79baacac (2042277036)
[350101][metasec-libc-prng] rand#6 => 0x6e201d75 (1847598453)
[350101][metasec-libc-prng] rand#7 => 0x2a24610a (707027210)
[350101][metasec-libc-prng] rand#8 => 0x1eca8d7b (516590971)
```

## Stable output

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

## X-Medusa raw pack

- raw file: `dyidre/versions/350101/deterministic_350101_x_medusa_raw.bin`
- base64 length: `948`
- raw length: `709`
- raw sha256: `996b8fa532f23c7d3c132ab1b4817ec4f36fa68ef074af627c7a4a03cb29b0b7`
- layout head: `mini20=b7cd946a9f86dba0fbb899298d783a4690a0583c` `const2=acac` `flags=0001aa`

## Diagnosis

Before fixing `metasec.fixedPid`, `/dev/urandom`, libc `rand`, and all logged JNI/syscall inputs were already identical, but `X-Medusa` still changed between two JVM runs. `AbstractEmulator` used the host JVM pid (`ManagementFactory.getRuntimeMXBean().getName()`) as emulated pid. The MetaSec F8/Medusa environment pack observes pid/tid-like state, so different Maven process ids changed the large Medusa subpack. Fixed pid makes Medusa stable.
