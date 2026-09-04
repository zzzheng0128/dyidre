// Douyin 350101 MetaSec probe — xheader.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l xheader_350101.js

// ===== mode: xheader / 最终 header 写出 =====
// 历史来源：metasec_xheader_treeput_probe_350.js
// 什么时候用：确认 X-Argus/X-Ladon/X-Medusa/X-Helios/X-Soter 最终写入 TreeMap 的 key/value。
function __dyidre_mode_xheader() {
// Probe MetaSec 350.101 X-* header emission by dumping treeMapPut_350 args.
//
// Target:
//   libmetasec_ml.so + 0x149ca8  buildSignedHttpHeadersInner_350
//   libmetasec_ml.so + 0x11fc30  treeMapPut_350(map, key_memblock, value_memblock)
//
// Run example:
//   probes/350101/run_metasec_probe_350101.sh xheader 90 xhdr01
//
// Interesting callsites:
//   0x14A2B0 -> observed X-Argus
//   0x14A320 -> observed X-Ladon
//   0x14A53C -> F8-generated main final header pair, likely X-Medusa; dump key/value to prove it
//   0x14A65C -> observed X-Soter

var TARGET_MODULE = "libmetasec_ml.so";
var TREE_MAP_PUT_OFF = 0x11fc30;
var INNER_ENTRY_OFF = 0x149ca8;
var MAX_DUMP_BYTES = 0x800;

var interestingCallsites = {
    0x14a2b0: "insert X-Argus",
    0x14a320: "insert X-Ladon",
    0x14a53c: "insert F8-main-final-header",
    0x14a65c: "insert X-Soter"
};

var installed = false;
var hitCount = {};
var xheaderErrorCount = 0;

function log(s) {
    console.log("[metasec-xhdr350] " + s);
}

function tryStealth() {
    try {
        if (typeof Java !== "undefined" &&
            Java !== null &&
            typeof Java.setStealth === "function" &&
            typeof Hook !== "undefined" &&
            Hook !== null &&
            Hook.WXSHADOW !== undefined) {
            Java.setStealth(Hook.WXSHADOW);
            log("Java.setStealth(Hook.WXSHADOW) enabled");
        }
    } catch (e) {
        log("stealth setup skipped: " + e);
    }
}

function byteToNumber(v) {
    try {
        // rustFrida 的 QuickJS 环境里，readU8()/Uint8Array 元素偶尔会以 BigInt 形式参与运算。
        // 这里统一压成 0..255 的普通 number，避免 “cannot convert bigint to number”。
        if (typeof v === "bigint") return Number(v & 0xffn);
        return Number(v) & 0xff;
    } catch (_) {
        return 0;
    }
}

function u32ToNumber(v) {
    try {
        // MEM_BLOCK 的长度字段是 u32；统一转 number，后面才能做 Math.min/大小比较。
        if (typeof v === "bigint") return Number(v & 0xffffffffn) >>> 0;
        return Number(v) >>> 0;
    } catch (_) {
        return 0;
    }
}

function pad2(n) {
    var s = byteToNumber(n).toString(16);
    return s.length < 2 ? "0" + s : s;
}

function bytesToHex(bytes, maxLen) {
    var out = [];
    var n = Math.min(bytes.length, maxLen);
    for (var i = 0; i < n; i++) {
        out.push(pad2(bytes[i]));
    }
    return out.join(" ");
}

function bytesToAscii(bytes, maxLen) {
    var out = "";
    var n = Math.min(bytes.length, maxLen);
    for (var i = 0; i < n; i++) {
        var b = byteToNumber(bytes[i]);
        if (b === 0x0d) out += "\\r";
        else if (b === 0x0a) out += "\\n";
        else if (b === 0x09) out += "\\t";
        else if (b >= 0x20 && b <= 0x7e) out += String.fromCharCode(b);
        else out += ".";
    }
    return out;
}

function fnv1a32(bytes) {
    var h = 0x811c9dc5;
    for (var i = 0; i < bytes.length; i++) {
        h ^= byteToNumber(bytes[i]);
        h = Math.imul(h, 0x01000193) >>> 0;
    }
    var s = h.toString(16);
    while (s.length < 8) s = "0" + s;
    return s;
}

function safeRange(p) {
    try {
        var r = Process.findRangeByAddress(p);
        if (r === null || r.protection.indexOf("r") < 0) return null;
        return r;
    } catch (e) {
        return null;
    }
}

function isNullPtr(p) {
    try {
        var s = ptr(p).toString().toLowerCase();
        return s === "0x0" || s === "0";
    } catch (_) {
        return true;
    }
}

function safeReadBytes(p, len) {
    try {
        if (len <= 0) return new Uint8Array(0);
        var buf = Memory.readByteArray(p, len);
        if (buf === null) return null;
        return new Uint8Array(buf);
    } catch (e) {
        return null;
    }
}

function readCStringBytes(p, maxLen) {
    var out = [];
    for (var i = 0; i < maxLen; i++) {
        try {
            var b = byteToNumber(p.add(i).readU8());
            if (b === 0) return out;
            out.push(b);
        } catch (e) {
            return out;
        }
    }
    return out;
}

function dumpMaybeCString(label, p) {
    try {
        if (safeRange(p) === null) {
            log(label + " raw=" + p + " unreadable");
            return;
        }
        var bytes = readCStringBytes(p, 0x200);
        log(label + " raw-cstr len=" + bytes.length +
            " fnv1a=" + fnv1a32(bytes) +
            " ascii=\"" + bytesToAscii(bytes, bytes.length) + "\"");
    } catch (e) {
        log(label + " raw-cstr failed: " + e);
    }
}

function dumpMemBlock(label, raw) {
    var p;
    try {
        p = ptr(raw);
    } catch (e) {
        log(label + " ptr_parse_failed raw=" + raw + " err=" + e);
        return;
    }

    try {
        if (isNullPtr(p)) {
            log(label + "=0x0");
            return;
        }
    } catch (e0) {
    }

    if (safeRange(p) === null) {
        dumpMaybeCString(label, p);
        return;
    }

    try {
        var memLen = u32ToNumber(p.add(8).readU32());
        var srcLen = u32ToNumber(p.add(12).readU32());
        var body = p.add(16).readPointer();
        var len = srcLen !== 0 ? srcLen : memLen;
        var sane = len >= 0 && len < 0x20000 && !isNullPtr(body) && safeRange(body) !== null;

        if (!sane) {
            log(label + " memblock? p=" + p +
                " mem_len=0x" + memLen.toString(16) +
                " src_len=0x" + srcLen.toString(16) +
                " body=" + body + " sane=false");
            dumpMaybeCString(label, p);
            return;
        }

        var dumpLen = Math.min(len, MAX_DUMP_BYTES);
        var bytes = safeReadBytes(body, dumpLen);
        if (bytes === null) {
            log(label + " memblock p=" + p +
                " mem_len=0x" + memLen.toString(16) +
                " src_len=0x" + srcLen.toString(16) +
                " body=" + body + " read_failed");
            return;
        }

        log(label + " memblock p=" + p +
            " mem_len=0x" + memLen.toString(16) +
            " src_len=0x" + srcLen.toString(16) +
            " body=" + body +
            " dump=0x" + dumpLen.toString(16) +
            " fnv1a=" + fnv1a32(bytes));
        log(label + " ascii=\"" + bytesToAscii(bytes, dumpLen) + "\"" +
            (len > dumpLen ? " ...<truncated>" : ""));
        log(label + " hex=" + bytesToHex(bytes, Math.min(dumpLen, 0x100)) +
            (dumpLen > 0x100 ? " ...<hex truncated>" : ""));
    } catch (e) {
        log(label + " memblock dump failed: " + e);
        dumpMaybeCString(label, p);
    }
}

function offFromBase(base, p) {
    try {
        if (p === undefined || p === null) return -1;
        var diffText = ptr(p).sub(ptr(base)).toString();
        if (diffText.indexOf("0x") === 0 || diffText.indexOf("-0x") === 0) {
            return parseInt(diffText, 16);
        }
        return parseInt(diffText, 10);
    } catch (e) {
        return -1;
    }
}

function ctxValue(ctx, name) {
    try {
        if (ctx && ctx[name] !== undefined && ctx[name] !== null) return ctx[name];
    } catch (_) {
    }
    return "?";
}

function ptrText(value) {
    try {
        if (value === "?" || value === undefined || value === null) return "?";
        return ptr(value).toString();
    } catch (_) {
        return String(value);
    }
}

function returnAddressOf(invocation) {
    try {
        if (invocation.returnAddress !== undefined && invocation.returnAddress !== null) {
            return invocation.returnAddress;
        }
    } catch (_) {
    }
    try {
        if (invocation.context && invocation.context.x30 !== undefined) return invocation.context.x30;
    } catch (_) {
    }
    try {
        if (invocation.context && invocation.context.lr !== undefined) return invocation.context.lr;
    } catch (_) {
    }
    return null;
}

function installAtBase(base) {
    if (installed) return;
    installed = true;

    var entry = base.add(INNER_ENTRY_OFF);
    var put = base.add(TREE_MAP_PUT_OFF);
    log("module base=" + base + " inner=" + entry + " treeMapPut=" + put);

    Interceptor.attach(entry, {
        onEnter: function (args) {
            try {
                log("hit buildSignedHttpHeadersInner_350 x0(ctx)=" + args[0] +
                    " x1(json_list)=" + args[1] +
                    " x2(url)=" + args[2] +
                    " x3(x_ss_stub)=" + args[3] +
                    " x4(type)=" + args[4] +
                    " x5(tree_map)=" + args[5] +
	                    // rustFrida 的 Interceptor helper 把寄存器 ctx 直接作为 this，
	                    // 不是官方 Frida 那种 this.context 包一层。
	                    " x8(out)=" + ptrText(ctxValue(this, "x8")));
            } catch (e) {
                if (xheaderErrorCount++ < 5) log("inner entry dump failed: " + e);
            }
        }
    });

    Interceptor.attach(put, {
        onEnter: function (args) {
            try {
                var lr = returnAddressOf(this);
                var lrOff = offFromBase(base, lr);
                var callOff = lrOff - 4;
                if (!isFinite(callOff) || callOff < 0) return;
                var tag = interestingCallsites[callOff];
                if (tag === undefined) return;

                var key = String(callOff);
                hitCount[key] = (hitCount[key] || 0) + 1;

                log("---- treeMapPut from 0x" + callOff.toString(16) +
                    " (" + tag + ") hit=" + hitCount[key] + " ----");
                log("map=" + args[0] + " key=" + args[1] + " value=" + args[2] +
                    " lr=0x" + lrOff.toString(16));
                dumpMemBlock("key", args[1]);
                dumpMemBlock("value", args[2]);
            } catch (e) {
                if (xheaderErrorCount++ < 5) {
                    log("treeMapPut dump failed: " + e);
                    try { log(String(e.stack)); } catch (_) {}
                }
            }
        }
    });
}

function waitForTargetModule() {
    tryStealth();

    function findTargetBase() {
        try {
            var m = Process.findModuleByName(TARGET_MODULE);
            return m === null ? null : m.base;
        } catch (e) {
            return null;
        }
    }

    function findGlobalExport(name) {
        try {
            if (typeof Module.findExportByName === "function") {
                return Module.findExportByName(null, name);
            }
        } catch (_) {
        }
        try {
            if (typeof Module.findGlobalExportByName === "function") {
                return Module.findGlobalExportByName(name);
            }
        } catch (_) {
        }
        return null;
    }

    var base = findTargetBase();
    if (base !== null) {
        installAtBase(base);
        return;
    }

    var hookedLoader = false;

    function watchLoader(symbol) {
        var dlopen = findGlobalExport(symbol);
        if (dlopen === null) return;

        try {
            Interceptor.attach(dlopen, {
                onEnter: function (args) {
                    try {
                        this.path = args[0].readCString();
                    } catch (e) {
                        this.path = "";
                    }
                },
                onLeave: function () {
                    var path = this.path || "";
                    if (installed || path.indexOf(TARGET_MODULE) < 0) return;

                    var finish = function () {
                        var loadedBase = findTargetBase();
                        log(symbol + " loaded: " + path + " base=" + loadedBase);
                        if (loadedBase !== null) installAtBase(loadedBase);
                    };
                    if (typeof setImmediate === "function") setImmediate(finish);
                    else finish();
                }
            });
            hookedLoader = true;
            log("watch " + symbol + " @" + dlopen);
        } catch (e) {
            log("watch " + symbol + " failed: " + e);
        }
    }

    watchLoader("android_dlopen_ext");
    watchLoader("dlopen");

    if (hookedLoader) log("waiting for " + TARGET_MODULE);
    else log("cannot find dlopen/android_dlopen_ext");
}

waitForTargetModule();

}

(function () {
    console.log("[metasec-xheader] standalone loaded (Frida 17)");
    __dyidre_mode_xheader();
})();
