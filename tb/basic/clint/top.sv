`include "config.svh"
`include "common.svh"

module top;
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

    clint clint_inst(.*);
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test_msip;
        rst = 1;
        bus_clint_read_addr = 'b0;
        bus_clint_write_addr = 'b0;
        bus_clint_read_size = 'h4;
        bus_clint_write_size = 'h4;
        bus_clint_data = 'b0;
        bus_clint_rd = 'b1;
        bus_clint_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(all_intif_int_software_req == 'b0) else $finish;
        wait_clk();
        bus_clint_read_addr = MSIP_ADDR;
        wait_clk();
        assert(clint_bus_data == 'b0);
        bus_clint_write_addr = MSIP_ADDR;
        bus_clint_data = 'b1;
        bus_clint_wr = 'b1;
        wait_clk();
        assert(all_intif_int_software_req == 'b1) else $finish;
        wait_clk();
        assert(all_intif_int_software_req == 'b1) else $finish;
        assert(clint_bus_data == 'b1);
        bus_clint_data = 'b0;
        wait_clk();
        assert(all_intif_int_software_req == 'b0) else $finish;
        wait_clk();
        assert(all_intif_int_software_req == 'b0);
        assert(clint_bus_data == 'b0);
    endtask

    task test_mtime;
        rst = 1;
        bus_clint_read_addr = 'b0;
        bus_clint_write_addr = 'b0;
        bus_clint_read_size = 'h4;
        bus_clint_write_size = 'h4;
        bus_clint_data = 'b0;
        bus_clint_rd = 'b1;
        bus_clint_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        bus_clint_read_addr = MTIME_ADDR;
        bus_clint_write_addr = MTIME_ADDR;
        wait_clk();
        assert(clint_bus_data == 'b10) else $finish;
        bus_clint_data = 'b10100101;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_wr = 'b0;
        repeat(2) wait_clk();
        assert(clint_bus_data == 'b10100111) else $finish;
        bus_clint_read_addr = MTIME_ADDR + 'h4;
        wait_clk();
        assert(clint_bus_data == 'b0) else $finish;
        bus_clint_write_addr = MTIME_ADDR + 'h4;
        bus_clint_data = 'b01011010;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_wr = 'b0;
        wait_clk();
        assert(clint_bus_data == 'b01011010) else $finish;
        bus_clint_write_addr = MTIME_ADDR;
        bus_clint_read_addr = MTIME_ADDR;
        bus_clint_data = 'hffffffff;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_wr = 'b0;
        repeat(2) wait_clk();
        assert(clint_bus_data == 'b1) else $finish;
        bus_clint_read_addr = MTIME_ADDR + 'h4;
        wait_clk();
        assert(clint_bus_data == 'b01011011) else $finish;
    endtask

    task test_mtimecmp;
        rst = 1;
        bus_clint_read_addr = 'b0;
        bus_clint_write_addr = 'b0;
        bus_clint_read_size = 'h4;
        bus_clint_write_size = 'h4;
        bus_clint_data = 'b0;
        bus_clint_rd = 'b1;
        bus_clint_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        bus_clint_read_addr = MTIMECMP_ADDR;
        wait_clk();
        assert(clint_bus_data == 'b0) else $finish;
        bus_clint_read_addr = MTIMECMP_ADDR + 'h4;
        wait_clk();
        assert(clint_bus_data == 'b0) else $finish;
        bus_clint_write_addr = MTIMECMP_ADDR;
        bus_clint_data = 'b10100011;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_write_addr = MTIMECMP_ADDR + 'h4;
        bus_clint_data = 'b10010010;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_read_addr = MTIMECMP_ADDR;
        wait_clk();
        assert(clint_bus_data == 'b10100011) else $finish;
        bus_clint_read_addr = MTIMECMP_ADDR + 'h4;
        wait_clk();
        assert(clint_bus_data == 'b10010010) else $finish;
        wait_clk();
        bus_clint_write_addr = MTIME_ADDR + 'h4;
        bus_clint_data = 'b10010010;
        bus_clint_wr = 'b1;
        wait_clk();
        bus_clint_write_addr = MTIME_ADDR;
        bus_clint_data = 'b10100010;
        bus_clint_wr = 'b1;
        wait_clk();
        assert(all_intif_int_timer_req == 'b0) else $finish;
        bus_clint_wr = 'b0;
        wait_clk();
        assert(all_intif_int_timer_req == 'b1) else $finish;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        test_msip();
        test_mtime();
        test_mtimecmp();
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