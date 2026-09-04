// Douyin 350101 MetaSec probe — gum-http.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l gum_http_350101.js

// ===== mode: gum-http / HTTP 签名入口 raw trace =====
// 历史来源：gumtrace_getHttpHeadVerify_350101_full_once.js
// 什么时候用：需要对齐 buildSignedHttpHeadersInner_350 入口之后的完整 raw 指令流时短跑。
function __dyidre_mode_gum_http() {
// GumTrace + RustFrida launcher script.
//
// Target:
//   Douyin 35.0.0/35.4.0 libmetasec_ml.so buildSignedHttpHeadersInner_350
//   old 334: libwhats3340.so + 0x15ab90 getHttpHeadVerify
//   new 350: libmetasec_ml.so + 0x149ca8 sub_149CA8
//   new 350 callback wrapper observed in unidbg: libmetasec_ml.so + 0x14dbf4
//
// Device files:
//   /data/local/tmp/libGumTrace.so
//   /data/local/tmp/xx.js
//
// Run:
//   su 0 -c 'cd /data/local/tmp && ./rustfrida --spawn com.ss.android.ugc.aweme -l xx.js'

var TARGET_MODULE = "libmetasec_ml.so";
var TARGET_OFFSET = 0x149ca8;
var WRAPPER_OFFSET = 0x14dbf4;
var GUMTRACE_SO = "/data/local/tmp/libGumTrace.so";
var TRACE_FILE = "/data/data/com.ss.android.ugc.aweme/gumtrace_getHttpHeadVerify_350101_full_once.log";

// GumTrace options:
//   0 = Stand
//   1 = DEBUG
//   2 = STABLE
var GUMTRACE_MODE = 2;
// For s1/s2/struct parity checks we only need the entry arguments.
// Flip this to true when an instruction-level GumTrace log is needed.
var ENABLE_GUMTRACE = true;
var DUMP_BYTES = 0x100;
var DUMP_NESTED_BYTES = 0x40;
var DUMP_CSTRING_MAX = 0x2000;

var gumtraceLoaded = false;
var gumtraceInit = null;
var gumtraceRun = null;
var gumtraceUnrun = null;

var installed = false;
var wrapperInstalled = false;
var tracing = false;
var tracedOnce = false;
var wrapperTracedOnce = false;
var listener = null;
var wrapperListener = null;

function log(s) {
    console.log("[gumtrace-getHttpHeadVerify-350] " + s);
}

function reg(thiz, name) {
    try {
        if (thiz !== undefined && thiz !== null && thiz.context !== undefined && thiz.context !== null) {
            var cv = thiz.context[name];
            if (cv !== undefined) {
                return ptr(cv).toString();
            }
        }
        var v = thiz[name];
        return v === undefined ? "undefined" : ptr(v).toString();
    } catch (e) {
        return "err:" + e;
    }
}

function regPtr(thiz, name) {
    try {
        if (thiz !== undefined && thiz !== null && thiz.context !== undefined && thiz.context !== null) {
            var cv = thiz.context[name];
            if (cv !== undefined) {
                return ptr(cv);
            }
        }
        var v = thiz[name];
        return v === undefined ? null : ptr(v);
    } catch (e) {
        log("[entry-dump] regPtr " + name + " failed: " + e);
        return null;
    }
}

function arg(args, index) {
    try {
        var v = args[index];
        return v === undefined ? "undefined" : String(v);
    } catch (e) {
        return "err:" + e;
    }
}

function pad2(n) {
    var s = (n & 0xff).toString(16);
    return s.length < 2 ? "0" + s : s;
}

function hex32(n) {
    var s = (n >>> 0).toString(16);
    while (s.length < 8) {
        s = "0" + s;
    }
    return s;
}

function fnv1a32(bytes) {
    var h = 0x811c9dc5;
    for (var i = 0; i < bytes.length; i++) {
        h ^= bytes[i] & 0xff;
        h = Math.imul(h, 0x01000193) >>> 0;
    }
    return hex32(h);
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
        var b = bytes[i] & 0xff;
        if (b === 0x0d) {
            out += "\\r";
        } else if (b === 0x0a) {
            out += "\\n";
        } else if (b === 0x09) {
            out += "\\t";
        } else if (b >= 0x20 && b <= 0x7e) {
            out += String.fromCharCode(b);
        } else {
            out += ".";
        }
    }
    return out;
}

function safePtr(v) {
    try {
        if (v === undefined || v === null) {
            return null;
        }
        return ptr(v);
    } catch (e) {
        return null;
    }
}

function isNullPtr(p) {
    try {
        if (p === null || p === undefined) {
            return true;
        }
        var s = ptr(p).toString();
        return s === "0x0" || s === "0";
    } catch (e) {
        return true;
    }
}

function safeReadBytes(p, len) {
    try {
        var buf = Memory.readByteArray(p, len);
        if (buf === null) {
            return null;
        }
        return new Uint8Array(buf);
    } catch (e) {
        return null;
    }
}

function readCStringBytes(p, maxLen) {
    var out = [];
    for (var i = 0; i < maxLen; i++) {
        try {
            var b = p.add(i).readU8();
            if (b === 0) {
                return { bytes: out, complete: true, error: null };
            }
            out.push(b & 0xff);
        } catch (e) {
            return { bytes: out, complete: false, error: String(e) };
        }
    }
    return { bytes: out, complete: false, error: "max" };
}

function rangeInfo(p) {
    try {
        var r = Process.findRangeByAddress(p);
        if (r === null) {
            return "unmapped";
        }
        var file = "";
        if (r.file !== undefined && r.file !== null && r.file.path !== undefined) {
            file = " " + r.file.path;
        }
        return r.base + "-" + r.base.add(r.size) + " " + r.protection + file;
    } catch (e) {
        return "range_err:" + e;
    }
}

function findReadableRange(p) {
    try {
        var r = Process.findRangeByAddress(p);
        if (r === null || r.protection.indexOf("r") < 0) {
            return null;
        }
        return r;
    } catch (e) {
        return null;
    }
}

function dumpNestedPointer(label, p) {
    try {
        if (isNullPtr(p)) {
            return;
        }
        if (findReadableRange(p) === null) {
            return;
        }

        var first = safeReadBytes(p, DUMP_NESTED_BYTES);
        if (first !== null) {
            log("[entry-dump] " + label + " -> " + p +
                " range=" + rangeInfo(p) +
                " bytes len=0x" + first.length.toString(16) +
                " fnv1a=" + fnv1a32(first) +
                " hex=" + bytesToHex(first, DUMP_NESTED_BYTES) +
                " ascii=\"" + bytesToAscii(first, DUMP_NESTED_BYTES) + "\"");
        }

        var c = readCStringBytes(p, DUMP_CSTRING_MAX);
        if (c.bytes.length > 0) {
            log("[entry-dump] " + label + " cstr len=" + c.bytes.length +
                " complete=" + c.complete +
                " fnv1a=" + fnv1a32(c.bytes) +
                " preview=\"" + bytesToAscii(c.bytes, 512) + "\"" +
                (c.error === null ? "" : " stop=" + c.error));
        }
    } catch (e) {
        log("[entry-dump] " + label + " nested dump failed: " + e);
    }
}

function dumpOnePointer(label, raw) {
    try {
        var p = safePtr(raw);
        if (p === null) {
            log("[entry-dump] " + label + "=" + raw + " ptr_parse_failed");
            return;
        }

        log("[entry-dump] " + label + "=" + p + " range=" + rangeInfo(p));
        if (isNullPtr(p)) {
            return;
        }

        var q = [];
        var nested = [];
        for (var i = 0; i < 8; i++) {
            try {
                var qp = Memory.readPointer(p.add(i * 8));
                q.push("+0x" + (i * 8).toString(16) + "=" + qp);
                nested.push({ index: i, pointer: qp });
            } catch (e) {
                q.push("+0x" + (i * 8).toString(16) + "=<err:" + e + ">");
                break;
            }
        }
        log("[entry-dump] " + label + " qwords " + q.join(" "));

        var first = safeReadBytes(p, DUMP_BYTES);
        if (first !== null) {
            log("[entry-dump] " + label + " bytes len=0x" + first.length.toString(16) +
                " fnv1a=" + fnv1a32(first) +
                " hex=" + bytesToHex(first, DUMP_BYTES));
            log("[entry-dump] " + label + " ascii=\"" + bytesToAscii(first, DUMP_BYTES) + "\"");
        } else {
            log("[entry-dump] " + label + " bytes <read failed>");
        }

        var c = readCStringBytes(p, DUMP_CSTRING_MAX);
        if (c.bytes.length > 0) {
            log("[entry-dump] " + label + " cstr len=" + c.bytes.length +
                " complete=" + c.complete +
                " fnv1a=" + fnv1a32(c.bytes) +
                " preview=\"" + bytesToAscii(c.bytes, 512) + "\"" +
                (c.error === null ? "" : " stop=" + c.error));
        }

        for (var j = 0; j < nested.length; j++) {
            dumpNestedPointer(label + ".q" + nested[j].index, nested[j].pointer);
        }
    } catch (e) {
        log("[entry-dump] " + label + " dump failed: " + e);
    }
}

function dumpFullCString(label, raw) {
    try {
        var p = safePtr(raw);
        if (p === null) {
            log("[wrapper-full] " + label + "=" + raw + " ptr_parse_failed");
            return;
        }
        if (isNullPtr(p)) {
            log("[wrapper-full] " + label + "=0x0");
            return;
        }
        var c = readCStringBytes(p, DUMP_CSTRING_MAX);
        log("[wrapper-full] " + label + " cstr len=" + c.bytes.length +
            " complete=" + c.complete +
            " fnv1a=" + fnv1a32(c.bytes) +
            " value=\"" + bytesToAscii(c.bytes, c.bytes.length) + "\"" +
            (c.error === null ? "" : " stop=" + c.error));
    } catch (e) {
        log("[wrapper-full] " + label + " dump failed: " + e);
    }
}

function dumpEntryArgs(thiz, args) {
    log("[entry-dump] ---- 0x" + TARGET_OFFSET.toString(16) + " args begin ----");
    dumpOnePointer("x0", args[0]);
    dumpOnePointer("x1", args[1]);
    dumpOnePointer("x2", args[2]);
    dumpOnePointer("x3", args[3]);
    dumpOnePointer("x4", args[4]);
    dumpOnePointer("x5", args[5]);
    dumpOnePointer("x8", regPtr(thiz, "x8"));
    log("[entry-dump] lr=" + reg(thiz, "x30") + " sp=" + reg(thiz, "sp"));
    log("[entry-dump] ---- 0x" + TARGET_OFFSET.toString(16) + " args end ----");
}

function dumpWrapperArgs(thiz, args) {
    log("[wrapper-dump] ---- 0x" + WRAPPER_OFFSET.toString(16) + " args begin ----");
    dumpOnePointer("wrap.x0", args[0]);
    dumpFullCString("wrap.x0", args[0]);
    dumpOnePointer("wrap.x1", args[1]);
    dumpFullCString("wrap.x1", args[1]);
    dumpOnePointer("wrap.x2", args[2]);
    dumpOnePointer("wrap.x3", args[3]);
    dumpOnePointer("wrap.x4", args[4]);
    dumpOnePointer("wrap.x5", args[5]);
    dumpOnePointer("wrap.x8", regPtr(thiz, "x8"));
    log("[wrapper-dump] lr=" + reg(thiz, "x30") + " sp=" + reg(thiz, "sp"));
    log("[wrapper-dump] ---- 0x" + WRAPPER_OFFSET.toString(16) + " args end ----");
}

function loadGumTrace() {
    if (gumtraceLoaded) {
        return true;
    }

    try {
        var mod = Module.load(GUMTRACE_SO, 2, false);
        log("Module.load ok: " + JSON.stringify(mod));
    } catch (e) {
        log("Module.load failed: " + e);
        return false;
    }

    var initPtr = Module.findExportByName("libGumTrace.so", "init");
    var runPtr = Module.findExportByName("libGumTrace.so", "run");
    var unrunPtr = Module.findExportByName("libGumTrace.so", "unrun");

    log("exports init=" + initPtr + " run=" + runPtr + " unrun=" + unrunPtr);

    if (initPtr === null || runPtr === null || unrunPtr === null) {
        log("missing GumTrace exports");
        return false;
    }

    gumtraceInit = new NativeFunction(initPtr, "void", ["pointer", "pointer", "int", "pointer"]);
    gumtraceRun = new NativeFunction(runPtr, "void", []);
    gumtraceUnrun = new NativeFunction(unrunPtr, "void", []);

    gumtraceLoaded = true;
    return true;
}

function startTrace() {
    if (!loadGumTrace()) {
        return false;
    }

    var moduleNames = Memory.allocUtf8String(TARGET_MODULE);
    var outputPath = Memory.allocUtf8String(TRACE_FILE);
    var options = Memory.alloc(8);
    options.writeU64(BigInt(GUMTRACE_MODE));

    // thread_id = 0 means gum_stalker_follow_me():
    // follow the current app thread, exactly during this function call.
    gumtraceInit(moduleNames, outputPath, 0, options);
    gumtraceRun();
    return true;
}

function stopTrace() {
    try {
        gumtraceUnrun();
        log("trace stopped, file=" + TRACE_FILE);
    } catch (e) {
        log("unrun exception: " + e);
    }
}

function installEntryAtBase(base) {
    if (installed) {
        return;
    }
    installed = true;

    var target = base.add(TARGET_OFFSET);
    log("module base=" + base + " target=" + target + " offset=0x" + TARGET_OFFSET.toString(16));

    listener = Interceptor.attach(target, {
        onEnter: function (args) {
            if (tracedOnce || tracing) {
                this.doTrace = false;
                return;
            }

            tracedOnce = true;
            tracing = true;
            this.doTrace = true;

            log(
                "hit target; " +
                "x0(cookie_http)=" + args[0] + " " +
                "x1(json_list)=" + args[1] + " " +
                "x2(url)=" + args[2] + " " +
                "x3(x_ss_stub)=" + args[3] + " " +
                "x4/type=" + arg(args, 4) + " " +
                "x5(tree_map)=" + arg(args, 5) + " " +
                "x8(sig_tree)=" + reg(this, "x8") + " " +
                "lr=" + reg(this, "x30")
            );
            dumpEntryArgs(this, args);

            if (ENABLE_GUMTRACE && !startTrace()) {
                tracing = false;
                this.doTrace = false;
                log("startTrace failed");
                return;
            }
            if (ENABLE_GUMTRACE) {
                log("trace started");
            } else {
                log("entry dump only; GumTrace disabled");
            }
        },
        onLeave: function (retval) {
            if (!this.doTrace) {
                return;
            }

            log("leave target ret=" + retval);
            if (ENABLE_GUMTRACE) {
                stopTrace();
            }
            tracing = false;

            if (listener !== null) {
                try {
                    listener.detach();
                    log("detached target hook");
                } catch (e) {
                    log("detach exception: " + e);
                }
                listener = null;
            }
        }
    });

    log("installed GumTrace gate hook");
}

function installWrapperAtBase(base) {
    if (wrapperInstalled) {
        return;
    }
    wrapperInstalled = true;

    var target = base.add(WRAPPER_OFFSET);
    log("wrapper target=" + target + " offset=0x" + WRAPPER_OFFSET.toString(16));

    wrapperListener = Interceptor.attach(target, {
        onEnter: function (args) {
            if (wrapperTracedOnce) {
                return;
            }
            wrapperTracedOnce = true;
            log(
                "hit wrapper; " +
                "x0/s1=" + args[0] + " " +
                "x1/s2=" + args[1] + " " +
                "x2=" + arg(args, 2) + " " +
                "x3=" + arg(args, 3) + " " +
                "x4=" + arg(args, 4) + " " +
                "x5=" + arg(args, 5) + " " +
                "x8=" + reg(this, "x8") + " " +
                "lr=" + reg(this, "x30")
            );
            dumpWrapperArgs(this, args);
        },
        onLeave: function (retval) {
            if (!wrapperTracedOnce || wrapperListener === null) {
                return;
            }
            log("leave wrapper ret=" + retval);
            try {
                wrapperListener.detach();
                log("detached wrapper hook");
            } catch (e) {
                log("wrapper detach exception: " + e);
            }
            wrapperListener = null;
        }
    });

    log("installed wrapper hook");
}

function installAtBase(base) {
    installWrapperAtBase(base);
    installEntryAtBase(base);
}

function waitForTargetModule() {
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
                    this.path = "";
                    try {
                        this.path = args[0].readCString();
                    } catch (e) {
                        this.path = "";
                    }
                },
                onLeave: function () {
                    var path = this.path || "";
                    if (installed || path.indexOf(TARGET_MODULE) < 0) {
                        return;
                    }

                    var finish = function () {
                        log(symbol + " loaded: " + path);
                        var loadedBase = findTargetBase();
                        if (loadedBase === null) {
                            log("loaded but base still null");
                            return;
                        }
                        installAtBase(loadedBase);
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
    console.log("[metasec-gum-http] standalone loaded (Frida 17)");
    __dyidre_mode_gum_http();
})();
