# 350101 自动采集摘要

- result: not-started
- exit_status: 1
- serial: 18201FDF6002GR
- package: com.ss.android.ugc.aweme
- seconds: 180
- tag: ssl_frida_attach
- engine: frida
- frida_bin: /Users/freeman/project/douyin/dyidre/.venv-frida350/bin/frida
- frida_server: /data/local/tmp/frida-server-17.17.0
- frida_mode: attach
- frida_attach_delay: 0s
- frida_runtime: qjs
- mitm_proxy: 192.168.31.84:8080
- old_proxy: 192.168.31.84:8080
- proxy_restored: 1
- clear_app_data: 0
- force_stop_app: 1
- ssl_js_local: /Users/freeman/project/douyin/dyidre/probes/350101/runtime_ssl.js
- ssl_js_remote: /data/local/tmp/metasec_ssl_single_350101_ssl_frida_attach.js
- ssl_js_log_remote: /data/local/tmp/metasec_ssl_single_350101_ssl_frida_attach.console.log（手机端实时日志）

## 产物

- flows.mitm：唯一默认数据产物，可用 mitmweb -r 查看。
- run_parameters.txt / device_state_*.txt：本次参数和设备前后状态。
- mitmdump.log / rf_runner.console.log / auto_skip_popups.log：排错日志。

## 复核

先确认代理已恢复，再用 mitmweb -r flows.mitm 查看样本。
