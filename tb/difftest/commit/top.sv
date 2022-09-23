`timescale 1ns/100ps
`include "tdb_reader.svh"
`include "config.svh"
`include "common.svh"

import tdb_reader::*;

import "DPI-C" function string getenv(input string env_name);

`define assert(condition) assert((condition)) else begin #10; $finish; end
`define assert_cycle(_cycle, condition) assert((condition)) else begin $display("cycle = %0d", (_cycle)); #10; $finish; end
`define assert_equal(_cycle, _expected, _actual) assert((_expected) == (_actual)) else begin $display("cycle = %0d, expected = %0x, actual = %0x", (_cycle), (_expected), (_actual)); #10; $finish; end

module top;
    tdb_reader tdb;

    logic clk;
    logic rst;
    
    logic intif_commit_has_interrupt;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data;
    logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data;
    
    logic[`ADDR_WIDTH - 1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1];
    logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_jump;
    logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_hit;
    logic[`COMMIT_WIDTH - 1:0] commit_bp_valid;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1];
    checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop;
    logic commit_cpbuf_flush;
    
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible;
    logic commit_rat_map_table_restore;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid;
    logic commit_rat_release_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid;
    logic commit_rat_commit_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id;
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id;
    logic commit_rat_restore_map;
    
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we;

    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    
    logic commit_csrf_branch_num_add;
    logic commit_csrf_branch_predicted_add;
    logic commit_csrf_branch_hit_add;
    logic commit_csrf_branch_miss_add;
    logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id;
    logic rob_commit_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id;
    logic rob_commit_flush_tail_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id;
    rob_item_t rob_commit_flush_data;
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id;
    logic rob_commit_flush_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1];
    rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1];
    rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] commit_rob_input_data_we;

    logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id;
    logic rob_commit_retire_head_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1];
    rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid;
    logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid;

    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id;
    logic commit_phyf_flush_invalid;
    
    logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid;
    logic commit_phyf_data_valid_restore;
    
    wb_commit_pack_t wb_commit_port_data_out;

    logic rob_commit_empty;
    logic rob_commit_full;
    logic commit_rob_flush;
    
    commit_feedback_pack_t commit_feedback_pack;

    checkpoint_t cp;
    rob_item_t rob_item;
    wb_commit_op_info_t t_pack;

    integer i, j;
    longint cur_cycle;

    commit commit_inst(.*);

    localparam STATE_NORMAL = 2'b00;
    localparam STATE_FLUSH = 2'b01;
    localparam STATE_INTERRUPT_FLUSH = 2'b10;

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        intif_commit_has_interrupt = 'b0;
        intif_commit_mcause_data = 'b0;
        intif_commit_ack_data = 'b0;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            cpbuf_commit_data[i] = cp;
        end

        for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
            csrf_commit_read_data[i] = 'b0;
        end

        csrf_all_mstatus_data = 'b0;
        rob_commit_next_id_valid = 'b0;
        rob_commit_flush_tail_id = 'b0;
        rob_commit_flush_tail_id_valid = 'b0;
        rob_item.new_phy_reg_id = 'b0;
        rob_item.old_phy_reg_id = 'b0;
        rob_item.old_phy_reg_id_valid = 'b0;
        rob_item.finish = 'b0;
        rob_item.pc = 'b0;
        rob_item.inst_value = 'b0;
        rob_item.has_exception = 'b0;
        rob_item.exception_id = riscv_exception_t::instruction_address_misaligned;
        rob_item.exception_value = 'b0;
        rob_item.predicted = 'b0;
        rob_item.predicted_jump = 'b0;
        rob_item.predicted_next_pc = 'b0;
        rob_item.checkpoint_id_valid = 'b0;
        rob_item.checkpoint_id = 'b0;
        rob_item.bru_op = 'b0;
        rob_item.bru_jump = 'b0;
        rob_item.bru_next_pc = 'b0;
        rob_item.is_mret = 'b0;
        rob_item.csr_addr = 'b0;
        rob_item.csr_newvalue = 'b0;
        rob_item.csr_newvalue_valid = 'b0;
        rob_commit_flush_data = rob_item;
        rob_commit_flush_next_id = 'b0;
        rob_commit_flush_next_id_valid = 'b0;
        
        for(i = 0;i < `WB_WIDTH;i++) begin
            rob_commit_input_data[i] = rob_item;
        end

        rob_commit_retire_head_id = 'b0;
        rob_commit_retire_head_id_valid = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            rob_commit_retire_data[i] = rob_item;
        end

        rob_commit_retire_id_valid = 'b0;
        t_pack.enable = 'b0;
        t_pack.value = 'b0;
        t_pack.valid = 'b0;
        t_pack.rob_id = 'b0;
        t_pack.pc = 'b0;
        t_pack.imm = 'b0;
        t_pack.has_exception = 'b0;
        t_pack.exception_id = riscv_exception_t::instruction_address_misaligned;
        t_pack.exception_value = 'b0;
        t_pack.predicted = 'b0;
        t_pack.predicted_jump = 'b0;
        t_pack.predicted_next_pc = 'b0;
        t_pack.checkpoint_id_valid = 'b0;
        t_pack.checkpoint_id = 'b0;
        t_pack.bru_jump = 'b0;
        t_pack.bru_next_pc = 'b0;
        t_pack.rs1 = 'b0;
        t_pack.arg1_src = arg_src_t::_reg;
        t_pack.rs1_need_map = 'b0;
        t_pack.rs1_phy = 'b0;
        t_pack.src1_value = 'b0;
        t_pack.src1_loaded = 'b0;
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rs2_phy = 'b0;
        t_pack.src2_value = 'b0;
        t_pack.src2_loaded = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.rd_phy = 'b0;
        t_pack.rd_value = 'b0;
        t_pack.csr = 'b0;
        t_pack.csr_newvalue = 'b0;
        t_pack.csr_newvalue_valid = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            wb_commit_port_data_out.op_info[i] = t_pack;
        end

        rob_commit_empty = 'b0;
        rob_commit_full = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();
        
        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "cur_state", 0), commit_inst.cur_state)
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();
            
            if(!tdb.read_cur_row()) begin
                break;
            end

            intif_commit_has_interrupt = tdb.get_uint8(DOMAIN_INPUT, "intif_commit_has_interrupt", 0);
            intif_commit_mcause_data = tdb.get_uint32(DOMAIN_INPUT, "intif_commit_mcause_data", 0);
            intif_commit_ack_data = tdb.get_uint32(DOMAIN_INPUT, "intif_commit_ack_data", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                cpbuf_commit_data[i].rat_phy_map_table_valid = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "cpbuf_commit_data.rat_phy_map_table_valid", i);
                cpbuf_commit_data[i].rat_phy_map_table_visible = tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_INPUT, "cpbuf_commit_data.rat_phy_map_table_visible", i);
                cpbuf_commit_data[i].global_history = tdb.get_uint16(DOMAIN_INPUT, "cpbuf_commit_data.global_history", i);
                cpbuf_commit_data[i].local_history = tdb.get_uint16(DOMAIN_INPUT, "cpbuf_commit_data.local_history", i);
            end

            for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
                csrf_commit_read_data[i] = tdb.get_uint32(DOMAIN_INPUT, "csrf_commit_read_data", i);
            end

            csrf_all_mstatus_data = tdb.get_uint32(DOMAIN_INPUT, "csrf_all_mstatus_data", 0);
            
            rob_commit_next_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_next_id_valid", 0);

            rob_commit_flush_tail_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_tail_id", 0);
            rob_commit_flush_tail_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_tail_id_valid", 0);
            
            rob_commit_flush_data.new_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.new_phy_reg_id", 0);
            rob_commit_flush_data.old_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.old_phy_reg_id", 0);
            rob_commit_flush_data.old_phy_reg_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.old_phy_reg_id_valid", 0);
            rob_commit_flush_data.finish = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.finish", 0);
            rob_commit_flush_data.pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.pc", 0);
            rob_commit_flush_data.inst_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.inst_value", 0);
            rob_commit_flush_data.has_exception = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.has_exception", 0);
            rob_commit_flush_data.exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.exception_id", 0));
            rob_commit_flush_data.exception_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.exception_value", 0);
            rob_commit_flush_data.predicted = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.predicted", 0);
            rob_commit_flush_data.predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.predicted_jump", 0);
            rob_commit_flush_data.predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.predicted_next_pc", 0);
            rob_commit_flush_data.checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.checkpoint_id_valid", 0);
            rob_commit_flush_data.checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_flush_data.checkpoint_id", 0);
            rob_commit_flush_data.bru_op = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.bru_op", 0);
            rob_commit_flush_data.bru_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.bru_jump", 0);
            rob_commit_flush_data.bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.bru_next_pc", 0);
            rob_commit_flush_data.is_mret = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.is_mret", 0);
            rob_commit_flush_data.csr_addr = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_flush_data.csr_addr", 0);
            rob_commit_flush_data.csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_flush_data.csr_newvalue", 0);
            rob_commit_flush_data.csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_data.csr_newvalue_valid", 0);
            rob_commit_flush_next_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_next_id", 0);
            rob_commit_flush_next_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_flush_next_id_valid", 0);

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                rob_commit_input_data[i].new_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.new_phy_reg_id", i);
                rob_commit_input_data[i].old_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.old_phy_reg_id", i);
                rob_commit_input_data[i].old_phy_reg_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.old_phy_reg_id_valid", i);
                rob_commit_input_data[i].finish = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.finish", i);
                rob_commit_input_data[i].pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.pc", i);
                rob_commit_input_data[i].inst_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.inst_value", i);
                rob_commit_input_data[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.has_exception", i);
                rob_commit_input_data[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.exception_id", i));
                rob_commit_input_data[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.exception_value", i);
                rob_commit_input_data[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.predicted", i);
                rob_commit_input_data[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.predicted_jump", i);
                rob_commit_input_data[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.predicted_next_pc", i);
                rob_commit_input_data[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.checkpoint_id_valid", i);
                rob_commit_input_data[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_input_data.checkpoint_id", i);
                rob_commit_input_data[i].bru_op = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.bru_op", i);
                rob_commit_input_data[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.bru_jump", i);
                rob_commit_input_data[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.bru_next_pc", i);
                rob_commit_input_data[i].is_mret = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.is_mret", i);
                rob_commit_input_data[i].csr_addr = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_input_data.csr_addr", i);
                rob_commit_input_data[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_input_data.csr_newvalue", i);
                rob_commit_input_data[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_input_data.csr_newvalue_valid", i);
            end

            rob_commit_retire_head_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_head_id", 0);
            rob_commit_retire_head_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_head_id_valid", 0);

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                rob_commit_retire_data[i].new_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.new_phy_reg_id", i);
                rob_commit_retire_data[i].old_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.old_phy_reg_id", i);
                rob_commit_retire_data[i].old_phy_reg_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.old_phy_reg_id_valid", i);
                rob_commit_retire_data[i].finish = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.finish", i);
                rob_commit_retire_data[i].pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.pc", i);
                rob_commit_retire_data[i].inst_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.inst_value", i);
                rob_commit_retire_data[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.has_exception", i);
                rob_commit_retire_data[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.exception_id", i));
                rob_commit_retire_data[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.exception_value", i);
                rob_commit_retire_data[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.predicted", i);
                rob_commit_retire_data[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.predicted_jump", i);
                rob_commit_retire_data[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.predicted_next_pc", i);
                rob_commit_retire_data[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.checkpoint_id_valid", i);
                rob_commit_retire_data[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_retire_data.checkpoint_id", i);
                rob_commit_retire_data[i].bru_op = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.bru_op", i);
                rob_commit_retire_data[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.bru_jump", i);
                rob_commit_retire_data[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.bru_next_pc", i);
                rob_commit_retire_data[i].is_mret = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.is_mret", i);
                rob_commit_retire_data[i].csr_addr = tdb.get_uint16(DOMAIN_INPUT, "rob_commit_retire_data.csr_addr", i);
                rob_commit_retire_data[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "rob_commit_retire_data.csr_newvalue", i);
                rob_commit_retire_data[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_data.csr_newvalue_valid", i);
            end
            
            rob_commit_retire_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_retire_id_valid", 0);

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                wb_commit_port_data_out.op_info[i].enable = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.enable", i);
                wb_commit_port_data_out.op_info[i].value = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.value", i);
                wb_commit_port_data_out.op_info[i].valid = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.valid", i);
                wb_commit_port_data_out.op_info[i].rob_id = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rob_id", i);
                wb_commit_port_data_out.op_info[i].pc = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.pc", i);
                wb_commit_port_data_out.op_info[i].imm = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.imm", i);
                wb_commit_port_data_out.op_info[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.has_exception", i);
                wb_commit_port_data_out.op_info[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.exception_id", i));
                wb_commit_port_data_out.op_info[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.exception_value", i);
                wb_commit_port_data_out.op_info[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.predicted", i);
                wb_commit_port_data_out.op_info[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.predicted_jump", i);
                wb_commit_port_data_out.op_info[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.predicted_next_pc", i);
                wb_commit_port_data_out.op_info[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.checkpoint_id_valid", i);
                wb_commit_port_data_out.op_info[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "wb_commit_port_data_out.checkpoint_id", i);
                wb_commit_port_data_out.op_info[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.bru_jump", i);
                wb_commit_port_data_out.op_info[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.bru_next_pc", i);
                wb_commit_port_data_out.op_info[i].rs1 = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1", i);
                wb_commit_port_data_out.op_info[i].arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.arg1_src", i));
                wb_commit_port_data_out.op_info[i].rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1_need_map", i);
                wb_commit_port_data_out.op_info[i].rs1_phy = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1_phy", i);
                wb_commit_port_data_out.op_info[i].src1_value = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.src1_value", i);
                wb_commit_port_data_out.op_info[i].src1_loaded = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.src1_loaded", i);
                wb_commit_port_data_out.op_info[i].rs2 = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2", i);
                wb_commit_port_data_out.op_info[i].arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.arg2_src", i));
                wb_commit_port_data_out.op_info[i].rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2_need_map", i);
                wb_commit_port_data_out.op_info[i].rs2_phy = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2_phy", i);
                wb_commit_port_data_out.op_info[i].src2_value = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.src2_value", i);
                wb_commit_port_data_out.op_info[i].src2_loaded = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.src2_loaded", i);
                wb_commit_port_data_out.op_info[i].rd = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd", i);
                wb_commit_port_data_out.op_info[i].rd_enable = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd_enable", i);
                wb_commit_port_data_out.op_info[i].need_rename = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.need_rename", i);
                wb_commit_port_data_out.op_info[i].rd_phy = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd_phy", i);
                wb_commit_port_data_out.op_info[i].rd_value = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.rd_value", i);
                wb_commit_port_data_out.op_info[i].csr = tdb.get_uint16(DOMAIN_INPUT, "wb_commit_port_data_out.csr", i);
                wb_commit_port_data_out.op_info[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.csr_newvalue", i);
                wb_commit_port_data_out.op_info[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.csr_newvalue_valid", i);
                wb_commit_port_data_out.op_info[i].op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.op", i));
                wb_commit_port_data_out.op_info[i].op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.op_unit", i));
                wb_commit_port_data_out.op_info[i].sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.sub_op", i);
            end

            rob_commit_empty = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_empty", 0);
            rob_commit_full = tdb.get_uint8(DOMAIN_INPUT, "rob_commit_full", 0);

            eval();
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_intif_ack_data", 0), commit_intif_ack_data)

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_bp_valid", 0), commit_bp_valid)
            
            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(commit_bp_valid[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_bp_pc", i), commit_bp_pc[i])
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_bp_instruction", i), commit_bp_instruction[i])
                    `assert_equal(cur_cycle, (tdb.get_uint8(DOMAIN_OUTPUT, "commit_bp_jump", 0) >> i) & 'b1, commit_bp_jump[i])
                    `assert_equal(cur_cycle, (tdb.get_uint8(DOMAIN_OUTPUT, "commit_bp_hit", 0) >> i) & 'b1, commit_bp_hit[i])
                end
            end

            if((commit_inst.cur_state == STATE_NORMAL) && tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_branch_miss_add", 0)) begin
                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "commit_cpbuf_id", i), commit_cpbuf_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_cpbuf_flush", 0), commit_cpbuf_flush)

            if(!commit_cpbuf_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_cpbuf_pop", 0), commit_cpbuf_pop)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_map_table_restore", 0), commit_rat_map_table_restore)

            if(commit_rat_map_table_restore) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "commit_rat_map_table_valid", 0), commit_rat_map_table_valid)
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "commit_rat_map_table_visible", 0), commit_rat_map_table_visible)
            end

            if(tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_release_phy_id_valid", 0)) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_release_map", 0), commit_rat_release_map)
            end

            if(commit_rat_release_map) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_release_phy_id_valid", 0), commit_rat_release_phy_id_valid)

                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    if(commit_rat_release_phy_id_valid[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_release_phy_id", i), commit_rat_release_phy_id[i])
                    end
                end
            end

            if(tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_commit_phy_id_valid", 0)) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_commit_map", 0), commit_rat_commit_map)
            end

            if(commit_rat_commit_map) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_commit_phy_id_valid", 0), commit_rat_commit_phy_id_valid)

                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    if(commit_rat_commit_phy_id_valid[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_commit_phy_id", i), commit_rat_commit_phy_id[i])
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_restore_map", 0), commit_rat_restore_map)

            if(commit_rat_restore_map) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_restore_new_phy_id", 0), commit_rat_restore_new_phy_id)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rat_restore_old_phy_id", 0), commit_rat_restore_old_phy_id)
            end

            for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "commit_csrf_read_addr", i), commit_csrf_read_addr[i])
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_we", 0), commit_csrf_we)

            if(cur_cycle == 54321) begin
                $display("cur_state = %0d, next_state = %0d, normal_feedback_pack.flush = %0d, flush_feedback_pack.flush = %0d, interrupt_flush_feedback_pack.flush = %0d", commit_inst.cur_state, commit_inst.next_state, commit_inst.normal_feedback_pack.flush, commit_inst.flush_feedback_pack.flush, commit_inst.interrupt_flush_feedback_pack.flush);
                
            end

            for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
                if(commit_csrf_we[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "commit_csrf_write_addr", i), commit_csrf_write_addr[i])
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_csrf_write_data", i), commit_csrf_write_data[i])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_branch_num_add",  0), commit_csrf_branch_num_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_branch_predicted_add",  0), commit_csrf_branch_predicted_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_branch_hit_add", 0), commit_csrf_branch_hit_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_branch_miss_add", 0), commit_csrf_branch_miss_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_csrf_commit_num_add", 0), commit_csrf_commit_num_add)
            
            if(commit_inst.cur_state == STATE_NORMAL) begin
                if(tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_next_id", 0) == tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.next_handle_rob_id", 0)) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_next_id", 0), commit_rob_next_id)
                end
            end
            else begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_flush_id", 0), commit_rob_flush_id)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_flush", 0), commit_rob_flush)

            if(!commit_rob_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data_we", 0), commit_rob_input_data_we)

                for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                    if(commit_rob_input_data_we[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_id", i), commit_rob_input_id[i])
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.new_phy_reg_id", i), commit_rob_input_data[i].new_phy_reg_id)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.old_phy_reg_id", i), commit_rob_input_data[i].old_phy_reg_id)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.old_phy_reg_id_valid", i), commit_rob_input_data[i].old_phy_reg_id_valid)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.finish", i), commit_rob_input_data[i].finish)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.pc", i), commit_rob_input_data[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.inst_value", i), commit_rob_input_data[i].inst_value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.has_exception", i), commit_rob_input_data[i].has_exception)
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.exception_id", i)), commit_rob_input_data[i].exception_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.exception_value", i), commit_rob_input_data[i].exception_value)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.predicted", i), commit_rob_input_data[i].predicted)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.predicted_jump", i), commit_rob_input_data[i].predicted_jump)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.predicted_next_pc", i), commit_rob_input_data[i].predicted_next_pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.checkpoint_id_valid", i), commit_rob_input_data[i].checkpoint_id_valid)
                        `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "commit_rob_input_data.checkpoint_id", i), commit_rob_input_data[i].checkpoint_id)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.bru_op", i), commit_rob_input_data[i].bru_op)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.bru_jump", i), commit_rob_input_data[i].bru_jump)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.bru_next_pc", i), commit_rob_input_data[i].bru_next_pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.is_mret", i), commit_rob_input_data[i].is_mret)
                        `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "commit_rob_input_data.csr_addr", i), commit_rob_input_data[i].csr_addr)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_rob_input_data.csr_newvalue", i), commit_rob_input_data[i].csr_newvalue)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_input_data.csr_newvalue_valid", i), commit_rob_input_data[i].csr_newvalue_valid)
                    end
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_retire_pop", 0), commit_rob_retire_pop)

                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    if(commit_rob_retire_pop[i]) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_rob_retire_id", i), commit_rob_retire_id[i])
                    end
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_phyf_invalid", 0), commit_phyf_invalid)

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(commit_phyf_invalid[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_phyf_id", i), commit_phyf_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_phyf_flush_invalid", 0), commit_phyf_flush_invalid)

            if(commit_phyf_flush_invalid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_phyf_flush_id", 0), commit_phyf_flush_id)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_phyf_data_valid_restore", 0), commit_phyf_data_valid_restore)

            if(commit_phyf_data_valid_restore) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb, DOMAIN_OUTPUT, "commit_phyf_data_valid", 0), commit_phyf_data_valid)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.enable", 0), commit_feedback_pack.enable)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.next_handle_rob_id_valid", 0), commit_feedback_pack.next_handle_rob_id_valid)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.next_handle_rob_id", 0), commit_feedback_pack.next_handle_rob_id)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.has_exception", 0), commit_feedback_pack.has_exception)

            if(commit_feedback_pack.has_exception) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_feedback_pack.exception_pc", 0), commit_feedback_pack.exception_pc)
            end

            if(commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.flush", 0), commit_feedback_pack.flush)
            end
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.committed_rob_id_valid", 0), commit_feedback_pack.committed_rob_id_valid)

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(commit_feedback_pack.committed_rob_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.committed_rob_id", i), commit_feedback_pack.committed_rob_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.jump_enable", 0), commit_feedback_pack.jump_enable)

            if(commit_feedback_pack.jump_enable) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.jump", 0), commit_feedback_pack.jump)

                if(commit_feedback_pack.jump) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "commit_feedback_pack.next_pc", 0), commit_feedback_pack.next_pc)
                end
            end

            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/commit.tdb"});
        test();
        $display("TEST PASSED");
        $finish;
    end

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule