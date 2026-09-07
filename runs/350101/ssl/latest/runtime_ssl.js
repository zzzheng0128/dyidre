globalThis.METASEC_PROBE_CONFIG = {"mode": "ssl", "ssl": {"stealth": false}};
// Douyin 350101 统一 MetaSec probe。
//
// 这是 probes/350101 下唯一面向使用者的 Frida/rustFrida JS 入口。
// 以前那些单功能脚本已经合并成 mode，避免后续版本迭代时选错脚本。
//
// 加载前可以在 runtime JS 头部写入配置：
//   globalThis.METASEC_PROBE_CONFIG = { mode: "counter-one" };
//
// 也可以先以 rpc 模式常驻，再通过 RPC 动态安装 probe：
//   curl -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
//     -H 'Content-Type: application/json' -d '["counter-one"]'
//
// 推荐从 host 侧统一 runner 启动：
//   probes/350101/run_metasec_probe_350101.sh <mode> [seconds] [tag]
//
// 输出约定：
//   原始 console/log 都放到 runs/350101/<kind>/<run_id>/，不要堆在 probes 目录。

// ===== mode: counter-one / 单请求计数 =====
// 历史来源：metasec_one_request_counter_350.js
// 什么时候用：只触发一条 HTTP 请求，统计 HTTP/F8/F13/exeVMInner 命中次数，对齐真机 vs unidbg 路径。
function __dyidre_mode_counter_one() {
// Lightweight one-request MetaSec counter for rustFrida RPC.
//
// Install through the unified RF RPC session:
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
//     -H 'Content-Type: application/json' -d '["counter-one"]'
//
// Then:
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metacountreset -H 'Content-Type: application/json' -d '["one"]'
//   # trigger exactly one HTTP request in Douyin
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metacountsummary -H 'Content-Type: application/json' -d '[]'

(function () {
    try {
        if (globalThis.__metasecOneRequestCounterState) {
            globalThis.__metasecOneRequestCounterState.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV2) {
            globalThis.__metasecOneRequestCounterStateV2.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV3) {
            globalThis.__metasecOneRequestCounterStateV3.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV4) {
            globalThis.__metasecOneRequestCounterStateV4.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV5) {
            globalThis.__metasecOneRequestCounterStateV5.active = false;
        }
        if (globalThis.__metasecOneRequestCounterStateV6) {
            globalThis.__metasecOneRequestCounterStateV6.active = false;
        }
    } catch (_) {
    }

    var TARGET_MODULE = "libmetasec_ml.so";

    var OFFSETS = {
        http_callback_14dbf4: 0x14dbf4,
        http_entry_149ca8: 0x149ca8,
        exeVMInner_4cc10: 0x4cc10,
        nativeVmpBuildMaterial_124dd4: 0x124dd4,
        nativeVmpSelectMaterial_12564c: 0x12564c,
        nativeStage1_14a1ac: 0x14a1ac,
        nativeStage2_14a1fc: 0x14a1fc,
        managedF5_14a38c: 0x14a38c,
        managedF7_14a3ec: 0x14a3ec,
        managedF8_14a4e0: 0x14a4e0,
        managedF13_14a588: 0x14a588
    };

    function log(s) {
        console.log("[metacount] " + s);
    }

    function now() {
        return Date.now();
    }

    function hex(n) {
        try {
            if (typeof n === "number") return "0x" + n.toString(16);
            return ptr(n).toString();
        } catch (e) {
            return String(n);
        }
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

    function emptyState(tag) {
        return {
            tag: tag || "",
            active: false,
            started_ms: 0,
            stopped_ms: 0,
            module: null,
            counts: {},
            exe_vmcode: {},
            exe_lr: {},
            stop_after_first_request: true,
            inside_http_only: true,
            inside_http: false,
            inside_outer: false,
            outer_only: true,
            done: false,
            input: null,
            samples: []
        };
    }

    var state = globalThis.__metasecOneRequestCounterStateV7 || emptyState("");
    globalThis.__metasecOneRequestCounterStateV7 = state;

    function reset(tag, stopAfterFirstRequest, insideHttpOnly, outerOnly) {
        var m = Process.findModuleByName(TARGET_MODULE);
        state.tag = tag || "";
        state.active = true;
        state.started_ms = now();
        state.stopped_ms = 0;
        state.module = m ? { name: m.name, base: m.base.toString(), size: m.size, path: m.path } : null;
        state.counts = {};
        state.exe_vmcode = {};
        state.exe_lr = {};
        state.stop_after_first_request = stopAfterFirstRequest === undefined ? true : !!stopAfterFirstRequest;
        state.inside_http_only = insideHttpOnly === undefined ? true : !!insideHttpOnly;
        state.inside_http = false;
        state.outer_only = outerOnly === undefined ? true : !!outerOnly;
        state.inside_outer = false;
        state.done = false;
        state.input = null;
        state.samples = [];
        log("reset tag=" + state.tag + " stop_after_first_request=" + state.stop_after_first_request +
            " inside_http_only=" + state.inside_http_only +
            " outer_only=" + state.outer_only +
            " module=" + JSON.stringify(state.module));
        return state;
    }

    function stop() {
        state.active = false;
        state.stopped_ms = now();
        return summary();
    }

    function summary() {
        var out = JSON.parse(JSON.stringify(state));
        out.elapsed_ms = (state.stopped_ms || now()) - state.started_ms;
        return out;
    }

    function record(label, base, ctx, args) {
        if (!state.active) return;
        if (state.done) return;
        if (state.outer_only && label !== "http_callback_14dbf4" && !state.inside_outer) return;
        if (state.outer_only && label === "http_callback_14dbf4" && !state.inside_outer) {
            state.inside_outer = true;
            captureInput(args);
        }
        if (state.inside_http_only && label !== "http_entry_149ca8" && !state.inside_http) return;
        if (state.inside_http_only && label === "http_entry_149ca8" && !state.inside_http) {
            state.inside_http = true;
        }
        inc(state.counts, label);

        var sample = null;
        try {
            if (label === "exeVMInner_4cc10") {
                var vmCode = args[0];
                var vmOff = rel(base, vmCode);
                var lrOff = rel(base, ctx.lr);
                inc(state.exe_vmcode, vmOff);
                inc(state.exe_lr, lrOff);
                if (state.samples.length < 48) {
                    sample = {
                        label: label,
                        hit: state.counts[label],
                        pc: rel(base, ctx.pc),
                        lr: lrOff,
                        vmCode: vmOff,
                        pParamList: hex(args[1]),
                        vmData1: rel(base, args[2]),
                        vmData2: rel(base, args[3]),
                        vmParam: hex(args[4])
                    };
                }
            } else if (state.samples.length < 48) {
                sample = {
                    label: label,
                    hit: state.counts[label],
                    pc: rel(base, ctx.pc),
                    lr: rel(base, ctx.lr),
                    x0: hex(ctx.x0),
                    x1: hex(ctx.x1),
                    x2: hex(ctx.x2),
                    x3: hex(ctx.x3),
                    x8: hex(ctx.x8)
                };
            }
        } catch (e) {
            inc(state.counts, label + ".sample_error");
            if (state.samples.length < 48) {
                sample = { label: label, error: String(e) };
            }
        }

        if (sample !== null) {
            state.samples.push(sample);
        }

        if (state.stop_after_first_request
                && label === "managedF13_14a588"
                && (state.counts.http_entry_149ca8 || 0) >= 1) {
            state.active = false;
            state.stopped_ms = now();
            state.done = true;
            log("auto-stopped after first request: " + JSON.stringify(state.counts));
        }
    }

    function leaveHttp() {
        if (!state.active || state.done || !state.inside_http_only || !state.inside_http || state.outer_only) {
            return;
        }
        state.active = false;
        state.stopped_ms = now();
        state.inside_http = false;
        state.done = true;
        log("auto-stopped at http_entry onLeave: " + JSON.stringify(state.counts));
    }

    function readCStringSafe(p, maxLen) {
        try {
            var q = ptr(p);
            if (q.toString() === "0x0") return null;
            return Memory.readCString(q);
        } catch (e) {
            return "<readCString-error:" + e + ">";
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

    function captureInput(args) {
        var s1 = readCStringSafe(args[0], 32768);
        var s2 = readCStringSafe(args[1], 32768);
        state.input = {
            s1_len: s1 === null ? -1 : s1.length,
            s1_fnv1a: fnv1a32(s1),
            s1: s1,
            s2_len: s2 === null ? -1 : s2.length,
            s2_fnv1a: fnv1a32(s2),
            s2: s2
        };
    }

    function leaveOuter() {
        if (!state.active || state.done || !state.outer_only || !state.inside_outer) {
            return;
        }
        state.active = false;
        state.stopped_ms = now();
        state.inside_outer = false;
        state.done = true;
        log("auto-stopped at http_callback onLeave: " + JSON.stringify(state.counts));
    }

    function installAtModule(m) {
        if (globalThis.__metasecOneRequestCounterInstalledV7) {
            return "already-installed";
        }
        globalThis.__metasecOneRequestCounterInstalledV7 = true;
        log("install module base=" + m.base + " path=" + m.path);

        Object.keys(OFFSETS).forEach(function (label) {
            var off = OFFSETS[label];
            var target = m.base.add(off);
            try {
                var callbacks = {
                    onEnter: function (args) {
                        record(label, m.base, this, args);
                    }
                };
                if (label === "http_entry_149ca8") {
                    callbacks.onLeave = function () {
                        leaveHttp();
                    };
                } else if (label === "http_callback_14dbf4") {
                    callbacks.onLeave = function () {
                        leaveOuter();
                    };
                }
                Interceptor.attach(target, callbacks);
                log("hook " + label + " @" + target);
            } catch (e) {
                log("hook failed " + label + " @" + target + ": " + e);
            }
        });
        return "ok";
    }

    function install() {
        var m = Process.findModuleByName(TARGET_MODULE);
        if (m) {
            return installAtModule(m);
        }

        if (globalThis.__metasecOneRequestCounterWaitingV7) {
            return "waiting";
        }
        globalThis.__metasecOneRequestCounterWaitingV7 = true;

        var dlopen = Module.findExportByName(null, "android_dlopen_ext") || Module.findExportByName(null, "dlopen");
        if (!dlopen) {
            return "no-dlopen";
        }

        Interceptor.attach(dlopen, {
            onEnter: function (args) {
                this.path = "";
                try {
                    this.path = args[0].readCString();
                } catch (_) {
                    this.path = "";
                }
            },
            onLeave: function () {
                if (this.path.indexOf(TARGET_MODULE) < 0) return;
                // 不在 dlopen onLeave 里直接 Interceptor.attach：RF 在 loader 回调内
                // 密集 patch 容易抛内部异常。这里只记录“库已出现”，由 host
                // runner 通过 metabranchinstall RPC 轮询安装。
                globalThis.__metasecBranchProbe350SawDlopen = true;
            }
        });
        return "waiting";
    }

    var old = rpc.exports || {};
    old.metacountinstall = install;
    old.metacountreset = reset;
    old.metacountstop = stop;
    old.metacountsummary = summary;
    rpc.exports = old;

    return install();
})();

}

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
        var dlopen = Module.findExportByName(null, "android_dlopen_ext") || Module.findExportByName(null, "dlopen");
        if (!dlopen) return "no-dlopen";
        Interceptor.attach(dlopen, {
            onEnter: function (args) {
                this.path = "";
                try { this.path = args[0].readCString(); } catch (_) {}
            },
            onLeave: function () {
                if (this.path.indexOf(TARGET_MODULE) < 0) return;
                var mod = Process.findModuleByName(TARGET_MODULE);
                if (mod) installAtModule(mod);
            }
        });
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

// ===== mode: branch / CF 分支值探针 =====
// 历史来源：metasec_branch_probe_350.js
// 什么时候用：raw PC 可以重新同步，但 header 值还不一致时，追 CF/x2/blr_target 等值级分叉。
function __dyidre_mode_branch() {
// Focused one-request branch probe for Douyin 350.101 libmetasec_ml.so.
//
// Purpose:
//   Compare true-device and unidbg around buildSignedHttpHeadersInner_350:
//   - why F5/F7 are skipped or executed;
//   - whether the pre-stage native VMP wrapper at 0x12AC9C runs;
//   - what exeVMInner programs are called inside the same HTTP window.

(function () {
    var TARGET_MODULE = "libmetasec_ml.so";

    try {
        if (globalThis.__metasecBranchProbe350State) {
            globalThis.__metasecBranchProbe350State.active = false;
        }
    } catch (_) {}

    function emptyState(tag) {
        return {
            tag: tag || "",
            active: false,
            done: false,
            started_ms: 0,
            stopped_ms: 0,
            module: null,
            outer_only: true,
            inside_outer: false,
            inside_http_only: true,
            inside_http: false,
            stop_after_first_request: true,
            counts: {},
            exe_vmcode: {},
            exe_lr: {},
            samples: []
        };
    }

    var state = emptyState("");
    globalThis.__metasecBranchProbe350State = state;

    var OFFSETS = {
        http_callback_14dbf4: 0x14dbf4,
        http_entry_149ca8: 0x149ca8,

        // 0x149180 helper returns a MEM_BLOCK-like object through X8=sp+0x68.
        // buildSignedHttpHeadersInner checks this result before stage1/stage2.
        branch_pre_stage_result_ptr_14a16c: 0x14a16c,
        branch_pre_stage_ptr_gate_14a170: 0x14a170,
        branch_pre_stage_len_gate_14a178: 0x14a178,

        // 0x149F5C helper result is stored to [sp+0x10], then bit0 decides
        // whether F5/F7 Argus/Ladon generation block runs.
        branch_helper_ret_149f60: 0x149f60,
        branch_f5f7_gate_14a250: 0x14a250,
        // bit0=1 goes through 0x14A254..0x14A334, then jumps to 0x14A438,
        // so this path skips F5/F7.
        branch_precompute_then_skip_f5f7_14a254: 0x14a254,
        // bit0=0 jumps here and falls through F5/F7.
        branch_run_f5f7_14a348: 0x14a348,

        // Fixed native wrapper around exeVMInner(vmCode=0x201800).
        vmwrap_201800_call_12acf4: 0x12acf4,
        vmwrap_201800_ret_12acf8: 0x12acf8,

        nativeStage1_14a1ac: 0x14a1ac,
        nativeStage2_14a1fc: 0x14a1fc,
        managedF5_14a38c: 0x14a38c,
        managedF7_14a3ec: 0x14a3ec,
        branch_after_f5f7_join_14a438: 0x14a438,
        managedF8_14a4e0: 0x14a4e0,
        managedF13_14a588: 0x14a588,
        exeVMInner_4cc10: 0x4cc10
    };

    // RF inline hook 对基本块内部、相邻几条指令连续 patch 不够稳。
    // 默认 branch 只启用 counter-one 已验证稳定的阶段点；如果必须追
    // 0x14A250 这类单条分支指令，用 stackplz/eDBG 硬件断点，或手动
    // 在 runtime JS 里设置 METASEC_PROBE_CONFIG.branchDeep=true。
    var DEEP_BRANCH_POINTS = {
        branch_pre_stage_result_ptr_14a16c: true,
        branch_pre_stage_ptr_gate_14a170: true,
        branch_pre_stage_len_gate_14a178: true,
        branch_helper_ret_149f60: true,
        branch_f5f7_gate_14a250: true,
        branch_precompute_then_skip_f5f7_14a254: true,
        branch_run_f5f7_14a348: true,
        branch_after_f5f7_join_14a438: true,
        vmwrap_201800_call_12acf4: true,
        vmwrap_201800_ret_12acf8: true
    };

    function isDeepBranchEnabled() {
        try {
            return !!(globalThis.METASEC_PROBE_CONFIG && globalThis.METASEC_PROBE_CONFIG.branchDeep);
        } catch (_) {
            return false;
        }
    }

    function log(s) {
        try {
            console.log("[metabranch] " + String(s));
        } catch (_) {}
    }

    function inc(map, key) {
        key = String(key);
        map[key] = (map[key] || 0) + 1;
    }

    function hex(v) {
        try {
            return ptr(v).toString();
        } catch (e) {
            return String(v);
        }
    }

    function toNum(v) {
        try {
            return parseInt(ptr(v).toString(), 16);
        } catch (_) {
            return 0;
        }
    }

    function isNullPtr(v) {
        try {
            var s = ptr(v).toString().toLowerCase();
            return s === "0x0" || s === "0";
        } catch (_) {
            return true;
        }
    }

    function rel(base, p) {
        var n = toNum(p);
        var b = toNum(base);
        if (n >= b && n < b + 0x8000000) {
            return "0x" + (n - b).toString(16);
        }
        return hex(p);
    }

    function readU32Safe(p) {
        try {
            var q = ptr(p);
            if (isNullPtr(q)) return null;
            return Memory.readU32(q) >>> 0;
        } catch (_) {
            return null;
        }
    }

    function readPtrSafe(p) {
        try {
            var q = ptr(p);
            if (isNullPtr(q)) return null;
            return Memory.readPointer(q);
        } catch (_) {
            return null;
        }
    }

    function addSample(sample) {
        if (state.samples.length < 128) {
            state.samples.push(sample);
        }
    }

    function reset(tag, stopAfterFirstRequest, insideHttpOnly, outerOnly) {
        var m = Process.findModuleByName(TARGET_MODULE);
        state.tag = tag || "";
        state.active = true;
        state.done = false;
        state.started_ms = Date.now();
        state.stopped_ms = 0;
        state.module = m ? { name: m.name, base: m.base.toString(), size: m.size, path: m.path } : null;
        state.outer_only = outerOnly === undefined ? true : !!outerOnly;
        state.inside_outer = false;
        state.inside_http_only = insideHttpOnly === undefined ? true : !!insideHttpOnly;
        state.inside_http = false;
        state.stop_after_first_request = stopAfterFirstRequest === undefined ? true : !!stopAfterFirstRequest;
        state.counts = {};
        state.exe_vmcode = {};
        state.exe_lr = {};
        state.samples = [];
        // pre-resume 阶段 libmetasec_ml.so 可能还没加载；runner 通过 RPC reset
        // 时模块通常已经出现，这里补一次安装，避免 branch mode 空跑 0 hit。
        if (m !== null) {
            installAtModule(m);
        }
        log("reset " + JSON.stringify({
            tag: state.tag,
            module: state.module,
            outer_only: state.outer_only,
            inside_http_only: state.inside_http_only,
            stop_after_first_request: state.stop_after_first_request
        }));
        return summary();
    }

    function stop() {
        state.active = false;
        state.stopped_ms = Date.now();
        return summary();
    }

    function summary() {
        var out = JSON.parse(JSON.stringify(state));
        out.elapsed_ms = (state.stopped_ms || Date.now()) - state.started_ms;
        return out;
    }

    function shouldRecord(label) {
        if (!state.active || state.done) return false;
        if (state.outer_only && label !== "http_callback_14dbf4" && !state.inside_outer) return false;
        if (state.inside_http_only && label !== "http_entry_149ca8" && !state.inside_http) return false;
        return true;
    }

    function record(label, base, ctx, args) {
        if (label === "http_callback_14dbf4" && state.active && state.outer_only && !state.inside_outer) {
            state.inside_outer = true;
        }
        if (label === "http_entry_149ca8" && state.active && state.inside_http_only && !state.inside_http) {
            state.inside_http = true;
        }
        if (!shouldRecord(label)) return;

        inc(state.counts, label);

        var sp = null;
        try {
            sp = ctx.sp;
        } catch (_) {
            sp = ptr(0);
        }

        var sample = {
            label: label,
            hit: state.counts[label],
            pc: rel(base, ctx.pc),
            lr: rel(base, ctx.lr),
            x0: hex(ctx.x0),
            x1: hex(ctx.x1),
            x2: hex(ctx.x2),
            x3: hex(ctx.x3),
            x4: hex(ctx.x4),
            x8: hex(ctx.x8),
            sp: hex(sp)
        };

        try {
            if (label === "exeVMInner_4cc10") {
                var vmCode = rel(base, args[0]);
                var lrOff = rel(base, ctx.lr);
                inc(state.exe_vmcode, vmCode);
                inc(state.exe_lr, lrOff);
                sample.vmCode = vmCode;
                sample.pParamList = hex(args[1]);
                sample.vmData1 = rel(base, args[2]);
                sample.vmData2 = rel(base, args[3]);
                sample.vmParam = hex(args[4]);
            }

            if (label === "branch_pre_stage_result_ptr_14a16c"
                    || label === "branch_pre_stage_ptr_gate_14a170"
                    || label === "branch_pre_stage_len_gate_14a178") {
                var prePtr = readPtrSafe(ptr(sp).add(0x68));
                sample.sp68_ptr = prePtr === null ? "<read-failed>" : hex(prePtr);
                if (prePtr !== null && !isNullPtr(prePtr)) {
                    sample.sp68_len_c = readU32Safe(prePtr.add(0x0c));
                    sample.sp68_body = hex(readPtrSafe(prePtr.add(0x10)) || ptr(0));
                }
            }

            if (label === "branch_helper_ret_149f60") {
                sample.w0_ret = toNum(ctx.x0) & 0xffffffff;
                sample.sp10_u32_before_store = readU32Safe(ptr(sp).add(0x10));
            }

            if (label === "branch_f5f7_gate_14a250") {
                sample.w8_gate = toNum(ctx.x8) & 0xffffffff;
                sample.sp10_u32 = readU32Safe(ptr(sp).add(0x10));
                sample.bit0 = sample.w8_gate & 1;
                sample.decision = sample.bit0
                    ? "precompute 0x14A254..0x14A334, then skip F5/F7 -> 0x14A438"
                    : "jump to 0x14A348 and run F5/F7";
            }

            if (label === "vmwrap_201800_call_12acf4" || label === "vmwrap_201800_ret_12acf8") {
                sample.wrapper_x0_vmcode = rel(base, ctx.x0);
                sample.wrapper_x1_paramlist = hex(ctx.x1);
                sample.wrapper_x2_vmdata1 = rel(base, ctx.x2);
                sample.wrapper_x3_vmdata2 = rel(base, ctx.x3);
                sample.wrapper_x4_vmparam = hex(ctx.x4);
            }
        } catch (e) {
            sample.error = String(e);
        }

        addSample(sample);
    }

    function maybeAutoStop(label) {
        if (!state.active || state.done) return;
        if (state.stop_after_first_request
                && label === "managedF13_14a588"
                && (state.counts.http_entry_149ca8 || 0) >= 1) {
            state.active = false;
            state.stopped_ms = Date.now();
            state.done = true;
            log("auto-stopped " + JSON.stringify(state.counts));
        }
    }

    function installAtModule(m) {
        if (globalThis.__metasecBranchProbe350Installed) {
            return "already-installed";
        }
        var moduleBase = null;
        var modulePath = TARGET_MODULE;
        try {
            moduleBase = ptr(m.base);
        } catch (e0) {
            moduleBase = Module.findBaseAddress(TARGET_MODULE);
        }
        if (moduleBase === null || moduleBase === undefined || moduleBase.toString() === "0x0") {
            return "module-base-not-found";
        }
        try {
            if (m.path !== undefined && m.path !== null) modulePath = String(m.path);
        } catch (_) {
            modulePath = TARGET_MODULE;
        }

        var branchDeep = isDeepBranchEnabled();
        var moduleBaseText = "0x0";
        try {
            moduleBaseText = moduleBase.toString();
        } catch (_) {
            moduleBaseText = TARGET_MODULE;
        }
        log("install module base=" + moduleBaseText + " path=" + modulePath);
        if (!branchDeep) {
            log("safe mode: skip dense basic-block probes; use stackplz/eDBG or branchDeep=true for exact branch instruction points");
        }
        globalThis.__metasecBranchProbe350Installed = true;
        Object.keys(OFFSETS).forEach(function (label) {
            if (!branchDeep && DEEP_BRANCH_POINTS[label]) {
                return;
            }
            var target = moduleBase.add(OFFSETS[label]);
            try {
                var callbacks = {
                    onEnter: function (args) {
                        record(label, moduleBase, this, args);
                        if (label === "managedF13_14a588") {
                            maybeAutoStop(label);
                        }
                    },
                };
                if (label === "http_callback_14dbf4") {
                    callbacks.onLeave = function () {
                        if (label === "http_callback_14dbf4") {
                            state.inside_outer = false;
                        }
                        maybeAutoStop(label);
                    };
                } else if (label === "http_entry_149ca8") {
                    callbacks.onLeave = function () {
                        if (!state.outer_only) {
                            state.inside_http = false;
                        }
                        maybeAutoStop(label);
                    };
                }
                Interceptor.attach(target, callbacks);
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

        // pre-resume 加载脚本时，目标 so 往往还没 dlopen。
        // branch 原版只返回 module-not-found，导致后续 reset 虽然成功但没有任何 hook。
        // 这里补 dlopen 监听，和 counter-one/counter-multi 保持同一启动语义。
        if (globalThis.__metasecBranchProbe350Waiting) {
            return "waiting";
        }
        globalThis.__metasecBranchProbe350Waiting = true;

        var dlopen = Module.findExportByName(null, "android_dlopen_ext") || Module.findExportByName(null, "dlopen");
        if (!dlopen) {
            return "no-dlopen";
        }

        Interceptor.attach(dlopen, {
            onEnter: function (args) {
                this.path = "";
                try {
                    this.path = args[0].readCString();
                } catch (_) {
                    this.path = "";
                }
            },
            onLeave: function () {
                if (this.path.indexOf(TARGET_MODULE) < 0) return;
                var mod = Process.findModuleByName(TARGET_MODULE);
                if (mod) installAtModule(mod);
            }
        });
        return "waiting";
    }

    var old = rpc.exports || {};
    old.metabranchinstall = install;
    old.metabranchreset = reset;
    old.metabranchstop = stop;
    old.metabranchsummary = summary;
    rpc.exports = old;

    return install();
})();

}

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
        var ab = Memory.readByteArray(p(addr), len);
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
        var a = Module.findExportByName("libc.so", name);
        if (a === null) a = Module.findExportByName(null, name);
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
        var a = Module.findExportByName("libc.so", "getrandom");
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
    try {
        if (typeof Hook !== "undefined" && Hook.WXSHADOW !== undefined) {
            return Interceptor.attach(addr, callbacks, Hook.WXSHADOW);
        }
    } catch (e) {
    }
    return Interceptor.attach(addr, callbacks);
}

function installModuleHooks(m) {
    if (installed) return;
    installed = true;
    var base = m.base !== undefined ? m.base : Module.findBaseAddress(TARGET_MODULE);
    emit("install module=" + TARGET_MODULE +
        " base=" + base +
        " size=" + (m.size === undefined ? "?" : "0x" + m.size.toString(16)) +
        " path=" + (m.path === undefined ? "?" : m.path));
    dumpProcessEnv("install");
    installGetrandomProbe();

    try {
        if (typeof Java !== "undefined" && typeof Java["set" + "Stealth"] === "function" &&
            typeof Hook !== "undefined" && Hook.WXSHADOW !== undefined) {
            Java["set" + "Stealth"](Hook.WXSHADOW);
            emit("Java.setStealth(WXSHADOW) ok");
        }
    } catch (e0) {
        emit("Java.setStealth(WXSHADOW) failed: " + e0);
    }

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
            var base = Module.findBaseAddress(TARGET_MODULE);
            if (base !== null) m = { base: base, size: 0, path: TARGET_MODULE };
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
            var a = Module.findExportByName(null, names[i]);
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

// ===== mode: jnitrace / JNI 环境补洞 =====
// 历史来源：metasec_jnitrace_spawn_early_wxshadow_lite.js
// 什么时候用：unidbg 缺 MS.b、NewString、FindClass、GetMethodID 等返回时，用真机 JNI 日志补 stub。
function __dyidre_mode_jnitrace() {
// Light early JNI baseline for libmetasec_ml.so.
//
// Goal:
//   - spawn pre-resume install
//   - WXSHADOW stealth patch for native JNI hook sites
//   - log only baseline-useful metasec events, not every hot JNI call

var TARGET_MODULE = "libmetasec_ml.so";
var STEALTH = (typeof Hook !== "undefined" && Hook.WXSHADOW !== undefined) ? Hook.WXSHADOW : 1;

var classMap = {};
var methodMap = {};
var traceInstalled = false;
var slotSpecs = [];
var hookedAddrs = {};
var envTableExpanded = false;
var libartBase = null;
var seenMethodKeys = {};
var seenStringKeys = {};
var lastReqCostMs = "?";
var reqSeq = 0;
var reqSuppressed = 0;
var reqStats = {};
var reqLastSummaryMs = 0;

// Keep the baseline usable without turning RF/adb into a firehose.
var STRING_MAX = 260;
var REQ_MAX_PER_ENDPOINT = 2;
var REQ_MIN_REPEAT_MS = 30000;
var REQ_SUMMARY_MS = 30000;

// Pixel 6 / Android 15 / libart.so offsets observed on this device.
var FIXED_JNI_OFFSETS = {
    FindClass: 0x73a520,
    GetStaticMethodID: 0x6189bc,
    CallStaticObjectMethodV: 0x43b038,
    CallStaticObjectMethodA: 0x51efa0,
    NewStringUTF: 0x8ace98,
    GetStringUTFChars: 0x737de4,
    RegisterNatives: 0x615b78
};

function now() {
    return String(Date.now());
}

function emit(s) {
    console.log("[metasec-jni-wxshadow-lite] " + now() + " " + s);
}

try {
    Java["set" + "Stealth"](Hook.WXSHADOW);
    emit("Java.setStealth(WXSHADOW) ok, native stealth=" + STEALTH);
} catch (e) {
    emit("Java.setStealth(WXSHADOW) failed: " + e + ", native stealth=" + STEALTH);
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
        if (isNull(p)) {
            return null;
        }
        return safePtr(p).readCString();
    } catch (e) {
        return "<cstring:" + e + ">";
    }
}

function retAddr(ctx) {
    if (ctx.returnAddress !== undefined) return safePtr(ctx.returnAddress);
    if (ctx.lr !== undefined) return safePtr(ctx.lr);
    if (ctx.x30 !== undefined) return safePtr(ctx.x30);
    return ptr(0);
}

function targetCaller(ctx) {
    var ra = retAddr(ctx);
    if (isNull(ra)) return null;
    var m = null;
    try {
        m = Module.findByAddress(ra);
    } catch (e) {
        m = null;
    }
    if (m === null || m.name.indexOf(TARGET_MODULE) < 0) return null;
    return { module: m, ra: ra, off: ra.sub(m.base) };
}

function classDisplay(clazz) {
    var k = key(clazz);
    return classMap[k] || ("<class " + k + ">");
}

function isBridgeSig(sig) {
    return sig === "(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;";
}

function rememberMethod(clazz, mid, name, sig, info) {
    if (isNull(mid)) return;
    var rec = {
        cls: classDisplay(clazz),
        name: name || "<name?>",
        sig: sig || "<sig?>"
    };
    methodMap[key(mid)] = rec;
    var methodKey = rec.name + rec.sig;
    if ((rec.cls.indexOf("metasec") >= 0 || isBridgeSig(rec.sig) || rec.name === "valueOf") &&
        !seenMethodKeys[methodKey]) {
        seenMethodKeys[methodKey] = true;
        emit(info.off + " GetStaticMethodID " + rec.cls + "->" + rec.name + rec.sig + " = " + key(mid));
    }
}

function formatMethod(mid) {
    var rec = methodMap[key(mid)];
    if (rec === undefined) return "<method " + key(mid) + ">";
    return rec.cls + "->" + rec.name + rec.sig;
}

function shouldLogStaticCall(mid) {
    var rec = methodMap[key(mid)];
    if (rec === undefined) return false;
    if (rec.cls.indexOf("com/bytedance/mobsec/metasec/ml/MS") >= 0 && isBridgeSig(rec.sig)) return true;
    if ((rec.name === "a" || rec.name === "b") && isBridgeSig(rec.sig)) return true;
    return false;
}

function interestingString(v) {
    if (v === null) return false;
    if (v === "utf-8") return false;
    if (v === "{}") return false;
    if (v === "\\|") return false;
    if (v === ";" || v === "r") return false;
    return v.indexOf("http_reqsign") >= 0 ||
        v.indexOf("consume_ML_DoHttpReqSignIT") >= 0 ||
        v.indexOf("ApiAndParams") >= 0 ||
        v.indexOf("mssdk.bytedance.com") >= 0 ||
        v.indexOf("sdk_ver=") >= 0 ||
        v.indexOf("v04.09.05") >= 0;
}

function shouldLogString(v) {
    if (!interestingString(v)) return false;
    if (v.indexOf("ApiAndParams") >= 0 || v.indexOf("consume_ML_DoHttpReqSignIT") >= 0) {
        return true;
    }
    if (seenStringKeys[v]) return false;
    seenStringKeys[v] = true;
    return true;
}

function shortString(v) {
    if (v === null) return "null";
    if (v.length > STRING_MAX) return v.substring(0, STRING_MAX) + "...<len=" + v.length + ">";
    return v;
}

function hash32(s) {
    var h = 2166136261 >>> 0;
    for (var i = 0; i < s.length; i++) {
        h ^= s.charCodeAt(i);
        h = Math.imul(h, 16777619) >>> 0;
    }
    return ("00000000" + h.toString(16)).slice(-8);
}

function extractApiUrl(v) {
    var s = String(v);
    var m = /\"ApiAndParams\"\s*:\s*\"([\s\S]*?)\"\s*\}/.exec(s);
    if (m) return m[1];
    return s;
}

function parseUrlLite(url) {
    var s = String(url).replace(/\\\//g, "/");
    var m = /^(https?:\/\/)?([^\/\?\s]+)([^\?\s]*)(?:\?([^\s#]*))?/.exec(s);
    if (!m) {
        return {
            key: shortString(s),
            host: "<raw>",
            path: "",
            qs: "",
            raw: s
        };
    }
    return {
        key: m[2] + m[3],
        host: m[2],
        path: m[3] || "/",
        qs: m[4] || "",
        raw: s
    };
}

function pickQuery(qs) {
    if (!qs) return "";
    var keep = {
        aid: true,
        version_code: true,
        version_name: true,
        manifest_version_code: true,
        update_version_code: true,
        sdk_ver: true,
        sdk_ver_code: true,
        app_ver: true,
        lc_id: true,
        mode: true,
        region_type: true,
        ts: true,
        _rticket: true
    };
    var parts = qs.split("&");
    var out = [];
    for (var i = 0; i < parts.length; i++) {
        var kv = parts[i].split("=", 1)[0];
        if (keep[kv]) out.push(parts[i]);
        if (out.length >= 10) break;
    }
    return out.join("&");
}

function emitReqSummary(force) {
    var t = Date.now();
    if (!force && t - reqLastSummaryMs < REQ_SUMMARY_MS) return;
    reqLastSummaryMs = t;
    var keys = Object.keys(reqStats);
    keys.sort(function (a, b) {
        return reqStats[b].count - reqStats[a].count;
    });
    var top = [];
    for (var i = 0; i < keys.length && i < 5; i++) {
        top.push(keys[i] + "=" + reqStats[keys[i]].count);
    }
    emit("REQ_SUMMARY total=" + reqSeq + " unique=" + keys.length +
        " suppressed=" + reqSuppressed + " top=" + top.join(","));
}

function logApiAndParams(off, v, source) {
    var url = extractApiUrl(v);
    var u = parseUrlLite(url);
    reqSeq++;

    var r = reqStats[u.key];
    if (r === undefined) {
        r = { count: 0, lastEmit: 0 };
        reqStats[u.key] = r;
    }
    r.count++;

    var t = Date.now();
    var shouldEmit = r.count <= REQ_MAX_PER_ENDPOINT || (t - r.lastEmit) >= REQ_MIN_REPEAT_MS;
    if (!shouldEmit) {
        reqSuppressed++;
        emitReqSummary(false);
        return;
    }

    r.lastEmit = t;
    var picked = pickQuery(u.qs);
    emit(off + " REQ#" + reqSeq + " cost_ms=" + lastReqCostMs +
        " src=" + source +
        " host=" + u.host +
        " path=" + u.path +
        (picked ? " qs=" + shortString(picked) : "") +
        " len=" + url.length +
        " h=" + hash32(url));
}

function getLibartBase() {
    if (libartBase !== null) return libartBase;
    try {
        libartBase = Module.findBaseAddress("libart.so");
    } catch (e) {
        libartBase = null;
    }
    if (libartBase === null || libartBase === undefined || safePtr(libartBase).toString() === "0x0") {
        emit("libart base not found");
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
    if (addr === null || addr === undefined || safePtr(addr).toString() === "0x0") return false;
    var k = safePtr(addr).toString();
    if (hookedAddrs[k]) return true;
    try {
        Interceptor.attach(addr, callbacks, STEALTH);
        hookedAddrs[k] = true;
        emit("hook " + name + "[" + index + "] @ " + addr + " via " + source + " stealth=WXSHADOW");
        return true;
    } catch (e) {
        emit("hook " + name + "[" + index + "] @ " + addr + " failed via " + source + ": " + e);
        return false;
    }
}

function expandSlotsFromEnv(env) {
    if (envTableExpanded || isNull(env)) return;
    envTableExpanded = true;
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

    hookSlot("FindClass", 6, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            var info = targetCaller(this);
            if (info === null) return;
            this.trace = info;
            this.name = safeCString(args[1]);
        },
        onLeave: function (retval) {
            if (this.trace === undefined) return;
            if (!isNull(retval) && this.name !== null) classMap[key(retval)] = this.name;
            if (String(this.name).indexOf("metasec") >= 0 ||
                String(this.name).indexOf("ms/bd") >= 0 ||
                String(this.name).indexOf("java/lang/Integer") >= 0 ||
                String(this.name).indexOf("java/lang/Long") >= 0 ||
                String(this.name).indexOf("java/lang/Boolean") >= 0) {
                emit(this.trace.off + " FindClass \"" + String(this.name) + "\" => " + key(retval));
            }
        }
    });

    hookSlot("GetStaticMethodID", 113, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            var info = targetCaller(this);
            if (info === null) return;
            this.trace = info;
            this.clazz = args[1];
            this.name = safeCString(args[2]);
            this.sig = safeCString(args[3]);
        },
        onLeave: function (retval) {
            if (this.trace === undefined) return;
            rememberMethod(this.clazz, retval, this.name, this.sig, this.trace);
        }
    });

    hookSlot("RegisterNatives", 215, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            var info = targetCaller(this);
            if (info === null) return;
            this.trace = info;
            this.clazz = args[1];
            this.methods = args[2];
            this.count = 0;
            try {
                if (args.length > 3 && args[3] !== undefined) {
                    this.count = args[3].toInt32();
                } else if (this.context !== undefined && this.context.x3 !== undefined) {
                    this.count = safePtr(this.context.x3).toInt32();
                }
            } catch (e) {
                this.count = 0;
            }
        },
        onLeave: function () {
            if (this.trace === undefined) return;
            emit(this.trace.off + " RegisterNatives " + classDisplay(this.clazz) + " count=" + this.count);
            for (var i = 0; i < this.count; i++) {
                try {
                    var ent = safePtr(this.methods).add(i * 24);
                    var name = safeCString(ent.readPointer());
                    var sig = safeCString(ent.add(8).readPointer());
                    var fn = ent.add(16).readPointer();
                    var mod = Module.findByAddress(fn);
                    var where = key(fn);
                    if (mod !== null) where = mod.name + "+" + fn.sub(mod.base);
                    emit("  native " + name + " " + sig + " -> " + where);
                } catch (e) {
                    emit("  native[" + i + "] decode failed: " + e);
                }
            }
        }
    });

    hookSlot("NewStringUTF", 167, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            var info = targetCaller(this);
            if (info === null) return;
            var v = safeCString(args[1]);
            if (!shouldLogString(v)) return;
            this.trace = info;
            this.value = v;
        },
        onLeave: function () {
            if (this.trace === undefined) return;
            var v = String(this.value);
            if (v.indexOf("consume_ML_DoHttpReqSignIT") >= 0) {
                var cm = /consume_ML_DoHttpReqSignIT\"\s*:\s*(\d+)/.exec(v);
                lastReqCostMs = cm ? cm[1] : "?";
                return;
            }
            if (v.indexOf("ApiAndParams") >= 0) {
                logApiAndParams(this.trace.off, v, "NewStringUTF");
                return;
            }
            emit(this.trace.off + " NewStringUTF \"" + shortString(v) + "\"");
        }
    });

    hookSlot("GetStringUTFChars", 169, {
        onEnter: function (args) {
            expandSlotsFromEnv(args[0]);
            var info = targetCaller(this);
            if (info === null) return;
            this.trace = info;
            this.jstr = args[1];
        },
        onLeave: function (retval) {
            if (this.trace === undefined || isNull(retval)) return;
            var v = safeCString(retval);
            if (!interestingString(v)) return;
            if (String(v).indexOf("consume_ML_DoHttpReqSignIT") >= 0) {
                var cm = /consume_ML_DoHttpReqSignIT\"\s*:\s*(\d+)/.exec(String(v));
                lastReqCostMs = cm ? cm[1] : lastReqCostMs;
                return;
            }
            if (String(v).indexOf("ApiAndParams") >= 0) {
                logApiAndParams(this.trace.off, v, "GetStringUTFChars");
                return;
            }
            if (shouldLogString(v)) {
                emit(this.trace.off + " GetStringUTFChars jstr=" + key(this.jstr) + " -> \"" + shortString(String(v)) + "\"");
            }
        }
    });

    emit("installed");
}

installTrace();

}

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
            typeof Java["set" + "Stealth"] === "function" &&
            typeof Hook !== "undefined" &&
            Hook !== null &&
            Hook.WXSHADOW !== undefined) {
            Java["set" + "Stealth"](Hook.WXSHADOW);
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

    var base = Module.findBaseAddress(TARGET_MODULE);
    if (base !== null) {
        installAtBase(base);
        return;
    }

    var dlopen = Module.findExportByName(null, "android_dlopen_ext");
    if (dlopen === null) dlopen = Module.findExportByName(null, "dlopen");
    if (dlopen === null) {
        log("cannot find dlopen/android_dlopen_ext");
        return;
    }

    log("waiting for " + TARGET_MODULE);
    Interceptor.attach(dlopen, {
        onEnter: function (args) {
            try {
                this.path = args[0].readCString();
            } catch (e) {
                this.path = "";
            }
        },
        onLeave: function () {
            if (this.path.indexOf(TARGET_MODULE) < 0) return;
            var loadedBase = Module.findBaseAddress(TARGET_MODULE);
            log("dlopen loaded: " + this.path + " base=" + loadedBase);
            if (loadedBase !== null) installAtBase(loadedBase);
        }
    });
}

waitForTargetModule();

}

// ===== mode: native-vmp / native VMP 局部验证 =====
// 历史来源：native_vmp_1f7860_probe_350.js
// 什么时候用：只盯 vmCode=0x1f7860 这一段 native VMP，验证它是不是参与当前 X-header 材料生成。
function __dyidre_mode_native_vmp() {
// Minimal true-device probe for Douyin 35.0/35.1 libmetasec_ml.so native VMP.
//
// Purpose:
//   Verify whether real device execution of:
//     0x12564C -> 0x124DD4 -> 0x4CC10(exeVMInner, vmCode=0x1F7860)
//   produces the mssdk material object recovered in:
//     metasec_350101_01/vm_lift_1f7860/native_vmp_1f7860_recovered.c
//
// Run example:
//   probes/350101/run_metasec_probe_350101.sh native-vmp 90 vmp01

var TARGET_MODULE = "libmetasec_ml.so";

var OFF_EXEVMINNER = 0x4cc10;
var OFF_SELECT_MATERIAL = 0x12564c;
var OFF_BUILD_MATERIAL_WRAPPER = 0x124dd4;

var installed = false;
var hit124 = 0;
var hit4cc10 = 0;
var hit125 = 0;

function log(s) {
    console.log("[native-vmp-1f7860-probe] " + s);
}

function pstr(p) {
    try {
        return ptr(p).toString();
    } catch (e) {
        return String(p);
    }
}

function offOf(base, p) {
    try {
        var diff = ptr(p).sub(base).toString();
        if (diff.indexOf("0x") === 0 || diff.indexOf("-0x") === 0) return diff;
        return "0x" + diff;
    } catch (e) {
        return "?";
    }
}

function isNull(p) {
    try {
        var s = ptr(p).toString().toLowerCase();
        return s === "0x0" || s === "0";
    } catch (e) {
        return true;
    }
}

function ctxReg(invocation, name) {
    try {
        // rustFrida 的 Interceptor helper：userFn.call(ctx, args)，所以 x0-x30/lr/pc 在 this 上。
        if (invocation && invocation[name] !== undefined && invocation[name] !== null) return invocation[name];
    } catch (_) {
    }
    try {
        // 兼容官方 Frida：寄存器在 this.context 上。
        if (invocation && invocation.context && invocation.context[name] !== undefined && invocation.context[name] !== null) {
            return invocation.context[name];
        }
    } catch (_) {
    }
    if (name === "lr") {
        try {
            if (invocation && invocation.returnAddress !== undefined && invocation.returnAddress !== null) return invocation.returnAddress;
        } catch (_) {
        }
        return ctxReg(invocation, "x30");
    }
    return "?";
}

function ctxPtr(invocation, name) {
    try {
        var value = ctxReg(invocation, name);
        if (value === "?") return ptr(0);
        return ptr(value);
    } catch (_) {
        return ptr(0);
    }
}

function ctxRegPtrText(invocation, name) {
    try {
        var value = ctxReg(invocation, name);
        if (value === "?") return "?";
        return ptr(value).toString();
    } catch (_) {
        try {
            return String(ctxReg(invocation, name));
        } catch (_) {
            return "?";
        }
    }
}

function readPtr(p, off) {
    try {
        return ptr(p).add(off).readPointer();
    } catch (e) {
        return ptr(0);
    }
}

function readU32(p, off) {
    try {
        return ptr(p).add(off).readU32();
    } catch (e) {
        return 0xffffffff;
    }
}

function readU64(p, off) {
    try {
        return ptr(p).add(off).readU64();
    } catch (e) {
        return null;
    }
}

function readCstr(p, maxLen) {
    try {
        if (isNull(p)) {
            return "<null>";
        }
        return ptr(p).readCString(maxLen || 512);
    } catch (e) {
        return "<err:" + e + ">";
    }
}

function dumpRefObj(label, refp) {
    try {
        if (isNull(refp)) {
            log(label + " ref=<null>");
            return;
        }
        var obj = readPtr(refp, 0);
        var rc = readPtr(refp, 8);
        log(label + " ref=" + refp + " obj=" + obj + " refcnt_ptr=" + rc);
        dumpNativeVmpResult(label + ".obj", obj);
    } catch (e) {
        log(label + " dumpRefObj failed: " + e);
    }
}

function dumpNativeVmpResult(label, obj) {
    try {
        if (isNull(obj)) {
            log(label + "=<null>");
            return;
        }
        var vt = readPtr(obj, 0);
        var material = readPtr(obj, 8);
        log(label + " result=" + obj + " vt=" + vt + " material=" + material);
        dumpMaterial(label + ".material", material);
    } catch (e) {
        log(label + " dumpNativeVmpResult failed: " + e);
    }
}

function dumpMaterial(label, m) {
    try {
        if (isNull(m)) {
            log(label + "=<null>");
            return;
        }
        var seed = readU32(m, 0x18);
        var moduleName = readCstr(readPtr(m, 0x20), 128);
        var appId = readCstr(readPtr(m, 0x28), 128);
        var enabled = readU32(m, 0x30);
        var sdkVer = readCstr(readPtr(m, 0x38), 128);
        var salt = readU32(m, 0x40);
        var appInfoCount = readU64(m, 0x48);
        var appInfos = readPtr(m, 0x50);
        var kvCount = readU64(m, 0x58);
        var kvItems = readPtr(m, 0x60);

        log(label + " material=" + m +
            " seed=0x" + seed.toString(16) +
            " module=" + JSON.stringify(moduleName) +
            " app_id=" + JSON.stringify(appId) +
            " enabled=" + enabled +
            " sdk_version=" + JSON.stringify(sdkVer) +
            " salt=0x" + salt.toString(16) +
            " appInfoCount=" + appInfoCount +
            " appInfos=" + appInfos +
            " kvCount=" + kvCount +
            " kvItems=" + kvItems);

        if (!isNull(appInfos)) {
            var app0 = readPtr(appInfos, 0);
            var pkg = readCstr(readPtr(app0, 0x18), 256);
            var materialCount = readU64(app0, 0x20);
            var materialValues = readPtr(app0, 0x28);
            var mat0 = isNull(materialValues) ? "<null>" : readCstr(readPtr(materialValues, 0), 256);
            log(label + ".app[0]=" + app0 +
                " package=" + JSON.stringify(pkg) +
                " materialCount=" + materialCount +
                " material0=" + JSON.stringify(mat0));
        }

        if (!isNull(kvItems)) {
            var n = 0;
            try {
                n = Number(kvCount);
            } catch (e) {
                n = 0;
            }
            if (n > 8) {
                n = 8;
            }
            for (var i = 0; i < n; i++) {
                var item = readPtr(kvItems, i * 8);
                var key = readCstr(readPtr(item, 0x18), 256);
                var val = readCstr(readPtr(item, 0x20), 512);
                log(label + ".kv[" + i + "] item=" + item +
                    " key=" + JSON.stringify(key) +
                    " value=" + JSON.stringify(val));
            }
        }
    } catch (e) {
        log(label + " dumpMaterial failed: " + e);
    }
}

function dumpMemBlockish(label, p) {
    try {
        if (isNull(p)) {
            log(label + "=<null>");
            return;
        }
        var q = [];
        for (var i = 0; i < 4; i++) {
            q.push("+0x" + (i * 8).toString(16) + "=" + readPtr(p, i * 8));
        }
        log(label + " " + p + " " + q.join(" "));
    } catch (e) {
        log(label + " dumpMemBlockish failed: " + e);
    }
}

function installAtBase(base) {
    if (installed) {
        return;
    }
    installed = true;

    log("module base=" + base);

	    Interceptor.attach(base.add(OFF_EXEVMINNER), {
	        onEnter: function (args) {
	            try {
	                hit4cc10++;
	                var vmoff = offOf(base, args[0]);
	                if (vmoff === "0x1f7860" || hit4cc10 <= 8) {
	                    log("hit exeVMInner#" + hit4cc10 +
	                        " pc=" + ctxRegPtrText(this, "pc") +
	                        " lr=" + ctxRegPtrText(this, "lr") +
	                        " vmCode=" + args[0] + "(" + vmoff + ")" +
	                        " pParamList=" + args[1] +
	                        " vmData1=" + args[2] + "(" + offOf(base, args[2]) + ")" +
	                        " vmData2=" + args[3] + "(" + offOf(base, args[3]) + ")" +
	                        " vmParam=" + args[4]);
	                    if (vmoff === "0x1f7860") {
	                        dumpMemBlockish("exeVMInner.pParamList", args[1]);
	                        log("exeVMInner.vmParam funBridge=" + readPtr(args[4], 0) +
	                            "(" + offOf(base, readPtr(args[4], 0)) + ")" +
	                            " stack_end=" + readPtr(args[4], 8) +
	                            " saveLR=" + readPtr(args[4], 0x10) +
	                            "(" + offOf(base, readPtr(args[4], 0x10)) + ")");
	                    }
	                }
	            } catch (e) {
	                log("exeVMInner onEnter failed: " + e);
	            }
	        }
	    });

	    Interceptor.attach(base.add(OFF_SELECT_MATERIAL), {
	        onEnter: function (args) {
	            try {
	                hit125++;
	                this.dst = ctxPtr(this, "x8");
	                this.selector = args[1];
	                log("hit selectValueFromNativeVmpMaterial#" + hit125 +
	                    " x8/dst=" + this.dst +
	                    " x0/source=" + args[0] +
	                    " x1/selector=" + args[1] +
	                    " x2/extra=" + args[2] +
	                    " lr=" + ctxRegPtrText(this, "lr"));
	                dumpMemBlockish("select.source", args[0]);
	                dumpMemBlockish("select.selector", args[1]);
	            } catch (e) {
	                log("select onEnter failed: " + e);
	            }
	        },
	        onLeave: function (retval) {
	            log("leave selectValueFromNativeVmpMaterial ret=" + retval +
                " dst=" + this.dst);
            dumpMemBlockish("select.dst_after", this.dst);
        }
    });

	    Interceptor.attach(base.add(OFF_BUILD_MATERIAL_WRAPPER), {
	        onEnter: function (args) {
	            try {
	                hit124++;
	                this.outRef = ctxPtr(this, "x8");
	                log("hit nativeVmpBuildMssdkMaterial#" + hit124 +
	                    " x8/out_ref=" + this.outRef +
	                    " x0/block_a=" + args[0] +
	                    " x1/block_b=" + args[1] +
	                    " x2/extra=" + args[2] +
	                    " lr=" + ctxRegPtrText(this, "lr"));
	                dumpMemBlockish("build.block_a", args[0]);
	                dumpMemBlockish("build.block_b", args[1]);
	            } catch (e) {
	                log("build onEnter failed: " + e);
	            }
	        },
        onLeave: function (retval) {
            log("leave nativeVmpBuildMssdkMaterial ret=" + retval +
                " out_ref=" + this.outRef);
            dumpRefObj("build.out_after", this.outRef);
        }
    });

    log("installed hooks: exeVMInner=0x" + OFF_EXEVMINNER.toString(16) +
        " select=0x" + OFF_SELECT_MATERIAL.toString(16) +
        " build=0x" + OFF_BUILD_MATERIAL_WRAPPER.toString(16));
}

function waitForTargetModule() {
    var base = Module.findBaseAddress(TARGET_MODULE);
    if (base !== null) {
        installAtBase(base);
        return;
    }

    var dlopen = Module.findExportByName(null, "android_dlopen_ext");
    if (dlopen === null) {
        dlopen = Module.findExportByName(null, "dlopen");
    }
    if (dlopen === null) {
        log("cannot find dlopen/android_dlopen_ext");
        return;
    }

    log("waiting for " + TARGET_MODULE);
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
            if (this.path.indexOf(TARGET_MODULE) < 0) {
                return;
            }
            var base = Module.findBaseAddress(TARGET_MODULE);
            log("dlopen loaded: " + this.path + " base=" + base);
            if (base !== null) {
                installAtBase(base);
            }
        }
    });
}

waitForTargetModule();

}

// ===== mode: gum-exevm / exeVMInner raw trace =====
// 历史来源：gumtrace_4cc10.js
// 什么时候用：需要看 exeVMInner handler/raw PC 序列时短跑；日志会很大，不适合作长期采集。
function __dyidre_mode_gum_exevm() {
// GumTrace + RustFrida launcher script.
//
// Target:
//   libmetasec_ml.so + 0x4cc10
//
// Device files:
//   /data/local/tmp/libGumTrace.so
//   /data/local/tmp/xx.js
//
// Run:
//   su -c 'cd /data/local/tmp && ./rustfrida --spawn com.ss.android.ugc.aweme -l xx.js'

var TARGET_MODULE = "libmetasec_ml.so";
var TARGET_OFFSET = 0x4cc10;
var GUMTRACE_SO = "/data/local/tmp/libGumTrace.so";
var TRACE_FILE = "/data/data/com.ss.android.ugc.aweme/gumtrace_4cc10.log";

// GumTrace options:
//   0 = Stand
//   1 = DEBUG
//   2 = STABLE
var GUMTRACE_MODE = 2;

var gumtraceLoaded = false;
var gumtraceInit = null;
var gumtraceRun = null;
var gumtraceUnrun = null;

var installed = false;
var tracing = false;
var tracedOnce = false;
var listener = null;

function log(s) {
    console.log("[gumtrace-4cc10] " + s);
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

function installAtBase(base) {
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

            log("hit target; x0=" + args[0] + " x1=" + args[1] + " x2=" + args[2] + " x3=" + args[3] + " lr=" + ptr(this.x30));
            if (!startTrace()) {
                tracing = false;
                this.doTrace = false;
                log("startTrace failed");
                return;
            }
            log("trace started");
        },
        onLeave: function (retval) {
            if (!this.doTrace) {
                return;
            }

            log("leave target ret=" + retval);
            stopTrace();
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

function waitForTargetModule() {
    var base = Module.findBaseAddress(TARGET_MODULE);
    if (base !== null) {
        installAtBase(base);
        return;
    }

    var dlopen = Module.findExportByName(null, "android_dlopen_ext");
    if (dlopen === null) {
        dlopen = Module.findExportByName(null, "dlopen");
    }
    if (dlopen === null) {
        log("cannot find dlopen/android_dlopen_ext");
        return;
    }

    log("waiting for " + TARGET_MODULE);
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
            if (this.path.indexOf(TARGET_MODULE) < 0) {
                return;
            }

            log("dlopen loaded: " + this.path);
            var loadedBase = Module.findBaseAddress(TARGET_MODULE);
            if (loadedBase === null) {
                log("loaded but base still null");
                return;
            }
            installAtBase(loadedBase);
        }
    });
}

waitForTargetModule();

}

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
    var base = Module.findBaseAddress(TARGET_MODULE);
    if (base !== null) {
        installAtBase(base);
        return;
    }

    var dlopen = Module.findExportByName(null, "android_dlopen_ext");
    if (dlopen === null) {
        dlopen = Module.findExportByName(null, "dlopen");
    }
    if (dlopen === null) {
        log("cannot find dlopen/android_dlopen_ext");
        return;
    }

    log("waiting for " + TARGET_MODULE);
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
            if (this.path.indexOf(TARGET_MODULE) < 0) {
                return;
            }

            log("dlopen loaded: " + this.path);
            var loadedBase = Module.findBaseAddress(TARGET_MODULE);
            if (loadedBase === null) {
                log("loaded but base still null");
                return;
            }
            installAtBase(loadedBase);
        }
    });
}

waitForTargetModule();

}

// ===== mode: artcheck / 检测面检查 =====
// 历史来源：artmethod_maps_check.js
// 什么时候用：确认 Frida/ArtMethod/maps 是否留下异常痕迹；用于判断“注入崩/被识别”是不是检测面问题。
function __dyidre_mode_artcheck() {
function jsonBigInt(obj) {
  try {
    return JSON.stringify(obj, function (_k, v) {
      return typeof v === "bigint" ? "0x" + v.toString(16) : v;
    });
  } catch (e) {
    return String(obj);
  }
}

function dumpArt(tag) {
  try {
    var st = Java._artRouteStats();
    console.log("[artcheck][" + tag + "] stats=" + jsonBigInt(st));
  } catch (e) {
    console.log("[artcheck][" + tag + "] _artRouteStats failed: " + e);
  }

  try {
    Java._artRouterDebug();
    console.log("[artcheck][" + tag + "] _artRouterDebug ok");
  } catch (e) {
    console.log("[artcheck][" + tag + "] _artRouterDebug failed: " + e);
  }
}

Java.ready(function () {
  console.log("[artcheck] Java ready");

  try {
    console.log("[artcheck] stealth before=" + Java.getStealth());
  } catch (e) {
    console.log("[artcheck] Java.getStealth failed: " + e);
  }

  try {
    Java["set" + "Stealth"](Hook.WXSHADOW);
    console.log("[artcheck] stealth after=" + Java.getStealth());
  } catch (e) {
    console.log("[artcheck] Java.setStealth(WXSHADOW) failed: " + e);
  }

  dumpArt("before-hook");

  try {
    var JN = Java.use("J.N");
    var MnXVOzVo = JN.MnXVOzVo.overload(
      "java.lang.Object",
      "long",
      "java.lang.String",
      "int",
      "int",
      "boolean",
      "boolean",
      "boolean",
      "int",
      "boolean",
      "int",
      "int",
      "long"
    );

    MnXVOzVo.impl = function (
      a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12
    ) {
      console.log("[artcheck][hit] url=" + url);
      return this.$orig(a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
    };

    console.log("[artcheck] hook installed: J.N.MnXVOzVo");
  } catch (e) {
    console.log("[artcheck] hook install failed: " + e);
  }

  dumpArt("after-hook");
});

}

// ===== mode: stackplz-bridge / RF 到 stackplz 的桥 =====
// 历史来源：rf_stackplz_hwbrk_bridge.js
// 什么时候用：RF 常驻后，把硬件断点/watch 请求转发给 stackplz dev RPC，用来拿堆栈和寄存器。
function __dyidre_mode_stackplz_bridge() {
// rustFrida -> stackplz hardware-breakpoint bridge for dyidre 350101.
//
// Source:
//   Hand-written bridge after validating stackplz dev RPC mode.
//
// Goal:
//   RF knows target module base inside the process. stackplz knows how to set
//   hardware break/watch points and print stack/regs. This script connects both:
//   host -> RF HTTP RPC -> this JS -> stackplz RPC socket.
//
// Install:
//   curl -s -X POST http://127.0.0.1:19191/rpc/0/metaprobeinstall \
//     -H 'Content-Type: application/json' -d '["stackplz-bridge"]'
//
// Exported RPC:
//   stackplzmodule(moduleName)
//   stackplzset(absAddr, type, pid, len, port)
//   stackplzbreakmodule(moduleName, offset, type, pid, len, port)
//
// Output:
//   stackplz writes /data/local/tmp/stackplz_hwbrk_rf_<tag>.log.

(function () {
    if (globalThis.__rfStackplzBridgeInstalled) {
        console.log("[rf-stackplz] bridge already installed");
        return "already-installed";
    }
    globalThis.__rfStackplzBridgeInstalled = true;

    function log(s) {
        console.log("[rf-stackplz] " + s);
    }

    function num(v) {
        if (typeof v === "bigint") return Number(v);
        return Number(v);
    }

    function hexPtr(v) {
        return ptr(v).toString();
    }

    function parsePort(v) {
        var n = v === undefined || v === null ? 41718 : Number(v);
        if (!(n > 0 && n < 65536)) throw new Error("bad port: " + v);
        return n;
    }

    function htons(v) {
        return ((v & 0xff) << 8) | ((v >>> 8) & 0xff);
    }

    function ipv4Le(ip) {
        var p = String(ip || "127.0.0.1").split(".");
        if (p.length !== 4) throw new Error("only IPv4 is supported: " + ip);
        return (Number(p[0]) & 255) |
            ((Number(p[1]) & 255) << 8) |
            ((Number(p[2]) & 255) << 16) |
            ((Number(p[3]) & 255) << 24);
    }

    var libc = "libc.so";
    var socketFn = new NativeFunction(Module.findExportByName(libc, "socket"), "int", ["int", "int", "int"]);
    var connectFn = new NativeFunction(Module.findExportByName(libc, "connect"), "int", ["int", "pointer", "int"]);
    var writeFn = new NativeFunction(Module.findExportByName(libc, "write"), "ssize_t", ["int", "pointer", "size_t"]);
    var readFn = new NativeFunction(Module.findExportByName(libc, "read"), "ssize_t", ["int", "pointer", "size_t"]);
    var closeFn = new NativeFunction(Module.findExportByName(libc, "close"), "int", ["int"]);

    function writeAll(fd, p, len) {
        var off = 0;
        while (off < len) {
            var n = num(writeFn(fd, p.add(off), len - off));
            if (n <= 0) throw new Error("write failed at " + off + "/" + len + ", ret=" + n);
            off += n;
        }
    }

    function readAll(fd, p, len) {
        var off = 0;
        while (off < len) {
            var n = num(readFn(fd, p.add(off), len - off));
            if (n <= 0) throw new Error("read failed at " + off + "/" + len + ", ret=" + n);
            off += n;
        }
    }

    function sendStackplzBrk(options, host, port) {
        host = host || "127.0.0.1";
        port = parsePort(port);

        var fd = socketFn(2, 1, 0); // AF_INET, SOCK_STREAM
        if (fd < 0) throw new Error("socket() failed ret=" + fd);

        try {
            var sa = Memory.alloc(16);
            sa.writeU16(2);                  // sin_family = AF_INET
            sa.add(2).writeU16(htons(port)); // sin_port, network byte order
            sa.add(4).writeU32(ipv4Le(host)); // sin_addr

            var cr = connectFn(fd, sa, 16);
            if (cr !== 0) throw new Error("connect(" + host + ":" + port + ") failed ret=" + cr);

            var payload = JSON.stringify(options);
            var lenBuf = Memory.alloc(4);
            lenBuf.writeU32(payload.length);
            writeAll(fd, lenBuf, 4);

            var payloadBuf = Memory.allocUtf8String(payload);
            writeAll(fd, payloadBuf, payload.length);

            var respLenBuf = Memory.alloc(4);
            readAll(fd, respLenBuf, 4);
            var respLen = Number(respLenBuf.readU32());
            if (respLen <= 0 || respLen > 65536) throw new Error("bad response length: " + respLen);

            var respBuf = Memory.alloc(respLen + 1);
            readAll(fd, respBuf, respLen);
            var text = respBuf.readUtf8String();
            try {
                return JSON.parse(text);
            } catch (_) {
                return { status: "raw", msg: text };
            }
        } finally {
            closeFn(fd);
        }
    }

    function normalizeType(t) {
        t = t || "x";
        if (t !== "x" && t !== "r" && t !== "w" && t !== "rw") {
            throw new Error("bad brk type: " + t);
        }
        return t;
    }

    function setHwBrkAbsolute(absAddr, brkType, brkPid, brkLen, port) {
        var opts = {
            brk_pid: brkPid === undefined || brkPid === null ? -1 : Number(brkPid),
            brk_len: brkLen === undefined || brkLen === null ? 4 : Number(brkLen),
            brk_type: normalizeType(brkType),
            brk_addr: hexPtr(absAddr)
        };
        log("send " + JSON.stringify(opts));
        return sendStackplzBrk(opts, "127.0.0.1", port);
    }

    function setHwBrkModule(moduleName, offset, brkType, brkPid, brkLen, port) {
        var m = Process.findModuleByName(moduleName);
        if (m === null) throw new Error("module not found: " + moduleName);
        var target = m.base.add(offset);
        var resp = setHwBrkAbsolute(target, brkType, brkPid, brkLen, port);
        return {
            module: moduleName,
            base: m.base.toString(),
            path: m.path,
            offset: String(offset),
            address: target.toString(),
            response: resp
        };
    }

    var old = rpc.exports || {};
    old.stackplzset = setHwBrkAbsolute;
    old.stackplzbreakmodule = setHwBrkModule;
    old.stackplzmodule = function (moduleName) {
        var m = Process.findModuleByName(moduleName);
        if (m === null) return null;
        return { name: m.name, base: m.base.toString(), size: m.size, path: m.path };
    };
    rpc.exports = old;

    log("bridge installed; call /rpc/0/stackplzbreakmodule with [module, offset, type, brk_pid, len, port]");
    return "ok";
})();

}

// ===== mode: ssl / sscronet + ttboringssl 抓包辅助 =====
// 历史来源：z/ida_dy0628/ww240.js#hookSSL / mm / dlopentodo / hookCallBack。
// 什么时候用：重新抓包时，先确认 sscronet 证书校验/明文 TLS 路径是否还能被当前版本命中。
//
// 默认策略：
//   1. 监听 libttboringssl.so 加载；
//   2. hook SSL_CTX_set_custom_verify / SSL_set_custom_verify，记录并包裹 custom verify callback；
//   3. callback 会先调用原始校验，再按 ww240.js 老逻辑强制返回 0；
//   4. hook SSL_write / SSL_read 打印少量 TLS 明文预览；
//   5. hook libttcrypto.so 的 BIO_write/BIO_write_all/BIO_flush/CBB_flush，作为旧 hookSSL 里
//      libcrypto.so offset 的新版本替代；
//   6. 如果导出 SSL_CTX_new + SSL_CTX_set_keylog_callback，安装 keylog callback，方便 Wireshark 解密。
//
// 注意：
//   ww240.js 里对系统 libcrypto.so 的 CBB_flush/BIO_write 等 offset 是强版本相关的，
//   这里默认不启用；需要完全复现旧脚本时可配置：
//     globalThis.METASEC_PROBE_CONFIG = {
//       mode: "ssl",
//       ssl: { legacyOffsets: true }
//     };
//
// rustFrida 兼容：
//   老 Frida 写法依赖 NativeCallback；当前 RF QuickJS 没暴露 NativeCallback，
//   但 RF 支持 Interceptor.replace(target, function (...) { this.$orig(...) })。
//   所以下面的 custom verify setter/callback 会优先走 NativeCallback，
//   没有 NativeCallback 时走 RF JS replace，语义仍对齐 dlopentodo():
//     SSL_CTX_set_custom_verify(ctx, mode, cb) -> original(ctx, 0, cb)
//     cb(ssl, outAlert) -> original(ssl, outAlert); return 0
function __dyidre_mode_ssl() {
(function () {
    var TARGET_SSL = "libttboringssl.so";
    var TARGET_CRYPTO = "libttcrypto.so";
    var TARGET_CRONET = "libsscronet.so";

    var rootCfg = globalThis.METASEC_PROBE_CONFIG || {};
    var cfg = rootCfg.ssl || {};
    var state = globalThis.__dyidreSslProbe350101 || {
        installed: false,
        dlopenHooked: false,
        modules: {},
        hooked: {},
        callbackHooked: {},
        callbackRefs: [],
        replacements: [],
        counts: {},
        events: [],
        options: {}
    };
    globalThis.__dyidreSslProbe350101 = state;

    state.options = {
        customVerify: cfg.customVerify === undefined ? true : !!cfg.customVerify,
        forceVerifyOk: cfg.forceVerifyOk === undefined ? true : !!cfg.forceVerifyOk,
        // SSL 采集默认走普通 inline replace；WXSHADOW 只在专门验证时打开。
        // JNI/Art 模式仍由各自的 Java.setStealth(WXSHADOW) 控制。
        stealth: cfg.stealth === undefined ? false : !!cfg.stealth,
        logIo: cfg.logIo === undefined ? true : !!cfg.logIo,
        logBio: cfg.logBio === undefined ? true : !!cfg.logBio,
        logSysWrite: cfg.logSysWrite === undefined ? false : !!cfg.logSysWrite,
        keylog: cfg.keylog === undefined ? true : !!cfg.keylog,
        legacyOffsets: cfg.legacyOffsets === undefined ? false : !!cfg.legacyOffsets,
        maxBytes: cfg.maxBytes || 192,
        maxEvents: cfg.maxEvents || 256,
        maxConsolePerKind: cfg.maxConsolePerKind || 40
    };

    function log(s) {
        try {
            console.log("[metassl] " + String(s));
        } catch (_) {}
    }

    function inc(k) {
        k = String(k);
        state.counts[k] = (state.counts[k] || 0) + 1;
    }

    function countOf(k) {
        return state.counts[String(k)] || 0;
    }

    function logHit(k, s) {
        var n = countOf(k);
        var limit = state.options.maxConsolePerKind;
        if (n <= limit || (n > 0 && (n & (n - 1)) === 0)) {
            log(s + " hit=" + n);
        }
    }

    function isNull(p) {
        try {
            var q = ptr(p);
            if (q.toString() === "0x0") return true;
            if (typeof q.isNull === "function") return q.isNull();
            return false;
        } catch (_) {
            return true;
        }
    }

    function toNum(v) {
        try {
            if (typeof v === "number") return v;
            return parseInt(ptr(v).toString(), 16);
        } catch (_) {
            return 0;
        }
    }

    function hex(v) {
        try {
            if (v === null || v === undefined) return String(v);
            return ptr(v).toString();
        } catch (_) {
            return String(v);
        }
    }

    function rel(base, p) {
        try {
            var n = toNum(p);
            var b = toNum(base);
            if (n >= b && n < b + 0x8000000) {
                return "0x" + (n - b).toString(16);
            }
            return hex(p);
        } catch (_) {
            return hex(p);
        }
    }

    function moduleAt(p) {
        try {
            var m = Process.findModuleByAddress(ptr(p));
            if (m === null) return null;
            return m.name + "+" + rel(m.base, p);
        } catch (_) {
            return null;
        }
    }

    function lrOf(ctx) {
        try {
            if (ctx && ctx.lr !== undefined) {
                return moduleAt(ctx.lr) || hex(ctx.lr);
            }
        } catch (_) {}
        return "unknown";
    }

    function hasNativeCallback() {
        return typeof NativeCallback === "function";
    }

    function replaceStealth(target, replacement) {
        if (state.options.stealth &&
            typeof Hook !== "undefined" && Hook.WXSHADOW !== undefined) {
            return Interceptor.replace(target, replacement, Hook.WXSHADOW);
        }
        return Interceptor.replace(target, replacement);
    }

    function callOrig(ctxObj, args) {
        // RF replace 回调实际形态是 function(ctx)：
        //   ctx.x0..ctx.x30 是寄存器，ctx.$orig(...) 才能调用原函数。
        // 官方 Frida/NativeCallback 路径不会走这里。
        if (ctxObj && typeof ctxObj.$orig === "function") {
            return ctxObj.$orig.apply(ctxObj, args || []);
        }
        throw new Error("ctx.$orig is not available in this runtime");
    }

    function record(ev) {
        if (state.events.length < state.options.maxEvents) {
            state.events.push(ev);
        }
    }

    function byteToNumber(v) {
        try {
            if (typeof v === "bigint") return Number(v & 0xffn);
            return Number(v) & 0xff;
        } catch (_) {
            return 0;
        }
    }

    function readBytesPreview(p, len) {
        var max = state.options.maxBytes;
        var n = toNum(len);
        if (n < 0) n = 0;
        if (n > max) n = max;
        if (n <= 0 || isNull(p)) {
            return { len: toNum(len), shown: 0, hex: "", ascii: "" };
        }
        try {
            var hs = [];
            var as = [];
            var q = ptr(p);
            for (var i = 0; i < n; i++) {
                // RF QuickJS 下 Memory.readByteArray -> Uint8Array 偶尔拿不到内容；
                // 逐字节 readU8 更慢一点，但抓包 preview 足够稳。
                var b = byteToNumber(Memory.readU8(q.add(i)));
                hs.push(("0" + b.toString(16)).slice(-2));
                as.push((b >= 0x20 && b <= 0x7e) ? String.fromCharCode(b) : ".");
            }
            return { len: toNum(len), shown: n, hex: hs.join(" "), ascii: as.join("") };
        } catch (e) {
            return { len: toNum(len), shown: 0, error: String(e) };
        }
    }

    function findExport(moduleName, symbol) {
        try {
            return Module.findExportByName(moduleName, symbol);
        } catch (_) {
            return null;
        }
    }

    function rememberModule(name) {
        try {
            var m = Process.findModuleByName(name);
            if (m !== null) {
                state.modules[name] = { base: m.base.toString(), size: m.size, path: m.path };
                return m;
            }
        } catch (_) {}
        return null;
    }

    function hookExportAttach(moduleName, symbol, callbacks) {
        var key = moduleName + "!" + symbol + "!attach";
        if (state.hooked[key]) return "already";
        var p = findExport(moduleName, symbol);
        if (p === null) return "missing";
        try {
            Interceptor.attach(p, callbacks);
            state.hooked[key] = true;
            log("hook attach " + moduleName + "!" + symbol + " @" + p);
            return "ok";
        } catch (e) {
            log("hook attach failed " + moduleName + "!" + symbol + " @" + p + ": " + e);
            return "failed:" + e;
        }
    }

    function hookSslIo(moduleName) {
        if (!state.options.logIo) return;

        // hookExportAttach(moduleName, "SSL_write", {
        //     onEnter: function (args) {
        //         inc(moduleName + ".SSL_write");
        //         var preview = readBytesPreview(args[1], args[2]);
        //         var ev = {
        //             api: moduleName + "!SSL_write",
        //             ssl: hex(args[0]),
        //             len: toNum(args[2]),
        //             lr: lrOf(this.context),
        //             data: preview
        //         };
        //         record(ev);
        //         this.__dyidreSslKind = moduleName + ".SSL_write";
        //         logHit(this.__dyidreSslKind, "SSL_write len=" + ev.len + " lr=" + ev.lr +
        //             (preview.error ? " error=" + preview.error : " ascii=" + JSON.stringify(preview.ascii || "")));
        //     },
        //     onLeave: function (retval) {
        //         inc(moduleName + ".SSL_write.ret");
        //         logHit(moduleName + ".SSL_write.ret", "SSL_write ret=" + retval);
        //     }
        // });

        // hookExportAttach(moduleName, "SSL_read", {
        //     onEnter: function (args) {
        //         this.buf = args[1];
        //         this.want = args[2];
        //         this.ssl = args[0];
        //         this.lrText = lrOf(this.context);
        //     },
        //     onLeave: function (retval) {
        //         var n = toNum(retval);
        //         inc(moduleName + ".SSL_read");
        //         if (n <= 0) {
        //             logHit(moduleName + ".SSL_read", "SSL_read ret=" + retval + " lr=" + this.lrText);
        //             return;
        //         }
        //         var preview = readBytesPreview(this.buf, n);
        //         var ev = {
        //             api: moduleName + "!SSL_read",
        //             ssl: hex(this.ssl),
        //             ret: n,
        //             want: toNum(this.want),
        //             lr: this.lrText,
        //             data: preview
        //         };
        //         record(ev);
        //         logHit(moduleName + ".SSL_read", "SSL_read ret=" + n + " lr=" + this.lrText +
        //             (preview.error ? " error=" + preview.error : " ascii=" + JSON.stringify(preview.ascii || "")));
        //     }
        // });
    }

    function hookCryptoBio(moduleName) {
        if (!state.options.logBio) return;

        hookExportAttach(moduleName, "BIO_write", {
            onEnter: function (args) {
                inc(moduleName + ".BIO_write");
                var preview = readBytesPreview(args[1], args[2]);
                var ev = {
                    api: moduleName + "!BIO_write",
                    bio: hex(args[0]),
                    len: toNum(args[2]),
                    lr: lrOf(this.context),
                    data: preview
                };
                record(ev);
                logHit(moduleName + ".BIO_write", "BIO_write len=" + ev.len + " lr=" + ev.lr +
                    (preview.error ? " error=" + preview.error : " ascii=" + JSON.stringify(preview.ascii || "")));
            },
            onLeave: function (retval) {
                inc(moduleName + ".BIO_write.ret");
                logHit(moduleName + ".BIO_write.ret", "BIO_write ret=" + retval);
            }
        });

        hookExportAttach(moduleName, "BIO_write_all", {
            onEnter: function (args) {
                inc(moduleName + ".BIO_write_all");
                var preview = readBytesPreview(args[1], args[2]);
                var ev = {
                    api: moduleName + "!BIO_write_all",
                    bio: hex(args[0]),
                    len: toNum(args[2]),
                    lr: lrOf(this.context),
                    data: preview
                };
                record(ev);
                logHit(moduleName + ".BIO_write_all", "BIO_write_all len=" + ev.len + " lr=" + ev.lr +
                    (preview.error ? " error=" + preview.error : " ascii=" + JSON.stringify(preview.ascii || "")));
            },
            onLeave: function (retval) {
                inc(moduleName + ".BIO_write_all.ret");
                logHit(moduleName + ".BIO_write_all.ret", "BIO_write_all ret=" + retval);
            }
        });

        hookExportAttach(moduleName, "BIO_flush", {
            onEnter: function (args) {
                inc(moduleName + ".BIO_flush");
                logHit(moduleName + ".BIO_flush", "BIO_flush bio=" + args[0] + " lr=" + lrOf(this.context));
            },
            onLeave: function (retval) {
                inc(moduleName + ".BIO_flush.ret");
                logHit(moduleName + ".BIO_flush.ret", "BIO_flush ret=" + retval);
            }
        });

        hookExportAttach(moduleName, "CBB_flush", {
            onEnter: function (args) {
                inc(moduleName + ".CBB_flush");
                logHit(moduleName + ".CBB_flush", "CBB_flush cbb=" + args[0] + " lr=" + lrOf(this.context));
            },
            onLeave: function (retval) {
                inc(moduleName + ".CBB_flush.ret");
                logHit(moduleName + ".CBB_flush.ret", "CBB_flush ret=" + retval);
            }
        });
    }

    function hookSysWrite() {
        if (!state.options.logSysWrite) return;
        var key = "libc!write!attach";
        if (state.hooked[key]) return;
        var p = findExport(null, "write");
        if (p === null) return;
        try {
            Interceptor.attach(p, {
                onEnter: function (args) {
                    inc("libc.write");
                    var preview = readBytesPreview(args[1], args[2]);
                    record({
                        api: "libc!write",
                        fd: toNum(args[0]),
                        len: toNum(args[2]),
                        lr: lrOf(this.context),
                        data: preview
                    });
                    log("write fd=" + toNum(args[0]) + " len=" + toNum(args[2]) +
                        " lr=" + lrOf(this.context));
                }
            });
            state.hooked[key] = true;
            log("hook attach libc!write @" + p);
        } catch (e) {
            log("hook libc!write failed @" + p + ": " + e);
        }
    }

    function hookKeylog(moduleName) {
        if (!state.options.keylog) return;

        var key = moduleName + "!keylog";
        if (state.hooked[key]) return;

        var setKeylog = findExport(moduleName, "SSL_CTX_set_keylog_callback");
        var ctxNew = findExport(moduleName, "SSL_CTX_new");
        if (setKeylog === null || ctxNew === null) {
            log("keylog symbols missing in " + moduleName + ": SSL_CTX_new=" + ctxNew + " SSL_CTX_set_keylog_callback=" + setKeylog);
            return;
        }
        if (!hasNativeCallback()) {
            state.hooked[key] = "skipped-no-nativecallback";
            log("keylog skipped: NativeCallback is not available in this JS runtime");
            return;
        }

        var setKeylogFn = new NativeFunction(setKeylog, "void", ["pointer", "pointer"]);
        var keyLogCallback = new NativeCallback(function (ssl, line) {
            inc(moduleName + ".keylog");
            var text = "";
            try {
                text = ptr(line).readCString();
            } catch (e) {
                text = "<read-keylog-error:" + e + ">";
            }
            record({ api: moduleName + "!keylog", ssl: hex(ssl), line: text });
            log("KEYLOG " + text);
        }, "void", ["pointer", "pointer"]);
        state.callbackRefs.push(keyLogCallback);

        hookExportAttach(moduleName, "SSL_CTX_new", {
            onLeave: function (retval) {
                if (isNull(retval)) return;
                try {
                    setKeylogFn(retval, keyLogCallback);
                    inc(moduleName + ".SSL_CTX_new.keylog_set");
                    log("SSL_CTX_new ctx=" + retval + " -> keylog callback installed");
                } catch (e) {
                    log("SSL_CTX_new keylog install failed: " + e);
                }
            }
        });
        state.hooked[key] = true;
    }

    function hookCustomVerifyCallback(cb, source) {
        if (!state.options.customVerify || isNull(cb)) return;
        var key = hex(cb);
        if (state.callbackHooked[key]) return;

        if (!hasNativeCallback()) {
            try {
                replaceStealth(cb, function (ctx) {
                    var ssl = ctx && ctx.x0 !== undefined ? ctx.x0 : 0;
                    var outAlert = ctx && ctx.x1 !== undefined ? ctx.x1 : 0;
                    var oldRet = 0;
                    var oldErr = null;
                    try {
                        oldRet = callOrig(ctx);
                    } catch (e0) {
                        oldErr = String(e0);
                    }
                    inc("custom_verify_callback");
                    record({
                        api: "custom_verify_callback",
                        source: source,
                        callback: key,
                        ssl: hex(ssl),
                        outAlert: hex(outAlert),
                        originalRet: oldRet,
                        originalError: oldErr,
                        forcedRet: state.options.forceVerifyOk ? 0 : oldRet,
                        path: "rf-js-replace"
                    });
                    log("custom_verify_cb " + key + " source=" + source +
                        " original=" + oldRet + (oldErr ? " err=" + oldErr : "") +
                        (state.options.forceVerifyOk ? " -> force 0" : ""));
                    return state.options.forceVerifyOk ? 0 : oldRet;
                });
                state.callbackHooked[key] = "rf-js-replace";
                log("custom verify callback hooked " + key + " source=" + source + " path=rf-js-replace");
            } catch (e) {
                log("custom verify callback RF replace failed " + key + ": " + e);
            }
            return;
        }

        try {
            var originalCb = new NativeFunction(cb, "int", ["pointer", "pointer"]);
            var replacement = new NativeCallback(function (ssl, outAlert) {
                var oldRet = 0;
                var oldErr = null;
                try {
                    oldRet = originalCb(ssl, outAlert);
                } catch (e) {
                    oldErr = String(e);
                }
                inc("custom_verify_callback");
                record({
                    api: "custom_verify_callback",
                    source: source,
                    callback: key,
                    ssl: hex(ssl),
                    outAlert: hex(outAlert),
                    originalRet: oldRet,
                    originalError: oldErr,
                    forcedRet: state.options.forceVerifyOk ? 0 : oldRet,
                    path: "nativecallback-replace"
                });
                log("custom_verify_cb " + key + " source=" + source +
                    " original=" + oldRet + (oldErr ? " err=" + oldErr : "") +
                    (state.options.forceVerifyOk ? " -> force 0" : ""));
                return state.options.forceVerifyOk ? 0 : oldRet;
            }, "int", ["pointer", "pointer"]);

            Interceptor.replace(cb, replacement);
            state.callbackHooked[key] = "nativecallback-replace";
            state.callbackRefs.push(replacement);
            log("custom verify callback hooked " + key + " source=" + source);
        } catch (e) {
            log("custom verify callback hook failed " + key + ": " + e);
        }
    }

    function replaceCustomVerifySetter(moduleName, symbol) {
        if (!state.options.customVerify) return;
        var key = moduleName + "!" + symbol + "!replace";
        if (state.hooked[key]) return;

        var p = findExport(moduleName, symbol);
        if (p === null) {
            log(symbol + " missing in " + moduleName);
            return;
        }

        if (!hasNativeCallback()) {
            try {
                replaceStealth(p, function (ctx) {
                    var ctxOrSsl = ctx && ctx.x0 !== undefined ? ctx.x0 : 0;
                    var mode = ctx && ctx.x1 !== undefined ? ctx.x1 : 0;
                    var cb = ctx && ctx.x2 !== undefined ? ctx.x2 : 0;
                    inc(moduleName + "." + symbol);
                    var cbText = hex(cb);
                    record({
                        api: moduleName + "!" + symbol,
                        ctxOrSsl: hex(ctxOrSsl),
                        mode: toNum(mode),
                        callback: cbText,
                        action: state.options.forceVerifyOk ? "rf-js-call-original-mode-0-and-force-callback-0" : "rf-js-call-original-as-is"
                    });
                    logHit(moduleName + "." + symbol, symbol + " ctx/ssl=" + hex(ctxOrSsl) +
                        " mode=" + hex(mode) + " cb=" + cbText + " path=rf-js-replace");
                    hookCustomVerifyCallback(cb, moduleName + "!" + symbol);
                    if (state.options.forceVerifyOk) {
                        // 对齐 ww240.js#dlopentodo:
                        //   return custom_verify(arg1, 0, arg3)
                        // RF 这里改寄存器后无参 $orig()，避免 ABI 包装差异。
                        ctx.x1 = 0;
                        callOrig(ctx);
                        return;
                    }
                    callOrig(ctx);
                    return;
                });
                state.hooked[key] = "rf-js-replace";
                log("replace " + moduleName + "!" + symbol + " @" + p + " path=rf-js-replace");
            } catch (e) {
                log("RF replace failed " + moduleName + "!" + symbol + " @" + p + ": " + e + "; fallback attach-only");
                hookExportAttach(moduleName, symbol, {
                    onEnter: function (args) {
                        inc(moduleName + "." + symbol);
                        record({
                            api: moduleName + "!" + symbol,
                            ctxOrSsl: hex(args[0]),
                            mode: toNum(args[1]),
                            callback: hex(args[2]),
                            action: "attach-only-rf-replace-failed"
                        });
                        logHit(moduleName + "." + symbol, symbol + " attach-only ctx/ssl=" + args[0] +
                            " mode=" + args[1] + " cb=" + hex(args[2]));
                    }
                });
            }
            return;
        }

        try {
            var original = new NativeFunction(p, "void", ["pointer", "int", "pointer"]);
            var replacement = new NativeCallback(function (ctxOrSsl, mode, cb) {
                inc(moduleName + "." + symbol);
                var cbText = hex(cb);
                record({
                    api: moduleName + "!" + symbol,
                    ctxOrSsl: hex(ctxOrSsl),
                    mode: Number(mode),
                    callback: cbText,
                    action: state.options.forceVerifyOk ? "call-original-mode-0-and-force-callback-0" : "call-original-as-is"
                });
                logHit(moduleName + "." + symbol, symbol + " ctx/ssl=" + ctxOrSsl + " mode=" + mode + " cb=" + cbText);
                hookCustomVerifyCallback(cb, moduleName + "!" + symbol);
                if (state.options.forceVerifyOk) {
                    return original(ctxOrSsl, 0, cb);
                }
                return original(ctxOrSsl, mode, cb);
            }, "void", ["pointer", "int", "pointer"]);

            Interceptor.replace(p, replacement);
            state.hooked[key] = true;
            state.replacements.push(replacement);
            log("replace " + moduleName + "!" + symbol + " @" + p);
        } catch (e) {
            log("replace failed " + moduleName + "!" + symbol + " @" + p + ": " + e);
        }
    }

    function hookLegacySystemOffsets() {
        if (!state.options.legacyOffsets) return;

        var crypto = rememberModule("libcrypto.so");
        var ssl = rememberModule("libssl.so");
        if (crypto === null || ssl === null) {
            log("legacyOffsets enabled but system libcrypto/libssl not both loaded");
            return;
        }

        var offsets = {
            CBB_flush: 0xd17d8,
            BIO_flush: 0xcbe6c,
            BIO_write: 0xcbc38,
            BIO_write_all: 0xcbcd8,
            sock_write: 0xcf714
        };
        Object.keys(offsets).forEach(function (name) {
            var key = "libcrypto.so+" + name;
            if (state.hooked[key]) return;
            try {
                var target = crypto.base.add(offsets[name]);
                Interceptor.attach(target, {
                    onEnter: function (args) {
                        inc(key);
                        logHit(key, "legacy " + key + " hit @" + target + " lr=" + lrOf(this.context));
                    }
                });
                state.hooked[key] = true;
                log("legacy hook " + key + " @" + target);
            } catch (e) {
                log("legacy hook failed " + key + ": " + e);
            }
        });

        var flushKey = "libssl.so+ssl_write_buffer_flush";
        if (!state.hooked[flushKey]) {
            try {
                var flushTarget = ssl.base.add(0x2cdd4);
                Interceptor.attach(flushTarget, {
                    onEnter: function () {
                        inc(flushKey);
                        logHit(flushKey, "legacy " + flushKey + " hit @" + flushTarget + " lr=" + lrOf(this.context));
                    }
                });
                state.hooked[flushKey] = true;
                log("legacy hook " + flushKey + " @" + flushTarget);
            } catch (e) {
                log("legacy hook failed " + flushKey + ": " + e);
            }
        }
    }

    function installAll() {
        rememberModule(TARGET_CRONET);
        var tt = rememberModule(TARGET_SSL);
        var crypto = rememberModule(TARGET_CRYPTO);
        var sysSsl = rememberModule("libssl.so");
        rememberModule("libcrypto.so");

        if (tt !== null) {
            replaceCustomVerifySetter(TARGET_SSL, "SSL_CTX_set_custom_verify");
            replaceCustomVerifySetter(TARGET_SSL, "SSL_set_custom_verify");
            hookSslIo(TARGET_SSL);
            hookKeylog(TARGET_SSL);
        }

        if (crypto !== null) {
            // hookCryptoBio(TARGET_CRYPTO);
        }

        // 兼容老系统/老版本：如果系统 libssl 被使用，也打印 SSL_read/write。
        if (sysSsl !== null) {
            // hookSslIo("libssl.so");
        }

        hookSysWrite();
        hookLegacySystemOffsets();

        state.installed = true;
        return summary();
    }

    function hookDlopen() {
        if (state.dlopenHooked) return;
        state.dlopenHooked = true;

        function attachLoader(symbol) {
            var p = findExport(null, symbol);
            if (p === null) return;
            try {
                Interceptor.attach(p, {
                    onEnter: function (args) {
                        this.path = "";
                        try {
                            this.path = args[0].readCString();
                        } catch (_) {
                            this.path = "";
                        }
                    },
                    onLeave: function () {
                        var path = this.path || "";
                        if (path.indexOf(TARGET_SSL) >= 0 ||
                                path.indexOf(TARGET_CRYPTO) >= 0 ||
                                path.indexOf(TARGET_CRONET) >= 0 ||
                                path.indexOf("libssl.so") >= 0 ||
                                path.indexOf("libcrypto.so") >= 0) {
                            log(symbol + " loaded " + path);
                            installAll();
                        }
                    }
                });
                log("watch loader " + symbol + " @" + p);
            } catch (e) {
                log("watch loader failed " + symbol + ": " + e);
            }
        }

        attachLoader("android_dlopen_ext");
        attachLoader("dlopen");
    }

    function summary() {
        return {
            installed: state.installed,
            dlopenHooked: state.dlopenHooked,
            options: state.options,
            modules: state.modules,
            counts: state.counts,
            hooked: Object.keys(state.hooked).sort(),
            callbacks: Object.keys(state.callbackHooked).sort(),
            events: state.events
        };
    }

    var old = rpc.exports || {};
    old.metasslinstall = installAll;
    old.metasslsummary = summary;
    rpc.exports = old;

    hookDlopen();
    return installAll();
})();

}

// ===== unified controller / 统一调度器 =====
(function () {
    var VERSION = "350101";
    // 所有可安装 mode 的注册表。新增版本时优先复制这个表，再替换 offset 和版本名。
    var MODES = {
        "counter-one": { run: __dyidre_mode_counter_one, source: "metasec_probe_350101.js#counter-one", desc: "单请求调用计数 / 路径对齐" },
        "counter-multi": { run: __dyidre_mode_counter_multi, source: "metasec_probe_350101.js#counter-multi", desc: "多请求调用计数 / 稳定性对比" },
        "branch": { run: __dyidre_mode_branch, source: "metasec_probe_350101.js#branch", desc: "CF/branch 值级探针" },
        "true-env": { run: __dyidre_mode_true_env, source: "metasec_probe_350101.js#true-env", desc: "真机环境 + F8/X-Medusa 入参/输出" },
        "jnitrace": { run: __dyidre_mode_jnitrace, source: "metasec_probe_350101.js#jnitrace", desc: "WXSHADOW lite JNI 采集" },
        "xheader": { run: __dyidre_mode_xheader, source: "metasec_probe_350101.js#xheader", desc: "最终 X-* header TreeMap 写出" },
        "native-vmp": { run: __dyidre_mode_native_vmp, source: "metasec_probe_350101.js#native-vmp", desc: "native VMP 0x1f7860 局部验证" },
        "gum-exevm": { run: __dyidre_mode_gum_exevm, source: "metasec_probe_350101.js#gum-exevm", desc: "GumTrace exeVMInner +0x4cc10" },
        "gum-http": { run: __dyidre_mode_gum_http, source: "metasec_probe_350101.js#gum-http", desc: "GumTrace HTTP/sign inner +0x149ca8" },
        "ssl": { run: __dyidre_mode_ssl, source: "metasec_probe_350101.js#ssl", desc: "sscronet/libttboringssl 抓包辅助 / custom verify / SSL_read/write / keylog" },
        "artcheck": { run: __dyidre_mode_artcheck, source: "metasec_probe_350101.js#artcheck", desc: "ArtMethod/maps 检测面检查" },
        "stackplz-bridge": { run: __dyidre_mode_stackplz_bridge, source: "metasec_probe_350101.js#stackplz-bridge", desc: "RF -> stackplz RPC bridge" }
    };

    // 常用短别名。host runner 也有同一份白名单，二者要同步维护。
    var ALIASES = {
        "counter": "counter-one",
        "one": "counter-one",
        "multi": "counter-multi",
        "trueenv": "true-env",
        "env": "true-env",
        "jni": "jnitrace",
        "headers": "xheader",
        "treeput": "xheader",
        "vmp": "native-vmp",
        "exevm": "gum-exevm",
        "gum-4cc10": "gum-exevm",
        "http": "gum-http",
        "gum-http-full": "gum-http",
        "ssl-capture": "ssl",
        "capture": "ssl",
        "maps": "artcheck",
        "art": "artcheck",
        "stackplz": "stackplz-bridge"
    };

    function log(s) {
        console.log("[metasec-probe350] " + s);
    }

    function normalize(mode) {
        if (mode === undefined || mode === null || String(mode).length === 0) return "rpc";
        var m = String(mode).toLowerCase();
        return ALIASES[m] || m;
    }

    function modeList() {
        var out = [];
        Object.keys(MODES).sort().forEach(function (k) {
            out.push({ mode: k, source: MODES[k].source, desc: MODES[k].desc });
        });
        return out;
    }

    function installMode(mode) {
        // rpc 模式只暴露控制接口，不主动下 hook；适合 stackplz/eDBG 联动或反复试小 probe。
        var m = normalize(mode);
        if (m === "rpc") {
            log("rpc mode only; no hook installed");
            return { status: "ok", mode: "rpc", note: "call metaprobeinstall(mode) to install a probe" };
        }
        if (!Object.prototype.hasOwnProperty.call(MODES, m)) {
            throw new Error("unknown mode: " + mode + "; available=" + Object.keys(MODES).sort().join(","));
        }
        log("install mode=" + m + " source=" + MODES[m].source);
        var ret = MODES[m].run();
        return { status: "ok", mode: m, source: MODES[m].source, result: ret };
    }

    function installMany(modes) {
        if (modes === undefined || modes === null) return installMode("rpc");
        if (typeof modes === "string") {
            if (modes.indexOf(",") >= 0) modes = modes.split(",");
            else return installMode(modes);
        }
        if (!Array.isArray(modes)) return installMode(String(modes));
        var results = [];
        for (var i = 0; i < modes.length; i++) {
            results.push(installMode(modes[i]));
        }
        return results;
    }

    function moduleBase(name) {
        try {
            var p = Module.findBaseAddress(name);
            return p === null ? null : p.toString();
        } catch (e) {
            return "error:" + e;
        }
    }

    function safeString(v) {
        try {
            if (v === null) return null;
            if (v === undefined) return "undefined";
            return String(v);
        } catch (e) {
            return "<stringify-error:" + e + ">";
        }
    }

    // RPC 导出：host 可以在不重启 App 的情况下查询模块基址、安装 probe、拿 summary。
    var old = rpc.exports || {};
    old.metaprobeinfo = function () {
        return {
            version: VERSION,
            pid: (typeof Process !== "undefined" && Process.id) ? Process.id : null,
            modes: modeList(),
            metasec: moduleBase("libmetasec_ml.so"),
            art: moduleBase("libart.so"),
            libc: moduleBase("libc.so")
        };
    };
    old.metaprobemodes = modeList;
    old.metaprobeinstall = installMode;
    old.metaprobeinstallmany = installMany;
    old.ping = function () { return "pong"; };
    old.info = old.metaprobeinfo;
    old.findbase = function (name) { return moduleBase(name); };
    old.evalstr = function (expr) { return safeString(eval(expr)); };
    rpc.exports = old;

    // host runner 会在 runtime JS 头部写入 METASEC_PROBE_CONFIG；没写时默认只开 RPC。
    var cfg = globalThis.METASEC_PROBE_CONFIG || { mode: "rpc" };
    var selected = cfg.modes || cfg.mode || "rpc";
    log("loaded version=" + VERSION + " selected=" + JSON.stringify(selected));
    if (cfg.auto === false) {
        log("auto=false; waiting for RPC metaprobeinstall");
        return;
    }
    installMany(selected);
})();
