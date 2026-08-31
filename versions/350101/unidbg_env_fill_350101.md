# 350.101 Unidbg 环境补齐记录

日期：2026-08-31

目标：让 `Sign6_350101` 的单个 HTTP 签名请求尽量贴近真机路径，避免后续验证
X-header 算法时被错误环境分支带偏。

## 当前结论

`exeVMInner` 不是只生成两个 key。350.101 HTTP 签名窗口里，真机核心路径是：

```text
0x1EC670 x2
0x1ECAF0 x1
0x1F7860 x1
```

其中：

- `0x1EC670` / `0x1ECAF0` 是 F8 管理字节码里通过 native binding 触发的小 VMP；
- `0x1F7860` 走 `0x12564C -> 0x124DD4 -> exeVMInner`，用于构造/选择 mssdk material；
- `0x201800` 不是当前 HTTP X-header 核心链。它在 Unidbg 未同步真机 `.msdata`
  时会多跑一次；同步 Pixel6 350.101 `.msdata/mssdk/ml` 后已消失。

## 已补到 Unidbg demo 的能力

文件：

```text
unidbg/unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java
```

### 1. rootfs 映射

新增：

```bash
-Dmetasec.rootfs=/path/to/rootfs
```

用于把真机 `.msdata` 放进 Unidbg 文件系统，例如：

```text
<rootfs>/data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk/ml/
```

### 2. `MS.b(0x10003)`

返回 `.msdata` 根路径：

```text
/data/user/0/com.ss.android.ugc.aweme/files/.msdata
```

这只是“告诉 native 根目录在哪里”，不是实际读 KV。

### 3. `MS.b(0x1000022)`

按 repo/key 读取 `.msf3_<sha1(key)>`：

```text
repo = d8b674543fc0b023b69f6a3f5a0f287d458ea204
file = .msf3_<sha1(key)>
return = hex(raw file bytes)
```

当前单请求命中过这些 key：

| key | sha1 文件名 |
|---|---|
| `1128-0-167774bf518c11948aa0784351ccf5a9` | `.msf3_6fcd8907538d237434167eb88c22ce2492e97161` |
| `1128-0-sdi` | `.msf3_18942e0a8835406640db421a854dc5eeb5cb2026` |
| `de9ecbeeb513c97d0be52260179ef0e8` | `.msf3_a2c1fbad8731da75423eb57599985db945e7c6da` |
| `ptmr` | `.msf3_2d380627968775a593c3e8b8d72b10a47c3cddbe`，当前真机目录中未见 |

### 4. runtime config 归一化

新增总开关：

```bash
-Dmetasec.alignTrueDeviceHttpRuntime=true
```

等价于当前真机 HTTP 请求窗口：

```text
runtimeObj+0x50 signv5_ctrl   = 1
runtimeObj+0x51 d_signv5_ctrl = 0
0xD952C runtime gate byte     = 0
```

这个开关的目的不是伪造算法结果，而是把 Unidbg 拉回真机分支：

```text
0x149F60 returns 1
0x14A250 bit0=1 -> skip F5/F7
0xD952C returns 0 -> smallB / vmCode 0x1ECAF0 runs
```

## 验证命令

```bash
cd /Users/freeman/project/douyin/unidbg/unidbg-android
java -cp "target/test-classes:../unidbg-api/target/classes:target/classes:$(cat target/test.cp)" \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.rootfs=/Users/freeman/project/douyin/unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930 \
  -Dmetasec.countOneRequest=true \
  -Dmetasec.probeHttpBranches=true \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  com.ss.android.ugc.aweme.Sign6_350101
```

验证日志：

```text
unidbg/unidbg-android/target/sign6_350101_rootfs_pixel6_20260831_133047.log
```

关键结果：

```text
[runtime-config-override] new.signv5=0x1 new.d_signv5=0x0
[runtime-gate-force] newDynamic=0x0 newGlobal=0x0

branch_helper_ret_149f60: x0=0x1
branch_f5f7_gate_14a250: bit0=1 -> skip F5/F7

exeVMInner.vmCode={0x1ec670=2, 0x1ecaf0=1, 0x1f7860=1}
exeVMInner.lr={0xd95cc=2, 0xd964c=1, 0x124e34=1}
```

## 真机 `.msdata` 同步记录

本轮用 Pixel6 / 35.1.0 / versionCode 350101 抽取：

```text
/Users/freeman/project/douyin/unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930/
```

抽取方式：APatch 的 root shell 普通 `ls/find` 会被 SELinux 拦，改用
`/data/adb/ap/bin/busybox tar` 在手机端落 tar，再 `adb pull` 到本地。

已同步 14 个文件：

```text
.msf3_18942e0a8835406640db421a854dc5eeb5cb2026
.msf3_6fcd8907538d237434167eb88c22ce2492e97161
.msf3_a2c1fbad8731da75423eb57599985db945e7c6da
.msf3_dbbb89b204134a1cfdf05fa9b4a681c06052ae21
.msf3_e091743a88dfbc4b61028d6ef838de143f278c61
.msf3_fce7d408bfb0e915d002539a7abd511a745391bb
.msfs_9893091c6eb67fa4460195bc94948f551762e3ff
.msfs_a27c9590f849a233578fe59080a95524e510f402
.msp_092fde7a53a0274594af0984c7830fc0c13dc8bd
.msp_589c22335a381f122d129225f5c0ba3056ed5811
.mss_2fc7f1452374b6e341d67717f032abbe0da0f4a6
.mss_442656d8b09bcb0a6e6ee93f4b7b1e09ea93796b
.mss_64750e04a9a148327d6c1be46d348587266888df
.mss_9b8ed9956d7e60469912dd239a0251f93cd1e80d
```

## 还没补平但暂不阻断的地方

同步真机 `.msdata` 后，HTTP 单请求核心 VM multiset 已经和真机一致。
当前剩余缺口：

- `MS.b(0x1000022, repo, "ptmr")` 仍 miss：
  `.msf3_2d380627968775a593c3e8b8d72b10a47c3cddbe`；
- native 还会直接探测一些 cache/material 文件，其中这几个在当前目录未见：
  `.msp_3dddca0f066cc2e65e67a784c3c1326a4a8c39e4`、
  `.msp_f0a3865870d476fd2019497ce810af59b1f3581b`、
  `.mss_1f149f2d7f76b27fded4588b7ec7fb6dd577723d`；
- native 还 stat 了 `.msfs_75610f50...`、`.msfs_eaf803ae...`、
  `.msfs_826c9c...`，后续如果 X-Medusa 仍有差异，再追它们的成功/失败语义。

也就是说：现在已经可以把“算法核心链”先按 `0x1EC670/0x1ECAF0/0x1F7860`
继续还原；`ptmr` 和缺失 cache 文件作为环境差异候选保留。

## 旧同步命令模板

本机 adb 路径：

```text
/Users/freeman/Library/Android/sdk/platform-tools/adb
```

如果换设备/重装后要刷新 rootfs，优先用手机端 tar 文件再 pull，避免
`adb exec-out su -c tar` 流被 APatch/SELinux/pty 输出污染：

```bash
TS=$(date +%Y%m%d_%H%M%S)
REMOTE_TAR=/data/local/tmp/metasec_ml_350101_${TS}.tar
LOCAL_TAR=/Users/freeman/project/douyin/unidbg/unidbg-android/target/metasec_ml_350101_${TS}.tar
ROOTFS=/Users/freeman/project/douyin/unidbg/unidbg-android/target/rootfs_pixel6_350101_${TS}

/Users/freeman/Library/Android/sdk/platform-tools/adb shell su -c \
  "/data/adb/ap/bin/busybox tar -C /data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk -cf $REMOTE_TAR ml"
/Users/freeman/Library/Android/sdk/platform-tools/adb pull "$REMOTE_TAR" "$LOCAL_TAR"
mkdir -p "$ROOTFS/data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk"
tar -C "$ROOTFS/data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk" -xf "$LOCAL_TAR"
/Users/freeman/Library/Android/sdk/platform-tools/adb shell su -c "rm -f $REMOTE_TAR"
```

同步后重跑 one-request 验证：

```bash
cd /Users/freeman/project/douyin/unidbg/unidbg-android
java -cp "target/test-classes:../unidbg-api/target/classes:target/classes:$(cat target/test.cp)" \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.rootfs="$ROOTFS" \
  -Dmetasec.countOneRequest=true \
  -Dmetasec.probeHttpBranches=true \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  com.ss.android.ugc.aweme.Sign6_350101
```
