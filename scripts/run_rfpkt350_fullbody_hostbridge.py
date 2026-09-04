#!/usr/bin/env python3
import argparse
import base64
import datetime as dt
import hashlib
import json
import os
import queue
import re
import signal
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
PACKET_RE = re.compile(r"\[rfpkt350\].*?packet-b64\s+([A-Za-z0-9+/_=-]+)")


def now_tag():
    return dt.datetime.now().strftime("%Y%m%d_%H%M%S")


def run(cmd, *, check=False, capture=True, text=True, cwd=None, timeout=None):
    kwargs = {
        "cwd": cwd,
        "timeout": timeout,
        "text": text,
    }
    if capture:
        kwargs.update({"stdout": subprocess.PIPE, "stderr": subprocess.STDOUT})
    proc = subprocess.run(cmd, **kwargs)
    if check and proc.returncode != 0:
        out = proc.stdout if capture else ""
        raise RuntimeError(f"command failed rc={proc.returncode}: {' '.join(cmd)}\n{out}")
    return proc


def adb_cmd(args):
    adb = os.environ.get("ADB") or "adb"
    serial = os.environ.get("SERIAL")
    cmd = [adb]
    if serial:
        cmd += ["-s", serial]
    return cmd + args


def adb_shell(script, *, capture=True, check=False, timeout=None):
    return run(adb_cmd(["shell", script]), capture=capture, check=check, timeout=timeout)


def shell_quote_single(s):
    return "'" + str(s).replace("'", "'\"'\"'") + "'"


def strip_ansi(line):
    return ANSI_RE.sub("", line)


def b64decode_text(s):
    raw = s.strip()
    pad = "=" * ((4 - len(raw) % 4) % 4)
    return base64.b64decode(raw + pad, validate=False).decode("utf-8", "replace")


def ensure_md5(packet):
    if packet.get("raw_data_md5"):
        return
    raw_hex = packet.get("raw_data") or ""
    try:
        packet["raw_data_md5"] = hashlib.md5(bytes.fromhex(raw_hex)).hexdigest()
    except Exception:
        packet["raw_data_md5"] = hashlib.md5(raw_hex.encode("utf-8")).hexdigest()


def post_packet(upload_url, packet):
    ensure_md5(packet)
    packet_text = json.dumps(packet, ensure_ascii=False, separators=(",", ":"))
    payload = json.dumps({
        "device_id": packet.get("device_id") or "",
        "packets": [packet_text],
    }, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        upload_url,
        data=payload,
        headers={"Content-Type": "application/json; charset=utf-8"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=5) as resp:
        body = resp.read().decode("utf-8", "replace")
        return resp.status, body, packet_text


def write_line(fp, obj):
    fp.write(json.dumps(obj, ensure_ascii=False, separators=(",", ":")) + "\n")
    fp.flush()


def generate_runtime_js(src_js, out_js, config):
    src = Path(src_js).read_text(encoding="utf-8")
    prelude = "globalThis.METASEC_PACKET_CONFIG = "
    prelude += json.dumps(config, ensure_ascii=False, indent=2)
    prelude += ";\n"
    out = prelude + src
    Path(out_js).write_text(out, encoding="utf-8")


def start_reader(proc, paths, upload_url, counts, stop_event):
    q = queue.Queue()

    def reader():
        try:
            for line in proc.stdout:
                q.put(line)
        finally:
            q.put(None)

    def parser():
        with open(paths["console"], "w", encoding="utf-8", errors="replace") as console_fp, \
                open(paths["bridge"], "a", encoding="utf-8", errors="replace") as bridge_fp, \
                open(paths["seen"], "a", encoding="utf-8", errors="replace") as seen_fp, \
                open(paths["uploaded"], "a", encoding="utf-8", errors="replace") as uploaded_fp, \
                open(paths["upload_tsv"], "a", encoding="utf-8", errors="replace") as upload_tsv:
            while True:
                item = q.get()
                if item is None:
                    break
                console_fp.write(item)
                console_fp.flush()
                clean = strip_ansi(item).rstrip("\n")
                noisy_packet_line = "packet-b64 " in clean or "packet-json " in clean
                if not noisy_packet_line and (
                    "[rfpkt350]" in clean
                    or "Zygote" in clean
                    or "spawn" in clean
                    or "ERROR" in clean
                    or "failed" in clean
                ):
                    print(clean[:1200], flush=True)
                m = PACKET_RE.search(clean)
                if not m:
                    continue
                counts["packet_b64"] += 1
                try:
                    packet_text = b64decode_text(m.group(1))
                    packet = json.loads(packet_text)
                    ensure_md5(packet)
                    write_line(seen_fp, {"ts": time.time(), "packet": packet})
                    status, body, posted_text = post_packet(upload_url, packet)
                    counts["uploaded"] += 1
                    body_len = len(packet.get("raw_data") or "") // 2
                    headers_len = len(json.loads(packet.get("headers") or "{}"))
                    url = packet.get("url") or ""
                    upload_tsv.write(
                        f"{counts['uploaded']}\t{status}\theaders={headers_len}\tbody={body_len}\turl={url}\n"
                    )
                    upload_tsv.flush()
                    write_line(uploaded_fp, {"ts": time.time(), "status": status, "response": body, "packet": packet})
                    print(
                        f"[bridge] uploaded#{counts['uploaded']} http={status} headers={headers_len} "
                        f"body={body_len} url={url[:180]}",
                        flush=True,
                    )
                except Exception as exc:
                    counts["upload_failed"] += 1
                    bridge_fp.write(f"{time.time()} packet parse/upload failed: {exc}\n")
                    bridge_fp.flush()
                    print(f"[bridge] packet parse/upload failed: {exc}", flush=True)
        stop_event.set()

    threading.Thread(target=reader, name="rfpkt-reader", daemon=True).start()
    threading.Thread(target=parser, name="rfpkt-parser", daemon=True).start()


def start_swiper(seconds, interval, stop_event):
    if seconds < 0:
        return

    def worker():
        time.sleep(seconds)
        while not stop_event.is_set():
            try:
                run(adb_cmd(["shell", "input", "swipe", "540", "1800", "540", "520", "450"]), capture=True, timeout=5)
                print("[bridge] swipe", flush=True)
            except Exception as exc:
                print(f"[bridge] swipe failed: {exc}", flush=True)
            for _ in range(max(1, interval)):
                if stop_event.is_set():
                    return
                time.sleep(1)

    threading.Thread(target=worker, name="rfpkt-swiper", daemon=True).start()


def start_proc_monitor(pkg, out_path, stop_event):
    def worker():
        with open(out_path, "w", encoding="utf-8") as fp:
            fp.write("ts\tpid\n")
            while not stop_event.is_set():
                try:
                    p = adb_shell(f"su -c 'pidof {pkg} 2>/dev/null || true'", timeout=5)
                    pid = (p.stdout or "").strip().replace("\r", " ")
                except Exception as exc:
                    pid = f"ERR:{exc}"
                fp.write(f"{time.time()}\t{pid}\n")
                fp.flush()
                for _ in range(5):
                    if stop_event.is_set():
                        return
                    time.sleep(1)

    threading.Thread(target=worker, name="rfpkt-proc-monitor", daemon=True).start()


def collect_postmortem(run_dir, pkg):
    logcat_cmd = (
        "su -c 'logcat -d -v threadtime | grep -E "
        "\"ANR|am_crash|FATAL|Fatal signal|SIGSEGV|tombstone|"
        "Input dispatching timed out|Application Not Responding|rustFrida|"
        "rfpkt350|libstagefright|com.ss.android.ugc.aweme\" || true'"
    )
    try:
        p = adb_shell(logcat_cmd, timeout=20)
        (run_dir / "logcat_filtered.log").write_text(p.stdout or "", encoding="utf-8", errors="replace")
    except Exception as exc:
        (run_dir / "logcat_filtered.log").write_text(f"logcat failed: {exc}\n", encoding="utf-8")
    try:
        p = adb_shell("su -c '/data/local/tmp/read_zygote_stagefright_tail 4048 /data/local/tmp/rf_dirty_after_rfpkt350 2>/dev/null || true'", timeout=10)
        (run_dir / "zygote_dirty_after.txt").write_text(p.stdout or "", encoding="utf-8", errors="replace")
    except Exception as exc:
        (run_dir / "zygote_dirty_after.txt").write_text(f"dirty check failed: {exc}\n", encoding="utf-8")
    try:
        p = adb_shell(f"su -c 'pidof {pkg} 2>/dev/null || true; ps -A | grep -E \"rustfrida|{pkg}\" || true'", timeout=10)
        (run_dir / "process_after.txt").write_text(p.stdout or "", encoding="utf-8", errors="replace")
    except Exception as exc:
        (run_dir / "process_after.txt").write_text(f"process check failed: {exc}\n", encoding="utf-8")


def ensure_frida_server(remote_path, restart=True, client_bin=None):
    name = Path(remote_path).name
    exists_inner = f"test -f {shell_quote_single(remote_path)} && echo yes || true"
    p = adb_shell(f"su -c {shell_quote_single(exists_inner)}", timeout=10)
    if "yes" not in (p.stdout or ""):
        raise RuntimeError(f"device frida-server missing: {remote_path}")

    chmod_inner = f"chmod 755 {shell_quote_single(remote_path)}"
    adb_shell(f"su -c {shell_quote_single(chmod_inner)}", check=True, timeout=10)

    if restart:
        kill_inner = (
            f"killall {shell_quote_single(name)} 2>/dev/null || true; "
            "killall frida-server 2>/dev/null || true"
        )
        adb_shell(f"su -c {shell_quote_single(kill_inner)}", timeout=10)

    def current_pid():
        pid_inner = (
            f"pidof {shell_quote_single(name)} 2>/dev/null || "
            "pidof frida-server 2>/dev/null || true"
        )
        pp = adb_shell(f"su -c {shell_quote_single(pid_inner)}", timeout=10)
        return (pp.stdout or "").strip().replace("\r", " ").split()

    def client_can_connect():
        if not client_bin:
            return False
        device_args = ["-D", os.environ["SERIAL"]] if os.environ.get("SERIAL") else ["-U"]
        try:
            pp = run([client_bin, *device_args, "ps"], capture=True, timeout=8)
            return pp.returncode == 0
        except Exception:
            return False

    pids = current_pid()
    if not pids and client_can_connect():
        pids = ["frida-ps-ok"]
    if not pids:
        log_remote = f"/data/local/tmp/{name}.log"
        start_inner = (
            f"cd /data/local/tmp; "
            f"nohup {shell_quote_single(remote_path)} >{shell_quote_single(log_remote)} 2>&1 </dev/null &"
        )
        adb_shell(f"su -c {shell_quote_single(start_inner)}", timeout=10)
        for _ in range(20):
            pids = current_pid()
            if not pids and client_can_connect():
                pids = ["frida-ps-ok"]
            if pids:
                break
            time.sleep(0.5)
    if not pids:
        raise RuntimeError(f"frida-server did not start: {remote_path}")
    print(f"[bridge] frida_server_remote={remote_path} pid={pids[0]}", flush=True)


def main():
    default_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--dyidre-root", default=str(default_root))
    parser.add_argument("--js", default=None)
    parser.add_argument("--run-dir", default=None)
    parser.add_argument("--tag", default=None)
    parser.add_argument("--seconds", type=int, default=180)
    parser.add_argument("--pkg", default="com.ss.android.ugc.aweme")
    parser.add_argument("--engine", choices=("rustfrida", "frida"), default="rustfrida",
                        help="injector to use: rustfrida keeps wxshadow path; frida uses stock Frida server/client")
    parser.add_argument("--rf-remote", default="/data/local/tmp/rustfrida")
    parser.add_argument("--frida-bin", default=None)
    parser.add_argument("--frida-server-remote", default="/data/local/tmp/frida-server-17.17.0")
    parser.add_argument("--frida-restart-server", dest="frida_restart_server", action="store_true", default=False)
    parser.add_argument("--no-frida-restart-server", dest="frida_restart_server", action="store_false")
    parser.add_argument("--frida-runtime", choices=("qjs", "v8"), default="qjs")
    parser.add_argument("--attach", action="store_true",
                        help="for --engine frida: launch app normally, wait, then attach instead of spawn")
    parser.add_argument("--attach-delay", type=int, default=10)
    parser.add_argument("--remote-js", default=None)
    parser.add_argument("--upload-url", default="http://127.0.0.1:8891/up/dy/packets")
    parser.add_argument("--connect-timeout", type=int, default=60)
    parser.add_argument("--filter-all", action="store_true")
    parser.add_argument("--capture-all-http", action="store_true",
                        help="stable wide mode: capture/upload every non-media Cronet URL and keep bodyless POST records")
    parser.add_argument("--include-static-traffic", action="store_true",
                        help="also capture image/video/effect/model/static URLs; default excludes them for stability")
    parser.add_argument("--hook-read", action="store_true",
                        help="hook CronetInputStream.read and allow read-triggered emits; heavy, default off")
    parser.add_argument("--emit-bodyless-post", action="store_true",
                        help="upload POST records even when request body was not captured, if headers/url are present")
    parser.add_argument("--emit-empty-post", action="store_true",
                        help="upload POST records even when both body and headers are empty")
    parser.add_argument("--max-body-bytes", type=int, default=0)
    parser.add_argument("--native-jn", dest="native_jn", action="store_true", default=False,
                        help="enable libsscronet.so native J.N URL/method/header hooks; default off")
    parser.add_argument("--no-native-jn", dest="native_jn", action="store_false",
                        help="disable libsscronet.so native J.N hooks")
    parser.add_argument("--hook-jn", action="store_true")
    parser.add_argument("--native", action="store_true", help="enable libmetasec_ml.so+0x14DBF4 hook; default is stable Java Cronet-only")
    parser.add_argument("--no-native", action="store_true", help="compatibility flag; native hook is already off by default")
    parser.add_argument("--swipe-after", type=int, default=15)
    parser.add_argument("--swipe-interval", type=int, default=12)
    parser.add_argument("--no-swipe", action="store_true")
    parser.add_argument("--print-packets", action="store_true")
    parser.add_argument("--verbose-hooks", action="store_true")
    args = parser.parse_args()

    if args.seconds < 1:
        raise SystemExit("--seconds must be >= 1")

    root = Path(args.dyidre_root).resolve()
    src_js = Path(args.js or root / "probes/350101/url_jn_packet_fullbody_350101.js")
    tag = args.tag or f"fullbody_hostbridge_{now_tag()}"
    run_dir = Path(args.run_dir or root / "runs/350101/packet_capture" / tag).resolve()
    run_dir.mkdir(parents=True, exist_ok=True)

    runtime_js = run_dir / "runtime_url_jn_packet_fullbody_350101.js"
    remote_js = args.remote_js or f"/data/local/tmp/rfpkt350_fullbody_{re.sub(r'[^A-Za-z0-9_.-]', '_', tag)}.js"

    config = {
        "taskName": tag,
        "filterAll": bool(args.filter_all or args.capture_all_http),
        "captureBodies": True,
        "captureResponseBody": False,
        "excludeStaticTraffic": not bool(args.include_static_traffic),
        "copyResponseHeaders": True,
        "hookNativeJN": bool(args.native_jn),
        "hookJN": bool(args.hook_jn),
        "skipBodyOnMainThread": True,
        "hookNative": bool(args.native) and not bool(args.no_native),
        "emitOnFirstBody": False,
        "emitOnXmWithBody": False,
        "emitOnDisconnect": True,
        "emitOnOutputCloseAfterBody": True,
        "hookInputStreamRead": bool(args.hook_read),
        "emitOnReadAfterBody": bool(args.hook_read),
        "emitOnGetInputStreamAfterBody": True,
        "emitOnBodyIdle": False,
        "useJavaIdleTimer": False,
        "emitEmptyPostDisconnect": bool(args.emit_empty_post or args.capture_all_http),
        "emitBodylessPostDisconnect": bool(args.emit_bodyless_post or args.capture_all_http),
        "skipWeakerDuplicateUrl": False,
        "bodyIdleFlushMs": 1800,
        "maxPending": 512,
        "maxBodyBytes": args.max_body_bytes,
        "logCreateEvery": 10 if args.verbose_hooks else 25,
        "logJNEvery": 10 if args.verbose_hooks else 50,
        "logConnectionEvery": 10 if args.verbose_hooks else 50,
        "logWriteEvery": 10 if args.verbose_hooks else 50,
        "logReadEvery": 25 if args.verbose_hooks else 0,
        "logNativeEvery": 5 if args.verbose_hooks else 20,
        "logDisconnectEvery": 10 if args.verbose_hooks else 20,
        "maxDiagLogs": 500 if args.verbose_hooks else 300,
        "logBodyEvery": 5 if args.verbose_hooks else 10,
        "nativeStringDumpLimit": 8 if args.verbose_hooks else 0,
        "printPackets": bool(args.print_packets),
    }
    generate_runtime_js(src_js, runtime_js, config)

    if args.engine == "rustfrida":
        run(adb_cmd(["push", str(runtime_js), remote_js]), check=True)
    parsed_upload = urllib.parse.urlparse(args.upload_url)
    upload_port = parsed_upload.port
    if upload_port is None:
        upload_port = 443 if parsed_upload.scheme == "https" else 80
    run(adb_cmd(["reverse", f"tcp:{upload_port}", f"tcp:{upload_port}"]), capture=True)

    # Start from a clean target process and clean logcat buffer.
    adb_shell(f"su -c 'am force-stop {args.pkg}; logcat -c; rm -f /data/local/tmp/rfpkt350_fullbody.log'", capture=True)

    print(f"[bridge] run_dir={run_dir}", flush=True)
    print(f"[bridge] engine={args.engine}", flush=True)
    if args.engine == "frida":
        print(f"[bridge] frida_attach={bool(args.attach)} attach_delay={args.attach_delay}s", flush=True)
        print(f"[bridge] frida_server_remote={args.frida_server_remote} restart={bool(args.frida_restart_server)}", flush=True)
    print(f"[bridge] runtime_js={runtime_js}", flush=True)
    if args.engine == "rustfrida":
        print(f"[bridge] remote_js={remote_js}", flush=True)
    print(f"[bridge] upload_url={args.upload_url}", flush=True)
    print(f"[bridge] adb_reverse=tcp:{upload_port}->tcp:{upload_port}", flush=True)
    print(f"[bridge] native_jn={bool(args.native_jn)} hook_jn={bool(args.hook_jn)} native_metasec={bool(args.native) and not bool(args.no_native)}", flush=True)
    print(f"[bridge] exclude_static={not bool(args.include_static_traffic)} hook_read={bool(args.hook_read)}", flush=True)
    print(f"[bridge] packet_seen={run_dir / 'packets_seen.jsonl'}", flush=True)
    print(f"[bridge] packet_uploaded={run_dir / 'packets_uploaded.jsonl'}", flush=True)
    console_name = "rustfrida_console.log" if args.engine == "rustfrida" else "frida_console.log"
    print(f"[bridge] console={run_dir / console_name}", flush=True)

    if args.engine == "rustfrida":
        cmd_inner = (
            f"cd /data/local/tmp && "
            f"RF_RESTORE_ZYGOTE_AFTER_CHILD_RESUME=1 "
            f"RF_DIAG_ZYM_NO_SETARGV0=1 "
            f"{shell_quote_single(args.rf_remote)} "
            f"--connect-timeout {int(args.connect_timeout)} "
            f"--spawn {shell_quote_single(args.pkg)} "
            f"-l {shell_quote_single(remote_js)}"
        )
        cmd = adb_cmd(["shell", f"su -c {shell_quote_single(cmd_inner)}"])
    else:
        frida_bin = args.frida_bin
        if not frida_bin:
            candidate = root / ".venv-frida350" / "bin" / "frida"
            frida_bin = str(candidate) if candidate.exists() else "frida"
        ensure_frida_server(args.frida_server_remote, bool(args.frida_restart_server), frida_bin)
        frida_device_args = ["-D", os.environ["SERIAL"]] if os.environ.get("SERIAL") else ["-U"]
        if args.attach:
            run(adb_cmd(["shell", "monkey", "-p", args.pkg, "-c", "android.intent.category.LAUNCHER", "1"]),
                capture=True)
            time.sleep(max(0, int(args.attach_delay)))
            p = adb_shell(f"pidof {args.pkg} 2>/dev/null || true", timeout=5)
            pid = (p.stdout or "").strip().replace("\r", " ").split()
            if not pid:
                raise RuntimeError(f"target process not running before attach: {args.pkg}")
            print(f"[bridge] frida_attach_pid={pid[0]}", flush=True)
            cmd = [
                frida_bin,
                *frida_device_args,
                "-p", pid[0],
                "-l", str(runtime_js),
                "--runtime", args.frida_runtime,
            ]
        else:
            cmd = [
                frida_bin,
                *frida_device_args,
                "-f", args.pkg,
                "-l", str(runtime_js),
                "--runtime", args.frida_runtime,
            ]
    proc = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
        bufsize=1,
    )

    stop_event = threading.Event()
    counts = {"packet_b64": 0, "uploaded": 0, "upload_failed": 0}
    paths = {
        "console": str(run_dir / console_name),
        "bridge": str(run_dir / "bridge.log"),
        "seen": str(run_dir / "packets_seen.jsonl"),
        "uploaded": str(run_dir / "packets_uploaded.jsonl"),
        "upload_tsv": str(run_dir / "upload_results.tsv"),
    }
    start_reader(proc, paths, args.upload_url, counts, stop_event)
    start_proc_monitor(args.pkg, str(run_dir / "process_monitor.tsv"), stop_event)
    if not args.no_swipe:
        start_swiper(args.swipe_after, args.swipe_interval, stop_event)

    deadline = time.time() + args.seconds
    try:
        while time.time() < deadline and proc.poll() is None:
            time.sleep(1)
    except KeyboardInterrupt:
        print("[bridge] interrupted by user", flush=True)

    if proc.poll() is None:
        try:
            proc.stdin.write("exit\n")
            proc.stdin.flush()
        except Exception:
            pass
        try:
            proc.wait(timeout=12)
        except subprocess.TimeoutExpired:
            proc.terminate()
            try:
                proc.wait(timeout=5)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait(timeout=5)

    stop_event.set()
    time.sleep(1)
    collect_postmortem(run_dir, args.pkg)

    summary = {
        "run_dir": str(run_dir),
        "engine": args.engine,
        "frida_attach": bool(args.attach) if args.engine == "frida" else False,
        "runtime_js": str(runtime_js),
        "remote_js": remote_js if args.engine == "rustfrida" else "",
        "seconds": args.seconds,
        "packet_b64": counts["packet_b64"],
        "uploaded": counts["uploaded"],
        "upload_failed": counts["upload_failed"],
        "process_rc": proc.returncode,
    }
    (run_dir / "summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print("[bridge] summary=" + json.dumps(summary, ensure_ascii=False, separators=(",", ":")), flush=True)
    return 0 if counts["uploaded"] > 0 and counts["upload_failed"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
