# 350.101 managed VM `G` binding 台账

本文只记录 350.101 `libmetasec_ml.so` 的离线静态证据。`G` 的索引在
**每个 module 内重新编号**；不同 module 的同名 `G0` 不能因为名字相同就
视为同一个对象。这里的 `target` 一律指 constructor 传入 builder 的地址，
不暗示其指向对象的宽度、C 类型、生命周期或业务含义。

本轮证据锚定的 SO 是
[metasec_so_identity.md](metasec_so_identity.md) 所记录的
`sha256=2416637ae9c5…c95730cc76`、Build-ID
`025e51707b4c64f0b578e2dd7f12aa58ca94241a` 样本；工作目录中的原始 SO 与
`materials/350101` 副本已逐字节比对一致。

## 结论

`Gxx` 是 managed module 的**具名 global/import binding**，不是：

- `CFxx` 的 native-callback 编号；
- `Fxx` 的 decoded program/export 编号；
- `0x5e` 的通用调用表。

四个 constructor 都把 `G` 表作为 `managedModuleBuild_350` 的 `X6/W7`
输入；`F` 是 build 完成后才通过 `managedModuleFindProgram(module, "Fxx")`
取得的独立导出表。基础 ABI 及四张表的计数见
[managed_vm_boot_350101.md](managed_vm_boot_350101.md)。

| module | constructor | G count | G target 的当前静态分类 |
|---|---:|---:|---|
| HTTP | `0x14CEBC` | 1 | 1 个 `.data` 地址 |
| second | `0x152B58` | 65 | 63 个 `.bss`，2 个 `.data.rel.ro` |
| main sign | `0x1702B8` | 11 | `.data.rel.ro` / `.bss` / `.data` 混合 |
| child | `0x171DDC` | 3 | 3 个相邻的 `.bss` 地址 |

合计是 80 个 module-local binding，并非一个全局 `G0..G79` 命名空间。

四个 decoded package 的 import section 也已交叉确认：每个 `env.Gx` 都是
kind=3 的 mutable `i64` global import。这是 blob-level ABI；它说明 builder
链接的是 global import，而不是把 G target 当作 native code entry。各 module
的具体索引范围见对应小节。

下文的 relocation type `0x1b` / `0x1c` 是这四个**当前 decoded package**
中观察到的 record 值。四包现均已逐项交叉 linking symbol：只有某条 record 的关联
symbol 被解析为 data symbol 时，才称其为“data-symbol reference”，绝不单凭 type
推导 symbol 身份。它们并不被声称为通用或标准 Wasm relocation ABI，更不等同于
`call`、`global.get` 或 `global.set`。

## builder 中已闭合的链接语义

`managedModuleDecodeBuild_350` 在解析 blob 后调用 `0x158460`。该例程对
`CF` 与 `G` 分别建容器：

1. `0x158608..0x158690` 逐条读取 G-table 的 `name` 和 `target`，以名字建
   独立查找表；target 作为不透明指针复制进绑定对象的 `+0x20`。
2. `0x158798..0x1587D4` 读取 parsed import 的名字，在该 G 查找表中查询，
   再把查询到的 target 写入 module 接管的 import-slot 存储。最后一步的
   `LDR X9, [binding+0x20]`、按 signed per-record offset 取 slot、
   `STR X9, [module_import_base+offset]` 已可确认是一次 **8-byte** target
   值写入。
3. 这段 build/link 路径没有对该 target 作间接调用。因此“target 是地址”
   可以确定；“target 指向什么业务对象、何时被 bytecode 读写”仍须逐项证明。

入口处 `0x158480..0x15848C` 还把调用方给出的 G count 与 parsed import
计数比较。G 表缺项或数量不匹配不是可安全忽略的可选输入。

栈上 record 的已证实布局为：

```c
typedef struct ManagedBinding350 {
    const char *name;   // "G0", "G1", ...
    void *target;       // opaque host/global target address
    uint8_t flags;      // 当前四张 G 表的构造点均写 0
    uint8_t pad[7];
} ManagedBinding350;    // 0x18
```

这也解释了旧 IDA 原型中的 `program_table` 为什么不准确：该参数位置确实会
参与 module 内的 import link，但它不是 build 后 `module->programs` 的 `F`
数组。下文统一称 `g_table/g_count`。

## HTTP module：`G0`

| item | value | evidence boundary |
|---|---:|---|
| name | `G0` at `0x202F50` | constructor literal |
| target | `0x27ECF0` | `.data`，不是 `.text` / `.bss` |
| record construction | `0x14D088..0x14D0A0` | name、target、zero flag |
| builder handoff | `0x14D0A4..0x14D0D4` | `X6=table`，`W7=1` |
| blob import | import #18 / 19; global index #0 | `env.G0`，mutable `i64` global |

对固定地址形式的静态 xref 可再收窄一层。`0x27ECF0` 有三个直接 materialize
点：constructor 的 `0x14D094`，以及两个 native reader：

- `0x149694`：`LDR W` 读取 `G0-target+0x214`，随后按条件读取
  `+0x234` 或 `+0x23C`；
- `0x1499B0`：同样读取 `+0x214`，随后按条件读取 `+0x22C` 或 `+0x23C`。

上述四个 offset 在这些现场都是 32-bit read，局部序列没有对该 target 的
`STR`。这只能证明同一静态对象存在 native consumers；当前证据**没有**把任一次
读取归属到 HTTP managed `G0`，所以不升级为字段名或 host implementation。
离线 package 结构交叉确认唯一的 `G0` linking data symbol 被 HTTP `F0`、`F1` 的
`reloc.CODE` 记录显式引用，因此可闭合 `F0→G0`、`F1→G0` 两条**静态引用**。这不
给出原始 global 的读/写方向，也不把上述 native reader 归属到任一 managed F。

## second module：`G0..G64`

constructor 从 `0x152D94` 起在 `sp+0x8` 构造 65 个 `0x18`-byte record，
到 `0x1534AC` 完成最后一个 zero flag；`0x1534D8/0x1534DC/0x1534E4` 分别
准备 `X6=sp+8`、`W7=65`、调用 builder。

| G range | passed target | ELF region | currently proven meaning |
|---|---:|---|---|
| G0 | `0x2C5068` | `.bss` | opaque shared address |
| G1 | `0x2C506C` | `.bss` | opaque shared address |
| G2 | `0x2C5070` | `.bss` | opaque shared address |
| G3 | `0x270E68` | `.data.rel.ro` | opaque static address |
| G4..G13 | `0x2C5078 + 8*(i-4)` | `.bss` | one target per entry |
| G14 | `0x2605A8` | `.data.rel.ro` | opaque static address |
| G15..G64 | `0x2C50C8 + 8*(i-15)` | `.bss` | one target per entry |

表内 65 个 target 地址互不重复，也没有一个落在 `.text`。相邻地址的步长不能
被反推成其指向对象的大小或字段类型。

second package 的 89 个 import 中，#24..#88 恰为 `env.G0..env.G64`；每项都是
mutable `i64` global import。这个 ABI 与 65 项 constructor 表逐项相符，但不
自动说明每个 exported F 会使用每个 G。

second 的 data/linking layout 还闭合了 65 项的**静态 slot 图**。这里的 `pool`
只指 package data segment 映射的运行时基址，不指代 native target 的对象类型：

```text
G[i] data-symbol storage = pool + 0xB98 + 0x10*i,  0 <= i <= 64
```

完整 linking symbol table 中 65/65 个 `G0..G64` 都是 `segment=1`、
`offset=0x10*i`、`size=8` 的 data symbol；active data segment #1 的基址为
`0xB98`、长度 `0x410`、初始为零。独立的 global section 也有 65/65 个 mutable
`i64` local global，以相同的 `0xB98 + 0x10*i` 序列初始化。因此例如 G0/G1/G2/
G3 的静态 slot 分别为 `+0xB98/+0xBA8/+0xBB8/+0xBC8`，G64 为 `+0xF98`。

second 的 `reloc.CODE` 已完整解析：568 条 record 中 `0x1b` 的 419/419 项
目标都是 linking symbol kind=function，`0x1c` 的 149/149 项目标都是
kind=data。149 条 data-symbol class 中，70 条命中 `G0..G64`，其余 79 条是
非 G data symbol；全部 record 都落在已定义 code body 内。因此可可靠记录
完整的**显式 data-symbol relocation reference**：

| decoded F | referenced G import | G-reloc count |
|---|---|---:|
| F0 | G3 | 1 |
| F1 | G0、G1、G2 | 3 |
| F23 | G4..G14 | 11 |
| F24 | G14..G24 | 11 |
| F25 | G14、G25..G34 | 11 |
| F26 | G14、G35..G44 | 11 |
| F27 | G14、G45..G54 | 11 |
| F28 | G14、G55..G64 | 11 |

这 70 条记录覆盖 `G0..G64` 的 65/65 项：G14 被 F23..F28 各引用一次，其余
64 项各一次；除此表所列 F 以外，没有 G-symbol 的 `0x1c` record。这比单纯
import 声明更强，但仍**不**表示每条执行路径都会读写 native target，也不能把
`0x1c` 改名为原始 `global.get/set`。

F1 是唯一可再收窄的例外：[已解码的 F1 listing](managed_vm_decode_cf64_f1_350101/F1_350101_F1_0x742000_0xdbd8.decoded.asm)
在 records `000c..0017` 有 `LD_POOL_PTR + LD64` 对
`+0xB98/+0xBA8/+0xBB8` 的访问，和 G0/G1/G2 的 relocation、slot 图三者一致，
故可记录为“F1 读取对应 **8-byte pool slot**”。这仍不是 passed native target
的对象宽度，也不推出原始 global-import 的读/写方向。F0/G3 与 F23..F28/G4..G64
目前只有 data-symbol reference，读/写保持 U。

对 constructor passed target 本身的 direct-address audit 也没有产生可归属的
native LDR/STR 解引用：`0x152D94..0x1534AC` 只形成地址并写入 binding record，
再由 `0x1534D8/0x1534DC/0x1534E4` 交给 builder。特别是 `.bss` 中的 4/8-byte
相邻布局不能反推对象或字段类型。

## main sign module：`G0..G10`

main constructor 在 `0x170DEC..0x170F1C` 构造 11 项，随后
`0x170F48/0x170F4C/0x170F54` 将 `sp+0x8`、`W7=11` 和表一并交给 builder。
所有 flag 均为零。

| G | name VA | passed target | constructor range | ELF region / only safe classification |
|---:|---:|---:|---|---|
| G0 | `0x2041BC` | `0x2714C8` | `0x170DEC..0x170E04` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G1 | `0x2041C0` | `0x2715A8` | `0x170E08..0x170E20` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G2 | `0x2041C4` | `0x2715D0` | `0x170E24..0x170E3C` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G3 | `0x2041C8` | `0x2716C8` | `0x170E40..0x170E58` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G4 | `0x2041CC` | `0x2716F8` | `0x170E5C..0x170E74` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G5 | `0x2041D0` | `0x2717B8` | `0x170E78..0x170E90` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G6 | `0x2041D4` | `0x2717F8` | `0x170E94..0x170EAC` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G7 | `0x2041D8` | `0x2C5070` | `0x170EB0..0x170EC8` | `.bss` opaque shared address |
| G8 | `0x2041DC` | `0x2616A8` | `0x170ECC..0x170EE4` | `.data.rel.ro`，`R_AARCH64_RELATIVE` destination cell |
| G9 | `0x2041E0` | `0x29F890` | `0x170EE8..0x170F00` | `.data` static table base |
| G10 | `0x2041E4` | `0x29FF18` | `0x170F04..0x170F1C` | `.data`，`R_AARCH64_ABS64` destination cell |

main blob 的 import metadata 已确认 11 个 `env.G0..env.G10`，均为 mutable
`i64` global import，global index 为 `0..10` 且顺序与上表一致。这证明 main
的 G 表是 blob-level global import 的实际链接输入，而非 program/export 表。

此外，main 的 `reloc.CODE` 可给出一种较弱但可靠的 usage 证据：`0x1c`
**data-symbol relocation class**。它证明对应 F 的 code body 有显式 G
data-symbol 链接引用；保护后的 code stream 和现有 relocation 类型表尚不足以
把该引用标成 `global.get` 或 `global.set`，所以下表的读/写方向一律为未知（U）。
完整 `reloc.CODE` 共 867 项：`0x1b` 的 810/810 项指向 function symbol，
`0x1c` 的 57/57 项指向 data symbol；下表仅取其中指向 G data symbol 的 22 项。

| G | F with `0x1c` data-symbol relocation | read/write |
|---:|---|---|
| G0 | F5 | U |
| G1 | F5 | U |
| G2 | F9 | U |
| G3 | F9 | U |
| G4 | F9 | U |
| G5 | F9 | U |
| G6 | F9 | U |
| G7 | F9 | U |
| G8 | F9 | U |
| G9 | F5、F7、F8、F9、F13、F14、F24、F27、F33、F36、F41、F44 | U |
| G10 | F9 | U |

这 22 条 relocation 与表中的 `(F, G)` 对一一对应：G9 由 12 个不同 F 引用，
其余每个 G 各由 F5 或 F9 显式引用一次。其余 43 个 main F body 未出现这类
指向 G data-symbol 的 `0x1c` relocation；这只排除该**显式链接形式**，并不
证明运行时没有间接使用。

main 的 target 还可作两类更窄的静态说明。G0..G6 与 G8 是 ELF64 dynamic
relocation 的 8-byte destination cell；G10 的 cell 是 `R_AARCH64_ABS64`，其
装载值解析为 `JNI_OnLoad`。这些都只说明 ELF loader 的 pointer-sized 写入，
不说明 cell 指向的业务对象。G9 则有四个直接 native read：
`0x16D3A4` 的 2-byte `G9+0x15c`、`0x16D3A8` 的 1-byte `G9+0x15e`、
`0x16D4A4` 的 8-byte `G9+0x151`、`0x16D4AC` 的 2-byte `G9+0x159`；相邻
局部序列未见 store。它们仍不能证明任何 F 通过 `G9` 触发这些读取。对
G0..G8/G10，direct `ADRP/ADD`+nearby-memory xref pass 没有得到额外可报告的
native access；这不是“全程序无 xref”的断言。

`G9` 的 passed target 与
[source_work_static_tables_350101.md](source_work_static_tables_350101.md) 记录的
静态二级表基址相同；这证明地址身份相同，不单独证明某个 F 已经通过 `G9` 取用
该表。

## child module：`G0..G2`

| G | name VA | passed target | constructor range |
|---:|---:|---:|---|
| G0 | `0x2045E4` | `0x2C5068` (`.bss`) | `0x171FC4..0x171FDC` |
| G1 | `0x2045E8` | `0x2C506C` (`.bss`) | `0x171FE0..0x171FF8` |
| G2 | `0x2045EC` | `0x2C5070` (`.bss`) | `0x171FFC..0x172014` |

`0x172018..0x172048` 以 `W7=3` 交给 builder。这三项与 second module 的
`G0..G2` 复用完全相同的 target 地址，说明它们是跨 module 共享的注册目标；
但三个地址只相隔 4 bytes，不能据此假定为三个指针、三个 `u32`，或任意具体
业务字段。

child package 的 21 个 import 中，#18/#19/#20 分别为 `env.G0/G1/G2`，global
index 为 #0/#1/#2，均为 mutable `i64` global import。对
`0x2C5068/0x2C506C/0x2C5070` 的 direct-address audit 仅得到 7 次 constructor
materialization：second 的 `0x152DA0/0x152DBC/0x152DD8`、main G7 的
`0x170EBC`、child 的 `0x171FD0/0x171FEC/0x172008`。这个结果不排除经指针流、
relocation 或 managed code 的访问，但没有可归属的 native LDR/STR 解引用。
离线 package 结构交叉确认 `G0/G1/G2` 均为 linking data symbol，且三条 G 相关
`reloc.CODE` 记录都归属 child `F0`，故可闭合 `F0→G0/G1/G2` 的静态引用。已有
child `F0` decoded listing 还独立显示三组对应 package slot 的 `LD_POOL_PTR→LD64`，
因此只把它们记作 F0 对三个 **8-byte package slot** 的窄读取；不推出原始 global
的读/写方向、passed target 的类型，或跨 F 的数据流。

child 已解码 program 中的 `0x5e` 是 module-local program dispatch，相关
import `0..16` 是 child CF，而不是这里的 G binding。详见
[cf75_child_module_boundary_350101.md](cf75_child_module_boundary_350101.md)。

## 本轮闭合状态与剩余边界

| evidence layer | closed scope | status |
|---|---|---|
| constructor registration + builder G-map | 80/80 G binding | closed |
| blob global-import ABI | 80/80 `env.Gx`，mutable `i64` | closed |
| binder target store | target value 写入 module import slot，8-byte store | closed |
| F→G data-symbol reference | HTTP 1/1；second 65/65；main 11/11；child 3/3；合计 80/80 G | closed as static association |
| managed slot read | second F1→G0/G1/G2；child F0→G0/G1/G2 的 package slot，`LD64` | narrow closed |
| original global get/set direction、host target object type/field semantics | all G | intentionally U |

因此，“G 表分析完成”在本台账中表示 registration、link ABI、symbol-class usage 和
可验证的 direct native access 都已记录到证据上限；不把未知部分伪装成实现。若需
继续收窄，native relocation parser 的静态审计已表明它只校验/消费 record 字节并推进
cursor，未材料化 record 字段，也未出现 code/data patch store；当前已见的
parser→build→bind 调用链也未找到独立 materializer。该结论仅限现有静态材料，不能
推出全局不存在另一条 loader；因此仍不能单独证明 operand 形式、写入宽度或端序，且须
分开证明原始 global 的读/写方向和 passed target 的对象语义。当前 managed runtime
不应把任何 U 项建模为零值、普通指针或 CF callback。
