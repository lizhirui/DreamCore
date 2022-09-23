#pragma once
#include "common.h"
#include "../component/port.h"
#include "../component/regfile.h"
#include "../component/checkpoint_buffer.h"
#include "execute_wb.h"
#include "wb_commit.h"
#include "commit.h"

namespace pipeline
{
    typedef struct wb_feedback_channel_t : if_print_t
    {
        bool enable;
        uint32_t phy_id;
        uint32_t value;

        virtual json get_json()
        {
            json t;
            t["enable"] = enable;
            t["phy_id"] = phy_id;
            t["value"] = value;
            return t;
        }
    }wb_feedback_channel_t;

    typedef struct wb_feedback_pack_t : if_print_t
    {
        wb_feedback_channel_t channel[EXECUTE_UNIT_NUM];

        virtual json get_json()
        {
            json t = json::array();

            for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
            {
                t.push_back(channel[i].get_json());
            }

            return t;
        }
    }wb_feedback_pack_t;

    class wb : public if_reset_t
    {
        private:
            component::port<execute_wb_pack_t> **alu_wb_port;
            component::port<execute_wb_pack_t> **bru_wb_port;
            component::port<execute_wb_pack_t> **csr_wb_port;
            component::port<execute_wb_pack_t> **div_wb_port;
            component::port<execute_wb_pack_t> **lsu_wb_port;
            component::port<execute_wb_pack_t> **mul_wb_port;

            std::vector<component::port<execute_wb_pack_t> *> execute_wb_port;

            component::port<wb_commit_pack_t> *wb_commit_port;

            component::regfile<phy_regfile_item_t> *phy_regfile;
            component::checkpoint_buffer *checkpoint_buffer;
            trace::trace_database tdb;

        public:
            wb(component::port<execute_wb_pack_t> **alu_wb_port, component::port<execute_wb_pack_t> **bru_wb_port, component::port<execute_wb_pack_t> **csr_wb_port, component::port<execute_wb_pack_t> **div_wb_port, component::port<execute_wb_pack_t> **lsu_wb_port, component::port<execute_wb_pack_t> **mul_wb_port, component::port<wb_commit_pack_t> *wb_commit_port, component::regfile<phy_regfile_item_t> *phy_regfile, component::checkpoint_buffer *checkpoint_buffer);
            void init();
            virtual void reset();
            wb_feedback_pack_t run(commit_feedback_pack_t commit_feedback_pack);
    };
}