
module top;
    localparam SEL_WIDTH = 4;
    localparam DATA_WIDTH = 2;

    logic[SEL_WIDTH - 1:0] sel_in;
    logic[DATA_WIDTH - 1:0] data_in[0:SEL_WIDTH - 1];
    logic[DATA_WIDTH - 1:0] data_out;
    logic data_out_valid;

    data_selector #(
        .SEL_WIDTH(SEL_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )data_selector_inst(
        .sel_in(sel_in),
        .data_in(data_in),
        .data_out(data_out),
        .data_out_valid(data_out_valid)
    );

    integer i;

    task test;
        for(i = 0;i < SEL_WIDTH;i++) begin
            data_in[i] = i;
        end

        #10
        sel_in = 'b0;
        #10
        assert(data_out_valid == 'b0) else $finish;

        for(i = 0;i < SEL_WIDTH;i++) begin
            sel_in = 1 << i;
            #10
            assert(data_out_valid == 'b1) else $finish;
            assert(data_out == i) else $finish;
        end
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