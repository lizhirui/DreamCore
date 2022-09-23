#pragma once
#include "common.h"
#include "config.h"
#include "slave_base.h"

namespace component
{
    typedef struct slave_info_t
    {
        uint32_t base;
        uint32_t size;
        std::shared_ptr<slave_base> slave;
    }slave_info_t;

    class bus : public if_reset_t
    {
        private:
            enum class sync_request_type_t
            {
                write8,
                write16,
                write32
            };

            typedef struct sync_request_t
            {
                sync_request_type_t req;
                uint32_t arg1;
                union
                {
                    uint8_t u8;
                    uint16_t u16;
                    uint32_t u32;
                }arg2;
            }sync_request_t;

            std::queue<sync_request_t> sync_request_q;
            std::vector<slave_info_t> slave_info_list;
            
            trace::trace_database tdb;

            bool check_addr_override(uint32_t base, uint32_t size)
            {
                for(auto i = 0;i < slave_info_list.size();i++)
                {
                    if(((base >= slave_info_list[i].base) && (base < (slave_info_list[i].base + slave_info_list[i].size))) || ((base < slave_info_list[i].base) && ((base + size) > slave_info_list[i].base)))
                    {
                        return true;
                    }
                }

                return false;
            }

        public:
            bus() : tdb(TRACE_BUS)
            {
            
            }

            int find_slave_info(uint32_t addr)
            {
                for(auto i = 0;i < slave_info_list.size();i++)
                {
                    if((addr >= slave_info_list[i].base) && (addr < (slave_info_list[i].base + slave_info_list[i].size)))
                    {
                        return i;
                    }
                }

                return -1;
            }

            slave_base *get_slave_obj(uint32_t addr)
            {
                int slave_id = find_slave_info(addr);

                if(slave_id >= 0)
                {
                    return slave_info_list[slave_id].slave.get();
                }

                return NULL;
            }

            uint32_t convert_to_slave_addr(uint32_t addr)
            {
                int slave_id = find_slave_info(addr);
                uint32_t result = addr;

                if(slave_id >= 0)
                {
                    result = addr - slave_info_list[slave_id].base;
                }

                return result;
            }

            void map(uint32_t base, uint32_t size, std::shared_ptr<slave_base> slave)
            {
                assert(!check_addr_override(base, size));
                slave_info_t slave_info;
                slave_info.base = base;
                slave_info.size = size;
                slave_info.slave = slave;
                slave->init(size);
                slave_info_list.push_back(slave_info);
            }

            virtual void reset()
            {
                clear_queue(sync_request_q);

                this->tdb.create(TRACE_DIR + "bus.tdb");
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bus_addr_cur", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "fetch_bus_read_req_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_fetch_data", sizeof(uint32_t), FETCH_WIDTH);
                this->tdb.mark_signal(trace::domain_t::output, "bus_fetch_read_ack", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_read_addr_cur", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_write_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_read_size_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_write_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_read_req_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "stbuf_bus_write_req", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_stbuf_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_stbuf_read_ack", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_stbuf_write_ack_next", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_fetch_addr_cur", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_fetch_rd_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "tcm_bus_fetch_data", sizeof(uint32_t), FETCH_WIDTH);

                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_read_addr_cur", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_write_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_read_size_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_write_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_rd_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_tcm_stbuf_wr", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "tcm_bus_stbuf_data", sizeof(uint32_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_read_addr_cur", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_write_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_read_size_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_write_size", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_rd_cur", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "bus_clint_wr", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "clint_bus_data", sizeof(uint32_t), 1);
                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_bus_addr_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_bus_read_req_cur", 0, 0);
                
                for(auto i = 0;i < FETCH_WIDTH;i++)
                {
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_fetch_data", 0, i);
                }

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_fetch_read_ack", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "stbuf_bus_read_addr_cur", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "stbuf_bus_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_read_size_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_write_size", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "stbuf_bus_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_read_req_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_bus_write_req", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_stbuf_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_stbuf_read_ack", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_stbuf_write_ack_next", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_fetch_addr_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_fetch_rd_cur", 0, 0);
                
                for(auto i = 0;i < FETCH_WIDTH;i++)
                {
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "tcm_bus_fetch_data", 0, i);
                }

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_stbuf_read_addr_cur", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_stbuf_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_read_size_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_write_size", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_stbuf_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_rd_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_stbuf_wr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "tcm_bus_stbuf_data", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_clint_read_addr_cur", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_clint_write_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_clint_read_size_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_clint_write_size", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "bus_clint_data", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_clint_rd_cur", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "bus_clint_wr", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "clint_bus_data", 0, 0);
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

            bool check_align(uint32_t addr, uint32_t access_size)
            {
                return !(addr & (access_size - 1));
            }
            
            void write8(uint32_t addr, uint8_t value)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    slave_info_list[slave_index].slave->write8(addr - slave_info_list[slave_index].base, value);
                }
            }

            void write8_sync(uint32_t addr, uint8_t value)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::write8;
                t_req.arg1 = addr;
                t_req.arg2.u8 = value;
                sync_request_q.push(t_req);
            }

            void write16(uint32_t addr, uint16_t value)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    slave_info_list[slave_index].slave->write16(addr - slave_info_list[slave_index].base, value);
                }
            }

            void write16_sync(uint32_t addr, uint16_t value)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::write16;
                t_req.arg1 = addr;
                t_req.arg2.u16 = value;
                sync_request_q.push(t_req);
            }

            void write32(uint32_t addr, uint32_t value)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    slave_info_list[slave_index].slave->write32(addr - slave_info_list[slave_index].base, value);
                }
            }

            void write32_sync(uint32_t addr, uint32_t value)
            {
                sync_request_t t_req;

                t_req.req = sync_request_type_t::write32;
                t_req.arg1 = addr;
                t_req.arg2.u32 = value;
                sync_request_q.push(t_req);
            }

            uint8_t read8(uint32_t addr)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    return slave_info_list[slave_index].slave->read8(addr - slave_info_list[slave_index].base);
                }
                
                return 0;
            }

            uint16_t read16(uint32_t addr)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    return slave_info_list[slave_index].slave->read16(addr - slave_info_list[slave_index].base);
                }
                
                return 0;
            }

            uint32_t read32(uint32_t addr)
            {
                if(auto slave_index = find_slave_info(addr);slave_index >= 0)
                {
                    return slave_info_list[slave_index].slave->read32(addr - slave_info_list[slave_index].base);
                }
                
                return 0;
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
                        case sync_request_type_t::write8:
                            write8(t_req.arg1, t_req.arg2.u8);
                            break;

                        case sync_request_type_t::write16:
                            write16(t_req.arg1, t_req.arg2.u16);
                            break;

                        case sync_request_type_t::write32:
                            write32(t_req.arg1, t_req.arg2.u32);
                            break;
                    }
                }
            }
    };
}