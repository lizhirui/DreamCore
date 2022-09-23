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
    
    logic ras_csrf_ras_full_add;
    logic[`ADDR_WIDTH - 1:0] bp_ras_addr;
    logic bp_ras_push;
    logic bp_ras_pop;
    logic[`ADDR_WIDTH - 1:0] ras_bp_addr;

    integer i;
    longint cur_cycle;

    ras#(
        .DEPTH(`RAS_SIZE)
    )ras_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bp_ras_addr = 'b0;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b0;
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

            bp_ras_addr = tdb.get_uint32(DOMAIN_INPUT, "bp_ras_addr", 0);
            bp_ras_push = tdb.get_uint8(DOMAIN_INPUT, "bp_ras_push", 0);
            bp_ras_pop = tdb.get_uint8(DOMAIN_INPUT, "bp_ras_pop", 0);
            eval();
            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "ras_bp_addr", 0), ras_bp_addr)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "ras_csrf_ras_full_add", 0), ras_csrf_ras_full_add)
            wait_clk();
        end 
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb = new;
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/ras.tdb"});
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