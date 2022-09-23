#pragma once
#include "common.h"
#include "../component/fifo.h"
#include "../component/bus.h"
#include "../component/checkpoint_buffer.h"
#include "../component/branch_predictor.h"
#include "../component/store_buffer.h"
#include "execute/bru.h"
#include "fetch_decode.h"
#include "decode.h"
#include "rename.h"
#include "commit.h"

namespace pipeline
{
    class fetch : public if_print_t, public if_reset_t
    {
        private:
            component::bus *bus;
            component::fifo<fetch_decode_pack_t> *fetch_decode_fifo;
            component::checkpoint_buffer *checkpoint_buffer;
            component::branch_predictor *branch_predictor;
            component::store_buffer *store_buffer;
            uint32_t init_pc;
            uint32_t pc;
            bool jump_wait;
            bool wait_first_memory_result;
            trace::trace_database tdb;

        public:
            fetch(component::bus *bus, component::fifo<fetch_decode_pack_t> *fetch_decode_fifo, component::checkpoint_buffer *checkpoint_buffer, component::branch_predictor *branch_predictor, component::store_buffer *store_buffer, uint32_t init_pc);
            virtual void reset();
            void run(decode_feedback_pack_t decode_feedback_pack, rename_feedback_pack_t rename_feedback_pack, commit_feedback_pack_t commit_feedback_pack);
            uint32_t get_pc();
            virtual void print(std::string indent);
            virtual json get_json();
    };
}