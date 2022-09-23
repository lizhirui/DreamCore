`include "config.svh"
`include "common.svh"

module execute_bru(
        input logic clk,
        input logic rst,
        
        output logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id,
        input checkpoint_t cpbuf_exbru_data,
        
        output checkpoint_t exbru_bp_cp,
        output logic[`ADDR_WIDTH -1:0] exbru_bp_pc,
        output logic[`INSTRUCTION_WIDTH - 1:0] exbru_bp_instruction,
        output logic exbru_bp_jump,
        output logic[`ADDR_WIDTH - 1:0] exbru_bp_next_pc,
        output logic exbru_bp_hit,
        output logic exbru_bp_valid,
        
        input logic[`REG_DATA_WIDTH - 1:0] csrf_all_mepc_data,
        
        input issue_execute_pack_t issue_bru_fifo_data_out,
        input logic issue_bru_fifo_data_out_valid,
        output logic issue_bru_fifo_pop,
        
        output execute_wb_pack_t bru_wb_port_data_in,
        output logic bru_wb_port_we,
        output logic bru_wb_port_flush,
        
        output execute_feedback_channel_t bru_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;
    logic new_next_pc_valid;
    logic[`REG_DATA_WIDTH - 1:0] new_next_pc;

    assign bru_wb_port_flush = !issue_bru_fifo_data_out_valid || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign bru_wb_port_we = !bru_wb_port_flush;
    assign issue_bru_fifo_pop = bru_wb_port_we;

    assign rev_pack = issue_bru_fifo_data_out;
    assign bru_wb_port_data_in = send_pack;

    assign exbru_cpbuf_id = rev_pack.checkpoint_id;
    assign exbru_bp_cp = cpbuf_exbru_data;
    assign exbru_bp_pc = send_pack.pc;
    assign exbru_bp_instruction = rev_pack.value;
    assign exbru_bp_jump = send_pack.bru_jump;
    assign exbru_bp_next_pc = send_pack.bru_next_pc;
    assign exbru_bp_hit = send_pack.predicted_jump == send_pack.bru_jump;
    assign exbru_bp_valid = bru_wb_port_we && rev_pack.enable && rev_pack.valid && rev_pack.checkpoint_id_valid;

    assign bru_execute_channel_feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && bru_wb_port_we && !send_pack.has_exception;
    assign bru_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign bru_execute_channel_feedback_pack.value = send_pack.rd_value;

    assign send_pack.enable = rev_pack.enable;
    assign send_pack.value = rev_pack.value;
    assign send_pack.valid = rev_pack.valid;
    assign send_pack.rob_id = rev_pack.rob_id;
    assign send_pack.pc = rev_pack.pc;
    assign send_pack.imm = rev_pack.imm;
    assign send_pack.has_exception = rev_pack.has_exception;
    assign send_pack.exception_id = rev_pack.exception_id;
    assign send_pack.exception_value = rev_pack.exception_value;

    assign send_pack.predicted = rev_pack.predicted;
    assign send_pack.predicted_jump = rev_pack.predicted_jump;
    assign send_pack.predicted_next_pc = rev_pack.predicted_next_pc;
    assign send_pack.checkpoint_id_valid = rev_pack.checkpoint_id_valid;
    assign send_pack.checkpoint_id = rev_pack.checkpoint_id;

    assign send_pack.rs1 = rev_pack.rs1;
    assign send_pack.arg1_src = rev_pack.arg1_src;
    assign send_pack.rs1_need_map = rev_pack.rs1_need_map;
    assign send_pack.rs1_phy = rev_pack.rs1_phy;
    assign send_pack.src1_value = rev_pack.src1_value;
    assign send_pack.src1_loaded = rev_pack.src1_loaded;

    assign send_pack.rs2 = rev_pack.rs2;
    assign send_pack.arg2_src = rev_pack.arg2_src;
    assign send_pack.rs2_need_map = rev_pack.rs2_need_map;
    assign send_pack.rs2_phy = rev_pack.rs2_phy;
    assign send_pack.src2_value = rev_pack.src2_value;
    assign send_pack.src2_loaded = rev_pack.src2_loaded;

    assign send_pack.rd = rev_pack.rd;
    assign send_pack.rd_enable = rev_pack.rd_enable;
    assign send_pack.need_rename = rev_pack.need_rename;
    assign send_pack.rd_phy = rev_pack.rd_phy;

    assign send_pack.csr = rev_pack.csr;
    assign send_pack.csr_newvalue = 'b0;
    assign send_pack.csr_newvalue_valid = 'b0;
    assign send_pack.op = rev_pack.op;
    assign send_pack.op_unit = rev_pack.op_unit;
    assign send_pack.sub_op.raw_data = rev_pack.sub_op.raw_data;

    assign send_pack.bru_next_pc = send_pack.bru_jump ? (new_next_pc_valid ? new_next_pc : (rev_pack.pc + rev_pack.imm)) : (rev_pack.pc + 'd4);

    always_comb begin
        send_pack.rd_value = 'b0;
        send_pack.bru_jump = 'b0;
        new_next_pc_valid = 'b0;
        new_next_pc = 'b0;

        case(rev_pack.sub_op.bru_op)
            bru_op_t::beq: begin
                send_pack.bru_jump = rev_pack.src1_value == rev_pack.src2_value;
            end

            bru_op_t::bge: begin
                send_pack.bru_jump = ($signed(rev_pack.src1_value)) >= ($signed(rev_pack.src2_value));
            end

            bru_op_t::bgeu: begin
                send_pack.bru_jump = rev_pack.src1_value >= rev_pack.src2_value;
            end

            bru_op_t::blt: begin
                send_pack.bru_jump = ($signed(rev_pack.src1_value)) < ($signed(rev_pack.src2_value));
            end

            bru_op_t::bltu: begin
                send_pack.bru_jump = rev_pack.src1_value < rev_pack.src2_value;
            end

            bru_op_t::bne: begin
                send_pack.bru_jump = rev_pack.src1_value != rev_pack.src2_value;
            end

            bru_op_t::jal: begin
                send_pack.rd_value = rev_pack.pc + 'd4;
                send_pack.bru_jump = 'b1;
            end

            bru_op_t::jalr: begin
                send_pack.rd_value = rev_pack.pc + 'd4;
                send_pack.bru_jump = 'b1;
                new_next_pc_valid = 'b1;
                new_next_pc = (rev_pack.imm + rev_pack.src1_value) & (~`REG_DATA_WIDTH'h1);
            end

            bru_op_t::mret: begin
                send_pack.bru_jump = 'b1;
                new_next_pc_valid = 'b1;
                new_next_pc = csrf_all_mepc_data;
            end
            endcase
    end

endmodule