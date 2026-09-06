// Douyin 350101 MetaSec probe — MS.b trace.
// Pure Frida 17 standalone script (stock frida / rusda-server, no rustFrida APIs).
//
// Load:
//   frida -q -U -f com.ss.android.ugc.aweme -l probes/350101/frida/gum_msb_trace_350101.js
//
// 用途：记录 libmetasec_ml.so 通过 JNI 调用
//   com/bytedance/mobsec/metasec/ml/MS->b(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;
// 的完整序列：op / arg1 / arg2 / str / obj / 返回值 / native 调用点。
// 输出字段顺序对齐 unidbg Sign6MetaSecBase 的 traceMsB 行：
//   [350101][MS.b] op=0x.. arg1=0x.. arg2=0x.. str=.. obj=.. => ..
// 方便和 unidbg 侧 `-Dmetasec.traceMsB=true` 的日志直接 diff，找补环境缺口。
//
// 实现说明：
//   - 不 hook Java 层（避免 Java.use 持引用被检测）；直接 hook libart 的
//     CallStaticObjectMethodV/A，和 jnitrace_350101.js 同一套固定偏移 + env 表扩展。
//   - 通过 FindClass/GetStaticMethodID 钩子维护 classMap/methodMap，用 jmethodID
//     精确识别 MS.b，不靠字符串匹配每次调用。
//   - va_list 只读不改写（AArch64 va_list 算法本地重放，不回写 __gr_offs）。
//   - 对象描述通过 env 的 JNI 表做（GetStringUTFChars / GetArrayLength /
//     GetByteArrayElements / IsInstanceOf），全程 try/catch，绝不弄崩目标。

var TARGET_MODULE = "libmetasec_ml.so";
var MS_BRIDGE_SIG = "(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;";
var MS_BRIDGE_OWNER = "com/bytedance/mobsec/metasec/ml/MS";

// Pixel 6 / Android 15 / libart.so offsets observed on this device (same set as
// jnitrace_350101.js). env-table expansion below is the version-independent fallback.
var FIXED_JNI_OFFSETS = {
    FindClass: 0x73a520,
    GetStaticMethodID: 0x6189bc,
    CallStaticObjectMethodV: 0x43b038,
    CallStaticObjectMethodA: 0x51efa0
};

var JNI_INDEX = {
    FindClass: 6,
    IsInstanceOf: 32,
    GetObjectClass: 31,
    NewGlobalRef: 21,
    GetStaticMethodID: 113,
    CallStaticObjectMethodV: 115,
    CallStaticObjectMethodA: 116,
    GetStringUTFChars: 169,
    ReleaseStringUTFChars: 170,
    GetArrayLength: 171,
    GetByteArrayElements: 184,
    ReleaseByteArrayElements: 192
};

// rusda / stock frida 兼容：WXSHADOW 存在才用，不存在就普通 attach。
var HAS_WXSHADOW = (typeof Hook !== "undefined" && Hook.WXSHADOW !== undefined);

// 可调项。
var LOG_FULL_BACKTRACE = false;   // true 时每个 MS.b 调用 dump libmetasec_ml 内完整回溯
var STRING_MAX = 260;
var BYTE_HEX_MAX = 0x40;
var SUMMARY_MS = 30000;

var classMap = {};
var methodMap = {};
var msbMethodIds = {};
var hookedAddrs = {};
var slotSpecs = [];
var libartBase = null;
var traceInstalled = false;

var seq = 0;
var opStats = {};
var lastSummaryMs = 0;

var cachedStringClass = null;
var cachedByteArrayClass = null;
var classCacheTried = false;

function now() {
    return String(Date.now());
}

function emit(s) {
    console.log("[metasec-msb] " + now() + " " + s);
}

function safePtr(v) {
    try {
        return ptr(v);
    } catch (e) {
        return ptr(0);
    }
}

function isNull(p) {
    return p === null || p === undefined || safePtr(p).toString() === "0x0";
}

function key(p) {
    return safePtr(p).toString();
}

function safeCString(p) {
    try {
        if (isNull(p)) return null;
        return safePtr(p).readCString();
    } catch (e) {
        return null;
    }
}

function hex32(v) {
    return "0x" + ("00000000" + (v >>> 0).toString(16)).slice(-8);
}

function hexU64(v) {
    try {
        return "0x" + v.toString(16);
    } catch (e) {
        return String(v);
    }
}

// Frida 版本兼容：17 里 Module.findBaseAddress/findByAddress 可能不存在，
// 统一走这几个 helper，优先新 API，兜底手动枚举。
function findModuleByName(name) {
    try {
        if (typeof Process !== "undefined" && typeof Process.getModuleByName === "function") {
            var m = Process.getModuleByName(name);
            if (m !== null) return m;
        }
    } catch (e) {}
    try {
        if (typeof Module !== "undefined" && typeof Module.findBaseAddress === "function") {
            var b = Module.findBaseAddress(name);
            if (b !== null && !isNull(b)) return { name: name, base: b };
        }
    } catch (e) {}
    try {
        var ms = Process.enumerateModules();
        for (var i = 0; i < ms.length; i++) {
            if (ms[i].name === name) return ms[i];
        }
    } catch (e) {}
    return null;
}

function findModuleByAddress(addr) {
    try {
        if (typeof Process !== "undefined" && typeof Process.getModuleByAddress === "function") {
            return Process.getModuleByAddress(addr);
        }
    } catch (e) {}
    try {
        if (typeof Module !== "undefined" && typeof Module.findByAddress === "function") {
            return Module.findByAddress(addr);
        }
    } catch (e) {}
    try {
        var p = safePtr(addr);
        var ms = Process.enumerateModules();
        for (var i = 0; i < ms.length; i++) {
            var lo = ms[i].base;
            var hi = lo.add(ms[i].size);
            if (p.compare(lo) >= 0 && p.compare(hi) < 0) return ms[i];
        }
    } catch (e) {}
    return null;
}

function retAddr(ctx) {
    if (ctx.returnAddress !== undefined) return safePtr(ctx.returnAddress);
    if (ctx.lr !== undefined) return safePtr(ctx.lr);
    if (ctx.x30 !== undefined) return safePtr(ctx.x30);
    return ptr(0);
}

// 返回 {off, full}；调用点不在目标 so 内时 off 为 "<external>"。
function callerInfo(ctx) {
    var ra = retAddr(ctx);
    if (isNull(ra)) return { off: "<no-ra>", full: "" };
    var m = null;
    try {
        m = findModuleByAddress(ra);
    } catch (e) {
        m = null;
    }
    if (m === null) return { off: "<external " + key(ra) + ">", full: "" };
    var off = m.name + "+0x" + ra.sub(m.base).toString(16);
    if (m.name.indexOf(TARGET_MODULE) < 0) return { off: "<external " + off + ">", full: "" };
    var full = "";
    if (LOG_FULL_BACKTRACE) {
        try {
            var frames = Thread.backtrace(ctx, Backtracer.ACCURATE);
            var parts = [];
            for (var i = 0; i < frames.length && i < 16; i++) {
                var fm = findModuleByAddress(frames[i]);
                if (fm === null) {
                    parts.push(key(frames[i]));
                } else {
                    parts.push(fm.name + "+0x" + frames[i].sub(fm.base).toString(16));
                }
            }
            full = parts.join(" <- ");
        } catch (e) {
            full = "<backtrace:" + e + ">";
        }
    }
    return { off: off, full: full };
}

// ---------- class / method 识别 ----------

function isBridgeSig(sig) {
    return sig === MS_BRIDGE_SIG;
}

function classDisplay(clazz) {
    var k = key(clazz);
    return classMap[k] || ("<class " + k + ">");
}

function rememberMethod(clazz, mid, name, sig) {
    if (isNull(mid)) return;
    var rec = {
        cls: classDisplay(clazz),
        name: name || "<name?>",
        sig: sig || "<sig?>"
    };
    methodMap[key(mid)] = rec;
    if (rec.name === "b" && isBridgeSig(rec.sig) && rec.cls.indexOf(MS_BRIDGE_OWNER) >= 0) {
        var mk = key(mid);
        if (!msbMethodIds[mk]) {
            msbMethodIds[mk] = true;
            emit("MS.b jmethodID registered: " + rec.cls + "->" + rec.name + rec.sig + " = " + mk);
        }
    }
}

function isMsbMethod(mid) {
    if (mid === null || mid === undefined) return false;
    if (msbMethodIds[key(mid)]) return true;
    // GetStaticMethodID 钩子还没看到时的兜底：name/sig 都对就认。
    var rec = methodMap[key(mid)];
    return rec !== undefined && rec.name === "b" && isBridgeSig(rec.sig) &&
        rec.cls.indexOf(MS_BRIDGE_OWNER) >= 0;
}

// ---------- JNI 表辅助（用调用现场自己的 env） ----------

function jniFn(env, index, retType, argTypes) {
    var table = safePtr(env).readPointer();
    var fn = table.add(index * 8).readPointer();
    return new NativeFunction(fn, retType, argTypes);
}

function ensureClassCache(env) {
    if (classCacheTried) return;
    classCacheTried = true;
    try {
        var findClass = jniFn(env, JNI_INDEX.FindClass, "pointer", ["pointer", "pointer"]);
        // FindClass 返回 local ref，离开当前 JNI 调用就失效；必须转 global，
        // 否则下一次调用用过期的 clazz 做 IsInstanceOf 会触发 ART abort。
        var newGlobal = jniFn(env, JNI_INDEX.NewGlobalRef, "pointer", ["pointer", "pointer"]);
        var p1 = findClass(env, Memory.allocUtf8String("java/lang/String"));
        if (!isNull(p1)) cachedStringClass = newGlobal(env, p1);
        var p2 = findClass(env, Memory.allocUtf8String("[B"));
        if (!isNull(p2)) cachedByteArrayClass = newGlobal(env, p2);
        emit("class cache string=" + key(cachedStringClass) + " bytes=" + key(cachedByteArrayClass));
    } catch (e) {
        emit("class cache failed: " + e);
    }
}

function isInstanceOf(env, obj, clazz) {
    if (isNull(obj) || isNull(clazz)) return false;
    try {
        var fn = jniFn(env, JNI_INDEX.IsInstanceOf, "int", ["pointer", "pointer", "pointer"]);
        return fn(env, obj, clazz) !== 0;
    } catch (e) {
        return false;
    }
}

function describeString(env, jstr) {
    var chars = null;
    try {
        var get = jniFn(env, JNI_INDEX.GetStringUTFChars, "pointer", ["pointer", "pointer", "pointer"]);
        chars = get(env, jstr, NULL);
        if (isNull(chars)) return "java/lang/String<\"<null-chars>\">";
        var text = safeCString(chars) || "";
        if (text.length > STRING_MAX) text = text.substring(0, STRING_MAX) + "...<len=" + text.length + ">";
        return "java/lang/String<\"" + text.replace(/\n/g, "\\n").replace(/\r/g, "\\r") + "\">";
    } catch (e) {
        return "<string-desc:" + e + ">";
    } finally {
        if (chars !== null && !isNull(chars)) {
            try {
                jniFn(env, JNI_INDEX.ReleaseStringUTFChars, "void", ["pointer", "pointer", "pointer"])(env, jstr, chars);
            } catch (e2) {}
        }
    }
}

function describeByteArray(env, arr) {
    var elems = null;
    try {
        var len = jniFn(env, JNI_INDEX.GetArrayLength, "int32", ["pointer", "pointer"])(env, arr);
        var get = jniFn(env, JNI_INDEX.GetByteArrayElements, "pointer", ["pointer", "pointer", "pointer"]);
        elems = get(env, arr, NULL);
        var hex = "<no-body>";
        if (!isNull(elems)) {
            var n = Math.min(len, BYTE_HEX_MAX);
            var bytes = [];
            for (var i = 0; i < n; i++) bytes.push(("0" + elems.add(i).readU8().toString(16)).slice(-2));
            hex = bytes.join(" ") + (len > n ? " ..." : "");
        }
        return "[B<byte[" + len + "] hex=" + hex + ">";
    } catch (e) {
        return "<bytearray-desc:" + e + ">";
    } finally {
        if (elems !== null && !isNull(elems)) {
            try {
                jniFn(env, JNI_INDEX.ReleaseByteArrayElements, "void",
                    ["pointer", "pointer", "pointer", "int32"])(env, arr, elems, 0);
            } catch (e2) {}
        }
    }
}

// 对齐 unidbg describeDvmObjectForLog 的形态。
function describeObject(env, obj) {
    if (isNull(obj)) return "null";
    try {
        ensureClassCache(env);
        if (isInstanceOf(env, obj, cachedStringClass)) return describeString(env, obj);
        if (isInstanceOf(env, obj, cachedByteArrayClass)) return describeByteArray(env, obj);
    } catch (e) {}
    return "<obj " + key(obj) + ">";
}

// ---------- 参数解析 ----------

// AArch64 va_list 只读重放：__stack@+0 __gr_top@+8 __vr_top@+16 __gr_offs@+24 __vr_offs@+28。
// 不回写 __gr_offs（真正的 callee 后面还要消费同一份 va_list）。
// MS.b(IIJString,Object) 的 5 个参数全是通用寄存器槽。
function readVaListGrSlots(va, count) {
    var slots = [];
    try {
        var stack = safePtr(va.readPointer());
        var grTop = safePtr(va.add(8).readPointer());
        var grOffs = va.add(24).readS32();
        for (var i = 0; i < count; i++) {
            var p;
            if (grOffs < 0) {
                p = grTop.add(grOffs);
                grOffs += 8;
            } else {
                p = stack;
                stack = stack.add(8);
            }
            slots.push(p);
        }
    } catch (e) {
        emit("va_list parse failed: " + e);
    }
    return slots;
}

// 统一返回 {op, arg1, arg2, str, obj}；失败字段为 null。
function parseMsbArgs(kind, args) {
    if (kind === "A") {
        var jv = safePtr(args[3]); // jvalue*，每个 8 字节 union
        if (isNull(jv)) return null;
        try {
            return {
                op: jv.readU32(),
                arg1: jv.add(8).readU32(),
                arg2: jv.add(16).readU64(),
                str: jv.add(24).readPointer(),
                obj: jv.add(32).readPointer()
            };
        } catch (e) {
            emit("jvalue parse failed: " + e);
            return null;
        }
    }
    var va = safePtr(args[3]); // va_list
    if (isNull(va)) return null;
    var slots = readVaListGrSlots(va, 5);
    if (slots.length < 5) return null;
    try {
        return {
            op: slots[0].readU32(),
            arg1: slots[1].readU32(),
            arg2: slots[2].readU64(),
            str: slots[3].readPointer(),
            obj: slots[4].readPointer()
        };
    } catch (e) {
        emit("va slot read failed: " + e);
        return null;
    }
}

// ---------- 主逻辑 ----------

function emitSummary(force) {
    var t = Date.now();
    if (!force && t - lastSummaryMs < SUMMARY_MS) return;
    lastSummaryMs = t;
    var keys = Object.keys(opStats);
    keys.sort(function (a, b) { return opStats[b] - opStats[a]; });
    var parts = [];
    for (var i = 0; i < keys.length && i < 12; i++) parts.push(keys[i] + "=" + opStats[keys[i]]);
    emit("MSB_SUMMARY total=" + seq + " ops{" + parts.join(", ") + "}");
}

function makeStaticCallHandler(kind) {
    return {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            if (!isMsbMethod(args[2])) return;
            var parsed = parseMsbArgs(kind, args);
            if (parsed === null) return;
            this.msb = true;
            this.env = args[0];
            this.parsed = parsed;
            this.caller = callerInfo(this.context);
            this.seq = ++seq;
        },
        onLeave: function (retval) {
            if (!this.msb) return;
            var p = this.parsed;
            var opHex = hex32(p.op);
            opStats[opHex] = (opStats[opHex] || 0) + 1;
            var line = "[350101][MS.b] op=" + opHex +
                " arg1=" + hex32(p.arg1) +
                " arg2=" + hexU64(p.arg2) +
                " str=" + describeObject(this.env, p.str) +
                " obj=" + describeObject(this.env, p.obj) +
                " => " + describeObject(this.env, retval) +
                " ; seq=" + this.seq + " via=" + kind + " caller=" + this.caller.off;
            emit(line);
            if (this.caller.full !== "") emit("  backtrace " + this.caller.full);
            emitSummary(false);
        }
    };
}

// ---------- hook 安装（与 jnitrace_350101.js 同机制） ----------

function getLibartBase() {
    if (libartBase !== null) return libartBase;
    var m = findModuleByName("libart.so");
    if (m === null) return null;
    libartBase = safePtr(m.base);
    if (isNull(libartBase)) {
        libartBase = null;
        return null;
    }
    emit("libart.so base=" + libartBase);
    return libartBase;
}

function fixedJniAddress(name) {
    if (!Object.prototype.hasOwnProperty.call(FIXED_JNI_OFFSETS, name)) return null;
    var base = getLibartBase();
    if (base === null) return null;
    return safePtr(base).add(FIXED_JNI_OFFSETS[name]);
}

function attachSlot(name, index, callbacks, addr, source) {
    if (addr === null || addr === undefined || isNull(addr)) return false;
    var k = key(addr);
    if (hookedAddrs[k]) return true;
    try {
        if (HAS_WXSHADOW) {
            Interceptor.attach(addr, callbacks, Hook.WXSHADOW);
        } else {
            Interceptor.attach(addr, callbacks);
        }
        hookedAddrs[k] = true;
        emit("hook " + name + "[" + index + "] @ " + addr + " via " + source +
            (HAS_WXSHADOW ? " stealth=WXSHADOW" : " stealth=off"));
        return true;
    } catch (e) {
        emit("hook " + name + "[" + index + "] @ " + addr + " failed via " + source + ": " + e);
        return false;
    }
}

function expandSlotsFromEnv(env) {
    if (isNull(env)) return;
    if (expandSlotsFromEnv.done) return;
    expandSlotsFromEnv.done = true;
    try {
        var table = safePtr(env).readPointer();
        emit("expand JNI table from env=" + key(env) + " table=" + key(table));
        for (var i = 0; i < slotSpecs.length; i++) {
            var s = slotSpecs[i];
            var addr = table.add(s.index * 8).readPointer();
            attachSlot(s.name, s.index, s.callbacks, addr, "env-table");
        }
    } catch (e) {
        emit("expand JNI table failed: " + e);
    }
}

function hookSlot(name, index, callbacks) {
    slotSpecs.push({ name: name, index: index, callbacks: callbacks });
    attachSlot(name, index, callbacks, fixedJniAddress(name), "fixed-libart-offset");
}

function installTrace() {
    if (traceInstalled) return;
    traceInstalled = true;
    emit("install target=" + TARGET_MODULE);

    hookSlot("FindClass", JNI_INDEX.FindClass, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            this.name = safeCString(args[1]);
        },
        onLeave: function (retval) {
            if (!isNull(retval) && this.name !== null) classMap[key(retval)] = this.name;
        }
    });

    hookSlot("GetStaticMethodID", JNI_INDEX.GetStaticMethodID, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            this.clazz = args[1];
            this.name = safeCString(args[2]);
            this.sig = safeCString(args[3]);
        },
        onLeave: function (retval) {
            rememberMethod(this.clazz, retval, this.name, this.sig);
        }
    });

    hookSlot("CallStaticObjectMethodV", JNI_INDEX.CallStaticObjectMethodV, makeStaticCallHandler("V"));
    hookSlot("CallStaticObjectMethodA", JNI_INDEX.CallStaticObjectMethodA, makeStaticCallHandler("A"));

    emit("installed");
}

// spawn 早期 libart 还没加载：等它出现再装 hook。
// 双保险：module observer + 定时轮询（不同 Android/Frida 组合下 observer
// 对 zygote 预加载模块可能不回放，轮询兜住）。
function tryInstall() {
    if (traceInstalled) return;
    if (getLibartBase() === null) return;
    installTrace();
}

try {
    Process.attachModuleObserver({
        onAdded: function (m) {
            if (m.name === "libart.so") tryInstall();
        }
    });
} catch (e) {
    emit("module observer failed: " + e);
}

var installTimer = setInterval(function () {
    tryInstall();
    if (traceInstalled) clearInterval(installTimer);
}, 100);

// 心跳：确认脚本还活着、libart 出现没有、hook 装上没有。
[2000, 5000, 10000, 30000].forEach(function (ms) {
    setTimeout(function () {
        emit("heartbeat t=" + ms / 1000 + "s libart=" +
            (getLibartBase() === null ? "missing" : "ok") +
            " installed=" + traceInstalled + " seq=" + seq);
    }, ms);
});

tryInstall();

console.log("[metasec-msb] standalone loaded (Frida 17, stock/rusda)");
