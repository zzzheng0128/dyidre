#!/usr/bin/env python3
"""Strict, executable runtime scaffold for the 350.101 managed VM.

This is deliberately separate from ``native_vmp_runtime.py``: the managed VM
uses 0x18-byte records, a 0x50-qword frame-slot bank, a second double view,
and the CF0..CF101 native-binding table.

It implements only opcode semantics already recorded by
``metasec_managed_vm_decoder.py``.  Unknown opcodes and unimplemented CF
bindings raise named exceptions; they are never silently approximated.

Examples:

  python3 managed_vm_runtime.py --program-bin ../managed_program_dumps.../350101_F3_*.bin --coverage-out coverage.json
  python3 managed_vm_runtime.py --program-bin ../managed_program_dumps.../350101_F6_*.bin --call-abi program_table
  python3 managed_vm_runtime.py --selftest
"""

from __future__ import annotations

import argparse
import base64
import binascii
import hashlib
import json
import math
import os
import secrets
import struct
import time
from collections import Counter
from dataclasses import dataclass, field
from pathlib import Path
from typing import Callable


MASK64 = (1 << 64) - 1
RECORD_SIZE = 0x18


class ManagedVmError(RuntimeError):
    """Base error for the standalone managed-VM runtime."""


class UnsupportedManagedOpcode(ManagedVmError):
    """An opcode whose native handler has not yet been recovered."""


class UnimplementedCfBinding(ManagedVmError):
    """A real CF table index without an evidence-backed host replacement."""


class UnresolvedManagedProgramCall(ManagedVmError):
    """A module-local program-table call without an explicit host bridge."""


class MemoryFault(ManagedVmError):
    """A raw address was read before the caller mapped it."""


def u64(value: int) -> int:
    return value & MASK64


def sx(value: int, bits: int) -> int:
    value &= (1 << bits) - 1
    return value - (1 << bits) if value & (1 << (bits - 1)) else value


def s32(value: int) -> int:
    return sx(value, 32)


def rol(value: int, count: int, bits: int = 64) -> int:
    mask = (1 << bits) - 1
    count %= bits
    return ((value << count) | (value >> (bits - count))) & mask


def ror(value: int, count: int, bits: int = 64) -> int:
    return rol(value, bits - (count % bits), bits)


class SparseMemory:
    """Little-endian memory with deliberate faults for unmapped raw reads."""

    def __init__(self) -> None:
        self.bytes: dict[int, int] = {}
        self._next_alloc = 0x7100_0000_0000
        self._allocations: dict[int, int] = {}

    def map(self, address: int, data: bytes) -> None:
        for index, byte in enumerate(data):
            self.bytes[u64(address + index)] = byte

    def alloc(self, size: int, alignment: int = 8) -> int:
        if size < 0:
            raise ValueError("negative allocation")
        address = (self._next_alloc + alignment - 1) & -alignment
        allocated_size = max(size, 1)
        self._next_alloc = address + allocated_size
        self._allocations[address] = allocated_size
        self.map(address, bytes(allocated_size))
        return address

    def free(self, address: int) -> None:
        """Release one exact ``alloc()`` result, matching the raw free ABI.

        Static mapped bytes do not acquire allocator ownership merely because
        they are readable.  Requiring an exact allocation base prevents a
        host replay from silently accepting the use-after-free/invalid-free
        cases that the native allocator would reject or leave undefined.
        """
        if address == 0:
            return  # C ``free(NULL)`` is defined as a no-op.
        try:
            size = self._allocations.pop(address)
        except KeyError as exc:
            raise MemoryFault(f"free of unknown/already-freed allocation 0x{address:x}") from exc
        for index in range(size):
            self.bytes.pop(u64(address + index), None)

    def read(self, address: int, width: int, signed: bool = False) -> int:
        if width not in (1, 2, 4, 8):
            raise ValueError(f"unsupported width {width}")
        raw = []
        for index in range(width):
            at = u64(address + index)
            if at not in self.bytes:
                raise MemoryFault(f"unmapped read at 0x{at:x} (width={width})")
            raw.append(self.bytes[at])
        value = int.from_bytes(bytes(raw), "little", signed=False)
        return sx(value, width * 8) if signed else value

    def write(self, address: int, width: int, value: int) -> None:
        if width not in (1, 2, 4, 8):
            raise ValueError(f"unsupported width {width}")
        self.map(address, u64(value).to_bytes(8, "little")[:width])

    def write_mapped_bytes(self, address: int, data: bytes) -> None:
        """Overwrite an already-mapped contiguous byte range atomically.

        Most VM raw stores intentionally use :meth:`write`, whose documented
        behavior is to create a mapping.  The recovered proto-wire writer has
        a different host-safety boundary: its native ABI has no capacity
        argument, so a host replay must not silently grow an arbitrary output
        region.  Preflight the whole range before touching a byte so a short
        destination cannot leave a partial serialization behind.
        """
        for offset in range(len(data)):
            at = u64(address + offset)
            if at not in self.bytes:
                raise MemoryFault(
                    f"unmapped write at 0x{at:x} (size={len(data)})"
                )
        for offset, byte in enumerate(data):
            self.bytes[u64(address + offset)] = byte

    def read_c_string(self, address: int, max_length: int = 1 << 20) -> bytes:
        """Read a NUL-terminated byte string without silently crossing gaps."""
        result = bytearray()
        for index in range(max_length):
            byte = self.read(address + index, 1)
            if byte == 0:
                return bytes(result)
            result.append(byte)
        raise MemoryFault(f"unterminated C string at 0x{address:x} (limit {max_length})")


@dataclass
class MemBlock:
    data: bytes = b""
    # The native body has an allocation/capacity word as well as a length.
    # Keep it because CF55/CF56 manipulate storage capacity without changing
    # the visible bytes.  It is deliberately a host-model field, not a raw
    # layout claim.
    capacity: int = 8

    def __post_init__(self) -> None:
        self.data = bytes(self.data)
        self.capacity = max(self.capacity, len(self.data) + 1)


@dataclass
class Ref:
    value: object | None = None


@dataclass(frozen=True)
class HostSdkIdentity350:
    """Explicit identity inputs shared by the narrow CF22--CF24 adapters.

    CF22 asks the Java bridge for the app version on every invocation, whereas
    CF23 and CF24 construct once-cached native values from the SDK's three
    static text components.  Keep those sources injectable: the 350.101
    sample observed ``35.1.0`` / ``v04.09.05`` / ``ml`` / ``android``, but a
    host replay must not silently substitute that sample's identity.
    """

    app_version: str | None
    sdk_semver: str
    sdk_flavor: str
    sdk_platform: str


@dataclass(frozen=True)
class HostNativeVmpMaterial350:
    """Ordered key/value surface emitted by native VMP ``0x1F7860``.

    CF35 does not derive this table from its selector: it first passes its
    opaque slot5 context to the native VMP, then scans the resulting material
    object.  A replay therefore supplies the resulting table through an
    explicit provider instead of silently hard-coding device material or
    pretending this managed-VM runtime executes the native VMP.

    ``None`` represents an observed null item slot, which the native scan
    skips.  Non-null entries preserve native table order, so a duplicate key
    has the same first-match behavior.  Keys and values originate as native C
    strings, hence they must be NUL-free; CF35's selector itself remains a
    full raw ``MEM_BLOCK`` byte/length comparison and may contain any bytes.
    """

    entries: tuple[tuple[bytes, bytes] | None, ...]

    def __post_init__(self) -> None:
        if not isinstance(self.entries, tuple):
            raise TypeError("HostNativeVmpMaterial350.entries must be a tuple")
        for index, entry in enumerate(self.entries):
            if entry is None:
                continue
            if (
                not isinstance(entry, tuple)
                or len(entry) != 2
                or not isinstance(entry[0], bytes)
                or not isinstance(entry[1], bytes)
            ):
                raise TypeError(
                    f"HostNativeVmpMaterial350 entry #{index} must be (bytes, bytes) or None"
                )
            if b"\0" in entry[0] or b"\0" in entry[1]:
                raise ValueError(
                    f"HostNativeVmpMaterial350 entry #{index} is not native C-string data"
                )


@dataclass
class RefFieldContext350:
    """Host model for the proven shared-reference fields of a CF context.

    It deliberately models only fields reached by the recovered CF wrappers;
    the integer key is the native byte offset.  It is not a claim that the
    native context has no other members or that this is its complete layout.
    """

    refs: dict[int, Ref] = field(default_factory=dict)
    # CF13 tests ``*(ctx + 0x08) + 0x0c > 0`` before choosing a REF member.
    # The surrounding nested type is still unrecovered, so retain just the
    # observable signed predicate rather than inventing that object layout.
    cf13_selector_count: int = 0

    def ref_at(self, offset: int) -> Ref:
        try:
            return self.refs[offset]
        except KeyError as exc:
            raise ManagedVmError(
                f"RefFieldContext350 has no recovered REF at +0x{offset:x}"
            ) from exc


@dataclass
class MemBlockTriplet350:
    """Three adjacent MEM_BLOCK members at +0x20/+0x38/+0x50.

    CF50 constructs them in ascending-offset order; CF52 destroys the same
    members in descending-offset order.  This remains a narrow host model,
    not a claim about the rest of either native aggregate.
    """

    at_20: MemBlock = field(default_factory=MemBlock)
    at_38: MemBlock = field(default_factory=MemBlock)
    at_50: MemBlock = field(default_factory=MemBlock)

    def members_in_native_destroy_order(self) -> tuple[MemBlock, MemBlock, MemBlock]:
        return (self.at_50, self.at_38, self.at_20)

    def members_in_native_init_order(self) -> tuple[MemBlock, MemBlock, MemBlock]:
        return (self.at_20, self.at_38, self.at_50)


@dataclass
class HostTreeMaps350:
    """Narrow model of the two read-locked tree maps used by CF74/CF84.

    The native aggregate owns a tree at ``+0x30`` whose values are
    ``MEM_BLOCK`` instances and another at ``+0x58`` whose values are raw
    pointers; both are protected by the same rwlock at ``+0x88``.  The
    comparator/key representation is not recovered, so keys remain the exact
    managed slot integers passed to ``queryTreeItem`` rather than being
    guessed as strings or decoded native structures.
    """

    memblocks_at_30: dict[int, MemBlock] = field(default_factory=dict)
    pointers_at_58: dict[int, int] = field(default_factory=dict)


@dataclass
class HostMutex:
    """Single-threaded stand-in for the raw ``pthread_mutex_t`` used by CF95.

    It intentionally does not pretend to model blocking or ownership.  A
    replay needing contention supplies ``mutex_lock_provider`` instead.
    """

    locked: bool = False


@dataclass
class HostLockGuard350:
    """Minimal host analogue of the conditional-unlock object used by CF92.

    Native ``0x44A98`` reads a dword at ``+0x10`` and unlocks the mutex held
    through the ``+0x08`` member only when that dword is zero.  The vtable
    overwrite done by native code is represented by the terminal ``released``
    marker; it has no managed-bytecode-visible address in the host model.
    """

    mutex: HostMutex
    state_at_10: int = 0
    released: bool = False


@dataclass
class HostOutPointer350:
    """Host cell for a native ``void **`` output parameter."""

    value: int = 0


@dataclass
class HostCjsonObject350:
    """Ordered host representation of the recovered cJSON object surface.

    Native cJSON objects retain insertion order and permit duplicate member
    names.  A Python ``dict`` would lose that distinction, so CF79/CF85/CF87
    use this ordered list when exact cJSON-style replay is required.  This is
    purposefully a semantic model, not a byte-for-byte cJSON layout claim.
    """

    members: list[tuple[str, object]] = field(default_factory=list)

    def add(self, key: str, value: object) -> None:
        self.members.append((key, value))


@dataclass
class HostCjsonObjectField350:
    """Host analogue of the one proven cJSON pointer field at native ``+8``.

    CF85 and CF87 do not receive a cJSON object directly: their wrappers load
    ``*(void **)(slot4 + 8)`` before adding an item.  Keeping that indirection
    explicit prevents a caller from confusing these helpers with CF79, whose
    recovered native wrapper receives the cJSON object itself.
    """

    cjson: HostCjsonObject350 | None = None


@dataclass(frozen=True)
class HostIdItem350:
    """One ordered semantic node behind native ``ID_ITEM``.

    CF78's native parser retains member order and duplicate keys, so a host
    node uses an ordered tuple rather than a dictionary.  ``type_code`` is
    the recovered native discriminant (false=1, true=2, null=4, number=8,
    string=0x10, array=0x20, object=0x40); ``value`` remains provider-owned
    raw bytes/numeric data because the native number/string grammar has not
    been generalized here.
    """

    type_code: int
    value: bytes | int | float | None = None
    key: bytes | None = None
    children: tuple[HostIdItem350, ...] = ()

    def __post_init__(self) -> None:
        if self.type_code not in (1, 2, 4, 8, 0x10, 0x20, 0x40):
            raise ValueError(f"unsupported recovered ID_ITEM type {self.type_code!r}")
        if self.key is not None and not isinstance(self.key, bytes):
            raise TypeError("HostIdItem350.key must be bytes or None")
        if not isinstance(self.value, (bytes, int, float, type(None))):
            raise TypeError("HostIdItem350.value must be raw bytes, numeric, or None")
        if not isinstance(self.children, tuple) or not all(
            isinstance(child, HostIdItem350) for child in self.children
        ):
            raise TypeError("HostIdItem350.children must be a tuple of HostIdItem350")


@dataclass(frozen=True)
class HostIdItemWrap350:
    """Host analogue of the native ``ID_ITEM_WRAP`` object's ``+0x08`` root."""

    root: HostIdItem350


@dataclass
class HostRefIdItemWrap350:
    """Observable payload of CF78's hidden ``REF_ID_ITEM_WRAP`` destination.

    The native representation also owns a reference-count pointer.  This
    narrow model preserves only its bytecode-visible wrapper replacement.
    """

    wrap: HostIdItemWrap350 | None = None


@dataclass(frozen=True)
class ProtoWireField350:
    """One field type proven in a descriptor-backed proto-wire schema.

    ``kind`` names the native serializer case, not an asserted public
    ``.proto`` declaration. The narrow F5/F8 models deliberately list only
    observed root descriptor types.
    """

    number: int
    kind: str
    nested_schema_offset: int | None = None


@dataclass(frozen=True)
class ProtoWireSchema350:
    """A schema checkpoint usable by a strict host proto-wire replay."""

    schema_offset: int
    native_size: int
    fields: tuple[ProtoWireField350, ...]

    def field(self, number: int) -> ProtoWireField350:
        for descriptor in self.fields:
            if descriptor.number == number:
                return descriptor
        raise ManagedVmError(
            f"schema +0x{self.schema_offset:x} has no recovered field #{number}"
        )


@dataclass(frozen=True)
class OpaqueProtoWireMessage350:
    """Captured wire body for a known nested schema whose fields are unclosed.

    It carries an explicit schema anchor so callers cannot accidentally pass a
    byte string for a different nested field.  This is a replay boundary, not
    a parser or a claim that arbitrary nested protobuf payloads are modeled.
    """

    schema_offset: int
    wire: bytes

    def __post_init__(self) -> None:
        if not isinstance(self.wire, bytes):
            raise TypeError("OpaqueProtoWireMessage350.wire must be bytes")


@dataclass
class HostProtoWireMessage350:
    """Strict host representation of one descriptor-backed proto-wire object.

    ``members`` are explicit emitted values rather than a guessed native
    object layout. Serialization follows the recovered descriptor-table order;
    a missing field means "omit it". Repeated root-field behavior has not been
    observed in this schema checkpoint, so duplicate numbers are rejected.
    Current registration accepts only the observed F5/F8 root schemas at
    ``+0x271AD8`` and ``+0x272080``.
    """

    schema_offset: int
    members: list[tuple[int, object]] = field(default_factory=list)

    def add(self, number: int, value: object) -> None:
        self.members.append((number, value))


# F5/CF31-33 checkpoint from the local, descriptor-backed message at
# libmetasec_ml.so+0x271AD8. The root object is 0xe0 bytes and its descriptor
# table contains 22 entries. The field-type table matches the corresponding
# F8 root prefix, but its field-15 nested target is distinct. Nested field
# contents are not yet recovered, so only an explicitly anchored captured body
# is admitted.
_F5_PROTO_WIRE_SCHEMA_350 = ProtoWireSchema350(
    schema_offset=0x271AD8,
    native_size=0xE0,
    fields=(
        ProtoWireField350(1, "sint32"),
        ProtoWireField350(2, "sint32"),
        ProtoWireField350(3, "sint32"),
        ProtoWireField350(4, "string"),
        ProtoWireField350(5, "string"),
        ProtoWireField350(6, "string"),
        ProtoWireField350(7, "string"),
        ProtoWireField350(8, "string"),
        ProtoWireField350(9, "sint32"),
        ProtoWireField350(10, "bytes"),
        ProtoWireField350(11, "enum"),
        ProtoWireField350(12, "sint64"),
        ProtoWireField350(13, "bytes"),
        ProtoWireField350(14, "bytes"),
        ProtoWireField350(15, "message", 0x271980),
        ProtoWireField350(16, "string"),
        ProtoWireField350(17, "sint32"),
        ProtoWireField350(18, "bytes"),
        ProtoWireField350(19, "bytes"),
        ProtoWireField350(20, "string"),
        ProtoWireField350(21, "sint32"),
        ProtoWireField350(22, "sint32"),
    ),
)

# F8/CF90-91 checkpoint from the local, descriptor-backed message at
# libmetasec_ml.so+0x272080. The root object is 0xf8 bytes and its descriptor
# table contains these 24 entries. Nested schema field contents are not yet
# recovered, so only explicitly anchored OpaqueProtoWireMessage350 bodies are
# admitted for fields 15 and 23.
_F8_PROTO_WIRE_SCHEMA_350 = ProtoWireSchema350(
    schema_offset=0x272080,
    native_size=0xF8,
    fields=(
        ProtoWireField350(1, "bytes"),
        ProtoWireField350(2, "sint32"),
        ProtoWireField350(3, "sint32"),
        ProtoWireField350(4, "string"),
        ProtoWireField350(5, "string"),
        ProtoWireField350(6, "string"),
        ProtoWireField350(7, "string"),
        ProtoWireField350(8, "string"),
        ProtoWireField350(9, "sint32"),
        ProtoWireField350(10, "bytes"),
        ProtoWireField350(11, "enum"),
        ProtoWireField350(12, "sint64"),
        ProtoWireField350(13, "bytes"),
        ProtoWireField350(14, "bytes"),
        ProtoWireField350(15, "message", 0x271DD8),
        ProtoWireField350(16, "string"),
        ProtoWireField350(17, "sint32"),
        ProtoWireField350(18, "bytes"),
        ProtoWireField350(19, "bytes"),
        ProtoWireField350(20, "string"),
        ProtoWireField350(21, "sint32"),
        ProtoWireField350(22, "sint32"),
        ProtoWireField350(23, "message", 0x271F10),
        ProtoWireField350(24, "string"),
    ),
)
_PROTO_WIRE_SCHEMAS_350: dict[int, ProtoWireSchema350] = {
    _F5_PROTO_WIRE_SCHEMA_350.schema_offset: _F5_PROTO_WIRE_SCHEMA_350,
    _F8_PROTO_WIRE_SCHEMA_350.schema_offset: _F8_PROTO_WIRE_SCHEMA_350,
}


def _proto_wire_varint_350(value: int, what: str) -> bytes:
    if isinstance(value, bool) or not isinstance(value, int) or not 0 <= value <= MASK64:
        raise ManagedVmError(f"{what} is not an unsigned 64-bit varint")
    output = bytearray()
    while value >= 0x80:
        output.append((value & 0x7F) | 0x80)
        value >>= 7
    output.append(value)
    return bytes(output)


def _proto_wire_zigzag_350(value: object, bits: int, what: str) -> int:
    if isinstance(value, bool) or not isinstance(value, int):
        raise ManagedVmError(f"{what} must be an integer")
    lower = -(1 << (bits - 1))
    upper = (1 << (bits - 1)) - 1
    if not lower <= value <= upper:
        raise ManagedVmError(f"{what} is outside signed {bits}-bit range")
    return ((value << 1) ^ (value >> (bits - 1))) & ((1 << bits) - 1)


def _encode_proto_wire_member_350(descriptor: ProtoWireField350, value: object) -> bytes:
    """Encode one explicitly present F8 root field with strict type gates."""
    if descriptor.kind == "bytes":
        if not isinstance(value, bytes):
            raise ManagedVmError(f"field #{descriptor.number} requires bytes")
        if not value:
            raise ManagedVmError(
                f"field #{descriptor.number} is default-empty; omit it instead"
            )
        body = value
        wire_type = 2
    elif descriptor.kind == "string":
        if not isinstance(value, str):
            raise ManagedVmError(f"field #{descriptor.number} requires str")
        try:
            body = value.encode("utf-8", "strict")
        except UnicodeEncodeError as exc:
            raise ManagedVmError(
                f"field #{descriptor.number} is not strict UTF-8 text"
            ) from exc
        if not body:
            raise ManagedVmError(
                f"field #{descriptor.number} is default-empty; omit it instead"
            )
        wire_type = 2
    elif descriptor.kind == "sint32":
        encoded = _proto_wire_zigzag_350(value, 32, f"field #{descriptor.number}")
        if encoded == 0:
            raise ManagedVmError(
                f"field #{descriptor.number} is default-zero; omit it instead"
            )
        body = _proto_wire_varint_350(encoded, f"field #{descriptor.number}")
        wire_type = 0
    elif descriptor.kind == "sint64":
        encoded = _proto_wire_zigzag_350(value, 64, f"field #{descriptor.number}")
        if encoded == 0:
            raise ManagedVmError(
                f"field #{descriptor.number} is default-zero; omit it instead"
            )
        body = _proto_wire_varint_350(encoded, f"field #{descriptor.number}")
        wire_type = 0
    elif descriptor.kind == "enum":
        if isinstance(value, bool) or not isinstance(value, int) or not 0 < value <= 0xFFFF_FFFF:
            raise ManagedVmError(
                f"field #{descriptor.number} requires a non-default unsigned 32-bit enum"
            )
        body = _proto_wire_varint_350(value, f"field #{descriptor.number}")
        wire_type = 0
    elif descriptor.kind == "message":
        if not isinstance(value, OpaqueProtoWireMessage350):
            raise ManagedVmError(
                f"field #{descriptor.number} requires an anchored opaque nested wire body"
            )
        if value.schema_offset != descriptor.nested_schema_offset:
            raise ManagedVmError(
                f"field #{descriptor.number} expects nested schema +0x{descriptor.nested_schema_offset:x}"
            )
        if not value.wire:
            raise ManagedVmError(
                f"field #{descriptor.number} is default-empty; omit it instead"
            )
        body = value.wire
        wire_type = 2
    else:
        raise ManagedVmError(
            f"field #{descriptor.number} has unsupported recovered kind {descriptor.kind!r}"
        )
    tag = _proto_wire_varint_350(
        (descriptor.number << 3) | wire_type, f"field #{descriptor.number} tag"
    )
    if wire_type == 2:
        return tag + _proto_wire_varint_350(len(body), f"field #{descriptor.number} length") + body
    return tag + body


def serialize_proto_wire_message_350(message: HostProtoWireMessage350) -> bytes:
    """Serialize one observed F5/F8 host schema, or fail explicitly.

    This is intentionally not a general protobuf implementation: unsupported
    schemas, field kinds, default-presence cases, raw trailing records, and
    nested object layouts remain errors until separate evidence closes them.
    """
    if not isinstance(message, HostProtoWireMessage350):
        raise ManagedVmError("proto-wire slot4 is not HostProtoWireMessage350")
    try:
        schema = _PROTO_WIRE_SCHEMAS_350[message.schema_offset]
    except KeyError as exc:
        raise ManagedVmError(
            f"no host proto-wire schema for +0x{message.schema_offset:x}"
        ) from exc
    values_by_number: dict[int, object] = {}
    for member in message.members:
        if not isinstance(member, tuple) or len(member) != 2:
            raise ManagedVmError("proto-wire members must be (field_number, value) tuples")
        number, value = member
        if isinstance(number, bool) or not isinstance(number, int):
            raise ManagedVmError("proto-wire field number must be an integer")
        schema.field(number)  # Reject unsupported fields before emitting any byte.
        if number in values_by_number:
            raise ManagedVmError(
                f"schema +0x{schema.schema_offset:x} has no observed repeated field #{number}"
            )
        values_by_number[number] = value
    output = bytearray()
    for descriptor in schema.fields:
        if descriptor.number in values_by_number:
            output.extend(
                _encode_proto_wire_member_350(descriptor, values_by_number[descriptor.number])
            )
    return bytes(output)


class HostHeap:
    """Stable synthetic pointers for MEM_BLOCK, REF, mutexes, strings and maps."""

    def __init__(self) -> None:
        self._next = 0x7200_0000_0000
        self.objects: dict[int, object] = {}

    def put(self, value: object) -> int:
        address = self._next
        self._next += 0x20
        self.objects[address] = value
        return address

    def get(self, address: int, expected: type | tuple[type, ...] | None = None) -> object:
        try:
            value = self.objects[address]
        except KeyError as exc:
            raise ManagedVmError(f"no host object at 0x{address:x}") from exc
        if expected is not None and not isinstance(value, expected):
            raise ManagedVmError(f"host object at 0x{address:x} is {type(value).__name__}, expected {expected}")
        return value

    def text(self, address: int) -> str:
        value = self.get(address)
        if isinstance(value, str):
            return value
        if isinstance(value, MemBlock):
            return value.data.decode("utf-8", "replace")
        raise ManagedVmError(f"object at 0x{address:x} is not text")


@dataclass(frozen=True)
class Record:
    index: int
    raw: bytes

    @property
    def op(self) -> int:
        return self.raw[0]

    @property
    def a(self) -> int:
        return self.raw[8]

    @property
    def b(self) -> int:
        return self.raw[9]

    @property
    def c(self) -> int:
        return self.raw[10]

    @property
    def d(self) -> int:
        return self.raw[11]

    @property
    def i16(self) -> int:
        return struct.unpack_from("<h", self.raw, 0x0a)[0]

    @property
    def u16(self) -> int:
        return struct.unpack_from("<H", self.raw, 0x0a)[0]

    @property
    def i32(self) -> int:
        return struct.unpack_from("<i", self.raw, 8)[0]

    @property
    def u32(self) -> int:
        return struct.unpack_from("<I", self.raw, 8)[0]

    @property
    def q1(self) -> int:
        return struct.unpack_from("<Q", self.raw, 0x10)[0]


@dataclass
class Program:
    name: str
    records: list[Record]
    # `0x5c` uses a VM-PC token held in a slot, not an inline record-relative
    # displacement.  A caller that runs a program containing it supplies the
    # observed token -> decoded-record relation here.  Keeping it explicit is
    # safer than treating the token as a byte offset or fabricating a target.
    indirect_pc: dict[int, int] = field(default_factory=dict)
    # The shared native opcode ``0x5e`` is module-table dependent.  The main
    # sign module's table contains CF callbacks, but the second and child
    # modules dispatch the same immediate through a managed-program table.
    # Keep the distinction on the dumped Program rather than assuming a
    # numeric index means the global CF0..CF101 namespace everywhere.
    call_abi: str = "cf_table"

    def __post_init__(self) -> None:
        if self.call_abi not in {"cf_table", "program_table"}:
            raise ValueError(
                f"{self.name}: call_abi must be 'cf_table' or 'program_table', "
                f"not {self.call_abi!r}"
            )

    def resolve_indirect_pc(self, token: int) -> int:
        try:
            return self.indirect_pc[u64(token)]
        except KeyError as exc:
            raise ManagedVmError(
                f"{self.name}: indirect VM-PC token 0x{u64(token):x} has no record mapping"
            ) from exc

    @classmethod
    def from_file(cls, path: Path, *, call_abi: str = "cf_table") -> "Program":
        raw = path.read_bytes()
        if len(raw) % RECORD_SIZE:
            raise ValueError(f"{path}: bytecode length 0x{len(raw):x} is not 0x18-aligned")
        return cls(
            path.stem,
            [Record(i, raw[i * RECORD_SIZE:(i + 1) * RECORD_SIZE])
             for i in range(len(raw) // RECORD_SIZE)],
            call_abi=call_abi,
        )


@dataclass
class Frame350:
    """Observed managed frame views: qword slots and CF79 double slots."""

    slots: list[int] = field(default_factory=lambda: [0] * 0x50)
    doubles: list[float] = field(default_factory=lambda: [0.0] * 8)
    value_stack_top: int = 0
    status: int = 0
    return_value: int = 0

    def __post_init__(self) -> None:
        if len(self.slots) != 0x50:
            raise ValueError("ManagedFrame350 has exactly 0x50 qword slots")
        if len(self.doubles) != 8:
            raise ValueError("the inline double view has slots 0..7")
        self.slots = [u64(value) for value in self.slots]

    def get(self, index: int) -> int:
        return self.slots[index]

    def set(self, index: int, value: int) -> None:
        self.slots[index] = u64(value)


CfHandler = Callable[[Frame350], None]
OpaqueCfHandler = Callable[[int, Frame350], None]
# A child module's ``0x5e`` record calls a module-local program-table index on
# the same managed frame.  The callback is intentionally explicit: a dumped
# body does not include every target program or its import table, so there is
# no safe generic fallback that could substitute the primary CF registry.
ManagedProgramCallHandler350 = Callable[[int, Frame350], None]
# CF03's otherwise deterministic transform incorporates the address of its
# native temporary MEM_BLOCK body.  A matching replay therefore supplies that
# already-captured address as a value; the host never dereferences it.
Cf03TemporaryBodyAddressProvider = Callable[[bytes, int], int]
# CF02's flattened algorithm remains native-only, but F1 establishes this
# complete raw-buffer ABI.  The provider receives pre-read byte strings and
# must return exactly ``source_length_u32`` bytes for an atomic writeback.
Cf02TransformProvider = Callable[[bytes, bytes, int, bytes, int], bytes]


class OpaqueCfBackend350:
    """Explicit adapter for CFs whose 350.101 semantics are still opaque.

    This is intentionally a *dispatcher*, never a default-value provider.
    Install one handler per needed CF (typically backed by a captured trace or
    a separately recovered host implementation).  Missing entries keep the
    same hard failure as a no-backend registry, preventing an incomplete
    replay from quietly becoming a different signing algorithm.
    """

    def __init__(self, handlers: dict[int, CfHandler]) -> None:
        self.handlers = dict(handlers)

    def __call__(self, index: int, frame: Frame350) -> None:
        try:
            handler = self.handlers[index]
        except KeyError as exc:
            raise UnimplementedCfBinding(
                f"CF{index:02d} has no handler in OpaqueCfBackend350"
            ) from exc
        handler(frame)


@dataclass(frozen=True)
class CfBinding:
    index: int
    entry: int | None
    name: str
    implemented: bool


# The table is complete even where semantics are not.  Entries outside this
# map remain named ``unrecovered`` and throw on use; an ABI-only name below is
# still not a host implementation.
_CF_NAMES: dict[int, str] = {
    0: "fill_memblock_len5_byte6", 1: "flattened_transform_raw_provider", 2: "flattened_transform_raw_provider", 3: "rc4_residue_transpose_memblock_ref", 4: "alloc_raw", 7: "memcpy", 8: "release_ref",
    5: "init_memblock8", 6: "set_ref_addref",
    10: "copy_memblock_data", 11: "free_memblock", 12: "init_memblock_from_cstr",
    13: "copy_context_ref_cf13", 14: "is_empty_memblock", 15: "clone_ref", 16: "rand_u31",
    17: "copy_context_ref_38", 18: "copy_context_ref_70",
    19: "copy_context_ref_d8", 20: "copy_context_ref_18", 21: "release_ref_locked",
    22: "app_version_ref", 23: "sdk_version_word", 24: "sdk_identity_cstr", 25: "get_env_object",
    26: "registry_lookup", 27: "xor8_inplace_key_f8",
    29: "md5_memblock_to_ref",
    30: "concat_memblocks", 31: "proto_wire_f5_size", 32: "fill_memblock_from_byte",
    33: "proto_wire_f5_write",
    34: "base64_decode", 35: "native_vmp_material_select_ref", 36: "xor8_inplace_key_d8", 37: "copy_memblock", 38: "init_memblock_by_src",
    40: "shared_ref_assign_ret", 41: "argus_simon128_256",
    42: "pack_u16_le", 43: "argus_aes_cbc_pkcs7", 44: "base64_encode",
    45: "xor8_inplace_key_e0", 46: "xor8_inplace_key_e8", 47: "xor8_inplace_key_f0",
    48: "short_header_transform32", 49: "build_short_header_pack36",
    9: "init_memblock_from_cstr_ret", 28: "empty_string_cmp_lsb", 39: "http_client_json_list_ptr",
    50: "init_memblock_triplet", 51: "native_global_singleton_ptr",
    52: "destroy_memblock_triplet",
    53: "shared_ref_assign_ret",
    54: "substring_memblock", 55: "reserve_memblock",
    56: "append_memblock_byte_ret",
    57: "strtoull", 58: "rc4_memblock_to_ref", 59: "crc8_poly31_init0", 61: "sm3", 77: "crc32_ieee", 79: "cjson_add_number", 85: "cjson_add_string_field", 86: "urlsafe_base64_decode_check", 87: "cjson_add_bool_field", 88: "cjson_print_unformatted_to_ref",
    60: "alloc_prepare_raw",
    62: "clone_ref_no_return",
    63: "second_module_f22_memblock_hash_u32",
    # This child-module adapter has a verified frame layout but unknown
    # pointer/object effects, so no handler is registered.
    64: "child_module_f1_slots19_0_10_27_unrecovered",
    65: "context_flag_e8", 66: "realtime_seconds", 68: "getpid", 70: "getppid",
    67: "copy_context_ref_b0", 69: "copy_context_ref_28", 71: "thread_pointer",
    72: "native_global_u32_acquire", 73: "locked_context_qword_40", 74: "tree_pointer_lookup",
    75: "child_module_f6_frame_adapter_unrecovered",
    76: "cached_uuid4_ref", 80: "native_global_u32_a",
    81: "native_global_u32_b", 82: "native_vmp_u32_global_2c1040", 83: "native_global_u32_c",
    84: "tree_memblock_lookup",
    78: "parse_json_to_id_item_ref",
    89: "realtime_millis", 90: "proto_wire_f8_size", 91: "proto_wire_f8_write",
    92: "release_lock_guard", 93: "release_ref_no_return",
    94: "get_thread_local_object", 95: "pthread_mutex_lock",
    96: "locked_shared_ref_assign",
    97: "free_slot4", 98: "format_alloc_string", 99: "format_default_string",
    100: "format_string_to_memblock", 101: "asprintf_one_arg",
}

# The five static string/byte deobfuscators are direct byte-wise XOR loops.
# Each native helper receives ``uint8_t *buf`` and ``int32_t len``; it does not
# inspect a terminator or a MEM_BLOCK header.  The key addresses are module
# relative and retain the native table ordering as an audit anchor.
_CF_XOR8_KEYS: dict[int, bytes] = {
    27: bytes.fromhex("35 1f 7f f7 90 9f e1 b1"),  # key @ 0x2025F8
    36: bytes.fromhex("a5 10 71 c7 50 90 e1 b1"),  # key @ 0x2025D8
    45: bytes.fromhex("a5 12 81 d7 60 10 71 b2"),  # key @ 0x2025E0
    46: bytes.fromhex("b5 20 91 e7 40 a0 e3 b6"),  # key @ 0x2025E8
    47: bytes.fromhex("a7 50 78 c9 60 97 ef f1"),  # key @ 0x2025F0
}

# Static registration table from initManagedSignModuleLarge_350 (0x1702b8),
# recorded in managed_sign_cf_table_350101.md.  Address availability does not
# imply host implementation; CfBinding.implemented remains the authority.
_CF_ENTRIES: tuple[int, ...] = (
    0x16ea70, 0x16eac0, 0x16eb40, 0x16ebc0, 0x16ec10, 0x16ec3c, 0x16ec54, 0x16ec90, 0x16ecf0, 0x16ed08,
    0x16ed54, 0x16eda0, 0x16edb8, 0x16edf4, 0x16ee2c, 0x16ee58, 0x16ee94, 0x16eeb8, 0x16eef0, 0x16ef28,
    0x16ef60, 0x16ef98, 0x16efb0, 0x16efcc, 0x16eff0, 0x16f014, 0x16f038, 0x16f084, 0x16f0d0, 0x16f0fc,
    0x16f14c, 0x16f19c, 0x16f1c8, 0x16f218, 0x16f264, 0x16f29c, 0x16f2ec, 0x16f338, 0x16f374, 0x16f3c4,
    0x16f3f0, 0x16f43c, 0x16f48c, 0x16f4c4, 0x16f544, 0x16f57c, 0x16f5c8, 0x16f614, 0x16f660, 0x16f6b0,
    0x16f6fc, 0x16f714, 0x16f738, 0x16f750, 0x16f79c, 0x16f808, 0x16f844, 0x16f890, 0x16f8f0, 0x16f940,
    0x16f96c, 0x16f998, 0x16f9f8, 0x16fa34, 0x16fa60, 0x16facc, 0x16faf8, 0x16fb1c, 0x16fb54, 0x16fb78,
    0x16fbb0, 0x16fbd4, 0x16fbf8, 0x16fc1c, 0x16fc48, 0x16fc94, 0x16fce4, 0x16fd00, 0x16fd2c, 0x16fd64,
    0x16fdc0, 0x16fde4, 0x16fe08, 0x16fe2c, 0x16fe50, 0x16fea0, 0x16ff00, 0x16ff2c, 0x16ff8c, 0x16ffc4,
    0x16ffe8, 0x170014, 0x170060, 0x170078, 0x170090, 0x1700a8, 0x1700d4, 0x170110, 0x170128, 0x170188,
    0x1701d8, 0x170258,
)
assert len(_CF_ENTRIES) == 102


class CfRegistry350:
    """Full CF0..CF101 registry with executable high-confidence primitives."""

    def __init__(
        self,
        memory: SparseMemory,
        heap: HostHeap,
        environment: dict[str, object] | None = None,
        random_u31_provider: Callable[[], int] | None = None,
        process_id_provider: Callable[[], int] | None = None,
        parent_process_id_provider: Callable[[], int] | None = None,
        thread_pointer_provider: Callable[[], int] | None = None,
        current_time_millis_provider: Callable[[], int] | None = None,
        native_globals_u32: dict[int, int] | None = None,
        native_globals_ptr: dict[int, int] | None = None,
        thread_local_ptr_provider: Callable[[], int] | None = None,
        mutex_lock_provider: Callable[[int], int] | None = None,
        cf76_random_bytes_provider: Callable[[], bytes] | None = None,
        sdk_identity_provider: Callable[[], HostSdkIdentity350] | None = None,
        cf35_material_provider: Callable[[object], HostNativeVmpMaterial350] | None = None,
        cf03_temp_body_address_provider: Cf03TemporaryBodyAddressProvider | None = None,
        cf01_transform_provider: Cf02TransformProvider | None = None,
        cf02_transform_provider: Cf02TransformProvider | None = None,
        cf78_json_parser_provider: Callable[[bytes], HostIdItem350 | None] | None = None,
        opaque_cf_handler: OpaqueCfHandler | None = None,
    ) -> None:
        self.memory = memory
        self.heap = heap
        # CF25 @ 0x16F014 calls sub_4303C directly; slot4 is not an input.
        # Keep the host replacement explicit and injectable for replay tests.
        self.environment_ptr = heap.put(environment if environment is not None else {})
        # CF16 reaches the once-seeded native ``rand()`` helper.  Device
        # seeding is intentionally not invented here: trace replay supplies a
        # deterministic provider, while ad-hoc execution obtains a fresh
        # value in the native 31-bit result range.
        self.random_u31_provider = random_u31_provider or (lambda: secrets.randbits(31))
        # CF68/CF70 call getpid/getppid.  Injection keeps an offline trace
        # replay distinct from the host process that happens to execute it.
        self.process_id_provider = process_id_provider or os.getpid
        self.parent_process_id_provider = parent_process_id_provider or os.getppid
        # CF71 returns the architecture TLS register (TPIDR_EL0), not a POSIX
        # tid. It is process/runtime-address-space specific, so replay must
        # supply the captured value instead of using Python's thread id.
        self.thread_pointer_provider = thread_pointer_provider
        # Both CF66 and CF89 ultimately use CLOCK_REALTIME.  The first divides
        # the millisecond helper by 1000; keeping one source matches the native
        # relationship and the deterministic replay knob.
        self.current_time_millis_provider = (
            current_time_millis_provider or (lambda: time.time_ns() // 1_000_000)
        )
        # CF72/CF80--CF83 return SO or native-VM state words.  A missing input
        # stays a hard error so a synthetic zero cannot look like a valid
        # matching-replay device state.
        self.native_globals_u32 = dict(native_globals_u32 or {})
        # CF51 returns a lazily constructed 0x2d0-byte SO singleton.  Its
        # internal layout is still opaque, so replay supplies its stable
        # pointer instead of having this host runtime manufacture one.
        self.native_globals_ptr = dict(native_globals_ptr or {})
        self.thread_local_ptr_provider = thread_local_ptr_provider
        self.mutex_lock_provider = mutex_lock_provider or self._lock_host_mutex
        # CF76 seeds its native xorshift state once from /dev/urandom, then
        # formats two successive xorshift words with a UUID-v4 template and
        # caches the resulting shared MEM_BLOCK.  The provider represents the
        # resulting 16 little-endian random-word bytes for deterministic
        # replay; it is deliberately not a fabricated device identifier.
        self.cf76_random_bytes_provider = cf76_random_bytes_provider or (
            lambda: secrets.token_bytes(16)
        )
        self._cf76_cached_uuid: MemBlock | None = None
        # CF22 resolves the Java value per call; CF23/CF24 each use an
        # independent C++ static guard.  Keeping a provider plus separate
        # caches reproduces that observable lifetime without hard-coding the
        # current sample's app/SDK identity.
        self.sdk_identity_provider = sdk_identity_provider
        self._cf23_cached_version_word: int | None = None
        self._cf24_cached_cstr: int | None = None
        # CF35 builds this table through native VMP ``0x1F7860`` before its
        # selector scan.  The managed runtime deliberately receives only a
        # captured/recovered table provider; it must never manufacture keys.
        self.cf35_material_provider = cf35_material_provider
        # CF03's native temporary MEM_BLOCK allocation address is mixed into
        # its key and output stride.  It is not reproducible from a Python
        # allocation, so a matching replay supplies its captured address as
        # an opaque bit value; this runtime never dereferences it.
        self.cf03_temp_body_address_provider = cf03_temp_body_address_provider
        # F1 proves CF02's five raw-buffer arguments and no slot2 result, but
        # does not close the flattened algorithm.  A provider receives only
        # exact byte ranges and supplies the resulting output bytes; absent
        # provider state remains a hard error rather than a guessed transform.
        self.cf01_transform_provider = cf01_transform_provider
        self.cf02_transform_provider = cf02_transform_provider
        # CF78 owns a custom native JSON parser.  A provider returns its
        # ordered ID_ITEM root (or None for a native parse failure); this
        # runtime does not substitute a superficially similar JSON library.
        self.cf78_json_parser_provider = cf78_json_parser_provider
        self.opaque_cf_handler = opaque_cf_handler
        self.handlers: dict[int, CfHandler] = {
            0: self.cf00_fill_memblock,
            1: self.cf01_flattened_transform_provider,
            2: self.cf02_flattened_transform_provider,
            3: self.cf03_rc4_residue_transpose_memblock_ref,
            4: self.cf04_alloc_raw,
            5: self.cf05_init_memblock8,
            6: self.cf06_set_ref_addref,
            7: self.cf07_memcpy,
            8: self.cf08_release_ref,
            9: self.cf09_init_memblock_from_cstr_ret,
            10: self.cf10_copy_memblock_data,
            11: self.cf11_free_memblock,
            12: self.cf12_copy_string_memblock,
            13: self.cf13_copy_context_ref,
            14: self.cf14_is_empty_memblock,
            15: self.cf15_clone_ref,
            16: self.cf16_rand_u31,
            17: self.cf17_copy_context_ref_38,
            18: self.cf18_copy_context_ref_70,
            19: self.cf19_copy_context_ref_d8,
            20: self.cf20_copy_context_ref_18,
            21: self.cf21_release_ref_locked,
            22: self.cf22_app_version_ref,
            23: self.cf23_sdk_version_word,
            24: self.cf24_sdk_identity_cstr,
            25: self.cf25_get_env_object,
            26: self.cf26_registry_lookup,
            27: self.cf27_xor8_in_place,
            28: self.cf28_empty_string_cmp_lsb,
            29: self.cf29_md5_memblock_to_ref,
            30: self.cf30_concat_memblocks,
            31: self.cf31_proto_wire_f5_size,
            32: self.cf32_fill_memblock_from_byte,
            33: self.cf33_proto_wire_f5_write,
            34: self.cf34_base64_decode,
            35: self.cf35_native_vmp_material_select_ref,
            36: self.cf36_xor8_in_place,
            37: self.cf37_copy_memblock,
            38: self.cf38_init_memblock_by_src,
            39: self.cf39_http_client_json_list_ptr,
            40: self.cf40_shared_ref_assign_ret,
            41: self.cf41_simon128_256_pkcs7,
            42: self.cf42_pack_u16_le,
            43: self.cf43_aes128_cbc_pkcs7,
            44: self.cf44_base64_encode,
            45: self.cf45_xor8_in_place,
            46: self.cf46_xor8_in_place,
            47: self.cf47_xor8_in_place,
            48: self.cf48_short_header_transform32,
            49: self.cf49_pack_short_header,
            50: self.cf50_init_memblock_triplet,
            51: self.cf51_native_global_singleton_ptr,
            52: self.cf52_destroy_memblock_triplet,
            53: self.cf53_shared_ref_assign_ret,
            54: self.cf54_substring_memblock,
            55: self.cf55_reserve_memblock,
            56: self.cf56_append_memblock_byte_ret,
            57: self.cf57_strtoull,
            58: self.cf58_rc4_memblock_to_ref,
            59: self.cf59_crc8_poly31_init0,
            60: self.cf60_alloc_prepare_raw,
            61: self.cf61_sm3,
            62: self.cf62_clone_ref_no_return,
            63: self.cf63_second_module_f22_memblock_hash_u32,
            65: self.cf65_context_flag_e8,
            66: self.cf66_realtime_seconds,
            67: self.cf67_copy_context_ref_b0,
            68: self.cf68_getpid,
            69: self.cf69_copy_context_ref_28,
            70: self.cf70_getppid,
            71: self.cf71_thread_pointer,
            72: self.cf72_native_global_u32_acquire,
            73: self.cf73_locked_context_qword_40,
            74: self.cf74_tree_pointer_lookup,
            76: self.cf76_cached_uuid4_ref,
            77: self.cf77_crc32_ieee,
            78: self.cf78_parse_json_to_id_item_ref,
            79: self.cf79_json_add_number,
            80: self.cf80_native_global_u32_a,
            81: self.cf81_native_global_u32_b,
            82: self.cf82_native_vmp_u32_global_2c1040,
            83: self.cf83_native_global_u32_c,
            84: self.cf84_tree_memblock_lookup,
            85: self.cf85_cjson_add_string_field,
            86: self.cf86_urlsafe_base64_decode_check,
            87: self.cf87_cjson_add_bool_field,
            88: self.cf88_cjson_print_unformatted_to_ref,
            89: self.cf89_realtime_millis,
            90: self.cf90_proto_wire_f8_size,
            91: self.cf91_proto_wire_f8_write,
            92: self.cf92_release_lock_guard,
            93: self.cf93_release_ref_no_return,
            94: self.cf94_get_thread_local_object,
            95: self.cf95_pthread_mutex_lock,
            96: self.cf96_locked_shared_ref_assign,
            97: self.cf97_free_slot4,
            98: self.cf98_format_alloc_string,
            99: self.cf99_format_default_string,
            100: self.cf100_format_memblock,
            101: self.cf101_asprintf_one_arg,
        }

    def manifest(self) -> list[CfBinding]:
        return [CfBinding(i, self._entry(i), _CF_NAMES.get(i, "unrecovered"), i in self.handlers) for i in range(102)]

    @staticmethod
    def _entry(index: int) -> int:
        return _CF_ENTRIES[index]

    def call(self, index: int, frame: Frame350) -> None:
        if not 0 <= index <= 101:
            raise UnimplementedCfBinding(f"CF index out of range: {index}")
        handler = self.handlers.get(index)
        if handler is None:
            if self.opaque_cf_handler is not None:
                self.opaque_cf_handler(index, frame)
                return
            raise UnimplementedCfBinding(f"CF{index:02d} ({_CF_NAMES.get(index, 'unrecovered')}) has no standalone replacement")
        handler(frame)

    def _block(self, pointer: int) -> MemBlock:
        return self.heap.get(pointer, MemBlock)  # type: ignore[return-value]

    def _data(self, pointer: int) -> bytes:
        value = self.heap.get(pointer)
        if isinstance(value, MemBlock):
            return value.data
        if isinstance(value, str):
            return value.encode()
        raise ManagedVmError(f"object at 0x{pointer:x} is neither MEM_BLOCK nor string")

    def _c_string_data(self, pointer: int) -> bytes:
        """Resolve a native C-string argument from host objects or raw memory."""
        if pointer == 0:
            # CF09's native helper selects the image's empty-string literal.
            return b""
        if pointer in self.heap.objects:
            return self._data(pointer)
        return self.memory.read_c_string(pointer)

    @staticmethod
    def _cjson_key(data: bytes) -> str:
        """Map a native cJSON member name to the host model's text key.

        cJSON itself takes a NUL-terminated byte string and does not validate
        UTF-8 on item insertion.  Existing signer vectors use UTF-8 keys; a
        replacement decode keeps a malformed replay inspectable without
        inventing a different key encoding.
        """
        return data.decode("utf-8", "replace")

    def _add_cjson_member(self, target: HostCjsonObject350 | dict[str, object],
                          key: bytes, value: object) -> None:
        text_key = self._cjson_key(key)
        if isinstance(target, HostCjsonObject350):
            target.add(text_key, value)
        else:
            # Compatibility surface for pre-existing CF79 callers.  A dict
            # necessarily follows Python's last-value-wins duplicate policy;
            # use HostCjsonObject350 when native duplicate-key fidelity is
            # needed.
            target[text_key] = value

    def _cjson_field_target(self, pointer: int) -> HostCjsonObject350 | None:
        field_value = self.heap.get(pointer, HostCjsonObjectField350)
        return field_value.cjson  # type: ignore[union-attr]

    def _cjson_print_unformatted(self, value: object) -> str:
        """Render the finite cJSON value subset built by recovered bindings.

        CF88 invokes the native unformatted printer.  We model its observable
        compact shape for objects, string/bool/finite-number items and nested
        recovered objects.  The generic native cJSON graph has more node types
        (arrays, raw nodes, references and custom allocators); silently
        replacing those with a Python encoding would make a replay lie, so
        they remain explicit unsupported cases.
        """
        if isinstance(value, HostCjsonObject350):
            rendered_members = []
            for key, member_value in value.members:
                rendered_members.append(
                    json.dumps(key, ensure_ascii=False, separators=(",", ":"))
                    + ":" + self._cjson_print_unformatted(member_value)
                )
            return "{" + ",".join(rendered_members) + "}"
        if isinstance(value, str):
            return json.dumps(value, ensure_ascii=False, separators=(",", ":"))
        if isinstance(value, bool):
            return "true" if value else "false"
        if isinstance(value, (int, float)) and not isinstance(value, bool):
            numeric = float(value)
            if not math.isfinite(numeric):
                raise ManagedVmError("CF88 cannot print a non-finite cJSON number")
            # cJSON's standard number path uses a compact ``%g`` style
            # representation.  The 15 significant digits here mirror its
            # primary double conversion and cover the observed integral F8
            # numeric fields exactly.
            return format(numeric, ".15g")
        raise ManagedVmError(
            f"CF88 cJSON print has no recovered model for {type(value).__name__}"
        )

    @staticmethod
    def _apply_c_width(data: bytes, width: int | None, left: bool,
                       zero: bool = False) -> bytes:
        """Apply a byte-count field width without assuming Unicode text."""
        if width is None or len(data) >= width:
            return data
        pad = (b"0" if zero else b" ") * (width - len(data))
        return data + pad if left else pad + data

    def _format_asprintf_one_arg(self, fmt: bytes, arg: int) -> bytes:
        """Defined one-vararg subset of the libc ``asprintf`` ABI used by CF101.

        CF101 passes exactly X0--X2 to ``asprintf``.  A format needing a
        second conversion (or ``*`` width/precision) would therefore already
        be undefined in the native caller; this host model stops rather than
        reading invented variadic arguments.  It operates on bytes because
        the native format/output are C strings, not Python Unicode strings.
        """
        output = bytearray()
        used_arg = False
        pos = 0
        while pos < len(fmt):
            if fmt[pos] != ord("%"):
                output.append(fmt[pos])
                pos += 1
                continue
            pos += 1
            if pos == len(fmt):
                raise ManagedVmError("CF101 unterminated C format")
            if fmt[pos] == ord("%"):
                output.append(ord("%"))
                pos += 1
                continue

            flags = set()
            while pos < len(fmt) and fmt[pos] in b"-+ #0":
                flags.add(chr(fmt[pos]))
                pos += 1
            if pos < len(fmt) and fmt[pos] == ord("*"):
                raise ManagedVmError("CF101 format has an unsupported '*' width")
            width_start = pos
            while pos < len(fmt) and ord("0") <= fmt[pos] <= ord("9"):
                pos += 1
            width = int(fmt[width_start:pos]) if pos != width_start else None
            precision: int | None = None
            if pos < len(fmt) and fmt[pos] == ord("."):
                pos += 1
                if pos < len(fmt) and fmt[pos] == ord("*"):
                    raise ManagedVmError("CF101 format has an unsupported '*' precision")
                precision_start = pos
                while pos < len(fmt) and ord("0") <= fmt[pos] <= ord("9"):
                    pos += 1
                precision = int(fmt[precision_start:pos] or b"0")

            length = ""
            if pos + 1 < len(fmt) and fmt[pos:pos + 2] in (b"hh", b"ll"):
                length = fmt[pos:pos + 2].decode("ascii")
                pos += 2
            elif pos < len(fmt) and fmt[pos] in b"hljztL":
                length = chr(fmt[pos])
                pos += 1
            if pos == len(fmt):
                raise ManagedVmError("CF101 unterminated C conversion")
            spec = chr(fmt[pos])
            pos += 1
            if used_arg:
                raise ManagedVmError("CF101 format requires more than its one native variadic argument")
            used_arg = True

            left = "-" in flags
            if spec == "s":
                if length:
                    raise ManagedVmError(f"CF101 unsupported %{length}s conversion")
                rendered = self._c_string_data(arg)
                if precision is not None:
                    rendered = rendered[:precision]
                output.extend(self._apply_c_width(rendered, width, left))
                continue
            if spec == "c":
                if length or precision is not None:
                    raise ManagedVmError(f"CF101 unsupported %{length}c conversion")
                output.extend(self._apply_c_width(bytes((arg & 0xff,)), width, left))
                continue
            if spec == "p":
                if length or precision is not None:
                    raise ManagedVmError("CF101 unsupported qualified %p conversion")
                rendered = b"0x" + format(u64(arg), "x").encode("ascii")
                output.extend(self._apply_c_width(rendered, width, left, zero="0" in flags))
                continue
            if spec not in "diuoxX":
                raise ManagedVmError(f"CF101 unsupported %{length}{spec} conversion")
            if length == "hh":
                bits = 8
            elif length == "h":
                bits = 16
            elif length in ("",):
                bits = 32
            elif length in ("l", "ll", "j", "z", "t"):
                # AArch64 Android uses 64-bit long, size_t and ptrdiff_t.
                bits = 64
            else:
                raise ManagedVmError(f"CF101 unsupported %{length}{spec} conversion")
            raw = arg & ((1 << bits) - 1)
            sign = b""
            if spec in "di":
                value = sx(raw, bits)
                if value < 0:
                    sign, value = b"-", -value
                elif "+" in flags:
                    sign = b"+"
                elif " " in flags:
                    sign = b" "
                digits = str(value).encode("ascii")
            else:
                value = raw
                base = {"u": 10, "o": 8, "x": 16, "X": 16}[spec]
                digits = (str(value) if base == 10 else format(value, "o" if base == 8 else "x")).encode("ascii")
                if spec == "X":
                    digits = digits.upper()
            if precision == 0 and value == 0:
                digits = b""
            if precision is not None:
                digits = b"0" * max(0, precision - len(digits)) + digits
            prefix = b""
            if "#" in flags and value:
                if spec == "o" and not digits.startswith(b"0"):
                    prefix = b"0"
                elif spec == "x":
                    prefix = b"0x"
                elif spec == "X":
                    prefix = b"0X"
            rendered = sign + prefix + digits
            if width is not None and len(rendered) < width and "0" in flags and not left and precision is None:
                rendered = sign + prefix + b"0" * (width - len(rendered)) + digits
            output.extend(self._apply_c_width(rendered, width, left))
        return bytes(output)

    @staticmethod
    def _rounded_memblock_capacity(requested: int) -> int:
        """Native 0x109BE8's minimum-8, power-of-two capacity policy."""
        if requested < 1:
            raise ManagedVmError(f"negative/zero MEM_BLOCK reserve request {requested}")
        requested = max(requested, 8)
        return 1 << (requested - 1).bit_length()

    @staticmethod
    def _set_block_data(block: MemBlock, data: bytes) -> None:
        block.data = bytes(data)
        block.capacity = max(block.capacity, len(block.data) + 1)

    def _lock_host_mutex(self, pointer: int) -> int:
        mutex = self.heap.get(pointer, HostMutex)
        if mutex.locked:
            raise ManagedVmError(
                "CF95 would block on an already locked HostMutex; provide "
                "mutex_lock_provider for a multi-threaded replay"
            )
        mutex.locked = True
        return 0

    def cf00_fill_memblock(self, frame: Frame350) -> None:
        """CF00: fill slot4 with ``low8(slot6)`` repeated ``signed_low32(slot5)``.

        Wrapper ``0x16EA70`` passes slot5 in W1 and slot6 in X2 to
        ``makeFilledMemBlock_len_byte_350 @ 0x10BFD8``.  The helper moves W2
        to the fill-byte argument W3, while ``sub_10AC70`` uses W1 as the
        signed output length for allocation, memset, and the stored block
        length.  The opposite slot order is a common-looking but incorrect
        interpretation of the wrapper's register moves.

        A negative native length resets the block's visible length to zero
        before the helper returns its ignored error code; preserve that
        observable state without inventing a managed exception.  Normal
        paths use the proven minimum-8/power-of-two capacity growth policy
        and do not write slot2.
        """
        destination = self._block(frame.get(4))
        length = s32(frame.get(5))
        if length < 0:
            self._set_block_data(destination, b"")
            return
        destination.capacity = max(
            destination.capacity, self._rounded_memblock_capacity(length + 1)
        )
        self._set_block_data(destination, bytes((frame.get(6) & 0xff,)) * length)

    def _cf02_raw_bytes(self, address: int, length: int) -> bytes:
        """Read one CF02 raw buffer completely before invoking its provider."""
        return bytes(self.memory.read(address + offset, 1) for offset in range(length))

    def _cf_flattened_raw_transform(
        self,
        index: int,
        provider: Cf02TransformProvider | None,
        frame: Frame350,
    ) -> None:
        """Execute one F0/F1-proven raw-buffer provider boundary."""
        if provider is None:
            raise ManagedVmError(
                f"CF{index:02d} requires cf{index:02d}_transform_provider "
                "for the unrecovered flattened transform"
            )
        output_ptr = frame.get(4)
        source_ptr = frame.get(5)
        source_length = frame.get(6) & 0xffff_ffff
        auxiliary_ptr = frame.get(7)
        auxiliary_length = frame.get(8) & 0xffff_ffff
        output_initial = self._cf02_raw_bytes(output_ptr, source_length)
        source = self._cf02_raw_bytes(source_ptr, source_length)
        auxiliary = self._cf02_raw_bytes(auxiliary_ptr, auxiliary_length)
        result = provider(
            output_initial, source, source_length, auxiliary, auxiliary_length
        )
        if not isinstance(result, bytes):
            raise ManagedVmError(
                f"cf{index:02d}_transform_provider must return bytes"
            )
        if len(result) != source_length:
            raise ManagedVmError(
                f"cf{index:02d}_transform_provider result length must equal low32(slot6)"
            )
        self.memory.write_mapped_bytes(output_ptr, result)

    def cf01_flattened_transform_provider(self, frame: Frame350) -> None:
        """CF01: provider-gated F0 raw-buffer bridge, preserving slot2.

        F0's fully decoded adapter supplies the same raw output/source/
        source-length/auxiliary/auxiliary-length ABI as CF02, but targets the
        distinct flattened body ``0x16B748``. There is no direct local CF01
        call vector, so this boundary intentionally accepts only an explicit
        provider and never reuses CF02's algorithm/provider by default.
        """
        self._cf_flattened_raw_transform(1, self.cf01_transform_provider, frame)

    def cf02_flattened_transform_provider(self, frame: Frame350) -> None:
        """CF02: provider-gated F1 raw-buffer bridge, preserving slot2.

        Wrapper ``0x16EB40`` maps managed slots 4..8 directly to
        ``X0, X1, W2, X3, X4`` for ``flattenedTransform_CF02_350 @ 0x16BEB0``.
        The fully decoded F1 adapter establishes these as raw output/source/
        source-length/auxiliary/auxiliary-length buffers, where both lengths
        are unmodified low-32-bit values. It provides no byte-level result
        vector or general flattened algorithm, so this is intentionally an
        explicit provider boundary—not a guessed transform.

        Inputs and the destination's initial bytes are read completely before
        calling the provider. Its result must be ``bytes`` of exactly the
        source length; ``write_mapped_bytes`` then preflights the entire
        output range before atomic writeback. Missing/failed/invalid provider
        paths leave both output and managed slot2 untouched.
        """
        self._cf_flattened_raw_transform(2, self.cf02_transform_provider, frame)

    def cf04_alloc_raw(self, frame: Frame350) -> None:
        frame.set(2, self.memory.alloc(frame.get(4)))

    def cf05_init_memblock8(self, frame: Frame350) -> None:
        """CF05 initializes the caller-provided 8-byte-capacity MEM_BLOCK."""
        block = self._block(frame.get(4))
        block.data, block.capacity = b"", 8

    def cf06_set_ref_addref(self, frame: Frame350) -> None:
        """CF06 assigns a ref-counted source into the destination REF."""
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]

    def cf07_memcpy(self, frame: Frame350) -> None:
        length = frame.get(6)
        data = bytes(self.memory.read(frame.get(5) + i, 1) for i in range(length))
        self.memory.map(frame.get(4), data)
        frame.set(2, frame.get(4))

    def cf08_release_ref(self, frame: Frame350) -> None:
        self.heap.get(frame.get(4), Ref).value = None  # type: ignore[union-attr]

    def cf09_init_memblock_from_cstr_ret(self, frame: Frame350) -> None:
        """CF09: construct slot4 from a C string in slot5 and return slot4.

        The ``0x16ED08 -> 0x10B7D4`` chain computes ``strlen`` on slot5 (or
        its built-in empty fallback), grows the destination as needed, copies
        the terminating NUL, and returns the destination pointer.  The host
        block stores payload bytes, while ``capacity`` retains the observable
        storage-side effect for CF55/CF56.
        """
        self._set_block_data(self._block(frame.get(4)), self._c_string_data(frame.get(5)))
        frame.set(2, frame.get(4))

    def cf10_copy_memblock_data(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), self._block(frame.get(5)).data)
        frame.set(2, frame.get(4))

    def cf11_free_memblock(self, frame: Frame350) -> None:
        block = self._block(frame.get(4))
        block.data, block.capacity = b"", 0

    def cf12_copy_string_memblock(self, frame: Frame350) -> None:
        """CF12 constructs slot4 from the NUL-terminated source in slot5.

        ``0x16EDB8`` calls ``0x10B5F0`` with ``(slot4, slot5)`` and returns
        directly.  In particular, unlike CF10, its wrapper never performs a
        ``managedFrameSetSlot(frame, 2, ...)``.  Preserve slot2 so subsequent
        bytecode cannot accidentally consume a fabricated return pointer.
        """
        self._set_block_data(self._block(frame.get(4)), self._c_string_data(frame.get(5)))

    def cf14_is_empty_memblock(self, frame: Frame350) -> None:
        frame.set(2, int(not self._block(frame.get(4)).data))

    def cf15_clone_ref(self, frame: Frame350) -> None:
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]

    def cf16_rand_u31(self, frame: Frame350) -> None:
        """CF16: write the native ``rand()``-range result to return slot2.

        Wrapper ``0x16EE94`` invokes ``0x12E0C8`` with no frame arguments,
        then passes W0 to ``managedFrameSetSlot_350(frame, 2, value)``.  The
        helper performs a guarded one-time seed and calls ``rand()``; its seed
        material is process-local, so callers wanting an exact trace must
        inject the corresponding result provider.
        """
        frame.set(2, self.random_u31_provider() & 0x7fff_ffff)

    def _copy_context_ref(self, frame: Frame350, offset: int) -> None:
        """Assign context ``+offset`` REF to the hidden slot4 destination.

        CF17--CF19 acquire the context read lock before this operation; CF20
        is a direct tail call.  The observed result for all four wrappers is
        the same shared-reference assignment and none writes return slot2.
        Lock scheduling remains outside this single-threaded host model.
        """
        destination = self.heap.get(frame.get(4), Ref)
        context = self.heap.get(frame.get(5), RefFieldContext350)
        destination.value = context.ref_at(offset).value  # type: ignore[union-attr]

    def cf13_copy_context_ref(self, frame: Frame350) -> None:
        """CF13: choose context ``+0x08`` or ``+0x80`` REF and copy to slot4.

        ``0x57FD4`` reads the signed dword at ``*(slot5 + 0x08) + 0x0c``.
        Positive selects the REF pair at ``slot5 + 0x08``; otherwise it
        selects ``slot5 + 0x80``.  As in native code, slot4 arrives in X8 as
        an output reference and slot2 is not changed.
        """
        context = self.heap.get(frame.get(5), RefFieldContext350)
        offset = 0x08 if context.cf13_selector_count > 0 else 0x80  # type: ignore[union-attr]
        self._copy_context_ref(frame, offset)

    def cf17_copy_context_ref_38(self, frame: Frame350) -> None:
        """CF17: copy the REF pair at native context offset ``+0x38``."""
        self._copy_context_ref(frame, 0x38)

    def cf18_copy_context_ref_70(self, frame: Frame350) -> None:
        """CF18: copy the REF pair at native context offset ``+0x70``."""
        self._copy_context_ref(frame, 0x70)

    def cf19_copy_context_ref_d8(self, frame: Frame350) -> None:
        """CF19: copy the REF pair at native context offset ``+0xd8``."""
        self._copy_context_ref(frame, 0xD8)

    def cf20_copy_context_ref_18(self, frame: Frame350) -> None:
        """CF20: copy the REF pair at native context offset ``+0x18``."""
        self._copy_context_ref(frame, 0x18)

    def cf21_release_ref_locked(self, frame: Frame350) -> None:
        """CF21: locked shared-REF release at slot4, with no slot2 write.

        ``0x16EF98`` forwards slot4 to ``0x625AC``.  That helper takes the
        ref's lock, then ``0x656A0`` decrements the control block at ``+8``;
        on its final reference it frees that block, invokes the managed
        object's release vfunc, and clears both ref words.  ``Ref`` carries
        exactly the bytecode-visible ownership relation, so its host release
        mirrors the observable terminal state without inventing a control
        block layout or a vtable.
        """
        self.heap.get(frame.get(4), Ref).value = None  # type: ignore[union-attr]

    def _sdk_identity(self) -> HostSdkIdentity350:
        if self.sdk_identity_provider is None:
            raise ManagedVmError(
                "CF22/CF23/CF24 require sdk_identity_provider from matching replay state"
            )
        identity = self.sdk_identity_provider()
        if not isinstance(identity, HostSdkIdentity350):
            raise ManagedVmError(
                "sdk_identity_provider must return HostSdkIdentity350"
            )
        return identity

    @staticmethod
    def _sdk_identity_components(identity: HostSdkIdentity350) -> tuple[str, str, str]:
        """Validate the literal component shape observed in 350.101.

        Native ``sub_590D4`` force-terminates a copy at offsets 3 and 6 then
        calls ``atoi`` at offsets 1, 4 and 7.  The strict host surface accepts
        only the captured ``vNN.NN.NN`` spelling instead of extending that
        parser to undocumented version formats.  ``sub_64338`` then joins
        these same three ASCII components with ``%s-%s-%s`` into a 64-byte
        cached buffer.
        """
        semver, flavor, platform = (
            identity.sdk_semver,
            identity.sdk_flavor,
            identity.sdk_platform,
        )
        if not all(isinstance(value, str) for value in (semver, flavor, platform)):
            raise ManagedVmError("HostSdkIdentity350 SDK components must be strings")
        if (
            len(semver) != 9
            or semver[0] != "v"
            or semver[3] != "."
            or semver[6] != "."
            or not (semver[1:3] + semver[4:6] + semver[7:9]).isdigit()
        ):
            raise ManagedVmError(
                "HostSdkIdentity350.sdk_semver must use observed vNN.NN.NN form"
            )
        if not flavor or not platform:
            raise ManagedVmError("HostSdkIdentity350 SDK flavor/platform must be non-empty")
        try:
            semver.encode("ascii")
            flavor.encode("ascii")
            platform.encode("ascii")
        except UnicodeEncodeError as exc:
            raise ManagedVmError(
                "HostSdkIdentity350 SDK components must be ASCII C-string data"
            ) from exc
        return semver, flavor, platform

    def cf22_app_version_ref(self, frame: Frame350) -> None:
        """CF22: put Java ``MS.b(0x1000011)`` text in the hidden slot4 REF.

        ``0x16EFB0`` moves only slot4 into AArch64's hidden X8 output
        register, then ``0xAA9B4`` invokes the Java bridge with operation
        ``0x1000011``.  The result is UTF-8 copied into a ref-counted
        24-byte MEM_BLOCK; null/empty/conversion-failure reaches the native
        empty-block fallback.  Model the bytecode-visible ``Ref`` value and
        its exact observed capacity, while leaving control-block ownership
        outside the host object model.  The wrapper never writes slot2.
        """
        app_version = self._sdk_identity().app_version
        if app_version is not None and not isinstance(app_version, str):
            raise ManagedVmError("HostSdkIdentity350.app_version must be str or None")
        try:
            data = (app_version or "").encode("utf-8")
        except UnicodeEncodeError as exc:
            raise ManagedVmError("CF22 app version cannot be UTF-8 encoded") from exc
        self.heap.get(frame.get(4), Ref).value = MemBlock(
            data, capacity=len(data) + 1
        )  # type: ignore[union-attr]

    def cf23_sdk_version_word(self, frame: Frame350) -> None:
        """CF23: guarded SDK/version word, zero-extended into slot2.

        ``0x16EFCC`` has no managed inputs.  Its ``0x5897C`` helper constructs
        and caches ``major<<24 | minor<<16 | patch<<8 | flavor | platform``.
        In the observed 350.101 identity this is ``0x04090500``.  The low
        feature bits are native first-character tests: flavor ``m`` -> 0,
        ``e`` -> 0x20; platform ``i``/``l``/``w`` -> 1/2/3, otherwise 0.
        """
        if self._cf23_cached_version_word is None:
            semver, flavor, platform = self._sdk_identity_components(self._sdk_identity())
            major = int(semver[1:3], 10)
            minor = int(semver[4:6], 10)
            patch = int(semver[7:9], 10)
            flavor_bits = 0x20 if flavor[0] == "e" else 0
            platform_bits = {"i": 1, "l": 2, "w": 3}.get(platform[0], 0)
            self._cf23_cached_version_word = (
                (major << 24) | (minor << 16) | (patch << 8) | flavor_bits | platform_bits
            ) & 0xFFFF_FFFF
        frame.set(2, self._cf23_cached_version_word)

    def cf24_sdk_identity_cstr(self, frame: Frame350) -> None:
        """CF24: return a process-lifetime cached ``sdk-flavor-platform`` C string.

        The native ``0x62260`` guard formats ``%s-%s-%s`` into a 64-byte
        global buffer and returns its raw pointer through slot2.  A host
        allocation supplies an equally stable, NUL-terminated raw address;
        it deliberately does not claim the native global's physical address.
        """
        if self._cf24_cached_cstr is None:
            semver, flavor, platform = self._sdk_identity_components(self._sdk_identity())
            text = f"{semver}-{flavor}-{platform}".encode("ascii")
            if len(text) >= 0x40:
                raise ManagedVmError("CF24 SDK identity exceeds native 64-byte cache")
            self._cf24_cached_cstr = self.memory.alloc(0x40)
            self.memory.map(self._cf24_cached_cstr, text + b"\0")
        frame.set(2, self._cf24_cached_cstr)

    def cf67_copy_context_ref_b0(self, frame: Frame350) -> None:
        """CF67: locked copy of the context REF pair at ``+0xb0``."""
        self._copy_context_ref(frame, 0xB0)

    def cf69_copy_context_ref_28(self, frame: Frame350) -> None:
        """CF69: locked copy of the context REF pair at ``+0x28``."""
        self._copy_context_ref(frame, 0x28)

    def cf25_get_env_object(self, frame: Frame350) -> None:
        frame.set(2, self.environment_ptr)

    def cf26_registry_lookup(self, frame: Frame350) -> None:
        registry = self.heap.get(frame.get(4), dict)
        key = self.heap.text(frame.get(5))
        frame.set(2, int(registry.get(key, 0xA985F)))

    def _cf_xor8_in_place(self, index: int, frame: Frame350) -> None:
        """Exact CF27/36/45/46/47 raw-buffer XOR loop.

        The helpers at `0x12CF90`, `0x12B904`, `0x12BFA8`, `0x12C648`, and
        `0x12C9A4` save X0 and W1, then their flattened continuations perform
        ``buf[i] ^= key[i & 7]`` while signed ``i < (int32_t)W1``.  They do
        not call ``strlen`` or inspect/write a terminator.  Keeping the signed
        low-32-bit length also preserves the native no-op behavior for a
        negative W1 rather than treating the full managed qword as a length.
        """
        address = frame.get(4)
        length = s32(frame.get(5))
        key = _CF_XOR8_KEYS[index]
        for offset in range(max(length, 0)):
            self.memory.write(
                address + offset,
                1,
                self.memory.read(address + offset, 1) ^ key[offset & 7],
            )
        frame.set(2, address)

    def cf27_xor8_in_place(self, frame: Frame350) -> None:
        self._cf_xor8_in_place(27, frame)

    def cf36_xor8_in_place(self, frame: Frame350) -> None:
        self._cf_xor8_in_place(36, frame)

    def cf45_xor8_in_place(self, frame: Frame350) -> None:
        self._cf_xor8_in_place(45, frame)

    def cf46_xor8_in_place(self, frame: Frame350) -> None:
        self._cf_xor8_in_place(46, frame)

    def cf47_xor8_in_place(self, frame: Frame350) -> None:
        self._cf_xor8_in_place(47, frame)

    def cf28_empty_string_cmp_lsb(self, frame: Frame350) -> None:
        """CF28: ``strcmp(memblock_body, \"\") & 1``.

        The wrapper at ``0x16F0D0`` calls ``0x9CDB8(slot4)`` and masks its
        result with one.  The helper returns ``1`` for a null/empty block; for
        a nonempty C string it tails into ``strcmp(body, \"\")``.  The C
        library's result is the first non-zero byte for this particular RHS,
        so preserving only bit zero is both the native wrapper's observable
        result and avoids incorrectly normalising it to a boolean.
        """
        data = self._block(frame.get(4)).data
        frame.set(2, 1 if not data else (data[0] & 1))

    def cf29_md5_memblock_to_ref(self, frame: Frame350) -> None:
        """CF29: MD5 a slot5 MEM_BLOCK into the hidden slot4 REF output.

        Wrapper ``0x16F0FC`` resolves slot4, slot5 and slot6, moves them to
        X8, X0 and ``W1 & 1`` respectively, then calls ``0x11AF7C``.  The
        callee reads the MEM_BLOCK body/length, computes standard MD5, clears
        and replaces the destination shared reference, and never invokes the
        managed ``setSlot(frame, 2, ...)`` helper.  Flag zero owns a new
        16-byte raw digest MEM_BLOCK; flag one takes its lowercase ASCII hex
        form through ``bytesToHexString`` (32 bytes).  The latter allocates a
        64-byte native capacity for the fixed 33-byte-with-NUL request.

        ``Ref`` deliberately represents only the observable shared-reference
        destination; its native control-block lifecycle is outside this host
        model.  In particular, slot2 is preserved on both flag branches.
        """
        digest = hashlib.md5(self._block(frame.get(5)).data).digest()
        if frame.get(6) & 1:
            data = digest.hex().encode("ascii")
            result = MemBlock(data, capacity=self._rounded_memblock_capacity(len(data) + 1))
        else:
            result = MemBlock(digest, capacity=len(digest) + 1)
        self.heap.get(frame.get(4), Ref).value = result  # type: ignore[union-attr]

    def cf30_concat_memblocks(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), self._block(frame.get(5)).data + self._block(frame.get(6)).data)
        frame.set(2, frame.get(4))

    def cf32_fill_memblock_from_byte(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), bytes((frame.get(5) & 0xff,)) * frame.get(6))
        frame.set(2, frame.get(4))

    def cf34_base64_decode(self, frame: Frame350) -> None:
        try:
            decoded = base64.b64decode(self._data(frame.get(5)), validate=True)
        except (ValueError, binascii.Error):
            decoded = b""
        if frame.get(4) in self.heap.objects and isinstance(self.heap.get(frame.get(4)), Ref):
            self.heap.get(frame.get(4), Ref).value = MemBlock(decoded)  # type: ignore[union-attr]
        frame.set(2, int(bool(decoded)))

    def _cf35_material(self, source: object) -> HostNativeVmpMaterial350:
        if self.cf35_material_provider is None:
            raise ManagedVmError(
                "CF35 requires cf35_material_provider from matching native-VMP replay state"
            )
        material = self.cf35_material_provider(source)
        if not isinstance(material, HostNativeVmpMaterial350):
            raise ManagedVmError(
                "cf35_material_provider must return HostNativeVmpMaterial350"
            )
        return material

    def cf35_native_vmp_material_select_ref(self, frame: Frame350) -> None:
        """CF35: select one native-VMP material value into hidden slot4 REF.

        Wrapper ``0x16F29C`` sends slot4 to hidden X8, slot5 to X0, and slot6
        to X1 before calling ``0x12564C``; it never calls
        ``managedFrameSetSlot(..., 2, ...)``.  The helper clones two refs from
        the opaque source context, invokes native VMP ``0x1F7860``, clears the
        destination ref, and scans material entries.  The comparison at
        ``0x10A524`` first requires equal signed lengths, then does a raw
        byte comparison, so selector ``MEM_BLOCK.data`` is neither decoded
        nor NUL-truncated.  A match creates a fresh output MEM_BLOCK; no
        match leaves the freshly cleared destination.  A failed VMP build
        crashes before that clear in native code, which this strict provider
        boundary represents by raising before touching slot4.

        The provider receives slot5's host object unchanged because only its
        native ``+0x08/+0x28/+0x48`` fields are known and they belong to the
        unreplaced VMP boundary.  ``Ref`` models the bytecode-visible payload
        only, not the temporary native material/control-block lifecycle.
        """
        material = self._cf35_material(self.heap.get(frame.get(5)))
        selector = self._block(frame.get(6)).data
        destination = self.heap.get(frame.get(4), Ref)
        destination.value = None  # type: ignore[union-attr]
        for entry in material.entries:
            if entry is not None and entry[0] == selector:
                destination.value = MemBlock(entry[1])  # type: ignore[union-attr]
                return

    def cf37_copy_memblock(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), self._block(frame.get(5)).data)
        frame.set(2, frame.get(4))

    def cf38_init_memblock_by_src(self, frame: Frame350) -> None:
        length = frame.get(6)
        self._set_block_data(self._block(frame.get(4)), bytes(self.memory.read(frame.get(5) + i, 1) for i in range(length)))

    def cf39_http_client_json_list_ptr(self, frame: Frame350) -> None:
        """CF39: return the address of the caller's HTTP-client JSON list.

        ``0x47820`` acquires the context read lock at ``slot4 + 0x100`` and
        returns the interior address ``slot4 + 0x68``; it does *not* dereference
        that member.  A single-threaded host frame therefore preserves the
        exact returned pointer without manufacturing list contents.
        """
        frame.set(2, frame.get(4) + 0x68)

    def cf40_shared_ref_assign_ret(self, frame: Frame350) -> None:
        """CF40: assign slot5 REF into slot4, then return slot4 in slot2.

        The native helper at ``0x47908`` releases/replaces the destination
        pair, increments the source control block's refcount, and returns the
        destination address.  The host model represents the observable value
        assignment; HostHeap intentionally has no native control block or
        mutex lifecycle to emulate.
        """
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]
        frame.set(2, frame.get(4))

    def cf53_shared_ref_assign_ret(self, frame: Frame350) -> None:
        """CF53: generic shared-reference assignment, returning destination.

        Wrapper ``0x16F750`` resolves frame slots 4 and 5, calls ``0x47C1C``,
        and writes that helper's returned destination to slot 2.  The helper
        replaces the two-word shared-reference pair at the destination,
        releasing the old control block and assigning/incrementing the source
        pair.  This is the same observable host operation as CF40, but a
        distinct native helper and ABI wrapper, so it is kept as its own CF.
        """
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]
        frame.set(2, frame.get(4))

    def cf41_simon128_256_pkcs7(self, frame: Frame350) -> None:
        """CF41/F16: SIMON128/256 ECB over a PKCS#7-padded MEM_BLOCK.

        Observed ABI: slot4=input, slot5=output, slot6=key material.  The
        native wrapper normalizes key material to 32 bytes; accepting any
        other length here would hide a missing lifecycle/normalization rule,
        so the standalone runtime deliberately rejects it.
        """
        source = self._block(frame.get(4)).data
        key = self._block(frame.get(6)).data
        if len(key) != 32:
            raise ManagedVmError(f"CF41 requires normalized 32-byte key material, got {len(key)}")
        mask = MASK64
        rotr = lambda value, count: ((value >> count) | (value << (64 - count))) & mask
        rotl = lambda value, count: ((value << count) | (value >> (64 - count))) & mask
        words = [int.from_bytes(key[offset:offset + 8], "little") for offset in range(0, 32, 8)]
        round_keys = [words[0]]
        z = 0x3DC94C3A046D678B
        for index in range(71):
            mix = words[1] ^ rotr(words[3], 3)
            next_word = words[0] ^ (0xFFFFFFFFFFFFFFFC | ((z >> (index % 62)) & 1)) ^ mix ^ rotr(mix, 1)
            words = [words[1], words[2], words[3], next_word & mask]
            round_keys.append(words[0])
        pad = 16 - (len(source) & 15)
        padded = source + bytes((pad,)) * pad
        output = bytearray()
        for offset in range(0, len(padded), 16):
            left = int.from_bytes(padded[offset:offset + 8], "little")
            right = int.from_bytes(padded[offset + 8:offset + 16], "little")
            for round_key in round_keys:
                fn = (rotl(right, 1) & rotl(right, 8)) ^ rotl(right, 2)
                left, right = right, (left ^ fn ^ round_key) & mask
            output.extend(left.to_bytes(8, "little"))
            output.extend(right.to_bytes(8, "little"))
        self._set_block_data(self._block(frame.get(5)), bytes(output))

    def cf42_pack_u16_le(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), struct.pack("<H", frame.get(5) & 0xffff))

    def cf43_aes128_cbc_pkcs7(self, frame: Frame350) -> None:
        """CF43's observed mode-1 branch: AES-128-CBC with PKCS#7 padding.

        slot4 is the output MEM_BLOCK; slot5/body, slot6/key16, slot7/iv16,
        and slot8/mode descriptor are inputs.  The evidence currently covers
        only descriptor type 1, so all other modes fail explicitly.
        """
        mode = self.heap.get(frame.get(8))
        mode_type = mode.get("type") if isinstance(mode, dict) else None
        if mode_type != 1:
            raise ManagedVmError(f"CF43 only has evidence for mode type 1, got {mode_type!r}")
        body = self._block(frame.get(5)).data
        key = self._block(frame.get(6)).data
        iv = self._block(frame.get(7)).data
        if len(key) != 16 or len(iv) != 16:
            raise ManagedVmError(f"CF43 type 1 requires key16/iv16, got key={len(key)} iv={len(iv)}")
        try:
            from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
        except ImportError as exc:
            raise ManagedVmError("CF43 requires the cryptography AES backend") from exc
        pad = 16 - (len(body) & 15)
        padded = body + bytes((pad,)) * pad
        encryptor = Cipher(algorithms.AES(key), modes.CBC(iv)).encryptor()
        self._set_block_data(self._block(frame.get(4)), encryptor.update(padded) + encryptor.finalize())

    def cf44_base64_encode(self, frame: Frame350) -> None:
        out = self.heap.get(frame.get(4), Ref)
        out.value = MemBlock(base64.b64encode(self._block(frame.get(5)).data))

    def cf48_short_header_transform32(self, frame: Frame350) -> None:
        """CF48/F17 short-header transform; slot4=text, slot5=out, slot6=key32."""
        text = self._block(frame.get(4)).data
        key = self._block(frame.get(6)).data
        if len(key) != 32:
            raise ManagedVmError(f"CF48 requires normalized 32-byte key material, got {len(key)}")
        mask = MASK64
        def rotl(value: int, count: int) -> int:
            return ((value << count) | (value >> (64 - count))) & mask
        def rotr(value: int, count: int) -> int:
            return ((value >> count) | (value << (64 - count))) & mask
        state = [int.from_bytes(key[offset:offset + 8], "little") for offset in range(0, 32, 8)]
        schedule = [state[0]]
        for index in range(34):
            next_b = (rotr(state[1], 8) + state[0]) & mask
            next_b ^= index
            next_a = next_b ^ rotr(state[0], 61)
            state = [next_a & mask, state[2], state[3], next_b & mask]
            schedule.append(state[0])
        pad = 16 - (len(text) & 15)
        padded = text + bytes((pad,)) * pad
        output = bytearray()
        for offset in range(0, len(padded), 16):
            y = int.from_bytes(padded[offset:offset + 8], "little")
            x = int.from_bytes(padded[offset + 8:offset + 16], "little")
            for round_key in schedule[:34]:
                x = (rotr(x, 8) + y) & mask
                x ^= round_key
                y = rotl(y, 3) ^ x
            output.extend((y & mask).to_bytes(8, "little"))
            output.extend((x & mask).to_bytes(8, "little"))
        self._set_block_data(self._block(frame.get(5)), bytes(output))

    def cf49_pack_short_header(self, frame: Frame350) -> None:
        prefix = self._block(frame.get(4)).data
        transformed = self._block(frame.get(5)).data
        frame.set(2, self.heap.put(MemBlock(prefix + transformed)))

    def cf51_native_global_singleton_ptr(self, frame: Frame350) -> None:
        """CF51: return the once-initialized native singleton pointer.

        ``0x44614`` atomically initializes/caches a 0x2d0-byte global object
        and CF51 writes the returned X0 to slot2.  Its opaque body must come
        from the matching trace/replay state, so only the pointer ABI is
        modeled here.
        """
        frame.set(2, self._native_global_ptr(51))

    def cf50_init_memblock_triplet(self, frame: Frame350) -> None:
        """CF50: default-construct three MEM_BLOCK fields without slot2 write.

        ``0x16F6FC`` forwards slot4 to ``0x16CE40``.  That helper invokes
        ``0x10B438`` for the aggregate's ``+0x20``, ``+0x38`` and ``+0x50``
        members, in that order.  Each native constructor allocates its
        default eight-byte (empty C-string) buffer.  ``MemBlock.capacity=8``
        is the host-visible equivalent; the real allocator pointer stays
        deliberately outside this runtime's synthetic heap.
        """
        triplet = self.heap.get(frame.get(4), MemBlockTriplet350)
        for block in triplet.members_in_native_init_order():  # type: ignore[union-attr]
            block.data, block.capacity = b"", 8

    def cf52_destroy_memblock_triplet(self, frame: Frame350) -> None:
        """CF52: destroy MEM_BLOCK members at ``+0x50/+0x38/+0x20``.

        The wrapper ``0x16F738`` forwards slot4 to ``0x16CE70``.  That helper
        calls the MEM_BLOCK destructor ``0x10B764`` in exactly this order and
        does not write the managed return slot.  ``MemBlockTriplet350`` is the
        minimal host representation of those three proven field offsets.
        """
        triplet = self.heap.get(frame.get(4), MemBlockTriplet350)
        for block in triplet.members_in_native_destroy_order():  # type: ignore[union-attr]
            block.data, block.capacity = b"", 0

    def cf54_substring_memblock(self, frame: Frame350) -> None:
        source = self._block(frame.get(5)).data
        self._set_block_data(self._block(frame.get(4)), source[frame.get(6):frame.get(6) + frame.get(7)])
        frame.set(2, frame.get(4))

    def cf55_reserve_memblock(self, frame: Frame350) -> None:
        """CF55: reserve at least slot5 bytes in the slot4 MEM_BLOCK.

        ``0x16F808`` tails through ``0x10B7CC`` into the allocator's
        minimum-8/power-of-two growth routine.  No frame return slot is
        written; only capacity may change.
        """
        block = self._block(frame.get(4))
        requested = frame.get(5)
        if requested > 0x7fff_ffff:
            raise ManagedVmError(f"CF55 reserve request out of native int range: {requested}")
        block.capacity = max(block.capacity, self._rounded_memblock_capacity(int(requested)))

    def cf56_append_memblock_byte_ret(self, frame: Frame350) -> None:
        """CF56: append low byte(slot5) to slot4, return the destination.

        The ``0x16F844 -> 0x10B9FC -> 0x109FB8`` path reserves ``len + 2``,
        writes the byte and terminator, and returns the original MEM_BLOCK.
        """
        block = self._block(frame.get(4))
        block.capacity = max(block.capacity, self._rounded_memblock_capacity(len(block.data) + 2))
        self._set_block_data(block, block.data + bytes((frame.get(5) & 0xff,)))
        frame.set(2, frame.get(4))

    @staticmethod
    def _strtoull_digits(character: int) -> int:
        if 48 <= character <= 57:
            return character - 48
        if 65 <= character <= 90:
            return character - 65 + 10
        if 97 <= character <= 122:
            return character - 97 + 10
        return 36

    def cf57_strtoull(self, frame: Frame350) -> None:
        """CF57: C ``strtoull(slot4, slot5, slot6)`` with raw endptr output."""
        address, endptr, base = frame.get(4), frame.get(5), frame.get(6)
        if base != 0 and not 2 <= base <= 36:
            raise ManagedVmError(f"CF57 invalid strtoull base {base}")
        text = self.memory.read_c_string(address)
        pos = 0
        while pos < len(text) and text[pos] in b" \t\n\r\v\f":
            pos += 1
        negative = False
        if pos < len(text) and text[pos] in (ord("+"), ord("-")):
            negative = text[pos] == ord("-")
            pos += 1
        parse_base = base
        if parse_base == 0:
            if (
                pos + 2 < len(text)
                and text[pos:pos + 2].lower() == b"0x"
                and self._strtoull_digits(text[pos + 2]) < 16
            ):
                parse_base = 16
                pos += 2
            elif pos < len(text) and text[pos] == ord("0"):
                parse_base = 8
            else:
                parse_base = 10
        elif (
            parse_base == 16
            and pos + 2 < len(text)
            and text[pos:pos + 2].lower() == b"0x"
            and self._strtoull_digits(text[pos + 2]) < 16
        ):
            pos += 2

        first_digit = pos
        value = 0
        overflow = False
        while pos < len(text):
            digit = self._strtoull_digits(text[pos])
            if digit >= parse_base:
                break
            if value > (MASK64 - digit) // parse_base:
                overflow = True
            elif not overflow:
                value = value * parse_base + digit
            pos += 1
        if pos == first_digit:
            # C's endptr is the original nptr, including skipped whitespace,
            # when no conversion at all was performed.
            pos = 0
            value = 0
        elif overflow:
            value = MASK64
        elif negative:
            value = (-value) & MASK64
        if endptr:
            self.memory.write(endptr, 8, address + pos)
        frame.set(2, value)

    @staticmethod
    def _rc4(key: bytes, source: bytes) -> bytes:
        """Standard RC4 KSA followed by zero-warmup PRGA over raw bytes."""
        state = list(range(256))
        j = 0
        for i in range(256):
            j = (j + state[i] + key[i % len(key)]) & 0xff
            state[i], state[j] = state[j], state[i]
        i = j = 0
        output = bytearray()
        for byte in source:
            i = (i + 1) & 0xff
            j = (j + state[i]) & 0xff
            state[i], state[j] = state[j], state[i]
            output.append(byte ^ state[(state[i] + state[j]) & 0xff])
        return bytes(output)

    @staticmethod
    def _bit_reverse8(value: int) -> int:
        """Return the native F4-generated bit reversal of one byte."""
        value &= 0xff
        value = ((value & 0x55) << 1) | ((value >> 1) & 0x55)
        value = ((value & 0x33) << 2) | ((value >> 2) & 0x33)
        return ((value & 0x0f) << 4) | ((value >> 4) & 0x0f)

    def cf03_rc4_residue_transpose_memblock_ref(self, frame: Frame350) -> None:
        """CF03: address-seeded RC4 plus residue-major MEM_BLOCK transpose.

        Wrapper ``0x16EBC0`` forwards hidden slot4 in X8, slot5 in X0, and
        the full raw slot6 scalar in X1 to ``0x16C65C``; it never writes the
        outer frame's slot2.  The flattened body makes a temporary
        ``len(source)+7``-byte MEM_BLOCK, then mixes that temporary body's
        native address into an 8-byte RC4 key and an output stride.  Its
        address is deliberately injected rather than derived from a Python
        allocation: the value is part of the observed algorithm, but no host
        allocation address is a valid substitute for a captured native one.

        With ``p`` as the supplied temporary body address and ``q=slot6``:

        ``key = [q>>24, p, 0x16, p>>8, 0x4a, p>>16, 0x87, q>>16] & 0xff``;
        ``A = [0x87, 0x05, q>>24, q>>16, p, p>>8, p>>16] + RC4(key, source)``;
        and ``B = [bit_reverse8(stride)] + concat(A[r::stride])`` for
        ``r=0..stride-1`` and ``stride=8 | ((p>>24)&3)``.  Therefore B is
        always ``len(source)+8`` bytes.  Both source and output are binary;
        embedded NUL bytes do not terminate either operation.

        Missing, malformed, or failing address providers raise before slot4
        or slot2 changes.  The supplied address is only shifted/masked and is
        never dereferenced by this runtime.
        """
        source = self._block(frame.get(5)).data
        destination = self.heap.get(frame.get(4), Ref)
        provider = self.cf03_temp_body_address_provider
        if not callable(provider):
            raise ManagedVmError(
                "CF03 requires cf03_temp_body_address_provider with the "
                "captured native temporary MEM_BLOCK body address"
            )
        scalar = frame.get(6)
        temporary_body_address = provider(source, scalar)
        if type(temporary_body_address) is not int or not (
            0 <= temporary_body_address <= MASK64
        ):
            raise ManagedVmError(
                "cf03_temp_body_address_provider must return one u64 address"
            )

        p = temporary_body_address
        key = bytes((
            (scalar >> 24) & 0xff,
            p & 0xff,
            0x16,
            (p >> 8) & 0xff,
            0x4a,
            (p >> 16) & 0xff,
            0x87,
            (scalar >> 16) & 0xff,
        ))
        temporary = bytes((
            0x87,
            0x05,
            (scalar >> 24) & 0xff,
            (scalar >> 16) & 0xff,
            p & 0xff,
            (p >> 8) & 0xff,
            (p >> 16) & 0xff,
        )) + self._rc4(key, source)
        stride = 8 | ((p >> 24) & 3)
        output = bytearray((self._bit_reverse8(stride),))
        for residue in range(stride):
            output.extend(temporary[residue::stride])
        # Assignment is intentionally last: all host/provider validation and
        # transform work above must leave an existing output REF untouched on
        # failure, just as this bridge refuses to invent a native address.
        destination.value = MemBlock(bytes(output), capacity=len(output) + 1)  # type: ignore[union-attr]

    def cf58_rc4_memblock_to_ref(self, frame: Frame350) -> None:
        """CF58: RC4 raw slot5 bytes with raw slot6 key into hidden slot4 REF.

        ``0x16F8F0`` moves slot4 to hidden X8, slot5 to X0 and slot6 to X1,
        then calls ``encryptForMssdk @ 0x11B98C`` without a managed slot2
        store.  Its nonempty branch extracts both MEM_BLOCK body/length pairs
        and invokes ``0x107600`` with warmup zero.  The split helpers at
        ``0x1074FC`` and ``0x1075A0`` are the standard RC4 KSA and PRGA.

        Empty source *or* empty key follows native ``setObjectAddRef_4(X8,
        NULL)`` and clears the output REF, rather than constructing an empty
        MEM_BLOCK.  Both input blocks are resolved before output assignment:
        malformed host state raises and preserves the old output/slot2 rather
        than being treated as the native empty-input branch.  Data remains
        binary; NUL bytes have no delimiter meaning.
        """
        source = self._block(frame.get(5)).data
        key = self._block(frame.get(6)).data
        destination = self.heap.get(frame.get(4), Ref)
        if not source or not key:
            destination.value = None  # type: ignore[union-attr]
            return
        destination.value = MemBlock(  # type: ignore[union-attr]
            self._rc4(key, source), capacity=len(source) + 1
        )

    def cf59_crc8_poly31_init0(self, frame: Frame350) -> None:
        """CF59: CRC-8 (poly 0x31, init 0, no final XOR) of slot4 MEM_BLOCK."""
        crc = 0
        for byte in self._block(frame.get(4)).data:
            crc ^= byte
            for _ in range(8):
                crc = ((crc << 1) ^ 0x31) & 0xff if crc & 0x80 else (crc << 1) & 0xff
        frame.set(2, crc)

    def cf60_alloc_prepare_raw(self, frame: Frame350) -> None:
        """CF60: allocator wrapper, slot4 byte count -> raw pointer in slot2."""
        frame.set(2, self.memory.alloc(frame.get(4)))

    def cf61_sm3(self, frame: Frame350) -> None:
        try:
            data = bytes(self.memory.read(frame.get(4) + index, 1) for index in range(frame.get(5)))
            digest = hashlib.new("sm3", data).digest()
        except ValueError as exc:
            raise ManagedVmError("Python build lacks hashlib SM3") from exc
        self.memory.map(frame.get(6), digest)
        frame.set(2, 0)

    def cf62_clone_ref_no_return(self, frame: Frame350) -> None:
        """CF62: copy the slot5 shared ref into slot4 without writing slot2."""
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]

    def cf63_second_module_f22_memblock_hash_u32(self, frame: Frame350) -> None:
        """CF63: exact pure F22 byte recurrence over the slot4 MEM_BLOCK.

        Native ``0x16FA34`` puts outer slot4 into a cleared second-module F22
        child frame.  The dumped F22 body reads only the signed logical length
        and body pointer, makes no raw store and calls no CF, then the wrapper
        copies child slot2's low word to outer slot2.  The host MEM_BLOCK's
        byte length is the corresponding non-negative visible logical length.
        """
        data = self._block(frame.get(4)).data
        value = 0x2023_0928
        for index, byte in enumerate(data):
            if index & 1 == 0:
                mixed = ((value << 6) & 0xFFFF_FFFF) ^ value
                value = (value >> 4) & 0xFFFF_FFFF
                value = byte ^ mixed ^ value
            else:
                mixed = ((value << 12) & 0xFFFF_FFFF) | byte
                value = ((value >> 7) ^ value) & 0xFFFF_FFFF
                value = ~(mixed ^ value)
            value &= 0xFFFF_FFFF
        # The native adapter uses MOV W2, W0 before outer set-slot: explicitly
        # preserve that low32 zero-extension rather than the F22 child slot's
        # sign-extended internal representation.
        frame.set(2, value)

    def cf65_context_flag_e8(self, frame: Frame350) -> None:
        """CF65: return bit 0 of the raw slot4 context's observed ``+0xE8`` flag."""
        frame.set(2, self.memory.read(frame.get(4) + 0xE8, 4) & 1)

    def cf66_realtime_seconds(self, frame: Frame350) -> None:
        """CF66: native CLOCK_REALTIME millisecond helper, divided by 1000."""
        frame.set(2, self.current_time_millis_provider() // 1_000)

    def cf68_getpid(self, frame: Frame350) -> None:
        """CF68: ``getpid()`` result is zero-extended into return slot2."""
        frame.set(2, self.process_id_provider() & 0xffff_ffff)

    def cf70_getppid(self, frame: Frame350) -> None:
        """CF70: ``getppid()`` result is zero-extended into return slot2."""
        frame.set(2, self.parent_process_id_provider() & 0xffff_ffff)

    def cf71_thread_pointer(self, frame: Frame350) -> None:
        """CF71: return the AArch64 ``TPIDR_EL0`` thread-pointer value.

        ``0x16FBD4`` invokes flattened helper ``0xD9674`` without frame
        arguments and writes X0 to slot2. A focused Unicorn2 trace proves its
        X0 equals entry ``TPIDR_EL0`` (``0xe4fff700`` in that run), so this is
        neither an integer thread id nor a stable singleton.
        """
        if self.thread_pointer_provider is None:
            raise ManagedVmError(
                "CF71 requires thread_pointer_provider for matching replay state"
            )
        frame.set(2, self.thread_pointer_provider())

    def cf74_tree_pointer_lookup(self, frame: Frame350) -> None:
        """CF74: look up the raw value in slot4 aggregate's tree at ``+0x58``.

        ``0x16FC48 -> 0x1195F4`` takes the aggregate rwlock at ``+0x88``,
        calls ``queryTreeItem(slot4 + 0x58, slot5)``, and returns the first
        qword of a matching tree item, or zero when absent.  Slot2 receives
        that value.  The host model intentionally preserves slot5 as an
        opaque integer key because no static evidence identifies its native
        comparator type.
        """
        trees = self.heap.get(frame.get(4), HostTreeMaps350)
        frame.set(2, u64(trees.pointers_at_58.get(frame.get(5), 0)))  # type: ignore[union-attr]

    @staticmethod
    def _cf76_format_uuid4(random_words: bytes) -> bytes:
        """Apply native ``xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`` formatting.

        ``0x118728`` reads the low nibble then the high nibble of each byte
        from the two xorshift output words.  It replaces ``x`` directly and
        ``y`` with ``(nibble & 3) | 8``.  Keeping that nibble order is needed
        for a captured xorshift output to replay byte-for-byte.
        """
        if len(random_words) != 16:
            raise ManagedVmError(
                "CF76 random-byte provider must return exactly two xorshift words (16 bytes)"
            )
        alphabet = b"0123456789abcdef"
        out = bytearray()
        nibble_index = 0
        for character in b"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx":
            if character not in (ord("x"), ord("y")):
                out.append(character)
                continue
            byte = random_words[nibble_index >> 1]
            nibble = byte & 0x0F if (nibble_index & 1) == 0 else byte >> 4
            if character == ord("y"):
                nibble = (nibble & 3) | 8
            out.append(alphabet[nibble])
            nibble_index += 1
        # The literal version nibble in ``4xxx`` consumes no random nibble;
        # one high nibble of the second xorshift word is consequently unused.
        assert nibble_index == 31
        return bytes(out)

    def cf76_cached_uuid4_ref(self, frame: Frame350) -> None:
        """CF76: lazily create and share the native UUID-v4-style MEM_BLOCK.

        ``0x16FCE4 -> 0x11FA94`` initializes a process-global shared REF only
        on first use.  Its producer reads 16 bytes from ``/dev/urandom`` to
        seed xorshift128+, and ``0x118728`` formats the two subsequent output
        words as a UUID-v4 template.  The wrapper writes only the slot4 REF;
        managed slot2 remains unchanged.
        """
        destination = self.heap.get(frame.get(4), Ref)
        if self._cf76_cached_uuid is None:
            random_words = bytes(self.cf76_random_bytes_provider())
            self._cf76_cached_uuid = MemBlock(self._cf76_format_uuid4(random_words))
        destination.value = self._cf76_cached_uuid  # type: ignore[union-attr]

    def cf84_tree_memblock_lookup(self, frame: Frame350) -> None:
        """CF84: copy a tree value at ``slot5 + 0x30`` into slot4 MEM_BLOCK.

        ``0x16FE50 -> 0x119750`` locks the same ``+0x88`` rwlock as CF74 and
        probes a separate tree rooted at ``+0x30`` with opaque key slot6.  A
        hit is copied with ``copyMemBlock``; a miss constructs an empty C
        string in slot4.  The native wrapper does not write slot2.
        """
        destination = self._block(frame.get(4))
        trees = self.heap.get(frame.get(5), HostTreeMaps350)
        source = trees.memblocks_at_30.get(frame.get(6))  # type: ignore[union-attr]
        self._set_block_data(destination, b"" if source is None else source.data)

    def cf77_crc32_ieee(self, frame: Frame350) -> None:
        """CF77: standard reflected CRC-32/ISO-HDLC over a MEM_BLOCK.

        Wrapper ``0x16FD00`` passes slot4 to ``0x11B5D4`` and stores W0 in
        slot2.  That helper unwraps the block body/length and tails into
        ``0x10E15C``: initial complement, the 256-entry reflected table loop,
        then final complement.  ``binascii.crc32`` has precisely those
        CRC-32/ISO-HDLC parameters, including the empty-input result zero.
        """
        frame.set(2, binascii.crc32(self._block(frame.get(4)).data) & 0xffff_ffff)

    def _cf78_c_string(self, pointer: int) -> bytes | None:
        """Read CF78's raw NUL-terminated ``char *`` without text coercion."""
        if pointer == 0:
            return None
        if pointer in self.heap.objects:
            value = self.heap.get(pointer)
            if not isinstance(value, MemBlock):
                raise ManagedVmError(
                    "CF78 slot5 must be a raw C pointer or byte-backed MemBlock, not host text"
                )
            return value.data.split(b"\0", 1)[0]
        return self.memory.read_c_string(pointer)

    def _cf78_parse_root(self, raw: bytes | None) -> HostIdItem350:
        # Native NULL goes straight to newIDItem_json; no parser is involved.
        if raw is None:
            return HostIdItem350(0x40)
        if self.cf78_json_parser_provider is None:
            raise ManagedVmError(
                "CF78 requires cf78_json_parser_provider for non-NULL native JSON input"
            )
        root = self.cf78_json_parser_provider(raw)
        if root is not None and not isinstance(root, HostIdItem350):
            raise ManagedVmError(
                "cf78_json_parser_provider must return HostIdItem350 or None on native parse failure"
            )
        # ``parseJsonToIDItem`` replaces a parse failure with newIDItem_json:
        # a new empty object-root, not a null ref or error return.
        return HostIdItem350(0x40) if root is None else root

    def cf78_parse_json_to_id_item_ref(self, frame: Frame350) -> None:
        """CF78: place a parsed ID-item wrapper in hidden slot4, preserving slot2.

        ``0x16FD2C`` moves slot4 to X8 and slot5 to X0 then calls
        ``0x123B14`` without a managed return-slot store.  The latter consumes
        a raw NUL-terminated C string, creates a fresh ``ID_ITEM_WRAP`` and
        places it in the destination REF.  Its parser supports BOM/control
        whitespace, valid prefixes with trailing bytes, and ordered duplicate
        object keys, so this narrow bridge accepts an explicit native-compatible
        parser provider rather than treating Python text/``json.loads`` as an
        oracle.  A provider ``None`` result represents native parse failure
        and receives the proven empty-object fallback; absent/invalid provider
        state is a host error before slot4 is changed.
        """
        root = self._cf78_parse_root(self._cf78_c_string(frame.get(5)))
        destination = self.heap.get(frame.get(4), HostRefIdItemWrap350)
        destination.wrap = HostIdItemWrap350(root)  # type: ignore[union-attr]

    def cf89_realtime_millis(self, frame: Frame350) -> None:
        """CF89: native CLOCK_REALTIME-derived current time in milliseconds."""
        frame.set(2, self.current_time_millis_provider())

    def _proto_wire_from_slot4(self, frame: Frame350, schema_offset: int,
                               binding: str) -> bytes:
        """Resolve one schema-bound host message behind a native slot4 ABI.

        The native pairs accept a raw descriptor-backed object pointer. This
        host bridge intentionally accepts only their explicit semantic
        analogue, and binds each CF alias to its observed root schema, so it
        cannot be mistaken for fabricated native object memory or a generic
        protobuf serializer.
        """
        message = self.heap.get(frame.get(4), HostProtoWireMessage350)
        if message.schema_offset != schema_offset:  # type: ignore[union-attr]
            raise ManagedVmError(
                f"{binding} requires host proto-wire schema +0x{schema_offset:x}"
            )
        return serialize_proto_wire_message_350(message)  # type: ignore[arg-type]

    def _write_proto_wire(self, frame: Frame350, schema_offset: int,
                          binding: str) -> None:
        """Write one schema-bound wire body to the pre-mapped raw slot5 range."""
        wire = self._proto_wire_from_slot4(frame, schema_offset, binding)
        self.memory.write_mapped_bytes(frame.get(5), wire)
        frame.set(2, len(wire))

    def cf31_proto_wire_f5_size(self, frame: Frame350) -> None:
        """CF31: F5 schema ``+0x271AD8`` exact proto-wire byte count only."""
        frame.set(2, len(self._proto_wire_from_slot4(frame, 0x271AD8, "CF31")))

    def cf33_proto_wire_f5_write(self, frame: Frame350) -> None:
        """CF33: write the F5-only wire body to an already mapped raw buffer."""
        self._write_proto_wire(frame, 0x271AD8, "CF33")

    def cf90_proto_wire_f8_size(self, frame: Frame350) -> None:
        """CF90: F8 schema ``+0x272080`` exact proto-wire byte count only."""
        frame.set(2, len(self._proto_wire_from_slot4(frame, 0x272080, "CF90")))

    def cf91_proto_wire_f8_write(self, frame: Frame350) -> None:
        """CF91: write the same F8-only wire body to an already mapped buffer.

        Native ``postDataWriteBuf`` has no capacity argument.  The host
        equivalent therefore preflights the caller-provided raw region before
        committing any byte; slot5 remains a bare byte pointer, never a
        ``MEM_BLOCK`` host object.
        """
        self._write_proto_wire(frame, 0x272080, "CF91")

    def cf92_release_lock_guard(self, frame: Frame350) -> None:
        """CF92: release a conditional-unlock guard passed in slot4.

        ``0x170060`` calls ``0x44A98(slot4)``.  The helper replaces its vtable
        then invokes ``pthread_mutex_unlock((slot4->holder) + 8)`` only when
        its dword at ``+0x10`` is zero.  It does not write slot2.
        """
        guard = self.heap.get(frame.get(4), HostLockGuard350)
        guard.released = True  # type: ignore[union-attr]
        if guard.state_at_10 == 0:  # type: ignore[union-attr]
            if not guard.mutex.locked:  # type: ignore[union-attr]
                raise ManagedVmError("CF92 would unlock an unlocked HostMutex")
            guard.mutex.locked = False  # type: ignore[union-attr]

    def cf93_release_ref_no_return(self, frame: Frame350) -> None:
        """CF93: release the slot4 shared ref and leave slot2 untouched."""
        self.heap.get(frame.get(4), Ref).value = None  # type: ignore[union-attr]

    def cf94_get_thread_local_object(self, frame: Frame350) -> None:
        """CF94: write the native TLS-derived object pointer to ``*slot4``.

        ``0x1305E4`` obtains/initializes a pthread TLS cell, refreshes its
        object at TLS ``+0x10``, then stores that pointer at the caller's out
        address.  Object contents and TLS lifetime are environmental, so a
        replay must supply the matching pointer provider.  Slot2 is untouched.
        """
        if self.thread_local_ptr_provider is None:
            raise ManagedVmError(
                "CF94 requires thread_local_ptr_provider from matching replay state"
            )
        out = self.heap.get(frame.get(4), HostOutPointer350)
        out.value = u64(self.thread_local_ptr_provider())  # type: ignore[union-attr]

    def cf95_pthread_mutex_lock(self, frame: Frame350) -> None:
        """CF95: forward slot4 to ``pthread_mutex_lock`` and return its W0."""
        frame.set(2, self.mutex_lock_provider(frame.get(4)) & 0xffff_ffff)

    def cf79_json_add_number(self, frame: Frame350) -> None:
        """CF79: ``cJSON_AddNumberToObject(slot4, slot5, double-slot2)``."""
        target = self.heap.get(frame.get(4), (dict, HostCjsonObject350))
        self._add_cjson_member(target, self._c_string_data(frame.get(5)), frame.doubles[2])  # type: ignore[arg-type]
        frame.set(2, 1)

    def cf85_cjson_add_string_field(self, frame: Frame350) -> None:
        """CF85: add ``cstr(slot6)`` below the cJSON pointer at ``slot4 + 8``.

        Wrapper ``0x16FEA0`` loads slots 4--6, invokes ``0x123AF4``, then
        stores its boolean result in slot2.  ``0x123AF4`` first dereferences
        its object receiver at ``+8`` and reaches ``0x10D5A8``.  That helper
        creates a cJSON item with type ``0x10`` (string), copies slot6 through
        ``strdup``, and attaches it using slot5 as the member name.  Either a
        NULL key/value or a NULL ``+8`` object makes the native helper return
        false without changing the parent; the host keeps that behavior.
        """
        if frame.get(5) == 0 or frame.get(6) == 0:
            frame.set(2, 0)
            return
        target = self._cjson_field_target(frame.get(4))
        if target is None:
            frame.set(2, 0)
            return
        self._add_cjson_member(
            target,
            self._c_string_data(frame.get(5)),
            self._c_string_data(frame.get(6)).decode("utf-8", "replace"),
        )
        frame.set(2, 1)

    def cf87_cjson_add_bool_field(self, frame: Frame350) -> None:
        """CF87: add ``bool(slot6 & 1)`` below the cJSON pointer at ``slot4 + 8``.

        ``0x16FF2C`` masks slot6 to one bit and passes the result to
        ``0x123C94``.  Its ``0x10D448`` helper allocates a cJSON item marked
        type 1 (false) or 2 (true), then attaches it under the slot5 C-string
        key.  The wrapper writes the attach-success boolean to slot2.
        """
        if frame.get(5) == 0:
            frame.set(2, 0)
            return
        target = self._cjson_field_target(frame.get(4))
        if target is None:
            frame.set(2, 0)
            return
        self._add_cjson_member(target, self._c_string_data(frame.get(5)), bool(frame.get(6) & 1))
        frame.set(2, 1)

    def cf88_cjson_print_unformatted_to_ref(self, frame: Frame350) -> None:
        """CF88: print cJSON at ``slot5 + 8`` into the shared-string slot4.

        ``0x16FF8C`` fetches slots 4/5 and calls ``0x123DE8(slot5, x8=slot4)``.
        The target loads ``*(void **)(slot5 + 8)``, calls ``0x10CBF8`` with
        its formatting flag set to zero, then builds a `std::string` from the
        result and assigns a new shared control block at slot4 through
        ``0x4788C``.  The flag-zero call is the unformatted cJSON print path;
        the wrapper leaves managed slot2 untouched.  A NULL cJSON pointer
        reaches the native empty-string constructor, which is represented by
        an empty host string.
        """
        destination = self.heap.get(frame.get(4), Ref)
        source = self.heap.get(frame.get(5), HostCjsonObjectField350)
        cjson = source.cjson  # type: ignore[union-attr]
        destination.value = "" if cjson is None else self._cjson_print_unformatted(cjson)  # type: ignore[union-attr]

    def _native_global_u32(self, index: int) -> int:
        try:
            return self.native_globals_u32[index] & 0xffff_ffff
        except KeyError as exc:
            raise ManagedVmError(
                f"CF{index:02d} requires native_globals_u32[{index}] from the matching replay state"
            ) from exc

    def _native_global_ptr(self, index: int) -> int:
        try:
            return u64(self.native_globals_ptr[index])
        except KeyError as exc:
            raise ManagedVmError(
                f"CF{index:02d} requires native_globals_ptr[{index}] from the matching replay state"
            ) from exc

    def cf80_native_global_u32_a(self, frame: Frame350) -> None:
        """CF80: return the 32-bit SO global loaded by native helper 0xA28BC."""
        frame.set(2, self._native_global_u32(80))

    def cf81_native_global_u32_b(self, frame: Frame350) -> None:
        """CF81: return the 32-bit SO global loaded by native helper 0xA28C8."""
        frame.set(2, self._native_global_u32(81))

    def cf82_native_vmp_u32_global_2c1040(self, frame: Frame350) -> None:
        """CF82: return the replay-supplied word from VMP state at ``+0x2c1040``.

        Wrapper ``0x16FE08`` obtains no managed input slots, calls ``0xD9574``,
        and stores its low 32-bit result in slot2.  That helper executes the
        fixed native VMP program ``0x1EC670``; the observed path reads a word
        from the SO's mutable ``.bss + 0x2c1040`` and writes it into the VMP
        output window.  The surrounding VM state and other branches are not
        generalized here, so a matching replay supplies the resulting word
        explicitly through ``native_globals_u32[82]``.
        """
        frame.set(2, self._native_global_u32(82))

    def cf72_native_global_u32_acquire(self, frame: Frame350) -> None:
        """CF72: acquire-load the 32-bit SO global read at ``0x13E044``."""
        frame.set(2, self._native_global_u32(72))

    def cf73_locked_context_qword_40(self, frame: Frame350) -> None:
        """CF73: return the raw context qword observed at ``slot4 + 0x40``.

        ``0x16FC1C`` resolves only slot4 and calls ``0x15064C``.  That helper
        enters its native lock/guard path, loads ``[X19,#0x40]`` at
        ``0x150678``, unlocks, and returns the unmodified qword through
        managed slot2.  A single-threaded host replay represents precisely
        that readable field; contention and the surrounding native lock state
        remain intentionally outside the raw-memory bridge.
        """
        frame.set(2, self.memory.read(frame.get(4) + 0x40, 8))

    def cf83_native_global_u32_c(self, frame: Frame350) -> None:
        """CF83: return the 32-bit SO global loaded by ``0xBEFC4``."""
        frame.set(2, self._native_global_u32(83))

    def cf86_urlsafe_base64_decode_check(self, frame: Frame350) -> None:
        try:
            text = self._data(frame.get(4)).decode("ascii")
            text = text.replace("-", "+").replace("_", "/")
            text += "=" * (-len(text) % 4)
            decoded = base64.b64decode(text, validate=True)
        except (UnicodeDecodeError, ValueError, binascii.Error):
            decoded = b""
        frame.set(2, int(bool(decoded)))

    def cf96_locked_shared_ref_assign(self, frame: Frame350) -> None:
        """CF96 assigns the shared reference but its wrapper has no slot2 write."""
        self.heap.get(frame.get(4), Ref).value = self.heap.get(frame.get(5), Ref).value  # type: ignore[union-attr]

    def cf97_free_slot4(self, frame: Frame350) -> None:
        """CF97: tail-call ``free(slot4)`` and preserve all managed slots.

        Wrapper ``0x170110`` fetches only slot4, then calls ``0x1C2F48``;
        that address is a direct branch to ``0x1C2F44 -> free@plt``.  F8's
        source-work bytes can still be observed at this boundary because they
        occupy the released allocation, but CF97 does not construct or return
        those bytes.  ``SparseMemory.free`` deliberately accepts only a raw
        allocation produced by the host model, or NULL.
        """
        self.memory.free(frame.get(4))

    def cf98_format_alloc_string(self, frame: Frame350) -> None:
        out = self.heap.get(frame.get(4), Ref)
        fmt = self.heap.text(frame.get(5))
        out.value = fmt
        frame.set(2, 0)

    def cf99_format_default_string(self, frame: Frame350) -> None:
        self._set_block_data(self._block(frame.get(4)), b"0" if frame.get(5) == 0 else self.heap.text(frame.get(5)).encode())
        frame.set(2, frame.get(4))

    def cf100_format_memblock(self, frame: Frame350) -> None:
        fmt = self.heap.text(frame.get(5))
        args = (frame.get(6) & 0xffffffff, self.heap.text(frame.get(7)), self.heap.text(frame.get(8)))
        # Observed sign-path format is %u-%s-%s. Keep other format strings explicit.
        if fmt != "%u-%s-%s":
            raise ManagedVmError(f"CF100 unsupported format {fmt!r}")
        self._set_block_data(self._block(frame.get(4)), ("%u-%s-%s" % args).encode())
        frame.set(2, frame.get(4))

    def cf101_asprintf_one_arg(self, frame: Frame350) -> None:
        """CF101: ``asprintf((char **)slot4, (char *)slot5, slot6)``.

        Wrapper ``0x170258`` obtains managed slots 4, 5 and 6, calls its
        ``0x16EA60 -> asprintf@plt`` thunk with those values as X0, X1 and X2,
        then writes W0 to managed slot2.  The host output pointer receives a
        synthetic heap pointer to the NUL-free C-string body.  This mirrors
        the visible allocation/result contract while deliberately leaving
        allocation failure and undefined multi-vararg formats as hard errors.
        """
        out = self.heap.get(frame.get(4), HostOutPointer350)
        fmt = self._c_string_data(frame.get(5))
        rendered = self._format_asprintf_one_arg(fmt, frame.get(6))
        if len(rendered) > 0x7fff_ffff:
            raise ManagedVmError("CF101 formatted output exceeds signed-int asprintf result")
        # ``MemBlock`` is the host's byte-addressable owned-buffer analogue;
        # its contents omit the implicit native trailing NUL.
        out.value = self.heap.put(MemBlock(rendered))  # type: ignore[union-attr]
        frame.set(2, len(rendered))


@dataclass
class ExecutionResult:
    halted: bool
    steps: int
    pc: int
    return_value: int
    op_counts: Counter[int]
    cf_counts: Counter[int]
    program_call_counts: Counter[int]


class ManagedVmRuntime350:
    def __init__(
        self,
        program: Program,
        memory: SparseMemory | None = None,
        heap: HostHeap | None = None,
        cf: CfRegistry350 | None = None,
        program_call_handler: ManagedProgramCallHandler350 | None = None,
    ) -> None:
        self.program = program
        self.memory = memory or SparseMemory()
        self.heap = heap or HostHeap()
        self.cf = cf or CfRegistry350(self.memory, self.heap)
        self.program_call_handler = program_call_handler

    def run(self, frame: Frame350 | None = None, max_steps: int = 1_000_000) -> ExecutionResult:
        frame = frame or Frame350()
        f32 = [0.0] * 32
        f64 = [0.0] * 32
        pc = 0
        op_counts: Counter[int] = Counter()
        cf_counts: Counter[int] = Counter()
        program_call_counts: Counter[int] = Counter()
        for step in range(max_steps):
            if not 0 <= pc < len(self.program.records):
                raise ManagedVmError(f"{self.program.name}: pc {pc} outside {len(self.program.records)} records")
            rec = self.program.records[pc]
            if rec.index != pc:
                raise ManagedVmError("non-contiguous program records")
            op_counts[rec.op] += 1
            a, b, c, d = rec.a, rec.b, rec.c, rec.d
            next_pc = pc + 1
            s = frame.get
            w = frame.set

            if rec.op == 0x00: w(c, sx(((s(b) & 0xff) << 8) | ((s(b) >> 8) & 0xff), 32))
            elif rec.op == 0x01: w(b, s(a) ^ rec.u16)
            elif rec.op == 0x02: w(c, s(b) ^ s(a))
            elif rec.op == 0x07:
                bits = struct.unpack("<I", struct.pack("<f", f32[b]))[0]
                self.memory.write(s(a) + rec.i16, 4, bits)
            elif rec.op == 0x08: self.memory.write(s(a) + rec.i16, 4, s(b))
            elif rec.op == 0x09: w(c, s32(s(a) - s(b)))
            elif rec.op == 0x0a: f64[d] = f64[c] - f64[b]
            elif rec.op == 0x0d: w(a, (s(b) & 0xffffffff) >> (s(c) & 31))
            elif rec.op == 0x0e: w(c, s32((s(b) & 0xffffffff) >> d))
            elif rec.op == 0x10: w(c, s32(sx(s(b), 32) >> d))
            elif rec.op == 0x13: w(c, int(s(a) < s(b)))
            elif rec.op == 0x14: w(b, int(s(a) < u64(rec.i16)))
            elif rec.op == 0x15: w(b, int(sx(s(a), 64) < rec.i16))
            elif rec.op == 0x16: w(c, int(sx(s(a), 64) < sx(s(b), 64)))
            elif rec.op == 0x18: w(c, s32((s(b) & 0xffffffff) << d))
            elif rec.op == 0x19: self.memory.write(s(a) + rec.i16, 2, s(b))
            elif rec.op == 0x1e: w(c, s(a) if s(b) else 0)
            elif rec.op == 0x1f: w(c, s(a) if not s(b) else 0)
            elif rec.op == 0x23: w(c, sx(s(b), 8))
            elif rec.op == 0x24:
                bits = struct.unpack("<Q", struct.pack("<d", f64[b]))[0]
                self.memory.write(s(a) + rec.i16, 8, bits)
            elif rec.op == 0x25: self.memory.write(s(a) + rec.i16, 8, s(b))
            elif rec.op == 0x26: self.memory.write(s(a) + rec.i16, 1, s(b))
            elif rec.op == 0x2e: w(c, s32(ror(s(b) & 0xffffffff, d, 32)))
            elif rec.op == 0x33: w(b, s(a) | rec.u16)
            elif rec.op == 0x34: w(c, s(a) | s(b))
            elif rec.op in (0x35, 0xb3): w(c, s(a) & s(b))
            elif rec.op == 0x36: w(c, ~(s(a) | s(b)))
            elif rec.op == 0x38: f64[d] = -f64[c]
            elif rec.op == 0x39: f32[d] = -f32[c]
            elif rec.op == 0x3a: w(c, (s(a) * s(b)) >> 64)
            elif rec.op == 0x3c: w(c, (sx(s(a), 64) * sx(s(b), 64)) >> 64)
            elif rec.op == 0x3e: w(c, s32(s(a) * s(b)))
            elif rec.op == 0x3f: w(c, s32((sx(s(a), 32) * sx(s(b), 32)) >> 32))
            elif rec.op == 0x50: w(b, self.memory.read(s(a) + rec.i16, 4))
            elif rec.op == 0x51:
                f32[b] = struct.unpack("<f", self.memory.read(s(a) + rec.i16, 4).to_bytes(4, "little"))[0]
            elif rec.op == 0x52: w(b, self.memory.read(s(a) + rec.i16, 4, signed=True))
            elif rec.op == 0x53: w(b, self.memory.read(rec.q1, 8) + rec.u16)
            elif rec.op == 0x54: w(b, s32(rec.u16 << 16))
            elif rec.op == 0x55: w(b, self.memory.read(s(a) + rec.i16, 2))
            elif rec.op == 0x56: w(b, self.memory.read(s(a) + rec.i16, 2, signed=True))
            elif rec.op == 0x57: w(b, self.memory.read(self.memory.read(s(a), 8) + rec.i16, 8))
            elif rec.op == 0x58: w(b, self.memory.read(s(a) + rec.i16, 8))
            elif rec.op == 0x59: w(b, self.memory.read(s(a) + rec.i16, 1))
            elif rec.op == 0x5a: w(b, self.memory.read(s(a) + rec.i16, 1, signed=True))
            elif rec.op == 0x5b:
                frame.return_value = s(a)
                return ExecutionResult(
                    True,
                    step + 1,
                    pc,
                    frame.return_value,
                    op_counts,
                    cf_counts,
                    program_call_counts,
                )
            elif rec.op == 0x5c: next_pc = self.program.resolve_indirect_pc(s(a))
            elif rec.op == 0x5e:
                if self.program.call_abi == "cf_table":
                    cf_counts[rec.u32] += 1
                    self.cf.call(rec.u32, frame)
                else:
                    program_call_counts[rec.u32] += 1
                    if self.program_call_handler is None:
                        raise UnresolvedManagedProgramCall(
                            f"{self.program.name}: record {pc:#x} invokes "
                            f"module program-table index {rec.u32} on the shared frame; "
                            "install program_call_handler rather than treating it as CF"
                        )
                    self.program_call_handler(rec.u32, frame)
            elif rec.op == 0x5f: next_pc = pc + 1 + rec.i32
            elif rec.op == 0x64: w(c, s(a) - s(b))
            elif rec.op == 0x66: w(c, s(b) >> (s(a) & 63))
            elif rec.op == 0x67: w(c, s(b) >> (d + 32))
            elif rec.op == 0x68: w(c, s(b) >> d)
            elif rec.op == 0x6c: w(c, s(b) << (s(a) & 63))
            elif rec.op == 0x6d: w(c, s(b) << (d + 32))
            elif rec.op == 0x6e: w(c, s(b) << d)
            elif rec.op == 0x72: w(c, rol(s(b), 32 - d))
            elif rec.op == 0x73: w(c, ror(s(b), d))
            elif rec.op in (0x84, 0x86): w(c, s(a) + s(b))
            elif rec.op == 0x85: w(b, s(a) + rec.i16)
            elif rec.op == 0x87: w(b, self.memory.read(s(a) + rec.i16, 4))
            elif rec.op == 0x8d: w(b, s(a) & rec.u16)
            elif rec.op == 0x8f: f64[d] = float(s32(s(c)))
            elif rec.op == 0x90: f64[d] = float(f32[c])
            elif rec.op == 0xa1: w(c, 64 if s(a) == 0 else 64 - s(a).bit_length())
            elif rec.op == 0xa2:
                value = (~s(a)) & 0xffffffff
                w(c, 32 if value == 0 else 32 - value.bit_length())
            elif rec.op == 0xa7:
                if s(a) != s(b): next_pc = pc + 1 + rec.i16
            elif rec.op == 0xa9:
                if sx(s(a), 64) < 1: next_pc = pc + 1 + rec.i16
            elif rec.op == 0xae:
                if s(a) == s(b): next_pc = pc + 1 + rec.i16
            elif rec.op == 0xb2: w(b, s(a) & rec.u16)
            elif rec.op == 0xb4: w(c, s32(s(a) + s(b)))
            elif rec.op == 0xb5: w(b, s32(s(a) + rec.i16))
            else:
                raise UnsupportedManagedOpcode(f"{self.program.name}: record {pc:#x}, opcode {rec.op:#04x}, operands {a:02x} {b:02x} {c:02x} {d:02x}")
            pc = next_pc
        raise ManagedVmError(f"{self.program.name}: step limit {max_steps} reached")


def coverage(program: Program) -> dict[str, object]:
    supported = {0x00, 0x01, 0x02, 0x07, 0x08, 0x09, 0x0a, 0x0d, 0x0e, 0x10, 0x13, 0x14, 0x15, 0x16, 0x18, 0x19, 0x1e, 0x1f, 0x23, 0x24, 0x25, 0x26, 0x2e, 0x33, 0x34, 0x35, 0x36, 0x38, 0x39, 0x3a, 0x3c, 0x3e, 0x3f, 0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5a, 0x5b, 0x5c, 0x5e, 0x5f, 0x64, 0x66, 0x67, 0x68, 0x6c, 0x6d, 0x6e, 0x72, 0x73, 0x84, 0x85, 0x86, 0x87, 0x8d, 0x8f, 0x90, 0xa1, 0xa2, 0xa7, 0xa9, 0xae, 0xb2, 0xb3, 0xb4, 0xb5}
    counts = Counter(record.op for record in program.records)
    call_counts = Counter(
        record.u32 for record in program.records if record.op == 0x5e
    )
    return {
        "program": program.name,
        "records": len(program.records),
        "supported_records": sum(n for op, n in counts.items() if op in supported),
        "unsupported_records": sum(n for op, n in counts.items() if op not in supported),
        "unsupported_ops": {
            f"0x{op:02x}": n for op, n in sorted(counts.items()) if op not in supported
        },
        "call_abi": program.call_abi,
        "call_target_kind": "cf_index" if program.call_abi == "cf_table" else "program_index",
        "call_targets": {str(index): count for index, count in sorted(call_counts.items())},
    }


def selftest() -> None:
    def record(op: int, a: int = 0, b: int = 0, c: int = 0, d: int = 0) -> bytes:
        raw = bytearray(RECORD_SIZE)
        raw[0] = op
        raw[8:12] = bytes((a, b, c, d))
        return bytes(raw)

    # XOR64 s2=s1^s0; RET s2. This checks binary parsing, slots, ALU and RET.
    raw = bytearray(RECORD_SIZE * 2)
    raw[0] = 0x02
    raw[8:12] = bytes((0, 1, 2, 0))
    raw[RECORD_SIZE] = 0x5b
    raw[RECORD_SIZE + 8] = 2
    program = Program("selftest", [Record(0, bytes(raw[:RECORD_SIZE])), Record(1, bytes(raw[RECORD_SIZE:]))])
    frame = Frame350()
    frame.set(0, 0x55)
    frame.set(1, 0xaa)
    result = ManagedVmRuntime350(program).run(frame)
    assert result.halted and result.return_value == 0xff
    memory, heap = SparseMemory(), HostHeap()
    registry = CfRegistry350(memory, heap)
    left, right, out = heap.put(MemBlock(b"ab")), heap.put(MemBlock(b"cd")), heap.put(MemBlock())
    frame = Frame350()
    frame.set(4, out)
    frame.set(5, left)
    frame.set(6, right)
    registry.call(30, frame)
    assert heap.get(out, MemBlock).data == b"abcd"
    # CF00's register shuffle is non-obvious: W1/slot5 is the signed output
    # length, while W2/slot6 supplies only the low fill byte.  Exercise both
    # low32 truncation and the native negative-length clear path.
    cf00_output = heap.put(MemBlock(b"stale", capacity=8))
    cf00_frame = Frame350()
    cf00_frame.set(2, 0xA11CE)
    cf00_frame.set(4, cf00_output)
    cf00_frame.set(5, 0x1_0000_0009)
    cf00_frame.set(6, 0xA2)
    registry.call(0, cf00_frame)
    cf00_value = heap.get(cf00_output, MemBlock)
    assert cf00_value.data == b"\xa2" * 9 and cf00_value.capacity == 16
    assert cf00_frame.get(2) == 0xA11CE
    cf00_frame.set(5, 0xFFFF_FFFF)
    cf00_frame.set(6, 0x11)
    registry.call(0, cf00_frame)
    assert cf00_value.data == b"" and cf00_value.capacity == 16
    assert cf00_frame.get(2) == 0xA11CE
    # CF02's F1 plumbing is fully known even though the flattened body is
    # not. The provider sees exact raw bytes (including NUL), low32 lengths,
    # and the CF00-created 0x20-filled output before one atomic writeback.
    cf02_memory, cf02_heap = SparseMemory(), HostHeap()
    cf02_output = cf02_memory.alloc(5)
    cf02_source = cf02_memory.alloc(5)
    cf02_auxiliary = cf02_memory.alloc(3)
    cf02_memory.map(cf02_output, b"\x20" * 5)
    cf02_memory.map(cf02_source, b"A\0B!?")
    cf02_memory.map(cf02_auxiliary, b"\0xy")
    cf02_seen: list[tuple[bytes, bytes, int, bytes, int]] = []

    def cf02_provider(
        output_initial: bytes,
        source: bytes,
        source_length: int,
        auxiliary: bytes,
        auxiliary_length: int,
    ) -> bytes:
        cf02_seen.append((
            output_initial, source, source_length, auxiliary, auxiliary_length
        ))
        return bytes.fromhex("de ad 00 be ef")

    cf02_registry = CfRegistry350(
        cf02_memory, cf02_heap, cf02_transform_provider=cf02_provider
    )
    cf02_frame = Frame350()
    cf02_frame.set(2, 0xA11CE)
    cf02_frame.set(4, cf02_output)
    cf02_frame.set(5, cf02_source)
    cf02_frame.set(6, 0x7_0000_0005)
    cf02_frame.set(7, cf02_auxiliary)
    cf02_frame.set(8, 0x9_0000_0003)
    cf02_registry.call(2, cf02_frame)
    assert cf02_seen == [(b"\x20" * 5, b"A\0B!?", 5, b"\0xy", 3)]
    assert bytes(cf02_memory.read(cf02_output + offset, 1) for offset in range(5)) == (
        bytes.fromhex("de ad 00 be ef")
    )
    assert cf02_frame.get(2) == 0xA11CE
    assert [cf02_frame.get(index) for index in range(4, 9)] == [
        cf02_output, cf02_source, 0x7_0000_0005, cf02_auxiliary, 0x9_0000_0003
    ]
    # CF01 has the same F0 raw ABI but a distinct flattened body/provider.
    # Prove a CF02 callback cannot silently stand in for it.
    cf01_output = cf02_memory.alloc(4)
    cf01_source = cf02_memory.alloc(4)
    cf01_auxiliary = cf02_memory.alloc(2)
    cf02_memory.map(cf01_output, b"\x20" * 4)
    cf02_memory.map(cf01_source, b"\0pq!")
    cf02_memory.map(cf01_auxiliary, b"z\0")
    cf01_seen: list[tuple[bytes, bytes, int, bytes, int]] = []

    def cf01_provider(
        output_initial: bytes,
        source: bytes,
        source_length: int,
        auxiliary: bytes,
        auxiliary_length: int,
    ) -> bytes:
        cf01_seen.append((
            output_initial, source, source_length, auxiliary, auxiliary_length
        ))
        return b"\x01\x02\x03\x04"

    cf01_frame = Frame350()
    cf01_frame.set(2, 0xB10C)
    cf01_frame.set(4, cf01_output)
    cf01_frame.set(5, cf01_source)
    cf01_frame.set(6, 0x5_0000_0004)
    cf01_frame.set(7, cf01_auxiliary)
    cf01_frame.set(8, 0x6_0000_0002)
    CfRegistry350(
        cf02_memory, cf02_heap, cf01_transform_provider=cf01_provider
    ).call(1, cf01_frame)
    assert cf01_seen == [(b"\x20" * 4, b"\0pq!", 4, b"z\0", 2)]
    assert bytes(cf02_memory.read(cf01_output + offset, 1) for offset in range(4)) == b"\x01\x02\x03\x04"
    assert cf01_frame.get(2) == 0xB10C
    cf01_before = bytes(cf02_memory.read(cf01_output + offset, 1) for offset in range(4))
    try:
        CfRegistry350(
            cf02_memory, cf02_heap, cf02_transform_provider=cf02_provider
        ).call(1, cf01_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF01 fell back to the distinct CF02 provider")
    assert bytes(cf02_memory.read(cf01_output + offset, 1) for offset in range(4)) == cf01_before
    assert cf01_frame.get(2) == 0xB10C
    # Missing, throwing, and malformed providers must not partially alter the
    # raw destination or managed slot2.
    cf02_before = bytes(cf02_memory.read(cf02_output + offset, 1) for offset in range(5))
    try:
        CfRegistry350(cf02_memory, cf02_heap).call(2, cf02_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF02 fabricated a flattened transform without a provider")
    assert bytes(cf02_memory.read(cf02_output + offset, 1) for offset in range(5)) == cf02_before
    assert cf02_frame.get(2) == 0xA11CE
    cf02_bad_registry = CfRegistry350(
        cf02_memory, cf02_heap, cf02_transform_provider=lambda *_: b"bad"
    )
    try:
        cf02_bad_registry.call(2, cf02_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF02 accepted a wrong-length provider result")
    assert bytes(cf02_memory.read(cf02_output + offset, 1) for offset in range(5)) == cf02_before
    assert cf02_frame.get(2) == 0xA11CE
    cf02_short_output = cf02_memory.alloc(4)
    cf02_memory.map(cf02_short_output, b"keep")
    cf02_short_frame = Frame350()
    cf02_short_frame.set(2, 0xD00D)
    cf02_short_frame.set(4, cf02_short_output)
    cf02_short_frame.set(5, cf02_source)
    cf02_short_frame.set(6, 5)
    cf02_short_frame.set(7, cf02_auxiliary)
    cf02_short_frame.set(8, 3)
    cf02_provider_called = [False]

    def unexpected_cf02_provider(*_: object) -> bytes:
        cf02_provider_called[0] = True
        return b"never"

    try:
        CfRegistry350(
            cf02_memory, cf02_heap, cf02_transform_provider=unexpected_cf02_provider
        ).call(2, cf02_short_frame)
    except MemoryFault:
        pass
    else:
        raise AssertionError("CF02 accepted a short output range")
    assert not cf02_provider_called[0]
    assert bytes(cf02_memory.read(cf02_short_output + offset, 1) for offset in range(4)) == b"keep"
    assert cf02_short_frame.get(2) == 0xD00D
    # CF03 is completely static except for the temporary native MEM_BLOCK
    # body address.  Its provider supplies that captured address as an opaque
    # value; this fixture exercises the RC4 key, address-derived stride,
    # residue-major transpose, binary NUL handling, and no-slot2 ABI.
    cf03_source = heap.put(MemBlock(bytes.fromhex("00 01 02 41 00 42")))
    cf03_output = heap.put(Ref(MemBlock(b"stale")))
    cf03_seen: list[tuple[bytes, int]] = []

    def cf03_address_provider(source: bytes, scalar: int) -> int:
        cf03_seen.append((source, scalar))
        return 0x1234_5678

    cf03_registry = CfRegistry350(
        memory, heap, cf03_temp_body_address_provider=cf03_address_provider
    )
    cf03_frame = Frame350()
    cf03_frame.set(2, 0xA11CE)
    cf03_frame.set(4, cf03_output)
    cf03_frame.set(5, cf03_source)
    cf03_frame.set(6, 0xDEAD_BEEF_1122_3344)
    cf03_registry.call(3, cf03_frame)
    cf03_value = heap.get(cf03_output, Ref).value
    assert cf03_seen == [(bytes.fromhex("00 01 02 41 00 42"), 0xDEAD_BEEF_1122_3344)]
    assert isinstance(cf03_value, MemBlock)
    assert cf03_value.data == bytes.fromhex("50 87 ab 05 e7 11 e8 22 78 56 34 ae 33 31")
    assert cf03_value.capacity == 15 and cf03_frame.get(2) == 0xA11CE
    assert [cf03_frame.get(index) for index in range(4, 7)] == [
        cf03_output, cf03_source, 0xDEAD_BEEF_1122_3344
    ]
    # The replay bridge has no valid default address.  Missing and malformed
    # providers fail before replacing the hidden output or slot2.
    cf03_previous = MemBlock(b"preserve-on-provider-error")
    heap.get(cf03_output, Ref).value = cf03_previous
    try:
        CfRegistry350(memory, heap).call(3, cf03_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF03 fabricated a temporary native address")
    assert heap.get(cf03_output, Ref).value is cf03_previous
    assert cf03_frame.get(2) == 0xA11CE
    try:
        CfRegistry350(
            memory, heap, cf03_temp_body_address_provider=lambda *_: -1
        ).call(3, cf03_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF03 accepted an out-of-range temporary address")
    assert heap.get(cf03_output, Ref).value is cf03_previous
    assert cf03_frame.get(2) == 0xA11CE
    # CF29 writes a hidden REF output and must leave slot2 untouched.  Cover
    # both native result shapes; a non-one odd flag proves the wrapper masks
    # slot6 to its low bit rather than treating it as a boolean object.
    md5_source, md5_output = heap.put(MemBlock(b"abc")), heap.put(Ref(MemBlock(b"stale")))
    frame.set(2, 0xB10C)
    frame.set(4, md5_output)
    frame.set(5, md5_source)
    frame.set(6, 0)
    registry.call(29, frame)
    md5_raw = heap.get(md5_output, Ref).value
    assert isinstance(md5_raw, MemBlock)
    assert md5_raw.data == bytes.fromhex("900150983cd24fb0d6963f7d28e17f72")
    assert md5_raw.capacity == 17 and frame.get(2) == 0xB10C
    frame.set(6, 3)
    registry.call(29, frame)
    md5_hex = heap.get(md5_output, Ref).value
    assert isinstance(md5_hex, MemBlock)
    assert md5_hex.data == b"900150983cd24fb0d6963f7d28e17f72"
    assert md5_hex.capacity == 64 and frame.get(2) == 0xB10C
    # CF58 has a fully static binary RC4 path.  This neutral published vector
    # checks the KSA/zero-warmup PRGA result without using device material;
    # a second input proves embedded NUL bytes are transformed, not truncated.
    cf58_key = heap.put(MemBlock(b"Key"))
    cf58_source = heap.put(MemBlock(b"Plaintext"))
    cf58_output = heap.put(Ref(MemBlock(b"stale")))
    cf58_frame = Frame350()
    cf58_frame.set(2, 0xA11CE)
    cf58_frame.set(4, cf58_output)
    cf58_frame.set(5, cf58_source)
    cf58_frame.set(6, cf58_key)
    registry.call(58, cf58_frame)
    cf58_value = heap.get(cf58_output, Ref).value
    assert isinstance(cf58_value, MemBlock)
    assert cf58_value.data == bytes.fromhex("bb f3 16 e8 d9 40 af 0a d3")
    assert cf58_value.capacity == 10 and cf58_frame.get(2) == 0xA11CE
    cf58_frame.set(5, heap.put(MemBlock(b"\0\0")))
    registry.call(58, cf58_frame)
    cf58_nul_value = heap.get(cf58_output, Ref).value
    assert isinstance(cf58_nul_value, MemBlock) and cf58_nul_value.data == bytes.fromhex("eb 9f")
    assert cf58_frame.get(2) == 0xA11CE
    # Native empty source/key inputs clear the destination REF, not a block.
    cf58_frame.set(5, heap.put(MemBlock()))
    registry.call(58, cf58_frame)
    assert heap.get(cf58_output, Ref).value is None and cf58_frame.get(2) == 0xA11CE
    heap.get(cf58_output, Ref).value = MemBlock(b"stale-again")
    cf58_frame.set(5, cf58_source)
    cf58_frame.set(6, heap.put(MemBlock()))
    registry.call(58, cf58_frame)
    assert heap.get(cf58_output, Ref).value is None and cf58_frame.get(2) == 0xA11CE
    # A bad host operand is not a native empty-input branch; it fails before
    # replacing the hidden output or changing managed slot2.
    cf58_prior = MemBlock(b"preserve-on-host-error")
    heap.get(cf58_output, Ref).value = cf58_prior
    cf58_frame.set(5, heap.put("not-a-memblock"))
    cf58_frame.set(6, cf58_key)
    try:
        registry.call(58, cf58_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF58 accepted a non-MEM_BLOCK source")
    assert heap.get(cf58_output, Ref).value is cf58_prior
    assert cf58_frame.get(2) == 0xA11CE
    # CF35 does not fabricate VMP material: its provider sees the original
    # opaque slot5 object, scans in native entry order, writes only hidden
    # slot4, and treats a selector's full raw length as significant.
    cf35_source = {"opaque_native_vmp_context": object()}
    cf35_seen_sources: list[object] = []

    def cf35_provider(source: object) -> HostNativeVmpMaterial350:
        cf35_seen_sources.append(source)
        return HostNativeVmpMaterial350((
            None,
            (b"common_key", b"common-replay-value"),
            (b"sign_key", b"first-sign-replay-value"),
            (b"sign_key", b"later-duplicate-must-not-win"),
        ))

    cf35_registry = CfRegistry350(memory, heap, cf35_material_provider=cf35_provider)
    cf35_source_ptr = heap.put(cf35_source)
    cf35_output = heap.put(Ref(MemBlock(b"stale-output")))
    cf35_selector = heap.put(MemBlock(b"sign_key"))
    cf35_frame = Frame350()
    cf35_frame.set(2, 0xA11CE)
    cf35_frame.set(4, cf35_output)
    cf35_frame.set(5, cf35_source_ptr)
    cf35_frame.set(6, cf35_selector)
    cf35_registry.call(35, cf35_frame)
    cf35_value = heap.get(cf35_output, Ref).value
    assert cf35_seen_sources[0] is cf35_source
    assert isinstance(cf35_value, MemBlock)
    assert cf35_value.data == b"first-sign-replay-value"
    assert cf35_frame.get(2) == 0xA11CE
    # An extra NUL is a real extra selector byte, not C-string termination.
    cf35_frame.set(6, heap.put(MemBlock(b"sign_key\0")))
    cf35_registry.call(35, cf35_frame)
    assert heap.get(cf35_output, Ref).value is None and cf35_frame.get(2) == 0xA11CE
    # A missing/failed native-VMP material build is not a selector miss and
    # leaves slot4 observable state untouched, matching the native crash edge.
    unavailable_cf35_output = heap.put(Ref(MemBlock(b"preserve-on-provider-error")))
    unavailable_cf35_value = heap.get(unavailable_cf35_output, Ref).value
    unavailable_cf35 = CfRegistry350(memory, heap)
    cf35_frame.set(4, unavailable_cf35_output)
    try:
        unavailable_cf35.call(35, cf35_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF35 fabricated native-VMP material without a provider")
    assert heap.get(unavailable_cf35_output, Ref).value is unavailable_cf35_value
    assert cf35_frame.get(2) == 0xA11CE
    cstr_dst, cstr_raw = heap.put(MemBlock()), memory.alloc(3)
    memory.map(cstr_raw, b"ok\0")
    frame = Frame350()
    frame.set(4, cstr_dst)
    frame.set(5, cstr_raw)
    registry.call(9, frame)
    assert heap.get(cstr_dst, MemBlock).data == b"ok" and frame.get(2) == cstr_dst
    frame.set(2, 0xBEEF)
    frame.set(5, 17)
    registry.call(55, frame)
    assert heap.get(cstr_dst, MemBlock).capacity >= 32 and frame.get(2) == 0xBEEF
    frame.set(5, ord("!"))
    registry.call(56, frame)
    assert heap.get(cstr_dst, MemBlock).data == b"ok!" and frame.get(2) == cstr_dst
    registry = CfRegistry350(memory, heap, environment={"aid": 1128})
    frame = Frame350()
    frame.set(4, 0xDEADBEEF)  # Native CF25 ignores this slot.
    registry.call(25, frame)
    assert heap.get(frame.get(2), dict)["aid"] == 1128
    registry = CfRegistry350(memory, heap, random_u31_provider=lambda: 0xDEADBEEF)
    frame = Frame350()
    registry.call(16, frame)
    assert frame.get(2) == 0x5EADBEEF
    dst_ref, src_ref = heap.put(Ref()), heap.put(Ref("copied"))
    frame = Frame350()
    frame.set(4, dst_ref)
    frame.set(5, src_ref)
    registry.call(40, frame)
    assert heap.get(dst_ref, Ref).value == "copied" and frame.get(2) == dst_ref
    heap.get(src_ref, Ref).value = "copied-by-cf53"
    registry.call(53, frame)
    assert heap.get(dst_ref, Ref).value == "copied-by-cf53" and frame.get(2) == dst_ref
    context_fields = heap.put(RefFieldContext350({
        0x08: Ref("field-08"),
        0x18: Ref("field-18"),
        0x28: Ref("field-28"),
        0x38: Ref("field-38"),
        0x70: Ref("field-70"),
        0x80: Ref("field-80"),
        0xB0: Ref("field-b0"),
        0xD8: Ref("field-d8"),
    }, cf13_selector_count=1))
    destination = heap.put(Ref())
    frame = Frame350()
    frame.set(2, 0xA11CE)
    frame.set(4, destination)
    frame.set(5, context_fields)
    registry.call(13, frame)
    assert heap.get(destination, Ref).value == "field-08" and frame.get(2) == 0xA11CE
    heap.get(context_fields, RefFieldContext350).cf13_selector_count = 0
    registry.call(13, frame)
    assert heap.get(destination, Ref).value == "field-80" and frame.get(2) == 0xA11CE
    for cf_index, offset, expected in (
        (17, 0x38, "field-38"),
        (18, 0x70, "field-70"),
        (19, 0xD8, "field-d8"),
        (20, 0x18, "field-18"),
        (67, 0xB0, "field-b0"),
        (69, 0x28, "field-28"),
    ):
        destination = heap.put(Ref())
        frame = Frame350()
        frame.set(2, 0xA11CE)
        frame.set(4, destination)
        frame.set(5, context_fields)
        registry.call(cf_index, frame)
        assert heap.get(destination, Ref).value == expected and frame.get(2) == 0xA11CE
    released = heap.put(Ref("release-me"))
    frame = Frame350()
    frame.set(2, 0xA11CE)
    frame.set(4, released)
    registry.call(21, frame)
    assert heap.get(released, Ref).value is None and frame.get(2) == 0xA11CE
    # CF22--CF24 share explicit identity input but retain their differing
    # native lifetimes: CF22 invokes Java on every call; CF23 and CF24 each
    # preserve the first guard-initialized result.  These are the focused
    # 350.101 F5/F8 observations, not defaults for an arbitrary application.
    identity_state = [HostSdkIdentity350(
        app_version="35.1.0",
        sdk_semver="v04.09.05",
        sdk_flavor="ml",
        sdk_platform="android",
    )]
    identity_registry = CfRegistry350(
        memory, heap, sdk_identity_provider=lambda: identity_state[0]
    )
    identity_ref = heap.put(Ref("stale"))
    identity_frame = Frame350()
    identity_frame.set(2, 0xA11CE)
    identity_frame.set(4, identity_ref)
    identity_frame.set(5, 0x5555)
    identity_registry.call(22, identity_frame)
    identity_value = heap.get(identity_ref, Ref).value
    assert isinstance(identity_value, MemBlock)
    assert identity_value.data == b"35.1.0" and identity_value.capacity == 7
    assert identity_frame.get(2) == 0xA11CE and identity_frame.get(5) == 0x5555
    identity_frame.set(4, 0x1111)
    identity_frame.set(5, 0x2222)
    identity_frame.set(6, 0x3333)
    identity_frame.set(7, 0x4444)
    identity_frame.set(8, 0x5555)
    identity_registry.call(23, identity_frame)
    assert identity_frame.get(2) == 0x0409_0500
    assert [identity_frame.get(index) for index in range(4, 9)] == [
        0x1111, 0x2222, 0x3333, 0x4444, 0x5555
    ]
    identity_registry.call(24, identity_frame)
    cached_identity_cstr = identity_frame.get(2)
    assert memory.read_c_string(cached_identity_cstr) == b"v04.09.05-ml-android"
    identity_state[0] = HostSdkIdentity350(
        app_version="36.0.0",
        sdk_semver="v01.02.03",
        sdk_flavor="el",
        sdk_platform="windows",
    )
    identity_registry.call(23, identity_frame)
    assert identity_frame.get(2) == 0x0409_0500
    identity_registry.call(24, identity_frame)
    assert identity_frame.get(2) == cached_identity_cstr
    identity_frame.set(2, 0xA11CE)
    identity_frame.set(4, identity_ref)
    identity_registry.call(22, identity_frame)
    changed_identity_value = heap.get(identity_ref, Ref).value
    assert isinstance(changed_identity_value, MemBlock)
    assert changed_identity_value.data == b"36.0.0" and identity_frame.get(2) == 0xA11CE
    empty_identity_registry = CfRegistry350(
        memory,
        heap,
        sdk_identity_provider=lambda: HostSdkIdentity350(
            app_version=None,
            sdk_semver="v04.09.05",
            sdk_flavor="ml",
            sdk_platform="android",
        ),
    )
    empty_identity_ref = heap.put(Ref("stale"))
    identity_frame.set(2, 0xA11CE)
    identity_frame.set(4, empty_identity_ref)
    empty_identity_registry.call(22, identity_frame)
    empty_identity_value = heap.get(empty_identity_ref, Ref).value
    assert isinstance(empty_identity_value, MemBlock)
    assert empty_identity_value.data == b"" and empty_identity_value.capacity == 1
    assert identity_frame.get(2) == 0xA11CE
    try:
        CfRegistry350(memory, heap).call(23, Frame350())
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF23 fabricated a SDK identity without a provider")
    trees = heap.put(HostTreeMaps350(
        pointers_at_58={0xC001: 0x7000_1234_5678},
        memblocks_at_30={0xC002: MemBlock(b"tree-value")},
    ))
    frame = Frame350()
    frame.set(4, trees)
    frame.set(5, 0xC001)
    registry.call(74, frame)
    assert frame.get(2) == 0x7000_1234_5678
    tree_output = heap.put(MemBlock(b"stale"))
    frame.set(2, 0xB10C)
    frame.set(4, tree_output)
    frame.set(5, trees)
    frame.set(6, 0xC002)
    registry.call(84, frame)
    assert heap.get(tree_output, MemBlock).data == b"tree-value" and frame.get(2) == 0xB10C
    frame.set(6, 0xC003)
    registry.call(84, frame)
    assert heap.get(tree_output, MemBlock).data == b"" and frame.get(2) == 0xB10C
    uuid_registry = CfRegistry350(
        memory, heap, cf76_random_bytes_provider=lambda: bytes(range(16))
    )
    uuid_ref, second_uuid_ref = heap.put(Ref()), heap.put(Ref())
    frame.set(2, 0xB10C)
    frame.set(4, uuid_ref)
    uuid_registry.call(76, frame)
    uuid_value = heap.get(uuid_ref, Ref).value
    assert isinstance(uuid_value, MemBlock)
    assert uuid_value.data == b"00102030-4050-4607-8809-0a0b0c0d0e0f"
    frame.set(4, second_uuid_ref)
    uuid_registry.call(76, frame)
    assert heap.get(second_uuid_ref, Ref).value is uuid_value and frame.get(2) == 0xB10C
    triplet = heap.put(MemBlockTriplet350(
        at_20=MemBlock(b"a"), at_38=MemBlock(b"bb"), at_50=MemBlock(b"ccc"),
    ))
    frame = Frame350()
    frame.set(2, 0xB10C)
    frame.set(4, triplet)
    registry.call(50, frame)
    assert all(not block.data and block.capacity == 8
               for block in heap.get(triplet, MemBlockTriplet350).members_in_native_init_order())
    assert frame.get(2) == 0xB10C
    registry.call(52, frame)
    assert all(not block.data and block.capacity == 0
               for block in heap.get(triplet, MemBlockTriplet350).members_in_native_destroy_order())
    assert frame.get(2) == 0xB10C
    frame.set(4, dst_ref)
    frame.set(5, src_ref)
    frame.set(2, 0x1234)
    registry.call(96, frame)
    assert frame.get(2) == 0x1234
    frame.set(2, 0x5678)
    registry.call(62, frame)
    assert heap.get(dst_ref, Ref).value == "copied-by-cf53" and frame.get(2) == 0x5678
    registry = CfRegistry350(
        memory,
        heap,
        process_id_provider=lambda: 0x1_2345_6789,
        parent_process_id_provider=lambda: 0x2_89AB_CDEF,
        thread_pointer_provider=lambda: 0xE4FF_F700,
        current_time_millis_provider=lambda: 1_788_136_882_999,
        native_globals_u32={
            72: 0x1_C0FFEE01,
            80: 0x1_ABCDEF01,
            81: 0x12345678,
            82: 0x1_71AC15A0,
            83: 0x1_2468ACE0,
        },
        native_globals_ptr={51: 0x7BAD_F00D_1234},
        thread_local_ptr_provider=lambda: 0x7BAD_F00D_5678,
    )
    frame = Frame350()
    registry.call(68, frame)
    assert frame.get(2) == 0x2345_6789
    registry.call(70, frame)
    assert frame.get(2) == 0x89AB_CDEF
    registry.call(71, frame)
    assert frame.get(2) == 0xE4FF_F700
    # CF82 takes no managed arguments.  Its captured result is mutable native
    # VMP/.bss state, so verify it comes only from the explicit replay word
    # and that it does not disturb unrelated slots.
    frame.set(2, 0xA11CE)
    frame.set(4, 0x4444)
    frame.set(5, 0x5555)
    frame.set(6, 0x6666)
    registry.call(82, frame)
    assert frame.get(2) == 0x71AC15A0
    assert [frame.get(index) for index in (4, 5, 6)] == [0x4444, 0x5555, 0x6666]
    missing_cf82_frame = Frame350()
    missing_cf82_frame.set(2, 0xD00D)
    try:
        CfRegistry350(memory, heap).call(82, missing_cf82_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF82 fabricated native VMP/.bss state")
    assert missing_cf82_frame.get(2) == 0xD00D
    cjson = HostCjsonObject350()
    cjson_field = heap.put(HostCjsonObjectField350(cjson))
    cjson_direct = heap.put(cjson)
    cjson_key, cjson_string = memory.alloc(4), memory.alloc(6)
    memory.map(cjson_key, b"dyn\0")
    memory.map(cjson_string, b"value\0")
    frame.set(4, cjson_field)
    frame.set(5, cjson_key)
    frame.set(6, cjson_string)
    registry.call(85, frame)
    assert frame.get(2) == 1 and cjson.members == [("dyn", "value")]
    frame.set(5, heap.put("flag"))
    frame.set(6, 3)  # CF87 passes only the native low bit.
    registry.call(87, frame)
    assert frame.get(2) == 1 and cjson.members[-1] == ("flag", True)
    frame.set(5, cjson_key)
    frame.doubles[2] = 12.5
    frame.set(4, cjson_direct)
    registry.call(79, frame)
    assert frame.get(2) == 1 and cjson.members[-1] == ("dyn", 12.5)
    cjson_text = heap.put(Ref("stale"))
    frame.set(2, 0xC0FFEE)
    frame.set(4, cjson_text)
    frame.set(5, cjson_field)
    registry.call(88, frame)
    assert heap.get(cjson_text, Ref).value == '{"dyn":"value","flag":true,"dyn":12.5}'
    assert frame.get(2) == 0xC0FFEE
    # The native string wrapper refuses a NULL C-string argument and does not
    # attach an item; preserve the already accumulated object state.
    before_cjson_members = list(cjson.members)
    frame.set(4, cjson_field)
    frame.set(5, cjson_key)
    frame.set(6, 0)
    registry.call(85, frame)
    assert frame.get(2) == 0 and cjson.members == before_cjson_members
    cf101_out = heap.put(HostOutPointer350())
    cf101_fmt, cf101_arg = memory.alloc(7), memory.alloc(3)
    memory.map(cf101_fmt, b"tag:%s\0")
    memory.map(cf101_arg, b"ok\0")
    frame.set(4, cf101_out)
    frame.set(5, cf101_fmt)
    frame.set(6, cf101_arg)
    registry.call(101, frame)
    assert frame.get(2) == 6
    assert heap.get(heap.get(cf101_out, HostOutPointer350).value, MemBlock).data == b"tag:ok"
    frame.set(5, heap.put("%#08x"))
    frame.set(6, 0x2A)
    registry.call(101, frame)
    assert frame.get(2) == 8
    assert heap.get(heap.get(cf101_out, HostOutPointer350).value, MemBlock).data == b"0x00002a"
    cf97_raw = memory.alloc(4)
    memory.map(cf97_raw, b"tmp\0")
    frame.set(2, 0xC0FFEE)
    frame.set(4, cf97_raw)
    registry.call(97, frame)
    assert frame.get(2) == 0xC0FFEE
    try:
        memory.read(cf97_raw, 1)
        raise AssertionError("CF97 did not release raw allocation")
    except MemoryFault:
        pass
    context = memory.alloc(0xEC)
    memory.write(context + 0xE8, 4, 3)
    frame.set(4, context)
    registry.call(65, frame)
    assert frame.get(2) == 1
    cf73_context = memory.alloc(0x48)
    memory.write(cf73_context + 0x40, 8, 0x7BAD_F00D_1234_5678)
    frame.set(4, cf73_context)
    registry.call(73, frame)
    assert frame.get(2) == 0x7BAD_F00D_1234_5678
    text, endptr = memory.alloc(7), memory.alloc(8)
    memory.map(text, b" 0x2aZ\0")
    frame.set(4, text)
    frame.set(5, endptr)
    frame.set(6, 0)
    registry.call(57, frame)
    assert frame.get(2) == 42 and memory.read(endptr, 8) == text + 5
    crc_input = heap.put(MemBlock(b"123456789"))
    frame.set(4, crc_input)
    registry.call(59, frame)
    assert frame.get(2) == 0xA2
    registry.call(77, frame)
    assert frame.get(2) == 0xCBF4_3926
    # CF78 is a hidden-output C-string parser bridge.  Its parser is supplied
    # explicitly because native acceptance (BOM/control whitespace, prefix
    # success, duplicate keys) is not interchangeable with a generic JSON
    # library.  This fixture proves raw bytes and NUL termination reach that
    # provider unchanged, and that an ordered duplicate-key tree replaces
    # slot4 while managed slot2 stays untouched.
    cf78_source = memory.alloc(len(b'\xef\xbb\xbf {"alpha":7}\0ignored'))
    memory.map(cf78_source, b'\xef\xbb\xbf {"alpha":7}\0ignored')
    cf78_seen: list[bytes] = []

    def cf78_parser(raw: bytes) -> HostIdItem350 | None:
        cf78_seen.append(raw)
        return HostIdItem350(0x40, children=(
            HostIdItem350(8, value=7, key=b"alpha"),
            HostIdItem350(0x10, value=b"again", key=b"alpha"),
        ))

    cf78_registry = CfRegistry350(
        memory, heap, cf78_json_parser_provider=cf78_parser
    )
    cf78_output = heap.put(HostRefIdItemWrap350())
    cf78_frame = Frame350()
    cf78_frame.set(2, 0xA11CE)
    cf78_frame.set(4, cf78_output)
    cf78_frame.set(5, cf78_source)
    cf78_registry.call(78, cf78_frame)
    cf78_wrap = heap.get(cf78_output, HostRefIdItemWrap350).wrap
    assert cf78_seen == [b'\xef\xbb\xbf {"alpha":7}']
    assert cf78_wrap is not None and cf78_wrap.root.type_code == 0x40
    assert [(child.key, child.value) for child in cf78_wrap.root.children] == [
        (b"alpha", 7), (b"alpha", b"again")
    ]
    assert cf78_frame.get(2) == 0xA11CE
    # A provider ``None`` represents native parse failure and must still
    # replace the destination with a fresh empty-object root.
    cf78_parse_fail_output = heap.put(HostRefIdItemWrap350())
    cf78_parse_fail_frame = Frame350()
    cf78_parse_fail_frame.set(2, 0xB10C)
    cf78_parse_fail_frame.set(4, cf78_parse_fail_output)
    cf78_parse_fail_frame.set(5, heap.put(MemBlock(b"not-json\0tail")))
    cf78_fail_registry = CfRegistry350(
        memory, heap, cf78_json_parser_provider=lambda raw: None
    )
    cf78_fail_registry.call(78, cf78_parse_fail_frame)
    cf78_fail_wrap = heap.get(cf78_parse_fail_output, HostRefIdItemWrap350).wrap
    assert cf78_fail_wrap is not None and cf78_fail_wrap.root.type_code == 0x40
    assert cf78_parse_fail_frame.get(2) == 0xB10C
    # Native NULL bypasses parsing and follows the same empty-object path.
    cf78_null_output = heap.put(HostRefIdItemWrap350())
    cf78_null_frame = Frame350()
    cf78_null_frame.set(2, 0xC0FFEE)
    cf78_null_frame.set(4, cf78_null_output)
    cf78_null_frame.set(5, 0)
    CfRegistry350(memory, heap).call(78, cf78_null_frame)
    cf78_null_wrap = heap.get(cf78_null_output, HostRefIdItemWrap350).wrap
    assert cf78_null_wrap is not None and cf78_null_wrap.root.type_code == 0x40
    assert cf78_null_frame.get(2) == 0xC0FFEE
    # Non-NULL input without a native-compatible provider is a host error
    # before the hidden output is changed, rather than a fabricated parse.
    cf78_prior_wrap = HostIdItemWrap350(HostIdItem350(0x10, value=b"old"))
    cf78_blocked_output = heap.put(HostRefIdItemWrap350(cf78_prior_wrap))
    cf78_blocked_frame = Frame350()
    cf78_blocked_frame.set(2, 0xD00D)
    cf78_blocked_frame.set(4, cf78_blocked_output)
    cf78_blocked_frame.set(5, cf78_source)
    try:
        CfRegistry350(memory, heap).call(78, cf78_blocked_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF78 parsed non-NULL input without a provider")
    assert heap.get(cf78_blocked_output, HostRefIdItemWrap350).wrap is cf78_prior_wrap
    assert cf78_blocked_frame.get(2) == 0xD00D
    # CF27/45/46/47 are exact raw XOR-8 loops.  Use known post-decode strings
    # from the focused managed-CF trace, including the byte that callers chose
    # to use as a NUL terminator; the native loop treats it as ordinary data.
    for cf_index, plain in (
        (27, b"none\0"),
        (45, b"X-Medusa\0"),
        (46, b"X-Argus\0"),
        (47, b"sign_key\0"),
    ):
        encoded = bytes(byte ^ _CF_XOR8_KEYS[cf_index][offset & 7]
                        for offset, byte in enumerate(plain))
        xor_buffer = memory.alloc(len(encoded))
        memory.map(xor_buffer, encoded)
        frame.set(4, xor_buffer)
        frame.set(5, len(encoded))
        registry.call(cf_index, frame)
        assert frame.get(2) == xor_buffer
        assert bytes(memory.read(xor_buffer + offset, 1) for offset in range(len(plain))) == plain
    # CF36 shares the raw signed-length ABI but uses the independent D8 key.
    # Its recovered F7/F13 callers supply 8 and 9 raw bytes, so this vector
    # deliberately includes a ninth byte to cover key wrapping without
    # implying a C-string or MEM_BLOCK contract.
    cf36_buffer = memory.alloc(9)
    memory.map(cf36_buffer, bytes.fromhex("00 11 22 33 44 55 66 77 88"))
    frame.set(4, cf36_buffer)
    frame.set(5, 9)
    registry.call(36, frame)
    assert frame.get(2) == cf36_buffer
    assert bytes(memory.read(cf36_buffer + offset, 1) for offset in range(9)) == bytes.fromhex(
        "a5 01 53 f4 14 c5 87 c6 2d"
    )
    negative_xor_buffer = memory.alloc(1)
    memory.write(negative_xor_buffer, 1, 0xA5)
    frame.set(4, negative_xor_buffer)
    frame.set(5, 0xFFFF_FFFF)
    registry.call(36, frame)
    assert frame.get(2) == negative_xor_buffer and memory.read(negative_xor_buffer, 1) == 0xA5
    # CF90/CF91 are a deliberately narrow F8-only two-pass bridge.  Members
    # arrive in a different order to prove serialization follows the observed
    # descriptor table rather than Python insertion order.  The nested body is
    # explicitly opaque because its own descriptor fields remain unclosed.
    proto_memory, proto_heap = SparseMemory(), HostHeap()
    proto_registry = CfRegistry350(proto_memory, proto_heap)
    proto_message = proto_heap.put(HostProtoWireMessage350(
        0x272080,
        [
            (15, OpaqueProtoWireMessage350(0x271DD8, b"\x08\x01")),
            (4, "1128"),
            (1, b"\xaa\xbb"),
            (12, -7),
            (11, 3),
            (3, -2),
            (2, 5),
        ],
    ))
    expected_f8_wire = bytes.fromhex("0a02aabb100a18032204313132385803600d7a020801")
    proto_frame = Frame350()
    proto_frame.set(4, proto_message)
    proto_registry.call(90, proto_frame)
    assert proto_frame.get(2) == len(expected_f8_wire)
    proto_destination = proto_memory.alloc(proto_frame.get(2))
    proto_frame.set(5, proto_destination)
    proto_registry.call(91, proto_frame)
    assert proto_frame.get(2) == len(expected_f8_wire)
    assert bytes(proto_memory.read(proto_destination + offset, 1)
                 for offset in range(len(expected_f8_wire))) == expected_f8_wire
    # Deterministic local CF91 capture: the root fields are modeled directly,
    # while the two still-unclosed nested schemas remain anchored opaque wire
    # bodies.  This upgrades the F8 checkpoint from a prefix/length observation
    # to a byte-level 0x299 oracle without asserting a generic native layout.
    observed_f8_message = proto_heap.put(HostProtoWireMessage350(
        0x272080,
        [
            (1, bytes.fromhex("2d4b4fca49750d433fb5ae2c226dcc56")),
            (2, 5),
            (3, 267102815),
            (4, "1128"),
            (5, "397365608203400"),
            (6, "1588093228"),
            (7, "35.1.0"),
            (8, "v04.09.05-ml-android"),
            (9, 67699968),
            (10, bytes.fromhex("0800000000000000")),
            (12, 1788136882),
            (13, bytes.fromhex("d64fa6ee6d9921bdd27ee93b09a7300e100f3a47")),
            (14, bytes.fromhex("1f08578a515b")),
            (15, OpaqueProtoWireMessage350(
                0x271DD8, bytes.fromhex("080210bee15418bee15428bee154"),
            )),
            (17, 1788136882),
            (20, "none"),
            (21, 369),
            (23, OpaqueProtoWireMessage350(0x271F10, bytes.fromhex(
                "32137630342e30352e30342e30382d62756766697838f2c00162a60208021a04"
                "31313238220f3339373336353630383230333430302a08216e6f74736574213208"
                "216e6f747365742138fd887a40fd887a48fd887a50fd887a5a08216e6f74736574"
                "216208216e6f74736574216a08216e6f747365742170fd887a7a08216e6f747365"
                "74218501f02374c98d01f02374c99501f02374c99d01f02374c9a501f02374c9ad"
                "01f02374c9b20108216e6f7473657421b801fd887ac001fd887ac801fd887ad001"
                "a0fd9bd48a68d801fd887ae001a0fd9bd48a68e801fd887af20108216e6f747365"
                "7421fa0108216e6f7473657421820208216e6f74736574218a0208216e6f747365"
                "7421920208216e6f74736574219a0208216e6f7473657421a20208216e6f747365"
                "7421aa0208216e6f7473657421b002fd887ac002a0fd9bd48a686a007208216e6f"
                "747365742178f2c0019001848485c2139801c4b6a6a90da00184d8fa8d0f",
            ))),
            (24, "{\"cmr\":16777216,\"cmr2\":16777216,\"un_h\":4133029968,\"vpn\":0,\"kd\":0,\"fkd\":1900702622,\"pd\":256330306,\"dyn\":\"\",\"do\":0,\"tk\":true}"),
        ],
    ))
    observed_f8_wire = serialize_proto_wire_message_350(
        proto_heap.get(observed_f8_message, HostProtoWireMessage350)  # type: ignore[arg-type]
    )
    assert len(observed_f8_wire) == 0x299
    assert hashlib.sha256(observed_f8_wire).hexdigest() == (
        "e165201118d59a72fc08af30a585fe563e29b8a3241f923f2dc9c58f6b50da6e"
    )
    proto_frame.set(4, observed_f8_message)
    proto_registry.call(90, proto_frame)
    assert proto_frame.get(2) == 0x299
    observed_destination = proto_memory.alloc(proto_frame.get(2))
    proto_frame.set(5, observed_destination)
    proto_registry.call(91, proto_frame)
    assert proto_frame.get(2) == 0x299
    assert bytes(proto_memory.read(observed_destination + offset, 1)
                 for offset in range(0x299)) == observed_f8_wire
    # The separate F5 root schema has the same recovered primitive type
    # surface through field 22, but its field-15 nested target and current
    # captured values are distinct. Verify its own size/write aliases against
    # the complete deterministic 0x91 local body.
    observed_f5_message = proto_heap.put(HostProtoWireMessage350(
        0x271AD8,
        [
            (1, 538970409),
            (2, 1),
            (3, 28573955),
            (4, "1128"),
            (5, "397365608203400"),
            (6, "1588093228"),
            (7, "35.1.0"),
            (8, "v04.09.05-ml-android"),
            (9, 67699968),
            (10, bytes.fromhex("0800000000000000")),
            (12, 1788136882),
            (13, bytes.fromhex("cf03476f3b96")),
            (14, bytes.fromhex("1f08578a515b")),
            (15, OpaqueProtoWireMessage350(
                0x271980, bytes.fromhex("080210bee15418bee154"),
            )),
            (17, 1788136882),
            (20, "none"),
            (21, 369),
        ],
    ))
    observed_f5_wire = serialize_proto_wire_message_350(
        proto_heap.get(observed_f5_message, HostProtoWireMessage350)  # type: ignore[arg-type]
    )
    assert len(observed_f5_wire) == 0x91
    assert hashlib.sha256(observed_f5_wire).hexdigest() == (
        "cee115642ad18ce54df063a67c48262123edd9a688d68e2eb0d14393633b9d40"
    )
    proto_frame.set(4, observed_f5_message)
    proto_registry.call(31, proto_frame)
    assert proto_frame.get(2) == 0x91
    observed_f5_destination = proto_memory.alloc(proto_frame.get(2))
    proto_frame.set(5, observed_f5_destination)
    proto_registry.call(33, proto_frame)
    assert proto_frame.get(2) == 0x91
    assert bytes(proto_memory.read(observed_f5_destination + offset, 1)
                 for offset in range(0x91)) == observed_f5_wire
    # Native aliases share an engine, but each observed callsite has a
    # different root schema. Do not let a host F8 object silently cross into
    # the F5 pair (or the inverse).
    proto_frame.set(4, observed_f8_message)
    try:
        proto_registry.call(31, proto_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF31 accepted the F8 root schema")
    proto_frame.set(4, observed_f5_message)
    try:
        proto_registry.call(90, proto_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF90 accepted the F5 root schema")
    proto_frame.set(4, proto_message)
    # A short target is rejected before its existing bytes or the return slot
    # change.  That is a host safety check, not an invented native capacity
    # parameter.
    short_destination = proto_memory.alloc(len(expected_f8_wire) - 1)
    proto_memory.map(short_destination, b"\xcc" * (len(expected_f8_wire) - 1))
    proto_frame.set(2, 0xBEEF)
    proto_frame.set(5, short_destination)
    try:
        proto_registry.call(91, proto_frame)
    except MemoryFault:
        pass
    else:
        raise AssertionError("CF91 accepted a short output buffer")
    assert proto_frame.get(2) == 0xBEEF
    assert bytes(proto_memory.read(short_destination + offset, 1)
                 for offset in range(len(expected_f8_wire) - 1)) == b"\xcc" * (len(expected_f8_wire) - 1)
    unsupported_schema = proto_heap.put(HostProtoWireMessage350(0x272081, [(1, b"x")]))
    proto_frame.set(4, unsupported_schema)
    try:
        proto_registry.call(90, proto_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF90 accepted an unsupported proto-wire schema")
    unsupported_field = proto_heap.put(HostProtoWireMessage350(0x272080, [(25, b"x")]))
    proto_frame.set(4, unsupported_field)
    try:
        proto_registry.call(90, proto_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF90 accepted an unsupported proto-wire field")
    unobserved_repeated = proto_heap.put(HostProtoWireMessage350(
        0x272080, [(4, "first"), (4, "second")],
    ))
    proto_frame.set(4, unobserved_repeated)
    try:
        proto_registry.call(90, proto_frame)
    except ManagedVmError:
        pass
    else:
        raise AssertionError("CF90 accepted an unobserved repeated root field")
    registry.call(66, frame)
    assert frame.get(2) == 1_788_136_882
    registry.call(89, frame)
    assert frame.get(2) == 1_788_136_882_999
    registry.call(80, frame)
    assert frame.get(2) == 0xABCDEF01
    registry.call(81, frame)
    assert frame.get(2) == 0x12345678
    registry.call(51, frame)
    assert frame.get(2) == 0x7BAD_F00D_1234
    registry.call(72, frame)
    assert frame.get(2) == 0xC0FFEE01
    registry.call(83, frame)
    assert frame.get(2) == 0x2468ACE0
    empty, odd = heap.put(MemBlock()), heap.put(MemBlock(b"a"))
    frame.set(4, empty)
    registry.call(28, frame)
    assert frame.get(2) == 1
    frame.set(4, odd)
    registry.call(28, frame)
    assert frame.get(2) == 1
    frame.set(4, 0x6800)
    registry.call(39, frame)
    assert frame.get(2) == 0x6868
    mutex = heap.put(HostMutex())
    frame.set(4, mutex)
    registry.call(95, frame)
    assert frame.get(2) == 0 and heap.get(mutex, HostMutex).locked
    guard = heap.put(HostLockGuard350(heap.get(mutex, HostMutex)))
    frame.set(2, 0xD00D)
    frame.set(4, guard)
    registry.call(92, frame)
    assert heap.get(guard, HostLockGuard350).released and not heap.get(mutex, HostMutex).locked
    suppressed_guard = heap.put(HostLockGuard350(heap.get(mutex, HostMutex), state_at_10=1))
    frame.set(4, suppressed_guard)
    registry.call(92, frame)
    assert heap.get(suppressed_guard, HostLockGuard350).released and frame.get(2) == 0xD00D
    tls_out = heap.put(HostOutPointer350())
    frame.set(4, tls_out)
    registry.call(94, frame)
    assert heap.get(tls_out, HostOutPointer350).value == 0x7BAD_F00D_5678 and frame.get(2) == 0xD00D
    frame.set(4, src_ref)
    frame.set(2, 0x4321)
    registry.call(93, frame)
    assert heap.get(src_ref, Ref).value is None and frame.get(2) == 0x4321
    memory.map(0x1000, b"abc")
    frame.set(4, 0x1000)
    frame.set(5, 3)
    frame.set(6, 0x2000)
    registry.call(61, frame)
    assert bytes(memory.read(0x2000 + i, 1) for i in range(32)) == hashlib.new("sm3", b"abc").digest()
    # Keep the executable registry tied to the checked-in evidence manifest.
    # The JSON's field and item order are intentional: it is also the exact
    # --cf-manifest-out contract, so a renamed wrapper, changed entry, or an
    # accidental opaque->implemented promotion cannot hide behind a count.
    manifest_json = json.loads(
        Path(__file__).with_name("cf_bindings_350101.json").read_text(encoding="utf-8")
    )
    assert type(manifest_json) is list
    actual_manifest = registry.manifest()
    assert len(manifest_json) == len(actual_manifest) == 102
    for position, (item, binding) in enumerate(zip(manifest_json, actual_manifest)):
        assert type(item) is dict
        assert tuple(item) == ("entry", "implemented", "index", "name")
        assert type(item["index"]) is int and item["index"] == position
        assert type(item["entry"]) in (int, type(None))
        assert type(item["name"]) is str
        assert type(item["implemented"]) is bool
        assert binding == CfBinding(**item)
    assert [binding.index for binding in actual_manifest if not binding.implemented] == [64, 75]

    # CF63 is now a pure standalone body. An opaque backend remains opt-in
    # and per-CF: it permits trace-backed work without inventing semantics,
    # but a missing per-index handler fails.
    opaque_calls: list[int] = []

    def opaque_cf64(opaque_frame: Frame350) -> None:
        opaque_calls.append(64)
        opaque_frame.set(2, 0xF00D)

    registry = CfRegistry350(
        memory,
        heap,
        opaque_cf_handler=OpaqueCfBackend350({64: opaque_cf64}),
    )
    frame = Frame350()
    registry.call(64, frame)
    assert opaque_calls == [64] and frame.get(2) == 0xF00D
    try:
        registry.call(75, frame)
    except UnimplementedCfBinding:
        pass
    else:
        raise AssertionError("opaque backend accepted an unconfigured CF")

    # CF63 calls the fully dumped pure second-module F22. It reads the input
    # MEM_BLOCK only and returns low32(child.s2) through outer slot2.
    cf63_vectors = {
        b"": 0x2023_0928,
        b"\x00": 0x2AE3_73BA,
        b"\x00\x01": 0xE272_EAA3,
        b"abc": 0x716D_1D28,
        bytes(range(16)): 0xF6A0_D105,
        b"MetaSec-F22": 0x1103_E6A1,
    }
    cf63_registry = CfRegistry350(memory, heap)
    for cf63_data, cf63_expected in cf63_vectors.items():
        cf63_source = heap.put(MemBlock(cf63_data))
        cf63_frame = Frame350()
        cf63_frame.set(2, 0xDEAD_BEEF)
        cf63_frame.set(4, cf63_source)
        cf63_frame.set(5, 0xA11CE)
        cf63_registry.call(63, cf63_frame)
        assert cf63_frame.get(2) == cf63_expected
        assert heap.get(cf63_source, MemBlock).data == cf63_data  # type: ignore[union-attr]
        assert cf63_frame.get(4) == cf63_source and cf63_frame.get(5) == 0xA11CE

    # Handlers recovered from F9/F10/F11: F32 load, I32->F64, F64 math/store,
    # raw 64-bit math, a conditional branch and an indirect VM-PC branch.
    new_ops = [
        record(0x51, 1, 2), record(0x8f, 0, 0, 3, 4), record(0x8f, 0, 0, 6, 7),
        record(0x0a, 0, 4, 7, 8), record(0x24, 5, 8), record(0x64, 9, 10, 11),
        record(0x66, 9, 11, 12), record(0x5b, 12),
    ]
    memory = SparseMemory()
    f32_ptr, f64_ptr = memory.alloc(4), memory.alloc(8)
    memory.write(f32_ptr, 4, struct.unpack("<I", struct.pack("<f", 1.25))[0])
    frame = Frame350()
    for index, value in ((1, f32_ptr), (3, 3), (6, 11), (5, f64_ptr), (9, 2), (10, 14)):
        frame.set(index, value)
    result = ManagedVmRuntime350(Program("new-op-selftest", [Record(i, raw) for i, raw in enumerate(new_ops)]), memory).run(frame)
    assert result.return_value == (((2 - 14) & MASK64) >> 2)
    assert struct.unpack("<d", memory.read(f64_ptr, 8).to_bytes(8, "little"))[0] == 8.0
    branch = [record(0xa9, 0, 0, 1, 0), record(0x5b, 1), record(0x5b, 2)]
    frame = Frame350()
    frame.set(0, 0)
    frame.set(1, 0x11)
    frame.set(2, 0x22)
    assert ManagedVmRuntime350(Program("a9-selftest", [Record(i, raw) for i, raw in enumerate(branch)])).run(frame).return_value == 0x22
    indirect = [record(0x5c, 0), record(0x5b, 1), record(0x5b, 2)]
    frame = Frame350()
    frame.set(0, 0xFEED)
    frame.set(1, 1)
    frame.set(2, 2)
    assert ManagedVmRuntime350(Program("indirect-selftest", [Record(i, raw) for i, raw in enumerate(indirect)], {0xFEED: 2})).run(frame).return_value == 2

    # The primary table still routes opcode 0x5e to its CF surface.
    cf_call_memory, cf_call_heap = SparseMemory(), HostHeap()
    cf_call_registry = CfRegistry350(
        cf_call_memory,
        cf_call_heap,
        current_time_millis_provider=lambda: 222_000,
    )
    cf_call = [record(0x5e, 66), record(0x5b, 2)]
    cf_result = ManagedVmRuntime350(
        Program("cf-call-selftest", [Record(i, raw) for i, raw in enumerate(cf_call)]),
        cf_call_memory,
        cf_call_heap,
        cf_call_registry,
    ).run(Frame350())
    assert cf_result.return_value == 222
    assert cf_result.cf_counts == Counter({66: 1})
    assert cf_result.program_call_counts == Counter()

    # Opcode 0x5e is not globally synonymous with CF0..CF101.  The secondary
    # and child module tables route the same immediate to another managed
    # program on the same frame.  A program-table dump must fail closed until
    # its caller supplies that module-local bridge.
    program_call = [record(0x5e, 0x11), record(0x5b, 2)]
    nested_program = Program(
        "program-call-selftest",
        [Record(i, raw) for i, raw in enumerate(program_call)],
        call_abi="program_table",
    )
    try:
        ManagedVmRuntime350(nested_program).run(Frame350())
    except UnresolvedManagedProgramCall as exc:
        assert "program-table index 17" in str(exc)
    else:
        raise AssertionError("program-table opcode 0x5e fell through to CF dispatch")
    nested_calls: list[int] = []

    def program_call_handler(index: int, nested_frame: Frame350) -> None:
        nested_calls.append(index)
        nested_frame.set(2, 0x9876)

    nested_result = ManagedVmRuntime350(
        nested_program,
        program_call_handler=program_call_handler,
    ).run(Frame350())
    assert nested_calls == [0x11]
    assert nested_result.cf_counts == Counter()
    assert nested_result.program_call_counts == Counter({0x11: 1})
    assert nested_result.return_value == 0x9876
    nested_coverage = coverage(nested_program)
    assert nested_coverage["call_abi"] == "program_table"
    assert nested_coverage["call_target_kind"] == "program_index"
    assert nested_coverage["call_targets"] == {"17": 1}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--program-bin", type=Path)
    parser.add_argument(
        "--call-abi",
        choices=("cf_table", "program_table"),
        default="cf_table",
        help=(
            "interpret opcode 0x5e through the primary CF table (default) or "
            "a module-local managed-program table when producing coverage"
        ),
    )
    parser.add_argument("--coverage-out", type=Path)
    parser.add_argument("--cf-manifest-out", type=Path,
                        help="write the complete CF0..CF101 bridge manifest as JSON")
    parser.add_argument("--selftest", action="store_true")
    args = parser.parse_args()
    if args.selftest:
        selftest()
        print("managed_vm_runtime selftest: ok")
        return
    if args.cf_manifest_out:
        registry = CfRegistry350(SparseMemory(), HostHeap())
        args.cf_manifest_out.write_text(json.dumps(
            [binding.__dict__ for binding in registry.manifest()], indent=2, sort_keys=True) + "\n")
    if not args.program_bin:
        if args.cf_manifest_out:
            return
        parser.error("--program-bin is required unless --selftest is used")
    report = coverage(Program.from_file(args.program_bin, call_abi=args.call_abi))
    text = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.coverage_out:
        args.coverage_out.write_text(text)
    print(text, end="")


if __name__ == "__main__":
    main()
