`include "config.svh"
`include "common.svh"

module top;
    localparam PORT_NUM = 4;
    localparam WIDTH = 4;

    logic clk;
    logic rst;
    
    logic[PORT_NUM - 1:0] data_in_enable;
    logic[WIDTH - 1:0] data_in[0:PORT_NUM - 1];
    logic[PORT_NUM - 1:0] data_in_valid;
    logic push;
    logic full;
    logic flush;
    
    logic[WIDTH - 1:0] data_out[0:PORT_NUM - 1];
    logic[PORT_NUM - 1:0] data_out_valid;
    logic[PORT_NUM - 1:0] data_pop_valid;
    logic pop;
    logic empty;

    logic[WIDTH - 1:0] cur_data;
    integer i;
    
    multififo #(
        .PORT_NUM(PORT_NUM),
        .WIDTH(WIDTH),
        .DEPTH(8)
    )multififo_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task reset;
        rst = 1;
        
        for(i = 0;i < PORT_NUM;i++) begin
            data_in[i] = 'b0;
            data_in_valid[i] = 'b0;
            data_pop_valid[i] = 'b0;
        end

        push = 'b0;
        flush = 'b0;
        pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
    endtask

    task test;
        reset();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b0) else $finish;
        assert(empty == 'b1) else $finish;
        data_in[0] = 'b0001;
        data_in_valid[0] = 'b1;
        push = 'b1;
        wait_clk();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b1) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b0001) else $finish;
        data_in[0] = 'b0010;
        data_in[1] = 'b0011;
        data_in[2] = 'b0100;
        data_in[3] = 'b0101;
        data_in_valid[0] = 'b1;
        data_in_valid[1] = 'b1;
        data_in_valid[2] = 'b1;
        data_in_valid[3] = 'b1;
        push = 'b1;
        wait_clk();
        assert(data_in_enable == 'b111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b1111) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b0001) else $finish;
        assert(data_out[1] == 'b0010) else $finish;
        assert(data_out[2] == 'b0011) else $finish;
        assert(data_out[3] == 'b0100) else $finish;
        data_in[0] = 'b1010;
        data_in[1] = 'b1011;
        data_in[2] = 'b1100;
        data_in[3] = 'b1101;
        data_in_valid[0] = 'b1;
        data_in_valid[1] = 'b1;
        data_in_valid[2] = 'b1;
        data_in_valid[3] = 'b1;
        push = 'b1;
        wait_clk();
        assert(data_in_enable == 'b0) else $finish;
        assert(full == 'b1) else $finish;
        assert(data_out_valid == 'b1111) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b0001) else $finish;
        assert(data_out[1] == 'b0010) else $finish;
        assert(data_out[2] == 'b0011) else $finish;
        assert(data_out[3] == 'b0100) else $finish;
        push = 'b0;
        data_pop_valid[0] = 'b1;
        pop = 'b1;
        wait_clk();
        assert(data_in_enable == 'b1) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b1111) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b0010) else $finish;
        assert(data_out[1] == 'b0011) else $finish;
        assert(data_out[2] == 'b0100) else $finish;
        assert(data_out[3] == 'b0101) else $finish;
        data_pop_valid[0] = 'b1;
        data_pop_valid[1] = 'b1;
        data_pop_valid[2] = 'b1;
        data_pop_valid[3] = 'b1;
        pop = 'b1;
        wait_clk();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b111) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b1010) else $finish;
        assert(data_out[1] == 'b1011) else $finish;
        assert(data_out[2] == 'b1100) else $finish;
        wait_clk();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b0) else $finish;
        assert(empty == 'b1) else $finish;
        data_in[0] = 'b0010;
        data_in[1] = 'b0011;
        data_in[2] = 'b0100;
        data_in[3] = 'b0101;
        data_in_valid[0] = 'b1;
        data_in_valid[1] = 'b1;
        data_in_valid[2] = 'b1;
        data_in_valid[3] = 'b1;
        push = 'b1;
        wait_clk();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b1111) else $finish;
        assert(empty == 'b0) else $finish;
        assert(data_out[0] == 'b0010) else $finish;
        assert(data_out[1] == 'b0011) else $finish;
        assert(data_out[2] == 'b0100) else $finish;
        assert(data_out[3] == 'b0101) else $finish;
        flush = 'b1;
        wait_clk();
        assert(data_in_enable == 'b1111) else $finish;
        assert(full == 'b0) else $finish;
        assert(data_out_valid == 'b0) else $finish;
        assert(empty == 'b1) else $finish;
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