#pragma once
#include "common.h"
#include "../component/fifo.h"
#include "fetch_decode.h"
#include "decode_rename.h"
#include "commit.h"

namespace pipeline
{
    typedef struct decode_feedback_pack_t : public if_print_t
    {
        bool idle;

        virtual json get_json()
        {
            json t;
            return t;
        }
    }decode_feedback_pack_t;

    class decode : public if_reset_t
    {
        private:
            component::fifo<fetch_decode_pack_t> *fetch_decode_fifo;
            component::fifo<decode_rename_pack_t> *decode_rename_fifo;
            trace::trace_database tdb;

        public:
            decode(component::fifo<fetch_decode_pack_t> *fetch_decode_fifo, component::fifo<decode_rename_pack_t> *decode_rename_fifo);
            virtual void reset();
            decode_feedback_pack_t run(commit_feedback_pack_t commit_feedback_pack);
    };
}