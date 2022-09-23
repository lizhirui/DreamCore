#pragma once
#include "common.h"
#include "checkpoint_buffer.h"

namespace component
{
    template<typename T>
    class regfile : public if_reset_t
    {
        private:
            enum class sync_request_type_t
            {
                write,
                restore
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                T arg2;
                bool arg3;
                checkpoint_t cp;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;
            
            T *reg_data;
            uint64_t *reg_data_valid;
            uint32_t size;
            uint32_t bitmap_size;

            trace::trace_database tdb;

        public:
            regfile(uint32_t size) : tdb(TRACE_PHY_REGFILE)
            {
                this->size = size;
                reg_data = new T[size];
                bitmap_size = (size + bitsizeof(reg_data_valid[0]) - 1) / (bitsizeof(reg_data_valid[0]));
                reg_data_valid = new uint64_t[bitmap_size];
                memset(reg_data, 0, sizeof(reg_data[0]) * size);
                memset(reg_data_valid, 0, sizeof(reg_data_valid) * bitmap_size);
            }

            ~regfile()
            {
                delete[] reg_data;
                delete[] reg_data_valid;
            }

            virtual void reset()
            {
                memset(reg_data, 0, sizeof(reg_data[0]) * size);
                memset(reg_data_valid, 0, sizeof(reg_data_valid) * bitmap_size);
                clear_queue(sync_request_q);

                this->tdb.create(TRACE_DIR + "phy_regfile.tdb");

                this->tdb.mark_signal(trace::domain_t::input, "readreg_phyf_id", sizeof(uint8_t), READREG_WIDTH * 2);
                this->tdb.mark_signal(trace::domain_t::output, "phyf_readreg_data", sizeof(uint32_t), READREG_WIDTH * 2);
                this->tdb.mark_signal(trace::domain_t::output, "phyf_readreg_data_valid", sizeof(uint8_t), READREG_WIDTH * 2);

                this->tdb.mark_signal(trace::domain_t::input, "issue_phyf_id", sizeof(uint8_t), READREG_WIDTH * 2);
                this->tdb.mark_signal(trace::domain_t::output, "phyf_issue_data", sizeof(uint32_t), READREG_WIDTH * 2);
                this->tdb.mark_signal(trace::domain_t::output, "phyf_issue_data_valid", sizeof(uint8_t), READREG_WIDTH * 2);

                this->tdb.mark_signal(trace::domain_t::input, "wb_phyf_id", sizeof(uint8_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "wb_phyf_data", sizeof(uint32_t), EXECUTE_UNIT_NUM);
                this->tdb.mark_signal(trace::domain_t::input, "wb_phyf_we", sizeof(uint8_t), EXECUTE_UNIT_NUM);

                this->tdb.mark_signal(trace::domain_t::input, "commit_phyf_id", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "commit_phyf_invalid", sizeof(uint8_t), COMMIT_WIDTH);

                this->tdb.mark_signal(trace::domain_t::input, "commit_phyf_flush_id", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_phyf_flush_invalid", sizeof(uint8_t), 1);

                this->tdb.mark_signal_bitmap(trace::domain_t::input, "commit_phyf_data_valid", PHY_REG_NUM, 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_phyf_data_valid_restore", sizeof(uint8_t), 1);

                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();               
                                
                for(auto i = 0;i < READREG_WIDTH * 2;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "readreg_phyf_id", 255, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "phyf_readreg_data", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "phyf_readreg_data_valid", 0, i);
    
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_phyf_id", 255, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "phyf_issue_data", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "phyf_issue_data_valid", 0, i);
                }

                for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_phyf_id", 0, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "wb_phyf_data", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "wb_phyf_we", 0, i);
                }

                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_invalid", 0, i);;
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_id", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_flush_invalid", 0, 0);

                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "commit_phyf_data_valid", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_phyf_data_valid_restore", 0, 0);
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

            void write(uint32_t addr, T value, bool valid)
            {
                assert(addr < size);
                reg_data[addr] = value;

                if(valid)
                {
                    reg_data_valid[addr / bitsizeof(reg_data_valid[0])] |= 1ULL << (addr % bitsizeof(reg_data_valid[0]));
                }
                else
                {
                    reg_data_valid[addr / bitsizeof(reg_data_valid[0])] &= ~(1ULL << (addr % bitsizeof(reg_data_valid[0])));
                }
            }

            T read(uint32_t addr)
            {
                assert(addr < size);
                return reg_data[addr];
            }

            bool cp_get_data_valid(checkpoint_t &cp, uint32_t addr)
            {
                assert(addr < size);
                return (cp.phy_regfile_data_valid[addr / bitsizeof(cp.phy_regfile_data_valid[0])] & (1ULL << (addr % bitsizeof(cp.phy_regfile_data_valid[0])))) != 0;
            }

            void cp_set_data_valid(checkpoint_t &cp, uint32_t addr, bool valid)
            {
                assert(addr < size);

                if(valid)
                {
                    cp.phy_regfile_data_valid[addr / bitsizeof(cp.phy_regfile_data_valid[0])] |= 1ULL << (addr % bitsizeof(cp.phy_regfile_data_valid[0]));
                }
                else
                {
                    cp.phy_regfile_data_valid[addr / bitsizeof(cp.phy_regfile_data_valid[0])] &= ~(1ULL << (addr % bitsizeof(cp.phy_regfile_data_valid[0])));
                }
            }

            bool read_data_valid(uint32_t addr)
            {
                assert(addr < size);
                return ((reg_data_valid[addr / bitsizeof(reg_data_valid[0])]) & (1ULL << (addr % bitsizeof(reg_data_valid[0])))) != 0;
            }

            void write_sync(uint32_t addr, T value, bool valid)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::write;
                t_req.arg1 = addr;
                t_req.arg2 = value;
                t_req.arg3 = valid;
                sync_request_q.push(t_req);
            }
            
            void restore(checkpoint_t &cp)
            {
                memcpy(reg_data_valid, cp.phy_regfile_data_valid, sizeof(cp.phy_regfile_data_valid));
            }

            void restore_sync(checkpoint_t &cp)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::restore;
                t_req.cp = cp;
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
                        case sync_request_type_t::write:
                            write(t_req.arg1, t_req.arg2, t_req.arg3);
                            break;

                        case sync_request_type_t::restore:
                            restore(t_req.cp);
                            break;
                    }
                }
            }
    };
}