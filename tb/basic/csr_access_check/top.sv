`include "config.svh"
`include "common.svh"

module top;
    logic[`CSR_ADDR_WIDTH - 1:0] ro_csr_addr;
    logic ro_valid;
    logic[`CSR_ADDR_WIDTH - 1:0] wr_csr_addr;
    logic wr_valid;

    csr_access_check#(
        .WRITE_PREMISSION(0)
    )csr_access_check_ro_inst(
        .csr_addr(ro_csr_addr),
        .valid(ro_valid)  
    );

    csr_access_check#(
        .WRITE_PREMISSION(1)
    )csr_access_check_wr_inst(
        .csr_addr(wr_csr_addr),
        .valid(wr_valid)
    );

    task test_ro;
        ro_csr_addr = `CSR_MCONFIGPTR;
        #10;
        assert(ro_valid == 'b1) else $finish;
        ro_csr_addr = 0;
        #10;
        assert(ro_valid == 'b0) else $finish;
    endtask

    task test_wr;
        wr_csr_addr = `CSR_MCONFIGPTR;
        #10;
        assert(wr_valid == 'b0) else $finish;
        wr_csr_addr = `CSR_MSTATUS;
        #10;
        assert(wr_valid == 'b1) else $finish;
        wr_csr_addr = 0;
        #10;
        assert(wr_valid == 'b0) else $finish;
    endtask

    initial begin
        test_ro();
        test_wr();
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