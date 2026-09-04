// Douyin 350101 MetaSec probe — counter-multi.
// Pure Frida 17 standalone script.
// Load: frida -U -f com.ss.android.ugc.aweme -l counter_multi_350101.js

// ===== mode: counter-multi / 多请求计数 =====
// 历史来源：metasec_multi_request_counter_350.js
// 什么时候用：单请求已经对齐后，再采 8 条左右请求，确认滑动/多 URL 场景没有偶发分叉。
function __dyidre_mode_counter_multi() {
// Multi-request MetaSec counter for Douyin 350.101.
//
// Goal:
//   Capture several real-device HTTP signing windows and count which
//   exeVMInner/native/managed pieces each request actually reaches.
//
// Usage with rustFrida RPC:
//   1. load this script with --spawn/--attach and --rpc-port.
//   2. rpc.exports.metamultistart(8, "tag")
//   3. interact with app / let startup requests fire
//   4. rpc.exports.metamultisummary()

(function () {
    var TARGET_MODULE = "libmetasec_ml.so";
    var MAX_SAMPLES_PER_REQUEST = 80;

    var OFFSETS = {
        http_callback_14dbf4: 0x14dbf4,
        http_entry_149ca8: 0x149ca8,

        branch_helper_ret_149f60: 0x149f60,
        branch_f5f7_gate_14a250: 0x14a250,
        branch_precompute_then_skip_f5f7_14a254: 0x14a254,
        branch_run_f5f7_14a348: 0x14a348,
        branch_after_f5f7_join_14a438: 0x14a438,

        nativeStage1_14a1ac: 0x14a1ac,
        nativeStage2_14a1fc: 0x14a1fc,
        managedF5_14a38c: 0x14a38c,
        managedF7_14a3ec: 0x14a3ec,
        managedF8_14a4e0: 0x14a4e0,
        managedF13_14a588: 0x14a588,

        managed_native_blr_15454c: 0x15454c,
        native_binding_smallA_15281c: 0x15281c,
        native_binding_runtimeGate_152840: 0x152840,
        native_binding_runtimeGate_ret_15284c: 0x15284c,
        native_binding_smallB_152864: 0x152864,

        smallVmWrapperA_d9574: 0xd9574,
        smallVmWrapperB_d95f4: 0xd95f4,
        runtimeGate_d9044_entry: 0xd9044,
        runtimeGate_d952c_returnByte: 0xd952c,

        envVmWrapper_201800_12ac9c: 0x12ac9c,
        vmwrap_201800_call_12acf4: 0x12acf4,
        vmwrap_201800_ret_12acf8: 0x12acf8,

        nativeVmpSelectMaterial_12564c: 0x12564c,
        nativeVmpBuildMaterial_124dd4: 0x124dd4,
        exeVMInner_4cc10: 0x4cc10
    };

    function log(s) {
        console.log("[metamulti] " + s);
    }

    function now() {
        return Date.now();
    }

    function hex(x) {
        try {
            if (x === null || x === undefined) return "null";
            if (typeof x === "number") return "0x" + (x >>> 0).toString(16);
            return ptr(x).toString();
        } catch (e) {
            return String(x);
        }
    }

    function u64hex(x) {
        try { return ptr(x).toString(); } catch (e) { return String(x); }
    }

    function rel(base, p) {
        try {
            var q = ptr(p);
            var qn = parseInt(q.toString(), 16);
            var bn = parseInt(ptr(base).toString(), 16);
            if (isFinite(qn) && isFinite(bn) && qn >= bn && qn < bn + 0x8000000) {
                return "0x" + (qn - bn).toString(16);
            }
            return q.toString();
        } catch (e) {
            return "?";
        }
    }

    function inc(map, key) {
        key = String(key);
        map[key] = (map[key] || 0) + 1;
    }

    function readCStringSafe(p, maxLen) {
        try {
            var q = ptr(p);
            if (q.isNull && q.isNull()) return null;
            var s = Memory.readCString(q, maxLen || 32768);
            if (s !== null && s.length > (maxLen || 32768)) return s.substring(0, maxLen || 32768);
            return s;
        } catch (e) {
            return "<readCString-error:" + e + ">";
        }
    }

    function readU8Safe(p) {
        try { return Memory.readU8(ptr(p)); } catch (e) { return null; }
    }

    function readPointerSafe(p) {
        try { return Memory.readPointer(ptr(p)); } catch (e) { return ptr(0); }
    }

    function u32(x) {
        try {
            return parseInt(ptr(x).and(ptr("0xffffffff")).toString(), 16) >>> 0;
        } catch (e) {
            try { return parseInt(String(x), 16) >>> 0; } catch (_) { return 0; }
        }
    }

    function fnv1a32(s) {
        if (s === null || s === undefined) return "0x00000000";
        var h = 0x811c9dc5;
        for (var i = 0; i < s.length; i++) {
            h ^= s.charCodeAt(i) & 0xff;
            h = Math.imul(h, 0x01000193) >>> 0;
        }
        return "0x" + ("00000000" + h.toString(16)).slice(-8);
    }

    function pathOfUrl(s) {
        try {
            var m = String(s || "").match(/^https?:\/\/([^\/?#]+)([^?#]*)(?:\?([^#]*))?/);
            if (!m) return { host: "", path: "", qs: "" };
            return { host: m[1] || "", path: m[2] || "", qs: m[3] || "" };
        } catch (e) {
            return { host: "", path: "", qs: "" };
        }
    }

    function emptyState() {
        return {
            tag: "",
            active: false,
            limit: 0,
            started_ms: 0,
            stopped_ms: 0,
            module: null,
            next_id: 1,
            open: {},
            completed: [],
            global_counts: {},
            global_exe_vmcode: {},
            global_exe_lr: {},
            installed: false
        };
    }

    var state = globalThis.__metasecMultiRequestCounter350 || emptyState();
    globalThis.__metasecMultiRequestCounter350 = state;

    function start(limit, tag) {
        state.active = true;
        state.limit = limit || 8;
        state.tag = tag || "";
        state.started_ms = now();
        state.stopped_ms = 0;
        state.next_id = 1;
        state.open = {};
        state.completed = [];
        state.global_counts = {};
        state.global_exe_vmcode = {};
        state.global_exe_lr = {};
        var m = Process.findModuleByName(TARGET_MODULE);
        state.module = m ? { name: m.name, base: m.base.toString(), size: m.size, path: m.path } : null;
        install();
        log("start tag=" + state.tag + " limit=" + state.limit + " module=" + JSON.stringify(state.module));
        return summary();
    }

    function stop() {
        state.active = false;
        state.stopped_ms = now();
        return summary();
    }

    function summary() {
        var out = JSON.parse(JSON.stringify(state));
        delete out.open;
        out.open_count = Object.keys(state.open || {}).length;
        out.elapsed_ms = (state.stopped_ms || now()) - state.started_ms;
        return out;
    }

    function currentThreadKey(ctx) {
        try {
            if (ctx && ctx.threadId !== undefined) return String(ctx.threadId);
        } catch (_) {}
        try { return String(Process.getCurrentThreadId()); } catch (_) { return "0"; }
    }

    function makeRequest(base, ctx, args) {
        var s1 = readCStringSafe(args[0], 65536);
        var s2 = readCStringSafe(args[1], 65536);
        var u = pathOfUrl(s1);
        return {
            id: state.next_id++,
            started_ms: now(),
            stopped_ms: 0,
            tid: currentThreadKey(ctx),
            counts: {},
            exe_vmcode: {},
            exe_lr: {},
            input: {
                s1_len: s1 === null ? -1 : s1.length,
                s1_fnv1a: fnv1a32(s1),
                s1: s1,
                host: u.host,
                path: u.path,
                qs: u.qs,
                s2_len: s2 === null ? -1 : s2.length,
                s2_fnv1a: fnv1a32(s2),
                s2: s2
            },
            samples: [],
            inside_http: false,
            outer_pc: rel(base, ctx.pc),
            outer_lr: rel(base, ctx.lr)
        };
    }

    function pushSample(rec, sample) {
        if (!rec || rec.samples.length >= MAX_SAMPLES_PER_REQUEST) return;
        rec.samples.push(sample);
    }

    function getRec(ctx) {
        return state.open[currentThreadKey(ctx)] || null;
    }

    function finishRec(ctx) {
        var key = currentThreadKey(ctx);
        var rec = state.open[key];
        if (!rec) return;
        rec.stopped_ms = now();
        rec.elapsed_ms = rec.stopped_ms - rec.started_ms;
        rec.inside_http = false;
        state.completed.push(rec);
        delete state.open[key];
        if (state.completed.length >= state.limit) {
            state.active = false;
            state.stopped_ms = now();
            log("auto-stopped collected=" + state.completed.length);
            log("summary-json " + JSON.stringify(summary()));
        }
    }

    function record(label, base, ctx, args) {
        if (!state.active) return;
        if (state.completed.length >= state.limit) return;

        if (label === "http_callback_14dbf4") {
            var key = currentThreadKey(ctx);
            if (!state.open[key]) {
                state.open[key] = makeRequest(base, ctx, args);
                pushSample(state.open[key], {
                    label: label,
                    pc: rel(base, ctx.pc),
                    lr: rel(base, ctx.lr),
                    x0: hex(ctx.x0),
                    x1: hex(ctx.x1)
                });
                inc(state.global_counts, label);
            }
            return;
        }

        var rec = getRec(ctx);
        if (!rec) return;

        if (label === "http_entry_149ca8") rec.inside_http = true;
        if (!rec.inside_http && label !== "http_entry_149ca8") return;

        inc(rec.counts, label);
        inc(state.global_counts, label);

        var sample = {
            label: label,
            hit: rec.counts[label],
            pc: rel(base, ctx.pc),
            lr: rel(base, ctx.lr),
            sp: hex(ctx.sp),
            x0: hex(ctx.x0),
            x1: hex(ctx.x1),
            x2: hex(ctx.x2),
            x3: hex(ctx.x3),
            x4: hex(ctx.x4),
            x8: hex(ctx.x8)
        };

        if (label === "exeVMInner_4cc10") {
            sample.vmCode = rel(base, args[0]);
            sample.pParamList = hex(args[1]);
            sample.vmData1 = rel(base, args[2]);
            sample.vmData2 = rel(base, args[3]);
            sample.vmParam = hex(args[4]);
            inc(rec.exe_vmcode, sample.vmCode);
            inc(rec.exe_lr, sample.lr);
            inc(state.global_exe_vmcode, sample.vmCode);
            inc(state.global_exe_lr, sample.lr);
        } else if (label === "branch_helper_ret_149f60") {
            sample.w0_ret = u32(ctx.x0);
        } else if (label === "branch_f5f7_gate_14a250") {
            sample.w8 = u32(ctx.x8);
            sample.bit0 = sample.w8 & 1;
            sample.decision = sample.bit0 ? "skip F5/F7 -> F8" : "run F5/F7";
        } else if (label === "managed_native_blr_15454c") {
            sample.blr_target = rel(base, ctx.x8);
        } else if (label === "runtimeGate_d9044_entry") {
            sample.byte_2c1070 = readU8Safe(ptr(base).add(0x2c1070));
        } else if (label === "runtimeGate_d952c_returnByte") {
            var dyn = ptr(ctx.x23).add(0x70);
            sample.x23 = hex(ctx.x23);
            sample.ret_byte_dynamic = readU8Safe(dyn);
            sample.ret_byte_global = readU8Safe(ptr(base).add(0x2c1070));
        } else if (label === "native_binding_runtimeGate_ret_15284c") {
            sample.d9044_ret_w0 = u32(ctx.x0);
        } else if (label === "envVmWrapper_201800_12ac9c") {
            sample.wrapper_caller_lr = rel(base, ctx.lr);
        } else if (label === "vmwrap_201800_call_12acf4") {
            sample.wrapper_vmCode = rel(base, ctx.x0);
            sample.wrapper_vmData1 = rel(base, ctx.x2);
            sample.wrapper_vmData2 = rel(base, ctx.x3);
        } else if (label === "vmwrap_201800_ret_12acf8") {
            sample.ret_x0 = hex(ctx.x0);
            sample.ret_x8 = hex(ctx.x8);
        }

        pushSample(rec, sample);
    }

    function onHttpLeave(ctx) {
        var rec = getRec(ctx);
        if (rec) rec.inside_http = false;
    }

    function installAtModule(m) {
        if (state.installed || globalThis.__metasecMultiRequestCounter350Installed) return "already-installed";
        state.installed = true;
        globalThis.__metasecMultiRequestCounter350Installed = true;
        state.module = { name: m.name, base: m.base.toString(), size: m.size, path: m.path };
        log("install module base=" + m.base + " path=" + m.path);

        Object.keys(OFFSETS).forEach(function (label) {
            var target = m.base.add(OFFSETS[label]);
            try {
                var cb = {
                    onEnter: function (args) { record(label, m.base, this, args); }
                };
                if (label === "http_callback_14dbf4") {
                    cb.onLeave = function () { finishRec(this); };
                } else if (label === "http_entry_149ca8") {
                    cb.onLeave = function () { onHttpLeave(this); };
                }
                Interceptor.attach(target, cb);
                log("hook " + label + " @" + target);
            } catch (e) {
                log("hook failed " + label + " @" + target + ": " + e);
            }
        });
        return "ok";
    }

    function install() {
        var m = Process.findModuleByName(TARGET_MODULE);
        if (m) return installAtModule(m);

        if (globalThis.__metasecMultiRequestCounter350Waiting) return "waiting";
        globalThis.__metasecMultiRequestCounter350Waiting = true;

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

        function watchLoader(symbol) {
            var dlopen = findGlobalExport(symbol);
            if (!dlopen) return false;

            try {
                Interceptor.attach(dlopen, {
                    onEnter: function (args) {
                        this.path = "";
                        try { this.path = args[0].readCString(); } catch (_) {}
                    },
                    onLeave: function () {
                        if (this.path.indexOf(TARGET_MODULE) < 0) return;
                        var retry = function () {
                            install();
                        };
                        if (typeof setImmediate === "function") setImmediate(retry);
                        else retry();
                    }
                });
                log("watch " + symbol + " @" + dlopen);
                return true;
            } catch (e) {
                log("watch " + symbol + " failed: " + e);
                return false;
            }
        }

        var hooked = false;
        hooked = watchLoader("android_dlopen_ext") || hooked;
        hooked = watchLoader("dlopen") || hooked;
        if (!hooked) {
            globalThis.__metasecMultiRequestCounter350Waiting = false;
            return "no-dlopen";
        }
        return "waiting";
    }

    var old = rpc.exports || {};
    old.metamultiinstall = install;
    old.metamultistart = start;
    old.metamultistop = stop;
    old.metamultisummary = summary;
    rpc.exports = old;

    install();
    return start(8, "autoload");
})();

}

(function () {
    console.log("[metasec-counter-multi] standalone loaded (Frida 17)");
    __dyidre_mode_counter_multi();
})();
