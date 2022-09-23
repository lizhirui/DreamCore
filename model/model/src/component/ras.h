#include "common.h"
#include "config.h"
#include "stack.h"

namespace component
{
    typedef struct ras_item_t : public if_print_t
    {
        uint32_t addr;
        uint32_t cnt;
    }ras_item_t;

    class ras : component::stack<ras_item_t>
    {  
        private:
            uint32_t last_addr = 0;

            trace::trace_database tdb;

            ras_item_t get_item(uint32_t item_id)
            {
                return this->buffer[item_id];
            }

            void set_item(uint32_t item_id, ras_item_t item)
            {
                this->buffer[item_id] = item;
            }

            bool get_top_id(uint32_t *top_id)
            {
                if(this->is_empty())
                {
                    return false;
                }
                
                *top_id = this->top_ptr - 1;
                return true;
            }

            void throw_push(ras_item_t item)
            {
                for(uint32_t i = 1;i < this->top_ptr;i++)
                {
                    this->buffer[i - 1] = this->buffer[i];
                }

                this->buffer[this->top_ptr - 1] = item;
            }

        public:
            ras(uint32_t size) : component::stack<ras_item_t>(size), tdb(TRACE_RAS)
            {
                
            }

            virtual void reset()
            {
                last_addr = 0;
                component::stack<ras_item_t>::reset();

                this->tdb.create(TRACE_DIR + "ras.tdb");
                this->tdb.mark_signal(trace::domain_t::output, "ras_csrf_ras_full_add", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bp_ras_addr", sizeof(uint32_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bp_ras_push", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::input, "bp_ras_pop", sizeof(uint8_t), 1);
                this->tdb.mark_signal(trace::domain_t::output, "ras_bp_addr", sizeof(uint32_t), 1);
                this->tdb.write_metainfo();
                this->tdb.trace_on();
                this->tdb.capture_status();
                this->tdb.write_row();
            }

            void trace_pre()
            {
                this->tdb.capture_input();
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "ras_csrf_ras_full_add", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bp_ras_addr", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_ras_push", 0, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_ras_pop", 0, 0);
                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "ras_bp_addr", 0, 0);

                ras_item_t t_item;

                if(get_top(&t_item))
                {
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "ras_bp_addr", t_item.addr, 0);
                }
                else
                {
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "ras_bp_addr", last_addr, 0);
                }
            }

            void trace_post()
            {
                this->tdb.capture_output_status();
                this->tdb.write_row();
            }

            void push_addr(uint32_t addr)
            {
                ras_item_t t_item;

                if(get_top(&t_item) && (t_item.addr == addr) && (t_item.cnt < 0xFFFFFFFFU))
                {
                    t_item.cnt++;
                    uint32_t item_id = 0;
                    assert(get_top_id(&item_id));
                    set_item(item_id, t_item);
                }
                else
                {
                    t_item.addr = addr;
                    t_item.cnt = 1;

                    if(is_full())
                    {
                        ras_full_add();
                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "ras_csrf_ras_full_add", 1, 0);
                        throw_push(t_item);
                    }
                    else
                    {
                        push(t_item);
                    }
                }

                this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bp_ras_addr", addr, 0);
                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_ras_push", 1, 0);
            }

            uint32_t pop_addr()
            {
                ras_item_t t_item;

                this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_ras_pop", 1, 0);

                if(get_top(&t_item))
                {
                    if(t_item.cnt == 1)
                    {
                        last_addr = t_item.addr;
                        pop(&t_item);
                    }
                    else
                    {
                        t_item.cnt--;
                        uint32_t item_id = 0;
                        assert(get_top_id(&item_id));
                        set_item(item_id, t_item);
                    }

                    return t_item.addr;
                }
                else
                {
                    return last_addr;
                }
            }
    };
}