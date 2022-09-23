`include "config.svh"
`include "common.svh"

module multififo #(
        parameter PORT_NUM = 2,
        parameter WIDTH = 1000,
        parameter DEPTH = 256
    )(
        input logic clk,
        input logic rst,
        
        output logic[PORT_NUM - 1:0] data_in_enable,
        input logic[WIDTH - 1:0] data_in[0:PORT_NUM - 1],
        input logic[PORT_NUM - 1:0] data_in_valid,
        input logic push,
        output logic full,
        input logic flush,
        
        output logic[WIDTH - 1:0] data_out[0:PORT_NUM - 1],
        output logic[PORT_NUM - 1:0] data_out_valid,
        input logic[PORT_NUM - 1:0] data_pop_valid,
        input logic pop,
        output logic empty
    );

    localparam DEPTH_WIDTH = $clog2(DEPTH);
    localparam BANK_NUM = PORT_NUM;
    localparam BANK_ADDR_WIDTH = $clog2(BANK_NUM);

    logic[DEPTH_WIDTH:0] rptr;
    logic[DEPTH_WIDTH:0] rptr_next;
    logic[DEPTH_WIDTH:0] wptr;
    logic[DEPTH_WIDTH:0] wptr_next;

    logic[DEPTH_WIDTH:0] wptr_rptr_sub;//wptr - rptr

    logic[DEPTH_WIDTH:0] used_space;
    logic[DEPTH_WIDTH:0] free_space;

    logic[$clog2(PORT_NUM):0] push_enable_num;
    logic[$clog2(PORT_NUM):0] pop_enable_num;

    logic[$clog2(PORT_NUM):0] data_in_num;
    logic[PORT_NUM - 1:0] data_in_valid_filtered;

    logic[$clog2(PORT_NUM):0] data_out_num;
    logic[PORT_NUM - 1:0] data_out_valid_filtered;

    logic[WIDTH - 1:0] buffer[0:PORT_NUM - 1][0:DEPTH / PORT_NUM - 1];

    logic[DEPTH_WIDTH - 1:0] read_full_addr_set[0:PORT_NUM - 1];
    logic[DEPTH_WIDTH - BANK_ADDR_WIDTH - 1:0] read_bank_addr_set[0:PORT_NUM - 1];
    logic[PORT_NUM - 1:0] read_bank_id_cmp[0:BANK_NUM - 1];
    logic[DEPTH_WIDTH - BANK_ADDR_WIDTH - 1:0] read_bank_addr[0:BANK_NUM - 1];
    logic[$clog2(PORT_NUM) - 1:0] read_bank_set_index[0:BANK_NUM - 1];
    logic[BANK_NUM * WIDTH - 1:0] read_bank_data_reg[0:BANK_NUM - 1];
    logic[$clog2(BANK_NUM * WIDTH) - 1:0] read_bank_data_reg_shift[0:BANK_NUM - 1];
    logic[PORT_NUM * WIDTH - 1:0] read_bank_data_recombine[0:BANK_NUM - 1];

    logic[DEPTH_WIDTH - 1:0] write_full_addr_set[0:PORT_NUM - 1];
    logic[DEPTH_WIDTH - BANK_ADDR_WIDTH - 1:0] write_bank_addr_set[0:PORT_NUM - 1];
    logic[PORT_NUM - 1:0] write_bank_id_cmp[0:BANK_NUM - 1];
    logic[DEPTH_WIDTH - BANK_ADDR_WIDTH - 1:0] write_bank_addr[0:BANK_NUM - 1];
    logic set_we[0:PORT_NUM - 1];
    logic bank_we[0:BANK_NUM - 1];
    logic[WIDTH - 1:0] set_write_data[0:PORT_NUM - 1];
    logic[WIDTH - 1:0] bank_write_data[0:BANK_NUM - 1];

    genvar i, j;

    //full and empty signal
    assign full = ((rptr[DEPTH_WIDTH - 1:0] == wptr[DEPTH_WIDTH - 1:0]) && (rptr[DEPTH_WIDTH] != wptr[DEPTH_WIDTH])) ? 'b1 : 'b0;
    assign empty = (rptr == wptr) ? 'b1 : 'b0;

    //calculate used_space and free_space
    assign wptr_rptr_sub = wptr - rptr;
    assign used_space = full ? DEPTH : {1'b0, wptr_rptr_sub[DEPTH_WIDTH - 1:0]};
    assign free_space = DEPTH - used_space;

    //generate data_in_enable
    assign push_enable_num = (free_space >= 'd4) ? 'd4 : free_space;

    expand_one #(
        .WIDTH(PORT_NUM)
    )expand_one_data_in_enable_inst(
        .data_in(push_enable_num),
        .data_out(data_in_enable)
    );

    //generate data_in_num and data_in_valid_filtered(must be continuous)
    count_one #(
        .CONTINUOUS(1),
        .WIDTH(PORT_NUM)
    )count_one_data_in_valid_inst(
        .data_in(data_in_valid & data_in_enable),
        .sum(data_in_num)
    );

    expand_one #(
        .WIDTH(PORT_NUM)
    )expand_one_data_in_valid_filtered_inst(
        .data_in(data_in_num),
        .data_out(data_in_valid_filtered)
    );

    //generate data_out_valid
    assign pop_enable_num = (used_space >= 'd4) ? 'd4 : used_space;

    expand_one #(
        .WIDTH(PORT_NUM)
    )expand_one_data_out_valid_inst(
        .data_in(pop_enable_num),
        .data_out(data_out_valid)
    );

    //generate data_out_num and data_out_valid_filtered(msut be continuous)
    count_one #(
        .CONTINUOUS(1),
        .WIDTH(PORT_NUM)
    )count_one_data_pop_valid_inst(
        .data_in(data_out_valid & data_pop_valid),
        .sum(data_out_num)
    );

    expand_one #(
        .WIDTH(PORT_NUM)
    )expand_one_data_out_valid_filtered(
        .data_in(data_out_num),
        .data_out(data_out_valid_filtered)
    );

    //generate wptr
    always_ff @(posedge clk) begin
        if(rst | flush) begin
            wptr <= 'b0;
        end
        else if(!full && push) begin
            wptr <= wptr + data_in_num;
        end
    end

    //generate rptr
    always_ff @(posedge clk) begin
        if(rst | flush) begin
            rptr <= 'b0;
        end
        else if(!empty && pop) begin
            rptr <= rptr + data_out_num;
        end
    end

    //read bank
    generate
        for(i = 0;i < BANK_NUM;i++) begin
            assign read_full_addr_set[i] = rptr + i;
            assign read_bank_addr_set[i] = read_full_addr_set[i][DEPTH_WIDTH - 1:BANK_ADDR_WIDTH];

            for(j = 0;j < BANK_NUM;j++) begin
                assign read_bank_id_cmp[i][j] = read_full_addr_set[j][BANK_ADDR_WIDTH - 1:0] == unsigned'(i);
            end

            parallel_finder #(
                .WIDTH(BANK_NUM)
            )parallel_finder_read_bank_set_index_inst(
                .data_in(read_bank_id_cmp[i]),
                .index(read_bank_set_index[i])
            );

            data_selector #(
                .SEL_WIDTH(BANK_NUM),
                .DATA_WIDTH(DEPTH_WIDTH - BANK_ADDR_WIDTH)
            )data_selector_read_bank_addr_inst(
                .sel_in(read_bank_id_cmp[i]),
                .data_in(read_bank_addr_set),
                .data_out(read_bank_addr[i])
            );

            assign read_bank_data_reg[i] = buffer[i][read_bank_addr[i]];
            assign read_bank_data_reg_shift[i] = read_bank_set_index[i] * WIDTH;
            assign data_out[i] = read_bank_data_recombine[BANK_NUM - 1][i * WIDTH+:WIDTH];
        end

        assign read_bank_data_recombine[0] = (read_bank_data_reg[0] << read_bank_data_reg_shift[0]);

        for(i = 1;i < BANK_NUM;i++) begin
            assign read_bank_data_recombine[i] = read_bank_data_recombine[i - 1] | (read_bank_data_reg[i] << read_bank_data_reg_shift[i]);
        end
    endgenerate

    //write bank
    generate
        for(i = 0;i < BANK_NUM;i++) begin
            assign set_we[i] = data_in_valid_filtered[i] && push;
            assign set_write_data[i] = data_in[i];
        end
    endgenerate

    generate
        for(i = 0;i < BANK_NUM;i++) begin
            assign write_full_addr_set[i] = wptr + i;
            assign write_bank_addr_set[i] = write_full_addr_set[i][DEPTH_WIDTH - 1:BANK_ADDR_WIDTH];

            for(j = 0;j < BANK_NUM;j++) begin
                assign write_bank_id_cmp[i][j] = write_full_addr_set[j][BANK_ADDR_WIDTH - 1:0] == unsigned'(i);
            end

            data_selector #(
                .SEL_WIDTH(BANK_NUM),
                .DATA_WIDTH(DEPTH_WIDTH - BANK_ADDR_WIDTH)
            )data_selector_write_bank_addr_inst(
                .sel_in(write_bank_id_cmp[i]),
                .data_in(write_bank_addr_set),
                .data_out(write_bank_addr[i])
            );

            data_selector #(
                .SEL_WIDTH(BANK_NUM),
                .DATA_WIDTH(1)
            )data_selector_bank_we_inst(
                .sel_in(write_bank_id_cmp[i]),
                .data_in(set_we),
                .data_out(bank_we[i])
            );

            data_selector #(
                .SEL_WIDTH(BANK_NUM),
                .DATA_WIDTH(WIDTH)
            )data_selector_bank_write_data_inst(
                .sel_in(write_bank_id_cmp[i]),
                .data_in(set_write_data),
                .data_out(bank_write_data[i])
            );

            always_ff @(posedge clk) begin
                if(bank_we[i]) begin
                    buffer[i][write_bank_addr[i]] <= bank_write_data[i];
                end
            end
        end
    endgenerate
endmodule