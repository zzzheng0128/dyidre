# `get_token` / `report` 字段注释台账（350.101 对照）

来源：

- `/Users/freeman/project/douyin/dycompare/dy_get_token分析.txt`
- `/Users/freeman/project/douyin/dycompare/dy_report.txt`

本文件只保存字段定义和来源，不复制源文件中的 token、设备 ID、APK 路径、IP、UUID、指纹或哈希原值。字段编号是外层 protobuf/对象编号，不是 C 结构体偏移。

## 1. `get_token`：设备与运行时快照

### 1.1 外层 group 1：基础设备、系统和文件系统

| 字段 | 类型 | 来源/推导 | 用途 |
|---:|---|---|---|
| 1 | string | 未设置占位 | 缺省值标记 |
| 2/3 | string | `ro.product.brand/model` | 品牌、型号 |
| 4/5/6 | string | 蓝牙名、固定 `android`、`ro.build.version.release` | 设备/平台标识 |
| 7 | nested/packed | 分辨率字符串 | 屏幕尺寸 |
| 8 | u32 | densityDpi × 2 | 屏幕密度 |
| 9/10 | string/u64 | `ro.build.display.id`、`ro.build.date.utc` | 系统构建信息 |
| 11/12 | string | locale/timezone Java helper | 语言和时区 |
| 13/14 | u32 | 亮度、battery level × 2 | 电源/交互状态 |
| 15..18 | u32 | RAM、ROM、SD 总量/可用量，按 MB/GB 取整 | 资源画像 |
| 21/23/24 | string | Android ID、serial、DRM 派生值 | 稳定设备标识；权限不足时为空/占位 |
| 25/26/27 | u64/string/u64 | 当前时间−uptime、`boot_id`、app_process 基址 × 2 | 启动与进程环境 |
| 32/33/40 | string | 本机 IP、网关、DHCP Java helper | 网络环境 |
| 36/37/43 | integer | SIM 信息、是否有 SIM | 通信能力 |
| 45/46/47/48 | integer/string/u32 | `/data/user`、`/storage` 文件时间、`sourceDir`、SDK × 2 | 安装/文件系统/系统版本 |
| 53..55 | string | OAID、已安装 APK package path | 设备标识和应用环境 |
| 56..63 | u64 | `/data/user`、`/sdcard`、系统目录 atime/mtime | 文件系统时间画像 |
| 64..68 | u64 | 各目录 filesystem ID | 文件系统/容器一致性 |
| 69/72/75..87 | u64/u32 | system free/total、inode、`st_dev/rdev` | 存储和挂载环境 |
| 89 | repeated string | 输入法 APK/包名列表 | 输入法环境 |
| 90..92 | u64 | libc、`libandroid_servers`、`libandroid_runtime` XOR/校验值 | 系统库完整性输入 |
| 93..96 | string | boot/apex oat SHA-1；缺失时占位 | ART/系统框架完整性 |
| 97..106 | u64 | browser/mms/email/calendar/camera 数据目录时间 | 应用安装/使用痕迹 |
| 112 | u64 | `CLOCK_REALTIME - CLOCK_BOOTTIME` | 开机时间/时钟一致性 |
| 119/120 | u32 | ppid/pid | 进程关系 |
| 121..124 | string/JSON | 系统应用路径、系统文件 ctime、厂商配置 JSON | 系统环境 |
| 125/127 | u64/string | 首次安装时间、Java setting | 安装及配置状态 |
| 129 | string | `/dev/ashmem` link 名 | 运行时内存环境 |
| 131..133 | u64 | boot oat/framework/ext 的重定位或地址相关值 | ART 地址/完整性材料 |

### 1.2 外层 group 2：MetaSec/应用身份

| 字段 | 类型 | 来源 | 用途 |
|---:|---|---|---|
| 2 | string | `msp_token` | MetaSec 会话 token |
| 3/4/5 | string/u32 | platform、SDK 名称、SDK code × 2 | SDK 版本协商 |
| 6/7/8 | string | appid、version name、did | 应用/设备身份 |
| 9 | string | serial hex（样本中为固定全零形态） | 序列号材料 |
| 12 | string | Java helper `njss(0x1000025)` | KIID/设备派生标识 |

## 2. `report`：风险与环境上报

### 2.1 group 1：时间、CPU、显示和资源

`1=cur_time`；嵌套字段包括 `start_time`、`uptime`、`cpu_core`、`cpu_hw`、`cpu_max/min`、`cpu_ft`、`blue_name`、`ro_model`、`ro_board/device/name/bootloader`、分辨率、`wm_size/wm_density`、电池温度/电量/数据、RAM/ROM/SD、Wi-Fi MAC、`ro_brand/platform`、package features/libraries、ROM 使用率和 `/proc/self/stat` 的进程时间字段。

用途：形成硬件、系统和资源画像；这些字段通常先进入 report/tree，再由策略或签名材料消费。

### 2.2 group 3：应用身份和随机材料

`mssdk token`、`did`、`iid`、`session_id`、`android_id1/2`、`uuid`、`bddid`、`bti_rand`。其中 UUID 来自 `/dev/urandom`，`bti_rand` 与环境树中的固定 key 对应。

### 2.3 group 4：应用/SDK 元数据

`st_ctim_tv_sec`（APK/sourceDir ctime）、`fltk`（首次风险检测时间快照）、JNI 包名、cmdline 包名、appid、version_code、`net_sence`、SDK 版本、`ml/inhouse` 标志、sdkid/subaid、元数据版本和版本字段。

### 2.4 group 5：自修改代码探针

`cb` 是 fork 后复制代码到映射区执行得到的循环计数（样本值为“10 × 2”的编码形态）。它对应 350.101 `signal-loop/I-cache` 探针，异常时影响 guard 的 `signal_loop_failed`，不是业务计数器。

### 2.5 group 6：系统完整性和电源环境

包括 `ro_finger`、时区/语言/系统版本、`arm64`、ELF machine、ADB 状态、USB 状态、SDK、MCC/MNC、SIM、Binder 值、libc/runtime/android_servers 校验值、boot oat/framework/ext/apex SHA-1、锁屏、响铃、音量、亮度，以及 Java `njss(0x1000032/0x1000033)` 结果。

用途：完整性、调试/开发环境和设备状态画像；异常多数写风险字段，不等于立即退出。

### 2.6 group 7：网络

`net_info`（本机 IP、网关、接口）、proxy host/port、gateway repeated、my_ip、net_type。用于 VPN/proxy/路由环境判断及网络画像。

### 2.7 group 8：root、调试、链接器和进程环境

关键字段：

| 字段 | 来源/含义 | 350 对应关注点 |
|---|---|---|
| 输入法 repeated | package manager | 输入法环境 |
| `has_su` / `su_file` | `/system/bin/su` 等路径 | root 风险 |
| zygote_pid / uid | 进程/用户信息 | 进程环境 |
| app sig SHA-1 | APK 签名 | 包完整性 |
| `link_verify` | linker info 的 verify 状态 | guard/report link 校验 |
| `ro_secure_i/ro_secure` | system properties | 安全配置 |
| `ro_debuggable` | system property | 调试环境 |
| `ro_manuf/ro_tags/ro_incremental/ro_desc` | build properties | 系统构建画像 |
| OEM unlock 字段 | `ro.oem_unlock_supported`、`sys.oem_unlock_allowed` | bootloader 状态 |
| `environ` | `/proc/self/environ` | 注入/运行环境 |
| `has_debug_app` | package manager 扫描 | 调试应用风险 |
| verifiedbootstate/device_state | boot properties | 启动链状态 |
| `fc` / `cso` / `mpls` | libc API CRC、hook so、maps 库列表 | hook/注入/映像环境 |
| `xp_msg` / `frd_msg` / `mg_msg` | maps、fd、task 等扫描结果 | Frida/root/异常组件风险 |
| `dv` / `ab` | development settings、ADB enabled | 开发者/ADB 状态 |
| `atify` / `notify` / `cba` | linker `rtld_db_dlactivity` 地址和值 | linker 回调一致性 |
| `pid` / `aks` / `np1` / `np2` | pid、APK inode、no_new_privs | 进程和权限状态 |
| `fap` / `fsh` / `fdl` | APK fd 实路径、SHA-1、应用目录列表 | APK/文件系统一致性 |
| `knl` / `uai` / `vh` | uname、User-Agent、vdex 片段 | 内核/运行时画像 |
| `dp` / `dump` | AppInfo flags、dumpable | 调试/权限状态 |

### 2.8 group 9：传感器

`acc_gyro_euler` 是从 MetaSec 数据文件解密得到的加速度、陀螺仪、欧拉角时间序列；用于运动/传感器环境画像，不是 HTTP header 本身。

### 2.9 group 10：策略、APK 校验和运行配置 JSON

嵌套 JSON 的主要 key：

`bti`、`opps/cpps/rpps`（端口扫描）、`sg_s`、`d_s_v5`（服务端下发的 sign/httpdns 控制）、`tkHash`、`ak_cl/ak_fl`（APK 文件列表）、`path/ak_ph`、`v2sign/v3sign/ak_sh/sign/sg_all/sha1`（APK 签名校验）、`cso/bdc/ebdc`、`vpc/vpn/ipg/abdc`、`atmt`、`spc/mgk/npn`、`mpls`、`frd_msg/xp_msg/mg_msg`、`fc`、`cmr`、`c_s_apl`、`bqq`、`dv/ab/sg/sp`、`atify/notify/cba`、`pid/aks/np1/np2`、`fap/fsh/fdl`、`knl/uai/vh`、`dynErr/dynRet`、`dp/dump`。

用途：把多个低层检测结果聚合成可上传的策略输入。字段是否改变签名，必须继续用 writer→reader→consumer trace 证明。

### 2.10 group 11/13：文件与风险时间线

包含应用/系统文件时间、risk app 条目、音量/亮度历史数组等。数组项通常是 `value:timestamp`，用于检测环境变化和行为时间线。

### 2.11 group 14：可选扩展

当前样本大多为空或占位，不能因为字段编号存在就认定有稳定业务语义；后续样本出现非空值时再单独建立证据记录。

## 3. 与 350.101 结构/流程的对应

```text
get_token/report 原始字段
  -> JSON_LIST / JSON_ITEM / TREE_MAP
  -> guard、risk object、settings、report item
  -> F8/X-Medusa 环境 JSON 或 F5/X-Argus protobuf 字段
  -> managed VM / native VMP
  -> X-* header 或仅风险上报
```

当前可以直接对齐的 350.101 状态：

- `link_verify` → `guard+0x48/+0x4C` 及 report item6；
- signal-loop `cb` → `guard+0x30`；
- libc/runtime/android_servers/XOR、APK SHA/签名、oat SHA → 完整性/环境材料；
- `cmr/vpn/kd/fkd/pd/do` 等数字 → F8 `CF79 jsonAddNumber` 环境对象；
- token/did/iid/session/url/stub → HTTP inner 的 managed call pack 和 X-Argus/X-Medusa 输入。

尚未闭合的部分必须标为 `P`：group 10 的每个 key 如何映射到具体 CF/F opcode、哪些字段最终进入哪一个 header、guard+0x40/+0x68..+0x7C 的 VMP 写入者，以及异常值是否只上报还是改变控制流。

## 4. 后续采证格式

```text
field_group | field_id/key | source API/file | raw type | normalized value
writer RVA | reader RVA | consumer | branch effect | evidence S/D/V/P
```

原始文本只作为证据输入保存，不要将真实 token、设备 ID、网络地址或 APK 路径提交到公共报告。
