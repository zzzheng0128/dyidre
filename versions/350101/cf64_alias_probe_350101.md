# CF64 F2/F19/F13 窄范围 alias probe — 350.101

状态：已实现本地只读观测器；当前本地 Unidbg baseline 没有命中三个目标
调用，因而没有新增 object-alias 结论。

本记录只解决 CF64/F1 的第一个动态别名缺口：F1 直接调用的 `F2`、`F19`
和 `F13` 在返回后会把 child frame 的结果重新采纳到 F1 slot。它不实现
CF64，不修改 VM 状态，也不使用真机、KPM、apatch 或注入。

## 为什么需要独立 probe

已有 `metasec.childNativeAbiProbe` 面向 child-table 中 `kind=3` 的 native
wrapper（例如 `0x0d..0x16`），其正常返回边界是 `0x154550/0x154560`。
以下三个 F1 直调目标却都是 `kind=1` 的 managed bytecode body：

| F1 record | live F1 code offset | child table index | body | expected `bodyId` |
|---:|---:|---:|---|---:|
| `0x0083` | `+0x0c48` | `0x19` | F2 | `0x46000002506` |
| `0x00f7` | `+0x1728` | `0x1b` | F19 | `0x200000031c2` |
| `0x04d3` | `+0x73c8` | `0x25` | F13 | `0x200000079e4` |

它们先在 `module+0x154590` 执行 `mov x1,x19`，再在
`module+0x154594` 的 `BL` 进入 `managedBytecodeRun_350`，并于
`module+0x154598` 返回。把它们接到 native probe 的 `0x154550` 会把
另一条 kind-3 ABI 当成 post state，故新探针必须独立。

静态位置和 F1 的 early forwarding chain 见
[`cf63_cf64_child_module_boundary_350101.md`](cf63_cf64_child_module_boundary_350101.md)
及 [`cf64_child_native_abi_350101.md`](cf64_child_native_abi_350101.md)。

## 证据门槛

实现位于
`unidbg-android/src/test/java/com/ss/android/ugc/aweme/Sign6MetaSecBase.java`
的默认关闭开关 `metasec.cf64AliasProbe=true`。一个 event 必须同时通过
以下六个 local CodeHook 边界：

1. `0x153ECC`：只接受 `LR == module.base + 0x16FABC`，保存 CF64 outer
   `s4=X8, s5=X0, s6=low32(X1), s7=X2`；
2. `0x153F50`：按 adapter SP 取回这次 outer input，读取 live F1，扫描唯一
   `op=0x5e` holder，并要求 `table[0x18] == F1 descriptor`；
3. `0x15AB1C`：要求 `LR == module.base + 0x1570F0`、同一 child frame、
   holder/table/root-F1；`record=X0-8` 必须精确等于 live
   `F1.codeBegin +` 表中的对应 offset，且 `record.op==0x5e`、`W2==index`；
4. table entry 必须为相应 `kind=1`、`body == program+8`、且 `bodyId` 与上表
   一致；
5. `0x154594`：这是 `mov x1,x19` 之后、body `BL` 之前的 CodeHook；要求
   `LR == module.base + 0x15AB44`、`X0==program+8`、
   `X1==X19==child frame` 以及 `SP == dispatcherSP-0x50`，然后采集 pre；
6. `0x154598`：要求 `LR == module.base + 0x154598`、同一 `X19` frame/SP，
   然后采集 post；F1 返回到 `0x153F54` 时再采集 final state 并清理未配对项。

这比“同一 table index”更窄：即使某个子孙程序也分派 `0x19`、`0x1b` 或
`0x25`，没有匹配到 F1 的**那一条** record 也不会生成 alias event。

## 采集内容与边界

默认记录 child frame `s0..s31`，并对 `s4,s5,s6,s7,s14,s16,s17,s18,s20,s21`
做至多 `0x40` 字节的本地只读 sample（长度与 FNV-1a；`dumpHex=false` 为
默认值）。F1 session 还固定保存并于结束时复读：

- outer `s4`、`s5`、`s7` 的 pointee；
- `*(outer.s4+0x10)` 与 `*(outer.s5+0x10)` 的 pointer identity 和原 pointer
  所指 bytes；
- `*(int32_t *)(outer.s5+0x0c)`，即 F2 的 `s5` scalar 来源。

上述 outer anchors 除 F1 start/end 外，也会在每个**已接受**的 F2/F19/F13
event 的 kind-1 pre/post 中各采一份；因此目标 body 自身返回造成的 sampled
mutation 不必等到整个 F1 结束才可见。若本次没有 accepted event，则只保留
F1 边界样本，不能将其变化归因给三个目标之一。

它输出的是“same sampled bytes changed/unchanged/not-sampled”和 derived
field pointer identity 是否变化；direct outer input 仅报告其采样基线，不会把
这种采样自动解释为某一个高层对象字段。特别是：

- F2 返回后的 F1 `0x0091..0x009b` 已经是 post-F2 state；
- F19/F13 的 callee-save/epilogue 可以恢复 slot 值，但并不能说明 pointee
  没有被写；
- F13 后还有后续 F16 采纳，因此 F13 post 的 `s17` 不能当作 F1 final flag
  object 的闭合证据。

## 本地运行方式

只支持 Unicorn CodeHook backend；Dynarmic/Hypervisor 会在安装前打印 skip。
一条最小本地 callback 复跑命令为：

```bash
cd /Users/freeman/project/douyin/unidbg
./mvnw -q -pl unidbg-android -am \
  -Dmaven.test.skip=false -DfailIfNoTests=false \
  -Dtest=Sign6_350101#testMetasec \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.cf64AliasProbe=true \
  -Dmetasec.cf64Alias.maxEvents=12 \
  -Dmetasec.cf64Alias.maxBytes=0x20 \
  -Dmetasec.repeat=1 test
```

可选参数：

```text
metasec.cf64Alias.slots=0-31
metasec.cf64Alias.rawSlots=4,5,6,7,14,16,17,18,20,21
metasec.cf64Alias.maxEvents=12
metasec.cf64Alias.maxPending=64
metasec.cf64Alias.maxBytes=0x40
metasec.cf64Alias.dumpHex=false
```

所有地址 offset 都可按同名前缀的 `...Offset` 属性覆盖，但 350.101 的默认
值来自当前 SO；runtime heap/table/body 地址从 live descriptor 取得，不能用
旧 run 的绝对地址替代。

## 当前 baseline

2026-09-05 的本地 Unicorn2 单请求执行通过（`1` test、`0` failures、`0`
errors）。probe 成功关联了一次 CF64→F1 session：live F1/table/holder 关系
正常，F1 初始 frame 也符合 adapter 的 `s0/s10/s19/s27` forwarding shape。
但这条请求报告：

```text
target{pre=0,post=0} cap{reached=false,skipped=0} unresolved=0
```

即该 input 下没有走到 F1 的直调 `F2/F19/F13` 三条 record。因此：

- 本次 F1 end 的 outer sample/pointer 变化只表明**别的 F1 路径**可能影响了
  它们，不能归因到 F2、F19 或 F13；
- 没有输出任何 `---- pre`/`---- post` target event，也没有 alias closure；
- 下一步必须使用会实际走到 `0x19`、`0x1b` 或 `0x25` 的受控本地 input，保存
  同一 session 的 pre/post/final 记录；不能用静态 F body 名或旧 runtime address
  补充这一空缺。

这保持 CF64 为 opaque boundary；该 probe 是收集下一条证据的设施，不是
standalone 实现或绕过路径。
