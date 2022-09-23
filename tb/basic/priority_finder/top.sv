
module top;
    localparam WIDTH = 4;

    logic[WIDTH - 1:0] data_in_first;
    logic[$clog2(WIDTH) - 1:0] index_first;
    logic index_valid_first;

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(WIDTH)
    )priority_finder_first_inst(
        .data_in(data_in_first),
        .index(index_first),
        .index_valid(index_valid_first)
    );

    logic[WIDTH - 1:0] data_in_last;
    logic[$clog2(WIDTH) - 1:0] index_last;
    logic index_valid_last;

    priority_finder #(
        .FIRST_PRIORITY(0),
        .WIDTH(WIDTH)
    )priority_finder_last_inst(
        .data_in(data_in_last),
        .index(index_last),
        .index_valid(index_valid_last)
    );

    task test_first;
        data_in_first = 'b0;
        #10
        assert(index_valid_first == 'b0) else $finish;
        #10
        data_in_first = 'b0001;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b0011;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b0101;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b0111;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b1001;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b1011;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b1101;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b1111;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd0) else $finish;
        #10
        data_in_first = 'b0010;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd1) else $finish;
        #10
        data_in_first = 'b0110;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd1) else $finish;
        #10
        data_in_first = 'b1010;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd1) else $finish;
        #10
        data_in_first = 'b1110;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd1) else $finish;
        #10
        data_in_first = 'b0100;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd2) else $finish;
        #10
        data_in_first = 'b1100;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd2) else $finish;
        #10
        data_in_first = 'b1000;
        #10
        assert(index_valid_first == 'b1) else $finish;
        assert(index_first == 'd3) else $finish;
    endtask

    task test_last;
        data_in_last = 'b0;
        #10
        assert(index_valid_last == 'b0) else $finish;
        #10
        data_in_last = 'b0001;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd0) else $finish;
        #10
        data_in_last = 'b0010;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd1) else $finish;
        #10
        data_in_last = 'b0011;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd1) else $finish;
        #10
        data_in_last = 'b0100;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd2) else $finish;
        #10
        data_in_last = 'b0101;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd2) else $finish;
        #10
        data_in_last = 'b0110;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd2) else $finish;
        #10
        data_in_last = 'b0111;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd2) else $finish;
        #10
        data_in_last = 'b1000;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        #10
        data_in_last = 'b1001;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        #10
        data_in_last = 'b1010;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        data_in_last = 'b1011;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        data_in_last = 'b1100;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        #10
        data_in_last = 'b1101;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        #10
        data_in_last = 'b1110;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
        #10
        data_in_last = 'b1111;
        #10
        assert(index_valid_last == 'b1) else $finish;
        assert(index_last == 'd3) else $finish;
    endtask

    initial begin
        test_first();
        test_last();
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