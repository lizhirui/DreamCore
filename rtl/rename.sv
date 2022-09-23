`include "config.svh"
`include "common.svh"

module rename(
        input logic clk,
        input logic rst,
        
        output logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1],
        output checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1],
        output logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we,
        input checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1],
        
        input logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid,
        output logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1],
        output logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid,
        output logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1],
        output logic rename_rat_map,
        
        input logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid,
        input logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible,
        
        output logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2],
        input logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2],
        
        input logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid,
        
        output rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1],
        output logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid,
        output logic rename_rob_push,
        
        output logic rename_csrf_phy_regfile_full_add,
        output logic rename_csrf_rob_full_add,
        
        input decode_rename_pack_t decode_rename_fifo_data_out[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_out_valid,
        output logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_pop_valid,
        output logic decode_rename_fifo_pop,
        
        output rename_readreg_pack_t rename_readreg_port_data_in,
        output logic rename_readreg_port_we,
        output logic rename_readreg_port_flush,
        
        output rename_feedback_pack_t rename_feedback_pack,
        input issue_feedback_pack_t issue_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    checkpoint_t new_cp[0:`RENAME_WIDTH - 1];
    rob_item_t rob_item[0:`RENAME_WIDTH - 1];
    decode_rename_pack_t rev_pack[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rev_pack_valid;
    rename_readreg_pack_t send_pack;

    logic[`RENAME_WIDTH - 1:0] new_phy_id_need;
    logic[$clog2(`RENAME_WIDTH) - 1:0] new_phy_id_channel_index[0:`RENAME_WIDTH - 1];
    logic[`PHY_REG_ID_WIDTH - 1:0] new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] new_phy_id_valid;

    logic[`RENAME_WIDTH - 1:0] rd_old_phy_feedback_cmp[0:`RENAME_WIDTH - 1];
    logic[$clog2(`RENAME_WIDTH - 1) - 1:0] rd_old_phy_feedback_index[0:`RENAME_WIDTH - 1];
    logic[`PHY_REG_ID_WIDTH - 1:0] rd_old_phy_feedback[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rd_old_phy_feedback_valid;

    logic[`RENAME_WIDTH - 1:0] rs1_phy_feedback_cmp[0:`RENAME_WIDTH - 1];
    logic[$clog2(`RENAME_WIDTH - 1) - 1:0] rs1_phy_feedback_index[0:`RENAME_WIDTH - 1];
    logic[`PHY_REG_ID_WIDTH - 1:0] rs1_phy_feedback[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rs1_phy_feedback_valid;

    logic[`RENAME_WIDTH - 1:0] rs2_phy_feedback_cmp[0:`RENAME_WIDTH - 1];
    logic[$clog2(`RENAME_WIDTH - 1) - 1:0] rs2_phy_feedback_index[0:`RENAME_WIDTH - 1];
    logic[`PHY_REG_ID_WIDTH - 1:0] rs2_phy_feedback[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rs2_phy_feedback_valid;

    logic[`RENAME_WIDTH - 1:0] phy_regfile_full_cmp;
    logic[`RENAME_WIDTH - 1:0] rob_full_cmp;

    genvar i, j;

    assign rev_pack = decode_rename_fifo_data_out;
    assign rev_pack_valid = decode_rename_fifo_data_out_valid;
    assign rename_readreg_port_data_in = send_pack;
    assign rename_readreg_port_we = !issue_feedback_pack.stall;
    assign rename_readreg_port_flush = commit_feedback_pack.enable && commit_feedback_pack.flush;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign decode_rename_fifo_data_pop_valid[i] = send_pack.op_info[i].enable;
        end
    endgenerate

    assign decode_rename_fifo_pop = !rename_readreg_port_flush && rename_readreg_port_we;

    //new phy id redirect
    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign new_phy_id_need[i] = rev_pack_valid[i] && rev_pack[i].enable && rev_pack[i].valid && rev_pack[i].need_rename;
            assign new_phy_id[i] = rat_rename_new_phy_id[new_phy_id_channel_index[i]];
            assign new_phy_id_valid[i] = rat_rename_new_phy_id_valid[new_phy_id_channel_index[i]];
        end

        assign new_phy_id_channel_index[0] = 'b0;

        for(i = 1;i < `RENAME_WIDTH;i++) begin
             assign new_phy_id_channel_index[i] = new_phy_id_need[i - 1] ? (new_phy_id_channel_index[i - 1] + 'b1) : new_phy_id_channel_index[i - 1];
        end
    endgenerate

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign send_pack.op_info[i].enable = rev_pack_valid[i] && rev_pack[i].enable && (new_phy_id_valid[i] || !rev_pack[i].valid || 
                                                 !rev_pack[i].need_rename) && rob_rename_new_id_valid[i];
            assign send_pack.op_info[i].value = rev_pack[i].value;
            assign send_pack.op_info[i].valid = rev_pack[i].valid;
            assign send_pack.op_info[i].pc = rev_pack[i].pc;
            assign send_pack.op_info[i].imm = rev_pack[i].imm;
            assign send_pack.op_info[i].has_exception = rev_pack[i].has_exception;
            assign send_pack.op_info[i].exception_id = rev_pack[i].exception_id;
            assign send_pack.op_info[i].exception_value = rev_pack[i].exception_value;
            assign send_pack.op_info[i].predicted = rev_pack[i].predicted;
            assign send_pack.op_info[i].predicted_jump = rev_pack[i].predicted_jump;
            assign send_pack.op_info[i].predicted_next_pc = rev_pack[i].predicted_next_pc;
            assign send_pack.op_info[i].checkpoint_id_valid = rev_pack[i].checkpoint_id_valid;
            assign send_pack.op_info[i].checkpoint_id = rev_pack[i].checkpoint_id;
            assign send_pack.op_info[i].rs1 = rev_pack[i].rs1;
            assign send_pack.op_info[i].arg1_src = rev_pack[i].arg1_src;
            assign send_pack.op_info[i].rs1_need_map = rev_pack[i].rs1_need_map;
            assign send_pack.op_info[i].rs2 = rev_pack[i].rs2;
            assign send_pack.op_info[i].arg2_src = rev_pack[i].arg2_src;
            assign send_pack.op_info[i].rs2_need_map = rev_pack[i].rs2_need_map;
            assign send_pack.op_info[i].rd = rev_pack[i].rd;
            assign send_pack.op_info[i].rd_enable = rev_pack[i].rd_enable;
            assign send_pack.op_info[i].need_rename = rev_pack[i].need_rename;
            assign send_pack.op_info[i].csr = rev_pack[i].csr;
            assign send_pack.op_info[i].op = rev_pack[i].op;
            assign send_pack.op_info[i].op_unit = rev_pack[i].op_unit;
            assign send_pack.op_info[i].sub_op.raw_data = rev_pack[i].sub_op.raw_data;
        end
    endgenerate

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin: rd_rs_feedback_generate
            for(j = 0;j < i;j++) begin
                assign rd_old_phy_feedback_cmp[i][j] = rev_pack_valid[j] && rev_pack[j].enable && rev_pack[j].valid && rev_pack[j].need_rename &&
                                                       (rev_pack[j].rd == rev_pack[i].rd);
                assign rs1_phy_feedback_cmp[i][j] = rev_pack_valid[j] && rev_pack[j].enable && rev_pack[j].valid && rev_pack[j].rd_enable && 
                                                    (rev_pack[j].rd == rev_pack[i].rs1);
                assign rs2_phy_feedback_cmp[i][j] = rev_pack_valid[j] && rev_pack[j].enable && rev_pack[j].valid && rev_pack[j].rd_enable && 
                                                    (rev_pack[j].rd == rev_pack[i].rs2);
            end

            for(j = i;j < `RENAME_WIDTH;j++) begin
                assign rd_old_phy_feedback_cmp[i][j] = 'b0;
                assign rs1_phy_feedback_cmp[i][j] = 'b0;
                assign rs2_phy_feedback_cmp[i][j] = 'b0;
            end

            priority_finder #(
                .FIRST_PRIORITY(0),
                .WIDTH(`RENAME_WIDTH)
            )priority_finder_rd_old_phy_feedback(
                .data_in(rd_old_phy_feedback_cmp[i]),
                .index(rd_old_phy_feedback_index[i]),
                .index_valid(rd_old_phy_feedback_valid[i])
            );

            priority_finder #(
                .FIRST_PRIORITY(0),
                .WIDTH(`RENAME_WIDTH)
            )priority_finder_rs1_phy_feedback(
                .data_in(rs1_phy_feedback_cmp[i]),
                .index(rs1_phy_feedback_index[i]),
                .index_valid(rs1_phy_feedback_valid[i])
            );

            priority_finder #(
                .FIRST_PRIORITY(0),
                .WIDTH(`RENAME_WIDTH)
            )priority_finder_rs2_phy_feedback(
                .data_in(rs2_phy_feedback_cmp[i]),
                .index(rs2_phy_feedback_index[i]),
                .index_valid(rs2_phy_feedback_valid[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign rename_rat_read_arch_id[i][0] = rev_pack[i].rs1;
            assign rename_rat_read_arch_id[i][1] = rev_pack[i].rs2;
            assign rename_rat_read_arch_id[i][2] = rev_pack[i].rd;
            assign send_pack.op_info[i].rs1_phy = rs1_phy_feedback_valid[i] ? send_pack.op_info[rs1_phy_feedback_index[i]].rd_phy : rat_rename_read_phy_id[i][0];
            assign send_pack.op_info[i].rs2_phy = rs2_phy_feedback_valid[i] ? send_pack.op_info[rs2_phy_feedback_index[i]].rd_phy : rat_rename_read_phy_id[i][1];
            assign send_pack.op_info[i].rd_phy = new_phy_id[i];
            assign rename_rat_phy_id[i] = new_phy_id[i];
            assign rename_rat_arch_id[i] = rev_pack[i].rd;
            assign rename_rat_phy_id_valid[i] = send_pack.op_info[i].enable && rev_pack[i].need_rename;
        end
    endgenerate

    assign rename_rat_map = !rename_readreg_port_flush && rename_readreg_port_we;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign rob_item[i].new_phy_reg_id = new_phy_id[i];
            assign rob_item[i].old_phy_reg_id = rd_old_phy_feedback_valid[i] ? 
                                                new_phy_id[rd_old_phy_feedback_index[i]] :
                                                rat_rename_read_phy_id[i][2];
            assign rob_item[i].old_phy_reg_id_valid = rev_pack_valid[i] && rev_pack[i].enable && rev_pack[i].valid && rev_pack[i].need_rename;
            assign rob_item[i].finish = 'b0;
            assign rob_item[i].pc = rev_pack[i].pc;
            assign rob_item[i].inst_value = rev_pack[i].value;
            assign rob_item[i].has_exception = rev_pack[i].has_exception;
            assign rob_item[i].exception_id = rev_pack[i].exception_id;
            assign rob_item[i].exception_value = rev_pack[i].exception_value;
            assign rob_item[i].predicted = 'b0;
            assign rob_item[i].predicted_jump = 'b0;
            assign rob_item[i].predicted_next_pc = 'b0;
            assign rob_item[i].checkpoint_id_valid = 'b0;
            assign rob_item[i].checkpoint_id = 'b0;
            assign rob_item[i].bru_op = 'b0;
            assign rob_item[i].bru_jump = 'b0;
            assign rob_item[i].bru_next_pc = 'b0;
            assign rob_item[i].is_mret = rev_pack[i].op == op_t::mret;
            assign rob_item[i].csr_addr = rev_pack[i].csr;
            assign rob_item[i].csr_newvalue = 'b0;
            assign rob_item[i].csr_newvalue_valid = 'b0;
            assign send_pack.op_info[i].rob_id = rob_rename_new_id[i];
            assign rename_rob_data[i] = rob_item[i];
            assign rename_rob_data_valid[i] = rob_rename_new_id_valid[i] && send_pack.op_info[i].enable;
        end
    endgenerate

    assign rename_rob_push = !rename_readreg_port_flush && rename_readreg_port_we;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign rename_cpbuf_id[i] = rev_pack[i].checkpoint_id;
            assign new_cp[i].global_history = cpbuf_rename_data[i].global_history;
            assign new_cp[i].local_history = cpbuf_rename_data[i].local_history;

            if(i == 0) begin
                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    assign new_cp[i].rat_phy_map_table_valid[j] = !send_pack.op_info[i].enable || !rev_pack[i].valid || !rev_pack[i].need_rename ? 
                                                                  rat_rename_map_table_valid[j] :
                                                                  (j == send_pack.op_info[i].rd_phy) ? 'b1 : rat_rename_map_table_valid[j];
                    assign new_cp[i].rat_phy_map_table_visible[j] = !send_pack.op_info[i].enable || !rev_pack[i].valid || !rev_pack[i].need_rename ? 
                                                                    rat_rename_map_table_visible[j] :
                                                                    (j == send_pack.op_info[i].rd_phy) ? 'b1 : 
                                                                    (j == rob_item[i].old_phy_reg_id) ? 'b0 : rat_rename_map_table_visible[j];                                
                end
            end
            else begin
                for(j = 0;j < `PHY_REG_NUM;j++) begin
                    assign new_cp[i].rat_phy_map_table_valid[j] = !send_pack.op_info[i].enable || !rev_pack[i].valid || !rev_pack[i].need_rename ? 
                                                                  new_cp[i - 1].rat_phy_map_table_valid[j] :
                                                                  (j == send_pack.op_info[i].rd_phy) ? 'b1 : new_cp[i - 1].rat_phy_map_table_valid[j];
                    assign new_cp[i].rat_phy_map_table_visible[j] = !send_pack.op_info[i].enable || !rev_pack[i].valid || !rev_pack[i].need_rename ? 
                                                                    new_cp[i - 1].rat_phy_map_table_visible[j] :
                                                                    (j == send_pack.op_info[i].rd_phy) ? 'b1 : 
                                                                    (j == rob_item[i].old_phy_reg_id) ? 'b0 : new_cp[i - 1].rat_phy_map_table_visible[j];                                
                end
            end

            assign rename_cpbuf_data[i] = new_cp[i];
            assign rename_cpbuf_we[i] = !rename_readreg_port_flush && rename_readreg_port_we && send_pack.op_info[i].enable && send_pack.op_info[i].checkpoint_id_valid;
        end
    endgenerate

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign phy_regfile_full_cmp[i] = rev_pack_valid[i] && rev_pack[i].enable && rev_pack[i].valid && rev_pack[i].need_rename && !new_phy_id_valid[i];
            assign rob_full_cmp[i] = rev_pack_valid[i] && rev_pack[i].enable && !rob_rename_new_id_valid[i];
        end
    endgenerate

    assign rename_csrf_phy_regfile_full_add = phy_regfile_full_cmp != 'b0;
    assign rename_csrf_rob_full_add = rob_full_cmp != 'b0;

    assign rename_feedback_pack.idle = decode_rename_fifo_data_out_valid == 'b0;
endmodule