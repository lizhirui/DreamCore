`include "config.svh"
`include "common.svh"

module execute_div(
        input logic clk,
        input logic rst,
        
        input issue_execute_pack_t issue_div_fifo_data_out,
        input logic issue_div_fifo_data_out_valid,
        output logic issue_div_fifo_pop,
        
        output execute_wb_pack_t div_wb_port_data_in,
        output logic div_wb_port_we,
        output logic div_wb_port_flush,
        
        output execute_feedback_channel_t div_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;

    logic overflow;

    assign div_wb_port_flush = !issue_div_fifo_data_out_valid || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign div_wb_port_we = !div_wb_port_flush;
    assign issue_div_fifo_pop = div_wb_port_we;

    assign rev_pack = issue_div_fifo_data_out;
    assign div_wb_port_data_in = send_pack;

    assign div_execute_channel_feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && div_wb_port_we && !send_pack.has_exception;
    assign div_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign div_execute_channel_feedback_pack.value = send_pack.rd_value;

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
    
    assign overflow = (rev_pack.src1_value == 'h80000000) && (rev_pack.src2_value == 'hFFFFFFFF);

    always_comb begin
        send_pack.rd_value = 'b0;

        case(rev_pack.sub_op.div_op)
            div_op_t::div: begin
                send_pack.rd_value = (rev_pack.src2_value == 0) ? 'hFFFFFFFF : overflow ? 'h80000000 : ($signed(rev_pack.src1_value) / $signed(rev_pack.src2_value));
            end

            div_op_t::divu: begin
                send_pack.rd_value = (rev_pack.src2_value == 0) ? 'hFFFFFFFF : (rev_pack.src1_value / rev_pack.src2_value);
            end

            div_op_t::rem: begin
                send_pack.rd_value = (rev_pack.src2_value == 0) ? rev_pack.src1_value : overflow ? 'h0 : ($signed(rev_pack.src1_value) % $signed(rev_pack.src2_value));
            end

            div_op_t::remu: begin
                send_pack.rd_value = (rev_pack.src2_value == 0) ? rev_pack.src1_value : (rev_pack.src1_value % rev_pack.src2_value);
            end
        endcase
    end
endmodule