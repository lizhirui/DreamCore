#pragma once
#include "common.h"
#include "config.h"

namespace pipeline
{
    typedef struct fetch_decode_pack_t : public if_print_t
    {
        uint32_t pc;
        uint32_t value;
        bool enable;
        bool has_exception;
        riscv_exception_t exception_id;
        uint32_t exception_value;
        bool predicted;
        bool predicted_jump;
        uint32_t predicted_next_pc;
        bool checkpoint_id_valid;
        uint32_t checkpoint_id;

        virtual void print(std::string indent)
        {
            std::string blank = "    ";

            std::cout << indent << "pc = 0x" << fillzero(8) << outhex(pc);
            std::cout << blank << "value = 0x" << fillzero(8) << outhex(value);
            std::cout << blank << "enable = " << outbool(enable);
            std::cout << blank << "has_exception = " << outbool(has_exception);
            std::cout << blank << "exception_id = " << outenum(exception_id);
            std::cout << blank << "exception_value = 0x" << fillzero(8) << outhex(exception_value) << std::endl;
        }

        virtual json get_json()
        {
            json t;
            t["pc"] = pc;
            t["value"] = value;
            t["enable"] = enable;
            t["has_exception"] = has_exception;
            t["exception_id"] = outenum(exception_id);
            t["exception_value"] = exception_value;
            t["predicted"] = predicted;
            t["predicted_jump"] = predicted_jump;
            t["predicted_next_pc"] = predicted_next_pc;
            t["checkpoint_id_valid"] = checkpoint_id_valid;
            t["checkpoint_id"] = checkpoint_id;
            return t;
        }
    }fetch_decode_pack_t;
}