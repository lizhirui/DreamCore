`include "config.svh"
`include "common.svh"

`define assert_equal(_cycle, _expected, _actual) assert((_expected) == (_actual)) else begin $display("cycle = %0d, expected = %0x, actual = %0x", (_cycle), (_expected), (_actual)); #10; $finish; end

module top;
    localparam ITEM_NUM = 8;

    logic[ITEM_NUM - 1:0] seq;
    logic[$clog2(ITEM_NUM) - 1:0] start_pos;
    logic[$clog2(ITEM_NUM) - 1:0] enabled_item_id[0:ITEM_NUM - 1];

    integer i, j;

    list_enabled_item_id #(
        .ITEM_NUM(ITEM_NUM)
    )list_enabled_item_id_inst(.*);

    typedef logic[$clog2(ITEM_NUM) - 1:0] return_type[0:ITEM_NUM - 1];

    logic[$clog2(ITEM_NUM) - 1:0] model_result[0:ITEM_NUM - 1];
    int unsigned model_count;

    function return_type get_result(logic[ITEM_NUM - 1:0] seq, logic[$clog2(ITEM_NUM) - 1:0] start_pos);
        return_type ret;
        int unsigned i, index;

        index = 0;

        for(i = start_pos;i < ITEM_NUM;i++) begin
            if(seq[i]) begin
                ret[index] = i;
                index++;
            end
        end

        for(i = 0;i < start_pos;i++) begin
            if(seq[i]) begin
                ret[index] = i;
                index++;
            end
        end

        return ret;
    endfunction

    function int unsigned get_result_count(logic[ITEM_NUM - 1:0] seq);
        int unsigned i;
        int unsigned ret;

        ret = 0;

        for(i = 0;i < ITEM_NUM;i++) begin
            if(seq[i]) begin
                ret++;
            end
        end

        return ret;
    endfunction

    task eval;
        #0.1;
    endtask

    task test_simple;
       seq = 'b10100110;
       start_pos = 'b0;
       eval();
       `assert_equal(0, 'd1, enabled_item_id[0])
       `assert_equal(0, 'd2, enabled_item_id[1])
       `assert_equal(0, 'd5, enabled_item_id[2])
       `assert_equal(0, 'd7, enabled_item_id[3])
       seq = 'b10100110;
       start_pos = 'd5;
       eval();
       `assert_equal(0, 'd5, enabled_item_id[0])
       `assert_equal(0, 'd7, enabled_item_id[1])
       `assert_equal(0, 'd1, enabled_item_id[2])
       `assert_equal(0, 'd2, enabled_item_id[3])
    endtask

    task test_random;
        for(i = 0;i < 65536;i++) begin
            seq = $urandom_range(0, 2**ITEM_NUM - 1);
            start_pos = $urandom_range(0, ITEM_NUM - 1);
            model_result = get_result(seq, start_pos);
            model_count = get_result_count(seq);
            eval();

            for(j = 0;j < model_count;j++) begin
                `assert_equal(i * 100 + j, model_result[j], enabled_item_id[j])
            end
        end
    endtask

    initial begin
        test_simple();
        test_random();
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