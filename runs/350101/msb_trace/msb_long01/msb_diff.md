# MS.b true-device vs unidbg diff

- device: `runs/350101/msb_trace/msb_long01/frida_console.log` (356 calls, 63 ops)
- unidbg: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_cf71_tls_20260904.log` (16 calls, 12 ops)

## op 覆盖

| op | device 次数 | unidbg 次数 | 覆盖 |
|---|---:|---:|---|
| `0x10001` | 1 | 1 | both |
| `0x10002` | 1 | 1 | both |
| `0x10003` | 1 | 1 | both |
| `0x10006` | 1 | 0 | device-only ⚠️ |
| `0x10007` | 1 | 0 | device-only ⚠️ |
| `0x10008` | 1 | 1 | both |
| `0x20001` | 1 | 1 | both |
| `0x20002` | 54 | 1 | both |
| `0x30001` | 6 | 0 | device-only ⚠️ |
| `0x1000001` | 1 | 1 | both |
| `0x1000002` | 5 | 0 | device-only ⚠️ |
| `0x1000005` | 1 | 0 | device-only ⚠️ |
| `0x1000006` | 1 | 0 | device-only ⚠️ |
| `0x1000009` | 6 | 0 | device-only ⚠️ |
| `0x100000a` | 5 | 0 | device-only ⚠️ |
| `0x1000010` | 6 | 0 | device-only ⚠️ |
| `0x1000011` | 113 | 2 | both |
| `0x1000012` | 2 | 0 | device-only ⚠️ |
| `0x1000013` | 4 | 0 | device-only ⚠️ |
| `0x1000017` | 5 | 0 | device-only ⚠️ |
| `0x1000018` | 4 | 0 | device-only ⚠️ |
| `0x1000019` | 2 | 0 | device-only ⚠️ |
| `0x100001a` | 1 | 0 | device-only ⚠️ |
| `0x100001b` | 1 | 0 | device-only ⚠️ |
| `0x100001c` | 5 | 0 | device-only ⚠️ |
| `0x100001d` | 1 | 0 | device-only ⚠️ |
| `0x100001e` | 3 | 0 | device-only ⚠️ |
| `0x100001f` | 4 | 0 | device-only ⚠️ |
| `0x1000020` | 4 | 0 | device-only ⚠️ |
| `0x1000021` | 4 | 0 | device-only ⚠️ |
| `0x1000022` | 10 | 4 | both |
| `0x1000023` | 4 | 0 | device-only ⚠️ |
| `0x1000026` | 6 | 0 | device-only ⚠️ |
| `0x1000027` | 6 | 0 | device-only ⚠️ |
| `0x100002b` | 4 | 0 | device-only ⚠️ |
| `0x100002c` | 1 | 0 | device-only ⚠️ |
| `0x100002d` | 4 | 0 | device-only ⚠️ |
| `0x100002e` | 4 | 0 | device-only ⚠️ |
| `0x100002f` | 12 | 0 | device-only ⚠️ |
| `0x1000030` | 1 | 0 | device-only ⚠️ |
| `0x1000032` | 4 | 0 | device-only ⚠️ |
| `0x1000033` | 4 | 0 | device-only ⚠️ |
| `0x1000034` | 4 | 0 | device-only ⚠️ |
| `0x1000035` | 4 | 0 | device-only ⚠️ |
| `0x1000036` | 4 | 0 | device-only ⚠️ |
| `0x1000038` | 4 | 0 | device-only ⚠️ |
| `0x1000039` | 1 | 0 | device-only ⚠️ |
| `0x100003a` | 1 | 0 | device-only ⚠️ |
| `0x100003b` | 1 | 0 | device-only ⚠️ |
| `0x2000001` | 1 | 1 | both |
| `0x2000002` | 1 | 1 | both |
| `0x3000001` | 4 | 0 | device-only ⚠️ |
| `0x10000001` | 2 | 0 | device-only ⚠️ |
| `0x10000002` | 4 | 0 | device-only ⚠️ |
| `0x10000003` | 4 | 0 | device-only ⚠️ |
| `0x10000006` | 5 | 0 | device-only ⚠️ |
| `0x10000009` | 5 | 0 | device-only ⚠️ |
| `0x1000000a` | 1 | 0 | device-only ⚠️ |
| `0x1000000b` | 1 | 0 | device-only ⚠️ |
| `0x1000000c` | 1 | 0 | device-only ⚠️ |
| `0x1000000d` | 1 | 0 | device-only ⚠️ |
| `0x1000000e` | 1 | 1 | both |
| `0x1000000f` | 1 | 0 | device-only ⚠️ |

## 返回值对照（双方都有问的 op+key）

| op | key(str/obj) | device 返回 | unidbg 返回 | 判定 |
|---|---|---|---|---|
| `0x1000000e` | `-` | <obj 0x75d59d8801> | Num<2> | type-check |
| `0x1000001` | `-` | Str<"/data/app/~~3imE9y9Uej2rhpgx1bMlhg==/com.ss.android.ugc.awem...<len=95>"> | Str<"/data/app/com.ss.android.ugc.aweme/base.apk"> | VALUE-DIFF ⚠️ |
| `0x1000011` | `-` | Str<"35.1.0"> x113 | Str<"35.1.0"> x2 | VALUE-DIFF ⚠️ |
| `0x1000022` | `d8b674543fc0b023b69f6a3f5a0f287d458ea204` | Str<"80dd151582403f5a"> | null | KIND-DIFF ⚠️ |
| `0x1000022` | `d8b674543fc0b023b69f6a3f5a0f287d458ea204` | Str<"3e6f72ab4da9565df60cdddada5bf30db6be0533a98597ddc0a393319386...<len=80>"> | null x2 | KIND-DIFF ⚠️ |
| `0x1000022` | `d8b674543fc0b023b69f6a3f5a0f287d458ea204` | Str<"19dcca07f67427bf557676541ee63ed352ffda3824cd8bfa4b6f1b5ac7b8...<len=152>"> | null | KIND-DIFF ⚠️ |
| `0x10001` | `-` | Str<"35.1.0"> | Str<"35.1.0"> | match |
| `0x10002` | `-` | Str<"com.ss.android.ugc.aweme"> | Str<"com.ss.android.ugc.aweme"> | match |
| `0x10003` | `-` | Str<"/data/user/0/com.ss.android.ugc.aweme/files/.msdata"> | Str<"/data/user/0/com.ss.android.ugc.aweme/files/.msdata"> | match |
| `0x10008` | `-` | Str<"35.1.0"> | null | KIND-DIFF ⚠️ |
| `0x2000001` | `-` | <obj 0x75d59d8801> | null | type-check |
| `0x2000002` | `-` | <obj 0x75d59d880d> | null | type-check |
| `0x20002` | `http_reqsign` | null x43 | null | VALUE-DIFF ⚠️ |

match=3 gap=10

## unidbg 从未被问的 op+key（device-only）

- `0x10000001` key=`-` device 返回 Str<"1080*2400"> x2 x2
- `0x10000002` key=`-` device 返回 Str<"np"> x4 x4
- `0x10000003` key=`-` device 返回 Str<"np"> x4 x4
- `0x10000006` key=`-` device 返回 Str<"{"core":8,"pc":"","hw":"","max":"1803000","min":"300000","ft...<len=163>"> x5 x5
- `0x10000009` key=`-` device 返回 Str<"com.google.android.inputmethod.latin[<!>]com.google.android....<len=63>"> x5 x5
- `0x1000000a` key=`-` device 返回 null x1
- `0x1000000b` key=`-` device 返回 null x1
- `0x1000000c` key=`-` device 返回 null x1
- `0x1000000d` key=`-` device 返回 Str<"com.google.android.inputmethod.latin"> x1
- `0x1000000f` key=`-` device 返回 <obj 0x72dc8cb601> x1
- `0x1000002` key=`-` device 返回 byte[858] x1
- `0x1000002` key=`android` device 返回 byte[1484] x4 x4
- `0x1000005` key=`-` device 返回 Str<"420"> x1
- `0x1000006` key=`-` device 返回 Str<"4614"> x1
- `0x1000009` key=`-` device 返回 Str<"Asia/Shanghai,8"> x6 x6
- `0x100000a` key=`-` device 返回 Str<"zh_CN"> x5 x5
- `0x1000010` key=`-` device 返回 <obj 0x72f5dad409> | <obj 0x75c01ff401> | <obj 0x72f5dad411> x6
- `0x1000012` key=`-` device 返回 Str<"35.1.0"> x2 x2
- `0x1000013` key=`-` device 返回 Str<"-0.22,0.58,9.65"> x3 | null x4
- `0x1000017` key=`-` device 返回 Str<"100"> x5 x5
- `0x1000018` key=`com.bytedance.shell.TTSECINFO` device 返回 null x4 x4
- `0x1000019` key=`-` device 返回 null x2 x2
- `0x100001a` key=`-` device 返回 Str<"zh_CN"> x1
- `0x100001b` key=`-` device 返回 Str<""> x1
- `0x100001c` key=`-` device 返回 Str<"["192.168.31.1","0.0.0.0"]"> x5 x5
- `0x100001d` key=`-` device 返回 <obj 0x75c01ff401> x1
- `0x100001e` key=`-` device 返回 null x3 x3
- `0x100001f` key=`-` device 返回 <obj 0x72f5dad401> | <obj 0x72f5dad411> | <obj 0x72f5dad429> x4
- `0x1000020` key=`-` device 返回 <obj 0x72f5dad401> | <obj 0x72f5dad411> | <obj 0x72f5dad429> x4
- `0x1000021` key=`-` device 返回 <obj 0x72f5dad401> | <obj 0x72f5dad411> | <obj 0x72f5dad429> x4
- `0x1000022` key=`d8b674543fc0b023b69f6a3f5a0f287d458ea204` device 返回 Str<"093e857d604d0895"> x4 x4
- `0x1000022` key=`d8b674543fc0b023b69f6a3f5a0f287d458ea204` device 返回 Str<"64e30ecbf3174265"> x2 x2
- `0x1000022` key=`d8b674543fc0b023b69f6a3f5a0f287d458ea204` device 返回 Str<"bebbc6a220c34f9dc6f76358f11edfd6"> x1
- `0x1000023` key=`d8b674543fc0b023b69f6a3f5a0f287d458ea204|1128-0-167774bf518c1194` device 返回 null x4 x4
- `0x1000026` key=`-` device 返回 Str<""> x6 x6
- `0x1000027` key=`-` device 返回 null x6 x6
- `0x100002b` key=`-` device 返回 Str<""> x4 x4
- `0x100002c` key=`-` device 返回 <obj 0x75c01ff401> x1
- `0x100002d` key=`-` device 返回 Str<"0"> x4 x4
- `0x100002e` key=`-` device 返回 Str<"[]"> x4 x4
- `0x100002f` key=`-` device 返回 null x4 | Str<"google/oriole/oriole:15/BP1A.250305.019/13003188:user/releas...<len=66>"> x4 | Str<"Google"> x4 x12
- `0x1000030` key=`-` device 返回 Str<"Mozilla/5.0 (Linux; Android 15; Pixel 6 Build/BP1A.250305.01...<len=159>"> x1
- `0x1000032` key=`-` device 返回 Str<"{"1":"Pixel 6","2":"google","3":"oriole","4":"15","5":"BP1A....<len=163>"> x4 x4
- `0x1000033` key=`-` device 返回 <obj 0x72f5dad405> | <obj 0x72f5dad409> | <obj 0x72f5dad421> x4
- `0x1000034` key=`-` device 返回 Str<"ARM|Mali-G78|OpenGL ES 3.2 v1.r51p0-00eac0.20897de31e8026c40...<len=75>"> x4 x4
- `0x1000035` key=`-` device 返回 Str<"1_LSM6DSR Accelerometer_STMicro|5_TMD3719 Ambient Light_AMS|...<len=83>"> x4 x4
- `0x1000036` key=`caijing_initialization` device 返回 Str<"0"> x1
- `0x1000036` key=`caijing_initialization_again` device 返回 Str<"0"> x1
- `0x1000036` key=`cold_start` device 返回 Str<"0"> x1
- `0x1000036` key=`luckydog_init` device 返回 Str<"0"> x1
- `0x1000038` key=`-` device 返回 <obj 0x72f5dad40d> | <obj 0x72f5dad429> | <obj 0x72f5dad43d> x4
- `0x1000039` key=`-` device 返回 Str<"35109900"> x1
- `0x100003a` key=`-` device 返回 Str<"117"> x1
- `0x100003b` key=`-` device 返回 Str<"13"> x1
- `0x10006` key=`-` device 返回 Str<";ac6fdf5_20250714_5afdb178-609e-11f0-869a-d673e719a189"> x1
- `0x10007` key=`-` device 返回 null x1
- `0x20001` key=`{\n	"sdk_aid":	"3019",\n	"device_id":	"4087336283154583",\n	"hos` device 返回 Str<"OK"> x1
- `0x20002` key=`risk_inspect` device 返回 null x8 x8
- `0x20002` key=`sdk_risk_report` device 返回 null x1
- `0x20002` key=`sdk_start` device 返回 null x1
- `0x20002` key=`secdeviceid` device 返回 null x1
- `0x3000001` key=`-` device 返回 null x4 x4
- `0x30001` key=`https://mssdk.bytedance.com/pilvinen/v1/sseelfk/haku?lc_id=15880` device 返回 <obj 0x72f5dad419> x1
- `0x30001` key=`https://mssdk.bytedance.com/ri/report?lc_id=1588093228&platform=` device 返回 <obj 0x72f5dad439> | <obj 0x72f5dad451> | <obj 0x72f5dad465> x4
- `0x30001` key=`https://mssdk.bytedance.com/sdi/get_token?lc_id=1588093228&platf` device 返回 <obj 0x75c01ff419> x1

## 真机没问、unidbg 被问的 op+key（unidbg-only，可能是补环境引出的差异路径）

- `0x20001` key=`{\n	"sdk_aid":	"3019",\n	"device_id":	"397365608203400",\n	"host` unidbg 返回 Str<"OK"> x1
