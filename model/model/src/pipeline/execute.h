#pragma once

namespace pipeline
{
    typedef struct execute_feedback_channel_t : if_print_t
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
    }execute_feedback_channel_t;

    typedef struct execute_feedback_pack_t : if_print_t
    {
        execute_feedback_channel_t channel[EXECUTE_UNIT_NUM];

        virtual json get_json()
        {
            json t = json::array();

            for(auto i = 0;i < EXECUTE_UNIT_NUM;i++)
            {
                t.push_back(channel[i].get_json());
            }

            return t;
        }
    }execute_feedback_pack_t;
}