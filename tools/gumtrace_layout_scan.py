#!/usr/bin/env python3
"""Offline AArch64 GumTrace memory-layout census; no allocator or IDA required.

Addresses denote observed access views, NOT allocation identities. The tool
does not recover secrets, execute traces, apply types, or infer business names.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import time
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path

LINE = re.compile(r"^\[([^]]+)\]\s+(0x[0-9a-fA-F]+)!(0x[0-9a-fA-F]+)\s+([^;]+);(.*)")
REG = re.compile(r"\b(x\d+|w\d+|sp|wsp|fp|lr|[qdsv]\d+)=(0x[0-9a-fA-F]+)")
MEM = re.compile(r"\bmem_([rw])=(0x[0-9a-fA-F]+)")
BRACKET = re.compile(r"\[([^]]+)\]")
IMM = re.compile(r"^#?(-?(?:0x[0-9a-fA-F]+|\d+))$")
MAX_OFFSET = 0x2000
MAX_PCS = 64
MAX_SAMPLES = 4


def canon(reg):
    return {"fp": "x29", "lr": "x30", "wsp": "sp"}.get(
        reg, "x" + reg[1:] if reg.startswith("w") else reg)


def immediate(s):
    match = IMM.match(s.strip())
    return int(match[1], 0) if match else None


def width(reg, op):
    if op in {"ldpsw", "ldrsw", "ldursw", "ldtrsw"}:
        return 4
    if op.endswith(("sb", "b")):
        return 1
    if op.endswith(("sh", "h")):
        return 2
    return {"w": 4, "x": 8, "s": 4, "d": 8, "q": 16,
            "b": 1, "h": 2}.get(reg[0])


@dataclass(frozen=True)
class Alias:
    root: int
    delta: int = 0
    kind: str = "unknown"
    source: tuple | None = None  # load owner/root, offset, width, line, PC

    @property
    def value(self):
        return self.root + self.delta


@dataclass
class Fact:
    count: int = 0
    reads: int = 0
    writes: int = 0
    value_observed: int = 0
    pcs: set = field(default_factory=set)
    sites_truncated: bool = False
    samples: list = field(default_factory=list)
    first: int = 0
    last: int = 0
    pointer_uses: int = 0
    callback_uses: int = 0

    def observe(self, seq, pc, kind, known, root, ea, assembly):
        self.count += 1
        self.reads += kind == "r"
        self.writes += kind == "w"
        self.value_observed += known
        if len(self.pcs) < MAX_PCS:
            self.pcs.add(pc)
        elif pc not in self.pcs:
            self.sites_truncated = True
        self.first = self.first or seq
        self.last = seq
        if len(self.samples) < MAX_SAMPLES and not any(x["pc"] == pc for x in self.samples):
            self.samples.append({"line": seq, "pc": pc, "view": hex(root),
                                 "effective_address": hex(ea), "assembly": assembly})


@dataclass
class View:
    root: int
    fields: dict = field(default_factory=dict)
    indexed_fields: dict = field(default_factory=dict)
    indexed_patterns: Counter = field(default_factory=Counter)
    indexed_truncated_events: int = 0
    origins: Counter = field(default_factory=Counter)
    regs: Counter = field(default_factory=Counter)
    indexed: int = 0
    negative_or_wide: int = 0
    alias_accesses: int = 0
    incoming: int = 0
    outgoing: int = 0


class Scanner:
    def __init__(self, source, max_offset=MAX_OFFSET):
        self.source = source
        self.max_offset = max_offset
        self.aliases = {}
        self.views = {}
        self.stats = Counter()
        self.unsupported = Counter()
        self.modules = Counter()
        self.edges = {}
        self.sp_min = None
        self.sp_max = None
        self.tls_bases = set()
        self.stack_pages = set()
        self.prev_call_return = None
        self.pending_gap = False
        self.imports = Counter()

    def view(self, root):
        return self.views.setdefault(root, View(root))

    def get_alias(self, reg, value):
        key = canon(reg)
        tag = self.aliases.get(key)
        if tag is None or tag.value != value:
            tag = Alias(value, kind="stack" if key == "sp" else "unknown")
            self.aliases[key] = tag
        return tag

    def pointer_use(self, tag, pc, seq, callback=False):
        if tag.source is None:
            return
        root, off, size, load_line, load_pc = tag.source
        owner = self.views.get(root)
        fact = owner.fields.get((off, size)) if owner else None
        if not fact:
            return
        if callback:
            fact.callback_uses += 1
            return
        fact.pointer_uses += 1
        if root == tag.root:
            return
        key = (root, off, size, tag.root)
        if key not in self.edges:
            self.edges[key] = {"owner": hex(root), "offset": hex(off),
                               "width": size, "child_view": hex(tag.root),
                               "load_line": load_line, "load_pc": load_pc,
                               "use_line": seq, "use_pc": pc}
            owner.outgoing += 1
            self.view(tag.root).incoming += 1

    def consume(self, line, seq):
        self.stats["physical_lines"] += 1
        match = LINE.match(line)
        if not match:
            if line.startswith("call func:"):
                self.imports[line.split("call func:", 1)[1].split("(", 1)[0].strip()] += 1
                self.pending_gap = True
            return
        module, va_s, rva_s, assembly, tail = match.groups()
        va, rva = int(va_s, 16), int(rva_s, 16)
        self.modules[(module, va - rva)] += 1
        self.stats["instructions"] += 1
        pc = f"{module}+{hex(rva)}"
        split = assembly.strip().split(None, 1)
        op = split[0].lower()
        operands = split[1].lower() if len(split) == 2 else ""
        if self.pending_gap or self.prev_call_return == va:
            for reg in [f"x{i}" for i in range(19)]:
                self.aliases.pop(reg, None)
            self.stats["untraced_call_alias_resets"] += 1
        self.pending_gap = False
        self.prev_call_return = None
        before_s, arrow, after_s = tail.partition("->")
        before = {reg: int(val, 16) for reg, val in REG.findall(before_s)}
        after = {reg: int(val, 16) for reg, val in REG.findall(after_s)} if arrow else {}
        pre = {canon(reg): value for reg, value in before.items()}
        post = {canon(reg): value for reg, value in after.items()}
        for reg, value in before.items():
            if reg.startswith("w"):
                # A 32-bit observation does not establish a 64-bit alias.
                self.aliases.pop(canon(reg), None)
            elif canon(reg) in self.aliases and self.aliases[canon(reg)].value != value:
                self.aliases.pop(canon(reg), None)
            if reg == "sp":
                self.stack_pages.add(value >> 12)
                self.sp_min = value if self.sp_min is None else min(self.sp_min, value)
                self.sp_max = value if self.sp_max is None else max(self.sp_max, value)
        old_aliases = dict(self.aliases)
        generated = {}
        events = MEM.findall(before_s)
        if events:
            self.stats["memory_instructions"] += 1
            bracket = BRACKET.search(operands)
            supported = re.fullmatch(
                r"(?:ld[r]|ldur|ldar|ldxr|ldaxr|ldtr)(?:b|h|sb|sh|sw)?|"
                r"(?:str|stur|stlr|stxr|stlxr|sttr)(?:b|h)?|ldp|stp|ldpsw|ldnp|stnp", op)
            if not bracket or not supported:
                self.unsupported[op] += 1
            else:
                address_ops = [x.strip() for x in bracket[1].split(",")]
                base_reg = canon(address_ops[0])
                base = pre.get(base_reg)
                if base is None:
                    self.stats["missing_base_value"] += 1
                else:
                    tag = self.get_alias(base_reg, base)
                    view = self.view(tag.root)
                    view.origins[tag.kind] += 1
                    view.regs[base_reg] += 1
                    view.alias_accesses += tag.delta != 0
                    self.pointer_use(tag, pc, seq)
                    indexed = len(address_ops) > 1 and immediate(address_ops[1]) is None
                    indexed_tail = len(address_ops) > 2 and not indexed
                    if indexed_tail:
                        self.stats["unsupported_address_mode"] += 1
                        indexed = True
                    values = [x.strip() for x in operands[:bracket.start()].rstrip(", ").split(",")]
                    if op.startswith(("stxr", "stlxr")):
                        values = values[1:]
                    pair = op in {"ldp", "stp", "ldpsw", "ldnp", "stnp"}
                    values = values[:2] if pair else values[:1]
                    if indexed:
                        view.indexed += 1
                        view.indexed_patterns[bracket[1]] += 1
                        self.stats["indexed_memory_instructions"] += 1
                    for kind, ea_s in events:
                        ea = int(ea_s, 16)
                        w = width(values[0], op) if values else None
                        if w is None:
                            self.unsupported[op + ":width"] += 1
                            continue
                        for element, value_reg in enumerate(values):
                            address = ea + element * w
                            off = address - tag.root
                            key = canon(value_reg)
                            known = key in (post if kind == "r" else pre) or value_reg in {"xzr", "wzr"}
                            if indexed:
                                # Indexed data remains an array view; never expand
                                # each dynamic index into a fake struct member.
                                if 0 <= off and off + w <= self.max_offset:
                                    idx_key = (off, w)
                                    if idx_key in view.indexed_fields or len(view.indexed_fields) < 64:
                                        fact = view.indexed_fields.setdefault(idx_key, Fact())
                                        fact.observe(seq, pc, kind, known, tag.root, address, assembly)
                                        self.stats["indexed_field_events_recorded"] += 1
                                    else:
                                        view.indexed_truncated_events += 1
                                        self.stats["indexed_field_events_over_cap"] += 1
                                if kind == "r" and key in post:
                                    generated[key] = Alias(post[key], kind="indexed_load")
                                continue
                            if off < 0 or off + w > self.max_offset:
                                view.negative_or_wide += 1
                                self.stats["out_of_window_field_events"] += 1
                                if kind == "r" and key in post:
                                    generated[key] = Alias(post[key], kind="load_outside_view")
                                continue
                            fact = view.fields.setdefault((off, w), Fact())
                            fact.observe(seq, pc, kind, known, tag.root, address, assembly)
                            self.stats["field_events"] += 1
                            if kind == "r" and key in post and w == 8 and value_reg.startswith("x"):
                                generated[key] = Alias(post[key], kind="field_load",
                                                       source=(tag.root, off, w, seq, pc))
                    # Pre/post-indexing updates the address register AFTER the
                    # access; mem_r/mem_w is the authoritative effective address.
                    if base_reg in post and post[base_reg] != base:
                        generated[base_reg] = Alias(tag.root, post[base_reg] - tag.root,
                                                    tag.kind, tag.source)
        ops = [x.strip() for x in operands.split(",")]
        if op in {"mov", "orr"} and len(ops) >= 2:
            src = ops[1]
            if op == "orr" and len(ops) == 3 and src == "xzr":
                src = ops[2]
            if ops[0].startswith("x") and (src.startswith("x") or src in {"sp", "fp", "lr"}):
                src_reg, dst = canon(src), canon(ops[0])
                if src_reg in pre and dst in post and pre[src_reg] == post[dst]:
                    generated[dst] = self.get_alias(src_reg, pre[src_reg])
                    self.stats["mov_alias_events"] += 1
        elif op in {"add", "sub"} and len(ops) == 3 and immediate(ops[2]) is not None:
            dst, src = canon(ops[0]), canon(ops[1])
            if (ops[0].startswith("x") or dst == "sp") and src in pre and dst in post:
                delta = immediate(ops[2]) * (-1 if op == "sub" else 1)
                if post[dst] == pre[src] + delta:
                    tag = self.get_alias(src, pre[src])
                    if dst == "sp":
                        generated[dst] = Alias(post[dst], kind="stack")
                    elif tag.kind == "module_page":
                        generated[dst] = Alias(post[dst], kind="global_address")
                    elif src == "sp" or tag.kind == "stack":
                        generated[dst] = Alias(post[dst], kind="stack_derived")
                    elif abs(delta) <= self.max_offset:
                        generated[dst] = Alias(tag.root, tag.delta + delta, tag.kind, tag.source)
                    else:
                        generated[dst] = Alias(post[dst], kind="derived_unbounded")
                    self.stats["add_sub_alias_events"] += 1
        elif op in {"adrp", "adr"} and ops and canon(ops[0]) in post:
            dst = canon(ops[0])
            generated[dst] = Alias(post[dst], kind="module_page" if op == "adrp" else "global_address")
        elif op == "mrs" and "tpidr_el0" in operands and ops and canon(ops[0]) in post:
            dst = canon(ops[0])
            self.tls_bases.add(post[dst])
            generated[dst] = Alias(post[dst], kind="tls")
        if op in {"br", "blr"} and ops:
            reg = canon(ops[0])
            if reg in pre:
                self.pointer_use(self.get_alias(reg, pre[reg]), pc, seq, callback=True)
        # Any actual output register not assigned a proven alias loses old
        # provenance, even if a prior pointer had the same low 32-bit value.
        for reg, value in after.items():
            key = canon(reg)
            if op in {"cmp", "cmn", "tst"} and key in old_aliases and old_aliases[key].value == value:
                continue
            self.aliases.pop(key, None)
            if not reg.startswith("w") and key in generated and generated[key].value == value:
                self.aliases[key] = generated[key]
        # Loads without post-values must not carry a stale destination alias.
        if events and op.startswith("ld") and not after:
            for token in ops[:2]:
                self.aliases.pop(canon(token), None)
        if op in {"bl", "blr"}:
            self.prev_call_return = va + 4

    def classification(self, view):
        if view.root in self.tls_bases or view.origins["tls"]:
            return "tls_view"
        if any(view.origins[k] for k in ("stack", "stack_derived")):
            return "stack_view"
        if view.root >> 12 in self.stack_pages:
            return "stack_page_candidate"
        if view.origins["module_page"]:
            return "page_view"
        if view.origins["global_address"]:
            return "global_view"
        if view.indexed:
            return "indexed_or_mixed_view"
        if view.negative_or_wide:
            return "partial_or_moving_view"
        byte_offsets = {off for (off, size) in view.fields if size == 1}
        if len(byte_offsets) >= 8 and max(byte_offsets) - min(byte_offsets) + 1 <= len(byte_offsets) * 1.25:
            return "dense_byte_buffer_view"
        return "object_candidate"

    def export(self):
        views = []
        for view in self.views.values():
            if not view.fields and not view.indexed_fields:
                continue
            fields = []
            indexed_fields = []
            for access_map, output in ((view.fields, fields), (view.indexed_fields, indexed_fields)):
                for (off, size), fact in sorted(access_map.items()):
                    output.append({"offset": off, "width": size, "events": fact.count,
                               "reads": fact.reads, "writes": fact.writes,
                               "value_observed": fact.value_observed,
                               "pcs": sorted(fact.pcs), "pcs_truncated": fact.sites_truncated,
                               "evidence": fact.samples, "first_line": fact.first,
                               "last_line": fact.last, "dereference_uses": fact.pointer_uses,
                               "indirect_call_uses": fact.callback_uses})
            views.append({"id": f"{self.source}@{view.root:x}", "source": self.source,
                          "base": hex(view.root), "classification": self.classification(view),
                          "origins": dict(view.origins), "registers": dict(view.regs),
                          "alias_accesses": view.alias_accesses, "indexed_accesses": view.indexed,
                          "indexed_patterns": dict(view.indexed_patterns),
                          "indexed_fields": indexed_fields,
                          "indexed_truncated_events": view.indexed_truncated_events,
                          "excluded_offset_events": view.negative_or_wide,
                          "incoming_edges": view.incoming, "outgoing_edges": view.outgoing,
                          "observed_extent": max(f["offset"] + f["width"] for f in fields + indexed_fields),
                          "fields": fields})
        return views


def group_candidates(views):
    """Exact layout AND >=2 shared PC/offset sites. Never union by proximity.

    These are access-equivalent families, not a proof of a shared C++ type.
    An explicit call/lifetime model would be needed for stronger conclusions.
    """
    buckets = defaultdict(list)
    excluded = Counter()
    for view in views:
        cls = view["classification"]
        if cls not in {"object_candidate", "global_view"} or not 2 <= len(view["fields"]) <= 48:
            excluded[cls if cls not in {"object_candidate", "global_view"} else "field_count_outside_2_48"] += 1
            continue
        layout = (cls, tuple((f["offset"], f["width"]) for f in view["fields"]))
        sites = {(f["offset"], f["width"], pc) for f in view["fields"] for pc in f["pcs"]}
        placed = False
        for family in buckets[layout]:
            common = family["common_sites"] & sites
            if len({x[2] for x in common}) >= 2 and len({x[0] for x in common}) >= 2:
                family["members"].append(view)
                family["common_sites"] = common
                placed = True
                break
        if not placed:
            buckets[layout].append({"members": [view], "common_sites": sites})
    result = []
    for groups in buckets.values():
        for family in groups:
            members = family["members"]
            sources = {x["source"] for x in members}
            sites = family["common_sites"]
            two_sites = len({x[2] for x in sites}) >= 2 and len({x[0] for x in sites}) >= 2
            family["layout_confidence"] = "medium" if two_sites else "low"
            family["cross_source_repeated"] = len(sources) >= 2 and two_sites
            family["score"] = (30 * family["cross_source_repeated"] +
                               5 * min(len(members), 5) +
                               3 * sum(bool(f["dereference_uses"]) for f in members[0]["fields"]) +
                               min(len(members[0]["fields"]), 12) -
                               10 * (members[0]["observed_extent"] > 0x800))
            result.append(family)
    result.sort(key=lambda x: (-x["score"], x["members"][0]["base"]))
    for i, fam in enumerate(result, 1):
        fam["id"] = f"TRACE_OBJ_{i:04d}"
        fam["common_sites"] = [list(x) for x in sorted(fam["common_sites"])]
    return result, dict(excluded)


def field_label(field):
    off = field["offset"]
    prefix = "callback" if field["indirect_call_uses"] else "ptr" if field["dereference_uses"] else "unk"
    return f"{prefix}_{off:02x}"


def c_draft(family):
    fields = family["members"][0]["fields"]
    name = family["id"]
    # Partition overlapping byte intervals. Observed overlaps are represented
    # as opaque byte spans; no invented union discriminator or packing.
    spans = []
    for f in fields:
        start, end = f["offset"], f["offset"] + f["width"]
        if spans and start < spans[-1][1]:
            spans[-1][1] = max(end, spans[-1][1])
            spans[-1][2].append(f)
        else:
            spans.append([start, end, [f]])
    lines = [f"/* {name}: observed view; extent is not sizeof/allocation size. */", "typedef struct {"]
    cursor = 0
    checks = []
    for start, end, members in spans:
        if start > cursor:
            lines.append(f"    uint8_t unobserved_{cursor:02x}[{start-cursor}];")
        f = members[0]
        size = f["width"]
        if len(members) == 1 and size in (1, 2, 4, 8) and start % size == 0:
            label = field_label(f)
            lines.append(f"    uint{size*8}_t {label}; /* +0x{start:x}; pointer labels denote observed address use */")
        else:
            label = f"overlap_or_bytes_{start:02x}"
            lines.append(f"    uint8_t {label}[{end-start}]; /* +0x{start:x}; overlap/SIMD/unaligned evidence */")
        checks.append(f'_Static_assert(offsetof({name}, {label}) == {start}, "{name}.{label}");')
        cursor = end
    lines.extend([f"}} {name};", *checks])
    return "\n".join(lines)


def emit_report(result, outdir, top):
    families = result["families"]
    rows = ["# GumTrace 离线内存布局扫描", "",
            "本报告仅使用列出的原始 trace。所有对象名是中性观察视图；没有引用旧结构体定义、旧 IDB 或旧业务名称。",
            "", "## 输入与覆盖", "",
            "|输入|字节数|物理行数|指令数|内存指令数|字段访问事件|SHA-256|",
            "|---|---:|---:|---:|---:|---:|---|"]
    for src in result["sources"]:
        s = src["stats"]
        rows.append(f'|{src["id"]} `{src["path"]}`|{src["size_bytes"]}|{s.get("physical_lines",0)}|'
                    f'{s.get("instructions",0)}|{s.get("memory_instructions",0)}|{s.get("field_events",0)}|`{src["sha256"]}`|')
    rows += ["", "## 字段事实与候选统计", "",
             f'- 观察视图：{len(result["views"])}；归并字段事实：{sum(len(v["fields"]) for v in result["views"])}。',
             f'- 另外保留索引偏移事实：{sum(len(v.get("indexed_fields", [])) for v in result["views"])}；每个视图最多保留 64 个不同索引偏移，超额事件明确计数。',
             f'- 加载值随后被解引用的关系：{len(result["relations"])}。',
             f'- 其中跨已知生命周期边界的关系：{result.get("lifetime_review", {}).get("relations_crossing_boundary", 0)}；这些记录保留审计标记，不作为对象关联的证明。',
             f'- 筛选出的访问等价候选族：{len(families)}；跨输入重复：{sum(f["cross_source_repeated"] for f in families)}。',
             f'- 分类：`{json.dumps(dict(Counter(v["classification"] for v in result["views"])), ensure_ascii=False)}`。',
             "", "内存地址和访问宽度是直接观测。结构体边界、类型和生命周期仍属推断，最高记为 medium；跨输入重复须同时有相同字段布局和两个不同偏移上的共同指令证据。",
             "", "## 解释边界", "",
             "- `mem_r/mem_w` 提供有效地址；LDR 采用箭头右侧的结果，STR 采用箭头左侧的源寄存器。LDP/STP 分成两个元素；前/后索引以有效地址为准。",
             "- MOV 与固定 ADD/SUB 仅在寄存器实值一致时传播；32 位写入、未跟踪调用会清除相应别名。",
             "- 不依赖分配函数；基址来自已观察的访问、寄存器别名、字段解引用。视图基址可能是内部地址，不能当作 allocation 起点。",
             "- 同地址复用尚不能拆成独立生命周期；日志没有线程标识，不把物理相邻行当作跨线程因果证据。",
             "- 对日志显式记录的 free/再分配做额外核查：跨越这些边界的同址聚合从结构体候选排除。未记录的自定义回收仍无法据此拆分。",
             "- 栈、TLS、ADRP 页基址和索引访问单列；不把连续扫描的每个字节扩成结构体成员。",
             "- 跨文件地址不直接比较；共享的静态访问 PC 仅是访问等价证据，多个对象调用同一个 helper 仍可能类型不同。",
             "- 日志没有提供 SO 的字节哈希；同 RVA 的跨输入重复是辅助证据，不能替代二进制版本校验。",
             "- 指针由字段值后续被实际解引用证明；函数指针由间接分支使用证明。单个槽不足以确认 vtable。",
             "- 重叠读写也可能来自宽拷贝或复用；C 草案用不透明字节区表达，不强推 union。最小观察范围不等于实际大小；空白区只是未观察区域。",
             "- 此扫描不能单凭调用缺失证明自定义分配器，也不能单凭跟踪中未出现某条路径证明该路径不存在。",
             "", "## 候选目录", "",
             "完整字段/视图保存在 JSON；下面按跨样本重复、独立访问及指针边排序列出候选。", "",
             "|候选|置信度|视图数|输入数|字段数|观察范围|",
             "|---|---|---:|---:|---:|---:|"]
    for fam in families[:top]:
        rep = fam["members"][0]
        rows.append(f'|{fam["id"]}|{fam["layout_confidence"]}|{len(fam["members"])}|'
                    f'{len(set(v["source"] for v in fam["members"]))}|{len(rep["fields"])}|`{hex(rep["observed_extent"])}`|')
    for fam in families[:top]:
        rep = fam["members"][0]
        rows += ["", f'### {fam["id"]}', "",
                 f'代表视图：`{rep["id"]}`；来源类别 `{rep["origins"]}`。',
                 f'重复视图：' + ", ".join(f'`{v["id"]}`' for v in fam["members"][:6]) + "。", "",
                 "|偏移|宽度|读/写次数|后续用途|证据（原始日志物理行）|",
                 "|---:|---:|---:|---|---|"]
        for f in rep["fields"]:
            ev = "; ".join(f'{e["pc"]} / {rep["source"]}:{e["line"]}' for e in f["evidence"][:2])
            use = "间接分支" if f["indirect_call_uses"] else "解引用为地址" if f["dereference_uses"] else "未确认"
            rows.append(f'|`{hex(f["offset"])}`|{f["width"]}|{f["reads"]}/{f["writes"]}|{use}|{ev}|')
        rows += ["", "```c", c_draft(fam), "```", "",
                 "缺口：真实分配边界、同地址复用、完整初始化/释放路径，以及字段语义需进一步证据；当前不应用 IDA 类型。"]
    rows += ["", "## 未确认项及后续证据", "",
             "1. 自定义分配：需要同一次记录里的 arena/slab 初始化、游标或空闲链更新、返回地址，以及回收/复用时间点，才能证明分配粒度与生命周期。",
             "2. 真正的结构边界：需要对象根在函数边界传入/返回的记录；仅看到内部指针读写时只能报告子视图。",
             "3. 指针/长度/容量的具体角色：需要字段参与比较、地址计算、扩展或释放的证据；数值大小本身不足以定名。",
             "4. 栈包与帧：需线程 ID、调用深度/帧标识才能可靠区别同一栈地址在不同调用中的复用。",
             "5. 访问日志只覆盖执行过的路径，无法据此宣称全 SO 已恢复。", "",
             "## 各输入解析限制", ""]
    for src in result["sources"]:
        rows.append(f'- {src["id"]}：未支持内存指令 `{src["unsupported_memory"]}`；其他计数 `{src["stats"]}`。')
    rows += ["", "## 分配相关的实际记录", "",
             "这些计数仅来自 trace 中显式的 call func 记录，不参与对象根筛选；因此不依赖 malloc 才能产出候选。", "",
             "|输入|malloc|calloc|realloc|free|", "|---|---:|---:|---:|---:|"]
    for src in result["sources"]:
        calls = src["import_calls_observed"]
        rows.append(f'|{src["id"]}|{calls.get("malloc",0)}|{calls.get("calloc",0)}|{calls.get("realloc",0)}|{calls.get("free",0)}|')
    rows += ["", "标准分配调用仍存在；是否还存在对象池/arena/自定义分配，不能由该计数单独确认。", "",
             "## 索引访问的待确认视图", "",
             "保留动态偏移供进一步区分 record array、稀疏字段与工作区，不自动提升为结构体。", "",
             "|来源及视图|分类|索引事件|已保留偏移/宽度（最多展示 12 项）|超限事件|",
             "|---|---|---:|---|---:|"]
    indexed = sorted((v for v in result["views"] if v.get("indexed_fields")),
                     key=lambda v: -v["indexed_accesses"])
    for v in indexed[:25]:
        desc = ", ".join(f'{hex(f["offset"])}/{f["width"]}' for f in v["indexed_fields"][:12])
        rows.append(f'|`{v["id"]}`|{v["classification"]}|{v["indexed_accesses"]}|{desc}|{v["indexed_truncated_events"]}|')
    if result.get("lifetime_review"):
        rows += ["", "## 同地址复用复核", "",
                 f'检测出 {result["lifetime_review"]["excluded_views"]} 个跨已记录生命周期的访问视图，已排除自动结构体提升。',
                 "", "|视图|访问区间（物理行）|区间内的已知边界|", "|---|---|---|"]
        reused = [v for v in result["views"] if v.get("known_lifetime_boundaries")]
        for v in reused[:20]:
            rows.append(f'|`{v["id"]}`|{v["observed_line_span"]}|{v["known_lifetime_boundaries"][:6]}|')
    (outdir / "report.md").write_text("\n".join(rows) + "\n", encoding="utf-8")
    (outdir / "layout_candidates.h").write_text(
        "#pragma once\n#include <stdint.h>\n#include <stddef.h>\n\n" +
        "\n\n".join(c_draft(f) for f in families[:top]) + "\n", encoding="utf-8")


def allocation_history(path):
    """Optional negative evidence; allocation events are never root seeds."""
    history = defaultdict(list)
    call_re = re.compile(rb"^call func: (malloc|calloc|realloc|free)\(([^)]*)\)")
    ret_re = re.compile(rb"^ret: (0x[0-9a-fA-F]+)")
    pending = None
    with Path(path).open("rb") as fp:
        for seq, raw in enumerate(fp, 1):
            if raw.startswith(b"call func:"):
                pending = None
                match = call_re.match(raw)
                if not match:
                    continue
                name = match[1].decode()
                try:
                    args = [int(x.strip(), 0) for x in match[2].split(b",")]
                except ValueError:
                    continue
                if name == "free" and args:
                    history[args[0]].append({"line": seq, "event": "free"})
                else:
                    pending = (name, args, seq)
            elif pending and raw.startswith(b"ret:"):
                match = ret_re.match(raw)
                name, args, call_line = pending
                pending = None
                if not match or not int(match[1], 16):
                    continue
                address = int(match[1], 16)
                if name == "realloc":
                    # Successful realloc invalidates the previous object even
                    # when the returned numeric address happens to be equal.
                    history[args[0]].append({"line": call_line, "event": "realloc_success"})
                    size = args[1] if len(args) > 1 else None
                else:
                    size = args[0] * args[1] if name == "calloc" and len(args) > 1 else args[0]
                history[address].append({"line": seq, "event": name + "_return", "size": size})
            elif pending and raw.startswith(b"["):
                # Do not attach an unrelated later return to a missing record.
                pending = None
    return history


def review_lifetimes(result):
    histories = {}
    for source in result["sources"]:
        hist = allocation_history(source["path"])
        histories[source["id"]] = hist
        source["allocation_observations"] = {hex(addr): events for addr, events in hist.items()}
    removed = 0
    for view in result["views"]:
        fields = view["fields"] + view.get("indexed_fields", [])
        if not fields:
            continue
        first, last = min(f["first_line"] for f in fields), max(f["last_line"] for f in fields)
        events = histories[view["source"]].get(int(view["base"], 16), [])
        boundaries = [e for e in events if first < e["line"] < last]
        if boundaries:
            view.setdefault("classification_before_lifetime_review", view["classification"])
            view["classification"] = "reused_address_view"
            view["observed_line_span"] = [first, last]
            view["known_lifetime_boundaries"] = boundaries
            removed += 1
    for edge in result["relations"]:
        hist = histories[edge["source"]]
        events = hist.get(int(edge["owner"], 16), []) + hist.get(int(edge["child_view"], 16), [])
        edge["crosses_known_lifetime_boundary"] = any(
            edge["load_line"] < e["line"] <= edge["use_line"] for e in events)
    result["lifetime_review"] = {"excluded_views": removed,
                                 "relations_crossing_boundary": sum(e["crosses_known_lifetime_boundary"] for e in result["relations"])}


def write_result(result, outdir, top):
    result["families"], result["excluded_from_family_grouping"] = group_candidates(result["views"])
    (outdir / "field_facts.json").write_text(json.dumps(result, ensure_ascii=False, separators=(",", ":")) + "\n", encoding="utf-8")
    emit_report(result, outdir, top)
    print(json.dumps({"views": len(result["views"]), "families": len(result["families"]),
                      "relations": len(result["relations"]), "out_dir": str(outdir)}, ensure_ascii=False), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logs", nargs="*", type=Path)
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--max-lines", type=int, default=0, help="0 scans every physical line")
    parser.add_argument("--top", type=int, default=40)
    parser.add_argument("--review-existing", action="store_true", help="review already extracted facts without reparsing instructions")
    args = parser.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)
    if args.review_existing:
        result = json.loads((args.out_dir / "field_facts.json").read_text(encoding="utf-8"))
        review_lifetimes(result)
        write_result(result, args.out_dir, args.top)
        return
    if not args.logs:
        parser.error("provide logs or --review-existing")
    result = {"schema": 1, "sources": [], "views": [], "relations": []}
    for n, path in enumerate(args.logs, 1):
        scanner = Scanner(f"S{n:02d}")
        sha = hashlib.sha256()
        start = time.monotonic()
        scanned_bytes = 0
        with path.open("rb") as fp:
            for seq, raw in enumerate(fp, 1):
                if args.max_lines and seq > args.max_lines:
                    break
                sha.update(raw)
                scanned_bytes += len(raw)
                scanner.consume(raw.decode("utf-8", errors="replace"), seq)
                if seq % 1000000 == 0:
                    print(f"{scanner.source}: {seq:,} lines, {time.monotonic()-start:.1f}s, {len(scanner.views)} views", flush=True)
        info = {"id": scanner.source, "path": str(path.resolve()), "size_bytes": path.stat().st_size,
                "scanned_bytes": scanned_bytes, "complete_file_scan": scanned_bytes == path.stat().st_size,
                "sha256": sha.hexdigest(), "hash_scope": "scanned bytes", "stats": dict(scanner.stats),
                "unsupported_memory": dict(scanner.unsupported), "import_calls_observed": dict(scanner.imports),
                "module_bases": [{"module": mod, "base": hex(base), "instructions": count}
                                 for (mod, base), count in scanner.modules.items()],
                "seconds": round(time.monotonic()-start, 2)}
        result["sources"].append(info)
        result["views"].extend(scanner.export())
        result["relations"].extend({"source": scanner.source, **e} for e in scanner.edges.values())
        print(f"{scanner.source}: complete={info['complete_file_scan']} {dict(scanner.stats)}", flush=True)
    review_lifetimes(result)
    write_result(result, args.out_dir, args.top)


if __name__ == "__main__":
    main()
