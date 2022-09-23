`include "config.svh"
`include "common.svh"

module top;
    localparam WIDTH = 4;

    logic clk;
    logic rst;
    
    logic[WIDTH - 1:0] data_in;
    logic we;
    logic flush;
    logic[WIDTH - 1:0] data_out;

    logic[WIDTH - 1:0] cur_data;
    integer i;
    
    port#(
        .WIDTH(WIDTH)
    )port_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        data_in = 'b0;
        we = 'b0;
        flush = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(data_out == 'b0) else $finish;
        data_in = 'b1001;
        wait_clk();
        assert(data_out == 'b0) else $finish;
        wait_clk();
        we = 'b1;
        wait_clk();
        assert(data_out == 'b1001) else $finish;
        wait_clk();
        flush = 'b1;
        wait_clk();
        assert(data_out == 'b0) else $finish;
        flush = 'b0;
        we = 'b0;
        wait_clk();
        assert(data_out == 'b0) else $finish;
    endtask

    task test_random;
        rst = 1;
        data_in = 'b0;
        we = 'b0;
        flush = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(data_out == 'b0) else $finish;
        wait_clk();

        for(i = 0;i < 10000;i++) begin
            cur_data = $urandom_range(0, 2**WIDTH - 1);
            data_in = cur_data;
            we = 'b1;
            wait_clk();
            assert(data_out == cur_data) else $finish;
            data_in = cur_data + 1;
            we = 'b0;
            wait_clk();
            assert(data_out == WIDTH'(cur_data + 1)) else $finish;
            flush = 'b1;
            wait_clk();
            assert(data_out == 'b0) else $finish;
            we = 'b1;
            wait_clk();
            assert(data_out == 'b0) else $finish;
            flush = 'b0;
            we = 'b0;
            wait_clk();
            assert(data_out == 'b0) else $finish;
        end
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