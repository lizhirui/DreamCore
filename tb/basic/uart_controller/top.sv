`include "config.svh"
`include "common.svh"

`define assert(condition) assert((condition)) else begin #10; $finish; end
`define assert_equal(_expected, _actual) assert((_expected) == (_actual)) else begin $display("expected = %0x, actual = %0x", (_expected), (_actual)); #10; $finish; end

module top;
    logic clk;
    logic rst;

    logic rxd;
    logic txd;
    
    logic[7:0] send_data;
    logic send;
    logic send_busy;

    logic[7:0] rev_data;
    logic rev_data_valid;
    logic rev_data_invalid;

    logic[7:0] rev_data_buf;

    integer i;
    integer ti;
    integer ri;

    localparam FREQ_DIV = `UART_FREQ_DIV;
    
    uart_controller #(
        .FREQ_DIV(FREQ_DIV)
    )uart_controller_inst(.*);

    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task task_send(logic[7:0] data);
        rxd = 'b0;
        repeat(FREQ_DIV) wait_clk();

        for(ti = 0;ti < 8;ti++) begin
            rxd = data[ti];
            repeat(FREQ_DIV) wait_clk();
            `assert_equal(ti == 7, rev_data_valid)
            `assert_equal(FREQ_DIV - 2, uart_controller_inst.rev_clk_cnt)
            `assert_equal(ti + 2, uart_controller_inst.rev_cnt)
        end

        `assert_equal('b1, rev_data_valid)
        `assert_equal(data, rev_data)
        rxd = 'b1;
        repeat(FREQ_DIV) wait_clk();
        `assert_equal('b1, rev_data_valid)
        `assert_equal(data, rev_data)
    endtask

    task test;
        rst = 1;
        rxd = 'b1;
        send_data = 'b0;
        send = 'b0;
        rev_data_invalid = 'b0;
        wait_clk();
        rst = 0;
        `assert_equal('b0, rev_data_valid)
        `assert_equal('b0, send_busy)

        for(i = 0;i <= 255;i++) begin
            task_send(i);
        end

        rev_data_invalid = 'b1;
        wait_clk();
        `assert_equal('b0, rev_data_valid)
        rev_data_invalid = 'b0;

        for(i = 0;i <= 255;i++) begin
            `assert_equal('b0, send_busy)
            send_data = i;
            send = 'b1;
            wait_clk();
            `assert_equal('b1, send_busy)
            @(send_busy);
            `assert_equal(i, rev_data_buf)
        end
    endtask

    initial begin
        rev_data_buf = 'b0;
        
        while(1) begin
            wait_clk();

            if(!txd) begin
                `assert_equal('b1, send_busy)

                for(ri = 0;ri < 8;ri++) begin
                    repeat(FREQ_DIV) begin wait_clk(); `assert_equal('b1, send_busy) end
                    rev_data_buf[ri] = txd;
                end

                repeat(FREQ_DIV) begin `assert_equal('b1, send_busy) wait_clk(); end
                `assert_equal('b1, txd)
                `assert_equal('b1, send_busy)
                repeat(FREQ_DIV) wait_clk();
                `assert_equal('b1, txd)
                `assert_equal('b0, send_busy)
            end
        end
    end

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