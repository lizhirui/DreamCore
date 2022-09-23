`ifndef __TDB_READER_SVH__
`define __TDB_READER_SVH__

    package tdb_reader;
        import "DPI-C" context function chandle tdb_new();
        import "DPI-C" context function void tdb_free(chandle reader);
        import "DPI-C" context function void tdb_open(chandle reader, string filename);
        import "DPI-C" context function int tdb_is_open(chandle reader);
        import "DPI-C" context function void tdb_close(chandle reader);
        import "DPI-C" context function int tdb_read_cur_row(chandle reader);
        import "DPI-C" context function void tdb_move_row(chandle reader);
        import "DPI-C" context function void tdb_move_to_next_row(chandle reader);
        import "DPI-C" context function void tdb_move_to_prev_row(chandle reader);
        import "DPI-C" context function longint unsigned tdb_get_cur_row(chandle reader);
        import "DPI-C" context function byte unsigned tdb_get_uint8(chandle reader, int domain, string name, int unsigned index);
        import "DPI-C" context function shortint unsigned tdb_get_uint16(chandle reader, int domain, string name, int unsigned index);
        import "DPI-C" context function int unsigned tdb_get_uint32(chandle reader, int domain, string name, int unsigned index);
        import "DPI-C" context function longint unsigned tdb_get_uint64(chandle reader, int domain, string name, int unsigned index);
        import "DPI-C" context function void tdb_get_vector(input chandle reader, input int domain, input string name, output byte unsigned out[], input int unsigned index);

        const int DOMAIN_INPUT = 0;
        const int DOMAIN_OUTPUT = 1;
        const int DOMAIN_STATUS = 2;

        class tdb_reader;
            local chandle reader;
            local int disposed;

            function new();
                reader = tdb_new();
                disposed = 0;
            endfunction

            function void dispose();
                tdb_free(reader);
                disposed = 1;
            endfunction

            function void open(string filename);
                tdb_open(reader, filename);
            endfunction

            function int is_open();
                return tdb_is_open(reader);
            endfunction

            function void close();
                tdb_close(reader);
            endfunction

            function int read_cur_row();
                return tdb_read_cur_row(reader);
            endfunction

            function void move_row();
                tdb_move_row(reader);
            endfunction

            function void move_to_next_row();
                tdb_move_to_next_row(reader);
            endfunction

            function void move_to_prev_row();
                tdb_move_to_prev_row(reader);
            endfunction

            function longint unsigned get_cur_row();
                return tdb_get_cur_row(reader);
            endfunction

            function byte unsigned get_uint8(int domain, string name, int unsigned index);
                return tdb_get_uint8(reader, domain, name, index);
            endfunction

            function shortint unsigned get_uint16(int domain, string name, int unsigned index);
                return tdb_get_uint16(reader, domain, name, index);
            endfunction

            function int unsigned get_uint32(int domain, string name, int unsigned index);
                return tdb_get_uint32(reader, domain, name, index);
            endfunction

            function longint unsigned get_uint64(int domain, string name, int unsigned index);
                return tdb_get_uint64(reader, domain, name, index);
            endfunction

            virtual class get_vector#(parameter VECTOR_LENGTH = 1);
                static function logic[VECTOR_LENGTH - 1:0] _do(tdb_reader tdb_reader_obj, int domain, string name, int unsigned index);
                    localparam VECTOR_GROUP_NUM = (VECTOR_LENGTH + 8 - 1) / 8;
                    byte unsigned unpacked_buf[0:VECTOR_GROUP_NUM - 1];
                    logic[VECTOR_LENGTH - 1:0] packed_buf;
                    int unsigned i;
                    tdb_get_vector(tdb_reader_obj.reader, domain, name, unpacked_buf, index);

                    for(i = 0;i < VECTOR_GROUP_NUM;i++) begin
                        packed_buf[i * 8 +: 8] = unpacked_buf[i];
                    end

                    return packed_buf;
                endfunction
            endclass
        endclass
    endpackage
`endif