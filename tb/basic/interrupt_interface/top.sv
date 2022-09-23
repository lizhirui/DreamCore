`include "config.svh"
`include "common.svh"

module top;
    logic clk;
    logic rst;

    logic all_intif_int_ext_req;
    logic all_intif_int_software_req;
    logic all_intif_int_timer_req;

    logic intif_all_int_ext_ack;
    logic intif_all_int_software_ack;
    logic intif_all_int_timer_ack;

    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mie_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mstatus_data;
    logic[`REG_DATA_WIDTH - 1:0] csrf_all_mip_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_csrf_mip_data;

    logic intif_commit_has_interrupt;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_mcause_data;
    logic[`REG_DATA_WIDTH - 1:0] intif_commit_ack_data;
    logic[`REG_DATA_WIDTH - 1:0] commit_intif_ack_data;

    logic[`REG_DATA_WIDTH - 1:0] all_int_mip;

    interrupt_interface interrupt_interface(.*);

    assign all_int_mip = (('b1 << `MIP_MEIP) | ('b1 << `MIP_MSIP) | ('b1 << `MIP_MTIP));
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task test;
        rst = 1;
        all_intif_int_ext_req = 'b0;
        all_intif_int_software_req = 'b0;
        all_intif_int_timer_req = 'b0;
        csrf_all_mie_data = 'b0;
        csrf_all_mstatus_data = 'b0;
        csrf_all_mip_data = 'b0;
        commit_intif_ack_data = 'b0;
        wait_clk();
        rst = 0;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == 'b0) else $finish;
        assert(intif_commit_has_interrupt == 'b0) else $finish;
        assert(intif_commit_mcause_data == 'b0) else $finish;
        assert(intif_commit_ack_data == 'b0) else $finish;
        all_intif_int_ext_req = 'b1;
        all_intif_int_software_req = 'b1;
        all_intif_int_timer_req = 'b1;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == all_int_mip) else $finish;
        assert(intif_commit_has_interrupt == 'b0) else $finish;
        assert(intif_commit_mcause_data == 'b0) else $finish;
        assert(intif_commit_ack_data == 'b0) else $finish;
        csrf_all_mstatus_data = 'b1000;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == all_int_mip) else $finish;
        assert(intif_commit_has_interrupt == 'b0) else $finish;
        assert(intif_commit_mcause_data == 'b0) else $finish;
        assert(intif_commit_ack_data == 'b0) else $finish;
        csrf_all_mie_data = ('b1 << `MIP_MEIP) | ('b1 << `MIP_MSIP) | ('b1 << `MIP_MTIP);
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == all_int_mip) else $finish;
        assert(intif_commit_has_interrupt == 'b1) else $finish;
        assert(intif_commit_mcause_data == `MIP_MEIP) else $finish;
        assert(intif_commit_ack_data == 'b1 << `MIP_MEIP) else $finish;
        all_intif_int_ext_req = 'b0;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == ((1 << `MIP_MSIP) | ('b1 << `MIP_MTIP))) else $finish;
        assert(intif_commit_has_interrupt == 'b1) else $finish;
        assert(intif_commit_mcause_data == `MIP_MSIP) else $finish;
        assert(intif_commit_ack_data == 'b1 << `MIP_MSIP) else $finish;
        all_intif_int_software_req = 'b0;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == ('b1 << `MIP_MTIP)) else $finish;
        assert(intif_commit_has_interrupt == 'b1) else $finish;
        assert(intif_commit_mcause_data == `MIP_MTIP) else $finish;
        assert(intif_commit_ack_data == 'b1 << `MIP_MTIP) else $finish;
        all_intif_int_timer_req = 'b0;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        assert(intif_csrf_mip_data == 'b0) else $finish;
        assert(intif_commit_has_interrupt == 'b0) else $finish;
        assert(intif_commit_mcause_data == 'b0) else $finish;
        assert(intif_commit_ack_data == 'b0) else $finish;
        commit_intif_ack_data = all_int_mip;
        wait_clk();
        assert(intif_all_int_ext_ack == 'b1) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        commit_intif_ack_data = ((1 << `MIP_MSIP) | ('b1 << `MIP_MTIP));
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b1) else $finish;
        assert(intif_all_int_timer_ack == 'b0) else $finish;
        commit_intif_ack_data = ('b1 << `MIP_MTIP);
        wait_clk();
        assert(intif_all_int_ext_ack == 'b0) else $finish;
        assert(intif_all_int_software_ack == 'b0) else $finish;
        assert(intif_all_int_timer_ack == 'b1) else $finish;
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        test();
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