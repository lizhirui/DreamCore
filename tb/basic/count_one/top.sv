`include "config.svh"
`include "common.svh"

module top;
    localparam WIDTH = 3;

    logic[WIDTH - 1:0] data_in;
    logic[$clog2(WIDTH):0] sum;

    logic[WIDTH - 1:0] con_data_in;
    logic[$clog2(WIDTH):0] con_sum;
    
    count_one #(
        .CONTINUOUS(0),
        .WIDTH(WIDTH)
    )count_one_inst(.*);

    count_one #(
        .CONTINUOUS(1),
        .WIDTH(WIDTH)
    )count_one_con_inst(
        .data_in(con_data_in),
        .sum(con_sum)
    );

    task test;
        data_in = 'b000;
        #10;
        assert(sum == 'd0) else $finish;
        #10;
        data_in = 'b001;
        #10;
        assert(sum == 'd1) else $finish;
        #10;
        data_in = 'b010;
        #10;
        assert(sum == 'd1) else $finish;
        #10;
        data_in = 'b011;
        #10;
        assert(sum == 'd2) else $finish;
        #10;
        data_in = 'b100;
        #10;
        assert(sum == 'd1) else $finish;
        #10;
        data_in = 'b101;
        #10;
        assert(sum == 'd2) else $finish;
        #10;
        data_in = 'b110;
        #10;
        assert(sum == 'd2) else $finish;
        #10;
        data_in = 'b111;
        #10;
        assert(sum == 'd3) else $finish;
    endtask

    task test_con;
        con_data_in = 'b000;
        #10;
        assert(con_sum == 'd0) else $finish;
        #10;
        con_data_in = 'b001;
        #10;
        assert(con_sum == 'd1) else $finish;
        #10;
        con_data_in = 'b010;
        #10;
        assert(con_sum == 'd0) else $finish;
        #10;
        con_data_in = 'b011;
        #10;
        assert(con_sum == 'd2) else $finish;
        #10;
        con_data_in = 'b100;
        #10;
        assert(con_sum == 'd0) else $finish;
        #10;
        con_data_in = 'b101;
        #10;
        assert(con_sum == 'd1) else $finish;
        #10;
        con_data_in = 'b110;
        #10;
        assert(con_sum == 'd0) else $finish;
        #10;
        con_data_in = 'b111;
        #10;
        assert(con_sum == 'd3) else $finish;
    endtask

    initial begin
        test();
        test_con();
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