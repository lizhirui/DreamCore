#pragma once
#include "common.h"
#include "config.h"
#include "csrfile.h"
#include "csr_all.h"

namespace component
{
    class interrupt_interface : public if_reset_t
    {
        private:
            enum class sync_request_type_t
            {
                set_ack
            };
            
            typedef struct sync_request_t
            {
                sync_request_type_t req;
                riscv_interrupt_t cause;
            }sync_request_t;
            
            std::queue<sync_request_t> sync_request_q;

            bool meip = false;
            bool msip = false;
            bool mtip = false;
            bool mei_ack = false;
            bool msi_ack = false;
            bool mti_ack = false;

            csrfile *csr_file;

            trace::trace_database tdb;

        public:
            interrupt_interface(csrfile *csr_file) : tdb(TRACE_INTERRUPT_INTERFACE)
            {
                this->csr_file = csr_file;
            }

            virtual void reset()
            {
                mei_ack = false;
                msi_ack = false;
                mti_ack = false;

                this->tdb.create(TRACE_DIR + "interrupt_interface.tdb");

                this->tdb.mark_signal(trace::domain_t::input, "all_intif_int_ext_req", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "all_intif_int_software_req", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "all_intif_int_timer_req", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::output, "intif_all_int_ext_ack", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "intif_all_int_software_ack", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "intif_all_int_timer_ack", sizeof(uint8_t), 1);

                this->tdb.mark_signal(trace::domain_t::input, "csrf_all_mie_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "csrf_all_mstatus_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "csrf_all_mip_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "intif_csrf_mip_data", sizeof(uint32_t), 1);
                
                this->tdb.mark_signal(trace::domain_t::output, "intif_commit_has_interrupt", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "intif_commit_mcause_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "intif_commit_ack_data", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "commit_intif_ack_data", sizeof(uint32_t), 1);

                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_ext_req", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_software_req", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_timer_req", 0, 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_ext_ack", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_software_ack", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_timer_ack", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mie_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mstatus_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mip_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_csrf_mip_data", 0, 0);
                
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_commit_has_interrupt", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_commit_mcause_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_commit_ack_data", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_intif_ack_data", 0, 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mie_data", csr_file->read_sys(CSR_MIE), 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mstatus_data", csr_file->read_sys(CSR_MSTATUS), 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "csrf_all_mip_data", csr_file->read_sys(CSR_MIP), 0);
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

            bool get_cause(riscv_interrupt_t *cause)
            {
                csr::mie mie;
                csr::mstatus mstatus;
                mie.load(csr_file->read_sys(CSR_MIE));
                mstatus.load(csr_file->read_sys(CSR_MSTATUS));

                if(!mstatus.get_mie())
                {
                    return false;
                }

                if(meip && mie.get_meie())
                {
                    *cause = riscv_interrupt_t::machine_external;
                }
                else if(msip && mie.get_msie())
                {
                    *cause = riscv_interrupt_t::machine_software;
                }
                else if(mtip && mie.get_mtie())
                {
                    *cause = riscv_interrupt_t::machine_timer;
                }
                else
                {
                    return false;
                }

                return true;
            }

            bool has_interrupt()
            {
                csr::mie mie;
                csr::mstatus mstatus;
                mie.load(csr_file->read_sys(CSR_MIE));
                mstatus.load(csr_file->read_sys(CSR_MSTATUS));
                return mstatus.get_mie() && ((meip && mie.get_meie()) || (msip && mie.get_msie()) || (mtip && mie.get_mtie()));
            }

            void set_pending(riscv_interrupt_t cause, bool pending)
            {
                switch(cause)
                {
                    case riscv_interrupt_t::machine_external:
                        meip = pending;
                        break;

                    case riscv_interrupt_t::machine_software:
                        msip = pending;
                        break;

                    case riscv_interrupt_t::machine_timer:
                        mtip = pending;
                        break;
                }
            }

            void set_ack(riscv_interrupt_t cause)
            {
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_intif_ack_data", 1U << ((uint32_t)cause), 0);

                switch(cause)
                {
                    case riscv_interrupt_t::machine_external:
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_ext_ack", 1, 0);
                        mei_ack = true;
                        break;

                    case riscv_interrupt_t::machine_software:
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_software_ack", 1, 0);
                        msi_ack = true;
                        break;

                    case riscv_interrupt_t::machine_timer:
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_all_int_timer_ack", 1, 0);
                        mti_ack = true;
                        break;
                }
            }

            void set_ack_sync(riscv_interrupt_t cause)
            {
                sync_request_t t_req;
                t_req.req = sync_request_type_t::set_ack;
                t_req.cause = cause;
                sync_request_q.push(t_req);
            }

            bool get_ack(riscv_interrupt_t cause)
            {
                switch(cause)
                {
                    case riscv_interrupt_t::machine_external:
                        return mei_ack;

                    case riscv_interrupt_t::machine_software:
                        return msi_ack;

                    case riscv_interrupt_t::machine_timer:
                        return mti_ack;

                    default:
                        return false;
                }
            }

            void run()
            {
                mei_ack = false;
                msi_ack = false;
                mti_ack = false;
                csr::mip mip;
                mip.load(csr_file->read_sys(CSR_MIP));
                mip.set_meip(meip);
                mip.set_msip(msip);
                mip.set_mtip(mtip);
                csr_file->write_sys_sync(CSR_MIP, mip.get_value());
                csr_file->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "intif_csrf_mip_data", mip.get_value(), 0);

                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_csrf_mip_data", mip.get_value(), 0);

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_ext_req", meip, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_software_req", msip, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "all_intif_int_timer_req", mtip, 0);

                {
                    riscv_interrupt_t t;

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "intif_commit_has_interrupt", get_cause(&t), 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_commit_mcause_data", (uint32_t)t, 0);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "intif_commit_ack_data", 1U << ((uint32_t)t), 0);
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
                        case sync_request_type_t::set_ack:
                            set_ack(item.cause);
                            break;
                    }
                }
            }
    };
}