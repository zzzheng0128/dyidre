globalThis.METASEC_PACKET_CONFIG = {
  "taskName": "fullbody_hostbridge_20260901_223728",
  "filterAll": true,
  "captureBodies": true,
  "captureResponseBody": false,
  "copyResponseHeaders": true,
  "skipBodyOnMainThread": true,
  "emitOnFirstBody": false,
  "emitOnXmWithBody": false,
  "emitOnDisconnect": true,
  "maxPending": 512,
  "maxBodyBytes": 0,
  "logCreateEvery": 25,
  "logBodyEvery": 10,
  "printPackets": false
};
// Standalone rustFrida wxshadow packet probe for Douyin 35.1.0 / 350101.
//
// Xposed parity:
//   J.N.MnXVOzVo       -> url/native request ptr
//   J.N.MfdvbiJC       -> method
//   J.N.MtJFji5x       -> request headers
//   CronetFixedModeOutputStream.write -> request body
//   libmetasec_ml.so+0x14DBF4 -> MetaSec X-* headers
//   CronetHttpURLConnection.disconnect -> final packet
//
// Stability rule: do not upload from inside Douyin. Emit one base64 JSON line
// and let the host bridge POST it to dydcd.

if (false) Java.setStealth(Hook.WXSHADOW);

(function () {
  var TAG = "[rfpkt350]";
  var VERSION_CODE = "350101";
  var VERSION_NAME = "35.1.0";
  var TARGET_MODULE = "libmetasec_ml.so";
  var HTTP_CALLBACK_OFF = 0x14dbf4;
  var URL_PREFIX = "com.ttnet.org.chromium.net.urlconnection.CronetHttpURLConnection:";
  var DEFAULT_FILTERS = [
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

  var cfg = globalThis.METASEC_PACKET_CONFIG || globalThis.METASEC_SLIM_CONFIG || {};
  var options = {
    taskName: String(cfg.taskName || "collect_frida_wxshadow_hostupload"),
    filterAll: cfg.filterAll === undefined ? false : !!cfg.filterAll,
    filters: cfg.filters || DEFAULT_FILTERS,
    captureBodies: cfg.captureBodies === undefined ? true : !!cfg.captureBodies,
    captureResponseBody: cfg.captureResponseBody === undefined ? false : !!cfg.captureResponseBody,
    copyResponseHeaders: cfg.copyResponseHeaders === undefined ? true : !!cfg.copyResponseHeaders,
    skipBodyOnMainThread: cfg.skipBodyOnMainThread === undefined ? true : !!cfg.skipBodyOnMainThread,
    // Xposed parity: upload the assembled packet at disconnect by default.
    // Early body/XM emits are useful for debugging but they are partial packets
    // and make the backend look like "headers/body missing".
    emitOnFirstBody: cfg.emitOnFirstBody === undefined ? false : !!cfg.emitOnFirstBody,
    emitOnXmWithBody: cfg.emitOnXmWithBody === undefined ? false : !!cfg.emitOnXmWithBody,
    emitOnDisconnect: cfg.emitOnDisconnect === undefined ? true : !!cfg.emitOnDisconnect,
    maxPending: Number(cfg.maxPending || 256),
    maxBodyBytes: Number(cfg.maxBodyBytes === undefined ? 0 : cfg.maxBodyBytes),
    logCreateEvery: Number(cfg.logCreateEvery === undefined ? 50 : cfg.logCreateEvery),
    logBodyEvery: Number(cfg.logBodyEvery === undefined ? 20 : cfg.logBodyEvery),
    logUrlMax: Number(cfg.logUrlMax || 220),
    printPackets: !!cfg.printPackets
  };

  var state = globalThis.__rfPacket350101 || {
    installed: false,
    nativeHooked: false,
    loaderHooked: {},
    requestsByPtr: {},
    requests: [],
    fieldCache: {},
    processName: "com.ss.android.ugc.aweme",
    deviceId: "",
    extraInfo: "",
    lastPacket: "",
    events: [],
    stats: {
      create: 0,
      target: 0,
      filtered: 0,
      method: 0,
      header: 0,
      bodyChunks: 0,
      bodyBytes: 0,
      responseChunks: 0,
      responseBytes: 0,
      responseHeaders: 0,
      xmHits: 0,
      xmMatched: 0,
      disconnect: 0,
      emitted: 0,
      skippedMainBody: 0,
      errors: 0
    }
  };
  globalThis.__rfPacket350101 = state;

  function log(s) {
    try { console.log(TAG + " " + String(s)); } catch (_) {}
  }

  function addEvent(s) {
    try {
      state.events.push(Date.now() + " " + String(s));
      while (state.events.length > 80) state.events.shift();
    } catch (_) {}
  }

  function safeString(v) {
    try {
      if (v === null || v === undefined) return "";
      return String(v);
    } catch (_) {
      return "";
    }
  }

  function shortText(v, maxLen) {
    var s = safeString(v);
    var n = Number(maxLen || options.logUrlMax || 220);
    if (!s || n <= 0 || s.length <= n) return s;
    return s.substring(0, n) + "...(" + s.length + ")";
  }

  function currentThreadInfo() {
    try { return "tid_" + Process.getCurrentThreadId(); } catch (_) { return "tid_unknown"; }
  }

  function isMainThread() {
    try { return Number(Process.getCurrentThreadId()) === Number(Process.id); } catch (_) { return false; }
  }

  function readCStringSafe(p, maxLen) {
    try {
      var q = ptr(p);
      if (q.isNull()) return "";
      return q.readCString(maxLen || 65536) || "";
    } catch (_) {
      return "";
    }
  }

  function desiredStealthValue() {
    if (typeof Hook !== "undefined" && Hook && Hook.WXSHADOW !== undefined) return Hook.WXSHADOW;
    return 1;
  }

  function configureStealth() {
    try {
      var before = -1;
      try { if (typeof Java.getStealth === "function") before = Number(Java.getStealth()); } catch (_) {}
      Java.setStealth(desiredStealthValue());
      var after = before;
      try { if (typeof Java.getStealth === "function") after = Number(Java.getStealth()); } catch (_) {}
      log("java stealth wxshadow before=" + before + " after=" + after);
    } catch (e) {
      state.stats.errors++;
      addEvent("setStealth failed: " + e);
      log("setStealth(WXSHADOW) failed: " + e);
    }
  }

  function initJavaMetadata() {
    try {
      var Build = Java.use("android.os.Build");
      var Version = Java.use("android.os.Build$VERSION");
      state.extraInfo = safeString(Build.MANUFACTURER.value) + "-" +
        safeString(Build.PRODUCT.value) + "-" + safeString(Version.SDK_INT.value);
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
    } catch (_) {}
    if (!state.deviceId || state.deviceId === "undefined" || state.deviceId === "null") {
      state.deviceId = "rf-" + state.processName + "-" + (Process.id || 0);
    }
    log("java ready device_id=" + state.deviceId + " process=" + state.processName +
      " filterAll=" + options.filterAll + " captureBodies=" + options.captureBodies +
      " task=" + options.taskName);
  }

  function getFieldValue(obj, name) {
    if (!obj) return null;
    try {
      var cls = obj.getClass();
      while (cls) {
        var className = safeString(cls.getName ? cls.getName() : cls);
        var key = className + "#" + name;
        var cached = state.fieldCache[key];
        if (cached) {
          try { return cached.get(obj); } catch (_) { delete state.fieldCache[key]; }
        }
        try {
          var f = cls.getDeclaredField(name);
          f.setAccessible(true);
          state.fieldCache[key] = f;
          return f.get(obj);
        } catch (_) {
          cls = cls.getSuperclass();
        }
      }
    } catch (e) {
      addEvent("getField " + name + " failed: " + e);
    }
    return null;
  }

  function urlFromConnection(conn) {
    var s = safeString(conn);
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
    if (s.indexOf("douyinvod.com") >= 0) return false;
    if (s.indexOf("/up/dy/packets") >= 0) return false;
    if (s.indexOf("127.0.0.1") >= 0 || s.indexOf("localhost") >= 0) return false;
    if (options.filterAll) return true;
    for (var i = 0; i < options.filters.length; i++) {
      if (s.indexOf(String(options.filters[i])) >= 0) return true;
    }
    return false;
  }

  function trimPending() {
    while (state.requests.length > options.maxPending) {
      var old = state.requests.shift();
      if (old && old.urlPtr) delete state.requestsByPtr[old.urlPtr];
      addEvent("drop pending url=" + shortText(old && old.url));
    }
  }

  function remember(ptrText, url) {
    var key = safeString(ptrText);
    var old = state.requestsByPtr[key];
    if (old) return old;
    var req = {
      urlPtr: key,
      url: safeString(url),
      httpMethod: "",
      requestHeaders: {},
      responseHeaders: {},
      requestBodyB64Chunks: [],
      responseBodyB64Chunks: [],
      requestBodyHex: "",
      responseBodyHex: "",
      requestBodyCount: 0,
      responseBodyCount: 0,
      curProcess: state.processName || "com.ss.android.ugc.aweme",
      curThread: currentThreadInfo(),
      requestStartTime: Date.now(),
      requestEndTime: 0,
      xms: "",
      reportId: "",
      emittedBody: false,
      emittedXm: false,
      emittedFinal: false,
      requestBodyTruncated: false,
      responseBodyTruncated: false
    };
    state.requestsByPtr[key] = req;
    state.requests.push(req);
    trimPending();
    return req;
  }

  function removeReq(req) {
    if (!req) return;
    if (req.urlPtr) delete state.requestsByPtr[req.urlPtr];
    for (var i = state.requests.length - 1; i >= 0; i--) {
      if (state.requests[i] === req) {
        state.requests.splice(i, 1);
        break;
      }
    }
  }

  function matchUrlPtr(ptrText) {
    return state.requestsByPtr[safeString(ptrText)] || null;
  }

  function matchUrl(url) {
    var s = safeString(url);
    if (!s) return null;
    for (var i = state.requests.length - 1; i >= 0; i--) {
      var req = state.requests[i];
      if (req && req.url === s) return req;
    }
    return null;
  }

  function ensureRequestForUrl(url, reason) {
    var s = safeString(url);
    if (!s || !isTargetUrl(s)) return null;
    var req = matchUrl(s);
    if (req) return req;
    req = remember("auto:" + Date.now() + ":" + state.requests.length, s);
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

  var b64Map = null;
  function ensureB64Map() {
    if (b64Map) return b64Map;
    b64Map = {};
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    for (var i = 0; i < chars.length; i++) b64Map[chars.charAt(i)] = i;
    b64Map["-"] = 62;
    b64Map["_"] = 63;
    return b64Map;
  }

  function byteToHex(v) {
    v = Number(v);
    if (v < 0) v += 256;
    return (v < 16 ? "0" : "") + (v & 0xff).toString(16);
  }

  function base64ToHex(b64) {
    var map = ensureB64Map();
    var s = safeString(b64);
    var out = [];
    var buf = 0;
    var bits = 0;
    for (var i = 0; i < s.length; i++) {
      var c = s.charAt(i);
      if (c === "=") break;
      var v = map[c];
      if (v === undefined) continue;
      buf = (buf << 6) | v;
      bits += 6;
      if (bits >= 8) {
        bits -= 8;
        out.push(byteToHex((buf >> bits) & 0xff));
      }
    }
    return out.join("");
  }

  function chunksToHex(chunks) {
    if (!chunks || chunks.length === 0) return "";
    var out = [];
    for (var i = 0; i < chunks.length; i++) out.push(base64ToHex(chunks[i]));
    return out.join("");
  }

  function validSlice(arr, off, len) {
    var total = 0;
    try { total = Number(arr.length); } catch (_) { total = Number(off) + Number(len); }
    var start = Math.max(0, Number(off) || 0);
    var count = Math.max(0, Number(len) || 0);
    if (total > 0 && start + count > total) count = Math.max(0, total - start);
    return { off: start, len: count };
  }

  function encodeJavaBytesToBase64(bytes, off, len) {
    try {
      var slice = validSlice(bytes, off, len);
      if (slice.len <= 0) return { text: "", len: 0 };
      var Base64 = state.base64Class || Java.use("android.util.Base64");
      state.base64Class = Base64;
      var encode = state.base64Encode || Base64.encodeToString.overload("[B", "int", "int", "int");
      state.base64Encode = encode;
      return { text: safeString(encode.call(Base64, bytes, slice.off, slice.len, 2)), len: slice.len };
    } catch (e) {
      state.stats.errors++;
      addEvent("base64 encode failed: " + e);
      return { text: "", len: 0 };
    }
  }

  function appendB64Chunk(req, field, encoded) {
    if (!req || !encoded || !encoded.text || encoded.len <= 0) return;
    var isReq = field === "request";
    var countField = isReq ? "requestBodyCount" : "responseBodyCount";
    var chunksField = isReq ? "requestBodyB64Chunks" : "responseBodyB64Chunks";
    var truncatedField = isReq ? "requestBodyTruncated" : "responseBodyTruncated";
    var cur = Number(req[countField] || 0);
    var add = Number(encoded.len || 0);
    if (options.maxBodyBytes > 0 && cur + add > options.maxBodyBytes) {
      req[truncatedField] = true;
      addEvent("body truncated url=" + shortText(req.url));
      return;
    }
    req[chunksField].push(String(encoded.text));
    req[countField] = cur + add;
    if (isReq) {
      req.requestBodyHex = "";
      state.stats.bodyChunks++;
      state.stats.bodyBytes += add;
      if (options.logBodyEvery > 0 && (state.stats.bodyChunks <= 3 || state.stats.bodyChunks % options.logBodyEvery === 0)) {
        log("body chunk count=" + state.stats.bodyChunks + " total_bytes=" + state.stats.bodyBytes +
          " url=" + shortText(req.url));
      }
    } else {
      req.responseBodyHex = "";
      state.stats.responseChunks++;
      state.stats.responseBytes += add;
    }
  }

  function utf8Base64(text) {
    var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var s = safeString(text);
    var bytes = [];
    for (var i = 0; i < s.length; i++) {
      var c = s.charCodeAt(i);
      if (c < 0x80) {
        bytes.push(c);
      } else if (c < 0x800) {
        bytes.push(0xc0 | (c >> 6));
        bytes.push(0x80 | (c & 0x3f));
      } else if (c >= 0xd800 && c <= 0xdbff && i + 1 < s.length) {
        var d = s.charCodeAt(++i);
        var u = 0x10000 + (((c & 0x3ff) << 10) | (d & 0x3ff));
        bytes.push(0xf0 | (u >> 18));
        bytes.push(0x80 | ((u >> 12) & 0x3f));
        bytes.push(0x80 | ((u >> 6) & 0x3f));
        bytes.push(0x80 | (u & 0x3f));
      } else {
        bytes.push(0xe0 | (c >> 12));
        bytes.push(0x80 | ((c >> 6) & 0x3f));
        bytes.push(0x80 | (c & 0x3f));
      }
    }
    var out = "";
    for (var j = 0; j < bytes.length; j += 3) {
      var b0 = bytes[j];
      var b1 = j + 1 < bytes.length ? bytes[j + 1] : 0;
      var b2 = j + 2 < bytes.length ? bytes[j + 2] : 0;
      var n = (b0 << 16) | (b1 << 8) | b2;
      out += chars[(n >> 18) & 63];
      out += chars[(n >> 12) & 63];
      out += j + 1 < bytes.length ? chars[(n >> 6) & 63] : "=";
      out += j + 2 < bytes.length ? chars[n & 63] : "=";
    }
    return out;
  }

  function materializeBodies(req) {
    if (!req.requestBodyHex) req.requestBodyHex = chunksToHex(req.requestBodyB64Chunks);
    if (!req.responseBodyHex) req.responseBodyHex = chunksToHex(req.responseBodyB64Chunks);
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
    } catch (_) {
      return safeString(listObj);
    }
  }

  function copyResponseHeaders(req, conn) {
    if (!options.copyResponseHeaders || !req || !conn || Object.keys(req.responseHeaders).length > 0) return;
    try {
      var map = getFieldValue(conn, "mResponseHeadersMap");
      if (!map) return;
      var it = map.entrySet().iterator();
      while (it.hasNext()) {
        var entry = it.next();
        req.responseHeaders[safeString(entry.getKey())] = joinJavaList(entry.getValue());
      }
      state.stats.responseHeaders++;
    } catch (e) {
      state.stats.errors++;
      addEvent("copy response headers failed: " + e);
    }
  }

  function packetJson(req, reason) {
    materializeBodies(req);
    var extra = state.extraInfo || "";
    extra += (extra ? " " : "") + "emit=" + safeString(reason);
    if (req.xms) extra += " xm";
    if (req.requestBodyTruncated || req.responseBodyTruncated) {
      extra += " truncated request=" + req.requestBodyTruncated + " response=" + req.responseBodyTruncated;
    }
    return JSON.stringify({
      version: VERSION_NAME,
      version_code: VERSION_CODE,
      device_id: state.deviceId || "",
      url: req.url || "",
      method: req.httpMethod || "",
      headers: JSON.stringify(req.requestHeaders || {}),
      response_headers: JSON.stringify(req.responseHeaders || {}),
      raw_data: req.requestBodyHex || "",
      raw_data_md5: "",
      response_data: req.responseBodyHex || "",
      process: req.curProcess || state.processName || "com.ss.android.ugc.aweme",
      thread: req.curThread || "",
      request_start_time: req.requestStartTime || Date.now(),
      request_end_time: req.requestEndTime || Date.now(),
      net_type: "http",
      from: "frida",
      type: "hook",
      task_name: options.taskName,
      is_tablet: false,
      report_id: req.reportId || "",
      extra_info: extra
    });
  }

  function emitPacket(req, reason) {
    if (!req) return;
    req.requestEndTime = req.requestEndTime || Date.now();
    var one = packetJson(req, reason);
    state.lastPacket = one;
    state.stats.emitted++;
    log("packet-ready reason=" + safeString(reason) +
      " body_bytes=" + Number(req.requestBodyCount || 0) +
      " headers=" + Object.keys(req.requestHeaders || {}).length +
      " xm=" + (req.xms ? 1 : 0) +
      " url=" + shortText(req.url));
    log("packet-b64 " + utf8Base64(one));
    if (options.printPackets) log("packet-json " + one);
  }

  function addXmHeaders(nativeUrl, xms) {
    state.stats.xmHits++;
    var req = matchXMUrl(nativeUrl);
    if (!req) {
      addEvent("xm no match url=" + shortText(nativeUrl));
      return;
    }
    var headers = parseXmHeaders(xms);
    var keys = Object.keys(headers);
    for (var i = 0; i < keys.length; i++) req.requestHeaders[keys[i]] = headers[keys[i]];
    req.xms = safeString(xms);
    state.stats.xmMatched++;
    log("xm merged keys=" + keys.join(",") + " url=" + shortText(req.url));
    if (options.emitOnXmWithBody && req.requestBodyCount > 0 && !req.emittedXm) {
      req.emittedXm = true;
      emitPacket(req, "xm");
    }
  }

  function installJNHooks() {
    try {
      var JN = Java.use("J.N");
      var createReq = JN.MnXVOzVo.overload(
        "java.lang.Object", "long", "java.lang.String", "int", "int",
        "boolean", "boolean", "boolean", "int", "boolean", "int", "int", "long"
      );
      createReq.impl = function (a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
        var ret = this.$orig(a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
        state.stats.create++;
        var urlText = safeString(url);
        var ptrText = safeString(ret);
        if (ptrText !== "0" && isTargetUrl(urlText)) {
          state.stats.target++;
          var req = remember(ptrText, urlText);
          if (options.logCreateEvery > 0 && (state.stats.target <= 3 || state.stats.target % options.logCreateEvery === 0)) {
            log("create count=" + state.stats.target + " ptr=" + ptrText + " url=" + shortText(req.url));
          }
        } else {
          state.stats.filtered++;
        }
        return ret;
      };

      var setMethod = JN.MfdvbiJC.overload("long", "java.lang.Object", "java.lang.String");
      setMethod.impl = function (urlPtr, obj, method) {
        var req = matchUrlPtr(urlPtr);
        if (req) {
          req.httpMethod = safeString(method);
          state.stats.method++;
        }
        return this.$orig(urlPtr, obj, method);
      };

      var addReqHeader = JN.MtJFji5x.overload("long", "java.lang.Object", "java.lang.String", "java.lang.String");
      addReqHeader.impl = function (urlPtr, obj, key, value) {
        var req = matchUrlPtr(urlPtr);
        if (req) {
          addHeader(req, key, value);
          state.stats.header++;
        }
        return this.$orig(urlPtr, obj, key, value);
      };
      log("installed J.N URL/method/header hooks");
    } catch (e) {
      state.stats.errors++;
      addEvent("install J.N failed: " + e);
      log("install J.N failed: " + e);
    }
  }

  function installCronetHooks() {
    try {
      var Out = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetFixedModeOutputStream");
      var write = Out.write.overload("[B", "int", "int");
      write.impl = function (bytes, off, len) {
        var req = null;
        var encoded = null;
        try {
          if (options.captureBodies) {
            if (options.skipBodyOnMainThread && isMainThread()) {
              state.stats.skippedMainBody++;
            } else {
              var conn = getFieldValue(this, "mConnection");
              var url = urlFromConnection(conn);
              req = matchUrl(url) || ensureRequestForUrl(url, "write");
              if (req) encoded = encodeJavaBytesToBase64(bytes, off, len);
            }
          }
        } catch (e) {
          state.stats.errors++;
          addEvent("write pre failed: " + e);
        }
        var ret = this.$orig(bytes, off, len);
        try {
          if (req && encoded && encoded.text) {
            appendB64Chunk(req, "request", encoded);
            if (options.emitOnFirstBody && !req.emittedBody && req.requestBodyCount > 0) {
              req.emittedBody = true;
              emitPacket(req, "body");
            }
          }
        } catch (e2) {
          state.stats.errors++;
          addEvent("write append failed: " + e2);
        }
        return ret;
      };
      log("installed CronetFixedModeOutputStream.write hook");
    } catch (e) {
      state.stats.errors++;
      addEvent("install write failed: " + e);
      log("install write failed: " + e);
    }

    try {
      var In = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetInputStream");
      var read = In.read.overload("[B", "int", "int");
      read.impl = function (bytes, off, len) {
        var n = this.$orig(bytes, off, len);
        try {
          if (options.captureResponseBody) {
            var count = Number(n);
            if (count > 0) {
              var conn = getFieldValue(this, "mHttpURLConnection");
              var url = urlFromConnection(conn);
              var req = matchUrl(url) || ensureRequestForUrl(url, "read");
              if (req) {
                appendB64Chunk(req, "response", encodeJavaBytesToBase64(bytes, off, count));
                copyResponseHeaders(req, conn);
              }
            }
          }
        } catch (e) {
          state.stats.errors++;
          addEvent("read failed: " + e);
        }
        return n;
      };
      log("installed CronetInputStream.read hook captureResponseBody=" + options.captureResponseBody);
    } catch (e2) {
      state.stats.errors++;
      addEvent("install read failed: " + e2);
      log("install read failed: " + e2);
    }

    try {
      var Conn = Java.use("com.ttnet.org.chromium.net.urlconnection.CronetHttpURLConnection");
      var disconnect = Conn.disconnect.overload();
      disconnect.impl = function () {
        var req = null;
        try {
          var url = urlFromConnection(this);
          req = matchUrl(url) || ensureRequestForUrl(url, "disconnect");
          if (req) {
            req.requestEndTime = Date.now();
            copyResponseHeaders(req, this);
          }
        } catch (e) {
          state.stats.errors++;
          addEvent("disconnect pre failed: " + e);
        }
        var ret = this.$orig();
        try {
          if (req && options.emitOnDisconnect && !req.emittedFinal) {
            req.emittedFinal = true;
            state.stats.disconnect++;
            emitPacket(req, "disconnect");
            removeReq(req);
          }
        } catch (e2) {
          state.stats.errors++;
          addEvent("disconnect emit failed: " + e2);
        }
        return ret;
      };
      log("installed CronetHttpURLConnection.disconnect hook");
    } catch (e3) {
      state.stats.errors++;
      addEvent("install disconnect failed: " + e3);
      log("install disconnect failed: " + e3);
    }
  }

  function hookNativeAtBase(base) {
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
      }, desiredStealthValue());
      state.nativeHooked = true;
      log("hooked " + TARGET_MODULE + "+0x" + HTTP_CALLBACK_OFF.toString(16) + " @" + addr + " stealth=wxshadow");
    } catch (e) {
      state.stats.errors++;
      addEvent("native hook failed: " + e);
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
          if (base !== null) hookNativeAtBase(base);
        }
      }
    }, desiredStealthValue());
    log("watch loader " + symbol + " stealth=wxshadow");
  }

  function installNativeHook() {
    var base = Module.findBaseAddress(TARGET_MODULE);
    log("native install base=" + base);
    if (base !== null) hookNativeAtBase(base);
    if (!state.nativeHooked) {
      watchLoader("android_dlopen_ext");
      watchLoader("dlopen");
    }
  }

  function install() {
    if (state.installed) {
      log("already installed");
      return;
    }
    state.installed = true;
    configureStealth();
    initJavaMetadata();
    installJNHooks();
    installCronetHooks();
    installNativeHook();
  }

  var old = rpc.exports || {};
  old.urljnsummary = function () {
    return {
      installed: state.installed,
      nativeHooked: state.nativeHooked,
      counts: state.stats,
      pending: state.requests.length,
      taskName: options.taskName,
      deviceId: state.deviceId,
      processName: state.processName,
      filterAll: options.filterAll,
      captureBodies: options.captureBodies,
      captureResponseBody: options.captureResponseBody,
      events: state.events,
      lastPacket: state.lastPacket
    };
  };
  old.slimsummary = old.urljnsummary;
  rpc.exports = old;

  try {
    if (typeof Java !== "undefined" && Java && typeof Java.ready === "function") Java.ready(install);
    else install();
  } catch (e) {
    state.stats.errors++;
    addEvent("Java.ready failed: " + e);
    log("Java.ready failed, installing directly: " + e);
    install();
  }
})();
