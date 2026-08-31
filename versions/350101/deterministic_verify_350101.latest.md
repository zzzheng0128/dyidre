# 350.101 deterministic unidbg verification

- run1: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_deterministic_verify_run1.log`
- run2: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_deterministic_verify_run2.log`
- all headers stable: `True`

## Header stability

| header | len | sha1 | same |
|---|---:|---|---|
| `X-Argus` | `260` | `849d4c9732348c2e1f5d790424f348c1c91a2946` | `True` |
| `X-Gorgon` | `52` | `c99432f3c6831c3042dcc4925087a2133f513e3d` | `True` |
| `X-Helios` | `48` | `cc37d4982a8f16517113bb46114a8c95cc77f711` | `True` |
| `X-Khronos` | `10` | `675a79fb3d8a3507710581fa9527b87860652c3f` | `True` |
| `X-Ladon` | `48` | `007904b16135e458d95aea912e2b12e2a7032bd6` | `True` |
| `X-Medusa` | `948` | `7f39cf9e238f266cb7b548bfc7b16b3aafcac262` | `True` |
| `X-Soter` | `120` | `c8cb4a7e8f18e34468af3c4e72d76fbb34f52115` | `True` |

## Random/PRNG trace

### sign6_350101_deterministic_verify_run1.log

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

### sign6_350101_deterministic_verify_run2.log

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

## Stable X-Medusa

- length: `948`
- sha1: `7f39cf9e238f266cb7b548bfc7b16b3aafcac262`
