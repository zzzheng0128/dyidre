globalThis.METASEC_PROBE_CONFIG = {"mode": "packet-capture", "packet": {"uploadUrl": "http://127.0.0.1:8891/up/dy/packets", "version": "35.1.0", "taskName": "fullbody_wxshadow_anrguard_20260901_181933", "profile": "token", "nativeStealth": "wxshadow", "javaStealth": "wxshadow", "requireJavaStealth": true, "hookJN": false, "maxPending": 96, "maxQueue": 16, "maxBodyBytes": 262144, "hookStreams": true, "hookConnections": true, "uploadVia": "java", "uploadOnXm": true, "watchLoader": false, "captureBodies": true, "captureResponseBody": true, "copyResponseHeaders": true, "skipMainThread": true, "useThreadNames": false, "logUrlMax": 180, "connectTimeoutMs": 1500, "readTimeoutMs": 1500, "nativeOnly": false}};
Java.setStealth(Hook.WXSHADOW);
function __dyidre_mode_packet_capture() {
(function () {
    var VERSION_CODE = "350101";
    var VERSION_NAME = "35.1.0";
    var TARGET_MODULE = "libmetasec_ml.so";
    var HTTP_CALLBACK_OFF = 0x14dbf4;
    var URL_PREFIX = "com.ttnet.org.chromium.net.urlconnection.CronetHttpURLConnection:";

    var cfg = globalThis.METASEC_PROBE_CONFIG || {};
    var opt = cfg.packet || cfg.capture || {};

    var DEFAULT_WIDE_FILTERS = [
        "/device_register",
        "get_token",
        "ri/report?",
        "/app_log/",
        "/passport/account/info/v2/",
        "/passport/mobile/sms_login/",
        "/passport/ticket_guard/get_client_cert/",
        "/feed",
        "/location/info/",
        "/captcha/verify",
        "/captcha/get",
        "/send_code/",
        "/aweme/v1/commit/item/digg/",
        "/aweme/v1/commit/follow/user/",
        "/aweme/detail/",
        "/aweme/v1/create/aweme/",
        "/service/2/app_log/",
        "/aweme/v2/feed/",
        "api/preinstall_collect",
        "/luckycat/activity/",
        "/api/plugin/config/v2/?soc_platform",
        "/api/ad/splash/aweme/v14/",
        "/api/ad/v1/splash/stock/",
        "/service/settings/v3/",
        "/monitor/collect/batch/"
    ];
    var DEFAULT_TOKEN_FILTERS = [
        "get_token",
        "/passport/ticket_guard/get_client_cert/",
        "/device_register",
        "/captcha/verify",
        "/captcha/get"
    ];

    function defaultFiltersForProfile(profile) {
        var p = String(profile || "token").toLowerCase();
        if (p === "wide" || p === "full" || p === "all") return DEFAULT_WIDE_FILTERS;
        return DEFAULT_TOKEN_FILTERS;
    }

    function normalizeJavaStealthMode(v) {
        if (v === undefined || v === null || v === "") return "wxshadow";
        var s = String(v).toLowerCase();
        if (s === "1" || s === "true" || s === "on" || s === "yes" || s === "wxshadow" || s === "hook.wxshadow") {
            return "wxshadow";
        }
        if (s === "2" || s === "recomp" || s === "hook.recomp") {
            return "recomp";
        }
        if (s === "0" || s === "false" || s === "off" || s === "no" || s === "normal" || s === "none" || s === "hook.normal") {
            return "normal";
        }
        return s;
    }

    var state = globalThis.__metasecPacketCapture350101 || {
        installed: false,
        javaHooked: false,
        nativeHooked: false,
        loaderHooked: {},
        requestsByPtr: {},
        requests: [],
        uploadQueue: [],
        uploadWorkerRunning: false,
        fieldCache: {},
        stats: {
            created: 0,
            filtered: 0,
            requestBodyBytes: 0,
            responseBodyBytes: 0,
            xmHits: 0,
            xmMatched: 0,
            uploaded: 0,
            uploadStarted: 0,
            uploadQueued: 0,
            uploadDropped: 0,
            uploadFailed: 0,
            uploadOnXm: 0,
            hookSkippedMain: 0
        },
        events: []
    };
    globalThis.__metasecPacketCapture350101 = state;

    var packetProfile = String(opt.profile || "token").toLowerCase();
    state.options = {
        upload: opt.upload === undefined ? true : !!opt.upload,
        uploadUrl: String(opt.uploadUrl || "http://127.0.0.1:8891/up/dy/packets"),
        version: String(opt.version || VERSION_NAME),
        taskName: String(opt.taskName || "collect_frida"),
        type: String(opt.type || "hook"),
        source: String(opt.source || "frida"),
        profile: packetProfile,
        filterAll: !!opt.filterAll,
        filters: opt.filters || defaultFiltersForProfile(packetProfile),
        nativeStealth: normalizeJavaStealthMode(opt.nativeStealth || opt.stealth || "wxshadow"),
        javaStealth: normalizeJavaStealthMode(opt.javaStealth),
        requireJavaStealth: opt.requireJavaStealth === undefined ? false : !!opt.requireJavaStealth,
        maxPending: Number(opt.maxPending || 96),
        maxQueue: Number(opt.maxQueue || 16),
        maxBodyBytes: Number(opt.maxBodyBytes === undefined ? 256 * 1024 : opt.maxBodyBytes),
        hookJN: opt.hookJN === undefined ? false : !!opt.hookJN,
        hookStreams: opt.hookStreams === undefined ? false : !!opt.hookStreams,
        hookConnections: opt.hookConnections === undefined ? false : !!opt.hookConnections,
        uploadVia: String(opt.uploadVia || "java").toLowerCase(),
        uploadOnXm: opt.uploadOnXm === undefined ? true : !!opt.uploadOnXm,
        watchLoader: opt.watchLoader === undefined ? true : !!opt.watchLoader,
        captureBodies: opt.captureBodies === undefined ? false : !!opt.captureBodies,
        captureResponseBody: opt.captureResponseBody === undefined ? true : !!opt.captureResponseBody,
        copyResponseHeaders: opt.copyResponseHeaders === undefined ? true : !!opt.copyResponseHeaders,
        skipMainThread: opt.skipMainThread === undefined ? true : !!opt.skipMainThread,
        useThreadNames: !!opt.useThreadNames,
        printPackets: !!opt.printPackets,
        logUrlMax: Number(opt.logUrlMax || 180),
        connectTimeoutMs: Number(opt.connectTimeoutMs || 3000),
        readTimeoutMs: Number(opt.readTimeoutMs || 3000)
    };

    function log(s) {
        console.log("[packet350] " + s);
    }

    function addEvent(s) {
        state.events.push(Date.now() + " " + s);
        if (state.events.length > 80) state.events.shift();
    }

    function shortText(v, maxLen) {
        var s = safeString(v);
        var n = Number(maxLen || state.options.logUrlMax || 180);
        if (!s || n <= 0 || s.length <= n) return s;
        return s.substring(0, n) + "...(" + s.length + ")";
    }

    function safeString(v) {
        try {
            if (v === null) return null;
            if (v === undefined) return "";
            return String(v);
        } catch (e) {
            return "<string-error:" + e + ">";
        }
    }

    function toPlainNumber(v, fallback) {
        try {
            if (typeof v === "bigint") return Number(v);
            var n = Number(v);
            return isNaN(n) ? fallback : n;
        } catch (_) {
            return fallback;
        }
    }

    function desiredJavaStealthValue(mode) {
        if (mode === "wxshadow") {
            if (typeof Hook !== "undefined" && Hook !== null && Hook.WXSHADOW !== undefined) return Hook.WXSHADOW;
            return 1;
        }
        if (mode === "recomp") {
            if (typeof Hook !== "undefined" && Hook !== null && Hook.RECOMP !== undefined) return Hook.RECOMP;
            return 2;
        }
        return 0;
    }

    function desiredNativeHookValue(mode) {
        return desiredJavaStealthValue(mode);
    }

    function configureJavaStealth() {
        var mode = state.options.javaStealth;
        if (mode === "normal") {
            log("java stealth disabled for packet hooks");
            return true;
        }
        try {
            if (typeof Java === "undefined" || Java === null || typeof Java["set" + "Stealth"] !== "function") {
                throw new Error("Java.setStealth unavailable");
            }
            var desired = desiredJavaStealthValue(mode);
            var before = -1;
            try {
                if (typeof Java.getStealth === "function") before = toPlainNumber(Java.getStealth(), -1);
            } catch (_) {
                before = -1;
            }
            if (before !== toPlainNumber(desired, desired)) {
                Java["set" + "Stealth"](desired);
            }
            var after = before;
            try {
                if (typeof Java.getStealth === "function") after = toPlainNumber(Java.getStealth(), before);
            } catch (_) {
                after = before;
            }
            log("java stealth=" + mode + " before=" + before + " after=" + after);
            return true;
        } catch (e) {
            addEvent("java stealth failed mode=" + mode + ": " + e);
            log("Java.setStealth(" + mode + ") failed: " + e);
            if (state.options.requireJavaStealth) throw e;
            return false;
        }
    }

    function readCStringSafe(p, maxLen) {
        try {
            var q = ptr(p);
            if (q.isNull()) return "";
            return q.readCString(maxLen || 65536) || "";
        } catch (e) {
            return "";
        }
    }

    function currentThreadInfo() {
        if (!state.options.useThreadNames) {
            try {
                return "tid_" + Process.getCurrentThreadId();
            } catch (_) {
                return "tid_unknown";
            }
        }
        try {
            var Thread = state.threadClass || Java.use("java.lang.Thread");
            state.threadClass = Thread;
            var t = Thread.currentThread();
            return safeString(t.getName()) + "_" + safeString(t.getId());
        } catch (e) {
            try {
                return "tid_" + Process.getCurrentThreadId();
            } catch (_) {
                return "tid_unknown";
            }
        }
    }

    function isMainThread() {
        try {
            return Number(Process.getCurrentThreadId()) === Number(Process.id);
        } catch (_) {
            return false;
        }
    }

    function getFieldValue(obj, name) {
        if (!obj) return null;
        try {
            var cls = obj.getClass();
            while (cls) {
                var className = safeString(cls.getName ? cls.getName() : cls);
                var cacheKey = className + "#" + name;
                var cached = state.fieldCache[cacheKey];
                if (cached) {
                    try {
                        return cached.get(obj);
                    } catch (_) {
                        delete state.fieldCache[cacheKey];
                    }
                }
                try {
                    var f = cls.getDeclaredField(name);
                    f.setAccessible(true);
                    state.fieldCache[cacheKey] = f;
                    return f.get(obj);
                } catch (e) {
                    cls = cls.getSuperclass();
                    if (!cls) break;
                }
            }
        } catch (_) {
        }
        return null;
    }

    function urlFromConnection(conn) {
        var s = safeString(conn);
        if (!s) return "";
        if (s.indexOf(URL_PREFIX) === 0) return s.substring(URL_PREFIX.length);
        return s;
    }

    function extractPath(url) {
        var s = safeString(url);
        var m = s.match(/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\/[^\/?#]+([^?#]*)/);
        if (m) return m[1] || "/";
        return s.split("?")[0];
    }

    function isTargetUrl(url) {
        var s = safeString(url);
        if (!s) return false;
        if (s.indexOf("douyinpic.com") >= 0) return false;
        if (state.options.filterAll) return true;
        for (var i = 0; i < state.options.filters.length; i++) {
            if (s.indexOf(String(state.options.filters[i])) >= 0) return true;
        }
        return false;
    }

    function trimPending() {
        while (state.requests.length > state.options.maxPending) {
            var old = state.requests.shift();
            if (old && old.urlPtr) delete state.requestsByPtr[old.urlPtr];
        }
    }

    function newRequest(urlPtr, url) {
        var key = safeString(urlPtr);
        var req = {
            urlPtr: key,
            url: safeString(url),
            httpMethod: "",
            requestHeaders: {},
            responseHeaders: {},
            requestBodyHex: "",
            requestBodyCount: 0,
            responseBodyHex: "",
            curProcess: state.processName || "com.ss.android.ugc.aweme",
            curThread: currentThreadInfo(),
            requestStartTime: Date.now(),
            requestEndTime: 0,
            reportId: "",
            xms: "",
            requestBodyTruncated: false,
            responseBodyTruncated: false
        };
        state.requestsByPtr[key] = req;
        state.requests.push(req);
        trimPending();
        state.stats.created++;
        log("track ptr=" + key + " url=" + shortText(req.url));
        return req;
    }

    function matchUrlPtr(urlPtr) {
        return state.requestsByPtr[safeString(urlPtr)] || null;
    }

    function matchUrl(url, thread) {
        var s = safeString(url);
        if (!s) return null;
        for (var i = state.requests.length - 1; i >= 0; i--) {
            var req = state.requests[i];
            if (req && req.url === s && req.curThread === thread) return req;
        }
        for (var j = state.requests.length - 1; j >= 0; j--) {
            var req2 = state.requests[j];
            if (req2 && req2.url === s) return req2;
        }
        return null;
    }

    function ensureRequestForUrl(url, reason) {
        var s = safeString(url);
        if (!s || !isTargetUrl(s)) return null;
        var thread = currentThreadInfo();
        var req = matchUrl(s, thread);
        if (req) return req;
        req = newRequest("auto:" + Date.now() + ":" + state.stats.created, s);
        req.curThread = thread;
        addEvent("auto track " + safeString(reason) + " url=" + shortText(s));
        return req;
    }

    function matchXMUrl(nativeUrl) {
        var target = safeString(nativeUrl);
        if (!target) return null;
        for (var i = state.requests.length - 1; i >= 0; i--) {
            var req = state.requests[i];
            if (!req || !req.url) continue;
            var path = extractPath(req.url);
            if (path && path !== "/" && target.indexOf(path) >= 0) return req;
        }
        return null;
    }

    function removeRequest(req) {
        if (!req) return;
        if (req.urlPtr) delete state.requestsByPtr[req.urlPtr];
        for (var i = state.requests.length - 1; i >= 0; i--) {
            if (state.requests[i] === req) {
                state.requests.splice(i, 1);
                return;
            }
        }
    }

    function byteToHex(v) {
        v = Number(v);
        if (v < 0) v += 256;
        return (v < 16 ? "0" : "") + (v & 0xff).toString(16);
    }

    function javaByteArrayToHex(arr, off, len) {
        if (!arr) return "";
        off = Number(off) || 0;
        len = Number(len) || 0;
        if (off < 0 || len <= 0) return "";
        var total = 0;
        try { total = Number(arr.length); } catch (_) { total = off + len; }
        var end = Math.min(total || (off + len), off + len);
        var out = [];
        for (var i = off; i < end; i++) {
            out.push(byteToHex(arr[i]));
        }
        return out.join("");
    }

    function appendBodyHex(req, field, hex) {
        if (!req || !hex) return;
        var max = state.options.maxBodyBytes;
        var curBytes = Math.floor((req[field] || "").length / 2);
        var addBytes = Math.floor(hex.length / 2);
        if (max > 0 && curBytes >= max) {
            req[field === "requestBodyHex" ? "requestBodyTruncated" : "responseBodyTruncated"] = true;
            return;
        }
        if (max > 0 && curBytes + addBytes > max) {
            var remain = Math.max(0, max - curBytes);
            hex = hex.substring(0, remain * 2);
            addBytes = remain;
            req[field === "requestBodyHex" ? "requestBodyTruncated" : "responseBodyTruncated"] = true;
        }
        req[field] = (req[field] || "") + hex;
        if (field === "requestBodyHex") {
            req.requestBodyCount += addBytes;
            state.stats.requestBodyBytes += addBytes;
        } else {
            state.stats.responseBodyBytes += addBytes;
        }
    }

    function addHeader(req, key, value) {
        key = safeString(key);
        if (!req || !key) return;
        req.requestHeaders[key] = safeString(value);
    }

    function joinJavaList(listObj) {
        if (!listObj) return "";
        try {
            var it = listObj.iterator();
            var parts = [];
            while (it.hasNext()) parts.push(safeString(it.next()));
            return parts.join(",");
        } catch (e) {
            return safeString(listObj);
        }
    }

    function copyResponseHeaders(req, conn) {
        if (!state.options.copyResponseHeaders) return;
        if (!req || !conn || Object.keys(req.responseHeaders).length > 0) return;
        var map = getFieldValue(conn, "mResponseHeadersMap");
        if (!map) return;
        try {
            var it = map.entrySet().iterator();
            while (it.hasNext()) {
                var entry = it.next();
                var key = safeString(entry.getKey());
                var value = joinJavaList(entry.getValue());
                req.responseHeaders[key] = value;
            }
        } catch (e) {
            addEvent("response headers failed: " + e);
        }
    }

    function parseXmHeaders(xms) {
        var out = {};
        var text = safeString(xms);
        var lines = text.split(/\r\n|\n|\r/);
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            var idx = line.indexOf(":");
            if (idx > 0) out[line.substring(0, idx).trim()] = line.substring(idx + 1).trim();
        }
        if (Object.keys(out).length > 0) return out;

        var parts = text.replace(/\r\n/g, ",").replace(/\n/g, ",").replace(/\r/g, ",").split(",");
        for (var j = 0; j + 1 < parts.length; j += 2) {
            var key = String(parts[j] || "").trim();
            var value = String(parts[j + 1] || "").trim();
            if (key) out[key] = value;
        }
        return out;
    }

    function addXmHeaders(nativeUrl, xms) {
        state.stats.xmHits++;
        var req = matchXMUrl(nativeUrl);
        if (!req) {
            addEvent("xm no match url=" + shortText(nativeUrl));
            return;
        }
        var headers = parseXmHeaders(xms);
        Object.keys(headers).forEach(function (k) {
            req.requestHeaders[k] = headers[k];
        });
        req.xms = safeString(xms);
        state.stats.xmMatched++;
        log("xm matched url=" + shortText(req.url) + " keys=" + Object.keys(headers).join(","));
        if (state.options.uploadOnXm && !req.uploadQueued) {
            req.uploadQueued = true;
            state.stats.uploadOnXm++;
            uploadRequest(req);
            removeRequest(req);
        }
    }

    function md5Hex(text) {
        try {
            var MessageDigest = Java.use("java.security.MessageDigest");
            var md = MessageDigest.getInstance("MD5");
            var bytes = utf8Bytes(text || "");
            return javaByteArrayToHex(md.digest.overload("[B").call(md, bytes), 0, 16);
        } catch (e) {
            return "";
        }
    }

    function utf8Bytes(text) {
        var JString = Java.use("java.lang.String");
        var s = JString.$new(String(text || ""));
        return s.getBytes.overload("java.lang.String").call(s, "UTF-8");
    }

    function packetJson(req) {
        var extra = state.extraInfo || "";
        if (req.requestBodyTruncated || req.responseBodyTruncated) {
            extra += (extra ? " " : "") + "frida_truncated request=" + req.requestBodyTruncated + " response=" + req.responseBodyTruncated;
        }
        return JSON.stringify({
            version: state.options.version,
            version_code: VERSION_CODE,
            device_id: state.deviceId || "",
            url: req.url,
            method: req.httpMethod || "",
            headers: JSON.stringify(req.requestHeaders || {}),
            response_headers: JSON.stringify(req.responseHeaders || {}),
            raw_data: req.requestBodyHex || "",
            raw_data_md5: md5Hex(req.requestBodyHex || ""),
            response_data: req.responseBodyHex || "",
            process: req.curProcess || "",
            thread: req.curThread || "",
            request_start_time: req.requestStartTime || 0,
            request_end_time: req.requestEndTime || Date.now(),
            net_type: "http",
            from: state.options.source,
            type: state.options.type,
            task_name: state.options.taskName,
            is_tablet: false,
            report_id: req.reportId || "",
            extra_info: extra
        });
    }

    function postJson(url, body) {
        var URL = Java.use("java.net.URL");
        var HttpURLConnection = Java.use("java.net.HttpURLConnection");
        var conn = Java.cast(URL.$new(url).openConnection(), HttpURLConnection);
        conn.setConnectTimeout(state.options.connectTimeoutMs);
        conn.setReadTimeout(state.options.readTimeoutMs);
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        var bytes = utf8Bytes(body);
        var os = conn.getOutputStream();
        os.write.overload("[B").call(os, bytes);
        os.flush();
        os.close();
        var code = conn.getResponseCode();
        conn.disconnect();
        return code;
    }

    function ensureUploaderClass() {
        if (state.uploaderClass) return state.uploaderClass;
        var Runnable = Java.use("java.lang.Runnable");
        state.uploaderClass = Java.registerClass({
            name: "com.dyidre.frida.PacketUploadWorker" + VERSION_CODE + "_" + Process.id + "_" + Date.now(),
            implements: [Runnable],
            methods: {
                run: function () {
                    try {
                        while (state.uploadQueue.length > 0) {
                            var req = state.uploadQueue.shift();
                            var one = packetJson(req);
                            state.lastPacket = one;
                            if (state.options.printPackets) log("packet-json " + one);
                            var body = JSON.stringify({ device_id: state.deviceId || "", packets: [one] });
                            var code = postJson(state.options.uploadUrl, body);
                            if (code >= 200 && code < 300) {
                                state.stats.uploaded++;
                            } else {
                                state.stats.uploadFailed++;
                                log("upload http code=" + code);
                            }
                        }
                    } catch (e) {
                        state.stats.uploadFailed++;
                        log("upload worker failed: " + e);
                    } finally {
                        state.uploadWorkerRunning = false;
                        if (state.uploadQueue.length > 0) {
                            try { startUploadWorker(); } catch (e2) {
                                state.stats.uploadFailed++;
                                log("upload worker restart failed: " + e2);
                            }
                        }
                    }
                }
            }
        });
        return state.uploaderClass;
    }

    function startUploadWorker() {
        if (state.uploadWorkerRunning) return;
        if (!state.uploadQueue || state.uploadQueue.length <= 0) return;
        var Thread = state.threadClass || Java.use("java.lang.Thread");
        state.threadClass = Thread;
        var Uploader = ensureUploaderClass();
        var worker = Uploader.$new();
        var thread = Thread.$new(worker, "dyidre-packet-upload-worker");
        try { thread.setDaemon(true); } catch (_) {}
        state.uploadWorkerRunning = true;
        thread.start();
        state.stats.uploadStarted++;
        log("upload worker start queued=" + state.uploadQueue.length);
    }

    function enqueueUpload(req) {
        if (!req) return;
        while (state.uploadQueue.length >= state.options.maxQueue) {
            state.uploadQueue.shift();
            state.stats.uploadDropped++;
        }
        state.uploadQueue.push(req);
        state.stats.uploadQueued++;
        try {
            startUploadWorker();
        } catch (e) {
            state.stats.uploadFailed++;
            log("upload enqueue failed: " + e);
        }
    }

    function uploadRequest(req) {
        if (!req) return;
        req.requestEndTime = Date.now();
        if (!state.options.upload) {
            state.lastPacket = packetJson(req);
            if (state.options.printPackets) log("packet-json " + state.lastPacket);
            return;
        }
        enqueueUpload(req);
        log("upload queued bytes req=" + Math.floor((req.requestBodyHex || "").length / 2) +
            " resp=" + Math.floor((req.responseBodyHex || "").length / 2) +
            " url=" + shortText(req.url));
    }

    function initJavaMetadata() {
        try {
            var Build = Java.use("android.os.Build");
            var Version = Java.use("android.os.Build$VERSION");
            state.extraInfo = safeString(Build.MANUFACTURER.value) + "-" + safeString(Build.PRODUCT.value) + "-" + safeString(Version.SDK_INT.value);
        } catch (_) {
            state.extraInfo = "";
        }
        try {
            var ActivityThread = Java.use("android.app.ActivityThread");
            var app = ActivityThread.currentApplication();
            if (app) {
                var SettingsSecure = Java.use("android.provider.Settings$Secure");
                state.deviceId = safeString(SettingsSecure.getString(app.getContentResolver(), "android_id"));
            }
            var proc = ActivityThread.currentProcessName();
            if (proc) state.processName = safeString(proc);
        } catch (_) {
            if (!state.deviceId) state.deviceId = "";
            if (!state.processName) state.processName = "com.ss.android.ugc.aweme";
        }
        if (!state.deviceId || state.deviceId === "undefined" || state.deviceId === "null") {
            state.deviceId = "rf-" + (state.processName || "com.ss.android.ugc.aweme") + "-" + (Process.id || 0);
        }
    }

    function hookJN() {
        try {
            var JN = Java.use("J.N");
            var createReq = JN.MnXVOzVo.overload(
                "java.lang.Object", "long", "java.lang.String", "int", "int",
                "boolean", "boolean", "boolean", "int", "boolean", "int", "int", "long"
            );
            createReq.impl = function (a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
                var ret = this.$orig(a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
                var urlText = safeString(url);
                var ptrText = safeString(ret);
                if (ptrText !== "0" && isTargetUrl(urlText)) {
                    newRequest(ptrText, urlText);
                } else {
                    state.stats.filtered++;
                }
                return ret;
            };

            var setMethod = JN.MfdvbiJC.overload("long", "java.lang.Object", "java.lang.String");
            setMethod.impl = function (urlPtr, obj, method) {
                var req = matchUrlPtr(urlPtr);
                if (req) req.httpMethod = safeString(method);
                return this.$orig(urlPtr, obj, method);
            };

            var addReqHeader = JN.MtJFji5x.overload("long", "java.lang.Object", "java.lang.String", "java.lang.String");
            addReqHeader.impl = function (urlPtr, obj, key, value) {
                addHeader(matchUrlPtr(urlPtr), key, value);
                return this.$orig(urlPtr, obj, key, value);
            };
            log("hooked J.N request adapter/method/header");
        } catch (e) {
            log("hook J.N failed: " + e);
        }
    }

    function hookCronetStreams() {
        if (state.options.hookStreams) try {
            var Out = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetFixedModeOutputStream");
            var write = Out.write.overload("[B", "int", "int");
            write.impl = function (bytes, off, len) {
                var ret = this.$orig(bytes, off, len);
                try {
                    if (!state.options.captureBodies) return ret;
                    if (state.options.skipMainThread && isMainThread()) {
                        state.stats.hookSkippedMain++;
                        return ret;
                    }
                    var conn = getFieldValue(this, "mConnection");
                    var url = urlFromConnection(conn);
                    var req = matchUrl(url, currentThreadInfo()) || ensureRequestForUrl(url, "stream.write");
                    if (req) appendBodyHex(req, "requestBodyHex", javaByteArrayToHex(bytes, off, len));
                } catch (e) {
                    addEvent("write capture failed: " + e);
                }
                return ret;
            };
            log("hooked CronetFixedModeOutputStream.write");
        } catch (e) {
            log("hook output stream failed: " + e);
        } else {
            log("skip Cronet stream body hooks (METASEC_PACKET_HOOK_STREAMS=0)");
        }

        if (state.options.hookStreams) try {
            var In = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetInputStream");
            var read = In.read.overload("[B", "int", "int");
            read.impl = function (bytes, off, len) {
                var n = this.$orig(bytes, off, len);
                try {
                    if (!state.options.captureBodies || !state.options.captureResponseBody) return n;
                    if (state.options.skipMainThread && isMainThread()) {
                        state.stats.hookSkippedMain++;
                        return n;
                    }
                    var count = Number(n);
                    if (count > 0) {
                        var conn = getFieldValue(this, "mHttpURLConnection");
                        var url = urlFromConnection(conn);
                        var req = matchUrl(url, currentThreadInfo()) || ensureRequestForUrl(url, "stream.read");
                        if (req) {
                            appendBodyHex(req, "responseBodyHex", javaByteArrayToHex(bytes, off, count));
                            copyResponseHeaders(req, conn);
                        }
                    }
                } catch (e) {
                    addEvent("read capture failed: " + e);
                }
                return n;
            };
            log("hooked CronetInputStream.read");
        } catch (e) {
            log("hook input stream failed: " + e);
        } else {
            log("skip Cronet input body hooks (METASEC_PACKET_HOOK_STREAMS=0)");
        }

        if (state.options.hookConnections) try {
            var Conn = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetHttpURLConnection");
            try {
                var setRequestMethod = Conn.setRequestMethod.overload("java.lang.String");
                setRequestMethod.impl = function (method) {
                    var ret = this.$orig(method);
                    try {
                        var req = ensureRequestForUrl(urlFromConnection(this), "setRequestMethod");
                        if (req) req.httpMethod = safeString(method);
                    } catch (e) {
                        addEvent("setRequestMethod capture failed: " + e);
                    }
                    return ret;
                };
                log("hooked CronetHttpURLConnection.setRequestMethod");
            } catch (e0) {
                addEvent("setRequestMethod hook skipped: " + e0);
            }
            try {
                var addRequestProperty = Conn.addRequestProperty.overload("java.lang.String", "java.lang.String");
                addRequestProperty.impl = function (key, value) {
                    var ret = this.$orig(key, value);
                    try {
                        addHeader(ensureRequestForUrl(urlFromConnection(this), "addRequestProperty"), key, value);
                    } catch (e) {
                        addEvent("addRequestProperty capture failed: " + e);
                    }
                    return ret;
                };
                log("hooked CronetHttpURLConnection.addRequestProperty");
            } catch (e1) {
                addEvent("addRequestProperty hook skipped: " + e1);
            }
            try {
                var setRequestProperty = Conn.setRequestProperty.overload("java.lang.String", "java.lang.String");
                setRequestProperty.impl = function (key, value) {
                    var ret = this.$orig(key, value);
                    try {
                        addHeader(ensureRequestForUrl(urlFromConnection(this), "setRequestProperty"), key, value);
                    } catch (e) {
                        addEvent("setRequestProperty capture failed: " + e);
                    }
                    return ret;
                };
                log("hooked CronetHttpURLConnection.setRequestProperty");
            } catch (e2) {
                addEvent("setRequestProperty hook skipped: " + e2);
            }
            try {
                var getOutputStream = Conn.getOutputStream.overload();
                getOutputStream.impl = function () {
                    var ret = this.$orig();
                    try {
                        ensureRequestForUrl(urlFromConnection(this), "getOutputStream");
                    } catch (e) {
                        addEvent("getOutputStream capture failed: " + e);
                    }
                    return ret;
                };
                log("hooked CronetHttpURLConnection.getOutputStream");
            } catch (e3) {
                addEvent("getOutputStream hook skipped: " + e3);
            }
            try {
                var getInputStream = Conn.getInputStream.overload();
                getInputStream.impl = function () {
                    var ret = this.$orig();
                    try {
                        ensureRequestForUrl(urlFromConnection(this), "getInputStream");
                    } catch (e) {
                        addEvent("getInputStream capture failed: " + e);
                    }
                    return ret;
                };
                log("hooked CronetHttpURLConnection.getInputStream");
            } catch (e4) {
                addEvent("getInputStream hook skipped: " + e4);
            }
            var disconnect = Conn.disconnect.overload();
            disconnect.impl = function () {
                var req = null;
                try {
                    if (state.options.skipMainThread && isMainThread()) {
                        state.stats.hookSkippedMain++;
                    } else {
                        var url = urlFromConnection(this);
                        req = matchUrl(url, currentThreadInfo()) || ensureRequestForUrl(url, "disconnect");
                    }
                    if (req && state.options.copyResponseHeaders) {
                        copyResponseHeaders(req, this);
                    }
                } catch (e) {
                    addEvent("disconnect pre-capture failed: " + e);
                }
                var ret = this.$orig();
                try {
                    if (req) {
                        uploadRequest(req);
                        removeRequest(req);
                    }
                } catch (e2) {
                    addEvent("disconnect upload queue failed: " + e2);
                }
                return ret;
            };
            log("hooked CronetHttpURLConnection.disconnect");
        } catch (e) {
            log("hook connection failed: " + e);
        } else {
            log("skip Cronet connection hooks (METASEC_PACKET_HOOK_CONNECTIONS=0)");
        }
    }

    function installJavaHooks() {
        if (state.javaHooked) return;
        state.javaHooked = true;
        var ready = function () {
            initJavaMetadata();
            log("java ready uploadUrl=" + state.options.uploadUrl + " device_id=" + state.deviceId +
                " process=" + state.processName);
            if (state.options.hookJN) hookJN();
            else log("skip J.N hooks (METASEC_PACKET_HOOK_JN=0)");
            hookCronetStreams();
        };
        try {
            configureJavaStealth();
            if (Java.ready) Java.ready(ready);
            else Java.perform(ready);
        } catch (e) {
            state.javaHooked = false;
            addEvent("java hook bootstrap failed: " + e);
            log("java hook bootstrap failed stealth=" + state.options.javaStealth + ": " + e);
            if (state.options.requireJavaStealth) throw e;
        }
    }

    function installNativeAtBase(base) {
        if (state.nativeHooked) return;
        try {
            var addr = ptr(base).add(HTTP_CALLBACK_OFF);
            Interceptor.attach(addr, {
                onEnter: function (args) {
                    this.url = readCStringSafe(args[0], 65536);
                },
                onLeave: function (retval) {
                    var xms = readCStringSafe(retval, 65536);
                    if (this.url && xms) addXmHeaders(this.url, xms);
                }
            }, desiredNativeHookValue(state.options.nativeStealth));
            state.nativeHooked = true;
            log("hooked " + TARGET_MODULE + "+0x" + HTTP_CALLBACK_OFF.toString(16) + " @" + addr +
                " stealth=" + state.options.nativeStealth);
        } catch (e) {
            log("native hook failed: " + e);
        }
    }

    function watchLoader(symbol) {
        if (state.loaderHooked[symbol]) return;
        var p = Module.findExportByName(null, symbol);
        if (p === null) return;
        state.loaderHooked[symbol] = true;
        Interceptor.attach(p, {
            onEnter: function (args) {
                this.path = readCStringSafe(args[0], 4096);
            },
            onLeave: function () {
                if ((this.path || "").indexOf(TARGET_MODULE) >= 0) {
                    var base = Module.findBaseAddress(TARGET_MODULE);
                    if (base !== null) installNativeAtBase(base);
                }
            }
        });
    }

    function installNativeHook() {
        var base = Module.findBaseAddress(TARGET_MODULE);
        log("install native side stealth=" + state.options.nativeStealth + " watchLoader=" + state.options.watchLoader + " base=" + base);
        if (base !== null) {
            installNativeAtBase(base);
            if (!state.options.watchLoader) return;
        }
        if (!state.options.watchLoader) {
            addEvent("target module not loaded and loader watch disabled");
            log("target module not loaded and loader watch disabled");
            return;
        }
        watchLoader("android_dlopen_ext");
        watchLoader("dlopen");
    }

    function summary() {
        return {
            installed: state.installed,
            javaHooked: state.javaHooked,
            nativeHooked: state.nativeHooked,
            options: state.options,
            deviceId: state.deviceId || "",
            processName: state.processName || "",
            pending: state.requests.length,
            stats: state.stats,
            events: state.events,
            lastPacket: state.lastPacket || ""
        };
    }

    var old = rpc.exports || {};
    old.metapacketsummary = summary;
    rpc.exports = old;

    if (state.installed) {
        log("already installed");
        return "already-installed";
    }
    state.installed = true;
    installJavaHooks();
    installNativeHook();
    return "installed";
})();

}
__dyidre_mode_packet_capture();
