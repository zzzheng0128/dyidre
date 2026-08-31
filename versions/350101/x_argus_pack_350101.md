# 350.101 F5 / X-Argus pack recovery

- Source log: `unidbg/unidbg-android/target/sign6_350101_cfpost_20260831_000758.log`
- CF44 call line: `2041`
- CF44 slots: `s2=0x6eb693c7 s4=0x12849c10 s5=0x12849c40 s6=0x12849c70 s7=0x12849cf8 s8=0x12849c40`
- CF44 MEM_BLOCK: `mem_len=0x100`, `src_len=0xc2`, `body=0x125e0500`
- Raw binary length: `0xc2`
- Raw FNV1a: `2e4001ec` (log `2e4001ec`)
- Base64 length: `0x104`
- Final header X-Argus length: `0x104`
- `base64(CF44 input) == final X-Argus`: `True`
- CF98 value line: `2075`, logged length `260`, visible prefix length `256`, prefix matches: `True`
- Raw CF44 input bin: `dyidre/versions/350101/x_argus_pack_350101_cf44_input.bin`

## Final X-Argus

```text
Ft63NmO7Y9mYK9dVjq3ghhDq51gZdP0WfivCLG7vzC0HOmT48Fd5/0QMiasuduuA2XVhxTIInwyYkPTMPXqux422n1pCQl9Imcz858u4nSE6V6Ddg5+NyIomj7pq0GtsQTgB7CQyr5qFvHcStfT8FszwwHK+homxotYmoTnRYabraPaYhNXoN3jnWMZh7F+7s1deAI1nouvKWjKOcLg4JdGgKp36iX+9f6fu0PTxMsX5BB+UYMzUks4uJz6XlEzJuBI=
```

## CF44 input bytes

```text
0000: 16 de b7 36 63 bb 63 d9 98 2b d7 55 8e ad e0 86
0010: 10 ea e7 58 19 74 fd 16 7e 2b c2 2c 6e ef cc 2d
0020: 07 3a 64 f8 f0 57 79 ff 44 0c 89 ab 2e 76 eb 80
0030: d9 75 61 c5 32 08 9f 0c 98 90 f4 cc 3d 7a ae c7
0040: 8d b6 9f 5a 42 42 5f 48 99 cc fc e7 cb b8 9d 21
0050: 3a 57 a0 dd 83 9f 8d c8 8a 26 8f ba 6a d0 6b 6c
0060: 41 38 01 ec 24 32 af 9a 85 bc 77 12 b5 f4 fc 16
0070: cc f0 c0 72 be 86 89 b1 a2 d6 26 a1 39 d1 61 a6
0080: eb 68 f6 98 84 d5 e8 37 78 e7 58 c6 61 ec 5f bb
0090: b3 57 5e 00 8d 67 a2 eb ca 5a 32 8e 70 b8 38 25
00a0: d1 a0 2a 9d fa 89 7f bd 7f a7 ee d0 f4 f1 32 c5
00b0: f9 04 1f 94 60 cc d4 92 ce 2e 27 3e 97 94 4c c9
00c0: b8 12
```

## Current field-level interpretation

- `F5` consumes the full `MetaSecManagedCallArg350` pack from `0x14A38C`.
- The visible helper path is `CF61(query) -> CF61(x-ss-stub) -> CF61(0x44 intermediate) -> CF44 -> CF98*2` with `CF38/CF10` MEM_BLOCK snapshots in between.
- The `0xc2` CF44 input is the byte-exact binary Argus pack. The exact inner field names are still derived from the preceding `CF38/CF10/CF61` lifetimes; do not split it by guesswork alone.
- The stable upgrade anchor is therefore `F5 @ 0x1715F8` / caller `0x14A38C`, one `CF44` with `src_len ~= 0xc2`, then two `CF98("%s")` calls returning key `X-Argus` and the base64 value.

