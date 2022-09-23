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
    
    logic[`ADDR_WIDTH - 1:0] fetch_bus_addr;
    logic fetch_bus_read_req;
    logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data;
    logic bus_fetch_read_ack;
    
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
    
    logic[`ADDR_WIDTH - 1:0] bus_tcm_fetch_addr;
    logic bus_tcm_fetch_rd;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_fetch_data;

    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_tcm_stbuf_data;
    logic bus_tcm_stbuf_rd;
    logic bus_tcm_stbuf_wr;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_stbuf_data;
    
    logic[`ADDR_WIDTH - 1:0] bus_clint_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_clint_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_clint_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_clint_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_clint_data;
    logic bus_clint_rd;
    logic bus_clint_wr;
    logic[`BUS_DATA_WIDTH - 1:0] clint_bus_data;

    integer i;
    longint cur_cycle;

    bus bus_inst(.*);
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        fetch_bus_addr = 'b0;
        fetch_bus_read_req = 'b0;
        stbuf_bus_read_addr = 'b0;
        stbuf_bus_write_addr = 'b0;
        stbuf_bus_read_size = 'b0;
        stbuf_bus_write_size = 'b0;
        stbuf_bus_data = 'b0;
        stbuf_bus_read_req = 'b0;
        stbuf_bus_write_req = 'b0;
        tcm_bus_fetch_data = 'b0;
        tcm_bus_stbuf_data = 'b0;
        clint_bus_data = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            tdb.move_to_next_row();

            if(tdb.read_cur_row()) begin
                cur_cycle = tdb.get_cur_row();
                fetch_bus_addr = tdb.get_uint32(DOMAIN_INPUT, "fetch_bus_addr_cur", 0);
                fetch_bus_read_req = tdb.get_uint8(DOMAIN_INPUT, "fetch_bus_read_req_cur", 0);

                stbuf_bus_read_addr = tdb.get_uint32(DOMAIN_INPUT, "stbuf_bus_read_addr_cur", 0);
                stbuf_bus_read_size = tdb.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0);
                stbuf_bus_read_req = tdb.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_req_cur", 0);
            end

            tdb.move_to_prev_row();
            `assert(tdb.read_cur_row())
            cur_cycle = tdb.get_cur_row();

            stbuf_bus_write_addr = tdb.get_uint32(DOMAIN_INPUT, "stbuf_bus_write_addr", 0);
            stbuf_bus_write_size = tdb.get_uint8(DOMAIN_INPUT, "stbuf_bus_write_size", 0);
            stbuf_bus_data = tdb.get_uint32(DOMAIN_INPUT, "stbuf_bus_data", 0);
            stbuf_bus_write_req = tdb.get_uint8(DOMAIN_INPUT, "stbuf_bus_write_req", 0);

            for(i = 0;i < `FETCH_WIDTH;i++) begin
                tcm_bus_fetch_data[i * `INSTRUCTION_WIDTH+:`INSTRUCTION_WIDTH] = tdb.get_uint32(DOMAIN_INPUT, "tcm_bus_fetch_data", i);
            end
            
            tcm_bus_stbuf_data = tdb.get_uint32(DOMAIN_INPUT, "tcm_bus_stbuf_data", 0);
            clint_bus_data = tdb.get_uint32(DOMAIN_INPUT, "clint_bus_data", 0);
            eval();

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_fetch_read_ack", 0), bus_fetch_read_ack)

            if(bus_fetch_read_ack) begin
                for(i = 0;i < `FETCH_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_fetch_data", i), bus_fetch_data[i * `INSTRUCTION_WIDTH+:`INSTRUCTION_WIDTH])
                end
            end

            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_stbuf_read_ack", 0), bus_stbuf_read_ack)

            if(bus_stbuf_read_ack) begin
                case(tdb.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0))
                    'd1: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0) & 'hff, bus_stbuf_data[7:0])
                    'd2: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0) & 'hffff, bus_stbuf_data[15:0])
                    'd4: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0), bus_stbuf_data[31:0])
                    default: `assert(0)
                endcase
            end

            if(cur_cycle > 0) begin
                tdb.move_to_prev_row();
                `assert(tdb.read_cur_row())
                cur_cycle = tdb.get_cur_row();
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_stbuf_write_ack_next", 0), bus_stbuf_write_ack)
                tdb.move_to_next_row();
                `assert(tdb.read_cur_row())
                cur_cycle = tdb.get_cur_row();
            end

            tdb.move_to_next_row();

            if(tdb.read_cur_row()) begin
                cur_cycle = tdb.get_cur_row();
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_tcm_fetch_rd_cur", 0), bus_tcm_fetch_rd)
                
                if(bus_tcm_fetch_rd) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_tcm_fetch_addr_cur", 0), bus_tcm_fetch_addr)
                end

                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_rd_cur", 0), bus_tcm_stbuf_rd)

                if(bus_tcm_stbuf_rd) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_read_addr_cur", 0), bus_tcm_stbuf_read_addr)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_read_size_cur", 0), bus_tcm_stbuf_read_size)
                end
                
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_clint_rd_cur", 0), bus_clint_rd)

                if(bus_clint_rd) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_clint_read_addr_cur", 0), bus_clint_read_addr)
                    `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_clint_read_size_cur", 0), bus_clint_read_size)
                end
            end

            tdb.move_to_prev_row();
            `assert(tdb.read_cur_row())
            cur_cycle = tdb.get_cur_row();
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_wr", 0), bus_tcm_stbuf_wr)

            if(bus_tcm_stbuf_wr) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_write_addr", 0), bus_tcm_stbuf_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_write_size", 0), bus_tcm_stbuf_write_size)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_data", 0), bus_tcm_stbuf_data)
            end    
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_clint_wr", 0), bus_clint_wr)

            if(bus_clint_wr) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_clint_write_addr", 0), bus_clint_write_addr)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "bus_clint_write_size", 0), bus_clint_write_size)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "bus_clint_data", 0), bus_clint_data)
            end
            
            wait_clk();

            tdb.move_to_next_row();
            cur_cycle = tdb.get_cur_row();

            if(!tdb.read_cur_row()) begin
                break;
            end
        end 
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/bus.tdb"});
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