`include "config.svh"
`include "common.svh"

module uart_controller #(
        parameter FREQ_DIV = 16
    )(
        input logic clk,
        input logic rst,

        input logic rxd,
        output logic txd,

        input logic[7:0] send_data,
        input logic send,
        output logic send_busy,

        output logic[7:0] rev_data,
        output logic rev_data_valid,
        input logic rev_data_invalid
    );

    logic[1:0] rxd_sync_shift_reg;
    logic rxd_sync;

    logic rev_sample;
    logic rev_doing;
    logic rev_done;

    logic[31:0] rev_clk_cnt;
    logic[3:0] rev_cnt;

    logic[31:0] send_clk_cnt;
    logic[3:0] send_cur_state;
    logic[3:0] send_next_state;
    logic send_en;
    logic[7:0] send_data_buf;

    always_ff @(posedge clk) begin
        if(rst) begin
            rxd_sync_shift_reg <= '1;
        end
        else begin
            rxd_sync_shift_reg <= {rxd_sync_shift_reg[0], rxd};
        end
    end

    assign rxd_sync = rxd_sync_shift_reg[1];

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_doing <= 'b0;
        end
        else if(!rev_doing && !rxd_sync) begin
            rev_doing <= 'b1;
        end
        else if(rev_doing && rev_done) begin
            rev_doing <= 'b0;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_clk_cnt <= 'b0;
        end
        else if(!rev_doing && !rxd_sync) begin
            rev_clk_cnt <= 'b1;
        end
        else if(rev_doing) begin
            if(rev_clk_cnt < (FREQ_DIV - 1)) begin
                rev_clk_cnt <= rev_clk_cnt + 'b1;
            end
            else begin
                rev_clk_cnt <= 'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_sample <= 'b0;
        end
        else if(rev_doing && (rev_clk_cnt == (FREQ_DIV / 2 - 1))) begin
            rev_sample <= 'b1;
        end
        else begin
            rev_sample <= 'b0;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_data <= 'b0;
        end
        else if(rev_sample && (rev_cnt > 'b0) && (rev_cnt <= 'd8)) begin
            rev_data <= {rxd_sync, rev_data[7:1]};
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_data_valid <= 'b0;
        end
        else if(rev_sample && (rev_cnt == 'd8)) begin
            rev_data_valid <= 'b1;
        end
        else if(rev_sample && (rev_cnt == 'b1)) begin
            rev_data_valid <= 'b0;
        end
        else if(rev_data_invalid) begin
            rev_data_valid <= 'b0;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_cnt <= 'b0;
        end
        else if(!rev_doing && !rxd_sync) begin
            rev_cnt <= 'b0;
        end
        else if(rev_done) begin
            rev_cnt <= 'b0;
        end
        else if(rev_sample) begin
            rev_cnt <= rev_cnt + 'b1;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            rev_done <= 'b0;
        end
        else if(rev_cnt == 'd10) begin
            rev_done <= 'b1;
        end
        else begin
            rev_done <= 'b0;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            send_clk_cnt <= 'b0;
        end
        else if(send_busy) begin
            if(send_clk_cnt < (FREQ_DIV - 1)) begin
                send_clk_cnt <= send_clk_cnt + 'b1;
            end
            else begin
                send_clk_cnt <= 'b0;
            end
        end
        else if(send) begin
            send_clk_cnt <= 'b0;
        end
    end

    assign send_en = ((send_clk_cnt == (FREQ_DIV - 1)) && send_busy) || (send && !send_busy);

    always_ff @(posedge clk) begin
        if(rst) begin
            send_cur_state <= 'b0;
        end
        else if(send_cur_state != send_next_state) begin
            send_cur_state <= send_next_state;
        end
    end

    always_comb begin
        send_next_state = send_cur_state;

        if(send_cur_state == 'b0) begin
            if(send) begin
                send_next_state = 'b1;
            end
        end
        else begin
            if(send_en) begin
                if(send_cur_state == 'd10) begin
                    send_next_state = 'b0;
                end
                else begin
                    send_next_state = send_cur_state + 'b1;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            send_data_buf <= 'b0;
        end
        else if(send && !send_busy) begin
            send_data_buf <= send_data;
        end
    end

    assign send_busy = send_cur_state != 'b0;

    always_ff @(posedge clk) begin
        if(rst) begin
            txd <= 'b1;
        end
        else if(send_en) begin
            case(send_cur_state)
                'd0: txd <= 'b0;
                'd1: txd <= send_data_buf[0];
                'd2: txd <= send_data_buf[1];
                'd3: txd <= send_data_buf[2];
                'd4: txd <= send_data_buf[3];
                'd5: txd <= send_data_buf[4];
                'd6: txd <= send_data_buf[5];
                'd7: txd <= send_data_buf[6];
                'd8: txd <= send_data_buf[7];
                'd9: txd <= 'b1;
            endcase
        end
    end
endmodule