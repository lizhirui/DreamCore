#include "tdb_reader.h"
#include <cstring>

namespace trace
{
    std::unordered_map<std::string, int> &trace_reader::get_map(domain_t domain)
    {
        switch(domain)
        {
            case domain_t::input:
                return input_fieldid_map;
            case domain_t::output:
                return output_fieldid_map;
            case domain_t::status:
                return status_fieldid_map;
            default:
                assert(false);
        }
    }

    std::vector<fieldinfo_t> &trace_reader::get_list(domain_t domain)
    {
        switch(domain)
        {
            case domain_t::input:
                return input_fieldinfo_list;
            case domain_t::output:
                return output_fieldinfo_list;
            case domain_t::status:
                return status_fieldinfo_list;
            default:
                assert(false);
        }
    }

    std::string trace_reader::get_domain_name(domain_t domain)
    {
        switch(domain)
        {
            case domain_t::input:
                return "INPUT";
            case domain_t::output:
                return "OUTPUT";
            case domain_t::status:
                return "STATUS";
            default:
                assert(false);
        }
    }

    void trace_reader::check_open()
    {
        if(!_is_open)
        {
            std::cout << "No trace database is open!" << std::endl;
            assert(false);
        }
    }

    void trace_reader::check_row_index(uint64_t index)
    {
        if(index > row_num)
        {
            std::cout << "Index " << index << " is out of range [0, " << row_num << "]!" << std::endl;
            assert(false);
        }
    }

    void trace_reader::check_name_exist(domain_t domain, std::string name)
    {
        if(get_map(domain).find(name) == get_map(domain).end())
        {
            std::cout << "Field name " << name << " isn't exist in domain " << get_domain_name(domain) << "!" << std::endl;
            assert(false);
        }
    }

    void trace_reader::check_name_nonexist(domain_t domain, std::string name)
    {
        if(get_map(domain).find(name) != get_map(domain).end())
        {
            std::cout << "Field name " << name << " is already exist in domain " << get_domain_name(domain) << "!" << std::endl;
            assert(false);
        }
    }

    void trace_reader::check_index(std::string name, uint64_t index, uint64_t count)
    {
        if(index >= count)
        {
            std::cout << "Field " << name << ": Index " << index << " is out of range [0, " << count << ")!" << std::endl;
            assert(false);
        }
    }

    trace_reader::trace_reader()
    {
        _is_open = false;
        row_buffer = NULL;
    }

    trace_reader::~trace_reader()
    {
        if(row_buffer)
        {
            delete[] row_buffer;
            row_buffer = NULL;
        }
    }

    void trace_reader::open(std::string filename)
    {
        if(db.is_open())
        {
            db.close();
        }

        db.open(filename, std::ios::binary);
        _is_open = db.is_open();
        
        if(!_is_open)
        {
            std::cout << "Failed to open trace database %s!\n" << filename << std::endl;
            assert(false);
        }

        db.read((char*)&hinfo, sizeof(hinfo));
        assert(std::strncmp(hinfo.featurestr, FEATURE_STRING, sizeof(FEATURE_STRING)) == 0);
        printf("fieldinfo_num = %u\n", hinfo.fieldinfo_num);
        printf("input_fieldinfo_num = %u\n", hinfo.input_fieldinfo_num);
        printf("output_fieldinfo_num = %u\n", hinfo.output_fieldinfo_num);
        printf("status_fieldinfo_num = %u\n", hinfo.status_fieldinfo_num);
        assert(hinfo.fieldinfo_num > 0);
        assert(hinfo.data_offset > 0);
        assert(hinfo.row_size > 0);
        row_buffer = new char[hinfo.row_size];
        assert(row_buffer);
        cur_row = 0;
        
        fieldinfo_t finfo;

        for(uint32_t i = 0; i < hinfo.input_fieldinfo_num; i++)
        {
            db.read((char*)&finfo, sizeof(fieldinfo));
            input_fieldinfo_list.push_back(finfo);
            input_fieldid_map[finfo.name] = i;
        }

        for(uint32_t i = 0; i < hinfo.output_fieldinfo_num; i++)
        {
            db.read((char*)&finfo, sizeof(fieldinfo));
            output_fieldinfo_list.push_back(finfo);
            output_fieldid_map[finfo.name] = i;
        }

        for(uint32_t i = 0; i < hinfo.status_fieldinfo_num; i++)
        {
            db.read((char*)&finfo, sizeof(fieldinfo));
            status_fieldinfo_list.push_back(finfo);
            status_fieldid_map[finfo.name] = i;
        }

        db.seekg(0, std::ios::end);
        file_size = db.tellg();
        row_num = (file_size - hinfo.data_offset) / hinfo.row_size;
        printf("data_offset = %u\n", hinfo.data_offset);
        printf("row_size = %u\n", hinfo.row_size);
        printf("file_size = %llu\n", (long long unsigned int)file_size);
        assert((row_num * hinfo.row_size) == (file_size - hinfo.data_offset));
        db.seekg(hinfo.data_offset, std::ios::beg);
    }

    bool trace_reader::is_open()
    {
        return _is_open;
    }

    void trace_reader::close()
    {
        if(db.is_open())
        {
            db.close();
        }

        _is_open = false;
    }

    bool trace_reader::read_cur_row()
    {
        check_open();

        if(cur_row >= row_num)
        {
            return false;
        }

        db.seekg(hinfo.data_offset + hinfo.row_size * cur_row, std::ios::beg);
        db.read(row_buffer, hinfo.row_size);
        return true;
    }

    void trace_reader::move_row(uint64_t index)
    {
        check_open();
        check_row_index(index);
        cur_row = index;
    }
    
    void trace_reader::move_to_next_row()
    {
        check_open();
        check_row_index(cur_row);
        cur_row++;
    }

    void trace_reader::move_to_prev_row()
    {
        check_open();

        if(cur_row == 0)
        {
            std::cout << "Current row is 0, can't move to prev row!" << std::endl;
            assert(false);
        }

        cur_row--;
    }

    uint64_t trace_reader::get_cur_row()
    {
        check_open();
        return cur_row;
    }

    void *trace_reader::read_field(domain_t domain, std::string name, uint32_t index)
    {
        check_open();
        check_name_exist(domain, name);
        uint32_t fieldid = get_map(domain)[name];
        auto const &item = get_list(domain)[fieldid];
        check_index(name, index, item.element_num);
        return (void *)(((char *)row_buffer) + item.offset + (index * item.element_size));
    }

    uint32_t trace_reader::get_field_size(domain_t domain, std::string name)
    {
        check_open();
        check_name_exist(domain, name);
        uint32_t fieldid = get_map(domain)[name];
        auto const &item = get_list(domain)[fieldid];
        return item.element_size;
    }
}