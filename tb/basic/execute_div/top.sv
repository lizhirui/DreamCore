`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    issue_execute_pack_t issue_div_fifo_data_out;
    logic issue_div_fifo_data_out_valid;
    logic issue_div_fifo_pop;
    
    execute_wb_pack_t div_wb_port_data_in;
    logic div_wb_port_we;
    logic div_wb_port_flush;
    
    execute_feedback_channel_t div_execute_channel_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    issue_execute_pack_t t_pack;
    
    execute_div execute_div_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        t_pack.enable = 'b0;
        t_pack.value = 'b0;
        t_pack.valid = 'b0;
        t_pack.rob_id = 'b0;
        t_pack.pc = 'b0;
        t_pack.imm = 'b0;
        t_pack.has_exception = 'b0;
        t_pack.exception_id = riscv_exception_t::instruction_address_misaligned;
        t_pack.exception_value = 'b0;
        t_pack.predicted = 'b0;
        t_pack.predicted_jump = 'b0;
        t_pack.predicted_next_pc = 'b0;
        t_pack.checkpoint_id_valid = 'b0;
        t_pack.checkpoint_id = 'b0;
        t_pack.rs1 = 'b0;
        t_pack.arg1_src = arg_src_t::_reg;
        t_pack.rs1_need_map = 'b0;
        t_pack.rs1_phy = 'b0;
        t_pack.src1_value = 'b0;
        t_pack.src1_loaded = 'b0;
        t_pack.rs2 = 'b0;
        t_pack.arg2_src = arg_src_t::_reg;
        t_pack.rs2_need_map = 'b0;
        t_pack.rs2_phy = 'b0;
        t_pack.src2_value = 'b0;
        t_pack.src2_loaded = 'b0;
        t_pack.rd = 'b0;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        t_pack.rd_phy = 'b0;
        t_pack.csr = 'b0;
        t_pack.lsu_addr = 'b0;
        t_pack.op = op_t::div;
        t_pack.op_unit = op_unit_t::div;
        t_pack.sub_op.div_op = div_op_t::div;
        issue_div_fifo_data_out = t_pack;
        issue_div_fifo_data_out_valid = 'b0;
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
        assert(div_wb_port_data_in.enable == 'b0) else $finish;
        assert(div_wb_port_we == 'b0) else $finish;
        assert(div_wb_port_flush == 'b1) else $finish;
        assert(issue_div_fifo_pop == 'b0) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
        wait_clk();
        t_pack.enable = 'b1;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::illegal_instruction;
        issue_div_fifo_data_out = t_pack;
        wait_clk();
        assert(div_wb_port_we == 'b0) else $finish;
        assert(div_wb_port_flush == 'b1) else $finish;
        assert(issue_div_fifo_pop == 'b0) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
        issue_div_fifo_data_out_valid = 'b1;
        wait_clk();
        assert(div_wb_port_data_in.enable == 'b1) else $finish;
        assert(div_wb_port_data_in.valid == 'b0) else $finish;
        assert(div_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(div_wb_port_data_in.exception_id == riscv_exception_t::illegal_instruction) else $finish;
        assert(div_wb_port_we == 'b1) else $finish;
        assert(div_wb_port_flush == 'b0) else $finish;
        assert(issue_div_fifo_pop == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.valid = 'b1;
        t_pack.has_exception = 'b0;
        issue_div_fifo_data_out = t_pack;
        wait_clk();
        assert(div_wb_port_data_in.enable == 'b1) else $finish;
        assert(div_wb_port_data_in.valid == 'b1) else $finish;
        assert(div_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(div_wb_port_we == 'b1) else $finish;
        assert(div_wb_port_flush == 'b0) else $finish;
        assert(issue_div_fifo_pop == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::breakpoint;
        issue_div_fifo_data_out = t_pack;
        wait_clk();
        assert(div_wb_port_data_in.enable == 'b1) else $finish;
        assert(div_wb_port_data_in.valid == 'b1) else $finish;
        assert(div_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(div_wb_port_data_in.exception_id == riscv_exception_t::breakpoint) else $finish;
        assert(div_wb_port_we == 'b1) else $finish;
        assert(div_wb_port_flush == 'b0) else $finish;
        assert(issue_div_fifo_pop == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.has_exception = 'b0;
        t_pack.src1_value = 'd12;
        t_pack.src2_value = 'd6;
        t_pack.rd_phy = 'd10;
        t_pack.rd_enable = 'b1;
        t_pack.need_rename = 'b1;
        issue_div_fifo_data_out = t_pack;
        wait_clk();
        assert(div_wb_port_data_in.enable == 'b1) else $finish;
        assert(div_wb_port_data_in.valid == 'b1) else $finish;
        assert(div_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(div_wb_port_data_in.rd_value == unsigned'('d2)) else $finish;
        assert(div_wb_port_we == 'b1) else $finish;
        assert(div_wb_port_flush == 'b0) else $finish;
        assert(issue_div_fifo_pop == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.phy_id == unsigned'('d10)) else $finish;
        assert(div_execute_channel_feedback_pack.value == unsigned'('d2)) else $finish;
        commit_feedback_pack.enable = 'b1;
        wait_clk();
        assert(div_wb_port_data_in.enable == 'b1) else $finish;
        assert(div_wb_port_data_in.valid == 'b1) else $finish;
        assert(div_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(div_wb_port_we == 'b1) else $finish;
        assert(div_wb_port_flush == 'b0) else $finish;
        assert(issue_div_fifo_pop == 'b1) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b1) else $finish;
        commit_feedback_pack.flush = 'b1;
        wait_clk();
        assert(div_wb_port_we == 'b0) else $finish;
        assert(div_wb_port_flush == 'b1) else $finish;
        assert(issue_div_fifo_pop == 'b0) else $finish;
        assert(div_execute_channel_feedback_pack.enable == 'b0) else $finish;
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