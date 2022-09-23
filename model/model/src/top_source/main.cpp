#include "common.h"
#include "config.h"
#include "../test/test.h"
#include "../component/fifo.h"
#include "../component/port.h"
#include "../component/slave/memory.h"
#include "../component/bus.h"
#include "../component/regfile.h"
#include "../component/csrfile.h"
#include "../component/csr_all.h"
#include "../component/store_buffer.h"
#include "../component/checkpoint_buffer.h"
#include "../component/branch_predictor.h"
#include "../component/interrupt_interface.h"
#include "../component/slave/clint.h"
#include "../pipeline/fetch.h"
#include "../pipeline/fetch_decode.h"
#include "../pipeline/decode.h"
#include "../pipeline/decode_rename.h"
#include "../pipeline/rename.h"
#include "../pipeline/rename_readreg.h"
#include "../pipeline/readreg.h"
#include "../pipeline/readreg_issue.h"
#include "../pipeline/issue.h"
#include "../pipeline/issue_execute.h"
#include "../pipeline/execute.h"
#include "../pipeline/execute/alu.h"
#include "../pipeline/execute/bru.h"
#include "../pipeline/execute/csr.h"
#include "../pipeline/execute/div.h"
#include "../pipeline/execute/lsu.h"
#include "../pipeline/execute/mul.h"
#include "../pipeline/execute_wb.h"
#include "../pipeline/wb.h"
#include "../pipeline/wb_commit.h"
#include "../pipeline/commit.h"
#include "asio.hpp"
#include <thread>

#ifdef WIN32
    #include <windows.h>
#endif

static std::atomic<bool> ctrl_c_detected = false;

static uint64_t cpu_clock_cycle = 0;
static uint64_t committed_instruction_num = 0;
static uint64_t branch_num = 0;
static uint64_t branch_predicted = 0;
static uint64_t branch_hit = 0;
static uint64_t branch_miss = 0;
static uint64_t fetch_decode_fifo_full = 0;
static uint64_t decode_rename_fifo_full = 0;
static uint64_t issue_queue_full = 0;
static uint64_t issue_execute_fifo_full = 0;
static uint64_t checkpoint_buffer_full = 0;
static uint64_t rob_full = 0;
static uint64_t phy_regfile_full = 0;
static uint64_t ras_full = 0;
static uint64_t fetch_not_full = 0;

static component::fifo<pipeline::fetch_decode_pack_t> fetch_decode_fifo(FETCH_DECODE_FIFO_SIZE);
static component::fifo<pipeline::decode_rename_pack_t> decode_rename_fifo(DECODE_RENAME_FIFO_SIZE);
static pipeline::rename_readreg_pack_t default_rename_readreg_pack;
static pipeline::readreg_issue_pack_t default_readreg_issue_pack;
static pipeline::execute_wb_pack_t default_execute_wb_pack;
static pipeline::wb_commit_pack_t default_wb_commit_pack;

static component::port<pipeline::rename_readreg_pack_t> rename_readreg_port(default_rename_readreg_pack);
static component::port<pipeline::readreg_issue_pack_t> readreg_issue_port(default_readreg_issue_pack);
static component::fifo<pipeline::issue_execute_pack_t> *issue_alu_fifo[ALU_UNIT_NUM];
static component::fifo<pipeline::issue_execute_pack_t> *issue_bru_fifo[BRU_UNIT_NUM];
static component::fifo<pipeline::issue_execute_pack_t> *issue_csr_fifo[CSR_UNIT_NUM];
static component::fifo<pipeline::issue_execute_pack_t> *issue_div_fifo[DIV_UNIT_NUM];
static component::fifo<pipeline::issue_execute_pack_t> *issue_lsu_fifo[LSU_UNIT_NUM];
static component::fifo<pipeline::issue_execute_pack_t> *issue_mul_fifo[MUL_UNIT_NUM];

static component::port<pipeline::execute_wb_pack_t> *alu_wb_port[ALU_UNIT_NUM];
static component::port<pipeline::execute_wb_pack_t> *bru_wb_port[BRU_UNIT_NUM];
static component::port<pipeline::execute_wb_pack_t> *csr_wb_port[CSR_UNIT_NUM];
static component::port<pipeline::execute_wb_pack_t> *div_wb_port[DIV_UNIT_NUM];
static component::port<pipeline::execute_wb_pack_t> *lsu_wb_port[LSU_UNIT_NUM];
static component::port<pipeline::execute_wb_pack_t> *mul_wb_port[MUL_UNIT_NUM];

static component::port<pipeline::wb_commit_pack_t> wb_commit_port(default_wb_commit_pack);

static component::bus bus;
static component::rat rat(PHY_REG_NUM, ARCH_REG_NUM);
static component::rob rob(ROB_SIZE);
static component::regfile<pipeline::phy_regfile_item_t> phy_regfile(PHY_REG_NUM);
static component::csrfile csr_file;
static component::store_buffer store_buffer(STORE_BUFFER_SIZE, &bus);
static component::checkpoint_buffer checkpoint_buffer(CHECKPOINT_BUFFER_SIZE);
static component::branch_predictor branch_predictor;
static component::interrupt_interface interrupt_interface(&csr_file);
static component::slave::clint clint(&interrupt_interface);

static pipeline::fetch fetch_stage(&bus, &fetch_decode_fifo, &checkpoint_buffer, &branch_predictor, &store_buffer, 0x80000000);
static pipeline::decode decode_stage(&fetch_decode_fifo, &decode_rename_fifo);
static pipeline::rename rename_stage(&decode_rename_fifo, &rename_readreg_port, &rat, &rob, &checkpoint_buffer);
static pipeline::readreg readreg_stage(&rename_readreg_port, &readreg_issue_port, &phy_regfile, &checkpoint_buffer, &rat);
static pipeline::issue issue_stage(&readreg_issue_port, issue_alu_fifo, issue_bru_fifo, issue_csr_fifo, issue_div_fifo, issue_lsu_fifo, issue_mul_fifo, &phy_regfile, &store_buffer, &bus);
static pipeline::execute::alu *execute_alu_stage[ALU_UNIT_NUM];
static pipeline::execute::bru *execute_bru_stage[BRU_UNIT_NUM];
static pipeline::execute::csr *execute_csr_stage[CSR_UNIT_NUM];
static pipeline::execute::div *execute_div_stage[DIV_UNIT_NUM];
static pipeline::execute::lsu *execute_lsu_stage[LSU_UNIT_NUM];
static pipeline::execute::mul *execute_mul_stage[MUL_UNIT_NUM];
static pipeline::wb wb_stage(alu_wb_port, bru_wb_port, csr_wb_port, div_wb_port, lsu_wb_port, mul_wb_port, &wb_commit_port, &phy_regfile, &checkpoint_buffer);
static pipeline::commit commit_stage(&wb_commit_port, &rat, &rob, &csr_file, &phy_regfile, &checkpoint_buffer, &branch_predictor, &interrupt_interface);

static pipeline::decode_feedback_pack_t t_decode_feedback_pack;
static pipeline::rename_feedback_pack_t t_rename_feedback_pack;
static pipeline::issue_feedback_pack_t t_issue_feedback_pack;
static pipeline::execute_feedback_pack_t t_execute_feedback_pack;
static pipeline::wb_feedback_pack_t t_wb_feedback_pack;
static pipeline::commit_feedback_pack_t t_commit_feedback_pack;

static asio::io_context recv_ioc;
static asio::io_context send_ioc;
std::atomic<bool> recv_thread_stop = false;
std::atomic<bool> recv_thread_stopped = false;
std::atomic<bool> server_thread_stopped = false;
std::atomic<bool> program_stop = false;

static asio::io_context tcp_charfifo_thread_ioc;
static boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> charfifo_send_fifo;
static boost::lockfree::spsc_queue<char, boost::lockfree::capacity<1024>> charfifo_rev_fifo;
std::atomic<bool> charfifo_thread_stopped = false;
std::atomic<bool> charfifo_recv_thread_stop = false;
std::atomic<bool> charfifo_recv_thread_stopped = false;

void branch_num_add()
{
    branch_num++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_num_add", 1, 0);
}

void branch_predicted_add()
{
    branch_predicted++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_predicted_add", 1, 0);
}

void branch_hit_add()
{
    branch_hit++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_hit_add", 1, 0);
}

void branch_miss_add()
{
    branch_miss++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_branch_miss_add", 1, 0);
}

void fetch_decode_fifo_full_add()
{
    fetch_decode_fifo_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_fetch_decode_fifo_full_add", 1, 0);
}

void decode_rename_fifo_full_add()
{
    decode_rename_fifo_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "decode_csrf_decode_rename_fifo_full_add", 1, 0);
}

void issue_queue_full_add()
{
    issue_queue_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "issue_csrf_issue_queue_full_add", 1, 0);
}

void issue_execute_fifo_full_add()
{
    issue_execute_fifo_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "issue_csrf_issue_execute_fifo_full_add", 1, 0);
}

void checkpoint_buffer_full_add()
{
    checkpoint_buffer_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_checkpoint_buffer_full_add", 1, 0);
}

void rob_full_add()
{
    rob_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_csrf_rob_full_add", 1, 0);
}

void phy_regfile_full_add()
{
    phy_regfile_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "rename_csrf_phy_regfile_full_add", 1, 0);
}

void ras_full_add()
{
    ras_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "ras_csrf_ras_full_add", 1, 0);
}

void fetch_not_full_add()
{
    fetch_not_full++;
    csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "fetch_csrf_fetch_not_full_add", 1, 0);
}

void tcp_charfifo_recv_thread_receive_entry(asio::ip::tcp::socket &soc)
{
    char buf[1024];

    while(!charfifo_recv_thread_stop)
    {
        try
        {
            auto length = soc.receive(asio::buffer(&buf, sizeof(buf)));

            for(auto i = 0;i < length;i++)
            {
                while(!charfifo_rev_fifo.push(buf[i]));
            }
        }
        catch(const std::exception &ex)
        {
            std::cout << ex.what() << std::endl;
            break;
        }
    }

    charfifo_recv_thread_stopped = true;
}

void tcp_charfifo_thread_entry(asio::ip::tcp::acceptor &&listener)
{
    try
    {
        while(!program_stop)
        {
            std::cout << "Wait Telnet Connection" << std::endl;
            auto soc = listener.accept();
            soc.set_option(asio::ip::tcp::no_delay(true));
            std::cout << "Telnet Connected" << std::endl;
            charfifo_recv_thread_stop = false;
            charfifo_recv_thread_stopped = false;
            std::thread rev_thread(tcp_charfifo_recv_thread_receive_entry, std::ref(soc));

            try
            {
                while(1)
                {
                    if(!charfifo_send_fifo.empty())
                    {
                        auto ch = charfifo_send_fifo.front();
                        soc.send(asio::buffer(&ch, 1));
                        while(!charfifo_send_fifo.pop());
                    }

                    if(charfifo_recv_thread_stopped)
                    {
                        break;
                    }

                    if(charfifo_send_fifo.empty())
                    {
                        std::this_thread::sleep_for(std::chrono::milliseconds(30));
                    }
                }
            }
            catch(const std::exception &ex)
            {
                std::cout << ex.what() << std::endl;
            }
            
            charfifo_recv_thread_stop = true;
            rev_thread.join();
            soc.shutdown(asio::socket_base::shutdown_both);
            soc.close();
            std::cout << "Telnet Disconnected" << std::endl;
        }
        
        listener.close();
        charfifo_thread_stopped = true;
    }
    catch(const std::exception &ex)
    {
        std::cout << ex.what() << std::endl;
    }
}

static void telnet_init()
{
    asio::ip::tcp::acceptor listener(tcp_charfifo_thread_ioc, {asio::ip::address::from_string("0.0.0.0"), 10241});
    listener.set_option(asio::ip::tcp::no_delay(true));
    listener.listen();
    std::cout << "Telnet Bind on 0.0.0.0:10241" << std::endl;
    charfifo_thread_stopped = false;
    std::thread server_thread(tcp_charfifo_thread_entry, std::move(listener));
    server_thread.detach();
}

static bool need_to_trigger = true;

static void reset()
{
    need_to_trigger = true;
    fetch_decode_fifo.reset();
    decode_rename_fifo.reset();
    rename_readreg_port.reset();
    readreg_issue_port.reset();

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        issue_alu_fifo[i]->reset();
        execute_alu_stage[i]->reset();
    }

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        issue_bru_fifo[i]->reset();
        execute_bru_stage[i]->reset();
    }

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        issue_csr_fifo[i]->reset();
        execute_csr_stage[i]->reset();
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        issue_div_fifo[i]->reset();
        execute_div_stage[i]->reset();
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        issue_lsu_fifo[i]->reset();
        execute_lsu_stage[i]->reset();
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        issue_mul_fifo[i]->reset();
        execute_mul_stage[i]->reset();
    }

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        alu_wb_port[i]->reset();
    }

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        bru_wb_port[i]->reset();
    }

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        csr_wb_port[i]->reset();
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        div_wb_port[i]->reset();
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        lsu_wb_port[i]->reset();
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        mul_wb_port[i]->reset();
    }

    wb_commit_port.reset();
    bus.reset();
    phy_regfile.reset();
    rat.reset();
    rat.init_start();

    for(uint32_t i = 1;i < 32;i++)
    {
        rat.set_map(i, i);
        rat.commit_map(i);
        pipeline::phy_regfile_item_t t_item;
        t_item.value = 0;
        //t_item.valid = true;
        phy_regfile.write(i, t_item, true);
    }

    rat.init_finish();
    rob.reset();
    csr_file.reset();
    store_buffer.reset();
    checkpoint_buffer.reset();
    branch_predictor.reset();
    interrupt_interface.reset();
    ((component::slave::memory *)bus.get_slave_obj(0x80000000))->reset();
    clint.reset();

    fetch_stage.reset();
    decode_stage.reset();
    rename_stage.reset();
    readreg_stage.reset();
    issue_stage.reset();
    wb_stage.reset();
    commit_stage.reset();
    cpu_clock_cycle = 0;
    committed_instruction_num = 0;
    branch_num = 0;
    branch_predicted = 0;
    branch_hit = 0;
    branch_miss = 0;
    fetch_decode_fifo_full = 0;
    decode_rename_fifo_full = 0;
    issue_queue_full = 0;
    issue_execute_fifo_full = 0;
    checkpoint_buffer_full = 0;
    rob_full = 0;
    phy_regfile_full = 0;
    ras_full = 0;
}

static void init()
{
    telnet_init();

    bus.map(0x80000000, 1048576, std::make_shared<component::slave::memory>());
    bus.map(0x20000000, 0x10000, std::shared_ptr<component::slave::clint>(&clint));

    //std::ifstream binfile("../../../testprgenv/main/test.bin", std::ios::binary);
    //std::ifstream binfile("../../../testfile.bin", std::ios::binary);
    //std::ifstream binfile("../../../coremark_10.bin", std::ios::binary);
    //std::ifstream binfile("../../../dhrystone.bin", std::ios::binary);
    //std::ifstream binfile("../../../rt-thread/bsp/MyRISCVCore/MyRISCVCore/rtthread.bin", std::ios::binary);
    //std::ifstream binfile("../../../../../software/hello_world/main/hello_world.bin", std::ios::binary);
    std::ifstream binfile("../../../../../software/bootloader/main/bootloader.bin", std::ios::binary);

    if(!binfile || !binfile.is_open())
    {
        std::cout << "coremark.bin Open Failed!" << std::endl;
        exit(1);
    }

    char buf[4096];
    size_t n = 0;

    while(!binfile.eof())
    {
        memset(buf, 0, sizeof(buf));
        binfile.read((char *)&buf, sizeof(buf));

        for(auto i = 0;i < sizeof(buf);i++)
        {
            bus.write8(0x80000000 + ((uint32_t)n) + i, buf[i]);
        }

        n += sizeof(buf);
    }

    std::cout << "coremark.bin Read OK!Bytes(" << sizeof(buf) << "Byte-Block):" << n << std::endl;

    fetch_decode_fifo.set_pop_status_save(true);
    decode_rename_fifo.set_pop_status_save(true);

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        issue_alu_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }
    
    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        issue_bru_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }
 
    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        issue_csr_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        issue_div_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        issue_lsu_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        issue_mul_fifo[i] = new component::fifo<pipeline::issue_execute_pack_t>(1);
    }

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        alu_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }
    
    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        bru_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }
 
    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        csr_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        div_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        lsu_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        mul_wb_port[i] = new component::port<pipeline::execute_wb_pack_t>(default_execute_wb_pack);
    }

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        execute_alu_stage[i] = new pipeline::execute::alu(i, issue_alu_fifo[i], alu_wb_port[i]);
    }

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        execute_bru_stage[i] = new pipeline::execute::bru(i, issue_bru_fifo[i], bru_wb_port[i], &csr_file, &branch_predictor, &checkpoint_buffer);
    }

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        execute_csr_stage[i] = new pipeline::execute::csr(i, issue_csr_fifo[i], csr_wb_port[i], &csr_file);
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        execute_div_stage[i] = new pipeline::execute::div(i, issue_div_fifo[i], div_wb_port[i]);
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        execute_lsu_stage[i] = new pipeline::execute::lsu(i, issue_lsu_fifo[i], lsu_wb_port[i], &bus, &store_buffer);
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        execute_mul_stage[i] = new pipeline::execute::mul(i, issue_mul_fifo[i], mul_wb_port[i]);
    }

    rat.init_start();

    for(uint32_t i = 1;i < 32;i++)
    {
        rat.set_map(i, i);
        rat.commit_map(i);
        pipeline::phy_regfile_item_t t_item;
        t_item.value = 0;
        //t_item.valid = true;
        phy_regfile.write(i, t_item, true);
    }

    rat.init_finish();

    csr_file.map(CSR_MVENDORID, true, std::make_shared<component::csr::mvendorid>());
    csr_file.map(CSR_MARCHID, true, std::make_shared<component::csr::marchid>());
    csr_file.map(CSR_MIMPID, true, std::make_shared<component::csr::mimpid>());
    csr_file.map(CSR_MHARTID, true, std::make_shared<component::csr::mhartid>());
    csr_file.map(CSR_MCONFIGPTR, true, std::make_shared<component::csr::mconfigptr>());
    csr_file.map(CSR_MSTATUS, false, std::make_shared<component::csr::mstatus>());
    csr_file.map(CSR_MISA, false, std::make_shared<component::csr::misa>());
    csr_file.map(CSR_MIE, false, std::make_shared<component::csr::mie>());
    csr_file.map(CSR_MTVEC, false, std::make_shared<component::csr::mtvec>());
    csr_file.map(CSR_MCOUNTEREN, false, std::make_shared<component::csr::mcounteren>());
    csr_file.map(CSR_MSTATUSH, false, std::make_shared<component::csr::mstatush>());
    csr_file.map(CSR_MSCRATCH, false, std::make_shared<component::csr::mscratch>());
    csr_file.map(CSR_MEPC, false, std::make_shared<component::csr::mepc>());
    csr_file.map(CSR_MCAUSE, false, std::make_shared<component::csr::mcause>());
    csr_file.map(CSR_MTVAL, false, std::make_shared<component::csr::mtval>());
    csr_file.map(CSR_MIP, false, std::make_shared<component::csr::mip>());
    csr_file.map(CSR_CHARFIFO, false, std::make_shared<component::csr::charfifo>(&charfifo_send_fifo, &charfifo_rev_fifo));
    csr_file.map(CSR_FINISH, false, std::make_shared<component::csr::finish>());
    csr_file.map(CSR_MCYCLE, false, std::make_shared<component::csr::mcycle>());
    csr_file.map(CSR_MINSTRET, false, std::make_shared<component::csr::minstret>());
    csr_file.map(CSR_MCYCLEH, false, std::make_shared<component::csr::mcycleh>());
    csr_file.map(CSR_MINSTRETH, false, std::make_shared<component::csr::minstreth>());
    csr_file.map(CSR_BRANCHNUM, true, std::make_shared<component::csr::mhpmcounter>("branchnum"));
    csr_file.map(CSR_BRANCHNUMH, true, std::make_shared<component::csr::mhpmcounterh>("branchnumh"));
    csr_file.map(CSR_BRANCHPREDICTED, true, std::make_shared<component::csr::mhpmcounter>("branchpredicted"));
    csr_file.map(CSR_BRANCHPREDICTEDH, true, std::make_shared<component::csr::mhpmcounterh>("branchpredictedh"));
    csr_file.map(CSR_BRANCHHIT, true, std::make_shared<component::csr::mhpmcounter>("branchhit"));
    csr_file.map(CSR_BRANCHHITH, true, std::make_shared<component::csr::mhpmcounterh>("branchhith"));
    csr_file.map(CSR_BRANCHMISS, true, std::make_shared<component::csr::mhpmcounter>("branchmiss"));
    csr_file.map(CSR_BRANCHMISSH, true, std::make_shared<component::csr::mhpmcounterh>("branchmissh"));
    csr_file.map(CSR_FD, true, std::make_shared<component::csr::mhpmcounter>("fd"));
    csr_file.map(CSR_FDH, true, std::make_shared<component::csr::mhpmcounterh>("fdh"));
    csr_file.map(CSR_DR, true, std::make_shared<component::csr::mhpmcounter>("dr"));
    csr_file.map(CSR_DRH, true, std::make_shared<component::csr::mhpmcounterh>("drh"));
    csr_file.map(CSR_IQ, true, std::make_shared<component::csr::mhpmcounter>("iq"));
    csr_file.map(CSR_IQH, true, std::make_shared<component::csr::mhpmcounterh>("iqh"));
    csr_file.map(CSR_IE, true, std::make_shared<component::csr::mhpmcounter>("ie"));
    csr_file.map(CSR_IEH, true, std::make_shared<component::csr::mhpmcounterh>("ieh"));
    csr_file.map(CSR_CB, true, std::make_shared<component::csr::mhpmcounter>("cb"));
    csr_file.map(CSR_CBH, true, std::make_shared<component::csr::mhpmcounterh>("cbh"));
    csr_file.map(CSR_ROB, true, std::make_shared<component::csr::mhpmcounter>("rob"));
    csr_file.map(CSR_ROBH, true, std::make_shared<component::csr::mhpmcounterh>("robh"));
    csr_file.map(CSR_PHY, true, std::make_shared<component::csr::mhpmcounter>("phy"));
    csr_file.map(CSR_PHYH, true, std::make_shared<component::csr::mhpmcounterh>("phyh"));
    csr_file.map(CSR_RAS, true, std::make_shared<component::csr::mhpmcounter>("ras"));
    csr_file.map(CSR_RASH, true, std::make_shared<component::csr::mhpmcounterh>("rash"));
    csr_file.map(CSR_FNF, true, std::make_shared<component::csr::mhpmcounterh>("fnf"));
    csr_file.map(CSR_FNFH, true, std::make_shared<component::csr::mhpmcounterh>("fnfh"));

    for(auto i = 0;i < 16;i++)
    {
        csr_file.map(0x3A0 + i, false, std::make_shared<component::csr::pmpcfg>(i));
    }

    for(auto i = 0;i < 64;i++)
    {
        csr_file.map(0x3B0 + i, false, std::make_shared<component::csr::pmpaddr>(i));
    }

    wb_stage.init();
}

static bool pause_state = false;
static bool step_state = false;
static bool wait_commit = false;
static bool gui_mode = false;

static void cmd_quit()
{
    exit(0);
}

static void cmd_continue()
{
    pause_state = false;
    step_state = false;
    wait_commit = false;
}

static void cmd_step()
{
    pause_state = false;
    step_state = true;
    wait_commit = false;
}

static void cmd_stepcommit()
{
    pause_state = false;
    step_state = true;
    wait_commit = true;
}

static void cmd_print()
{
    std::cout << "FETCH:" << std::endl;
    fetch_stage.print("\t");
    std::cout << std::endl;
    std::cout << "FETCH -> DECODE:" << std::endl;
    fetch_decode_fifo.print("\t");
    std::cout << std::endl;
    std::cout << "DECODE -> RENAME:" << std::endl;
    decode_rename_fifo.print("\t");
    std::cout << std::endl;
    std::cout << "RENAME:" << std::endl;
    std::cout << "\tstall(from issue stage) = " << outbool(t_issue_feedback_pack.stall) << std::endl;
    std::cout << std::endl;
    std::cout << "RENAME -> READREG:" << std::endl;
    rename_readreg_port.print("\t");
    std::cout << std::endl;
    std::cout << "READREG:" << std::endl;
    std::cout << "\tstall(from issue stage) = " << outbool(t_issue_feedback_pack.stall) << std::endl;
    std::cout << std::endl;
    std::cout << "READREG -> ISSUE:" << std::endl;
    readreg_issue_port.print("\t");
    std::cout << std::endl;
    std::cout << "ISSUE:" << std::endl;
    issue_stage.print("\t");
    std::cout << std::endl;
    std::cout << "ISSUE -> EXECUTE:" << std::endl;

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        std::cout << "\tALU_UNIT[" << i << "]:" << std::endl;
        issue_alu_fifo[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        std::cout << "\tBRU_UNIT[" << i << "]:" << std::endl;
        issue_bru_fifo[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        std::cout << "\tCSR_UNIT[" << i << "]:" << std::endl;
        issue_csr_fifo[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        std::cout << "\tDIV_UNIT[" << i << "]:" << std::endl;
        issue_div_fifo[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        std::cout << "\tLSU_UNIT[" << i << "]:" << std::endl;
        issue_lsu_fifo[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        std::cout << "\tMUL_UNIT[" << i << "]:" << std::endl;
        issue_mul_fifo[i] -> print("\t\t");
    }
   
    std::cout << std::endl;
    std::cout << "EXECUTE->WB:" << std::endl;

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        std::cout << "\tALU_UNIT[" << i << "]:" << std::endl;
        alu_wb_port[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        std::cout << "\tBRU_UNIT[" << i << "]:" << std::endl;
        bru_wb_port[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        std::cout << "\tCSR_UNIT[" << i << "]:" << std::endl;
        csr_wb_port[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        std::cout << "\tDIV_UNIT[" << i << "]:" << std::endl;
        div_wb_port[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        std::cout << "\tLSU_UNIT[" << i << "]:" << std::endl;
        lsu_wb_port[i] -> print("\t\t");
    }

    std::cout << std::endl;

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        std::cout << "\tMUL_UNIT[" << i << "]:" << std::endl;
        mul_wb_port[i] -> print("\t\t");
    }
   
    std::cout << std::endl;
    std::cout << "WB->COMMIT:" << std::endl;
    wb_commit_port.print("\t");
    std::cout << std::endl;
}

static void cmd_rat()
{
    rat.print("");
    std::cout << std::endl;
}

static void cmd_rob()
{
    rob.print("");
    std::cout << std::endl;
}

static void cmd_csr()
{
    csr_file.print("");
    std::cout << std::endl;
}

static void cmd_arch()
{
    std::cout << "Archtecture Registers:" << std::endl;

    for(auto i = 0;i < ARCH_REG_NUM;i++)
    {
        if(i == 0)
        {
            std::cout << "x0 = 0x" << fillzero(8) << outhex(0) << "(0)" << std::endl;
        }
        else
        {
            uint32_t phy_id;
            rat.get_commit_phy_id(i, &phy_id);
            auto v = phy_regfile.read(phy_id);
            assert(phy_regfile.read_data_valid(phy_id));
            std::cout << "x" << i << " = 0x" << fillzero(8) << outhex(v.value) << "(" << v.value << ") -> " << phy_id << std::endl;
        }
    }

    std::cout << std::endl;
}

static uint32_t get_current_pc()
{
    if(!rob.is_empty())
    {
        return rob.get_front().pc;
    }

    pipeline::decode_rename_pack_t drpack;

    if(decode_rename_fifo.get_front(&drpack) && drpack.enable)
    {
        return drpack.pc;
    }

    pipeline::fetch_decode_pack_t fdpack;

    if(fetch_decode_fifo.get_front(&fdpack) && fdpack.enable)
    {
        return fdpack.pc;
    }

    return fetch_stage.get_pc();
}

static asio::io_context tcp_server_thread_ioc;
void tcp_server_thread_entry(asio::ip::tcp::acceptor &&listener);

static void cmd_gui()
{
    try
    {
        asio::ip::tcp::acceptor listener(tcp_server_thread_ioc, {asio::ip::address::from_string("0.0.0.0"), 10240});
        listener.set_option(asio::ip::tcp::no_delay(true));
        listener.listen();
        std::cout << "Server Bind on 0.0.0.0:10240" << std::endl;
        server_thread_stopped = false;
        std::thread server_thread(tcp_server_thread_entry, std::move(listener));
        server_thread.detach();
        gui_mode = true;
    }
    catch(const std::exception &e)
    {
        std::cout << "Server Bind Port Failed:" << e.what() << std::endl;
    }
}

typedef void (*cmd_handler)();

typedef struct cmd_desc_t
{
    std::string cmd_name;
    cmd_handler handler;
}cmd_desc_t;

static cmd_desc_t cmd_list[] = {
                               {"q", cmd_quit},
                               {"c", cmd_continue},
                               {"s", cmd_step},
                               {"sc", cmd_stepcommit},
                               {"p", cmd_print},
                               {"rat", cmd_rat},
                               {"rob", cmd_rob},
                               {"csr", cmd_csr},
                               {"arch", cmd_arch},
                               {"gui", cmd_gui},
                               {"", NULL}
                               };

static bool cmd_handle(std::string cmd)
{
    if(cmd == "")
    {
        return true;
    }

    for(auto i = 0;;i++)
    {
        if(cmd_list[i].handler == NULL)
        {
            break;
        }

        if(cmd_list[i].cmd_name == cmd)
        {
            cmd_list[i].handler();
            return true;
        }
    }

    return false;
}

uint64_t get_cpu_clock_cycle()
{
    return cpu_clock_cycle;
}

static void trace_pre()
{
    branch_predictor.trace_pre();
    rat.trace_pre();
    rob.trace_pre();
    phy_regfile.trace_pre();
    store_buffer.trace_pre();
    checkpoint_buffer.trace_pre();
    csr_file.trace_pre();
    interrupt_interface.trace_pre();
    bus.trace_pre();
    ((component::slave::memory *)bus.get_slave_obj(0x80000000))->trace_pre();
    clint.trace_pre();
}

static void trace_post()
{
    clint.trace_post();
    ((component::slave::memory *)bus.get_slave_obj(0x80000000))->trace_post();
    bus.trace_post();
    interrupt_interface.trace_post();
    csr_file.trace_post();
    checkpoint_buffer.trace_post();
    store_buffer.trace_post();
    phy_regfile.trace_post();
    rob.trace_post();
    rat.trace_post();
    branch_predictor.trace_post();
}

static void run()
{
    init();
    reset();
    cmd_gui();

    std::string last_cmd = "";

    step_state = true;

    while(1)
    {
        /*if((cpu_clock_cycle >= 103005) && need_to_trigger)
        {
            step_state = true;
            wait_commit = false;
            need_to_trigger = false;
        }*/

        /*if((committed_instruction_num >= 16590) && need_to_trigger)
        {
            step_state = true;
            wait_commit = false;
            need_to_trigger = false;
        }*/

        /*if((get_current_pc() >= 0x800000b0) && need_to_trigger)
        {
            step_state = true;
            wait_commit = false;
            need_to_trigger = false;
        }*/

        if(ctrl_c_detected || (step_state && ((!wait_commit) || (wait_commit && rob.get_committed()))))
        {
            if(ctrl_c_detected)
            {
                step_state = true;
                wait_commit = false;
            }

            pause_state = true;
            trace::trace_database::flush_all_tdb();

            if(gui_mode)
            {
                //std::cout << "Wait GUI Command" << std::endl;
            }

            while(pause_state)
            {
                if(!gui_mode)
                {
                    std::cout << "Cycle" << cpu_clock_cycle << ",0x" << fillzero(8) << outhex(get_current_pc()) << ":Command>";
                    std::string cmd;
                    std::getline(std::cin, cmd);

                    if(std::cin.fail() || std::cin.eof())
                    {
                        std::cin.clear();
                        std::cout << std::endl;
                    }

                    if(cmd == "")
                    {
                        cmd = last_cmd;
                    }
                
                    last_cmd = cmd;

                    if(!cmd_handle(cmd))
                    {
                        std::cout << "Invalid Command!" << std::endl;
                    }
                }
                else
                {
                    try
                    {
                        recv_ioc.run_one();
                    }
                    catch(const std::exception &ex)
                    {
                        std::cout << ex.what() << std::endl;
                    }

                    if(program_stop)
                    {
                        break;
                    }
                }
            }

            if(program_stop)
            {
                break;
            }

            ctrl_c_detected = false;
        }

        rob.set_committed(false);
        fetch_decode_fifo.reset_pop_status();
        decode_rename_fifo.reset_pop_status();
        trace_pre();
        clint.run_pre();
        t_commit_feedback_pack = commit_stage.run();
        t_wb_feedback_pack = wb_stage.run(t_commit_feedback_pack);

        uint32_t execute_feedback_channel = 0;

        for(auto i = 0;i < ALU_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_alu_stage[i]->run(t_commit_feedback_pack);
        }

        for(auto i = 0;i < BRU_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_bru_stage[i]->run(t_commit_feedback_pack);;
        }

        for(auto i = 0;i < CSR_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_csr_stage[i]->run(t_commit_feedback_pack);
        }

        for(auto i = 0;i < DIV_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_div_stage[i]->run(t_commit_feedback_pack);
        }

        for(auto i = 0;i < LSU_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_lsu_stage[i]->run(t_commit_feedback_pack);
        }

        for(auto i = 0;i < MUL_UNIT_NUM;i++)
        {
            t_execute_feedback_pack.channel[execute_feedback_channel++] = execute_mul_stage[i]->run(t_commit_feedback_pack);
        }

        t_issue_feedback_pack = issue_stage.run(t_execute_feedback_pack, t_wb_feedback_pack, t_commit_feedback_pack);
        readreg_stage.run(t_issue_feedback_pack, t_execute_feedback_pack, t_wb_feedback_pack, t_commit_feedback_pack);
        t_rename_feedback_pack = rename_stage.run(t_issue_feedback_pack, t_commit_feedback_pack);
        t_decode_feedback_pack = decode_stage.run(t_commit_feedback_pack);
        fetch_stage.run(t_decode_feedback_pack, t_rename_feedback_pack, t_commit_feedback_pack);
        interrupt_interface.run();
        clint.run_post();
        rat.sync();
        rob.sync();
        phy_regfile.sync();
        csr_file.sync();
        store_buffer.run(t_commit_feedback_pack);
        bus.sync();
        store_buffer.sync();
        checkpoint_buffer.sync();
        branch_predictor.sync();
        interrupt_interface.sync();
        cpu_clock_cycle++;
        csr_file.write_sys(CSR_MCYCLE, (uint32_t)(cpu_clock_cycle & 0xffffffffu));
        csr_file.write_sys(CSR_MCYCLEH, (uint32_t)(cpu_clock_cycle >> 32));
        csr_file.get_tdb()->update_signal<uint8_t>(trace::domain_t::input, "commit_csrf_commit_num_add", (uint8_t)(rob.get_global_commit_num() - committed_instruction_num), 0);
        committed_instruction_num = rob.get_global_commit_num();
        csr_file.write_sys(CSR_MINSTRET, (uint32_t)(committed_instruction_num & 0xffffffffu));
        csr_file.write_sys(CSR_MINSTRETH, (uint32_t)(committed_instruction_num >> 32));
        csr_file.write_sys(CSR_BRANCHNUM, (uint32_t)(branch_num & 0xffffffffu));
        csr_file.write_sys(CSR_BRANCHNUMH, (uint32_t)(branch_num >> 32));
        csr_file.write_sys(CSR_BRANCHPREDICTED, (uint32_t)(branch_predicted & 0xffffffffu));
        csr_file.write_sys(CSR_BRANCHPREDICTEDH, (uint32_t)(branch_predicted >> 32));
        csr_file.write_sys(CSR_BRANCHHIT, (uint32_t)(branch_hit & 0xffffffffu));
        csr_file.write_sys(CSR_BRANCHHITH, (uint32_t)(branch_hit >> 32));
        csr_file.write_sys(CSR_BRANCHMISS, (uint32_t)(branch_miss & 0xffffffffu));
        csr_file.write_sys(CSR_BRANCHMISSH, (uint32_t)(branch_miss >> 32));
        csr_file.write_sys(CSR_FD, (uint32_t)(fetch_decode_fifo_full & 0xffffffffu));
        csr_file.write_sys(CSR_FDH, (uint32_t)(fetch_decode_fifo_full >> 32));
        csr_file.write_sys(CSR_DR, (uint32_t)(decode_rename_fifo_full & 0xffffffffu));
        csr_file.write_sys(CSR_DRH, (uint32_t)(decode_rename_fifo_full >> 32));
        csr_file.write_sys(CSR_IQ, (uint32_t)(issue_queue_full & 0xffffffffu));
        csr_file.write_sys(CSR_IQH, (uint32_t)(issue_queue_full >> 32));
        csr_file.write_sys(CSR_IE, (uint32_t)(issue_execute_fifo_full & 0xffffffffu));
        csr_file.write_sys(CSR_IEH, (uint32_t)(issue_execute_fifo_full >> 32));
        csr_file.write_sys(CSR_CB, (uint32_t)(checkpoint_buffer_full & 0xffffffffu));
        csr_file.write_sys(CSR_CBH, (uint32_t)(checkpoint_buffer_full >> 32));
        csr_file.write_sys(CSR_ROB, (uint32_t)(rob_full & 0xffffffffu));
        csr_file.write_sys(CSR_ROBH, (uint32_t)(rob_full >> 32));
        csr_file.write_sys(CSR_PHY, (uint32_t)(phy_regfile_full & 0xffffffffu));
        csr_file.write_sys(CSR_PHYH, (uint32_t)(phy_regfile_full >> 32));
        csr_file.write_sys(CSR_RAS, (uint32_t)(ras_full & 0xffffffffu));
        csr_file.write_sys(CSR_RASH, (uint32_t)(ras_full >> 32));
        csr_file.write_sys(CSR_FNF, (uint32_t)(fetch_not_full & 0xffffffffu));
        csr_file.write_sys(CSR_FNFH, (uint32_t)(fetch_not_full >> 32));
        trace_post();
    }
}

#ifdef WIN32
    static BOOL WINAPI console_handler(DWORD dwCtrlType)
    {
        if(dwCtrlType == CTRL_C_EVENT)
        {
            ctrl_c_detected = true;
            return TRUE;
        }

        return FALSE;
    }
#endif

static std::string socket_cmd_quit(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    recv_thread_stop = true;
    program_stop = true;
    return "ok";
}

static std::string socket_cmd_reset(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    reset();
    return "ok";
}

static std::string socket_cmd_continue(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    pause_state = false;
    step_state = false;
    wait_commit = false;
    return "ok";
}

static std::string socket_cmd_pause(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    step_state = true;
    wait_commit = false;
    return "ok";
}

static std::string socket_cmd_step(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    pause_state = false;
    step_state = true;
    wait_commit = false;
    return "ok";
}

static std::string socket_cmd_stepcommit(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    pause_state = false;
    step_state = true;
    wait_commit = true;
    return "ok";
}

static std::string socket_cmd_read_memory(std::vector<std::string> args)
{
    if(args.size() != 2)
    {
        return "argerror";
    }

    uint32_t address = 0;
    uint32_t size = 0;
    std::stringstream address_str(args[0]);
    std::stringstream size_str(args[1]);
    address_str.unsetf(std::ios::dec);
    address_str.setf(std::ios::hex);
    address_str >> address;
    size_str >> size;

    std::stringstream result;

    result << std::hex << address;

    for(auto addr = address;addr < (address + size);addr++)
    {
        result << "," << std::hex << (uint32_t)bus.read8(addr);
    }

    return result.str();
}

static std::string socket_cmd_write_memory(std::vector<std::string> args)
{
    if(args.size() != 2)
    {
        return "argerror";
    }

    uint32_t address = 0;
    std::stringstream address_str(args[0]);
    std::string data_str = args[1];
    address_str.unsetf(std::ios::dec);
    address_str.setf(std::ios::hex);
    address_str >> address;

    for(auto offset = 0;offset < (data_str.length() >> 1);offset++)
    {
        std::stringstream hex_str(data_str.substr(offset << 1, 2));
        hex_str.unsetf(std::ios::dec);
        hex_str.setf(std::ios::hex);
        uint32_t value = 0;
        hex_str >> value;
        bus.write8(address + offset, (uint8_t)value);
    }

    return "ok";
}

static std::string socket_cmd_read_archreg(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    std::stringstream result;

    for(auto i = 0;i < ARCH_REG_NUM;i++)
    {
        if(i == 0)
        {
            result << std::hex << 0;
        }
        else
        {
            uint32_t phy_id;
            rat.get_commit_phy_id(i, &phy_id);
            auto v = phy_regfile.read(phy_id);
            assert(phy_regfile.read_data_valid(phy_id));
            result << "," << std::hex << v.value;
        }
    }

    return result.str();
}

static std::string socket_cmd_read_csr(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    return csr_file.get_info_packet();
}

static std::string socket_cmd_get_pc(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    std::stringstream result;
    result << outhex(get_current_pc());
    return result.str();
}

static std::string socket_cmd_get_cycle(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    std::stringstream result;
    result << cpu_clock_cycle;
    return result.str();
}

static std::string socket_cmd_get_pipeline_status(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    json ret;
    ret["fetch"] = fetch_stage.get_json();
    ret["fetch_decode"] = fetch_decode_fifo.get_json();
    ret["decode_rename"] = decode_rename_fifo.get_json();
    ret["rename_readreg"] = rename_readreg_port.get_json();
    ret["readreg_issue"] = readreg_issue_port.get_json();
    ret["issue"] = issue_stage.get_json();

    json tie;
    json tie_alu, tie_bru, tie_csr, tie_div, tie_lsu, tie_mul;
    tie_alu = json::array();
    tie_bru = json::array();
    tie_csr = json::array();
    tie_div = json::array();
    tie_lsu = json::array();
    tie_mul = json::array();

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        tie_alu.push_back(issue_alu_fifo[i]->get_json());
    }

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        tie_bru.push_back(issue_bru_fifo[i]->get_json());
    }

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        tie_csr.push_back(issue_csr_fifo[i]->get_json());
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        tie_div.push_back(issue_div_fifo[i]->get_json());
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        tie_lsu.push_back(issue_lsu_fifo[i]->get_json());
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        tie_mul.push_back(issue_mul_fifo[i]->get_json());
    }

    tie["alu"] = tie_alu;
    tie["bru"] = tie_bru;
    tie["csr"] = tie_csr;
    tie["div"] = tie_div;
    tie["lsu"] = tie_lsu;
    tie["mul"] = tie_mul;
    ret["issue_execute"] = tie;

    json tew;
    json tew_alu, tew_bru, tew_csr, tew_div, tew_lsu, tew_mul;
    tew_alu = json::array();
    tew_bru = json::array();
    tew_csr = json::array();
    tew_div = json::array();
    tew_lsu = json::array();
    tew_mul = json::array();

    for(auto i = 0;i < ALU_UNIT_NUM;i++)
    {
        tew_alu.push_back(alu_wb_port[i]->get_json());
    }

    for(auto i = 0;i < BRU_UNIT_NUM;i++)
    {
        tew_bru.push_back(bru_wb_port[i]->get_json());
    }

    for(auto i = 0;i < CSR_UNIT_NUM;i++)
    {
        tew_csr.push_back(csr_wb_port[i]->get_json());
    }

    for(auto i = 0;i < DIV_UNIT_NUM;i++)
    {
        tew_div.push_back(div_wb_port[i]->get_json());
    }

    for(auto i = 0;i < LSU_UNIT_NUM;i++)
    {
        tew_lsu.push_back(lsu_wb_port[i]->get_json());
    }

    for(auto i = 0;i < MUL_UNIT_NUM;i++)
    {
        tew_mul.push_back(mul_wb_port[i]->get_json());
    }

    tew["alu"] = tew_alu;
    tew["bru"] = tew_bru;
    tew["csr"] = tew_csr;
    tew["div"] = tew_div;
    tew["lsu"] = tew_lsu;
    tew["mul"] = tew_mul;
    ret["execute_wb"] = tew;
    ret["wb_commit"] = wb_commit_port.get_json();

    ret["issue_feedback_pack"] = t_issue_feedback_pack.get_json();
    ret["wb_feedback_pack"] = t_wb_feedback_pack.get_json();
    ret["commit_feedback_pack"] = t_commit_feedback_pack.get_json();
    ret["rob"] = rob.get_json();
    return ret.dump();
}

static std::string socket_cmd_get_commit_num(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    std::stringstream result;
    result << rob.get_commit_num();
    rob.clear_commit_num();
    return result.str();
}

static std::string socket_cmd_get_finish(std::vector<std::string> args)
{
    if(args.size() != 0)
    {
        return "argerror";
    }

    std::stringstream result;
    result << (int)csr_file.read_sys(CSR_FINISH);
    return result.str();
}

typedef std::string (*socket_cmd_handler)(std::vector<std::string> args);

typedef struct socket_cmd_desc_t
{
    std::string cmd_name;
    socket_cmd_handler handler;
}socket_cmd_desc_t;

static socket_cmd_desc_t socket_cmd_list[] = {
                                      {"quit", socket_cmd_quit},
                                      {"reset", socket_cmd_reset},
                                      {"continue", socket_cmd_continue},
                                      {"pause", socket_cmd_pause},
                                      {"step", socket_cmd_step},
                                      {"stepcommit", socket_cmd_stepcommit},
                                      {"read_memory", socket_cmd_read_memory},
                                      {"write_memory", socket_cmd_write_memory},
                                      {"read_archreg", socket_cmd_read_archreg},
                                      {"read_csr", socket_cmd_read_csr},
                                      {"get_pc", socket_cmd_get_pc},
                                      {"get_cycle", socket_cmd_get_cycle},
                                      {"get_pipeline_status", socket_cmd_get_pipeline_status},
                                      {"get_commit_num", socket_cmd_get_commit_num},
                                      {"get_finish", socket_cmd_get_finish},
                                      {"", NULL}
                                      };

void send_cmd_result(asio::ip::tcp::socket &soc, std::string result)
{
    char *buffer = new char[result.length() + 4];
    *(uint32_t *)buffer = (uint32_t)result.length();
    memcpy(buffer + 4, result.data(), result.length());
    soc.send(asio::buffer(buffer, result.length() + 4));
    delete[] buffer;
}

void socket_cmd_handle(asio::ip::tcp::socket &soc, std::string rev_str)
{
    std::stringstream stream(rev_str);
    std::vector<std::string> cmd_arg_list;
    
    while(!stream.eof())
    {
        std::string t;
        stream >> t;
        cmd_arg_list.push_back(t);
    }

    if(cmd_arg_list.size() >= 2)
    {
        auto prefix = cmd_arg_list[0];
        auto cmd = cmd_arg_list[1];
        cmd_arg_list.erase(cmd_arg_list.begin());
        cmd_arg_list.erase(cmd_arg_list.begin());
        std::string ret = "notfound";

        for(auto i = 0;;i++)
        {
            if(socket_cmd_list[i].handler == NULL)
            {
                break;
            }

            if(socket_cmd_list[i].cmd_name == cmd)
            {
                ret = socket_cmd_list[i].handler(cmd_arg_list);
                break;
            }
        }

        asio::post(send_ioc, [&soc, prefix, cmd, ret]{send_cmd_result(soc, prefix + " " + cmd + " " + ret);});
    }
}

void tcp_server_thread_receive_entry(asio::ip::tcp::socket &soc)
{
    uint32_t length = 0;
    size_t rev_length = 0;
    char *packet_payload = nullptr;
    char packet_length[4];
    std::string rev_str = "";

    while(!recv_thread_stop)
    {
        try
        {
            if(packet_payload == nullptr)
            {
                rev_length += soc.receive(asio::buffer(packet_length + rev_length, sizeof(packet_length) - rev_length));
                auto finish = rev_length == sizeof(packet_length);

                if(finish)
                {
                    length = *(uint32_t *)packet_length;
                    rev_str.resize(length);
                    packet_payload = rev_str.data();
                    rev_length = 0;
                }
            }
            else
            {
                rev_length += soc.receive(asio::buffer(packet_payload + rev_length, length - rev_length));
                auto finish = rev_length == length;

                if(finish)
                {
                    packet_payload = nullptr;
                    rev_length = 0;

                    std::stringstream stream(rev_str);
                    std::vector<std::string> cmd_arg_list;
    
                    while(!stream.eof())
                    {
                        std::string t;
                        stream >> t;
                        cmd_arg_list.push_back(t);
                    }

                    if((cmd_arg_list.size() >= 2) && (cmd_arg_list[1] == std::string("pause")))
                    {
                        ctrl_c_detected = true;
                    }
                    
                    asio::post(recv_ioc, [&soc, rev_str]{socket_cmd_handle(soc, rev_str);});
                }
            }
        }
        catch(const std::exception &ex)
        {
            std::cout << ex.what() << std::endl;
            break;
        }
    }

    recv_thread_stopped = true;
}

void tcp_server_thread_entry(asio::ip::tcp::acceptor &&listener)
{
    try
    {
        while(!program_stop)
        {
            std::cout << "Wait GUI Connection" << std::endl;
            auto soc = listener.accept();
            soc.set_option(asio::ip::tcp::no_delay(true));
            std::cout << "GUI Connected" << std::endl;
            recv_thread_stop = false;
            recv_thread_stopped = false;
            std::thread rev_thread(tcp_server_thread_receive_entry, std::ref(soc));

            try
            {
                while(1)
                {
                    send_ioc.run_one_for(std::chrono::milliseconds(1000));

                    if(recv_thread_stopped)
                    {
                        break;
                    }
                }
            }
            catch(const std::exception &ex)
            {
                std::cout << ex.what() << std::endl;
            }
            
            recv_thread_stop = true;
            rev_thread.join();
            soc.shutdown(asio::socket_base::shutdown_both);
            soc.close();
            std::cout << "GUI Disconnected" << std::endl;
        }
        
        listener.close();
        server_thread_stopped = true;
    }
    catch(const std::exception &ex)
    {
        std::cout << ex.what() << std::endl;
    }
}

int main()
{
    test::test();

    #ifdef WIN32
        if(!SetConsoleCtrlHandler(console_handler, TRUE))
        {
            std::cout << "SetControlCtrlHandler Failed!" << std::endl;
        }
    #endif

    run();
    while(!server_thread_stopped);
    while(!charfifo_thread_stopped);
    return 0;
}
