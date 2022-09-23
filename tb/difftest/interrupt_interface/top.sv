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

    logic all_intif_int_ext_req;
    logic all_intif_int_software_req;
    logic all_intif_int_timer_req;

    logic intif_all_int_ext_ack;
    logic intif_all_int_software_ack;
    logic intif_all_int_timer_ack;

    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data;

    logic intif_commit_has_interrupt;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data;
    logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data;

    logic[`REG_DATA_WIDTH - 1:0] all_int_mip;

    longint cur_cycle;

    interrupt_interface interrupt_interface(.*);

    assign all_int_mip = (('b1 << `MIP_MEIP) | ('b1 << `MIP_MSIP) | ('b1 << `MIP_MTIP));
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        all_intif_int_ext_req = 'b0;
        all_intif_int_software_req = 'b0;
        all_intif_int_timer_req = 'b0;
        csrf_all_mie_data = 'b0;
        csrf_all_mstatus_data = 'b0;
        csrf_all_mip_data = 'b0;
        commit_intif_ack_data = 'b0;
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

            all_intif_int_ext_req = tdb.get_uint8(DOMAIN_INPUT, "all_intif_int_ext_req", 0);
            all_intif_int_software_req = tdb.get_uint8(DOMAIN_INPUT, "all_intif_int_software_req", 0);
            all_intif_int_timer_req = tdb.get_uint8(DOMAIN_INPUT, "all_intif_int_timer_req", 0);

            csrf_all_mie_data = tdb.get_uint32(DOMAIN_INPUT, "csrf_all_mie_data", 0);
            csrf_all_mstatus_data = tdb.get_uint32(DOMAIN_INPUT, "csrf_all_mstatus_data", 0);
            csrf_all_mip_data = tdb.get_uint32(DOMAIN_INPUT, "csrf_all_mip_data", 0);

            commit_intif_ack_data = tdb.get_uint32(DOMAIN_INPUT, "commit_intif_ack_data", 0);
            eval();
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "intif_all_int_ext_ack", 0), intif_all_int_ext_ack)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "intif_all_int_software_ack", 0), intif_all_int_software_ack)
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "intif_all_int_timer_ack", 0), intif_all_int_timer_ack)

            `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "intif_csrf_mip_data", 0), intif_csrf_mip_data)
            
            `assert_equal(cur_cycle, tdb.get_uint8(DOMAIN_OUTPUT, "intif_commit_has_interrupt", 0), intif_commit_has_interrupt)

            if(intif_commit_has_interrupt) begin
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "intif_commit_mcause_data", 0), intif_commit_mcause_data)
                `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "intif_commit_ack_data", 0), intif_commit_ack_data)
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/interrupt_interface.tdb"});
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