`include "config.svh"
`include "common.svh"

module readreg(
        input logic clk,
        input logic rst,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1],
        input logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1],
        input logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1],
        
        input rename_readreg_pack_t rename_readreg_port_data_out,
        
        output readreg_issue_pack_t readreg_issue_port_data_in,
        output logic readreg_issue_port_we,
        output logic readreg_issue_port_flush,
        
        input issue_feedback_pack_t issue_feedback_pack,
        input execute_feedback_pack_t execute_feedback_pack,
        input wb_feedback_pack_t wb_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    rename_readreg_pack_t rev_pack;
    readreg_issue_pack_t send_pack;

    logic[`REG_DATA_WIDTH - 1:0] feedback_data[0:`READREG_WIDTH - 1][0:1];
    logic feedback_data_valid[0:`READREG_WIDTH - 1][0:1];
    logic[`EXECUTE_UNIT_NUM * 2 - 1:0] feedback_data_cmp[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] feedback_data_temp[0:`READREG_WIDTH - 1][0:1][0:`EXECUTE_UNIT_NUM * 2 - 1];

    genvar i, j, k;

    assign readreg_issue_port_flush = commit_feedback_pack.enable & commit_feedback_pack.flush;
    assign readreg_issue_port_we = !issue_feedback_pack.stall;

    assign rev_pack = rename_readreg_port_data_out;
    assign readreg_issue_port_data_in = send_pack;

    generate
        for(i = 0;i < `READREG_WIDTH;i++) begin: readreg_generate_i
            assign send_pack.op_info[i].enable = rev_pack.op_info[i].enable;
            assign send_pack.op_info[i].value = rev_pack.op_info[i].value;
            assign send_pack.op_info[i].valid = rev_pack.op_info[i].valid;
            assign send_pack.op_info[i].rob_id = rev_pack.op_info[i].rob_id;
            assign send_pack.op_info[i].pc = rev_pack.op_info[i].pc;
            assign send_pack.op_info[i].imm = rev_pack.op_info[i].imm;
            assign send_pack.op_info[i].has_exception = rev_pack.op_info[i].has_exception;
            assign send_pack.op_info[i].exception_id = rev_pack.op_info[i].exception_id;
            assign send_pack.op_info[i].exception_value = rev_pack.op_info[i].exception_value;

            assign send_pack.op_info[i].predicted = rev_pack.op_info[i].predicted;
            assign send_pack.op_info[i].predicted_jump = rev_pack.op_info[i].predicted_jump;
            assign send_pack.op_info[i].predicted_next_pc = rev_pack.op_info[i].predicted_next_pc;
            assign send_pack.op_info[i].checkpoint_id_valid = rev_pack.op_info[i].checkpoint_id_valid;
            assign send_pack.op_info[i].checkpoint_id = rev_pack.op_info[i].checkpoint_id;

            assign send_pack.op_info[i].rs1 = rev_pack.op_info[i].rs1;
            assign send_pack.op_info[i].arg1_src = rev_pack.op_info[i].arg1_src;
            assign send_pack.op_info[i].rs1_need_map = rev_pack.op_info[i].rs1_need_map;
            assign send_pack.op_info[i].rs1_phy = rev_pack.op_info[i].rs1_phy;

            assign send_pack.op_info[i].rs2 = rev_pack.op_info[i].rs2;
            assign send_pack.op_info[i].arg2_src = rev_pack.op_info[i].arg2_src;
            assign send_pack.op_info[i].rs2_need_map = rev_pack.op_info[i].rs2_need_map;
            assign send_pack.op_info[i].rs2_phy = rev_pack.op_info[i].rs2_phy;

            assign send_pack.op_info[i].rd = rev_pack.op_info[i].rd;
            assign send_pack.op_info[i].rd_enable = rev_pack.op_info[i].rd_enable;
            assign send_pack.op_info[i].need_rename = rev_pack.op_info[i].need_rename;
            assign send_pack.op_info[i].rd_phy = rev_pack.op_info[i].rd_phy;

            assign send_pack.op_info[i].csr = rev_pack.op_info[i].csr;
            assign send_pack.op_info[i].op = rev_pack.op_info[i].op;
            assign send_pack.op_info[i].op_unit = rev_pack.op_info[i].op_unit;
            assign send_pack.op_info[i].sub_op.raw_data = rev_pack.op_info[i].sub_op.raw_data;
            
            assign readreg_phyf_id[i][0] = rev_pack.op_info[i].rs1_phy;
            assign readreg_phyf_id[i][1] = rev_pack.op_info[i].rs2_phy;

            for(j = 0;j < 2;j++) begin: readreg_generate_j
                for(k = 0;k < `EXECUTE_UNIT_NUM;k++) begin: readreg_generate_k
                    assign feedback_data_cmp[i][j][k] = (execute_feedback_pack.channel[k].enable && (readreg_phyf_id[i][j] == execute_feedback_pack.channel[k].phy_id));
                    assign feedback_data_temp[i][j][k] = execute_feedback_pack.channel[k].value;
                    assign feedback_data_cmp[i][j][`EXECUTE_UNIT_NUM + k] = (wb_feedback_pack.channel[k].enable && (readreg_phyf_id[i][j] == wb_feedback_pack.channel[k].phy_id));
                    assign feedback_data_temp[i][j][`EXECUTE_UNIT_NUM + k] = wb_feedback_pack.channel[k].value;
                end

                data_selector #(
                    .SEL_WIDTH(`EXECUTE_UNIT_NUM * 2),
                    .DATA_WIDTH(`REG_DATA_WIDTH)
                )data_selector_feedback_data_inst(
                    .sel_in(feedback_data_cmp[i][j]),
                    .data_in(feedback_data_temp[i][j]),
                    .data_out(feedback_data[i][j]),
                    .data_out_valid(feedback_data_valid[i][j])
                );
            end

            assign send_pack.op_info[i].src1_value = rev_pack.op_info[i].rs1_need_map ? (phyf_readreg_data_valid[i][0] ? phyf_readreg_data[i][0] : feedback_data[i][0]) :
                                                     rev_pack.op_info[i].arg1_src == arg_src_t::imm ? rev_pack.op_info[i].imm : 'b0;
            assign send_pack.op_info[i].src1_loaded = !rev_pack.op_info[i].enable | !rev_pack.op_info[i].valid | !rev_pack.op_info[i].rs1_need_map | phyf_readreg_data_valid[i][0] | feedback_data_valid[i][0];
            assign send_pack.op_info[i].src2_value = rev_pack.op_info[i].rs2_need_map ? (phyf_readreg_data_valid[i][1] ? phyf_readreg_data[i][1] : feedback_data[i][1]) :
                                                     rev_pack.op_info[i].arg2_src == arg_src_t::imm ? rev_pack.op_info[i].imm : 'b0;
            assign send_pack.op_info[i].src2_loaded = !rev_pack.op_info[i].enable | !rev_pack.op_info[i].valid | !rev_pack.op_info[i].rs2_need_map | phyf_readreg_data_valid[i][1] | feedback_data_valid[i][1];
        end
    endgenerate

endmodule