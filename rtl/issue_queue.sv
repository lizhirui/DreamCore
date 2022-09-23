`include "config.svh"
`include "common.svh"

module issue_queue #(
        parameter INPUT_PORT_NUM = 1,
        parameter OUTPUT_PORT_NUM = 1,
        parameter DEPTH = 1
    )(
        input logic clk,
        input logic rst,
        
        output logic[INPUT_PORT_NUM - 1:0] iq_issue_data_channel_enable,
        input issue_queue_item_t issue_iq_data[0:INPUT_PORT_NUM - 1],
        input logic[INPUT_PORT_NUM - 1:0] issue_iq_data_valid,
        input logic issue_iq_push,
        output logic iq_issue_full,
        input logic issue_iq_flush,
        
        output issue_queue_item_t iq_issue_data[0:OUTPUT_PORT_NUM - 1],
        output logic[OUTPUT_PORT_NUM - 1:0] iq_issue_data_valid,
        output logic iq_issue_empty,
        
        input logic stbuf_all_empty,

        input logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full,
        input logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full,
        input logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full,
        input logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full,
        input logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full,
        input logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full,

        output logic iq_issue_issue_execute_fifo_full_add,
        
        input execute_feedback_pack_t execute_feedback_pack,
        input wb_feedback_pack_t wb_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    localparam DEPTH_WIDTH = $clog2(DEPTH);

    issue_queue_item_t[DEPTH - 1:0] buffer;
    logic[DEPTH_WIDTH:0] wptr;
    logic[DEPTH_WIDTH:0] wptr_next;

    issue_queue_item_t[DEPTH - 1:0] buffer_feedback;
    issue_queue_item_t[DEPTH - 1:0] buffer_input;

    logic[$clog2(INPUT_PORT_NUM):0] wptr_ext_incr;

    logic[DEPTH - 1:0] buffer_need_map;
    logic[DEPTH - 1:0] buffer_need_map_temp;
    logic[DEPTH_WIDTH - 1:0] buffer_map_src[0:DEPTH - 1];
    logic[DEPTH_WIDTH - 1:0] buffer_map_src_temp[0:DEPTH - 1];
    logic[DEPTH - 1:0] buffer_map_dst_valid;
    logic[DEPTH_WIDTH - 1:0] buffer_map_dst[0:DEPTH - 1];

    logic[DEPTH - 1:0] buffer_map_dst_cmp[0:DEPTH - 1];
    
    logic[DEPTH - 1:0] buffer_item_invalid;
    logic[$clog2(OUTPUT_PORT_NUM):0] buffer_item_invalid_num;

    logic[`COMMIT_WIDTH - 1:0] inst_waiting_ok_cmp;
    logic inst_waiting_ok;

    logic[`ROB_ID_WIDTH - 1:0] inst_rob_id[0:OUTPUT_PORT_NUM - 1];
    logic[OUTPUT_PORT_NUM - 1:0] inst_rob_id_cmp;
    logic is_inst_waiting_next;
    logic[`ROB_ID_WIDTH - 1:0] inst_waiting_rob_id_next;

    logic is_inst_waiting;
    logic[`ROB_ID_WIDTH - 1:0] inst_waiting_rob_id;

    logic[$clog2(`ALU_UNIT_NUM):0] alu_remain_num_input[0:DEPTH - 1];
    logic[$clog2(`BRU_UNIT_NUM):0] bru_remain_num_input[0:DEPTH - 1];
    logic[$clog2(`CSR_UNIT_NUM):0] csr_remain_num_input[0:DEPTH - 1];
    logic[$clog2(`DIV_UNIT_NUM):0] div_remain_num_input[0:DEPTH - 1];
    logic[$clog2(`LSU_UNIT_NUM):0] lsu_remain_num_input[0:DEPTH - 1];
    logic[$clog2(`MUL_UNIT_NUM):0] mul_remain_num_input[0:DEPTH - 1];

    logic[$clog2(`ALU_UNIT_NUM):0] alu_remain_num[0:DEPTH - 1];
    logic[$clog2(`BRU_UNIT_NUM):0] bru_remain_num[0:DEPTH - 1];
    logic[$clog2(`CSR_UNIT_NUM):0] csr_remain_num[0:DEPTH - 1];
    logic[$clog2(`DIV_UNIT_NUM):0] div_remain_num[0:DEPTH - 1];
    logic[$clog2(`LSU_UNIT_NUM):0] lsu_remain_num[0:DEPTH - 1];
    logic[$clog2(`MUL_UNIT_NUM):0] mul_remain_num[0:DEPTH - 1];

    logic[$clog2(`EXECUTE_UNIT_NUM):0] unit_remain_num[0:DEPTH - 1];

    logic[DEPTH - 1:0] has_lsu_op;
    logic[DEPTH - 1:0] has_lsu_op_input;
    logic[DEPTH - 1:0] fence_trigger;
    logic[DEPTH - 1:0] need_to_exit;

    logic[DEPTH_WIDTH:0] cur_output_index[0:DEPTH - 1];
    logic[DEPTH - 1:0] output_port_map_cmp[0:OUTPUT_PORT_NUM - 1];
    logic[DEPTH_WIDTH - 1:0] output_port_map_index[0:OUTPUT_PORT_NUM - 1];
    logic output_port_map_valid[0:OUTPUT_PORT_NUM - 1];

    logic[DEPTH_WIDTH - 1:0] cur_id[0:DEPTH - 1];

    logic[DEPTH_WIDTH:0] remain_space;

    logic[`EXECUTE_UNIT_NUM - 1:0] phy_exefb_cmp[0:DEPTH - 1][0:1];
    logic[$clog2(`EXECUTE_UNIT_NUM) - 1:0] phy_exefb_index[0:DEPTH - 1][0:1];
    logic phy_exefb_index_valid[0:DEPTH - 1][0:1];

    logic[`WB_WIDTH - 1:0] phy_wbfb_cmp[0:DEPTH - 1][0:1];
    logic[$clog2(`WB_WIDTH) - 1:0] phy_wbfb_index[0:DEPTH - 1][0:1];
    logic phy_wbfb_index_valid[0:DEPTH - 1][0:1];

    genvar i, j;

    //generate full/empty signals
    assign iq_issue_full = (wptr[DEPTH_WIDTH] == 'b1) && (wptr[DEPTH_WIDTH - 1:0] == 'b0);
    assign iq_issue_empty = (wptr == 'b0);

    //count empty items and generate data_channel_enable signal
    assign remain_space = iq_issue_full ? 'b0 : (DEPTH - wptr[DEPTH_WIDTH - 1:0]);
    assign iq_issue_data_channel_enable = ('b1 << remain_space) - 'b1;

    //count input items to generate wptr incr
    count_one #(
        .CONTINUOUS(1),
        .WIDTH(INPUT_PORT_NUM)
    )count_one_wptr_incr_inst(
        .data_in(iq_issue_data_channel_enable & issue_iq_data_valid),
        .sum(wptr_ext_incr)
    );

    generate
        //generate initial execute unit remain number
        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`ALU_UNIT_NUM)
        )count_one_alu_remain_num(
            .data_in(~issue_alu_fifo_full),
            .sum(alu_remain_num_input[0])
        );

        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`BRU_UNIT_NUM)
        )count_one_bru_remain_num(
            .data_in(~issue_bru_fifo_full),
            .sum(bru_remain_num_input[0])
        );

        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`CSR_UNIT_NUM)
        )count_one_csr_remain_num(
            .data_in(~issue_csr_fifo_full),
            .sum(csr_remain_num_input[0])
        );

        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`DIV_UNIT_NUM)
        )count_one_div_remain_num(
            .data_in(~issue_div_fifo_full),
            .sum(div_remain_num_input[0])
        );

        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`LSU_UNIT_NUM)
        )count_one_lsu_remain_num(
            .data_in(~issue_lsu_fifo_full),
            .sum(lsu_remain_num_input[0])
        );

        count_one #(
            .CONTINUOUS(0),
            .WIDTH(`MUL_UNIT_NUM)
        )count_one_mul_remain_num(
            .data_in(~issue_mul_fifo_full),
            .sum(mul_remain_num_input[0])
        );

        //generate initial cur_output_index signal
        assign cur_output_index[0] = 'b0;
        //generate initial need_to_exit signal
        assign need_to_exit[0] = (buffer_feedback[0].op_unit == op_unit_t::csr) || (buffer_feedback[0].op == op_t::mret);
        //generate has_lsu_op and has_lsu_op_input signal
        assign has_lsu_op[0] = (buffer_feedback[0].op_unit == op_unit_t::lsu);
        assign has_lsu_op_input[0] = 'b0;
        //generate initial fence_trigger signal, which indicates fence behavior occurs
        assign fence_trigger[0] = (buffer_feedback[0].op == op_t::fence) && (!stbuf_all_empty || (commit_feedback_pack.next_handle_rob_id != buffer_feedback[0].rob_id));
        //generate initial buffer_item_invalid signal
        assign buffer_item_invalid[0] = (unsigned'(0) < wptr) //valid index
                                        && (buffer_feedback[0].src1_loaded && buffer_feedback[0].src2_loaded) //source operators are all ready
                                        && (|unit_remain_num[0]) //idle execute unit is exist
                                        && (!fence_trigger[0]) //no fence behavior occurs
                                        && (!is_inst_waiting || inst_waiting_ok) //no waiting instruction
                                        && (((buffer_feedback[0].op_unit != op_unit_t::csr) && (buffer_feedback[0].op != op_t::mret)) || 
                                        (commit_feedback_pack.next_handle_rob_id_valid && (commit_feedback_pack.next_handle_rob_id == buffer_feedback[0].rob_id)));
                                        //csr or mret instruction must be issued only when that's the first issued instruction at this time
                                        //and corresponding rob_id must be next_handle_rob_id

        for(i = 1;i < DEPTH;i++) begin
            //let last exeucte unit remain number as current remain_num_input
            assign alu_remain_num_input[i] = alu_remain_num[i - 1];
            assign bru_remain_num_input[i] = bru_remain_num[i - 1];
            assign csr_remain_num_input[i] = csr_remain_num[i - 1];
            assign div_remain_num_input[i] = div_remain_num[i - 1];
            assign lsu_remain_num_input[i] = lsu_remain_num[i - 1];
            assign mul_remain_num_input[i] = mul_remain_num[i - 1];
            //generate output port index(item i need to be output only when buffer_item_invalid[i] == true)
            assign cur_output_index[i] = (cur_output_index[i - 1] == OUTPUT_PORT_NUM) ? cur_output_index[i - 1] : (cur_output_index[i - 1] + buffer_item_invalid[i - 1]);
            //generate has_lsu_op and has_lsu_op_input signal
            assign has_lsu_op[i] = (buffer_feedback[i].op_unit == op_unit_t::lsu) || has_lsu_op_input[i];
            assign has_lsu_op_input[i] = has_lsu_op[i - 1];
            //generate fence_trigger signal, for any fence instruction which isn't the first issued instruction must trigger fence behavior
            assign fence_trigger[i] = buffer_feedback[i].op == op_t::fence;
            //indicate whether current item is the last item that should be issued
            assign need_to_exit[i] = (buffer_feedback[i].op_unit == op_unit_t::csr) || (buffer_feedback[i].op == op_t::mret) || need_to_exit[i - 1];
            //indicate whether current item should be issued
            assign buffer_item_invalid[i] = (unsigned'(i) < wptr) //valid index
                                            && (buffer_feedback[i].src1_loaded && buffer_feedback[i].src2_loaded) //source operators are all ready
                                            && (|unit_remain_num[i]) //idle execute unit is exist
                                            && (!need_to_exit[i - 1]) //last item isn't the last item
                                            && (cur_output_index[i] < OUTPUT_PORT_NUM) //enough output port is exist
                                            && (!fence_trigger[i]) //no fence behavior occurs
                                            && (!is_inst_waiting || inst_waiting_ok) //no waiting instruction
                                            && ((buffer_feedback[i].op_unit != op_unit_t::lsu) || (!has_lsu_op_input[i])) //lsu instruction doesn't support out-of-order execute
                                            && ((buffer_feedback[i].op_unit != op_unit_t::csr) && (buffer_feedback[i].op != op_t::mret));
                                            //csr or mret instruction must be issued only when that's the first issued instruction at this time
                                            //and corresponding rob_id must be next_handle_rob_id
        end

        for(i = 0;i < DEPTH;i++) begin
            //update execute unit remain number
            assign alu_remain_num[i] = (alu_remain_num_input[i] == 'b0) ? 'b0 : (alu_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::alu) && buffer_item_invalid[i]) ? 'b1 : 'b0));
            assign bru_remain_num[i] = (bru_remain_num_input[i] == 'b0) ? 'b0 : (bru_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::bru) && buffer_item_invalid[i]) ? 'b1 : 'b0));
            assign csr_remain_num[i] = (csr_remain_num_input[i] == 'b0) ? 'b0 : (csr_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::csr) && buffer_item_invalid[i]) ? 'b1 : 'b0));
            assign div_remain_num[i] = (div_remain_num_input[i] == 'b0) ? 'b0 : (div_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::div) && buffer_item_invalid[i]) ? 'b1 : 'b0));
            assign lsu_remain_num[i] = (lsu_remain_num_input[i] == 'b0) ? 'b0 : (lsu_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::lsu)) && buffer_item_invalid[i] ? 'b1 : 'b0));
            assign mul_remain_num[i] = (mul_remain_num_input[i] == 'b0) ? 'b0 : (mul_remain_num_input[i] - (((buffer_feedback[i].op_unit == op_unit_t::mul)) && buffer_item_invalid[i] ? 'b1 : 'b0));

            //current execute unit remain number
            assign unit_remain_num[i] = (buffer_feedback[i].op_unit == op_unit_t::alu) ? alu_remain_num_input[i] :
                                        (buffer_feedback[i].op_unit == op_unit_t::bru) ? bru_remain_num_input[i] :
                                        (buffer_feedback[i].op_unit == op_unit_t::csr) ? csr_remain_num_input[i] :
                                        (buffer_feedback[i].op_unit == op_unit_t::div) ? div_remain_num_input[i] :
                                        (buffer_feedback[i].op_unit == op_unit_t::lsu) ? lsu_remain_num_input[i] : mul_remain_num_input[i];
        end
    endgenerate

    //generate output port index -> buffer_feedback item index map
    generate
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            for(j = 0;j < DEPTH;j++) begin
                assign output_port_map_cmp[i][j] = (i == cur_output_index[j]) && buffer_item_invalid[j];
            end

            parallel_finder #(
                .WIDTH(DEPTH)
            )parallel_finder_output_port_map_inst(
                .data_in(output_port_map_cmp[i]),
                .index(output_port_map_index[i]),
                .index_valid(output_port_map_valid[i])
            );
        end
    endgenerate

    //map output data to output port
    generate
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            assign iq_issue_data[i] = buffer_feedback[output_port_map_index[i]];
            assign iq_issue_data_valid[i] = output_port_map_valid[i];
        end
    endgenerate

    //generate instruction waiting information
    generate
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            assign inst_rob_id[i] = iq_issue_data[i].rob_id;
            assign inst_rob_id_cmp[i] = ((iq_issue_data[i].op_unit == op_unit_t::csr) || (iq_issue_data[i].op == op_t::mret)) && iq_issue_data_valid[i];
        end
    endgenerate

    data_selector #(
        .SEL_WIDTH(OUTPUT_PORT_NUM),
        .DATA_WIDTH(`ROB_ID_WIDTH)
    )data_selector_inst_rob_id_inst(
        .sel_in(inst_rob_id_cmp),
        .data_in(inst_rob_id),
        .data_out(inst_waiting_rob_id_next),
        .data_out_valid(is_inst_waiting_next)
    );

    always_ff @(posedge clk) begin
        if(rst | issue_iq_flush) begin
            is_inst_waiting <= 'b0;
            inst_waiting_rob_id <= 'b0;
        end
        else if(!is_inst_waiting || inst_waiting_ok) begin
            is_inst_waiting <= is_inst_waiting_next;
            inst_waiting_rob_id <= inst_waiting_rob_id_next;
        end
    end

    //generate inst_waiting_ok signal to indicate waiting instruction has done.
    generate
        for(i = 0;i < `COMMIT_WIDTH;i++) begin
            assign inst_waiting_ok_cmp[i] = commit_feedback_pack.enable && commit_feedback_pack.committed_rob_id_valid[i] && (commit_feedback_pack.committed_rob_id[i] == inst_waiting_rob_id);
        end
    endgenerate

    parallel_finder #(
        .WIDTH(`COMMIT_WIDTH)
    )parallel_finder_inst_waiting_ok_inst(
        .data_in(inst_waiting_ok_cmp),
        .index_valid(inst_waiting_ok)
    );

    //count invalid items
    count_one #(
        .CONTINUOUS(0),
        .WIDTH(OUTPUT_PORT_NUM)
    )count_one_buffer_item_invalid_num_inst(
        .data_in(iq_issue_data_valid),
        .sum(buffer_item_invalid_num)
    );

    //generate wptr_next
    //this process has two part, one part is invalid item number, another part is input item number
    //when a instruction retiring event is waiting, other instructions are probihited to issue, so invalid item number is 0
    assign wptr_next = wptr - buffer_item_invalid_num + (issue_iq_push ? wptr_ext_incr : 'b0);

    //generate wptr
    always_ff @(posedge clk) begin
        if(rst | issue_iq_flush) begin
            wptr <= 'b0;
        end
        else begin
            wptr <= wptr_next;
        end
    end

    //---------------------------------------------------------------------------------------------------------------------------------------------------------
    //new buffer generation process:
    //1. buffer -> buffer_feedback: if the src1/2_loaded of any item is false, then src1/2_value will be obtained from execute/wb feedback channel.
    //2. {buffer_feedback, input data} -> buffer_input: insert new data with buffer_feedback into buffer_input.
    //3. buffer_input -> buffer: this is a compress process, which means that the data that is transferred to buffer write port is compressed buffer_input. 
    //---------------------------------------------------------------------------------------------------------------------------------------------------------

    //generate phy feedback information
    generate
        for(i = 0;i < DEPTH;i++) begin: issue_input
            for(j = 0;j < `EXECUTE_UNIT_NUM;j++) begin
                assign phy_exefb_cmp[i][0][j] = execute_feedback_pack.channel[j].enable && (buffer[i].rs1_phy == execute_feedback_pack.channel[j].phy_id);
                assign phy_exefb_cmp[i][1][j] = execute_feedback_pack.channel[j].enable && (buffer[i].rs2_phy == execute_feedback_pack.channel[j].phy_id);
            end

            parallel_finder #(
                .WIDTH(`EXECUTE_UNIT_NUM)
            )parallel_finder_phy_exefb_0_inst(
                .data_in(phy_exefb_cmp[i][0]),
                .index(phy_exefb_index[i][0]),
                .index_valid(phy_exefb_index_valid[i][0])
            );

            parallel_finder #(
                .WIDTH(`EXECUTE_UNIT_NUM)
            )parallel_finder_phy_exefb_1_inst(
                .data_in(phy_exefb_cmp[i][1]),
                .index(phy_exefb_index[i][1]),
                .index_valid(phy_exefb_index_valid[i][1])
            );

            for(j = 0;j < `WB_WIDTH;j++) begin
                assign phy_wbfb_cmp[i][0][j] = wb_feedback_pack.channel[j].enable && (buffer[i].rs1_phy == wb_feedback_pack.channel[j].phy_id);
                assign phy_wbfb_cmp[i][1][j] = wb_feedback_pack.channel[j].enable && (buffer[i].rs2_phy == wb_feedback_pack.channel[j].phy_id);
            end

            parallel_finder #(
                .WIDTH(`WB_WIDTH)
            )parallel_finder_phy_wbfb_0_inst(
                .data_in(phy_wbfb_cmp[i][0]),
                .index(phy_wbfb_index[i][0]),
                .index_valid(phy_wbfb_index_valid[i][0])
            );

            parallel_finder #(
                .WIDTH(`WB_WIDTH)
            )parallel_finder_phy_wbfb_1_inst(
                .data_in(phy_wbfb_cmp[i][1]),
                .index(phy_wbfb_index[i][1]),
                .index_valid(phy_wbfb_index_valid[i][1])
            );
        end
    endgenerate

    //generate buffer_feedback
    generate
        for(i = 0;i < DEPTH;i++) begin
            assign buffer_feedback[i].enable = buffer[i].enable;
            assign buffer_feedback[i].value = buffer[i].value;
            assign buffer_feedback[i].valid = buffer[i].valid;
            assign buffer_feedback[i].rob_id = buffer[i].rob_id;
            assign buffer_feedback[i].pc = buffer[i].pc;
            assign buffer_feedback[i].imm = buffer[i].imm;
            assign buffer_feedback[i].has_exception = buffer[i].has_exception;
            assign buffer_feedback[i].exception_id = buffer[i].exception_id;
            assign buffer_feedback[i].exception_value = buffer[i].exception_value;

            assign buffer_feedback[i].predicted = buffer[i].predicted;
            assign buffer_feedback[i].predicted_jump = buffer[i].predicted_jump;
            assign buffer_feedback[i].predicted_next_pc = buffer[i].predicted_next_pc;
            assign buffer_feedback[i].checkpoint_id_valid = buffer[i].checkpoint_id_valid;
            assign buffer_feedback[i].checkpoint_id = buffer[i].checkpoint_id;

            assign buffer_feedback[i].rs1 = buffer[i].rs1;
            assign buffer_feedback[i].arg1_src = buffer[i].arg1_src;
            assign buffer_feedback[i].rs1_need_map = buffer[i].rs1_need_map;
            assign buffer_feedback[i].rs1_phy = buffer[i].rs1_phy;
            assign buffer_feedback[i].src1_value = buffer[i].src1_loaded ? buffer[i].src1_value : 
                                          phy_exefb_index_valid[i][0] ? execute_feedback_pack.channel[phy_exefb_index[i][0]] : 
                                          wb_feedback_pack.channel[phy_wbfb_index[i][0]];
            assign buffer_feedback[i].src1_loaded = buffer[i].src1_loaded || phy_exefb_index_valid[i][0] || phy_wbfb_index_valid[i][0];

            assign buffer_feedback[i].rs2 = buffer[i].rs2;
            assign buffer_feedback[i].arg2_src = buffer[i].arg2_src;
            assign buffer_feedback[i].rs2_need_map = buffer[i].rs2_need_map;
            assign buffer_feedback[i].rs2_phy = buffer[i].rs2_phy;
            assign buffer_feedback[i].src2_value = buffer[i].src2_loaded ? buffer[i].src2_value : 
                                          phy_exefb_index_valid[i][1] ? execute_feedback_pack.channel[phy_exefb_index[i][1]] : 
                                          wb_feedback_pack.channel[phy_wbfb_index[i][1]];
            assign buffer_feedback[i].src2_loaded = buffer[i].src2_loaded || phy_exefb_index_valid[i][1] || phy_wbfb_index_valid[i][1];

            assign buffer_feedback[i].rd = buffer[i].rd;
            assign buffer_feedback[i].rd_enable = buffer[i].rd_enable;
            assign buffer_feedback[i].need_rename = buffer[i].need_rename;
            assign buffer_feedback[i].rd_phy = buffer[i].rd_phy;

            assign buffer_feedback[i].csr = buffer[i].csr;
            assign buffer_feedback[i].op = buffer[i].op;
            assign buffer_feedback[i].op_unit = buffer[i].op_unit;
            assign buffer_feedback[i].sub_op.raw_data = buffer[i].sub_op.raw_data;
        end
    endgenerate

    //generate buffer_input
    generate
        for(i = 0;i < DEPTH;i++) begin
            assign buffer_input[i] = (i >= wptr) && (i < (wptr + INPUT_PORT_NUM)) ? issue_iq_data[i - wptr] : buffer_feedback[i];
        end
    endgenerate

    //generate source->destination map, source is uncompressed buffer, destination is compressed buffer
    //if buffer_map_dst[i] == j and buffer_map_dst_valid[i] == true, a map from i to j is exist
    //buffer_map_dst[i] has definition only when buffer_map_dst_valid[i] == true, otherwise, corresponding item will be compressed(i.e., removed)
    generate
        for(i = 0;i < DEPTH;i++) begin
            assign buffer_map_dst_valid[i] = !buffer_item_invalid[i];
        end

        assign buffer_map_dst[0] = 'b0;

        for(i = 1;i < DEPTH;i++) begin
            assign buffer_map_dst[i] = buffer_map_dst_valid[i - 1] ? (buffer_map_dst[i - 1] + 'b1) : buffer_map_dst[i - 1];
        end
    endgenerate

    //convert source->destination map to destination->source map, i.e., buffer_map_src, and a enable array, buffer_need_map
    //if buffer_map_src[j] == i and buffer_need_map[j] == true, a map from i to j is exist
    //buffer_map_src[j] has definition only when buffer_need_map[j] == true, otherwise, corresponding item will be a unknown item
    generate
        for(i = 0;i < DEPTH;i++) begin: buffer_map_dst_to_buffer_map_src
            for(j = 0;j < DEPTH;j++) begin
                assign buffer_map_dst_cmp[i][j] = (buffer_map_dst[j] == i) && buffer_map_dst_valid[j];
            end

            parallel_finder #(
                .WIDTH(DEPTH)
            )parallel_finder_buffer_map_dst_to_buffer_map_src_inst(
                .data_in(buffer_map_dst_cmp[i]),
                .index(buffer_map_src_temp[i]),
                .index_valid(buffer_need_map_temp[i])
            );

            assign buffer_map_src[i] = buffer_map_src_temp[i];
            assign buffer_need_map[i] = buffer_need_map_temp[i];
        end
    endgenerate

    //update buffer with dst->src map
    generate
        for(i = 0;i < DEPTH;i++) begin
            always_ff @(posedge clk) begin
                if(buffer_need_map[i]) begin
                    buffer[i] <= buffer_input[buffer_map_src[i]];
                end
            end
        end
    endgenerate

    assign iq_issue_issue_execute_fifo_full_add = ((iq_issue_data_channel_enable & issue_iq_data_valid) != issue_iq_data_valid) && issue_iq_push && !issue_iq_flush;
endmodule