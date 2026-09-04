/*
 * Evidence-backed structured lift of managed sign programs F0, F1 and F2
 * for libmetasec_ml.so 350.101.
 *
 * Evidence:
 *   - runtime descriptors/code dump in
 *     unidbg-android/target/managed_program_dumps_350101_f0_f1_f2_20260904/
 *   - record-by-record listings beside this file
 *   - managed CF table: ../managed_cf_semantics_350101.md
 *
 * This is not a standalone replacement for libmetasec: CF00/CF01/CF02 are
 * native calls.  The goal is to make the managed orchestration and F2's
 * bytecode algorithm directly readable.
 */
#include <stdint.h>

/*
 * Only fields consumed by F0/F1 are asserted.  The real managed object has
 * ownership/refcount fields before +0x0c, so do not use this as a full ABI.
 */
typedef struct {
    uint8_t unknown_00[0x0c];
    int32_t field_0c;
    uint8_t *data_10;
} ManagedBlockView350;

/*
 * CF00 @ 0x16ea70: sub_10BFD8(slot4, slot5_length, slot6_fill_byte), create/fill a block.
 * CF01 @ 0x16eac0: five-slot flattened transform wrapper.
 * CF02 @ 0x16eb40: another five-slot flattened transform wrapper.
 *
 * The parameter order here is the post-bytecode slot order, not a claim about
 * the AArch64 ABI internal to the CF wrapper.
 */
extern void CF00_make_fill_350(ManagedBlockView350 *slot4_destination,
                                int32_t slot5_length,
                                uint64_t slot6_fill_byte);
extern void CF01_transform_350(uint8_t *slot4_output,
                                 const uint8_t *slot5_source,
                                 int32_t slot6_source_length,
                                 const uint8_t *slot7_auxiliary,
                                 int32_t slot8_auxiliary_length);
extern void CF02_transform_350(uint8_t *slot4_output,
                                 const uint8_t *slot5_source,
                                 int32_t slot6_source_length,
                                 const uint8_t *slot7_auxiliary,
                                 int32_t slot8_auxiliary_length);

/*
 * F0 descriptor: global +0x2c58d0, kind=1, body code 0x1268dc00..0x1268ded0.
 *
 * Entry slots: S4=source, S5=destination, S6=auxiliary block.
 * If either S4 or S6 is null it has no effect.  S5 is dereferenced on the
 * non-null path, matching the original code; it has no separate null check.
 */
void managed_F0_350(ManagedBlockView350 *source,
                     ManagedBlockView350 *destination,
                     ManagedBlockView350 *auxiliary)
{
    if (source == 0 || auxiliary == 0)
        return;

    /* bytecode S4=destination, S5=source->field_0c length, S6=0x20 fill; CALL CF00 */
    CF00_make_fill_350(destination, source->field_0c, 0x20);

    /*
     * bytecode then prepares:
     *   S4 = destination->data_10
     *   S5 = source->data_10
     *   S6 = source->field_0c
     *   S7 = auxiliary->data_10
     *   S8 = auxiliary->field_0c
     * and calls CF01.  No conventional S2 return is written by F0; destination
     * is the output object.
     */
    CF01_transform_350(destination->data_10, source->data_10, source->field_0c,
                        auxiliary->data_10, auxiliary->field_0c);
}

/*
 * F1 descriptor: global +0x2c58d8, kind=1, body code 0x1268df00..0x1268e1d0.
 *
 * It has the identical slot plumbing and CF00 allocation/fill step as F0.
 * Its only semantic bytecode difference is the terminal CF index: CF02,
 * rather than F0's CF01.
 */
void managed_F1_350(ManagedBlockView350 *source,
                     ManagedBlockView350 *destination,
                     ManagedBlockView350 *auxiliary)
{
    if (source == 0 || auxiliary == 0)
        return;

    CF00_make_fill_350(destination, source->field_0c, 0x20);
    CF02_transform_350(destination->data_10, source->data_10, source->field_0c,
                        auxiliary->data_10, auxiliary->field_0c);
}

static int32_t sext32_350(uint32_t value)
{
    return (int32_t)value;
}

/*
 * F2 descriptor: global +0x2c58e0, kind=1, 26 records.
 *
 * Entry: S4=bytes, S5=signed 32-bit byte count.
 * Exit:  S2=sign-extended 32-bit state.  (S31 is only the VM return address.)
 *
 * F2 deliberately alternates its recurrence on every byte.  This is a small
 * state mixer; the bytecode does not identify it as a standard named hash.
 */
int32_t managed_F2_byte_mixer_350(const uint8_t *bytes, int32_t count)
{
    uint32_t state = 0;

    if (count < 1)
        return 0;

    for (uint32_t index = 0; index != (uint32_t)count; ++index) {
        const uint32_t byte = bytes[index];
        const uint32_t old = state;

        if ((index & 1u) == 0) {
            /* records 8..13 */
            state = byte ^ old ^ (old << 7) ^ (old >> 3);
        } else {
            /* records 15..21 */
            state = ~(((old << 11) | byte) ^ (old >> 5) ^ old);
        }
    }

    return sext32_350(state);
}
