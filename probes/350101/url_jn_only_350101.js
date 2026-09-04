// Slim rustFrida packet probe for Douyin 35.1.0 / 350101.
//
// Keeps the old stable "single JS intercept URL" path under rustFrida+wxshadow,
// then adds only the light pieces needed for upload:
//   - J.N.MnXVOzVo/MfdvbiJC/MtJFji5x: URL/method/request headers;
//   - libmetasec_ml.so+0x14DBF4: MetaSec X-* header string;
//   - async Java HttpURLConnection POST to dydcd /up/dy/packets.
//
// It deliberately does not hook Cronet stream body. Body capture is the noisy
// path that caused LocalRef/ANR issues and should be reintroduced separately.

if (false) Java.setStealth(Hook.WXSHADOW);

(function () {
  var TAG = "[slim350]";
  var VERSION_CODE = "350101";
  var VERSION_NAME = "35.1.0";
  var TARGET_MODULE = "libmetasec_ml.so";
  var HTTP_CALLBACK_OFF = 0x14dbf4;

  var installed = false;
  var nativeHooked = false;
  var loaderHooked = {};
  var reqByPtr = {};
  var reqs = [];
  var uploadQueue = [];
  var uploadWorkerRunning = false;
  var uploaderClass = null;
  var deviceId = "";
  var processName = "com.ss.android.ugc.aweme";
  var extraInfo = "";
  var lastPacket = "";

  var cfg = globalThis.METASEC_SLIM_CONFIG || {};
  var uploadUrl = String(cfg.uploadUrl || "http://127.0.0.1:8891/up/dy/packets");
  var taskName = String(cfg.taskName || "url_jn_slim_capture");
  var uploadEnabled = cfg.upload === undefined ? true : !!cfg.upload;
  var maxPending = Number(cfg.maxPending || 64);
  var maxQueue = Number(cfg.maxQueue || 8);
  var logUrlMax = Number(cfg.logUrlMax || 220);
  var filters = cfg.filters || [
    "get_token",
    "/passport/ticket_guard/get_client_cert/",
    "/device_register",
    "/captcha/verify",
    "/captcha/get"
  ];

  var counts = {
    create: 0,
    target: 0,
    method: 0,
    header: 0,
    xmHits: 0,
    xmMatched: 0,
    uploadQueued: 0,
    uploadStarted: 0,
    uploaded: 0,
    uploadFailed: 0,
    uploadDropped: 0,
    errors: 0
  };

  function log(s) {
    try {
      console.log(TAG + " " + String(s));
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
    var n = Number(maxLen || logUrlMax || 220);
    if (!s || n <= 0 || s.length <= n) return s;
    return s.substring(0, n) + "...(" + s.length + ")";
  }

  function currentThreadInfo() {
    try {
      return "tid_" + Process.getCurrentThreadId();
    } catch (_) {
      return "tid_unknown";
    }
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

  function isTargetUrl(url) {
    var s = safeString(url);
    if (!s) return false;
    if (cfg.filterAll) return true;
    for (var i = 0; i < filters.length; i++) {
      if (s.indexOf(String(filters[i])) >= 0) return true;
    }
    return false;
  }

  function extractPath(url) {
    var s = safeString(url);
    var m = s.match(/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\/[^\/?#]+([^?#]*)/);
    if (m) return m[1] || "/";
    return s.split("?")[0];
  }

  function remember(ptrText, url) {
    var req = {
      ptr: safeString(ptrText),
      url: safeString(url),
      method: "",
      headers: {},
      headerCount: 0,
      xms: "",
      thread: currentThreadInfo(),
      startedAt: Date.now()
    };
    reqByPtr[req.ptr] = req;
    reqs.push(req);
    while (reqs.length > maxPending) {
      var old = reqs.shift();
      if (old && old.ptr) delete reqByPtr[old.ptr];
    }
    return req;
  }

  function removeReq(req) {
    if (!req) return;
    if (req.ptr) delete reqByPtr[req.ptr];
    for (var i = reqs.length - 1; i >= 0; i--) {
      if (reqs[i] === req) {
        reqs.splice(i, 1);
        break;
      }
    }
  }

  function matchXMUrl(nativeUrl) {
    var target = safeString(nativeUrl);
    if (!target) return null;
    for (var i = reqs.length - 1; i >= 0; i--) {
      var req = reqs[i];
      if (!req || !req.url) continue;
      var path = extractPath(req.url);
      if (path && path !== "/" && target.indexOf(path) >= 0) return req;
    }
    return null;
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
    for (var i = off; i < end; i++) out.push(byteToHex(arr[i]));
    return out.join("");
  }

  function utf8Bytes(text) {
    var JString = Java.use("java.lang.String");
    var s = JString.$new(String(text || ""));
    return s.getBytes.overload("java.lang.String").call(s, "UTF-8");
  }

  function md5Hex(text) {
    try {
      var MessageDigest = Java.use("java.security.MessageDigest");
      var md = MessageDigest.getInstance("MD5");
      var bytes = utf8Bytes(text || "");
      return javaByteArrayToHex(md.digest.overload("[B").call(md, bytes), 0, 16);
    } catch (_) {
      return "";
    }
  }

  function packetJson(req) {
    return JSON.stringify({
      version: VERSION_NAME,
      version_code: VERSION_CODE,
      device_id: deviceId || "",
      url: req.url || "",
      method: req.method || "",
      headers: JSON.stringify(req.headers || {}),
      response_headers: "{}",
      raw_data: "",
      raw_data_md5: md5Hex(""),
      response_data: "",
      process: processName || "com.ss.android.ugc.aweme",
      thread: req.thread || "",
      request_start_time: req.startedAt || Date.now(),
      request_end_time: Date.now(),
      net_type: "http",
      from: "frida",
      type: "hook",
      task_name: taskName,
      is_tablet: false,
      report_id: "",
      extra_info: extraInfo + (req.xms ? " slim-xm" : " slim-no-xm")
    });
  }

  function postJson(url, body) {
    var URL = Java.use("java.net.URL");
    var HttpURLConnection = Java.use("java.net.HttpURLConnection");
    var conn = Java.cast(URL.$new(url).openConnection(), HttpURLConnection);
    conn.setConnectTimeout(Number(cfg.connectTimeoutMs || 3000));
    conn.setReadTimeout(Number(cfg.readTimeoutMs || 3000));
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
    if (uploaderClass) return uploaderClass;
    var Runnable = Java.use("java.lang.Runnable");
    uploaderClass = Java.registerClass({
      name: "com.dyidre.frida.SlimPacketUploadWorker" + VERSION_CODE + "_" + Process.id + "_" + Date.now(),
      implements: [Runnable],
      methods: {
        run: function () {
          try {
            while (uploadQueue.length > 0) {
              var req = uploadQueue.shift();
              var one = packetJson(req);
              lastPacket = one;
              if (cfg.printPackets) log("packet-json " + one);
              var body = JSON.stringify({ device_id: deviceId || "", packets: [one] });
              var code = postJson(uploadUrl, body);
              if (code >= 200 && code < 300) {
                counts.uploaded++;
                log("uploaded code=" + code + " url=" + shortText(req.url));
              } else {
                counts.uploadFailed++;
                log("upload http code=" + code + " url=" + shortText(req.url));
              }
            }
          } catch (e) {
            counts.uploadFailed++;
            log("upload worker failed: " + e);
          } finally {
            uploadWorkerRunning = false;
            if (uploadQueue.length > 0) {
              try { startUploadWorker(); } catch (e2) {
                counts.uploadFailed++;
                log("upload worker restart failed: " + e2);
              }
            }
          }
        }
      }
    });
    return uploaderClass;
  }

  function startUploadWorker() {
    if (uploadWorkerRunning || uploadQueue.length <= 0) return;
    var Thread = Java.use("java.lang.Thread");
    var Uploader = ensureUploaderClass();
    var worker = Uploader.$new();
    var thread = Thread.$new(worker, "dyidre-slim-packet-upload");
    try { thread.setDaemon(true); } catch (_) {}
    uploadWorkerRunning = true;
    counts.uploadStarted++;
    thread.start();
    log("upload worker start queued=" + uploadQueue.length);
  }

  function uploadReq(req) {
    if (!req) return;
    if (!uploadEnabled) {
      lastPacket = packetJson(req);
      log("upload disabled; built packet url=" + shortText(req.url));
      return;
    }
    while (uploadQueue.length >= maxQueue) {
      uploadQueue.shift();
      counts.uploadDropped++;
    }
    uploadQueue.push(req);
    counts.uploadQueued++;
    startUploadWorker();
    log("upload queued url=" + shortText(req.url));
  }

  function addXmHeaders(nativeUrl, xms) {
    counts.xmHits++;
    var req = matchXMUrl(nativeUrl);
    if (!req) {
      log("xm no match url=" + shortText(nativeUrl));
      return;
    }
    var headers = parseXmHeaders(xms);
    Object.keys(headers).forEach(function (k) {
      req.headers[k] = headers[k];
    });
    req.xms = safeString(xms);
    counts.xmMatched++;
    log("xm matched url=" + shortText(req.url) + " keys=" + Object.keys(headers).join(","));
    uploadReq(req);
    removeReq(req);
  }

  function initJavaMetadata() {
    try {
      var Build = Java.use("android.os.Build");
      var Version = Java.use("android.os.Build$VERSION");
      extraInfo = safeString(Build.MANUFACTURER.value) + "-" + safeString(Build.PRODUCT.value) + "-" + safeString(Version.SDK_INT.value);
    } catch (_) {
      extraInfo = "";
    }
    try {
      var ActivityThread = Java.use("android.app.ActivityThread");
      var app = ActivityThread.currentApplication();
      if (app) {
        var SettingsSecure = Java.use("android.provider.Settings$Secure");
        deviceId = safeString(SettingsSecure.getString(app.getContentResolver(), "android_id"));
      }
      var proc = ActivityThread.currentProcessName();
      if (proc) processName = safeString(proc);
    } catch (_) {}
    if (!deviceId || deviceId === "undefined" || deviceId === "null") {
      deviceId = "rf-" + processName + "-" + (Process.id || 0);
    }
    log("java ready uploadUrl=" + uploadUrl + " device_id=" + deviceId + " process=" + processName);
  }

  function installJNHooks() {
    var JN = Java.use("J.N");
    var createReq = JN.MnXVOzVo.overload(
      "java.lang.Object", "long", "java.lang.String", "int", "int",
      "boolean", "boolean", "boolean", "int", "boolean", "int", "int", "long"
    );
    createReq.impl = function (a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
      var ret = this.$orig(a0, a1, url, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
      counts.create++;
      var urlText = safeString(url);
      var ptrText = safeString(ret);
      if (ptrText !== "0" && isTargetUrl(urlText)) {
        counts.target++;
        remember(ptrText, urlText);
        log("create ptr=" + ptrText + " url=" + shortText(urlText));
      }
      return ret;
    };

    var setMethod = JN.MfdvbiJC.overload("long", "java.lang.Object", "java.lang.String");
    setMethod.impl = function (urlPtr, obj, method) {
      var ptrText = safeString(urlPtr);
      var req = reqByPtr[ptrText];
      if (req) {
        req.method = safeString(method);
        counts.method++;
        log("method ptr=" + ptrText + " method=" + req.method + " url=" + shortText(req.url));
      }
      return this.$orig(urlPtr, obj, method);
    };

    var addReqHeader = JN.MtJFji5x.overload("long", "java.lang.Object", "java.lang.String", "java.lang.String");
    addReqHeader.impl = function (urlPtr, obj, key, value) {
      var ptrText = safeString(urlPtr);
      var req = reqByPtr[ptrText];
      if (req) {
        req.headerCount++;
        counts.header++;
        var k = safeString(key);
        req.headers[k] = safeString(value);
        if (/^(x-|content-type|user-agent|cookie)$/i.test(k)) {
          log("header ptr=" + ptrText + " " + k + "=" + safeString(value));
        }
      }
      return this.$orig(urlPtr, obj, key, value);
    };

    log("installed J.N URL/method/header hooks");
  }

  function hookNativeAtBase(base) {
    if (nativeHooked) return;
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
      nativeHooked = true;
      log("hooked " + TARGET_MODULE + "+0x" + HTTP_CALLBACK_OFF.toString(16) + " @" + addr + " stealth=wxshadow");
    } catch (e) {
      counts.errors++;
      log("native hook failed: " + e);
    }
  }

  function watchLoader(symbol) {
    if (loaderHooked[symbol]) return;
    var p = Module.findExportByName(null, symbol);
    if (p === null) return;
    loaderHooked[symbol] = true;
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
    if (!nativeHooked) {
      watchLoader("android_dlopen_ext");
      watchLoader("dlopen");
    }
  }

  function install() {
    if (installed) {
      log("already installed");
      return;
    }
    installed = true;

    try {
      try {
        log("stealth before=" + Java.getStealth());
        Java.setStealth(desiredStealthValue());
        log("stealth after=" + Java.getStealth());
      } catch (e0) {
        log("setStealth(WXSHADOW) failed: " + e0);
      }

      initJavaMetadata();
      installJNHooks();
      installNativeHook();
    } catch (e) {
      counts.errors++;
      log("install failed: " + e);
    }
  }

  var old = rpc.exports || {};
  old.urljnsummary = function () {
    return {
      installed: installed,
      nativeHooked: nativeHooked,
      counts: counts,
      active: Object.keys(reqByPtr).length,
      uploadUrl: uploadUrl,
      taskName: taskName,
      deviceId: deviceId,
      processName: processName,
      lastPacket: lastPacket
    };
  };
  old.slimsummary = old.urljnsummary;
  rpc.exports = old;

  try {
    if (typeof Java !== "undefined" && Java && typeof Java.ready === "function") {
      Java.ready(install);
    } else {
      install();
    }
  } catch (e) {
    counts.errors++;
    log("Java.ready scheduling failed, installing directly: " + e);
    install();
  }
})();
