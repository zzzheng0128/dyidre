#!/usr/bin/env python3
import argparse
import html
import os
import re
import subprocess
import time
import xml.etree.ElementTree as ET


DENY_TEXTS = [
    "不允许",
    "拒绝",
    "禁止",
    "暂不允许",
    "不同意授权",
    "Deny",
    "DENY",
    "Don’t allow",
    "Don't allow",
]

SKIP_TEXTS = [
    "跳过",
    "暂不",
    "暂不开启",
    "以后再说",
    "稍后再说",
    "稍后",
    "取消",
    "关闭",
    "我知道了",
    "知道了",
    "忽略",
    "不启用",
    "下次再说",
]

PROCEED_TEXTS = [
    "同意",
    "同意并继续",
    "同意，继续",
    "同意并进入",
    "同意并使用",
    "进入抖音",
    "开始使用",
    "Agree",
]

ALLOW_WORDS = [
    "允许",
    "授权",
    "开启",
    "打开",
    "去设置",
    "始终",
    "使用期间",
    "Allow",
]

PRIVACY_WORDS = [
    "隐私政策",
    "用户协议",
    "服务协议",
    "个人信息",
]


def run(cmd, timeout=8):
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=timeout)
    return p.stdout


def adb(args, serial, adb_path):
    # 组合采集流程传入同一个 adb，避免 SDK 路径变化导致弹窗处理失效。
    cmd = [adb_path]
    if serial:
        cmd += ["-s", serial]
    cmd += args
    return run(cmd)


def parse_bounds(bounds):
    m = re.match(r"\[(\d+),(\d+)\]\[(\d+),(\d+)\]", bounds or "")
    if not m:
        return None
    x1, y1, x2, y2 = map(int, m.groups())
    if x2 <= x1 or y2 <= y1:
        return None
    return (x1, y1, x2, y2, (x1 + x2) // 2, (y1 + y2) // 2)


def get_nodes(serial, adb_path):
    adb(["shell", "uiautomator", "dump", "/sdcard/window.xml"], serial, adb_path)
    xml = adb(["shell", "cat", "/sdcard/window.xml"], serial, adb_path)
    start = xml.find("<?xml")
    if start > 0:
        xml = xml[start:]
    root = ET.fromstring(xml)
    nodes = []
    all_text = []
    for n in root.iter("node"):
        text = html.unescape(n.attrib.get("text", "") or "")
        desc = html.unescape(n.attrib.get("content-desc", "") or "")
        rid = n.attrib.get("resource-id", "") or ""
        bounds = n.attrib.get("bounds", "") or ""
        clickable = n.attrib.get("clickable", "") == "true"
        enabled = n.attrib.get("enabled", "") != "false"
        b = parse_bounds(bounds)
        label = text or desc
        if label:
            all_text.append(label)
        if enabled and b:
            nodes.append({
                "text": text,
                "desc": desc,
                "rid": rid,
                "label": label,
                "bounds": bounds,
                "xy": (b[4], b[5]),
                "clickable": clickable,
            })
    return nodes, "\n".join(all_text)


def has_any(s, words):
    return any(w and w in s for w in words)


def is_short_button(label, max_len=16):
    s = (label or "").strip()
    return 0 < len(s) <= max_len and "\n" not in s


def is_clickable_button(n):
    label = n["label"]
    rid = n["rid"]
    return n["clickable"] or "button" in rid.lower() or is_short_button(label)


def bad_allow(label):
    return has_any(label, ALLOW_WORDS) and not has_any(label, DENY_TEXTS + SKIP_TEXTS)


def pick_node(nodes, page_text):
    # Android permission dialog: resource-id is more reliable than text.
    for n in nodes:
        rid = n["rid"]
        label = n["label"]
        if "permission_deny" in rid or "permission_deny_button" in rid:
            return n, "deny-rid"
        if is_short_button(label, 24) and has_any(label, DENY_TEXTS) and is_clickable_button(n):
            return n, "deny-text"

    # Privacy/terms first-launch page: allow only the product agreement button,
    # not Android runtime permission "allow" buttons.
    if has_any(page_text, PRIVACY_WORDS):
        candidates = []
        for n in nodes:
            label = (n["label"] or "").strip()
            if not is_short_button(label, 20):
                continue
            if label in PROCEED_TEXTS or has_any(label, PROCEED_TEXTS):
                if not any(x in label for x in ["权限", "授权", "位置", "相机", "麦克风", "通讯录", "通知"]):
                    candidates.append(n)
        if candidates:
            candidates.sort(key=lambda x: x["xy"][1], reverse=True)
            return candidates[0], "privacy-agree"

    for n in nodes:
        label = n["label"]
        if is_short_button(label, 24) and has_any(label, SKIP_TEXTS) and not bad_allow(label) and is_clickable_button(n):
            return n, "skip-text"

    return None, None


def do_swipe(serial, adb_path):
    # Pixel 6 portrait: upward feed swipe.
    adb(["shell", "input", "swipe", "540", "1900", "540", "650", "450"], serial, adb_path)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--serial", default=os.environ.get("SERIAL", "18201FDF6002GR"))
    ap.add_argument(
        "--adb",
        default=os.environ.get("ADB", "/Users/freeman/Library/Android/sdk/platform-tools/adb"),
        help="adb 可执行文件路径；默认读取 ADB 环境变量",
    )
    ap.add_argument("--duration", type=int, default=180)
    ap.add_argument("--interval", type=float, default=0.8)
    ap.add_argument("--swipe-after", type=int, default=0)
    ap.add_argument("--swipe-interval", type=int, default=30)
    ap.add_argument("--popup-slow-interval", type=float, default=5.0)
    args = ap.parse_args()

    end = time.time() + args.duration
    start = time.time()
    agree_time = None
    next_swipe = None
    seen = {}
    print(f"[auto-skip] serial={args.serial} duration={args.duration}s swipe_after={args.swipe_after}s swipe_interval={args.swipe_interval}s")
    while time.time() < end:
        now = time.time()
        if next_swipe is not None and now >= next_swipe:
            print(f"[auto-skip] swipe up at +{int(now - start)}s")
            do_swipe(args.serial, args.adb)
            next_swipe = now + args.swipe_interval

        try:
            nodes, page_text = get_nodes(args.serial, args.adb)
            node, reason = pick_node(nodes, page_text)
            if node is not None:
                x, y = node["xy"]
                label = node["label"] or node["rid"]
                key = f"{reason}:{label}:{node['bounds']}"
                seen[key] = seen.get(key, 0) + 1
                print(f"[auto-skip] tap {reason} ({x},{y}) label={label!r} rid={node['rid']!r} count={seen[key]}")
                adb(["shell", "input", "tap", str(x), str(y)], args.serial, args.adb)
                if reason == "privacy-agree" and agree_time is None:
                    agree_time = time.time()
                    if args.swipe_after > 0:
                        next_swipe = agree_time + args.swipe_after
                        print(f"[auto-skip] privacy agreed; first swipe scheduled in {args.swipe_after}s")
                time.sleep(1.0)
                continue
        except Exception as e:
            print(f"[auto-skip] dump/parse failed: {e}")
        if agree_time is not None and args.swipe_after > 0:
            time.sleep(args.popup_slow_interval)
        else:
            time.sleep(args.interval)
    print("[auto-skip] done")


if __name__ == "__main__":
    main()
