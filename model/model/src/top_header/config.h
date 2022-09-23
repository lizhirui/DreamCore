#pragma once
#include "common.h"
const uint32_t FETCH_WIDTH = 4;
const uint32_t DECODE_WIDTH = 4;
const uint32_t RENAME_WIDTH = 4;
const uint32_t READREG_WIDTH = RENAME_WIDTH;
const uint32_t ISSUE_WIDTH = 2;
const uint32_t COMMIT_WIDTH = 4;

const uint32_t PHY_REG_NUM = 128;
const uint32_t ARCH_REG_NUM = 32;

const uint32_t FETCH_DECODE_FIFO_SIZE = 256;
const uint32_t DECODE_RENAME_FIFO_SIZE = 16;
const uint32_t ISSUE_QUEUE_SIZE = 16;
const uint32_t ROB_SIZE = 64;
const uint32_t CHECKPOINT_BUFFER_SIZE = 256;
const uint32_t STORE_BUFFER_SIZE = 16;

const uint32_t ALU_UNIT_NUM = 2;
const uint32_t BRU_UNIT_NUM = 1;
const uint32_t CSR_UNIT_NUM = 1;
const uint32_t DIV_UNIT_NUM = 1;
const uint32_t LSU_UNIT_NUM = 1;
const uint32_t MUL_UNIT_NUM = 2;

const uint32_t EXECUTE_UNIT_NUM = ALU_UNIT_NUM + BRU_UNIT_NUM + CSR_UNIT_NUM + DIV_UNIT_NUM + LSU_UNIT_NUM + MUL_UNIT_NUM;

const uint32_t GSHARE_PC_P1_ADDR_WIDTH = 12;
const uint32_t GSHARE_PC_P2_ADDR_WIDTH = 0;
const uint32_t GSHARE_GLOBAL_HISTORY_WIDTH = GSHARE_PC_P1_ADDR_WIDTH;
//const uint32_t GSHARE_PHT_ADDR_WIDTH = GSHARE_PC_P1_ADDR_WIDTH + GSHARE_PC_P2_ADDR_WIDTH;
const uint32_t GSHARE_PHT_ADDR_WIDTH = GSHARE_PC_P1_ADDR_WIDTH;
const uint32_t GSHARE_PHT_SIZE = 1U << GSHARE_PHT_ADDR_WIDTH;
const uint32_t GSHARE_PC_P1_ADDR_MASK = (1U << GSHARE_PC_P1_ADDR_WIDTH) - 1U;
const uint32_t GSHARE_PC_P2_ADDR_MASK = (1U << GSHARE_PC_P2_ADDR_WIDTH) - 1U;
const uint32_t GSHARE_GLOBAL_HISTORY_MASK = (1U << GSHARE_GLOBAL_HISTORY_WIDTH) - 1U;

const uint32_t LOCAL_PC_P1_ADDR_WIDTH = 12;
const uint32_t LOCAL_PC_P2_ADDR_WIDTH = 0;
const uint32_t LOCAL_BHT_ADDR_WIDTH = LOCAL_PC_P1_ADDR_WIDTH;
const uint32_t LOCAL_BHT_SIZE = 1U << LOCAL_BHT_ADDR_WIDTH;
const uint32_t LOCAL_BHT_WIDTH = LOCAL_PC_P1_ADDR_WIDTH;
//const uint32_t LOCAL_PHT_ADDR_WIDTH = LOCAL_PC_P1_ADDR_WIDTH + LOCAL_PC_P2_ADDR_WIDTH;
const uint32_t LOCAL_PHT_ADDR_WIDTH = LOCAL_PC_P1_ADDR_WIDTH;
const uint32_t LOCAL_PHT_SIZE = 1U << LOCAL_PHT_ADDR_WIDTH;
const uint32_t LOCAL_PC_P1_ADDR_MASK = (1U << LOCAL_PC_P1_ADDR_WIDTH) - 1U;
const uint32_t LOCAL_PC_P2_ADDR_MASK = (1U << LOCAL_PC_P2_ADDR_WIDTH) - 1U;
const uint32_t LOCAL_BHT_WIDTH_MASK = (1U << LOCAL_BHT_WIDTH) - 1U;

const uint32_t RAS_SIZE = 256;

const uint32_t CALL_PC_P1_ADDR_WIDTH = 12;
const uint32_t CALL_PC_P2_ADDR_WIDTH = 0;
const uint32_t CALL_GLOBAL_HISTORY_WIDTH = CALL_PC_P1_ADDR_WIDTH;
//const uint32_t CALL_TARGET_CACHE_ADDR_WIDTH = CALL_PC_P1_ADDR_WIDTH + CALL_PC_P2_ADDR_WIDTH;
const uint32_t CALL_TARGET_CACHE_ADDR_WIDTH = CALL_PC_P1_ADDR_WIDTH;
const uint32_t CALL_TARGET_CACHE_SIZE = 1U << CALL_TARGET_CACHE_ADDR_WIDTH;
const uint32_t CALL_PC_P1_ADDR_MASK = (1U << CALL_PC_P1_ADDR_WIDTH) - 1U;
const uint32_t CALL_PC_P2_ADDR_MASK = (1U << CALL_PC_P2_ADDR_WIDTH) - 1U;
const uint32_t CALL_GLOBAL_HISTORY_MASK = (1U << CALL_GLOBAL_HISTORY_WIDTH) - 1U;

const uint32_t NORMAL_PC_P1_ADDR_WIDTH = 12;
const uint32_t NORMAL_PC_P2_ADDR_WIDTH = 0;
const uint32_t NORMAL_GLOBAL_HISTORY_WIDTH = NORMAL_PC_P1_ADDR_WIDTH;
//const uint32_t NORMAL_TARGET_CACHE_ADDR_WIDTH = NORMAL_PC_P1_ADDR_WIDTH + NORMAL_PC_P2_ADDR_WIDTH;
const uint32_t NORMAL_TARGET_CACHE_ADDR_WIDTH = NORMAL_PC_P1_ADDR_WIDTH;
const uint32_t NORMAL_TARGET_CACHE_SIZE = 1U << NORMAL_TARGET_CACHE_ADDR_WIDTH;
const uint32_t NORMAL_PC_P1_ADDR_MASK = (1U << NORMAL_PC_P1_ADDR_WIDTH) - 1U;
const uint32_t NORMAL_PC_P2_ADDR_MASK = (1U << NORMAL_PC_P2_ADDR_WIDTH) - 1U;
const uint32_t NORMAL_GLOBAL_HISTORY_MASK = (1U << NORMAL_GLOBAL_HISTORY_WIDTH) - 1U;

const std::string TRACE_DIR = R"(D:\program\project\MyRISC-VCore\model\MyRISC-VCore_Model_CMake\trace\coremark_10\)";

//#define TRACE_ENABLE
//#define TRACE_ENABLE_FULL

#ifdef TRACE_ENABLE_FULL
    const bool TRACE_FETCH = true;
    const bool TRACE_DECODE = true;
    const bool TRACE_RENAME = true;
    const bool TRACE_READREG = true;
    const bool TRACE_ISSUE = true;
    const bool TRACE_EXECUTE_ALU = true;
    const bool TRACE_EXECUTE_BRU = true;
    const bool TRACE_EXECUTE_CSR = true;
    const bool TRACE_EXECUTE_DIV = true;
    const bool TRACE_EXECUTE_LSU = true;
    const bool TRACE_EXECUTE_MUL = true;
    const bool TRACE_WB = true;
    const bool TRACE_COMMIT = true;
    const bool TRACE_BRANCH_PREDICTOR = true;
    const bool TRACE_RAS = true;
    const bool TRACE_RAT = true;
    const bool TRACE_ROB = true;
    const bool TRACE_PHY_REGFILE = true;
    const bool TRACE_STORE_BUFFER = true;
    const bool TRACE_CHECKPOINT_BUFFER = true;
    const bool TRACE_CSRFILE = true;
    const bool TRACE_INTERRUPT_INTERFACE = true;
    const bool TRACE_BUS = true;
    const bool TRACE_CLINT = true;
    const bool TRACE_TCM = true;
#elif defined(TRACE_ENABLE)
    const bool TRACE_FETCH = false;
    const bool TRACE_DECODE = false;
    const bool TRACE_RENAME = false;
    const bool TRACE_READREG = false;
    const bool TRACE_ISSUE = false;
    const bool TRACE_EXECUTE_ALU = false;
    const bool TRACE_EXECUTE_BRU = false;
    const bool TRACE_EXECUTE_CSR = false;
    const bool TRACE_EXECUTE_DIV = false;
    const bool TRACE_EXECUTE_LSU = false;
    const bool TRACE_EXECUTE_MUL = false;
    const bool TRACE_WB = false;
    const bool TRACE_COMMIT = false;
    const bool TRACE_BRANCH_PREDICTOR = false;
    const bool TRACE_RAS = false;
    const bool TRACE_RAT = false;
    const bool TRACE_ROB = false;
    const bool TRACE_PHY_REGFILE = false;
    const bool TRACE_STORE_BUFFER = false;
    const bool TRACE_CHECKPOINT_BUFFER = false;
    const bool TRACE_CSRFILE = false;
    const bool TRACE_INTERRUPT_INTERFACE = false;
    const bool TRACE_BUS = false;
    const bool TRACE_CLINT = false;
    const bool TRACE_TCM = true;
#else
    const bool TRACE_FETCH = false;
    const bool TRACE_DECODE = false;
    const bool TRACE_RENAME = false;
    const bool TRACE_READREG = false;
    const bool TRACE_ISSUE = false;
    const bool TRACE_EXECUTE_ALU = false;
    const bool TRACE_EXECUTE_BRU = false;
    const bool TRACE_EXECUTE_CSR = false;
    const bool TRACE_EXECUTE_DIV = false;
    const bool TRACE_EXECUTE_LSU = false;
    const bool TRACE_EXECUTE_MUL = false;
    const bool TRACE_WB = false;
    const bool TRACE_COMMIT = false;
    const bool TRACE_BRANCH_PREDICTOR = false;
    const bool TRACE_RAS = false;
    const bool TRACE_RAT = false;
    const bool TRACE_ROB = false;
    const bool TRACE_PHY_REGFILE = false;
    const bool TRACE_STORE_BUFFER = false;
    const bool TRACE_CHECKPOINT_BUFFER = false;
    const bool TRACE_CSRFILE = false;
    const bool TRACE_INTERRUPT_INTERFACE = false;
    const bool TRACE_BUS = false;
    const bool TRACE_CLINT = false;
    const bool TRACE_TCM = false;
#endif