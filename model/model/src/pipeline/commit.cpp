#include "common.h"
#include "commit.h"
#include "../component/csr_all.h"

namespace pipeline
{
	commit::commit(component::port<wb_commit_pack_t> *wb_commit_port, component::rat *rat, component::rob *rob, component::csrfile *csr_file, component::regfile<phy_regfile_item_t> *phy_regfile, component::checkpoint_buffer *checkpoint_buffer, component::branch_predictor *branch_predictor, component::interrupt_interface *interrupt_interface) : tdb(TRACE_COMMIT)
	{
		this->wb_commit_port = wb_commit_port;
		this->rat = rat;
		this->rob = rob;
		this->csr_file = csr_file;
		this->phy_regfile = phy_regfile;
		this->cur_state = state_t::normal;
		this->rob_item_id = 0;
		this->restore_rob_item_id = 0;
		this->interrupt_pc = 0;
		this->interrupt_id = riscv_interrupt_t::machine_external;
		this->checkpoint_buffer = checkpoint_buffer;
		this->branch_predictor = branch_predictor;
		this->interrupt_interface = interrupt_interface;
	}

	void commit::reset()
	{
		this->cur_state = state_t::normal;
		this->interrupt_pc = 0;
		this->interrupt_id = riscv_interrupt_t::machine_external;

		this->tdb.create(TRACE_DIR + "commit.tdb");
		this->tdb.bind_signal(trace::domain_t::status, "cur_state", &this->cur_state, sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::input, "intif_commit_has_interrupt", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "intif_commit_mcause_data", sizeof(uint32_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "intif_commit_ack_data", sizeof(uint32_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_intif_ack_data", sizeof(uint32_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_pc", sizeof(uint32_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_instruction", sizeof(uint32_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_jump", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_hit", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_bp_valid", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_cpbuf_id", sizeof(uint16_t), COMMIT_WIDTH);
		this->tdb.mark_signal_bitmap(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_valid", PHY_REG_NUM, COMMIT_WIDTH);
        this->tdb.mark_signal_bitmap(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_visible", PHY_REG_NUM, COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_commit_data.global_history", sizeof(uint16_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_commit_data.local_history", sizeof(uint16_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_cpbuf_pop", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_cpbuf_flush", sizeof(uint8_t), 1);

		this->tdb.mark_signal_bitmap(trace::domain_t::output, "commit_rat_map_table_valid", PHY_REG_NUM, 1);
        this->tdb.mark_signal_bitmap(trace::domain_t::output, "commit_rat_map_table_visible", PHY_REG_NUM, 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_map_table_restore", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_release_phy_id", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_release_phy_id_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_release_map", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_commit_phy_id", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_commit_phy_id_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_commit_map", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_restore_new_phy_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_restore_old_phy_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rat_restore_map", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_read_addr", sizeof(uint16_t), 4);
		this->tdb.mark_signal(trace::domain_t::input, "csrf_commit_read_data", sizeof(uint32_t), 4);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_write_addr", sizeof(uint16_t), 4);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_write_data", sizeof(uint32_t), 4);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_we", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::input, "csrf_all_mstatus_data", sizeof(uint32_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_branch_num_add", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_branch_predicted_add", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_branch_hit_add", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_branch_miss_add", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_csrf_commit_num_add", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_next_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_next_id_valid", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_tail_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_tail_id_valid", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_flush_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.new_phy_reg_id", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.finish", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.inst_value", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.has_exception", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.exception_id", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.exception_value", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.predicted", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.predicted_jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.predicted_next_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id", sizeof(uint16_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.bru_op", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.bru_jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.bru_next_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.is_mret", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.csr_addr", sizeof(uint16_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_next_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_flush_next_id_valid", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.new_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.finish", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.inst_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.bru_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.is_mret", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.csr_addr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.new_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.finish", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.inst_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.bru_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.is_mret", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.csr_addr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_input_data.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_input_data_we", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_head_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_head_id_valid" ,sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_retire_id", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.new_phy_reg_id", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id_valid", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.finish", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.pc", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.inst_value", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.has_exception", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.exception_id", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.exception_value", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.predicted", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.predicted_jump", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.predicted_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id_valid", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id", sizeof(uint16_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.bru_op", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.bru_jump", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.bru_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.is_mret", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.csr_addr", sizeof(uint16_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue", sizeof(uint32_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue_valid", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_retire_id_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_retire_pop", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_phyf_id", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_phyf_invalid", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_phyf_flush_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_phyf_flush_invalid", sizeof(uint8_t), 1);

		this->tdb.mark_signal_bitmap(trace::domain_t::output, "commit_phyf_data_valid", PHY_REG_NUM, 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_phyf_data_valid_restore", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rob_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.imm", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs1", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.arg1_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs1_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs1_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.src1_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.src1_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs2", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.arg2_src", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs2_need_map", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rs2_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.src2_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.src2_loaded", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rd", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rd_enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.need_rename", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rd_phy", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.rd_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.csr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.op_unit", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_commit_port_data_out.sub_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);

		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_empty", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::input, "rob_commit_full", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_rob_flush", sizeof(uint8_t), 1);

		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.has_exception", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.exception_pc", sizeof(uint32_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.flush", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.committed_rob_id", sizeof(uint8_t), COMMIT_WIDTH);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.committed_rob_id_valid", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.jump_enable", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.jump", sizeof(uint8_t), 1);
		this->tdb.mark_signal(trace::domain_t::output, "commit_feedback_pack.next_pc", sizeof(uint32_t), 1);
	
		this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
	}

    commit_feedback_pack_t commit::run()
	{
		this->tdb.capture_input();

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "intif_commit_has_interrupt", 0, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "intif_commit_mcause_data", 0, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "intif_commit_ack_data", 0, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_intif_ack_data", 0, 0);

        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_pc", 0, i);
    		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_instruction", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_bp_jump", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_bp_hit", 0, 0);
    	this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_bp_valid", 0, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_next_pc", 0, i);
    
    		this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_cpbuf_id", 0, i);
    		this->tdb.update_signal_bitmap_all(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_valid", 0, i);
            this->tdb.update_signal_bitmap_all(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_visible", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_commit_data.global_history", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_commit_data.local_history", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_cpbuf_pop", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_cpbuf_flush", 0, 0);

		this->tdb.update_signal_bitmap_all(trace::domain_t::output, "commit_rat_map_table_valid", 0, 0);
        this->tdb.update_signal_bitmap_all(trace::domain_t::output, "commit_rat_map_table_visible", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_map_table_restore", 0, 0);

        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_release_phy_id", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_release_phy_id_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_release_map", 0, 0);

        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_commit_phy_id", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_commit_phy_id_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_commit_map", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_new_phy_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_old_phy_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_map", 0, 0);

        
        for(auto i = 0;i < 4;i++)
        {
    		this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_read_addr", 0, i);
    		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_commit_read_data", 0, i);
    		this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", 0, i);
    		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_we", 0, 0);

		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mstatus_data", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_num_add", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_predicted_add", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_hit_add", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_miss_add", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_commit_num_add", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_next_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_next_id_valid", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_tail_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_tail_id_valid", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.new_phy_reg_id", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.finish", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.pc", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.inst_value", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.has_exception", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_id", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_value", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_next_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id_valid", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_op", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.bru_next_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.is_mret", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.csr_addr", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id_valid", 0, 0);

        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
			this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_id", 0, i);
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.new_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.finish", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.inst_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_rob_input_data.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.bru_op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.is_mret", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_rob_input_data.csr_addr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.csr_newvalue_valid", 0, i);
    		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.new_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.finish", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.inst_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_input_data.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.bru_op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.is_mret", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_input_data.csr_addr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.csr_newvalue_valid", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data_we", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_head_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_head_id_valid" ,0, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
			this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_retire_id", 0, i);
    		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.new_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.finish", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.inst_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.is_mret", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.csr_addr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue_valid", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_id_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_retire_pop", 0, 0);

        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_id", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_invalid", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_invalid", 0, 0);

		this->tdb.update_signal_bitmap_all(trace::domain_t::output, "commit_phyf_data_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_data_valid_restore", 0, 0);

        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.bru_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.bru_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_value", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "wb_commit_port_data_out.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue_valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.sub_op", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_empty", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_full", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush", 0, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.enable", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.has_exception", 0, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_feedback_pack.exception_pc", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.flush", 0, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.committed_rob_id", 0, i);
        }

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.committed_rob_id_valid", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.jump_enable", 0, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.jump", 0, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_feedback_pack.next_pc", 0, 0);

		{
			riscv_interrupt_t t = riscv_interrupt_t::user_software;
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "intif_commit_has_interrupt", interrupt_interface->get_cause(&t), 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "intif_commit_mcause_data", (uint32_t)t, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "intif_commit_ack_data", 1U << ((uint32_t)t), 0);
		}

		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mstatus_data", csr_file->read_sys(CSR_MSTATUS), 0);

		{
			uint32_t rob_item_id;
			auto t = rob->get_tail_id(&rob_item_id);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_tail_id", rob_item_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_tail_id_valid", t, 0);
		}

		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_empty", rob->is_empty(), 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_full", rob->is_full(), 0);
		this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_read_addr", CSR_MTVEC, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_commit_read_data", csr_file->read_sys(CSR_MTVEC), 0);

		csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_read_addr", CSR_MTVEC, 0);
		csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "csrf_commit_read_data", csr_file->read_sys(CSR_MTVEC), 0);

		commit_feedback_pack_t feedback_pack;
		phy_regfile_item_t default_phy_reg_item;
		bool need_flush = false;
		memset(&feedback_pack, 0, sizeof(feedback_pack));
		memset(&default_phy_reg_item, 0, sizeof(default_phy_reg_item));
		auto origin_commit_num = rob->get_commit_num();//only for tracedb generation

		if(this->cur_state == state_t::normal)
		{
			//handle output
			if(!rob->is_empty())
			{
				assert(rob->get_front_id(&this->rob_item_id));
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_head_id", this->rob_item_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_head_id_valid", 1, 0);
				feedback_pack.enable = true;
				feedback_pack.next_handle_rob_id = this->rob_item_id;
				feedback_pack.next_handle_rob_id_valid = true;
				auto first_id = this->rob_item_id;
				this->rob_item = rob->get_item(this->rob_item_id);

				if(interrupt_interface->get_cause(&interrupt_id))
				{
					interrupt_pc = this->rob_item.pc;
					assert(rob->get_tail_id(&this->restore_rob_item_id));
					this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush_id", this->restore_rob_item_id, 0);
					feedback_pack.enable = true;
					feedback_pack.flush = true;
					cur_state = state_t::interrupt_flush;
					need_flush = true;

					for(auto i = 0;i < COMMIT_WIDTH;i++)
					{
						this->rob_item = rob->get_item(this->rob_item_id);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_retire_id", this->rob_item_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.new_phy_reg_id", this->rob_item.new_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id", this->rob_item.old_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id_valid", this->rob_item.old_phy_reg_id_valid, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.finish", this->rob_item.finish, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.pc", this->rob_item.pc, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.inst_value", this->rob_item.inst_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.has_exception", this->rob_item.has_exception, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_id", (uint32_t)this->rob_item.exception_id, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_value", this->rob_item.exception_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted", this->rob_item.predicted, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_jump", this->rob_item.predicted_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_next_pc", this->rob_item.predicted_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id_valid", this->rob_item.checkpoint_id_valid, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id", this->rob_item.checkpoint_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_op", this->rob_item.bru_op, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_jump", this->rob_item.bru_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.bru_next_pc", this->rob_item.bru_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.is_mret", this->rob_item.is_mret, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.csr_addr", this->rob_item.csr_addr, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue", this->rob_item.csr_newvalue, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue_valid", this->rob_item.csr_newvalue_valid, i);
						this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "rob_commit_retire_id_valid", 1, i, 0);
					}
				}
				else
				{
					for(auto i = 0;i < COMMIT_WIDTH;i++)
					{
						this->rob_item = rob->get_item(this->rob_item_id);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_retire_id", this->rob_item_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.new_phy_reg_id", this->rob_item.new_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id", this->rob_item.old_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.old_phy_reg_id_valid", this->rob_item.old_phy_reg_id_valid, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.finish", this->rob_item.finish, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.pc", this->rob_item.pc, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.inst_value", this->rob_item.inst_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.has_exception", this->rob_item.has_exception, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_id", (uint32_t)this->rob_item.exception_id, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.exception_value", this->rob_item.exception_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted", this->rob_item.predicted, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_jump", this->rob_item.predicted_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.predicted_next_pc", this->rob_item.predicted_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id_valid", this->rob_item.checkpoint_id_valid, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.checkpoint_id", this->rob_item.checkpoint_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_op", this->rob_item.bru_op, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.bru_jump", this->rob_item.bru_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.bru_next_pc", this->rob_item.bru_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.is_mret", this->rob_item.is_mret, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_retire_data.csr_addr", this->rob_item.csr_addr, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue", this->rob_item.csr_newvalue, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_retire_data.csr_newvalue_valid", this->rob_item.csr_newvalue_valid, i);
						this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "rob_commit_retire_id_valid", 1, i, 0);

						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_retire_id", this->rob_item_id, i);
    					rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.new_phy_reg_id", this->rob_item.new_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id", this->rob_item.old_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id_valid", this->rob_item.old_phy_reg_id_valid, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.finish", this->rob_item.finish, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.pc", this->rob_item.pc, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.inst_value", this->rob_item.inst_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.has_exception", this->rob_item.has_exception, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.exception_id", (uint32_t)this->rob_item.exception_id, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.exception_value", this->rob_item.exception_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.predicted", this->rob_item.predicted, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.predicted_jump", this->rob_item.predicted_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.predicted_next_pc", this->rob_item.predicted_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id_valid", this->rob_item.checkpoint_id_valid, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id", this->rob_item.checkpoint_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.bru_op", this->rob_item.bru_op, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.bru_jump", this->rob_item.bru_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.bru_next_pc", this->rob_item.bru_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.is_mret", this->rob_item.is_mret, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_retire_data.csr_addr", this->rob_item.csr_addr, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue", this->rob_item.csr_newvalue, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue_valid", this->rob_item.csr_newvalue_valid, i);
    					rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_id_valid", 1, i);

						if(rob_item.finish)
						{
							feedback_pack.next_handle_rob_id_valid = rob->get_next_id(this->rob_item_id, &feedback_pack.next_handle_rob_id) && (feedback_pack.next_handle_rob_id != first_id);

							this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_next_id", feedback_pack.next_handle_rob_id, 0);
							this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_next_id_valid", feedback_pack.next_handle_rob_id_valid, 0);

							rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_next_id", feedback_pack.next_handle_rob_id, 0);
							rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_next_id_valid", feedback_pack.next_handle_rob_id_valid, 0);

							feedback_pack.committed_rob_id_valid[i] = true;
							feedback_pack.committed_rob_id[i] = this->rob_item_id;

							if(rob_item.has_exception)
							{
								assert(rob->get_tail_id(&this->restore_rob_item_id));
								feedback_pack.enable = true;
								feedback_pack.flush = true;
								cur_state = state_t::flush;
								need_flush = true;
								break;
							}
							else
							{
								this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_rob_retire_pop", 1, i, 0);
								rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_retire_pop", 1, i);
								rob->pop_sync();

								if(rob_item.old_phy_reg_id_valid)
								{
									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_release_phy_id", rob_item.old_phy_reg_id, i);
									this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_rat_release_phy_id_valid", 1, i, 0);
									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_release_map", 1, 0);

									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_release_phy_id", rob_item.old_phy_reg_id, i);
									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_release_phy_id_valid", 1, i);
									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_release_map", 1, 0);

									rat->release_map_sync(rob_item.old_phy_reg_id);

									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_id", rob_item.old_phy_reg_id, i);
									this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_phyf_invalid", 1, i, 0);

									phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_id", rob_item.old_phy_reg_id, i);
									phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_invalid", 1, i);

									phy_regfile->write_sync(rob_item.old_phy_reg_id, default_phy_reg_item, false);

									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_commit_phy_id", rob_item.new_phy_reg_id, i);			
									this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_rat_commit_phy_id_valid", 1, i, 0);
									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_commit_map", 1, 0);

									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_commit_phy_id", rob_item.new_phy_reg_id, i);
									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_commit_phy_id_valid", 1, i);
									rat->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rat_commit_map", 1, 0);

									rat->commit_map_sync(rob_item.new_phy_reg_id);
								}
							
								rob->set_committed(true);
								rob->add_commit_num(1);

								if(rob_item.csr_newvalue_valid)
								{
									csr_file->write_sync(rob_item.csr_addr, rob_item.csr_newvalue);
									this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", rob_item.csr_addr, i);
    								this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", rob_item.csr_newvalue, i);
									this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, i, 0);

									csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", rob_item.csr_addr, i);
									csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", rob_item.csr_newvalue, i);
									csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, i);
								}

								//branch handle
								if(rob_item.bru_op)
								{
									branch_num_add();
									this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_num_add", 1, 0);

									if(rob_item.is_mret)
									{
										component::csr::mstatus mstatus;
										mstatus.load(csr_file->read_sys(CSR_MSTATUS));
										mstatus.set_mie(mstatus.get_mpie());
										csr_file->write_sys_sync(CSR_MSTATUS, mstatus.get_value());
										this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MSTATUS, i);
    									this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", mstatus.get_value(), i);
										this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, i, 0);

										csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MSTATUS, i);
										csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", mstatus.get_value(), i);
										csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, i);
									}

									if(rob_item.predicted)
									{
										branch_predicted_add();
										this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_predicted_add", 1, 0);
										this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_pc", rob_item.pc, i);
    									this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_instruction", rob_item.inst_value, i);
										this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_bp_jump", rob_item.bru_jump, i, 0);
										this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_bp_next_pc", rob_item.bru_next_pc, i);
										this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_bp_valid", 1, i, 0);

										//whether prediction is success
										if((rob_item.bru_jump == rob_item.predicted_jump) && ((rob_item.bru_next_pc == rob_item.predicted_next_pc) || (!rob_item.predicted_jump)))
										{
											branch_hit_add();
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_hit_add", 1, 0);
											branch_predictor->update_prediction(rob_item.pc, rob_item.inst_value, rob_item.bru_jump, rob_item.bru_next_pc, true, i);
    										this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_bp_hit", 1, i, 0);		
											checkpoint_buffer->pop_sync();
											this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_cpbuf_pop", 1, i, 0);
											checkpoint_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_cpbuf_pop", 1, i);
											break;
											//nothing to do
										}
										else if(rob_item.checkpoint_id_valid)
										{
											branch_miss_add();
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_branch_miss_add", 1, 0);
											branch_predictor->update_prediction(rob_item.pc, rob_item.inst_value, rob_item.bru_jump, rob_item.bru_next_pc, false, i);
											auto cp = checkpoint_buffer->get_item(rob_item.checkpoint_id);
											this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_cpbuf_id", rob_item.checkpoint_id, i);
    										this->tdb.update_signal_bitmap(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_valid", &cp.rat_phy_map_table_valid, i);
											this->tdb.update_signal_bitmap(trace::domain_t::input, "cpbuf_commit_data.rat_phy_map_table_visible", &cp.rat_phy_map_table_visible, i);
											this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_commit_data.global_history", cp.global_history, i);
											this->tdb.update_signal<uint16_t>(trace::domain_t::input, "cpbuf_commit_data.local_history", cp.local_history, i);

											checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_cpbuf_id", rob_item.checkpoint_id, i);
											checkpoint_buffer->get_tdb()->update_signal_bitmap(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_valid", &cp.rat_phy_map_table_valid, i);
											checkpoint_buffer->get_tdb()->update_signal_bitmap(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_visible", &cp.rat_phy_map_table_visible, i);
											checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "cpbuf_commit_data.global_history", cp.global_history, i);
											checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "cpbuf_commit_data.local_history", cp.local_history, i);

											if(rob_item.old_phy_reg_id_valid)
											{
												rat->cp_release_map(cp, rob_item.old_phy_reg_id);
												//phy_regfile->cp_set_data_valid(cp, rob_item.old_phy_reg_id, false);
												//rat->cp_commit_map(cp, rob_item.new_phy_reg_id);
											}

											uint32_t _cnt = 0;

											for(uint32_t i = 0;i < PHY_REG_NUM;i++)
											{
												if(!rat->cp_get_visible(cp, i))
												{
													rat->cp_set_valid(cp, i, false);
													phy_regfile->cp_set_data_valid(cp, i, false);
												}
												else
												{
													//assert(phy_regfile->cp_get_data_valid(cp, i));
													phy_regfile->cp_set_data_valid(cp, i, true);
													_cnt++;
												}
											}

											assert(_cnt == 31);

											this->tdb.update_signal_bitmap(trace::domain_t::output, "commit_rat_map_table_valid", &cp.phy_regfile_data_valid, 0);
											this->tdb.update_signal_bitmap(trace::domain_t::output, "commit_rat_map_table_visible", &cp.rat_phy_map_table_visible, 0);
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_map_table_restore", 1, 0);
											rat->restore_sync(cp);
											this->tdb.update_signal_bitmap(trace::domain_t::output, "commit_phyf_data_valid", &cp.phy_regfile_data_valid, 0);
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_data_valid_restore", 1, 0);

											phy_regfile->get_tdb()->update_signal_bitmap(trace::domain_t::input, "commit_phyf_data_valid", &cp.phy_regfile_data_valid, 0);
											phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_data_valid_restore", 1, 0);
											phy_regfile->restore_sync(cp);
											feedback_pack.enable = true;
											feedback_pack.flush = true;
											feedback_pack.jump_enable = true;
											feedback_pack.jump = rob_item.bru_jump;
											feedback_pack.next_pc = rob_item.bru_jump ? rob_item.bru_next_pc : (rob_item.pc + 4);
											rob->flush();
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush", 1, 0);
											rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush", 1, 0);
											checkpoint_buffer->flush();
											this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_cpbuf_flush", 1, 0);
											checkpoint_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_cpbuf_flush", 1, 0);
											need_flush = true;
											break;
										}
										else
										{
											//it's not possible
											assert(false);
										}
									}
									else
									{
										feedback_pack.enable = true;
										feedback_pack.jump_enable = true;
										feedback_pack.jump = rob_item.bru_jump;
										feedback_pack.next_pc = rob_item.bru_jump ? rob_item.bru_next_pc : (rob_item.pc + 4);
										break;
									}
								}
							}
						}
						else
						{
							break;
						}

						if(!rob->get_next_id(this->rob_item_id, &this->rob_item_id) || (this->rob_item_id == first_id))
						{
							break;
						}
					}
				}
			}

			//handle input
			if(!need_flush)
			{
				auto rev_pack = wb_commit_port->get();

				for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
				{
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.enable", rev_pack.op_info[i].enable, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.value", rev_pack.op_info[i].value, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.valid", rev_pack.op_info[i].valid, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rob_id", rev_pack.op_info[i].rob_id, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.pc", rev_pack.op_info[i].pc, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.imm", rev_pack.op_info[i].imm, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.has_exception", rev_pack.op_info[i].has_exception, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.exception_id", (uint32_t)rev_pack.op_info[i].exception_id, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.exception_value", rev_pack.op_info[i].exception_value, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted", rev_pack.op_info[i].predicted, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted_jump", rev_pack.op_info[i].predicted_jump, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.predicted_next_pc", rev_pack.op_info[i].predicted_next_pc, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id_valid", rev_pack.op_info[i].checkpoint_id_valid, i);
					this->tdb.update_signal<uint16_t>(trace::domain_t::input, "wb_commit_port_data_out.checkpoint_id", rev_pack.op_info[i].checkpoint_id, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.bru_jump", rev_pack.op_info[i].bru_jump, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.bru_next_pc", rev_pack.op_info[i].bru_next_pc, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1", rev_pack.op_info[i].rs1, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.arg1_src", (uint8_t)rev_pack.op_info[i].arg1_src, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1_need_map", rev_pack.op_info[i].rs1_need_map, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs1_phy", rev_pack.op_info[i].rs1_phy, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.src1_value", rev_pack.op_info[i].src1_value, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.src1_loaded", rev_pack.op_info[i].src1_loaded, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2", rev_pack.op_info[i].rs2, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.arg2_src", (uint8_t)rev_pack.op_info[i].arg2_src, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2_need_map", rev_pack.op_info[i].rs2_need_map, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rs2_phy", rev_pack.op_info[i].rs2_phy, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.src2_value", rev_pack.op_info[i].src2_value, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.src2_loaded", rev_pack.op_info[i].src2_loaded, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd", rev_pack.op_info[i].rd, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_enable", rev_pack.op_info[i].rd_enable, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.need_rename", rev_pack.op_info[i].need_rename, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_phy", rev_pack.op_info[i].rd_phy, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.rd_value", rev_pack.op_info[i].rd_value, i);
					this->tdb.update_signal<uint16_t>(trace::domain_t::input, "wb_commit_port_data_out.csr", rev_pack.op_info[i].csr, i);
					this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue", rev_pack.op_info[i].csr_newvalue, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.csr_newvalue_valid", rev_pack.op_info[i].csr_newvalue_valid, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.op", (uint8_t)rev_pack.op_info[i].op, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.op_unit", (uint8_t)rev_pack.op_info[i].op_unit, i);
					this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_commit_port_data_out.sub_op", *(uint8_t *)&rev_pack.op_info[i].sub_op, i);

					if(rev_pack.op_info[i].enable)
					{
						auto rob_item = rob->get_item(rev_pack.op_info[i].rob_id);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_id", rev_pack.op_info[i].rob_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.new_phy_reg_id", rob_item.new_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id", rob_item.old_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.old_phy_reg_id_valid", rob_item.old_phy_reg_id_valid, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.finish", rob_item.finish, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.pc", rob_item.pc, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.inst_value", rob_item.inst_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.has_exception", rob_item.has_exception, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.exception_id", (uint32_t)rob_item.exception_id, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.exception_value", rob_item.exception_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.predicted", rob_item.predicted, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.predicted_jump", rob_item.predicted_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.predicted_next_pc", rob_item.predicted_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.checkpoint_id_valid", rob_item.checkpoint_id_valid, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_input_data.checkpoint_id", rob_item.checkpoint_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.bru_op", rob_item.bru_op, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.bru_jump", rob_item.bru_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.bru_next_pc", rob_item.bru_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.is_mret", rob_item.is_mret, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_input_data.csr_addr", rob_item.csr_addr, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_input_data.csr_newvalue", rob_item.csr_newvalue, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_input_data.csr_newvalue_valid", rob_item.csr_newvalue_valid, i);

						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_id", rev_pack.op_info[i].rob_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.new_phy_reg_id", rob_item.new_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id", rob_item.old_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id_valid", rob_item.old_phy_reg_id_valid, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.finish", rob_item.finish, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.pc", rob_item.pc, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.inst_value", rob_item.inst_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.has_exception", rob_item.has_exception, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.exception_id", (uint32_t)rob_item.exception_id, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.exception_value", rob_item.exception_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.predicted", rob_item.predicted, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.predicted_jump", rob_item.predicted_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.predicted_next_pc", rob_item.predicted_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.checkpoint_id_valid", rob_item.checkpoint_id_valid, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_input_data.checkpoint_id", rob_item.checkpoint_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.bru_op", rob_item.bru_op, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.bru_jump", rob_item.bru_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.bru_next_pc", rob_item.bru_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.is_mret", rob_item.is_mret, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_input_data.csr_addr", rob_item.csr_addr, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.csr_newvalue", rob_item.csr_newvalue, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.csr_newvalue_valid", rob_item.csr_newvalue_valid, i);

						rob_item.finish = true;
						rob_item.has_exception = rev_pack.op_info[i].has_exception;
						rob_item.exception_id = rev_pack.op_info[i].exception_id;
						rob_item.exception_value = rev_pack.op_info[i].exception_value;
						rob_item.predicted = rev_pack.op_info[i].predicted;
						rob_item.predicted_jump = rev_pack.op_info[i].predicted_jump;
						rob_item.predicted_next_pc = rev_pack.op_info[i].predicted_next_pc;
						rob_item.checkpoint_id_valid = rev_pack.op_info[i].checkpoint_id_valid;
						rob_item.checkpoint_id = rev_pack.op_info[i].checkpoint_id;
						rob_item.bru_op = rev_pack.op_info[i].op_unit == op_unit_t::bru;
						rob_item.bru_jump = rev_pack.op_info[i].bru_jump;
						rob_item.bru_next_pc = rev_pack.op_info[i].bru_next_pc;
						rob_item.csr_newvalue = rev_pack.op_info[i].csr_newvalue;
						rob_item.csr_newvalue_valid = rev_pack.op_info[i].csr_newvalue_valid;
						rob->set_item_sync(rev_pack.op_info[i].rob_id, rob_item);
						
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.new_phy_reg_id", rob_item.new_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id", rob_item.old_phy_reg_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.old_phy_reg_id_valid", rob_item.old_phy_reg_id_valid, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.finish", rob_item.finish, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.pc", rob_item.pc, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.inst_value", rob_item.inst_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.has_exception", rob_item.has_exception, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.exception_id", (uint32_t)rob_item.exception_id, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.exception_value", rob_item.exception_value, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.predicted", rob_item.predicted, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.predicted_jump", rob_item.predicted_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.predicted_next_pc", rob_item.predicted_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.checkpoint_id_valid", rob_item.checkpoint_id_valid, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_rob_input_data.checkpoint_id", rob_item.checkpoint_id, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.bru_op", rob_item.bru_op, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.bru_jump", rob_item.bru_jump, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.bru_next_pc", rob_item.bru_next_pc, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.is_mret", rob_item.is_mret, i);
						this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_rob_input_data.csr_addr", rob_item.csr_addr, i);
						this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_rob_input_data.csr_newvalue", rob_item.csr_newvalue, i);
						this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_input_data.csr_newvalue_valid", rob_item.csr_newvalue_valid, i);
						this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_rob_input_data_we", 1, i, 0);

						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.new_phy_reg_id", rob_item.new_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id", rob_item.old_phy_reg_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id_valid", rob_item.old_phy_reg_id_valid, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.finish", rob_item.finish, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.pc", rob_item.pc, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.inst_value", rob_item.inst_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.has_exception", rob_item.has_exception, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.exception_id", (uint32_t)rob_item.exception_id, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.exception_value", rob_item.exception_value, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.predicted", rob_item.predicted, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.predicted_jump", rob_item.predicted_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.predicted_next_pc", rob_item.predicted_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.checkpoint_id_valid", rob_item.checkpoint_id_valid, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_rob_input_data.checkpoint_id", rob_item.checkpoint_id, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.bru_op", rob_item.bru_op, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.bru_jump", rob_item.bru_jump, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.bru_next_pc", rob_item.bru_next_pc, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.is_mret", rob_item.is_mret, i);
						rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_rob_input_data.csr_addr", rob_item.csr_addr, i);
						rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.csr_newvalue", rob_item.csr_newvalue, i);
						rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.csr_newvalue_valid", rob_item.csr_newvalue_valid, i);
    					rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data_we", 1, i);
					}
				}
			}
		}
		else if(this->cur_state == state_t::flush)//flush
		{
			//flush rob and restore rat
			auto t_rob_item = rob->get_item(this->restore_rob_item_id);
			this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush_id", this->restore_rob_item_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.new_phy_reg_id", t_rob_item.new_phy_reg_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id", t_rob_item.old_phy_reg_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id_valid", t_rob_item.old_phy_reg_id_valid, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.finish", t_rob_item.finish, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.pc", t_rob_item.pc, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.inst_value", t_rob_item.inst_value, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.has_exception", t_rob_item.has_exception, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_id", (uint32_t)t_rob_item.exception_id, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_value", t_rob_item.exception_value, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted", t_rob_item.predicted, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_jump", t_rob_item.predicted_jump, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_next_pc", t_rob_item.predicted_next_pc, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id_valid", t_rob_item.checkpoint_id_valid, 0);
			this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id", t_rob_item.checkpoint_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_op", t_rob_item.bru_op, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_jump", t_rob_item.bru_jump, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.bru_next_pc", t_rob_item.bru_next_pc, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.is_mret", t_rob_item.is_mret, 0);
			this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.csr_addr", t_rob_item.csr_addr, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue", t_rob_item.csr_newvalue, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue_valid", t_rob_item.csr_newvalue_valid, 0);

			rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush_id", this->restore_rob_item_id, 0);
		    rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.new_phy_reg_id", t_rob_item.new_phy_reg_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id", t_rob_item.old_phy_reg_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id_valid", t_rob_item.old_phy_reg_id_valid, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.finish", t_rob_item.finish, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.pc", t_rob_item.pc, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.inst_value", t_rob_item.inst_value, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.has_exception", t_rob_item.has_exception, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_id", (uint32_t)t_rob_item.exception_id, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_value", t_rob_item.exception_value, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted", t_rob_item.predicted, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_jump", t_rob_item.predicted_jump, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_next_pc", t_rob_item.predicted_next_pc, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id_valid", t_rob_item.checkpoint_id_valid, 0);
            rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id", t_rob_item.checkpoint_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_op", t_rob_item.bru_op, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_jump", t_rob_item.bru_jump, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.bru_next_pc", t_rob_item.bru_next_pc, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.is_mret", t_rob_item.is_mret, 0);
            rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.csr_addr", t_rob_item.csr_addr, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue", t_rob_item.csr_newvalue, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue_valid", t_rob_item.csr_newvalue_valid, 0);
			
			if(t_rob_item.old_phy_reg_id_valid)
			{
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_new_phy_id", t_rob_item.new_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_old_phy_id", t_rob_item.old_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_map", 1, 0);
				rat->restore_map_sync(t_rob_item.new_phy_reg_id, t_rob_item.old_phy_reg_id);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_id", t_rob_item.new_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_invalid", 1, 0);

				phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_id", t_rob_item.new_phy_reg_id, 0);
                phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_invalid", 1, 0);

				phy_regfile->write_sync(t_rob_item.new_phy_reg_id, default_phy_reg_item, false);
			}

			{
				uint32_t id;
				auto t = rob->get_prev_id(this->restore_rob_item_id, &id);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id", id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id_valid", t, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id", id, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id_valid", t, 0);
			}

			if((this->restore_rob_item_id != this->rob_item_id) && rob->get_prev_id(this->restore_rob_item_id, &this->restore_rob_item_id))
			{
				feedback_pack.enable = true;
				feedback_pack.flush = true;
			}
			else
			{
				rob->flush();
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush", 1, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush", 1, 0);
				feedback_pack.enable = true;
				feedback_pack.has_exception = true;
				csr_file->write_sys_sync(CSR_MEPC, rob_item.pc);
				csr_file->write_sys_sync(CSR_MTVAL, rob_item.exception_value);
				csr_file->write_sys_sync(CSR_MCAUSE, static_cast<uint32_t>(rob_item.exception_id));
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MEPC, 0);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", rob_item.pc, 0);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 0, 0);
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MTVAL, 1);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", rob_item.exception_value, 1);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 1, 0);
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MCAUSE, 2);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", (uint32_t)rob_item.exception_id, 2);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 2, 0);

				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MEPC, 0);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", rob_item.pc, 0);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 0);
				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MTVAL, 1);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", rob_item.exception_value, 1);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 1);
				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MCAUSE, 2);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", (uint32_t)rob_item.exception_id, 2);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 2);
				feedback_pack.exception_pc = csr_file->read_sys(CSR_MTVEC);
				feedback_pack.flush = true;
				cur_state = state_t::normal;
				rob->set_committed(true);
				rob->add_commit_num(1);
			}
		}
		else if(this->cur_state == state_t::interrupt_flush)//interrupt_flush
		{
			//flush rob and restore rat
			auto t_rob_item = rob->get_item(this->restore_rob_item_id);
			this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush_id", this->restore_rob_item_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.new_phy_reg_id", t_rob_item.new_phy_reg_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id", t_rob_item.old_phy_reg_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.old_phy_reg_id_valid", t_rob_item.old_phy_reg_id_valid, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.finish", t_rob_item.finish, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.pc", t_rob_item.pc, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.inst_value", t_rob_item.inst_value, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.has_exception", t_rob_item.has_exception, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_id", (uint32_t)t_rob_item.exception_id, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.exception_value", t_rob_item.exception_value, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted", t_rob_item.predicted, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_jump", t_rob_item.predicted_jump, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.predicted_next_pc", t_rob_item.predicted_next_pc, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id_valid", t_rob_item.checkpoint_id_valid, 0);
			this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.checkpoint_id", t_rob_item.checkpoint_id, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_op", t_rob_item.bru_op, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.bru_jump", t_rob_item.bru_jump, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.bru_next_pc", t_rob_item.bru_next_pc, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.is_mret", t_rob_item.is_mret, 0);
			this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rob_commit_flush_data.csr_addr", t_rob_item.csr_addr, 0);
			this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue", t_rob_item.csr_newvalue, 0);
			this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_data.csr_newvalue_valid", t_rob_item.csr_newvalue_valid, 0);

			rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush_id", this->restore_rob_item_id, 0);
		    rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.new_phy_reg_id", t_rob_item.new_phy_reg_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id", t_rob_item.old_phy_reg_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id_valid", t_rob_item.old_phy_reg_id_valid, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.finish", t_rob_item.finish, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.pc", t_rob_item.pc, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.inst_value", t_rob_item.inst_value, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.has_exception", t_rob_item.has_exception, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_id", (uint32_t)t_rob_item.exception_id, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_value", t_rob_item.exception_value, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted", t_rob_item.predicted, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_jump", t_rob_item.predicted_jump, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_next_pc", t_rob_item.predicted_next_pc, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id_valid", t_rob_item.checkpoint_id_valid, 0);
            rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id", t_rob_item.checkpoint_id, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_op", t_rob_item.bru_op, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_jump", t_rob_item.bru_jump, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.bru_next_pc", t_rob_item.bru_next_pc, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.is_mret", t_rob_item.is_mret, 0);
            rob->get_tdb()->update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.csr_addr", t_rob_item.csr_addr, 0);
            rob->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue", t_rob_item.csr_newvalue, 0);
            rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue_valid", t_rob_item.csr_newvalue_valid, 0);
			
			if(t_rob_item.old_phy_reg_id_valid)
			{
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_new_phy_id", t_rob_item.new_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_old_phy_id", t_rob_item.old_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rat_restore_map", 1, 0);
				rat->restore_map_sync(t_rob_item.new_phy_reg_id, t_rob_item.old_phy_reg_id);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_id", t_rob_item.new_phy_reg_id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_phyf_flush_invalid", 1, 0);
				phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_id", t_rob_item.new_phy_reg_id, 0);
                phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_invalid", 1, 0);
				phy_regfile->write_sync(t_rob_item.new_phy_reg_id, default_phy_reg_item, false);
			}

			{
				uint32_t id;
				auto t = rob->get_prev_id(this->restore_rob_item_id, &id);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id", id, 0);
				this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rob_commit_flush_next_id_valid", t, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id", id, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id_valid", t, 0);
			}

			if((this->restore_rob_item_id != this->rob_item_id) && rob->get_prev_id(this->restore_rob_item_id, &this->restore_rob_item_id))
			{
				feedback_pack.enable = true;
				feedback_pack.flush = true;
			}
			else
			{
				rob->flush();
				this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rob_flush", 1, 0);
				rob->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush", 1, 0);
				feedback_pack.enable = true;
				feedback_pack.has_exception = true;
				csr_file->write_sys_sync(CSR_MEPC, interrupt_pc);
				csr_file->write_sys_sync(CSR_MTVAL, 0);
				csr_file->write_sys_sync(CSR_MCAUSE, 0x80000000 | static_cast<uint32_t>(interrupt_id));
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MEPC, 0);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", rob_item.pc, 0);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 0, 0);
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MTVAL, 1);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", 0, 1);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 1, 0);
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MCAUSE, 2);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", 0x80000000 | static_cast<uint32_t>(interrupt_id), 2);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 2, 0);

				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MEPC, 0);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", rob_item.pc, 0);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 0);
				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MTVAL, 1);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", 0, 1);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 1);
				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MCAUSE, 2);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", 0x80000000 | static_cast<uint32_t>(interrupt_id), 2);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 2);
				component::csr::mstatus mstatus;
				mstatus.load(csr_file->read_sys(CSR_MSTATUS));
				mstatus.set_mpie(mstatus.get_mie());
				mstatus.set_mie(false);
				csr_file->write_sys_sync(CSR_MSTATUS, mstatus.get_value());
				csr_file->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "commit_csrf_write_addr", CSR_MSTATUS, 3);
				csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "commit_csrf_write_data", mstatus.get_value(), 3);
				csr_file->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_we", 1, 3);
				this->tdb.update_signal<uint16_t>(trace::domain_t::output, "commit_csrf_write_addr", CSR_MSTATUS, 3);
    			this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_csrf_write_data", mstatus.get_value(), 3);
				this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_csrf_we", 1, 3, 0);
				this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_intif_ack_data", 1U << ((uint32_t)interrupt_id), 0);
				interrupt_interface->set_ack_sync(interrupt_id);
				feedback_pack.exception_pc = csr_file->read_sys(CSR_MTVEC);
				feedback_pack.flush = true;
				cur_state = state_t::normal;
				rob->set_committed(true);
				rob->add_commit_num(1);
			}
		}
		
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_csrf_commit_num_add", rob->get_commit_num() - origin_commit_num, 0);

		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.enable", feedback_pack.enable, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id_valid", (uint8_t)feedback_pack.next_handle_rob_id_valid, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.next_handle_rob_id", feedback_pack.next_handle_rob_id, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.has_exception", feedback_pack.has_exception, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_feedback_pack.exception_pc", feedback_pack.exception_pc, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.flush", feedback_pack.flush, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
    		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.committed_rob_id", feedback_pack.committed_rob_id[i], i);
			this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "commit_feedback_pack.committed_rob_id_valid", feedback_pack.committed_rob_id_valid[i], i, 0);
        }
		
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.jump_enable", feedback_pack.jump_enable, 0);
		this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_feedback_pack.jump", feedback_pack.jump, 0);
		this->tdb.update_signal<uint32_t>(trace::domain_t::output, "commit_feedback_pack.next_pc", feedback_pack.next_pc, 0);

		this->tdb.capture_output_status();
        this->tdb.write_row();
		return feedback_pack;
	}
}