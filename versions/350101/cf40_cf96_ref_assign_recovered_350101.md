# CF40 / CF96 shared-reference assignment — 350.101

Both bindings implement an observable host-level `Ref.value` assignment, but
their managed return ABI differs.

| CF | wrapper | slots | slot2 write |
|---|---:|---|---|
| CF40 | `0x16F3F0` | `slot4=dst`, `slot5=src` | yes: returns `slot4` |
| CF96 | `0x1700D4` | `slot4=dst`, `slot5=src` | no |

## CF40 proof

The wrapper loads slots 4 and 5, calls `0x47908`, then invokes
`managedFrameSetSlot_350(frame, 2, X0)`.  `0x47908` compares the pair's first
word, releases an existing destination control block when needed, copies both
words from source to destination, increments `src_control[0]` when non-null,
and returns the destination pointer in `X0`.

## CF96 proof

`0x1700D4` loads slots 4 and 5 and calls `0x1434A0`, then returns directly.
There is no call to `managedFrameSetSlot_350`; host code must preserve the
prior slot2 value.  Both native paths contain locking/control-block details;
the standalone runtime intentionally models only the visible reference value
transition.
