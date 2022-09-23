`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id;
    checkpoint_t cpbuf_exbru_data;
    
    checkpoint_t exbru_bp_cp;
    logic[`ADDR_WIDTH -1:0] exbru_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] exbru_bp_instruction;
    logic exbru_bp_jump;
    logic[`ADDR_WIDTH - 1:0] exbru_bp_next_pc;
    logic exbru_bp_hit;
    logic exbru_bp_valid;
    
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mepc_data;
    
    issue_execute_pack_t issue_bru_fifo_data_out;
    logic issue_bru_fifo_data_out_valid;
    logic issue_bru_fifo_pop;
    
    execute_wb_pack_t bru_wb_port_data_in;
    logic bru_wb_port_we;
    logic bru_wb_port_flush;
    
    execute_feedback_channel_t bru_execute_channel_feedback_pack;
    commit_feedback_pack_t commit_feedback_pack;

    issue_execute_pack_t t_pack;
    
    execute_bru execute_bru_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        cpbuf_exbru_data = 'b0;
        csrf_all_mepc_data = 'b0;
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
        t_pack.op = op_t::beq;
        t_pack.op_unit = op_unit_t::bru;
        t_pack.sub_op.bru_op = bru_op_t::beq;
        issue_bru_fifo_data_out = t_pack;
        issue_bru_fifo_data_out_valid = 'b0;
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
        assert(bru_wb_port_data_in.enable == 'b0) else $finish;
        assert(bru_wb_port_we == 'b0) else $finish;
        assert(bru_wb_port_flush == 'b1) else $finish;
        assert(issue_bru_fifo_pop == 'b0) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        wait_clk();
        t_pack.enable = 'b1;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::illegal_instruction;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(bru_wb_port_we == 'b0) else $finish;
        assert(bru_wb_port_flush == 'b1) else $finish;
        assert(issue_bru_fifo_pop == 'b0) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        issue_bru_fifo_data_out_valid = 'b1;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b0) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(bru_wb_port_data_in.exception_id == riscv_exception_t::illegal_instruction) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.valid = 'b1;
        t_pack.has_exception = 'b0;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        t_pack.has_exception = 'b1;
        t_pack.exception_id = riscv_exception_t::breakpoint;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b1) else $finish;
        assert(bru_wb_port_data_in.exception_id == riscv_exception_t::breakpoint) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        cpbuf_exbru_data.local_history = 'h1574a2dc;
        t_pack.pc = 'h1526c2d8;
        t_pack.imm = 'h18745658;
        t_pack.value = 'h1574a035;
        t_pack.has_exception = 'b0;
        t_pack.predicted_jump = 'b0;
        t_pack.checkpoint_id = 'd35;
        t_pack.checkpoint_id_valid = 'b1;
        t_pack.op = op_t::jal;
        t_pack.sub_op.bru_op = bru_op_t::jal;
        t_pack.rd_phy = 'd10;
        t_pack.rd_enable = 'b1;
        t_pack.need_rename = 'b1;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(exbru_bp_cp.local_history == cpbuf_exbru_data.local_history) else $finish;
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(bru_wb_port_data_in.rd_value == unsigned'(t_pack.pc + 'd4)) else $finish;
        assert(bru_wb_port_data_in.bru_next_pc == unsigned'(t_pack.pc + t_pack.imm)) else $finish;
        assert(bru_wb_port_data_in.bru_jump == 'b1) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.phy_id == unsigned'('d10)) else $finish;
        assert(bru_execute_channel_feedback_pack.value == unsigned'(t_pack.pc + 'd4)) else $finish;
        assert(exbru_bp_pc == t_pack.pc);
        assert(exbru_bp_instruction == t_pack.value);
        assert(exbru_bp_jump == 'b1);
        assert(exbru_bp_next_pc == unsigned'(t_pack.pc + t_pack.imm));
        assert(exbru_bp_hit == 'b0);
        assert(exbru_bp_valid == 'b1);
        assert(exbru_cpbuf_id == t_pack.checkpoint_id);
        t_pack.op = op_t::mret;
        t_pack.sub_op.bru_op = bru_op_t::mret;
        csrf_all_mepc_data = 'h15251224;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(exbru_bp_pc == t_pack.pc);
        assert(exbru_bp_instruction == t_pack.value);
        assert(exbru_bp_jump == 'b1);
        assert(exbru_bp_next_pc == csrf_all_mepc_data);
        assert(exbru_bp_hit == 'b0);
        assert(exbru_bp_valid == 'b1);
        assert(exbru_cpbuf_id == t_pack.checkpoint_id);
        t_pack.op = op_t::beq;
        t_pack.sub_op.bru_op = bru_op_t::beq;
        t_pack.src1_value = 'h15286679;
        t_pack.src2_value = 'h15286679;
        t_pack.rd_enable = 'b0;
        t_pack.need_rename = 'b0;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(bru_wb_port_data_in.rd_value == 'b0) else $finish;
        assert(bru_wb_port_data_in.bru_next_pc == unsigned'(t_pack.pc + t_pack.imm)) else $finish;
        assert(bru_wb_port_data_in.bru_jump == 'b1) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        assert(exbru_bp_pc == t_pack.pc);
        assert(exbru_bp_instruction == t_pack.value);
        assert(exbru_bp_jump == 'b1);
        assert(exbru_bp_next_pc == unsigned'(t_pack.pc + t_pack.imm));
        assert(exbru_bp_hit == 'b0);
        assert(exbru_bp_valid == 'b1);
        assert(exbru_cpbuf_id == t_pack.checkpoint_id);
        t_pack.op = op_t::beq;
        t_pack.sub_op.bru_op = bru_op_t::beq;
        t_pack.src1_value = 'h15286679;
        t_pack.src2_value = 'h1528667a;
        issue_bru_fifo_data_out = t_pack;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(bru_wb_port_data_in.rd_value == 'b0) else $finish;
        assert(bru_wb_port_data_in.bru_next_pc == unsigned'(t_pack.pc + 'd4)) else $finish;
        assert(bru_wb_port_data_in.bru_jump == 'b0) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        assert(exbru_bp_pc == t_pack.pc);
        assert(exbru_bp_instruction == t_pack.value);
        assert(exbru_bp_jump == 'b0);
        assert(exbru_bp_next_pc == unsigned'(t_pack.pc + 'd4));
        assert(exbru_bp_hit == 'b1);
        assert(exbru_bp_valid == 'b1);
        assert(exbru_cpbuf_id == t_pack.checkpoint_id);
        commit_feedback_pack.enable = 'b1;
        wait_clk();
        assert(bru_wb_port_data_in.enable == 'b1) else $finish;
        assert(bru_wb_port_data_in.valid == 'b1) else $finish;
        assert(bru_wb_port_data_in.has_exception == 'b0) else $finish;
        assert(bru_wb_port_we == 'b1) else $finish;
        assert(bru_wb_port_flush == 'b0) else $finish;
        assert(issue_bru_fifo_pop == 'b1) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
        commit_feedback_pack.flush = 'b1;
        wait_clk();
        assert(bru_wb_port_we == 'b0) else $finish;
        assert(bru_wb_port_flush == 'b1) else $finish;
        assert(issue_bru_fifo_pop == 'b0) else $finish;
        assert(bru_execute_channel_feedback_pack.enable == 'b0) else $finish;
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