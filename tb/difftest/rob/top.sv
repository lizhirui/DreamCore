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
    
    logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid;
    
    rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid;
    logic rename_rob_push;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1];
    rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1];
    rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] commit_rob_input_data_we;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id;
    logic rob_commit_retire_head_id_valid;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1];
    rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid;
    logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id;
    logic rob_commit_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id;
    logic rob_commit_flush_tail_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id;
    rob_item_t rob_commit_flush_data;
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id;
    logic rob_commit_flush_next_id_valid;

    logic rob_commit_empty;
    logic rob_commit_full;
    logic commit_rob_flush;

    integer i, j;
    longint cur_cycle;

    rob_item_t rob_test;

    rob rob_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        rob_test.new_phy_reg_id = 'b0;
        rob_test.old_phy_reg_id = 'b0;
        rob_test.old_phy_reg_id_valid = 'b0;
        rob_test.finish = 'b0;
        rob_test.pc = 'b0;
        rob_test.inst_value = 'b0;
        rob_test.has_exception = 'b0;
        rob_test.exception_id = riscv_exception_t::instruction_address_misaligned;
        rob_test.exception_value = 'b0;
        rob_test.predicted = 'b0;
        rob_test.predicted_jump = 'b0;
        rob_test.predicted_next_pc = 'b0;
        rob_test.checkpoint_id_valid = 'b0;
        rob_test.checkpoint_id = 'b0;
        rob_test.bru_op = 'b0;
        rob_test.bru_jump = 'b0;
        rob_test.bru_next_pc = 'b0;
        rob_test.is_mret = 'b0;
        rob_test.csr_addr = 'b0;
        rob_test.csr_newvalue = 'b0;
        rob_test.csr_newvalue_valid = 'b0;

        for(i = 0;i < `RENAME_WIDTH;i++) begin
            rename_rob_data[i] = rob_test;
            rename_rob_data_valid[i] = 'b0;
        end

        rename_rob_push = 'b0;
        
        for(i = 0;i < `WB_WIDTH;i++) begin
            commit_rob_input_id[i] = 'b0;
            commit_rob_input_data[i] = rob_test;
            commit_rob_input_data_we[i] = 'b0;
        end

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            commit_rob_retire_id[i] = 'b0;
            commit_rob_retire_pop[i] = 'b0;
        end

        commit_rob_next_id = 'b0;
        commit_rob_flush_id = 'b0;
        commit_rob_flush = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                rename_rob_data[i].new_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.new_phy_reg_id", i);
                rename_rob_data[i].old_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.old_phy_reg_id", i);
                rename_rob_data[i].old_phy_reg_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.old_phy_reg_id_valid", i);
                rename_rob_data[i].finish = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.finish", i);
                rename_rob_data[i].pc = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.pc", i);
                rename_rob_data[i].inst_value = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.inst_value", i);
                rename_rob_data[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.has_exception", i);
                rename_rob_data[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.exception_id", i));
                rename_rob_data[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.exception_value", i);
                rename_rob_data[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.predicted", i);
                rename_rob_data[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.predicted_jump", i);
                rename_rob_data[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.predicted_next_pc", i);
                rename_rob_data[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.checkpoint_id_valid", i);
                rename_rob_data[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "rename_rob_data.checkpoint_id", i);
                rename_rob_data[i].bru_op = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.bru_op", i);
                rename_rob_data[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.bru_jump", i);
                rename_rob_data[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.bru_next_pc", i);
                rename_rob_data[i].is_mret = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.is_mret", i);
                rename_rob_data[i].csr_addr = tdb.get_uint16(DOMAIN_INPUT, "rename_rob_data.csr_addr", i);
                rename_rob_data[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "rename_rob_data.csr_newvalue", i);
                rename_rob_data[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data.csr_newvalue_valid", i);
                rename_rob_data_valid[i] = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_data_valid", i);
            end

            rename_rob_push = tdb.get_uint8(DOMAIN_INPUT, "rename_rob_push", 0);

            for(i = 0;i < `WB_WIDTH;i++) begin
                commit_rob_input_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_id", i);
                commit_rob_input_data[i].new_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.new_phy_reg_id", i);
                commit_rob_input_data[i].old_phy_reg_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.old_phy_reg_id", i);
                commit_rob_input_data[i].old_phy_reg_id_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.old_phy_reg_id_valid", i);
                commit_rob_input_data[i].finish = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.finish", i);
                commit_rob_input_data[i].pc = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.pc", i);
                commit_rob_input_data[i].inst_value = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.inst_value", i);
                commit_rob_input_data[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.has_exception", i);
                commit_rob_input_data[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.exception_id", i));
                commit_rob_input_data[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.exception_value", i);
                commit_rob_input_data[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.predicted", i);
                commit_rob_input_data[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.predicted_jump", i);
                commit_rob_input_data[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.predicted_next_pc", i);
                commit_rob_input_data[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.checkpoint_id_valid", i);
                commit_rob_input_data[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "commit_rob_input_data.checkpoint_id", i);
                commit_rob_input_data[i].bru_op = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.bru_op", i);
                commit_rob_input_data[i].bru_jump = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.bru_jump", i);
                commit_rob_input_data[i].bru_next_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.bru_next_pc", i);
                commit_rob_input_data[i].is_mret = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.is_mret", i);
                commit_rob_input_data[i].csr_addr = tdb.get_uint16(DOMAIN_INPUT, "commit_rob_input_data.csr_addr", i);
                commit_rob_input_data[i].csr_newvalue = tdb.get_uint32(DOMAIN_INPUT, "commit_rob_input_data.csr_newvalue", i);
                commit_rob_input_data[i].csr_newvalue_valid = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data.csr_newvalue_valid", i);
                commit_rob_input_data_we[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_input_data_we", i);
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_rob_retire_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_retire_id", i);
                commit_rob_retire_pop[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_retire_pop", i);
            end

            commit_rob_next_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_next_id", 0);
            commit_rob_flush_id = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_flush_id", 0);
            commit_rob_flush = tdb.get_uint8(DOMAIN_INPUT, "commit_rob_flush", 0);
            eval();
            
            for(i = 0;i < `RENAME_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_rename_new_id_valid", i), rob_rename_new_id_valid[i])

                if(rob_rename_new_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_rename_new_id", i), rob_rename_new_id[i])
                end
            end

            for(i = 0;i < `WB_WIDTH;i++) begin
                if(commit_rob_input_data_we[i]) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.new_phy_reg_id", i), rob_commit_input_data[i].new_phy_reg_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.old_phy_reg_id", i), rob_commit_input_data[i].old_phy_reg_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.old_phy_reg_id_valid", i), rob_commit_input_data[i].old_phy_reg_id_valid)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.finish", i), rob_commit_input_data[i].finish)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.pc", i), rob_commit_input_data[i].pc)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.inst_value", i), rob_commit_input_data[i].inst_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.has_exception", i), rob_commit_input_data[i].has_exception)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.exception_id", i), rob_commit_input_data[i].exception_id)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.exception_value", i), rob_commit_input_data[i].exception_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.predicted", i), rob_commit_input_data[i].predicted)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.predicted_jump", i), rob_commit_input_data[i].predicted_jump)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.predicted_next_pc", i), rob_commit_input_data[i].predicted_next_pc)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.checkpoint_id_valid", i), rob_commit_input_data[i].checkpoint_id_valid)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_input_data.checkpoint_id", i), rob_commit_input_data[i].checkpoint_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.bru_op", i), rob_commit_input_data[i].bru_op)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.bru_jump", i), rob_commit_input_data[i].bru_jump)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.bru_next_pc", i), rob_commit_input_data[i].bru_next_pc)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.is_mret", i), rob_commit_input_data[i].is_mret)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_input_data.csr_addr", i), rob_commit_input_data[i].csr_addr)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.csr_newvalue", i), rob_commit_input_data[i].csr_newvalue)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.csr_newvalue_valid", i), rob_commit_input_data[i].csr_newvalue_valid)
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_head_id_valid", 0), rob_commit_retire_head_id_valid)

            if(rob_commit_retire_head_id_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_head_id", 0), rob_commit_retire_head_id)
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(tdb.get_uint8(DOMAIN_INPUT, "commit_rob_retire_id", i) != 255) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.new_phy_reg_id", i), rob_commit_retire_data[i].new_phy_reg_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.old_phy_reg_id", i), rob_commit_retire_data[i].old_phy_reg_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.old_phy_reg_id_valid", i), rob_commit_retire_data[i].old_phy_reg_id_valid)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.finish", i), rob_commit_retire_data[i].finish)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.pc", i), rob_commit_retire_data[i].pc)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.inst_value", i), rob_commit_retire_data[i].inst_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.has_exception", i), rob_commit_retire_data[i].has_exception)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.exception_id", i), rob_commit_retire_data[i].exception_id)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.exception_value", i), rob_commit_retire_data[i].exception_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.predicted", i), rob_commit_retire_data[i].predicted)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.predicted_jump", i), rob_commit_retire_data[i].predicted_jump)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.predicted_next_pc", i), rob_commit_retire_data[i].predicted_next_pc)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.checkpoint_id_valid", i), rob_commit_retire_data[i].checkpoint_id_valid)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_retire_data.checkpoint_id", i), rob_commit_retire_data[i].checkpoint_id)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.bru_op", i), rob_commit_retire_data[i].bru_op)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.bru_jump", i), rob_commit_retire_data[i].bru_jump)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.bru_next_pc", i), rob_commit_retire_data[i].bru_next_pc)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.is_mret", i), rob_commit_retire_data[i].is_mret)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_retire_data.csr_addr", i), rob_commit_retire_data[i].csr_addr)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_retire_data.csr_newvalue", i), rob_commit_retire_data[i].csr_newvalue)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_data.csr_newvalue_valid", i), rob_commit_retire_data[i].csr_newvalue_valid)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_id_valid", i), rob_commit_retire_id_valid[i])
                end
            end

            if(tdb.get_uint8(DOMAIN_INPUT, "commit_rob_next_id", 0) != 255) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_next_id_valid", 0), rob_commit_next_id_valid)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_tail_id_valid", 0), rob_commit_flush_tail_id_valid)

            if(rob_commit_flush_tail_id_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_tail_id", 0), rob_commit_flush_tail_id)
            end

            if(tdb.get_uint8(DOMAIN_INPUT, "commit_rob_flush_id", 0) != 255) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.new_phy_reg_id", 0), rob_commit_flush_data.new_phy_reg_id)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.old_phy_reg_id", 0), rob_commit_flush_data.old_phy_reg_id)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.old_phy_reg_id_valid", 0), rob_commit_flush_data.old_phy_reg_id_valid)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.finish", 0), rob_commit_flush_data.finish)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.pc", 0), rob_commit_flush_data.pc)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.inst_value", 0), rob_commit_flush_data.inst_value)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.has_exception", 0), rob_commit_flush_data.has_exception)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.exception_id", 0), rob_commit_flush_data.exception_id)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.exception_value", 0), rob_commit_flush_data.exception_value)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.predicted", 0), rob_commit_flush_data.predicted)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.predicted_jump", 0), rob_commit_flush_data.predicted_jump)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.predicted_next_pc", 0), rob_commit_flush_data.predicted_next_pc)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.checkpoint_id_valid", 0), rob_commit_flush_data.checkpoint_id_valid)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_flush_data.checkpoint_id", 0), rob_commit_flush_data.checkpoint_id)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.bru_op", 0), rob_commit_flush_data.bru_op)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.bru_jump", 0), rob_commit_flush_data.bru_jump)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.bru_next_pc", 0), rob_commit_flush_data.bru_next_pc)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.is_mret", 0), rob_commit_flush_data.is_mret)
                `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "rob_commit_flush_data.csr_addr", 0), rob_commit_flush_data.csr_addr)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "rob_commit_flush_data.csr_newvalue", 0), rob_commit_flush_data.csr_newvalue)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_data.csr_newvalue_valid", 0), rob_commit_flush_data.csr_newvalue_valid)
            end

            if(tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_next_id", 0) != 255) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_next_id_valid", 0), rob_commit_flush_next_id_valid)

                if(rob_commit_flush_next_id_valid) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_next_id", 0), rob_commit_flush_next_id)
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_empty", 0), rob_commit_empty)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "rob_commit_full", 0), rob_commit_full)
            wait_clk();
        end 
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/rob.tdb"});
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