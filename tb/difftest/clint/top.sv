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

    localparam logic[`ADDR_WIDTH - 1:0] MSIP_ADDR = 'b0;
    localparam logic[`ADDR_WIDTH - 1:0] MTIMECMP_ADDR = 'h4000;
    localparam logic[`ADDR_WIDTH - 1:0] MTIME_ADDR = 'hbff8;

    logic clk;
    logic rst;
    
    logic[`ADDR_WIDTH - 1:0] bus_clint_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_clint_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_clint_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_clint_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_clint_data;
    logic bus_clint_rd;
    logic bus_clint_wr;
    logic[`BUS_DATA_WIDTH - 1:0] clint_bus_data;
    logic all_intif_int_software_req;
    logic all_intif_int_timer_req;

    longint cur_cycle;

    clint clint_inst(.*);
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bus_clint_read_addr = 'b0;
        bus_clint_write_addr = 'b0;
        bus_clint_read_size = 'b10;
        bus_clint_write_size = 'b10;
        bus_clint_data = 'b0;
        bus_clint_rd = 'b1;
        bus_clint_wr = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            tdb.move_to_next_row();

            if(tdb.read_cur_row()) begin
                cur_cycle = tdb.get_cur_row();
                bus_clint_read_addr = tdb.get_uint32(DOMAIN_INPUT, "bus_clint_read_addr_cur", 0);
                bus_clint_read_size = tdb.get_uint8(DOMAIN_INPUT, "bus_clint_read_size_cur", 0);
                bus_clint_rd = tdb.get_uint8(DOMAIN_INPUT, "bus_clint_rd_cur", 0);
            end

            tdb.move_to_prev_row();
            `assert(tdb.read_cur_row())
            cur_cycle = tdb.get_cur_row();
            bus_clint_write_addr = tdb.get_uint32(DOMAIN_INPUT, "bus_clint_write_addr", 0);
            bus_clint_write_size = tdb.get_uint8(DOMAIN_INPUT, "bus_clint_write_size", 0);
            bus_clint_data = tdb.get_uint32(DOMAIN_INPUT, "bus_clint_data", 0);     
            bus_clint_wr = tdb.get_uint8(DOMAIN_INPUT, "bus_clint_wr", 0);
            eval();

            if(cur_cycle > 0) begin
                if(tdb.get_uint8(DOMAIN_INPUT, "bus_clint_rd_cur", 0)) begin
                    `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "clint_bus_data", 0), clint_bus_data)
                end
                
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "all_intif_int_software_req", 0), all_intif_int_software_req)
                `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "all_intif_int_timer_req", 0), all_intif_int_timer_req)
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/clint.tdb"});
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