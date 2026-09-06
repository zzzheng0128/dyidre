#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
campaign_round3_classify.py — 基于明文种子词汇的全量函数自动分类器

输入: seed_index.json (1,210 函数 / 2,261 条 site->明文 种子)
输出: campaign_round3_ledger.json (逐函数分类台账) + 终端摘要

方法: 对每个函数的全部种子做小写子串匹配, 按领域计分;
强关键词(专有名词)权重 2, 普通关键词权重 1。
置信度: >=4 高, 2-3 中, 1 低, 纯噪音 未定。
"""
import json
from collections import Counter, defaultdict

# ---- 领域关键词表 (全部小写匹配) ----
# 强词 = 该领域专有名词, 一词即可定方向; 普词 = 需要共现
DOMAINS = {
    "cloud_phone_vm": {  # 云手机/模拟器/虚拟空间
        "strong": ["bksim", "vphone", "ro.x8.", "/x8.prop", "/x8/config", "vmprop.",
                   "ro.vmos", "rksdk", "titan", "minicap", "2ndos", "8zs.sandbox",
                   "mena.czl", "phonegaga", "dual.space", "full_vm", "opmuuid",
                   "oppo_iccid", "vivo_iccid", "opporadio", "redfinger"],
        "weak": ["iccid", "emulator", "qemu", "genymotion", "/vendor/lib64"],
    },
    "root_magisk": {  # root / Magisk 检测
        "strong": ["magisk", "daemonsu", "shuamesu", "/su/bin", "ku.sud", "bstk",
                   "supersu", "superuser", "inject_app_process", "root.pkg",
                   "longeneroot", "/system/xbin/su", "/system/bin/su", "bdsu",
                   "sutemp", "sudo", "rootfs"],
        "weak": ["/sbin/", "busybox", "root", ".su"],
    },
    "inject_framework": {  # 注入/Hook 框架检测
        "strong": ["frida", "xposed", "shadowhook", "substrate", "maps_risklist",
                   "maps_safelist", "nativebridgeerror", "libnativebridge",
                   "no_xposed_risk", "rtld_db_dlactivity", "posed"],
        "weak": ["hook", "inject", "/proc/self/maps", "anon:"],
    },
    "brand_rom": {  # 品牌/ROM 指纹
        "strong": ["ro.product.brand", "ro.build.fingerprint", "miui", "coloros",
                   "huawei", "honor", "redmi", "xiaomi", "oneplus", "meizu",
                   "gionee", "koobee", "leeco", "letv", "nubia", "qiku",
                   "smartisan", "noahedu", "prize", "oppo", "vivo"],
        "weak": ["ro.product.", "ro.build.", "ro.config.", "manufacturer",
                 "google"],
    },
    "device_id": {  # 设备标识采集
        "strong": ["mediadrm", "property_device_unique_id", "android_id",
                   "device_id", "sdk_aid", "host_aid", "oaid", "imei",
                   "apk_all_sign_md5", "getpropertybytearray", "java/util/uuid"],
        "weak": ["uuid", "getpackagename", "pm path", "sign"],
    },
    "anti_debug_proc": {  # 反调试/进程状态解析
        "strong": ["tracer_pid", "process_tree", "orphan", "/proc/%d/status",
                   "ptrace"],
        "weak": ["ppid", "/proc/self/status", "pid"],
    },
    "sys_prop": {  # 系统属性读取(通用)
        "strong": ["__system_property", "systemproperties", "/system/build.prop"],
        "weak": ["getproperty", "persist.", "sys.usb", "init.svc"],
    },
    "jni_reflect": {  # JNI/反射/ART 辅助
        "strong": ["artmethod", "java/lang/reflect", "activitythread",
                   "libart.so", "getmethodid", "findclass"],
        "weak": ["java/lang/", "android/", "classloader", "<init>", "getclass",
                 "getsystemservice", "invoke"],
    },
    "network_report": {  # 上报/网络通道
        "strong": ["reporturls", "configurls", "/ri/report", "itor/collect",
                   "rp_fail_record", "http.proxyhost"],
        "weak": ["http", "url", "channel", "host"],
    },
    "hardware_feature": {  # 硬件/系统服务特性探测
        "strong": ["feature_bluetooth", "feature_location", "feature_nfc",
                   "feature_telephony", "audio_service", "keyguard_service",
                   "inputdevice"],
        "weak": ["getsystemservice", "service", "sensor"],
    },
    "crypto": {  # 加密/编码
        "strong": ["pbstringencrypt", "aes", "rsa", "base64"],
        "weak": ["md5", "sha", "encrypt", "sign"],
    },
    "app_risk": {  # 风险应用/包名检测
        "strong": ["mssdk_riskapp_db", "com.tencent.mm", "com.huawei.appmarket",
                   "riskapp"],
        "weak": ["com.", "apk", "package"],
    },
    "sdk_version": {  # SDK 版本/内部标识 (v04.09.05 族)
        "strong": ["v04.09.05", ".mss_", ".msf3_", "msspitem", "msmanagerutils",
                   "mssdk", "!notset!", "sdi_v2"],
        "weak": ["bd", "1.0", "sdi", "3019"],
    },
}

# 纯噪音种子: 格式串/JNI 签名碎片/单字符 — 不参与定域
NOISE = {"%d", "%s", "%ld", "%lld", "%p", "%u.%u.%u.%u", "{}", "|", ":", ";",
         "r", "l", "w", "a", "d", "n", "o", "1", "2", "0", "i", "j", "cp",
         "hh", "op", "rp", "rb", "ml", "er;", "ager;", "bject;", "tring;",
         "ring;)i", "string;", "-8", "ab", "er", "op"}

def is_jni_sig(s: str) -> bool:
    """JNI 方法签名形态: (xxx)yyy 或 Lxxx; 碎片"""
    return (s.startswith("(") and ")" in s) or (s.endswith(";") and len(s) <= 22)

# classify() 打分规则：
#   对每个函数的全部种子明文做小写子串匹配，按 DOMAINS 16 域计分；
#   强关键词（专有名，如 magisk/frida/ro.x8.*）权重 2，普通词权重 1；
#   NOISE 集合（printf 占位符、单字母、JNI 碎片）直接丢弃；
#   置信度 = 最高分映射：>=4 高，2-3 中，1 低，纯噪音 未定；
#   secondary 记录次高域（用于发现跨域函数，如 brand_rom ∩ cloud_phone_vm）。
def classify(seeds):
    pts = [s["pt"] for s in seeds]
    scores = defaultdict(float)
    hits = defaultdict(list)
    informative = 0
    for pt in pts:
        low = pt.lower()
        if low in NOISE or is_jni_sig(pt) or len(low) <= 1:
            continue
        informative += 1
        for dom, kw in DOMAINS.items():
            for w in kw["strong"]:
                if w in low:
                    scores[dom] += 2
                    hits[dom].append(pt)
                    break
            else:
                for w in kw["weak"]:
                    if w in low:
                        scores[dom] += 1
                        hits[dom].append(pt)
                        break
    if not scores:
        return ("plumbing_noise" if informative == 0 else "unclassified",
                None, 0.0, "未定", [])
    ranked = sorted(scores.items(), key=lambda kv: -kv[1])
    dom, score = ranked[0]
    secondary = ranked[1][0] if len(ranked) > 1 and ranked[1][1] >= 2 else None
    if score >= 4:
        conf = "高"
    elif score >= 2:
        conf = "中"
    else:
        conf = "低"
    return (dom, secondary, score, conf, hits[dom][:5])

def main():
    d = json.load(open("seed_index.json"))
    idx = d["index"]
    # 已被 Round 2 完整反编译坐实的 10 个函数 -> 强制高置信
    verified = {"0x7f1a0", "0xc2a60", "0x39778", "0x77ec4", "0xc5d00",
                "0xc710c", "0xafe94", "0x12e2a4", "0xc0190", "0x16b080"}
    ledger = {}
    dom_stat = Counter()
    conf_stat = Counter()
    for addr, e in idx.items():
        dom, sec, score, conf, ev = classify(e["seeds"])
        if addr in verified and conf != "未定":
            conf = "高(已反编译坐实)"
        ledger[addr] = {
            "name": e["name"], "domain": dom, "secondary": sec,
            "score": score, "confidence": conf,
            "seed_count": len(e["seeds"]), "evidence": ev,
        }
        dom_stat[dom] += 1
        conf_stat[conf] += 1
    json.dump(ledger, open("campaign_round3_ledger.json", "w"),
              ensure_ascii=False, indent=1)
    print(f"total: {len(ledger)}")
    print("\n== domain distribution ==")
    for dom, n in dom_stat.most_common():
        print(f"  {dom:<18} {n}")
    print("\n== confidence distribution ==")
    for c, n in conf_stat.most_common():
        print(f"  {c:<14} {n}")
    # domain x confidence matrix (brief)
    print("\n== domain x conf ==")
    mat = defaultdict(Counter)
    for v in ledger.values():
        mat[v["domain"]][v["confidence"]] += 1
    for dom, n in dom_stat.most_common():
        row = mat[dom]
        print(f"  {dom:<18} 高:{row.get('高',0)+row.get('高(已反编译坐实)',0):<4} "
              f"中:{row.get('中',0):<4} 低:{row.get('低',0):<4}")

if __name__ == "__main__":
    main()
