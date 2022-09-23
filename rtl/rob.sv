`include "config.svh"
`include "common.svh"

module rob(
        input logic clk,
        input logic rst,
        
        output logic[`ROB_ID_WIDTH - 1:0] rob_rename_new_id[0:`RENAME_WIDTH - 1],
        output logic[`RENAME_WIDTH - 1:0] rob_rename_new_id_valid,
        
        input rob_item_t rename_rob_data[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] rename_rob_data_valid,
        input logic rename_rob_push,
        
        input logic[`ROB_ID_WIDTH - 1:0] commit_rob_input_id[0:`WB_WIDTH - 1],
        output rob_item_t rob_commit_input_data[0:`WB_WIDTH - 1],
        input rob_item_t commit_rob_input_data[0:`WB_WIDTH - 1],
        input logic[`WB_WIDTH - 1:0] commit_rob_input_data_we,
        
        output logic[`ROB_ID_WIDTH - 1:0] rob_commit_retire_head_id,
        output logic rob_commit_retire_head_id_valid,

        input logic[`ROB_ID_WIDTH - 1:0] commit_rob_retire_id[0:`COMMIT_WIDTH - 1],
        output rob_item_t rob_commit_retire_data[0:`COMMIT_WIDTH - 1],
        output logic[`COMMIT_WIDTH - 1:0] rob_commit_retire_id_valid,
        input logic[`COMMIT_WIDTH - 1:0] commit_rob_retire_pop,

        input logic[`ROB_ID_WIDTH - 1:0] commit_rob_next_id,
        output logic rob_commit_next_id_valid,
        
        output logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_tail_id,
        output logic rob_commit_flush_tail_id_valid,
        
        input logic[`ROB_ID_WIDTH - 1:0] commit_rob_flush_id,
        output rob_item_t rob_commit_flush_data,
        output logic[`ROB_ID_WIDTH - 1:0] rob_commit_flush_next_id,
        output logic rob_commit_flush_next_id_valid,

        output logic rob_commit_empty,
        output logic rob_commit_full,
        input logic commit_rob_flush
    );

    localparam DEPTH = `ROB_SIZE;
    localparam DEPTH_WIDTH = `ROB_ID_WIDTH;
    localparam WRITE_CHANNEL_NUM = `RENAME_WIDTH + `WB_WIDTH;

    rob_item_t[DEPTH - 1:0] buffer;

    logic[DEPTH_WIDTH:0] rptr;
    logic[DEPTH_WIDTH:0] wptr;
    logic[DEPTH_WIDTH:0] rptr_next;
    logic[DEPTH_WIDTH:0] wptr_next;
    logic full;
    logic empty;

    logic[$clog2(`RENAME_WIDTH):0] new_num;

    logic[$clog2(`COMMIT_WIDTH):0] retire_num;

    logic[DEPTH_WIDTH - 1:0] write_channel_addr[0:WRITE_CHANNEL_NUM - 1];
    rob_item_t write_channel_data[0:WRITE_CHANNEL_NUM - 1];
    logic[WRITE_CHANNEL_NUM - 1:0] write_channel_enable;

    logic[WRITE_CHANNEL_NUM - 1:0] buffer_write_port_addr_cmp[0:DEPTH - 1];
    rob_item_t buffer_write_port_data[0:DEPTH - 1];
    logic[DEPTH - 1:0] buffer_write_port_enable;

    genvar i, j;

    assign full = (rptr[DEPTH_WIDTH] != wptr[DEPTH_WIDTH]) && (rptr[DEPTH_WIDTH - 1:0] == wptr[DEPTH_WIDTH - 1:0]);
    assign empty = rptr == wptr;

    always_ff @(posedge clk) begin
        if(rst | commit_rob_flush) begin
            rptr <= 'b0;
        end
        else begin
            rptr <= rptr_next;
        end
    end

    always_ff @(posedge clk) begin
        if(rst | commit_rob_flush) begin
            wptr <= 'b0;
        end
        else begin
            wptr <= wptr_next;
        end
    end

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign rob_rename_new_id[i] = wptr[DEPTH_WIDTH - 1:0] + unsigned'(i);
            assign rob_rename_new_id_valid[i] = ((rob_rename_new_id[i] < rptr[DEPTH_WIDTH - 1:0]) || (rob_rename_new_id[i] >= wptr[DEPTH_WIDTH - 1:0]));
        end
    endgenerate

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`RENAME_WIDTH)
    )count_one_new_num_inst(
        .data_in(rename_rob_data_valid & rob_rename_new_id_valid),
        .sum(new_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`RENAME_WIDTH)
    )count_one_retire_num_inst(
        .data_in(commit_rob_retire_pop),
        .sum(retire_num)
    );

    assign rptr_next = empty ? rptr : rptr + retire_num;
    assign wptr_next = full ? wptr : rename_rob_push ? (wptr + new_num) : wptr;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign write_channel_addr[i] = rob_rename_new_id[i];
            assign write_channel_data[i] = rename_rob_data[i];
            assign write_channel_enable[i] = rename_rob_data_valid && rob_rename_new_id_valid[i];
        end
    endgenerate

    generate
        for(i = 0;i < `WB_WIDTH;i++) begin
            assign write_channel_addr[`RENAME_WIDTH + i] = commit_rob_input_id[i];
            assign write_channel_data[`RENAME_WIDTH + i] = commit_rob_input_data[i];
            assign write_channel_enable[`RENAME_WIDTH + i] = commit_rob_input_data_we[i];
        end
    endgenerate

    generate
        for(i = 0;i < DEPTH;i++) begin: write_port_mux
            for(j = 0;j < WRITE_CHANNEL_NUM;j++) begin
                assign buffer_write_port_addr_cmp[i][j] = (write_channel_addr[j] == unsigned'(i)) && write_channel_enable[j];
            end

            data_selector #(
                .SEL_WIDTH(WRITE_CHANNEL_NUM),
                .DATA_WIDTH($bits(rob_item_t))
            )data_selector_buffer_write_data_inst(
                .sel_in(buffer_write_port_addr_cmp[i]),
                .data_in(write_channel_data),
                .data_out(buffer_write_port_data[i]),
                .data_out_valid(buffer_write_port_enable[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < DEPTH;i++) begin
            always_ff @(posedge clk) begin
                if(!rst) begin
                    if(buffer_write_port_enable[i]) begin
                        buffer[i] <= buffer_write_port_data[i];
                    end
                end
            end
        end
    endgenerate

    generate
        for(i = 0;i < `WB_WIDTH;i++) begin
            assign rob_commit_input_data[i] = buffer[commit_rob_input_id[i]];
        end
    endgenerate

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign rob_commit_retire_data[i] = buffer[commit_rob_retire_id[i]];
            assign rob_commit_retire_id_valid[i] = `ptr_in_range(commit_rob_retire_id[i], rptr, wptr, DEPTH_WIDTH);
        end
    endgenerate

    assign rob_commit_retire_head_id = rptr[DEPTH_WIDTH - 1:0];
    assign rob_commit_retire_head_id_valid = !empty;

    assign rob_commit_flush_data = buffer[commit_rob_flush_id];

    assign rob_commit_flush_tail_id = wptr[DEPTH_WIDTH - 1:0] - 'b1;
    assign rob_commit_flush_tail_id_valid = !empty;

    assign rob_commit_flush_next_id = commit_rob_flush_id - 'b1;
    assign rob_commit_flush_next_id_valid = `ptr_in_range(rob_commit_flush_next_id, rptr, wptr, DEPTH_WIDTH) && (rob_commit_flush_next_id != rob_commit_flush_tail_id);

    assign rob_commit_next_id_valid = `ptr_in_range(commit_rob_next_id, rptr, wptr, DEPTH_WIDTH) && (commit_rob_next_id != rob_commit_retire_head_id);

    assign rob_commit_empty = empty;
    assign rob_commit_full = full;
endmodule