#!/usr/bin/env python3
"""ida_mcp.py — 直连本机 IDA Pro MCP 插件（SSE 传输, localhost:13337）的
极简 JSON-RPC 客户端。运行时的工具表没登记该 MCP server，因此走
SSE 端点直接对话。传输层用裸 socket——该服务器（Qt 内置）与
requests/urllib3 的分块解码不兼容（握手后正文不到达），裸 socket 正常。

用法:
  python3 ida_mcp.py list-tools
  python3 ida_mcp.py call <tool_name> '<json_args>'
  python3 ida_mcp.py call-batch <file.jsonl>   # 每行 {"tool":..,"args":{..}}
"""
import json, queue, socket, sys, threading, time

HOST, PORT = "127.0.0.1", 13337


def _read_headers(f):
    """读 HTTP 响应头，返回状态行+头 dict；socket.makefile 逐行读。"""
    status = f.readline().decode("latin1").strip()
    headers = {}
    while True:
        line = f.readline().decode("latin1").strip()
        if not line:
            break
        k, _, v = line.partition(":")
        headers[k.strip().lower()] = v.strip()
    return status, headers


class IdaMcp:
    """SSE 长连接客户端。生命周期：__init__ 建连并等 endpoint 事件 → init() 握手
    → tool()/call() 发起调用并同步等响应。
    方法速查：
      _open()   建立 /sse 长连接，起 _pump 线程，等 endpoint 事件拿到回投路径
      _readline()  兼容 chunked / 裸流两种传输的行读取
      _pump()   后台线程：把 SSE 事件流拆成 endpoint/message 事件，message 入 inbox
      _post()   每条 JSON-RPC 单独起一个 POST 短连接（Connection: close）
      call()    发一个 JSON-RPC 请求并阻塞等同 id 响应（超时 self.timeout 秒）
      init()    MCP 握手：initialize + notifications/initialized
      tool()    调 tools/call 并把 text 内容拼成字符串返回（另返回原始 result）
    """
    def __init__(self, timeout=120):
        self.timeout = timeout
        self.msg_path = None
        self.inbox = queue.Queue()
        self._id = 0
        self._open()

    def _open(self):
        # SSE 长连接：endpoint 事件给出回投路径，message 事件带回响应
        self.sock = socket.create_connection((HOST, PORT), timeout=self.timeout)
        self.sock.sendall(b"GET /sse HTTP/1.1\r\nHost: localhost\r\n"
                          b"Accept: text/event-stream\r\n\r\n")
        self.sf = self.sock.makefile("rb")
        status, headers = _read_headers(self.sf)
        if "200" not in status:
            raise RuntimeError(f"SSE handshake failed: {status}")
        self.chunked = "chunked" in headers.get("transfer-encoding", "")
        t = threading.Thread(target=self._pump, daemon=True)
        t.start()
        deadline = time.time() + 30
        while self.msg_path is None:
            if time.time() > deadline:
                raise TimeoutError("no endpoint event from SSE stream")
            time.sleep(0.01)

    def _readline(self):
        """兼容 chunked / 裸流的行读取。"""
        if self.chunked:
            n = int(self.sf.readline().strip() or b"0", 16)
            if n == 0:
                return b""
            data = self.sf.read(n)
            self.sf.read(2)                    # CRLF
            # 一个 chunk 可能带多行；简单起见按整段返回（事件解析按行切）
            return data
        return self.sf.readline()

    def _pump(self):
        ev, buf = None, []
        pending = b""
        while True:
            try:
                chunk = self._readline()
            except Exception:
                return
            if not chunk:
                return
            pending += chunk
            while b"\n" in pending:
                line, pending = pending.split(b"\n", 1)
                raw = line.decode("utf-8", "replace").rstrip("\r")
                if raw.startswith("event:"):
                    ev = raw[6:].strip()
                elif raw.startswith("data:"):
                    buf.append(raw[5:].strip())
                elif raw == "":
                    if ev == "endpoint" and buf:
                        self.msg_path = "".join(buf).strip()
                    elif ev == "message" and buf:
                        try:
                            self.inbox.put(json.loads("".join(buf)))
                        except Exception:
                            pass
                    ev, buf = None, []

    def _post(self, body):
        s = socket.create_connection((HOST, PORT), timeout=self.timeout)
        payload = json.dumps(body).encode()
        s.sendall(b"POST " + self.msg_path.encode() + b" HTTP/1.1\r\n"
                  b"Host: localhost\r\nContent-Type: application/json\r\n"
                  b"Content-Length: " + str(len(payload)).encode() +
                  b"\r\nConnection: close\r\n\r\n" + payload)
        f = s.makefile("rb")
        status, headers = _read_headers(f)
        s.close()
        if "200" not in status and "202" not in status:
            raise RuntimeError(f"POST failed: {status}")

    def call(self, method, params=None):
        self._id += 1
        rid = self._id
        body = {"jsonrpc": "2.0", "id": rid, "method": method}
        if params is not None:
            body["params"] = params
        self._post(body)
        if method == "notifications/initialized":
            return None
        while True:
            msg = self.inbox.get(timeout=self.timeout)
            if msg.get("id") == rid:
                return msg

    def init(self):
        r = self.call("initialize", {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {"name": "dyidre-direct", "version": "1.0"}})
        self.call("notifications/initialized")
        return r

    def tool(self, name, args=None):
        r = self.call("tools/call", {"name": name, "arguments": args or {}})
        res = r.get("result", {})
        out = []
        for c in res.get("content", []):
            if c.get("type") == "text":
                out.append(c["text"])
        return "\n".join(out), res


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "list-tools"
    m = IdaMcp()
    m.init()
    if cmd == "list-tools":
        r = m.call("tools/list", {})
        tools = r.get("result", {}).get("tools", [])
        for t in tools:
            print(f"{t['name']}: {t.get('description','')[:100]}")
        print(f"[{len(tools)} tools]")
    elif cmd == "call":
        name, args = sys.argv[2], json.loads(sys.argv[3]) if len(sys.argv) > 3 else {}
        text, _ = m.tool(name, args)
        print(text)
    elif cmd == "call-batch":
        ok = err = 0
        for line in open(sys.argv[2]):
            line = line.strip()
            if not line:
                continue
            req = json.loads(line)
            try:
                text, _ = m.tool(req["tool"], req.get("args", {}))
                print(json.dumps({"req": req, "text": text}, ensure_ascii=False))
                ok += 1
            except Exception as e:
                print(json.dumps({"req": req, "error": str(e)}, ensure_ascii=False))
                err += 1
        print(f"[batch done: {ok} ok, {err} err]", file=sys.stderr)


if __name__ == "__main__":
    main()
