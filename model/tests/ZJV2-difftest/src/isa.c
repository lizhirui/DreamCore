#include "isa.h"
#include "dut.h"

int inst_is_load(inst_t inst) {
    return inst.i_inst_t.opcode == 0x3;
}


int inst_is_load_uart(inst_t inst, qemu_regs_t *regs) {
    uint32_t rs1 = inst.i_inst_t.rs1;
    uint64_t addr = inst.i_inst_t.imm + regs->gpr[rs1];
    if (inst_is_load(inst) && UART_START <= addr && addr <= UART_END) {
        // printf("[DEBUG] uart load addr: 0x%016lx, pc: 0x%016lx\n", addr, regs->pc);
        // printf("rs1: 0x%016lx, imm: 0x%08x\n", regs->gpr[rs1], inst.i_inst_t.imm);
        return 1;
    } else {
        return 0;
    }
}

int inst_is_print(inst_t inst) {
    return inst.val == 0x7b ? 1 : 0;
}
