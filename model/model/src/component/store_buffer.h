#pragma once
#include "common.h"
#include "fifo.h"
#include "bus.h"
#include "../pipeline/commit.h"
#include "slave/memory.h"
#include "slave/clint.h"

namespace component
{
    typedef struct store_buffer_item_t : public if_print_t
    {
        bool enable;
        bool committed;
        uint32_t rob_id;
        uint32_t pc;
        uint32_t addr;
        uint32_t data;
        uint32_t size;
    }store_buffer_item_t;

    typedef struct store_buffer_state_pack_t
    {
        uint32_t wptr;
        bool wstage;
    }store_buffer_state_pack_t;

    class store_buffer : public fifo<store_buffer_item_t>
    {
        private:
            enum class sync_request_type_t
            {
                set_item,
                push,
                pop,
                restore
            };
            
            typedef struct sync_request_t
            {
                sync_request_type_t req;
                store_buffer_item_t arg1_store_buffer_item;
                store_buffer_state_pack_t arg1_store_buffer_state_pack;
            }sync_request_t;
            
            std::queue<sync_request_t> sync_request_q;

            bus *bus_if;

            trace::trace_database tdb;

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

            store_buffer_item_t get_item(uint32_t id)
            {
                assert(check_id_valid(id));
                return this->buffer[id];
            }
            
            void set_item(uint32_t id, store_buffer_item_t value)
            {
                assert(check_id_valid(id));
                this->buffer[id] = value;
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

            bool get_front_id_stage(uint32_t *front_id, bool *front_stage)
            {
                if(this->is_empty())
                {
                    return false;
                }
                
                *front_id = this->rptr;
                *front_stage = this->rstage;
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
            
            bool get_next_id(uint32_t id, uint32_t *next_id)
            {
                assert(check_id_valid(id));
                *next_id = (id + 1) % this->size;
                return check_id_valid(*next_id);
            }

            bool get_next_id_stage(uint32_t id, bool stage, uint32_t *next_id, bool *next_stage)
            {
                assert(check_id_valid(id));
                *next_id = (id + 1) % this->size;
                *next_stage = ((id + 1) >= this->size) != stage;
                return check_id_valid(*next_id);
            }
        
        public:
            store_buffer(uint32_t size, bus *bus_if) : fifo<store_buffer_item_t>(size), tdb(TRACE_STORE_BUFFER)
            {
                this->bus_if = bus_if;
            }

            virtual void reset()
            {
                fifo<store_buffer_item_t>::reset();
                clear_queue(sync_request_q);

                this->tdb.create(TRACE_DIR + "store_buffer.tdb");

                this->tdb.mark_signal(trace::domain_t::status, "rptr", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::status, "wptr", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "issue_stbuf_read_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "issue_stbuf_read_size", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "issue_stbuf_rd", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_exlsu_bus_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_exlsu_bus_data_feedback", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_exlsu_bus_ready", sizeof(uint32_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "exlsu_stbuf_rob_id", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exlsu_stbuf_write_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exlsu_stbuf_write_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exlsu_stbuf_write_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "exlsu_stbuf_push", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_exlsu_full", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_read_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_write_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_read_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_write_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_read_req", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "stbuf_bus_write_req", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bus_stbuf_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bus_stbuf_read_ack", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bus_stbuf_write_ack", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", sizeof(uint8_t), COMMIT_WIDTH);
                this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", sizeof(uint8_t), COMMIT_WIDTH);

                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();
                                
                this->tdb.update_signal<uint8_t>(trace::domain_t::status, "rptr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::status, "wptr", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "issue_stbuf_read_size", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "issue_stbuf_rd", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_data_feedback", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_ready", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_rob_id", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exlsu_stbuf_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_write_size", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exlsu_stbuf_write_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_push", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_exlsu_full", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_read_addr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_size", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_write_size", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_read_req", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_write_req", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_stbuf_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_stbuf_read_ack", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_stbuf_write_ack", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);
                
                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", 0, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_exlsu_full", is_full(), 0);
            }

            void trace_post()
            {
                this->tdb.update_signal<uint8_t>(trace::domain_t::status, "rptr", rptr + (rstage & 0x01) * size, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::status, "wptr", wptr + (wstage & 0x01) * size, 0);
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

            trace::trace_database *get_tdb()
            {
                return &tdb;
            }

            store_buffer_state_pack_t save()
            {
                store_buffer_state_pack_t pack;
                
                pack.wptr = wptr;
                pack.wstage = wstage;
                return pack;
            }

            void restore(store_buffer_state_pack_t pack)
            {
                wptr = pack.wptr;
                wstage = pack.wstage;
            }

            void restore_sync(store_buffer_state_pack_t pack)
            {
                sync_request_t item;

                item.req = sync_request_type_t::restore;
                item.arg1_store_buffer_state_pack = pack;
                sync_request_q.push(item);
            }
            
            void push_sync(store_buffer_item_t element)
            {
                sync_request_t item;

                item.req = sync_request_type_t::push;
                item.arg1_store_buffer_item = element;
                sync_request_q.push(item);

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_rob_id", element.rob_id, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exlsu_stbuf_write_addr", element.addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_write_size", element.size, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "exlsu_stbuf_write_data", element.data, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "exlsu_stbuf_push", 1, 0);
            }
            
            void pop_sync()
            {
                sync_request_t item;
                    
                item.req = sync_request_type_t::pop;
                sync_request_q.push(item);
            }

            uint32_t get_feedback_value(uint32_t addr, uint32_t size, uint32_t bus_value)
            {
                uint32_t result = bus_value;
                uint32_t cur_id;
                
                if(get_front_id(&cur_id))
                {
                    auto first_id = cur_id;

                    do
                    {
                        auto cur_item = get_item(cur_id);

                        if((cur_item.addr >= addr) && (cur_item.addr < (addr + size)))
                        {
                            uint32_t bit_offset = (cur_item.addr - addr) << 3;
                            uint32_t bit_length = std::min(cur_item.size, addr + size - cur_item.addr) << 3;
                            uint32_t bit_mask = (bit_length == 32) ? 0xffffffffu : ((1 << bit_length) - 1);
                            result &= ~(bit_mask << bit_offset);
                            result |= (cur_item.data & bit_mask) << bit_offset;
                        }
                        else if((cur_item.addr < addr) && ((cur_item.addr + cur_item.size) > addr))
                        {
                            uint32_t bit_offset = (addr - cur_item.addr) << 3;
                            uint32_t bit_length = std::min(size, cur_item.addr + cur_item.size - addr) << 3;
                            uint32_t bit_mask = (bit_length == 32) ? 0xffffffffu : ((1 << bit_length) - 1);
                            result &= ~bit_mask;
                            result |= (cur_item.data >> bit_offset) & bit_mask;
                        }
                    }while(get_next_id(cur_id, &cur_id) && (cur_id != first_id));
                }

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_data", bus_value, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_data_feedback", result, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_exlsu_bus_ready", 1, 0);  

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_stbuf_data", bus_value, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_stbuf_read_ack", 1, 0);
                return result;
            }

            void run(pipeline::commit_feedback_pack_t commit_feedback_pack)
            {
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);

                for(auto i = 0;i < COMMIT_WIDTH;i++)
                {
	                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id", commit_feedback_pack.committed_rob_id[i], i);
	                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.committed_rob_id_valid", commit_feedback_pack.committed_rob_id_valid[i], i);
                }

                if(commit_feedback_pack.enable && commit_feedback_pack.flush)
                {
                    uint32_t cur_id;
                    bool cur_stage;
                    bool found = false;
                    uint32_t found_id;
                    bool found_stage;

                    if(get_front_id_stage(&cur_id, &cur_stage))
                    {
                        auto first_id = cur_id;

                        do
                        {
                            auto cur_item = get_item(cur_id);

                            if(!cur_item.committed)
                            {
                                bool ready_to_commit = false;

                                if(commit_feedback_pack.enable)
                                {
                                    for(auto i = 0;i < COMMIT_WIDTH;i++)
                                    {
                                        if(commit_feedback_pack.committed_rob_id_valid[i] && (commit_feedback_pack.committed_rob_id[i] == cur_item.rob_id))
                                        {
                                            ready_to_commit = true;
                                            break;
                                        }
                                    }
                                }

                                if(!ready_to_commit)
                                {
                                    found = true;
                                    found_id = cur_id;
                                    found_stage = cur_stage;
                                    break;
                                }
                            }
                        }while(get_next_id_stage(cur_id, cur_stage, &cur_id, &cur_stage) && (cur_id != first_id));

                        if(found)
                        {
                            wptr = found_id;
                            wstage = found_stage;
                        }
                    }

                    clear_queue(sync_request_q);
                }
                else
                {
                    //handle write back
                    store_buffer_item_t item;

                    if(get_front(&item))
                    {
                        if(item.committed)
                        {
                            store_buffer_item_t t_item;
                            pop(&t_item);
                            assert((item.size == 1) || (item.size == 2) || (item.size == 4));

                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_write_addr", item.addr, 0);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_write_size", item.size, 0);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "stbuf_bus_data", item.data, 0);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "stbuf_bus_write_req", 1, 0);

                            bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "stbuf_bus_write_addr", item.addr, 0);
                            bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_write_size", item.size, 0);
                            bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "stbuf_bus_data", item.data, 0);                        
                            bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_write_req", 1, 0);
						    bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_stbuf_write_ack_next", 1, 0);

                            switch(bus_if->find_slave_info(item.addr))
                            {
                                case 0://memory
                                    bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_stbuf_write_addr", bus_if->convert_to_slave_addr(item.addr), 0);
                                    bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_write_size", item.size, 0);
                                    bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_stbuf_data", item.data, 0);
                                    bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_wr", 1, 0);

                                    {
                                        component::slave::memory *obj = (component::slave::memory *)bus_if->get_slave_obj(item.addr);
                                        obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_stbuf_write_addr", bus_if->convert_to_slave_addr(item.addr), 0);
                                        obj->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_write_size", item.size, 0);
                                        obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_stbuf_data", item.data, 0);
                                        obj->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_wr", 1, 0);
                                    }

                                    break;

                                case 1://clint
                                    bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_clint_write_addr", bus_if->convert_to_slave_addr(item.addr), 0);
                                    bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_clint_write_size", item.size, 0);
                                    bus_if->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_clint_data", item.data, 0);
                                    bus_if->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_clint_wr", 1, 0);

                                    {
                                        component::slave::clint *obj = (component::slave::clint *)bus_if->get_slave_obj(item.addr);
                                        obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "bus_clint_write_addr", bus_if->convert_to_slave_addr(item.addr), 0);
                                        obj->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "bus_clint_write_size", item.size, 0);
                                        obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "bus_clint_data", item.data, 0);
                                        obj->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "bus_clint_wr", 1, 0);
                                    }

                                    break;
                            }

                            switch(item.size)
                            {
                                case 1:
                                    bus_if->write8_sync(item.addr, (uint8_t)item.data);
                                    break;

                                case 2:
                                    bus_if->write16_sync(item.addr, (uint16_t)item.data);
                                    break;

                                case 4:
                                    bus_if->write32_sync(item.addr, item.data);
                                    break;
                            }
                        }
                    }
                }

                //handle feedback
                if(commit_feedback_pack.enable)
                {
                    uint32_t cur_id;

                    if(get_front_id(&cur_id))
                    {
                        auto first_id = cur_id;

                        do
                        {
                            auto cur_item = get_item(cur_id);

                            for(auto i = 0;i < COMMIT_WIDTH;i++)
                            {
                                if(commit_feedback_pack.committed_rob_id_valid[i] && (commit_feedback_pack.committed_rob_id[i] == cur_item.rob_id))
                                {
                                    cur_item.committed = true;
                                }
                            }

                            set_item(cur_id, cur_item);
                        }while(get_next_id(cur_id, &cur_id) && (cur_id != first_id));
                    }
                }
            }
            
            void sync()
            {
                while(!sync_request_q.empty())
                {
                    auto item = sync_request_q.front();
                    sync_request_q.pop();
                    
                    switch(item.req)
                    {
                        case sync_request_type_t::push:
                            this->push(item.arg1_store_buffer_item);
                            break;
                            
                        case sync_request_type_t::pop:
                        {
                            store_buffer_item_t v;
                            this->pop(&v);
                            break;
                        }

                        case sync_request_type_t::restore:
                            this->restore(item.arg1_store_buffer_state_pack);
                            break;
                    }
                }
            }
    };
}
