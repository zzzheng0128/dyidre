#!/usr/bin/env python3
"""Evidence-first runtime scaffold for the 350.101 native ``exeVMInner`` VM.

This is deliberately *not* an emulator that invents missing handler semantics.
It provides the reusable pieces needed to grow one safely:

* a single decoder for the 32-bit virtual instruction format;
* a 32-register / byte-addressable VM state;
* implementations for instruction families whose semantics are backed by the
  existing 350.101 handler analysis; and
* a fail-closed manifest for the few native wrapper ABIs whose stack layout is
  independently closed; and
* strict failure plus a coverage JSON report for every other opcode.

It imports the established trace decoder rather than maintaining a second,
possibly divergent, opcode table.  The runtime therefore accepts any program
whose words and ABI are supplied by a wrapper, while its implemented opcode
set remains explicitly evidence-limited.

Typical use:

  python3 native_vmp_runtime.py --trace ../vm_lift_1f7860/gumtrace_1f7860_slice.log \
      --vm-page 0x7102dfb000 --vm-page 0x7102dfc000 --vm-page 0x7102dfd000 \
      --coverage-out coverage_1f7860.json
  python3 native_vmp_runtime.py --static-image ../../materials/350101/libmetasec_ml.so \
      --static-file-offset 0x1ecaf0 --static-vm-code 0x1ecaf0 \
      --static-byte-count 0x244 --static-coverage-out coverage_static_1ecaf0.json
  python3 native_vmp_runtime.py \
      --validate-package-check-static-candidate-350 ../../materials/350101/libmetasec_ml.so
  python3 native_vmp_runtime.py --selftest
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from dataclasses import dataclass, field, fields, replace
from pathlib import Path
from typing import Callable, Mapping, Sequence


THIS_DIR = Path(__file__).resolve().parent
PROJECT_DIR = THIS_DIR.parents[2]
TRACE_DECODER = PROJECT_DIR / "skills" / "metasec_vm_trace_decoder.py"


def _load_decoder():
    spec = importlib.util.spec_from_file_location("metasec_vm_trace_decoder", TRACE_DECODER)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load trace decoder: {TRACE_DECODER}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


decoder = _load_decoder()
MASK64 = (1 << 64) - 1


class UnsupportedOpcode(RuntimeError):
    """Raised instead of silently approximating an unverified VM handler."""


class UnmappedVmMemory(RuntimeError):
    """Raised when a recovered load depends on bytes absent from the VM image.

    Native handlers dereference their computed virtual address directly.  A
    standalone replay must therefore receive an explicit memory image rather
    than turning a missing host/input field into a synthetic zero value.
    """


class VmMemory:
    """Sparse little-endian byte memory used by the standalone interpreter."""

    def __init__(self, initial: dict[int, int] | None = None):
        self._bytes: dict[int, int] = dict(initial or {})

    def read(self, address: int, width: int, signed: bool = False) -> int:
        if width not in (1, 2, 4, 8):
            raise ValueError(f"unsupported width: {width}")
        missing = next(
            (address + i for i in range(width) if address + i not in self._bytes),
            None,
        )
        if missing is not None:
            raise UnmappedVmMemory(
                f"unmapped VM memory read at address=0x{address:x}, width={width}; "
                f"first missing byte=0x{missing:x}"
            )
        value = sum(self._bytes[address + i] << (8 * i) for i in range(width))
        if signed and value & (1 << (width * 8 - 1)):
            value -= 1 << (width * 8)
        return value

    def write(self, address: int, width: int, value: int) -> None:
        if width not in (1, 2, 4, 8):
            raise ValueError(f"unsupported width: {width}")
        for i in range(width):
            self._bytes[address + i] = (value >> (8 * i)) & 0xFF


@dataclass
class VmState:
    """The portable part of exeVMInner state; native helper state stays bridged."""

    code_base: int
    regs: list[int] = field(default_factory=lambda: [0] * 32)
    pc: int = 0
    memory: VmMemory = field(default_factory=VmMemory)
    # Interpreter-only bookkeeping for recovered CALL_REG selectors. The
    # native handler's architectural effect is the link-register write.
    call_stack: list[int] = field(default_factory=list)
    steps: int = 0

    def __post_init__(self) -> None:
        if len(self.regs) != 32:
            raise ValueError("the 350.101 VMP has 32 virtual registers")
        if not self.pc:
            self.pc = self.code_base

    def reg(self, index: int) -> int:
        return self.regs[index] & MASK64

    def set_reg(self, index: int, value: int) -> None:
        self.regs[index] = value & MASK64


@dataclass(frozen=True)
class Instruction:
    pc: int
    word: int
    op: int
    r_dst: int
    r_src: int
    imm16: int
    simm16: int

    @classmethod
    def decode(cls, pc: int, word: int) -> "Instruction":
        fields = decoder.fields(word)
        return cls(
            pc=pc,
            word=word & 0xFFFFFFFF,
            op=fields["op"],
            r_dst=fields["r16"],
            r_src=fields["r21"],
            imm16=fields["imm16"],
            simm16=fields["simm16"],
        )

    @property
    def fallthrough(self) -> int:
        return self.pc + 4


class UnknownNativeVmpWrapperAbi(ValueError):
    """Raised when a wrapper/VM-program pair lacks a closed 350.101 ABI."""


class UnknownNativeVmpImage(ValueError):
    """Raised when bytes are not the one image covered by this manifest."""


class UnknownNativeVmpEntryObservation(UnknownNativeVmpWrapperAbi):
    """Raised when an entry-register snapshot does not close a wrapper ABI."""


class UnknownNativeVmpStaticCandidate(ValueError):
    """Raised when a bounded static VMP candidate lacks exact provenance."""


@dataclass(frozen=True)
class NativeVmpImageIdentity350:
    """Content identity for the one 350.101 SO covered by these offsets.

    Version labels and module-relative offsets are not enough to safely reuse
    an ABI manifest across builds.  This intentionally records the exact
    binary identity recovered in ``metasec_so_identity.md``.  It is a local
    validation aid only; it neither loads the SO nor executes any VM code.
    """

    version: str
    size: int
    sha256: str


KNOWN_NATIVE_VMP_IMAGE_350 = NativeVmpImageIdentity350(
    version="350.101",
    size=0x2BB410,
    sha256="2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76",
)


def native_vmp_image_identity_350(
    image: bytes | bytearray | memoryview,
) -> NativeVmpImageIdentity350:
    """Calculate the narrow identity fields used by the 350.101 manifest."""
    if not isinstance(image, (bytes, bytearray, memoryview)):
        raise TypeError("image must be bytes-like")
    # A copy keeps this small offline helper valid for non-contiguous
    # memoryviews too.  The canonical sample is only 0x2bb410 bytes.
    image_bytes = bytes(image)
    return NativeVmpImageIdentity350(
        version=KNOWN_NATIVE_VMP_IMAGE_350.version,
        size=len(image_bytes),
        sha256=hashlib.sha256(image_bytes).hexdigest(),
    )


def validate_native_vmp_image_identity_350(
    identity: NativeVmpImageIdentity350,
) -> NativeVmpImageIdentity350:
    """Fail closed unless an already-calculated identity is canonical."""
    if not isinstance(identity, NativeVmpImageIdentity350):
        raise TypeError("identity must be NativeVmpImageIdentity350")
    canonical = KNOWN_NATIVE_VMP_IMAGE_350
    if identity != canonical:
        mismatches = [
            f"{member.name}: got {getattr(identity, member.name)!r}, "
            f"expected {getattr(canonical, member.name)!r}"
            for member in fields(NativeVmpImageIdentity350)
            if getattr(identity, member.name) != getattr(canonical, member.name)
        ]
        raise UnknownNativeVmpImage(
            "native VMP ABI is only covered for the exact 350.101 SO: "
            + "; ".join(mismatches)
        )
    return canonical


def validate_native_vmp_image_350(
    image: bytes | bytearray | memoryview,
) -> NativeVmpImageIdentity350:
    """Calculate and validate a local SO byte sequence against the manifest."""
    return validate_native_vmp_image_identity_350(native_vmp_image_identity_350(image))


@dataclass(frozen=True)
class NativeVmpStaticCandidate350:
    """One caller-bounded VMP-code span with static 350.101 provenance.

    This records the callsite and exact syntactic-inventory facts needed to
    recognize a static candidate in the one covered image.  It is expressly
    *not* a :class:`NativeVmpWrapperAbi350`: no wrapper stack layout, pParam
    contract, callback arity/return type, result ABI, dynamic reachability, or
    guard-memory effect follows from this descriptor.
    """

    name: str
    wrapper_entry: int
    args_setup: int
    exe_vm_callsite: int
    caller_lr: int
    vm_code: int
    vm_code_end: int
    file_offset: int
    byte_count: int
    vm_data1: int
    vm_data2: int
    code_sha256: str
    word_count: int
    implemented_words: int
    unsupported_words: int
    terminal_word_offset: int
    terminal_word: int
    unsupported_top_level: tuple[tuple[int, int], ...]
    unsupported_op11: tuple[tuple[int, int], ...]


# ``runMetaPackageCheckVM_350`` statically supplies this program, its two
# auxiliary tables, and a native parameter block.  The next independently
# observed VMP entry bounds the span; its last word is a zero sentinel.  Keep
# this separate from KNOWN_NATIVE_VMP_WRAPPERS_350 until the wrapper ABI and
# dynamic side effects are independently closed.
PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350 = NativeVmpStaticCandidate350(
    name="package_check_1ea850",
    wrapper_entry=0xD7E94,
    args_setup=0xD7EBC,
    exe_vm_callsite=0xD7EE8,
    caller_lr=0xD7EEC,
    vm_code=0x1EA850,
    vm_code_end=0x1EC4D0,
    file_offset=0x1EA850,
    byte_count=0x1C80,
    vm_data1=0x262800,
    vm_data2=0x262890,
    code_sha256="40d7a29bd9efdb2af3c92427b9fa212d6f71a14e332e24d30beeac67b2112392",
    word_count=1824,
    implemented_words=1807,
    unsupported_words=17,
    terminal_word_offset=0x1EC4CC,
    terminal_word=0,
    unsupported_top_level=((0x00, 1), (0x06, 2), (0x09, 2), (0x3D, 4)),
    unsupported_op11=((0x0D, 5), (0x20, 1), (0x21, 2)),
)

KNOWN_NATIVE_VMP_STATIC_CANDIDATES_350: tuple[NativeVmpStaticCandidate350, ...] = (
    PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350,
)


def _require_native_vmp_static_candidate_shape_350(
    candidate: NativeVmpStaticCandidate350,
) -> None:
    """Reject type-coercible lookalikes before exact candidate comparison."""
    if not isinstance(candidate, NativeVmpStaticCandidate350):
        raise TypeError("candidate must be NativeVmpStaticCandidate350")
    if type(candidate.name) is not str:
        raise UnknownNativeVmpStaticCandidate("candidate name must be a string")
    if type(candidate.code_sha256) is not str:
        raise UnknownNativeVmpStaticCandidate("candidate code_sha256 must be a string")
    numeric_fields = (
        "wrapper_entry", "args_setup", "exe_vm_callsite", "caller_lr",
        "vm_code", "vm_code_end", "file_offset", "byte_count", "vm_data1",
        "vm_data2", "word_count", "implemented_words", "unsupported_words",
        "terminal_word_offset", "terminal_word",
    )
    invalid_numeric = [
        name for name in numeric_fields if type(getattr(candidate, name)) is not int
    ]
    if invalid_numeric:
        raise UnknownNativeVmpStaticCandidate(
            "candidate fields must be integers: " + ", ".join(invalid_numeric)
        )
    for name in ("unsupported_top_level", "unsupported_op11"):
        rows = getattr(candidate, name)
        if (
            type(rows) is not tuple
            or any(
                type(row) is not tuple
                or len(row) != 2
                or type(row[0]) is not int
                or type(row[1]) is not int
                for row in rows
            )
        ):
            raise UnknownNativeVmpStaticCandidate(
                f"candidate {name} must be a tuple of integer pairs"
            )


def validate_native_vmp_static_candidate_350(
    candidate: NativeVmpStaticCandidate350,
) -> NativeVmpStaticCandidate350:
    """Fail closed unless *candidate* exactly matches static 350.101 evidence."""
    _require_native_vmp_static_candidate_shape_350(candidate)
    canonical = next(
        (
            known for known in KNOWN_NATIVE_VMP_STATIC_CANDIDATES_350
            if known.name == candidate.name
        ),
        None,
    )
    if canonical is None:
        raise UnknownNativeVmpStaticCandidate(
            f"no closed 350.101 native-VMP static candidate named {candidate.name!r}"
        )
    if candidate != canonical:
        mismatches = [
            f"{member.name}: got {getattr(candidate, member.name)!r}, "
            f"expected {getattr(canonical, member.name)!r}"
            for member in fields(NativeVmpStaticCandidate350)
            if getattr(candidate, member.name) != getattr(canonical, member.name)
        ]
        raise UnknownNativeVmpStaticCandidate(
            f"{canonical.name} static candidate does not match the 350.101 manifest: "
            + "; ".join(mismatches)
        )
    return canonical


@dataclass(frozen=True)
class NativeVmpVmParamLayout350:
    """Static field offsets in the three-qword native ``VmParam64`` block."""

    fun_bridge_offset: int
    p_param_anchor_offset: int
    outer_return_lr_offset: int


@dataclass(frozen=True)
class NativeVmpEntryContextWrite350:
    """One statically observed write below the incoming pParam anchor.

    ``offset`` is signed and relative to the opaque pParam anchor.  The
    labels name the entry-time source only; they do not claim a complete
    pParam snapshot, callback behavior, or VM-program semantics.
    """

    offset: int
    role: str


@dataclass(frozen=True)
class NativeVmpBridgeAbi350:
    """Register-only ABI of one statically recovered tail-call trampoline."""

    name: str
    entry_offset: int
    target_input_register: str
    primary_arg_input_register: str
    target_forward_register: str
    primary_arg_forward_register: str
    preserved_registers: tuple[str, ...]
    transfer: str
    writes_memory: bool
    writes_link_register: bool


SMALL_VMP_VM_PARAM_LAYOUT_350 = NativeVmpVmParamLayout350(
    fun_bridge_offset=0,
    p_param_anchor_offset=0x8,
    outer_return_lr_offset=0x10,
)

# These are exeVMInner entry writes common to the recovered small-wrapper
# route.  They are intentionally metadata, not an allocated replacement for
# pParam: the wrapper supplies an anchor and the interpreter grows its own
# local context below that address.
SMALL_VMP_ENTRY_CONTEXT_WRITES_350: tuple[NativeVmpEntryContextWrite350, ...] = (
    NativeVmpEntryContextWrite350(-0x120, "vm_code"),
    NativeVmpEntryContextWrite350(-0x118, "zero"),
    NativeVmpEntryContextWrite350(-0xF8, "p_param_window"),
    NativeVmpEntryContextWrite350(-0xF0, "vm_data1"),
    NativeVmpEntryContextWrite350(-0xE8, "vm_data2"),
    NativeVmpEntryContextWrite350(-0xE0, "fun_bridge"),
    NativeVmpEntryContextWrite350(-0x30, "aligned_context_base"),
    NativeVmpEntryContextWrite350(-0x20, "outer_return_lr"),
)

# 0xD9980 is exactly ``mov x2, x0; mov x0, x1; br x2``.  The descriptor
# documents register forwarding only; it never manufactures a callback or
# treats the target as a generic C function.
SMALL_VMP_TAIL_BRIDGE_ABI_350 = NativeVmpBridgeAbi350(
    name="tailcall_target_x0_arg_x1",
    entry_offset=0xD9980,
    target_input_register="x0",
    primary_arg_input_register="x1",
    target_forward_register="x2",
    primary_arg_forward_register="x0",
    preserved_registers=("x1",),
    transfer="br_x2",
    writes_memory=False,
    writes_link_register=False,
)


@dataclass(frozen=True)
class NativeVmpWrapperAbi350:
    """One version-isolated native ``exeVMInner`` wrapper contract.

    This is an ABI inventory, not a VMP execution bridge.  In particular it
    does not supply a native ``funBridge``, material result, VM memory image,
    or any fallback value for a missing wrapper.  The offsets are relative to
    the 350.101 ``libmetasec_ml.so`` module base.

    ``param_window_stack_offset`` and ``vm_param_stack_offset`` are relative
    to the wrapper's stack pointer immediately before its ``BL 0x4cc10``.
    A ``result_kind`` of ``u32_at_param_window_plus_0`` means that the wrapper
    reads W0 from the first four bytes of that parameter window after the VMP
    returns.  ``out_ref_material`` deliberately records only the observed
    ownership/output shape of the heavy material builder.

    The optional pParam and bridge fields are static evidence metadata, not a
    request to reproduce native side effects.  They are populated only where
    that wrapper's stack anchor and tail-transfer shape were independently
    recovered; ``None``/empty remains meaningful unknown evidence.
    """

    name: str
    exe_vm_entry: int
    wrapper_entry: int
    caller_lr: int
    vm_code: int
    vm_data1: int
    vm_data2: int
    param_window_stack_offset: int
    vm_param_stack_offset: int
    fun_bridge: int
    result_kind: str
    result_offset: int | None
    param_window_sources: tuple[str, ...] = ()
    vm_param_layout: NativeVmpVmParamLayout350 | None = None
    p_param_anchor_stack_offset: int | None = None
    p_param_entry_context_writes: tuple[NativeVmpEntryContextWrite350, ...] = ()
    bridge_abi: NativeVmpBridgeAbi350 | None = None


@dataclass(frozen=True)
class NativeVmpEntryRegisters350:
    """The complete entry-register shape required to validate one wrapper."""

    pc: int
    lr: int
    sp: int
    x0: int
    x1: int
    x2: int
    x3: int
    x4: int


@dataclass(frozen=True)
class NativeVmpEntryObservation350:
    """One local register snapshot matched to a canonical wrapper contract."""

    abi: NativeVmpWrapperAbi350
    module_base: int
    registers: NativeVmpEntryRegisters350


# Static wrapper contracts with both wrapper-body and entry-event evidence.
# Do not add an entry-only pair here: an observed X0/LR at exeVMInner says
# nothing about its stack window, native bridge, or result ABI.
KNOWN_NATIVE_VMP_WRAPPERS_350: tuple[NativeVmpWrapperAbi350, ...] = (
    NativeVmpWrapperAbi350(
        name="small_1ec670",
        exe_vm_entry=0x4CC10,
        wrapper_entry=0xD9574,
        caller_lr=0xD95CC,
        vm_code=0x1EC670,
        vm_data1=0x262980,
        vm_data2=0x2629C0,
        param_window_stack_offset=0x8,
        vm_param_stack_offset=0x10,
        fun_bridge=0xD9980,
        result_kind="u32_at_param_window_plus_0",
        result_offset=0,
        vm_param_layout=SMALL_VMP_VM_PARAM_LAYOUT_350,
        p_param_anchor_stack_offset=0x4A0,
        p_param_entry_context_writes=SMALL_VMP_ENTRY_CONTEXT_WRITES_350,
        bridge_abi=SMALL_VMP_TAIL_BRIDGE_ABI_350,
    ),
    NativeVmpWrapperAbi350(
        name="small_1ecaf0",
        exe_vm_entry=0x4CC10,
        wrapper_entry=0xD95F4,
        caller_lr=0xD964C,
        vm_code=0x1ECAF0,
        vm_data1=0x262A00,
        vm_data2=0x262A20,
        param_window_stack_offset=0x8,
        vm_param_stack_offset=0x10,
        fun_bridge=0xD9980,
        result_kind="u32_at_param_window_plus_0",
        result_offset=0,
        vm_param_layout=SMALL_VMP_VM_PARAM_LAYOUT_350,
        p_param_anchor_stack_offset=0x3C0,
        p_param_entry_context_writes=SMALL_VMP_ENTRY_CONTEXT_WRITES_350,
        bridge_abi=SMALL_VMP_TAIL_BRIDGE_ABI_350,
    ),
    NativeVmpWrapperAbi350(
        name="material_1f7860",
        exe_vm_entry=0x4CC10,
        wrapper_entry=0x124DD4,
        caller_lr=0x124E34,
        vm_code=0x1F7860,
        vm_data1=0x26F2E0,
        vm_data2=0x26F300,
        param_window_stack_offset=0,
        vm_param_stack_offset=0x20,
        fun_bridge=0x129B24,
        result_kind="out_ref_material",
        result_offset=None,
        param_window_sources=("x8", "x0", "x1", "x2"),
    ),
)


def _native_vmp_wrapper_key_350(
    exe_vm_entry: int,
    vm_code: int,
    caller_lr: int,
) -> tuple[int, int, int]:
    """Validate one module-relative entry triple before manifest lookup."""
    values = {
        "exe_vm_entry": exe_vm_entry,
        "vm_code": vm_code,
        "caller_lr": caller_lr,
    }
    for name, value in values.items():
        if type(value) is not int or not 0 <= value <= 0xFFFFFFFF:
            raise UnknownNativeVmpWrapperAbi(
                f"{name} must be a 32-bit module-relative integer, got {value!r}"
            )
    return exe_vm_entry, vm_code, caller_lr


def _find_native_vmp_wrapper_abi_350(
    exe_vm_entry: int,
    vm_code: int,
    caller_lr: int,
) -> NativeVmpWrapperAbi350 | None:
    key = _native_vmp_wrapper_key_350(exe_vm_entry, vm_code, caller_lr)
    for abi in KNOWN_NATIVE_VMP_WRAPPERS_350:
        if key == (abi.exe_vm_entry, abi.vm_code, abi.caller_lr):
            return abi
    return None


def validate_native_vmp_wrapper_abi_350(
    abi: NativeVmpWrapperAbi350,
) -> NativeVmpWrapperAbi350:
    """Fail closed unless *abi* exactly matches one closed wrapper contract.

    This validates every field rather than accepting an otherwise-known
    ``(entry, vmCode, LR)`` triple with changed data pointers, stack layout, or
    result shape.  It intentionally cannot validate VMP runtime side effects.
    """
    if not isinstance(abi, NativeVmpWrapperAbi350):
        raise TypeError("abi must be NativeVmpWrapperAbi350")
    canonical = _find_native_vmp_wrapper_abi_350(
        abi.exe_vm_entry, abi.vm_code, abi.caller_lr
    )
    if canonical is None:
        raise UnknownNativeVmpWrapperAbi(
            "no closed 350.101 native-VMP wrapper ABI for "
            f"entry=0x{abi.exe_vm_entry:x}, vmCode=0x{abi.vm_code:x}, "
            f"callerLR=0x{abi.caller_lr:x}"
        )
    if abi != canonical:
        mismatches = [
            f"{member.name}: got {getattr(abi, member.name)!r}, "
            f"expected {getattr(canonical, member.name)!r}"
            for member in fields(NativeVmpWrapperAbi350)
            if getattr(abi, member.name) != getattr(canonical, member.name)
        ]
        raise UnknownNativeVmpWrapperAbi(
            f"{canonical.name} wrapper ABI does not match the 350.101 manifest: "
            + "; ".join(mismatches)
        )
    return canonical


def resolve_native_vmp_wrapper_abi_350(
    exe_vm_entry: int,
    vm_code: int,
    caller_lr: int,
) -> NativeVmpWrapperAbi350:
    """Resolve one exact, evidence-closed 350.101 native VMP wrapper.

    All arguments are module-relative offsets.  Entry-only observations such
    as ``0x1f6670/0x11999c`` and ``0x201800/0x12acf8`` are intentionally not
    returned: their wrapper ABI has not been recovered.
    """
    abi = _find_native_vmp_wrapper_abi_350(exe_vm_entry, vm_code, caller_lr)
    if abi is None:
        raise UnknownNativeVmpWrapperAbi(
            "no closed 350.101 native-VMP wrapper ABI for "
            f"entry=0x{exe_vm_entry:x}, vmCode=0x{vm_code:x}, "
            f"callerLR=0x{caller_lr:x}"
        )
    return validate_native_vmp_wrapper_abi_350(abi)


def validate_native_vmp_wrapper_image_350(
    image: bytes | bytearray | memoryview,
    abi: NativeVmpWrapperAbi350,
) -> NativeVmpWrapperAbi350:
    """Bind a closed wrapper ABI to the exact SO before accepting it.

    The ordering is deliberate: first reject a changed ABI manifest, then
    reject an image from a different build.  This helper does not inspect
    wrapper stack memory, invoke the VMP, or supply an output value.
    """
    canonical = validate_native_vmp_wrapper_abi_350(abi)
    validate_native_vmp_image_350(image)
    return canonical


def _is_u64(value: object) -> bool:
    return type(value) is int and 0 <= value <= MASK64


def _require_native_vmp_entry_registers_350(
    registers: NativeVmpEntryRegisters350,
) -> None:
    if not isinstance(registers, NativeVmpEntryRegisters350):
        raise TypeError("registers must be NativeVmpEntryRegisters350")
    invalid = [
        member.name
        for member in fields(NativeVmpEntryRegisters350)
        if not _is_u64(getattr(registers, member.name))
    ]
    if invalid:
        raise UnknownNativeVmpEntryObservation(
            "entry registers must be unsigned 64-bit integers: " + ", ".join(invalid)
        )


def _module_relative_matches_350(value: int, module_base: int, offset: int) -> bool:
    return module_base <= MASK64 - offset and value == module_base + offset


def _stack_relative_matches_350(value: int, sp: int, offset: int) -> bool:
    return sp <= MASK64 - offset and value == sp + offset


def resolve_native_vmp_entry_observation_350(
    registers: NativeVmpEntryRegisters350,
) -> NativeVmpEntryObservation350:
    """Resolve one complete entry snapshot to an exact canonical wrapper.

    This is deliberately narrower than an entry-triple lookup.  It requires
    the observed PC/LR/X0/X2/X3 module-relative pointers and X1/X4 stack
    relations to agree with one manifest item.  It does not dereference
    pParam, interpret auxiliary X9/X10 values, or model any ``funBridge``
    callback.
    """
    _require_native_vmp_entry_registers_350(registers)
    matches: list[tuple[NativeVmpWrapperAbi350, int]] = []
    for abi in KNOWN_NATIVE_VMP_WRAPPERS_350:
        if registers.pc < abi.exe_vm_entry:
            continue
        module_base = registers.pc - abi.exe_vm_entry
        if not (
            _module_relative_matches_350(registers.pc, module_base, abi.exe_vm_entry)
            and _module_relative_matches_350(registers.lr, module_base, abi.caller_lr)
            and _module_relative_matches_350(registers.x0, module_base, abi.vm_code)
            and _module_relative_matches_350(registers.x2, module_base, abi.vm_data1)
            and _module_relative_matches_350(registers.x3, module_base, abi.vm_data2)
            and _stack_relative_matches_350(
                registers.x1, registers.sp, abi.param_window_stack_offset
            )
            and _stack_relative_matches_350(
                registers.x4, registers.sp, abi.vm_param_stack_offset
            )
        ):
            continue
        matches.append((validate_native_vmp_wrapper_abi_350(abi), module_base))

    if len(matches) != 1:
        detail = "no" if not matches else f"{len(matches)}"
        raise UnknownNativeVmpEntryObservation(
            f"{detail} closed 350.101 wrapper ABIs match this complete entry snapshot"
        )
    abi, module_base = matches[0]
    return NativeVmpEntryObservation350(
        abi=abi,
        module_base=module_base,
        registers=registers,
    )


NativeBridge = Callable[[VmState, Instruction], int | None]
# The first four have current handler evidence; the last three remain bridge
# candidates until their predicates are recovered.
CONTROL_OPS = frozenset((0x0D, 0x14, 0x2B, 0x2D, 0x2C, 0x3A, 0x3F))
SUPPORTED_OPCODES = frozenset((
    0x01, 0x0B, 0x0D, 0x0F, 0x10, 0x11, 0x13, 0x14, 0x16, 0x18, 0x1A, 0x21,
    0x28, 0x2B, 0x2D, 0x2E, 0x30, 0x34, 0x35, 0x3B, 0x3E,
))
# ``op=0x11`` is a prefix, not a generic operation.  Keep this separate from
# the top-level set so an unreviewed selector can never become executable just
# because other op11 handlers were recovered.
SUPPORTED_OP11_SELECTORS = frozenset((0x03, 0x0E, 0x17, 0x1D, 0x1E, 0x2B, 0x2C, 0x32))
OP11_CONTROL_SELECTORS = frozenset((0x1E, 0x32))


def is_supported_word(word: int) -> bool:
    """Whether this exact word has an evidence-backed runtime implementation."""
    op = word & 0x3F
    if op == 0x11:
        return decoder.op11_selector(word) in SUPPORTED_OP11_SELECTORS
    return op in SUPPORTED_OPCODES


def is_control_word(word: int) -> bool:
    """Whether an exact word may transfer virtual PC away from fallthrough."""
    op = word & 0x3F
    return op in CONTROL_OPS or (
        op == 0x11 and decoder.op11_selector(word) in OP11_CONTROL_SELECTORS
    )


def opcode_coverage_from_words(
    words: Sequence[int],
) -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    """Classify exact VM words without claiming that they are executable.

    Both dynamic captures and caller-bounded static spans need the same
    selector-aware implementation gate.  Keeping it here avoids a static
    report accidentally treating every ``op=0x11`` word as supported merely
    because some of its secondary handlers have been recovered.
    """
    counts = Counter(word & 0x3F for word in words)
    op11_counts = Counter(
        decoder.op11_selector(word) for word in words if (word & 0x3F) == 0x11
    )
    opcode_rows: list[dict[str, object]] = []
    for op, count in sorted(counts.items()):
        name, note = decoder.OP_INFO.get(op, (f"UNK_{op:02X}", "unknown opcode"))
        if op == 0x11:
            implemented_count = sum(
                selector_count
                for selector, selector_count in op11_counts.items()
                if selector in SUPPORTED_OP11_SELECTORS
            )
        else:
            implemented_count = count if op in SUPPORTED_OPCODES else 0
        unsupported_count = count - implemented_count
        opcode_rows.append({
            "op": f"0x{op:02x}", "count": count, "name": name,
            "implemented": unsupported_count == 0,
            "implemented_word_count": implemented_count,
            "unsupported_word_count": unsupported_count,
            "evidence": note,
        })
    op11_rows: list[dict[str, object]] = []
    for selector, count in sorted(op11_counts.items()):
        name, note = decoder.OP11_SUBOP_INFO.get(
            selector, (f"SUBOP_{selector:02X}", "selector is not recovered")
        )
        op11_rows.append({
            "selector": f"0x{selector:02x}", "count": count, "name": name,
            "implemented": selector in SUPPORTED_OP11_SELECTORS,
            "evidence": note,
        })
    return opcode_rows, op11_rows


def coverage_from_static_span(
    image: bytes,
    *,
    file_offset: int,
    vm_code: int,
    byte_count: int,
) -> dict[str, object]:
    """Inventory one explicitly bounded VM-code byte span in an image.

    ``file_offset`` is intentionally explicit: a virtual address is not
    generally an ELF file offset.  The caller must establish that mapping from
    the relevant load segment before asking this helper to decode a span.  The
    result is a syntactic inventory only; it is not a dynamic trace, CFG, or
    proof that every listed word is reachable for a particular ABI/input.
    """
    if file_offset < 0:
        raise ValueError(f"file offset must be non-negative, got {file_offset}")
    if file_offset % 4:
        raise ValueError(f"static VM file offset must be 4-byte aligned, got 0x{file_offset:x}")
    if not 0 <= vm_code <= MASK64:
        raise ValueError(f"VM code address must be an unsigned 64-bit value, got {vm_code}")
    if vm_code % 4:
        raise ValueError(f"VM code address must be 4-byte aligned, got 0x{vm_code:x}")
    if byte_count <= 0 or byte_count % 4:
        raise ValueError(
            f"static VM span must contain a positive multiple of 4 bytes, got {byte_count}"
        )
    if vm_code + byte_count > MASK64 + 1:
        raise ValueError(
            f"static VM span wraps the unsigned 64-bit address space: "
            f"start=0x{vm_code:x}, bytes=0x{byte_count:x}"
        )
    end_offset = file_offset + byte_count
    if end_offset > len(image):
        raise ValueError(
            f"static VM span exceeds image: [0x{file_offset:x}, 0x{end_offset:x}) "
            f"outside 0x{len(image):x} bytes"
        )
    payload = image[file_offset:end_offset]
    words = [
        int.from_bytes(payload[offset:offset + 4], "little")
        for offset in range(0, len(payload), 4)
    ]
    opcode_rows, op11_rows = opcode_coverage_from_words(words)
    implemented_words = sum(is_supported_word(word) for word in words)
    return {
        "schema": "dyidre.native_vmp_runtime_350101.static_span.v1",
        "scope": (
            "explicit caller-bounded static VM-code span; not a dynamic trace, "
            "reachability proof, or ABI validation"
        ),
        "file_offset": f"0x{file_offset:x}",
        "vm_code_start": f"0x{vm_code:x}",
        "vm_code_end": f"0x{vm_code + byte_count:x}",
        "byte_count": byte_count,
        "word_count": len(words),
        "code_sha256": hashlib.sha256(payload).hexdigest(),
        "implemented_words": implemented_words,
        "unsupported_words": len(words) - implemented_words,
        "opcode_coverage": opcode_rows,
        "unsupported_opcodes": [row for row in opcode_rows if not row["implemented"]],
        "op11_subopcode_coverage": op11_rows,
        "unsupported_op11_selectors": [
            row for row in op11_rows if not row["implemented"]
        ],
    }


def coverage_from_static_file(
    image_path: Path,
    *,
    file_offset: int,
    vm_code: int,
    byte_count: int,
) -> dict[str, object]:
    """Run :func:`coverage_from_static_span` and pin it to an input image."""
    image = image_path.read_bytes()
    report = coverage_from_static_span(
        image,
        file_offset=file_offset,
        vm_code=vm_code,
        byte_count=byte_count,
    )
    report["source_image"] = str(image_path)
    report["source_image_sha256"] = hashlib.sha256(image).hexdigest()
    return report


def _unsupported_top_level_counts_350(
    report: Mapping[str, object],
) -> tuple[tuple[int, int], ...]:
    """Return unsupported non-``op11`` rows in a comparison-safe form."""
    rows = report["unsupported_opcodes"]
    if not isinstance(rows, list):
        raise UnknownNativeVmpStaticCandidate("static coverage has no opcode rows")
    values: list[tuple[int, int]] = []
    for row in rows:
        if not isinstance(row, Mapping):
            raise UnknownNativeVmpStaticCandidate("static coverage opcode row is malformed")
        op = int(str(row["op"]), 0)
        if op != 0x11:
            values.append((op, int(row["unsupported_word_count"])))
    return tuple(sorted(values))


def _unsupported_op11_counts_350(
    report: Mapping[str, object],
) -> tuple[tuple[int, int], ...]:
    """Return unsupported ``op11`` selector rows in a comparison-safe form."""
    rows = report["unsupported_op11_selectors"]
    if not isinstance(rows, list):
        raise UnknownNativeVmpStaticCandidate("static coverage has no op11 rows")
    values: list[tuple[int, int]] = []
    for row in rows:
        if not isinstance(row, Mapping):
            raise UnknownNativeVmpStaticCandidate("static coverage op11 row is malformed")
        values.append((int(str(row["selector"]), 0), int(row["count"])))
    return tuple(sorted(values))


def validate_package_check_vm_static_candidate_350(
    image: bytes | bytearray | memoryview,
) -> dict[str, object]:
    """Validate the exact package-check static span without executing it.

    The order is deliberate: the entire image must first match the one
    350.101 sample, then the caller-bounded candidate and its selector-aware
    syntactic inventory must match.  This never invokes ``exeVMInner``,
    allocates a pParam block, emulates the tail bridge, or derives guard-field
    writes from static words.
    """
    if not isinstance(image, (bytes, bytearray, memoryview)):
        raise TypeError("image must be bytes-like")
    # Freeze a mutable caller buffer before identity validation so the exact
    # bytes verified are also the bytes whose static span is decoded below.
    image_bytes = bytes(image)
    image_identity = validate_native_vmp_image_350(image_bytes)
    candidate = validate_native_vmp_static_candidate_350(
        PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350
    )
    report = coverage_from_static_span(
        image_bytes,
        file_offset=candidate.file_offset,
        vm_code=candidate.vm_code,
        byte_count=candidate.byte_count,
    )
    expected_report = {
        "file_offset": f"0x{candidate.file_offset:x}",
        "vm_code_start": f"0x{candidate.vm_code:x}",
        "vm_code_end": f"0x{candidate.vm_code_end:x}",
        "byte_count": candidate.byte_count,
        "word_count": candidate.word_count,
        "code_sha256": candidate.code_sha256,
        "implemented_words": candidate.implemented_words,
        "unsupported_words": candidate.unsupported_words,
    }
    mismatches = [
        f"{name}: got {report[name]!r}, expected {expected!r}"
        for name, expected in expected_report.items()
        if report[name] != expected
    ]
    terminal_word = int.from_bytes(
        image_bytes[candidate.terminal_word_offset:candidate.terminal_word_offset + 4],
        "little",
    )
    if terminal_word != candidate.terminal_word:
        mismatches.append(
            f"terminal word at 0x{candidate.terminal_word_offset:x}: "
            f"got 0x{terminal_word:08x}, expected 0x{candidate.terminal_word:08x}"
        )
    top_level = _unsupported_top_level_counts_350(report)
    if top_level != candidate.unsupported_top_level:
        mismatches.append(
            f"unsupported top-level opcode counts: got {top_level!r}, "
            f"expected {candidate.unsupported_top_level!r}"
        )
    op11 = _unsupported_op11_counts_350(report)
    if op11 != candidate.unsupported_op11:
        mismatches.append(
            f"unsupported op11 selector counts: got {op11!r}, "
            f"expected {candidate.unsupported_op11!r}"
        )
    if mismatches:
        raise UnknownNativeVmpStaticCandidate(
            f"{candidate.name} static inventory does not match the 350.101 manifest: "
            + "; ".join(mismatches)
        )

    # Preserve the generic static-span schema and rows so existing inventory
    # consumers keep working, while making the deliberately narrow evidence
    # boundary machine-readable for this known candidate.
    report["candidate_validation"] = {
        "schema": "dyidre.native_vmp_runtime_350101.package_check_static_candidate.v1",
        "candidate_name": candidate.name,
        "image_identity": {
            "version": image_identity.version,
            "size": image_identity.size,
            "sha256": image_identity.sha256,
        },
        "callsite": {
            "wrapper_entry": f"0x{candidate.wrapper_entry:x}",
            "args_setup": f"0x{candidate.args_setup:x}",
            "exe_vm_callsite": f"0x{candidate.exe_vm_callsite:x}",
            "caller_lr": f"0x{candidate.caller_lr:x}",
            "vm_data1": f"0x{candidate.vm_data1:x}",
            "vm_data2": f"0x{candidate.vm_data2:x}",
        },
        "terminal_word": {
            "file_offset": f"0x{candidate.terminal_word_offset:x}",
            "value": f"0x{candidate.terminal_word:08x}",
        },
        "evidence_boundary": {
            "proves": [
                "the exact SO and caller-bounded byte span match the recovered static inventory",
                "the program, auxiliary-table, and native-callsite offsets match this candidate",
            ],
            "does_not_prove": [
                "a complete NativeVmpWrapperAbi350 or a pParam/result ABI",
                "dynamic reachability or semantic behavior of every VM word",
                "tail-bridge business semantics, guard-field writes, device behavior, or signature results",
            ],
        },
    }
    return report


def words_from_reads(reads: Sequence[object]) -> dict[int, int]:
    """Build a stable VM program image from decoder ``VmRead`` objects.

    A normal interpreter needs one word per virtual PC. If a trace records
    more than one word at the same PC, the program could be self-modifying (or
    the supplied pages are not solely code); silently taking first or last
    would make later replay unsound, so such an image is rejected.
    """
    words: dict[int, int] = {}
    for read in reads:
        pc = int(read.vm_pc)  # type: ignore[attr-defined]
        word = int(read.word) & 0xFFFFFFFF  # type: ignore[attr-defined]
        previous = words.get(pc)
        if previous is not None and previous != word:
            raise ValueError(
                f"trace has conflicting VM words at pc=0x{pc:x}: "
                f"0x{previous:08x} vs 0x{word:08x}"
            )
        words[pc] = word
    return words


def words_from_trace(log: Path, pages: Sequence[int]) -> dict[int, int]:
    """Extract a stable VM program image from explicit traced code pages."""
    if not pages:
        raise ValueError("provide at least one VM code page; do not infer a partial program")
    rows = decoder.parse_log(log)
    vm_pages = {page & ~0xFFF for page in pages}
    return words_from_reads(decoder.extract_vm_reads(rows, vm_pages))


class NativeVmpRuntime350:
    """Partial, strict interpreter for evidence-confirmed 350.101 operations.

    ``bridges`` is intentionally keyed by opcode.  A later handler recovery
    can supply an implementation without changing the dispatcher or pretending
    that a native helper is a generic arithmetic instruction.
    """

    def __init__(self, words: dict[int, int], bridges: dict[int, NativeBridge] | None = None):
        self.words = dict(words)
        self.bridges = dict(bridges or {})

    @classmethod
    def from_trace(
        cls,
        log: Path,
        pages: Sequence[int],
        bridges: dict[int, NativeBridge] | None = None,
    ) -> "NativeVmpRuntime350":
        """Construct a strict runtime from explicit VM-code pages in a trace."""
        return cls(words_from_trace(log, pages), bridges)

    def fetch(self, state: VmState) -> Instruction:
        try:
            word = self.words[state.pc]
        except KeyError as exc:
            raise UnsupportedOpcode(f"no captured VM word at pc=0x{state.pc:x}") from exc
        return Instruction.decode(state.pc, word)

    def step(self, state: VmState) -> Instruction:
        insn = self.fetch(state)
        if insn.pc != state.pc:
            raise RuntimeError(
                f"fetch returned pc=0x{insn.pc:x} while VM state is at 0x{state.pc:x}"
            )
        next_pc = insn.fallthrough

        if insn.op == 0x0D:
            # +0x53540 packs an absolute VM-word index and adds code_base.
            next_pc = state.code_base + (decoder.op0d_target26(insn.word) << 2)
        elif insn.op == 0x0B:
            # +0x5685C is a 32-bit left-side masked store, not the legacy
            # 64-bit unaligned family label. It preserves old low bytes for
            # nonzero alignment and shifts the value's low word upward.
            base, value = decoder.op0b_regs(insn.word)
            address = (state.reg(base) + decoder.op0b_simm16(insn.word)) & MASK64
            aligned = address & ~0x3
            alignment = address & 0x3
            value32 = state.reg(value) & 0xFFFFFFFF
            if alignment == 0:
                state.memory.write(aligned, 4, value32)
            else:
                previous = state.memory.read(aligned, 4)
                preserve_mask = (1 << (8 * alignment)) - 1
                merged = (previous & preserve_mask) | (
                    (value32 << (8 * alignment)) & 0xFFFFFFFF
                )
                state.memory.write(aligned, 4, merged)
        elif insn.op == 0x01:
            dst, src = decoder.op01_regs(insn.word)
            address = (state.reg(src) + decoder.op01_simm16(insn.word)) & MASK64
            state.set_reg(dst, state.memory.read(address, 4, signed=True))
        elif insn.op == 0x0F:
            dst, src = decoder.op0f_regs(insn.word)
            state.set_reg(dst, state.reg(src) + decoder.op0f_simm16(insn.word))
        elif insn.op == 0x10:
            base, value = decoder.op10_regs(insn.word)
            address = (state.reg(base) + decoder.op10_simm16(insn.word)) & MASK64
            state.memory.write(address, 1, state.reg(value))
        elif insn.op == 0x13:
            # +0x55FD4 aligns address=v[base]+simm16 down to a qword.  For
            # nonzero alignment it preserves the old low bytes and fills the
            # rest from v[value] shifted left by 8*alignment.  This is the
            # complementary normal-path merge to op3e's right-side variant.
            base, value = decoder.op13_regs(insn.word)
            address = (state.reg(base) + decoder.op13_simm16(insn.word)) & MASK64
            aligned = address & ~0x7
            alignment = address & 0x7
            if alignment == 0:
                state.memory.write(aligned, 8, state.reg(value))
            else:
                previous = state.memory.read(aligned, 8)
                preserve_mask = (1 << (8 * alignment)) - 1
                merged = (previous & preserve_mask) | (
                    (state.reg(value) << (8 * alignment)) & MASK64
                )
                state.memory.write(aligned, 8, merged)
        elif insn.op == 0x11:
            selector = decoder.op11_selector(insn.word)
            r12, r17, r22, r27 = decoder.op11_fields(insn.word)
            if selector == 0x03:
                # +0x4DC54: W-register LSL followed by SXTW to the VM slot.
                shifted = ((state.reg(r12) & 0xFFFFFFFF) << r17) & 0xFFFFFFFF
                state.set_reg(r27, decoder.sign_extend(shifted, 32))
            elif selector == 0x0E:
                # +0x4E0BC is the secondary ADD64_REG handler for op11.0e.
                state.set_reg(r27, state.reg(r17) + state.reg(r22))
            elif selector == 0x17:
                # +0x4CF20 reads v[r22], shifts it by the *encoded* r17
                # field (not by v[r17]), then writes v[r27].
                state.set_reg(r27, state.reg(r22) << r17)
            elif selector == 0x1D:
                state.set_reg(r12, state.reg(r22) ^ state.reg(r27))
            elif selector == 0x1E:
                # +0x4F860 reaches the normal virtual-PC route at +0x4F880.
                # Its native host-escape comparisons are intentionally outside
                # this portable VM-state model.
                next_pc = state.reg(r22)
            elif selector == 0x2B:
                state.set_reg(
                    r27,
                    int(
                        decoder.sign_extend(state.reg(r12), 64)
                        < decoder.sign_extend(state.reg(r22), 64)
                    ),
                )
            elif selector == 0x2C:
                state.set_reg(r27, state.reg(r12) | state.reg(r22))
            elif selector == 0x32:
                # +0x4F830 writes the link slot before entering the shared
                # virtual-PC route. Preserve that order if link == target.
                state.set_reg(r12, insn.fallthrough)
                state.call_stack.append(insn.fallthrough)
                next_pc = state.reg(r27)
            elif insn.op in self.bridges:
                bridged_pc = self.bridges[insn.op](state, insn)
                if bridged_pc is not None:
                    next_pc = bridged_pc
            else:
                name, note = decoder.OP11_SUBOP_INFO.get(
                    selector, (f"SUBOP_{selector:02x}", "selector is not recovered")
                )
                raise UnsupportedOpcode(
                    f"pc=0x{insn.pc:x} word=0x{insn.word:08x} op=0x11 "
                    f"subop=0x{selector:02x} {name}: {note}"
                )
        elif insn.op == 0x14:
            # +0x54020's CSEL retains fallthrough on equality, hence BNE.
            lhs, rhs = decoder.op14_regs(insn.word)
            if state.reg(lhs) != state.reg(rhs):
                next_pc = insn.fallthrough + (decoder.op14_simm16(insn.word) << 2)
        elif insn.op == 0x16:
            # +0x56E70 is an ordinary AArch64 ST32 with a custom encoding.
            base, value = decoder.op16_regs(insn.word)
            address = (state.reg(base) + decoder.op16_simm16(insn.word)) & MASK64
            state.memory.write(address, 4, state.reg(value))
        elif insn.op == 0x18:
            # Current handler +0x54A1C uses a distinct scattered register
            # encoding, then performs an ordinary signed-offset qword load.
            dst, src = decoder.op18_regs(insn.word)
            address = (state.reg(src) + insn.simm16) & MASK64
            state.set_reg(dst, state.memory.read(address, 8))
        elif insn.op == 0x1A:
            # Current handler +0x561B4: a separately encoded ST64, not a
            # branch. It resolves base/value slots through x27, reconstructs
            # its own signed offset, then stores.
            base, value = decoder.op1a_regs(insn.word)
            address = (state.reg(base) + decoder.op1a_simm16(insn.word)) & MASK64
            state.memory.write(address, 8, state.reg(value))
        elif insn.op == 0x21:
            dst, src = decoder.op21_regs(insn.word)
            rhs = decoder.op21_simm16(insn.word) & MASK64
            state.set_reg(dst, int(state.reg(src) < rhs))
        elif insn.op == 0x28:
            dst, src = decoder.op28_regs(insn.word)
            address = (state.reg(src) + decoder.op28_simm16(insn.word)) & MASK64
            state.set_reg(dst, state.memory.read(address, 1))
        elif insn.op == 0x2B:
            reg_index = decoder.op2b_reg(insn.word)
            if decoder.sign_extend(state.reg(reg_index), 64) > 0:
                next_pc = insn.fallthrough + (decoder.op2b_simm16(insn.word) << 2)
        elif insn.op == 0x2D:
            # +0x53DB0 is the real VM equality branch. Its native B.CC decoy
            # path is interpreter hardening and is intentionally not modeled.
            lhs, rhs = decoder.op2d_regs(insn.word)
            if state.reg(lhs) == state.reg(rhs):
                next_pc = insn.fallthrough + (decoder.op2d_simm16(insn.word) << 2)
        elif insn.op == 0x2E:
            # +0x565E0 is a 32-bit right-side masked store, not an
            # unaligned load. It retains old high bytes except at the tail
            # alignment, where the normal path is a complete word store.
            base, value = decoder.op2e_regs(insn.word)
            address = (state.reg(base) + decoder.op2e_simm16(insn.word)) & MASK64
            aligned = address & ~0x3
            alignment = address & 0x3
            value32 = state.reg(value) & 0xFFFFFFFF
            if alignment == 3:
                state.memory.write(aligned, 4, value32)
            else:
                previous = state.memory.read(aligned, 4)
                preserve_mask = (0xFFFFFF00 << (8 * alignment)) & 0xFFFFFFFF
                merged = (previous & preserve_mask) | (
                    value32 >> (24 - 8 * alignment)
                )
                state.memory.write(aligned, 4, merged)
        elif insn.op == 0x30:
            dst, src = decoder.op30_regs(insn.word)
            state.set_reg(dst, state.reg(src) | decoder.op30_imm16(insn.word))
        elif insn.op == 0x34:
            high_word = decoder.op34_imm16(insn.word) << 16
            state.set_reg(decoder.op34_dst(insn.word), decoder.sign_extend(high_word, 32))
        elif insn.op == 0x35:
            dst, src = decoder.op35_regs(insn.word)
            state.set_reg(dst, (state.reg(src) & 0xFFFFFFFF) & decoder.op35_imm16(insn.word))
        elif insn.op == 0x3B:
            dst, src = decoder.op3b_regs(insn.word)
            state.set_reg(dst, decoder.sign_extend(state.reg(src), 32) + decoder.op3b_simm16(insn.word))
        elif insn.op == 0x3E:
            # +0x55D20 is not the old common-field OR-immediate operation.
            # It aligns address=v[base]+simm16 down to a qword, then retains
            # the high bytes and fills the low ``alignment + 1`` bytes from
            # the corresponding high portion of v[value].  At alignment 7,
            # this reduces to a full qword store and does not read old data.
            base, value = decoder.op3e_regs(insn.word)
            address = (state.reg(base) + decoder.op3e_simm16(insn.word)) & MASK64
            aligned = address & ~0x7
            alignment = address & 0x7
            if alignment == 7:
                state.memory.write(aligned, 8, state.reg(value))
            else:
                previous = state.memory.read(aligned, 8)
                preserve_mask = (0xFFFFFFFFFFFFFF00 << (8 * alignment)) & MASK64
                merged = (previous & preserve_mask) | (state.reg(value) >> (56 - 8 * alignment))
                state.memory.write(aligned, 8, merged)
        elif insn.op in self.bridges:
            bridged_pc = self.bridges[insn.op](state, insn)
            if bridged_pc is not None:
                next_pc = bridged_pc
        else:
            name, note = decoder.OP_INFO.get(insn.op, (f"UNK_{insn.op:02x}", "unseen"))
            raise UnsupportedOpcode(
                f"pc=0x{insn.pc:x} word=0x{insn.word:08x} op=0x{insn.op:02x} {name}: {note}"
            )

        state.pc = next_pc
        state.steps += 1
        return insn

    def run(
        self,
        state: VmState,
        max_steps: int = 100_000,
        *,
        host_exit_sentinel: int | None = None,
    ) -> VmState:
        """Run until the step limit or one explicitly supplied host exit.

        The portable VM model has no generic meaning for a PC outside its
        supplied word image.  A wrapper may, however, establish one exact
        saved-LR/host-return sentinel (as observed for the small 350.101 VM
        helpers).  Only a caller-supplied value is accepted here; a register
        jump to any other uncaptured address still fails at ``fetch()``.
        """
        if host_exit_sentinel is not None and not 0 <= host_exit_sentinel <= MASK64:
            raise ValueError(
                f"host exit sentinel must be an unsigned 64-bit address, got {host_exit_sentinel}"
            )
        if host_exit_sentinel is not None and host_exit_sentinel % 4:
            raise ValueError(
                f"host exit sentinel must be 4-byte aligned, got 0x{host_exit_sentinel:x}"
            )
        if host_exit_sentinel is not None and host_exit_sentinel in self.words:
            raise ValueError(
                f"host exit sentinel 0x{host_exit_sentinel:x} is present in the VM word image"
            )
        while True:
            if host_exit_sentinel is not None and state.pc == host_exit_sentinel:
                return state
            if state.steps >= max_steps:
                raise RuntimeError(f"step limit reached ({max_steps}) at pc=0x{state.pc:x}")
            self.step(state)


def _edge_int(value: object) -> int:
    return int(value, 0) if isinstance(value, str) else int(value)


def control_edge_map(
    edges: Mapping[object, Mapping[object, object]] | Sequence[Mapping[str, object]],
) -> dict[int, dict[int, int]]:
    """Normalize runtime edge maps and coverage JSON rows to one bridge ABI."""
    normalized: dict[int, dict[int, int]] = {}
    if isinstance(edges, Mapping):
        for source, targets in edges.items():
            source_int = _edge_int(source)
            normalized[source_int] = {
                _edge_int(target): _edge_int(count) for target, count in targets.items()
            }
        return normalized

    for row in edges:
        source = _edge_int(row["from_pc"])
        target = _edge_int(row["to_pc"])
        count = _edge_int(row.get("count", 1))
        normalized.setdefault(source, {})[target] = count
    return normalized


def make_trace_control_bridges(
    edges: Mapping[object, Mapping[object, object]] | Sequence[Mapping[str, object]],
) -> dict[int, NativeBridge]:
    """Make exact-path branch bridges from a captured trace.

    This bridge is intentionally conservative: a branch PC with more than one
    observed successor is rejected, since a new input might select either one.
    It is useful for replaying a single capture while the real predicate is
    still being recovered, but must never be presented as generic semantics.
    """
    edge_map = control_edge_map(edges)

    def branch(state: VmState, insn: Instruction) -> int:
        targets = edge_map.get(insn.pc, {})
        if len(targets) != 1:
            rendered = ", ".join(f"0x{pc:x}:{count}" for pc, count in sorted(targets.items()))
            raise UnsupportedOpcode(
                f"trace branch bridge ambiguous/missing at pc=0x{insn.pc:x}; observed [{rendered}]"
            )
        return next(iter(targets))

    return {op: branch for op in CONTROL_OPS}


def observed_control_edges(reads: list[object]) -> list[dict[str, object]]:
    """Return observed VM-PC edges, preserving trace order rather than CFG guesses."""
    # ``VmRead`` is supplied by the decoder module; retaining it as object
    # avoids coupling its dataclass as part of this runtime's public ABI.
    transitions: Counter[tuple[int, int, int | None, int]] = Counter()
    compact: list[object] = []
    previous: tuple[int, int] | None = None
    for read in reads:
        key = (read.vm_pc, read.word)  # type: ignore[attr-defined]
        if key != previous:
            compact.append(read)
            previous = key
    for current, following in zip(compact, compact[1:]):
        if is_control_word(current.word):  # type: ignore[attr-defined]
            op = current.op  # type: ignore[attr-defined]
            selector = decoder.op11_selector(current.word) if op == 0x11 else None  # type: ignore[attr-defined]
            transitions[(current.vm_pc, op, selector, following.vm_pc)] += 1  # type: ignore[attr-defined]
    return [
        {
            "from_pc": f"0x{source:x}", "op": f"0x{op:02x}",
            **({"subop": f"0x{selector:02x}"} if selector is not None else {}),
            "to_pc": f"0x{target:x}", "count": count,
        }
        for (source, op, selector, target), count in sorted(transitions.items())
    ]


def coverage_from_trace(log: Path, pages: list[int], keep_repeats: bool) -> dict[str, object]:
    """Emit a reproducible opcode/handler debt list from a GumTrace capture."""
    rows = decoder.parse_log(log)
    base = decoder.infer_image_base(rows)
    vm_pages = {page & ~0xFFF for page in pages} if pages else decoder.infer_vm_pages(rows, 1)
    raw_reads = decoder.extract_vm_reads(rows, vm_pages)
    collapsed = decoder.collapse_consecutive_reads(raw_reads)
    stream = collapsed if keep_repeats else decoder.unique_stream_reads(collapsed)
    events = decoder.extract_dispatches(rows, base, raw_reads)
    opcode_rows, op11_rows = opcode_coverage_from_words(
        [read.word for read in stream]
    )
    implemented_stream_words = sum(is_supported_word(read.word) for read in stream)
    targets = Counter(event.target for event in events)
    return {
        "schema": "dyidre.native_vmp_runtime_350101.coverage.v2",
        "source_log": str(log), "image_base": f"0x{base:x}",
        "trace_sha256": hashlib.sha256(log.read_bytes()).hexdigest(),
        "vm_pages": [f"0x{page:x}" for page in sorted(vm_pages)],
        "raw_word_reads": len(raw_reads), "stream_words": len(stream),
        "stream_selection": (
            "consecutive-duplicate-collapsed" if keep_repeats
            else "unique-(vm_pc,word)-after-consecutive-duplicate-collapse"
        ),
        "supported_opcodes": [f"0x{op:02x}" for op in sorted(SUPPORTED_OPCODES)],
        "supported_op11_selectors": [
            f"0x{selector:02x}" for selector in sorted(SUPPORTED_OP11_SELECTORS)
        ],
        "implemented_stream_words": implemented_stream_words,
        "unsupported_stream_words": len(stream) - implemented_stream_words,
        "br_x8_dispatches": len(events), "opcode_coverage": opcode_rows,
        "unsupported_opcodes": [row for row in opcode_rows if not row["implemented"]],
        "op11_subopcode_coverage": op11_rows,
        "unsupported_op11_selectors": [row for row in op11_rows if not row["implemented"]],
        "observed_control_edges": observed_control_edges(raw_reads),
        "handler_targets": [
            {"offset": f"0x{target:x}", "count": count, "label": decoder.handler_label(target)}
            for target, count in targets.most_common()
        ],
    }


def selftest() -> None:
    base = 0x1000
    def check(label: str, actual: object, expected: object) -> None:
        if actual != expected:
            raise AssertionError(f"{label}: got {actual!r}, expected {expected!r}")

    def reject_wrapper_abi(label: str, action: Callable[[], object]) -> None:
        try:
            action()
        except UnknownNativeVmpWrapperAbi:
            return
        raise AssertionError(f"{label}: unexpectedly accepted")

    def reject_image(label: str, action: Callable[[], object]) -> None:
        try:
            action()
        except UnknownNativeVmpImage:
            return
        raise AssertionError(f"{label}: unexpectedly accepted")

    def reject_static_candidate(label: str, action: Callable[[], object]) -> None:
        try:
            action()
        except UnknownNativeVmpStaticCandidate:
            return
        raise AssertionError(f"{label}: unexpectedly accepted")

    def reject_entry_observation(label: str, action: Callable[[], object]) -> None:
        try:
            action()
        except UnknownNativeVmpEntryObservation:
            return
        raise AssertionError(f"{label}: unexpectedly accepted")

    check(
        "known native VMP image identity",
        validate_native_vmp_image_identity_350(KNOWN_NATIVE_VMP_IMAGE_350),
        KNOWN_NATIVE_VMP_IMAGE_350,
    )
    reject_image(
        "wrong native VMP image size",
        lambda: validate_native_vmp_image_identity_350(
            replace(KNOWN_NATIVE_VMP_IMAGE_350, size=0x2BB400)
        ),
    )
    reject_image(
        "wrong native VMP image hash",
        lambda: validate_native_vmp_image_identity_350(
            replace(KNOWN_NATIVE_VMP_IMAGE_350, sha256="00" * 32)
        ),
    )
    reject_image(
        "same-size noncanonical native VMP image bytes",
        lambda: validate_native_vmp_image_350(b"\0" * KNOWN_NATIVE_VMP_IMAGE_350.size),
    )
    check(
        "closed native VMP static candidate count",
        len(KNOWN_NATIVE_VMP_STATIC_CANDIDATES_350),
        1,
    )
    check(
        "known package-check static candidate",
        validate_native_vmp_static_candidate_350(
            PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350
        ),
        PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350,
    )
    reject_static_candidate(
        "changed package-check static candidate span",
        lambda: validate_native_vmp_static_candidate_350(
            replace(PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350, byte_count=0x1C7C)
        ),
    )
    reject_static_candidate(
        "boolean package-check static sentinel",
        lambda: validate_native_vmp_static_candidate_350(
            replace(PACKAGE_CHECK_VMP_STATIC_CANDIDATE_350, terminal_word=False)
        ),
    )
    reject_image(
        "package-check static validation image identity first",
        lambda: validate_package_check_vm_static_candidate_350(b""),
    )

    check("closed native wrapper ABI count", len(KNOWN_NATIVE_VMP_WRAPPERS_350), 3)
    small_1ec670 = resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x1EC670, 0xD95CC)
    check("small 1ec670 wrapper", small_1ec670.wrapper_entry, 0xD9574)
    check("small 1ec670 data", (small_1ec670.vm_data1, small_1ec670.vm_data2), (0x262980, 0x2629C0))
    check("small 1ec670 result ABI", (small_1ec670.result_kind, small_1ec670.result_offset),
          ("u32_at_param_window_plus_0", 0))
    check(
        "small 1ec670 VmParam layout",
        small_1ec670.vm_param_layout,
        SMALL_VMP_VM_PARAM_LAYOUT_350,
    )
    check("small 1ec670 pParam anchor", small_1ec670.p_param_anchor_stack_offset, 0x4A0)
    check(
        "small 1ec670 bridge ABI",
        small_1ec670.bridge_abi,
        SMALL_VMP_TAIL_BRIDGE_ABI_350,
    )
    check(
        "small entry context write roles",
        tuple((write.offset, write.role) for write in small_1ec670.p_param_entry_context_writes),
        (
            (-0x120, "vm_code"), (-0x118, "zero"),
            (-0xF8, "p_param_window"), (-0xF0, "vm_data1"),
            (-0xE8, "vm_data2"), (-0xE0, "fun_bridge"),
            (-0x30, "aligned_context_base"), (-0x20, "outer_return_lr"),
        ),
    )

    small_1ecaf0 = resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x1ECAF0, 0xD964C)
    check("small 1ecaf0 wrapper", small_1ecaf0.wrapper_entry, 0xD95F4)
    check("small wrappers share bridge", small_1ecaf0.fun_bridge, small_1ec670.fun_bridge)
    check("small 1ecaf0 pParam anchor", small_1ecaf0.p_param_anchor_stack_offset, 0x3C0)

    material_1f7860 = resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x1F7860, 0x124E34)
    check("material wrapper", material_1f7860.wrapper_entry, 0x124DD4)
    check("material parameter source order", material_1f7860.param_window_sources,
          ("x8", "x0", "x1", "x2"))
    check("material result ABI", (material_1f7860.result_kind, material_1f7860.result_offset),
          ("out_ref_material", None))
    check(
        "material small-wrapper metadata remains unknown",
        (
            material_1f7860.vm_param_layout,
            material_1f7860.p_param_anchor_stack_offset,
            material_1f7860.p_param_entry_context_writes,
            material_1f7860.bridge_abi,
        ),
        (None, None, (), None),
    )
    for abi in KNOWN_NATIVE_VMP_WRAPPERS_350:
        check(f"validate canonical ABI {abi.name}", validate_native_vmp_wrapper_abi_350(abi), abi)

    reject_wrapper_abi(
        "entry-only 1f6670 pair",
        lambda: resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x1F6670, 0x11999C),
    )
    reject_wrapper_abi(
        "entry-only 201800 pair",
        lambda: resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x201800, 0x12ACF8),
    )
    reject_wrapper_abi(
        "wrong caller LR",
        lambda: resolve_native_vmp_wrapper_abi_350(0x4CC10, 0x1EC670, 0xD95C8),
    )
    reject_wrapper_abi(
        "wrong VM data",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, vm_data1=0x262984)
        ),
    )
    reject_wrapper_abi(
        "wrong parameter-window offset",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, param_window_stack_offset=0)
        ),
    )
    reject_wrapper_abi(
        "wrong VmParam offset",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, vm_param_stack_offset=0x20)
        ),
    )
    reject_wrapper_abi(
        "wrong result kind",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, result_kind="out_ref_material", result_offset=None)
        ),
    )
    reject_wrapper_abi(
        "wrong small pParam anchor",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, p_param_anchor_stack_offset=0x4A8)
        ),
    )
    reject_wrapper_abi(
        "wrong small bridge ABI",
        lambda: validate_native_vmp_wrapper_abi_350(
            replace(small_1ec670, bridge_abi=replace(
                SMALL_VMP_TAIL_BRIDGE_ABI_350, transfer="blr_x2"
            ))
        ),
    )
    reject_wrapper_abi(
        "wrong wrapper before image check",
        lambda: validate_native_vmp_wrapper_image_350(
            b"", replace(small_1ec670, vm_data1=0x262984)
        ),
    )

    observed_base = 0x6C070D0000
    small_observation = resolve_native_vmp_entry_observation_350(
        NativeVmpEntryRegisters350(
            pc=observed_base + 0x4CC10,
            lr=observed_base + 0xD95CC,
            sp=0x6BEDF6D940,
            x0=observed_base + 0x1EC670,
            x1=0x6BEDF6D948,
            x2=observed_base + 0x262980,
            x3=observed_base + 0x2629C0,
            x4=0x6BEDF6D950,
        )
    )
    check("small entry observation ABI", small_observation.abi, small_1ec670)
    check("small entry observation base", small_observation.module_base, observed_base)
    material_observation = resolve_native_vmp_entry_observation_350(
        NativeVmpEntryRegisters350(
            pc=observed_base + 0x4CC10,
            lr=observed_base + 0x124E34,
            sp=0x6BEDF6D940,
            x0=observed_base + 0x1F7860,
            x1=0x6BEDF6D940,
            x2=observed_base + 0x26F2E0,
            x3=observed_base + 0x26F300,
            x4=0x6BEDF6D960,
        )
    )
    check("material entry observation ABI", material_observation.abi, material_1f7860)
    reject_entry_observation(
        "wrong observed data pointer",
        lambda: resolve_native_vmp_entry_observation_350(
            replace(small_observation.registers, x3=observed_base + 0x2629C4)
        ),
    )
    reject_entry_observation(
        "wrong observed parameter window",
        lambda: resolve_native_vmp_entry_observation_350(
            replace(small_observation.registers, x1=small_observation.registers.sp)
        ),
    )

    def one(word: int) -> VmState:
        state = VmState(code_base=base)
        NativeVmpRuntime350({base: word}).step(state)
        return state

    partial_memory = VmMemory({0x5000: 0xA5})
    try:
        partial_memory.read(0x5000, 8)
    except UnmappedVmMemory:
        pass
    else:
        raise AssertionError("partial VM memory read was silently zero-filled")

    stable_reads = (
        decoder.VmRead(1, 0, base, 0x3C19E7F4, "ldr w0, [x0]"),
        decoder.VmRead(2, 0, base + 4, 0x280002A8, "ldr w0, [x0]")
    )
    check(
        "stable traced program image",
        words_from_reads(stable_reads),
        {base: 0x3C19E7F4, base + 4: 0x280002A8},
    )
    try:
        words_from_reads((stable_reads[0], decoder.VmRead(3, 0, base, 0x00000011, "ldr w0, [x0]")))
    except ValueError:
        pass
    else:
        raise AssertionError("self-modifying trace image was accepted")

    # Frozen raw-word field vectors. These deliberately do not use an encoder
    # derived from the decoder, so a swapped bit slice cannot self-validate.
    check("op01 fields", (decoder.op01_regs(0xF55A1A41), decoder.op01_simm16(0xF55A1A41)), ((30, 17), -23206))
    check("op0f fields", (decoder.op0f_regs(0xF543D24F), decoder.op0f_simm16(0xF543D24F)), ((30, 17), -23206))
    op0b_vectors = (
        (0x0012418B, (9, 3), 8),
        (0x0010810B, (8, 2), 16),
    )
    for word, expected_regs, expected_offset in op0b_vectors:
        check(
            f"op0b fields 0x{word:08x}",
            (decoder.op0b_regs(word), decoder.op0b_simm16(word)),
            (expected_regs, expected_offset),
        )
    check("op0b negative offset", decoder.op0b_simm16(0x0000004B), -0x8000)
    op13_vectors = (
        (0x02440013, (9, 2), 0),
        (0x22020013, (8, 1), 8),
        (0x02060013, (8, 3), 0),
    )
    for word, expected_regs, expected_offset in op13_vectors:
        check(
            f"op13 fields 0x{word:08x}",
            (decoder.op13_regs(word), decoder.op13_simm16(word)),
            (expected_regs, expected_offset),
        )
    check("op13 negative offset", decoder.op13_simm16(0x00010013), -0x8000)
    check("op18 fields", (decoder.op18_regs(0x808000D8), decoder.imm16_common(0x808000D8)), ((18, 17), 2051))
    check("op1a fields", (decoder.op1a_regs(0xA03B2F9A), decoder.op1a_simm16(0xA03B2F9A)), ((29, 31), 0x4A8))
    check("op1a negative offset", decoder.op1a_simm16(0xA03B2FDA), -0x7B58)
    check("op14 fields", (decoder.op14_regs(0x00660014), decoder.op14_simm16(0x00660014)), ((1, 16), 6))
    check("op2d fields", (decoder.op2d_regs(0xA923DEAD), decoder.op2d_simm16(0xA923DEAD)), ((17, 29), -23206))
    op2e_vectors = (
        (0x2C12302E, (9, 3), 11),
        (0x4C10202E, (8, 2), 19),
    )
    for word, expected_regs, expected_offset in op2e_vectors:
        check(
            f"op2e fields 0x{word:08x}",
            (decoder.op2e_regs(word), decoder.op2e_simm16(word)),
            (expected_regs, expected_offset),
        )
    check("op2e negative offset", decoder.op2e_simm16(0x0000082E), -0x8000)
    check("op16 fields", (decoder.op16_regs(0x00801016), decoder.op16_simm16(0x00801016)), ((2, 1), 0))
    check("op28 fields", (decoder.op28_regs(0x942000E8), decoder.op28_simm16(0x942000E8)), ((18, 17), -32767))
    check("op34 fields", (decoder.op34_dst(0x3439E7F4), decoder.op34_imm16(0x3439E7F4)), (22, 0xFF3C))
    check("op35 fields", (decoder.op35_regs(0x9C1F71B5), decoder.op35_imm16(0x9C1F71B5)), ((3, 23), 0x00FF))
    op3e_vectors = (
        (0x1E40013E, (9, 2), 7),
        (0x3E0000BE, (8, 1), 15),
        (0x1E0001BE, (8, 3), 7),
    )
    for word, expected_regs, expected_offset in op3e_vectors:
        check(
            f"op3e fields 0x{word:08x}",
            (decoder.op3e_regs(word), decoder.op3e_simm16(word)),
            (expected_regs, expected_offset),
        )
    op11_vectors = (
        (0x280640D1, 0x03, (4, 3, 0, 5)),
        (0x08680391, 0x0E, (0, 20, 1, 1)),
        (0x10A205D1, 0x17, (0, 17, 2, 2)),
        (0x08C17751, 0x1D, (23, 0, 3, 1)),
        (0x07C00791, 0x1E, (0, 0, 31, 0)),
        (0x08C13AD1, 0x2B, (19, 0, 3, 1)),
        (0x81C00B11, 0x2C, (0, 0, 7, 16)),
        (0xC801FC91, 0x32, (31, 0, 0, 25)),
    )
    for word, selector, expected_fields in op11_vectors:
        check(
            f"op11 selector/fields 0x{selector:02x}",
            (decoder.op11_selector(word), decoder.op11_fields(word)),
            (selector, expected_fields),
        )
    check(
        "op11 selector gate",
        (
            is_supported_word(0x81C00B11),
            is_supported_word(0x10A205D1),
            is_supported_word(0x0012418B),
            is_supported_word(0x02440013),
            is_supported_word(0x2C12302E),
            is_supported_word(0x1E40013E),
            is_supported_word(0x00000011),
        ),
        (True, True, True, True, True, True, False),
    )

    static_report = coverage_from_static_span(
        b"\x00" * 0x20
        + (0x0000000F).to_bytes(4, "little")
        + (0x00000011).to_bytes(4, "little"),
        file_offset=0x20,
        vm_code=0x4000,
        byte_count=8,
    )
    check("static span bounds", (static_report["file_offset"], static_report["vm_code_end"]), ("0x20", "0x4008"))
    check("static span word count", static_report["word_count"], 2)
    check("static span selector-gated count", static_report["implemented_words"], 1)
    check("static span unsupported word count", static_report["unsupported_words"], 1)
    check("static span unsupported op11", static_report["unsupported_op11_selectors"], [{
        "selector": "0x00", "count": 1, "name": "SUBOP_00", "implemented": False,
        "evidence": "selector is not recovered",
    }])
    mixed_op11_rows, _ = opcode_coverage_from_words((0x08680391, 0x00000011))
    mixed_op11 = next(row for row in mixed_op11_rows if row["op"] == "0x11")
    check(
        "mixed op11 aggregate counts",
        (
            mixed_op11["count"], mixed_op11["implemented"],
            mixed_op11["implemented_word_count"], mixed_op11["unsupported_word_count"],
        ),
        (2, False, 1, 1),
    )
    try:
        coverage_from_static_span(b"\x00" * 8, file_offset=0, vm_code=0x4000, byte_count=6)
    except ValueError:
        pass
    else:
        raise AssertionError("non-word-aligned static span was accepted")
    for label, file_offset, vm_code in (
        ("file offset", 1, 0x4000),
        ("VM code address", 0, 0x4001),
    ):
        try:
            coverage_from_static_span(
                b"\x00" * 8,
                file_offset=file_offset,
                vm_code=vm_code,
                byte_count=4,
            )
        except ValueError:
            pass
        else:
            raise AssertionError(f"unaligned static {label} was accepted")

    state = VmState(code_base=base)
    state.set_reg(17, 0x10000)
    state.memory.write(0xA55A, 4, 0xFFFFFF80)
    NativeVmpRuntime350({base: 0xF55A1A41}).step(state)
    check("op01 i32 sign extension", state.reg(30), MASK64 - 0x7F)

    state = VmState(code_base=base)
    state.set_reg(17, 0x10000)
    try:
        NativeVmpRuntime350({base: 0xF55A1A41}).step(state)
    except UnmappedVmMemory:
        pass
    else:
        raise AssertionError("op01 accepted an unmapped host/input address")
    check("op01 unmapped input leaves PC", state.pc, base)
    check("op01 unmapped input leaves steps", state.steps, 0)

    state = VmState(code_base=base)
    state.set_reg(17, 0x100)
    NativeVmpRuntime350({base: 0xF543D24F}).step(state)
    check("op0f signed offset", state.reg(30), (0x100 - 23206) & MASK64)

    state = VmState(code_base=base)
    state.set_reg(9, 0x8000)
    state.set_reg(3, 0xAABBCCDD96317A52)
    NativeVmpRuntime350({base: 0x0012418B}).step(state)
    check("op0b aligned-head full st32", state.memory.read(0x8008, 4), 0x96317A52)

    state = VmState(code_base=base)
    state.set_reg(1, 0x8000)
    state.set_reg(2, 0xAABBCCDDEEFF0099)
    state.memory.write(0x8000, 4, 0x11223344)
    NativeVmpRuntime350({base: 0x0002090B}).step(state)
    check("op0b masked-left merge", state.memory.read(0x8000, 4), 0xFF009944)

    state = VmState(code_base=base)
    state.set_reg(29, 0x8000)
    state.set_reg(0, 0x12345678)
    NativeVmpRuntime350({base: 0xF51A0010}).step(state)
    check("op10 st8", state.memory.read(0x83A8, 1), 0x78)

    state = VmState(code_base=base)
    state.set_reg(9, 0x8000)
    state.set_reg(2, 0xD08AFCF1A70B7A52)
    NativeVmpRuntime350({base: 0x02440013}).step(state)
    check("op13 aligned-head full st64", state.memory.read(0x8000, 8), 0xD08AFCF1A70B7A52)

    state = VmState(code_base=base)
    state.set_reg(1, 0x8000)
    state.set_reg(2, 0xAABBCCDDEEFF0099)
    state.memory.write(0x8000, 8, 0x1122334455667788)
    NativeVmpRuntime350({base: 0x04440013}).step(state)
    check("op13 masked-left merge", state.memory.read(0x8000, 8), 0xBBCCDDEEFF009988)

    state = VmState(code_base=base)
    state.set_reg(2, 0x9000)
    state.set_reg(1, 0x1122334455667788)
    NativeVmpRuntime350({base: 0x00801016}).step(state)
    check("op16 st32 custom fields", state.memory.read(0x9000, 4), 0x55667788)

    state = VmState(code_base=base)
    state.set_reg(17, 0x8000)
    state.memory.write(0x8803, 8, 0x8877665544332211)
    NativeVmpRuntime350({base: 0x808000D8}).step(state)
    check("op18 ld64 scattered fields", state.reg(18), 0x8877665544332211)

    state = VmState(code_base=base)
    state.set_reg(29, 0x8000)
    state.set_reg(31, 0xAABBCCDDEEFF0011)
    NativeVmpRuntime350({base: 0xA03B2F9A}).step(state)
    check("op1a st64 scattered fields", state.memory.read(0x84A8, 8), 0xAABBCCDDEEFF0011)

    state = VmState(code_base=base)
    state.set_reg(29, 0x10000)
    state.set_reg(31, 0x1122334455667788)
    NativeVmpRuntime350({base: 0xA03B2FDA}).step(state)
    check("op1a st64 signed offset", state.memory.read(0x84A8, 8), 0x1122334455667788)

    state = VmState(code_base=base)
    state.set_reg(2, 3)
    NativeVmpRuntime350({base: 0x100020A1}).step(state)
    check("op21 unsigned comparison", state.reg(1), 1)

    state = VmState(code_base=base)
    state.set_reg(5, 0x8800)
    state.memory.write(0x8800, 1, 0xAB)
    NativeVmpRuntime350({base: 0x280002A8}).step(state)
    check("op28 unsigned byte load", state.reg(5), 0xAB)

    state = VmState(code_base=base)
    state.set_reg(9, 0x8000)
    state.set_reg(3, 0xAABBCCDD96317A52)
    NativeVmpRuntime350({base: 0x2C12302E}).step(state)
    check("op2e aligned-tail full st32", state.memory.read(0x8008, 4), 0x96317A52)

    state = VmState(code_base=base)
    state.set_reg(1, 0x8000)
    state.set_reg(2, 0xAABBCCDDEEFF0099)
    state.memory.write(0x8000, 4, 0x11223344)
    NativeVmpRuntime350({base: 0x0402202E}).step(state)
    check("op2e masked-right merge", state.memory.read(0x8000, 4), 0x1122EEFF)

    state = VmState(code_base=base)
    state.set_reg(4, 0x10000000)
    NativeVmpRuntime350({base: 0x280640D1}).step(state)
    check("op11.03 sll32s", state.reg(5), 0xFFFFFFFF80000000)

    state = VmState(code_base=base)
    state.set_reg(20, 0x100)
    state.set_reg(1, 2)
    NativeVmpRuntime350({base: 0x08680391}).step(state)
    check("op11.0e add64", state.reg(1), 0x102)

    state = VmState(code_base=base)
    state.set_reg(2, 0xB)
    NativeVmpRuntime350({base: 0x10A205D1}).step(state)
    check("op11.17 sll64", state.reg(2), 0x160000)

    state = VmState(code_base=base)
    state.set_reg(3, 0xA5A5A5A5A5A5A5A5)
    state.set_reg(1, 0xFF00FF00FF00FF00)
    NativeVmpRuntime350({base: 0x08C17751}).step(state)
    check("op11.1d xor64", state.reg(23), 0x5AA55AA55AA55AA5)

    state = VmState(code_base=base)
    state.set_reg(19, MASK64)
    state.set_reg(3, 0)
    NativeVmpRuntime350({base: 0x08C13AD1}).step(state)
    check("op11.2b signed less-than", state.reg(1), 1)

    state = VmState(code_base=base)
    state.set_reg(0, 0x1000000000000001)
    state.set_reg(7, 0x8000000000000000)
    NativeVmpRuntime350({base: 0x81C00B11}).step(state)
    check("op11.2c or64", state.reg(16), 0x9000000000000001)

    state = VmState(code_base=base)
    state.set_reg(7, 0x12340000)
    NativeVmpRuntime350({base: 0x1A02DBB0}).step(state)
    check("op30 or immediate", state.reg(1), 0x12341B70)

    state = one(0x3C19E7F4)
    check("op34 signed high immediate", state.reg(7), 0xFFFFFFFFFF3C0000)

    state = one(0x3439E7F4)
    check("op34 bit21 high destination", state.reg(22), 0xFFFFFFFFFF3C0000)

    state = VmState(code_base=base)
    state.set_reg(23, 0xAABBCCDD)
    NativeVmpRuntime350({base: 0x9C1F71B5}).step(state)
    check("op35 low32 and immediate", state.reg(3), 0xDD)

    state = VmState(code_base=base)
    state.set_reg(0, 0xFFFFFFFF)
    NativeVmpRuntime350({base: 0x0801003B}).step(state)
    check("op3b signed 32-bit source", state.reg(1), 0)

    state = VmState(code_base=base)
    state.set_reg(9, 0x8000)
    state.set_reg(2, 0xD08AFCF1A70B7A52)
    NativeVmpRuntime350({base: 0x1E40013E}).step(state)
    check("op3e aligned-tail full st64", state.memory.read(0x8000, 8), 0xD08AFCF1A70B7A52)

    state = VmState(code_base=base)
    state.set_reg(9, 0x8001)
    state.set_reg(2, 0xAABBCCDDEEFF0099)
    state.memory.write(0x8008, 8, 0x1122334455667788)
    NativeVmpRuntime350({base: 0x1E40013E}).step(state)
    check("op3e masked-right merge", state.memory.read(0x8008, 8), 0x11223344556677AA)

    # Real programs—not a mocked fetch sequence—verify both destinations of
    # each recovered control transfer.
    fall_word, target_word = 0x08010234, 0x3C19E7F4
    runtime = NativeVmpRuntime350({base: 0x00660014, base + 4: fall_word, base + 28: target_word})
    state = VmState(code_base=base)
    state.set_reg(1, 1)
    state.set_reg(16, 2)
    runtime.step(state)
    check("op14 BNE target", state.pc, base + 28)
    runtime.step(state)
    check("op14 BNE fetched target", state.reg(7), 0xFFFFFFFFFF3C0000)

    runtime = NativeVmpRuntime350({base: 0x00660014, base + 4: fall_word, base + 28: target_word})
    state = VmState(code_base=base)
    state.set_reg(1, 2)
    state.set_reg(16, 2)
    runtime.step(state)
    check("op14 BNE fallthrough", state.pc, base + 4)
    runtime.step(state)
    check("op14 BNE fetched fallthrough", state.reg(1), 0x20200000)

    runtime = NativeVmpRuntime350({base: 0x0814002B, base + 4: fall_word, base + 0x54: target_word})
    state = VmState(code_base=base)
    state.set_reg(1, 1)
    runtime.step(state)
    check("op2b BGTZ target", state.pc, base + 0x54)
    state = VmState(code_base=base)
    state.set_reg(1, MASK64)
    runtime.step(state)
    check("op2b BGTZ fallthrough", state.pc, base + 4)

    runtime = NativeVmpRuntime350({base: 0x000411AD, base + 4: fall_word, base + 28: target_word})
    state = VmState(code_base=base)
    state.set_reg(2, 7)
    state.set_reg(1, 7)
    runtime.step(state)
    check("op2d BEQ target", state.pc, base + 28)
    state = VmState(code_base=base)
    state.set_reg(2, 7)
    state.set_reg(1, 8)
    runtime.step(state)
    check("op2d BEQ fallthrough", state.pc, base + 4)

    runtime = NativeVmpRuntime350({base: 0x0017200D, base + 0x25C: target_word})
    state = VmState(code_base=base)
    runtime.step(state)
    check("op0d absolute target", state.pc, base + 0x25C)
    runtime.step(state)
    check("op0d fetched target", state.reg(7), 0xFFFFFFFFFF3C0000)

    jump_target = base + 0x80
    runtime = NativeVmpRuntime350({base: 0x07C00791, jump_target: target_word})
    state = VmState(code_base=base)
    state.set_reg(31, jump_target)
    runtime.step(state)
    check("op11.1e jump-register target", state.pc, jump_target)
    runtime.step(state)
    check("op11.1e fetched target", state.reg(7), 0xFFFFFFFFFF3C0000)

    host_exit = 0x7F0012345000
    runtime = NativeVmpRuntime350({base: 0x07C00791})
    state = VmState(code_base=base)
    state.set_reg(31, host_exit)
    runtime.run(state, max_steps=1, host_exit_sentinel=host_exit)
    check("explicit host-exit sentinel PC", state.pc, host_exit)
    check("explicit host-exit sentinel step count", state.steps, 1)

    state = VmState(code_base=base)
    state.set_reg(31, host_exit)
    try:
        runtime.run(state, max_steps=2, host_exit_sentinel=host_exit + 4)
    except UnsupportedOpcode:
        pass
    else:
        raise AssertionError("nonmatching host-exit sentinel accepted an uncaptured jump")

    try:
        runtime.run(VmState(code_base=base), max_steps=1, host_exit_sentinel=base)
    except ValueError:
        pass
    else:
        raise AssertionError("captured VM address was accepted as a host-exit sentinel")

    try:
        runtime.run(VmState(code_base=base), max_steps=1, host_exit_sentinel=host_exit + 2)
    except ValueError:
        pass
    else:
        raise AssertionError("unaligned host-exit sentinel was accepted")

    call_target = base + 0x88
    runtime = NativeVmpRuntime350({base: 0xC801FC91, call_target: target_word})
    state = VmState(code_base=base)
    state.set_reg(25, call_target)
    runtime.step(state)
    check("op11.32 call-register target", state.pc, call_target)
    check("op11.32 link register", state.reg(31), base + 4)
    check("op11.32 call metadata", state.call_stack, [base + 4])
    runtime.step(state)
    check("op11.32 fetched target", state.reg(7), 0xFFFFFFFFFF3C0000)

    bridge_edges = [{"from_pc": hex(base), "to_pc": hex(base + 0x40), "count": 1}]
    runtime = NativeVmpRuntime350({base: 0x2C}, make_trace_control_bridges(bridge_edges))
    state = VmState(code_base=base)
    runtime.step(state)
    check("coverage edge-list bridge ABI", state.pc, base + 0x40)

    runtime = NativeVmpRuntime350({base: 0x11})
    state = VmState(code_base=base)
    try:
        runtime.step(state)
    except UnsupportedOpcode:
        pass
    else:
        raise AssertionError("unrecovered op11 was accepted")
    check("unsupported opcode leaves PC", state.pc, base)

    runtime = NativeVmpRuntime350({base: 0x11}, {0x11: lambda _state, _insn: base + 0x44})
    state = VmState(code_base=base)
    runtime.step(state)
    check("unrecovered op11 selector bridge", state.pc, base + 0x44)
    print("native_vmp_runtime_350 selftest: ok")


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--trace", type=Path, help="GumTrace log to inventory")
    parser.add_argument("--vm-page", action="append", type=lambda value: int(value, 0), default=[])
    parser.add_argument("--keep-repeats", action="store_true")
    parser.add_argument("--coverage-out", type=Path)
    parser.add_argument(
        "--static-image", type=Path,
        help="image containing an explicitly bounded VM-code span",
    )
    parser.add_argument(
        "--static-file-offset", type=lambda value: int(value, 0),
        help="file offset of that span (do not assume VM address equals file offset)",
    )
    parser.add_argument(
        "--static-vm-code", type=lambda value: int(value, 0),
        help="VM code address corresponding to the first span byte",
    )
    parser.add_argument(
        "--static-byte-count", type=lambda value: int(value, 0),
        help="positive, 4-byte-aligned length of the static VM-code span",
    )
    parser.add_argument("--static-coverage-out", type=Path)
    parser.add_argument(
        "--validate-package-check-static-candidate-350",
        type=Path,
        metavar="SO",
        help=(
            "validate the exact 350.101 package-check static candidate in SO; "
            "does not execute VMP code"
        ),
    )
    parser.add_argument(
        "--package-check-static-candidate-out",
        type=Path,
        help="write the validated package-check static-candidate report as JSON",
    )
    parser.add_argument("--selftest", action="store_true")
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    static_values = (
        args.static_image,
        args.static_file_offset,
        args.static_vm_code,
        args.static_byte_count,
    )
    static_requested = any(value is not None for value in static_values)
    package_candidate_requested = (
        args.validate_package_check_static_candidate_350 is not None
    )
    if args.static_coverage_out is not None and not static_requested:
        raise SystemExit(
            "--static-coverage-out requires a complete static span request"
        )
    if (
        args.package_check_static_candidate_out is not None
        and not package_candidate_requested
    ):
        raise SystemExit(
            "--package-check-static-candidate-out requires "
            "--validate-package-check-static-candidate-350"
        )
    if static_requested and not all(value is not None for value in static_values):
        raise SystemExit(
            "static inventory requires --static-image, --static-file-offset, "
            "--static-vm-code, and --static-byte-count together"
        )
    if args.trace and static_requested and (
        args.coverage_out is None or args.static_coverage_out is None
    ):
        raise SystemExit(
            "when requesting trace and static inventories together, provide both "
            "--coverage-out and --static-coverage-out"
        )
    if args.trace and package_candidate_requested and (
        args.coverage_out is None or args.package_check_static_candidate_out is None
    ):
        raise SystemExit(
            "when requesting trace and package-check validation together, provide "
            "both --coverage-out and --package-check-static-candidate-out"
        )
    if static_requested and package_candidate_requested and (
        args.static_coverage_out is None
        or args.package_check_static_candidate_out is None
    ):
        raise SystemExit(
            "when requesting static inventory and package-check validation together, "
            "provide both --static-coverage-out and "
            "--package-check-static-candidate-out"
        )
    if args.selftest:
        selftest()
    if args.trace:
        report = coverage_from_trace(args.trace, args.vm_page, args.keep_repeats)
        rendered = json.dumps(report, indent=2, ensure_ascii=False) + "\n"
        if args.coverage_out:
            args.coverage_out.parent.mkdir(parents=True, exist_ok=True)
            args.coverage_out.write_text(rendered, encoding="utf-8")
        else:
            print(rendered, end="")
    if static_requested:
        static_report = coverage_from_static_file(
            args.static_image,
            file_offset=args.static_file_offset,
            vm_code=args.static_vm_code,
            byte_count=args.static_byte_count,
        )
        rendered = json.dumps(static_report, indent=2, ensure_ascii=False) + "\n"
        if args.static_coverage_out:
            args.static_coverage_out.parent.mkdir(parents=True, exist_ok=True)
            args.static_coverage_out.write_text(rendered, encoding="utf-8")
        else:
            print(rendered, end="")
    if package_candidate_requested:
        candidate_report = validate_package_check_vm_static_candidate_350(
            args.validate_package_check_static_candidate_350.read_bytes()
        )
        rendered = json.dumps(candidate_report, indent=2, ensure_ascii=False) + "\n"
        if args.package_check_static_candidate_out:
            args.package_check_static_candidate_out.parent.mkdir(
                parents=True, exist_ok=True
            )
            args.package_check_static_candidate_out.write_text(rendered, encoding="utf-8")
        else:
            print(rendered, end="")
    if (
        not args.selftest
        and not args.trace
        and not static_requested
        and not package_candidate_requested
    ):
        raise SystemExit(
            "provide --selftest, --trace, a complete static span, and/or "
            "--validate-package-check-static-candidate-350"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
