`timescale 1ns / 100ps
`include "tdb_reader.svh"

import tdb_reader::*;

module test();
    tdb_reader tdb;
    int unsigned pc;
    int unsigned opcode;
    int i;

    initial begin
        tdb = new;
        tdb.open("/home/lizhirui/privwork/rtl_part/trace/fetch.tdb");

        while(tdb.read_cur_row()) begin
            pc = tdb.get_uint32(DOMAIN_STATUS, "pc", 0);
            $display("pc: %x", pc);

            for(i = 0;i < 4;i++) begin
                opcode = tdb.get_uint32(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in.value", i);
                $display("opcode[%d]: %x", i, opcode);
            end

            tdb.move_to_next_row();
            
            if(tdb.get_cur_row() >= 20) begin
                break; 
            end
        end
    end
endmodule