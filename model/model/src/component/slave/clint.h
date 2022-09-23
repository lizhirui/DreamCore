#pragma once
#include "common.h"
#include "../slave_base.h"
#include "../interrupt_interface.h"

namespace component
{
    namespace slave
    {
        class clint : public slave_base
        {
            private:
                bool msip = false;
                uint64_t mtimecmp = 0;
                uint64_t mtime = 0;

                static const uint32_t MSIP_ADDR = 0x0; 
                static const uint32_t MTIMECMP_ADDR = 0x4000;
                static const uint32_t MTIME_ADDR = 0xBFF8;

                component::interrupt_interface *interrupt_interface;

                trace::trace_database tdb;

                virtual void _reset()
                {
                    msip = false;
                    mtimecmp = 0;
                    mtime = 0;

                    this->tdb.create(TRACE_DIR + "clint.tdb");
                    
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_read_addr_cur", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_write_addr", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_read_size_cur", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_write_size", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_data", sizeof(uint32_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_rd_cur", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::input, "bus_clint_wr", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::output, "clint_bus_data", sizeof(uint32_t), 1);

                    this->tdb.mark_signal(trace::domain_t::output, "all_intif_int_software_req", sizeof(uint8_t), 1);
                    this->tdb.mark_signal(trace::domain_t::output, "all_intif_int_timer_req", sizeof(uint8_t), 1);

                    this->tdb.write_metainfo();
                    this->tdb.trace_on();
                    this->tdb.capture_status();
                    this->tdb.write_row();
                }

            public:
                clint(component::interrupt_interface *interrupt_interface) : tdb(TRACE_CLINT)
                {
                    this->interrupt_interface = interrupt_interface;
                }

                void trace_pre()
                {
                    this->tdb.capture_input();

                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_clint_read_addr_cur", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_clint_write_addr", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_clint_read_size_cur", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_clint_write_size", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_clint_data", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_clint_rd_cur", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_clint_wr", 0, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "clint_bus_data", 0, 0);

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "all_intif_int_software_req", 0, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "all_intif_int_timer_req", 0, 0);
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
                    
                }

                virtual void _write16(uint32_t addr, uint16_t value)
                {
                    
                }

                virtual void _write32(uint32_t addr, uint32_t value)
                {
                    switch(addr)
                    {
                        case MSIP_ADDR:
                            msip = (value & 0x01) != 0;
                            break;

                        case MTIMECMP_ADDR:
                            mtimecmp = (mtimecmp & 0xFFFFFFFF00000000ULL) | value;
                            break;

                        case MTIMECMP_ADDR + 4:
                            mtimecmp = (mtimecmp & 0xFFFFFFFFULL) | (((uint64_t)value) << 32);
                            break;

                        case MTIME_ADDR:
                            mtime = (mtime & 0xFFFFFFFF00000000ULL) | value;
                            break;

                        case MTIME_ADDR + 4:
                            mtime = (mtime & 0xFFFFFFFFULL) | (((uint64_t)value) << 32);
                            break;
                    }
                }

                virtual uint8_t _read8(uint32_t addr)
                {
                    return 0;
                }

                virtual uint16_t _read16(uint32_t addr)
                {
                    return 0;
                }

                virtual uint32_t _read32(uint32_t addr)
                {
                    switch(addr)
                    {
                        case MSIP_ADDR:
                            return msip ? 1 : 0;

                        case MTIMECMP_ADDR:
                            return (uint32_t)(mtimecmp & 0xFFFFFFFFULL);

                        case MTIMECMP_ADDR + 4:
                            return (uint32_t)(mtimecmp >> 32);

                        case MTIME_ADDR:
                            return (uint32_t)(mtime & 0xFFFFFFFFULL);

                        case MTIME_ADDR + 4:
                            return (uint32_t)(mtime >> 32);

                        default:
                            return 0;
                    }
                }

                void run_pre()
                {
                    interrupt_interface->set_pending(riscv_interrupt_t::machine_timer, mtime >= mtimecmp);
                    interrupt_interface->set_pending(riscv_interrupt_t::machine_software, msip);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "all_intif_int_software_req", msip, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "all_intif_int_timer_req", mtime >= mtimecmp, 0);
                }

                void run_post()
                {
                    mtime++;
                }
        };
    }
}