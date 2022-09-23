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

    integer i;
    logic[`ADDR_WIDTH - 1:0] cur_addr;
    logic[`REG_DATA_WIDTH - 1:0] cur_data;

    longint cur_cycle;
    
    tcm #(
        .IMAGE_PATH(`SIM_IMAGE_NAME),
        .IMAGE_INIT(1)
    )tcm_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_fetch_rd = 'b1;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_read_size = 'b0;
        bus_tcm_stbuf_write_size = 'b0;
        bus_tcm_stbuf_data = 'b0;
        bus_tcm_stbuf_rd = 'b1;
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        rst = 0;
        `assert(tdb.read_cur_row())
        cur_cycle = tdb.get_cur_row();

        while(1) begin
            tdb.move_to_next_row();

            if(tdb.read_cur_row()) begin
                cur_cycle = tdb.get_cur_row();
                bus_tcm_stbuf_read_addr = tdb.get_uint32(DOMAIN_INPUT, "bus_tcm_stbuf_read_addr_cur", 0);
                bus_tcm_stbuf_read_size = tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_read_size_cur", 0);
                bus_tcm_stbuf_rd = tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_rd_cur", 0);

                bus_tcm_fetch_addr = tdb.get_uint32(DOMAIN_INPUT, "bus_tcm_fetch_addr_cur", 0);
                bus_tcm_fetch_rd = tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_fetch_rd_cur", 0);
            end

            tdb.move_to_prev_row();
            `assert(tdb.read_cur_row())
            cur_cycle = tdb.get_cur_row();
            bus_tcm_stbuf_write_addr = tdb.get_uint32(DOMAIN_INPUT, "bus_tcm_stbuf_write_addr", 0);
            bus_tcm_stbuf_write_size = tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_write_size", 0);
            bus_tcm_stbuf_data = tdb.get_uint32(DOMAIN_INPUT, "bus_tcm_stbuf_data", 0);     
            bus_tcm_stbuf_wr = tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_wr", 0);
            eval();

            if(cur_cycle > 0) begin
                if(tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_rd_cur", 0)) begin
                    case(tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_stbuf_read_size_cur", 0))
                        'd1: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "tcm_bus_stbuf_data", 0) & 'hff, tcm_bus_stbuf_data[7:0])
                        'd2: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "tcm_bus_stbuf_data", 0) & 'hffff, tcm_bus_stbuf_data[15:0])
                        'd4: `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "tcm_bus_stbuf_data", 0), tcm_bus_stbuf_data[31:0])
                        default: `assert(0)
                    endcase
                end

                if(tdb.get_uint8(DOMAIN_INPUT, "bus_tcm_fetch_rd_cur", 0)) begin
                    for(i = 0;i < `FETCH_WIDTH;i++) begin
                        `assert_equal(cur_cycle, tdb.get_uint32(DOMAIN_OUTPUT, "tcm_bus_fetch_data", i), tcm_bus_fetch_data[i * `INSTRUCTION_WIDTH+:`INSTRUCTION_WIDTH])
                    end
                end
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
        tdb.open({getenv("SIM_ROOT_DIR"), "/trace/", getenv("SIM_TRACE_NAME"), "/tcm.tdb"});
        test();
        $display("TEST PASSED");
        $finish;
    end

    `ifdef SIMULATOR_NOT_SUPPORT_SFORMATF_AS_CONSTANT_EXPRESSION
        genvar bank_index;

        generate
            for(bank_index = 0;bank_index < `BUS_DATA_WIDTH / 8;bank_index++) begin
                initial begin
                    $readmemh({`SIM_IMAGE_NAME, $sformatf(".%0d", bank_index)}, tcm_inst.fetch_mem_generate[bank_index].fetch_mem.mem_copy, 0, tcm_inst.fetch_mem_generate[bank_index].fetch_mem.DEPTH - 1);
                    $readmemh({`SIM_IMAGE_NAME, $sformatf(".%0d", bank_index)}, tcm_inst.stbuf_mem_generate[bank_index].stbuf_mem.mem_copy, 0, tcm_inst.stbuf_mem_generate[bank_index].stbuf_mem.DEPTH - 1);
                end
            end
        endgenerate
    `endif

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule