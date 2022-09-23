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
    
    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size;
    logic issue_stbuf_rd;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback;
    logic stbuf_exlsu_bus_ready;
    
    logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id;
    logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size;
    logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data;
    logic exlsu_stbuf_push;
    logic stbuf_exlsu_full;
    
    logic stbuf_all_empty;
    
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_read_addr;
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_write_addr;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_read_size;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_write_size;
    logic[`REG_DATA_WIDTH - 1:0] stbuf_bus_data;
    logic stbuf_bus_read_req;
    logic stbuf_bus_write_req;
    logic[`REG_DATA_WIDTH - 1:0] bus_stbuf_data;
    logic bus_stbuf_read_ack;
    logic bus_stbuf_write_ack;
    
    commit_feedback_pack_t commit_feedback_pack;

    integer i, j;
    longint cur_cycle;

    logic[31:0] read_size;

    store_buffer store_buffer_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        issue_stbuf_read_addr = 'b0;
        issue_stbuf_read_size = 'b0;
        issue_stbuf_rd = 'b0;
        exlsu_stbuf_rob_id = 'b0;
        exlsu_stbuf_write_addr = 'b0;
        exlsu_stbuf_write_size = 'b0;
        exlsu_stbuf_write_data = 'b0;
        exlsu_stbuf_push = 'b0;
        bus_stbuf_data = 'b0;
        bus_stbuf_read_ack = 'b0;
        bus_stbuf_write_ack = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        commit_feedback_pack.flush = 'b0;
        
        for(i = 0;i < `ROB_ID_WIDTH;i++) begin
            commit_feedback_pack.committed_rob_id[i] = 'b0;
        end

        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "rptr", 0), store_buffer_inst.rptr)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_STATUS, "wptr", 0), store_buffer_inst.wptr)

            if(cur_cycle > 0) begin
                bus_stbuf_write_ack = tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_write_req", 0);
                bus_stbuf_read_ack = tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_read_req", 0);
            end

            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();
            
            if(!tdb.read_cur_row()) begin
                break;
            end

            issue_stbuf_read_addr = tdb.get_uint32(DOMAIN_INPUT, "issue_stbuf_read_addr", 0);
            issue_stbuf_read_size = tdb.get_uint32(DOMAIN_INPUT, "issue_stbuf_read_size", 0);
            issue_stbuf_rd = tdb.get_uint8(DOMAIN_INPUT, "issue_stbuf_rd", 0);

            if(issue_stbuf_rd) begin
                read_size = issue_stbuf_read_size;
            end

            exlsu_stbuf_rob_id = tdb.get_uint8(DOMAIN_INPUT, "exlsu_stbuf_rob_id", 0);
            exlsu_stbuf_write_addr = tdb.get_uint32(DOMAIN_INPUT, "exlsu_stbuf_write_addr", 0);
            exlsu_stbuf_write_size = tdb.get_uint8(DOMAIN_INPUT, "exlsu_stbuf_write_size", 0);
            exlsu_stbuf_write_data = tdb.get_uint32(DOMAIN_INPUT, "exlsu_stbuf_write_data", 0);
            exlsu_stbuf_push = tdb.get_uint8(DOMAIN_INPUT, "exlsu_stbuf_push", 0);

            bus_stbuf_data = tdb.get_uint32(DOMAIN_INPUT, "bus_stbuf_data", 0);

            commit_feedback_pack.enable = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0);
            commit_feedback_pack.flush = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0);
            
            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                commit_feedback_pack.committed_rob_id[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id", i);
                commit_feedback_pack.committed_rob_id_valid[i] = tdb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id_valid", i);
            end

            eval();

            if(tdb.get_uint8(DOMAIN_INPUT, "bus_stbuf_read_ack", 0) == bus_stbuf_read_ack) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_ready", 0), stbuf_exlsu_bus_ready)
            end
            else begin
                `assert_equal(cur_cycle, bus_stbuf_read_ack, stbuf_exlsu_bus_ready)
            end

            if(stbuf_exlsu_bus_ready && tdb.get_uint8(DOMAIN_INPUT, "bus_stbuf_read_ack", 0)) begin
                case(read_size)
                    'd1: begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data", 0) & 'hff, stbuf_exlsu_bus_data[7:0])
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data_feedback", 0) & 'hff, stbuf_exlsu_bus_data_feedback[7:0])
                    end

                    'd2: begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data", 0) & 'hffff, stbuf_exlsu_bus_data[15:0])
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data_feedback", 0) & 'hffff, stbuf_exlsu_bus_data_feedback[15:0])
                    end

                    'd4: begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data", 0), stbuf_exlsu_bus_data[31:0])
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_exlsu_bus_data_feedback", 0), stbuf_exlsu_bus_data_feedback[31:0])
                    end
                    default: `assert(0)
                endcase
                
            end
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_exlsu_full", 0), stbuf_exlsu_full)
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_read_req", 0), stbuf_bus_read_req)

            if(stbuf_bus_read_req) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_bus_read_addr", 0), stbuf_bus_read_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_read_size", 0), stbuf_bus_read_size)
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_write_req", 0), stbuf_bus_write_req)

            if(stbuf_bus_write_req) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_bus_write_addr", 0), stbuf_bus_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "stbuf_bus_write_size", 0), stbuf_bus_write_size)

                case(stbuf_bus_write_size)
                    'h1: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_bus_data", 0) & 'hff, stbuf_bus_data)
                    'h2: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_bus_data", 0) & 'hffff, stbuf_bus_data)
                    'h4: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "stbuf_bus_data", 0), stbuf_bus_data)
                    default: `assert(0)
                endcase
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/store_buffer.tdb"});
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