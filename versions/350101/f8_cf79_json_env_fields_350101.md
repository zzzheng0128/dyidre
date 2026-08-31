# 350.101 F8 / X-Medusa CF79 JSON number fields

这份记录补 `X-Medusa` 的业务字段层：`CF79 @ 0x16FD64` 是
`jsonAddNumber`，在 F8/X-Medusa phase 内给同一个 JSON/env object 写入
一组 number 字段。

来源日志：

```text
unidbg/unidbg-android/target/sign6_350101_cf79_doublebits_20260831_0045.log
```

调用形态：

```text
CF79 @ 0x16FD64
lr = 0x154550                 ; managed native-binding return point
slot4 = 0x125e58a0             ; same JSON/env receiver for all 8 writes
slot5 = key cstr
slot2 = value, read as managed double slot
```

注意：log 里的 `generic_raw=0x43300000` 不是最终数值本身。当前 unidbg
probe 需要用 `readManagedSlotDoubleBits(frame, 2)` 读 slot2 的 double bits，
否则所有字段看起来都会像同一个 raw qword。

## Observed fields

| order | key | value | low32 / note |
|---:|---|---:|---|
| 1 | `cmr` | `16777216` | `0x01000000` |
| 2 | `cmr2` | `16777216` | `0x01000000` |
| 3 | `un_h` | `4133029968` | `0xf6590850` |
| 4 | `vpn` | `0` | disabled/false in current unidbg env |
| 5 | `kd` | `0` | disabled/false in current unidbg env |
| 6 | `fkd` | `1704349507` | `0x65964f43`; same value appears in this run's slot8 |
| 7 | `pd` | `-1663556466` | low32 `0x9cd8248e` |
| 8 | `do` | `0` | disabled/false in current unidbg env |

The eight writes happen immediately after F8 phase begins, before the final
`CF44` base64 boundary:

```text
phase=F8/X-Medusa at 0x14A4E0
MS.b(0x1000011) -> "35.1.0"
/dev/urandom read
CF79 jsonAddNumber x8
phase=after F8 emit X-Medusa at 0x14A53C
```

## Relation to the final `0x2c8` pack

These fields are not copied as plaintext into the final binary pack.

Checked against:

```text
dyidre/versions/350101/x_medusa_pack_350101_cf44_input.bin
```

No exact hit was found for the observed values as:

```text
u32-le/u32-be, u64-le/u64-be, or IEEE754 little-endian double
```

So the correct model is:

```c
json_env = {};
jsonAddNumber(json_env, "cmr",  16777216);
jsonAddNumber(json_env, "cmr2", 16777216);
jsonAddNumber(json_env, "un_h", 4133029968);
jsonAddNumber(json_env, "vpn",  0);
jsonAddNumber(json_env, "kd",   0);
jsonAddNumber(json_env, "fkd",  1704349507);
jsonAddNumber(json_env, "pd",  -1663556466);
jsonAddNumber(json_env, "do",   0);

/*
 * The JSON/env object then feeds the Medusa material path. The visible final
 * pack is already after source-work transforms, F12 bit-pack mutation, F8
 * mini XOR, and CF44 base64.
 */
X_Medusa = base64(final_pack_0x2c8);
```

## Upgrade rule

For future versions, use `CF79` as an early environment sanity probe, not as a
final-pack offset map:

1. hook `0x16FD64` / the aligned `jsonAddNumber` helper;
2. confirm the key set and order: `cmr, cmr2, un_h, vpn, kd, fkd, pd, do`;
3. if values differ, check `.msdata`, `MS.b(...)`, `/dev/urandom`, and
   permission/env stubs before blaming F8 opcode decode;
4. to map these numbers into final `X-Medusa`, trace the JSON serialization or
   source-work input before F12, not the encrypted/bit-packed `0x2c8` blob.

【中文】这块的结论很实用：`cmr/cmr2/un_h/vpn/kd/fkd/pd/do` 是
Medusa 的环境 JSON 数字输入，不是 final pack 里的明文字段。最终包已经过
F8/F12/source-work 变换，不能直接按数值搜偏移。
