#pragma once
#include "common.h"
#include "config.h"
#include "ras.h"
#include "checkpoint_buffer.h"

namespace component
{
    class branch_predictor : public if_reset_t
    {
        private:
            uint32_t gshare_global_history = 0;
            uint32_t gshare_global_history_retired = 0;
            uint32_t gshare_pht[GSHARE_PHT_SIZE];

            void gshare_global_history_update(bool jump, bool hit)
            {
                gshare_global_history_retired = ((gshare_global_history_retired << 1) & GSHARE_GLOBAL_HISTORY_MASK) | (jump ? 1 : 0);

                if(!hit)
                {
                    gshare_global_history = gshare_global_history_retired;
                }
            }

            void gshare_global_history_update_bru_fix(checkpoint_t &cp, bool jump, bool hit)
            {
                uint32_t gshare_global_history_bru = ((cp.global_history << 1) & GSHARE_GLOBAL_HISTORY_MASK) | (jump ? 1 : 0);

                if(!hit)
                {
                    gshare_global_history = gshare_global_history_bru;
                }
            }

            void gshare_global_history_update_guess(bool jump)
            {
                gshare_global_history = ((gshare_global_history << 1) & GSHARE_GLOBAL_HISTORY_MASK) | (jump ? 1 : 0);
            }

            bool gshare_get_prediction(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + GSHARE_PC_P2_ADDR_WIDTH)) & GSHARE_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & GSHARE_PC_P2_ADDR_MASK;
                //uint32_t pht_addr = ((gshare_global_history ^ pc_p1) << GSHARE_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t pht_addr = gshare_global_history ^ pc_p1;
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_out", gshare_pht[pht_addr], 0);
                return gshare_pht[pht_addr] >= 2;
            }

            void gshare_update_prediction(uint32_t pc, bool jump, bool hit)
            {
                uint32_t pc_p1 = (pc >> (2 + GSHARE_PC_P2_ADDR_WIDTH)) & GSHARE_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & GSHARE_PC_P2_ADDR_MASK;
                //uint32_t pht_addr = ((gshare_global_history_retired ^ pc_p1) << GSHARE_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t pht_addr = gshare_global_history_retired ^ pc_p1;

                if(jump)
                {
                    if(gshare_pht[pht_addr] < 3)
                    {
                        gshare_pht[pht_addr]++;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_we", 1, 0);
                    }
                }
                else
                {
                    if(gshare_pht[pht_addr] > 0)
                    {
                        gshare_pht[pht_addr]--;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_we", 1, 0);
                    }
                }

                gshare_global_history_update(jump, hit);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_pht_write_addr", pht_addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_write_data", gshare_pht[pht_addr], 0);
            }

            uint32_t local_bht[LOCAL_BHT_SIZE];
            uint32_t local_bht_retired[LOCAL_BHT_SIZE];
            uint32_t local_pht[LOCAL_PHT_SIZE];

            void local_update_prediction(uint32_t pc, bool jump, bool hit)
            {
                uint32_t pc_p1 = (pc >> (2 + LOCAL_PC_P2_ADDR_WIDTH)) & LOCAL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & LOCAL_PC_P2_ADDR_MASK;
                uint32_t bht_value = local_bht_retired[pc_p1];
                //uint32_t pht_addr = ((bht_value ^ pc_p1) << LOCAL_PC_P2_ADDR_WIDTH) | pc_p2;     
                uint32_t pht_addr = bht_value ^ pc_p1;

                local_bht_retired[pc_p1] = ((local_bht_retired[pc_p1] << 1) & LOCAL_BHT_WIDTH_MASK) | (jump ? 1 : 0);
                
                if(jump)
                {
                    if(local_pht[pht_addr] < 3)
                    {
                        local_pht[pht_addr]++;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_we", 1, 0);
                    }
                }
                else
                {
                    if(local_pht[pht_addr] > 0)
                    {
                        local_pht[pht_addr]--;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_we", 1, 0);
                    }
                }

                if(!hit)
                {
                    local_bht[pc_p1] = local_bht_retired[pc_p1];
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_bht_feedback_commit_valid", 1, 0);
                }

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_commit", local_bht_retired[pc_p1], 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_commit_p1", pc_p1, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_write_addr", pc_p1, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_pht_write_addr", pht_addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_write_data", local_pht[pht_addr], 0);
            }

            uint32_t local_get_bht_value(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + LOCAL_PC_P2_ADDR_WIDTH)) & LOCAL_PC_P1_ADDR_MASK;
                return local_bht[pc_p1];
            }

            void local_update_prediction_bru_fix(component::checkpoint_t &cp, uint32_t pc, bool jump, bool hit)
            {
                uint32_t pc_p1 = (pc >> (2 + LOCAL_PC_P2_ADDR_WIDTH)) & LOCAL_PC_P1_ADDR_MASK;
                uint32_t local_history_bru = ((cp.local_history << 1) & LOCAL_BHT_WIDTH_MASK) | (jump ? 1 : 0);

                if(!hit)
                {
                    local_bht[pc_p1] = local_history_bru;
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_bht_feedback_bru_valid", 1, 0);
                }

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_bru", local_history_bru, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_bru_p1", pc_p1, 0);
            }

            void local_update_prediction_guess(uint32_t pc, bool jump)
            {
                uint32_t pc_p1 = (pc >> (2 + LOCAL_PC_P2_ADDR_WIDTH)) & LOCAL_PC_P1_ADDR_MASK;
                local_bht[pc_p1] = ((local_bht[pc_p1] << 1) & LOCAL_BHT_WIDTH_MASK) | (jump ? 1 : 0);
            }

            bool local_get_prediction(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + LOCAL_PC_P2_ADDR_WIDTH)) & LOCAL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & LOCAL_PC_P2_ADDR_MASK;
                uint32_t bht_value = local_bht[pc_p1];
                //uint32_t pht_addr = ((bht_value ^ pc_p1) << LOCAL_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t pht_addr = bht_value ^ pc_p1;
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_out", local_pht[pht_addr], 0);
                return local_pht[pht_addr] >= 2;
            }

            uint32_t cpht[GSHARE_PHT_SIZE];
            
            void cpht_update_prediction(uint32_t pc, bool hit)
            {
                uint32_t pc_p1 = (pc >> (2 + GSHARE_PC_P2_ADDR_WIDTH)) & GSHARE_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & GSHARE_PC_P2_ADDR_MASK;
                //uint32_t cpht_addr = ((gshare_global_history ^ pc_p1) << GSHARE_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t cpht_addr = gshare_global_history ^ pc_p1;
                
                if(cpht[cpht_addr] <= 1)//gshare
                {
                    if(hit && (cpht[cpht_addr] > 0))
                    {
                        cpht[cpht_addr]--;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_we", 1, 0);
                    }
                    else if(!hit)
                    {
                        cpht[cpht_addr]++;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_we", 1, 0);
                    }
                }
                else//local
                {
                    if(hit && (cpht[cpht_addr] < 3))
                    {
                        cpht[cpht_addr]++;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_we", 1, 0);
                    }
                    else if(!hit)
                    {
                        cpht[cpht_addr]--;
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_we", 1, 0);
                    }
                }

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpht_write_addr", cpht_addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_write_data", cpht[cpht_addr], 0);
            }

            //gshare only when return value is true
            bool cpht_get_prediction(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + GSHARE_PC_P2_ADDR_WIDTH)) & GSHARE_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & GSHARE_PC_P2_ADDR_MASK;
                //uint32_t cpht_addr = ((gshare_global_history ^ pc_p1) << GSHARE_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t cpht_addr = gshare_global_history ^ pc_p1;
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_out", cpht[cpht_addr], 0);
                return cpht[cpht_addr] <= 1;
            }

            component::ras main_ras;

            uint32_t call_global_history = 0;
            uint32_t call_target_cache[CALL_TARGET_CACHE_SIZE];

            void call_global_history_update(bool jump)
            {
                call_global_history = ((call_global_history << 1) & CALL_GLOBAL_HISTORY_MASK) | (jump ? 1 : 0);
            }

            void call_update_prediction(uint32_t pc, bool jump, uint32_t target)
            {
                uint32_t pc_p1 = (pc >> (2 + CALL_PC_P2_ADDR_WIDTH)) & CALL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & CALL_PC_P2_ADDR_MASK;
                //uint32_t target_cache_addr = ((call_global_history ^ pc_p1) << CALL_PC_P2_ADDR_WIDTH) | pc_p2; 
                uint32_t target_cache_addr = call_global_history ^ pc_p1;
                call_target_cache[target_cache_addr] = target;
                call_global_history_update(jump);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "call_target_cache_write_addr", target_cache_addr, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "call_target_cache_write_data", target, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "call_target_cache_we", 1, 0);
            }

            uint32_t call_get_prediction(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + CALL_PC_P2_ADDR_WIDTH)) & CALL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & CALL_PC_P2_ADDR_MASK;
                //uint32_t target_cache_addr = ((call_global_history ^ pc_p1) << CALL_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t target_cache_addr = call_global_history ^ pc_p1;
                return call_target_cache[target_cache_addr];
            }

            uint32_t normal_global_history = 0;
            uint32_t normal_target_cache[NORMAL_TARGET_CACHE_SIZE];

            void normal_global_history_update(bool jump)
            {
                normal_global_history = ((normal_global_history << 1) & NORMAL_GLOBAL_HISTORY_MASK) | (jump ? 1 : 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "normal_global_history_next", normal_global_history, 0);
            }

            void normal_update_prediction(uint32_t pc, bool jump, uint32_t target)
            {
                uint32_t pc_p1 = (pc >> (2 + NORMAL_PC_P2_ADDR_WIDTH)) & NORMAL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & NORMAL_PC_P2_ADDR_MASK;
                //uint32_t target_cache_addr = ((normal_global_history ^ pc_p1) << NORMAL_PC_P2_ADDR_WIDTH) | pc_p2; 
                uint32_t target_cache_addr = normal_global_history ^ pc_p1; 
                normal_target_cache[target_cache_addr] = target;
                normal_global_history_update(jump);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "normal_target_cache_write_addr", target_cache_addr, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "normal_target_cache_write_data", target, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "normal_target_cache_we", 1, 0);
            }

            uint32_t normal_get_prediction(uint32_t pc)
            {
                uint32_t pc_p1 = (pc >> (2 + NORMAL_PC_P2_ADDR_WIDTH)) & NORMAL_PC_P1_ADDR_MASK;
                uint32_t pc_p2 = (pc >> 2) & NORMAL_PC_P2_ADDR_MASK;
                //uint32_t target_cache_addr = ((normal_global_history ^ pc_p1) << NORMAL_PC_P2_ADDR_WIDTH) | pc_p2;
                uint32_t target_cache_addr = normal_global_history ^ pc_p1;
                return normal_target_cache[target_cache_addr];
            }

            enum class sync_request_type_t
            {
                update_prediction
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t pc;
                uint32_t instruction;
                bool jump;
                uint32_t next_pc;
                bool hit;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;
            trace::trace_database tdb;

        public:
            branch_predictor() : main_ras(RAS_SIZE), tdb(TRACE_BRANCH_PREDICTOR)
            {
                gshare_global_history = 0;
                memset(gshare_pht, 0, sizeof(gshare_pht));
                memset(local_bht, 0, sizeof(local_bht));
                memset(local_pht, 0, sizeof(local_pht));
                memset(cpht, 0, sizeof(cpht));
                call_global_history = 0;
                memset(call_target_cache, 0, sizeof(call_target_cache));
                normal_global_history = 0;
                memset(normal_target_cache, 0, sizeof(normal_target_cache));
            }

            virtual void reset()
            {
                gshare_global_history = 0;
                gshare_global_history_retired = 0;
                memset(gshare_pht, 0, sizeof(gshare_pht));
                memset(local_bht, 0, sizeof(local_bht));
                memset(local_pht, 0, sizeof(local_pht));
                memset(cpht, 0, sizeof(cpht));
                call_global_history = 0;
                memset(call_target_cache, 0, sizeof(call_target_cache));
                normal_global_history = 0;
                memset(normal_target_cache, 0, sizeof(normal_target_cache));
                clear_queue(sync_request_q);

                for(auto i = 0;i < GSHARE_PHT_SIZE;i++)
                {
                    gshare_pht[i] = 0x00;
                }

                main_ras.reset();

                this->tdb.create(TRACE_DIR + "branch_predictor.tdb");
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_instruction", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_update_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_update_instruction", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_update_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_update_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bp_update_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_valid", PHY_REG_NUM, 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_visible", PHY_REG_NUM, 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_cp.global_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_cp.local_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_instruction", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_hit", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exbru_bp_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_bp_pc", sizeof(uint32_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_bp_instruction", sizeof(uint32_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_bp_jump", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_bp_next_pc", sizeof(uint32_t), COMMIT_WIDTH);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_bp_hit", sizeof(uint8_t), 1);
		        this->tdb.mark_signal(trace::domain_t::input, "commit_bp_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_fetch_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_fetch_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_fetch_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_fetch_global_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_fetch_local_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_opcode", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_rd", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_rs1", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_imm_b", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_imm_j", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_rd_is_link", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_rs1_is_link", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_is_branch", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_is_call", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_is_normal_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_is_jal", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "fetch_is_jalr", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "call_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "normal_next_pc", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "exbru_is_branch", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_opcode", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_rd", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_rs1", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_rd_is_link", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_rs1_is_link", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_is_branch", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_is_call", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_is_normal_jump", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "commit_index", sizeof(uint8_t), 1);
                this->tdb.bind_signal(trace::domain_t::status, "gshare_global_history", &gshare_global_history, sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_global_history_next", sizeof(uint16_t), 1);
                this->tdb.bind_signal(trace::domain_t::status, "gshare_global_history_retired", &gshare_global_history_retired, sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_global_history_feedback", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_pht_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_pht_write_data", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_pht_we", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_commit", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_commit_p1", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_commit_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_bru", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_bru_p1", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_feedback_bru_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_bht_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_pht_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_pht_write_data", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_pht_we", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpht_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpht_write_data", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpht_we", sizeof(uint8_t), 1);
                this->tdb.bind_signal(trace::domain_t::status, "call_global_history", &call_global_history, sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "call_global_history_next", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "call_target_cache_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "call_target_cache_write_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "call_target_cache_we", sizeof(uint8_t), 1);
                this->tdb.bind_signal(trace::domain_t::status, "normal_global_history", &normal_global_history, sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "normal_global_history_next", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "normal_target_cache_write_addr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "normal_target_cache_write_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "normal_target_cache_we", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "gshare_pht_out", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "local_pht_out", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpht_out", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "ras_bp_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_ras_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_ras_push", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bp_ras_pop", sizeof(uint8_t), 1);
                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_instruction", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_valid", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_instruction", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_update_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_update_valid", 0, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_valid", 0, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_visible", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "exbru_bp_cp.global_history", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "exbru_bp_cp.local_history", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_instruction", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_hit", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_valid", 0, 0);
                
                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_pc", 0, i);
    		        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_instruction", 0, i);
                }

		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_jump", 0, 0);
                
                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
    		        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_next_pc", 0, i);
                }

		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_hit", 0, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_valid", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_fetch_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_fetch_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_fetch_valid", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "bp_fetch_global_history", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "bp_fetch_local_history", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_opcode", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rd", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rs1", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_imm_b", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_imm_j", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rd_is_link", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rs1_is_link", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_branch", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_call", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_normal_jump", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_jal", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_jalr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "gshare_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_jump", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "local_next_pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "call_next_pc", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "normal_next_pc", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "exbru_is_branch", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_opcode", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rd", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rs1", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rd_is_link", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rs1_is_link", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_branch", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_call", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_normal_jump", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_index", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_global_history_next", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_global_history_feedback", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_pht_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_we", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_commit", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_commit_p1", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_bht_feedback_commit_valid", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_bru", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_feedback_bru_p1", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_bht_feedback_bru_valid", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_bht_write_addr", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "local_pht_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_we", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpht_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_we", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "call_global_history_next", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "call_target_cache_write_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "call_target_cache_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "call_target_cache_we", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "normal_global_history_next", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "normal_target_cache_write_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "normal_target_cache_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "normal_target_cache_we", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_pht_out", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_pht_out", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpht_out", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "ras_bp_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_ras_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_push", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_pop", 0, 0);

                main_ras.trace_pre();
            }

            void trace_post()
            {
                main_ras.trace_post();

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_global_history_next", gshare_global_history, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "call_global_history_next", call_global_history, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "normal_global_history_next", normal_global_history, 0);
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

            void save(checkpoint_t &cp, uint32_t pc)
            {
                cp.global_history = gshare_global_history;
                cp.local_history = local_get_bht_value(pc);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "gshare_global_history_feedback", gshare_global_history, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "bp_fetch_global_history", cp.global_history, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "bp_fetch_local_history", cp.local_history, 0);
            }

            bool get_prediction(uint32_t pc, uint32_t instruction, bool *jump, uint32_t *next_pc)
            {
                auto op_data = instruction;
                auto opcode = op_data & 0x7f;
                auto rd = (op_data >> 7) & 0x1f;
                auto funct3 = (op_data >> 12) & 0x07;
                auto rs1 = (op_data >> 15) & 0x1f;
                auto rs2 = (op_data >> 20) & 0x1f;
                auto funct7 = (op_data >> 25) & 0x7f;
                auto imm_i = (op_data >> 20) & 0xfff;
                auto imm_s = (((op_data >> 7) & 0x1f)) | (((op_data >> 25) & 0x7f) << 5);
                auto imm_b = (((op_data >> 8) & 0x0f) << 1) | (((op_data >> 25) & 0x3f) << 5) | (((op_data >> 7) & 0x01) << 11) | (((op_data >> 31) & 0x01) << 12);
                auto imm_u = op_data & (~0xfff);
                auto imm_j = (((op_data >> 12) & 0xff) << 12) | (((op_data >> 20) & 0x01) << 11) | (((op_data >> 21) & 0x3ff) << 1) | (((op_data >> 31) & 0x01) << 20);

                auto need_jump_prediction = true;
                auto instruction_next_pc_valid = true;
                uint32_t instruction_next_pc = 0;

                auto rd_is_link = (rd == 1) || (rd == 5);
                auto rs1_is_link = (rs1 == 1) || (rs1 == 5);

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_pc", pc, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_instruction", instruction, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_valid", 1, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_opcode", opcode, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rd", rd, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rs1", rs1, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_imm_b", imm_b, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_imm_j", imm_j, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rd_is_link", rd_is_link, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_rs1_is_link", rs1_is_link, 0);

                switch(opcode)
                {
                    case 0x6f://jal
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_jal", 1, 0);
                        need_jump_prediction = false;
                        instruction_next_pc_valid = true;
                        instruction_next_pc = pc + sign_extend(imm_j, 21);

                        if(rd_is_link)
                        {
                            main_ras.push_addr(pc + 4);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_ras_addr", pc + 4, 0);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_push", 1, 0);
                        }

                        break;

                    case 0x67://jalr
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_jalr", 1, 0);
                        need_jump_prediction = false;
                        instruction_next_pc_valid = false;

                        if(rd_is_link)
                        {
                            if(rs1_is_link)
                            {
                                if(rs1 == rd)
                                {
                                    //push
                                    instruction_next_pc_valid = true;
                                    instruction_next_pc = call_get_prediction(pc);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_call", 1, 0);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "call_next_pc", instruction_next_pc, 0);
                                    main_ras.push_addr(pc + 4);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_ras_addr", pc + 4, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_push", 1, 0);
                                }
                                else
                                {
                                    //pop, then push for coroutine context switch
                                    instruction_next_pc_valid = true;
                                    instruction_next_pc = main_ras.pop_addr();
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "ras_bp_addr", instruction_next_pc, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_pop", 1, 0);
                                    main_ras.push_addr(pc + 4);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_ras_addr", pc + 4, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_push", 1, 0);
                                }
                            }
                            else
                            {
                                //push
                                instruction_next_pc_valid = true;
                                instruction_next_pc = call_get_prediction(pc);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_call", 1, 0);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "call_next_pc", instruction_next_pc, 0);
                                main_ras.push_addr(pc + 4);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_ras_addr", pc + 4, 0);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_push", 1, 0);
                            }
                        }
                        else
                        {
                            if(rs1_is_link)
                            {
                                //pop
                                instruction_next_pc_valid = true;
                                instruction_next_pc = main_ras.pop_addr();
                                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "ras_bp_addr", instruction_next_pc, 0);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_ras_pop", 1, 0);
                            }
                            else
                            {
                                //none
                                instruction_next_pc_valid = true;
                                instruction_next_pc = normal_get_prediction(pc);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_normal_jump", 1, 0);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "normal_next_pc", instruction_next_pc, 0);
                            }
                        }
                        
                        break;

                    case 0x63://beq bne blt bge bltu bgeu
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_is_branch", 1, 0);
                        need_jump_prediction = true;
                        instruction_next_pc_valid = !cpht_get_prediction(pc) ? local_get_prediction(pc) : gshare_get_prediction(pc);
                        instruction_next_pc = instruction_next_pc_valid ? (pc + sign_extend(imm_b, 13)) : (pc + 4);
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "gshare_jump", gshare_get_prediction(pc), 0);
                        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "gshare_next_pc", instruction_next_pc, 0);
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "local_jump", local_get_prediction(pc), 0);
                        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "local_next_pc", instruction_next_pc, 0);

                        switch(funct3)
                        {
                            case 0x0://beq
                            case 0x1://bne
                            case 0x4://blt
                            case 0x5://bge
                            case 0x6://bltu
                            case 0x7://bgeu
                                break;

                            default://invalid
                                return false;
                        }

                        break;

                    default:
                        return false;
                }

                if(!need_jump_prediction)
                {
                    *jump = true;

                    if(!instruction_next_pc_valid)
                    {
                        return false;
                    }

                    *next_pc = instruction_next_pc;
                }
                else
                {
                    *jump = instruction_next_pc_valid;
                    *next_pc = instruction_next_pc;
                }
                
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_fetch_valid", 1, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bp_fetch_jump", *jump, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bp_fetch_next_pc", *next_pc, 0);
                return true;
            }

            void update_prediction_guess(uint32_t pc, uint32_t instruction, bool jump, uint32_t next_pc)
            {
                auto op_data = instruction;
                auto opcode = op_data & 0x7f;
                auto rd = (op_data >> 7) & 0x1f;
                auto rs1 = (op_data >> 15) & 0x1f;
                auto rd_is_link = (rd == 1) || (rd == 5);
                auto rs1_is_link = (rs1 == 1) || (rs1 == 5);

                //condition branch instruction
                if(opcode == 0x63)
                {
                    gshare_global_history_update_guess(jump);
                    local_update_prediction_guess(pc, jump);
                }

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_pc", pc, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_instruction", instruction, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_update_jump", jump, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bp_update_next_pc", next_pc, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bp_update_valid", 1, 0);
            }

            void update_prediction_bru_guess(checkpoint_t &cp, uint32_t pc, uint32_t instruction, bool jump, uint32_t next_pc, bool hit)
            {
                auto op_data = instruction;
                auto opcode = op_data & 0x7f;
                auto rd = (op_data >> 7) & 0x1f;
                auto rs1 = (op_data >> 15) & 0x1f;
                auto rd_is_link = (rd == 1) || (rd == 5);
                auto rs1_is_link = (rs1 == 1) || (rs1 == 5);

                //condition branch instruction
                if(opcode == 0x63)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "exbru_is_branch", 1, 0);
                    gshare_global_history_update_bru_fix(cp, jump, hit);
                    local_update_prediction_bru_fix(cp, pc, jump, hit);
                }

                this->tdb.update_signal_bitmap(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_valid", cp.rat_phy_map_table_valid, 0);
                this->tdb.update_signal_bitmap(trace::domain_t::input, "exbru_bp_cp.rat_phy_map_table_visible", cp.rat_phy_map_table_visible, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "exbru_bp_cp.global_history", cp.global_history, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "exbru_bp_cp.local_history", cp.local_history, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_pc", pc, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_instruction", instruction, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_jump", jump, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exbru_bp_next_pc", next_pc, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_hit", hit, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exbru_bp_valid", 1, 0);
            }

            void update_prediction(uint32_t pc, uint32_t instruction, bool jump, uint32_t next_pc, bool hit, int commit_index = 0)
            {
                auto op_data = instruction;
                auto opcode = op_data & 0x7f;
                auto rd = (op_data >> 7) & 0x1f;
                auto rs1 = (op_data >> 15) & 0x1f;
                auto rd_is_link = (rd == 1) || (rd == 5);
                auto rs1_is_link = (rs1 == 1) || (rs1 == 5);

                //condition branch instruction
                if(opcode == 0x63)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_branch", 1, 0);
                    gshare_update_prediction(pc, jump, hit);
                    local_update_prediction(pc, jump, hit);
                    cpht_update_prediction(pc, hit);
                }
                else if(opcode == 0x67)
                {
                    if(rd_is_link)
                    {
                        if(rs1_is_link)
                        {
                            if(rs1 == rd)
                            {
                                //push
                                call_update_prediction(pc, jump, next_pc);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_call", 1, 0);
                            }
                            else
                            {
                                //pop, then push for coroutine context switch
                            }
                        }
                        else
                        {
                            //push
                            call_update_prediction(pc, jump, next_pc);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_call", 1, 0);
                        }
                    }
                    else
                    {
                        if(rs1_is_link)
                        {
                            //pop
                        }
                        else
                        {
                            //none
                            normal_update_prediction(pc, jump, next_pc);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_is_normal_jump", 1, 0);
                        }
                    }
                }

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_pc", pc, commit_index);
    		    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_instruction", instruction, commit_index);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_jump", jump << commit_index, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_bp_next_pc", next_pc, commit_index);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_hit", hit << commit_index, 0);
		        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_bp_valid", 1 << commit_index, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_opcode", opcode, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rd", rd, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rs1", rs1, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rd_is_link", rd_is_link, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_rs1_is_link", rs1_is_link, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "commit_index", commit_index, 0);
            }

            void update_prediction_sync(uint32_t pc, uint32_t instruction, bool jump, uint32_t next_pc, bool hit)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::update_prediction;
                t_req.pc = pc;
                t_req.instruction = instruction;
                t_req.jump = jump;
                t_req.next_pc = next_pc;
                t_req.hit = hit;
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
                        case sync_request_type_t::update_prediction:
                            update_prediction(t_req.pc, t_req.instruction, t_req.jump, t_req.next_pc, t_req.hit);
                            break;
                    }
                }
            }
    };
}