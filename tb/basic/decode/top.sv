`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic decode_csrf_decode_rename_fifo_full_add;
        
    fetch_decode_pack_t fetch_decode_fifo_data_out[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_out_valid;
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_pop_valid;
    logic fetch_decode_fifo_pop;
    
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_enable;
    decode_rename_pack_t decode_rename_fifo_data_in[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_valid;
    logic decode_rename_fifo_push;
    logic decode_rename_fifo_flush;
    
    decode_feedback_pack_t decode_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    fetch_decode_pack_t t_pack;

    integer i, j;

    decode decode_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        
        for(i = 0;i < `DECODE_WIDTH;i++) begin
            fetch_decode_fifo_data_out[i] = 'b0;
            fetch_decode_fifo_data_out_valid[i] = 'b0;
        end

        decode_rename_fifo_data_in_enable = 'b0;
        commit_feedback_pack.enable = 'b0;
        commit_feedback_pack.next_handle_rob_id_valid = 'b0;
        commit_feedback_pack.next_handle_rob_id = 'b0;
        commit_feedback_pack.has_exception = 'b0;
        commit_feedback_pack.exception_pc = 'b0;
        commit_feedback_pack.flush = 'b0;
        commit_feedback_pack.committed_rob_id = 'b0;
        commit_feedback_pack.committed_rob_id_valid = 'b0;
        commit_feedback_pack.jump_enable = 'b0;
        commit_feedback_pack.jump = 'b0;
        commit_feedback_pack.next_pc = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(fetch_decode_fifo_data_pop_valid == 'b0) else $finish;
        assert(fetch_decode_fifo_pop == 'b1) else $finish;
        assert(decode_rename_fifo_data_in_valid == 'b0) else $finish;
        assert(decode_rename_fifo_push == 'b1) else $finish;
        assert(decode_rename_fifo_flush == 'b0) else $finish;
        assert(decode_feedback_pack.idle == 'b1) else $finish;
        assert(decode_csrf_decode_rename_fifo_full_add == 'b0) else $finish;
        decode_rename_fifo_data_in_enable = ~(`DECODE_WIDTH'b0);
        eval();
        assert(decode_csrf_decode_rename_fifo_full_add == 'b0) else $finish;
        wait_clk();
        t_pack.enable = 'b1;
        t_pack.value = 'hf8410113;
        t_pack.has_exception = 'b0;
        
        for(i = 0;i < `DECODE_WIDTH;i++) begin
            fetch_decode_fifo_data_out[i] = t_pack;
            fetch_decode_fifo_data_out_valid[i] = 'b1;
        end

        wait_clk();
        
        for(i = 0;i < `DECODE_WIDTH;i++) begin
            assert(fetch_decode_fifo_data_pop_valid[i] == 'b1) else $finish;
            assert(decode_rename_fifo_data_in_valid[i] == 'b1) else $finish;
            assert(decode_rename_fifo_data_in[i].op == op_t::addi) else $finish;
            assert(decode_rename_fifo_data_in[i].op_unit == op_unit_t::alu) else $finish;
            assert(decode_rename_fifo_data_in[i].sub_op.alu_op == alu_op_t::add) else $finish;
            assert(decode_rename_fifo_data_in[i].value == t_pack.value) else $finish;
            assert(decode_rename_fifo_data_in[i].imm == -124) else $finish;
            assert(decode_rename_fifo_data_in[i].arg1_src == arg_src_t::_reg) else $finish;
            assert(decode_rename_fifo_data_in[i].rs1 == 'd2) else $finish;
            assert(decode_rename_fifo_data_in[i].arg2_src == arg_src_t::imm) else $finish;
            assert(decode_rename_fifo_data_in[i].rd == 'd2) else $finish;
            assert(decode_rename_fifo_data_in[i].rd_enable == 'b1) else $finish;
        end

        assert(fetch_decode_fifo_pop == 'b1) else $finish;
        assert(decode_feedback_pack.idle == 'b0) else $finish;
        commit_feedback_pack.enable = 'b1;
        commit_feedback_pack.flush = 'b1;
        eval();
        assert(decode_rename_fifo_flush == 'b1) else $finish;
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