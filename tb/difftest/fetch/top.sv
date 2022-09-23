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
    
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction;
    logic fetch_bp_update_jump;
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc;
    logic fetch_bp_update_valid;
    
    logic[`ADDR_WIDTH -1:0] fetch_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction;
    logic fetch_bp_valid;
    logic bp_fetch_jump;
    logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc;
    logic bp_fetch_valid;
    logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history;
    logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history; 
    
    logic[`ADDR_WIDTH - 1:0] fetch_bus_addr;
    logic fetch_bus_read_req;
    logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data;
    logic bus_fetch_read_ack;
    
    logic fetch_csrf_checkpoint_buffer_full_add;
    logic fetch_csrf_fetch_not_full_add;
    logic fetch_csrf_fetch_decode_fifo_full_add;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id;
    logic cpbuf_fetch_new_id_valid;
    checkpoint_t fetch_cpbuf_data;
    logic fetch_cpbuf_push;
    
    logic stbuf_all_empty;
    
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_enable;
    fetch_decode_pack_t fetch_decode_fifo_data_in[0:`FETCH_WIDTH - 1];
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_valid;
    logic fetch_decode_fifo_push;
    logic fetch_decode_fifo_flush;
    
    decode_feedback_pack_t decode_feedback_pack;
    rename_feedback_pack_t rename_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j;
    longint cur_cycle;

    fetch fetch_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bp_fetch_jump = 'b0;
        bp_fetch_next_pc = 'b0;
        bp_fetch_valid = 'b0;
        bp_fetch_global_history = 'b0;
        bp_fetch_local_history = 'b0;
        bus_fetch_data = 'b0;
        bus_fetch_read_ack = 'b0;
        cpbuf_fetch_new_id = 'b0;
        cpbuf_fetch_new_id_valid = 'b0;
        stbuf_all_empty = 'b0;
        fetch_decode_fifo_data_in_enable = 'b0;
        decode_feedback_pack.idle = 'b0;
        rename_feedback_pack.idle = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.flush = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();
        
        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_STATUS, "pc", 0), fetch_inst.pc)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "jump_wait", 0), fetch_inst.jump_wait)
            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();
            
            if(!tdb.read_cur_row()) begin
                break;
            end

            bp_fetch_jump = tdb.get_uint8(DOMAIN_INPUT, "bp_fetch_jump", 0);
            bp_fetch_next_pc = tdb.get_uint32(DOMAIN_INPUT, "bp_fetch_next_pc", 0);
            bp_fetch_valid = tdb.get_uint8(DOMAIN_INPUT, "bp_fetch_valid", 0);
            bp_fetch_global_history = tdb.get_uint16(DOMAIN_INPUT, "bp_fetch_global_history", 0);
            bp_fetch_local_history = tdb.get_uint16(DOMAIN_INPUT, "bp_fetch_local_history", 0);
            
            for(i = 0;i < `FETCH_WIDTH;i++) begin
                bus_fetch_data[i * `INSTRUCTION_WIDTH +: `INSTRUCTION_WIDTH] = tdb.get_uint32(DOMAIN_INPUT, "bus_fetch_data", i);
            end

            bus_fetch_read_ack = tdb.get_uint8(DOMAIN_INPUT, "bus_fetch_read_ack", 0);
            cpbuf_fetch_new_id = tdb.get_uint32(DOMAIN_INPUT, "cpbuf_fetch_new_id", 0);
            cpbuf_fetch_new_id_valid = tdb.get_uint8(DOMAIN_INPUT, "cpbuf_fetch_new_id_valid", 0);
            stbuf_all_empty = tdb.get_uint8(DOMAIN_INPUT, "stbuf_all_empty", 0);
            fetch_decode_fifo_data_in_enable = tdb.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_in_enable", 0);
            decode_feedback_pack.idle = tdb.get_uint8(DOMAIN_INPUT, "decode_feedback_pack.idle", 0);
            rename_feedback_pack.idle = tdb.get_uint8(DOMAIN_INPUT, "rename_feedback_pack.idle", 0);
            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.has_exception = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.has_exception", 0);
            commit_feedback_pack.exception_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_feedback_pack.exception_pc", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            commit_feedback_pack.jump_enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.jump_enable", 0);
            commit_feedback_pack.jump = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.jump", 0);
            commit_feedback_pack.next_pc = tdb.get_uint32(DOMAIN_INPUT, "commit_feedback_pack.next_pc", 0);
            eval();
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_bp_update_valid", 0), fetch_bp_update_valid)

            if(fetch_bp_update_valid) begin
               `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bp_update_pc", 0), fetch_bp_update_pc)
               `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bp_update_instruction", 0), fetch_bp_update_instruction)
               `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_bp_update_jump", 0), fetch_bp_update_jump)
               `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bp_update_next_pc", 0), fetch_bp_update_next_pc)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_bp_valid", 0), fetch_bp_valid)

            if(fetch_bp_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bp_pc", 0), fetch_bp_pc)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bp_instruction", 0), fetch_bp_instruction)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_csrf_checkpoint_buffer_full_add", 0), fetch_csrf_checkpoint_buffer_full_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_csrf_fetch_not_full_add", 0), fetch_csrf_fetch_not_full_add)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_csrf_fetch_decode_fifo_full_add", 0), fetch_csrf_fetch_decode_fifo_full_add)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "fetch_cpbuf_data.global_history", 0), fetch_cpbuf_data.global_history)
            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "fetch_cpbuf_data.local_history", 0), fetch_cpbuf_data.local_history)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_cpbuf_push", 0), fetch_cpbuf_push)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in_valid", 0), fetch_decode_fifo_data_in_valid)

            for(i = 0;i < `FETCH_WIDTH;i++) begin
                if(fetch_decode_fifo_data_in_valid & (1 << i)) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.enable", i), fetch_decode_fifo_data_in[i].enable)

                    if(fetch_decode_fifo_data_in[i].enable) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.value", i), fetch_decode_fifo_data_in[i].value)
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.pc", i), fetch_decode_fifo_data_in[i].pc)
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.has_exception", i), fetch_decode_fifo_data_in[i].has_exception)

                        if(fetch_decode_fifo_data_in[i].has_exception) begin
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.exception_id", i), fetch_decode_fifo_data_in[i].exception_id)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.exception_value", i), fetch_decode_fifo_data_in[i].exception_value)
                        end

                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.predicted", i), fetch_decode_fifo_data_in[i].predicted)

                        if(fetch_decode_fifo_data_in[i].predicted) begin
                            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.predicted_jump", i), fetch_decode_fifo_data_in[i].predicted_jump)
                            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.predicted_next_pc", i), fetch_decode_fifo_data_in[i].predicted_next_pc)
                        end
                        
                        `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.checkpoint_id_valid", i), fetch_decode_fifo_data_in[i].checkpoint_id_valid)

                        if(fetch_decode_fifo_data_in[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb.get_uint16(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.checkpoint_id", i), fetch_decode_fifo_data_in[i].checkpoint_id)
                        end
                    end
                end 
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_flush", 0), fetch_decode_fifo_flush)

            if((!fetch_decode_fifo_flush) && fetch_decode_fifo_data_in_valid) begin
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_push", 0), fetch_decode_fifo_push)
            end

            tdb.move_to_next_row();

            if(tdb.read_cur_row()) begin
                cur_cycle = tdb.get_cur_row();
                
                if(!tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0) || !tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0)) begin
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "fetch_bus_read_req_cur", 0), fetch_bus_read_req)
                
                    if(fetch_bus_read_req) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "fetch_bus_addr_cur", 0), fetch_bus_addr)
                    end
                end
            end

            tdb.move_to_prev_row();
            `assert(tdb.read_cur_row())
            cur_cycle = tdb.get_cur_row();
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/fetch.tdb"});
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