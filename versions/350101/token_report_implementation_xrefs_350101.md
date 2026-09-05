# `get_token` / `report` 实现位置交叉引用

这份记录把 `dycompare` 字段分析反查到当前 `z/ws` 代码。代码是旧版/兼容实现，不能直接当作 350.101 SO ABI；它适合定位字段生成逻辑和 protobuf 结构。

## 1. 请求入口与公共转换

| 位置 | 方法/结构 | 作用 | 输出 |
|---|---|---|---|
| [`handle_http.cpp:52`](/Users/freeman/project/douyin/z/ws/handle_http.cpp:52) | `tkt_handler_t::netToPhone(VM::BASE_PHONE&, PhoneInfo*, src, len)` | 解析网络 protobuf `BASE_PHONE`，把字符串、计数器、随机数、时间和 post_data 写入 `PhoneInfo` | `PhoneInfo` 运行时上下文 |
| [`handle_http.cpp:329`](/Users/freeman/project/douyin/z/ws/handle_http.cpp:329) | `on_token` | 收到 token 请求，调用 `netToPhone` 后进入 token 加密封装 | 加密 token body |
| [`handle_http.cpp:351`](/Users/freeman/project/douyin/z/ws/handle_http.cpp:351) | `on_report` | 收到 report 请求，调用 `netToPhone` 后进入 report 加密封装 | 加密 report body |
| [`handle_http.cpp:302`](/Users/freeman/project/douyin/z/ws/handle_http.cpp:302) | `on_setting` | 同一 `BASE_PHONE` 输入转换链的 setting 分支 | 加密 setting body |

`netToPhone` 的关键写入在 `handle_http.cpp:54-124`：`app_id/version/sdk/lc_id/x_db_key`、`did/iid/token/url_param/platform/x_ss_stub`、SDK/VM 版本、`cur_time_s/data_type`、`gSign_index[0..3]`、`bti_rand`、随机数组、内存/栈指针、校验序列号、请求时间和 `ladon_aid`。

## 2. protobuf 结构体定义

| 位置 | 结构 | 字段范围 | 对应源文本 |
|---|---|---|---|
| [`phone.proto:7`](/Users/freeman/project/douyin/z/ws/post/phone.proto:7) | `POST_REPORT_ITEM0` | CPU、屏幕、电池、RAM/ROM/SD、Wi-Fi、系统属性 | `report` group 1 |
| [`phone.proto:45`](/Users/freeman/project/douyin/z/ws/post/phone.proto:45) | `POST_REPORT_ITEM1` | token/did/iid/session/android_id/uuid | `report` group 3 |
| [`phone.proto:63`](/Users/freeman/project/douyin/z/ws/post/phone.proto:63) | `POST_REPORT_ITEM2` | APK ctime、首次检测时间、包名、版本、SDK、渠道 | `report` group 4 |
| [`phone.proto:83`](/Users/freeman/project/douyin/z/ws/post/phone.proto:83) | `POST_REPORT_ITEM3` | `cb`、czf 文件/属性、`nb`、eth0 | `report` group 5 |
| [`phone.proto:92`](/Users/freeman/project/douyin/z/ws/post/phone.proto:92) | `POST_REPORT_ITEM4` | fingerprint、ELF machine、ADB/USB、库校验、OAT SHA | `report` group 6 |
| [`phone.proto:113`](/Users/freeman/project/douyin/z/ws/post/phone.proto:113) | `POST_REPORT_ITEM5` | Wi-Fi、proxy、gateway、tun0、IP、net type | `report` group 7 |
| [`phone.proto:129`](/Users/freeman/project/douyin/z/ws/post/phone.proto:129) | `POST_REPORT_ITEM6` | root、zygote/uid、APK 签名、debug/hook、TracerPid、link_verify、system props | `report` group 8 |
| [`phone.proto:186`](/Users/freeman/project/douyin/z/ws/post/phone.proto:186) | `POST_REPORT_ITEM7` | 传感器与扩展校验 | `report` group 9 |
| [`phone.proto:194`](/Users/freeman/project/douyin/z/ws/post/phone.proto:194) | `POST_REPORT_ITEM8` | extension/tree map、hex serial、cur_type | `report` group 10 部分 |
| [`phone.proto:211`](/Users/freeman/project/douyin/z/ws/post/phone.proto:211) | `POST_REPORT_ITEM11` | 风险/文件/时间线 repeated 字段 | `report` group 13 |
| [`phone.proto:224`](/Users/freeman/project/douyin/z/ws/post/phone.proto:224) | `POST_REPORT_ITEM12` | GMS/Integrity API 可选结果 | `report` group 14 扩展 |
| [`phone.proto:238`](/Users/freeman/project/douyin/z/ws/post/phone.proto:238) | `POST_REPORT` | 顶层 `cur_time + item0..item11` | report 总包 |
| [`phone.proto:255`](/Users/freeman/project/douyin/z/ws/post/phone.proto:255) | `POST_TOKEN_SUB` | get_token group 1 设备/文件/网络字段 | token group 1 |
| [`phone.proto:314`](/Users/freeman/project/douyin/z/ws/post/phone.proto:314) | `POST_TOKEN` | token group 1 + platform/sdk/app/did/serial/kiid | token group 2 |
| [`phone.proto:333`](/Users/freeman/project/douyin/z/ws/post/phone.proto:333) | `XM_PHONE` | XM-23 环境扩展、冷启动、设备和签名状态 | report/token 扩展 |
| [`phone.proto:403`](/Users/freeman/project/douyin/z/ws/post/phone.proto:403) | `BASE_PHONE` | 网络输入参数和算法验证控制字段 | `netToPhone` 输入 |

## 3. 序列化与加密方法

| 位置 | 方法 | 入参 | 出参/副作用 | 用途 |
|---|---|---|---|---|
| [`proto.cpp:225`](/Users/freeman/project/douyin/z/ws/proto.cpp:225) | `callPostArgus` | `verify_type/rand/sign_count/time/stub/serial/url/total/kmsv/PhoneInfo` | 序列化 `argus_vm`，返回字节长度 | 生成 Argus protobuf 输入 |
| [`proto.cpp:304`](/Users/freeman/project/douyin/z/ws/proto.cpp:304) | `callPostMedusa` | key、随机、校验类型、stub/url/hash、JSON、PhoneInfo | 序列化 `medusa_vm`，返回字节长度 | 生成 Medusa protobuf 输入 |
| [`vm64.cpp:225`](/Users/freeman/project/douyin/z/ws/vm64.cpp:225) | `postDataToString2` | `PhoneInfo*`、旧版 `ARGUS_VM*` | 调 `callPostArgus` | 旧版 Argus VM 出口 |
| [`ws_vm.cpp:27`](/Users/freeman/project/douyin/z/ws/ws_vm.cpp:27) | `postDataToString2` | `PhoneInfo*`、旧版 `VM_XMEDUSA*` | 调 `callPostMedusa` | 旧版 Medusa VM 出口 |
| [`post.cpp:621`](/Users/freeman/project/douyin/z/ws/post.cpp:621) | `encryptPostTokenWrap` | `PhoneInfo*`、目标 buffer | 返回加密长度；内部对齐随机地址并调用 token/report 公共封装 | token 输出 |
| [`post.cpp:636`](/Users/freeman/project/douyin/z/ws/post.cpp:636) | `encryptPostReportWrap` | `PhoneInfo*`、目标 buffer | 返回加密长度；内部调用公共封装 | report 输出 |

## 4. 重要字段的已确认写入链

```text
BASE_PHONE protobuf
  -> netToPhone()
     -> PhoneInfo / gSign_index / bti_rand / rand_value
  -> on_token()  -> encryptPostTokenWrap()
     -> POST_TOKEN_SUB + POST_TOKEN -> 加密 body
  -> on_report() -> encryptPostReportWrap()
     -> POST_REPORT_ITEM0..12 -> 加密 body
```

`ARGUS_SUB` 中的 `sign_count/report/setting/report_fail/bti_rand` 在 `proto.cpp:266-275` 和 `proto.cpp:342-353` 写入；这解释了为什么源文本中的计数器和 `bti` 会同时出现在 token/report 相关材料中。

## 5. 版本边界

- `phone.proto` 的注释和 `z/ws` 方法是旧版兼容实现，适合做字段语义参考。
- 350.101 原生 SO 中，等价数据已拆进 `MetaSecCtx350`、`MetaSecHttpInnerArgPack350`、managed call pack、risk/report 对象和 F8 环境 JSON；不能直接把 `ARGUS_VM`/`VM_XMEDUSA` 当作 350 ABI。
- `POST_REPORT_ITEM6.link_verify`、`has_su`、`trace_pid` 与 350 guard/report 字段有较强对应，但仍需以 350.101 trace 的 writer/reader 为最终证据。
