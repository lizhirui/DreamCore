`include "config.svh"
`include "common.svh"

module top;
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

    bus bus_inst(.*);
    
    task wait_clk;
        @(posedge clk);
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
        assert(bus_fetch_read_ack == 'b0) else $finish;
        assert(bus_stbuf_read_ack == 'b0) else $finish;
        assert(bus_stbuf_write_ack == 'b0) else $finish;
        assert(bus_tcm_stbuf_rd == 'b0) else $finish;
        assert(bus_tcm_stbuf_wr == 'b0) else $finish;
        assert(bus_clint_rd == 'b0) else $finish;
        assert(bus_clint_wr == 'b0) else $finish;
        wait_clk();
        fetch_bus_addr = `TCM_ADDR + 'h10;
        fetch_bus_read_req = 'b1;
        stbuf_bus_read_addr = `TCM_ADDR + 'h20;
        stbuf_bus_write_addr = `TCM_ADDR + 'h30;
        stbuf_bus_read_size = 'b01;
        stbuf_bus_write_size = 'b10;
        stbuf_bus_data = 'hdeadbeef;
        stbuf_bus_read_req = 'b1;
        stbuf_bus_write_req = 'b1;
        tcm_bus_fetch_data = 128'habbccdde_12574985_1000203f_abcdef12;
        tcm_bus_stbuf_data = 128'hacaedffe_1ac1d2e5_1205abcd_fedd1698;
        clint_bus_data = 'hbbccaadd;
        wait_clk();
        assert(bus_fetch_data == 128'habbccdde_12574985_1000203f_abcdef12) else $finish;
        assert(bus_fetch_read_ack == 'b1) else $finish;
        assert(bus_stbuf_data == 'hfedd1698) else $finish;
        assert(bus_stbuf_read_ack == 'b1) else $finish;
        assert(bus_stbuf_write_ack == 'b1) else $finish;
        assert(bus_tcm_fetch_addr == 'h10) else $finish;
        assert(bus_tcm_fetch_rd == 'b1) else $finish;
        assert(bus_tcm_stbuf_read_addr == 'h20) else $finish;
        assert(bus_tcm_stbuf_write_addr == 'h30) else $finish;
        assert(bus_tcm_stbuf_read_size == 'b01) else $finish;
        assert(bus_tcm_stbuf_write_size == 'b10) else $finish;
        assert(bus_tcm_stbuf_data == 'hdeadbeef) else $finish;
        assert(bus_tcm_stbuf_rd == 'b1) else $finish;
        assert(bus_tcm_stbuf_wr == 'b1) else $finish;
        assert(bus_clint_rd == 'b0) else $finish;
        assert(bus_clint_wr == 'b0) else $finish;
        stbuf_bus_read_addr = `CLINT_ADDR + 'h40;
        stbuf_bus_write_addr = `CLINT_ADDR + 'h50;
        wait_clk();
        assert(bus_fetch_data == 128'habbccdde_12574985_1000203f_abcdef12) else $finish;
        assert(bus_fetch_read_ack == 'b1) else $finish;
        assert(bus_stbuf_data == 'hbbccaadd) else $finish;
        assert(bus_stbuf_read_ack == 'b1) else $finish;
        assert(bus_stbuf_write_ack == 'b1) else $finish;
        assert(bus_tcm_fetch_addr == 'h10) else $finish;
        assert(bus_tcm_fetch_rd == 'b1) else $finish;
        assert(bus_tcm_stbuf_rd == 'b0) else $finish;
        assert(bus_tcm_stbuf_wr == 'b0) else $finish;
        assert(bus_clint_read_addr == 'h40) else $finish;
        assert(bus_clint_write_addr == 'h50) else $finish;
        assert(bus_clint_read_size == 'b01) else $finish;
        assert(bus_clint_write_size == 'b10) else $finish;
        assert(bus_clint_data == 'hdeadbeef) else $finish;
        assert(bus_clint_rd == 'b1) else $finish;
        assert(bus_clint_wr == 'b1) else $finish;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
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