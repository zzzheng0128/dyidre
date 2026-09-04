#!/usr/bin/env python3
"""Decode HTTP/2 frames from eCapture TLS text output.

用途：
  eCapture `tls -m text` 抓到的是 SSL_read/SSL_write 层的明文。
  如果 App 使用 HTTP/2，这些明文不是可直接 grep 的 HTTP 文本，而是二进制
  HTTP/2 frame；header 还经过 HPACK 压缩。

本脚本做三件事：
  1. 从 `ecapture_console.log` / `ecapture_events.log` 里抽取 READ/WRITE payload；
  2. 按 FD + direction 拼接成 HTTP/2 byte stream 并切 frame；
  3. 遇到 HEADERS/CONTINUATION 时尝试用 `hpack` 解出 header。

依赖：
  - frame 解析只用 Python 标准库；
  - header 解压需要 `pip install -r requirements-http2.txt`。

注意：
  旧的非 `--hex` eCapture log 可能已经把不可打印字节替换成 UTF-8 `�`，
  这部分不可逆。后续请用 runner 默认的 `ECAPTURE_HEX=1` 采集。
"""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable


try:
    import hpack  # type: ignore
except Exception:  # pragma: no cover - optional dependency
    hpack = None


ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
TLS_EVENT_PATTERNS = [
    # 老格式：
    #   PID:22470 TID:22625 Comm:ChromiumNet0 FD:3073551840 WRITE (17 bytes):
    re.compile(
        r"PID:(?P<pid>\d+).*?TID:(?P<tid>\d+).*?Comm:(?P<comm>\S+)\s+"
        r"FD:(?P<fd>\d+)\s+(?P<direction>READ|WRITE)\s+\((?P<size>\d+)\s+bytes(?:,\s*hex)?\):"
    ),
    # 新格式：
    #   PID:29467, Comm:ChromiumNet0, TID:29709, FD:3073655232 WRITE (134 bytes, hex):
    re.compile(
        r"PID:(?P<pid>\d+),\s*Comm:(?P<comm>[^,]+),\s*TID:(?P<tid>\d+),\s*"
        r"FD:(?P<fd>\d+)\s+(?P<direction>READ|WRITE)\s+\((?P<size>\d+)\s+bytes(?:,\s*hex)?\):"
    ),
]
HEX_TOKEN_RE = re.compile(r"\b[0-9a-fA-F]{2}\b")
HTTP2_PREFACE = b"PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n"

FRAME_TYPES = {
    0x0: "DATA",
    0x1: "HEADERS",
    0x2: "PRIORITY",
    0x3: "RST_STREAM",
    0x4: "SETTINGS",
    0x5: "PUSH_PROMISE",
    0x6: "PING",
    0x7: "GOAWAY",
    0x8: "WINDOW_UPDATE",
    0x9: "CONTINUATION",
}

SETTINGS_NAMES = {
    0x1: "HEADER_TABLE_SIZE",
    0x2: "ENABLE_PUSH",
    0x3: "MAX_CONCURRENT_STREAMS",
    0x4: "INITIAL_WINDOW_SIZE",
    0x5: "MAX_FRAME_SIZE",
    0x6: "MAX_HEADER_LIST_SIZE",
}


@dataclass
class TlsEvent:
    source: str
    line: int
    pid: str
    tid: str
    comm: str
    fd: str
    direction: str
    declared_size: int
    payload: bytes
    decoded_ok: bool
    note: str = ""


@dataclass
class Frame:
    fd: str
    direction: str
    index: int
    offset: int
    length: int
    type_id: int
    type_name: str
    flags: int
    stream_id: int
    info: dict = field(default_factory=dict)
    headers: list[tuple[str, str]] = field(default_factory=list)
    error: str = ""


def strip_ansi(text: str) -> str:
    return ANSI_RE.sub("", text).replace("\r\n", "\n").replace("\r", "\n")


def read_logs(target: Path) -> list[tuple[str, str]]:
    if target.is_dir():
        names = ["ecapture_events.log", "ecapture_console.log", "ecapture_console.head.log"]
        files = [target / name for name in names if (target / name).exists()]
    else:
        files = [target]

    out: list[tuple[str, str]] = []
    for path in files:
        try:
            out.append((path.name, strip_ansi(path.read_text(encoding="utf-8", errors="replace"))))
        except OSError:
            pass
    return out


def looks_like_log_line(line: str) -> bool:
    if match_tls_event(line):
        return True
    if "probe=OpenSSL" in line:
        return True
    if line.startswith("20") and " INF " in line:
        return True
    if line.startswith("[DEBUG]"):
        return True
    if line.startswith("{") and '"level"' in line:
        return True
    return False


def match_tls_event(line: str) -> re.Match[str] | None:
    for pat in TLS_EVENT_PATTERNS:
        m = pat.search(line)
        if m:
            return m
    return None


def decode_c_escapes(text: str) -> bytes:
    out = bytearray()
    i = 0
    while i < len(text):
        ch = text[i]
        if ch != "\\":
            code = ord(ch)
            if code <= 0xFF:
                out.append(code)
            else:
                # 非 hex 模式里 eCapture/终端可能已经把二进制转成 U+FFFD。
                # 这时原字节不可恢复，保留 '?' 方便长度诊断。
                out.append(0x3F)
            i += 1
            continue

        if i + 1 >= len(text):
            out.append(0x5C)
            i += 1
            continue

        nxt = text[i + 1]
        if nxt == "x" and i + 3 < len(text):
            h = text[i + 2 : i + 4]
            try:
                out.append(int(h, 16))
                i += 4
                continue
            except ValueError:
                pass
        escapes = {
            "n": 0x0A,
            "r": 0x0D,
            "t": 0x09,
            "b": 0x08,
            "f": 0x0C,
            "v": 0x0B,
            "0": 0x00,
            "\\": 0x5C,
        }
        if nxt in escapes:
            out.append(escapes[nxt])
            i += 2
            continue
        out.append(ord(nxt) & 0xFF)
        i += 2
    return bytes(out)


def decode_payload_lines(lines: list[str], declared_size: int | None = None) -> tuple[bytes, str]:
    raw = "\n".join(line.strip() for line in lines if line.strip())
    if not raw:
        return b"", "empty-payload"

    # eCapture --hex hexdump：
    #   0000  00007D0125000000 8580000000DB82C2  ...    ascii...
    # 只取 offset 后面的 hex 列，不吃右侧 ASCII 栏。若已达到 declared size，立即停止。
    hexdump = bytearray()
    saw_hexdump = False
    for line in lines:
        m = re.match(r"^\s*[0-9a-fA-F]{4,8}\s+(.*)$", line)
        if not m:
            continue
        saw_hexdump = True
        for tok in re.findall(r"\b[0-9a-fA-F]{2,64}\b", m.group(1)):
            if len(tok) % 2 != 0:
                continue
            # 右侧 ASCII 栏理论上可能碰巧出现纯 hex token；
            # declared_size 能保证超过 payload 长度后不再继续吸。
            hexdump.extend(bytes.fromhex(tok))
            if declared_size is not None and len(hexdump) >= declared_size:
                return bytes(hexdump[:declared_size]), "hexdump"
    if saw_hexdump and hexdump:
        return bytes(hexdump), "hexdump"

    # eCapture --hex 通常是一段纯 hex；兼容带空格、冒号、偏移的 hexdump。
    compact = re.sub(r"[^0-9a-fA-F]", "", raw)
    tokens = HEX_TOKEN_RE.findall(raw)
    if len(compact) >= 2 and len(compact) % 2 == 0 and (len(tokens) >= 4 or "\\x" not in raw):
        try:
            return bytes.fromhex(compact), "hex"
        except ValueError:
            pass

    if "\\x" in raw or "\\" in raw:
        return decode_c_escapes(raw), "c-escape"

    try:
        return raw.encode("latin-1"), "latin1"
    except UnicodeEncodeError:
        return raw.encode("utf-8", errors="replace"), "utf8-replace"


def extract_events(logs: Iterable[tuple[str, str]]) -> list[TlsEvent]:
    events: list[TlsEvent] = []
    for source, text in logs:
        lines = text.splitlines()
        i = 0
        while i < len(lines):
            m = match_tls_event(lines[i])
            if not m:
                i += 1
                continue

            start_line = i + 1
            payload_lines: list[str] = []
            i += 1
            while i < len(lines):
                if looks_like_log_line(lines[i]):
                    break
                payload_lines.append(lines[i])
                i += 1

            declared = int(m.group("size"))
            payload, mode = decode_payload_lines(payload_lines, declared)
            decoded_ok = len(payload) == declared
            note = mode
            if not decoded_ok:
                note += f"; decoded_len={len(payload)} declared={declared}"

            events.append(
                TlsEvent(
                    source=source,
                    line=start_line,
                    pid=m.group("pid"),
                    tid=m.group("tid"),
                    comm=m.group("comm"),
                    fd=m.group("fd"),
                    direction=m.group("direction"),
                    declared_size=declared,
                    payload=payload,
                    decoded_ok=decoded_ok,
                    note=note,
                )
            )
    return events


def flag_names(type_id: int, flags: int) -> list[str]:
    names: list[str] = []
    if flags & 0x1:
        names.append("ACK" if type_id in (0x4, 0x6) else "END_STREAM")
    if flags & 0x4:
        names.append("END_HEADERS")
    if flags & 0x8:
        names.append("PADDED")
    if flags & 0x20:
        names.append("PRIORITY")
    return names


def parse_settings(payload: bytes) -> list[dict]:
    out: list[dict] = []
    for off in range(0, len(payload) - 5, 6):
        ident = int.from_bytes(payload[off : off + 2], "big")
        value = int.from_bytes(payload[off + 2 : off + 6], "big")
        out.append({"id": ident, "name": SETTINGS_NAMES.get(ident, f"UNKNOWN_{ident}"), "value": value})
    return out


def header_block_fragment(type_id: int, flags: int, payload: bytes) -> tuple[bytes, dict]:
    info: dict = {}
    data = payload
    pad_len = 0
    if flags & 0x8:
        if not data:
            return b"", {"error": "PADDED flag but empty payload"}
        pad_len = data[0]
        data = data[1:]
        info["pad_len"] = pad_len

    if type_id == 0x1 and flags & 0x20:
        if len(data) < 5:
            return b"", {"error": "PRIORITY flag but payload < 5"}
        dep = int.from_bytes(data[0:4], "big") & 0x7FFFFFFF
        weight = data[4]
        info["priority_dep"] = dep
        info["priority_weight"] = weight
        data = data[5:]

    if type_id == 0x5:
        if len(data) < 4:
            return b"", {"error": "PUSH_PROMISE payload < 4"}
        promised = int.from_bytes(data[0:4], "big") & 0x7FFFFFFF
        info["promised_stream_id"] = promised
        data = data[4:]

    if pad_len:
        if pad_len > len(data):
            return b"", {"error": "pad_len exceeds payload"}
        data = data[: -pad_len]
    return data, info


def parse_h2_stream(fd: str, direction: str, blob: bytes) -> tuple[list[Frame], dict]:
    pos = 0
    frames: list[Frame] = []
    notes: dict = {}
    hpack_decoder = hpack.Decoder() if hpack is not None else None
    header_acc: dict[int, bytearray] = defaultdict(bytearray)

    if blob.startswith(HTTP2_PREFACE):
        notes["preface"] = True
        pos += len(HTTP2_PREFACE)

    idx = 0
    while pos + 9 <= len(blob):
        off = pos
        length = int.from_bytes(blob[pos : pos + 3], "big")
        type_id = blob[pos + 3]
        flags = blob[pos + 4]
        stream_id = int.from_bytes(blob[pos + 5 : pos + 9], "big") & 0x7FFFFFFF
        pos += 9
        if pos + length > len(blob):
            notes["trailing_incomplete"] = {
                "offset": off,
                "need": length,
                "have": max(0, len(blob) - pos),
                "header_hex": blob[off : off + 9].hex(),
            }
            break

        payload = blob[pos : pos + length]
        pos += length

        frame = Frame(
            fd=fd,
            direction=direction,
            index=idx,
            offset=off,
            length=length,
            type_id=type_id,
            type_name=FRAME_TYPES.get(type_id, f"UNKNOWN_{type_id}"),
            flags=flags,
            stream_id=stream_id,
            info={"flags": flag_names(type_id, flags), "payload_prefix": payload[:64].hex()},
        )
        idx += 1

        if type_id == 0x4:
            frame.info["settings"] = parse_settings(payload)
        elif type_id == 0x6:
            frame.info["ping"] = payload.hex()
        elif type_id == 0x8 and len(payload) >= 4:
            frame.info["window_increment"] = int.from_bytes(payload[:4], "big") & 0x7FFFFFFF
        elif type_id == 0x7 and len(payload) >= 8:
            frame.info["last_stream_id"] = int.from_bytes(payload[:4], "big") & 0x7FFFFFFF
            frame.info["error_code"] = int.from_bytes(payload[4:8], "big")
        elif type_id in (0x1, 0x5, 0x9):
            fragment, extra = header_block_fragment(type_id, flags, payload)
            frame.info.update(extra)
            header_acc[stream_id].extend(fragment)
            if flags & 0x4:
                block = bytes(header_acc.pop(stream_id, b""))
                if hpack_decoder is None:
                    frame.error = "missing hpack; run: python3 -m pip install -r requirements-http2.txt"
                    frame.info["header_block_hex"] = block[:512].hex()
                else:
                    try:
                        decoded = hpack_decoder.decode(block)
                        frame.headers = [(str(k), str(v)) for k, v in decoded]
                    except Exception as exc:  # pragma: no cover - depends on input state
                        frame.error = f"hpack decode failed: {exc}"
                        frame.info["header_block_hex"] = block[:512].hex()

        frames.append(frame)

    if pos < len(blob):
        notes["trailing_bytes"] = len(blob) - pos
        notes["trailing_hex"] = blob[pos : pos + 64].hex()
    notes["total_bytes"] = len(blob)
    notes["parsed_frames"] = len(frames)
    return frames, notes


def decode(target: Path) -> dict:
    logs = read_logs(target)
    events = extract_events(logs)
    streams: dict[tuple[str, str], bytearray] = defaultdict(bytearray)
    event_rows: list[dict] = []

    for ev in events:
        streams[(ev.fd, ev.direction)].extend(ev.payload)
        event_rows.append(
            {
                "source": ev.source,
                "line": ev.line,
                "pid": ev.pid,
                "tid": ev.tid,
                "comm": ev.comm,
                "fd": ev.fd,
                "direction": ev.direction,
                "declared_size": ev.declared_size,
                "decoded_size": len(ev.payload),
                "decoded_ok": ev.decoded_ok,
                "note": ev.note,
                "payload_prefix": ev.payload[:64].hex(),
            }
        )

    frame_rows: list[dict] = []
    stream_notes: dict[str, dict] = {}
    header_rows: list[dict] = []
    frame_counts: Counter[str] = Counter()

    for (fd, direction), data in sorted(streams.items()):
        frames, notes = parse_h2_stream(fd, direction, bytes(data))
        stream_key = f"{fd}:{direction}"
        stream_notes[stream_key] = notes
        for fr in frames:
            frame_counts[fr.type_name] += 1
            row = {
                "fd": fr.fd,
                "direction": fr.direction,
                "index": fr.index,
                "offset": fr.offset,
                "length": fr.length,
                "type": fr.type_name,
                "type_id": fr.type_id,
                "flags": fr.flags,
                "flag_names": fr.info.get("flags", []),
                "stream_id": fr.stream_id,
                "info": fr.info,
                "error": fr.error,
            }
            frame_rows.append(row)
            for key, value in fr.headers:
                header_rows.append(
                    {
                        "fd": fr.fd,
                        "direction": fr.direction,
                        "frame_index": fr.index,
                        "stream_id": fr.stream_id,
                        "key": key,
                        "value": value,
                    }
                )

    return {
        "target": str(target),
        "hpack_available": hpack is not None,
        "events": event_rows,
        "event_count": len(event_rows),
        "frame_counts": dict(frame_counts),
        "frames": frame_rows,
        "headers": header_rows,
        "stream_notes": stream_notes,
    }


def md_escape(value: object) -> str:
    return str(value).replace("|", "\\|").replace("\n", "\\n")


def write_markdown(summary: dict, out: Path) -> None:
    lines: list[str] = []
    lines.append("# eCapture HTTP/2 decode")
    lines.append("")
    lines.append(f"source: `{summary['target']}`")
    lines.append("")
    lines.append(f"hpack: `{'available' if summary['hpack_available'] else 'missing'}`")
    if not summary["hpack_available"]:
        lines.append("")
        lines.append("HEADERS 只能切 frame，不能解 header。安装：")
        lines.append("")
        lines.append("```bash")
        lines.append("python3 -m pip install -r requirements-http2.txt")
        lines.append("```")
    lines.append("")

    lines.append("## TLS 明文事件")
    lines.append("")
    lines.append(f"events: `{summary['event_count']}`")
    lines.append("")
    if summary["events"]:
        lines.append("| source:line | fd | dir | bytes | ok | note | prefix |")
        lines.append("|---|---:|---|---:|---|---|---|")
        for ev in summary["events"][:120]:
            loc = f"{ev['source']}:{ev['line']}"
            lines.append(
                f"| `{loc}` | {ev['fd']} | `{ev['direction']}` | {ev['declared_size']} | "
                f"`{ev['decoded_ok']}` | `{md_escape(ev['note'])}` | `{ev['payload_prefix']}` |"
            )
    else:
        lines.append("没有从 text log 中抽到 `SSL_read/write` payload。pcapng 需要 Wireshark/tshark 解析。")
    lines.append("")

    lines.append("## HTTP/2 frame 统计")
    lines.append("")
    if summary["frame_counts"]:
        lines.append("| type | count |")
        lines.append("|---|---:|")
        for key, value in sorted(summary["frame_counts"].items()):
            lines.append(f"| `{key}` | {value} |")
    else:
        lines.append("未切出完整 HTTP/2 frame。")
    lines.append("")

    lines.append("## HTTP/2 frames")
    lines.append("")
    if summary["frames"]:
        lines.append("| fd | dir | idx | off | stream | type | flags | len | info/error |")
        lines.append("|---:|---|---:|---:|---:|---|---|---:|---|")
        for fr in summary["frames"][:200]:
            info_bits = []
            if fr.get("error"):
                info_bits.append(fr["error"])
            info = fr.get("info") or {}
            for key in ("ping", "window_increment", "settings"):
                if key in info:
                    info_bits.append(f"{key}={info[key]}")
            if not info_bits and "payload_prefix" in info:
                info_bits.append(f"prefix={info['payload_prefix']}")
            lines.append(
                f"| {fr['fd']} | `{fr['direction']}` | {fr['index']} | 0x{fr['offset']:x} | "
                f"{fr['stream_id']} | `{fr['type']}` | `{','.join(fr['flag_names'])}` | "
                f"{fr['length']} | `{md_escape('; '.join(info_bits))}` |"
            )
    else:
        lines.append("无。")
    lines.append("")

    lines.append("## 解出的 header")
    lines.append("")
    if summary["headers"]:
        lines.append("| fd | dir | stream | frame | key | value |")
        lines.append("|---:|---|---:|---:|---|---|")
        for h in summary["headers"][:240]:
            lines.append(
                f"| {h['fd']} | `{h['direction']}` | {h['stream_id']} | {h['frame_index']} | "
                f"`{md_escape(h['key'])}` | `{md_escape(h['value'])}` |"
            )
    else:
        lines.append("无。若存在 HEADERS frame 但这里为空，通常是没装 `hpack`、缺少前序动态表，或采集窗口没有业务请求。")
    lines.append("")

    lines.append("## stream notes")
    lines.append("")
    if summary["stream_notes"]:
        lines.append("```json")
        lines.append(json.dumps(summary["stream_notes"], ensure_ascii=False, indent=2))
        lines.append("```")
    else:
        lines.append("无。")
    lines.append("")

    out.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", help="eCapture run directory or text log")
    parser.add_argument("--out-md", help="markdown output path")
    parser.add_argument("--out-json", help="json output path")
    args = parser.parse_args()

    target = Path(args.target)
    summary = decode(target)
    if target.is_dir():
        out_md = Path(args.out_md) if args.out_md else target / "http2_decode.md"
        out_json = Path(args.out_json) if args.out_json else target / "http2_decode.json"
    else:
        out_md = Path(args.out_md) if args.out_md else target.with_suffix(target.suffix + ".http2.md")
        out_json = Path(args.out_json) if args.out_json else target.with_suffix(target.suffix + ".http2.json")

    write_markdown(summary, out_md)
    out_json.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"[decode-ecapture-http2] wrote {out_md}")
    print(f"[decode-ecapture-http2] wrote {out_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
