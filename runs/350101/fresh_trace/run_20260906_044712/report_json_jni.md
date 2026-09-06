# 350101 fresh trace — JSON 与 JNI 反射提取报告

- 运行目录：`/Users/freeman/project/douyin/dyidre/runs/350101/fresh_trace/run_20260906_044712`
- 测试类：`Sign6_350101_FreshTrace`（独立于主基线 Sign6_350101，单跑一次 http_reqsign）
- 数据源：`stdout.log`（JNIEnv 反射全量 + MS.b 回调）、`mem_strings.log`（全地址空间读写字符串监听，20000 事件上限）
- JNIEnv 调用总数：195；MS.b 回调次数：15


## 一、JSON 字符串清单（native 侧经 JNI 上抛的全部 JSON）

1. 来源 `NewStringUTF` @ .so 偏移 `0x12e900`
   ```json
   {
	"sdk_aid":	"3019",
	"device_id":	"397365608203400",
	"host_aid":	"1128",
	"channel":	"",
	"sdk_version":	"v04.09.05-ml-android",
	"app_version":	"35.1.0",
	"update_version_code":	"35.1.0",
	"package_name":	"com.ss.android.ugc.aweme",
	"configURLs":	["https://mon.snssdk.com/monitor/appmonitor/v2/settings", "https://monsetting.toutiao.com/monitor/appmonitor/v2/settings"],
	"reportURLs":	["https://mon.snssdk.com/monitor/collect", "https://mon.toutiao.com/monitor/collect", "https://mon.toutiaocloud.com/monitor/collect", "https://mon.toutiaocloud.net/monitor/collect"],
	"oversea":	false
}
   ```
2. 来源 `NewStringUTF` @ .so 偏移 `0x131b24`
   ```json
   {}
   ```
3. 来源 `NewStringUTF` @ .so 偏移 `0x131b24`
   ```json
   {"consume_ML_DoHttpReqSignIT":0}
   ```
4. 来源 `NewStringUTF` @ .so 偏移 `0x131b24`
   ```json
   {
	"ApiAndParams":	"https://log0-misc-lf.amemv.com/service/2/app_log/?version_code=350100&device_platform=android&device_id=4087336283154583&aid=1128&iid=3313280560987770&tt_data=a"
}
   ```

## 二、JNI 反射调用聚类

### 2.1 按函数统计

| JNI 函数 | 次数 |
|---|---|
| `NewStringUTF` | 38 |
| `GetMethodID` | 29 |
| `GetArrayLength` | 28 |
| `CallObjectMethodV` | 27 |
| `GetByteArrayRegion` | 25 |
| `CallStaticObjectMethodV` | 20 |
| `FindClass` | 8 |
| `GetStaticMethodID` | 7 |
| `GetObjectArrayElement` | 4 |
| `SetObjectArrayElement` | 3 |
| `GetSuperClass` | 2 |
| `RegisterNatives` | 1 |
| `NewGlobalRef` | 1 |
| `CallLongMethodV` | 1 |
| `NewObjectArray` | 1 |

### 2.2 FindClass

| 类 | 次数 |
|---|---|
| `java/lang/Long)` | 2 |
| `java/lang/Thread)` | 2 |
| `com/bytedance/mobsec/metasec/ml/MS)` | 1 |
| `java/lang/Integer)` | 1 |
| `java/lang/Boolean)` | 1 |
| `java/lang/String)` | 1 |

### 2.3 MethodID / FieldID 查询

| 查询 | 次数 |
|---|---|
| `GetMethodID: java/lang/String.getBytes(Ljava/lang/String;)[B) => 0x318b4ca9` | 23 |
| `GetMethodID: android/content/Context.getPackageName()Ljava/lang/String;) => 0xf6590850` | 3 |
| `GetStaticMethodID: java/lang/Thread.currentThread()Ljava/lang/Thread;) => 0xb11dab06` | 2 |
| `GetMethodID: java/lang/Thread.getStackTrace()[Ljava/lang/StackTraceElement;) => 0xb5a73646` | 2 |
| `GetStaticMethodID: com/bytedance/mobsec/metasec/ml/MS.b(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;) => 0x2f94ee13` | 1 |
| `GetStaticMethodID: java/lang/Integer.valueOf(I)Ljava/lang/Integer;) => 0x8f152ce2` | 1 |
| `GetMethodID: java/lang/Long.longValue()J) => 0x44606195` | 1 |
| `GetStaticMethodID: java/lang/Boolean.valueOf(Z)Ljava/lang/Boolean;) => 0x1d8c249f` | 1 |
| `GetStaticMethodID: java/lang/Long.valueOf(J)Ljava/lang/Long;) => 0x1a324bff` | 1 |
| `GetStaticMethodID: com/bytedance/mobsec/metasec/ml/MS.a()V) => 0x4bfa55cc` | 1 |

### 2.4 实际调用点（Call*/NewObject/RegisterNatives）

| 调用 | 次数 |
|---|---|
| `CallObjectMethodV("com.ss.android.ugc.aweme", getBytes("utf-8") => [B@0x636f6d2e73732e616e64726f69642e7567632e6177656d65))` | 3 |
| `CallObjectMethodV("35.1.0", getBytes("utf-8") => [B@0x33352e312e30))` | 3 |
| `CallObjectMethodV(android.content.Context@4000001c, getPackageName() => "com.ss.android.ugc.aweme"))` | 2 |
| `RegisterNatives(ms/bd/c/y2, unidbg@0xe4fff520, 1))` | 1 |
| `CallObjectMethodV("http_callback", getBytes("utf-8") => [B@0x687474705f63616c6c6261636b))` | 1 |
| `CallObjectMethodV("4294842512", getBytes("utf-8") => [B@0x34323934383432353132))` | 1 |
| `CallObjectMethodV("ws_callback", getBytes("utf-8") => [B@0x77735f63616c6c6261636b))` | 1 |
| `CallObjectMethodV("4294842528", getBytes("utf-8") => [B@0x34323934383432353238))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x10003, 0x0, 0x0L, null, null) => "/data/user/0/com.ss.android.ugc.aweme/fi)` | 1 |
| `CallObjectMethodV("/data/user/0/com.ss.android.ugc.aweme/files/.msdata", getBytes("utf-8") => [B@0x2f646174612f757365722f302f636f6d2e73732)` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x2000001, 0x0, 0x1283c9f0L, null, null) => null))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x2000002, 0x0, 0x1283c9f0L, null, null) => null))` | 1 |
| `CallStaticObjectMethodV(class java/lang/Integer, valueOf(0x0) => java.lang.Integer@4000001a))` | 1 |
| `CallObjectMethodV("881d61", getBytes("utf-8") => [B@0x383831643631))` | 1 |
| `CallObjectMethodV("6e90ad", getBytes("utf-8") => [B@0x366539306164))` | 1 |
| `CallObjectMethodV("["1128","","","bo95dJizD1WFcV03zOuLzN5Pn1sFtVa3szqiVQmflMJTNW0p0Kpqfw8D4i0zUlfrou4kuYt\/i0521YRygM83dwv\/wn3DD+TMJF+QFz)` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000000e, 0x0, 0x0L, null, null) => java.lang.Long@4000002c))` | 1 |
| `CallLongMethodV(java.lang.Long@4000002c, longValue() => 0x2L))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000022, 0x0, 0x0L, "d8b674543fc0b023b69f6a3f5a0f287d458ea204", "1128-0-16)` | 1 |
| `CallObjectMethodV("80dd151582403f5a", getBytes("utf-8") => [B@0x38306464313531353832343033663561))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000022, 0x0, 0x0L, "d8b674543fc0b023b69f6a3f5a0f287d458ea204", "1128-0-sd)` | 1 |
| `CallObjectMethodV("3e6f72ab4da9565df60cdddada5bf30db6be0533a98597ddc0a3933193868405d1220440433ad8a8", getBytes("utf-8") => [B@702657cc))` | 1 |
| `CallStaticObjectMethodV(class java/lang/Boolean, valueOf(true) => true))` | 1 |
| `CallObjectMethodV("1128", getBytes("utf-8") => [B@0x31313238))` | 1 |
| `CallStaticObjectMethodV(class java/lang/Long, valueOf(0x12935000L) => java.lang.Long@4000003f))` | 1 |
| `CallObjectMethodV("397365608203400", getBytes("utf-8") => [B@0x333937333635363038323033343030))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000001, 0x0, 0x0L, null, null) => "/data/app/~~3imE9y9Uej2rhpgx1bMlhg==/c)` | 1 |
| `CallObjectMethodV("/data/app/~~3imE9y9Uej2rhpgx1bMlhg==/com.ss.android.ugc.aweme-AYCj7pK2u8XFjiKUB2opWw==/base.apk", getBytes("utf-8") => )` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000022, 0x0, 0x0L, "d8b674543fc0b023b69f6a3f5a0f287d458ea204", "de9ecbeeb)` | 1 |
| `CallObjectMethodV("54712cc52d34c802", getBytes("utf-8") => [B@0x35343731326363353264333463383032))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000022, 0x0, 0x0L, "d8b674543fc0b023b69f6a3f5a0f287d458ea204", "ptmr") =>)` | 1 |
| `CallObjectMethodV("19dcca07f67427bf557676541ee63ed352ffda3824cd8bfa4b6f1b5ac7b8911372c64dc67da84dca2b1e5851b031260479b1ba53f668a0c40d33219)` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x10001, 0x0, 0x0L, null, null) => "35.1.0"))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x10002, 0x0, 0x0L, null, null) => "com.ss.android.ugc.aweme"))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x10008, 0x0, 0x0L, null, null) => "35.1.0"))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x20001, 0x0, 0x0L, "{)` | 1 |
| `CallObjectMethodV("3247301440846819", getBytes("utf-8") => [B@0x33323437333031343430383436383139))` | 1 |
| `CallObjectMethodV("836482d2656977ff15663f05c6cb24bf4e14fdb6", getBytes("utf-8") => [B@0x38333634383264323635363937376666313536363366303563)` | 1 |
| `CallStaticObjectMethodV(class java/lang/Thread, currentThread() => java.lang.Thread@40000069))` | 1 |
| `CallObjectMethodV(java.lang.Thread@40000069, getStackTrace() => [java.lang.StackTraceElement@4000006c, java.lang.StackTraceElement@4000006)` | 1 |
| `CallStaticObjectMethodV(class java/lang/Thread, currentThread() => java.lang.Thread@4000006f))` | 1 |
| `CallObjectMethodV(java.lang.Thread@4000006f, getStackTrace() => [java.lang.StackTraceElement@40000070, java.lang.StackTraceElement@4000007)` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x1000011, 0x0, 0x0L, null, null) => "35.1.0"))` | 1 |
| `NewObjectArray([null, null, null] => 3))` | 1 |
| `CallStaticObjectMethodV(class com/bytedance/mobsec/metasec/ml/MS, b(0x20002, 0x0, 0x0L, "http_reqsign", ["{}", "{"consume_ML_DoHttpReqSignIT":0})` | 1 |

## 三、MS.b 回调序列（Java 层环境回调）

| # | op | arg1 | arg2 | str | obj | 返回 |
|---|---|---|---|---|---|---|
| 1 | `0x10003` | 0x0 | 0x0 | null | null | java.lang.String<"/data/user/0/com.ss.an |
| 2 | `0x2000001` | 0x0 | 0x1283c9f0 | null | null | null |
| 3 | `0x2000002` | 0x0 | 0x1283c9f0 | null | null | null |
| 4 | `0x1000000e` | 0x0 | 0x0 | null | null | java.lang.Long<"2"> |
| 5 | `0x1000022` | 0x0 | 0x0 | java.lang.String<"d8b674543fc0b023b69f6a3f5a0f287d458ea204"> | java.lang.String<"1128-0-167774bf518c11948aa0784351ccf5a9"> | java.lang.String<"80dd151582403f5a"> |
| 6 | `0x1000022` | 0x0 | 0x0 | java.lang.String<"d8b674543fc0b023b69f6a3f5a0f287d458ea204"> | java.lang.String<"1128-0-sdi"> | java.lang.String<"3e6f72ab4da9565df60cdd |
| 7 | `0x1000001` | 0x0 | 0x0 | null | null | java.lang.String<"/data/app/~~3imE9y9Uej |
| 8 | `0x1000022` | 0x0 | 0x0 | java.lang.String<"d8b674543fc0b023b69f6a3f5a0f287d458ea204"> | java.lang.String<"de9ecbeeb513c97d0be52260179ef0e8"> | java.lang.String<"54712cc52d34c802"> |
| 9 | `0x1000022` | 0x0 | 0x0 | java.lang.String<"d8b674543fc0b023b69f6a3f5a0f287d458ea204"> | java.lang.String<"ptmr"> | java.lang.String<"19dcca07f67427bf557676 |
| 10 | `0x10001` | 0x0 | 0x0 | null | null | java.lang.String<"35.1.0"> |
| 11 | `0x10002` | 0x0 | 0x0 | null | null | java.lang.String<"com.ss.android.ugc.awe |
| 12 | `0x10008` | 0x0 | 0x0 | null | null | java.lang.String<"35.1.0"> |
| 13 | `0x20001` | 0x0 | 0x0 | java.lang.String<"{\n	"sdk_aid":	"3019",\n	"device_id":	"397 | null | java.lang.String<"OK"> |
| 14 | `0x1000011` | 0x0 | 0x0 | null | null | java.lang.String<"35.1.0"> |
| 15 | `0x20002` | 0x0 | 0x0 | java.lang.String<"http_reqsign"> | ArrayObject<object[3]> | null |

## 四、附带发现：内存里的 protobuf wire 片段

mem_strings.log 尾部捕获到 `35.1.0` / `v04.09.05-ml-android` 等版本串以 LEN-tag 形式写出，
写出点 LR = libmetasec_ml.so `0x14a530` 附近，疑似 X-Argus proto 明文拼装现场：

| 事件头 | ascii |
|---|---|
| [W] addr=0x1236f5a8 PC=RX@0x1217c2c4[libc.so]0x1c2c4 LR=RX@0x1248b4ec[libmetasec_ml.so]0x10b4ec run=23@41 | `ersion_code":."35.1.0",.."package_name":."com.ss.android.ugc.awe` |
| [W] addr=0x1236f5b0 PC=RX@0x1217c2c8[libc.so]0x1c2c8 LR=RX@0x1248b4ec[libmetasec_ml.so]0x10b4ec run=27@33 | `ode":."35.1.0",.."package_name":."com.ss.android.ugc.aweme",.."c` |
| [W] addr=0x1236f5b8 PC=RX@0x1217c2c8[libc.so]0x1c2c8 LR=RX@0x1248b4ec[libmetasec_ml.so]0x10b4ec run=27@25 | `5.1.0",.."package_name":."com.ss.android.ugc.aweme",.."configURL` |
| [W] addr=0x123790e0 PC=RX@0x123c78d4[libmetasec_ml.so]0x478d4 LR=RX@0x123c78cc[libmetasec_ml.so]0x478cc run=6@0 | `35.1.0..................rb..............0...............cmr.....` |
| [W] addr=0x12373c08 PC=RX@0x1217c294[libc.so]0x1c294 LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=16@26 | `.C?..,"m.V........".1128*.3973656082034002.1588093228:.35.1.0B.v` |
| [W] addr=0x12373c10 PC=RX@0x1217c29c[libc.so]0x1c29c LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=16@18 | `.V........".1128*.3973656082034002.1588093228:.35.1.0B.v04.09.05` |
| [W] addr=0x12373c18 PC=RX@0x1217c29c[libc.so]0x1c29c LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=17@47 | `..".1128*.3973656082034002.1588093228:.35.1.0B.v04.09.05-ml-andr` |
| [W] addr=0x12373c20 PC=RX@0x1217c2a4[libc.so]0x1c2a4 LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=21@39 | `*.3973656082034002.1588093228:.35.1.0B.v04.09.05-ml-androidH...@` |
| [W] addr=0x12373c28 PC=RX@0x1217c2a4[libc.so]0x1c2a4 LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=21@31 | `6082034002.1588093228:.35.1.0B.v04.09.05-ml-androidH...@R.......` |
| [W] addr=0x12373c30 PC=RX@0x1217c2ac[libc.so]0x1c2ac LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=21@23 | `02.1588093228:.35.1.0B.v04.09.05-ml-androidH...@R.........`.....` |
| [W] addr=0x12373c38 PC=RX@0x1217c2ac[libc.so]0x1c2ac LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=21@15 | `93228:.35.1.0B.v04.09.05-ml-androidH...@R.........`.....j.M..pR.` |
| [W] addr=0x12373c40 PC=RX@0x1217c294[libc.so]0x1c294 LR=RX@0x124ca530[libmetasec_ml.so]0x14a530 run=21@7 | `5.1.0B.v04.09.05-ml-androidH...@R.........`.....j.M..pR.K.'.a.x7` |
