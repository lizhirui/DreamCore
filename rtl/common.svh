`ifndef __COMMON_SVH__
`define __COMMON_SVH__
    `include "config.svh"

    package riscv_exception_t;
        typedef enum logic[`REG_DATA_WIDTH - 1:0]
        {
            instruction_address_misaligned = 'b0,
            instruction_access_fault,
            illegal_instruction,
            breakpoint,
            load_address_misaligned,
            load_access_fault,
            store_amo_address_misaligned,
            store_amo_access_fault,
            environment_call_from_u_mode,
            environment_call_from_s_mode,
            reserved_10,
            environment_call_from_m_mode,
            instruction_page_fault,
            load_page_fault,
            reserved_14,
            store_amo_page_fault
        }_type;
    endpackage

    package riscv_interrupt_t;
        typedef enum logic[`REG_DATA_WIDTH - 1:0]
        {
            user_software = 'b0,
            supervisor_software,
            reserved_software,
            machine_software,
            user_timer,
            supervisor_timer,
            reserved_timer,
            machine_timer,
            user_external,
            supervisor_external,
            reserved_external,
            machine_external
        }_type;
    endpackage

    package op_unit_t;
        typedef enum logic[2:0]
        {
            alu,
            mul,
            div,
            lsu,
            bru,
            csr
        }_type;
    endpackage

    package arg_src_t;
        typedef enum logic[1:0]
        {
            _reg,
            imm,
            _disable
        }_type;
    endpackage

    package op_t;
        typedef enum logic[5:0]
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
        }_type;
    endpackage

    `define FUNCTION_UNIT_OP_WIDTH 4

    package alu_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
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
        }_type;
    endpackage

    package bru_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
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
        }_type;
    endpackage

    package csr_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
        {
            csrrc,
            csrrs,
            csrrw
        }_type;
    endpackage

    package div_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
        {
            div,
            divu,
            rem,
            remu
        }_type;
    endpackage

    package lsu_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
        {
            lb,
            lbu,
            lh,
            lhu,
            lw,
            sb,
            sh,
            sw
        }_type;
    endpackage

    package mul_op_t;
        typedef enum logic[`FUNCTION_UNIT_OP_WIDTH - 1:0]
        {
            mul,
            mulh,
            mulhsu,
            mulhu
        }_type;
    endpackage

    typedef union packed
    {
        alu_op_t::_type alu_op;
        bru_op_t::_type bru_op;
        csr_op_t::_type csr_op;
        div_op_t::_type div_op;
        lsu_op_t::_type lsu_op;
        mul_op_t::_type mul_op;
        logic[`FUNCTION_UNIT_OP_WIDTH - 1:0] raw_data;
    }sub_op_t;

    `define REG_ADDR_WIDTH 5

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;
        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;
    }fetch_decode_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }decode_rename_pack_t;
    
    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }rename_readreg_op_info_t;

    typedef struct packed
    {
        rename_readreg_op_info_t[`RENAME_WIDTH - 1:0] op_info;
    }rename_readreg_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;
        logic[`REG_DATA_WIDTH - 1:0] src1_value;
        logic src1_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;
        logic[`REG_DATA_WIDTH - 1:0] src2_value;
        logic src2_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }readreg_issue_op_info_t;

    typedef struct packed
    {
        readreg_issue_op_info_t[`READREG_WIDTH - 1:0] op_info;
    }readreg_issue_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;
        logic[`REG_DATA_WIDTH - 1:0] src1_value;
        logic src1_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;
        logic[`REG_DATA_WIDTH - 1:0] src2_value;
        logic src2_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;
        logic[`ADDR_WIDTH - 1:0] lsu_addr;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }issue_execute_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic bru_jump;
        logic[`ADDR_WIDTH - 1:0] bru_next_pc;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;
        logic[`REG_DATA_WIDTH - 1:0] src1_value;
        logic src1_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;
        logic[`REG_DATA_WIDTH - 1:0] src2_value;
        logic src2_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;
        logic[`REG_DATA_WIDTH - 1:0] rd_value;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;
        logic[`REG_DATA_WIDTH - 1:0] csr_newvalue;
        logic csr_newvalue_valid;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }execute_wb_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic bru_jump;
        logic[`ADDR_WIDTH - 1:0] bru_next_pc;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;
        logic[`REG_DATA_WIDTH - 1:0] src1_value;
        logic src1_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;
        logic[`REG_DATA_WIDTH - 1:0] src2_value;
        logic src2_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;
        logic[`REG_DATA_WIDTH - 1:0] rd_value;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;
        logic[`REG_DATA_WIDTH - 1:0] csr_newvalue;
        logic csr_newvalue_valid;

        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }wb_commit_op_info_t;

    typedef struct packed
    {
        wb_commit_op_info_t[`EXECUTE_UNIT_NUM - 1:0] op_info;
    }wb_commit_pack_t;

    typedef struct packed
    {
        logic idle;
    }decode_feedback_pack_t;

    typedef struct packed
    {
        logic idle;
    }rename_feedback_pack_t;

    typedef struct packed
    {
        logic stall;
    }issue_feedback_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`PHY_REG_ID_WIDTH - 1:0] phy_id;
        logic[`REG_DATA_WIDTH - 1:0] value;
    }execute_feedback_channel_t;

    typedef struct packed
    {
        execute_feedback_channel_t[`EXECUTE_UNIT_NUM - 1:0] channel;
    }execute_feedback_pack_t;

    typedef struct packed
    {
        logic enable;
        logic[`PHY_REG_ID_WIDTH - 1:0] phy_id;
        logic[`REG_DATA_WIDTH - 1:0] value;
    }wb_feedback_channel_t;

    typedef struct packed
    {
        wb_feedback_channel_t[`EXECUTE_UNIT_NUM - 1:0] channel;
    }wb_feedback_pack_t;

    typedef struct packed
    {
        logic enable;
        logic next_handle_rob_id_valid;
        logic[`ROB_ID_WIDTH - 1:0] next_handle_rob_id;
        logic has_exception;
        logic[`ADDR_WIDTH - 1:0] exception_pc;
        logic flush;
        logic[`COMMIT_WIDTH - 1:0][`ROB_ID_WIDTH - 1:0] committed_rob_id;
        logic[`COMMIT_WIDTH - 1:0] committed_rob_id_valid;

        logic jump_enable;
        logic jump;
        logic[`ADDR_WIDTH - 1:0] next_pc;
    }commit_feedback_pack_t;

    typedef struct packed
    {
        logic[`PHY_REG_NUM - 1:0] rat_phy_map_table_valid;
        logic[`PHY_REG_NUM - 1:0] rat_phy_map_table_visible;
        logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] global_history;
        logic[`LOCAL_BHT_WIDTH - 1:0] local_history;
    }checkpoint_t;

    typedef struct packed
    {
        logic[`PHY_REG_ID_WIDTH - 1:0] new_phy_reg_id;
        logic[`PHY_REG_ID_WIDTH - 1:0] old_phy_reg_id;
        logic old_phy_reg_id_valid;
        logic finish;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`INSTRUCTION_WIDTH - 1:0] inst_value;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;
        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;
        logic bru_op;
        logic bru_jump;
        logic[`ADDR_WIDTH - 1:0] bru_next_pc;
        logic is_mret;
        logic[`CSR_ADDR_WIDTH - 1:0] csr_addr;
        logic[`REG_DATA_WIDTH - 1:0] csr_newvalue;
        logic csr_newvalue_valid;
    }rob_item_t;

    typedef struct packed
    {
        logic enable;
        logic committed;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] addr;
        logic[`REG_DATA_WIDTH - 1:0] data;
        logic[31:0] size;
    }store_buffer_item_t;

    typedef struct packed
    {
        logic enable;
        logic[`INSTRUCTION_WIDTH - 1:0] value;
        logic valid;
        logic[`ROB_ID_WIDTH - 1:0] rob_id;
        logic[`ADDR_WIDTH - 1:0] pc;
        logic[`REG_DATA_WIDTH - 1:0] imm;
        logic has_exception;
        riscv_exception_t::_type exception_id;
        logic[`REG_DATA_WIDTH - 1:0] exception_value;

        logic predicted;
        logic predicted_jump;
        logic[`ADDR_WIDTH - 1:0] predicted_next_pc;
        logic checkpoint_id_valid;
        logic[`CHECKPOINT_ID_WIDTH - 1:0] checkpoint_id;

        logic[`REG_ADDR_WIDTH - 1:0] rs1;
        arg_src_t::_type arg1_src;
        logic rs1_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy;
        logic[`REG_DATA_WIDTH - 1:0] src1_value;
        logic src1_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rs2;
        arg_src_t::_type arg2_src;
        logic rs2_need_map;
        logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy;
        logic[`REG_DATA_WIDTH - 1:0] src2_value;
        logic src2_loaded;

        logic[`REG_ADDR_WIDTH - 1:0] rd;
        logic rd_enable;
        logic need_rename;
        logic[`PHY_REG_ID_WIDTH - 1:0] rd_phy;

        logic[`CSR_ADDR_WIDTH - 1:0] csr;
        op_t::_type op;
        op_unit_t::_type op_unit;
        sub_op_t sub_op;
    }issue_queue_item_t;

    function logic check_align(
            input logic[`ADDR_WIDTH - 1:0] addr,
            input logic[31:0] size
        );

        check_align = ((addr & (size - 1)) == 'b0) ? 'b1 : 'b0;
    endfunction

    virtual class sign_extend#(parameter IMM_LENGTH = 12);
        static function logic[`REG_DATA_WIDTH - 1:0] _do(
                input logic[IMM_LENGTH - 1:0] imm
            );

            _do = `REG_DATA_WIDTH'(signed'(imm));
        endfunction
    endclass

    virtual class sign_extend_double#(parameter IMM_LENGTH = 12);
        static function logic[`REG_DATA_WIDTH * 2 - 1:0] _do(
                input logic[IMM_LENGTH - 1:0] imm
            );
            
            _do = (`REG_DATA_WIDTH * 2)'(signed'(imm));
        endfunction
    endclass

    virtual class unsign_extend_double#(parameter IMM_LENGTH = 12);
        static function logic[`REG_DATA_WIDTH * 2 - 1:0] _do(
                input logic[IMM_LENGTH - 1:0] imm
            );
            
            _do = (`REG_DATA_WIDTH * 2)'(imm);
        endfunction
    endclass

    //let max(a, b) = (a > b) ? a : b;
    //let min(a, b) = (a < b) ? a : b;

    `define max(a, b) (((a) > (b)) ? (a) : (b))
    `define min(a, b) (((a) < (b)) ? (a) : (b))

    `define ptr_in_range(x, rptr, wptr, width) ((rptr[(width) - 1:0] < wptr[(width) - 1:0]) ? (((x) >= rptr[(width) - 1:0]) && ((x) < wptr[(width) - 1:0])) : ((((x) >= rptr[(width) - 1:0]) || ((x) < wptr[(width) - 1:0])) && (rptr != wptr)))

    `define MIP_SSIP 1
    `define MIP_MSIP 3
    `define MIP_STIP 5
    `define MIP_MTIP 7
    `define MIP_SEIP 9
    `define MIP_MEIP 11

    `define MSTATUS_SIE 1
    `define MSTATUS_MIE 3
    `define MSTATUS_SPIE 5
    `define MSTATUS_UBE 6
    `define MSTATUS_MPIE 7
    `define MSTATUS_SPP 8
    `define MSTATUS_VS 9
    `define MSTATUS_MPP 11
    `define MSTATUS_FS 13
    `define MSTATUS_CS 15
    `define MSTATUS_MPRV 17
    `define MSTATUS_SUM 18
    `define MSTATUS_MXR 19
    `define MSTATUS_TVM 20
    `define MSTATUS_TW 21
    `define MSTATUS_TSK 22
    `define MSTATUS_SD 31

    `define CSR_MVENDORID 'hf11
    `define CSR_MARCHID 'hf12
    `define CSR_MIMPID 'hf13
    `define CSR_MHARTID 'hf14
    `define CSR_MCONFIGPTR 'hf15
    `define CSR_MSTATUS 'h300
    `define CSR_MISA 'h301
    `define CSR_MIE 'h304
    `define CSR_MTVEC 'h305
    `define CSR_MCOUNTEREN 'h306
    `define CSR_MSTATUSH 'h310
    `define CSR_MSCRATCH 'h340
    `define CSR_MEPC 'h341
    `define CSR_MCAUSE 'h342
    `define CSR_MTVAL 'h343
    `define CSR_MIP 'h344
    `define CSR_CHARFIFO 'h800
    `define CSR_FINISH 'h804
    `define CSR_UARTFIFO 'h810
    `define CSR_MCYCLE 'hB00
    `define CSR_MINSTRET 'hB02
    `define CSR_MCYCLEH 'hB80
    `define CSR_MINSTRETH 'hB82

    `define CSR_BRANCHNUM 'hB03
    `define CSR_BRANCHNUMH 'hB83
    `define CSR_BRANCHPREDICTED 'hB04
    `define CSR_BRANCHPREDICTEDH 'hB84
    `define CSR_BRANCHHIT 'hB05
    `define CSR_BRANCHHITH 'hB85
    `define CSR_BRANCHMISS 'hB06
    `define CSR_BRANCHMISSH 'hB86
    `define CSR_FD 'hB07
    `define CSR_FDH 'hB87
    `define CSR_DR 'hB08
    `define CSR_DRH 'hB88
    `define CSR_IQ 'hB09
    `define CSR_IQH 'hB89
    `define CSR_IE 'hB0A
    `define CSR_IEH 'hB8A
    `define CSR_CB 'hB0B
    `define CSR_CBH 'hB8B
    `define CSR_ROB 'hB0C
    `define CSR_ROBH 'hB8C
    `define CSR_PHY 'hB0D
    `define CSR_PHYH 'hB8D
    `define CSR_RAS 'hB0E
    `define CSR_RASH 'hB8E
    `define CSR_FNF 'hB0F
    `define CSR_FNFH 'hB8F
`endif