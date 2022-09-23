`include "config.svh"
`include "common.svh"

module commit(
        input logic clk,
        input logic rst,
        
        input logic intif_commit_has_interrupt,
        input logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data,
        input logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data,
        output logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data,
        
        output logic[`ADDR_WIDTH - 1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1],
        output logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_bp_jump,
        output logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_bp_hit,
        output logic[`COMMIT_WIDTH - 1:0] commit_bp_valid,
        
        output logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1],
        input checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop,
        output logic commit_cpbuf_flush,
        
        output logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_valid,
        output logic[`PHY_REG_NUM - 1:0] commit_rat_map_table_visible,
        output logic commit_rat_map_table_restore,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_release_phy_id[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_rat_release_phy_id_valid,
        output logic commit_rat_release_map,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_commit_phy_id[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_rat_commit_phy_id_valid,
        output logic commit_rat_commit_map,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_new_phy_id,
        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_rat_restore_old_phy_id,
        output logic commit_rat_restore_map,
        
        output logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        input logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        output logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        output logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1],
        output logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we,

        input logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data,
        
        output logic commit_csrf_branch_num_add,
        output logic commit_csrf_branch_predicted_add,
        output logic commit_csrf_branch_hit_add,
        output logic commit_csrf_branch_miss_add,
        output logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add,

        output logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id,
        input logic rob_commit_next_id_valid,
        
        input logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id,
        input logic rob_commit_flush_tail_id_valid,
        
        output logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id,
        input rob_item_t rob_commit_flush_data,
        input logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id,
        input logic rob_commit_flush_next_id_valid,
        
        output logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1],
        output rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1],
        input rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1],
        output logic[`WB_WIDTH - 1:0] commit_rob_input_data_we,

        input logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id,
        input logic rob_commit_retire_head_id_valid,
        
        output logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1],
        input rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1],
        input logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid,
        output logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid,

        output logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id,
        output logic commit_phyf_flush_invalid,
        
        output logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid,
        output logic commit_phyf_data_valid_restore,
        
        input wb_commit_pack_t wb_commit_port_data_out,

        input logic rob_commit_empty,
        input logic rob_commit_full,
        output logic commit_rob_flush,
        
        output commit_feedback_pack_t commit_feedback_pack
    );

    localparam STATE_NORMAL = 2'b00;
    localparam STATE_FLUSH = 2'b01;
    localparam STATE_INTERRUPT_FLUSH = 2'b10;

    logic[1:0] cur_state;
    logic[1:0] next_state;

    rob_item_t input_rob_item[0:`WB_WIDTH - 1];
    rob_item_t cur_rob_item;
    logic[`ROB_ID_WIDTH - 1:0] rob_item_id;
    logic[`ROB_ID_WIDTH - 1:0] restore_rob_item_id;
    riscv_interrupt_t::_type interrupt_id;
    riscv_interrupt_t::_type interrupt_id_temp;
    logic[`REG_DATA_WIDTH - 1:0] intif_ack_data;

    logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_valid;

    logic[`COMMIT_WIDTH - 1:0] retire_has_exception_cmp;
    logic[$clog2(`COMMIT_WIDTH) - 1:0] retire_has_exception_index;
    logic retire_has_exception;

    logic[`COMMIT_WIDTH - 1:0] retire_has_bru_op_cmp;
    logic[$clog2(`COMMIT_WIDTH) - 1:0] retire_has_bru_op_index;
    logic retire_has_bru_op;

    logic[`COMMIT_WIDTH - 1:0] retire_is_predicted_cmp;
    logic retire_is_predicted;

    logic[`COMMIT_WIDTH - 1:0] retire_is_hit_cmp;
    logic retire_is_hit;

    logic[`COMMIT_WIDTH - 1:0] retire_is_miss_cmp;
    logic retire_is_miss;

    logic[`COMMIT_WIDTH - 1:0] bru_op_is_hit;

    logic[`COMMIT_WIDTH - 1:0] rob_item_is_finish;

    logic[$clog2(`COMMIT_WIDTH):0] normal_csrf_commit_num_add;

    logic[`CSR_ADDR_WIDTH - 1:0] normal_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] normal_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] normal_csrf_we;

    logic[`CSR_ADDR_WIDTH - 1:0] flush_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] flush_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] flush_csrf_we;

    logic[`CSR_ADDR_WIDTH - 1:0] interrupt_flush_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] interrupt_flush_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] interrupt_flush_csrf_we;

    commit_feedback_pack_t normal_feedback_pack;
    commit_feedback_pack_t flush_feedback_pack;
    commit_feedback_pack_t interrupt_flush_feedback_pack;

    genvar i, j;

    assign commit_csrf_write_addr = (cur_state == STATE_NORMAL) ? normal_csrf_write_addr : (cur_state == STATE_FLUSH) ? flush_csrf_write_addr : interrupt_flush_csrf_write_addr;
    assign commit_csrf_write_data = (cur_state == STATE_NORMAL) ? normal_csrf_write_data : (cur_state == STATE_FLUSH) ? flush_csrf_write_data : interrupt_flush_csrf_write_data;
    assign commit_csrf_we = (cur_state == STATE_NORMAL) ? normal_csrf_we : (cur_state == STATE_FLUSH) ? flush_csrf_we : interrupt_flush_csrf_we;

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign commit_rob_retire_id[i] = rob_commit_retire_head_id + i;
        end
    endgenerate

    generate
        assign commit_rob_retire_valid[0] = (cur_state == STATE_NORMAL) && rob_commit_retire_id_valid[0] && rob_commit_retire_data[0].finish && !intif_commit_has_interrupt;

        for(i = 1;i < `COMMIT_WIDTH;i++) begin
            assign commit_rob_retire_valid[i] = (cur_state == STATE_NORMAL) && rob_commit_retire_id_valid[i] && 
                                                rob_commit_retire_data[i].finish && ((commit_rob_retire_valid[i - 1] && 
                                                !rob_commit_retire_data[i - 1].has_exception && !rob_commit_retire_data[i - 1].bru_op));
        end
    endgenerate

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign commit_rob_retire_pop[i] = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception;
        end
    endgenerate

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign retire_has_exception_cmp[i] = commit_rob_retire_valid[i] &&
                                                 rob_commit_retire_data[i].has_exception;
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`COMMIT_WIDTH)
    )priority_finder_retire_has_exception(
        .data_in(retire_has_exception_cmp),
        .index(retire_has_exception_index),
        .index_valid(retire_has_exception)
    );

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign retire_is_predicted_cmp[i] = commit_rob_retire_valid[i] &&
                                                rob_commit_retire_data[i].bru_op && rob_commit_retire_data[i].predicted;
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`COMMIT_WIDTH)
    )priority_finder_retire_is_predicted(
        .data_in(retire_is_predicted_cmp),
        .index_valid(retire_is_predicted)
    );

    generate
        for(i = 0;i < `COMMIT_WIDTH; i++) begin
            assign bru_op_is_hit[i] = (rob_commit_retire_data[i].bru_jump == rob_commit_retire_data[i].predicted_jump) &&
                                      ((rob_commit_retire_data[i].bru_next_pc == rob_commit_retire_data[i].predicted_next_pc) ||
                                      !rob_commit_retire_data[i].predicted_jump);
        end
    endgenerate

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign retire_is_hit_cmp[i] = commit_rob_retire_valid[i] &&
                                          rob_commit_retire_data[i].bru_op && rob_commit_retire_data[i].predicted && 
                                          bru_op_is_hit[i];
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`COMMIT_WIDTH)
    )priority_finder_retire_is_hit(
        .data_in(retire_is_hit_cmp),
        .index_valid(retire_is_hit)
    );

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign retire_is_miss_cmp[i] = commit_rob_retire_valid[i] &&
                                           rob_commit_retire_data[i].bru_op && rob_commit_retire_data[i].predicted && 
                                           !bru_op_is_hit[i];
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`COMMIT_WIDTH)
    )priority_finder_retire_is_miss(
        .data_in(retire_is_miss_cmp),
        .index_valid(retire_is_miss)
    );

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign retire_has_bru_op_cmp[i] = commit_rob_retire_valid[i] && rob_commit_retire_data[i].bru_op;
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`COMMIT_WIDTH)
    )priority_finder_retire_has_bru_op(
        .data_in(retire_has_bru_op_cmp),
        .index(retire_has_bru_op_index),
        .index_valid(retire_has_bru_op)
    );

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign commit_rat_release_phy_id[i] = rob_commit_retire_data[i].old_phy_reg_id;
            assign commit_rat_release_phy_id_valid[i] = commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && rob_commit_retire_data[i].old_phy_reg_id_valid;
            assign commit_phyf_id[i] = rob_commit_retire_data[i].old_phy_reg_id;
            assign commit_phyf_invalid[i] = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && rob_commit_retire_data[i].old_phy_reg_id_valid;
            assign commit_rat_commit_phy_id[i] = rob_commit_retire_data[i].new_phy_reg_id;
            assign commit_rat_commit_phy_id_valid[i] = commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && rob_commit_retire_data[i].old_phy_reg_id_valid;
            assign normal_csrf_write_addr[i] = rob_commit_retire_data[i].is_mret ? `CSR_MSTATUS : rob_commit_retire_data[i].csr_addr;
            assign normal_csrf_write_data[i] = rob_commit_retire_data[i].is_mret ? {csrf_all_mstatus_data[31:4], csrf_all_mstatus_data[7], csrf_all_mstatus_data[2:0]} : rob_commit_retire_data[i].csr_newvalue;
            assign normal_csrf_we[i] = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && (rob_commit_retire_data[i].is_mret || rob_commit_retire_data[i].csr_newvalue_valid);
            assign commit_bp_pc[i] = rob_commit_retire_data[i].pc;
            assign commit_bp_instruction[i] = rob_commit_retire_data[i].inst_value;
            assign commit_bp_jump[i] = rob_commit_retire_data[i].bru_jump;
            assign commit_bp_next_pc[i] = rob_commit_retire_data[i].bru_next_pc;
            assign commit_bp_hit[i] = bru_op_is_hit[i];
            assign commit_bp_valid[i] = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && retire_is_predicted_cmp[i];
            assign commit_cpbuf_id[i] = rob_commit_retire_data[i].checkpoint_id;
            assign commit_cpbuf_pop[i] = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i] && !rob_commit_retire_data[i].has_exception && retire_is_hit_cmp[i];
        end

        for(i = `COMMIT_WIDTH;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
            assign normal_csrf_write_addr[i] = 'b0;
            assign normal_csrf_write_data[i] = 'b0;
            assign normal_csrf_we[i] = 'b0;
        end
    endgenerate

    assign commit_rat_release_map = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH);
    assign commit_rat_commit_map = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH);
    assign commit_rat_map_table_valid = cpbuf_commit_data[retire_has_bru_op_index].rat_phy_map_table_visible;
    assign commit_rat_map_table_visible = commit_rat_map_table_valid;
    assign commit_rat_map_table_restore = (cur_state == STATE_NORMAL) && (next_state != STATE_INTERRUPT_FLUSH) && retire_is_predicted && retire_is_miss && !rob_commit_retire_data[retire_has_bru_op_index].has_exception;
    assign commit_phyf_data_valid = commit_rat_map_table_valid;
    assign commit_phyf_data_valid_restore = commit_rat_map_table_restore;

    assign commit_rob_flush = ((cur_state == STATE_NORMAL) && retire_is_miss) || ((cur_state != STATE_NORMAL) && (!rob_commit_flush_next_id_valid || (commit_rob_flush_id == rob_item_id)));
    assign commit_cpbuf_flush = (cur_state == STATE_NORMAL) && retire_is_miss;

    count_one #(
        .CONTINUOUS(1),
        .WIDTH(`COMMIT_WIDTH)
    )count_one_commit_num_add(
        .data_in(commit_rob_retire_valid),
        .sum(normal_csrf_commit_num_add)
    );

    assign commit_csrf_commit_num_add = (cur_state == STATE_NORMAL) ? normal_csrf_commit_num_add : 
                                        ((cur_state != STATE_NORMAL) && (next_state == STATE_NORMAL) ?
                                        'b1 : 'b0);

    assign commit_csrf_branch_num_add = (cur_state == STATE_NORMAL) && retire_has_bru_op;
    assign commit_csrf_branch_predicted_add = (cur_state == STATE_NORMAL) && retire_is_predicted;
    assign commit_csrf_branch_hit_add = (cur_state == STATE_NORMAL) && retire_is_hit;
    assign commit_csrf_branch_miss_add = (cur_state == STATE_NORMAL) && retire_is_miss;

    generate
        for(i = 0;i < `WB_WIDTH;i++) begin
            assign input_rob_item[i].new_phy_reg_id = rob_commit_input_data[i].new_phy_reg_id;
            assign input_rob_item[i].old_phy_reg_id = rob_commit_input_data[i].old_phy_reg_id;
            assign input_rob_item[i].old_phy_reg_id_valid = rob_commit_input_data[i].old_phy_reg_id_valid;
            assign input_rob_item[i].finish = 'b1;
            assign input_rob_item[i].pc = rob_commit_input_data[i].pc;
            assign input_rob_item[i].inst_value = rob_commit_input_data[i].inst_value;
            assign input_rob_item[i].has_exception = wb_commit_port_data_out.op_info[i].has_exception;
            assign input_rob_item[i].exception_id = wb_commit_port_data_out.op_info[i].exception_id;
            assign input_rob_item[i].exception_value = wb_commit_port_data_out.op_info[i].exception_value;
            assign input_rob_item[i].predicted = wb_commit_port_data_out.op_info[i].predicted;
            assign input_rob_item[i].predicted_jump = wb_commit_port_data_out.op_info[i].predicted_jump;
            assign input_rob_item[i].predicted_next_pc = wb_commit_port_data_out.op_info[i].predicted_next_pc;
            assign input_rob_item[i].checkpoint_id_valid = wb_commit_port_data_out.op_info[i].checkpoint_id_valid;
            assign input_rob_item[i].checkpoint_id = wb_commit_port_data_out.op_info[i].checkpoint_id;
            assign input_rob_item[i].bru_op = wb_commit_port_data_out.op_info[i].op_unit == op_unit_t::bru;
            assign input_rob_item[i].bru_jump = wb_commit_port_data_out.op_info[i].bru_jump;
            assign input_rob_item[i].bru_next_pc = wb_commit_port_data_out.op_info[i].bru_next_pc;
            assign input_rob_item[i].is_mret = rob_commit_input_data[i].is_mret;
            assign input_rob_item[i].csr_addr = rob_commit_input_data[i].csr_addr;
            assign input_rob_item[i].csr_newvalue = wb_commit_port_data_out.op_info[i].csr_newvalue;
            assign input_rob_item[i].csr_newvalue_valid = wb_commit_port_data_out.op_info[i].csr_newvalue_valid;
            assign commit_rob_input_id[i] = wb_commit_port_data_out.op_info[i].rob_id;
            assign commit_rob_input_data[i] = input_rob_item[i];
            assign commit_rob_input_data_we[i] = (cur_state == STATE_NORMAL) && (next_state == STATE_NORMAL) && !commit_rob_flush && wb_commit_port_data_out.op_info[i].enable;
        end
    endgenerate

    always_ff @(posedge clk) begin
        if((cur_state == STATE_NORMAL) && (next_state != STATE_NORMAL)) begin
            restore_rob_item_id <= rob_commit_flush_tail_id;
        end
        else if(cur_state != STATE_NORMAL) begin
            restore_rob_item_id <= rob_commit_flush_next_id;
        end
    end

    assign commit_rob_flush_id = (cur_state == STATE_NORMAL) ? rob_commit_flush_tail_id : restore_rob_item_id;

    assign commit_rat_restore_new_phy_id = rob_commit_flush_data.new_phy_reg_id;
    assign commit_rat_restore_old_phy_id = rob_commit_flush_data.old_phy_reg_id;
    assign commit_rat_restore_map = (cur_state != STATE_NORMAL) && rob_commit_flush_data.old_phy_reg_id_valid;
    assign commit_phyf_flush_id = rob_commit_flush_data.new_phy_reg_id;
    assign commit_phyf_flush_invalid = commit_rat_restore_map;

    always_ff @(posedge clk) begin
        if((cur_state == STATE_NORMAL) && (next_state == STATE_FLUSH)) begin
            cur_rob_item <= rob_commit_retire_data[retire_has_exception_index];
            rob_item_id <= commit_rob_retire_id[retire_has_exception_index];
        end
        else if((cur_state == STATE_NORMAL) && (next_state == STATE_INTERRUPT_FLUSH)) begin
            cur_rob_item <= rob_commit_retire_data[0];
            rob_item_id <= commit_rob_retire_id[0];
        end
    end

    always_comb begin
        case(intif_commit_mcause_data)
            riscv_interrupt_t::machine_software: interrupt_id_temp = riscv_interrupt_t::machine_software;
            riscv_interrupt_t::machine_timer: interrupt_id_temp = riscv_interrupt_t::machine_timer;
            riscv_interrupt_t::machine_external: interrupt_id_temp = riscv_interrupt_t::machine_external;
            default: interrupt_id_temp = riscv_interrupt_t::machine_external;
        endcase
    end

    always_ff @(posedge clk) begin
        if((cur_state == STATE_NORMAL) && (next_state == STATE_INTERRUPT_FLUSH)) begin
            interrupt_id <= interrupt_id_temp;
            intif_ack_data <= intif_commit_ack_data;
        end
    end
    
    assign flush_csrf_write_addr[0] = `CSR_MEPC;
    assign flush_csrf_write_data[0] = cur_rob_item.pc;
    assign flush_csrf_we[0] = (cur_state == STATE_FLUSH) && (next_state == STATE_NORMAL);
    assign flush_csrf_write_addr[1] = `CSR_MTVAL;
    assign flush_csrf_write_data[1] = cur_rob_item.exception_value;
    assign flush_csrf_we[1] = flush_csrf_we[0];
    assign flush_csrf_write_addr[2] = `CSR_MCAUSE;
    assign flush_csrf_write_data[2] = cur_rob_item.exception_id;
    assign flush_csrf_we[2] = flush_csrf_we[0];
    assign flush_csrf_write_addr[3] = 'b0;
    assign flush_csrf_write_data[3] = 'b0;
    assign flush_csrf_we[3] = 'b0;

    assign commit_csrf_read_addr[0] = `CSR_MTVEC;
    assign commit_csrf_read_addr[1] = 'b0;
    assign commit_csrf_read_addr[2] = 'b0;
    assign commit_csrf_read_addr[3] = 'b0;

    assign interrupt_flush_csrf_write_addr[0] = `CSR_MEPC;
    assign interrupt_flush_csrf_write_data[0] = cur_rob_item.pc;
    assign interrupt_flush_csrf_we[0] = (cur_state == STATE_INTERRUPT_FLUSH) && (next_state == STATE_NORMAL);
    assign interrupt_flush_csrf_write_addr[1] = `CSR_MTVAL;
    assign interrupt_flush_csrf_write_data[1] = 'b0;
    assign interrupt_flush_csrf_we[1] = interrupt_flush_csrf_we[0];
    assign interrupt_flush_csrf_write_addr[2] = `CSR_MCAUSE;
    assign interrupt_flush_csrf_write_data[2] = 'h80000000 | interrupt_id;
    assign interrupt_flush_csrf_we[2] = interrupt_flush_csrf_we[0];
    assign interrupt_flush_csrf_write_addr[3] = `CSR_MSTATUS;
    assign interrupt_flush_csrf_write_data[3] = {csrf_all_mstatus_data[31:8], csrf_all_mstatus_data[3], csrf_all_mstatus_data[6:4], 1'b0, csrf_all_mstatus_data[2:0]};
    assign interrupt_flush_csrf_we[3] = interrupt_flush_csrf_we[0];

    assign commit_intif_ack_data = ((cur_state == STATE_INTERRUPT_FLUSH) && (next_state == STATE_NORMAL)) ? intif_ack_data : 'b0;

    assign commit_feedback_pack = (cur_state == STATE_NORMAL) ? normal_feedback_pack : (cur_state == STATE_FLUSH) ? flush_feedback_pack : interrupt_flush_feedback_pack;

    assign commit_rob_next_id = rob_commit_retire_head_id + normal_csrf_commit_num_add;

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign rob_item_is_finish[i] = rob_commit_retire_data[i].finish && rob_commit_retire_id_valid[i];
        end
    endgenerate

    assign normal_feedback_pack.enable = !rob_commit_empty;
    assign normal_feedback_pack.next_handle_rob_id_valid = (cur_state == STATE_NORMAL) && (((rob_commit_next_id_valid) && (|rob_item_is_finish)) || ((!rob_commit_empty) && ((next_state == STATE_INTERRUPT_FLUSH) || (!(|rob_item_is_finish)))));
    assign normal_feedback_pack.next_handle_rob_id = (|rob_item_is_finish) ? commit_rob_next_id : rob_commit_retire_head_id;
    assign normal_feedback_pack.has_exception = 'b0;
    assign normal_feedback_pack.exception_pc = 'b0;
    assign normal_feedback_pack.flush = intif_commit_has_interrupt || retire_has_exception || retire_is_miss;

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign normal_feedback_pack.committed_rob_id[i] = commit_rob_retire_id[i];
            assign normal_feedback_pack.committed_rob_id_valid[i] = (next_state != STATE_INTERRUPT_FLUSH) && commit_rob_retire_valid[i];
        end
    endgenerate
    
    assign normal_feedback_pack.jump_enable = retire_has_bru_op && (retire_is_miss || !retire_is_predicted);
    assign normal_feedback_pack.jump = rob_commit_retire_data[retire_has_bru_op_index].bru_jump;
    assign normal_feedback_pack.next_pc = rob_commit_retire_data[retire_has_bru_op_index].bru_jump ? 
                                          rob_commit_retire_data[retire_has_bru_op_index].bru_next_pc :
                                          (rob_commit_retire_data[retire_has_bru_op_index].pc + 'd4);

    assign flush_feedback_pack.enable = 'b1;
    assign flush_feedback_pack.next_handle_rob_id_valid = 'b0;
    assign flush_feedback_pack.next_handle_rob_id = 'b0;
    assign flush_feedback_pack.has_exception = (cur_state == STATE_FLUSH) && (next_state == STATE_NORMAL);
    assign flush_feedback_pack.exception_pc = csrf_commit_read_data[0];
    assign flush_feedback_pack.flush = 'b1;
    assign flush_feedback_pack.committed_rob_id = 'b0;
    assign flush_feedback_pack.committed_rob_id_valid = 'b0;
    assign flush_feedback_pack.jump_enable = 'b0;
    assign flush_feedback_pack.jump = 'b0;
    assign flush_feedback_pack.next_pc = 'b0;

    assign interrupt_flush_feedback_pack.enable = 'b1;
    assign interrupt_flush_feedback_pack.next_handle_rob_id_valid = 'b0;
    assign interrupt_flush_feedback_pack.next_handle_rob_id = 'b0;
    assign interrupt_flush_feedback_pack.has_exception = (cur_state == STATE_INTERRUPT_FLUSH) && (next_state == STATE_NORMAL);
    assign interrupt_flush_feedback_pack.exception_pc = csrf_commit_read_data[0];
    assign interrupt_flush_feedback_pack.flush = 'b1;
    assign interrupt_flush_feedback_pack.committed_rob_id = 'b0;
    assign interrupt_flush_feedback_pack.committed_rob_id_valid = 'b0;
    assign interrupt_flush_feedback_pack.jump_enable = 'b0;
    assign interrupt_flush_feedback_pack.jump = 'b0;
    assign interrupt_flush_feedback_pack.next_pc = 'b0;

    always_ff @(posedge clk) begin
        if(rst) begin
            cur_state <= STATE_NORMAL;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always_comb begin
        case(cur_state)
            STATE_NORMAL: begin
                if(!rob_commit_empty && intif_commit_has_interrupt) begin
                    next_state = STATE_INTERRUPT_FLUSH;
                end
                else if(!rob_commit_empty && retire_has_exception) begin
                    next_state = STATE_FLUSH;
                end
                else begin
                    next_state = STATE_NORMAL;
                end
            end

            STATE_FLUSH: begin
                if(rob_commit_flush_next_id_valid && (commit_rob_flush_id != rob_item_id)) begin
                    next_state = STATE_FLUSH;
                end
                else begin
                    next_state = STATE_NORMAL;
                end
            end

            STATE_INTERRUPT_FLUSH: begin
                if(rob_commit_flush_next_id_valid && (commit_rob_flush_id != rob_item_id)) begin
                    next_state = STATE_INTERRUPT_FLUSH;
                end
                else begin
                    next_state = STATE_NORMAL;
                end
            end

            default: begin
                next_state = STATE_NORMAL;
            end
        endcase
    end
endmodule