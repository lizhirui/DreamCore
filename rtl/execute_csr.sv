`include "config.svh"
`include "common.svh"

module execute_csr(
        input logic clk,
        input logic rst,
        
        output logic[`CSR_ADDR_WIDTH - 1:0] excsr_csrf_addr,
        input logic[`REG_DATA_WIDTH - 1:0] csrf_excsr_data,
        
        input issue_execute_pack_t issue_csr_fifo_data_out,
        input logic issue_csr_fifo_data_out_valid,
        output logic issue_csr_fifo_pop,
        
        output execute_wb_pack_t csr_wb_port_data_in,
        output logic csr_wb_port_we,
        output logic csr_wb_port_flush,
        
        output execute_feedback_channel_t csr_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;

    logic csr_addr_read_valid;
    logic csr_addr_write_valid;

    assign rev_pack = issue_csr_fifo_data_out;
    assign csr_wb_port_data_in = send_pack;

    assign csr_wb_port_flush = !issue_csr_fifo_data_out_valid || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign csr_wb_port_we = !csr_wb_port_flush;
    assign issue_csr_fifo_pop = csr_wb_port_we;

    assign excsr_csrf_addr = rev_pack.csr;

    assign csr_execute_channel_feedback_pack.enable = send_pack.enable && send_pack.valid && send_pack.rd_enable && send_pack.need_rename && csr_wb_port_we && !send_pack.has_exception;
    assign csr_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign csr_execute_channel_feedback_pack.value = send_pack.rd_value;

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
    assign send_pack.op = rev_pack.op;
    assign send_pack.op_unit = rev_pack.op_unit; 
    assign send_pack.sub_op.raw_data = rev_pack.sub_op.raw_data;

    csr_access_check #(
        .WRITE_PREMISSION(0)
    )csr_access_check_read_inst(
        .csr_addr(rev_pack.csr),
        .valid(csr_addr_read_valid)
    );

    csr_access_check #(
        .WRITE_PREMISSION(1)
    )csr_access_check_write_inst(
        .csr_addr(rev_pack.csr),
        .valid(csr_addr_write_valid)
    );

    assign send_pack.has_exception = !csr_addr_read_valid || (rev_pack.rs1_need_map && !csr_addr_write_valid);
    assign send_pack.exception_id = riscv_exception_t::illegal_instruction;
    assign send_pack.exception_value = !csr_addr_read_valid ? 'b0 : rev_pack.value;
    assign send_pack.rd_value = csrf_excsr_data;
    assign send_pack.csr_newvalue_valid = !((rev_pack.arg1_src == arg_src_t::_reg) && !rev_pack.rs1_need_map) && csr_addr_write_valid;

    always_comb begin
        send_pack.csr_newvalue = 'b0;

        case(rev_pack.sub_op.csr_op)
            csr_op_t::csrrc: begin
                send_pack.csr_newvalue = csrf_excsr_data & ~(rev_pack.src1_value);
            end

            csr_op_t::csrrs: begin
                send_pack.csr_newvalue = csrf_excsr_data | rev_pack.src1_value;
            end

            csr_op_t::csrrw: begin
                send_pack.csr_newvalue = rev_pack.src1_value;
            end
        endcase
    end
endmodule