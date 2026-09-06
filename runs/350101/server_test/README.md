# 服务端验证实验记录（2026-09-05）

目的：验证 unidbg 产出的 X-* 签名头能否过真实服务端。

## 方法

从 9-02 抓包（`runs/350101/packet_capture/frida_capture_from_run_metasec_norestart_20260902_002925/packets_seen.jsonl`）
导出真实请求（URL/headers/body），刷新 ts/_rticket，用 unidbg（当前时间、非 deterministic）
实时签名，curl 重放；同时跑**无签名对照组**隔离签名变量。

## 结果

| 端点 | 无签名 | unidbg 签名 | 结论 |
|---|---|---|---|
| POST /service/2/app_log/ | `error data` | `error data` | ❌ 坏 oracle：响应无区分度（body 与会话密钥绑定，重放必然解不开） |
| GET /service/settings/v3/ | status_code 0 正常数据 | — | ❌ 不验签 |
| GET /aweme/homepage/component/ | status_code 0 | — | ❌ 不验签 |
| GET /aweme/v2/undertaking/settings/ | status_code 0 | — | ❌ 不验签 |
| POST polaris luckycat refresh_act_id | err_no 0 | — | ❌ 不验签 |
| POST /aweme/v2/feed/ | **返回真实 feed 数据**（70KB protobuf，43 个视频 ID） | — | ⚠️ 此 profile 下 feed 不强制验签 |
| POST mssdk sdi/get_token | 200，76 字节二进制响应 | — | ❓ 无法区分接受/拒绝 |

## 关键结论

1. **app_log 不能当 oracle**：带不带签名头响应完全一样。
2. **feed 在此设备/IP profile 下不强制 X-***：无签名也拿到真实数据。
   风控可能是"静默打标 + 降级"，而非硬拒绝。
3. 剩余可信 oracle 候选：
   - mssdk 自有端点（get_token / ri/report，二进制协议需解码）
   - 状态变更类端点（digg/follow，强验签但有真实副作用）
4. rootfs 已与真机当前状态同步（16 文件，含 .msfs_9893 和 0 字节 .ms 标记）。
5. 真机上同样不存在 .msp_3dddca0f/.msp_f0a386 —— unidbg faccessat 失败即真机行为，非缺口。

## 产物

- `s1.txt`/`s2.txt`/`body.bin` — app_log 请求素材
- `feed_orig.url`/`feed_orig.headers.json`/`feed_body.bin` — feed 请求素材（body md5 与 stub 不匹配，抓包截获的是编码前 buffer）
- `sign_live.log` — unidbg 实时签名输出（X-Khronos=1788609209）
- `curl_cmd.json`、`response.txt` — app_log 重放命令与响应
- `feed_unsigned_resp.bin` — 无签名 feed 响应（真实数据）
- `sdi_unsigned_resp.bin` — sdi get_token 无签名响应
