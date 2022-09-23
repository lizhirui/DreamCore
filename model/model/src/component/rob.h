#pragma once
#include "common.h"
#include "fifo.h"

namespace component
{
    typedef struct rob_item_t : public if_print_t
    {
        uint32_t new_phy_reg_id;
        uint32_t old_phy_reg_id;
        bool old_phy_reg_id_valid;
        bool finish;
        uint32_t pc;
        uint32_t inst_value;
        bool has_exception;
        riscv_exception_t exception_id;
        uint32_t exception_value;
        bool predicted;
        bool predicted_jump;
        uint32_t predicted_next_pc;
        bool checkpoint_id_valid;
        uint32_t checkpoint_id;
        bool bru_op;
        bool bru_jump;
        uint32_t bru_next_pc;
        bool is_mret;
        uint32_t csr_addr;
        uint32_t csr_newvalue;
        bool csr_newvalue_valid;

        virtual void print(std::string indent)
        {
            std::string blank = "    ";
            std::cout << indent << "new_phy_reg_id = " << new_phy_reg_id;
            std::cout << blank << "old_phy_reg_id = " << old_phy_reg_id;
            std::cout << blank << "old_phy_reg_id_valid = " << outbool(old_phy_reg_id_valid);
            std::cout << blank << "finish = " << outbool(finish);
            std::cout << blank << "pc = 0x" << fillzero(8) << outhex(pc);
            std::cout << blank << "inst_value = 0x" << fillzero(8) << outhex(inst_value);
            std::cout << blank << "has_exception = " << outbool(has_exception);
            std::cout << blank << "exception_id = " << outenum(exception_id);
            std::cout << blank << "exception_value = 0x" << fillzero(8) << outhex(exception_value) << std::endl;
        }

        virtual json get_json()
        {
            json ret;

            ret["new_phy_reg_id"] = new_phy_reg_id;
            ret["old_phy_reg_id"] = old_phy_reg_id;
            ret["old_phy_reg_id_valid"] = old_phy_reg_id_valid;
            ret["finish"] = finish;
            ret["pc"] = pc;
            ret["inst_value"] = inst_value;
            ret["has_exception"] = has_exception;
            ret["exception_id"] = outenum(exception_id);
            ret["exception_value"] = exception_value;
            ret["predicted"] = predicted;
            ret["predicted_jump"] = predicted_jump;
            ret["predicted_next_pc"] = predicted_next_pc;
            ret["checkpoint_id_valid"] = checkpoint_id_valid;
            ret["checkpoint_id"] = checkpoint_id;
            ret["bru_op"] = bru_op;
            ret["bru_jump"] = bru_jump;
            ret["bru_next_pc"] = bru_next_pc;
            ret["is_mret"] = is_mret;
            ret["csr_addr"] = csr_addr;
            ret["csr_newvalue"] = csr_newvalue;
            ret["csr_newvalue_valid"] = csr_newvalue_valid;
            return ret;
        }
    }rob_item_t;

    class rob : public fifo<rob_item_t>
    {
        private:
            enum class sync_request_type_t
            {
                push,
                pop,
                set_item
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                rob_item_t arg2;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;

            trace::trace_database tdb;

            bool committed = false;
            uint32_t commit_num = 0;
            uint64_t global_commit_num = 0;

            bool check_new_id_valid(uint32_t id)
            {
                if(this->is_full())
                {
                    return false;
                }
                else if(this->wstage == this->rstage)
                {
                    return !((id >= this->rptr) && (id < this->wptr));
                }
                else
                {
                    return !(((id >= this->rptr) && (id < this->size)) || (id < this->wptr));
                }
            }

            bool check_id_valid(uint32_t id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                else if(this->wstage == this->rstage)
                {
                    return (id >= this->rptr) && (id < this->wptr);
                }
                else
                {
                    return ((id >= this->rptr) && (id < this->size)) || (id < this->wptr);
                }
            }

        public:
            rob(uint32_t size) : fifo<rob_item_t>(size), tdb(TRACE_ROB)
            {
                
            }

            virtual void reset()
            {
                fifo<rob_item_t>::reset();
                clear_queue(sync_request_q);
                committed = false;
                commit_num = 0;
                global_commit_num = 0;

                this->tdb.create(TRACE_DIR + "rob.tdb");

                this->tdb.mark_signal(trace::domain_t::output, "rob_rename_new_id", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_rename_new_id_valid", sizeof(uint8_t), RENAME_WIDTH);
                
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.new_phy_reg_id", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.old_phy_reg_id", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.old_phy_reg_id_valid", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.finish", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.pc", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.inst_value", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.has_exception", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.exception_id", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.exception_value", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.predicted", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.predicted_jump", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.predicted_next_pc", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.checkpoint_id_valid", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.checkpoint_id", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.bru_op", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.bru_jump", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.bru_next_pc", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.is_mret", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.csr_addr", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.csr_newvalue", sizeof(uint32_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data.csr_newvalue_valid", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_data_valid", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_rob_push", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.new_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.finish", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.inst_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.bru_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.is_mret", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.csr_addr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.new_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.finish", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.inst_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.has_exception", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.exception_id", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.exception_value", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.predicted", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.predicted_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.predicted_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.checkpoint_id_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.checkpoint_id", sizeof(uint16_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.bru_op", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.bru_jump", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.bru_next_pc", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.is_mret", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.csr_addr", sizeof(uint16_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.csr_newvalue", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_input_data.csr_newvalue_valid", sizeof(uint8_t), EXECUTE_UNIT_NUM);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_rob_input_data_we", sizeof(uint8_t), EXECUTE_UNIT_NUM);

                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_head_id", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_head_id_valid" ,sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_retire_id", sizeof(uint8_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.new_phy_reg_id", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id_valid", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.finish", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.pc", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.inst_value", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.has_exception", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.exception_id", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.exception_value", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.predicted", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.predicted_jump", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.predicted_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id_valid", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id", sizeof(uint16_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.bru_op", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.bru_jump", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.bru_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.is_mret", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.csr_addr", sizeof(uint16_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue", sizeof(uint32_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue_valid", sizeof(uint8_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_retire_id_valid", sizeof(uint8_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_rob_retire_pop", sizeof(uint8_t), COMMIT_WIDTH);

                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_next_id", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_next_id_valid", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_tail_id", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_tail_id_valid", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "commit_rob_flush_id", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.new_phy_reg_id", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.finish", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.inst_value", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.has_exception", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.exception_id", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.exception_value", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.predicted", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.predicted_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.predicted_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.bru_op", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.bru_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.bru_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.is_mret", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.csr_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue_valid", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_next_id", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_flush_next_id_valid", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "rob_commit_empty", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::output, "rob_commit_full", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_rob_flush", sizeof(uint8_t), 1);

                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();
                                
                for(auto i = 0;i < RENAME_WIDTH;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_rename_new_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_rename_new_id_valid", 0, i);
                    
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.new_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.old_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.old_phy_reg_id_valid", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.finish", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.pc", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.inst_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.has_exception", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.exception_id", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.exception_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.predicted", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.predicted_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.predicted_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.checkpoint_id_valid", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_rob_data.checkpoint_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.bru_op", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.bru_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.bru_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.is_mret", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_rob_data.csr_addr", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "rename_rob_data.csr_newvalue", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data.csr_newvalue_valid", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_data_valid", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_rob_push", 0, 0);

                
                for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_id", 0, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.new_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.old_phy_reg_id_valid", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.finish", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.pc", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.inst_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.has_exception", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.exception_id", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.exception_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.predicted", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.predicted_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.predicted_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.checkpoint_id_valid", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "commit_rob_input_data.checkpoint_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.bru_op", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.bru_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.bru_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.is_mret", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "commit_rob_input_data.csr_addr", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_rob_input_data.csr_newvalue", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data.csr_newvalue_valid", 0, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.new_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.old_phy_reg_id_valid", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.finish", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.pc", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.inst_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.has_exception", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.exception_id", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.exception_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.predicted", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.predicted_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.predicted_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.checkpoint_id_valid", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_input_data.checkpoint_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.bru_op", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.bru_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.bru_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.is_mret", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_input_data.csr_addr", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_input_data.csr_newvalue", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_input_data.csr_newvalue_valid", 0, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_input_data_we", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_head_id", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_head_id_valid" ,0, 0);

                
                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_retire_id", 255, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.new_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.old_phy_reg_id_valid", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.finish", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.pc", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.inst_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.has_exception", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.exception_id", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.exception_value", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.predicted", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.predicted_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.predicted_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id_valid", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_retire_data.checkpoint_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.bru_op", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.bru_jump", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.bru_next_pc", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.is_mret", 0, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_retire_data.csr_addr", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_data.csr_newvalue_valid", 0, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_id_valid", 0, i);
    		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_retire_pop", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_next_id", 255, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_next_id_valid", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_tail_id", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_tail_id_valid", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush_id", 255, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.new_phy_reg_id", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.old_phy_reg_id_valid", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.finish", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.inst_value", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.has_exception", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_id", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.exception_value", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.predicted_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id_valid", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.checkpoint_id", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_op", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.bru_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.bru_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.is_mret", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "rob_commit_flush_data.csr_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_data.csr_newvalue_valid", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id", 255, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_next_id_valid", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_empty", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_full", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_rob_flush", 0, 0);

                {
                    uint32_t new_id;
                    bool new_id_valid = get_new_id(&new_id);

                    for(auto i = 0;i < RENAME_WIDTH;i++)
                    {
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_rename_new_id", new_id, i);
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_rename_new_id_valid", new_id_valid, i);
                        new_id_valid = get_next_new_id(new_id, &new_id);
                    }
                }

                {
                    uint32_t front_id;
                    bool front_id_valid = get_front_id(&front_id);

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_head_id", front_id, 0);
		            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_retire_head_id_valid" , front_id_valid, 0);
                }

                {
                    uint32_t tail_id;
                    bool tail_id_valid = get_tail_id(&tail_id);

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_tail_id", tail_id, 0);
		            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_flush_tail_id_valid", tail_id_valid, 0);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_empty", is_empty(), 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "rob_commit_full", is_full(), 0);
            }

            void trace_post()
            {
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

            trace::trace_database *get_tdb()
            {
                return &tdb;
            }

            bool get_committed()
            {
                return committed;
            }

            void set_committed(bool value)
            {
                committed = value;
            }

            void add_commit_num(uint32_t add_num)
            {
                commit_num += add_num;
                global_commit_num += add_num;
            }

            uint64_t get_global_commit_num()
            {
                return global_commit_num;
            }

            uint32_t get_commit_num()
            {
                return commit_num;
            }

            void clear_commit_num()
            {
                commit_num = 0;
            }

            bool push(rob_item_t element, uint32_t *item_id)
            {
                *item_id = this->wptr;
                return fifo<rob_item_t>::push(element);
            }

            rob_item_t get_item(uint32_t item_id)
            {
                return this->buffer[item_id];
            }

            void set_item(uint32_t item_id, rob_item_t item)
            {
                this->buffer[item_id] = item;
            }

            void set_item_sync(uint32_t item_id, rob_item_t item)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::set_item;
                t_req.arg1 = item_id;
                t_req.arg2 = item;
                sync_request_q.push(t_req);
            }

            rob_item_t get_front()
            {
                return this->buffer[rptr];
            }

            uint32_t get_size()
            {
                return this->is_full() ? this->size : ((this->wptr + this->size - this->rptr) % this->size);
            }

            uint32_t get_free_space()
            {
                return this->size - get_size();
            }

            bool get_new_id(uint32_t *new_id)
            {
                if(this->is_full())
                {
                    return false;
                }

                *new_id = this->wptr;
                return true;
            }

            bool get_next_new_id(uint32_t cur_new_id, uint32_t *next_new_id)
            {
                if(!check_new_id_valid(cur_new_id))
                {
                    return false;
                }

                *next_new_id = (cur_new_id + 1) % this->size;
                return check_new_id_valid(*next_new_id);
            }

            bool get_front_id(uint32_t *front_id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                
                *front_id = this->rptr;
                return true;
            }

            bool get_tail_id(uint32_t *tail_id)
            {
                if(this->is_empty())
                {
                    return false;
                }

                *tail_id = (wptr + this->size - 1) % this->size;
                return true;
            }

            bool get_prev_id(uint32_t id, uint32_t *prev_id)
            {
                assert(check_id_valid(id));
                *prev_id = (id + this->size - 1) % this->size;
                return check_id_valid(*prev_id);
            }

            bool get_next_id(uint32_t id, uint32_t *next_id)
            {
                assert(check_id_valid(id));
                *next_id = (id + 1) % this->size;
                return check_id_valid(*next_id);
            }

            bool pop()
            {
                rob_item_t t;
                return fifo<rob_item_t>::pop(&t);
            }

            void pop_sync()
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::pop;
                sync_request_q.push(t_req);
            }

            void sync()
            {
                sync_request_t t_req;

                while(!sync_request_q.empty())
                {
                    t_req = sync_request_q.front();
                    sync_request_q.pop();

                    switch(t_req.req)
                    {
                        case sync_request_type_t::pop:
                            pop();
                            break;

                        case sync_request_type_t::set_item:
                            set_item(t_req.arg1, t_req.arg2);
                            break;
                    }
                }
            }

            virtual json get_json()
            {
                json ret = json::array();
                if_print_t *if_print;

                if(!is_empty())
                {
                    auto cur = rptr;
                    auto cur_stage = rstage;

                    while(1)
                    {
                        if_print = dynamic_cast<if_print_t *>(&buffer[cur]);
                        json item = if_print->get_json();
                        item["rob_id"] = cur;
                        ret.push_back(item);
                
                        cur++;

                        if(cur >= size)
                        {
                            cur = 0;
                            cur_stage = !cur_stage;
                        }

                        if((cur == wptr) && (cur_stage == wstage))
                        {
                            break;
                        }
                    }
                }

                return ret;
            }
    };
}