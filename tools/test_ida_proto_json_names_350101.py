"""离线模拟 IDA 接口测试；不加载/修改真实数据库。"""

import importlib.util
import json
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch


SKILLS = Path(__file__).resolve().parents[1] / "skills"
SCRIPT = SKILLS / "ida_apply_proto_json_names_350101.py"


def load_module(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


restore = load_module(SCRIPT, "proto_json_restore_tested")


class FakeIDA:
    def __init__(self, directory, base=0):
        self.base = base
        self.digest = bytes.fromhex(restore.EXPECTED_SHA256)
        self.input_path = str(directory / "absent_input.so")
        self.idb_path = str(directory / "working.i64")
        self.processor = "ARM"
        self.is64 = True
        self.big_endian = False
        self.analysis_ready = True
        self.names = {base + rva: f"sub_{base + rva:X}" for rva, _, _ in restore.FUNCTIONS}
        self.memory = {base + rva: bytes.fromhex(signature) for rva, _, signature in restore.FUNCTIONS}
        self.entries = {ea: ea for ea in self.names}
        self.user_names = set()
        self.rename_calls = []
        self.save_calls = []
        self.messages = []
        self.fail_at = None
        self.save_ok = True
        self.badaddr = (1 << 64) - 1
        self.api = SimpleNamespace(
            auto=SimpleNamespace(auto_wait=lambda: self.analysis_ready),
            info=SimpleNamespace(
                inf_is_64bit=lambda: self.is64, inf_is_be=lambda: self.big_endian,
                inf_get_procname=lambda: self.processor,
            ),
            nalt=SimpleNamespace(
                retrieve_input_file_sha256=lambda: self.digest,
                get_input_file_path=lambda: self.input_path,
                get_imagebase=lambda: self.base,
            ),
            loader=SimpleNamespace(
                PATH_TYPE_IDB=1, get_path=lambda _: self.idb_path,
                save_database=self.save,
            ),
            name=SimpleNamespace(
                get_name=lambda ea: self.names.get(ea, ""),
                get_name_ea=self.lookup_name, set_name=self.rename,
                SN_CHECK=0, SN_NOWARN=1, SN_NON_AUTO=2,
            ),
            bytes=SimpleNamespace(
                get_bytes=lambda ea, size: self.memory.get(ea, b"")[:size],
                get_flags=lambda ea: ea in self.user_names,
                has_user_name=bool,
            ),
            funcs=SimpleNamespace(get_func=lambda ea: (
                SimpleNamespace(start_ea=self.entries[ea]) if ea in self.entries else None
            )),
            const=SimpleNamespace(BADADDR=self.badaddr),
            ui=SimpleNamespace(msg=self.messages.append, refresh_idaview_anyway=lambda: None),
        )

    def lookup_name(self, _, name):
        return next((ea for ea, current in self.names.items() if current == name), self.badaddr)

    def rename(self, ea, name, flags):
        self.rename_calls.append((ea, name, flags))
        if ea == self.fail_at or self.lookup_name(None, name) not in (ea, self.badaddr):
            return False
        self.names[ea] = name
        self.user_names.add(ea)
        return True

    def save(self, path, flags):
        self.save_calls.append((path, flags))
        return self.save_ok


class RestoreNamesTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.fake = FakeIDA(self.root)
        self.audit = self.root / "audit"
        self.addCleanup(patch.stopall)
        patch.object(restore, "_ida", return_value=self.fake.api).start()
        patch.object(restore, "_refresh", return_value=[]).start()

    def run_restore(self, **kwargs):
        return restore.restore_names(audit_dir=self.audit, **kwargs)

    def assert_no_writes(self):
        self.assertEqual(self.fake.rename_calls, [])
        self.assertEqual(self.fake.save_calls, [])
        self.assertFalse(self.audit.exists())

    def test_dry_run_is_read_only(self):
        result = self.run_restore(dry_run=True)
        self.assertEqual(result["counts"], {"pending": 11})
        self.assert_no_writes()

    def test_apply_saves_old_names_and_current_database(self):
        original = dict(self.fake.names)
        result = self.run_restore()
        self.assertEqual(result["counts"], {"renamed": 11})
        self.assertEqual(self.fake.save_calls, [(self.fake.idb_path, 0)])
        run_dir = Path(result["audit_dir"])
        before = json.loads((run_dir / "before.json").read_text())
        self.assertEqual(before["status"], "prepared")
        for row in before["rows"]:
            self.assertEqual(row["old"], original[int(row["ea"], 16)])
        after = json.loads((run_dir / "result.json").read_text())
        self.assertEqual(after["status"], "applied_saved")
        self.assertTrue(after["saved"])
        self.assertNotIn(0x10CAAC, self.fake.names)

    def test_second_run_has_no_new_writes(self):
        self.run_restore()
        original_runs = list(self.audit.iterdir())
        self.fake.rename_calls.clear()
        self.fake.save_calls.clear()
        result = self.run_restore()
        self.assertEqual(result["counts"], {"already_present": 11})
        self.assertEqual(self.fake.rename_calls, [])
        self.assertEqual(self.fake.save_calls, [])
        self.assertEqual(list(self.audit.iterdir()), original_runs)

    def test_preserves_manual_names(self):
        ea = restore.FUNCTIONS[0][0]
        self.fake.names[ea] = "my_reviewed_parser"
        self.fake.user_names.add(ea)
        result = self.run_restore()
        self.assertEqual(result["counts"]["skip_existing_name"], 1)
        self.assertEqual(result["counts"]["renamed"], 10)
        self.assertEqual(self.fake.names[ea], "my_reviewed_parser")

    def test_preserves_user_flag_even_for_default_spelling(self):
        ea = restore.FUNCTIONS[0][0]
        original = self.fake.names[ea]
        self.fake.user_names.add(ea)
        result = self.run_restore()
        self.assertEqual(result["counts"]["skip_existing_name"], 1)
        self.assertEqual(self.fake.names[ea], original)

    def test_name_collision_does_not_force_suffix_or_overwrite(self):
        self.fake.names[0x1234] = restore.FUNCTIONS[0][1]
        result = self.run_restore()
        self.assertEqual(result["counts"]["skip_name_collision"], 1)
        self.assertEqual(self.fake.names[0x1234], restore.FUNCTIONS[0][1])
        self.assertNotIn(restore.FUNCTIONS[0][0], [item[0] for item in self.fake.rename_calls])

    def test_missing_and_interior_entries_are_skipped(self):
        first, second = (item[0] for item in restore.FUNCTIONS[:2])
        del self.fake.entries[first]
        self.fake.entries[second] = second - 4
        result = self.run_restore()
        self.assertEqual(result["counts"]["skip_not_function_entry"], 2)
        self.assertEqual(result["counts"]["renamed"], 9)

    def test_late_byte_mismatch_aborts_before_any_write(self):
        self.fake.memory[restore.FUNCTIONS[-1][0]] = b"\x00" * 12
        with self.assertRaisesRegex(RuntimeError, "入口字节"):
            self.run_restore()
        self.assert_no_writes()

    def test_wrong_input_hash_aborts(self):
        self.fake.digest = b"\x00" * 32
        with self.assertRaisesRegex(RuntimeError, "SHA-256"):
            self.run_restore()
        self.assert_no_writes()

    def test_moved_or_replaced_disk_input_is_not_silently_trusted(self):
        source = self.root / "different.so"
        source.write_bytes(b"not the matching ELF")
        self.fake.input_path = str(source)
        with self.assertRaisesRegex(RuntimeError, "磁盘 SO"):
            self.run_restore()
        self.assert_no_writes()

    def test_hash_bridge_accepts_hex_text(self):
        for digest in (restore.EXPECTED_SHA256.upper(), restore.EXPECTED_SHA256.encode("ascii")):
            with self.subTest(digest=type(digest)):
                self.fake.digest = digest
                result = self.run_restore(dry_run=True)
                self.assertEqual(result["counts"], {"pending": 11})
        self.assert_no_writes()

    def test_wrong_architecture_aborts(self):
        for field, value in (("is64", False), ("big_endian", True), ("processor", "metapc")):
            with self.subTest(field=field):
                original = getattr(self.fake, field)
                setattr(self.fake, field, value)
                with self.assertRaisesRegex(RuntimeError, "AArch64"):
                    self.run_restore()
                setattr(self.fake, field, original)
        self.assert_no_writes()

    def test_cancelled_analysis_aborts(self):
        self.fake.analysis_ready = False
        with self.assertRaisesRegex(RuntimeError, "自动分析"):
            self.run_restore()
        self.assert_no_writes()

    def test_rebased_database_uses_rvas(self):
        rebased = FakeIDA(self.root, base=0x10000000)
        with patch.object(restore, "_ida", return_value=rebased.api):
            result = self.run_restore()
        self.assertEqual(result["counts"], {"renamed": 11})
        self.assertEqual(rebased.rename_calls[0][0], rebased.base + restore.FUNCTIONS[0][0])

    def test_outer_recovery_can_defer_save(self):
        result = self.run_restore(save=False)
        self.assertEqual(result["status"], "applied_not_saved")
        self.assertFalse(result["saved"])
        self.assertEqual(self.fake.save_calls, [])

    def test_partial_rename_failure_is_recorded_not_claimed_success(self):
        self.fake.fail_at = restore.FUNCTIONS[1][0]
        with self.assertRaisesRegex(RuntimeError, "set_name"):
            self.run_restore()
        result = json.loads(next(self.audit.glob("run_*/result.json")).read_text())
        self.assertEqual(result["status"], "failed")
        self.assertEqual(result["counts"], {"renamed": 1, "rename_failed": 1, "pending": 9})
        self.assertFalse(result["saved"])
        self.assertEqual(self.fake.save_calls, [])

    def test_save_failure_keeps_audit_and_reports_in_memory_changes(self):
        self.fake.save_ok = False
        with self.assertRaisesRegex(RuntimeError, "保存当前 IDB 失败"):
            self.run_restore()
        result = json.loads(next(self.audit.glob("run_*/result.json")).read_text())
        self.assertEqual(result["status"], "failed")
        self.assertEqual(result["counts"], {"renamed": 11})
        self.assertFalse(result["saved"])

    def test_name_changed_after_preflight_is_not_overwritten(self):
        original_writer = restore._write_new_json
        changed_ea = restore.FUNCTIONS[0][0]

        def write_then_change(path, value):
            original_writer(path, value)
            if path.name == "before.json":
                self.fake.names[changed_ea] = "new_manual_name"

        with patch.object(restore, "_write_new_json", side_effect=write_then_change):
            with self.assertRaisesRegex(RuntimeError, "预检后发生变化"):
                self.run_restore()
        self.assertEqual(self.fake.names[changed_ea], "new_manual_name")
        self.assertEqual(self.fake.rename_calls, [])

    def test_full_recovery_runs_guard_before_old_passes(self):
        bindings = {
            "ida_auto": self.fake.api.auto, "ida_kernwin": self.fake.api.ui,
            "ida_loader": self.fake.api.loader, "ida_nalt": self.fake.api.nalt,
        }
        with patch.dict(sys.modules, bindings):
            module = load_module(SKILLS / "ida_rehydrate_350101_9_3.py", "rehydrate_tested")
        module.RECOVERY_SCRIPTS = (SCRIPT,)
        module.PROTO_JSON_SCRIPT = SCRIPT
        events = []

        def validate():
            events.append("validate")

        def names(**kwargs):
            self.assertEqual(kwargs, {"save": False})
            events.append("names")

        def run_path(path, *, run_name):
            if run_name == "proto_json_recovery":
                events.append("load_only")
                return {"validate_target": validate, "restore_names": names}
            events.append("old_pass")
            return {}

        with patch.object(module.runpy, "run_path", side_effect=run_path):
            module.main()
        self.assertEqual(events, ["load_only", "validate", "old_pass", "names"])
        self.assertEqual(self.fake.save_calls, [(self.fake.input_path + ".i64", 0)])

    def test_full_recovery_hash_guard_failure_prevents_old_passes(self):
        bindings = {
            "ida_auto": self.fake.api.auto, "ida_kernwin": self.fake.api.ui,
            "ida_loader": self.fake.api.loader, "ida_nalt": self.fake.api.nalt,
        }
        with patch.dict(sys.modules, bindings):
            module = load_module(SKILLS / "ida_rehydrate_350101_9_3.py", "rehydrate_guard_tested")
        module.RECOVERY_SCRIPTS = (SCRIPT,)
        module.PROTO_JSON_SCRIPT = SCRIPT

        def fail():
            raise RuntimeError("wrong target")

        with patch.object(module.runpy, "run_path", return_value={"validate_target": fail}) as loader:
            with self.assertRaisesRegex(RuntimeError, "wrong target"):
                module.main()
        self.assertEqual(loader.call_count, 1)
        self.assertEqual(self.fake.save_calls, [])


if __name__ == "__main__":
    unittest.main()
