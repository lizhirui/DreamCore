
module top;
    localparam WIDTH = 4;

    logic[WIDTH - 1:0] data_in;
    logic[$clog2(WIDTH) - 1:0] index;
    logic index_valid;

    parallel_finder #(
        .WIDTH(WIDTH)
    )parallel_finder_inst(
        .data_in(data_in),
        .index(index),
        .index_valid(index_valid)
    );

    task test;
        data_in = 'b0;
        #10
        assert(index_valid == 'b0) else $finish;
        #10
        data_in = 'b0001;
        #10
        assert(index_valid == 'b1) else $finish;
        assert(index == 'd0) else $finish;
        #10
        data_in = 'b0010;
        #10
        assert(index_valid == 'b1) else $finish;
        assert(index == 'd1) else $finish;
        #10
        data_in = 'b0100;
        #10
        assert(index_valid == 'b1) else $finish;
        assert(index == 'd2) else $finish;
        #10
        data_in = 'b1000;
        #10
        assert(index_valid == 'b1) else $finish;
        assert(index == 'd3) else $finish;
    endtask

    initial begin
        test();
        $display("TEST PASSED");
    end

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule