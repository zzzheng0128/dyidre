# dyidre tools

这个目录放“后续版本升级可以直接复用”的设备侧工具和 payload。它们不是分析结论，但会影响真机采证能不能稳定跑起来，所以随仓库一起保存，并通过 Git LFS 管理二进制本体。

## 目录

| 路径 | 作用 |
|---|---|
| `runtime_payloads/rustfrida` | 设备侧 rustFrida 可执行文件，负责 spawn/attach、加载统一 JS、提供 RPC。 |
| `runtime_payloads/ecapture` | 设备侧 eCapture Android arm64 静态二进制，负责旁路抓 `SSL_read/SSL_write` 明文，不注入目标进程。 |
| `runtime_payloads/wxshadow.kpm` | wxshadow KPM，配合无痕/低痕 Java hook 场景使用。需要设备内核/APatch 环境支持。 |
| `runtime_payloads/hide-so.kpm` | hide-so KPM，用于隐藏/收敛 maps 里的注入痕迹，按需加载。 |
| `runtime_payloads/embed1.so`、`embed2.so`、`embed3.so` | rustFrida/zygote/embed 相关 payload。一般不直接手动加载，除非调 RF 自身启动链路。 |

更细的 hash、大小、来源看：

```text
tools/runtime_payloads/README.md
```

## 首次部署到手机

在仓库根目录执行：

```bash
adb push tools/runtime_payloads/rustfrida /data/local/tmp/rustfrida
adb shell "su -c 'chmod 755 /data/local/tmp/rustfrida'"
```

eCapture 通常由 runner 自动推送；手工部署时：

```bash
adb push tools/runtime_payloads/ecapture /data/local/tmp/ecapture
adb shell "su -c 'chmod 755 /data/local/tmp/ecapture'"
```

如果要测试 wxshadow/hide-so：

```bash
adb push tools/runtime_payloads/wxshadow.kpm /data/local/tmp/wxshadow.kpm
adb push tools/runtime_payloads/hide-so.kpm /data/local/tmp/hide-so.kpm
```

KPM 是否能加载取决于当前设备的 root/APatch/内核能力。加载失败时，不要先改分析脚本，先看设备侧内核日志和 `mkpms`/APatch 的加载报错。

## 跟 probes 怎么配合

350101 的统一入口是：

```bash
probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
```

常用例子：

```bash
# 只生成 runtime JS 和 run README，不碰设备；用来检查脚本是否能跑通。
DRY_RUN=1 probes/350101/run_metasec_probe_350101.sh counter-one 1 dryrun

# 单请求计数：确认真机和 unidbg 的函数/VM 调用次数是否一致。
probes/350101/run_metasec_probe_350101.sh counter-one 60 req01_count

# 真机环境采集：同步 s1/s2 外的环境、F8/X-Medusa、时间/随机等。
probes/350101/run_metasec_probe_350101.sh true-env 90 req01_env

# JNI 采集：补 unidbg 的 MS.b、NewString、FindClass、GetStringUTFChars 等 stub。
probes/350101/run_metasec_probe_350101.sh jnitrace 180 jni01

# GumTrace：只在需要 raw PC / VM handler 时短跑。
probes/350101/run_metasec_probe_350101.sh gum-exevm 90 gum4cc10

# eCapture：网络 TLS 明文基准，不注入目标进程。
probes/350101/run_ecapture_tls_350101.sh text 60 req01_ecap
```

输出会进入：

```text
runs/<version>/<run_kind>/<tag>/
```

## 跟 stackplz / eDBG 怎么配合

`stackplz` 和 `eDBG` 本体不放在这个目录；这里保存的是 dyidre 自己已经验证过的 RF/KPM payload。

复用方式：

```text
eCapture 先拿网络明文基准
  -> rustFrida/Frida JS 定位 module base、offset、buffer 指针
  -> stackplz 或 eDBG 对少量地址下 hbreak/watch/rwatch
  -> 把 regs/stack/memory dump 放到 runs/<version>/edbg_stackplz/<run_id>/
  -> 用结果补 unidbg stub、IDA 结构体和 C oracle
```

具体命令和 RPC bridge 看：

```text
docs/reusable-probes-stackplz-edbg.md
probes/350101/run_stackplz_hwbrk_rpc.sh
probes/350101/run_stackplz_offset_test.sh
```

## 新版本怎么复用

分析 37xx 或后续版本时，不要复制工具本体，只复制 probe 目录并改 offset：

```bash
cp -R probes/350101 probes/37xxxx
mkdir -p runs/37xxxx/{entrydump,gumtrace,jnitrace,true_env_xmedusa,edbg_stackplz,control}
mkdir -p versions/37xxxx
```

然后更新：

- `probes/37xxxx/metasec_probe_37xxxx.js` 里的 offset 表；
- `probes/37xxxx/run_metasec_probe_37xxxx.sh` 里的 `VERSION`；
- `materials/materials_sources.tsv` 里的 APK/SO/I64 来源；
- `versions/37xxxx/README.md` 和 `FILE_CATALOG.md`。

工具本体只有在 rustFrida/KPM 自身升级时才替换。替换后必须更新 `tools/runtime_payloads/README.md` 里的 hash 和说明。
