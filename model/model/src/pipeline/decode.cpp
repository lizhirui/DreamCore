#include "common.h"
#include "pipeline_common.h"
#include "decode.h"
#include "../component/fifo.h"
#include "fetch_decode.h"
#include "decode_rename.h"

namespace pipeline
{
    decode::decode(component::fifo<fetch_decode_pack_t> *fetch_decode_fifo, component::fifo<decode_rename_pack_t> *decode_rename_fifo) : tdb(TRACE_DECODE)
    {
        this->fetch_decode_fifo = fetch_decode_fifo;
        this->decode_rename_fifo = decode_rename_fifo;
    }

    void decode::reset()
    {
        this->tdb.create(TRACE_DIR + "decode.tdb");
        this->tdb.mark_signal(trace::domain_t::output, "decode_csrf_decode_rename_fifo_full_add", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.enable", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.value", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.pc", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.has_exception", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_id", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_value", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_jump", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_next_pc", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id_valid", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id", sizeof(uint16_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::input, "fetch_decode_fifo_data_out_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_data_pop_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "fetch_decode_fifo_pop", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::input, "decode_rename_fifo_data_in_enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.enable", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.value", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.valid", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.pc", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.imm", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.has_exception", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.exception_id", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.exception_value", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.predicted", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_jump", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_next_pc", sizeof(uint32_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id_valid", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id", sizeof(uint16_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rs1", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.arg1_src", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rs1_need_map", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rs2", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.arg2_src", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rs2_need_map", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rd", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.rd_enable", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.need_rename", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.csr", sizeof(uint16_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.op", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.op_unit", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in.sub_op", sizeof(uint8_t), DECODE_WIDTH);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_data_in_valid", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_push", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::output, "decode_rename_fifo_flush", sizeof(uint8_t), 1);

        this->tdb.mark_signal(trace::domain_t::output, "decode_feedback_pack.idle", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.enable", sizeof(uint8_t), 1);
        this->tdb.mark_signal(trace::domain_t::input, "commit_feedback_pack.flush", sizeof(uint8_t), 1);

        this->tdb.write_metainfo();
        this->tdb.trace_on();
        this->tdb.capture_status();
        this->tdb.write_row();
    }

    decode_feedback_pack_t decode::run(commit_feedback_pack_t commit_feedback_pack)
    {
        this->tdb.capture_input();

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_csrf_decode_rename_fifo_full_add", 0, 0);

        for(auto i = 0;i < DECODE_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.value", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_pop_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_pop", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_in_enable", 0, 0);

        for(auto i = 0;i < DECODE_WIDTH;i++)
        {
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.enable", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.valid", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.pc", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.imm", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.has_exception", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.exception_id", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.exception_value", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_jump", 0, i);
            this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_next_pc", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id_valid", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs1", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.arg1_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs1_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs2", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.arg2_src", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs2_need_map", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rd", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rd_enable", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.need_rename", 0, i);
            this->tdb.update_signal<uint16_t>(trace::domain_t::output, "decode_rename_fifo_data_in.csr", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.op", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.op_unit", 0, i);
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.sub_op", 0, i);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in_valid", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_push", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_feedback_pack.idle", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", 0, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", 0, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.enable", commit_feedback_pack.enable, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "commit_feedback_pack.flush", commit_feedback_pack.flush, 0);

        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out_valid", (1U << std::min(this->fetch_decode_fifo->get_size(), DECODE_WIDTH)) - 1U, 0);
        this->tdb.update_signal<uint8_t>(trace::domain_t::input, "decode_rename_fifo_data_in_enable", (1U << std::min(this->decode_rename_fifo->get_remain_space(), DECODE_WIDTH)) - 1U, 0);

        decode_feedback_pack_t feedback_pack;

        feedback_pack.idle = this->fetch_decode_fifo->is_empty();

        if(!(commit_feedback_pack.enable && commit_feedback_pack.flush))
        {
            for(auto i = 0;i < DECODE_WIDTH;i++)
            {
                if(!this->fetch_decode_fifo->is_empty() && !this->decode_rename_fifo->is_full())
                {
                    fetch_decode_pack_t rev_pack;
                    decode_rename_pack_t send_pack;
                    std::memset(&send_pack, 0, sizeof(send_pack));
                    this->fetch_decode_fifo->pop(&rev_pack);

                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.enable", rev_pack.enable, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.value", rev_pack.value, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.pc", rev_pack.pc, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.has_exception", rev_pack.has_exception, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_id", (uint32_t)rev_pack.exception_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.exception_value", rev_pack.exception_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted", rev_pack.predicted, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_jump", rev_pack.predicted_jump, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.predicted_next_pc", rev_pack.predicted_next_pc, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id_valid", rev_pack.checkpoint_id_valid, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::input, "fetch_decode_fifo_data_out.checkpoint_id", rev_pack.checkpoint_id, i);

                    this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_data_pop_valid", 1, i, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "fetch_decode_fifo_pop", 1, 0);               

                    if(rev_pack.enable)
                    {
                        auto op_data = rev_pack.value;
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

                        auto op_info = send_pack;
                        op_info.enable = true;
                        op_info.valid = !rev_pack.has_exception;
                        op_info.pc = rev_pack.pc;

                        switch(opcode)
                        {
                            case 0x37://lui
                                op_info.op = op_t::lui;
                                op_info.op_unit = op_unit_t::alu;
                                op_info.sub_op.alu_op = alu_op_t::lui;
                                op_info.arg1_src = arg_src_t::disable;
                                op_info.arg2_src = arg_src_t::disable;
                                op_info.imm = imm_u;
                                op_info.rd = rd;
                                op_info.rd_enable = true;
                                break;

                            case 0x17://auipc
                                op_info.op = op_t::auipc;
                                op_info.op_unit = op_unit_t::alu;
                                op_info.sub_op.alu_op = alu_op_t::auipc;
                                op_info.arg1_src = arg_src_t::disable;
                                op_info.arg2_src = arg_src_t::disable;
                                op_info.imm = imm_u;
                                op_info.rd = rd;
                                op_info.rd_enable = true;
                                break;

                            case 0x6f://jal
                                op_info.op = op_t::jal;
                                op_info.op_unit = op_unit_t::bru;
                                op_info.sub_op.bru_op = bru_op_t::jal;
                                op_info.arg1_src = arg_src_t::disable;
                                op_info.arg2_src = arg_src_t::disable;
                                op_info.imm = sign_extend(imm_j, 21);
                                op_info.rd = rd;
                                op_info.rd_enable = true;
                                break;

                            case 0x67://jalr
                                op_info.op = op_t::jalr;
                                op_info.op_unit = op_unit_t::bru;
                                op_info.sub_op.bru_op = bru_op_t::jalr;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::disable;
                                op_info.imm = sign_extend(imm_i, 12);
                                op_info.rd = rd;
                                op_info.rd_enable = true;
                                break;

                            case 0x63://beq bne blt bge bltu bgeu
                                op_info.op_unit = op_unit_t::bru;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::reg;
                                op_info.rs2 = rs2;
                                op_info.imm = sign_extend(imm_b, 13);

                                switch(funct3)
                                {
                                    case 0x0://beq
                                        op_info.op = op_t::beq;
                                        op_info.sub_op.bru_op = bru_op_t::beq;
                                        break;

                                    case 0x1://bne
                                        op_info.op = op_t::bne;
                                        op_info.sub_op.bru_op = bru_op_t::bne;
                                        break;

                                    case 0x4://blt
                                        op_info.op = op_t::blt;
                                        op_info.sub_op.bru_op = bru_op_t::blt;
                                        break;

                                    case 0x5://bge
                                        op_info.op = op_t::bge;
                                        op_info.sub_op.bru_op = bru_op_t::bge;
                                        break;

                                    case 0x6://bltu
                                        op_info.op = op_t::bltu;
                                        op_info.sub_op.bru_op = bru_op_t::bltu;
                                        break;

                                    case 0x7://bgeu
                                        op_info.op = op_t::bgeu;
                                        op_info.sub_op.bru_op = bru_op_t::bgeu;
                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }

                                break;

                            case 0x03://lb lh lw lbu lhu
                                op_info.op_unit = op_unit_t::lsu;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::disable;
                                op_info.imm = sign_extend(imm_i, 12);
                                op_info.rd = rd;
                                op_info.rd_enable = true;

                                switch(funct3)
                                {
                                    case 0x0://lb
                                        op_info.op = op_t::lb;
                                        op_info.sub_op.lsu_op = lsu_op_t::lb;
                                        break;

                                    case 0x1://lh
                                        op_info.op = op_t::lh;
                                        op_info.sub_op.lsu_op = lsu_op_t::lh;
                                        break;

                                    case 0x2://lw
                                        op_info.op = op_t::lw;
                                        op_info.sub_op.lsu_op = lsu_op_t::lw;
                                        break;

                                    case 0x4://lbu
                                        op_info.op = op_t::lbu;
                                        op_info.sub_op.lsu_op = lsu_op_t::lbu;
                                        break;

                                    case 0x5://lhu
                                        op_info.op = op_t::lhu;
                                        op_info.sub_op.lsu_op = lsu_op_t::lhu;
                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }

                                break;

                            case 0x23://sb sh sw
                                op_info.op_unit = op_unit_t::lsu;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::reg;
                                op_info.rs2 = rs2;
                                op_info.imm = sign_extend(imm_s, 12);

                                switch(funct3)
                                {
                                    case 0x0://sb
                                        op_info.op = op_t::sb;
                                        op_info.sub_op.lsu_op = lsu_op_t::sb;
                                        break;

                                    case 0x1://sh
                                        op_info.op = op_t::sh;
                                        op_info.sub_op.lsu_op = lsu_op_t::sh;
                                        break;

                                    case 0x2://sw
                                        op_info.op = op_t::sw;
                                        op_info.sub_op.lsu_op = lsu_op_t::sw;
                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }

                                break;

                            case 0x13://addi slti sltiu xori ori andi slli srli srai
                                op_info.op_unit = op_unit_t::alu;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::imm;
                                op_info.imm = sign_extend(imm_i, 12);
                                op_info.rd = rd;
                                op_info.rd_enable = true;

                                switch(funct3)
                                {
                                    case 0x0://addi
                                        op_info.op = op_t::addi;
                                        op_info.sub_op.alu_op = alu_op_t::add;
                                        break;

                                    case 0x2://slti
                                        op_info.op = op_t::slti;
                                        op_info.sub_op.alu_op = alu_op_t::slt;
                                        break;

                                    case 0x3://sltiu
                                        op_info.op = op_t::sltiu;
                                        op_info.sub_op.alu_op = alu_op_t::sltu;
                                        break;

                                    case 0x4://xori
                                        op_info.op = op_t::xori;
                                        op_info.sub_op.alu_op = alu_op_t::_xor;
                                        break;

                                    case 0x6://ori
                                        op_info.op = op_t::ori;
                                        op_info.sub_op.alu_op = alu_op_t::_or;
                                        break;

                                    case 0x7://andi
                                        op_info.op = op_t::andi;
                                        op_info.sub_op.alu_op = alu_op_t::_and;
                                        break;

                                    case 0x1://slli
                                        if(funct7 == 0x00)//slli
                                        {
                                            op_info.op = op_t::slli;
                                            op_info.sub_op.alu_op = alu_op_t::sll;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x5://srli srai
                                        if(funct7 == 0x00)//srli
                                        {
                                            op_info.op = op_t::srli;
                                            op_info.sub_op.alu_op = alu_op_t::srl;
                                        }
                                        else if(funct7 == 0x20)//srai
                                        {
                                            op_info.op = op_t::srai;
                                            op_info.sub_op.alu_op = alu_op_t::sra;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }

                                break;

                            case 0x33://add sub sll slt sltu xor srl sra or and mul mulh mulhsu mulhu div divu rem remu
                                op_info.op_unit = op_unit_t::alu;
                                op_info.arg1_src = arg_src_t::reg;
                                op_info.rs1 = rs1;
                                op_info.arg2_src = arg_src_t::reg;
                                op_info.rs2 = rs2;
                                op_info.rd = rd;
                                op_info.rd_enable = true;

                                switch(funct3)
                                {
                                    case 0x0://add sub mul
                                        if(funct7 == 0x00)//add
                                        {
                                            op_info.op = op_t::add;
                                            op_info.sub_op.alu_op = alu_op_t::add;
                                        }
                                        else if(funct7 == 0x20)//sub
                                        {
                                            op_info.op = op_t::sub;
                                            op_info.sub_op.alu_op = alu_op_t::sub;
                                        }
                                        else if(funct7 == 0x01)//mul
                                        {
                                            op_info.op = op_t::mul;
                                            op_info.op_unit = op_unit_t::mul;
                                            op_info.sub_op.mul_op = mul_op_t::mul;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x1://sll mulh
                                        if(funct7 == 0x00)//sll
                                        {
                                            op_info.op = op_t::sll;
                                            op_info.sub_op.alu_op = alu_op_t::sll;
                                        }
                                        else if(funct7 == 0x01)//mulh
                                        {
                                            op_info.op = op_t::mulh;
                                            op_info.op_unit = op_unit_t::mul;
                                            op_info.sub_op.mul_op = mul_op_t::mulh;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x2://slt mulhsu
                                        if(funct7 == 0x00)//slt
                                        {
                                            op_info.op = op_t::slt;
                                            op_info.sub_op.alu_op = alu_op_t::slt;
                                        }
                                        else if(funct7 == 0x01)//mulhsu
                                        {
                                            op_info.op = op_t::mulhsu;
                                            op_info.op_unit = op_unit_t::mul;
                                            op_info.sub_op.mul_op = mul_op_t::mulhsu;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x3://sltu mulhu
                                        if(funct7 == 0x00)//sltu
                                        {
                                            op_info.op = op_t::sltu;
                                            op_info.sub_op.alu_op = alu_op_t::sltu;
                                        }
                                        else if(funct7 == 0x01)//mulhu
                                        {
                                            op_info.op = op_t::mulhu;
                                            op_info.op_unit = op_unit_t::mul;
                                            op_info.sub_op.mul_op = mul_op_t::mulhu;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x4://xor div
                                        if(funct7 == 0x00)//xor
                                        {
                                            op_info.op = op_t::_xor;
                                            op_info.sub_op.alu_op = alu_op_t::_xor;
                                        }
                                        else if(funct7 == 0x01)//div
                                        {
                                            op_info.op = op_t::div;
                                            op_info.op_unit = op_unit_t::div;
                                            op_info.sub_op.div_op = div_op_t::div;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x5://srl sra divu
                                        if(funct7 == 0x00)//srl
                                        {
                                            op_info.op = op_t::srl;
                                            op_info.sub_op.alu_op = alu_op_t::srl;
                                        }
                                        else if(funct7 == 0x20)//sra
                                        {
                                            op_info.op = op_t::sra;
                                            op_info.sub_op.alu_op = alu_op_t::sra;
                                        }
                                        else if(funct7 == 0x01)//divu
                                        {
                                            op_info.op = op_t::divu;
                                            op_info.op_unit = op_unit_t::div;
                                            op_info.sub_op.div_op = div_op_t::divu;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x6://or rem
                                        if(funct7 == 0x00)//or
                                        {
                                            op_info.op = op_t::_or;
                                            op_info.sub_op.alu_op = alu_op_t::_or;
                                        }
                                        else if(funct7 == 0x01)//rem
                                        {
                                            op_info.op = op_t::rem;
                                            op_info.op_unit = op_unit_t::div;
                                            op_info.sub_op.div_op = div_op_t::rem;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x7://and remu
                                        if(funct7 == 0x00)//and
                                        {
                                            op_info.op = op_t::_and;
                                            op_info.sub_op.alu_op = alu_op_t::_and;
                                        }
                                        else if(funct7 == 0x01)//remu
                                        {
                                            op_info.op = op_t::remu;
                                            op_info.op_unit = op_unit_t::div;
                                            op_info.sub_op.div_op = div_op_t::remu;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }

                                break;

                            case 0x0f://fence fence.i
                                switch(funct3)
                                {
                                    case 0x0://fence
                                        if((rd == 0x00) && (rs1 == 0x00) && (((op_data >> 28) & 0x0f) == 0x00))//fence
                                        {
                                            op_info.op = op_t::fence;
                                            op_info.op_unit = op_unit_t::alu;
                                            op_info.sub_op.alu_op = alu_op_t::fence;
                                            op_info.arg1_src = arg_src_t::disable;
                                            op_info.arg2_src = arg_src_t::disable;
                                            op_info.imm = imm_i;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x1://fence.i
                                        if((rd == 0x00) && (rs1 == 0x00) && (imm_i == 0x00))//fence.i
                                        {
                                            op_info.op = op_t::fence_i;
                                            op_info.op_unit = op_unit_t::alu;
                                            op_info.sub_op.alu_op = alu_op_t::fence_i;
                                            op_info.arg1_src = arg_src_t::disable;
                                            op_info.arg2_src = arg_src_t::disable;
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }
                                break;

                            case 0x73://ecall ebreak csrrw csrrs csrrc csrrwi csrrsi csrrci mret
                                switch(funct3)
                                {
                                    case 0x0://ecall ebreak mret
                                        if((rd == 0x00) && (rs1 == 0x00))//ecall ebreak mret
                                        {
                                            switch(funct7)
                                            {
                                                case 0x00://ecall ebreak
                                                    switch(rs2)
                                                    {
                                                        case 0x00://ecall
                                                            op_info.op = op_t::ecall;
                                                            op_info.op_unit = op_unit_t::alu;
                                                            op_info.sub_op.alu_op = alu_op_t::ecall;
                                                            op_info.arg1_src = arg_src_t::disable;
                                                            op_info.arg2_src = arg_src_t::disable;
                                                            break;

                                                        case 0x01://ebreak
                                                            op_info.op = op_t::ebreak;
                                                            op_info.op_unit = op_unit_t::alu;
                                                            op_info.sub_op.alu_op = alu_op_t::ebreak;
                                                            op_info.arg1_src = arg_src_t::disable;
                                                            op_info.arg2_src = arg_src_t::disable;
                                                            break;

                                                        default://invalid
                                                            op_info.valid = false;
                                                            break;
                                                    }

                                                    break;

                                                case 0x18://mret
                                                    switch(rs2)
                                                    {
                                                        case 0x02://mret
                                                            op_info.op = op_t::mret;
                                                            op_info.op_unit = op_unit_t::bru;
                                                            op_info.sub_op.bru_op = bru_op_t::mret;
                                                            op_info.arg1_src = arg_src_t::disable;
                                                            op_info.arg2_src = arg_src_t::disable;
                                                            break;

                                                        default://invalid
                                                            op_info.valid = false;
                                                            break;
                                                    }

                                                    break;

                                                default://invalid
                                                    op_info.valid = false;
                                                    break;
                                            }
                                        }
                                        else//invalid
                                        {
                                            op_info.valid = false;
                                        }

                                        break;

                                    case 0x1://csrrw
                                        op_info.op = op_t::csrrw;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrw;
                                        op_info.arg1_src = arg_src_t::reg;
                                        op_info.rs1 = rs1;
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    case 0x2://csrrs
                                        op_info.op = op_t::csrrs;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrs;
                                        op_info.arg1_src = arg_src_t::reg;
                                        op_info.rs1 = rs1;
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    case 0x3://csrrc
                                        op_info.op = op_t::csrrc;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrc;
                                        op_info.arg1_src = arg_src_t::reg;
                                        op_info.rs1 = rs1;
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    case 0x5://csrrwi
                                        op_info.op = op_t::csrrwi;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrw;
                                        op_info.arg1_src = arg_src_t::imm;
                                        op_info.imm = rs1;//zimm
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    case 0x6://csrrsi
                                        op_info.op = op_t::csrrsi;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrs;
                                        op_info.arg1_src = arg_src_t::imm;
                                        op_info.imm = rs1;//zimm
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    case 0x7://csrrci
                                        op_info.op = op_t::csrrci;
                                        op_info.op_unit = op_unit_t::csr;
                                        op_info.sub_op.csr_op = csr_op_t::csrrc;
                                        op_info.arg1_src = arg_src_t::imm;
                                        op_info.imm = rs1;//zimm
                                        op_info.arg2_src = arg_src_t::disable;
                                        op_info.csr = imm_i;
                                        op_info.rd = rd;
                                        op_info.rd_enable = true;
                                        break;

                                    default://invalid
                                        op_info.valid = false;
                                        break;
                                }
                                break;

                            default://invalid
                                op_info.valid = false;
                                break;
                        }

                        op_info.rs1_need_map = (op_info.arg1_src == arg_src_t::reg) && (op_info.rs1 > 0);
                        op_info.rs2_need_map = (op_info.arg2_src == arg_src_t::reg) && (op_info.rs2 > 0);
                        op_info.need_rename = op_info.rd_enable && (op_info.rd > 0);
                        op_info.value = rev_pack.value;
                        op_info.has_exception = rev_pack.has_exception;
                        op_info.exception_id = rev_pack.exception_id;
                        op_info.exception_value = rev_pack.exception_value;
                        op_info.predicted = rev_pack.predicted;
                        op_info.predicted_jump = rev_pack.predicted_jump;
                        op_info.predicted_next_pc = rev_pack.predicted_next_pc;
                        op_info.checkpoint_id_valid = rev_pack.checkpoint_id_valid;
                        op_info.checkpoint_id = rev_pack.checkpoint_id;
                        send_pack = op_info;
                    }

                    decode_rename_fifo->push(send_pack);

                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.enable", send_pack.enable, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.value", send_pack.value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.valid", send_pack.valid, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.pc", send_pack.pc, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.imm", send_pack.imm, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.has_exception", send_pack.has_exception, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.exception_id", (uint32_t)send_pack.exception_id, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.exception_value", send_pack.exception_value, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted", send_pack.predicted, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_jump", send_pack.predicted_jump, i);
                    this->tdb.update_signal<uint32_t>(trace::domain_t::output, "decode_rename_fifo_data_in.predicted_next_pc", send_pack.predicted_next_pc, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id_valid", send_pack.checkpoint_id_valid, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "decode_rename_fifo_data_in.checkpoint_id", send_pack.checkpoint_id, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs1", send_pack.rs1, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.arg1_src", (uint8_t)send_pack.arg1_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs1_need_map", send_pack.rs1_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs2", send_pack.rs2, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.arg2_src", (uint8_t)send_pack.arg2_src, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rs2_need_map", send_pack.rs2_need_map, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rd", send_pack.rd, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.rd_enable", send_pack.rd_enable, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.need_rename", send_pack.need_rename, i);
                    this->tdb.update_signal<uint16_t>(trace::domain_t::output, "decode_rename_fifo_data_in.csr", send_pack.csr, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.op", (uint8_t)send_pack.op, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.op_unit", (uint8_t)send_pack.op_unit, i);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in.sub_op", *(uint8_t *)&send_pack.sub_op, i);
                    this->tdb.update_signal_bit<uint8_t>(trace::domain_t::output, "decode_rename_fifo_data_in_valid", 1, i, 0);
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_push", 1, 0);

                }
                else if(!this->fetch_decode_fifo->is_empty() && this->decode_rename_fifo->is_full())
                {
                    decode_rename_fifo_full_add();
                    this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_csrf_decode_rename_fifo_full_add", 1, 0);
                }
            }
        }
        else
        {
            decode_rename_fifo->flush();
            this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_rename_fifo_flush", 1, 0);
        }

        this->tdb.update_signal<uint8_t>(trace::domain_t::output, "decode_feedback_pack.idle", feedback_pack.idle, 0);

        this->tdb.capture_output_status();
        this->tdb.write_row();
        return feedback_pack;
    }
}