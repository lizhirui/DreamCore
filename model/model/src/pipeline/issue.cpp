#include "common.h"
#include "issue.h"

namespace pipeline
{
    issue::issue(component::port<readreg_issue_pack_t> *readreg_issue_port, component::fifo<issue_execute_pack_t> **issue_alu_fifo, component::fifo<issue_execute_pack_t> **issue_bru_fifo, component::fifo<issue_execute_pack_t> **issue_csr_fifo, component::fifo<issue_execute_pack_t> **issue_div_fifo, component::fifo<issue_execute_pack_t> **issue_lsu_fifo, component::fifo<issue_execute_pack_t> **issue_mul_fifo, component::regfile<phy_regfile_item_t> *phy_regfile, component::store_buffer *store_buffer, component::bus *bus) : issue_q(component::issue_queue<issue_queue_item_t>(ISSUE_QUEUE_SIZE)), tdb(TRACE_ISSUE)
    {
        this->readreg_issue_port = readreg_issue_port;
        this->issue_alu_fifo = issue_alu_fifo;
        this->issue_bru_fifo = issue_bru_fifo;
        this->issue_csr_fifo = issue_csr_fifo;
        this->issue_div_fifo = issue_div_fifo;
        this->issue_lsu_fifo = issue_lsu_fifo;
        this->issue_mul_fifo = issue_mul_fifo;
        this->phy_regfile = phy_regfile;
        this->store_buffer = store_buffer;
        this->bus = bus;
        this->is_inst_waiting = false;
        this->inst_waiting_rob_id = 0;
    }

    void issue::reset()
    {
        this->issue_q.reset();
        this->busy = false;
        this->is_inst_waiting = false;
        this->inst_waiting_rob_id = 0;
        this->last_index = 0;
        this->alu_index = 0;
        this->bru_index = 0;
        this->csr_index = 0;
        this->div_index = 0;
        this->lsu_index = 0;
        this->mul_index = 0;

        this->tdb.create(TRACE_DIR + "issue.tdb");

        this->tdb.mark_signal(trace::domain_t::input, "stbuf_all_empty", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "issue_phyf_id", sizeof(uint8_t), READREG_WIDTH * 2);
        this->tdb.mark_signal(trace::domain_t::input, "phyf_issue_data", sizeof(uint32_t), READREG_WIDTH * 2);
        this->tdb.mark_signal(trace::domain_t::input, "phyf_issue_data_valid", sizeof(uint8_t), READREG_WIDTH * 2);

        this->tdb.mark_signal(trace::domain_t::output, "issue_stbuf_read_addr", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_stbuf_read_size", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_stbuf_rd", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "issue_csrf_issue_execute_fifo_full_add", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csrf_issue_queue_full_add", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rob_id", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.imm", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.has_exception", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.exception_id", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.exception_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.predicted", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.predicted_jump", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.predicted_next_pc", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id_valid", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs1", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.arg1_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs1_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs1_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.src1_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.src1_loaded", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs2", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.arg2_src", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs2_need_map", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rs2_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.src2_value", sizeof(uint32_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.src2_loaded", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rd", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rd_enable", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.need_rename", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.rd_phy", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.csr", sizeof(uint16_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.op", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.op_unit", sizeof(uint8_t), READREG_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "readreg_issue_port_data_out.sub_op", sizeof(uint8_t), READREG_WIDTH);

        this->tdb.mark_signal(trace::domain_t::input, "issue_alu_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.enable", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.value", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.valid", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rob_id", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.pc", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.imm", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.has_exception", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.exception_id", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.exception_value", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.predicted", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.predicted_jump", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.predicted_next_pc", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.checkpoint_id", sizeof(uint16_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs1", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.arg1_src", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs1_need_map", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs1_phy", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.src1_value", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.src1_loaded", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs2", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.arg2_src", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs2_need_map", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rs2_phy", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.src2_value", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.src2_loaded", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rd", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rd_enable", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.need_rename", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.rd_phy", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.csr", sizeof(uint16_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.lsu_addr", sizeof(uint32_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.op", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.op_unit", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_data_in.sub_op", sizeof(uint8_t), ALU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_alu_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_bru_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.enable", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.value", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.valid", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rob_id", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.pc", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.imm", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.has_exception", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.exception_id", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.exception_value", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.predicted", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.predicted_jump", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.predicted_next_pc", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.checkpoint_id", sizeof(uint16_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs1", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.arg1_src", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs1_need_map", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs1_phy", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.src1_value", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.src1_loaded", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs2", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.arg2_src", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs2_need_map", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rs2_phy", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.src2_value", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.src2_loaded", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rd", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rd_enable", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.need_rename", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.rd_phy", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.csr", sizeof(uint16_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.lsu_addr", sizeof(uint32_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.op", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.op_unit", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_data_in.sub_op", sizeof(uint8_t), BRU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_bru_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_csr_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.enable", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.value", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.valid", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rob_id", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.pc", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.imm", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.has_exception", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.exception_id", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.exception_value", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.predicted", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.predicted_jump", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.predicted_next_pc", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.checkpoint_id", sizeof(uint16_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs1", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.arg1_src", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs1_need_map", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs1_phy", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.src1_value", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.src1_loaded", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs2", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.arg2_src", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs2_need_map", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rs2_phy", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.src2_value", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.src2_loaded", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rd", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rd_enable", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.need_rename", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.rd_phy", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.csr", sizeof(uint16_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.lsu_addr", sizeof(uint32_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.op", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.op_unit", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_data_in.sub_op", sizeof(uint8_t), CSR_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_csr_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_div_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.enable", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.value", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.valid", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rob_id", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.pc", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.imm", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.has_exception", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.exception_id", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.exception_value", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.predicted", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.predicted_jump", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.predicted_next_pc", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.checkpoint_id", sizeof(uint16_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs1", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.arg1_src", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs1_need_map", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs1_phy", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.src1_value", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.src1_loaded", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs2", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.arg2_src", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs2_need_map", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rs2_phy", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.src2_value", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.src2_loaded", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rd", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rd_enable", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.need_rename", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.rd_phy", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.csr", sizeof(uint16_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.lsu_addr", sizeof(uint32_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.op", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.op_unit", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_data_in.sub_op", sizeof(uint8_t), DIV_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_div_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_lsu_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.enable", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.value", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.valid", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rob_id", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.pc", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.imm", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.has_exception", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.exception_id", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.exception_value", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted_jump", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted_next_pc", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.checkpoint_id", sizeof(uint16_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.arg1_src", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1_need_map", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1_phy", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.src1_value", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.src1_loaded", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.arg2_src", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2_need_map", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2_phy", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.src2_value", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.src2_loaded", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rd", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rd_enable", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.need_rename", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.rd_phy", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.csr", sizeof(uint16_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.lsu_addr", sizeof(uint32_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.op", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.op_unit", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_data_in.sub_op", sizeof(uint8_t), LSU_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_lsu_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "issue_mul_fifo_full", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.enable", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.value", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.valid", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rob_id", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.pc", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.imm", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.has_exception", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.exception_id", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.exception_value", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.predicted", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.predicted_jump", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.predicted_next_pc", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.checkpoint_id", sizeof(uint16_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs1", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.arg1_src", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs1_need_map", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs1_phy", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.src1_value", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.src1_loaded", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs2", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.arg2_src", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs2_need_map", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rs2_phy", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.src2_value", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.src2_loaded", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rd", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rd_enable", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.need_rename", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.rd_phy", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.csr", sizeof(uint16_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.lsu_addr", sizeof(uint32_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.op", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.op_unit", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_data_in.sub_op", sizeof(uint8_t), MUL_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "issue_mul_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "issue_feedback_pack.stall", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.phy_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "execute_feedback_pack.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);

        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.enable", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.phy_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
        this->tdb.mark_signal(trace::domain_t::input, "wb_feedback_pack.value", sizeof(uint32_t), EXECUTE_UNIT_NUM);

        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.has_exception", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.exception_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", sizeof(uint8_t), COMMIT_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.jump_enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.next_pc", sizeof(uint32_t), 1);

        this->tdb.bind_signal(trace::domain_t::status, "busy", &this->busy, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "is_inst_waiting", &this->is_inst_waiting, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "inst_waiting_rob_id", &this->inst_waiting_rob_id, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "last_index", &this->last_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "alu_index", &this->alu_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "bru_index", &this->bru_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "csr_index", &this->csr_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "div_index", &this->div_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "lsu_index", &this->lsu_index, sizeof(uint8_t), 1);
        this->tdb.bind_signal(trace::domain_t::status, "mul_index", &this->mul_index, sizeof(uint8_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    issue_feedback_pack_t issue::run(execute_feedback_pack_t execute_feedback_pack, wb_feedback_pack_t wb_feedback_pack, commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_all_empty", 0, 0);
        
        for(auto i = 0;i < READREG_WIDTH * 2;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_phyf_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_issue_data", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_issue_data_valid", 0, i);
        }

        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_stbuf_read_addr", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_read_size", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_rd", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csrf_issue_execute_fifo_full_add", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csrf_issue_queue_full_add", 0, 0);
        
        for(auto i = 0;i < READREG_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "readreg_issue_port_data_out.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_alu_fifo_full", 0, 0);
        
        for(auto i = 0;i < ALU_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_alu_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_alu_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_alu_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_alu_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_bru_fifo_full", 0, 0);
        
        for(auto i = 0;i < BRU_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_bru_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_bru_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_bru_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_bru_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_csr_fifo_full", 0, 0);
        
        for(auto i = 0;i < CSR_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_csr_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_csr_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_csr_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csr_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_div_fifo_full", 0, 0);
        
        for(auto i = 0;i < DIV_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_div_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_div_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_div_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_div_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_lsu_fifo_full", 0, 0);
        
        for(auto i = 0;i < LSU_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_mul_fifo_full", 0, 0);
        
        for(auto i = 0;i < MUL_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rob_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_mul_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs1_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.src1_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.src1_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rs2_phy", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.src2_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.src2_loaded", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.rd_phy", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_mul_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_mul_fifo_data_in.lsu_addr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_mul_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_feedback_pack.stall", 0, 0);
        
        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.phy_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_feedback_pack.value", 0, i);
    
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.phy_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_feedback_pack.value", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.has_exception", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.exception_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump_enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.next_pc", 0, 0);

        auto rev_pack = readreg_issue_port->get();
        issue_feedback_pack_t feedback_pack;

        memset(&feedback_pack, 0, sizeof(feedback_pack));

        std::vector<uint32_t> item_id_list;

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_all_empty", store_buffer->is_empty(), 0);

        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.enable", execute_feedback_pack.channel[i].enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "execute_feedback_pack.phy_id", execute_feedback_pack.channel[i].phy_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "execute_feedback_pack.value", execute_feedback_pack.channel[i].value, i);
    
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.enable", wb_feedback_pack.channel[i].enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_feedback_pack.phy_id", wb_feedback_pack.channel[i].phy_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_feedback_pack.value", wb_feedback_pack.channel[i].value, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id_valid", commit_feedback_pack.next_handle_rob_id_valid, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.next_handle_rob_id", commit_feedback_pack.next_handle_rob_id, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.has_exception", commit_feedback_pack.has_exception, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.exception_pc", commit_feedback_pack.exception_pc, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);
        
        for(auto i = 0;i < COMMIT_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", commit_feedback_pack.committed_rob_id[i], i);
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", commit_feedback_pack.committed_rob_id_valid[i], i, 0);
        }
        
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump_enable", commit_feedback_pack.jump_enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump", commit_feedback_pack.jump, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.next_pc", commit_feedback_pack.next_pc, 0);

        for(auto i = 0;i < ALU_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_alu_fifo_full", issue_alu_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < BRU_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_bru_fifo_full", issue_bru_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < CSR_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_csr_fifo_full", issue_csr_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < DIV_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_div_fifo_full", issue_div_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < LSU_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_lsu_fifo_full", issue_lsu_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < MUL_UNIT_NUM;i++)
        {
            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "issue_mul_fifo_full", issue_mul_fifo[i]->is_full(), i, 0);
        }

        for(auto i = 0;i < READREG_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.enable", rev_pack.op_info[i].enable, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.value", rev_pack.op_info[i].value, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.valid", rev_pack.op_info[i].valid, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rob_id", rev_pack.op_info[i].rob_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.pc", rev_pack.op_info[i].pc, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.imm", rev_pack.op_info[i].imm, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.has_exception", rev_pack.op_info[i].has_exception, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.exception_id", (uint32_t)rev_pack.op_info[i].exception_id, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.exception_value", rev_pack.op_info[i].exception_value, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted", rev_pack.op_info[i].predicted, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted_jump", rev_pack.op_info[i].predicted_jump, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.predicted_next_pc", rev_pack.op_info[i].predicted_next_pc, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id_valid", rev_pack.op_info[i].checkpoint_id_valid, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "readreg_issue_port_data_out.checkpoint_id", rev_pack.op_info[i].checkpoint_id, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1", rev_pack.op_info[i].rs1, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.arg1_src", (uint8_t)rev_pack.op_info[i].arg1_src, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1_need_map", rev_pack.op_info[i].rs1_need_map, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs1_phy", rev_pack.op_info[i].rs1_phy, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.src1_value", rev_pack.op_info[i].src1_value, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.src1_loaded", rev_pack.op_info[i].src1_loaded, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2", rev_pack.op_info[i].rs2, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.arg2_src", (uint8_t)rev_pack.op_info[i].arg2_src, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2_need_map", rev_pack.op_info[i].rs2_need_map, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rs2_phy", rev_pack.op_info[i].rs2_phy, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "readreg_issue_port_data_out.src2_value", rev_pack.op_info[i].src2_value, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.src2_loaded", rev_pack.op_info[i].src2_loaded, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd", rev_pack.op_info[i].rd, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd_enable", rev_pack.op_info[i].rd_enable, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.need_rename", rev_pack.op_info[i].need_rename, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.rd_phy", rev_pack.op_info[i].rd_phy, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "readreg_issue_port_data_out.csr", rev_pack.op_info[i].csr, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.op", (uint8_t)rev_pack.op_info[i].op, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.op_unit", (uint8_t)rev_pack.op_info[i].op_unit, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_issue_port_data_out.sub_op", *(uint8_t *)&rev_pack.op_info[i].sub_op, i);
        }
        
        if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
        {
            bool inst_waiting_ok = false;

            for(auto i = 0;i < COMMIT_WIDTH;i++)
            {
                if(commit_feedback_pack.enable && commit_feedback_pack.committed_rob_id_valid[i] && (commit_feedback_pack.committed_rob_id[i] == inst_waiting_rob_id))
                {
                    inst_waiting_ok = true;
                    break;
                }
            }

            if(issue_q.is_empty() && ((!is_inst_waiting) || inst_waiting_ok))
            {
                is_inst_waiting = false;
            }

            //handle output
            if(!issue_q.is_empty() && ((!is_inst_waiting) || inst_waiting_ok))
            {
                issue_queue_item_t items[ISSUE_WIDTH];
                memset(&items, 0, sizeof(items));
                uint32_t id = 0;

                //instruction waiting finish
                is_inst_waiting = false;

                //calculate not full queue
                bool alu_unit_available[ALU_UNIT_NUM];
                bool bru_unit_available[BRU_UNIT_NUM];
                bool csr_unit_available[CSR_UNIT_NUM];
                bool div_unit_available[DIV_UNIT_NUM];
                bool lsu_unit_available[LSU_UNIT_NUM];
                bool mul_unit_available[MUL_UNIT_NUM];

                for(auto i = 0;i < ALU_UNIT_NUM;i++)
                {
                    alu_unit_available[i] = !issue_alu_fifo[i]->is_full();
                }

                for(auto i = 0;i < BRU_UNIT_NUM;i++)
                {
                    bru_unit_available[i] = !issue_bru_fifo[i]->is_full();
                }

                for(auto i = 0;i < CSR_UNIT_NUM;i++)
                {
                    csr_unit_available[i] = !issue_csr_fifo[i]->is_full();
                }

                for(auto i = 0;i < DIV_UNIT_NUM;i++)
                {
                    div_unit_available[i] = !issue_div_fifo[i]->is_full();
                }

                for(auto i = 0;i < LSU_UNIT_NUM;i++)
                {
                    lsu_unit_available[i] = !issue_lsu_fifo[i]->is_full();
                }

                for(auto i = 0;i < MUL_UNIT_NUM;i++)
                {
                    mul_unit_available[i] = !issue_mul_fifo[i]->is_full();
                }
            
                //get up to 2 items from issue_queue
                assert(this->issue_q.get_front_id(&id));
                auto first_id = id;
                auto has_lsu_op = false;
                auto has_csr_op = false;
                auto has_mret_op = false;

                uint32_t i = 0;
                
                do
                {
                    items[i] = this->issue_q.get_item(id);

                    if(((items[i].op_unit == op_unit_t::csr) || (items[i].op == op_t::mret)) && (i != 0))
                    {
                        break;
                    }

                    assert(commit_feedback_pack.enable);

                    if(items[i].op_unit == op_unit_t::csr)
                    {
                       if(commit_feedback_pack.next_handle_rob_id != items[i].rob_id)
                       {
                            break;
                       }
                    }
                    else if(items[i].op == op_t::mret)
                    {
                        if(commit_feedback_pack.next_handle_rob_id != items[i].rob_id)
                        {
                            break;
                        }
                    }

                    bool src1_ready = items[i].src1_loaded;
                    bool src2_ready = items[i].src2_loaded;

                    if(!src1_ready || !src2_ready)
                    {
                        for(auto j = 0;j < EXECUTE_UNIT_NUM;j++)
                        {
                            if(execute_feedback_pack.channel[j].enable)
                            {
                                if(!src1_ready && items[i].rs1_phy == execute_feedback_pack.channel[j].phy_id)
                                {
                                    src1_ready = true;
                                }

                                if(!src2_ready && items[i].rs2_phy == execute_feedback_pack.channel[j].phy_id)
                                {
                                    src2_ready = true;
                                }

                                if(src1_ready && src2_ready)
                                {
                                    break;
                                }
                            }
                        }
                    }

                    uint32_t unit_cnt = 0;
                    bool *unit_available = nullptr;
                    component::fifo<issue_execute_pack_t> **unit_fifo = NULL;
                    
                    switch(items[i].op_unit)
                    {
                        case op_unit_t::alu:
                            unit_cnt = ALU_UNIT_NUM;
                            unit_available = alu_unit_available;
                            unit_fifo = issue_alu_fifo;
                            break;
                            
                        case op_unit_t::bru:
                            unit_cnt = BRU_UNIT_NUM;
                            unit_available = bru_unit_available;
                            unit_fifo = issue_bru_fifo;
                            break;
                            
                        case op_unit_t::csr:
                            unit_cnt =  CSR_UNIT_NUM;
                            unit_available = csr_unit_available;
                            unit_fifo = issue_csr_fifo;
                            break;
                            
                        case op_unit_t::div:
                            unit_cnt = DIV_UNIT_NUM;
                            unit_available = div_unit_available;
                            unit_fifo = issue_div_fifo;
                            break;
                            
                        case op_unit_t::lsu:
                            unit_cnt = LSU_UNIT_NUM;
                            unit_available = lsu_unit_available;
                            unit_fifo = issue_lsu_fifo;
                            break;
                            
                        case op_unit_t::mul:
                            unit_cnt = MUL_UNIT_NUM;
                            unit_available = mul_unit_available;
                            unit_fifo = issue_mul_fifo;
                            break;
                    }
                    
                    bool unit_found = false;
                    uint32_t unit_index = 0;
                    
                    for(uint32_t i = 0;i < unit_cnt;i++)
                    {
                        if(unit_available[i])
                        {
                            unit_found = true;
                            unit_index = i;
                            break;
                        }
                    }

                    bool need_to_exit = false;

                    if((items[i].op_unit == op_unit_t::csr) || (items[i].op == op_t::mret))
                    {
                        need_to_exit = true;
                    }

                    bool fence_trigger = (items[i].op == op_t::fence) && ((!store_buffer->is_empty()) || (i != 0) || (commit_feedback_pack.next_handle_rob_id != items[i].rob_id));

                    auto op_id = i;
                    
                    if(src1_ready && src2_ready && unit_found && (!has_lsu_op || (items[i].op_unit != op_unit_t::lsu)) && (!has_csr_op || (items[i].op_unit != op_unit_t::csr)) && (!has_mret_op || (items[i].op != op_t::mret)) && (!fence_trigger))
                    {
                        unit_available[unit_index] = false;
                        item_id_list.push_back(id);
                        i++;
                    }
                    else
                    {
                        items[i].enable = false;
                    }

                    if(items[op_id].op_unit == op_unit_t::lsu)
                    {
                        has_lsu_op = true;
                    }

                    if(items[op_id].op_unit == op_unit_t::csr)
                    {
                        has_csr_op = true;
                    }

                    if(items[op_id].op == op_t::mret)
                    {
                        has_mret_op = true;
                    }

                    if(need_to_exit || fence_trigger)
                    {
                        break;
                    }
                }while(this->issue_q.get_next_id(id, &id) && (first_id != id) && (item_id_list.size() < ISSUE_WIDTH));
            
                //generate output to execute stage
                for(uint32_t i = 0; i < ISSUE_WIDTH;i++)
                {
                    if(i >= item_id_list.size())
                    {
                        break;
                    }

                    if(items[i].enable)
                    {
                        //csr and mret instruction must be executed after all instructions that is before it has been commited
                        if((items[i].op_unit == op_unit_t::csr) || (items[i].op == op_t::mret))
                        {
                            assert(commit_feedback_pack.enable);

                            /*if(commit_feedback_pack.next_handle_rob_id != items[i].rob_id)
                            {
                                break;
                            }*/

                            this->is_inst_waiting = true;
                            this->inst_waiting_rob_id = items[i].rob_id;
                        }

                        bool src1_feedback = false;
                        uint32_t src1_feedback_value = 0;
                        bool src2_feedback = false;
                        uint32_t src2_feedback_value = 0;

                        //wait src load
                        if(!(items[i].src1_loaded && items[i].src2_loaded))
                        {
                            //attempt to get feedback from execute and wb
                            for(auto j = 0;j < EXECUTE_UNIT_NUM;j++)
                            {
                                if(execute_feedback_pack.channel[j].enable)
                                {
                                    if(!items[i].src1_loaded && items[i].rs1_need_map && (items[i].rs1_phy == execute_feedback_pack.channel[j].phy_id))
                                    {
                                        src1_feedback = true;
                                        src1_feedback_value = execute_feedback_pack.channel[j].value;
                                    }

                                    if(!items[i].src2_loaded && items[i].rs2_need_map && (items[i].rs2_phy == execute_feedback_pack.channel[j].phy_id))
                                    {
                                        src2_feedback = true;
                                        src2_feedback_value = execute_feedback_pack.channel[j].value;
                                    }
                                }

                                if(wb_feedback_pack.channel[j].enable)
                                {
                                    if(!items[i].src1_loaded && !src1_feedback && items[i].rs1_need_map && (items[i].rs1_phy == wb_feedback_pack.channel[j].phy_id))
                                    {
                                        src1_feedback = true;
                                        src1_feedback_value = wb_feedback_pack.channel[j].value;
                                    }

                                    if(!items[i].src2_loaded && !src2_feedback && items[i].rs2_need_map && (items[i].rs2_phy == wb_feedback_pack.channel[j].phy_id))
                                    {
                                        src2_feedback = true;
                                        src2_feedback_value = wb_feedback_pack.channel[j].value;
                                    }
                                }
                            }

                            if(!((src1_feedback || items[i].src1_loaded) && (src2_feedback || items[i].src2_loaded)))
                            {
                                break;
                            }
                        }

                        issue_execute_pack_t send_pack;
                        memset(&send_pack, 0, sizeof(send_pack));
                    
                        send_pack.enable = items[i].enable;
                        send_pack.value = items[i].value;
                        send_pack.valid = items[i].valid;
                        send_pack.rob_id = items[i].rob_id;
                        send_pack.pc = items[i].pc;
                        send_pack.imm = items[i].imm;
                        send_pack.has_exception = items[i].has_exception;
                        send_pack.exception_id = items[i].exception_id;
                        send_pack.exception_value = items[i].exception_value;

                        send_pack.predicted = items[i].predicted;
                        send_pack.predicted_jump = items[i].predicted_jump;
                        send_pack.predicted_next_pc = items[i].predicted_next_pc;
                        send_pack.checkpoint_id_valid = items[i].checkpoint_id_valid;
                        send_pack.checkpoint_id = items[i].checkpoint_id;
                    
                        send_pack.rs1 = items[i].rs1;
                        send_pack.arg1_src = items[i].arg1_src;
                        send_pack.rs1_need_map = items[i].rs1_need_map;
                        send_pack.rs1_phy = items[i].rs1_phy;
                        send_pack.src1_value = src1_feedback ? src1_feedback_value : items[i].src1_value;
                        send_pack.src1_loaded = src1_feedback || items[i].src1_loaded;
                    
                        send_pack.rs2 = items[i].rs2;
                        send_pack.arg2_src = items[i].arg2_src;
                        send_pack.rs2_need_map = items[i].rs2_need_map;
                        send_pack.rs2_phy = items[i].rs2_phy;
                        send_pack.src2_value = src2_feedback ? src2_feedback_value : items[i].src2_value;
                        send_pack.src2_loaded = src2_feedback || items[i].src2_loaded;
                    
                        send_pack.rd = items[i].rd;
                        send_pack.rd_enable = items[i].rd_enable;
                        send_pack.need_rename = items[i].need_rename;
                        send_pack.rd_phy = items[i].rd_phy;
                    
                        send_pack.csr = items[i].csr;
                        send_pack.op = items[i].op;
                        send_pack.op_unit = items[i].op_unit;
                        memcpy(&send_pack.sub_op, &items[i].sub_op, sizeof(items[i].sub_op));

                        if(items[i].valid && items[i].op_unit == op_unit_t::lsu)
                        {
                            auto addr = send_pack.src1_value + send_pack.imm;
                            send_pack.lsu_addr = addr;
                            send_pack.exception_value = addr;

                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_stbuf_read_addr", addr, 0);
                    
                            switch(items[i].sub_op.lsu_op)
                            {
                                case lsu_op_t::lb:
                                case lsu_op_t::lbu:
                                    send_pack.has_exception = !bus->check_align(addr, 1);
                                    send_pack.exception_id = !bus->check_align(addr, 1) ? riscv_exception_t::load_address_misaligned : riscv_exception_t::load_access_fault;
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_read_size", 1, 0);
                                    break;

                                case lsu_op_t::lh:
                                case lsu_op_t::lhu:
                                    send_pack.has_exception = !bus->check_align(addr, 2);
                                    send_pack.exception_id = !bus->check_align(addr, 2) ? riscv_exception_t::load_address_misaligned : riscv_exception_t::load_access_fault;
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_read_size", 2, 0);
                                    break;

                                case lsu_op_t::lw:
                                    send_pack.has_exception = !bus->check_align(addr, 4);
                                    send_pack.exception_id = !bus->check_align(addr, 4) ? riscv_exception_t::load_address_misaligned : riscv_exception_t::load_access_fault;
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_read_size", 4, 0);
                                    break;

                                case lsu_op_t::sb:
                                    send_pack.has_exception = !bus->check_align(addr, 1);
                                    send_pack.exception_id = !bus->check_align(addr, 1) ? riscv_exception_t::store_amo_address_misaligned : riscv_exception_t::store_amo_access_fault;
                                    break;

                                case lsu_op_t::sh:
                                    send_pack.has_exception = !bus->check_align(addr, 2);
                                    send_pack.exception_id = !bus->check_align(addr, 2) ? riscv_exception_t::store_amo_address_misaligned : riscv_exception_t::store_amo_access_fault;
                                    break;

                                case lsu_op_t::sw:
                                    send_pack.has_exception = !bus->check_align(addr, 4);
                                    send_pack.exception_id = !bus->check_align(addr, 4) ? riscv_exception_t::store_amo_address_misaligned : riscv_exception_t::store_amo_access_fault;
                                    break;
                            }
                        }
                    
                        //ready to dispatch
                        uint32_t *unit_index = NULL;
                        uint32_t unit_cnt = 0;
                        component::fifo<issue_execute_pack_t> **unit_fifo = NULL;
                    
                        switch(send_pack.op_unit)
                        {
                            case op_unit_t::alu:
                                unit_index = &alu_index;
                                unit_cnt = ALU_UNIT_NUM;
                                unit_fifo = issue_alu_fifo;
                                break;
                            
                            case op_unit_t::bru:
                                unit_index = &bru_index;
                                unit_cnt = BRU_UNIT_NUM;
                                unit_fifo = issue_bru_fifo;
                                break;
                            
                            case op_unit_t::csr:
                                unit_index = &csr_index;
                                unit_cnt =  CSR_UNIT_NUM;
                                unit_fifo = issue_csr_fifo;
                                break;
                            
                            case op_unit_t::div:
                                unit_index = &div_index;
                                unit_cnt = DIV_UNIT_NUM;
                                unit_fifo = issue_div_fifo;
                                break;
                            
                            case op_unit_t::lsu:
                                unit_index = &lsu_index;
                                unit_cnt = LSU_UNIT_NUM;
                                unit_fifo = issue_lsu_fifo;
                                break;
                            
                            case op_unit_t::mul:
                                unit_index = &mul_index;
                                unit_cnt = MUL_UNIT_NUM;
                                unit_fifo = issue_mul_fifo;
                                break;
                        }
                    
                        //Round-Robin dispatch with full check
                        auto selected_index = *unit_index;
                        bool found = false;
                    
                        while(1)
                        {
                            if(!unit_fifo[selected_index]->is_full())
                            {
                                found = true;
                                break;
                            }
                        
                            selected_index = (selected_index + 1) % unit_cnt;
                        
                            if(selected_index == *unit_index)
                            {
                                break;
                            }
                        }
                    
                        if(found)
                        {
                            if(send_pack.op_unit == op_unit_t::lsu)
                            {
                                switch(items[i].sub_op.lsu_op)
                                {
                                    case lsu_op_t::lb:
                                    case lsu_op_t::lbu:
                                    case lsu_op_t::lh:
                                    case lsu_op_t::lhu:
                                    case lsu_op_t::lw:
                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_stbuf_rd", !send_pack.has_exception, 0);

                                        store_buffer->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_addr", send_pack.lsu_addr, 0);
                                        store_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "issue_stbuf_rd", 1, 0);

                                        store_buffer->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_read_addr", send_pack.lsu_addr, 0);
                                        store_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_req", 1, 0);
                                        break;
                                }

                                switch(items[i].sub_op.lsu_op)
                                {
                                    case lsu_op_t::lb:
                                    case lsu_op_t::lbu:
                                        store_buffer->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_size", 1, 0);
                                        store_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_size", 1, 0);
                                        break;

                                    case lsu_op_t::lh:
                                    case lsu_op_t::lhu:
                                        store_buffer->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_size", 2, 0);
                                        store_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_size", 2, 0);
                                        break;

                                    case lsu_op_t::lw:
                                        store_buffer->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_size", 4, 0);
                                        store_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_size", 4, 0);
                                        break;
                                }
                            }

                            std::string unit_name = "";

                            switch(send_pack.op_unit)
                            {
                                case op_unit_t::alu:
                                    unit_name = "alu";
                                    break;

                                case op_unit_t::bru:
                                    unit_name = "bru";
                                    break;

                                case op_unit_t::csr:
                                    unit_name = "csr";
                                    break;

                                case op_unit_t::div:
                                    unit_name = "div";
                                    break;

                                case op_unit_t::lsu:
                                    unit_name = "lsu";
                                    break;

                                case op_unit_t::mul:
                                    unit_name = "mul";
                                    break;
                            }
                            
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.enable", send_pack.enable, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.value", send_pack.value, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.valid", send_pack.valid, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rob_id", send_pack.rob_id, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.pc", send_pack.pc, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.imm", send_pack.imm, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.has_exception", send_pack.has_exception, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.exception_id", (uint32_t)send_pack.exception_id, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.exception_value", send_pack.exception_value, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.predicted", send_pack.predicted, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.predicted_jump", send_pack.predicted_jump, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.predicted_next_pc", send_pack.predicted_next_pc, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.checkpoint_id_valid", send_pack.checkpoint_id_valid, selected_index);
                            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.checkpoint_id", send_pack.checkpoint_id, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs1", send_pack.rs1, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.arg1_src", (uint8_t)send_pack.arg1_src, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs1_need_map", send_pack.rs1_need_map, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs1_phy", send_pack.rs1_phy, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.src1_value", send_pack.src1_value, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.src1_loaded", send_pack.src1_loaded, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs2", send_pack.rs2, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.arg2_src", (uint8_t)send_pack.arg2_src, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs2_need_map", send_pack.rs2_need_map, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rs2_phy", send_pack.rs2_phy, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.src2_value", send_pack.src2_value, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.src2_loaded", send_pack.src2_loaded, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rd", send_pack.rd, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rd_enable", send_pack.rd_enable, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.need_rename", send_pack.need_rename, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.rd_phy", send_pack.rd_phy, selected_index);
                            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.csr", send_pack.csr, selected_index);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.lsu_addr", send_pack.lsu_addr, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.op", (uint8_t)send_pack.op, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.op_unit", (uint8_t)send_pack.op_unit, selected_index);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_data_in.sub_op", *(uint8_t *)&send_pack.sub_op, selected_index);

                            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_" + unit_name + "_fifo_push", 1, selected_index, 0);

                            *unit_index = (selected_index + 1) % unit_cnt;
                            assert(unit_fifo[selected_index]->push(send_pack));
                        }
                        else
                        {
                            issue_execute_fifo_full_add();
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csrf_issue_execute_fifo_full_add", 1, 0);
                            break;
                        }

                        //stop issue of current cycle because of instruction waiting
                        if(is_inst_waiting)
                        {
                            break;
                        }
                    }
                }
            }    

            //handle queue(feedback pack activates blocking items)
            uint32_t cur_item_id = 0;

            if(issue_q.get_front_id(&cur_item_id))
            {
                auto first_item_id = cur_item_id;

                do
                {
                    auto id_need_ignore = false;

                    for(auto i = 0;i < item_id_list.size();i++)
                    {
                        if(cur_item_id == item_id_list[i])
                        {
                            id_need_ignore = true;
                            break;
                        }
                    }

                    if(!id_need_ignore)
                    {
                        auto cur_item = issue_q.get_item(cur_item_id);
                        auto modified = false;

                        for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
                        {
                            if(execute_feedback_pack.channel[i].enable)
                            {
                                if(!cur_item.src1_loaded && cur_item.rs1_need_map && (cur_item.rs1_phy == execute_feedback_pack.channel[i].phy_id))
                                {
                                    cur_item.src1_loaded = true;
                                    cur_item.src1_value = execute_feedback_pack.channel[i].value;
                                    modified = true;
                                }

                                if(!cur_item.src2_loaded && cur_item.rs2_need_map && (cur_item.rs2_phy == execute_feedback_pack.channel[i].phy_id))
                                {
                                    cur_item.src2_loaded = true;
                                    cur_item.src2_value = execute_feedback_pack.channel[i].value;
                                    modified = true;
                                }
                            }

                            if(wb_feedback_pack.channel[i].enable)
                            {
                                if(!cur_item.src1_loaded && cur_item.rs1_need_map && (cur_item.rs1_phy == wb_feedback_pack.channel[i].phy_id))
                                {
                                    cur_item.src1_loaded = true;
                                    cur_item.src1_value = wb_feedback_pack.channel[i].value;
                                    modified = true;
                                }

                                if(!cur_item.src2_loaded && cur_item.rs2_need_map && (cur_item.rs2_phy == wb_feedback_pack.channel[i].phy_id))
                                {
                                    cur_item.src2_loaded = true;
                                    cur_item.src2_value = wb_feedback_pack.channel[i].value;
                                    modified = true;
                                }
                            }
                        }

                        if(modified)
                        { 
                            issue_q.set_item_sync(cur_item_id, cur_item);
                        }
                    }
                }while(issue_q.get_next_id(cur_item_id, &cur_item_id) && (cur_item_id != first_item_id));
            }
        
            //handle input
            if(!this->busy)
            {
                this->busy = true;
                this->last_index = 0;//from item 0
            }

            for(auto i = 0;i < READREG_WIDTH;i++)
            {
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_phyf_id", rev_pack.op_info[i].rs1_phy, i * 2);
                phy_regfile->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "phyf_issue_data", phy_regfile->read(rev_pack.op_info[i].rs1_phy).value, i * 2);
	            phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "phyf_issue_data_valid", phy_regfile->read_data_valid(rev_pack.op_info[i].rs1_phy), i * 2);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_phyf_id", rev_pack.op_info[i].rs2_phy, i * 2 + 1);
                phy_regfile->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "phyf_issue_data", phy_regfile->read(rev_pack.op_info[i].rs2_phy).value, i * 2 + 1);
	            phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "phyf_issue_data_valid", phy_regfile->read_data_valid(rev_pack.op_info[i].rs2_phy), i * 2 + 1);
            }
        
            auto finish = true;
        
            for(;this->last_index < READREG_WIDTH;this->last_index++)
            {
                if(!rev_pack.op_info[this->last_index].enable)
                {
                    continue;
                }
            
                //if issue_queue is full, pause to handle this input until next cycle
                if(this->issue_q.is_full())
                {
                    issue_queue_full_add();
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_csrf_issue_queue_full_add", 1, 0);
                    finish = false;
                    break;
                }
            
                issue_queue_item_t t_item;
                memset(&t_item, 0, sizeof(t_item));
                auto cur_op = rev_pack.op_info[this->last_index];
                t_item.enable = cur_op.enable;
                t_item.value = cur_op.value;
                t_item.valid = cur_op.valid;
                t_item.rob_id = cur_op.rob_id;
                t_item.pc = cur_op.pc;
                t_item.imm = cur_op.imm;
                t_item.has_exception = cur_op.has_exception;
                t_item.exception_id = cur_op.exception_id;
                t_item.exception_value = cur_op.exception_value;

                t_item.predicted = cur_op.predicted;
                t_item.predicted_jump = cur_op.predicted_jump;
                t_item.predicted_next_pc = cur_op.predicted_next_pc;
                t_item.checkpoint_id_valid = cur_op.checkpoint_id_valid;
                t_item.checkpoint_id = cur_op.checkpoint_id;
            
                t_item.rs1 = cur_op.rs1;
                t_item.arg1_src = cur_op.arg1_src;
                t_item.rs1_need_map = cur_op.rs1_need_map;
                t_item.rs1_phy = cur_op.rs1_phy;
                t_item.src1_value = cur_op.src1_value;
                t_item.src1_loaded = cur_op.src1_loaded;
            
                t_item.rs2 = cur_op.rs2;
                t_item.arg2_src = cur_op.arg2_src;
                t_item.rs2_need_map = cur_op.rs2_need_map;
                t_item.rs2_phy = cur_op.rs2_phy;
                t_item.src2_value = cur_op.src2_value;
                t_item.src2_loaded = cur_op.src2_loaded;
            
                t_item.rd = cur_op.rd;
                t_item.rd_enable = cur_op.rd_enable;
                t_item.need_rename = cur_op.need_rename;
                t_item.rd_phy = cur_op.rd_phy;

                t_item.csr = cur_op.csr;
                t_item.op = cur_op.op;
                t_item.op_unit = cur_op.op_unit;
                memcpy(&t_item.sub_op, &cur_op.sub_op, sizeof(t_item.sub_op));

                if(t_item.valid)
                {
                    if(!t_item.src1_loaded && t_item.rs1_need_map)
                    {
                        phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "issue_phyf_id", t_item.rs1_phy, this->last_index * 2);

                        if(phy_regfile->read_data_valid(t_item.rs1_phy))
                        {
                            t_item.src1_loaded = true;
                            t_item.src1_value = phy_regfile->read(t_item.rs1_phy).value;
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_issue_data", t_item.src1_value, this->last_index * 2);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_issue_data_valid", 1, this->last_index * 2);
                        }
                    }

                    if(!t_item.src2_loaded && t_item.rs2_need_map)
                    {
                        phy_regfile->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "issue_phyf_id", t_item.rs2_phy, this->last_index * 2 + 1);

                        if(phy_regfile->read_data_valid(t_item.rs2_phy))
                        {
                            t_item.src2_loaded = true;
                            t_item.src2_value = phy_regfile->read(t_item.rs2_phy).value;
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "phyf_issue_data", t_item.src2_value, this->last_index * 2 + 1);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "phyf_issue_data_valid", 1, this->last_index * 2 + 1);
                        }
                    }

                    for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
                    {
                        if(execute_feedback_pack.channel[i].enable)
                        {
                            if(!t_item.src1_loaded && t_item.rs1_need_map && (t_item.rs1_phy == execute_feedback_pack.channel[i].phy_id))
                            {
                                t_item.src1_loaded = true;
                                t_item.src1_value = execute_feedback_pack.channel[i].value;
                            }

                            if(!t_item.src2_loaded && t_item.rs2_need_map && (t_item.rs2_phy == execute_feedback_pack.channel[i].phy_id))
                            {
                                t_item.src2_loaded = true;
                                t_item.src2_value = execute_feedback_pack.channel[i].value;
                            }
                        }

                        if(wb_feedback_pack.channel[i].enable)
                        {
                            if(!t_item.src1_loaded && t_item.rs1_need_map && (t_item.rs1_phy == wb_feedback_pack.channel[i].phy_id))
                            {
                                t_item.src1_loaded = true;
                                t_item.src1_value = wb_feedback_pack.channel[i].value;
                            }

                            if(!t_item.src2_loaded && t_item.rs2_need_map && (t_item.rs2_phy == wb_feedback_pack.channel[i].phy_id))
                            {
                                t_item.src2_loaded = true;
                                t_item.src2_value = wb_feedback_pack.channel[i].value;
                            }
                        }
                    }
                }
            
                issue_q.push(t_item);
            }
        
            if(finish)
            {
                this->busy = false;
                this->last_index = 0;
            }
        
            feedback_pack.stall = this->busy;

            //compress queue
            issue_q.compress_sync(item_id_list);
            issue_q.sync();
        }
        else
        {
            for(auto i = 0;i < ALU_UNIT_NUM;i++)
            {
                issue_alu_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_alu_fifo_flush", 1, i, 0);
            }

            for(auto i = 0;i < BRU_UNIT_NUM;i++)
            {
                issue_bru_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_bru_fifo_flush", 1, i, 0);
            }

            for(auto i = 0;i < CSR_UNIT_NUM;i++)
            {
                issue_csr_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_csr_fifo_flush", 1, i, 0);
            }

            for(auto i = 0;i < DIV_UNIT_NUM;i++)
            {
                issue_div_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_div_fifo_flush", 1, i, 0);
            }

            for(auto i = 0;i < LSU_UNIT_NUM;i++)
            {
                issue_lsu_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_lsu_fifo_flush", 1, i, 0);
            }

            for(auto i = 0;i < MUL_UNIT_NUM;i++)
            {
                issue_mul_fifo[i]->flush();
                this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "issue_mul_fifo_flush", 1, i, 0);
            }

            issue_q.flush();
            this->busy = false;
            this->is_inst_waiting = false;
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "issue_feedback_pack.stall", feedback_pack.stall, 0);

        this->tdb.capture_output_status();
        this->tdb.write_row();
        return feedback_pack;
    }

    void issue::print(std::string indent)
    {
        issue_q.print(indent);
    }

    json issue::get_json()
    {
        return issue_q.get_json();
    }
}
