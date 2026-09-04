globalThis.METASEC_PROBE_CONFIG = {"mode": "packet-capture", "packet": {"uploadUrl": "http://127.0.0.1:8891/up/dy/packets", "version": "35.1.0", "taskName": "native_capture_xm_173818", "profile": "token", "nativeStealth": "wxshadow", "hookJN": false, "maxPending": 96, "maxQueue": 16, "maxBodyBytes": 262144, "hookStreams": false, "hookConnections": false, "uploadVia": "native", "uploadOnXm": true, "captureBodies": false, "captureResponseBody": true, "copyResponseHeaders": true, "skipMainThread": true, "useThreadNames": false, "logUrlMax": 180, "connectTimeoutMs": 1500, "readTimeoutMs": 1500, "nativeOnly": true}};
function __dyidre_mode_packet_capture_native() {
(function () {
    var VERSION_CODE = "350101";
    var VERSION_NAME = "35.1.0";
    var TARGET_MODULE = "libmetasec_ml.so";
    var HTTP_CALLBACK_OFF = 0x14dbf4;

    var cfg = globalThis.METASEC_PROBE_CONFIG || {};
    var opt = cfg.packet || cfg.capture || {};

    var DEFAULT_TOKEN_FILTERS = [
        "get_token",
        "/passport/ticket_guard/get_client_cert/",
        "/device_register",
        "/captcha/verify",
        "/captcha/get"
    ];
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

    function defaultFiltersForProfile(profile) {
        var p = String(profile || "token").toLowerCase();
        if (p === "wide" || p === "full" || p === "all") return DEFAULT_WIDE_FILTERS;
        return DEFAULT_TOKEN_FILTERS;
    }

    var state = globalThis.__metasecPacketCapture350101Native || {
        installed: false,
        nativeHooked: false,
        loaderHooked: {},
        sentMap: {},
        sentKeys: [],
        stats: {
            seen: 0,
            filtered: 0,
            parsed: 0,
            uploaded: 0,
            uploadFailed: 0,
            duplicates: 0
        },
        events: []
    };
    globalThis.__metasecPacketCapture350101Native = state;

    var packetProfile = String(opt.profile || "token").toLowerCase();
    state.options = {
        upload: opt.upload === undefined ? true : !!opt.upload,
        uploadUrl: String(opt.uploadUrl || "http://127.0.0.1:8891/up/dy/packets"),
        version: String(opt.version || VERSION_NAME),
        taskName: String(opt.taskName || "collect_frida_native"),
        type: String(opt.type || "hook"),
        source: String(opt.source || "frida-native"),
        profile: packetProfile,
        filterAll: !!opt.filterAll,
        filters: opt.filters || defaultFiltersForProfile(packetProfile),
        nativeStealth: String(opt.nativeStealth || opt.stealth || "wxshadow").toLowerCase(),
        uploadOnXm: opt.uploadOnXm === undefined ? true : !!opt.uploadOnXm,
        logUrlMax: Number(opt.logUrlMax || 180)
    };

    function log(s) {
        console.log("[packet350n] " + s);
    }

    function addEvent(s) {
        state.events.push(Date.now() + " " + s);
        if (state.events.length > 80) state.events.shift();
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

    function shortText(v, maxLen) {
        var s = safeString(v);
        var n = Number(maxLen || state.options.logUrlMax || 180);
        if (!s || n <= 0 || s.length <= n) return s;
        return s.substring(0, n) + "...(" + s.length + ")";
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

    function parseXmHeaders(xms) {
        var out = {};
        var text = safeString(xms);
        var lines = text.split(/\r\n|\n|\r/);
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            var idx = line.indexOf(":");
            if (idx > 0) {
                var key = line.substring(0, idx).trim();
                var value = line.substring(idx + 1).trim();
                if (key) out[key] = value;
            }
        }
        if (Object.keys(out).length > 0) return out;

        var parts = text.replace(/\r\n/g, ",").replace(/\n/g, ",").replace(/\r/g, ",").split(",");
        for (var j = 0; j + 1 < parts.length; j += 2) {
            var k = String(parts[j] || "").trim();
            var v = String(parts[j + 1] || "").trim();
            if (k) out[k] = v;
        }
        return out;
    }

    function headerValue(headers, name) {
        var want = String(name || "").toLowerCase();
        var keys = Object.keys(headers || {});
        for (var i = 0; i < keys.length; i++) {
            if (String(keys[i]).toLowerCase() === want) return headers[keys[i]];
        }
        return "";
    }

    function packetDedupKey(url, headers) {
        return [
            safeString(url),
            headerValue(headers, "x-argus"),
            headerValue(headers, "x-ladon"),
            headerValue(headers, "x-medusa"),
            headerValue(headers, "x-gorgon"),
            headerValue(headers, "x-khronos")
        ].join("|");
    }

    function markSent(key) {
        if (state.sentMap[key]) return false;
        state.sentMap[key] = Date.now();
        state.sentKeys.push(key);
        while (state.sentKeys.length > 160) {
            var old = state.sentKeys.shift();
            delete state.sentMap[old];
        }
        return true;
    }

    function currentTidText() {
        try {
            return "tid_" + Process.getCurrentThreadId();
        } catch (_) {
            return "tid_unknown";
        }
    }

    function packetText(url, headers, xms) {
        var now = Date.now();
        return JSON.stringify({
            version: state.options.version,
            version_code: VERSION_CODE,
            device_id: "rf-native-" + (Process.id || 0),
            url: safeString(url),
            method: "",
            headers: JSON.stringify(headers || {}),
            response_headers: "{}",
            raw_data: "",
            raw_data_md5: "",
            response_data: "",
            process: "com.ss.android.ugc.aweme",
            thread: currentTidText(),
            request_start_time: now,
            request_end_time: now,
            net_type: "http",
            from: state.options.source,
            type: state.options.type,
            task_name: state.options.taskName,
            is_tablet: false,
            report_id: "",
            extra_info: "native_xm_only path=" + extractPath(url) + " xms_len=" + safeString(xms).length
        });
    }

    function parseHttpUploadUrl(url) {
        var s = safeString(url);
        var m = s.match(/^http:\/\/([^\/:?#]+)(?::([0-9]+))?([^#]*)$/i);
        if (!m) throw new Error("only http upload url is supported: " + s);
        var host = m[1];
        var port = Number(m[2] || 80);
        var path = m[3] || "/";
        if (!path) path = "/";
        if (path.charAt(0) !== "/") path = "/" + path;
        if (host === "localhost") host = "127.0.0.1";
        if (!host.match(/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/)) {
            throw new Error("upload host must be ipv4: " + host);
        }
        return { host: host, port: port, path: path };
    }

    function ipv4Le(host) {
        var parts = host.split(".");
        if (parts.length !== 4) throw new Error("bad ipv4: " + host);
        var b0 = Number(parts[0]) & 0xff;
        var b1 = Number(parts[1]) & 0xff;
        var b2 = Number(parts[2]) & 0xff;
        var b3 = Number(parts[3]) & 0xff;
        return (b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)) >>> 0;
    }

    function utf8ByteLength(s) {
        var str = String(s || "");
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            var c = str.charCodeAt(i);
            if (c < 0x80) {
                len += 1;
            } else if (c < 0x800) {
                len += 2;
            } else if (c >= 0xd800 && c <= 0xdbff && i + 1 < str.length) {
                var d = str.charCodeAt(i + 1);
                if (d >= 0xdc00 && d <= 0xdfff) {
                    len += 4;
                    i++;
                } else {
                    len += 3;
                }
            } else {
                len += 3;
            }
        }
        return len;
    }

    function toNumber(v, fallback) {
        try {
            var n = Number(v);
            return isNaN(n) ? fallback : n;
        } catch (_) {
            return fallback;
        }
    }

    function libc() {
        if (state.libc) return state.libc;
        function sym(name) {
            var p = Module.findExportByName("libc.so", name) || Module.findExportByName(null, name);
            if (p === null) throw new Error("missing libc symbol " + name);
            return p;
        }
        state.libc = {
            socket: new NativeFunction(sym("socket"), "int", ["int", "int", "int"]),
            connect: new NativeFunction(sym("connect"), "int", ["int", "pointer", "int"]),
            write: new NativeFunction(sym("write"), "long", ["int", "pointer", "ulong"]),
            close: new NativeFunction(sym("close"), "int", ["int"]),
            htons: new NativeFunction(sym("htons"), "uint16", ["uint16"])
        };
        return state.libc;
    }

    function zeroMemory(p, n) {
        for (var i = 0; i < n; i++) p.add(i).writeU8(0);
    }

    function writeAll(fd, p, len) {
        var off = 0;
        while (off < len) {
            var n = toNumber(libc().write(fd, p.add(off), len - off), -1);
            if (n <= 0) throw new Error("write failed at " + off + "/" + len);
            off += n;
        }
    }

    function nativePostJson(url, body) {
        var u = parseHttpUploadUrl(url);
        var c = libc();
        var fd = c.socket(2, 1, 0);
        if (fd < 0) throw new Error("socket failed");
        try {
            var sa = Memory.alloc(16);
            zeroMemory(sa, 16);
            sa.add(0).writeU16(2);
            sa.add(2).writeU16(c.htons(u.port));
            sa.add(4).writeU32(ipv4Le(u.host));

            var rc = c.connect(fd, sa, 16);
            if (rc !== 0) throw new Error("connect failed rc=" + rc + " " + u.host + ":" + u.port);

            var req =
                "POST " + u.path + " HTTP/1.1\r\n" +
                "Host: " + u.host + ":" + u.port + "\r\n" +
                "Content-Type: application/json; charset=utf-8\r\n" +
                "Connection: close\r\n" +
                "Content-Length: " + utf8ByteLength(body) + "\r\n" +
                "\r\n" +
                body;
            var reqBytes = utf8ByteLength(req);
            var buf = Memory.allocUtf8String(req);
            writeAll(fd, buf, reqBytes);
        } finally {
            try { c.close(fd); } catch (_) {}
        }
    }

    function uploadPacket(url, headers, xms) {
        var one = packetText(url, headers, xms);
        state.lastPacket = one;
        if (!state.options.upload) {
            log("packet-json " + one);
            return;
        }
        var body = JSON.stringify({ device_id: "rf-native-" + (Process.id || 0), packets: [one] });
        nativePostJson(state.options.uploadUrl, body);
    }

    function handleXm(nativeUrl, xms) {
        state.stats.seen++;
        var url = safeString(nativeUrl);
        if (!isTargetUrl(url)) {
            state.stats.filtered++;
            return;
        }
        var headers = parseXmHeaders(xms);
        var keys = Object.keys(headers);
        if (keys.length <= 0) {
            addEvent("xm empty headers url=" + shortText(url));
            return;
        }
        state.stats.parsed++;
        var dedup = packetDedupKey(url, headers);
        if (!markSent(dedup)) {
            state.stats.duplicates++;
            return;
        }
        log("xm/native url=" + shortText(url) + " keys=" + keys.join(","));
        if (!state.options.uploadOnXm) return;
        try {
            uploadPacket(url, headers, xms);
            state.stats.uploaded++;
            log("native upload ok url=" + shortText(url));
        } catch (e) {
            state.stats.uploadFailed++;
            addEvent("native upload failed: " + e);
            log("native upload failed url=" + shortText(url) + " err=" + e);
        }
    }

    function nativeHookMode() {
        var mode = state.options.nativeStealth;
        if (mode === "0" || mode === "false" || mode === "off" || mode === "no" || mode === "normal" || mode === "none") {
            if (typeof Hook !== "undefined" && Hook !== null && Hook.NORMAL !== undefined) return Hook.NORMAL;
            return 0;
        }
        if (mode === "2" || mode === "recomp") {
            if (typeof Hook !== "undefined" && Hook !== null && Hook.RECOMP !== undefined) return Hook.RECOMP;
            return 2;
        }
        if (typeof Hook !== "undefined" && Hook !== null && Hook.WXSHADOW !== undefined) return Hook.WXSHADOW;
        return 1;
    }

    function installNativeAtBase(base) {
        if (state.nativeHooked) return;
        try {
            var addr = ptr(base).add(HTTP_CALLBACK_OFF);
            var mode = nativeHookMode();
            Interceptor.attach(addr, {
                onEnter: function (args) {
                    this.url = readCStringSafe(args[0], 65536);
                },
                onLeave: function (retval) {
                    var xms = readCStringSafe(retval, 65536);
                    if (this.url && xms) handleXm(this.url, xms);
                }
            }, mode);
            state.nativeHooked = true;
            log("hooked " + TARGET_MODULE + "+0x" + HTTP_CALLBACK_OFF.toString(16) + " @" + addr + " mode=" + state.options.nativeStealth);
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
        if (base !== null) installNativeAtBase(base);
        watchLoader("android_dlopen_ext");
        watchLoader("dlopen");
    }

    function summary() {
        return {
            installed: state.installed,
            nativeHooked: state.nativeHooked,
            options: state.options,
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
    installNativeHook();
    return "installed-native";
})();

}
__dyidre_mode_packet_capture_native();
