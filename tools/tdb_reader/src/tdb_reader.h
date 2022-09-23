#pragma once
#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>
#include <cassert>

namespace trace
{
    static const int FIELDNAME_LENGTH = 255;
    static const char *FEATURE_STRING = "TRACEDB";//the length of this string must be 7

    #pragma pack(1)
    typedef struct fieldinfo
    {
        char name[FIELDNAME_LENGTH + 1];
        uint32_t offset;
        uint32_t size;
        uint32_t element_bitsize;
        uint32_t element_size;
        uint32_t element_num;
    }fieldinfo_t;

    typedef struct headerinfo
    {
        char featurestr[8];
        uint32_t fieldinfo_num;
        uint32_t input_fieldinfo_num;
        uint32_t output_fieldinfo_num;
        uint32_t status_fieldinfo_num;
        uint32_t data_offset;
        uint32_t row_size;
    }headerinfo_t;
    #pragma pack()

    enum class domain_t : int
    {
        input,
        output,
        status
    };

    class trace_reader
    {
        private:
            std::ifstream db;
            bool _is_open;
            std::vector<fieldinfo_t> input_fieldinfo_list;
            std::vector<fieldinfo_t> output_fieldinfo_list;
            std::vector<fieldinfo_t> status_fieldinfo_list;
            std::unordered_map<std::string, int> input_fieldid_map;
            std::unordered_map<std::string, int> output_fieldid_map;
            std::unordered_map<std::string, int> status_fieldid_map;
            headerinfo_t hinfo;
            char *row_buffer;
            uint64_t cur_row;
            uint64_t file_size;
            uint64_t row_num;

            std::unordered_map<std::string, int> &get_map(domain_t domain);
            std::vector<fieldinfo_t> &get_list(domain_t domain);
            std::string get_domain_name(domain_t domain);
            void check_open();
            void check_row_index(uint64_t index);
            void check_name_exist(domain_t domain, std::string name);
            void check_name_nonexist(domain_t domain, std::string name);
            void check_index(std::string name, uint64_t index, uint64_t count);

        public:
            trace_reader();
            ~trace_reader();
            void open(std::string filename);
            bool is_open();
            void close();
            bool read_cur_row();
            void move_row(uint64_t index);
            void move_to_next_row();
            void move_to_prev_row();
            uint64_t get_cur_row();
            void *read_field(domain_t domain, std::string name, uint32_t index);
            uint32_t get_field_size(domain_t domain, std::string name);
    };
}