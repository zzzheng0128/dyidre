#!/usr/bin/env python3
"""Extract HTTP interfaces from an eCapture TLS text run.

用途：
  eCapture text 模式抓到的是 SSL_read/SSL_write 明文：

  - HTTP/1.1：明文本身就是 `GET /path HTTP/1.1` 这种文本；
  - HTTP/2：明文是二进制 frame，header 还经过 HPACK 压缩。

本脚本把两类流量统一整理成：

  - `requests_all.json`：完整机器可读接口清单；
  - `requests_all.md`：人看的接口摘要。

设计原则：
  - request 侧尽量保留完整 path/query/header 和小 body；
  - response 侧默认只保留状态、header、body 长度/hash/prefix，避免把大图/视频写进报告；
  - HPACK 解不开时也保留 fd/stream/frame/error，方便判断是“漏了连接开头”还是 parser 问题。

依赖：
  - 基础事件抽取复用 `decode_ecapture_http2.py`；
  - HTTP/2 HEADERS 解码需要 `hpack`：

    python3 -m venv /tmp/dyidre_h2_venv
    /tmp/dyidre_h2_venv/bin/python -m pip install -r dyidre/requirements-http2.txt
    /tmp/dyidre_h2_venv/bin/python dyidre/scripts/extract_ecapture_requests.py dyidre/runs/350101/ecapture/<tag>/
"""

from __future__ import annotations

import argparse
import base64
import hashlib
import importlib.util
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


SCRIPT_DIR = Path(__file__).resolve().parent
H2_DECODER_PATH = SCRIPT_DIR / "decode_ecapture_http2.py"


def load_h2_module() -> Any:
    spec = importlib.util.spec_from_file_location("dyidre_decode_ecapture_http2", H2_DECODER_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {H2_DECODER_PATH}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


h2 = load_h2_module()


REQUEST_LINE_RE = re.compile(r"^(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)\s+(\S+)\s+HTTP/(\d(?:\.\d)?)$", re.I)
STATUS_LINE_RE = re.compile(r"^HTTP/(\d(?:\.\d)?)\s+(\d{3})(?:\s+(.*))?$", re.I)
SIGN_HEADER_PREFIXES = (
    "x-argus",
    "x-gorgon",
    "x-khronos",
    "x-ladon",
    "x-medusa",
    "x-helios",
    "x-soter",
    "x-ss-stub",
    "x-ss-req-ticket",
    "x-security-argus",
)


def b64_small(data: bytes, limit: int) -> str:
    if len(data) > limit:
        return ""
    return base64.b64encode(data).decode("ascii")


def text_preview(data: bytes, limit: int = 512) -> str:
    if not data:
        return ""
    out = data[:limit].decode("utf-8", errors="replace")
    out = out.replace("\r", "\\r").replace("\n", "\\n")
    return out


def bytes_meta(data: bytes, keep_limit: int = 65536) -> dict[str, Any]:
    return {
        "len": len(data),
        "sha256": hashlib.sha256(data).hexdigest() if data else "",
        "prefix_hex": data[:128].hex(),
        "prefix_text": text_preview(data, 512),
        "base64_if_small": b64_small(data, keep_limit),
        "base64_kept": len(data) <= keep_limit,
    }


def normalize_headers(headers: list[tuple[str, str]] | dict[str, str]) -> list[dict[str, str]]:
    if isinstance(headers, dict):
        return [{"name": str(k), "value": str(v)} for k, v in headers.items()]
    return [{"name": str(k), "value": str(v)} for k, v in headers]


def header_map(headers: list[dict[str, str]]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = defaultdict(list)
    for h in headers:
        out[h["name"].lower()].append(h["value"])
    return dict(out)


def first_header(headers: list[dict[str, str]], *names: str) -> str:
    names_l = {n.lower() for n in names}
    for h in headers:
        if h["name"].lower() in names_l:
            return h["value"]
    return ""


def signature_headers(headers: list[dict[str, str]]) -> dict[str, str]:
    out: dict[str, str] = {}
    for h in headers:
        low = h["name"].lower()
        if low.startswith("x-") or low in SIGN_HEADER_PREFIXES:
            out[h["name"]] = h["value"]
    return out


def parse_http1_message(payload: bytes) -> dict[str, Any] | None:
    marker = b"\r\n\r\n"
    pos = payload.find(marker)
    if pos < 0:
        return None

    head_raw = payload[:pos].decode("iso-8859-1", errors="replace")
    body = payload[pos + len(marker) :]
    lines = head_raw.split("\r\n")
    if not lines:
        return None

    first = lines[0].strip()
    req = REQUEST_LINE_RE.match(first)
    status = STATUS_LINE_RE.match(first)
    if not req and not status:
        return None

    headers: list[dict[str, str]] = []
    for line in lines[1:]:
        if not line or ":" not in line:
            continue
        k, v = line.split(":", 1)
        headers.append({"name": k.strip(), "value": v.strip()})

    if req:
        return {
            "kind": "request",
            "protocol": f"HTTP/{req.group(3)}",
            "method": req.group(1).upper(),
            "path": req.group(2),
            "headers": headers,
            "body": bytes_meta(body),
        }

    assert status is not None
    return {
        "kind": "response",
        "protocol": f"HTTP/{status.group(1)}",
        "status": int(status.group(2)),
        "reason": status.group(3) or "",
        "headers": headers,
        "body": bytes_meta(body, keep_limit=8192),
    }


def parse_http1(events: list[Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    requests: list[dict[str, Any]] = []
    responses: list[dict[str, Any]] = []

    for ev in events:
        msg = parse_http1_message(ev.payload)
        if not msg:
            continue
        common = {
            "source": ev.source,
            "line": ev.line,
            "pid": ev.pid,
            "tid": ev.tid,
            "comm": ev.comm,
            "fd": ev.fd,
            "direction": ev.direction,
        }
        if msg["kind"] == "request" and ev.direction == "WRITE":
            headers = msg["headers"]
            requests.append(
                {
                    **common,
                    "protocol": msg["protocol"],
                    "stream_id": None,
                    "method": msg["method"],
                    "authority": first_header(headers, "host", ":authority"),
                    "path": msg["path"],
                    "headers": headers,
                    "headers_map": header_map(headers),
                    "signature_headers": signature_headers(headers),
                    "request_body": msg["body"],
                    "decode_error": "",
                    "response": None,
                }
            )
        elif msg["kind"] == "response" and ev.direction == "READ":
            responses.append(
                {
                    **common,
                    "protocol": msg["protocol"],
                    "status": msg["status"],
                    "reason": msg["reason"],
                    "headers": msg["headers"],
                    "headers_map": header_map(msg["headers"]),
                    "body": msg["body"],
                }
            )
    return requests, responses


def parse_h2_frames(fd: str, direction: str, blob: bytes) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    pos = 0
    frames: list[dict[str, Any]] = []
    notes: dict[str, Any] = {}
    hpack_decoder = h2.hpack.Decoder() if h2.hpack is not None else None
    header_acc: dict[int, bytearray] = defaultdict(bytearray)

    if blob.startswith(h2.HTTP2_PREFACE):
        notes["preface"] = True
        pos += len(h2.HTTP2_PREFACE)

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
        type_name = h2.FRAME_TYPES.get(type_id, f"UNKNOWN_{type_id}")
        frame: dict[str, Any] = {
            "fd": fd,
            "direction": direction,
            "index": idx,
            "offset": off,
            "length": length,
            "type_id": type_id,
            "type": type_name,
            "flags": flags,
            "flag_names": h2.flag_names(type_id, flags),
            "stream_id": stream_id,
            "error": "",
            "headers": [],
            "payload_meta": bytes_meta(payload, keep_limit=8192),
        }
        idx += 1

        if type_id == 0x4:
            frame["settings"] = h2.parse_settings(payload)
        elif type_id == 0x6:
            frame["ping"] = payload.hex()
        elif type_id == 0x8 and len(payload) >= 4:
            frame["window_increment"] = int.from_bytes(payload[:4], "big") & 0x7FFFFFFF
        elif type_id == 0x7 and len(payload) >= 8:
            frame["last_stream_id"] = int.from_bytes(payload[:4], "big") & 0x7FFFFFFF
            frame["error_code"] = int.from_bytes(payload[4:8], "big")
        elif type_id in (0x1, 0x5, 0x9):
            fragment, extra = h2.header_block_fragment(type_id, flags, payload)
            frame.update({f"header_{k}": v for k, v in extra.items()})
            header_acc[stream_id].extend(fragment)
            if flags & 0x4:
                block = bytes(header_acc.pop(stream_id, b""))
                frame["header_block_meta"] = bytes_meta(block, keep_limit=8192)
                if hpack_decoder is None:
                    frame["error"] = "missing hpack; run with a Python env that has hpack installed"
                else:
                    try:
                        decoded = hpack_decoder.decode(block)
                        frame["headers"] = normalize_headers(decoded)
                    except Exception as exc:
                        frame["error"] = f"hpack decode failed: {exc}"
        frames.append(frame)

    if pos < len(blob):
        notes["trailing_bytes"] = len(blob) - pos
        notes["trailing_hex"] = blob[pos : pos + 64].hex()
    notes["total_bytes"] = len(blob)
    notes["parsed_frames"] = len(frames)
    return frames, notes


def parse_http2(events: list[Any]) -> tuple[list[dict[str, Any]], dict[str, Any]]:
    streams: dict[tuple[str, str], bytearray] = defaultdict(bytearray)
    first_loc: dict[tuple[str, str], dict[str, Any]] = {}
    for ev in events:
        key = (ev.fd, ev.direction)
        if key not in first_loc:
            first_loc[key] = {
                "source": ev.source,
                "line": ev.line,
                "pid": ev.pid,
                "tid": ev.tid,
                "comm": ev.comm,
                "fd": ev.fd,
                "direction": ev.direction,
            }
        streams[key].extend(ev.payload)

    requests: dict[tuple[str, int], dict[str, Any]] = {}
    frame_counts: Counter[str] = Counter()
    decode_errors: list[dict[str, Any]] = []
    stream_notes: dict[str, Any] = {}

    def ensure_request(fd: str, sid: int, loc: dict[str, Any]) -> dict[str, Any]:
        key = (fd, sid)
        if key not in requests:
            requests[key] = {
                **loc,
                "protocol": "HTTP/2",
                "stream_id": sid,
                "method": "",
                "authority": "",
                "path": "",
                "headers": [],
                "headers_map": {},
                "signature_headers": {},
                "request_body": bytes_meta(b""),
                "request_data_frames": [],
                "decode_error": "",
                "response": None,
            }
        return requests[key]

    for (fd, direction), data in sorted(streams.items()):
        loc = first_loc.get((fd, direction), {"fd": fd, "direction": direction})
        frames, notes = parse_h2_frames(fd, direction, bytes(data))
        stream_notes[f"{fd}:{direction}"] = notes

        for fr in frames:
            frame_counts[fr["type"]] += 1
            sid = int(fr["stream_id"])
            if sid == 0:
                continue
            if fr.get("error"):
                decode_errors.append(
                    {
                        "fd": fd,
                        "direction": direction,
                        "stream_id": sid,
                        "frame_index": fr["index"],
                        "type": fr["type"],
                        "error": fr["error"],
                        "header_block_prefix": (fr.get("header_block_meta") or {}).get("prefix_hex", ""),
                    }
                )

            if direction == "WRITE":
                req = ensure_request(fd, sid, loc)
                if fr["type"] == "HEADERS":
                    if fr["headers"]:
                        # 第一个 HEADERS 是请求头；后续同 stream 的 HEADERS 作为 trailers 保存。
                        if not req["headers"]:
                            req["headers"] = fr["headers"]
                            req["headers_map"] = header_map(fr["headers"])
                            req["method"] = first_header(fr["headers"], ":method")
                            req["authority"] = first_header(fr["headers"], ":authority", "host")
                            req["path"] = first_header(fr["headers"], ":path")
                            req["signature_headers"] = signature_headers(fr["headers"])
                        else:
                            req.setdefault("trailers", []).append(fr["headers"])
                    if fr.get("error") and not req["decode_error"]:
                        req["decode_error"] = fr["error"]
                elif fr["type"] == "DATA":
                    payload_b64 = fr["payload_meta"].get("base64_if_small", "")
                    req["request_data_frames"].append(
                        {
                            "frame_index": fr["index"],
                            "len": fr["length"],
                            "sha256": fr["payload_meta"]["sha256"],
                            "prefix_hex": fr["payload_meta"]["prefix_hex"],
                            "prefix_text": fr["payload_meta"]["prefix_text"],
                            "base64_if_small": payload_b64,
                            "end_stream": "END_STREAM" in fr["flag_names"],
                        }
                    )
            elif direction == "READ":
                req = ensure_request(fd, sid, loc)
                if req["direction"] != "WRITE":
                    req["direction"] = "WRITE?"
                resp = req.get("response")
                if resp is None:
                    resp = {
                        "headers": [],
                        "headers_map": {},
                        "status": None,
                        "body_len": 0,
                        "body_sha256_chunks": [],
                        "data_frames": [],
                        "decode_error": "",
                    }
                    req["response"] = resp
                if fr["type"] == "HEADERS":
                    if fr["headers"]:
                        resp["headers"].extend(fr["headers"])
                        resp["headers_map"] = header_map(resp["headers"])
                        status = first_header(fr["headers"], ":status")
                        if status.isdigit():
                            resp["status"] = int(status)
                    if fr.get("error") and not resp["decode_error"]:
                        resp["decode_error"] = fr["error"]
                elif fr["type"] == "DATA":
                    resp["body_len"] += fr["length"]
                    resp["body_sha256_chunks"].append(fr["payload_meta"]["sha256"])
                    resp["data_frames"].append(
                        {
                            "frame_index": fr["index"],
                            "len": fr["length"],
                            "sha256": fr["payload_meta"]["sha256"],
                            "prefix_hex": fr["payload_meta"]["prefix_hex"],
                            "prefix_text": fr["payload_meta"]["prefix_text"],
                            "end_stream": "END_STREAM" in fr["flag_names"],
                        }
                    )

    # 汇总 DATA frame 成 request_body。
    for req in requests.values():
        total_len = sum(int(x["len"]) for x in req.get("request_data_frames", []))
        req["request_body"] = {
            "len": total_len,
            "frames": len(req.get("request_data_frames", [])),
            "sha256_chunks": [x["sha256"] for x in req.get("request_data_frames", [])],
            "prefix_hex": (req.get("request_data_frames") or [{}])[0].get("prefix_hex", ""),
            "prefix_text": (req.get("request_data_frames") or [{}])[0].get("prefix_text", ""),
        }

    ordered = sorted(requests.values(), key=lambda r: (str(r.get("fd")), int(r.get("stream_id") or 0)))
    meta = {
        "hpack_available": h2.hpack is not None,
        "frame_counts": dict(frame_counts),
        "decode_errors": decode_errors[:500],
        "decode_error_count": len(decode_errors),
        "stream_notes": stream_notes,
    }
    return ordered, meta


def extract(target: Path) -> dict[str, Any]:
    logs = h2.read_logs(target)
    events = h2.extract_events(logs)
    http1_requests, http1_responses = parse_http1(events)
    http2_requests, h2_meta = parse_http2(events)

    all_requests = http1_requests + http2_requests
    all_requests.sort(
        key=lambda r: (
            str(r.get("source", "")),
            int(r.get("line", 0) or 0),
            str(r.get("fd", "")),
            int(r.get("stream_id") or 0),
        )
    )

    by_host: Counter[str] = Counter()
    by_protocol: Counter[str] = Counter()
    by_method: Counter[str] = Counter()
    sig_count: Counter[str] = Counter()
    for req in all_requests:
        by_protocol[req.get("protocol", "")] += 1
        by_method[req.get("method", "") or "?"] += 1
        host = req.get("authority") or first_header(req.get("headers", []), "host", ":authority") or "(unknown)"
        by_host[host] += 1
        for k in (req.get("signature_headers") or {}).keys():
            sig_count[k.lower()] += 1

    return {
        "target": str(target),
        "event_count": len(events),
        "request_count": len(all_requests),
        "http1_response_count": len(http1_responses),
        "by_protocol": dict(by_protocol),
        "by_method": dict(by_method),
        "by_host": dict(by_host),
        "signature_header_counts": dict(sig_count),
        "http2": h2_meta,
        "requests": all_requests,
        "http1_orphan_responses": http1_responses[:100],
    }


def md_escape(value: Any) -> str:
    s = str(value)
    return s.replace("|", "\\|").replace("\n", "\\n")


def short(value: str, limit: int = 180) -> str:
    value = value or ""
    return value if len(value) <= limit else value[: limit - 3] + "..."


def write_markdown(report: dict[str, Any], out: Path) -> None:
    lines: list[str] = []
    lines.append("# eCapture request/interface inventory")
    lines.append("")
    lines.append(f"source: `{report['target']}`")
    lines.append("")

    lines.append("## 总览")
    lines.append("")
    lines.append("| item | value |")
    lines.append("|---|---:|")
    lines.append(f"| TLS events | {report['event_count']} |")
    lines.append(f"| requests | {report['request_count']} |")
    lines.append(f"| HTTP/1 orphan responses | {report['http1_response_count']} |")
    lines.append(f"| HTTP/2 HPACK available | `{report['http2'].get('hpack_available')}` |")
    lines.append(f"| HTTP/2 decode errors | {report['http2'].get('decode_error_count')} |")
    lines.append("")

    def counter_table(title: str, d: dict[str, Any], limit: int = 50) -> None:
        lines.append(f"## {title}")
        lines.append("")
        if not d:
            lines.append("无。")
            lines.append("")
            return
        lines.append("| key | count |")
        lines.append("|---|---:|")
        for k, v in sorted(d.items(), key=lambda kv: (-int(kv[1]), kv[0]))[:limit]:
            lines.append(f"| `{md_escape(k)}` | {v} |")
        lines.append("")

    counter_table("protocol", report["by_protocol"])
    counter_table("method", report["by_method"])
    counter_table("host / authority", report["by_host"], limit=80)
    counter_table("signature / X-* headers", report["signature_header_counts"], limit=80)

    lines.append("## 接口清单")
    lines.append("")
    if not report["requests"]:
        lines.append("无。")
    else:
        lines.append("| # | proto | fd/stream | source | method | host | path | req body | status | X-* | error |")
        lines.append("|---:|---|---|---|---|---|---|---:|---:|---|---|")
        for i, req in enumerate(report["requests"], 1):
            fd_stream = f"{req.get('fd')}/{req.get('stream_id')}" if req.get("stream_id") is not None else str(req.get("fd"))
            loc = f"{req.get('source')}:{req.get('line')}"
            resp = req.get("response") or {}
            x_keys = ",".join((req.get("signature_headers") or {}).keys())
            body_len = (req.get("request_body") or {}).get("len", 0)
            lines.append(
                f"| {i} | `{req.get('protocol')}` | `{fd_stream}` | `{loc}` | "
                f"`{md_escape(req.get('method') or '')}` | `{md_escape(short(req.get('authority') or ''))}` | "
                f"`{md_escape(short(req.get('path') or '', 220))}` | {body_len} | "
                f"{resp.get('status') or ''} | `{md_escape(short(x_keys, 120))}` | "
                f"`{md_escape(short(req.get('decode_error') or (resp.get('decode_error') if isinstance(resp, dict) else '') or '', 160))}` |"
            )
    lines.append("")

    lines.append("## 可解出的请求详情")
    lines.append("")
    any_detail = False
    for i, req in enumerate(report["requests"], 1):
        if req.get("decode_error") and not req.get("method") and not req.get("path"):
            continue
        any_detail = True
        lines.append(f"### #{i} {req.get('protocol')} {req.get('method') or '?'} {req.get('authority') or ''}")
        lines.append("")
        lines.append(f"- source: `{req.get('source')}:{req.get('line')}`")
        lines.append(f"- fd/stream: `{req.get('fd')}/{req.get('stream_id')}`")
        lines.append(f"- path: `{md_escape(req.get('path') or '')}`")
        lines.append(f"- request body len: `{(req.get('request_body') or {}).get('len', 0)}`")
        resp = req.get("response") or {}
        if resp:
            lines.append(f"- response status: `{resp.get('status')}`")
            lines.append(f"- response body len: `{resp.get('body_len', (resp.get('body') or {}).get('len', 0))}`")
        lines.append("")
        if req.get("headers"):
            lines.append("request headers:")
            lines.append("")
            lines.append("```text")
            for h in req["headers"]:
                lines.append(f"{h['name']}: {h['value']}")
            lines.append("```")
            lines.append("")
        if resp and resp.get("headers"):
            lines.append("response headers:")
            lines.append("")
            lines.append("```text")
            for h in resp["headers"]:
                lines.append(f"{h['name']}: {h['value']}")
            lines.append("```")
            lines.append("")
    if not any_detail:
        lines.append("当前 HPACK 状态不足，HTTP/2 大部分请求只能看到 fd/stream/body 长度，不能解 header。需要从 App 启动/新连接开始采。")
        lines.append("")

    lines.append("## HTTP/2 decode error 样例")
    lines.append("")
    errs = report["http2"].get("decode_errors") or []
    if errs:
        lines.append("| fd | dir | stream | frame | type | error |")
        lines.append("|---:|---|---:|---:|---|---|")
        for e in errs[:80]:
            lines.append(
                f"| {e.get('fd')} | `{e.get('direction')}` | {e.get('stream_id')} | "
                f"{e.get('frame_index')} | `{e.get('type')}` | `{md_escape(e.get('error'))}` |"
            )
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
    report = extract(target)
    if target.is_dir():
        out_md = Path(args.out_md) if args.out_md else target / "requests_all.md"
        out_json = Path(args.out_json) if args.out_json else target / "requests_all.json"
    else:
        out_md = Path(args.out_md) if args.out_md else target.with_suffix(target.suffix + ".requests.md")
        out_json = Path(args.out_json) if args.out_json else target.with_suffix(target.suffix + ".requests.json")

    write_markdown(report, out_md)
    out_json.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"[extract-ecapture-requests] wrote {out_md}")
    print(f"[extract-ecapture-requests] wrote {out_json}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
