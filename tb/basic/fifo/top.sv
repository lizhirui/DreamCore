`include "config.svh"
`include "common.svh"

module top;
    localparam WIDTH = 4;

    logic clk;
    logic rst;
    
    logic[WIDTH - 1:0] one_data_in;
    logic one_push;
    logic one_full;
    logic one_flush;
    logic[WIDTH - 1:0] one_data_out;
    logic one_data_out_valid;
    logic one_pop;
    logic one_empty;

    logic[WIDTH - 1:0] much_data_in;
    logic much_push;
    logic much_full;
    logic much_flush;
    logic[WIDTH - 1:0] much_data_out;
    logic much_data_out_valid;
    logic much_pop;
    logic much_empty;

    logic[WIDTH - 1:0] cur_data;
    integer i;
    
    fifo#(
        .WIDTH(WIDTH),
        .DEPTH(1)
    )fifo_one_inst(
        .*,
        .data_in(one_data_in),
        .push(one_push),
        .full(one_full),
        .flush(one_flush),
        .data_out(one_data_out),
        .data_out_valid(one_data_out_valid),
        .pop(one_pop),
        .empty(one_empty)
    );

    fifo#(
        .WIDTH(WIDTH),
        .DEPTH(2)
    )fifo_much_inst(
        .*,
        .data_in(much_data_in),
        .push(much_push),
        .full(much_full),
        .flush(much_flush),
        .data_out(much_data_out),
        .data_out_valid(much_data_out_valid),
        .pop(much_pop),
        .empty(much_empty)
    );

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test_one;
        rst = 1;
        one_data_in = 'b0;
        one_push = 'b0;
        one_flush = 'b0;
        one_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        one_data_in = 'b1011;
        one_push = 'b1;
        wait_clk();
        assert(one_full == 'b1) else $finish;
        assert(one_data_out == 'b1011) else $finish;
        assert(one_data_out_valid == 'b1) else $finish;
        assert(one_empty == 'b0) else $finish;
        wait_clk();
        one_data_in = 'b0110;
        one_push = 'b1;
        wait_clk();
        assert(one_full == 'b1) else $finish;
        assert(one_data_out == 'b1011) else $finish;
        assert(one_data_out_valid == 'b1) else $finish;
        assert(one_empty == 'b0) else $finish;
        wait_clk();
        one_data_in = 'b0110;
        one_push = 'b1;
        one_pop = 'b1;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        assert(one_full == 'b1) else $finish;
        assert(one_data_out == 'b0110) else $finish;
        assert(one_data_out_valid == 'b1) else $finish;
        assert(one_empty == 'b0) else $finish;
        wait_clk();
        one_push = 'b0;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        one_data_in = 'b1010;
        one_push = 'b1;
        wait_clk();
        assert(one_full == 'b1) else $finish;
        assert(one_data_out == 'b1010) else $finish;
        assert(one_data_out_valid == 'b1) else $finish;
        assert(one_empty == 'b0) else $finish;
        wait_clk();
        one_flush = 'b1;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        one_data_in = 'b1010;
        one_push = 'b1;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();
        one_pop = 'b1;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
    endtask

    task test_one_random;
        rst = 1;
        one_data_in = 'b0;
        one_push = 'b0;
        one_flush = 'b0;
        one_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(one_full == 'b0) else $finish;
        assert(one_data_out_valid == 'b0) else $finish;
        assert(one_empty == 'b1) else $finish;
        wait_clk();

        for(i = 0;i < 10000;i++) begin
            cur_data = $urandom_range(0, 2**WIDTH - 1);
            one_data_in = cur_data;
            one_push = 'b1;
            wait_clk();
            assert(one_full == 'b1) else $finish;
            assert(one_data_out == cur_data) else $finish;
            assert(one_data_out_valid == 'b1) else $finish;
            assert(one_empty == 'b0) else $finish;
            wait_clk();
            one_data_in = cur_data + 1;
            wait_clk();
            assert(one_full == 'b1) else $finish;
            assert(one_data_out == cur_data) else $finish;
            assert(one_data_out_valid == 'b1) else $finish;
            assert(one_empty == 'b0) else $finish;
            wait_clk();
            one_pop = 'b1;
            wait_clk();
            assert(one_full == 'b0) else $finish;
            assert(one_data_out_valid == 'b0) else $finish;
            assert(one_empty == 'b1) else $finish;
            wait_clk();
            assert(one_full == 'b1) else $finish;
            assert(one_data_out == WIDTH'(cur_data + 1)) else $finish;
            assert(one_data_out_valid == 'b1) else $finish;
            assert(one_empty == 'b0) else $finish;
            wait_clk();
            one_flush = 'b1;
            wait_clk();
            assert(one_full == 'b0) else $finish;
            assert(one_data_out_valid == 'b0) else $finish;
            assert(one_empty == 'b1) else $finish;
            one_push = 'b0;
            one_pop = 'b0;
            one_flush = 'b0;
            wait_clk();
            assert(one_full == 'b0) else $finish;
            assert(one_data_out_valid == 'b0) else $finish;
            assert(one_empty == 'b1) else $finish;
        end
    endtask

    task test_much;
        rst = 1;
        much_data_in = 'b0;
        much_push = 'b0;
        much_flush = 'b0;
        much_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
        wait_clk();
        much_data_in = 'b1001;
        much_push = 'b1;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out == 'b1001) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        much_data_in = 'b0110;
        wait_clk();
        assert(much_full == 'b1) else $finish;
        assert(much_data_out == 'b1001) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        wait_clk();
        much_data_in = 'b0011;
        wait_clk();
        assert(much_full == 'b1) else $finish;
        assert(much_data_out == 'b1001) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        wait_clk();
        much_pop = 'b1;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out == 'b0110) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        much_push = 'b0;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
        wait_clk();
        much_pop = 'b0;
        much_data_in = 'b1001;
        much_push = 'b1;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out == 'b1001) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        much_data_in = 'b0110;
        wait_clk();
        assert(much_full == 'b1) else $finish;
        assert(much_data_out == 'b1001) else $finish;
        assert(much_data_out_valid == 'b1) else $finish;
        assert(much_empty == 'b0) else $finish;
        much_flush = 'b1;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
        much_push = 'b0;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
    endtask

    task test_much_random;
        rst = 1;
        much_data_in = 'b0;
        much_push = 'b0;
        much_flush = 'b0;
        much_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(much_full == 'b0) else $finish;
        assert(much_data_out_valid == 'b0) else $finish;
        assert(much_empty == 'b1) else $finish;
        wait_clk();

        for(i = 0;i < 10000;i++) begin
            cur_data = $urandom_range(0, 2**WIDTH - 1);
            much_data_in = cur_data;
            much_push = 'b1;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out == cur_data) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            much_data_in = cur_data + 1;
            wait_clk();
            assert(much_full == 'b1) else $finish;
            assert(much_data_out == cur_data) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            wait_clk();
            much_pop = 'b1;
            much_data_in = cur_data;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out == WIDTH'(cur_data + 1)) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out == cur_data) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            much_push = 'b0;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out_valid == 'b0) else $finish;
            assert(much_empty == 'b1) else $finish;
            much_pop = 'b0;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out_valid == 'b0) else $finish;
            assert(much_empty == 'b1) else $finish;
            much_data_in = cur_data;
            much_push = 'b1;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out == cur_data) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            much_data_in = cur_data + 1;
            wait_clk();
            assert(much_full == 'b1) else $finish;
            assert(much_data_out == cur_data) else $finish;
            assert(much_data_out_valid == 'b1) else $finish;
            assert(much_empty == 'b0) else $finish;
            wait_clk();
            much_flush = 'b1;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out_valid == 'b0) else $finish;
            assert(much_empty == 'b1) else $finish;
            much_flush = 'b0;
            much_push = 'b0;
            wait_clk();
            assert(much_full == 'b0) else $finish;
            assert(much_data_out_valid == 'b0) else $finish;
            assert(much_empty == 'b1) else $finish;
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        test_one();
        test_one_random();
        test_much();
        test_much_random();
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