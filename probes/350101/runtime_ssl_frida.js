// Standalone SSL probe for Douyin 35.1.0 / versionCode 350101.
// Source of the hook logic: metasec_probe_350101.js#ssl.
// 抓包必须 spawn 冷启：frida -U -f com.ss.android.ugc.aweme -l runtime_ssl.js
//   不要 attach 到已运行进程：已建好并注册过 custom verify 的 SSL_CTX 直接
//   调用原 callback，不会经过 probe，等于抓不到。
// 默认 forceVerifyOk=true：probe 先调用原 custom verify callback（维持
//   Cronet/BoringSSL 内部状态），再把结果强制改成 0 (ssl_verify_ok) 放行 MITM。
// 只想观察不想改结果：
//   globalThis.METASEC_PROBE_CONFIG = { mode: "ssl", ssl: { forceVerifyOk: false } };

(function () {
    var cfg = globalThis.METASEC_PROBE_CONFIG || {};
    if (!cfg.ssl) cfg.ssl = {};
    globalThis.METASEC_PROBE_CONFIG = cfg;
})();

// ===== mode: ssl / sscronet + ttboringssl 抓包辅助 =====
// 历史来源：z/ida_dy0628/ww240.js#hookSSL / mm / dlopentodo / hookCallBack。
// 什么时候用：重新抓包时，先确认 sscronet 证书校验/明文 TLS 路径是否还能被当前版本命中。
//
// 默认策略：
//   1. 监听 libttboringssl.so 加载；
//   2. hook SSL_CTX_set_custom_verify / SSL_set_custom_verify，记录并包裹 custom verify callback；
//   3. callback 会先调用原始校验，并原样返回，用于学习/诊断 custom_verify 状态机；
//   4. hook SSL_write / SSL_read 打印少量 TLS 明文预览；
//   5. hook libttcrypto.so 的 BIO_write/BIO_write_all/BIO_flush/CBB_flush，作为旧 hookSSL 里
//      libcrypto.so offset 的新版本替代；
//   6. 如果导出 SSL_CTX_new + SSL_CTX_set_keylog_callback，安装 keylog callback，方便 Wireshark 解密。
//   7. 默认不做 libsscronet.so text patch，避免 loader 回调/握手状态机中的 ANR 风险。
//
// 注意：
//   ww240.js 里对系统 libcrypto.so 的 CBB_flush/BIO_write 等 offset 是强版本相关的，
//   这里默认不启用；需要完全复现旧脚本时可配置：
//     globalThis.METASEC_PROBE_CONFIG = {
//       mode: "ssl",
//       ssl: { legacyOffsets: true }
//     };
//
// Frida 17 实现：
//   custom verify setter/callback 使用 NativeFunction + NativeCallback，语义对齐 dlopentodo():
    //     SSL_CTX_set_custom_verify(ctx, mode, cb) -> original(ctx, mode, ProbeVerifyCb)
    //     ProbeVerifyCb(ssl, outAlert) -> original_cb(ssl, outAlert); return original_ret
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
	        ctxCallbacks: {},
	        sslCallbacks: {},
	        callbackFns: {},
	        callbackHooked: {},
	        callbackRefs: [],
	        replacements: [],
	        counts: {},
	        events: [],
	        options: {}
	    };
	    globalThis.__dyidreSslProbe350101 = state;
	    if (!state.modules) state.modules = {};
	    if (!state.hooked) state.hooked = {};
	    if (!state.ctxCallbacks) state.ctxCallbacks = {};
	    if (!state.sslCallbacks) state.sslCallbacks = {};
	    if (!state.callbackFns) state.callbackFns = {};
	    if (!state.callbackHooked) state.callbackHooked = {};
	    if (!state.callbackRefs) state.callbackRefs = [];
	    if (!state.replacements) state.replacements = [];
	    if (!state.counts) state.counts = {};
	    if (!state.events) state.events = [];

	    state.options = {
	        customVerify: cfg.customVerify === undefined ? true : !!cfg.customVerify,
        forceVerifyOk: cfg.forceVerifyOk === undefined ? true : !!cfg.forceVerifyOk,
	        logIo: cfg.logIo === undefined ? false : !!cfg.logIo,
	        logBio: cfg.logBio === undefined ? false : !!cfg.logBio,
	        logSysWrite: cfg.logSysWrite === undefined ? false : !!cfg.logSysWrite,
	        keylog: cfg.keylog === undefined ? false : !!cfg.keylog,
	        legacyOffsets: cfg.legacyOffsets === undefined ? false : !!cfg.legacyOffsets,
        // 仅适用于 runs/350101/libsscronet.so 已核对的 build：
        //   +0x3cedf0: mov w0, #1 -> #0
        //   +0x3cf17c: mov w0, #2 -> #0
        //   +0x3cf1b4: mov w0, #1 -> #0
        // 设为 false 可关闭；原始字节不匹配时自动跳过。
	        cronetReturnZeroPatch: !!cfg.cronetReturnZeroPatch,
	        cronetReturnZeroPatchRequested: !!cfg.cronetReturnZeroPatch,
	        sslCtxOffset: cfg.sslCtxOffset === undefined ? 0x68 : Number(cfg.sslCtxOffset),
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
	        var total = toNum(len);
	        var max = state.options.maxBytes || 192;
	        var n = total;
	        if (n < 0) n = 0;
	        if (n > max) n = max;
	        if (n <= 0 || isNull(p)) {
	            return { len: total, shown: 0, hex: "", ascii: "" };
	        }

	        try {
	            var q = ptr(p);
	            var hexParts = [];
	            var asciiParts = [];
	            for (var i = 0; i < n; i++) {
	                var b = byteToNumber(q.add(i).readU8());
	                hexParts.push(("0" + b.toString(16)).slice(-2));
	                asciiParts.push((b >= 0x20 && b <= 0x7e) ? String.fromCharCode(b) : ".");
	            }
	            return {
	                len: total,
	                shown: n,
	                hex: hexParts.join(" "),
	                ascii: asciiParts.join("")
	            };
	        } catch (e) {
	            return { len: total, shown: 0, error: String(e) };
	        }
	    }

    function readExactBytes(p, len) {
        var out = [];
        var q = ptr(p);
        for (var i = 0; i < len; i++) {
            out.push(q.add(i).readU8());
        }
        return out;
    }

    function bytesEqual(a, b) {
        if (!a || !b || a.length !== b.length) return false;
        for (var i = 0; i < a.length; i++) {
            if (a[i] !== b[i]) return false;
        }
        return true;
    }

    function bytesHex(bytes) {
        var parts = [];
        for (var i = 0; i < bytes.length; i++) {
            parts.push(("0" + (bytes[i] & 0xff).toString(16)).slice(-2));
        }
        return parts.join(" ");
    }

	    function findExport(moduleName, symbol) {
	        try {
	            if (moduleName !== null && moduleName !== undefined) {
	                var m = Process.findModuleByName(moduleName);
	                return m === null ? null : m.findExportByName(symbol);
	            }
	        } catch (_) {
	        }
	        try {
	            if (typeof Module.findGlobalExportByName === "function") {
	                return Module.findGlobalExportByName(symbol);
	            }
	        } catch (_) {
	        }
	        try {
	            if (typeof Module.findExportByName === "function") {
	                return Module.findExportByName(null, symbol);
	            }
	        } catch (_) {
	        }
	        return null;
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

    function verifyRetName(ret) {
        if (ret === 0) return "ok";
        if (ret === 1) return "invalid";
        if (ret === 2) return "retry";
        return "ret-" + ret;
    }

    // 优先用导出的 SSL_get_SSL_CTX（存在时最稳），找不到再退回按偏移读。
    // 0x68 默认值来自看雪 39.x 文章，350101 上若 miss 会走 missing 分支。
    var sslGetCtxFn = null; // null=未探测, false=该 so 无此导出
    function getSslGetCtxFn() {
        if (sslGetCtxFn === null) {
            var p = findExport(TARGET_SSL, "SSL_get_SSL_CTX");
            sslGetCtxFn = p === null ? false : new NativeFunction(p, "pointer", ["pointer"]);
        }
        return sslGetCtxFn;
    }

    function readSslCtx(ssl) {
        try {
            if (isNull(ssl)) return ptr(0);
            var fn = getSslGetCtxFn();
            if (fn !== false) {
                var c = fn(ptr(ssl));
                return (c === null || c === undefined) ? ptr(0) : ptr(c);
            }
            return ptr(ssl).add(state.options.sslCtxOffset).readPointer();
        } catch (e) {
            // 偏移路径失败时兜底再走导出路径一次
            try {
                var fn2 = getSslGetCtxFn();
                if (fn2 !== false) {
                    var c2 = fn2(ptr(ssl));
                    return (c2 === null || c2 === undefined) ? ptr(0) : ptr(c2);
                }
            } catch (_) {}
            return ptr(0);
        }
    }

    function getVerifyNativeFunction(cbText) {
        var key = String(cbText);
        if (!state.callbackFns[key]) {
            state.callbackFns[key] = new NativeFunction(ptr(key), "int", ["pointer", "pointer"]);
        }
        return state.callbackFns[key];
    }

    function rememberVerifyCallback(kind, obj, mode, cb, source) {
        if (isNull(cb)) return false;

        var objKey = hex(obj);
        var cbKey = hex(cb);
        var item = {
            callback: cbKey,
            mode: Number(mode),
            source: source,
            seen: (state.counts[source + ".register"] || 0) + 1
        };

        if (kind === "ctx") {
            state.ctxCallbacks[objKey] = item;
        } else {
            state.sslCallbacks[objKey] = item;
        }

        try {
            getVerifyNativeFunction(cbKey);
        } catch (e) {
            item.error = "NativeFunction failed: " + e;
            return false;
        }

        inc(source + ".register");
        record({
            api: source,
            kind: kind,
            object: objKey,
            mode: Number(mode),
            callback: cbKey,
            action: "registered-observe-only"
        });
        logHit(source + ".register", source + " " + kind + "=" + objKey +
            " mode=" + mode + " cb=" + cbKey + " action=probe-callback");
        return true;
    }

    function findOriginalVerifyCallback(ssl) {
        var sslKey = hex(ssl);
        var sslItem = state.sslCallbacks[sslKey];
        if (sslItem) {
            return { kind: "ssl", object: sslKey, ctx: "", item: sslItem };
        }

        var ctx = readSslCtx(ssl);
        var ctxKey = hex(ctx);
        var ctxItem = state.ctxCallbacks[ctxKey];
        if (ctxItem) {
            return { kind: "ctx", object: ctxKey, ctx: ctxKey, item: ctxItem };
        }

        return { kind: "missing", object: "", ctx: ctxKey, item: null };
    }

    function getProbeVerifyCallback() {
        if (state.probeVerifyCallback) return state.probeVerifyCallback;

        var probe = new NativeCallback(function (ssl, outAlert) {
            var found = findOriginalVerifyCallback(ssl);
            var ret = 1;
            var err = null;
            var cbText = "";

            if (found.item && found.item.callback) {
                cbText = found.item.callback;
                try {
                    ret = getVerifyNativeFunction(cbText)(ssl, outAlert);
                } catch (e) {
                    err = String(e);
                    ret = 1;
                }
            } else {
                err = "missing original callback; check load timing or sslCtxOffset";
            }

            // 抓包模式：原 cb 已先行调用以维持 BoringSSL/Cronet 内部状态，
            // 返回值在这里同步覆盖为 0 (ssl_verify_ok)，放行 MITM 证书。
            var returned = state.options.forceVerifyOk ? 0 : ret;

            inc("custom_verify_callback");
            record({
                api: "custom_verify_callback",
                kind: found.kind,
                object: found.object,
                ssl: hex(ssl),
                ctx: found.ctx,
                outAlert: hex(outAlert),
                callback: cbText,
                originalRet: ret,
                originalRetName: verifyRetName(ret),
                originalError: err,
                returned: returned,
                action: state.options.forceVerifyOk ? "force-ok" : "observe-only-return-original"
            });

            logHit("custom_verify_callback", "custom_verify_cb ssl=" + hex(ssl) +
                " ctx=" + found.ctx + " kind=" + found.kind +
                " cb=" + (cbText || "<missing>") +
                " ret=" + ret + "(" + verifyRetName(ret) + ")" +
                (err ? " err=" + err : "") +
                (state.options.forceVerifyOk ? " => FORCE 0(ok)" : ""));
            return returned;
        }, "int", ["pointer", "pointer"]);

        state.probeVerifyCallback = probe;
        state.callbackRefs.push(probe);
        return probe;
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

        try {
            var original = new NativeFunction(p, "void", ["pointer", "int", "pointer"]);
            var replacement = new NativeCallback(function (ctxOrSsl, mode, cb) {
                inc(moduleName + "." + symbol);
                var kind = symbol === "SSL_CTX_set_custom_verify" ? "ctx" : "ssl";
                var probeCb = getProbeVerifyCallback();
                var registered = !isNull(cb) &&
                    hex(cb) !== hex(probeCb) &&
                    rememberVerifyCallback(kind, ctxOrSsl, mode, cb, moduleName + "!" + symbol);
                var nextCb = registered ? probeCb : cb;
                record({
                    api: moduleName + "!" + symbol,
                    kind: kind,
                    object: hex(ctxOrSsl),
                    mode: Number(mode),
                    callback: hex(cb),
                    replacement: registered ? hex(nextCb) : hex(cb),
                    action: registered ? "call-original-with-probe-callback" : "call-original-as-is"
                });
                var nextMode = state.options.forceVerifyOk ? 0 : Number(mode);
                logHit(moduleName + "." + symbol, symbol + " " + kind + "=" + ctxOrSsl +
                    " mode=" + mode + (nextMode !== Number(mode) ? " ->0" : "") +
                    " cb=" + hex(cb) +
                    (registered ? " -> probe" : " -> original"));
                return original(ctxOrSsl, nextMode, nextCb);
            }, "void", ["pointer", "int", "pointer"]);

            Interceptor.replace(p, replacement);
            state.hooked[key] = true;
            state.replacements.push(replacement);
            log("replace " + moduleName + "!" + symbol + " @" + p);
        } catch (e) {
            log("replace failed " + moduleName + "!" + symbol + " @" + p + ": " + e);
        }
    }

    function hookVerifyResult(moduleName) {
        var key = moduleName + "!SSL_get_verify_result!attach";
        if (state.hooked[key]) return;

        var p = findExport(moduleName, "SSL_get_verify_result");
        if (p === null) {
            log("SSL_get_verify_result missing in " + moduleName);
            return;
        }

        try {
            Interceptor.attach(p, {
                onEnter: function (args) {
                    this.ssl = args[0];
                    this.ctx = readSslCtx(args[0]);
                },
                onLeave: function (retval) {
                    var ret = toNum(retval);
                    inc(moduleName + ".SSL_get_verify_result");
                    record({
                        api: moduleName + "!SSL_get_verify_result",
                        ssl: hex(this.ssl),
                        ctx: hex(this.ctx),
                        result: ret,
                        action: "observe-only-return-original"
                    });
                    logHit(moduleName + ".SSL_get_verify_result",
                        "SSL_get_verify_result ssl=" + hex(this.ssl) +
                        " ctx=" + hex(this.ctx) +
                        " result=" + ret);
                }
            });
            state.hooked[key] = true;
            log("hook attach " + moduleName + "!SSL_get_verify_result @" + p);
        } catch (e) {
            log("hook SSL_get_verify_result failed " + moduleName + " @" + p + ": " + e);
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

    function writeAarch64Instruction(target, bytes) {
        // Frida 17 会处理可写映射与 ARM64 的指令缓存同步。
        Memory.patchCode(target, bytes.length, function (code) {
            code.writeByteArray(bytes);
        });
        return "patchCode";
    }

    function installCronetReturnZeroPatch(cronet) {
        // if (!state.options.cronetReturnZeroPatch) return;
        if (cronet === null) {
            log("cronet return-zero patch waiting for " + TARGET_CRONET);
            return;
        }

        var patchKey = TARGET_CRONET + "!return-zero-patch";
        if (state.hooked[patchKey]) return;

        // 文件偏移与 RVA 相同：350101 libsscronet.so 的首个 r-x LOAD 段
        // p_offset == p_vaddr == 0。写完整的 mov 指令，而不是只改其中一个字节。
        var patches = [
            { rva: 0x3cedf0, original: [0x20, 0x00, 0x80, 0x52], patched: [0x00, 0x00, 0x80, 0x52], originalReturn: 1 },
            { rva: 0x3cf17c, original: [0x40, 0x00, 0x80, 0x52], patched: [0x00, 0x00, 0x80, 0x52], originalReturn: 2 },
            { rva: 0x3cf1b4, original: [0x20, 0x00, 0x80, 0x52], patched: [0x00, 0x00, 0x80, 0x52], originalReturn: 1 }
        ];
        var result = [];

        for (var i = 0; i < patches.length; i++) {
            var spec = patches[i];
            var target = cronet.base.add(spec.rva);
            var before;
            try {
                before = readExactBytes(target, spec.original.length);
            } catch (e0) {
                result.push({ rva: "0x" + spec.rva.toString(16), address: hex(target), status: "read-failed", error: String(e0) });
                log("cronet patch read failed +0x" + spec.rva.toString(16) + " @" + target + ": " + e0);
                continue;
            }

            if (bytesEqual(before, spec.patched)) {
                result.push({ rva: "0x" + spec.rva.toString(16), address: hex(target), status: "already-patched", before: bytesHex(before) });
                log("cronet patch already applied +0x" + spec.rva.toString(16) + " @" + target);
                continue;
            }
            if (!bytesEqual(before, spec.original)) {
                result.push({ rva: "0x" + spec.rva.toString(16), address: hex(target), status: "skipped-unexpected-bytes", before: bytesHex(before), expected: bytesHex(spec.original) });
                log("cronet patch skipped +0x" + spec.rva.toString(16) + " @" + target +
                    " before=" + bytesHex(before) + " expected=" + bytesHex(spec.original));
                continue;
            }

            try {
                var method = writeAarch64Instruction(target, spec.patched);
                var after = readExactBytes(target, spec.patched.length);
                if (!bytesEqual(after, spec.patched)) {
                    throw new Error("verification failed; after=" + bytesHex(after));
                }
                result.push({ rva: "0x" + spec.rva.toString(16), address: hex(target), status: "patched", fromReturn: spec.originalReturn, toReturn: 0, method: method });
                log("cronet patch +0x" + spec.rva.toString(16) + " @" + target +
                    " mov w0,#" + spec.originalReturn + " -> #0 via " + method);
            } catch (e1) {
                result.push({ rva: "0x" + spec.rva.toString(16), address: hex(target), status: "write-failed", error: String(e1) });
                log("cronet patch write failed +0x" + spec.rva.toString(16) + " @" + target + ": " + e1);
            }
        }

        state.hooked[patchKey] = true;
        state.cronetReturnZeroPatch = result;
    }

    function installAll() {
        var cronet = rememberModule(TARGET_CRONET);
        var tt = rememberModule(TARGET_SSL);
        var crypto = rememberModule(TARGET_CRYPTO);

        if (tt !== null) {
            // replaceCustomVerifySetter(TARGET_SSL, "SSL_CTX_set_custom_verify");
            // replaceCustomVerifySetter(TARGET_SSL, "SSL_set_custom_verify");
            // 低风险 observe attach：SSL_get_verify_result 命中计数，辅助诊断。
            // hookVerifyResult(TARGET_SSL);
            // 以下按 options 门控，默认关闭；在配置里打开即生效。
            // hookKeylog(TARGET_SSL);   // cfg.ssl.keylog=true（官方 Frida 有 NativeCallback）
            // hookSslIo(TARGET_SSL);    // cfg.ssl.logIo=true（需在 hookSslIo 内放开 hook 代码）
        }
        if (crypto !== null) {
            // hookCryptoBio(TARGET_CRYPTO); // cfg.ssl.logBio=true
        }
        // if (cronet !== null) {
        //     // 兜底：万一某条连接没走 custom_verify callback 路径，
        //     // patch Cronet 证书校验返回值放行。原始字节不匹配时自动跳过。
        //     installCronetReturnZeroPatch(cronet);
        // }
        installCronetReturnZeroPatch(cronet);

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
                        if (
                            path.indexOf(TARGET_SSL) >= 0 ||
                                path.indexOf(TARGET_CRYPTO) >= 0 ||
                                path.indexOf(TARGET_CRONET) >= 0 
                                // ||
                                // path.indexOf("libssl.so") >= 0 ||
                                // path.indexOf("libcrypto.so") >= 0
                            
                            ) {
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
            cronetReturnZeroPatch: state.cronetReturnZeroPatch || [],
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

(function () {
    console.log("[metassl] standalone loaded version=350101 source=runtime_ssl.js");
    __dyidre_mode_ssl();
})();
