# 350.101 CF41 plaintext `0x92` / `XArgusStruct`

CF41 的输入不是普通定长 C struct，而是 `dy_sign/ml_reqsign.proto`
里 `bytedance.reqsign.XArgusStruct` 的 protobuf wire-format message。
它随后被 CF41 按 SIMON128/256 + PKCS#7 加密成 `0xa0`。

来源日志：

```text
unidbg/unidbg-android/target/sign6_350101_cf43mode_ret_20260831_072406.log
unidbg/unidbg-android/target/sign6_350101_cf43mode_20260831_072212.log
```

入口：

```text
CF41 @ 0x16F43C
slot4 -> plaintext MEM_BLOCK, current len 0x92
slot5 -> output MEM_BLOCK, overwritten to len 0xa0
slot6 -> 32-byte SIMON key/material
```

## Field map

Current `0x92` message decodes as `XArgusStruct`:

| offset | field | proto name | wire | value / meaning |
|---:|---:|---|---:|---|
| `0x00` | `1` | `k1_sdk_date` | varint | `0x40401252`; protobuf varint carries a shifted/encoded SDK date-like value |
| `0x06` | `2` | `k2_type` | varint | `2` |
| `0x08` | `3` | `k3_random_value` | varint | dynamic, sample A `0x6497ae3a`, sample B `0x65740c38` |
| `0x0e` | `4` | `k4_aid` | len | `"1128"` |
| `0x14` | `5` | `k5_device_id` | len | `"397365608203400"` |
| `0x25` | `6` | `k6_version_string` | len | `"1588093228"` |
| `0x31` | `7` | `k7_app_version_name` | len | `"35.1.0"` |
| `0x39` | `8` | `k8_sdk_version_name` | len | `"v04.09.05-ml-android"` |
| `0x4f` | `9` | `k9_sdk_version_code` | varint | `0x08120a00` / `135399936` |
| `0x54` | `10` | `k10_proto_header` | len | 8 raw bytes: `08 00 00 00 00 00 00 00` |
| `0x5e` | `12` | `k12_khronos` | varint | dynamic, sample A `0xd529772e`, sample B `0xd529764c` |
| `0x64` | `13` | `k13_xssstub_sm3` | len | 6 raw bytes: `cf 03 47 6f 3b 96` in current sample |
| `0x6c` | `14` | `k14_url_sm3` | len | 6 raw bytes: `1f 08 57 8a 51 5b` in current sample |
| `0x74` | `15` | `k15_algorithm_seq` | len | nested `AlgorithmSeq`, len 10 |
| `0x80` | `17` | `k17_khronos` | varint | same as field 12 in current samples |
| `0x87` | `20` | `k20_pskVersion` | len | `"none"` |
| `0x8e` | `21` | `k21_callType` | varint | `0x2e2` / `738` |

Nested field 15 is `XArgusStruct.AlgorithmSeq`:

| nested field | proto name | wire | value |
|---:|---|---:|---|
| `1` | `k1_algo_seq` | varint | `2` |
| `2` | `k2_report_seq` | varint | `1388734` / `0x1530be` |
| `3` | `k3_setting_seq` | varint | `1388734` / `0x1530be` |

Absent in the current `0x92` body:

```text
k11_platform, k16_ms_token, k18, k19
```

## Observations

- Field `4` is `aid="1128"`.
- Field `6` uses the proto name `k6_version_string`, but current content
  looks like app-id/version-material: `"1588093228"`.
- Field `7` is the app version string for this 350.101 run: `"35.1.0"`.
- Field `8` is the ML protocol tag: `"v04.09.05-ml-android"`.
- Field `20` currently carries `"none"`; this lines up with the previous
  unidbg environment gaps where optional env/msdata fields were absent.
- Field `3` and fields `12/17` are dynamic across two close runs. Treat them
  as seed/time/random-like until more samples pin them down.

【中文】这里不要把 `0x92` 硬写成 C 定长结构。升级版本时优先按
`XArgusStruct` 的 protobuf field 编号对齐：稳定字段看
`4/5/6/7/8/20/21`，动态字段看 `3/12/17`。如果字段编号和 wire type
不变，即使长度变了，也能很快判断 CF41 明文 pack 是否还是同族。
