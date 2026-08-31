# 350.101 CF61 / SM3 recovery

结论：`CF61 @ 0x16F998` 是 managed slot 适配层，实际下层为标准 SM3
one-shot。

## 地址命名

```text
0x16F998  cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350
0x16D520  sm3OneShot_F15InitUpdateFinal_350
0x171794  managedSignDigestStateInitF15_350
0x16D5A0  sm3Update_64byteBlocks_350
0x16D680  sm3Final_padLenEmit32_350
0x16D86C  sm3Compress_flattenedBlocks_350
```

`0x16D86C` 仍然是 shared flatten table 的微块入口；IDA 看到的是
`BR Xn` 平坦化控制流，但语义已经由 raw vector 验证为 SM3 compress。

## 识别过程

### 1. F15 初始化值

`managed_vm_decode/F15_350101_F15_0x606200_0x2a0.linear.c` 显示 F15 写入：

```text
state[0..7] =
7380166f 4914b2b9 172442d7 da8a0600
a96f30bc 163138aa e38dee4d b0fb0e4e
```

这正是标准 SM3 IV。

### 2. Native wrapper 形状

`0x16D520`：

```text
managedSignDigestStateInitF15_350(state)
sm3Update_64byteBlocks_350(state, input, input_len)
sm3Final_padLenEmit32_350(state, out32)
```

`0x16D5A0`：

- `state+0x00/+0x04` 为 64-bit byte counter
- `state+0x28` 为 64-byte tail buffer
- 每满 64 字节调用 `0x16D86C`

`0x16D680`：

- 追加 `0x80`
- 补零到 56 或 120
- 追加 8 字节大端 bit length
- 输出 8 个 32-bit state word 的大端序

这些细节与 SM3/SHA-2 家族一致；结合 F15 IV，可以优先假设 SM3。

### 3. Raw vector 验证

来源：

```text
unidbg/unidbg-android/target/sign6_350101_cf61_raw_20260831_063733.log
```

验证脚本内嵌在：

```text
cf61_sm3_recovered_350101.c
```

结果：

```text
query/F5+F8 len=0x2c0 match=true
x-ss-stub/F5 len=0x10 match=true
pack44/F5 len=0x44 match=true
pack44/F8 len=0x44 match=true
failures=0
```

关键 raw pairs：

```text
query len=0x2c0
  sm3/out32 = 1f08578a515b19dc248e2cefe5b538a05afc8268966f1e67210566ae85fbe96c

x-ss-stub len=0x10
  input     = fdf60e82c1607606e7386ba88d06b4ca
  sm3/out32 = cf03476f3b9699c7eb8260360698451d9016df928df1214e8fa01d93660ceb4d

F5 pack44 len=0x44
  sm3/out32 = f903630a5d9a2e1861605879681ac6846480294b8430d2f719d34f614397e753

F8 pack44 len=0x44
  sm3/out32 = 2fa4ae2edff5470dbe0c4fe5e021b68f1fcddfeac05a5a524bb0b704e1023251
```

## 对 X-* 路径的意义

`CF61` 不再是未知黑盒：

- `F5/X-Argus` 中至少三次使用：
  - query string SM3
  - `x-ss-stub` SM3
  - `0x44` 中间包 SM3
- `F8/X-Medusa` 中至少两次使用：
  - query string SM3
  - `0x44` 中间包 SM3

所以后续还原 X-Argus / X-Medusa 时，遇到 32-byte digest 输入可以直接用
SM3 oracle 对齐，不需要继续硬追 `0x16D86C` flatten 微块。

## 复现命令

```bash
cd /Users/freeman/project/douyin
clang -std=c11 -Wall -Wextra -Werror \
  dyidre/versions/350101/cf61_sm3_recovered_350101.c \
  -o /tmp/metasec_cf61_sm3_350101
/tmp/metasec_cf61_sm3_350101
```

如需重新采集 CF61 raw log：

```bash
cd /Users/freeman/project/douyin/unidbg
./mvnw -pl unidbg-android \
  -Dmaven.test.skip=false -DskipTests=false \
  -Dtest=com.ss.android.ugc.aweme.Sign6_350101#testMetasec \
  -Dmetasec.dumpManagedCfArgs=true \
  -Dmetasec.dumpManagedCfPost=true \
  -Dmetasec.managedCfCallsites=0x16f998 \
  -Dmetasec.managedCfMaxEvents=12 \
  -Dmetasec.managedCfPostMaxEvents=12 \
  -Dmetasec.managedCfMaxBytes=0x400 \
  test
```
