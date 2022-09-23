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
    
    issue_execute_pack_t issue_alu_fifo_data_out;
    logic issue_alu_fifo_data_out_valid;
    logic issue_alu_fifo_pop;
    
    execute_wb_pack_t alu_wb_port_data_in;
    logic alu_wb_port_we;
    logic alu_wb_port_flush;
    
    execute_feedback_channel_t alu_execute_channel_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    issue_execute_pack_t t_pack;

    integer i, j;
    int index;
    string index_str;
    longint cur_cycle;
    
    execute_alu execute_alu_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
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
        t_pack.csr = 'b0;
        t_pack.lsu_addr = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;
        issue_alu_fifo_data_out = t_pack;
        issue_alu_fifo_data_out_valid = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        commit_feedback_pack.flush = 'b0;
        commit_feedback_pack.committed_rob_id = 'b0;
        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
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

            issue_alu_fifo_data_out.enable = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.enable", 0);
            issue_alu_fifo_data_out.value = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.value", 0);
            issue_alu_fifo_data_out.valid = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.valid", 0);
            issue_alu_fifo_data_out.rob_id = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rob_id", 0);
            issue_alu_fifo_data_out.pc = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.pc", 0);
            issue_alu_fifo_data_out.imm = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.imm", 0);
            issue_alu_fifo_data_out.has_exception = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.has_exception", 0);
            issue_alu_fifo_data_out.exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_id", 0));
            issue_alu_fifo_data_out.exception_value = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_value", 0);
            issue_alu_fifo_data_out.predicted = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted", 0);
            issue_alu_fifo_data_out.predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_jump", 0);
            issue_alu_fifo_data_out.predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_next_pc", 0);
            issue_alu_fifo_data_out.checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id_valid", 0);
            issue_alu_fifo_data_out.checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id", 0);
            issue_alu_fifo_data_out.rs1 = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1", 0);
            issue_alu_fifo_data_out.arg1_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg1_src", 0));
            issue_alu_fifo_data_out.rs1_need_map = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_need_map", 0);
            issue_alu_fifo_data_out.rs1_phy = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_phy", 0);
            issue_alu_fifo_data_out.src1_value = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_value", 0);
            issue_alu_fifo_data_out.src1_loaded = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_loaded", 0);
            issue_alu_fifo_data_out.rs2 = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2", 0);
            issue_alu_fifo_data_out.arg2_src = arg_src_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg2_src", 0));
            issue_alu_fifo_data_out.rs2_need_map = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_need_map", 0);
            issue_alu_fifo_data_out.rs2_phy = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_phy", 0);
            issue_alu_fifo_data_out.src2_value = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_value", 0);
            issue_alu_fifo_data_out.src2_loaded = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_loaded", 0);
            issue_alu_fifo_data_out.rd = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd", 0);
            issue_alu_fifo_data_out.rd_enable = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_enable", 0);
            issue_alu_fifo_data_out.need_rename = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.need_rename", 0);
            issue_alu_fifo_data_out.rd_phy = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_phy", 0);
            issue_alu_fifo_data_out.csr = tdb.get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.csr", 0);
            issue_alu_fifo_data_out.lsu_addr = tdb.get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.lsu_addr", 0);
            issue_alu_fifo_data_out.op = op_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op", 0));
            issue_alu_fifo_data_out.op_unit = op_unit_t::_type'(tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op_unit", 0));
            issue_alu_fifo_data_out.sub_op.raw_data = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.sub_op", 0);
            issue_alu_fifo_data_out_valid = tdb.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out_valid", 0);
            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            eval();
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "issue_alu_fifo_pop", 0), issue_alu_fifo_pop)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.enable", 0), alu_wb_port_data_in.enable)

            if(alu_wb_port_data_in.enable) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.value", 0), alu_wb_port_data_in.value)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.valid", 0), alu_wb_port_data_in.valid)

                if(alu_wb_port_data_in.valid) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.imm", 0), alu_wb_port_data_in.imm)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs1", 0), alu_wb_port_data_in.rs1)
                    `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.arg1_src", 0)), alu_wb_port_data_in.arg1_src)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs1_need_map", 0), alu_wb_port_data_in.rs1_need_map)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs1_phy", 0), alu_wb_port_data_in.rs1_phy)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.src1_value", 0), alu_wb_port_data_in.src1_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.src1_loaded", 0), alu_wb_port_data_in.src1_loaded)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs2", 0), alu_wb_port_data_in.rs2)
                    `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.arg2_src", 0)), alu_wb_port_data_in.arg2_src)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs2_need_map", 0), alu_wb_port_data_in.rs2_need_map)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rs2_phy", 0), alu_wb_port_data_in.rs2_phy)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.src2_value", 0), alu_wb_port_data_in.src2_value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.src2_loaded", 0), alu_wb_port_data_in.src2_loaded)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rd", 0), alu_wb_port_data_in.rd)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rd_enable", 0), alu_wb_port_data_in.rd_enable)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.need_rename", 0), alu_wb_port_data_in.need_rename)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rd_phy", 0), alu_wb_port_data_in.rd_phy)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.rd_value", 0), alu_wb_port_data_in.rd_value)
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "alu_wb_port_data_in.csr", 0), alu_wb_port_data_in.csr)
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.rob_id", 0), alu_wb_port_data_in.rob_id)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.pc", 0), alu_wb_port_data_in.pc)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.has_exception", 0), alu_wb_port_data_in.has_exception)

                if(alu_wb_port_data_in.has_exception) begin
                    `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.exception_id", 0)), alu_wb_port_data_in.exception_id)
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.exception_value", 0), alu_wb_port_data_in.exception_value)
                end
                    
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.predicted", 0), alu_wb_port_data_in.predicted)

                if(alu_wb_port_data_in.predicted) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.predicted_jump", 0), alu_wb_port_data_in.predicted_jump)

                    if(alu_wb_port_data_in.predicted_jump) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.predicted_next_pc", 0), alu_wb_port_data_in.predicted_next_pc)
                    end
                end
                
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.checkpoint_id_valid", 0), alu_wb_port_data_in.checkpoint_id_valid)

                if(alu_wb_port_data_in.checkpoint_id_valid) begin
                    `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "alu_wb_port_data_in.checkpoint_id", 0), alu_wb_port_data_in.checkpoint_id)
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.bru_jump", 0), alu_wb_port_data_in.bru_jump)

                if(alu_wb_port_data_in.bru_jump) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.bru_next_pc", 0), alu_wb_port_data_in.bru_next_pc)
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.csr_newvalue_valid", 0), alu_wb_port_data_in.csr_newvalue_valid)

                if(alu_wb_port_data_in.csr_newvalue_valid) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_wb_port_data_in.csr_newvalue", 0), alu_wb_port_data_in.csr_newvalue)
                end
                
                `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.op", 0)), alu_wb_port_data_in.op)
                `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.op_unit", 0)), alu_wb_port_data_in.op_unit)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_data_in.sub_op", 0), alu_wb_port_data_in.sub_op.raw_data)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_flush", 0), alu_wb_port_flush)

            if(!alu_wb_port_flush) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_wb_port_we", 0), alu_wb_port_we)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.enable", 0), alu_execute_channel_feedback_pack.enable)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.phy_id", 0), alu_execute_channel_feedback_pack.phy_id)
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "alu_execute_channel_feedback_pack.value", 0), alu_execute_channel_feedback_pack.value)
            wait_clk();
        end       
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        for(index = 0;index < `ALU_UNIT_NUM;index++) begin
            $display("Progress: %0d/%0d", index, `ALU_UNIT_NUM);
            tdb = new;
            index_str.itoa(index);
            tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/execute_alu_", index_str, ".tdb"});
            test();
            tdb.close();
            tdb.dispose();
        end

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