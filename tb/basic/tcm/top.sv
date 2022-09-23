`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;
    logic[`ADDR_WIDTH - 1:0] bus_tcm_fetch_addr;
    logic bus_tcm_fetch_rd;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_fetch_data;
    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_read_addr;
    logic[`ADDR_WIDTH - 1:0] bus_tcm_stbuf_write_addr;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_read_size;
    logic[`SIZE_WIDTH - 1:0] bus_tcm_stbuf_write_size;
    logic[`REG_DATA_WIDTH - 1:0] bus_tcm_stbuf_data;
    logic bus_tcm_stbuf_rd;
    logic bus_tcm_stbuf_wr;
    logic[`BUS_DATA_WIDTH - 1:0] tcm_bus_stbuf_data;

    integer i;
    logic[`ADDR_WIDTH - 1:0] cur_addr;
    logic[`REG_DATA_WIDTH - 1:0] cur_data;
    
    tcm tcm_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_fetch_rd = 'b1;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_read_size = 'b0;
        bus_tcm_stbuf_write_size = 'b0;
        bus_tcm_stbuf_data = 'b0;
        bus_tcm_stbuf_rd = 'b1;
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        rst = 0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_write_size = 'd1;
        bus_tcm_stbuf_data = 'ha5a5a5a5;
        bus_tcm_stbuf_wr = 'b1;
        wait_clk();
        bus_tcm_stbuf_wr = 'b0;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_read_size = 'd1;
        wait_clk();
        assert(tcm_bus_stbuf_data[7:0] == 'ha5) else $finish;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_write_size = 'd4;
        bus_tcm_stbuf_data = 'h12345678;
        bus_tcm_stbuf_wr = 'b1;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'h4;
        bus_tcm_stbuf_write_size = 'd4;
        bus_tcm_stbuf_data = 'h90abcdef;
        bus_tcm_stbuf_wr = 'b1;
        wait_clk();
        bus_tcm_stbuf_wr = 'b0;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_read_size = 'd4;
        bus_tcm_fetch_addr = 'b0;
        wait_clk();
        assert(tcm_bus_stbuf_data[31:0] == 'h12345678) else $finish;
        assert(tcm_bus_fetch_data[31:0] == 'h12345678) else $finish;
        wait_clk();
        bus_tcm_stbuf_read_addr = 'h4;
        bus_tcm_fetch_addr = 'h4;
        wait_clk();
        assert(tcm_bus_stbuf_data[31:0] == 'h90abcdef) else $finish;
        assert(tcm_bus_fetch_data[31:0] == 'h90abcdef) else $finish;
        wait_clk();
        bus_tcm_stbuf_read_addr = 'h3;
        bus_tcm_fetch_addr = 'h3;
        wait_clk();
        assert(tcm_bus_stbuf_data[31:0] == 'habcdef12) else $finish;
        assert(tcm_bus_fetch_data[31:0] == 'habcdef12) else $finish;
        wait_clk();
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'h8;
        bus_tcm_stbuf_write_size = 'd2;
        bus_tcm_stbuf_data = 'ha55a;
        bus_tcm_stbuf_wr = 'b1;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'ha;
        bus_tcm_stbuf_write_size = 'd1;
        bus_tcm_stbuf_data = 'hcc;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'hb;
        bus_tcm_stbuf_write_size = 'd4;
        bus_tcm_stbuf_data = 'ha5cbeeac;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'hf;
        bus_tcm_stbuf_write_size = 'd1;
        bus_tcm_stbuf_data = 'hcb;
        wait_clk();
        bus_tcm_stbuf_write_addr = 'h10;
        bus_tcm_stbuf_write_size = 'd4;
        bus_tcm_stbuf_data = 'haabbccdd;
        wait_clk();
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        assert(tcm_bus_fetch_data == 128'hcba5cbee_accca55a_90abcdef_12345678) else $finish;
        assert(tcm_bus_stbuf_data == 128'hcba5cbee_accca55a_90abcdef_12345678) else $finish;
        wait_clk();
        bus_tcm_fetch_addr = 'h4;
        bus_tcm_stbuf_read_addr = 'h4;
        wait_clk();
        assert(tcm_bus_fetch_data[95:0] == 96'hcba5cbee_accca55a_90abcdef) else $finish;
        assert(tcm_bus_stbuf_data[95:0] == 96'hcba5cbee_accca55a_90abcdef) else $finish;
        wait_clk();
        bus_tcm_fetch_addr = 'h5;
        bus_tcm_stbuf_read_addr = 'h5;
        wait_clk();
        assert(tcm_bus_fetch_data[87:0] == 88'hcba5cbee_accca55a_90abcd) else $finish;
        assert(tcm_bus_stbuf_data[87:0] == 88'hcba5cbee_accca55a_90abcd) else $finish;
        wait_clk();
        bus_tcm_fetch_addr = 'h8;
        bus_tcm_stbuf_read_addr = 'h8;
        wait_clk();
        assert(tcm_bus_fetch_data[63:0] == 64'hcba5cbee_accca55a) else $finish;
        assert(tcm_bus_stbuf_data[63:0] == 64'hcba5cbee_accca55a) else $finish;
        wait_clk();
        bus_tcm_fetch_addr = 'hc;
        bus_tcm_stbuf_read_addr = 'hc;
        wait_clk();
        assert(tcm_bus_fetch_data[63:0] == 64'haabbccdd_cba5cbee) else $finish;
        assert(tcm_bus_stbuf_data[63:0] == 64'haabbccdd_cba5cbee) else $finish;
    endtask

    task test_sequence;
        rst = 1;
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_fetch_rd = 'b1;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_read_size = 'b0;
        bus_tcm_stbuf_write_size = 'b0;
        bus_tcm_stbuf_data = 'b0;
        bus_tcm_stbuf_rd = 'b1;
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();

        for(i = 0;i < 4096;i++) begin
            bus_tcm_stbuf_write_addr = i * 4;
            bus_tcm_stbuf_write_size = 'd4;
            bus_tcm_stbuf_data = i;
            bus_tcm_stbuf_wr = 'b1;
            wait_clk();
        end

        bus_tcm_stbuf_wr = 'b0;
        wait_clk();

        for(i = 0;i < 4096;i++) begin
            bus_tcm_stbuf_read_addr = i * 4;
            bus_tcm_fetch_addr = i * 4;
            wait_clk();
            assert(tcm_bus_stbuf_data[31:0] == i) else $finish;
            assert(tcm_bus_fetch_data[31:0] == i) else $finish;
            wait_clk();
        end
    endtask

    task test_sequence_cross;
        rst = 1;
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_fetch_rd = 'b1;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_read_size = 'b0;
        bus_tcm_stbuf_write_size = 'b0;
        bus_tcm_stbuf_data = 'b0;
        bus_tcm_stbuf_rd = 'b1;
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();

        for(i = 0;i < 4096;i++) begin
            bus_tcm_stbuf_write_addr = i * 4;
            bus_tcm_stbuf_write_size = 'd4;
            bus_tcm_stbuf_data = i + 65536;
            bus_tcm_stbuf_wr = 'b1;
            wait_clk();
        end

        bus_tcm_stbuf_wr = 'b0;
        wait_clk();

        for(i = 0;i < 4096;i++) begin
            bus_tcm_stbuf_read_addr = i * 4;
            bus_tcm_fetch_addr = i * 4;
            wait_clk();
            cur_data = i + 65536;
            assert(tcm_bus_stbuf_data[31:0] == cur_data) else $finish;
            assert(tcm_bus_fetch_data[31:0] == cur_data) else $finish;
            wait_clk();
            bus_tcm_stbuf_read_addr = i * 4 + 2;
            bus_tcm_fetch_addr = i * 4 + 2;
            wait_clk();
            
            if(i < 4095) begin
                cur_data = (cur_data >> 16) | ((i + 65536 + 1) << 16);
                assert(tcm_bus_stbuf_data[31:0] == cur_data) else $finish;
                assert(tcm_bus_fetch_data[31:0] == cur_data) else $finish;
                wait_clk();
            end
        end
    endtask

    task test_random;
        rst = 1;
        bus_tcm_fetch_addr = 'b0;
        bus_tcm_fetch_rd = 'b1;
        bus_tcm_stbuf_read_addr = 'b0;
        bus_tcm_stbuf_write_addr = 'b0;
        bus_tcm_stbuf_read_size = 'b0;
        bus_tcm_stbuf_write_size = 'b0;
        bus_tcm_stbuf_data = 'b0;
        bus_tcm_stbuf_rd = 'b1;
        bus_tcm_stbuf_wr = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();

        for(i = 0;i < 20000;i++) begin
            cur_addr = $urandom_range(0, `TCM_SIZE - 1);
            cur_data = $urandom_range(0, (1 << `REG_DATA_WIDTH) - 1);
            bus_tcm_stbuf_write_addr = cur_addr;
            bus_tcm_stbuf_write_size = 'd4;
            bus_tcm_stbuf_data = cur_data;
            bus_tcm_stbuf_wr = 'b1;
            wait_clk();
            bus_tcm_stbuf_wr = 'b0;
            bus_tcm_stbuf_read_addr = cur_addr;
            bus_tcm_fetch_addr = cur_addr;
            wait_clk();
            assert(tcm_bus_stbuf_data[31:0] == cur_data) else $finish;
            assert(tcm_bus_fetch_data[31:0] == cur_data) else $finish;
            wait_clk();
        end

        for(i = 0;i < 20000;i++) begin
            cur_addr = $urandom_range(0, `TCM_SIZE - 1);
            cur_data = $urandom_range(0, (1 << `REG_DATA_WIDTH) - 1);
            bus_tcm_stbuf_read_addr = cur_addr;
            bus_tcm_fetch_addr = cur_addr;
            bus_tcm_stbuf_write_addr = cur_addr;
            bus_tcm_stbuf_write_size = 'd4;
            bus_tcm_stbuf_data = cur_data;
            bus_tcm_stbuf_wr = 'b1;
            wait_clk();
            bus_tcm_stbuf_wr = 'b0;
            assert(tcm_bus_stbuf_data[31:0] == cur_data) else $finish;
            assert(tcm_bus_fetch_data[31:0] == cur_data) else $finish;
            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        test();
        test_sequence();
        test_sequence_cross();
        test_random();
        $display("TEST PASSED");
        $finish;
    end

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule