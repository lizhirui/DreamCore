`include "config.svh"
`include "common.svh"

module core_top#(
        parameter IMAGE_PATH = "",
        parameter IMAGE_INIT = 0
    )(
        input logic clk,
        input logic rst,

        input logic int_ext,
        
        input logic rxd,
        output logic txd
    );

    //branch_predictor<->ras
    logic[`ADDR_WIDTH - 1:0] bp_ras_addr;
    logic bp_ras_push;
    logic[`ADDR_WIDTH - 1:0] ras_bp_addr;
    logic bp_ras_pop;

    //bus<->store_buffer
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_read_addr;
    logic[`ADDR_WIDTH - 1:0] stbuf_bus_write_addr;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_read_size;
    logic[`SIZE_WIDTH - 1:0] stbuf_bus_write_size;
    logic[`REG_DATA_WIDTH - 1:0] stbuf_bus_data;
    logic stbuf_bus_read_req;
    logic stbuf_bus_write_req;
    logic[`REG_DATA_WIDTH - 1:0] bus_stbuf_data;
    logic bus_stbuf_read_ack;
    logic bus_stbuf_write_ack;

    //bus<->tcm
    logic[`ADDR_WIDTH - 1:0] bus_tcm_fetch_addr;
    logic bus_tcm_fetch_rd;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_fetch_data;

    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_tcm_stbuf_data;
    logic bus_tcm_stbuf_rd;
    logic bus_tcm_stbuf_wr;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_stbuf_data;

    //bus<->clint
    logic[`ADDR_WIDTH - 1:0] bus_clint_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_clint_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_clint_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_clint_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_clint_data;
    logic bus_clint_rd;
    logic bus_clint_wr;
    logic[`BUS_DATA_WIDTH - 1:0] clint_bus_data;

    //csrfile<->interrupt_interface
    logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data;

    //csrfile<->all
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mepc_data;

    //csrfile<->ras
    logic ras_csrf_ras_full_add;

    //csrfile<->fifo_uart_send
    logic[7:0] csrf_usendf_send_data;
    logic csrf_usendf_send;
    logic usendf_csrf_send_busy;

    //csrfile<->fifo_uart_rev
    logic[7:0] urevf_csrf_rev_data;
    logic urevf_csrf_rev_data_valid;
    logic csrf_urevf_rev_data_invalid;

    //execute_feedback_pack<->all
    execute_feedback_pack_t execute_feedback_pack;

    //interrupt_interface<->all
    logic all_intif_int_ext_req;
    logic all_intif_int_software_req;
    logic all_intif_int_timer_req;

    logic intif_all_int_ext_ack;
    logic intif_all_int_software_ack;
    logic intif_all_int_timer_ack;

    //store_buffer<->all
    logic stbuf_all_empty;

    //uart_controller<->fifo_uart_send
    logic[7:0] usendf_uart_send_data;
    logic usendf_uart_send;
    logic uart_usendf_send_busy;

    //uart_controller<->fifo_uart_rev
    logic[7:0] uart_urevf_rev_data;
    logic uart_urevf_rev_data_valid;
    logic urevf_uart_rev_data_invalid;

    //fetch<->branch_predictor
    logic[`ADDR_WIDTH -1:0] fetch_bp_update_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction;
    logic fetch_bp_update_jump;
    logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc;
    logic fetch_bp_update_valid;

    logic[`ADDR_WIDTH -1:0] fetch_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction;
    logic fetch_bp_valid;
    logic bp_fetch_jump;
    logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc;
    logic bp_fetch_valid;
    logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history;
    logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history; 

    //fetch<->bus
    logic[`ADDR_WIDTH - 1:0] fetch_bus_addr;
    logic fetch_bus_read_req;
    logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data;
    logic bus_fetch_read_ack;

    //fetch<->csrfile
    logic fetch_csrf_checkpoint_buffer_full_add;
    logic fetch_csrf_fetch_not_full_add;
    logic fetch_csrf_fetch_decode_fifo_full_add;

    //fetch<->checkpoint_buffer
    logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id;
    logic cpbuf_fetch_new_id_valid;
    checkpoint_t fetch_cpbuf_data;
    logic fetch_cpbuf_push;

    //fetch<->fetch_decode_fifo
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_enable;
    fetch_decode_pack_t fetch_decode_fifo_data_in[0:`FETCH_WIDTH - 1];
    logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_valid;
    logic fetch_decode_fifo_push;
    logic fetch_decode_fifo_flush;

    //decode<->csrfile
    logic decode_csrf_decode_rename_fifo_full_add;

    //decode<->fetch_decode_fifo
    fetch_decode_pack_t fetch_decode_fifo_data_out[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_out_valid;
    logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_pop_valid;
    logic fetch_decode_fifo_pop;

    //decode<->decode_rename_fifo
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_enable;
    decode_rename_pack_t decode_rename_fifo_data_in[0:`DECODE_WIDTH - 1];
    logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_valid;
    logic decode_rename_fifo_push;
    logic decode_rename_fifo_flush;

    //decode<->all
    decode_feedback_pack_t decode_feedback_pack;

    //rename<->checkpoint_buffer
    logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1];
    checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we;
    checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1];

    //rename<->rat
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_new_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rat_rename_new_phy_id_valid;
    logic[`PHY_REG_ID_WIDTH - 1:0] rename_rat_phy_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rat_phy_id_valid;
    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_arch_id[0:`RENAME_WIDTH - 1];
    logic rename_rat_map;

    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_valid;
    logic[`PHY_REG_NUM - 1:0] rat_rename_map_table_visible;

    logic[`ARCH_REG_ID_WIDTH - 1:0] rename_rat_read_arch_id[0:`RENAME_WIDTH - 1][0:2];
    logic[`PHY_REG_ID_WIDTH - 1:0] rat_rename_read_phy_id[0:`RENAME_WIDTH - 1][0:2];

    //rename<->rob
    logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid;

    rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid;
    logic rename_rob_push;

    //rename<->csrfile
    logic rename_csrf_phy_regfile_full_add;
    logic rename_csrf_rob_full_add;

    //rename<->decode_rename_fifo
    decode_rename_pack_t decode_rename_fifo_data_out[0:`RENAME_WIDTH - 1];
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_out_valid;
    logic[`RENAME_WIDTH - 1:0] decode_rename_fifo_data_pop_valid;
    logic decode_rename_fifo_pop;

    //rename<->rename_readreg_port
    rename_readreg_pack_t rename_readreg_port_data_in;
    logic rename_readreg_port_we;
    logic rename_readreg_port_flush;

    //rename<->all
    rename_feedback_pack_t rename_feedback_pack;

    //readreg<->phy_regfile
    logic[`PHY_REG_ID_WIDTH - 1:0] readreg_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_readreg_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_readreg_data_valid[0:`READREG_WIDTH - 1][0:1];

    //readreg<->rename_readreg_port
    rename_readreg_pack_t rename_readreg_port_data_out;

    //readreg<->readreg_issue_port
    readreg_issue_pack_t readreg_issue_port_data_in;
    logic readreg_issue_port_we;
    logic readreg_issue_port_flush;

    //issue<->phy_regfile
    logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1];
    logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1];
    logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1];

    //issue<->store_buffer
    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size;
    logic issue_stbuf_rd;

    //issue<->csrfile
    logic issue_csrf_issue_execute_fifo_full_add;
    logic issue_csrf_issue_queue_full_add;

    //issue<->readreg_issue_port
    readreg_issue_pack_t readreg_issue_port_data_out;

    //issue<->issue_alu_fifo
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full;
    issue_execute_pack_t issue_alu_fifo_data_in[0:`ALU_UNIT_NUM - 1];
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_push;
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_flush;

    //issue<->issue_bru_fifo
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full;
    issue_execute_pack_t issue_bru_fifo_data_in[0:`BRU_UNIT_NUM - 1];
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_push;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_flush;

    //issue<->issue_csr_fifo
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full;
    issue_execute_pack_t issue_csr_fifo_data_in[0:`CSR_UNIT_NUM - 1];
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_push;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_flush;

    //issue<->issue_div_fifo
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full;
    issue_execute_pack_t issue_div_fifo_data_in[0:`DIV_UNIT_NUM - 1];
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_push;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_flush;

    //issue<->issue_lsu_fifo
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full;
    issue_execute_pack_t issue_lsu_fifo_data_in[0:`LSU_UNIT_NUM - 1];
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_push;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_flush;

    //issue<->issue_mul_fifo
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full;
    issue_execute_pack_t issue_mul_fifo_data_in[0:`MUL_UNIT_NUM - 1];
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_push;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_flush;

    //issue<->all
    issue_feedback_pack_t issue_feedback_pack;

    //execute_alu<->issue_execute_alu_fifo
    issue_execute_pack_t issue_alu_fifo_data_out[0:`ALU_UNIT_NUM - 1];
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_data_out_valid;
    logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_pop;

    //execute_alu<->execute_alu_wb_port
    execute_wb_pack_t alu_wb_port_data_in[0:`ALU_UNIT_NUM - 1];
    logic[`ALU_UNIT_NUM - 1:0] alu_wb_port_we;
    logic[`ALU_UNIT_NUM - 1:0] alu_wb_port_flush;

    //execute_alu<->execute_feedback
    execute_feedback_channel_t alu_execute_channel_feedback_pack[0:`ALU_UNIT_NUM - 1];

    //execute_bru<->checkpoint_buffer
    logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id;
    checkpoint_t cpbuf_exbru_data;

    //execute_bru<->branch_predictor
    checkpoint_t exbru_bp_cp;
    logic[`ADDR_WIDTH -1:0] exbru_bp_pc;
    logic[`INSTRUCTION_WIDTH - 1:0] exbru_bp_instruction;
    logic exbru_bp_jump;
    logic[`ADDR_WIDTH - 1:0] exbru_bp_next_pc;
    logic exbru_bp_hit;
    logic exbru_bp_valid;

    //execute_bru<->issue_execute_bru_fifo
    issue_execute_pack_t issue_bru_fifo_data_out[0:`BRU_UNIT_NUM - 1];
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_data_out_valid;
    logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_pop;

    //execute_bru<->execute_bru_wb_port
    execute_wb_pack_t bru_wb_port_data_in[0:`BRU_UNIT_NUM - 1];
    logic[`BRU_UNIT_NUM - 1:0] bru_wb_port_we;
    logic[`BRU_UNIT_NUM - 1:0] bru_wb_port_flush;

    //execute_bru<->execute_feedback
    execute_feedback_channel_t bru_execute_channel_feedback_pack[0:`BRU_UNIT_NUM - 1];

    //execute_csr<->csrfile
    logic[`CSR_ADDR_WIDTH - 1:0] excsr_csrf_addr;
    logic[`REG_DATA_WIDTH - 1:0] csrf_excsr_data;

    //execute_csr<->issue_execute_csr_fifo
    issue_execute_pack_t issue_csr_fifo_data_out[0:`CSR_UNIT_NUM - 1];
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_data_out_valid;
    logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_pop;

    //execute_csr<->execute_csr_wb_port
    execute_wb_pack_t csr_wb_port_data_in[0:`CSR_UNIT_NUM - 1];
    logic[`CSR_UNIT_NUM - 1:0] csr_wb_port_we;
    logic[`CSR_UNIT_NUM - 1:0] csr_wb_port_flush;

    //execute_csr<->execute_feedback
    execute_feedback_channel_t csr_execute_channel_feedback_pack[0:`CSR_UNIT_NUM - 1];

    //execute_div<->issue_execute_div_fifo
    issue_execute_pack_t issue_div_fifo_data_out[0:`DIV_UNIT_NUM - 1];
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_data_out_valid;
    logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_pop;

    //execute_div<->execute_div_wb_port
    execute_wb_pack_t div_wb_port_data_in[0:`DIV_UNIT_NUM - 1];
    logic[`DIV_UNIT_NUM - 1:0] div_wb_port_we;
    logic[`DIV_UNIT_NUM - 1:0] div_wb_port_flush;

    //execute_div<->execute_feedback
    execute_feedback_channel_t div_execute_channel_feedback_pack[0:`DIV_UNIT_NUM - 1];

    //execute_lsu<->store_buffer
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data;
    logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback;
    logic stbuf_exlsu_bus_ready;

    logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id;
    logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size;
    logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data;
    logic exlsu_stbuf_push;
    logic stbuf_exlsu_full;

    //execute_lsu<->issue_execute_lsu_fifo
    issue_execute_pack_t issue_lsu_fifo_data_out[0:`LSU_UNIT_NUM - 1];
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_data_out_valid;
    logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_pop;

    //execute_lsu<->execute_lsu_wb_port
    execute_wb_pack_t lsu_wb_port_data_in[0:`LSU_UNIT_NUM - 1];
    logic[`LSU_UNIT_NUM - 1:0] lsu_wb_port_we;
    logic[`LSU_UNIT_NUM - 1:0] lsu_wb_port_flush;

    //execute_lsu<->execute_feedback
    execute_feedback_channel_t lsu_execute_channel_feedback_pack[0:`LSU_UNIT_NUM - 1];

    //execute_mul<->issue_execute_mul_fifo
    issue_execute_pack_t issue_mul_fifo_data_out[0:`MUL_UNIT_NUM - 1];
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_data_out_valid;
    logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_pop;

    //execute_mul<->execute_mul_wb_port
    execute_wb_pack_t mul_wb_port_data_in[0:`MUL_UNIT_NUM - 1];
    logic[`MUL_UNIT_NUM - 1:0] mul_wb_port_we;
    logic[`MUL_UNIT_NUM - 1:0] mul_wb_port_flush;

    //execute_mul<->execute_feedback
    execute_feedback_channel_t mul_execute_channel_feedback_pack[0:`MUL_UNIT_NUM - 1];

    //wb<->phy_regfile
    logic[`PHY_REG_ID_WIDTH - 1:0] wb_phyf_id[0:`WB_WIDTH - 1];
    logic[`REG_DATA_WIDTH - 1:0] wb_phyf_data[0:`WB_WIDTH - 1];
    logic[`WB_WIDTH - 1:0] wb_phyf_we;

    //wb<->execute_alu_wb_port
    execute_wb_pack_t alu_wb_port_data_out[0:`ALU_UNIT_NUM - 1];

    //wb<->execute_bru_wb_port
    execute_wb_pack_t bru_wb_port_data_out[0:`BRU_UNIT_NUM - 1];

    //wb<->execute_csr_wb_port
    execute_wb_pack_t csr_wb_port_data_out[0:`CSR_UNIT_NUM - 1];

    //wb<->execute_div_wb_port
    execute_wb_pack_t div_wb_port_data_out[0:`DIV_UNIT_NUM - 1];

    //wb<->execute_lsu_wb_port
    execute_wb_pack_t lsu_wb_port_data_out[0:`LSU_UNIT_NUM - 1];

    //wb<->execute_mul_wb_port
    execute_wb_pack_t mul_wb_port_data_out[0:`MUL_UNIT_NUM - 1];

    //wb<->wb_commit_port
    wb_commit_pack_t wb_commit_port_data_in;
    logic wb_commit_port_we;
    logic wb_commit_port_flush;

    //wb<->all
    wb_feedback_pack_t wb_feedback_pack;

    //commit<->interrupt_interface
    logic intif_commit_has_interrupt;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data;
    logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data;

    //commit<->branch_predictor
    logic[`ADDR_WIDTH -1:0] commit_bp_pc[0:`COMMIT_WIDTH - 1];
    logic[`INSTRUCTION_WIDTH - 1:0] commit_bp_instruction[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_jump;
    logic[`ADDR_WIDTH - 1:0] commit_bp_next_pc[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_bp_hit;
    logic[`COMMIT_WIDTH - 1:0] commit_bp_valid;

    //commit<->checkpoint_buffer
    logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1];
    checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop;
    logic commit_cpbuf_flush;

    //commit<->rat
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

    //commit<->csrfile
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_read_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] csrf_commit_read_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`CSR_ADDR_WIDTH - 1:0] commit_csrf_write_addr[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`REG_DATA_WIDTH - 1:0] commit_csrf_write_data[0:`COMMIT_CSR_CHANNEL_NUM - 1];
    logic[`COMMIT_CSR_CHANNEL_NUM - 1:0] commit_csrf_we;

    logic commit_csrf_branch_num_add;
    logic commit_csrf_branch_predicted_add;
    logic commit_csrf_branch_hit_add;
    logic commit_csrf_branch_miss_add;
    logic[$clog2(`COMMIT_WIDTH):0] commit_csrf_commit_num_add;

    //commit<->rob
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

    logic rob_commit_empty;
    logic rob_commit_full;
    logic commit_rob_flush;

    //commit<->phy_regfile
    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_id[0:`COMMIT_WIDTH - 1];
    logic[`COMMIT_WIDTH - 1:0] commit_phyf_invalid;

    logic[`PHY_REG_ID_WIDTH - 1:0] commit_phyf_flush_id;
    logic commit_phyf_flush_invalid;

    logic[`PHY_REG_NUM - 1:0] commit_phyf_data_valid;
    logic commit_phyf_data_valid_restore;

    //commit<->wb_commit_port
    wb_commit_pack_t wb_commit_port_data_out;

    //commit<->all
    commit_feedback_pack_t commit_feedback_pack;

    logic fifo_uart_rev_full;

    genvar i;

    fetch fetch_inst(.*);
    decode decode_inst(.*);
    rename rename_inst(.*);
    readreg readreg_inst(.*);
    issue issue_inst(.*);

    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin: execute_alu_generate
            execute_alu execute_alu_inst(
                .*,
                .issue_alu_fifo_data_out(issue_alu_fifo_data_out[i]),
                .issue_alu_fifo_data_out_valid(issue_alu_fifo_data_out_valid[i]),
                .issue_alu_fifo_pop(issue_alu_fifo_pop[i]),
                .alu_wb_port_data_in(alu_wb_port_data_in[i]),
                .alu_wb_port_we(alu_wb_port_we[i]),
                .alu_wb_port_flush(alu_wb_port_flush[i]),
                .alu_execute_channel_feedback_pack(alu_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `BRU_UNIT_NUM;i++) begin: execute_bru_generate
            execute_bru execute_bru_inst(
                .*,
                .issue_bru_fifo_data_out(issue_bru_fifo_data_out[i]),
                .issue_bru_fifo_data_out_valid(issue_bru_fifo_data_out_valid[i]),
                .issue_bru_fifo_pop(issue_bru_fifo_pop[i]),
                .bru_wb_port_data_in(bru_wb_port_data_in[i]),
                .bru_wb_port_we(bru_wb_port_we[i]),
                .bru_wb_port_flush(bru_wb_port_flush[i]),
                .bru_execute_channel_feedback_pack(bru_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `CSR_UNIT_NUM;i++) begin: execute_csr_generate
            execute_csr execute_csr_inst(
                .*,
                .issue_csr_fifo_data_out(issue_csr_fifo_data_out[i]),
                .issue_csr_fifo_data_out_valid(issue_csr_fifo_data_out_valid[i]),
                .issue_csr_fifo_pop(issue_csr_fifo_pop[i]),
                .csr_wb_port_data_in(csr_wb_port_data_in[i]),
                .csr_wb_port_we(csr_wb_port_we[i]),
                .csr_wb_port_flush(csr_wb_port_flush[i]),
                .csr_execute_channel_feedback_pack(csr_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `DIV_UNIT_NUM;i++) begin: execute_div_generate
            execute_div execute_div_inst(
                .*,
                .issue_div_fifo_data_out(issue_div_fifo_data_out[i]),
                .issue_div_fifo_data_out_valid(issue_div_fifo_data_out_valid[i]),
                .issue_div_fifo_pop(issue_div_fifo_pop[i]),
                .div_wb_port_data_in(div_wb_port_data_in[i]),
                .div_wb_port_we(div_wb_port_we[i]),
                .div_wb_port_flush(div_wb_port_flush[i]),
                .div_execute_channel_feedback_pack(div_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `LSU_UNIT_NUM;i++) begin: execute_lsu_generate
            execute_lsu execute_lsu_inst(
                .*,
                .issue_lsu_fifo_data_out(issue_lsu_fifo_data_out[i]),
                .issue_lsu_fifo_data_out_valid(issue_lsu_fifo_data_out_valid[i]),
                .issue_lsu_fifo_pop(issue_lsu_fifo_pop[i]),
                .lsu_wb_port_data_in(lsu_wb_port_data_in[i]),
                .lsu_wb_port_we(lsu_wb_port_we[i]),
                .lsu_wb_port_flush(lsu_wb_port_flush[i]),
                .lsu_execute_channel_feedback_pack(lsu_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `MUL_UNIT_NUM;i++) begin: execute_mul_generate
            execute_mul execute_mul_inst(
                .*,
                .issue_mul_fifo_data_out(issue_mul_fifo_data_out[i]),
                .issue_mul_fifo_data_out_valid(issue_mul_fifo_data_out_valid[i]),
                .issue_mul_fifo_pop(issue_mul_fifo_pop[i]),
                .mul_wb_port_data_in(mul_wb_port_data_in[i]),
                .mul_wb_port_we(mul_wb_port_we[i]),
                .mul_wb_port_flush(mul_wb_port_flush[i]),
                .mul_execute_channel_feedback_pack(mul_execute_channel_feedback_pack[i])
            );
        end
    endgenerate

    wb wb_inst(.*);
    commit commit_inst(.*);

    branch_predictor branch_predictor_inst(.*);
    bus bus_inst(.*);
    checkpoint_buffer checkpoint_buffer_inst(.*);
    clint clint_inst(.*);

    tcm #(
        .IMAGE_PATH(IMAGE_PATH),
        .IMAGE_INIT(IMAGE_INIT)
    )tcm_inst(
        .*
    );

    csrfile csrfile_inst(
        .*,
        .uart_send_data(csrf_usendf_send_data),
        .uart_send(csrf_usendf_send),
        .uart_send_busy(usendf_csrf_send_busy),
        .uart_rev_data(urevf_csrf_rev_data),
        .uart_rev_data_valid(urevf_csrf_rev_data_valid),
        .uart_rev_data_invalid(csrf_urevf_rev_data_invalid)
    );
    execute_feedback execute_feedback_inst(.*);
    interrupt_interface interrupt_interface_inst(.*);
    phy_regfile phy_regfile_inst(.*);

    ras #(
        .DEPTH(`RAS_SIZE)
    )ras_inst(
        .*
    );

    rat rat_inst(.*);
    rob rob_inst(.*);
    store_buffer store_buffer_inst(.*);

    multififo #(
        .PORT_NUM(`FETCH_WIDTH),
        .WIDTH($bits(fetch_decode_pack_t)),
        .DEPTH(`FETCH_DECODE_FIFO_SIZE)
    )multififo_fetch_decode_inst(
        .*,
        .data_in_enable(fetch_decode_fifo_data_in_enable),
        .data_in(fetch_decode_fifo_data_in),
        .data_in_valid(fetch_decode_fifo_data_in_valid),
        .push(fetch_decode_fifo_push),
        .flush(fetch_decode_fifo_flush),
        .data_out(fetch_decode_fifo_data_out),
        .data_out_valid(fetch_decode_fifo_data_out_valid),
        .data_pop_valid(fetch_decode_fifo_data_pop_valid),
        .pop(fetch_decode_fifo_pop),
        .full(),
        .empty()
    );

    multififo #(
        .PORT_NUM(`FETCH_WIDTH),
        .WIDTH($bits(decode_rename_pack_t)),
        .DEPTH(`DECODE_RENAME_FIFO_SIZE)
    )multififo_decode_rename_inst(
        .*,
        .data_in_enable(decode_rename_fifo_data_in_enable),
        .data_in(decode_rename_fifo_data_in),
        .data_in_valid(decode_rename_fifo_data_in_valid),
        .push(decode_rename_fifo_push),
        .flush(decode_rename_fifo_flush),
        .data_out(decode_rename_fifo_data_out),
        .data_out_valid(decode_rename_fifo_data_out_valid),
        .data_pop_valid(decode_rename_fifo_data_pop_valid),
        .pop(decode_rename_fifo_pop),
        .full(),
        .empty()
    );

    port #(
        .WIDTH($bits(rename_readreg_pack_t))
    )port_rename_readreg_inst(
        .*,
        .data_in(rename_readreg_port_data_in),
        .we(rename_readreg_port_we),
        .flush(rename_readreg_port_flush),
        .data_out(rename_readreg_port_data_out)
    );

    port #(
        .WIDTH($bits(readreg_issue_pack_t))
    )port_readreg_issue_inst(
        .*,
        .data_in(readreg_issue_port_data_in),
        .we(readreg_issue_port_we),
        .flush(readreg_issue_port_flush),
        .data_out(readreg_issue_port_data_out)
    );

    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin: fifo_issue_alu_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_alu_inst(
                .*,
                .data_in(issue_alu_fifo_data_in[i]),
                .push(issue_alu_fifo_push[i]),
                .full(issue_alu_fifo_full[i]),
                .flush(issue_alu_fifo_flush[i]),
                .data_out(issue_alu_fifo_data_out[i]),
                .data_out_valid(issue_alu_fifo_data_out_valid[i]),
                .pop(issue_alu_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `BRU_UNIT_NUM;i++) begin: fifo_issue_bru_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_bru_inst(
                .*,
                .data_in(issue_bru_fifo_data_in[i]),
                .push(issue_bru_fifo_push[i]),
                .full(issue_bru_fifo_full[i]),
                .flush(issue_bru_fifo_flush[i]),
                .data_out(issue_bru_fifo_data_out[i]),
                .data_out_valid(issue_bru_fifo_data_out_valid[i]),
                .pop(issue_bru_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `CSR_UNIT_NUM;i++) begin: fifo_issue_csr_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_csr_inst(
                .*,
                .data_in(issue_csr_fifo_data_in[i]),
                .push(issue_csr_fifo_push[i]),
                .full(issue_csr_fifo_full[i]),
                .flush(issue_csr_fifo_flush[i]),
                .data_out(issue_csr_fifo_data_out[i]),
                .data_out_valid(issue_csr_fifo_data_out_valid[i]),
                .pop(issue_csr_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `DIV_UNIT_NUM;i++) begin: fifo_issue_div_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_div_inst(
                .*,
                .data_in(issue_div_fifo_data_in[i]),
                .push(issue_div_fifo_push[i]),
                .full(issue_div_fifo_full[i]),
                .flush(issue_div_fifo_flush[i]),
                .data_out(issue_div_fifo_data_out[i]),
                .data_out_valid(issue_div_fifo_data_out_valid[i]),
                .pop(issue_div_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `LSU_UNIT_NUM;i++) begin: fifo_issue_lsu_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_lsu_inst(
                .*,
                .data_in(issue_lsu_fifo_data_in[i]),
                .push(issue_lsu_fifo_push[i]),
                .full(issue_lsu_fifo_full[i]),
                .flush(issue_lsu_fifo_flush[i]),
                .data_out(issue_lsu_fifo_data_out[i]),
                .data_out_valid(issue_lsu_fifo_data_out_valid[i]),
                .pop(issue_lsu_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `MUL_UNIT_NUM;i++) begin: fifo_issue_mul_interface
            handshake_dff #(
                .WIDTH($bits(issue_execute_pack_t))
            )fifo_issue_execute_mul_inst(
                .*,
                .data_in(issue_mul_fifo_data_in[i]),
                .push(issue_mul_fifo_push[i]),
                .full(issue_mul_fifo_full[i]),
                .flush(issue_mul_fifo_flush[i]),
                .data_out(issue_mul_fifo_data_out[i]),
                .data_out_valid(issue_mul_fifo_data_out_valid[i]),
                .pop(issue_mul_fifo_pop[i]),
                .empty()
            );
        end
    endgenerate

    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin:port_alu_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_alu_wb_inst(
                .*,
                .data_in(alu_wb_port_data_in[i]),
                .we(alu_wb_port_we[i]),
                .flush(alu_wb_port_flush[i]),
                .data_out(alu_wb_port_data_out[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `BRU_UNIT_NUM;i++) begin:port_bru_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_bru_wb_inst(
                .*,
                .data_in(bru_wb_port_data_in[i]),
                .we(bru_wb_port_we[i]),
                .flush(bru_wb_port_flush[i]),
                .data_out(bru_wb_port_data_out[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `CSR_UNIT_NUM;i++) begin:port_csr_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_csr_wb_inst(
                .*,
                .data_in(csr_wb_port_data_in[i]),
                .we(csr_wb_port_we[i]),
                .flush(csr_wb_port_flush[i]),
                .data_out(csr_wb_port_data_out[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `DIV_UNIT_NUM;i++) begin:port_div_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_div_wb_inst(
                .*,
                .data_in(div_wb_port_data_in[i]),
                .we(div_wb_port_we[i]),
                .flush(div_wb_port_flush[i]),
                .data_out(div_wb_port_data_out[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `LSU_UNIT_NUM;i++) begin:port_lsu_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_lsu_wb_inst(
                .*,
                .data_in(lsu_wb_port_data_in[i]),
                .we(lsu_wb_port_we[i]),
                .flush(lsu_wb_port_flush[i]),
                .data_out(lsu_wb_port_data_out[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < `MUL_UNIT_NUM;i++) begin:port_mul_wb_interface
            port #(
                .WIDTH($bits(execute_wb_pack_t))
            )port_execute_mul_wb_inst(
                .*,
                .data_in(mul_wb_port_data_in[i]),
                .we(mul_wb_port_we[i]),
                .flush(mul_wb_port_flush[i]),
                .data_out(mul_wb_port_data_out[i])
            );
        end
    endgenerate

    port #(
        .WIDTH($bits(wb_commit_pack_t))
    )port_wb_commit_inst(
        .*,
        .data_in(wb_commit_port_data_in),
        .we(wb_commit_port_we),
        .flush(wb_commit_port_flush),
        .data_out(wb_commit_port_data_out)
    );

    assign all_intif_int_ext_req = int_ext;

    uart_controller #(
        .FREQ_DIV(`UART_FREQ_DIV)
    )uart_controller_inst(
        .*,
        .send_data(usendf_uart_send_data),
        .send(usendf_uart_send),
        .send_busy(uart_usendf_send_busy),
        .rev_data(uart_urevf_rev_data),
        .rev_data_valid(uart_urevf_rev_data_valid),
        .rev_data_invalid(urevf_uart_rev_data_invalid)
    );

    fifo #(
        .WIDTH(8),
        .DEPTH(`UART_SEND_FIFO_SIZE)
    )fifo_uart_send_inst(
        .*,
        .data_in(csrf_usendf_send_data),
        .push(csrf_usendf_send),
        .full(usendf_csrf_send_busy),
        .flush(1'b0),
        .data_out(usendf_uart_send_data),
        .data_out_valid(usendf_uart_send),
        .pop(!uart_usendf_send_busy),
        .empty()
    );

    fifo #(
        .WIDTH(8),
        .DEPTH(`UART_REV_FIFO_SIZE)
    )fifo_uart_rev_inst(
        .*,
        .data_in(uart_urevf_rev_data),
        .push(uart_urevf_rev_data_valid),
        .full(fifo_uart_rev_full),
        .flush(1'b0),
        .data_out(urevf_csrf_rev_data),
        .data_out_valid(urevf_csrf_rev_data_valid),
        .pop(csrf_urevf_rev_data_invalid),
        .empty()
    );

    assign urevf_uart_rev_data_invalid = !fifo_uart_rev_full && uart_urevf_rev_data_valid;
endmodule