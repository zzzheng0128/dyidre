"""mitmproxy replay addon: validate the two SDK bootstrap requests.

Run it through mitmdump rather than the host Python interpreter, because the
standalone mitmdump binary ships its own mitmproxy modules:

    mitmdump -q -nr flows.mitm -s scripts/validate_mitm_target_flows.py

The report intentionally contains structure and integrity metadata only.  The
original, complete headers and bodies remain in flows.mitm; do not copy device
identifiers, tokens, or signature headers into a second text artifact merely
for validation.
"""

from __future__ import annotations

import hashlib
import json
from collections import Counter
from typing import Any
from urllib.parse import parse_qs, urlsplit

from mitmproxy import http


TARGET_PATHS = {
    "get_token": "/sdi/get_token",
    "report": "/ri/report",
}
REQUIRED_QUERY_KEYS = {"lc_id", "aid", "mode"}
records: dict[str, list[dict[str, Any]]] = {name: [] for name in TARGET_PATHS}
observed_paths: Counter[str] = Counter()


def _target_name(path: str) -> str | None:
    normalized = path.rstrip("/") or "/"
    for name, target_path in TARGET_PATHS.items():
        if normalized == target_path:
            return name
    return None


def _content_length_status(headers: http.Headers, body: bytes) -> tuple[bool, int | None]:
    """Return whether an explicit Content-Length agrees with captured bytes."""
    value = headers.get("content-length")
    if value is None:
        # HTTP/2 and some valid HTTP/1.1 requests omit Content-Length.
        return True, None
    try:
        expected = int(value)
    except ValueError:
        return False, None
    return expected == len(body), expected


def request(flow: http.HTTPFlow) -> None:
    request_obj = flow.request
    parsed_url = urlsplit(request_obj.pretty_url)
    observed_paths[f"{request_obj.host}{parsed_url.path}"] += 1
    target = _target_name(parsed_url.path)
    if target is None:
        return

    body = request_obj.raw_content or b""
    headers = request_obj.headers
    header_names = sorted({name.lower() for name in headers.keys()})
    query = parse_qs(parsed_url.query, keep_blank_values=True)
    content_length_ok, declared_length = _content_length_status(headers, body)
    has_host = bool(request_obj.host) or "host" in header_names
    query_missing = sorted(REQUIRED_QUERY_KEYS - set(query))
    well_formed_headers = bool(header_names) and all("\x00" not in name for name in header_names)
    normal = has_host and well_formed_headers and not query_missing and content_length_ok

    # Values are limited to transport metadata, not user/device/signature data.
    records[target].append(
        {
            "method": request_obj.method,
            "scheme": request_obj.scheme,
            "host": request_obj.host,
            "path": request_obj.path,
            "http_version": request_obj.http_version,
            "header_count": len(headers),
            "header_names": header_names,
            "content_type": headers.get("content-type"),
            "content_encoding": headers.get("content-encoding"),
            "declared_content_length": declared_length,
            "body_bytes": len(body),
            "body_sha256": hashlib.sha256(body).hexdigest(),
            "content_length_consistent": content_length_ok,
            "required_query_missing": query_missing,
            "normal": normal,
        }
    )


def done() -> None:
    targets: dict[str, dict[str, Any]] = {}
    errors: list[str] = []
    for name in TARGET_PATHS:
        candidates = records[name]
        valid_candidates = sum(1 for candidate in candidates if candidate["normal"])
        targets[name] = {
            "captured": len(candidates),
            "normal": valid_candidates,
            "candidates": candidates,
        }
        if valid_candidates == 0:
            errors.append(f"{name}: no complete request with consistent headers/body")

    report = {
        "schema": "dyidre.mitm-target-validation.v1",
        "valid": not errors,
        "observed_request_count": sum(observed_paths.values()),
        "observed_top_paths": observed_paths.most_common(20),
        "targets": targets,
        "errors": errors,
    }
    print(json.dumps(report, ensure_ascii=False, separators=(",", ":")), flush=True)
