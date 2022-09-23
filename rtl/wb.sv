`include "config.svh"
`include "common.svh"

module wb(
        input logic clk,
        input logic rst,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1],
        output logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1],
        output logic[`WB_WIDTH - 1:0] wb_phyf_we,
        
        input execute_wb_pack_t alu_wb_port_data_out[0:`ALU_UNIT_NUM - 1],
        input execute_wb_pack_t bru_wb_port_data_out[0:`BRU_UNIT_NUM - 1],
        input execute_wb_pack_t csr_wb_port_data_out[0:`CSR_UNIT_NUM - 1],
        input execute_wb_pack_t div_wb_port_data_out[0:`DIV_UNIT_NUM - 1],
        input execute_wb_pack_t lsu_wb_port_data_out[0:`LSU_UNIT_NUM - 1],
        input execute_wb_pack_t mul_wb_port_data_out[0:`MUL_UNIT_NUM - 1],
        
        output wb_commit_pack_t wb_commit_port_data_in,
        output logic wb_commit_port_we,
        output logic wb_commit_port_flush,
        
        output wb_feedback_pack_t wb_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    execute_wb_pack_t execute_wb_port[0:`EXECUTE_UNIT_NUM - 1];

    genvar i;

    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            assign execute_wb_port[i] = alu_wb_port_data_out[i];
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            assign execute_wb_port[`ALU_UNIT_NUM + i] = bru_wb_port_data_out[i];
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            assign execute_wb_port[`ALU_UNIT_NUM + `BRU_UNIT_NUM + i] = csr_wb_port_data_out[i];
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            assign execute_wb_port[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + i] = div_wb_port_data_out[i];
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            assign execute_wb_port[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + i] = lsu_wb_port_data_out[i];
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            assign execute_wb_port[`ALU_UNIT_NUM + `BRU_UNIT_NUM + `CSR_UNIT_NUM + `DIV_UNIT_NUM + `LSU_UNIT_NUM + i] = mul_wb_port_data_out[i];
        end
    endgenerate

    assign wb_commit_port_flush = commit_feedback_pack.enable & commit_feedback_pack.flush;
    assign wb_commit_port_we = 'b1;

    generate
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            assign wb_commit_port_data_in.op_info[i].enable = execute_wb_port[i].enable;
            assign wb_commit_port_data_in.op_info[i].value = execute_wb_port[i].value;
            assign wb_commit_port_data_in.op_info[i].valid = execute_wb_port[i].valid;
            assign wb_commit_port_data_in.op_info[i].rob_id = execute_wb_port[i].rob_id;
            assign wb_commit_port_data_in.op_info[i].pc = execute_wb_port[i].pc;
            assign wb_commit_port_data_in.op_info[i].imm = execute_wb_port[i].imm;
            assign wb_commit_port_data_in.op_info[i].has_exception = execute_wb_port[i].has_exception;
            assign wb_commit_port_data_in.op_info[i].exception_id = execute_wb_port[i].exception_id;
            assign wb_commit_port_data_in.op_info[i].exception_value = execute_wb_port[i].exception_value;

            assign wb_commit_port_data_in.op_info[i].predicted = execute_wb_port[i].predicted;
            assign wb_commit_port_data_in.op_info[i].predicted_jump = execute_wb_port[i].predicted_jump;
            assign wb_commit_port_data_in.op_info[i].predicted_next_pc = execute_wb_port[i].predicted_next_pc;
            assign wb_commit_port_data_in.op_info[i].checkpoint_id_valid = execute_wb_port[i].checkpoint_id_valid;
            assign wb_commit_port_data_in.op_info[i].checkpoint_id = execute_wb_port[i].checkpoint_id;

            assign wb_commit_port_data_in.op_info[i].bru_jump = execute_wb_port[i].bru_jump;
            assign wb_commit_port_data_in.op_info[i].bru_next_pc = execute_wb_port[i].bru_next_pc;

            assign wb_commit_port_data_in.op_info[i].rs1 = execute_wb_port[i].rs1;
            assign wb_commit_port_data_in.op_info[i].arg1_src = execute_wb_port[i].arg1_src;
            assign wb_commit_port_data_in.op_info[i].rs1_need_map = execute_wb_port[i].rs1_need_map;
            assign wb_commit_port_data_in.op_info[i].rs1_phy = execute_wb_port[i].rs1_phy;
            assign wb_commit_port_data_in.op_info[i].src1_value = execute_wb_port[i].src1_value;
            assign wb_commit_port_data_in.op_info[i].src1_loaded = execute_wb_port[i].src1_loaded;

            assign wb_commit_port_data_in.op_info[i].rs2 = execute_wb_port[i].rs2;
            assign wb_commit_port_data_in.op_info[i].arg2_src = execute_wb_port[i].arg2_src;
            assign wb_commit_port_data_in.op_info[i].rs2_need_map = execute_wb_port[i].rs2_need_map;
            assign wb_commit_port_data_in.op_info[i].rs2_phy = execute_wb_port[i].rs2_phy;
            assign wb_commit_port_data_in.op_info[i].src2_value = execute_wb_port[i].src2_value;
            assign wb_commit_port_data_in.op_info[i].src2_loaded = execute_wb_port[i].src2_loaded;

            assign wb_commit_port_data_in.op_info[i].rd = execute_wb_port[i].rd;
            assign wb_commit_port_data_in.op_info[i].rd_enable = execute_wb_port[i].rd_enable;
            assign wb_commit_port_data_in.op_info[i].need_rename = execute_wb_port[i].need_rename;
            assign wb_commit_port_data_in.op_info[i].rd_phy = execute_wb_port[i].rd_phy;
            assign wb_commit_port_data_in.op_info[i].rd_value = execute_wb_port[i].rd_value;

            assign wb_commit_port_data_in.op_info[i].csr = execute_wb_port[i].csr;
            assign wb_commit_port_data_in.op_info[i].csr_newvalue = execute_wb_port[i].csr_newvalue;
            assign wb_commit_port_data_in.op_info[i].csr_newvalue_valid = execute_wb_port[i].csr_newvalue_valid;
            assign wb_commit_port_data_in.op_info[i].op = execute_wb_port[i].op;
            assign wb_commit_port_data_in.op_info[i].op_unit = execute_wb_port[i].op_unit;
            assign wb_commit_port_data_in.op_info[i].sub_op.raw_data = execute_wb_port[i].sub_op.raw_data;

            assign wb_phyf_id[i] = execute_wb_port[i].rd_phy;
            assign wb_phyf_data[i] = execute_wb_port[i].rd_value;
            assign wb_phyf_we[i] = !wb_commit_port_flush && execute_wb_port[i].enable & execute_wb_port[i].valid & !execute_wb_port[i].has_exception & execute_wb_port[i].rd_enable & execute_wb_port[i].need_rename;
            assign wb_feedback_pack.channel[i].enable = wb_phyf_we[i];
            assign wb_feedback_pack.channel[i].phy_id = wb_phyf_id[i];
            assign wb_feedback_pack.channel[i].value = wb_phyf_data[i];
        end
    endgenerate
endmodule