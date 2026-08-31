# 350.101 CF41 / X-Argus tail SIMON128/256 recovery

CF41 是 F5/X-Argus 尾部 `0x92 -> 0xa0` 这一段的块变换层。

结论：当前 350.101 样本里，CF41 等价于：

```c
out = SIMON128_256_encrypt_pkcs7(input, key32);
```

其中：

- block size: 128 bit / 16 bytes
- word size: 64 bit
- key size: 256 bit / 32 bytes
- rounds: 72
- padding: PKCS#7 到 16 字节边界
- key schedule constant: `0x3dc94c3a046d678b`

## 入口和 wrapper

Managed CF wrapper：

```text
0x16F43C cf41_argusTailSimon128256_slot4_input_slot5_out_slot6_key_350
```

slot ABI：

```text
slot4 -> input MEM_BLOCK
slot5 -> output MEM_BLOCK
slot6 -> key/material MEM_BLOCK
```

下层链路：

```text
0x16F43C -> 0x16CB88 -> 0x16E538 -> 0x16E678 / 0x1717F4
```

`0x16CB88` 做 slot 适配和 key/material 处理：

- 读取 `slot4/slot5/slot6`
- clone `slot6`
- 如果 key/material 短于 32 字节，补到 32 字节
- 调 `0x16E538(input.body, input.len, &tmp_out, &tmp_len, key32)`
- 把临时输出重新包装成 `slot5` 的 MEM_BLOCK

## 静态证据

`0x16E538` 的核心行为：

- 清出 `0x240` 字节 schedule/work area
- 用 `0x16E678` 展开 key schedule
- 复制 input 到临时 MEM_BLOCK
- 通过 `roundUp16AndMakePaddingMemBlock_350` 生成 padding
- 每 16 字节调用 `0x1717F4`

`0x1717F4` 是 managed program `F16` 的 native wrapper：

```text
slot4 = schedule pointer
slot5 = input block pointer
slot6 = output block pointer
program = g_managedProg_sign_F16_350
```

F16 decoded bytecode 语义：

```c
uint64_t L = load64_le(in + 0);
uint64_t R = load64_le(in + 8);

for (int i = 0; i < 72; i++) {
    uint64_t f = (ROL64(R, 1) & ROL64(R, 8)) ^ ROL64(R, 2);
    uint64_t R2 = L ^ f ^ K[i];
    L = R;
    R = R2;
}

store64_le(out + 0, L);
store64_le(out + 8, R);
```

这正是 SIMON128/256 的 64-bit word round 形状。

`0x16E678` key schedule 语义：

```c
K[0..3] = load64_le(key32[0..32]);

for (int i = 0; i < 0x47; i++) {
    bit = (0x3dc94c3a046d678b >> (i % 62)) & 1;
    cz  = 0xfffffffffffffffc | bit;
    mix = K[i + 1] ^ ROR64(K[i + 3], 3);
    K[i + 4] = K[i] ^ cz ^ mix ^ ROR64(mix, 1);
}
```

最终 schedule 长度 `72 * 8 = 0x240` 字节，对上 `0x16E538` 的 work area。

## Runtime 向量

来源：

```text
unidbg/unidbg-android/target/sign6_350101_cf43mode_ret_20260831_072406.log
```

关键长度：

```text
input:    0x92
key32:    0x20
padded:   0xa0
output:   0xa0
out fnv:  29b26846
```

CF41 input：

```text
08 d2 a4 80 82 04 10 02 18 ba dc de a4 06 22 04
31 31 32 38 2a 0f 33 39 37 33 36 35 36 30 38 32
30 33 34 30 30 32 0a 31 35 38 38 30 39 33 32 32
38 3a 06 33 35 2e 31 2e 30 42 14 76 30 34 2e 30
39 2e 30 35 2d 6d 6c 2d 61 6e 64 72 6f 69 64 48
80 94 c8 40 52 08 08 00 00 00 00 00 00 00 60 ae
ee a5 a9 0d 6a 06 cf 03 47 6f 3b 96 72 06 1f 08
57 8a 51 5b 7a 0a 08 02 10 be e1 54 18 be e1 54
88 01 ae ee a5 a9 0d a2 01 04 6e 6f 6e 65 a8 01
e2 05
```

CF41 key/material：

```text
4c 6d ce 74 7a 11 3c fa 83 41 da 76 a2 fc e9 bb
98 d4 7f c0 25 5c 80 21 29 2a 55 f9 11 f9 98 4f
```

CF41 output：

```text
a6 34 01 c3 28 e9 e7 82 09 51 2f 5c b6 12 17 9a
bb 71 e1 f0 86 71 63 0c a5 61 9d 4b f9 b7 3c 99
20 a3 22 ac ee 29 63 19 e4 31 60 ad 3f 31 6b 3d
29 60 af 72 7f ef 5f 4b ee d8 83 4c 11 30 7f 69
b9 76 de 34 d2 09 13 f1 d2 a7 7e e2 83 1d 35 04
46 dc 64 3f 6e c3 06 56 18 31 0a 4b 1b dc b2 57
b8 15 ed 86 17 c2 a4 87 cf 74 dc fc 87 5c af d3
b7 51 da ee e4 de b3 54 00 68 b0 fc fe 84 27 46
49 26 bf 3e 1e 21 f1 64 52 cb 9e 29 34 ba c3 ca
6a 03 83 15 aa ab 92 3e cf cd cb 18 d3 74 1a f8
```

## Oracle

Standalone C oracle：

```text
dyidre/versions/350101/cf41_simon128_256_recovered_350101.c
```

编译运行：

```bash
cc -O2 -Wall -Wextra dyidre/versions/350101/cf41_simon128_256_recovered_350101.c -o /tmp/cf41_simon128_256_350101
/tmp/cf41_simon128_256_350101
```

当前结果：

```text
input=0x92 padded/out=0xa0 key=0x20 expected=0xa0
actual_fnv=29b26846 expected_fnv=29b26846 match=true
cf41 SIMON128/256 oracle failures=0
```

## 对 X-Argus 链路的意义

F5/X-Argus tail 当前可以写成：

```c
pack44 = pack24 || digest_or_material20;
sm3_44 = SM3(pack44);
transformA0 = SIMON128_256_PKCS7(XArgusStruct_wire92, key32_material);
bodyB3 = prefix9 || const8 || transformA0 || suffix2;
outC0 = AES_128_CBC_PKCS7(bodyB3, key16, iv16);
argusC2 = prefix2 || outC0;
X_Argus = base64(argusC2);
```

【中文】这意味着 F5 尾部的两层真正加密已经拆开：

- CF41：SIMON128/256，处理 `0x92 -> 0xa0`
- CF43：AES-128-CBC，处理 `0xb3 -> 0xc0`

`0x92` 明文已经对齐到 `dy_sign/ml_reqsign.proto::XArgusStruct`。
剩下的工作主要是继续追 optional 字段何时出现，而不是 VM opcode 或这两层
block 算法本身。
