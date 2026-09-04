// Douyin 350101 MetaSec probe — true-env.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l true_env_350101.js

// ===== mode: true-env / 真机环境基准 =====
// 历史来源：true_env_xmedusa_350101.js
// 什么时候用：采真实请求的 s1/s2、时间、随机、F8/X-Medusa 入参输出和 App 私有文件快照。
function __dyidre_mode_true_env() {
// True-device environment/value probe for Douyin 35.0/35.1 libmetasec_ml.so.
//
// Goal:
//   - capture one real request's process/time/random-ish environment
//   - capture F8/X-Medusa pack at 0x14A4E0
//   - capture emitted X-Medusa value at 0x14A53C
//
// Preferred run path:
//   probes/350101/run_metasec_probe_350101.sh true-env 90 <run_id>
//
// Output convention:
//   runs/350101/true_env_xmedusa/<timestamp>/
//
// This JS writes the raw in-app log:
//   /data/user/0/com.ss.android.ugc.aweme/files/true_env_xmedusa_350101.log
//
// The host wrapper pulls that log into the run folder as:
//   true_env_xmedusa_350101.log
//
// Files such as true_env_xmedusa_summary.json, f8_*.bin, xmedusa_*.b64 and
// metasec_app_files_snapshot.tar are post-processing artifacts derived from
// this raw log and the App private files snapshot. Keep the raw log; it is the
// source of truth when a later parser needs to be improved.

var TARGET_MODULE = "libmetasec_ml.so";
var OUT_FILE = "/data/user/0/com.ss.android.ugc.aweme/files/true_env_xmedusa_350101.log";

var OFF_HTTP_ENTRY = 0x149ca8;
var OFF_F8_ENTER = 0x14a4e0;
var OFF_XMEDUSA_EMIT = 0x14a53c;

var MAX_DUMP = 0x1000;
var MAX_CSTR = 0x8000;
var MAX_EVENTS = 2;
var MAX_RANDOM_EVENTS = 32;

var installed = false;
var httpHits = 0;
var f8Hits = 0;
var emitHits = 0;
var randomHits = 0;
var out = null;
var outDisabled = false;
var lastF8 = {};

function now() {
    return String(Date.now());
}

function openOut() {
    if (out !== null || outDisabled) return;
    try {
        out = new File(OUT_FILE, "ab");
    } catch (e) {
        console.log("[true-env-xmedusa] open log failed: " + e);
        outDisabled = true;
        out = null;
    }
}

function emit(s) {
    var line = "[true-env-xmedusa] " + now() + " " + s + "\n";
    console.log(line.substring(0, line.length - 1));
    try {
        openOut();
        if (out !== null) {
            out.write(line);
            out.flush();
        }
    } catch (e) {
        // keep probing even when file logging fails
    }
}

function p(v) {
    try {
        return ptr(v);
    } catch (e) {
        return ptr(0);
    }
}

function isNull(v) {
    try {
        var s = p(v).toString();
        return s === "0x0" || s === "0";
    } catch (e) {
        return true;
    }
}

function hex2(n) {
    var s = (n & 0xff).toString(16);
    return s.length < 2 ? "0" + s : s;
}

function hex32(n) {
    var s = (n >>> 0).toString(16);
    while (s.length < 8) s = "0" + s;
    return s;
}

function u64hex(v) {
    try {
        if (v === null || v === undefined) return "null";
        return "0x" + v.toString(16);
    } catch (e) {
        return String(v);
    }
}

function ptrHex(v) {
    try {
        return p(v).toString();
    } catch (e) {
        return String(v);
    }
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
    for (var i = 0; i < n; i++) out.push(hex2(bytes[i]));
    return out.join(" ");
}

function bytesToRawString(bytes, maxLen) {
    var n = Math.min(bytes.length, maxLen === undefined ? bytes.length : maxLen);
    var s = "";
    for (var i = 0; i < n; i++) s += String.fromCharCode(bytes[i] & 0xff);
    return s;
}

function bytesToAscii(bytes, maxLen) {
    var out = "";
    var n = Math.min(bytes.length, maxLen);
    for (var i = 0; i < n; i++) {
        var b = bytes[i] & 0xff;
        if (b === 0x0d) out += "\\r";
        else if (b === 0x0a) out += "\\n";
        else if (b === 0x09) out += "\\t";
        else if (b >= 0x20 && b <= 0x7e) out += String.fromCharCode(b);
        else out += ".";
    }
    return out;
}

function safeReadBytes(addr, len) {
    try {
        if (isNull(addr) || len <= 0) return null;
        var ab = p(addr).readByteArray(len);
        if (ab === null) return null;
        return new Uint8Array(ab);
    } catch (e) {
        return null;
    }
}

function safeRange(addr) {
    try {
        if (isNull(addr)) return null;
        var r = Process.findRangeByAddress(p(addr));
        if (r === null || r.protection.indexOf("r") < 0) return null;
        return r;
    } catch (e) {
        return null;
    }
}

function rangeInfo(addr) {
    try {
        var r = Process.findRangeByAddress(p(addr));
        if (r === null) return "unmapped";
        var file = "";
        if (r.file !== undefined && r.file !== null && r.file.path !== undefined) {
            file = " " + r.file.path;
        }
        return r.base + "-" + r.base.add(r.size) + " " + r.protection + file;
    } catch (e) {
        return "range_err:" + e;
    }
}

function readPtr(addr, off) {
    try {
        return p(addr).add(off).readPointer();
    } catch (e) {
        return ptr(0);
    }
}

function readU32(addr, off) {
    try {
        return Number(p(addr).add(off).readU32()) >>> 0;
    } catch (e) {
        return 0xffffffff;
    }
}

function readS32(addr, off) {
    var v = readU32(addr, off);
    return v > 0x7fffffff ? v - 0x100000000 : v;
}

function readU64(addr, off) {
    try {
        return p(addr).add(off).readU64();
    } catch (e) {
        return null;
    }
}

function readCStringBytes(addr, maxLen) {
    var pp = p(addr);
    var outBytes = [];
    for (var i = 0; i < maxLen; i++) {
        try {
            var b = pp.add(i).readU8();
            if (b === 0) return { bytes: outBytes, complete: true, stop: null };
            outBytes.push(b & 0xff);
        } catch (e) {
            return { bytes: outBytes, complete: false, stop: String(e) };
        }
    }
    return { bytes: outBytes, complete: false, stop: "max" };
}

function b64Decode(s) {
    var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var clean = String(s).replace(/[\r\n\t ]/g, "").replace(/-/g, "+").replace(/_/g, "/");
    var outBytes = [];
    var buf = 0;
    var bits = 0;
    for (var i = 0; i < clean.length; i++) {
        var ch = clean.charAt(i);
        if (ch === "=") break;
        var v = alphabet.indexOf(ch);
        if (v < 0) continue;
        buf = (buf << 6) | v;
        bits += 6;
        if (bits >= 8) {
            bits -= 8;
            outBytes.push((buf >> bits) & 0xff);
            buf &= (1 << bits) - 1;
        }
    }
    return outBytes;
}

function dumpBase64Summary(label, s) {
    try {
        var dec = b64Decode(s);
        var b18 = dec.length > 0x18 ? "0x" + hex2(dec[0x18]) : "na";
        emit(label + ".decoded base64_len=0x" + String(s.length.toString(16)) +
            " decoded_len=0x" + String(dec.length.toString(16)) +
            " fnv1a=" + fnv1a32(dec) +
            " b18=" + b18 +
            " first64=" + bytesToHex(dec, Math.min(dec.length, 0x40)));
    } catch (e) {
        emit(label + ".decoded failed: " + e);
    }
}

function dumpCString(label, addr, decodeBase64) {
    try {
        if (isNull(addr)) {
            emit(label + " cstr=<null>");
            return;
        }
        var c = readCStringBytes(addr, MAX_CSTR);
        var dumpLen = Math.min(c.bytes.length, MAX_DUMP);
        emit(label + " cstr ptr=" + ptrHex(addr) +
            " len=0x" + c.bytes.length.toString(16) +
            " complete=" + c.complete +
            " fnv1a=" + fnv1a32(c.bytes) +
            " ascii=\"" + bytesToAscii(c.bytes, dumpLen) + "\"" +
            (c.bytes.length > dumpLen ? " ...<truncated>" : "") +
            (c.stop === null ? "" : " stop=" + c.stop));
        if (decodeBase64 && c.bytes.length > 0) {
            var full = bytesToRawString(c.bytes);
            emit(label + ".b64_full=" + full);
            dumpBase64Summary(label, full);
        }
    } catch (e) {
        emit(label + " cstr failed: " + e);
    }
}

function dumpCharPtrPtr(label, ptrPtr, decodeBase64) {
    try {
        if (isNull(ptrPtr)) {
            emit(label + " ptr_ptr=<null>");
            return;
        }
        var val = readPtr(ptrPtr, 0);
        emit(label + " ptr_ptr=" + ptrHex(ptrPtr) + " -> " + ptrHex(val) + " range=" + rangeInfo(val));
        if (!isNull(val)) dumpCString(label, val, decodeBase64);
    } catch (e) {
        emit(label + " ptr_ptr failed: " + e);
    }
}

function dumpMaybeMemBlock(label, addr, decodeBase64) {
    try {
        if (isNull(addr)) {
            emit(label + "=<null>");
            return;
        }

        var memLen = readU32(addr, 8);
        var srcLen = readU32(addr, 12);
        var body = readPtr(addr, 16);
        var len = srcLen !== 0 ? srcLen : memLen;
        var sane = len > 0 && len < 0x20000 && !isNull(body) && safeRange(body) !== null;

        emit(label + " p=" + ptrHex(addr) +
            " range=" + rangeInfo(addr) +
            " mem_len=0x" + memLen.toString(16) +
            " src_len=0x" + srcLen.toString(16) +
            " body=" + ptrHex(body) +
            " bodyRange=" + rangeInfo(body) +
            " sane=" + sane);

        if (sane) {
            var readLen = decodeBase64 ? len : Math.min(len, MAX_DUMP);
            var bytes = safeReadBytes(body, readLen);
            if (bytes !== null) {
                var dumpLen = Math.min(bytes.length, MAX_DUMP);
                emit(label + " body len=0x" + len.toString(16) +
                    " dump=0x" + bytes.length.toString(16) +
                    " fnv1a=" + fnv1a32(bytes) +
                    " ascii=\"" + bytesToAscii(bytes, dumpLen) + "\"" +
                    (bytes.length > dumpLen ? " ...<truncated>" : ""));
                emit(label + " body_hex=" + bytesToHex(bytes, Math.min(bytes.length, 0x80)) +
                    (bytes.length > 0x80 ? " ...<hex truncated>" : ""));
                if (decodeBase64) {
                    var full = bytesToRawString(bytes);
                    emit(label + ".b64_full=" + full);
                    dumpBase64Summary(label, full);
                }
                return;
            }
        }

        if (safeRange(addr) !== null) {
            dumpCString(label + ".fallback", addr, decodeBase64);
        }
    } catch (e) {
        emit(label + " memblock failed: " + e);
    }
}

function regValue(thiz, name) {
    try {
        if (thiz !== undefined && thiz !== null &&
            thiz.context !== undefined && thiz.context !== null &&
            thiz.context[name] !== undefined) {
            return thiz.context[name];
        }
    } catch (e0) {
    }
    try {
        if (thiz !== undefined && thiz !== null && thiz[name] !== undefined) {
            return thiz[name];
        }
    } catch (e1) {
    }
    return null;
}

function regPtr(thiz, name) {
    try {
        var v = regValue(thiz, name);
        if (v === null || v === undefined) return ptr(0);
        return p(v);
    } catch (e) {
        return ptr(0);
    }
}

function reg(thiz, name) {
    var v = regValue(thiz, name);
    if (v === null || v === undefined) return "?";
    return ptrHex(v);
}

function dumpRegs(label, thiz) {
    emit(label + " regs x0=" + reg(thiz, "x0") +
        " x1=" + reg(thiz, "x1") +
        " x2=" + reg(thiz, "x2") +
        " x3=" + reg(thiz, "x3") +
        " x4=" + reg(thiz, "x4") +
        " x5=" + reg(thiz, "x5") +
        " x8=" + reg(thiz, "x8") +
        " lr=" + reg(thiz, "lr") +
        " sp=" + reg(thiz, "sp"));
}

function nativeIntFunc(name, ret, args) {
    try {
        var libc = Process.findModuleByName("libc.so");
        var a = libc === null ? null : libc.findExportByName(name);
        if (a === null) a = Module.findGlobalExportByName(name);
        if (a === null) return null;
        return new NativeFunction(a, ret, args || []);
    } catch (e) {
        return null;
    }
}

function dumpClocks(label) {
    try {
        var clockGettime = nativeIntFunc("clock_gettime", "int", ["int", "pointer"]);
        if (clockGettime === null) return;
        var ts = Memory.alloc(16);
        var ids = [
            ["REALTIME", 0],
            ["MONOTONIC", 1],
            ["BOOTTIME", 7]
        ];
        for (var i = 0; i < ids.length; i++) {
            ts.writeU64(0n);
            ts.add(8).writeU64(0n);
            var rc = clockGettime(ids[i][1], ts);
            emit(label + " clock." + ids[i][0] +
                " rc=" + rc +
                " sec=" + ts.readU64().toString() +
                " nsec=" + ts.add(8).readU64().toString());
        }
    } catch (e) {
        emit(label + " clock dump failed: " + e);
    }
}

function dumpStatusFile(label) {
    try {
        var st = File.readAllText("/proc/self/status");
        var lines = st.split("\n");
        var keep = [];
        for (var i = 0; i < lines.length; i++) {
            if (/^(Name|Umask|State|Tgid|Pid|PPid|TracerPid|Uid|Gid|Threads|Seccomp|NoNewPrivs):/.test(lines[i])) {
                keep.push(lines[i].replace(/\t+/g, " "));
            }
        }
        emit(label + " proc.status " + keep.join(" | "));
    } catch (e) {
        emit(label + " proc.status failed: " + e);
    }
}

function dumpProcessEnv(label) {
    try {
        var jsPid = "?";
        var jsTid = "?";
        try { jsPid = String(Process.id); } catch (e0) {}
        try { jsTid = String(Process.getCurrentThreadId()); } catch (e1) {}

        var getpid = nativeIntFunc("getpid", "int", []);
        var gettid = nativeIntFunc("gettid", "int", []);
        var syscall = nativeIntFunc("syscall", "long", ["long"]);
        var getppid = nativeIntFunc("getppid", "int", []);
        var getuid = nativeIntFunc("getuid", "int", []);
        var geteuid = nativeIntFunc("geteuid", "int", []);

        emit(label + " env Process.id=" + jsPid +
            " Process.tid=" + jsTid +
            " getpid=" + (getpid === null ? "na" : String(getpid())) +
            " gettid=" + (gettid === null ? "na" : String(gettid())) +
            " syscall_gettid=" + (syscall === null ? "na" : String(syscall(178))) +
            " getppid=" + (getppid === null ? "na" : String(getppid())) +
            " uid=" + (getuid === null ? "na" : String(getuid())) +
            " euid=" + (geteuid === null ? "na" : String(geteuid())));
        dumpClocks(label);
        dumpStatusFile(label);
    } catch (e) {
        emit(label + " env dump failed: " + e);
    }
}

function installGetrandomProbe() {
    try {
        var libc = Process.findModuleByName("libc.so");
        var a = libc === null ? null : libc.findExportByName("getrandom");
        if (a === null) return;
        Interceptor.attach(a, {
            onEnter: function (args) {
                this.buf = p(args[0]);
                this.len = Number(args[1]);
            },
            onLeave: function (retval) {
                if (randomHits >= MAX_RANDOM_EVENTS) return;
                var n = Number(retval);
                if (n <= 0 || this.len <= 0 || isNull(this.buf)) return;
                var bytes = safeReadBytes(this.buf, Math.min(n, 0x40));
                if (bytes !== null) {
                    randomHits++;
                    emit("getrandom ret=" + n +
                        " requested=0x" + this.len.toString(16) +
                        " first=" + bytesToHex(bytes, bytes.length) +
                        " fnv1a=" + fnv1a32(bytes));
                }
            }
        });
        emit("getrandom probe installed");
    } catch (e) {
        emit("getrandom probe failed: " + e);
    }
}

function dumpF8Pack(pack) {
    try {
        if (isNull(pack)) {
            emit("F8.pack=<null>");
            return;
        }
        lastF8.pack = p(pack);
        lastF8.seed = readU64(pack, 0);
        lastF8.xss = readPtr(pack, 0x10);
        lastF8.url = readPtr(pack, 0x18);
        lastF8.aux = readPtr(pack, 0x20);
        lastF8.token = readPtr(pack, 0x28);
        lastF8.type = readS32(pack, 0x40);
        lastF8.outKeyPtrPtr = readPtr(pack, 0x48);
        lastF8.outValuePtrPtr = readPtr(pack, 0x50);
        lastF8.mode = readS32(pack, 0x58);
        lastF8.finalFlag = readS32(pack, 0x5c);

        var q = [];
        for (var off = 0; off <= 0x60; off += 8) {
            q.push("+0x" + off.toString(16) + "=" + ptrHex(readPtr(pack, off)));
        }

        var raw = safeReadBytes(pack, 0x70);
        emit("F8.pack ptr=" + ptrHex(pack) +
            " range=" + rangeInfo(pack) +
            " seed=" + u64hex(lastF8.seed) +
            " type=" + lastF8.type +
            " mode=" + lastF8.mode +
            " final=" + lastF8.finalFlag +
            " out_key_ptr_ptr=" + ptrHex(lastF8.outKeyPtrPtr) +
            " out_value_ptr_ptr=" + ptrHex(lastF8.outValuePtrPtr) +
            " qwords=[" + q.join(", ") + "]");
        if (raw !== null) {
            emit("F8.pack.raw70 fnv1a=" + fnv1a32(raw) + " hex=" + bytesToHex(raw, raw.length));
        }

        dumpMaybeMemBlock("F8.in.x_ss_stub", lastF8.xss, false);
        dumpMaybeMemBlock("F8.in.url_or_path", lastF8.url, false);
        dumpMaybeMemBlock("F8.in.aux_ref_mem", lastF8.aux, false);
        dumpMaybeMemBlock("F8.in.token_block", lastF8.token, false);
    } catch (e) {
        emit("F8.pack dump failed: " + e);
    }
}

function attach(addr, callbacks) {
    return Interceptor.attach(addr, callbacks);
}

function installModuleHooks(m) {
    if (installed) return;
    installed = true;
    var base = m.base;
    emit("install module=" + TARGET_MODULE +
        " base=" + base +
        " size=" + (m.size === undefined ? "?" : "0x" + m.size.toString(16)) +
        " path=" + (m.path === undefined ? "?" : m.path));
    dumpProcessEnv("install");
    installGetrandomProbe();

    attach(base.add(OFF_HTTP_ENTRY), {
        onEnter: function (args) {
            httpHits++;
            if (httpHits > MAX_EVENTS) return;
            dumpRegs("HTTP.entry#" + httpHits + " off=0x" + OFF_HTTP_ENTRY.toString(16), this);
            dumpProcessEnv("HTTP.entry#" + httpHits);
            dumpMaybeMemBlock("HTTP.arg.x_ss_stub", regPtr(this, "x3"), false);
            dumpMaybeMemBlock("HTTP.arg.url", regPtr(this, "x2"), false);
        }
    });
    emit("hook HTTP.entry @" + base.add(OFF_HTTP_ENTRY));

    attach(base.add(OFF_F8_ENTER), {
        onEnter: function (args) {
            f8Hits++;
            if (f8Hits > MAX_EVENTS) return;
            dumpRegs("F8.enter#" + f8Hits + " off=0x" + OFF_F8_ENTER.toString(16), this);
            dumpProcessEnv("F8.enter#" + f8Hits);
            dumpF8Pack(regPtr(this, "x0"));
        }
    });
    emit("hook F8.enter @" + base.add(OFF_F8_ENTER));

    attach(base.add(OFF_XMEDUSA_EMIT), {
        onEnter: function (args) {
            emitHits++;
            if (emitHits > MAX_EVENTS) return;
            dumpRegs("XMedusa.emit#" + emitHits + " off=0x" + OFF_XMEDUSA_EMIT.toString(16), this);
            dumpProcessEnv("XMedusa.emit#" + emitHits);
            emit("XMedusa.lastF8 pack=" + ptrHex(lastF8.pack || ptr(0)) +
                " seed=" + u64hex(lastF8.seed) +
                " type=" + String(lastF8.type) +
                " mode=" + String(lastF8.mode) +
                " final=" + String(lastF8.finalFlag) +
                " out_key_ptr_ptr=" + ptrHex(lastF8.outKeyPtrPtr || ptr(0)) +
                " out_value_ptr_ptr=" + ptrHex(lastF8.outValuePtrPtr || ptr(0)));
            dumpCharPtrPtr("XMedusa.lastF8.out_key", lastF8.outKeyPtrPtr, false);
            dumpCharPtrPtr("XMedusa.lastF8.out_value", lastF8.outValuePtrPtr, true);
            dumpMaybeMemBlock("XMedusa.emit.key", regPtr(this, "x1"), false);
            dumpMaybeMemBlock("XMedusa.emit.value", regPtr(this, "x2"), true);
            emit("DONE first X-Medusa emit captured");
        }
    });
    emit("hook XMedusa.emit @" + base.add(OFF_XMEDUSA_EMIT));
}

function tryInstall() {
    if (installed) return true;
    try {
        var m = null;
        try { m = Process.findModuleByName(TARGET_MODULE); } catch (e0) { m = null; }
        if (m === null) {
            var loaded = Process.findModuleByName(TARGET_MODULE);
            if (loaded !== null) m = loaded;
        }
        if (m === null) return false;
        installModuleHooks(m);
        return true;
    } catch (e) {
        emit("tryInstall failed: " + e);
        return false;
    }
}

function hookDlopen() {
    var names = ["android_dlopen_ext", "dlopen"];
    for (var i = 0; i < names.length; i++) {
        try {
            var a = Module.findGlobalExportByName(names[i]);
            if (a === null) continue;
            Interceptor.attach(a, {
                onEnter: function (args) {
                    this.path = "";
                    try { this.path = p(args[0]).readCString(); } catch (e) {}
                },
                onLeave: function (retval) {
                    if (this.path.indexOf(TARGET_MODULE) >= 0) {
                        emit("dlopen loaded " + this.path);
                        tryInstall();
                    }
                }
            });
            emit("dlopen probe installed: " + names[i] + " @" + a);
            return;
        } catch (e0) {
        }
    }
}

emit("script start");
dumpProcessEnv("script.start");
hookDlopen();
if (!tryInstall()) {
    emit("module not loaded yet; waiting for android_dlopen_ext/dlopen");
}

}

(function () {
    console.log("[metasec-true-env] standalone loaded (Frida 17)");
    __dyidre_mode_true_env();
})();
