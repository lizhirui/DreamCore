`include "config.svh"
`include "common.svh"

module execute_alu(
        input logic clk,
        input logic rst,
        
        input issue_execute_pack_t issue_alu_fifo_data_out,
        input logic issue_alu_fifo_data_out_valid,
        output logic issue_alu_fifo_pop,
        
        output execute_wb_pack_t alu_wb_port_data_in,
        output logic alu_wb_port_we,
        output logic alu_wb_port_flush,
        
        output execute_feedback_channel_t alu_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;

    logic new_has_exception;
    riscv_exception_t::_type new_exception_id;
    logic[`REG_DATA_WIDTH - 1:0] new_exception_value;

    assign alu_wb_port_flush = !issue_alu_fifo_data_out_valid || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign alu_wb_port_we = ~alu_wb_port_flush;
    assign issue_alu_fifo_pop = alu_wb_port_we;
    assign rev_pack = issue_alu_fifo_data_out;
    assign alu_wb_port_data_in = send_pack;

    assign alu_execute_channel_feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && alu_wb_port_we && !send_pack.has_exception;
    assign alu_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign alu_execute_channel_feedback_pack.value = send_pack.rd_value;

    assign send_pack.enable = rev_pack.enable;
    assign send_pack.value = rev_pack.value;
    assign send_pack.valid = rev_pack.valid;
    assign send_pack.rob_id = rev_pack.rob_id;
    assign send_pack.pc = rev_pack.pc;
    assign send_pack.imm = rev_pack.imm;

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

    assign send_pack.has_exception = rev_pack.has_exception || !rev_pack.valid || new_has_exception;
    assign send_pack.exception_id = rev_pack.has_exception ? rev_pack.exception_id : 
                                    !rev_pack.valid ? riscv_exception_t::illegal_instruction : new_exception_id;
    assign send_pack.exception_value = rev_pack.has_exception ? rev_pack.exception_value : 
                                       !rev_pack.valid ? 'b0 : new_exception_value;

    always_comb begin
        send_pack.rd_value = 'b0;
        new_has_exception = 'b0;
        new_exception_id =  riscv_exception_t::instruction_address_misaligned;
        new_exception_value = 'b0;

        case(rev_pack.sub_op.alu_op)
            alu_op_t::add: begin
                send_pack.rd_value = rev_pack.src1_value + rev_pack.src2_value;
            end

            alu_op_t::_and: begin
                send_pack.rd_value = rev_pack.src1_value & rev_pack.src2_value;
            end

            alu_op_t::auipc: begin
                send_pack.rd_value = rev_pack.imm + rev_pack.pc;
            end

            alu_op_t::ebreak: begin
                send_pack.rd_value = 0;
                new_has_exception = 'b1;
                new_exception_id = riscv_exception_t::breakpoint;
                new_exception_value = 0;
            end

            alu_op_t::ecall: begin
                send_pack.rd_value = 0;
                new_has_exception = 'b1;
                new_exception_id = riscv_exception_t::environment_call_from_m_mode;
                new_exception_value = 0;
            end

            alu_op_t::fence: begin
                send_pack.rd_value = 0;
            end

            alu_op_t::fence_i: begin
                send_pack.rd_value = 0;
            end

            alu_op_t::lui: begin
                send_pack.rd_value = rev_pack.imm;
            end

            alu_op_t::_or: begin
                send_pack.rd_value = rev_pack.src1_value | rev_pack.src2_value;
            end

            alu_op_t::sll: begin
                send_pack.rd_value = rev_pack.src1_value << rev_pack.src2_value[4:0];
            end

            alu_op_t::slt: begin
                send_pack.rd_value = (($signed(rev_pack.src1_value)) < ($signed(rev_pack.src2_value))) ? 1 : 0;
            end

            alu_op_t::sltu: begin
                send_pack.rd_value = (rev_pack.src1_value < rev_pack.src2_value) ? 1 : 0;
            end

            alu_op_t::sra: begin
                send_pack.rd_value = $unsigned($signed(rev_pack.src1_value) >>> rev_pack.src2_value[4:0]);
            end

            alu_op_t::srl: begin
                send_pack.rd_value = rev_pack.src1_value >> rev_pack.src2_value[4:0];
            end

            alu_op_t::sub: begin
                send_pack.rd_value = rev_pack.src1_value - rev_pack.src2_value;
            end

            alu_op_t::_xor: begin
                send_pack.rd_value = rev_pack.src1_value ^ rev_pack.src2_value;
            end
        endcase
    end

endmodule