#!/usr/bin/env python3
import hashlib
import os
import re
import sys


def find_pid(name: bytes) -> int:
    for entry in os.listdir("/proc"):
        if not entry.isdigit():
            continue
        try:
            with open(f"/proc/{entry}/cmdline", "rb") as fp:
                cmd = fp.read().split(b"\0", 1)[0]
            if cmd == name:
                return int(entry)
        except Exception:
            pass
    raise SystemExit(f"no {name.decode()} pid")


def find_stagefright_exec_map(pid: int):
    with open(f"/proc/{pid}/maps", "r", encoding="utf-8", errors="replace") as fp:
        for line in fp:
            if "/system/lib64/libstagefright.so" in line and "r-xp" in line:
                m = re.match(
                    r"([0-9a-f]+)-([0-9a-f]+)\s+\S+\s+([0-9a-f]+)\s+\S+\s+\S+\s+(.*)",
                    line.strip(),
                )
                if not m:
                    raise SystemExit(f"bad map line: {line.strip()}")
                start = int(m.group(1), 16)
                end = int(m.group(2), 16)
                fileoff = int(m.group(3), 16)
                path = m.group(4)
                return start, end, fileoff, path, line.strip()
    raise SystemExit("no libstagefright r-xp map")


def main():
    pid = find_pid(b"zygote64")
    start, end, map_off, path, map_line = find_stagefright_exec_map(pid)
    # rustFrida zymbiote writes payload at the last page of this executable map.
    base = end - 0x1000
    fileoff = map_off + (base - start)
    length = int(sys.argv[1], 0) if len(sys.argv) > 1 else 4048

    with open(f"/proc/{pid}/mem", "rb", buffering=0) as mem:
        mem.seek(base)
        mem_bytes = mem.read(length)

    with open(path, "rb") as backing:
        backing.seek(fileoff)
        file_bytes = backing.read(length)
    if len(file_bytes) < length:
        file_bytes += b"\0" * (length - len(file_bytes))

    dirty = mem_bytes != file_bytes
    print(f"pid={pid}")
    print(f"map={map_line}")
    print(f"base=0x{base:x}")
    print(f"fileoff=0x{fileoff:x}")
    print(f"len={length}")
    print(f"mem_sha={hashlib.sha256(mem_bytes).hexdigest()}")
    print(f"file_sha={hashlib.sha256(file_bytes).hexdigest()}")
    print(f"dirty={'1' if dirty else '0'}")
    print(f"mem_head={mem_bytes[:32].hex()}")
    print(f"file_head={file_bytes[:32].hex()}")
    raise SystemExit(1 if dirty else 0)


if __name__ == "__main__":
    main()
