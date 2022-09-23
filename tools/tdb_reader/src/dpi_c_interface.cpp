#include "tdb_reader.h"
#include "svdpi.h"
#include <cstring>

using namespace trace;

extern "C"
{
    trace_reader *tdb_new()
    {
        auto reader = new trace_reader();
        assert(reader);
        return reader;
    }

    void tdb_free(trace_reader *reader)
    {
        delete reader;
    }

    void tdb_open(trace_reader *reader, const char *filename)
    {
        reader->open(filename);
    }

    int tdb_is_open(trace_reader *reader)
    {
        return (int)reader->is_open();
    }

    void tdb_close(trace_reader *reader)
    {
        reader->close();
    }

    int tdb_read_cur_row(trace_reader *reader)
    {
        return (int)reader->read_cur_row();
    }

    void tdb_move_row(trace_reader *reader, uint64_t index)
    {
        reader->move_row(index);
    }

    void tdb_move_to_next_row(trace_reader *reader)
    {
        reader->move_to_next_row();
    }

    void tdb_move_to_prev_row(trace_reader *reader)
    {
        reader->move_to_prev_row();
    }

    uint64_t tdb_get_cur_row(trace_reader *reader)
    {
        return reader->get_cur_row();
    }

    void check_element_size(trace_reader *reader, int domain, std::string name, uint32_t expected_size)
    {
        uint32_t actual_size = reader->get_field_size((domain_t)domain, name);

        if(expected_size != actual_size)
        {
            std::cout << "Field " << name << " has wrong size, expected " << expected_size << ", actual " << actual_size << std::endl;
            assert(false);
        }
    }

    uint8_t tdb_get_uint8(trace_reader *reader, int domain, const char *name, uint32_t index)
    {
        check_element_size(reader, domain, name, sizeof(uint8_t));
        return *((uint8_t *)reader->read_field((domain_t)domain, name, index));
    }
    
    uint16_t tdb_get_uint16(trace_reader *reader, int domain, const char *name, uint32_t index)
    {
        check_element_size(reader, domain, name, sizeof(uint16_t));
        return *((uint16_t *)reader->read_field((domain_t)domain, name, index));
    }

    uint32_t tdb_get_uint32(trace_reader *reader, int domain, const char *name, uint32_t index)
    {
        check_element_size(reader, domain, name, sizeof(uint32_t));
        return *((uint32_t *)reader->read_field((domain_t)domain, name, index));
    }

    uint64_t tdb_get_uint64(trace_reader *reader, int domain, const char *name, uint32_t index)
    {
        check_element_size(reader, domain, name, sizeof(uint64_t));
        return *((uint64_t *)reader->read_field((domain_t)domain, name, index));
    }

    void tdb_get_vector(trace_reader *reader, int domain, const char *name, const svOpenArrayHandle out, uint32_t index)
    {
        uint32_t size = svSize(out, 1);
        void *buf = svGetArrayPtr(out);
        check_element_size(reader, domain, name, size);
        auto data = reader->read_field((domain_t)domain, name, index);
        std::memcpy(buf, data, size);
    }
}