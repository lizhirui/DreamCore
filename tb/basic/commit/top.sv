`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    
    logic intif_commit_has_interrupt;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data;
    logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data;
    
    logic[`ADDR_WIDTH - 1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1];
    logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_jump;
    logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_hit;
    logic[`COMMIT_WIDTH - 1:0] commit_bp_valid;
    
    logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1];
    checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop;
    logic commit_cpbuf_flush;
    
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible;
    logic commit_rat_map_table_restore;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid;
    logic commit_rat_release_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid;
    logic commit_rat_commit_map;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id;
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id;
    logic commit_rat_restore_map;
    
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we;

    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    
    logic commit_csrf_branch_num_add;
    logic commit_csrf_branch_predicted_add;
    logic commit_csrf_branch_hit_add;
    logic commit_csrf_branch_miss_add;
    logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add;

    logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id;
    logic rob_commit_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id;
    logic rob_commit_flush_tail_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id;
    rob_item_t rob_commit_flush_data;
    logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id;
    logic rob_commit_flush_next_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1];
    rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1];
    rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] commit_rob_input_data_we;

    logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id;
    logic rob_commit_retire_head_id_valid;
    
    logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1];
    rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid;
    logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop;
    
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid;

    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id;
    logic commit_phyf_flush_invalid;
    
    logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid;
    logic commit_phyf_data_valid_restore;
    
    wb_commit_pack_t wb_commit_port_data_out;

    logic rob_commit_empty;
    logic rob_commit_full;
    logic commit_rob_flush;
    
    commit_feedback_pack_t commit_feedback_pack;

    checkpoint_t cp;
    rob_item_t rob_item;
    wb_commit_op_info_t t_pack;

    integer i, j;

    commit commit_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task test;
        rst = 1;
        intif_commit_has_interrupt = 'b0;
        intif_commit_mcause_data = 'b0;
        intif_commit_ack_data = 'b0;
        cp.rat_phy_map_table_valid = 'b0;
        cp.rat_phy_map_table_visible = 'b0;
        cp.global_history = 'b0;
        cp.local_history = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            cpbuf_commit_data[i] = cp;
        end

        for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
            csrf_commit_read_data[i] = 'b0;
        end

        csrf_all_mstatus_data = 'b0;
        rob_commit_next_id_valid = 'b0;
        rob_commit_flush_tail_id = 'b0;
        rob_commit_flush_tail_id_valid = 'b0;
        rob_item.new_phy_reg_id = 'b0;
        rob_item.old_phy_reg_id = 'b0;
        rob_item.old_phy_reg_id_valid = 'b0;
        rob_item.finish = 'b0;
        rob_item.pc = 'b0;
        rob_item.inst_value = 'b0;
        rob_item.has_exception = 'b0;
        rob_item.exception_id = riscv_exception_t::instruction_address_misaligned;
        rob_item.exception_value = 'b0;
        rob_item.predicted = 'b0;
        rob_item.predicted_jump = 'b0;
        rob_item.predicted_next_pc = 'b0;
        rob_item.checkpoint_id_valid = 'b0;
        rob_item.checkpoint_id = 'b0;
        rob_item.bru_op = 'b0;
        rob_item.bru_jump = 'b0;
        rob_item.bru_next_pc = 'b0;
        rob_item.is_mret = 'b0;
        rob_item.csr_addr = 'b0;
        rob_item.csr_newvalue = 'b0;
        rob_item.csr_newvalue_valid = 'b0;
        rob_commit_flush_data = rob_item;
        rob_commit_flush_next_id = 'b0;
        rob_commit_flush_next_id_valid = 'b0;
        
        for(i = 0;i < `WB_WIDTH;i++) begin
            rob_commit_input_data[i] = rob_item;
        end

        rob_commit_retire_head_id = 'b0;
        rob_commit_retire_head_id_valid = 'b0;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            rob_commit_retire_data[i] = rob_item;
        end

        rob_commit_retire_id_valid = 'b0;
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
        t_pack.bru_jump = 'b0;
        t_pack.bru_next_pc = 'b0;
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
        t_pack.rd_value = 'b0;
        t_pack.csr = 'b0;
        t_pack.csr_newvalue = 'b0;
        t_pack.csr_newvalue_valid = 'b0;
        t_pack.op = op_t::add;
        t_pack.op_unit = op_unit_t::alu;
        t_pack.sub_op.alu_op = alu_op_t::add;
        
        for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
            wb_commit_port_data_out.op_info[i] = t_pack;
        end

        rob_commit_empty = 'b0;
        rob_commit_full = 'b0;
        wait_clk();
        rst = 0;
        //verify reset status
        rob_commit_empty = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b0) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        //verify one rob item without finishing
        rob_commit_empty = 'b0;
        rob_commit_retire_head_id_valid = 'b1;
        rob_commit_retire_head_id = 'h2;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h2) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        //verify next_handle_rob_id_valid
        rob_commit_next_id_valid = 'b1;
        eval();
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        //let finish = 1
        rob_commit_next_id_valid = 'b0;
        rob_commit_retire_data[0].finish = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h2) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        //let rob ack signal assert
        rob_commit_retire_id_valid[0] = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h3) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_next_id == 'h3) else $finish;
        //verify next_handle_rob_id_valid again
        rob_commit_next_id_valid = 'b1;
        eval();
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        //let finish = 0
        rob_commit_retire_data[0].finish = 'b0;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h2) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_next_id == 'h2) else $finish;
        //enable item 0 and 2
        rob_commit_retire_data[0].finish = 'b1;
        rob_commit_retire_id_valid[2] = 'b1;
        rob_commit_retire_data[2].finish = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h3) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_next_id == 'h3) else $finish;
        //also enable item 1
        rob_commit_retire_id_valid[1] = 'b1;
        rob_commit_retire_data[1].finish = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'd3) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b111) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h5) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b111) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.committed_rob_id[2] == 'h4) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_retire_id[1] == 'h3) else $finish;
        assert(commit_rob_retire_id[2] == 'h4) else $finish;
        assert(commit_rob_next_id == 'h5) else $finish;
        //enable item 3
        rob_commit_retire_id_valid[3] = 'b1;
        rob_commit_retire_data[3].finish = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'd4) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1111) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h6) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b1111) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.committed_rob_id[2] == 'h4) else $finish;
        assert(commit_feedback_pack.committed_rob_id[3] == 'h5) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_retire_id[1] == 'h3) else $finish;
        assert(commit_rob_retire_id[2] == 'h4) else $finish;
        assert(commit_rob_retire_id[3] == 'h5) else $finish;
        assert(commit_rob_next_id == 'h6) else $finish;
        //let item 1 has exception
        rob_commit_retire_data[1].has_exception = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'd2) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h4) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b11) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_retire_id[1] == 'h3) else $finish;
        assert(commit_rob_next_id == 'h4) else $finish;
        //let item 0 has exception
        rob_commit_retire_data[0].has_exception = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'd1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h3) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_next_id == 'h3) else $finish;
        //let item 0 has phy reg
        rob_commit_retire_data[0].new_phy_reg_id = 'h1;
        rob_commit_retire_data[0].old_phy_reg_id = 'h2;
        rob_commit_retire_data[0].old_phy_reg_id_valid = 'b1;
        eval();
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b0) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        //let item 0 hasn't exception
        rob_commit_retire_data[0].has_exception = 'b0;
        eval();
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_release_phy_id[0] == 'h2) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_commit_phy_id[0] == 'h1) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b1) else $finish;
        assert(commit_phyf_id[0] == 'h2) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        //let interrupt signal assert
        intif_commit_has_interrupt = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_map == 'b0) else $finish;//normal state->interrupt_flush state
        assert(commit_rat_commit_map == 'b0) else $finish;//normal state->interrupt_flush state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        //let interrupt signal deassert
        intif_commit_has_interrupt = 'b0;

        //let all items have csr write request
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            rob_commit_retire_data[i].has_exception = 'b0;
            rob_commit_retire_data[i].csr_addr = unsigned'('h123 + i);
            rob_commit_retire_data[i].csr_newvalue = unsigned'('hdeadbeef + i);
            rob_commit_retire_data[i].csr_newvalue_valid = 'b1;
        end

        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;

        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assert(commit_csrf_write_addr[i] == rob_commit_retire_data[i].csr_addr) else $finish;
            assert(commit_csrf_write_data[i] == rob_commit_retire_data[i].csr_newvalue) else $finish;
            assert(commit_csrf_we[i] == 'b1) else $finish;
        end

        assert(commit_csrf_branch_num_add == 'b0) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'd4) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1111) else $finish;
        assert(commit_phyf_invalid == 'b1) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id == 'h6) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b1111) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.committed_rob_id[2] == 'h4) else $finish;
        assert(commit_feedback_pack.committed_rob_id[3] == 'h5) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        assert(commit_rob_retire_id[0] == 'h2) else $finish;
        assert(commit_rob_retire_id[1] == 'h3) else $finish;
        assert(commit_rob_retire_id[2] == 'h4) else $finish;
        assert(commit_rob_retire_id[3] == 'h5) else $finish;
        assert(commit_rob_next_id == 'h6) else $finish;
        //open item 3 branch prediction and let result becomes hit
        rob_commit_retire_data[3].predicted = 'b1;
        rob_commit_retire_data[3].bru_op = 'b1;
        rob_commit_retire_data[3].bru_jump = 'b1;
        rob_commit_retire_data[3].predicted_jump = 'b1;
        rob_commit_retire_data[3].bru_next_pc = 'hdeadbeef;
        rob_commit_retire_data[3].predicted_next_pc = 'hdeadbeef;
        rob_commit_retire_data[3].pc = 'h12345678;
        rob_commit_retire_data[3].inst_value = 'h1ab2c3d4;
        eval();
        assert(commit_bp_pc[3] == rob_commit_retire_data[3].pc) else $finish;
        assert(commit_bp_instruction[3] == rob_commit_retire_data[3].inst_value) else $finish;
        assert(commit_bp_jump[3] == rob_commit_retire_data[3].bru_jump) else $finish;
        assert(commit_bp_next_pc[3] == rob_commit_retire_data[3].bru_next_pc) else $finish;
        assert(commit_bp_hit[3] == 'b1) else $finish;
        assert(commit_bp_valid[3] == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b1) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b1) else $finish;
        assert(commit_csrf_branch_hit_add == 'b1) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        //let result becomes miss
        rob_commit_retire_data[3].bru_jump = 'b0;
        eval();
        assert(commit_bp_pc[3] == rob_commit_retire_data[3].pc) else $finish;
        assert(commit_bp_instruction[3] == rob_commit_retire_data[3].inst_value) else $finish;
        assert(commit_bp_jump[3] == rob_commit_retire_data[3].bru_jump) else $finish;
        assert(commit_bp_next_pc[3] == rob_commit_retire_data[3].bru_next_pc) else $finish;
        assert(commit_bp_hit[3] == 'b0) else $finish;
        assert(commit_bp_valid[3] == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_csrf_branch_num_add == 'b1) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b1) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b1) else $finish;
        //close prediction of item 3
        rob_commit_retire_data[3].predicted = 'b0;
        eval();
        assert(commit_bp_valid[3] == 'b0) else $finish;
        assert(commit_csrf_branch_num_add == 'b1) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b0) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b1) else $finish;
        assert(commit_feedback_pack.jump == rob_commit_retire_data[3].bru_jump) else $finish;
        assert(commit_feedback_pack.next_pc == (rob_commit_retire_data[3].pc + 'd4)) else $finish;
        //open prediction of item 3 and keep miss, and assign checkpoint_id
        rob_commit_retire_data[3].predicted = 'b1;
        rob_commit_retire_data[3].checkpoint_id_valid = 'b1;
        rob_commit_retire_data[3].checkpoint_id = 'h3;
        cpbuf_commit_data[3].rat_phy_map_table_visible = 'b11111;
        eval();
        assert(commit_bp_pc[3] == rob_commit_retire_data[3].pc) else $finish;
        assert(commit_bp_instruction[3] == rob_commit_retire_data[3].inst_value) else $finish;
        assert(commit_bp_jump[3] == rob_commit_retire_data[3].bru_jump) else $finish;
        assert(commit_bp_next_pc[3] == rob_commit_retire_data[3].bru_next_pc) else $finish;
        assert(commit_bp_hit[3] == 'b0) else $finish;
        assert(commit_bp_valid[3] == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_csrf_branch_num_add == 'b1) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b1) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b1) else $finish;
        assert(commit_cpbuf_id[3] == rob_commit_retire_data[3].checkpoint_id) else $finish;
        assert(commit_rat_map_table_valid == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_visible == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_restore == 'b1) else $finish;
        assert(commit_cpbuf_id[3] == rob_commit_retire_data[3].checkpoint_id) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b1) else $finish;
        assert(commit_rat_map_table_valid == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_visible == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_restore == 'b1) else $finish;
        assert(commit_phyf_data_valid == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_phyf_data_valid_restore == 'b1) else $finish;
        assert(commit_rob_flush == 'b1) else $finish;
        //assign phy
        cpbuf_commit_data[3].rat_phy_map_table_visible = 'b00111;
        rob_commit_retire_data[3].new_phy_reg_id = 'h3;
        rob_commit_retire_data[3].old_phy_reg_id = 'h4;
        rob_commit_retire_data[3].old_phy_reg_id_valid = 'b1;
        eval();
        assert(commit_rat_release_phy_id[3] == rob_commit_retire_data[3].old_phy_reg_id) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1001) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;
        assert(commit_rat_commit_phy_id[3] == rob_commit_retire_data[3].new_phy_reg_id) else $finish;
        assert(commit_rat_commit_phy_id_valid == 'b1001) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;
        assert(commit_phyf_id[3] == rob_commit_retire_data[3].old_phy_reg_id) else $finish;
        assert(commit_phyf_invalid == 'b1001) else $finish;
        assert(commit_bp_pc[3] == rob_commit_retire_data[3].pc) else $finish;
        assert(commit_bp_instruction[3] == rob_commit_retire_data[3].inst_value) else $finish;
        assert(commit_bp_jump[3] == rob_commit_retire_data[3].bru_jump) else $finish;
        assert(commit_bp_next_pc[3] == rob_commit_retire_data[3].bru_next_pc) else $finish;
        assert(commit_bp_hit[3] == 'b0) else $finish;
        assert(commit_bp_valid[3] == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_csrf_branch_num_add == 'b1) else $finish;
        assert(commit_csrf_branch_predicted_add == 'b1) else $finish;
        assert(commit_csrf_branch_hit_add == 'b0) else $finish;
        assert(commit_csrf_branch_miss_add == 'b1) else $finish;
        assert(commit_cpbuf_id[3] == rob_commit_retire_data[3].checkpoint_id) else $finish;
        assert(commit_rat_map_table_valid == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_visible == cpbuf_commit_data[3].rat_phy_map_table_visible) else $finish;
        assert(commit_rat_map_table_restore == 'b1) else $finish;
        assert(commit_cpbuf_id[3] == rob_commit_retire_data[3].checkpoint_id) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b1) else $finish;
        assert(commit_rat_map_table_valid == 'b00111) else $finish;
        assert(commit_rat_map_table_visible == 'b00111) else $finish;
        assert(commit_rat_map_table_restore == 'b1) else $finish;
        assert(commit_phyf_data_valid == 'b00111) else $finish;
        assert(commit_phyf_data_valid_restore == 'b1) else $finish;
        assert(commit_rob_flush == 'b1) else $finish;
        //verify rob_input when enable option of all items are zero
        for(i = 0;i < `WB_WIDTH;i++) begin
            wb_commit_port_data_out.op_info[i].enable = 'b0;
            wb_commit_port_data_out.op_info[i].rob_id = unsigned'('ha541deca + i);
            wb_commit_port_data_out.op_info[i].has_exception = unsigned'(i & 1);
            wb_commit_port_data_out.op_info[i].exception_value = unsigned'('hdeadbeef + i);
            wb_commit_port_data_out.op_info[i].predicted = unsigned'(i & 1);
            wb_commit_port_data_out.op_info[i].predicted_jump = ~unsigned'(i & 1);
            wb_commit_port_data_out.op_info[i].predicted_next_pc = unsigned'('habcdef12 + i);
            wb_commit_port_data_out.op_info[i].checkpoint_id_valid = ~unsigned'(i & 1);
            wb_commit_port_data_out.op_info[i].checkpoint_id = unsigned'('h334455aa + i);
            wb_commit_port_data_out.op_info[i].op_unit = unsigned'(i & 1) ? op_unit_t::bru : op_unit_t::alu;
            wb_commit_port_data_out.op_info[i].bru_next_pc = unsigned'('hccdd1254 + i);
            wb_commit_port_data_out.op_info[i].csr_newvalue = unsigned'('hccee1254 + i);
            wb_commit_port_data_out.op_info[i].csr_newvalue_valid = ~unsigned'(i & 1);
        end

        eval();
        assert(commit_rob_input_data_we == 'b0);

        //open all enable option
        for(i = 0;i < `WB_WIDTH;i++) begin
            wb_commit_port_data_out.op_info[i].enable = 'b1;
        end

        eval();
        
        for(i = 0;i < `WB_WIDTH;i++) begin
            assert(commit_rob_input_id[i] == wb_commit_port_data_out.op_info[i].rob_id) else $finish;
            assert(commit_rob_input_data[i].finish == 'b1) else $finish;
            assert(commit_rob_input_data[i].has_exception == wb_commit_port_data_out.op_info[i].has_exception) else $finish;
            assert(commit_rob_input_data[i].exception_id == wb_commit_port_data_out.op_info[i].exception_id) else $finish;
            assert(commit_rob_input_data[i].exception_value == wb_commit_port_data_out.op_info[i].exception_value) else $finish;
            assert(commit_rob_input_data[i].predicted == wb_commit_port_data_out.op_info[i].predicted) else $finish;
            assert(commit_rob_input_data[i].predicted_jump == wb_commit_port_data_out.op_info[i].predicted_jump) else $finish;
            assert(commit_rob_input_data[i].predicted_next_pc == wb_commit_port_data_out.op_info[i].predicted_next_pc) else $finish;
            assert(commit_rob_input_data[i].checkpoint_id_valid == wb_commit_port_data_out.op_info[i].checkpoint_id_valid) else $finish;
            assert(commit_rob_input_data[i].checkpoint_id == wb_commit_port_data_out.op_info[i].checkpoint_id) else $finish;
            assert(commit_rob_input_data[i].bru_op == (wb_commit_port_data_out.op_info[i].op_unit == op_unit_t::bru)) else $finish;
            assert(commit_rob_input_data[i].bru_jump == wb_commit_port_data_out.op_info[i].bru_jump) else $finish;
            assert(commit_rob_input_data[i].bru_next_pc == wb_commit_port_data_out.op_info[i].bru_next_pc) else $finish;
            assert(commit_rob_input_data[i].csr_newvalue == wb_commit_port_data_out.op_info[i].csr_newvalue) else $finish;
            assert(commit_rob_input_data[i].csr_newvalue_valid == wb_commit_port_data_out.op_info[i].csr_newvalue_valid) else $finish;
        end

        //switch to flush state
        rob_commit_retire_data[0].new_phy_reg_id = 'h3;
        rob_commit_retire_data[0].old_phy_reg_id = 'h4;
        rob_commit_retire_data[0].old_phy_reg_id_valid = 'b1;
        rob_commit_retire_data[1].new_phy_reg_id = 'h5;
        rob_commit_retire_data[1].old_phy_reg_id = 'h6;
        rob_commit_retire_data[1].old_phy_reg_id_valid = 'b1;
        rob_commit_retire_data[1].has_exception = 'b1;
        rob_commit_retire_data[1].pc = 'haabbccd0;
        rob_commit_retire_data[1].exception_value = 'ha1b2c3d4;
        rob_commit_retire_data[1].exception_id = riscv_exception_t::instruction_access_fault;
        rob_commit_flush_tail_id = 'h4;
        rob_commit_flush_tail_id_valid = 'b1;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b1) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b11) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        wait_clk();
        //now is flush state
        //check output when rob_commit_flush_next_id_valid == 'b0
        assert(commit_rob_flush_id == 'h4) else $finish;
        rob_commit_flush_data.old_phy_reg_id_valid = 'b1;
        rob_commit_flush_data.new_phy_reg_id = 'd9;
        rob_commit_flush_data.old_phy_reg_id = 'd10;
        rob_commit_flush_next_id = 'h3;
        rob_commit_flush_next_id_valid = 'b0;
        csrf_commit_read_data[0] = 'hdeadbeef;
        eval();
        assert(commit_rob_flush == 'b1) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b1) else $finish;
        assert(commit_feedback_pack.exception_pc == 'hdeadbeef) else $finish;
        assert(commit_csrf_read_addr[0] == `CSR_MTVEC) else $finish;
        assert(commit_csrf_write_addr[0] == `CSR_MEPC) else $finish;
        assert(commit_csrf_write_data[0] == rob_commit_retire_data[1].pc) else $finish;
        assert(commit_csrf_we[0] == 'b1) else $finish;
        assert(commit_csrf_write_addr[1] == `CSR_MTVAL) else $finish;
        assert(commit_csrf_write_data[1] == rob_commit_retire_data[1].exception_value) else $finish;
        assert(commit_csrf_we[1] == 'b1) else $finish;
        assert(commit_csrf_write_addr[2] == `CSR_MCAUSE) else $finish;
        assert(commit_csrf_write_data[2] == unsigned'('b1)) else $finish;
        assert(commit_csrf_we[2] == 'b1) else $finish;
        assert(commit_csrf_we[3] == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        //check output when rob_commit_flush_next_id_valid == 'b1
        rob_commit_flush_next_id_valid = 'b1;
        eval();
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        wait_clk();
        //now restore_rob_item_id == rob_item_id
        assert(commit_rob_flush == 'b1) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b1) else $finish;
        assert(commit_feedback_pack.exception_pc == 'hdeadbeef) else $finish;
        assert(commit_csrf_read_addr[0] == `CSR_MTVEC) else $finish;
        assert(commit_csrf_write_addr[0] == `CSR_MEPC) else $finish;
        assert(commit_csrf_write_data[0] == rob_commit_retire_data[1].pc) else $finish;
        assert(commit_csrf_we[0] == 'b1) else $finish;
        assert(commit_csrf_write_addr[1] == `CSR_MTVAL) else $finish;
        assert(commit_csrf_write_data[1] == rob_commit_retire_data[1].exception_value) else $finish;
        assert(commit_csrf_we[1] == 'b1) else $finish;
        assert(commit_csrf_write_addr[2] == `CSR_MCAUSE) else $finish;
        assert(commit_csrf_write_data[2] == unsigned'('b1)) else $finish;
        assert(commit_csrf_we[2] == 'b1) else $finish;
        assert(commit_csrf_we[3] == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        wait_clk();
        //now is normal state
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b1) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b11) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        //switch to interrupt_flush state
        intif_commit_has_interrupt = 'b1;
        intif_commit_mcause_data = 'h3;
        csrf_all_mstatus_data = 'b1000;
        intif_commit_ack_data = 'b100100100;
        rob_commit_retire_data[0].pc = 'haabbccd0;
        rob_commit_retire_data[0].exception_value = 'ha1b2c3d4;
        rob_commit_retire_data[0].exception_id = riscv_exception_t::instruction_access_fault;
        eval();
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_map == 'b0) else $finish;//normal state->interrupt_flush state
        assert(commit_rat_commit_map == 'b0) else $finish;//normal state->interrupt_flush state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b0) else $finish;
        assert(commit_phyf_invalid == 'b0) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b0) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
        wait_clk();
        //now is interrupt_flush state
        //check output when rob_commit_flush_next_id_valid == 'b0
        assert(commit_rob_flush_id == 'h4) else $finish;
        rob_commit_flush_data.old_phy_reg_id_valid = 'b1;
        rob_commit_flush_data.new_phy_reg_id = 'd9;
        rob_commit_flush_data.old_phy_reg_id = 'd10;
        rob_commit_flush_next_id = 'h2;
        rob_commit_flush_next_id_valid = 'b0;
        csrf_commit_read_data[0] = 'hdeadbeef;
        eval();
        assert(commit_rob_flush == 'b1) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b1) else $finish;
        assert(commit_feedback_pack.exception_pc == 'hdeadbeef) else $finish;
        assert(commit_csrf_read_addr[0] == `CSR_MTVEC) else $finish;
        assert(commit_csrf_write_addr[0] == `CSR_MEPC) else $finish;
        assert(commit_csrf_write_data[0] == rob_commit_retire_data[0].pc) else $finish;
        assert(commit_csrf_we[0] == 'b1) else $finish;
        assert(commit_csrf_write_addr[1] == `CSR_MTVAL) else $finish;
        assert(commit_csrf_write_data[1] == 'b0) else $finish;
        assert(commit_csrf_we[1] == 'b1) else $finish;
        assert(commit_csrf_write_addr[2] == `CSR_MCAUSE) else $finish;
        assert(commit_csrf_write_data[2] == unsigned'('h80000003)) else $finish;
        assert(commit_csrf_we[2] == 'b1) else $finish;
        assert(commit_csrf_write_addr[3] == `CSR_MSTATUS) else $finish;
        assert(commit_csrf_write_data[3] == unsigned'('b10000000)) else $finish;
        assert(commit_csrf_we[3] == 'b1) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        assert(commit_intif_ack_data == intif_commit_ack_data) else $finish;
        //check output when rob_commit_flush_next_id_valid == 'b1
        rob_commit_flush_next_id_valid = 'b1;
        eval();
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b0) else $finish;
        assert(commit_csrf_we == 'b0) else $finish;
        assert(commit_csrf_commit_num_add == 'b0) else $finish;
        assert(commit_intif_ack_data == 'b0) else $finish;
        wait_clk();
        //now restore_rob_item_id == rob_item_id
        assert(commit_rob_flush == 'b1) else $finish;
        assert(commit_rat_restore_new_phy_id == 'd9) else $finish;
        assert(commit_rat_restore_old_phy_id == 'd10) else $finish;
        assert(commit_rat_restore_map == 'b1) else $finish;
        assert(commit_phyf_flush_id == 'd9) else $finish;
        assert(commit_phyf_flush_invalid == 'b1) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.has_exception == 'b1) else $finish;
        assert(commit_feedback_pack.exception_pc == 'hdeadbeef) else $finish;
        assert(commit_csrf_read_addr[0] == `CSR_MTVEC) else $finish;
        assert(commit_csrf_write_addr[0] == `CSR_MEPC) else $finish;
        assert(commit_csrf_write_data[0] == rob_commit_retire_data[0].pc) else $finish;
        assert(commit_csrf_we[0] == 'b1) else $finish;
        assert(commit_csrf_write_addr[1] == `CSR_MTVAL) else $finish;
        assert(commit_csrf_write_data[1] == 'b0) else $finish;
        assert(commit_csrf_we[1] == 'b1) else $finish;
        assert(commit_csrf_write_addr[2] == `CSR_MCAUSE) else $finish;
        assert(commit_csrf_write_data[2] == unsigned'('h80000003)) else $finish;
        assert(commit_csrf_we[2] == 'b1) else $finish;
        assert(commit_csrf_write_addr[3] == `CSR_MSTATUS) else $finish;
        assert(commit_csrf_write_data[3] == unsigned'('b10000000)) else $finish;
        assert(commit_csrf_we[3] == 'b1) else $finish;
        assert(commit_csrf_commit_num_add == 'b1) else $finish;
        assert(commit_intif_ack_data == intif_commit_ack_data) else $finish;
        wait_clk();
        intif_commit_has_interrupt = 'b0;
        eval();
        //now is normal state
        assert(commit_intif_ack_data == 'b0) else $finish;
        assert(commit_bp_valid == 'b0) else $finish;
        assert(commit_cpbuf_pop == 'b0) else $finish;
        assert(commit_cpbuf_flush == 'b0) else $finish;
        assert(commit_rat_map_table_restore == 'b0) else $finish;
        assert(commit_rat_release_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_release_map == 'b1) else $finish;//normal state
        assert(commit_rat_commit_phy_id_valid == 'b1) else $finish;
        assert(commit_rat_commit_map == 'b1) else $finish;//normal state
        assert(commit_rat_restore_map == 'b0) else $finish;
        assert(commit_csrf_we == 'b1) else $finish;
        assert(commit_rob_input_data_we == 'b0) else $finish;
        assert(commit_rob_retire_pop == 'b1) else $finish;
        assert(commit_phyf_invalid == 'b1) else $finish;
        assert(commit_phyf_flush_invalid == 'b0) else $finish;
        assert(commit_phyf_data_valid_restore == 'b0) else $finish;
        assert(commit_rob_flush == 'b0) else $finish;
        assert(commit_feedback_pack.enable == 'b1) else $finish;
        assert(commit_feedback_pack.flush == 'b1) else $finish;
        assert(commit_feedback_pack.next_handle_rob_id_valid == 'b1) else $finish;
        assert(commit_feedback_pack.committed_rob_id_valid == 'b11) else $finish;
        assert(commit_feedback_pack.committed_rob_id[0] == 'h2) else $finish;
        assert(commit_feedback_pack.committed_rob_id[1] == 'h3) else $finish;
        assert(commit_feedback_pack.jump_enable == 'b0) else $finish;
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