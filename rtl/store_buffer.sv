`include "config.svh"
`include "common.svh"

module store_buffer(
        input logic clk,
        input logic rst,
        
        input logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr,
        input logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size,
        input logic issue_stbuf_rd,
        output logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data,
        output logic[`BUS_DATA_WIDTH - 1:0] stbuf_exlsu_bus_data_feedback,
        output logic stbuf_exlsu_bus_ready,
        
        input logic[`ROB_ID_WIDTH - 1:0] exlsu_stbuf_rob_id,
        input logic[`ADDR_WIDTH - 1:0] exlsu_stbuf_write_addr,
        input logic[`SIZE_WIDTH - 1:0] exlsu_stbuf_write_size,
        input logic[`BUS_DATA_WIDTH - 1:0] exlsu_stbuf_write_data,
        input logic exlsu_stbuf_push,
        output logic stbuf_exlsu_full,
        
        output logic stbuf_all_empty,
        
        output logic[`ADDR_WIDTH - 1:0] stbuf_bus_read_addr,
        output logic[`ADDR_WIDTH - 1:0] stbuf_bus_write_addr,
        output logic[`SIZE_WIDTH - 1:0] stbuf_bus_read_size,
        output logic[`SIZE_WIDTH - 1:0] stbuf_bus_write_size,
        output logic[`REG_DATA_WIDTH - 1:0] stbuf_bus_data,
        output logic stbuf_bus_read_req,
        output logic stbuf_bus_write_req,
        input logic[`REG_DATA_WIDTH - 1:0] bus_stbuf_data,
        input logic bus_stbuf_read_ack,
        input logic bus_stbuf_write_ack,
        
        input commit_feedback_pack_t commit_feedback_pack
    );

    localparam DEPTH = `STORE_BUFFER_SIZE;
    localparam DEPTH_WIDTH = $clog2(DEPTH);

    store_buffer_item_t[DEPTH - 1:0] buffer;

    logic[DEPTH_WIDTH:0] rptr;
    logic[DEPTH_WIDTH:0] wptr;
    logic[DEPTH_WIDTH:0] rptr_next;
    logic[DEPTH_WIDTH:0] wptr_next;
    logic full;
    logic empty;

    logic flush;
    logic[DEPTH_WIDTH:0] flush_next_wptr;
    logic[DEPTH_WIDTH - 1:0] flush_cur_ptr[0:DEPTH - 1];
    logic[DEPTH - 1:0] flush_commit_cmp;
    logic[DEPTH_WIDTH - 1:0] flush_commit_index;
    logic flush_commit_index_valid;

    logic issue_stbuf_read_reg_lock;
    logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr_r;
    logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size_r;

    logic[DEPTH_WIDTH - 1:0] feedback_cur_id[0:DEPTH - 1];
    store_buffer_item_t feedback_cur_item[0:DEPTH - 1];
    logic[`BUS_DATA_WIDTH - 1:0] feedback_bit_offset[0:DEPTH - 1];
    logic[`BUS_DATA_WIDTH:0] feedback_bit_length[0:DEPTH - 1];
    logic[`BUS_DATA_WIDTH - 1:0] feedback_bit_mask[0:DEPTH - 1];
    logic[`BUS_DATA_WIDTH - 1:0] feedback_data[0:DEPTH - 1];
    logic[`BUS_DATA_WIDTH - 1:0] feedback_input_data[0:DEPTH - 1];

    store_buffer_item_t new_item;
    store_buffer_item_t cur_item;

    logic[`COMMIT_WIDTH - 1:0] ready_to_commit_cmp[0:DEPTH - 1];
    logic[DEPTH - 1:0] ready_to_commit;

    genvar i, j;

    assign full = (rptr[DEPTH_WIDTH] != wptr[DEPTH_WIDTH]) && (rptr[DEPTH_WIDTH - 1:0] == wptr[DEPTH_WIDTH - 1:0]);
    assign empty = rptr == wptr;

    assign flush = commit_feedback_pack.enable && commit_feedback_pack.flush;

    assign stbuf_exlsu_full = full;
    assign stbuf_all_empty = empty;

    always_ff @(posedge clk) begin
        if(rst) begin
            issue_stbuf_read_reg_lock <= 'b0;
            issue_stbuf_read_addr_r <= 'b0;
            issue_stbuf_read_size_r <= 'b0;
        end
        else begin
            if(issue_stbuf_rd && (!issue_stbuf_read_reg_lock | bus_stbuf_read_ack)) begin
                issue_stbuf_read_addr_r <= issue_stbuf_read_addr;
                issue_stbuf_read_size_r <= issue_stbuf_read_size;
                issue_stbuf_read_reg_lock <= 'b1;
            end
            else if(bus_stbuf_read_ack) begin
                issue_stbuf_read_reg_lock <= 'b0;
            end
        end
    end
    
    always_ff @(posedge clk) begin
        if(rst) begin
            rptr <= 'b0;
        end
        else begin
            rptr <= rptr_next;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            wptr <= 'b0;
        end
        else begin
            wptr <= wptr_next;
        end
    end

    assign rptr_next = empty ? rptr : stbuf_bus_write_req ? (rptr + 'b1)  : rptr;
    assign wptr_next = flush ? flush_next_wptr : full ? wptr : exlsu_stbuf_push ? (wptr + 'b1) : wptr;

    generate 
        for(i = 0;i < DEPTH;i++) begin
            assign flush_cur_ptr[i] = rptr + i;
            assign flush_commit_cmp[i] = `ptr_in_range(flush_cur_ptr[i], rptr, wptr, DEPTH_WIDTH) && 
                                         (!commit_feedback_pack.enable || !ready_to_commit[flush_cur_ptr[i]]) && 
                                         !buffer[flush_cur_ptr[i]].committed;
        end
    endgenerate

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(DEPTH)
    )priority_finder_flush_commit_inst(
        .data_in(flush_commit_cmp),
        .index(flush_commit_index),
        .index_valid(flush_commit_index_valid)
    );

    assign flush_next_wptr = flush_commit_index_valid ? (rptr + flush_commit_index) : wptr;

    assign stbuf_bus_read_addr = issue_stbuf_read_addr;
    assign stbuf_bus_read_size = issue_stbuf_read_size;
    assign stbuf_bus_read_req = issue_stbuf_rd;
    assign stbuf_exlsu_bus_data = bus_stbuf_data;
    assign stbuf_exlsu_bus_ready = bus_stbuf_read_ack;

    generate
        assign feedback_input_data[0] = bus_stbuf_data;

        for(i = 1;i < DEPTH;i++) begin
            assign feedback_input_data[i] = feedback_data[i - 1];
        end

        for(i = 0;i < DEPTH;i++) begin
            assign feedback_cur_id[i] = rptr + i;
            assign feedback_cur_item[i] = buffer[feedback_cur_id[i]];
            assign feedback_bit_mask[i] = (unsigned'(`BUS_DATA_WIDTH'b1) << feedback_bit_length[i]) - 'b1;

            always_comb begin
                feedback_bit_offset[i] = 'b0;
                feedback_bit_length[i] = 'b0;
                feedback_data[i] = feedback_input_data[i];

                if(`ptr_in_range(feedback_cur_id[i], rptr, wptr, DEPTH_WIDTH)) begin
                    if((feedback_cur_item[i].addr >= issue_stbuf_read_addr_r) && (feedback_cur_item[i].addr < (issue_stbuf_read_addr_r + issue_stbuf_read_size_r))) begin
                        feedback_bit_offset[i] = {feedback_cur_item[i].addr - issue_stbuf_read_addr_r, 3'b0};
                        feedback_bit_length[i] = {`min(feedback_cur_item[i].size, issue_stbuf_read_addr_r + issue_stbuf_read_size_r - feedback_cur_item[i].addr), 3'b0};
                        feedback_data[i] = (feedback_input_data[i] & (~(feedback_bit_mask[i] << feedback_bit_offset[i]))) | ((`BUS_DATA_WIDTH'(feedback_cur_item[i].data) & feedback_bit_mask[i]) << feedback_bit_offset[i]);
                    end
                    else if((feedback_cur_item[i].addr < issue_stbuf_read_addr_r) && ((feedback_cur_item[i].addr + feedback_cur_item[i].size) > issue_stbuf_read_addr_r)) begin
                        feedback_bit_offset[i] = {issue_stbuf_read_addr_r - feedback_cur_item[i].addr, 3'b0};
                        feedback_bit_length[i] = {`min(issue_stbuf_read_size_r, feedback_cur_item[i].addr + feedback_cur_item[i].size - issue_stbuf_read_addr_r), 3'b0};
                        feedback_data[i] = (feedback_input_data[i] & (~feedback_bit_mask[i])) | ((feedback_cur_item[i].data >> feedback_bit_offset[i]) & feedback_bit_mask[i]);
                    end
                end
            end
        end
    endgenerate

    assign stbuf_exlsu_bus_data_feedback = feedback_data[DEPTH - 1];

    assign new_item.enable = 'b1;
    assign new_item.committed = 'b0;
    assign new_item.rob_id = exlsu_stbuf_rob_id;
    assign new_item.addr = exlsu_stbuf_write_addr;
    assign new_item.data = exlsu_stbuf_write_data;
    assign new_item.size = exlsu_stbuf_write_size;

    assign cur_item = buffer[rptr[DEPTH_WIDTH - 1:0]];

    assign stbuf_bus_write_addr = cur_item.addr;
    assign stbuf_bus_write_size = cur_item.size;
    assign stbuf_bus_data = cur_item.data;
    assign stbuf_bus_write_req = cur_item.enable && cur_item.committed && !flush && !empty;
    
    generate
        for(i = 0;i < DEPTH;i++) begin: ready_to_commit_generate
            for(j = 0;j < `COMMIT_WIDTH;j++) begin
                assign ready_to_commit_cmp[i][j] = `ptr_in_range(unsigned'(i), rptr, wptr, DEPTH_WIDTH) && 
                                                   commit_feedback_pack.committed_rob_id_valid[j] &&
                                                   (commit_feedback_pack.committed_rob_id[j] == buffer[i].rob_id);
            end

            parallel_finder #(
                .WIDTH(`COMMIT_WIDTH)
            )parallel_finder_ready_to_commit_inst(
                .data_in(ready_to_commit_cmp[i]),
                .index_valid(ready_to_commit[i])
            );
        end
    endgenerate

    generate
        for(i = 0;i < DEPTH;i++) begin
            always_ff @(posedge clk) begin
                if(!rst) begin
                    if(exlsu_stbuf_push && !full && (unsigned'(i) == wptr[DEPTH_WIDTH - 1:0])) begin
                        buffer[i] <= new_item;
                    end
                    else if(commit_feedback_pack.enable && ready_to_commit[i]) begin
                        buffer[i].committed <= 'b1;
                    end
                end
            end
        end
    endgenerate
endmodule