#ifndef ISA_H
#define ISA_H

#include "common.h"

// registers
// * 32 GPRs
// * 32 FPRs
// * 1  PC
// * 18 CSRs
const int csrs_count = 18;
const int regs_count = 32 + 32 + 1 + csrs_count;

typedef union {
    struct {
        uint32_t zero, ra, sp, gp, tp, t0, t1, t2, fp,
                s1, a0, a1, a2, a3, a4, a5, a6, a7,
                s2, s3, s4, s5, s6, s7, s8, s9, s10,
                s11, t3, t4, t5, t6;
        uint32_t pc;
        uint32_t ft0, ft1, ft2, ft3, ft4, ft5, ft6, ft7,
                fs0, fs1, fa0, fa1, fa2, fa3, fa4, fa5,
                fa6, fa7, fs2, fs3, fs4, fs5, fs6, fs7,
                fs8, fs9, fs10, fs11, ft8, ft9, ft10, ft11;
        uint32_t mstatus, medeleg, mideleg, mie, mip,
                mtvec, mscratch, mepc, mcause, mtval;
        uint32_t sstatus, sie, stvec, 
                sscratch, sepc, scause, stval, sip;
    };
    struct {
        uint32_t array[regs_count];
    };
    struct {
        uint32_t gpr[32];
    };
    struct {
        uint32_t fpr[65];
    };
} qemu_regs_t;


// instructions
typedef union {
    uint32_t val;

    // R-type
    // struct {
    //     uint32_t opcode: 7;
    //     uint32_t funct7: 7;
    //     uint32_t rs2: 5;
    //     uint32_t rs1: 5;
    //     uint32_t funct3: 3;
    //     uint32_t rd: 5;
    // } r_inst_t;

    // I-type
    struct{
        uint32_t opcode: 7;
        uint32_t rd: 5;
        uint32_t funct3: 3;
        uint32_t rs1: 5;
        uint32_t imm: 12;
    } i_inst_t;

    // S-type
    // struct {
    //     uint32_t opcode: 7;
    //     uint32_t imm7: 7;
    //     uint32_t rs2: 5;
    //     uint32_t rs1: 5;
    //     uint32_t funct3: 3;
    //     uint32_t imm5: 5;
    // } s_inst_t;
} inst_t; // Instruction

#define UART_START 0x10000000
#define UART_END   0x10000fff

#define NREGS      32

int inst_is_load(inst_t inst);

int inst_is_load_uart(inst_t inst, qemu_regs_t *regs);

int inst_is_print(inst_t inst);

#endif