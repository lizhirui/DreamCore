`include "config.svh"
`include "common.svh"

module top;
    localparam WIDTH = 8;

    logic[$clog2(WIDTH):0] data_in;
    logic[WIDTH - 1:0] data_out;
    
    expand_one #(
        .WIDTH(WIDTH)
    )expand_one_inst(.*);

    task test;
        data_in = 'd0;
        #10;
        assert(data_out == 'b0) else $finish;
        data_in = 'd1;
        #10;
        assert(data_out == 'b1) else $finish;
        data_in = 'd2;
        #10;
        assert(data_out == 'b11) else $finish;
        data_in = 'd3;
        #10;
        assert(data_out == 'b111) else $finish;
        data_in = 'd4;
        #10;
        assert(data_out == 'b1111) else $finish;
        data_in = 'd5;
        #10;
        assert(data_out == 'b11111) else $finish;
        data_in = 'd6;
        #10;
        assert(data_out == 'b111111) else $finish;
        data_in = 'd7;
        #10;
        assert(data_out == 'b1111111) else $finish;
        data_in = 'd8;
        #10;
        assert(data_out == 'b11111111) else $finish;
    endtask

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