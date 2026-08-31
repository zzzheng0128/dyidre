#include <inttypes.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/*
 * A lightweight ARM64 instruction decoding playground that demonstrates
 * category-based opcode dispatch, operand extraction, and execution using
 * a virtual CPU context. Each 32-bit instruction encodes a primary category
 * (data transfer, arithmetic, logic, control, compare) alongside the
 * register identifiers needed by each handler.
 */

#define ARM64_GPR_COUNT 32
#define ARM64_MEMORY_SIZE 1024

#if defined(__GNUC__) || defined(__clang__)
#define FORCE_INLINE static inline __attribute__((always_inline))
#define MAYBE_UNUSED __attribute__((unused))
#else
#define FORCE_INLINE static inline
#define MAYBE_UNUSED
#endif

typedef struct {
	uint64_t regs[ARM64_GPR_COUNT];
	uint8_t memory[ARM64_MEMORY_SIZE];
	uint64_t pc;
	bool zero_flag;
	bool negative_flag;
} Arm64Context;

FORCE_INLINE uint32_t extract_field(uint32_t value, uint32_t shift, uint32_t width)
{
	return (value >> shift) & ((1u << width) - 1u);
}

FORCE_INLINE uint64_t load_u64(const Arm64Context *ctx, uint32_t addr)
{
	if (addr + sizeof(uint64_t) > ARM64_MEMORY_SIZE) {
		fprintf(stderr, "[arm64-sim] load out-of-range @0x%x\n", addr);
		return 0;
	}

	uint64_t value = 0;
	memcpy(&value, ctx->memory + addr, sizeof(value));
	return value;
}

FORCE_INLINE void store_u64(Arm64Context *ctx, uint32_t addr, uint64_t value)
{
	if (addr + sizeof(uint64_t) > ARM64_MEMORY_SIZE) {
		fprintf(stderr, "[arm64-sim] store out-of-range @0x%x\n", addr);
		return;
	}

	memcpy(ctx->memory + addr, &value, sizeof(value));
}

FORCE_INLINE void update_nz_flags(Arm64Context *ctx, uint64_t result)
{
	ctx->zero_flag = (result == 0);
	ctx->negative_flag = (result >> 63) & 0x1;
}

FORCE_INLINE void handle_data_transfer(Arm64Context *ctx, uint32_t insn)
{
	const uint32_t subop = extract_field(insn, 24, 5);
	const uint8_t rd = extract_field(insn, 0, 5);
	const uint8_t rn = extract_field(insn, 5, 5);
	const uint8_t rm = extract_field(insn, 10, 5);
	const uint16_t imm12 = extract_field(insn, 12, 12);

	switch (subop) {
	case 0x00: { /* LDR literal */
		const uint32_t addr = imm12 % ARM64_MEMORY_SIZE;
		ctx->regs[rd] = load_u64(ctx, addr);
		break;
	}
	case 0x01: { /* LDR (immediate offset) */
		const uint32_t base = (uint32_t)(ctx->regs[rn] + imm12);
		ctx->regs[rd] = load_u64(ctx, base % ARM64_MEMORY_SIZE);
		break;
	}
	case 0x02: { /* STR (immediate offset) */
		const uint32_t base = (uint32_t)(ctx->regs[rn] + imm12);
		store_u64(ctx, base % ARM64_MEMORY_SIZE, ctx->regs[rm]);
		break;
	}
	case 0x03: { /* MOV (register) */
		ctx->regs[rd] = ctx->regs[rn];
		break;
	}
	default:
		fprintf(stderr, "[arm64-sim] unknown data-transfer subop 0x%x\n", subop);
		break;
	}
}

FORCE_INLINE void handle_arithmetic(Arm64Context *ctx, uint32_t insn)
{
	const uint32_t subop = extract_field(insn, 23, 6);
	const uint8_t rd = extract_field(insn, 0, 5);
	const uint8_t rn = extract_field(insn, 5, 5);
	const uint8_t rm = extract_field(insn, 10, 5);
	const uint16_t imm12 = extract_field(insn, 15, 12);

	switch (subop) {
	case 0x00: { /* ADD */
		const uint64_t result = ctx->regs[rn] + ctx->regs[rm];
		ctx->regs[rd] = result;
		update_nz_flags(ctx, result);
		break;
	}
	case 0x01: { /* SUB */
		const uint64_t result = ctx->regs[rn] - ctx->regs[rm];
		ctx->regs[rd] = result;
		update_nz_flags(ctx, result);
		break;
	}
	case 0x02: { /* MUL */
		const uint64_t result = ctx->regs[rn] * ctx->regs[rm];
		ctx->regs[rd] = result;
		update_nz_flags(ctx, result);
		break;
	}
	case 0x03: { /* ADD immediate */
		const uint64_t result = ctx->regs[rn] + imm12;
		ctx->regs[rd] = result;
		update_nz_flags(ctx, result);
		break;
	}
	case 0x04: { /* SUB immediate */
		const uint64_t result = ctx->regs[rn] - imm12;
		ctx->regs[rd] = result;
		update_nz_flags(ctx, result);
		break;
	}
	default:
		fprintf(stderr, "[arm64-sim] unknown arithmetic subop 0x%x\n", subop);
		break;
	}
}

FORCE_INLINE void handle_logical(Arm64Context *ctx, uint32_t insn)
{
	const uint32_t subop = extract_field(insn, 23, 6);
	const uint8_t rd = extract_field(insn, 0, 5);
	const uint8_t rn = extract_field(insn, 5, 5);
	const uint8_t rm = extract_field(insn, 10, 5);
	const uint8_t shift = extract_field(insn, 16, 6);

	switch (subop) {
	case 0x00:
		ctx->regs[rd] = ctx->regs[rn] & ctx->regs[rm];
		break;
	case 0x01:
		ctx->regs[rd] = ctx->regs[rn] | ctx->regs[rm];
		break;
	case 0x02:
		ctx->regs[rd] = ctx->regs[rn] ^ ctx->regs[rm];
		break;
	case 0x03:
		ctx->regs[rd] = ctx->regs[rn] << (shift & 0x3F);
		break;
	case 0x04:
		ctx->regs[rd] = ctx->regs[rn] >> (shift & 0x3F);
		break;
	default:
		fprintf(stderr, "[arm64-sim] unknown logical subop 0x%x\n", subop);
		break;
	}

	update_nz_flags(ctx, ctx->regs[rd]);
}

FORCE_INLINE void handle_control_flow(Arm64Context *ctx, uint32_t insn)
{
	const uint32_t subop = extract_field(insn, 25, 4);
	const int32_t imm19 = (int32_t)(extract_field(insn, 0, 19) << 13) >> 13; /* sign-extend */

	switch (subop) {
	case 0x0: /* B */
		ctx->pc += (int64_t)imm19 * 4;
		break;
	case 0x1: /* BL */
		ctx->regs[30] = ctx->pc;
		ctx->pc += (int64_t)imm19 * 4;
		break;
	case 0x2: /* B.cond via second-level decode */
	default: {
		const uint8_t condition = extract_field(insn, 19, 4);
		switch (condition) {
		case 0x0: /* EQ */
			if (ctx->zero_flag) {
				ctx->pc += (int64_t)imm19 * 4;
			}
			break;
		case 0x1: /* NE */
			if (!ctx->zero_flag) {
				ctx->pc += (int64_t)imm19 * 4;
			}
			break;
		case 0xb: /* LT (negative != overflow). Approx via negative flag */
			if (ctx->negative_flag) {
				ctx->pc += (int64_t)imm19 * 4;
			}
			break;
		default:
			fprintf(stderr, "[arm64-sim] unsupported branch condition 0x%x\n", condition);
			break;
		}
		break;
	}
	}
}

FORCE_INLINE void handle_compare(Arm64Context *ctx, uint32_t insn)
{
	const uint32_t subop = extract_field(insn, 23, 6);
	const uint8_t rn = extract_field(insn, 5, 5);
	const uint8_t rm = extract_field(insn, 10, 5);
	const uint16_t imm12 = extract_field(insn, 15, 12);

	switch (subop) {
	case 0x00: { /* CMP */
		const uint64_t result = ctx->regs[rn] - ctx->regs[rm];
		update_nz_flags(ctx, result);
		break;
	}
	case 0x01: { /* CMN */
		const uint64_t result = ctx->regs[rn] + ctx->regs[rm];
		update_nz_flags(ctx, result);
		break;
	}
	case 0x02: { /* CMP immediate */
		const uint64_t result = ctx->regs[rn] - imm12;
		update_nz_flags(ctx, result);
		break;
	}
	case 0x03: { /* TST */
		const uint64_t result = ctx->regs[rn] & ctx->regs[rm];
		update_nz_flags(ctx, result);
		break;
	}
	default:
		fprintf(stderr, "[arm64-sim] unknown compare subop 0x%x\n", subop);
		break;
	}
}

void decode_and_execute_arm64_stream(const uint32_t *bytecode,
									 size_t instruction_count,
									 Arm64Context *ctx)
{
	if (!bytecode || !ctx) {
		fprintf(stderr, "[arm64-sim] invalid arguments\n");
		return;
	}

	for (size_t i = 0; i < instruction_count; ++i) {
		const uint32_t insn = bytecode[i];
		const uint8_t category = extract_field(insn, 29, 3);

		switch (category) {
		case 0x0:
			handle_data_transfer(ctx, insn);
			break;
		case 0x1:
			handle_arithmetic(ctx, insn);
			break;
		case 0x2:
			handle_logical(ctx, insn);
			break;
		case 0x3:
			handle_control_flow(ctx, insn);
			break;
		case 0x4:
			handle_compare(ctx, insn);
			break;
		default:
			fprintf(stderr, "[arm64-sim] unknown primary opcode 0x%x\n", category);
			break;
		}

		ctx->pc += 4;
	}
}

FORCE_INLINE void arm64_context_reset(Arm64Context *ctx, uint64_t seed)
{
	if (!ctx) {
		return;
	}

	for (uint32_t i = 0; i < ARM64_GPR_COUNT; ++i) {
		ctx->regs[i] = seed + i;
	}

	memset(ctx->memory, 0, sizeof(ctx->memory));
	ctx->pc = 0;
	ctx->zero_flag = false;
	ctx->negative_flag = false;
}

FORCE_INLINE uint32_t MAYBE_UNUSED encode_data_transfer(uint8_t subop,
				      uint8_t rd,
				      uint8_t rn,
				      uint8_t rm,
				      uint16_t imm12)
{
	return (0x0u << 29) |
	       ((uint32_t)subop << 24) |
	       ((uint32_t)imm12 << 12) |
	       ((uint32_t)rm << 10) |
	       ((uint32_t)rn << 5) |
	       rd;
}

FORCE_INLINE uint32_t MAYBE_UNUSED encode_arithmetic(uint8_t subop,
				    uint8_t rd,
				    uint8_t rn,
				    uint8_t rm,
				    uint16_t imm12)
{
	return (0x1u << 29) |
	       ((uint32_t)subop << 23) |
	       ((uint32_t)imm12 << 15) |
	       ((uint32_t)rm << 10) |
	       ((uint32_t)rn << 5) |
	       rd;
}

FORCE_INLINE uint32_t MAYBE_UNUSED encode_logical(uint8_t subop,
				uint8_t rd,
				uint8_t rn,
				uint8_t rm,
				uint8_t shift)
{
	return (0x2u << 29) |
	       ((uint32_t)subop << 23) |
	       ((uint32_t)shift << 16) |
	       ((uint32_t)rm << 10) |
	       ((uint32_t)rn << 5) |
	       rd;
}

FORCE_INLINE uint32_t MAYBE_UNUSED encode_control(uint8_t subop, int32_t imm19, uint8_t condition)
{
	return (0x3u << 29) |
	       ((uint32_t)subop << 25) |
	       ((uint32_t)condition << 19) |
	       ((uint32_t)(imm19 & 0x7FFFF));
}

FORCE_INLINE uint32_t MAYBE_UNUSED encode_compare(uint8_t subop,
			       uint8_t rn,
			       uint8_t rm,
			       uint16_t imm12)
{
	return (0x4u << 29) |
	       ((uint32_t)subop << 23) |
	       ((uint32_t)imm12 << 15) |
	       ((uint32_t)rm << 10) |
	       ((uint32_t)rn << 5);
}

int main(void)
{
	Arm64Context ctx;
	arm64_context_reset(&ctx, 0);

	static const uint8_t program_bytes[] = {
		0x20, 0x00, 0x00, 0x03,
		0x00, 0x00, 0x88, 0x21,
		0x02, 0x0C, 0x80, 0x40,
		0x40, 0x10, 0x00, 0x80,
		0x02, 0x00, 0x00, 0x60,
	};
	// encode_data_transfer(0x03, 0, 1, 0, 0), /* MOV X0, X1 */
	// encode_arithmetic(0x03, 0, 0, 0, 16),   /* ADD X0, #16 */
	// encode_logical(0x01, 2, 0, 3, 0),       /* ORR X2, X0, X3 */
	// encode_compare(0x00, 2, 4, 0),          /* CMP X2, X4 */
	// encode_control(0x0, 2, 0),              /* B +8 bytes */

	_Static_assert((sizeof(program_bytes) % sizeof(uint32_t)) == 0,
		       "program_bytes length must be 4-byte aligned");

	const size_t program_len_bytes = sizeof(program_bytes);
	const size_t instruction_count = program_len_bytes / sizeof(uint32_t);
	uint32_t program[instruction_count];
	memcpy(program, program_bytes, program_len_bytes);

	printf("Program bytecode (%zu bytes):\n", program_len_bytes);
	for (size_t i = 0; i < program_len_bytes; ++i) {
		printf("0x%02X%s", program_bytes[i], (i + 1 == program_len_bytes) ? "\n\n" : ((i % 16 == 15) ? "\n" : " "));
	}

	decode_and_execute_arm64_stream(program, instruction_count, &ctx);

	printf("X0=%" PRIu64 "\n", ctx.regs[0]);
	printf("X2=%" PRIu64 "\n", ctx.regs[2]);
	printf("ZF=%d NF=%d PC=%" PRIu64 "\n",
	       ctx.zero_flag,
	       ctx.negative_flag,
	       ctx.pc);

	return 0;
}
