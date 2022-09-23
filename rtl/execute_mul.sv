`include "config.svh"
`include "common.svh"

module execute_mul(
        input logic clk,
        input logic rst,
        
        input issue_execute_pack_t issue_mul_fifo_data_out,
        input logic issue_mul_fifo_data_out_valid,
        output logic issue_mul_fifo_pop,
        
        output execute_wb_pack_t mul_wb_port_data_in,
        output logic mul_wb_port_we,
        output logic mul_wb_port_flush,
        
        output execute_feedback_channel_t mul_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;

    assign rev_pack = issue_mul_fifo_data_out;
    assign mul_wb_port_data_in = send_pack;

    assign mul_wb_port_flush = !issue_mul_fifo_data_out_valid || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign mul_wb_port_we = !mul_wb_port_flush;
    assign issue_mul_fifo_pop = mul_wb_port_we;

    assign mul_execute_channel_feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && mul_wb_port_we && !send_pack.has_exception;
    assign mul_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign mul_execute_channel_feedback_pack.value = send_pack.rd_value;

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

    assign send_pack.bru_jump = 'b0;
    assign send_pack.bru_next_pc = 'b0;

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

    always_comb begin
        send_pack.rd_value = 'b0;

        case(rev_pack.sub_op.mul_op)
            mul_op_t::mul: begin
                send_pack.rd_value = unsigned'(signed'(sign_extend_double#(32)::_do(rev_pack.src1_value)) * signed'(sign_extend_double#(32)::_do(rev_pack.src2_value)));
            end

            mul_op_t::mulh: begin
                send_pack.rd_value = unsigned'(signed'(sign_extend_double#(32)::_do(rev_pack.src1_value)) * signed'(sign_extend_double#(32)::_do(rev_pack.src2_value))) >> 32;
            end

            mul_op_t::mulhsu: begin
                send_pack.rd_value = unsigned'(signed'(sign_extend_double#(32)::_do(rev_pack.src1_value)) * signed'(unsign_extend_double#(32)::_do(rev_pack.src2_value))) >> 32;
            end

            mul_op_t::mulhu: begin
                send_pack.rd_value = (unsign_extend_double#(32)::_do(rev_pack.src1_value) * unsign_extend_double#(32)::_do(rev_pack.src2_value)) >> 32;
            end
        endcase
    end
endmodule