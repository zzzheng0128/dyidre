// Standalone SSL probe for Douyin 35.1.0 / versionCode 350101.
// Source of the hook logic: metasec_probe_350101.js#ssl.
// Load directly with rustFrida/Frida: -l runtime_ssl.js

(function () {
    var cfg = globalThis.METASEC_PROBE_CONFIG || {};
    if (!cfg.ssl) cfg.ssl = { stealth: false };
    globalThis.METASEC_PROBE_CONFIG = cfg;
})();

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
//   7. 对已核对的 350101 libsscronet.so，将三个返回码 #1/#2/#1 改为 #0。
//      每个补丁都先验证原始完整指令；版本或文件不匹配时会跳过，绝不按 RVA 盲写。
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
        requireStealth: cfg.requireStealth === undefined ? !!cfg.stealth : !!cfg.requireStealth,
        logIo: cfg.logIo === undefined ? true : !!cfg.logIo,
        logBio: cfg.logBio === undefined ? true : !!cfg.logBio,
        logSysWrite: cfg.logSysWrite === undefined ? false : !!cfg.logSysWrite,
        keylog: cfg.keylog === undefined ? true : !!cfg.keylog,
        legacyOffsets: cfg.legacyOffsets === undefined ? false : !!cfg.legacyOffsets,
        // 仅适用于 runs/350101/libsscronet.so 已核对的 build：
        //   +0x3cedf0: mov w0, #1 -> #0
        //   +0x3cf17c: mov w0, #2 -> #0
        //   +0x3cf1b4: mov w0, #1 -> #0
        // 设为 false 可关闭；原始字节不匹配时自动跳过。
        cronetReturnZeroPatch: cfg.cronetReturnZeroPatch === undefined ? true : !!cfg.cronetReturnZeroPatch,
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
            try {
                return Interceptor.replace(target, replacement, Hook.WXSHADOW);
            } catch (e) {
                log("native WXSHADOW replace failed @" + target + ": " + e);
                if (state.options.requireStealth) throw e;
                log("native WXSHADOW fallback to normal replace @" + target);
            }
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

    // function readBytesPreview(p, len) {
    //     var max = state.options.maxBytes;
    //     var n = toNum(len);
    //     if (n < 0) n = 0;
    //     if (n > max) n = max;
    //     if (n <= 0 || isNull(p)) {
    //         return { len: toNum(len), shown: 0, hex: "", ascii: "" };
    //     }
    //     try {
    //         var hs = [];
    //         var as = [];
    //         var q = ptr(p);
    //         for (var i = 0; i < n; i++) {
    //             // RF QuickJS 下 Memory.readByteArray -> Uint8Array 偶尔拿不到内容；
    //             // 逐字节 readU8 更慢一点，但抓包 preview 足够稳。
    //             var b = byteToNumber(Memory.readU8(q.add(i)));
    //             hs.push(("0" + b.toString(16)).slice(-2));
    //             as.push((b >= 0x20 && b <= 0x7e) ? String.fromCharCode(b) : ".");
    //         }
    //         return { len: toNum(len), shown: n, hex: hs.join(" "), ascii: as.join("") };
    //     } catch (e) {
    //         return { len: toNum(len), shown: 0, error: String(e) };
    //     }
    // }

    // function readExactBytes(p, len) {
    //     var out = [];
    //     var q = ptr(p);
    //     for (var i = 0; i < len; i++) {
    //         out.push(byteToNumber(Memory.readU8(q.add(i))));
    //     }
    //     return out;
    // }

    function readBytesPreview(p, len) {
        var out = [];
        var q = ptr(p);
        for (var i = 0; i < len; i++) {
            out.push(q.add(i).readU8());
        }
        return out;
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
            if (typeof Module !== "undefined" && typeof Module.findExportByName === "function") {
                return Module.findExportByName(moduleName, symbol);
            }
        } catch (_) {}
        try {
            if (moduleName) {
                var m = Process.findModuleByName(moduleName);
                if (m !== null) {
                    if (typeof m.findExportByName === "function") {
                        return m.findExportByName(symbol);
                    }
                    if (typeof m.getExportByName === "function") {
                        try {
                            return m.getExportByName(symbol);
                        } catch (_) {}
                    }
                    if (typeof m.enumerateExports === "function") {
                        var exports = m.enumerateExports();
                        for (var i = 0; i < exports.length; i++) {
                            if (exports[i].name === symbol) return exports[i].address;
                        }
                    }
                }
                return null;
            }
        } catch (_) {}
        try {
            if (typeof Module !== "undefined" && typeof Module.findGlobalExportByName === "function") {
                return Module.findGlobalExportByName(symbol);
            }
        } catch (_) {}
        try {
            if (typeof Process !== "undefined" && typeof Process.enumerateModules === "function") {
                var modules = Process.enumerateModules();
                for (var j = 0; j < modules.length; j++) {
                    var mod = modules[j];
                    if (typeof mod.findExportByName === "function") {
                        var p = mod.findExportByName(symbol);
                        if (p !== null) return p;
                    }
                }
            }
        } catch (_) {}
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

    function writeAarch64Instruction(target, bytes) {
        // Memory.patchCode 会负责 icache 同步；这是 ARM64 写指令时优先使用的路径。
        if (typeof Memory.patchCode === "function") {
            Memory.patchCode(target, bytes.length, function (code) {
                Memory.writeByteArray(code, bytes);
            });
            return "patchCode";
        }

        // rustFrida 若未实现 patchCode，退回到临时改写当前页权限的方式。
        // 目标是 r-x 的 .text；写完立即恢复该保护属性。
        var oldProtection = "r-x";
        try {
            var range = Process.findRangeByAddress(target);
            if (range && range.protection) oldProtection = range.protection;
        } catch (_) {}
        Memory.protect(target, bytes.length, "rwx");
        Memory.writeByteArray(target, bytes);
        Memory.protect(target, bytes.length, oldProtection);
        return "protect-write-restore";
    }

    function installCronetReturnZeroPatch(cronet) {
        if (!state.options.cronetReturnZeroPatch) return;
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
        // var tt = rememberModule(TARGET_SSL);
        // var crypto = rememberModule(TARGET_CRYPTO);
        // var sysSsl = rememberModule("libssl.so");
        // rememberModule("libcrypto.so");

        // if (tt !== null) {
        //     // replaceCustomVerifySetter(TARGET_SSL, "SSL_CTX_set_custom_verify");
        //     // replaceCustomVerifySetter(TARGET_SSL, "SSL_set_custom_verify");
        //     // hookSslIo(TARGET_SSL);
        //     // hookKeylog(TARGET_SSL);
        // }

        installCronetReturnZeroPatch(cronet);

        // if (crypto !== null) {
        //     // hookCryptoBio(TARGET_CRYPTO); 
        // }

        // // 兼容老系统/老版本：如果系统 libssl 被使用，也打印 SSL_read/write。
        // if (sysSsl !== null) {
        //     // hookSslIo("libssl.so");
        // }

        // // hookSysWrite();
        // // hookLegacySystemOffsets();

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
