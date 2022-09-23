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
    
    logic decode_csrf_decode_rename_fifo_full_add;
        
    fetch_decode_pack_t fetch_decode_fifo_data_out[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_out_valid;
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_pop_valid;
    logic fetch_decode_fifo_pop;
    
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_enable;
    decode_rename_pack_t decode_rename_fifo_data_in[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_valid;
    logic decode_rename_fifo_push;
    logic decode_rename_fifo_flush;
    
    decode_feedback_pack_t decode_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    fetch_decode_pack_t t_pack;

    integer i, j;
    longint cur_cycle;

    decode decode_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        
        for(i = 0;i < `DECODE_WIDTH;i++) begin
            fetch_decode_fifo_data_out[i] = 'b0;
            fetch_decode_fifo_data_out_valid[i] = 'b0;
        end

        decode_rename_fifo_data_in_enable = 'b0;
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

            for(i = 0;i < `DECODE_WIDTH;i++) begin
                fetch_decode_fifo_data_out[i].enable = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.enable", i);
                fetch_decode_fifo_data_out[i].value = tdb.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.value", i);
                fetch_decode_fifo_data_out[i].pc = tdb.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.pc", i);
                fetch_decode_fifo_data_out[i].has_exception = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.has_exception", i);
                fetch_decode_fifo_data_out[i].exception_id = riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.exception_id", i));
                fetch_decode_fifo_data_out[i].exception_value = tdb.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.exception_value", i);
                fetch_decode_fifo_data_out[i].predicted = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted", i);
                fetch_decode_fifo_data_out[i].predicted_jump = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted_jump", i);
                fetch_decode_fifo_data_out[i].predicted_next_pc = tdb.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted_next_pc", i);
                fetch_decode_fifo_data_out[i].checkpoint_id_valid = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.checkpoint_id_valid", i);
                fetch_decode_fifo_data_out[i].checkpoint_id = tdb.get_uint16(DOMAIN_INPUT, "fetch_decode_fifo_data_out.checkpoint_id", i);
            end

            fetch_decode_fifo_data_out_valid = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out_valid", 0);
            decode_rename_fifo_data_in_enable = tdb.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_in_enable", 0);
            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            eval();
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_csrf_decode_rename_fifo_full_add", 0), decode_csrf_decode_rename_fifo_full_add)

            if(tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_pop_valid", 0) && tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_pop", 0)) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_pop_valid", 0), fetch_decode_fifo_data_pop_valid)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_pop", 0), fetch_decode_fifo_pop)
            end

            for(i = 0;i < `DECODE_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.enable", i), decode_rename_fifo_data_in[i].enable)

                if(decode_rename_fifo_data_in[i].enable) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.value", i), decode_rename_fifo_data_in[i].value)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.valid", i), decode_rename_fifo_data_in[i].valid)

                    if(decode_rename_fifo_data_in[i].valid) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.imm", i), decode_rename_fifo_data_in[i].imm)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rs1", i), decode_rename_fifo_data_in[i].rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.arg1_src", i)), decode_rename_fifo_data_in[i].arg1_src)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rs1_need_map", i), decode_rename_fifo_data_in[i].rs1_need_map)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rs2", i), decode_rename_fifo_data_in[i].rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.arg2_src", i)), decode_rename_fifo_data_in[i].arg2_src)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rs2_need_map", i), decode_rename_fifo_data_in[i].rs2_need_map)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rd", i), decode_rename_fifo_data_in[i].rd)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.rd_enable", i), decode_rename_fifo_data_in[i].rd_enable)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.need_rename", i), decode_rename_fifo_data_in[i].need_rename)
                        `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.csr", i), decode_rename_fifo_data_in[i].csr)
                    end

                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.pc", i), decode_rename_fifo_data_in[i].pc)
                    
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.has_exception", i), decode_rename_fifo_data_in[i].has_exception)

                    if(decode_rename_fifo_data_in[i].has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.exception_id", i)), decode_rename_fifo_data_in[i].exception_id)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.exception_value", i), decode_rename_fifo_data_in[i].exception_value)
                    end
                    
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.predicted", i), decode_rename_fifo_data_in[i].predicted)

                    if(decode_rename_fifo_data_in[i].predicted_jump) begin
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.predicted_jump", i), decode_rename_fifo_data_in[i].predicted_jump)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.predicted_next_pc", i), decode_rename_fifo_data_in[i].predicted_next_pc)
                    end

                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.checkpoint_id_valid", i), decode_rename_fifo_data_in[i].checkpoint_id_valid)

                    if(decode_rename_fifo_data_in[i].checkpoint_id) begin
                        `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.checkpoint_id", i), decode_rename_fifo_data_in[i].checkpoint_id)
                    end

                    `assert_equal(cur_cycle, op_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.op", i)), decode_rename_fifo_data_in[i].op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.op_unit", i)), decode_rename_fifo_data_in[i].op_unit)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in.sub_op", i), decode_rename_fifo_data_in[i].sub_op.raw_data)
                end
            end

            if(!tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_flush", 0)) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_in_valid", 0), decode_rename_fifo_data_in_valid)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_flush", 0), decode_rename_fifo_flush)

            if((!decode_rename_fifo_flush) && decode_rename_fifo_data_in_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_push", 0), decode_rename_fifo_push)
            end
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "decode_feedback_pack.idle", 0), decode_feedback_pack.idle)
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/decode.tdb"});
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