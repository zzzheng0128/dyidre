import unittest
import io
from unittest.mock import patch

from gumtrace_layout_scan import Scanner, group_candidates, c_draft, allocation_history, review_lifetimes


def trace(asm, regs, pc=0x100):
    return f"[test.so] {hex(0x100000 + pc)}!{hex(pc)} {asm}; {regs} \\r\\n\n"


class LayoutScanTest(unittest.TestCase):
    def scan(self, *lines):
        scanner = Scanner("test")
        for i, line in enumerate(lines, 1):
            scanner.consume(line, i)
        return scanner

    def test_pair_store_values_and_width(self):
        s = self.scan(trace("stp x1, x2, [x0, #8]", "x1=0x10 x2=0x20 x0=0x2000 mem_w=0x2008"))
        self.assertEqual(set(s.views[0x2000].fields), {(8, 8), (16, 8)})
        self.assertEqual(s.views[0x2000].fields[(16, 8)].value_observed, 1)

    def test_mov_add_alias(self):
        s = self.scan(
            trace("mov x19, x0", "x19=0x0 x0=0x2000 -> x19=0x2000"),
            trace("add x20, x19, #0x10", "x20=0x0 x19=0x2000 -> x20=0x2010"),
            trace("ldr w1, [x20, #4]", "w1=0x0 x20=0x2010 mem_r=0x2014 -> w1=0x2"))
        self.assertIn((0x14, 4), s.views[0x2000].fields)

    def test_loaded_pointer_used(self):
        s = self.scan(
            trace("ldr x1, [x0, #8]", "x1=0x0 x0=0x2000 mem_r=0x2008 -> x1=0x3000"),
            trace("ldr w2, [x1, #4]", "w2=0x0 x1=0x3000 mem_r=0x3004 -> w2=0x5", 0x104))
        self.assertEqual(s.views[0x2000].fields[(8, 8)].pointer_uses, 1)
        self.assertEqual(len(s.edges), 1)

    def test_pre_index(self):
        s = self.scan(trace("stp x1, x2, [x0, #-0x10]!", "x1=0x1 x2=0x2 x0=0x2010 mem_w=0x2000 -> x0=0x2000"))
        self.assertEqual(s.stats["out_of_window_field_events"], 2)
        self.assertEqual(s.aliases["x0"].value, 0x2000)

    def test_post_index(self):
        s = self.scan(
            trace("ldp x1, x2, [x0], #0x10", "x1=0x0 x2=0x0 x0=0x2000 mem_r=0x2000 -> x1=0x8 x2=0x9 x0=0x2010"),
            trace("ldr w3, [x0]", "w3=0x0 x0=0x2010 mem_r=0x2010 -> w3=0x1"))
        self.assertEqual(set(s.views[0x2000].fields), {(0, 8), (8, 8), (16, 4)})

    def test_indexed_not_struct_fields(self):
        s = self.scan(trace("ldr x2, [x0, x1, lsl #3]", "x2=0x0 x0=0x2000 x1=0x2 mem_r=0x2010 -> x2=0x4000"))
        self.assertFalse(s.views[0x2000].fields)
        self.assertEqual(s.views[0x2000].indexed, 1)
        self.assertIn((16, 8), s.views[0x2000].indexed_fields)

    def test_compare_does_not_destroy_alias(self):
        s = self.scan(
            trace("add x1, x0, #0x10", "x1=0x0 x0=0x2000 -> x1=0x2010"),
            trace("cmp x1, #0", "x1=0x2010 -> x1=0x2010"),
            trace("ldr w2, [x1]", "w2=0x0 x1=0x2010 mem_r=0x2010 -> w2=0x1"))
        self.assertIn((0x10, 4), s.views[0x2000].fields)

    def test_unproven_fp_is_not_automatically_stack(self):
        s = self.scan(trace("ldr x1, [x29]", "x1=0x0 fp=0x2000 mem_r=0x2000 -> x1=0x5"))
        self.assertEqual(s.classification(s.views[0x2000]), "object_candidate")

    def test_word_write_clears_pointer_alias(self):
        s = self.scan(
            trace("mov x1, x0", "x1=0x0 x0=0x2000 -> x1=0x2000"),
            trace("add w1, w1, #4", "w1=0x2000 w1=0x2000 -> w1=0x2004"),
            trace("ldr w2, [x1]", "w2=0x0 x1=0x2004 mem_r=0x2004 -> w2=0x1"))
        self.assertIn(0x2004, s.views)
        self.assertNotIn(0x2000, s.views)

    def test_adrp_add_global_address_not_page(self):
        s = self.scan(
            trace("adrp x8, #0x3000", "x8=0x0 -> x8=0x3000"),
            trace("add x8, x8, #0x120", "x8=0x3000 x8=0x3000 -> x8=0x3120"),
            trace("ldr x9, [x8, #8]", "x9=0x0 x8=0x3120 mem_r=0x3128 -> x9=0x5000"))
        self.assertEqual(s.classification(s.views[0x3120]), "global_view")

    def test_untraced_call_reset(self):
        s = self.scan(
            trace("add x0, x1, #0x10", "x0=0x0 x1=0x2000 -> x0=0x2010", 0x100),
            trace("bl #0x102000", "", 0x104),
            trace("ldr w2, [x0]", "w2=0x0 x0=0x2010 mem_r=0x2010 -> w2=0x1", 0x108))
        self.assertIn(0x2010, s.views)
        self.assertNotIn(0x2000, s.views)

    def test_same_offsets_different_sites_not_grouped(self):
        a = self.scan(trace("ldp x1, x2, [x0]", "x1=0x0 x2=0x0 x0=0x2000 mem_r=0x2000 -> x1=0x1 x2=0x2", 0x100))
        b = self.scan(trace("ldp x1, x2, [x0]", "x1=0x0 x2=0x0 x0=0x3000 mem_r=0x3000 -> x1=0x1 x2=0x2", 0x200))
        families, _ = group_candidates(a.export() + b.export())
        self.assertEqual(len(families), 2)

    def test_overlap_draft_is_opaque(self):
        s = self.scan(
            trace("str x1, [x0]", "x1=0x1 x0=0x2000 mem_w=0x2000", 0x100),
            trace("str w1, [x0, #4]", "w1=0x1 x0=0x2000 mem_w=0x2004", 0x104))
        families, _ = group_candidates(s.export())
        self.assertIn("overlap_or_bytes_00[8]", c_draft(families[0]))

    def test_allocation_history_failed_realloc(self):
        data = b"call func: malloc(0x18)\\r\\n\nret: 0x2000\\r\\n\ncall func: realloc(0x2000, 0x40)\nret: 0x0\ncall func: free(0x2000)\n"
        with patch("gumtrace_layout_scan.Path.open", return_value=io.BytesIO(data)):
            history = allocation_history("unused")
        self.assertEqual([x["event"] for x in history[0x2000]], ["malloc_return", "free"])

    def test_free_boundary_excludes_address_aggregate(self):
        result = {"sources": [{"id": "S1", "path": "unused"}], "relations": [],
                  "views": [{"source": "S1", "base": "0x2000", "classification": "object_candidate",
                             "fields": [{"first_line": 4, "last_line": 25}]}]}
        with patch("gumtrace_layout_scan.allocation_history", return_value={0x2000: [{"line": 10, "event": "free"}]}):
            review_lifetimes(result)
        self.assertEqual(result["views"][0]["classification"], "reused_address_view")
        self.assertEqual(result["lifetime_review"]["excluded_views"], 1)


if __name__ == "__main__":
    unittest.main()
