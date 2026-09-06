# GumTrace 离线布局扫描

`gumtrace_layout_scan.py` 从已存在的 AArch64 指令日志提取内存访问视图，无需设备连接或 IDA，也不要求分配函数先被识别。

在工程根目录运行：

```bash
python3 dyidre/tools/gumtrace_layout_scan.py trace_a.log trace_b.log \
  --out-dir study_codex/trace_layout_result --top 40
```

输出 `report.md`、`field_facts.json` 和 `layout_candidates.h`。JSON 保存全量候选，Markdown/C 只展示 `--top` 指定数量。`--max-lines N` 可作格式试验，报告的 complete_file_scan 必须为 true 才代表扫描了整个文件。SHA-256 只针对实际扫描的字节。

输入格式示例：

```text
[demo.so] 0x100100!0x100 ldr x1, [x0, #8]; x1=0x0 x0=0x2000 mem_r=0x2008 -> x1=0x3000
[demo.so] 0x100104!0x104 ldr w2, [x1, #4]; w2=0x0 x1=0x3000 mem_r=0x3004 -> w2=0x5
```

第二行证明第一行加载的值随后被当作地址使用，比“数值看起来像指针”更可靠。报告保留的是访问地址、宽度、汇编和行号，不导出字符串内容或整段内存载荷。

扫描器覆盖 MOV、固定 ADD/SUB、标量和成对 LDR/STR、LDUR/STUR、常见独占/有序访问、前后索引、显式的部分原子访问。未支持的内存指令单列计数。索引访问单独收集，每个视图最多保留 64 个不同偏移；固定字段范围为基址后的 0x2000 字节，超限事件计数。阈值是扫描上限，不是对象大小证据。

分类与防误报包括：栈/TLS/页地址、连续字节块、移动基址、重叠访问、跨输入隔离；最后利用显式 malloc/calloc/realloc/free 记录排除跨已知生命周期的聚合。分配记录只用于核查，不是对象发现前提。自定义分配/回收若没有记录，仍无法可靠拆分生命周期。

已有字段提取结果只需重做生命周期审查与报告时：

```bash
python3 dyidre/tools/gumtrace_layout_scan.py \
  --out-dir study_codex/trace_layout_result --review-existing
```

仅 `--out-dir` 内的生成报告会更新，输入日志不变。工具不应用类型或改写 IDB。

验证解析逻辑：

```bash
python3 -m unittest discover -s dyidre/tools -p test_gumtrace_layout_scan.py
clang -x c -std=c11 -Wno-pragma-once-outside-header -fsyntax-only \
  study_codex/trace_layout_result/layout_candidates.h
```
