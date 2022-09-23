#pragma once
#include "common.h"
#include "config.h"
#include "fifo.h"

namespace component
{
    static const uint32_t phy_reg_num_bitmap_size = (PHY_REG_NUM + bitsizeof(uint64_t) - 1) / (bitsizeof(uint64_t));

    typedef struct checkpoint_t : public if_print_t
    {
        uint64_t rat_phy_map_table_valid[phy_reg_num_bitmap_size];
        uint64_t rat_phy_map_table_visible[phy_reg_num_bitmap_size];
        uint64_t phy_regfile_data_valid[phy_reg_num_bitmap_size];

        //only for global_cp
        uint32_t rat_phy_map_table[PHY_REG_NUM];

        //for branch predictor
        uint32_t global_history;
        uint32_t local_history;

        void clone(checkpoint_t &cp)
        {
            memcpy(&cp.rat_phy_map_table_valid, &rat_phy_map_table_valid, sizeof(rat_phy_map_table_valid));
            memcpy(&cp.rat_phy_map_table_visible, &rat_phy_map_table_visible, sizeof(rat_phy_map_table_visible));
            cp.global_history = global_history;
            cp.local_history = local_history;
        }

        virtual void print(std::string indent)
        {
            
        }

        virtual json get_json()
        {
            json ret;
            return ret;
        }
    }checkpoint_t;

    class checkpoint_buffer : public fifo<checkpoint_t>
    {
        private:
            enum class sync_request_type_t
            {
                pop,
                set_item
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                checkpoint_t arg2;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;

            trace::trace_database tdb;

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
            checkpoint_buffer(uint32_t size) : fifo<checkpoint_t>(size), tdb(TRACE_CHECKPOINT_BUFFER)
            {
                
            }

            virtual void reset()
            {
                fifo<checkpoint_t>::reset();
                clear_queue(sync_request_q);

                this->tdb.create(TRACE_DIR + "checkpoint_buffer.tdb");

                this->tdb.mark_signal(trace::domain_t::status, "rptr", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::status, "wptr", sizeof(uint16_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_fetch_new_id", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_fetch_new_id_valid", sizeof(uint8_t), 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "fetch_cpbuf_data.rat_phy_map_table_valid", PHY_REG_NUM, 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "fetch_cpbuf_data.rat_phy_map_table_visible", PHY_REG_NUM, 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_cpbuf_data.global_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_cpbuf_data.local_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_cpbuf_push", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "rename_cpbuf_id", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_valid", PHY_REG_NUM, RENAME_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_visible", PHY_REG_NUM, RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_cpbuf_data.global_history", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_cpbuf_data.local_history", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "rename_cpbuf_we", sizeof(uint8_t), RENAME_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_rename_data.rat_phy_map_table_valid", PHY_REG_NUM, RENAME_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_rename_data.rat_phy_map_table_visible", PHY_REG_NUM, RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_rename_data.global_history", sizeof(uint16_t), RENAME_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_rename_data.local_history", sizeof(uint16_t), RENAME_WIDTH);

                this->tdb.mark_signal(trace::domain_t::input, "exbru_cpbuf_id", sizeof(uint16_t), 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_exbru_data.rat_phy_map_table_valid", PHY_REG_NUM, 1);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_exbru_data.rat_phy_map_table_visible", PHY_REG_NUM, 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_exbru_data.global_history", sizeof(uint16_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_exbru_data.local_history", sizeof(uint16_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "commit_cpbuf_id", sizeof(uint16_t), COMMIT_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_valid", PHY_REG_NUM, COMMIT_WIDTH);
                this->tdb.mark_signal_bitmap(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_visible", PHY_REG_NUM, COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_commit_data.global_history", sizeof(uint16_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "cpbuf_commit_data.local_history", sizeof(uint16_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "commit_cpbuf_pop", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "commit_cpbuf_flush", sizeof(uint8_t), 1);

                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();

                this->tdb.update_signal<uint16_t>(trace::domain_t::status, "rptr", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::status, "wptr", 0, 0);

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_fetch_new_id", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpbuf_fetch_new_id_valid", 0, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "fetch_cpbuf_data.rat_phy_map_table_valid", 0, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "fetch_cpbuf_data.rat_phy_map_table_visible", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "fetch_cpbuf_data.global_history", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "fetch_cpbuf_data.local_history", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_cpbuf_push", 0, 0);


                for(auto i = 0;i < RENAME_WIDTH;i++)
                {
	                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_id", 65535, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_valid", 0, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::input, "rename_cpbuf_data.rat_phy_map_table_visible", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_data.global_history", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "rename_cpbuf_data.local_history", 0, i);
	                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_cpbuf_we", 0, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_rename_data.rat_phy_map_table_valid", 0, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_rename_data.rat_phy_map_table_visible", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_rename_data.global_history", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_rename_data.local_history", 0, i);
                }

                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "exbru_cpbuf_id", 65535, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_exbru_data.rat_phy_map_table_valid", 0, 0);
                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_exbru_data.rat_phy_map_table_visible", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_exbru_data.global_history", 0, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_exbru_data.local_history", 0, 0);


                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
	                this->tdb.update_signal<uint16_t>(trace::domain_t::input, "commit_cpbuf_id", 65535, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_valid", 0, i);
	                this->tdb.update_signal_bitmap_all(trace::domain_t::output, "cpbuf_commit_data.rat_phy_map_table_visible", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_commit_data.global_history", 0, i);
	                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_commit_data.local_history", 0, i);
	                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_cpbuf_pop", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_cpbuf_flush", 0, 0);

                this->tdb.update_signal<uint16_t>(trace::domain_t::output, "cpbuf_fetch_new_id", this->wptr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "cpbuf_fetch_new_id_valid", !is_full(), 0);
            }

            void trace_post()
            {
                this->tdb.update_signal<uint16_t>(trace::domain_t::status, "rptr", rptr + (rstage & 0x01) * size, 0);
                this->tdb.update_signal<uint16_t>(trace::domain_t::status, "wptr", wptr + (wstage & 0x01) * size, 0);
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

            trace::trace_database *get_tdb()
            {
                return &tdb;
            }

            bool push(checkpoint_t element, uint32_t *item_id)
            {
                *item_id = this->wptr;
                return fifo<checkpoint_t>::push(element);
            }

            checkpoint_t get_item(uint32_t item_id)
            {
                return this->buffer[item_id];
            }

            void set_item(uint32_t item_id, checkpoint_t &item)
            {
                this->buffer[item_id] = item;
            }

            void set_item_sync(uint32_t item_id, checkpoint_t &item)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::set_item;
                t_req.arg1 = item_id;
                t_req.arg2 = item;
                sync_request_q.push(t_req);
            }

            checkpoint_t get_front()
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
                checkpoint_t t;
                return fifo<checkpoint_t>::pop(&t);
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
                return ret;
            }
    };
}