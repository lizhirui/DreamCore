`include "config.svh"
`include "common.svh"

module checkpoint_buffer(
        input logic clk,
        input logic rst,
        
        output logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id,
        output logic cpbuf_fetch_new_id_valid,
        input checkpoint_t fetch_cpbuf_data,
        input logic fetch_cpbuf_push,
        
        input logic[`CHECKPOINT_ID_WIDTH - 1:0] rename_cpbuf_id[0:`RENAME_WIDTH - 1],
        input checkpoint_t rename_cpbuf_data[0:`RENAME_WIDTH - 1],
        input logic[`RENAME_WIDTH - 1:0] rename_cpbuf_we,
        output checkpoint_t cpbuf_rename_data[0:`RENAME_WIDTH - 1],
        
        input logic[`CHECKPOINT_ID_WIDTH - 1:0] exbru_cpbuf_id,
        output checkpoint_t cpbuf_exbru_data,
        
        input logic[`CHECKPOINT_ID_WIDTH - 1:0] commit_cpbuf_id[0:`COMMIT_WIDTH - 1],
        output checkpoint_t cpbuf_commit_data[0:`COMMIT_WIDTH - 1],
        input logic[`COMMIT_WIDTH - 1:0] commit_cpbuf_pop,
        input logic commit_cpbuf_flush
    );

    localparam DEPTH = `CHECKPOINT_BUFFER_SIZE;
    localparam DEPTH_WIDTH = `CHECKPOINT_ID_WIDTH;
    localparam READ_CHANNEL_NUM = `RENAME_WIDTH + 1 + `COMMIT_WIDTH;
    localparam WRITE_CHANNEL_NUM = 1 + `RENAME_WIDTH;

    checkpoint_t[DEPTH - 1:0] buffer;

    logic[DEPTH_WIDTH:0] rptr;
    logic[DEPTH_WIDTH:0] wptr;
    logic[DEPTH_WIDTH:0] rptr_next;
    logic[DEPTH_WIDTH:0] wptr_next;
    logic full;
    logic empty;

    logic[DEPTH_WIDTH - 1:0] read_channel_addr[0:READ_CHANNEL_NUM - 1];
    checkpoint_t read_channel_data[0:READ_CHANNEL_NUM]; 
    logic[DEPTH_WIDTH - 1:0] write_channel_addr[0:WRITE_CHANNEL_NUM - 1];
    checkpoint_t write_channel_data[0:WRITE_CHANNEL_NUM - 1];
    logic[WRITE_CHANNEL_NUM - 1:0] write_channel_enable;

    logic[$clog2(`COMMIT_WIDTH):0] commit_num;

    logic[WRITE_CHANNEL_NUM - 1:0] buffer_write_port_addr_cmp[0:DEPTH - 1];
    checkpoint_t buffer_write_port_data[0:DEPTH - 1];
    logic[DEPTH - 1:0] buffer_write_port_enable;

    genvar i, j;

    assign cpbuf_fetch_new_id = wptr[DEPTH_WIDTH - 1:0];
    assign cpbuf_fetch_new_id_valid = !full;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign read_channel_addr[i] = rename_cpbuf_id[i];
            assign cpbuf_rename_data[i] = read_channel_data[i];
        end
    endgenerate

    assign read_channel_addr[`RENAME_WIDTH] = exbru_cpbuf_id;
    assign cpbuf_exbru_data = read_channel_data[`RENAME_WIDTH];

    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign read_channel_addr[`RENAME_WIDTH + 1 + i] = commit_cpbuf_id[i];
            assign cpbuf_commit_data[i] = read_channel_data[`RENAME_WIDTH + 1 + i];
        end
    endgenerate

    assign write_channel_addr[0] = cpbuf_fetch_new_id;
    assign write_channel_data[0] = fetch_cpbuf_data;
    assign write_channel_enable[0] = fetch_cpbuf_push;

    generate
        for(i = 0;i < `RENAME_WIDTH;i++) begin
            assign write_channel_addr[1 + i] = rename_cpbuf_id[i];
            assign write_channel_data[1 + i] = rename_cpbuf_data[i];
            assign write_channel_enable[1 + i] = rename_cpbuf_we[i];
        end
    endgenerate

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`COMMIT_WIDTH)
    )count_one_commit_num_inst(
        .data_in(commit_cpbuf_pop),
        .sum(commit_num)
    );
    
    assign full = (rptr[DEPTH_WIDTH] != wptr[DEPTH_WIDTH]) && (rptr[DEPTH_WIDTH - 1:0] == wptr[DEPTH_WIDTH - 1:0]);
    assign empty = rptr == wptr;

    always_ff @(posedge clk) begin
        if(rst | commit_cpbuf_flush) begin
            rptr <= 'b0;
        end
        else begin
            rptr <= rptr_next;
        end
    end

    always_ff @(posedge clk) begin
        if(rst | commit_cpbuf_flush) begin
            wptr <= 'b0;
        end
        else begin
            wptr <= wptr_next;
        end
    end

    always_comb begin
        if(empty) begin
            rptr_next = rptr;
        end
        else begin
            rptr_next = rptr + commit_num;
        end
    end

    always_comb begin
        if(full) begin
            wptr_next = wptr;
        end
        else if(fetch_cpbuf_push) begin
            wptr_next = wptr + 'b1;
        end
        else begin
            wptr_next = wptr;
        end
    end

    generate
        for(i = 0;i < DEPTH;i++) begin: write_port_mux
            for(j = 0;j < WRITE_CHANNEL_NUM;j++) begin
                assign buffer_write_port_addr_cmp[i][j] = (write_channel_addr[j] == unsigned'(i)) && write_channel_enable[j];
            end

            data_selector #(
                .SEL_WIDTH(WRITE_CHANNEL_NUM),
                .DATA_WIDTH($bits(checkpoint_t))
            )data_selector_write_port_inst(
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
        for(i = 0;i < READ_CHANNEL_NUM;i++) begin
            assign read_channel_data[i] = buffer[read_channel_addr[i]];
        end
    endgenerate
endmodule