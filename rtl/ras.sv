`include "config.svh"
`include "common.svh"

module ras #(
        parameter DEPTH = 1
    )(
        input logic clk,
        input logic rst,
        
        output logic ras_csrf_ras_full_add,
        
        input logic[`ADDR_WIDTH - 1:0] bp_ras_addr,
        input logic bp_ras_push,
        input logic bp_ras_pop,
        output logic[`ADDR_WIDTH - 1:0] ras_bp_addr
    );

    localparam DEPTH_WIDTH = $clog2(DEPTH);

    logic[DEPTH - 1:0][`ADDR_WIDTH - 1:0] buffer;
    logic[DEPTH - 1:0][31:0] buffer_cnt;
    logic[DEPTH_WIDTH:0] top_ptr;
    logic[`ADDR_WIDTH - 1:0] top_ptr_next;
    logic need_cnt_add;
    logic need_throw;
    logic need_cnt_sub;

    genvar i;

    always_comb begin
        top_ptr_next = top_ptr;
        need_cnt_add = 'b0;
        need_throw = 'b0;
        need_cnt_sub = 'b0;

        if(bp_ras_push && !bp_ras_pop) begin
            if(top_ptr == 'b0) begin//stack is empty
                top_ptr_next = top_ptr + 'b1;
            end
            else if((bp_ras_addr == buffer[top_ptr - 'b1]) && (buffer_cnt[top_ptr - 'b1] < 'hffffffff)) begin//a equal item is in stack and the counter isn't full
                top_ptr_next = top_ptr;
                need_cnt_add = 'b1;
            end
            else if(top_ptr < DEPTH) begin//stack isn't full
                top_ptr_next = top_ptr + 'b1;
            end
            else begin//stack needs throw the oldest item
                top_ptr_next = top_ptr;
                need_throw = 'b1;
            end
        end
        else if(!bp_ras_push && bp_ras_pop) begin
            if(top_ptr == 'b0) begin//stack is empty
                top_ptr_next = top_ptr;
            end
            else if(buffer_cnt[top_ptr - 'b1] > 'b1) begin//the counter isn't empty
                top_ptr_next = top_ptr;
                need_cnt_sub = 'b1;
            end
            else begin//the counter is empty
                top_ptr_next = top_ptr - 'b1;
            end
        end
        else if(bp_ras_push && bp_ras_pop) begin
            if(top_ptr == 'b0) begin//stack is empty
                top_ptr_next = top_ptr + 'b1;
            end
            else if(bp_ras_addr == buffer[top_ptr - 'b1]) begin
                top_ptr_next = top_ptr;
            end
            else if(buffer_cnt[top_ptr - 'b1] > 'b1) begin
                top_ptr_next = top_ptr + 'b1;
                need_cnt_sub = 'b1;
            end
            else begin
                top_ptr_next = top_ptr;
            end
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            top_ptr <= 'b0;
        end
        else begin
            top_ptr <= top_ptr_next;
        end
    end

    generate
        for(i = 0;i < DEPTH - 1;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    buffer_cnt[i] <= 'b0;
                end
                else if((unsigned'(i) == (top_ptr - 'b1)) && (need_cnt_add || need_cnt_sub)) begin
                    if(need_cnt_add) begin
                        buffer_cnt[i] <= buffer_cnt[i] + 'b1;
                    end
                    else begin
                        buffer_cnt[i] <= buffer_cnt[i] - 'b1;
                    end
                end
                else if(need_throw)begin
                    buffer_cnt[i] <= buffer_cnt[i + 1];
                end
                else if((unsigned'(i) == top_ptr) && bp_ras_push && (!bp_ras_pop || (top_ptr != top_ptr_next))) begin
                    buffer_cnt[i] <= 'b1;
                end
                else if((unsigned'(i) == (top_ptr - 'b1)) && bp_ras_push && bp_ras_pop && (bp_ras_addr != buffer[i])) begin
                    buffer_cnt[i] <= 'b1;
                end
            end
        end

        always_ff @(posedge clk) begin
            if(rst) begin
                buffer_cnt[DEPTH - 1] <= 'b0;
            end
            else if(((DEPTH - 1) == (top_ptr - 'b1)) && (need_cnt_add || need_cnt_sub)) begin
                if(need_cnt_add) begin
                    buffer_cnt[DEPTH - 1] <= buffer_cnt[DEPTH - 1] + 'b1;
                end
                else begin
                    buffer_cnt[DEPTH - 1] <= buffer_cnt[DEPTH - 1] - 'b1;
                end
            end
            else if(need_throw)begin
                buffer_cnt[DEPTH - 1] <= 'b1;
            end
            else if(((DEPTH - 1) == top_ptr) && bp_ras_push && (!bp_ras_pop || (top_ptr != top_ptr_next))) begin
                buffer_cnt[DEPTH - 1] <= 'b1;
            end
            else if(((DEPTH - 1) == (top_ptr - 'b1)) && bp_ras_push && bp_ras_pop && (bp_ras_addr != buffer[DEPTH - 1])) begin
                buffer_cnt[DEPTH - 1] <= 'b1;
            end
        end
    endgenerate

    generate
        for(i = 0;i < DEPTH - 1;i++) begin
            always_ff @(posedge clk) begin
                if(rst) begin
                    buffer[i] <= 'b0;
                end
                else if(need_throw)begin
                    buffer[i] <= buffer[i + 1];
                end
                else if((unsigned'(i) == top_ptr) && bp_ras_push && (!bp_ras_pop || (top_ptr != top_ptr_next))) begin
                    buffer[i] <= bp_ras_addr;
                end
                else if((unsigned'(i) == (top_ptr - 'b1)) && bp_ras_push && bp_ras_pop && (bp_ras_addr != buffer[i]) && (buffer_cnt[i] == 'b1)) begin
                    buffer[i] <= bp_ras_addr;
                end
            end
        end

        always_ff @(posedge clk) begin
            if(rst) begin
                buffer[DEPTH - 1] <= 'b0;
            end
            else if(need_throw)begin
                buffer[DEPTH - 1] <= bp_ras_addr;
            end
            else if(((DEPTH - 1) == top_ptr) && bp_ras_push && (!bp_ras_pop || (top_ptr != top_ptr_next))) begin
                buffer[DEPTH - 1] <= bp_ras_addr;
            end
            else if(((DEPTH - 1) == (top_ptr - 'b1)) && bp_ras_push && bp_ras_pop && (bp_ras_addr != buffer[DEPTH - 1]) && (buffer_cnt[DEPTH - 1] == 'b1)) begin
                buffer[DEPTH - 1] <= bp_ras_addr;
            end
        end
    endgenerate

    assign ras_csrf_ras_full_add = need_throw;

    assign ras_bp_addr = top_ptr > 0 ? buffer[top_ptr - 'b1] : buffer[0];
endmodule