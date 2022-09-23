#pragma once
#include "common.h"

namespace pipeline
{
    enum class op_unit_t
    {
        alu,
        mul,
        div,
        lsu,
        bru,
        csr
    };

    enum class arg_src_t
    {
        reg,
        imm,
        disable
    };

    enum class op_t
    {
        add,
        addi,
        _and,
        andi,
        auipc,
        csrrc,
        csrrci,
        csrrs,
        csrrsi,
        csrrw,
        csrrwi,
        ebreak,
        ecall,
        fence,
        fence_i,
        lui,
        _or,
        ori,
        sll,
        slli,
        slt,
        slti,
        sltiu,
        sltu,
        sra,
        srai,
        srl,
        srli,
        sub,
        _xor,
        xori,
        beq,
        bge,
        bgeu,
        blt,
        bltu,
        bne,
        jal,
        jalr,
        div,
        divu,
        rem,
        remu,
        lb,
        lbu,
        lh,
        lhu,
        lw,
        sb,
        sh,
        sw,
        mul,
        mulh,
        mulhsu,
        mulhu,
        mret
    };

    enum class alu_op_t
    {
        add,
        _and,
        auipc,
        ebreak,
        ecall,
        fence,
        fence_i,
        lui,
        _or,
        sll,
        slt,
        sltu,
        sra,
        srl,
        sub,
        _xor
    };

    enum class bru_op_t
    {
        beq,
        bge,
        bgeu,
        blt,
        bltu,
        bne,
        jal,
        jalr,
        mret
    };

    enum class div_op_t
    {
        div,
        divu,
        rem,
        remu
    };

    enum class lsu_op_t
    {
        lb,
        lbu,
        lh,
        lhu,
        lw,
        sb,
        sh,
        sw
    };

    enum class mul_op_t
    {
        mul,
        mulh,
        mulhsu,
        mulhu
    };

    enum class csr_op_t
    {
        csrrc,
        csrrs,
        csrrw
    };

    typedef struct phy_regfile_item_t
    {
        uint32_t value;
        //bool valid;
    }phy_regfile_item_t;
}