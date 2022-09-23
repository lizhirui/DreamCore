`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic ras_csrf_ras_full_add;
    logic[`ADDR_WIDTH - 1:0] bp_ras_addr;
    logic bp_ras_push;
    logic bp_ras_pop;
    logic[`ADDR_WIDTH - 1:0] ras_bp_addr;

    logic three_ras_csrf_ras_full_add;
    logic[`ADDR_WIDTH - 1:0] three_bp_ras_addr;
    logic three_bp_ras_push;
    logic three_bp_ras_pop;
    logic[`ADDR_WIDTH - 1:0] three_ras_bp_addr;

    logic big_ras_csrf_ras_full_add;
    logic[`ADDR_WIDTH - 1:0] big_bp_ras_addr;
    logic big_bp_ras_push;
    logic big_bp_ras_pop;
    logic[`ADDR_WIDTH - 1:0] big_ras_bp_addr;

    integer i;
    
    ras#(
        .DEPTH(2)
    )ras_inst(.*);

    ras#(
        .DEPTH(3)
    )ras_three_inst(
        .*,
        .ras_csrf_ras_full_add(three_ras_csrf_ras_full_add),
        .bp_ras_addr(three_bp_ras_addr),
        .bp_ras_push(three_bp_ras_push),
        .bp_ras_pop(three_bp_ras_pop),
        .ras_bp_addr(three_ras_bp_addr)
    );

    ras#(
        .DEPTH(`RAS_SIZE)
    )ras_big_inst(
        .*,
        .ras_csrf_ras_full_add(big_ras_csrf_ras_full_add),
        .bp_ras_addr(big_bp_ras_addr),
        .bp_ras_push(big_bp_ras_push),
        .bp_ras_pop(big_bp_ras_pop),
        .ras_bp_addr(big_ras_bp_addr)
    );

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        bp_ras_addr = 'b0;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        bp_ras_addr = 'b1;
        bp_ras_push = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;
        bp_ras_addr = 'b11;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        bp_ras_addr = 'b111;
        eval();
        assert(ras_csrf_ras_full_add == 'b1) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b111) else $finish;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
    endtask

    task test_cnt;
        rst = 1;
        bp_ras_addr = 'b0;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        bp_ras_addr = 'b1;
        bp_ras_push = 'b1;
        eval();
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;
        bp_ras_addr = 'b11;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        bp_ras_addr = 'b11;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        bp_ras_addr = 'b11;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
    endtask

    task test_cnt_max;
        rst = 1;
        bp_ras_addr = 'b0;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        bp_ras_addr = 'b1;
        bp_ras_push = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1) else $finish;

        for(i = 0;i < 32'hFFFFFFFF;i++) begin
            bp_ras_addr = 'b11;
            eval();
            assert(ras_csrf_ras_full_add == 'b0) else $finish;
            wait_clk();
            assert(ras_bp_addr == 'b11) else $finish;
        end
        
        bp_ras_addr = 'b11;
        eval();
        assert(ras_csrf_ras_full_add == 'b1) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b11) else $finish;
    endtask

    task test_push_pop;
        rst = 1;
        bp_ras_addr = 'b0;
        bp_ras_push = 'b0;
        bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        bp_ras_addr = 'b1001;
        bp_ras_push = 'b1;
        bp_ras_pop = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1001) else $finish;
        bp_ras_addr = 'b1111;
        bp_ras_pop = 'b1;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1111) else $finish;
        bp_ras_push = 'b0;
        eval();
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1111) else $finish;
        wait_clk();
        assert(ras_bp_addr == 'b1111) else $finish;
        assert(ras_csrf_ras_full_add == 'b0) else $finish;
    endtask

    task test_push_pop_cnt;
        rst = 1;
        three_bp_ras_addr = 'b0;
        three_bp_ras_push = 'b0;
        three_bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        three_bp_ras_addr = 'b0110;
        three_bp_ras_push = 'b1;
        eval();
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b0110) else $finish;
        three_bp_ras_addr = 'b1001;
        three_bp_ras_push = 'b1;
        eval();
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b1001) else $finish;
        three_bp_ras_addr = 'b1110;
        three_bp_ras_push = 'b1;
        eval();
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b1110) else $finish;
        three_bp_ras_addr = 'b1111;
        three_bp_ras_pop = 'b1;
        eval();
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b1111) else $finish;
        three_bp_ras_push = 'b0;
        eval();
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b1001) else $finish;
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b0110) else $finish;
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b0110) else $finish;
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(three_ras_bp_addr == 'b0110) else $finish;
        assert(three_ras_csrf_ras_full_add == 'b0) else $finish;
    endtask

    task test_big;
        rst = 1;
        big_bp_ras_addr = 'b0;
        big_bp_ras_push = 'b0;
        big_bp_ras_pop = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();

        for(i = 0;i < `RAS_SIZE;i++) begin
            big_bp_ras_addr = i;
            big_bp_ras_push = 'b1;
            eval();
            assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
            wait_clk();
            assert(big_ras_bp_addr == i) else $finish;
        end
        
        big_bp_ras_addr = `RAS_SIZE - 1;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        wait_clk();
        //push 80008148
        big_bp_ras_addr = 'h80008148;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b1) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008148) else $finish;
        //push 80008684
        big_bp_ras_addr = 'h80008684;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b1) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008684) else $finish;
        //push 80006308
        big_bp_ras_addr = 'h80006308;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b1) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        eval();
        assert(big_ras_csrf_ras_full_add == 'b1) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80006308) else $finish;
        //pop 80006308
        big_bp_ras_push = 'b0;
        big_bp_ras_pop = 'b1;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008684) else $finish;
        //push 80006338
        big_bp_ras_addr = 'h80006338;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80006338) else $finish;
        //pop 80006338
        big_bp_ras_push = 'b0;
        big_bp_ras_pop = 'b1;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008684) else $finish;
        //push 80006368
        big_bp_ras_addr = 'h80006368;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80006368) else $finish;
        //pop 80006368
        big_bp_ras_push = 'b0;
        big_bp_ras_pop = 'b1;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008684) else $finish;
        //push 80006398
        big_bp_ras_addr = 'h80006398;
        big_bp_ras_push = 'b1;
        big_bp_ras_pop = 'b0;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80006398) else $finish;
        //pop 80006398
        big_bp_ras_push = 'b0;
        big_bp_ras_pop = 'b1;
        eval();
        assert(ras_big_inst.need_throw == 'b0) else $finish;
        assert(ras_big_inst.need_cnt_sub == 'b0) else $finish;
        assert(big_ras_csrf_ras_full_add == 'b0) else $finish;
        wait_clk();
        assert(big_ras_bp_addr == 'h80008684) else $finish;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        test();
        test_cnt();
        test_cnt_max();
        test_push_pop();
        test_push_pop_cnt();
        test_big();
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