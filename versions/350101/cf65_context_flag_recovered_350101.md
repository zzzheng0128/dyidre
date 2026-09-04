# CF65 raw-context flag — 350.101

`CF65` at `0x16FACC` reads `slot4`, calls `0x11A280`, masks the returned value
with one, and writes it to slot2.  `0x11A280` takes the same pointer, obtains a
read lock at `context + 0x100`, then performs `ldr w19, [context, #0xE8]` before
unlocking.  Therefore the observable managed ABI is:

```c
frame->slot[2] = *(uint32_t *)(frame->slot[4] + 0xE8) & 1;
```

The standalone runtime deliberately accepts a raw mapped pointer in slot4;
the lock and unrelated context layout remain outside this minimal proven ABI.
