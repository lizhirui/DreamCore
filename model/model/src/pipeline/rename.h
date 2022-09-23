#pragma once
#include "common.h"
#include "../component/fifo.h"
#include "../component/port.h"
#include "../component/rat.h"
#include "../component/rob.h"
#include "../component/checkpoint_buffer.h"
#include "decode_rename.h"
#include "rename_readreg.h"
#include "issue.h"
#include "commit.h"

namespace pipeline
{
    typedef struct rename_feedback_pack_t : public if_print_t
    {
        bool idle;

        virtual json get_json()
        {
            json t;
            return t;
        }
    }rename_feedback_pack_t;

    class rename : public if_reset_t
    {
        private:
            component::fifo<decode_rename_pack_t> *decode_rename_fifo;
            component::port<rename_readreg_pack_t> *rename_readreg_port;
            component::rat *rat;
            component::rob *rob;
            component::checkpoint_buffer *checkpoint_buffer;
            bool busy;

            decode_rename_pack_t rev_pack;
            trace::trace_database tdb;

        public:
            rename(component::fifo<decode_rename_pack_t> *decode_rename_fifo, component::port<rename_readreg_pack_t> *rename_readreg_port, component::rat *rat, component::rob *rob, component::checkpoint_buffer *checkpoint_buffer);
            virtual void reset();
            rename_feedback_pack_t run(issue_feedback_pack_t issue_pack, commit_feedback_pack_t commit_feedback_pack);
    };
}