#include "common.h"
#include "fetch.h"
#include "../component/fifo.h"
#include "../component/bus.h"
#include "../component/slave/memory.h"
#include "execute/bru.h"
#include "fetch_decode.h"

namespace pipeline
{
    fetch::fetch(component::bus *bus, component::fifo<fetch_decode_pack_t> *fetch_decode_fifo, component::checkpoint_buffer *checkpoint_buffer, component::branch_predictor *branch_predictor, component::store_buffer *store_buffer, uint32_t init_pc) : tdb(TRACE_FETCH)
    {
        this->bus = bus;
        this->fetch_decode_fifo = fetch_decode_fifo;
        this->checkpoint_buffer = checkpoint_buffer;
        this->branch_predictor = branch_predictor;
        this->store_buffer = store_buffer;
        this->init_pc = init_pc;
        this->pc = init_pc;
        this->jump_wait = false;
    }

    void fetch::reset()
    {
        this->pc = init_pc;
        this->jump_wait = false;
        this->wait_first_memory_result = true;

        this->tdb.create(TRACE_DIR + "fetch.tdb");
        this->tdb.bind_signal(trace::domain_t::status, "pc", &this->pc, sizeof(this->pc), 1);
        this->tdb.bind_signal(trace::domain_t::status, "jump_wait", &this->jump_wait, sizeof(this->jump_wait), 1);

        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_update_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_update_instruction", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_update_jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_update_next_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_update_valid", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_instruction", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bp_valid", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "bp_fetch_jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "bp_fetch_next_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "bp_fetch_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "bp_fetch_global_history", sizeof(uint16_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "bp_fetch_local_history", sizeof(uint16_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "fetch_bus_addr_cur", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_bus_read_req_cur", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "bus_fetch_data", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "bus_fetch_read_ack", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "fetch_csrf_checkpoint_buffer_full_add", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_csrf_fetch_not_full_add", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_csrf_fetch_decode_fifo_full_add", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_fetch_new_id", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "cpbuf_fetch_new_id_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_cpbuf_data.global_history", sizeof(uint16_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_cpbuf_data.local_history", sizeof(uint16_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_cpbuf_push", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "stbuf_all_empty", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_in_enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.enable", sizeof(uint8_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.value", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.pc", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.has_exception", sizeof(uint8_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_id", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_value", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted", sizeof(uint8_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_jump", sizeof(uint8_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_next_pc", sizeof(uint32_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id", sizeof(uint16_t), FETCH_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_in_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "decode_feedback_pack.idle", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "rename_feedback_pack.idle", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.has_exception", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.exception_pc", sizeof(uint32_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.jump_enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.jump", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.next_pc", sizeof(uint32_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    void fetch::run(decode_feedback_pack_t decode_feedback_pack, rename_feedback_pack_t rename_feedback_pack, commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();

        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_pc", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_instruction", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_update_jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_next_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_update_valid", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_pc", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_instruction", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_fetch_jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bp_fetch_next_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_fetch_valid", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::input, "bp_fetch_global_history", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::input, "bp_fetch_local_history", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bus_addr_cur", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bus_read_req_cur", 0, 0);
        
        for(auto i = 0;i < FETCH_WIDTH;i++)
        {
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_fetch_data", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_fetch_read_ack", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_checkpoint_buffer_full_add", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_fetch_not_full_add", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_fetch_decode_fifo_full_add", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "cpbuf_fetch_new_id", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "cpbuf_fetch_new_id_valid", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_cpbuf_data.global_history", 0, 0);
        this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_cpbuf_data.local_history", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_cpbuf_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_all_empty", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_in_enable", 0, 0);

        for(auto i = 0;i < FETCH_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_flush", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_feedback_pack.idle", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_feedback_pack.idle", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.has_exception", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.exception_pc", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump_enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump", 0, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.next_pc", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "stbuf_all_empty", store_buffer->is_empty(), 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_feedback_pack.idle", decode_feedback_pack.idle, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "rename_feedback_pack.idle", rename_feedback_pack.idle, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.has_exception", commit_feedback_pack.has_exception, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.exception_pc", commit_feedback_pack.exception_pc, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump_enable", commit_feedback_pack.jump_enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.jump", commit_feedback_pack.jump, 0);
        this->tdb.update_signal<uint32_t>(trace::domain_t::input, "commit_feedback_pack.next_pc", commit_feedback_pack.next_pc, 0);

        if(wait_first_memory_result)
        {
            wait_first_memory_result = false;
        }
        else
        {
            if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
            {
                if(jump_wait)
                {
                    if(commit_feedback_pack.jump_enable)
                    {
                        this->jump_wait = false;

                        if(commit_feedback_pack.jump)
                        {
                            this->pc = commit_feedback_pack.next_pc;
                        }
                    }
                }
                else
                {
                    uint32_t old_pc = this->pc;
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bus_addr_cur", old_pc, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bus_read_req_cur", 1, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bus_fetch_read_ack", 1, 0);

                    bus->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "fetch_bus_addr_cur", old_pc, 0);
                    bus->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "fetch_bus_read_req_cur", 1, 0);
                    bus->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_fetch_read_ack", 1, 0);

                    for(auto i = 0;i < FETCH_WIDTH;i++)
                    {
                        bus->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_fetch_data", bus->read32(old_pc + i * 4), i);
                    }

                    bus->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "bus_tcm_fetch_addr_cur", bus->convert_to_slave_addr(old_pc), 0);
                    bus->get_tdb()->update_signal<uint8_t>(trace::domain_t::output, "bus_tcm_fetch_rd_cur", bus->find_slave_info(old_pc) == 0, 0);

                    {
                        component::slave::memory *obj = (component::slave::memory *)bus->get_slave_obj(old_pc);

                        if(obj != NULL)
                        {
                            obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "bus_tcm_fetch_addr_cur", bus->convert_to_slave_addr(old_pc), 0);
                            obj->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "bus_tcm_fetch_rd_cur", bus->find_slave_info(old_pc) == 0, 0);
                    
                            for(auto i = 0;i < FETCH_WIDTH;i++)
                            {
                                obj->get_tdb()->update_signal<uint32_t>(trace::domain_t::output, "tcm_bus_fetch_data", bus->read32(old_pc + i * 4), i);
                            }
                        }
                    }
                
                    for(auto i = 0;i < FETCH_WIDTH;i++)
                    {
                        bus->get_tdb()->update_signal<uint32_t>(trace::domain_t::input, "tcm_bus_fetch_data", bus->read32(old_pc + i * 4), i);
                    }

                    for(auto i = 0;i < FETCH_WIDTH;i++)
                    {
                        this->tdb.update_signal_bit<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_in_enable", !this->fetch_decode_fifo->is_full(), i, 0);

                        if(!this->fetch_decode_fifo->is_full())
                        {
                            fetch_decode_pack_t t_fetch_decode_pack;
                            memset(&t_fetch_decode_pack, 0, sizeof(t_fetch_decode_pack));

                            uint32_t cur_pc = old_pc + i * 4;
                            bool has_exception = !bus->check_align(cur_pc, 4);
                            uint32_t opcode = has_exception ? 0 : this->bus->read32(cur_pc);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bus_fetch_data", opcode, i);
                            bool jump = ((opcode & 0x7f) == 0x6f) || ((opcode & 0x7f) == 0x67) || ((opcode & 0x7f) == 0x63) || (opcode == 0x30200073);
                            bool fence_i = ((opcode & 0x7f) == 0x0f) && (((opcode >> 12) & 0x07) == 0x01);

                            if(fence_i && ((i != 0) || (!decode_feedback_pack.idle) || (!rename_feedback_pack.idle) || commit_feedback_pack.enable || (!store_buffer->is_empty())))
                            {
                                break;
                            }

                            if(jump)
                            {
                                uint32_t jump_next_pc = 0;
                                bool jump_result = false;

                                if(branch_predictor->get_prediction(cur_pc, opcode, &jump_result, &jump_next_pc))
                                {
                                    component::checkpoint_t cp;
                                    branch_predictor->save(cp, cur_pc);
                                    t_fetch_decode_pack.checkpoint_id_valid = checkpoint_buffer->push(cp, &t_fetch_decode_pack.checkpoint_id);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "cpbuf_fetch_new_id", t_fetch_decode_pack.checkpoint_id, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "cpbuf_fetch_new_id_valid", t_fetch_decode_pack.checkpoint_id_valid, 0);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_cpbuf_data.global_history", cp.global_history, 0);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_cpbuf_data.local_history", cp.local_history, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_cpbuf_push", 1, 0);
                                
                                    checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "fetch_cpbuf_data.global_history", cp.global_history, 0);
                                    checkpoint_buffer->get_tdb()->update_signal<uint16_t>(trace::domain_t::input, "fetch_cpbuf_data.local_history", cp.local_history, 0);
                                    checkpoint_buffer->get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "fetch_cpbuf_push", 1, 0);

                                    branch_predictor->update_prediction_guess(cur_pc, opcode, jump_result, jump_next_pc);

                                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_fetch_jump", jump_result, 0);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "bp_fetch_next_pc", jump_next_pc, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "bp_fetch_valid", 1, 0);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "bp_fetch_global_history", cp.global_history, 0);
                                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "bp_fetch_local_history", cp.local_history, 0);

                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_pc", cur_pc, 0);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_instruction", opcode, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_update_jump", jump_result, 0);
                                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_update_next_pc", jump_next_pc, 0);
                                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_update_valid", 1, 0);
                                
                                    if(!t_fetch_decode_pack.checkpoint_id_valid)
                                    {
                                        checkpoint_buffer_full_add();
                                        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_checkpoint_buffer_full_add", 1, 0);
                                        this->jump_wait = true;
                                        this->pc = cur_pc + 4;
                                    }
                                    else
                                    {
                                        t_fetch_decode_pack.predicted = true;
                                        t_fetch_decode_pack.predicted_jump = jump_result;
                                        t_fetch_decode_pack.predicted_next_pc = jump_next_pc;
                                        uint32_t next_pc = jump_result ? jump_next_pc : (cur_pc + 4);

                                        this->pc = next_pc;
                                        this->jump_wait = false;
                                    }
                                }
                                else
                                {
                                    this->jump_wait = true;
                                    this->pc = cur_pc + 4;
                                }

                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_pc", cur_pc, 0);
                                this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_bp_instruction", opcode, 0);
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_bp_valid", 1, 0);
                            }
                            else
                            {
                                this->pc = cur_pc + 4;
                            }

                            t_fetch_decode_pack.value = opcode;
                            t_fetch_decode_pack.enable = true;
                            t_fetch_decode_pack.pc = cur_pc;
                            t_fetch_decode_pack.has_exception = has_exception;
                            t_fetch_decode_pack.exception_id = !bus->check_align(cur_pc, 4) ? riscv_exception_t::instruction_address_misaligned : riscv_exception_t::instruction_access_fault;
                            t_fetch_decode_pack.exception_value = cur_pc;
                            this->fetch_decode_fifo->push(t_fetch_decode_pack);

                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.enable", t_fetch_decode_pack.enable, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.value", t_fetch_decode_pack.value, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.pc", t_fetch_decode_pack.pc, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.has_exception", t_fetch_decode_pack.has_exception, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_id", (uint32_t)t_fetch_decode_pack.exception_id, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.exception_value", t_fetch_decode_pack.exception_value, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted", t_fetch_decode_pack.predicted, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_jump", t_fetch_decode_pack.predicted_jump, i);
                            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.predicted_next_pc", t_fetch_decode_pack.predicted_next_pc, i);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id_valid", t_fetch_decode_pack.checkpoint_id_valid, i);
                            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "fetch_decode_fifo_data_in.checkpoint_id", t_fetch_decode_pack.checkpoint_id, i);
                            this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_in_valid", 1, i, 0);
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_push", 1, 0);

                            //if(jump && ((t_fetch_decode_pack.predicted && t_fetch_decode_pack.predicted_jump) || (!t_fetch_decode_pack.predicted)))
                            if(jump)
                            {
                                fetch_not_full_add();
                                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_fetch_not_full_add", 1, 0);
                                break;
                            }
                        }
                        else
                        {
                            fetch_decode_fifo_full_add();
                            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_csrf_fetch_decode_fifo_full_add", 1, 0);
                        }
                    }
                }
            }
            else
            {
                this->fetch_decode_fifo->flush();
                this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_flush", 1, 0);
                this->jump_wait = false;

                if(commit_feedback_pack.has_exception)
                {
                    this->pc = commit_feedback_pack.exception_pc;
                }
                else if(commit_feedback_pack.jump_enable)
                {
                    this->pc = commit_feedback_pack.next_pc;
                }
            }
        }

        this->tdb.capture_output_status();
        this->tdb.write_row();
    }

    uint32_t fetch::get_pc()
    {
        return this->pc;
    }

    void fetch::print(std::string indent)
    {
        std::cout << indent << "pc = 0x" << fillzero(8) << outhex(this->pc);
        std::cout << "    jump_wait = " << outbool(this->jump_wait) << std::endl;
    }

    json fetch::get_json()
    {
        json j;
        j["pc"] = this->pc;
        j["jump_wait"] = this->jump_wait;
        return j;
    }
}