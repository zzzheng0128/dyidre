# recovery_test_drive.py — 无头 IDA 驱动：全新库上跑 dyidre 恢复脚本并另存 i64
# 用法: idat -A -S<本文件> <隔离目录>/libmetasec_ml.so
import runpy, json, ida_loader, ida_nalt, ida_kernwin, ida_auto

RECOVERY = "/Users/freeman/project/douyin/dyidre/skills/ida_apply_dyidre_enrich_9_3.py"
OUT_I64 = "/Users/freeman/project/douyin/dyidre/metasec_350101/recovery_test/libmetasec_ml_so_recovered.i64"
OUT_STATS = "/Users/freeman/project/douyin/dyidre/metasec_350101/recovery_test/restore_stats.json"

ida_auto.auto_wait()  # 先等自动分析完
mod = runpy.run_path(RECOVERY, run_name="dyidre_enrich_recovery")
mod["validate_target"]()
stats = mod["restore"](dry_run=False)
ok = ida_loader.save_database(OUT_I64, 0)
stats["saved"] = bool(ok)
json.dump(stats, open(OUT_STATS, "w"))
print("RECOVERY_TEST_DONE", json.dumps(stats))
ida_kernwin.exit(0)
