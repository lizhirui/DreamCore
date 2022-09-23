#pragma once
#include "common.h"
#include "../slave_base.h"

namespace component
{
    namespace slave
    {
        class memory : public slave_base
        {
            private:
                uint8_t *mem;

                trace::trace_database tdb;

                virtual void _init()
                {
                    mem = new uint8_t[this->size]();
                    memset(mem, 0, this->size);
                }

                virtual void _reset()
                {
                    this->tdb.create(TRACE_DIR + "tcm.tdb");
                    
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_fetch_addr_cur", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_fetch_rd_cur", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::output, "tcm_bus_fetch_data", sizeof(uint32_t), FETCH_WIDTH);

                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_read_addr_cur", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_write_addr", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_read_size_cur", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_write_size", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_data", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_rd_cur", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_tcm_stbuf_wr", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::output, "tcm_bus_stbuf_data", sizeof(uint32_t), 1);

                    this->tdb.write_metainfo();
                    this->tdb.trace_on();
                    this->tdb.capture_status();
                    this->tdb.write_row();
                }

            public:
                memory() : tdb(TRACE_TCM)
                {
                
                }

                ~memory()
                {
                    delete[] mem;
                }

                void trace_pre()
                {
                    this->tdb.capture_input();

                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_fetch_addr_cur", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_fetch_rd_cur", 0, 0);
                    
                    for(auto i = 0;i < FETCH_WIDTH;i++)
                    {
                        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "tcm_bus_fetch_data", 0, i);
                    }

                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_stbuf_read_addr_cur", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_stbuf_write_addr", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_read_size_cur", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_write_size", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_stbuf_data", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_rd_cur", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_stbuf_wr", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "tcm_bus_stbuf_data", 0, 0);
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

                virtual void _write8(uint32_t addr, uint8_t value)
                {
                    mem[addr] = value;
                }

                virtual void _write16(uint32_t addr, uint16_t value)
                {
                    *(uint16_t *)(mem + addr) = value;
                }

                virtual void _write32(uint32_t addr, uint32_t value)
                {
                    *(uint32_t *)(mem + addr) = value;
                }

                virtual uint8_t _read8(uint32_t addr)
                {
                    return mem[addr];
                }

                virtual uint16_t _read16(uint32_t addr)
                {
                    return *(uint16_t *)(mem + addr);
                }

                virtual uint32_t _read32(uint32_t addr)
                {
                    return *(uint32_t *)(mem + addr);
                }
        };
    }
}