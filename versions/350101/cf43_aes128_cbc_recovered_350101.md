# 350.101 CF43 AES-128-CBC recovery

CF43 is the F5/X-Argus tail block transform:

```text
wrapper 0x16F4C4 -> inner 0x11BF94
slot5 bodyB3 len=0xb3
slot6 key16  len=0x10
slot7 iv16   len=0x10
slot8 modeDesc[0].type = 1
```

The selected mode is resolved by both static dispatch and runtime output.

## Static dispatch

`0x11CAE0` and `0x11CBB4` both read the mode type this way:

```text
x8 = *(uint64_t *)arg0
w8 = *(uint32_t *)x8
```

Dispatcher tables:

```text
init table    @ 0x1F76F0: 00 0a 12 1a
process table @ 0x1F76F4: 00 09 12 18
```

For current F5, `modeDesc[0].type == 1`:

```text
init    -> 0x106230 aesCbcInit_350
process -> 0x1062A8 aesCbcEncrypt_350
```

`0x1062A8` has the standard CBC encrypt shape:

```c
for each 16-byte block:
    chain ^= plaintext_block;
    chain = AES_encrypt(chain, key_schedule);
    output_block = chain;
```

## Runtime proof

Source log:

```text
unidbg/unidbg-android/target/sign6_350101_cf43mode_ret_20260831_072406.log
```

Runtime facts:

```text
bodyB3 len=0xb3, FNV ebbffc4d
key16  = f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4
iv16   = 1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12

PKCS#7 pad: thirteen 0x0d bytes
padded len: 0xc0

0x11CBB4 entry: x2 == x3, x4 == 0xc0
0x11C8D8 return saved_x2_after len=0xc0, FNV a79949b1
next CF30 slot6/outC0 len=0xc0, FNV a79949b1
final CF44 input len=0xc2, FNV cc413c64
final CF44 input == 81 34 || outC0
```

Validation:

```text
OpenSSL AES-128-CBC(key16, iv16, nopad(padded_bodyB3)) == outC0: true
cf43_aes128_cbc_recovered_350101.c failures=0
```

## Recovered shape

```c
MEM_BLOCK cf43_current_f5_type1(MEM_BLOCK *body_b3,
                                MEM_BLOCK *key16,
                                MEM_BLOCK *iv16)
{
    uint8_t padded[0xc0];
    pkcs7_pad16(padded, body_b3->body.mem, 0xb3);  // 13 bytes of 0x0d

    uint8_t out_c0[0xc0];
    aes_128_cbc_encrypt(out_c0, padded, 0xc0, key16->body.mem, iv16->body.mem);

    return initMemBlockBySrc(out_c0, 0xc0);
}
```

【中文】这一步已经不是“像 AES”了：当前 350.101 F5 的 CF43 type1 分支就是
标准 AES-128-CBC + PKCS#7。后续升级版本优先看三个锚点：`modeDesc[0]`、
`0x11CAE0/0x11CBB4` 的跳表、以及 `0x11CBB4` 是否仍为 `x2==x3` 原地处理。
