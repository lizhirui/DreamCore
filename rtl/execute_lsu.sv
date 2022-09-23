`include "config.svh"
`include "common.svh"

module execute_lsu(
        input logic clk,
        input logic rst,
        
        input logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data,
        input logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback,
        input logic stbuf_exlsu_bus_ready,
        
        output logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id,
        output logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr,
        output logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size,
        output logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data,
        output logic exlsu_stbuf_push,
        input logic stbuf_exlsu_full,
        
        input issue_execute_pack_t issue_lsu_fifo_data_out,
        input logic issue_lsu_fifo_data_out_valid,
        output logic issue_lsu_fifo_pop,
        
        output execute_wb_pack_t lsu_wb_port_data_in,
        output logic lsu_wb_port_we,
        output logic lsu_wb_port_flush,
        
        output execute_feedback_channel_t lsu_execute_channel_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    logic is_load;
    logic busy;
    logic inst_valid;
    issue_execute_pack_t rev_pack;
    execute_wb_pack_t send_pack;

    assign inst_valid = issue_lsu_fifo_data_out_valid && rev_pack.enable && rev_pack.valid;

    assign lsu_wb_port_flush = busy || !issue_lsu_fifo_data_out_valid || (inst_valid && is_load && !rev_pack.has_exception && !stbuf_exlsu_bus_ready) || (commit_feedback_pack.enable && commit_feedback_pack.flush);
    assign lsu_wb_port_we = !lsu_wb_port_flush;
    assign issue_lsu_fifo_pop = lsu_wb_port_we;

    assign rev_pack = issue_lsu_fifo_data_out;
    assign lsu_wb_port_data_in = send_pack;

    assign exlsu_stbuf_push = !is_load && lsu_wb_port_we && inst_valid && !rev_pack.has_exception;

    assign busy = inst_valid && !is_load && stbuf_exlsu_full && !(commit_feedback_pack.enable && commit_feedback_pack.flush);

    assign lsu_execute_channel_feedback_pack.enable = inst_valid && send_pack.rd_enable && send_pack.need_rename && lsu_wb_port_we && !send_pack.has_exception;
    assign lsu_execute_channel_feedback_pack.phy_id = send_pack.rd_phy;
    assign lsu_execute_channel_feedback_pack.value = send_pack.rd_value;

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

    assign exlsu_stbuf_rob_id = rev_pack.rob_id;
    assign exlsu_stbuf_write_addr = rev_pack.lsu_addr;

    always_comb begin
        send_pack.rd_value = 'b0;
        exlsu_stbuf_write_data = 'b0;
        exlsu_stbuf_write_size = 'b0;
        is_load = 'b0;

        case(rev_pack.sub_op.lsu_op)
            lsu_op_t::lb: begin
                send_pack.rd_value = sign_extend#(8)::_do(stbuf_exlsu_bus_data_feedback[7:0]);
                is_load = 'b1;
            end

            lsu_op_t::lbu: begin
                send_pack.rd_value = stbuf_exlsu_bus_data_feedback[7:0];
                is_load = 'b1;
            end

            lsu_op_t::lh: begin
                send_pack.rd_value = sign_extend#(16)::_do(stbuf_exlsu_bus_data_feedback[15:0]);
                is_load = 'b1;
            end

            lsu_op_t::lhu: begin
                send_pack.rd_value = stbuf_exlsu_bus_data_feedback[15:0];
                is_load = 'b1;
            end

            lsu_op_t::lw: begin
                send_pack.rd_value = stbuf_exlsu_bus_data_feedback[31:0];
                is_load = 'b1;
            end

            lsu_op_t::sb: begin
                exlsu_stbuf_write_data = rev_pack.src2_value[7:0];
                exlsu_stbuf_write_size = 'd1;
            end

            lsu_op_t::sh: begin
                exlsu_stbuf_write_data = rev_pack.src2_value[15:0];
                exlsu_stbuf_write_size = 'd2;
            end

            lsu_op_t::sw: begin
                exlsu_stbuf_write_data = rev_pack.src2_value;
                exlsu_stbuf_write_size = 'd4;
            end
        endcase
    end
endmodule