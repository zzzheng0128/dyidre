#!/usr/bin/env python3
"""从 fresh_trace 运行产物中提取 JSON 字符串与 JNI 反射清单，生成 markdown 报告。"""
import re
import sys
import collections

run_dir = "/Users/freeman/project/douyin/dyidre/runs/350101/fresh_trace"
stdout_log = open(f"{run_dir}/stdout.log", encoding="utf-8", errors="replace").read()
mem_log = open(f"{run_dir}/mem_strings.log", encoding="utf-8", errors="replace").read()

# ---------- 1. JNIEnv-> 调用全量解析 ----------
# 按行状态机：单行调用直接解析；多行参数（NewStringUTF 内嵌换行 JSON 等）累积到
# 出现 " was called from RX@" 为止。注意 unidbg 的 GetMethodID 等行没有右括号：
#   JNIEnv->GetMethodID(java/lang/String.getBytes(...)[B) => 0x318b4ca9 was called from RX@...
call_pat = re.compile(
    r"^JNIEnv->(\w+)\((.*) was called from RX@0x[0-9a-f]+\[([^\]]+)\](0x[0-9a-f]+)",
    re.DOTALL)
calls = []  # (func, args, module, offset)
buf = None
for line in stdout_log.splitlines():
    if buf is None:
        if "JNIEnv->" in line and " was called from RX@" not in line:
            buf = line
            continue
        if "JNIEnv->" in line:
            text = line
        else:
            continue
    else:
        buf += "\n" + line
        if " was called from RX@" not in line:
            continue
        text = buf
        buf = None
    m = call_pat.search(text)
    if m:
        func, args, mod, off = m.group(1), m.group(2), m.group(3), m.group(4)
        calls.append((func, args.strip(), mod, off))

by_func = collections.Counter(c[0] for c in calls)

# FindClass / 方法ID / 字段ID 聚类
find_class = collections.Counter()
method_ids = collections.Counter()
field_ids = collections.Counter()
new_strings = []
call_sites = collections.Counter()
for func, args, mod, off in calls:
    if func == "FindClass":
        find_class[args] += 1
    elif func in ("GetMethodID", "GetStaticMethodID", "GetFieldID", "GetStaticFieldID"):
        method_ids[f"{func}: {args.replace(chr(10), ' ')}"] += 1
    elif func == "NewStringUTF":
        s = args
        if s.endswith(")"):
            s = s[:-1]
        if s.startswith('"') and s.endswith('"'):
            s = s[1:-1]
        new_strings.append((s, off))
    elif func.startswith("Call") or func in ("NewObject", "NewObjectArray", "RegisterNatives"):
        head = args.split("\n")[0][:120]
        call_sites[f"{func}({head})"] += 1

# ---------- 2. MS.b 回调 ----------
msb_pat = re.compile(r"\[350101\]\[MS\.b\] op=(0x[0-9a-f]+) arg1=(\S+) arg2=(\S+) str=(.*?) obj=(.*?) => (.*)")
msb = msb_pat.findall(stdout_log)

# ---------- 3. JSON 提取 ----------
def looks_json(s):
    s = s.strip()
    return (s.startswith("{") and s.endswith("}")) or (s.startswith("[") and s.endswith("]"))

json_items = []
for s, off in new_strings:
    if looks_json(s):
        json_items.append(("NewStringUTF", off, s))
for op, a1, a2, st, obj, ret in msb:
    if looks_json(st):
        json_items.append((f"MS.b op={op} str 参数", "-", st))
    # obj 形如 ArrayObject<object[3]>，里面元素在 SetObjectArrayElement 里
soe_pat = re.compile(r'SetObjectArrayElement\(.*?\) => "(.*?)" was called from RX@0x[0-9a-f]+\[[^\]]+\](0x[0-9a-f]+)', re.DOTALL)
for m in soe_pat.finditer(stdout_log):
    s = m.group(1)
    if looks_json(s):
        json_items.append(("SetObjectArrayElement", m.group(2), s))

# 去重保持顺序
seen = set()
uniq_json = []
for src, off, s in json_items:
    if s not in seen:
        seen.add(s)
        uniq_json.append((src, off, s))

# ---------- 4. mem log 里的 proto wire 片段（含 0x42/0x48 tag + ascii 版本串） ----------
proto_hits = []
blocks = re.split(r"\n(?=\[[RW]\] )", mem_log)
for b in blocks:
    if re.search(r"\d\.\d\.\d", b) and ("ml-android" in b or "aweme" in b or "35.1.0" in b):
        head = b.split("\n")[0]
        # 新格式：hexdump -C 风格，asc 在行尾 |...| 里，可能多行
        gutters = re.findall(r"\|(.{1,16})\|\s*$", b, re.MULTILINE)
        proto_hits.append((head, "".join(gutters)))

# ---------- 5. 生成报告 ----------
out = []
out.append("# 350101 fresh trace — JSON 与 JNI 反射提取报告\n")
out.append(f"- 运行目录：`{run_dir}`")
out.append("- 测试类：`Sign6_350101_FreshTrace`（独立于主基线 Sign6_350101，单跑一次 http_reqsign）")
out.append("- 数据源：`stdout.log`（JNIEnv 反射全量 + MS.b 回调）、`mem_strings.log`（全地址空间读写字符串监听，20000 事件上限）")
out.append(f"- JNIEnv 调用总数：{len(calls)}；MS.b 回调次数：{len(msb)}\n")

out.append("\n## 一、JSON 字符串清单（native 侧经 JNI 上抛的全部 JSON）\n")
if not uniq_json:
    out.append("（无）")
for i, (src, off, s) in enumerate(uniq_json, 1):
    one = s.replace("\n", "\\n").replace("\t", "\\t")
    out.append(f"{i}. 来源 `{src}`" + (f" @ .so 偏移 `{off}`" if off != "-" else ""))
    out.append(f"   ```json\n   {s}\n   ```")

out.append("\n## 二、JNI 反射调用聚类\n")
out.append("### 2.1 按函数统计\n")
out.append("| JNI 函数 | 次数 |")
out.append("|---|---|")
for f, n in by_func.most_common():
    out.append(f"| `{f}` | {n} |")

out.append("\n### 2.2 FindClass\n")
out.append("| 类 | 次数 |")
out.append("|---|---|")
for c, n in find_class.most_common():
    out.append(f"| `{c}` | {n} |")

out.append("\n### 2.3 MethodID / FieldID 查询\n")
out.append("| 查询 | 次数 |")
out.append("|---|---|")
for c, n in method_ids.most_common():
    out.append(f"| `{c}` | {n} |")

out.append("\n### 2.4 实际调用点（Call*/NewObject/RegisterNatives）\n")
out.append("| 调用 | 次数 |")
out.append("|---|---|")
for c, n in call_sites.most_common():
    out.append(f"| `{c}` | {n} |")

out.append("\n## 三、MS.b 回调序列（Java 层环境回调）\n")
out.append("| # | op | arg1 | arg2 | str | obj | 返回 |")
out.append("|---|---|---|---|---|---|---|")
for i, (op, a1, a2, st, obj, ret) in enumerate(msb, 1):
    st_s = st.replace("|", "\\|")[:60]
    obj_s = obj.replace("|", "\\|")[:60]
    ret_s = ret.replace("|", "\\|")[:40]
    out.append(f"| {i} | `{op}` | {a1} | {a2} | {st_s} | {obj_s} | {ret_s} |")

out.append("\n## 四、附带发现：内存里的 protobuf wire 片段\n")
out.append("mem_strings.log 尾部捕获到 `35.1.0` / `v04.09.05-ml-android` 等版本串以 LEN-tag 形式写出，")
out.append("写出点 LR = libmetasec_ml.so `0x14a530` 附近，疑似 X-Argus proto 明文拼装现场：\n")
out.append("| 事件头 | ascii |")
out.append("|---|---|")
for h, a in proto_hits[-12:]:
    out.append(f"| {h.replace('|','\\|')} | `{a}` |")

report = "\n".join(out) + "\n"
path = f"{run_dir}/report_json_jni.md"
open(path, "w", encoding="utf-8").write(report)
print(f"written: {path} ({len(report)} chars)")
print(f"jni calls={len(calls)} msb={len(msb)} json={len(uniq_json)} proto_hits={len(proto_hits)}")
