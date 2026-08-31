#!/usr/bin/env python3
"""
生成 dyidre/versions/<version>/FILE_CATALOG.md。

这个脚本解决交接里的一个小但很要命的问题：
目录里文件越来越多，后来的人不知道每个文件怎么来的、用哪个脚本生成、
后面升级版本时还能不能复用。

用法：
  python3 dyidre/scripts/generate_version_file_catalog.py 350101
  python3 dyidre/scripts/generate_version_file_catalog.py 350101 --stdout

说明：
  - 脚本按文件名/目录名模式做归类；
  - 重点文件给具体来源；
  - 无法精确归因的文件会标成“需人工补充”，后续看到就补规则。
"""

from __future__ import annotations

import argparse
import os
import re
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class FileMeta:
    category: str
    origin: str
    producer: str
    future_use: str


def dyidre_root() -> Path:
    return Path(__file__).resolve().parents[1]


def md_escape(text: str) -> str:
    return text.replace("|", "\\|").replace("\n", " ")


def file_size(path: Path) -> str:
    if path.is_dir():
        return "-"
    size = path.stat().st_size
    if size < 1024:
        return str(size)
    if size < 1024 * 1024:
        return f"{size / 1024:.1f}K"
    return f"{size / (1024 * 1024):.1f}M"


IMPORTANT: dict[str, FileMeta] = {
    "README.md": FileMeta(
        "入口文档",
        "人工整理",
        "手工维护",
        "接手 350101 先读，快速知道当前结论和核心文件。",
    ),
    "FILE_CATALOG.md": FileMeta(
        "交接清单",
        "目录扫描生成",
        "dyidre/scripts/generate_version_file_catalog.py",
        "说明本目录文件来源、生成脚本和后续用途；提交前可重跑更新。",
    ),
    "analysis_trajectory_350101.md": FileMeta(
        "分析轨迹",
        "350101 实际分析过程沉淀",
        "人工维护",
        "后续升级版本复制成 analysis_trajectory_<version>.md，逐项替换证据。",
    ),
    "summary.json": FileMeta(
        "结构证据",
        "entrydump/read-write trace 聚合",
        "dyidre/skills/metasec_struct_infer.py",
        "机器可读结构证据，供结构提升、IDA 注释和后续脚本复用。",
    ),
    "x0_evidence.md": FileMeta(
        "结构证据",
        "X0/ctx 读写证据聚合",
        "dyidre/skills/metasec_struct_infer.py",
        "按 offset 看 ctx 字段证据，升级时对照字段是否漂移。",
    ),
    "x0_struct.h": FileMeta(
        "结构草稿",
        "X0/ctx offset 自动骨架",
        "dyidre/skills/metasec_struct_infer.py",
        "早期稀疏结构草稿；不直接当最终结构。",
    ),
    "x0_promote_plan.md": FileMeta(
        "结构提升",
        "summary.json 二次整理",
        "dyidre/skills/metasec_struct_promote.py",
        "说明哪些字段可提升、哪些字段继续观察。",
    ),
    "x0_tail_timeline.md": FileMeta(
        "结构时间线",
        "ctx 尾部 scratch/output 写入时间线",
        "dyidre/skills/metasec_struct_infer.py",
        "追 ctx+0x3c0..0x500 一类输出/scratch 区。",
    ),
    "metasec_ctx350_draft.h": FileMeta(
        "结构体",
        "动态证据 + IDA 静态访问人工合并",
        "人工维护",
        "导入 IDA/对照新版本 ctx 布局。",
    ),
    "metasec_structs_350_all.h": FileMeta(
        "结构体",
        "334 旧结构 + 350101 动态证据修正",
        "人工维护",
        "当前结构总快照，IDA Local Types 和 unidbg 注释参考。",
    ),
    "metasec_so_identity.md": FileMeta(
        "SO 身份",
        "原始 SO hash/build-id/string anchors",
        "/Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_so_probe.py",
        "确认分析结论对应哪份 SO；升级版本第一步对照它。",
    ),
    "real_vs_unidbg_entry_shape.md": FileMeta(
        "入口 ABI",
        "真机 entrydump + unidbg entrydump",
        "dyidre/skills/metasec_entrydump_compare.py",
        "确认 X0-X5/X8 参数形态一致，避免 unidbg 输入偏掉。",
    ),
    "req01_app_log_s1s2_unidbg_sync_350101.md": FileMeta(
        "请求基准",
        "真机 request01 s1/s2 同步到 unidbg",
        "人工整理 + unidbg baseline",
        "说明固定请求怎么来的，后续算法验证都用这一组。",
    ),
    "environment_inputs_350101.md": FileMeta(
        "环境输入",
        "true-env/jnitrace/unidbg stub 汇总",
        "人工整理",
        "区分算法常量和真机环境值，避免把 fixed env 当算法。",
    ),
    "unidbg_env_fill_350101.md": FileMeta(
        "unidbg 环境",
        "JNI/MS.b/.msdata/rootfs 补齐过程",
        "人工整理 + unidbg 日志",
        "新版本 unidbg 跑不通时先看这里补环境。",
    ),
    "algorithm_validation_350101.md": FileMeta(
        "算法验收",
        "C oracle + unidbg deterministic replay",
        "run_recovered_c_oracles_350101.sh + unidbg baseline",
        "提交前确认算法是否仍然 byte-exact。",
    ),
    "deterministic_replay_350101.md": FileMeta(
        "确定性复现",
        "固定时间/随机/env 的 unidbg replay",
        "run_sign6_350101_deterministic.sh",
        "验证同一输入每次输出一致。",
    ),
    "deterministic_verify_350101.latest.md": FileMeta(
        "确定性验收",
        "最近一次 deterministic verify 结果",
        "verify_unidbg_deterministic_350101.py",
        "快速查看当前 baseline 是否对齐。",
    ),
    "build_signed_http_headers_350_recovered.c": FileMeta(
        "HTTP 总流程",
        "IDA 反编译 + trace 证据人工 lift",
        "人工维护",
        "从请求到 X-header 写出的主流程伪 C。",
    ),
    "x_headers_generation_350101.md": FileMeta(
        "X-header 链路",
        "TreeMap put/xheader probe + IDA 路径",
        "人工整理",
        "看每个 X-* header 在哪里生成、哪里写出。",
    ),
    "x_headers_algorithms_350101.md": FileMeta(
        "X-header 算法",
        "各 CF/VM/C oracle 汇总",
        "人工整理",
        "按 header 口径看算法还原进度。",
    ),
    "x_headers_algorithms_350101.c": FileMeta(
        "X-header C oracle",
        "算法还原代码",
        "人工维护",
        "固定输入下生成/验证各 X-* header 的 C 实现。",
    ),
    "fixed_s1_s2_signer_350101.md": FileMeta(
        "固定请求 signer",
        "C fixed signer 验证说明",
        "人工整理",
        "说明只输入 s1/s2 + fixed env 生成完整 header 的验收口径。",
    ),
    "metasec_350101_fixed_signer.c": FileMeta(
        "固定请求 signer",
        "C fixed signer 实现",
        "人工维护",
        "最终算法还原的可执行雏形。",
    ),
    "metasec_350101_recovered_c.h": FileMeta(
        "C oracle 接口",
        "手工整理公共接口",
        "人工维护",
        "多个 recovered C 文件共享的头文件。",
    ),
    "metasec_350101_recovered_c_suite.c": FileMeta(
        "C oracle suite",
        "统一测试入口",
        "人工维护",
        "把各 CF/header oracle 串起来做回归。",
    ),
    "run_recovered_c_oracles_350101.sh": FileMeta(
        "C oracle runner",
        "统一编译/运行脚本",
        "人工维护",
        "提交前跑它确认 C 还原没坏。",
    ),
    "managed_vm_boot_350101.md": FileMeta(
        "managed VM",
        ".init_array/module build 静态分析 + unidbg dump",
        "人工整理",
        "解释 managed module/F 程序怎么启动。",
    ),
    "managed_vm_recovery_350101.md": FileMeta(
        "managed VM",
        "managed bytecode decode + trace",
        "metasec_managed_vm_decoder.py + 人工整理",
        "记录 opcode、slot 模型、F5/F7/F8/F13 路线。",
    ),
    "managed_vm_program_lift_350101.md": FileMeta(
        "managed VM lift",
        "decoded asm/linear.c 二次提升",
        "人工整理",
        "把 F 程序提升成业务流程，升级时对照差异。",
    ),
    "managed_cf_semantics_350101.md": FileMeta(
        "CF 语义",
        "CF trace + IDA 分析",
        "人工整理",
        "说明 CFxx helper 各自做什么。",
    ),
    "managed_cf_recovered_350.c": FileMeta(
        "CF C lift",
        "高价值 CF helper 伪 C",
        "人工维护",
        "把 VM callback 原语变成可读 C。",
    ),
    "managed_cf_table_sign_350101.md": FileMeta(
        "CF 表",
        "sign module CF 注册表抽取",
        "/Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_cf_table_probe.py",
        "新版本快速对齐 CF index/name/callsite。",
    ),
    "managed_sign_cf_table_350101.md": FileMeta(
        "CF 表",
        "sign module CF 注册表抽取",
        "/Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_cf_table_probe.py",
        "unidbg focused probe 的 callsite 来源。",
    ),
    "exeVMInner_x_headers_350101.md": FileMeta(
        "native VMP",
        "GumTrace + IDA wrapper 分析",
        "gum-exevm/native-vmp probe + 人工整理",
        "说明 0x4CC10 在 X-header 里的角色和 vmCode 分布。",
    ),
    "flat_dispatch_350101.md": FileMeta(
        "控制流混淆",
        "IDA/GumTrace 分析",
        "人工整理",
        "识别 flattened dispatcher，避免误判成算法主线。",
    ),
    "ida_rename_update_350101_20260831.md": FileMeta(
        "IDA 落库",
        "IDA rename/prototype/comment 记录",
        "dyidre/skills/ida_apply_metasec_struct_evidence.py + ida-pro-mcp",
        "说明哪些名字/中文注释已经写回 IDA。",
    ),
    "edbg_assist_plan_350101.md": FileMeta(
        "eDBG/stackplz",
        "硬断点/watch 辅助方案",
        "人工整理",
        "RF 太吵时用 eDBG/stackplz 精确追字段写入。",
    ),
    "stackplz_rf_rpc_bridge_350101.md": FileMeta(
        "eDBG/stackplz",
        "RF RPC + stackplz bridge 实测记录",
        "stackplz-bridge probe",
        "后续按 module+offset 下硬断点的模板。",
    ),
}


def classify(rel: str, path: Path) -> FileMeta:
    name = path.name
    if rel in IMPORTANT:
        return IMPORTANT[rel]

    if path.is_dir():
        if rel.startswith("managed_vm_decode"):
            return FileMeta(
                "managed VM decode 目录",
                "managed program dump 解码结果",
                "/Users/freeman/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py",
                "升级时对照 F 程序 opcode/linear.c/unknown 统计。",
            )
        if rel == "vm_lift_1f7860":
            return FileMeta(
                "native VMP lift 目录",
                "GumTrace 切片 + native VMP 人工 lift",
                "gum-exevm/native-vmp probe + 人工整理",
                "追 vmCode=0x1f7860 的输入输出和 C lift。",
            )
        if rel == "instr_diff_350101":
            return FileMeta(
                "指令路径 diff 目录",
                "真机 GumTrace/instrseq 与 unidbg instrseq 对比",
                "dyidre/skills/metasec_instrseq_diff.py",
                "判断 raw PC 差异是否影响算法主线。",
            )
        if re.fullmatch(r"(one|multi)_request_compare_\d+", rel):
            return FileMeta(
                "请求对比目录",
                "真机 counter + unidbg one/multi request 对比",
                "counter-one/counter-multi probe + unidbg baseline",
                "判断单请求/多请求路径是否稳定。",
            )
        if rel == "true_request_vectors":
            return FileMeta(
                "真机请求向量",
                "从真机 app log/request dump 固化的 s1/s2",
                "人工整理 + unidbg sync 脚本",
                "固定算法输入，避免每次换请求造成假差异。",
            )
        return FileMeta("目录", "人工/脚本生成", "见目录内 README 或上级报告", "承载同类证据或中间产物。")

    if "/managed_vm_decode" in f"/{rel}":
        if name.endswith(".decoded.asm"):
            return FileMeta(
                "managed VM decoded asm",
                "managed bytecode dump 解码",
                "metasec_managed_vm_decoder.py",
                "看原始 VM 指令序列。",
            )
        if name.endswith(".linear.c"):
            return FileMeta(
                "managed VM linear C",
                "decoded asm 线性提升",
                "metasec_managed_vm_decoder.py",
                "作为人工 lift/C oracle 的中间层。",
            )
        if name.endswith(".decoded.stats.md") or name == "managed_vm_decode_summary.md":
            return FileMeta(
                "managed VM decode 统计",
                "decoder 统计",
                "metasec_managed_vm_decoder.py",
                "确认 unknown opcode 是否为 0，升级时先看这个。",
            )

    if re.match(r"^instr_diff_\d+/", rel):
        if name.endswith(".seq") or name.endswith(".tsv"):
            return FileMeta(
                "路径序列",
                "真机/unidbg 指令或 BLR/CF 序列",
                "GumTrace/unidbg trace 后处理",
                "给 diff 报告提供原始序列。",
            )
        return FileMeta(
            "路径 diff 报告",
            "真机 vs unidbg 指令/语义路径对比",
            "dyidre/skills/metasec_instrseq_diff.py + 人工整理",
            "确认差异是否只是 helper 级别。",
        )

    if re.match(r"^(one|multi)_request_compare_\d+/", rel):
        if re.fullmatch(r"(true_)?req_?\d*_*s[12]\.txt", name) or name in {"true_s1.txt", "true_s2.txt"}:
            return FileMeta(
                "请求向量",
                "真机单请求/多请求样本里的 s1/s2",
                "counter-one/counter-multi probe + 人工固化",
                "升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。",
            )
        return FileMeta(
            "请求对比证据",
            "真机请求与 unidbg 请求对比",
            "counter probe + unidbg baseline",
            "定位路径/值差异是否随请求变化。",
        )

    if rel.startswith("true_request_vectors/"):
        return FileMeta(
            "请求向量",
            "真机 request01 s1/s2 和同步结果",
            "人工整理 + unidbg aligned run",
            "固定后续算法验证输入。",
        )

    if rel.startswith("vm_lift_1f7860/"):
        if name.endswith(".c"):
            return FileMeta(
                "native VMP C lift",
                "vmCode=0x1f7860 人工恢复",
                "GumTrace 切片 + IDA 分析",
                "复现 native material builder。",
            )
        return FileMeta(
            "native VMP 证据",
            "GumTrace raw/slice/asm",
            "gum-exevm/native-vmp probe",
            "支撑 native VMP lift。",
        )

    if name.endswith(".log"):
        return FileMeta(
            "运行日志",
            "oracle/unidbg/脚本运行输出",
            "对应 runner 或验证脚本",
            "复查当时结果；可用新 run 替换 latest。",
        )

    if name.endswith(".bin"):
        return FileMeta(
            "二进制向量",
            "从 trace/log 提取的 raw pack、CF 输入或 header bytes",
            "metasec_*_report.py / true-env / 人工提取",
            "C oracle 的 byte-exact 测试向量。",
        )

    if name.endswith(".json"):
        return FileMeta(
            "机器可读证据",
            "probe/unidbg/后处理脚本输出",
            "对应 probe 或 dyidre/scripts 后处理",
            "给后续脚本、对比和报告复用。",
        )

    if name.endswith(".sh"):
        return FileMeta(
            "runner 脚本",
            "人工整理",
            "shell",
            "一键复跑对应验证或 unidbg 场景。",
        )

    if name.endswith(".py"):
        return FileMeta(
            "后处理脚本",
            "人工整理",
            "python",
            "解析日志或验证 deterministic baseline。",
        )

    if name.endswith(".h"):
        return FileMeta(
            "C/IDA 头文件",
            "结构体或 C oracle 公共声明",
            "人工维护",
            "IDA Local Types / C oracle 共享。",
        )

    if name.endswith(".c"):
        if name.startswith("cf") or "recovered" in name or "oracle" in name:
            return FileMeta(
                "C oracle",
                "VM/CF/算法人工还原",
                "人工维护",
                "byte-exact 验证具体算法片段。",
            )
        return FileMeta(
            "C 代码",
            "人工整理",
            "人工维护",
            "算法 lift 或说明性伪 C。",
        )

    if name.endswith(".md"):
        if name.startswith("cf41") or name.startswith("cf43") or name.startswith("cf48") or name.startswith("cf61"):
            return FileMeta(
                "CF 恢复报告",
                "CF trace + IDA + oracle",
                "人工整理",
                "说明 CF helper 的算法身份和验证向量。",
            )
        if name.startswith("f5_") or name.startswith("x_argus"):
            return FileMeta(
                "X-Argus 报告",
                "F5/CF pack/watch/oracle",
                "metasec_argus_*_report.py + 人工整理",
                "恢复 X-Argus pack、加密、base64 链路。",
            )
        if name.startswith("f8_") or name.startswith("x_medusa") or name.startswith("f12_"):
            return FileMeta(
                "X-Medusa 报告",
                "F8/F12/source-work/watch/oracle",
                "true-env/f8-watch/metasec_f12_bitpack_oracle.py + 人工整理",
                "恢复 X-Medusa final pack 和 source-work。",
            )
        if name.startswith("source_work") or name.startswith("f18_") or name.startswith("f19_") or name.startswith("f20_"):
            return FileMeta(
                "source-work 报告",
                "managed VM source-work family trace/lift",
                "metasec_workarea_timeline.py + decoder + 人工整理",
                "恢复 F18/F19/F20/F21 family 和嵌套变换。",
            )
        return FileMeta(
            "分析报告",
            "人工整理或脚本输出后人工修订",
            "见报告正文命令/证据段",
            "作为升级版本对照和交接说明。",
        )

    return FileMeta("未分类", "需人工补充", "需人工补充", "看到这个分类就补规则或在 README 解释。")


def collect(version_dir: Path) -> list[tuple[str, Path, FileMeta]]:
    items: list[tuple[str, Path, FileMeta]] = []
    for path in sorted(version_dir.rglob("*")):
        rel = path.relative_to(version_dir).as_posix()
        # 跳过 macOS 资源叉和隐藏缓存。
        if any(part.startswith("._") for part in rel.split("/")):
            continue
        if "__pycache__" in rel.split("/"):
            continue
        items.append((rel, path, classify(rel, path)))
    return items


def render(version: str, version_dir: Path, items: list[tuple[str, Path, FileMeta]]) -> str:
    category_counts: dict[str, int] = {}
    for _, _, meta in items:
        category_counts[meta.category] = category_counts.get(meta.category, 0) + 1

    lines: list[str] = []
    lines.append(f"# {version} 文件来源、生成脚本和后续用途")
    lines.append("")
    lines.append("这个文件是版本目录的交接清单。它回答三个问题：")
    lines.append("")
    lines.append("- 这个文件怎么来的；")
    lines.append("- 是哪个脚本或流程生成的；")
    lines.append("- 后面升级版本时它有什么用。")
    lines.append("")
    lines.append("它的主要目的不是归档，而是给下一个版本复用。比如分析 37xx 时，")
    lines.append("先拿本目录当 350101 基准：同类文件照着生成，同类结论逐项对齐，")
    lines.append("能复用的 C oracle/结构/offset 定位方法直接迁移，不能复用的地方留下差异证据。")
    lines.append("")
    lines.append("更新命令：")
    lines.append("")
    lines.append("```bash")
    lines.append(f"python3 scripts/generate_version_file_catalog.py {version}")
    lines.append("```")
    lines.append("")
    lines.append("如果你是在上级工作区 `/Users/freeman/project/douyin` 执行，则把命令前面加 `dyidre/`。")
    lines.append("")
    lines.append("版本目录：")
    lines.append("")
    lines.append("```text")
    lines.append(version_dir.relative_to(dyidre_root()).as_posix())
    lines.append("```")
    lines.append("")
    lines.append("## 升级新版本时怎么用")
    lines.append("")
    lines.append("| 350101 文件类型 | 分析 37xx 时怎么用 |")
    lines.append("|---|---|")
    lines.append("| `metasec_so_identity.md` / `materials_manifest.md` | 先确认 37xx 的 APK/SO/i64 身份，不要靠文件名猜版本。 |")
    lines.append("| `analysis_trajectory_350101.md` / `README.md` | 复制成新版本轨迹，逐项替换 offset、hash、日志和结论。 |")
    lines.append("| `probes/<version>/` 对应脚本产物 | 先复制 350101 probe，改 offset 表，再抓一条真机基准请求。 |")
    lines.append("| `real_vs_unidbg_entry_shape.md` / `environment_inputs_350101.md` | 对齐入口 ABI 和真机环境；37xx 跑不通时先查这里对应字段。 |")
    lines.append("| `managed_vm_decode*/` / `managed_cf_*` | 对比 F 程序、CF 表、slot/handler 是否漂移；优先看 unknown opcode 和 CF index。 |")
    lines.append("| `x_argus*` / `x_medusa*` / `source_work*` | 按 header 分段验证，确认 37xx 是沿用算法、换常量，还是换 VM 程序。 |")
    lines.append("| `*_recovered_*.c` / `metasec_*fixed_signer.c` | 作为 byte-exact oracle；37xx 每还原一段就补向量跑回归。 |")
    lines.append("| `ida_rename_update_*.md` / `metasec_structs_*_all.h` | 迁移 IDA 命名、结构和中文注释，但必须用 37xx 证据重新确认。 |")
    lines.append("")
    lines.append("## 分类统计")
    lines.append("")
    lines.append("| 分类 | 数量 |")
    lines.append("|---|---:|")
    for category, count in sorted(category_counts.items(), key=lambda kv: (-kv[1], kv[0])):
        lines.append(f"| {md_escape(category)} | {count} |")
    lines.append("")
    lines.append("## 文件清单")
    lines.append("")
    lines.append("| path | size | 分类 | 怎么来 | 生成脚本/流程 | 后续用途 |")
    lines.append("|---|---:|---|---|---|---|")
    for rel, path, meta in items:
        display = rel + ("/" if path.is_dir() else "")
        lines.append(
            "| `{}` | {} | {} | {} | {} | {} |".format(
                md_escape(display),
                file_size(path),
                md_escape(meta.category),
                md_escape(meta.origin),
                md_escape(meta.producer),
                md_escape(meta.future_use),
            )
        )
    lines.append("")
    lines.append("## 维护规则")
    lines.append("")
    lines.append("- 新增文件时，先让本脚本生成默认分类。")
    lines.append("- 如果出现 `未分类`，说明这个文件的来源/用途还没沉淀，提交前要补分类规则或在版本 README 里解释。")
    lines.append("- 脚本生成的清单不是替代分析报告；重点报告仍然要在正文里记录证据、命令和结论。")
    lines.append("- 大型真机 raw log 不放在版本目录，放 `dyidre/runs/<version>/` 或 `_archive/`。")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("version")
    parser.add_argument("--out")
    parser.add_argument("--stdout", action="store_true")
    args = parser.parse_args()

    root = dyidre_root()
    version_dir = root / "versions" / args.version
    if not version_dir.is_dir():
        raise SystemExit(f"version dir not found: {version_dir}")

    out = Path(args.out) if args.out else version_dir / "FILE_CATALOG.md"
    text = render(args.version, version_dir, collect(version_dir))
    if args.stdout:
        print(text)
    else:
        out.write_text(text + "\n", encoding="utf-8")
        print(f"[catalog] wrote {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
