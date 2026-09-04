# CF59 CRC-8 binding — 350.101

`CF59` at `0x16F940` reads slot4 and calls `0x11B5B4`.  That helper unwraps
the MEM_BLOCK body pointer at `+0x10` and length at `+0x0C`, then enters the
loop at `0x10E1DC`:

```text
crc = 0
for byte in data:
    crc = table[crc ^ byte]
return crc
```

The table at `+0x1F4230` begins `00 31 62 53 C4 F5 A6 97`, which is the
MSB-first CRC-8 table for polynomial `0x31`.  There is no nonzero init or
final XOR.  The host self-test records `CRC8("123456789") == 0xA2`.
