#include "dut.h"
#include <iostream>
#include <asio.hpp>
#include <string>
#include <sstream>
#include <iomanip>
#include <limits>
#include <unordered_map>

//#define TRACE

asio::io_context ioc;
asio::ip::tcp::endpoint endpoint(asio::ip::address::from_string("193.168.119.1"), 10240);
asio::ip::tcp::socket soc(ioc);

static std::string dut_receive()
{
    uint32_t length = 0;
    size_t rev_length = 0;
    char *packet_payload = nullptr;
    char packet_length[4];
    std::string rev_str = "";

    while(1)
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
                //std::cout << "rev_str = " << rev_str << std::endl;
                return rev_str;
            }
        }
    }
}

void dut_connect()
{
    soc.connect(endpoint);   
    soc.set_option(asio::ip::tcp::no_delay(true));
}

void dut_disconnect()
{
    soc.close();
}

static std::string& trim(std::string &s)   
{  
    if (s.empty())   
    {  
        return s;  
    }  
  
    s.erase(0,s.find_first_not_of(" "));  
    s.erase(s.find_last_not_of(" ") + 1);  
    return s;  
}  

static std::string dut_command(std::string command)
{
    std::string str = std::string("main ") + command;
    uint32_t len = str.length();
    soc.send(asio::buffer((char *)&len, 4));
    soc.send(asio::buffer(str.data(), str.length()));
    std::string rev_str = dut_receive();
    std::stringstream stream(rev_str);
    std::vector<std::string> cmd_arg_list;

    while(!stream.eof())
    {
        std::string t;
        stream >> t;
        cmd_arg_list.push_back(t);
    }

    if(cmd_arg_list.size() > 2)
    {
        std::stringstream stream2(rev_str);
        std::string s1, s2;
        std::string result;
        stream2 >> s1;
        stream2 >> s2;
        std::getline(stream2, result);
        trim(result);
        return result;
    }

    return "";
}

void dut_reset() 
{
    //std::cout << "dut_reset" << std::endl;
    dut_command("pause");
    dut_command("reset");
}

int dut_commit() 
{
    std::stringstream ss(dut_command("get_commit_num"));
    int commit = 0;
    ss >> commit;

#ifdef TRACE
    std::cout << "DUT commits " << commit << " instructions" << std::endl;
#endif
    
    return commit;
}

void dut_load(uint32_t address, char *buffer, uint32_t size)
{
    //std::cout << "dut_load" << std::endl;
    std::stringstream ss;

    ss << "write_memory " << std::setiosflags(std::ios::uppercase) << std::hex << address << " ";
    
    for(auto i = 0;i < size;i++)
    {
        ss << std::setw(2) << std::setfill('0') << std::setiosflags(std::ios::uppercase) << std::hex << ((uint32_t)(uint8_t)buffer[i]);
    }

    dut_command(ss.str());
}

void dut_step(int cycle) 
{
#ifdef TRACE
    std::cout << "DUT one cycle" << std::endl;
#endif

    for (int i = 0; i < cycle; i++) 
    {
        dut_command("step");
    }
}

bool dut_checkfinish()
{
    return dut_command("get_finish") != std::string("-1");
}

void dut_getregs(qemu_regs_t *regs) 
{
    memset(regs, 0, sizeof(*regs));
    std::string archreg_result = dut_command("read_archreg");
    std::stringstream archreg_ss(archreg_result);

    for(auto i = 0;i <= 31;i++)
    {
        std::string token;
        std::getline(archreg_ss, token, ',');
        std::stringstream ss2(token);
        ss2.unsetf(std::ios::dec);
        ss2.setf(std::ios::hex);
        uint32_t x = 0;
        ss2 >> x;
        regs->gpr[i] = x;
    }

    std::string pc_result = dut_command("get_pc");
    std::stringstream pc_ss(pc_result);
    pc_ss.unsetf(std::ios::dec);
    pc_ss.setf(std::ios::hex);
    uint32_t pc = 0;
    pc_ss >> pc;
    regs->array[32] = pc;

    std::string csr_result = dut_command("read_csr");
    std::stringstream csr_ss(csr_result);
    std::unordered_map<std::string, std::uint32_t> csr_map;
    std::string csr_item;

    while(std::getline(csr_ss, csr_item, ','))
    {
        std::stringstream csr_item_ss(csr_item);
        csr_item_ss.unsetf(std::ios::dec);
        csr_item_ss.setf(std::ios::hex);
        std::string csr_name;
        std::getline(csr_item_ss, csr_name, ':');
        uint32_t csr_value;
        csr_item_ss >> csr_value;
        csr_map[csr_name] = csr_value;
    }

    regs->mstatus = csr_map["mstatus"];
    regs->medeleg = csr_map["medeleg"];
    regs->mideleg = csr_map["mideleg"];
    regs->mie = csr_map["mie"];
    regs->mip = csr_map["mip"];
    regs->mtvec = csr_map["mtvec"];
    regs->mscratch = csr_map["mscratch"];
    regs->mepc = csr_map["mepc"];
    regs->mcause = csr_map["mcause"];
    regs->mtval = csr_map["mtval"];
}

void dut_write_counter(int value) 
{
    // TODO have to write the GPR and the counter (timer interrupt), GPR for mfc0, counter for every step to keep up with qemu
}
