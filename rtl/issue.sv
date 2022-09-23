`include "config.svh"
`include "common.svh"

module issue(
        input logic clk,
        input logic rst,
        
        input logic stbuf_all_empty,
        
        output logic[`PHY_REG_ID_WIDTH - 1:0] issue_phyf_id[0:`READREG_WIDTH - 1][0:1],
        input logic[`REG_DATA_WIDTH - 1:0] phyf_issue_data[0:`READREG_WIDTH - 1][0:1],
        input logic phyf_issue_data_valid[0:`READREG_WIDTH - 1][0:1],

        output logic[`ADDR_WIDTH - 1:0] issue_stbuf_read_addr,
        output logic[`SIZE_WIDTH - 1:0] issue_stbuf_read_size,
        output logic issue_stbuf_rd,
        
        output logic issue_csrf_issue_execute_fifo_full_add,
        output logic issue_csrf_issue_queue_full_add,
        
        input readreg_issue_pack_t readreg_issue_port_data_out,
        
        input logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_full,
        output issue_execute_pack_t issue_alu_fifo_data_in[0:`ALU_UNIT_NUM - 1],
        output logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_push,
        output logic[`ALU_UNIT_NUM - 1:0] issue_alu_fifo_flush,
        input logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_full,
        output issue_execute_pack_t issue_bru_fifo_data_in[0:`BRU_UNIT_NUM - 1],
        output logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_push,
        output logic[`BRU_UNIT_NUM - 1:0] issue_bru_fifo_flush,
        input logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_full,
        output issue_execute_pack_t issue_csr_fifo_data_in[0:`CSR_UNIT_NUM - 1],
        output logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_push,
        output logic[`CSR_UNIT_NUM - 1:0] issue_csr_fifo_flush,
        input logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_full,
        output issue_execute_pack_t issue_div_fifo_data_in[0:`DIV_UNIT_NUM - 1],
        output logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_push,
        output logic[`DIV_UNIT_NUM - 1:0] issue_div_fifo_flush,
        input logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_full,
        output issue_execute_pack_t issue_lsu_fifo_data_in[0:`LSU_UNIT_NUM - 1],
        output logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_push,
        output logic[`LSU_UNIT_NUM - 1:0] issue_lsu_fifo_flush,
        input logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_full,
        output issue_execute_pack_t issue_mul_fifo_data_in[0:`MUL_UNIT_NUM - 1],
        output logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_push,
        output logic[`MUL_UNIT_NUM - 1:0] issue_mul_fifo_flush,
        
        output issue_feedback_pack_t issue_feedback_pack,
        input execute_feedback_pack_t execute_feedback_pack,
        input wb_feedback_pack_t wb_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    localparam INPUT_PORT_NUM = `READREG_WIDTH;
    localparam OUTPUT_PORT_NUM = `ISSUE_WIDTH;

    logic[INPUT_PORT_NUM - 1:0] iq_issue_data_channel_enable;
    issue_queue_item_t issue_iq_data[0:INPUT_PORT_NUM - 1];
    logic[INPUT_PORT_NUM - 1:0] issue_iq_data_valid;
    logic issue_iq_push;
    logic iq_issue_full;
    logic issue_iq_flush;
    
    issue_queue_item_t iq_issue_data[0:OUTPUT_PORT_NUM - 1];
    logic[OUTPUT_PORT_NUM - 1:0] iq_issue_data_valid;
    logic iq_issue_empty;

    logic busy;

    logic[$clog2(`READREG_WIDTH) - 1:0] last_index;
    logic[`max($clog2(`ALU_UNIT_NUM) - 1, 0):0] alu_index;
    logic[`max($clog2(`BRU_UNIT_NUM) - 1, 0):0] bru_index;
    logic[`max($clog2(`CSR_UNIT_NUM) - 1, 0):0] csr_index;
    logic[`max($clog2(`DIV_UNIT_NUM) - 1, 0):0] div_index;
    logic[`max($clog2(`LSU_UNIT_NUM) - 1, 0):0] lsu_index;
    logic[`max($clog2(`MUL_UNIT_NUM) - 1, 0):0] mul_index;

    logic[`ISSUE_WIDTH - 1:0] issue_has_alu_op_cmp;
    logic[`ISSUE_WIDTH - 1:0] issue_has_bru_op_cmp;
    logic[`ISSUE_WIDTH - 1:0] issue_has_csr_op_cmp;
    logic[`ISSUE_WIDTH - 1:0] issue_has_div_op_cmp;
    logic[`ISSUE_WIDTH - 1:0] issue_has_lsu_op_cmp;
    logic[`ISSUE_WIDTH - 1:0] issue_has_mul_op_cmp;

    logic[$clog2(`ISSUE_WIDTH):0] issue_alu_op_num;
    logic[$clog2(`ISSUE_WIDTH):0] issue_bru_op_num;
    logic[$clog2(`ISSUE_WIDTH):0] issue_csr_op_num;
    logic[$clog2(`ISSUE_WIDTH):0] issue_div_op_num;
    logic[$clog2(`ISSUE_WIDTH):0] issue_lsu_op_num;
    logic[$clog2(`ISSUE_WIDTH):0] issue_mul_op_num;

    logic[`max($clog2(`ALU_UNIT_NUM) - 1, 0):0] available_alu_index[0:`ALU_UNIT_NUM - 1];
    logic[`max($clog2(`BRU_UNIT_NUM) - 1, 0):0] available_bru_index[0:`BRU_UNIT_NUM - 1];
    logic[`max($clog2(`CSR_UNIT_NUM) - 1, 0):0] available_csr_index[0:`CSR_UNIT_NUM - 1];
    logic[`max($clog2(`DIV_UNIT_NUM) - 1, 0):0] available_div_index[0:`DIV_UNIT_NUM - 1];
    logic[`max($clog2(`LSU_UNIT_NUM) - 1, 0):0] available_lsu_index[0:`LSU_UNIT_NUM - 1];
    logic[`max($clog2(`MUL_UNIT_NUM) - 1, 0):0] available_mul_index[0:`MUL_UNIT_NUM - 1];

    logic[`max($clog2(`ALU_UNIT_NUM) - 1, 0):0] send_alu_index[0:`ISSUE_WIDTH - 1];
    logic[`max($clog2(`BRU_UNIT_NUM) - 1, 0):0] send_bru_index[0:`ISSUE_WIDTH - 1];
    logic[`max($clog2(`CSR_UNIT_NUM) - 1, 0):0] send_csr_index[0:`ISSUE_WIDTH - 1];
    logic[`max($clog2(`DIV_UNIT_NUM) - 1, 0):0] send_div_index[0:`ISSUE_WIDTH - 1];
    logic[`max($clog2(`LSU_UNIT_NUM) - 1, 0):0] send_lsu_index[0:`ISSUE_WIDTH - 1];
    logic[`max($clog2(`MUL_UNIT_NUM) - 1, 0):0] send_mul_index[0:`ISSUE_WIDTH - 1];

    logic[`ISSUE_WIDTH - 1:0] alu_send_inst_cmp[0:`ALU_UNIT_NUM - 1];
    logic[`ISSUE_WIDTH - 1:0] bru_send_inst_cmp[0:`BRU_UNIT_NUM - 1];
    logic[`ISSUE_WIDTH - 1:0] csr_send_inst_cmp[0:`CSR_UNIT_NUM - 1];
    logic[`ISSUE_WIDTH - 1:0] div_send_inst_cmp[0:`DIV_UNIT_NUM - 1];
    logic[`ISSUE_WIDTH - 1:0] lsu_send_inst_cmp[0:`LSU_UNIT_NUM - 1];
    logic[`ISSUE_WIDTH - 1:0] mul_send_inst_cmp[0:`MUL_UNIT_NUM - 1];

    logic[$clog2(`ISSUE_WIDTH) - 1:0] alu_send_inst_index[0:`ALU_UNIT_NUM - 1];
    logic[$clog2(`ISSUE_WIDTH) - 1:0] bru_send_inst_index[0:`BRU_UNIT_NUM - 1];
    logic[$clog2(`ISSUE_WIDTH) - 1:0] csr_send_inst_index[0:`CSR_UNIT_NUM - 1];
    logic[$clog2(`ISSUE_WIDTH) - 1:0] div_send_inst_index[0:`DIV_UNIT_NUM - 1];
    logic[$clog2(`ISSUE_WIDTH) - 1:0] lsu_send_inst_index[0:`LSU_UNIT_NUM - 1];
    logic[$clog2(`ISSUE_WIDTH) - 1:0] mul_send_inst_index[0:`MUL_UNIT_NUM - 1];

    logic[`ALU_UNIT_NUM - 1:0] alu_send_inst_index_valid;
    logic[`BRU_UNIT_NUM - 1:0] bru_send_inst_index_valid;
    logic[`CSR_UNIT_NUM - 1:0] csr_send_inst_index_valid;
    logic[`DIV_UNIT_NUM - 1:0] div_send_inst_index_valid;
    logic[`LSU_UNIT_NUM - 1:0] lsu_send_inst_index_valid;
    logic[`MUL_UNIT_NUM - 1:0] mul_send_inst_index_valid;

    issue_queue_item_t t_item[0:`READREG_WIDTH - 1];
    issue_queue_item_t t_item_redirected[0:`READREG_WIDTH - 1];
    issue_queue_item_t t_item_empty;
    logic[`READREG_WIDTH - 1:0] redirected_valid;
    logic[`READREG_WIDTH - 1:0] redirected_pack_valid;
    readreg_issue_pack_t rev_pack;
    readreg_issue_op_info_t cur_op[0:`READREG_WIDTH - 1];

    logic[`EXECUTE_UNIT_NUM - 1:0] input_phy_exefb_cmp[0:`READREG_WIDTH - 1][0:1];
    logic[$clog2(`EXECUTE_UNIT_NUM) - 1:0] input_phy_exefb_index[0:`READREG_WIDTH - 1][0:1];
    logic input_phy_exefb_index_valid[0:`READREG_WIDTH - 1][0:1];

    logic[`WB_WIDTH - 1:0] input_phy_wbfb_cmp[0:`READREG_WIDTH - 1][0:1];
    logic[$clog2(`WB_WIDTH) - 1:0] input_phy_wbfb_index[0:`READREG_WIDTH - 1][0:1];
    logic input_phy_wbfb_index_valid[0:`READREG_WIDTH - 1][0:1];

    logic[$clog2(`READREG_WIDTH):0] input_push_num;

    logic lsu_has_exception;
    riscv_exception_t::_type lsu_exception_id;

    issue_execute_pack_t iq_issue_data_converted[0:OUTPUT_PORT_NUM - 1];

    genvar i, j;

    assign rev_pack = readreg_issue_port_data_out;

    issue_queue #(
        .INPUT_PORT_NUM(INPUT_PORT_NUM),
        .OUTPUT_PORT_NUM(OUTPUT_PORT_NUM),
        .DEPTH(`ISSUE_QUEUE_SIZE)
    )issue_queue_inst(
        .clk(clk),
        .rst(rst),
        .iq_issue_data_channel_enable(iq_issue_data_channel_enable),
        .issue_iq_data(issue_iq_data),
        .issue_iq_data_valid(issue_iq_data_valid),
        .issue_iq_push(issue_iq_push),
        .iq_issue_full(iq_issue_full),
        .issue_iq_flush(issue_iq_flush),
        .iq_issue_data(iq_issue_data),
        .iq_issue_data_valid(iq_issue_data_valid),
        .iq_issue_empty(iq_issue_empty),
        .stbuf_all_empty(stbuf_all_empty),
        .issue_alu_fifo_full(issue_alu_fifo_full),
        .issue_bru_fifo_full(issue_bru_fifo_full),
        .issue_csr_fifo_full(issue_csr_fifo_full),
        .issue_div_fifo_full(issue_div_fifo_full),
        .issue_lsu_fifo_full(issue_lsu_fifo_full),
        .issue_mul_fifo_full(issue_mul_fifo_full),
        .iq_issue_issue_execute_fifo_full_add(issue_csrf_issue_execute_fifo_full_add),
        .execute_feedback_pack(execute_feedback_pack),
        .wb_feedback_pack(wb_feedback_pack),
        .commit_feedback_pack(commit_feedback_pack)
    );

    generate
        for(i = 0;i < OUTPUT_PORT_NUM;i++) begin
            assign iq_issue_data_converted[i].enable = iq_issue_data[i].enable;
            assign iq_issue_data_converted[i].value = iq_issue_data[i].value;
            assign iq_issue_data_converted[i].valid = iq_issue_data[i].valid;
            assign iq_issue_data_converted[i].rob_id = iq_issue_data[i].rob_id;
            assign iq_issue_data_converted[i].pc = iq_issue_data[i].pc;
            assign iq_issue_data_converted[i].imm = iq_issue_data[i].imm;
            assign iq_issue_data_converted[i].has_exception = (iq_issue_data[i].valid && (iq_issue_data[i].op_unit == op_unit_t::lsu)) ? lsu_has_exception : iq_issue_data[i].has_exception;
            assign iq_issue_data_converted[i].exception_id = (iq_issue_data[i].valid && (iq_issue_data[i].op_unit == op_unit_t::lsu)) ? lsu_exception_id : iq_issue_data[i].exception_id;
            assign iq_issue_data_converted[i].exception_value = (iq_issue_data[i].valid && (iq_issue_data[i].op_unit == op_unit_t::lsu)) ? (iq_issue_data[i].src1_value + iq_issue_data[i].imm) : iq_issue_data[i].exception_value;
            assign iq_issue_data_converted[i].predicted = iq_issue_data[i].predicted;
            assign iq_issue_data_converted[i].predicted_jump = iq_issue_data[i].predicted_jump;
            assign iq_issue_data_converted[i].predicted_next_pc = iq_issue_data[i].predicted_next_pc;
            assign iq_issue_data_converted[i].checkpoint_id_valid = iq_issue_data[i].checkpoint_id_valid;
            assign iq_issue_data_converted[i].checkpoint_id = iq_issue_data[i].checkpoint_id;
            assign iq_issue_data_converted[i].rs1 = iq_issue_data[i].rs1;
            assign iq_issue_data_converted[i].arg1_src = iq_issue_data[i].arg1_src;
            assign iq_issue_data_converted[i].rs1_need_map = iq_issue_data[i].rs1_need_map;
            assign iq_issue_data_converted[i].rs1_phy = iq_issue_data[i].rs1_phy;
            assign iq_issue_data_converted[i].src1_value = iq_issue_data[i].src1_value;
            assign iq_issue_data_converted[i].src1_loaded = iq_issue_data[i].src1_loaded;
            assign iq_issue_data_converted[i].rs2 = iq_issue_data[i].rs2;
            assign iq_issue_data_converted[i].arg2_src = iq_issue_data[i].arg2_src;
            assign iq_issue_data_converted[i].rs2_need_map = iq_issue_data[i].rs2_need_map;
            assign iq_issue_data_converted[i].rs2_phy = iq_issue_data[i].rs2_phy;
            assign iq_issue_data_converted[i].src2_value = iq_issue_data[i].src2_value;
            assign iq_issue_data_converted[i].src2_loaded = iq_issue_data[i].src2_loaded;
            assign iq_issue_data_converted[i].rd = iq_issue_data[i].rd;
            assign iq_issue_data_converted[i].rd_enable = iq_issue_data[i].rd_enable;
            assign iq_issue_data_converted[i].need_rename = iq_issue_data[i].need_rename;
            assign iq_issue_data_converted[i].rd_phy = iq_issue_data[i].rd_phy;
            assign iq_issue_data_converted[i].csr = iq_issue_data[i].csr;
            assign iq_issue_data_converted[i].lsu_addr = iq_issue_data[i].src1_value + iq_issue_data[i].imm;
            assign iq_issue_data_converted[i].op = iq_issue_data[i].op;
            assign iq_issue_data_converted[i].op_unit = iq_issue_data[i].op_unit;
            assign iq_issue_data_converted[i].sub_op = iq_issue_data[i].sub_op;
        end
    endgenerate

    //--------------------------------------------------------------------input part-----------------------------------------------------------------------------
    //--------------------------------------------------------------------input part-----------------------------------------------------------------------------
    //--------------------------------------------------------------------input part-----------------------------------------------------------------------------
    //--------------------------------------------------------------------input part-----------------------------------------------------------------------------
    //generate issue_queue flush signal
    assign issue_iq_flush = commit_feedback_pack.enable && commit_feedback_pack.flush;

    generate
        for(i = 0;i < `READREG_WIDTH;i++) begin: issue_input
            //generate input port execute feedback information
            for(j = 0;j < `EXECUTE_UNIT_NUM;j++) begin
                assign input_phy_exefb_cmp[i][0][j] = execute_feedback_pack.channel[j].enable && (cur_op[i].rs1_phy == execute_feedback_pack.channel[j].phy_id);
                assign input_phy_exefb_cmp[i][1][j] = execute_feedback_pack.channel[j].enable && (cur_op[i].rs2_phy == execute_feedback_pack.channel[j].phy_id);
            end

            parallel_finder #(
                .WIDTH(`EXECUTE_UNIT_NUM)
            )parallel_finder_input_phy_exefb_0_inst(
                .data_in(input_phy_exefb_cmp[i][0]),
                .index(input_phy_exefb_index[i][0]),
                .index_valid(input_phy_exefb_index_valid[i][0])
            );

            parallel_finder #(
                .WIDTH(`EXECUTE_UNIT_NUM)
            )parallel_finder_input_phy_exefb_1_inst(
                .data_in(input_phy_exefb_cmp[i][1]),
                .index(input_phy_exefb_index[i][1]),
                .index_valid(input_phy_exefb_index_valid[i][1])
            );

            //generate input port wb feedback information
            for(j = 0;j < `WB_WIDTH;j++) begin
                assign input_phy_wbfb_cmp[i][0][j] = wb_feedback_pack.channel[j].enable && (cur_op[i].rs1_phy == wb_feedback_pack.channel[j].phy_id);
                assign input_phy_wbfb_cmp[i][1][j] = wb_feedback_pack.channel[j].enable && (cur_op[i].rs2_phy == wb_feedback_pack.channel[j].phy_id);
            end

            parallel_finder #(
                .WIDTH(`WB_WIDTH)
            )parallel_finder_input_phy_wbfb_0_inst(
                .data_in(input_phy_wbfb_cmp[i][0]),
                .index(input_phy_wbfb_index[i][0]),
                .index_valid(input_phy_wbfb_index_valid[i][0])
            );

            parallel_finder #(
                .WIDTH(`WB_WIDTH)
            )parallel_finder_input_phy_wbfb_1_inst(
                .data_in(input_phy_wbfb_cmp[i][1]),
                .index(input_phy_wbfb_index[i][1]),
                .index_valid(input_phy_wbfb_index_valid[i][1])
            );

            //generate input port data with phyfile/execute/wb feedback pack
            assign cur_op[i] = rev_pack.op_info[i];

            assign issue_phyf_id[i][0] = cur_op[i].rs1_phy;
            assign issue_phyf_id[i][1] = cur_op[i].rs2_phy;

            assign t_item[i].enable = cur_op[i].enable;
            assign t_item[i].value = cur_op[i].value;
            assign t_item[i].valid = cur_op[i].valid;
            assign t_item[i].rob_id = cur_op[i].rob_id;
            assign t_item[i].pc = cur_op[i].pc;
            assign t_item[i].imm = cur_op[i].imm;
            assign t_item[i].has_exception = cur_op[i].has_exception;
            assign t_item[i].exception_id = cur_op[i].exception_id;
            assign t_item[i].exception_value = cur_op[i].exception_value;

            assign t_item[i].predicted = cur_op[i].predicted;
            assign t_item[i].predicted_jump = cur_op[i].predicted_jump;
            assign t_item[i].predicted_next_pc = cur_op[i].predicted_next_pc;
            assign t_item[i].checkpoint_id_valid = cur_op[i].checkpoint_id_valid;
            assign t_item[i].checkpoint_id = cur_op[i].checkpoint_id;
        
            assign t_item[i].rs1 = cur_op[i].rs1;
            assign t_item[i].arg1_src = cur_op[i].arg1_src;
            assign t_item[i].rs1_need_map = cur_op[i].rs1_need_map;
            assign t_item[i].rs1_phy = cur_op[i].rs1_phy;
            assign t_item[i].src1_value = cur_op[i].src1_loaded ? cur_op[i].src1_value : 
                                          phyf_issue_data_valid[i][0] ? phyf_issue_data[i][0] : 
                                          input_phy_exefb_index_valid[i][0] ? execute_feedback_pack.channel[input_phy_exefb_index[i][0]] : 
                                          wb_feedback_pack.channel[input_phy_wbfb_index[i][0]];
            assign t_item[i].src1_loaded = cur_op[i].src1_loaded || phyf_issue_data_valid[i][0] || input_phy_exefb_index_valid[i][0] || input_phy_wbfb_index_valid[i][0];
        
            assign t_item[i].rs2 = cur_op[i].rs2;
            assign t_item[i].arg2_src = cur_op[i].arg2_src;
            assign t_item[i].rs2_need_map = cur_op[i].rs2_need_map;
            assign t_item[i].rs2_phy = cur_op[i].rs2_phy;
            assign t_item[i].src2_value = cur_op[i].src2_loaded ? cur_op[i].src2_value : 
                                          phyf_issue_data_valid[i][1] ? phyf_issue_data[i][1] : 
                                          input_phy_exefb_index_valid[i][1] ? execute_feedback_pack.channel[input_phy_exefb_index[i][1]] : 
                                          wb_feedback_pack.channel[input_phy_wbfb_index[i][1]];
            assign t_item[i].src2_loaded = cur_op[i].src2_loaded || phyf_issue_data_valid[i][1] || input_phy_exefb_index_valid[i][1] || input_phy_wbfb_index_valid[i][1];
        
            assign t_item[i].rd = cur_op[i].rd;
            assign t_item[i].rd_enable = cur_op[i].rd_enable;
            assign t_item[i].need_rename = cur_op[i].need_rename;
            assign t_item[i].rd_phy = cur_op[i].rd_phy;

            assign t_item[i].csr = cur_op[i].csr;
            assign t_item[i].op = cur_op[i].op;
            assign t_item[i].op_unit = cur_op[i].op_unit;
            assign t_item[i].sub_op = cur_op[i].sub_op;
        end
    endgenerate

    //prepare a empty pack
    assign t_item_empty.enable = 'b0;
    assign t_item_empty.value = 'b0;
    assign t_item_empty.valid = 'b0;
    assign t_item_empty.rob_id = 'b0;
    assign t_item_empty.pc = 'b0;
    assign t_item_empty.imm = 'b0;
    assign t_item_empty.has_exception = 'b0;
    assign t_item_empty.exception_id = riscv_exception_t::instruction_address_misaligned;
    assign t_item_empty.exception_value = 'b0;
    assign t_item_empty.predicted = 'b0;
    assign t_item_empty.predicted_jump = 'b0;
    assign t_item_empty.predicted_next_pc = 'b0;
    assign t_item_empty.checkpoint_id_valid = 'b0;
    assign t_item_empty.checkpoint_id = 'b0;
    assign t_item_empty.rs1 = 'b0;
    assign t_item_empty.arg1_src = arg_src_t::_disable;
    assign t_item_empty.rs1_need_map = 'b0;
    assign t_item_empty.rs1_phy = 'b0;
    assign t_item_empty.src1_value = 'b0;
    assign t_item_empty.src1_loaded = 'b0;
    assign t_item_empty.rs2 = 'b0;
    assign t_item_empty.arg2_src = arg_src_t::_disable;
    assign t_item_empty.rs2_need_map = 'b0;
    assign t_item_empty.rs2_phy = 'b0;
    assign t_item_empty.src2_value = 'b0;
    assign t_item_empty.src2_loaded = 'b0;
    assign t_item_empty.rd = 'b0;
    assign t_item_empty.rd_enable = 'b0;
    assign t_item_empty.need_rename = 'b0;
    assign t_item_empty.rd_phy = 'b0;
    assign t_item_empty.csr = 'b0;
    assign t_item_empty.op = op_t::add;
    assign t_item_empty.op_unit = op_unit_t::alu;
    assign t_item_empty.sub_op.raw_data = 'b0;

    //generate last_index signal to implement segmentalized items pushing
    always_ff @(posedge clk) begin
        if(rst) begin
            last_index <= 'b0;
        end
        else if(!busy) begin
            last_index <= 'b0;
        end
        else begin
            last_index <= last_index + input_push_num;
        end
    end

    //redirected result from last cycle
    generate
        for(i = 0;i < `READREG_WIDTH;i++) begin
            assign redirected_valid[i] = (i + last_index) < `READREG_WIDTH;
            assign t_item_redirected[i] = redirected_valid[i] ? t_item[i + last_index] : t_item_empty;
            assign redirected_pack_valid[i] = redirected_valid[i] && t_item_redirected[i].enable;
            assign issue_iq_data[i] = t_item_redirected[i];
        end
    endgenerate

    //generate busy signal: only when issue_queue isn't flushing and remain space of it isn't enough
    assign busy = !issue_iq_flush && ((redirected_pack_valid & iq_issue_data_channel_enable) != redirected_pack_valid);

    //count actual input push items
    count_one #(
        .CONTINUOUS(1),
        .WIDTH(`READREG_WIDTH)
    )count_one_input_push_num_inst(
        .data_in(redirected_pack_valid & iq_issue_data_channel_enable),
        .sum(input_push_num)
    );

    //generate push signals
    assign issue_iq_data_valid = redirected_pack_valid & iq_issue_data_channel_enable;
    assign issue_iq_push = 'b1;

    //generate feedback pack and pref reg add signals
    assign issue_feedback_pack.stall = busy;
    assign issue_csrf_issue_queue_full_add = busy;

    //--------------------------------------------------------------------output part----------------------------------------------------------------------------
    //--------------------------------------------------------------------output part----------------------------------------------------------------------------
    //--------------------------------------------------------------------output part----------------------------------------------------------------------------
    //--------------------------------------------------------------------output part----------------------------------------------------------------------------
    //count used execute unit
    for(i = 0;i < `ISSUE_WIDTH;i++) begin
        assign issue_has_alu_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::alu;
        assign issue_has_bru_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::bru;
        assign issue_has_csr_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::csr;
        assign issue_has_div_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::div;
        assign issue_has_lsu_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::lsu;
        assign issue_has_mul_op_cmp[i] = iq_issue_data_valid[i] && iq_issue_data[i].op_unit == op_unit_t::mul;
    end

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_alu_op_num_inst(
        .data_in(issue_has_alu_op_cmp),
        .sum(issue_alu_op_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_bru_op_num_inst(
        .data_in(issue_has_bru_op_cmp),
        .sum(issue_bru_op_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_csr_op_num_inst(
        .data_in(issue_has_csr_op_cmp),
        .sum(issue_csr_op_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_div_op_num_inst(
        .data_in(issue_has_div_op_cmp),
        .sum(issue_div_op_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_lsu_op_num_inst(
        .data_in(issue_has_lsu_op_cmp),
        .sum(issue_lsu_op_num)
    );

    count_one #(
        .CONTINUOUS(0),
        .WIDTH(`ISSUE_WIDTH)
    )count_one_issue_mul_op_num_inst(
        .data_in(issue_has_mul_op_cmp),
        .sum(issue_mul_op_num)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`ALU_UNIT_NUM)
    )list_enabled_item_id_alu_inst(
        .seq(~issue_alu_fifo_full),
        .start_pos(alu_index),
        .enabled_item_id(available_alu_index)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`BRU_UNIT_NUM)
    )list_enabled_item_id_bru_inst(
        .seq(~issue_bru_fifo_full),
        .start_pos(bru_index),
        .enabled_item_id(available_bru_index)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`CSR_UNIT_NUM)
    )list_enabled_item_id_csr_inst(
        .seq(~issue_csr_fifo_full),
        .start_pos(csr_index),
        .enabled_item_id(available_csr_index)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`DIV_UNIT_NUM)
    )list_enabled_item_id_div_inst(
        .seq(~issue_div_fifo_full),
        .start_pos(div_index),
        .enabled_item_id(available_div_index)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`LSU_UNIT_NUM)
    )list_enabled_item_id_lsu_inst(
        .seq(~issue_lsu_fifo_full),
        .start_pos(lsu_index),
        .enabled_item_id(available_lsu_index)
    );

    list_enabled_item_id #(
        .ITEM_NUM(`MUL_UNIT_NUM)
    )list_enabled_item_id_mul_inst(
        .seq(~issue_mul_fifo_full),
        .start_pos(mul_index),
        .enabled_item_id(available_mul_index)
    );

    //use round-robin algorithm to update next execute unit index
    always_ff @(posedge clk) begin
        if(rst) begin
            alu_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_alu_op_num != 'b0)) begin
            alu_index <= (available_alu_index[`max($clog2($size(available_alu_index)), 1)'(issue_alu_op_num - 1)] + 'b1) & (`ALU_UNIT_NUM - 1);
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            bru_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_bru_op_num != 'b0)) begin
            bru_index <= (available_bru_index[`max($clog2($size(available_bru_index)), 1)'(issue_bru_op_num - 1)] + 'b1) & (`BRU_UNIT_NUM - 1);
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            csr_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_csr_op_num != 'b0)) begin
            csr_index <= (available_csr_index[`max($clog2($size(available_csr_index)), 1)'(issue_csr_op_num - 1)] + 'b1) & (`CSR_UNIT_NUM - 1);
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            div_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_div_op_num != 'b0)) begin
            div_index <= (available_div_index[`max($clog2($size(available_div_index)), 1)'(issue_div_op_num - 1)] + 'b1) & (`DIV_UNIT_NUM - 1);
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            lsu_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_lsu_op_num != 'b0)) begin
            lsu_index <= (available_lsu_index[`max($clog2($size(available_lsu_index)), 1)'(issue_lsu_op_num - 1)] + 'b1) & (`LSU_UNIT_NUM - 1);
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            mul_index <= 'b0;
        end
        else if(!issue_iq_flush && (issue_mul_op_num != 'b0)) begin
            mul_index <= (available_mul_index[`max($clog2($size(available_mul_index)), 1)'(issue_mul_op_num - 1)] + 'b1) & (`MUL_UNIT_NUM - 1);
        end
    end

    //use round-robin algorithm to assign execute unit for every instruction from issue queue output port
    generate
        for(i = 0;i < `ISSUE_WIDTH;i++) begin
            if(i == 0) begin
                assign send_alu_index[i] = 'b0;
                assign send_bru_index[i] = 'b0;
                assign send_csr_index[i] = 'b0;
                assign send_div_index[i] = 'b0;
                assign send_lsu_index[i] = 'b0;
                assign send_mul_index[i] = 'b0;
            end
            else begin
                assign send_alu_index[i] = send_alu_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::alu)) ? 'b1 : 'b0);
                assign send_bru_index[i] = send_bru_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::bru)) ? 'b1 : 'b0);
                assign send_csr_index[i] = send_csr_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::csr)) ? 'b1 : 'b0);
                assign send_div_index[i] = send_div_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::div)) ? 'b1 : 'b0);
                assign send_lsu_index[i] = send_lsu_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::lsu)) ? 'b1 : 'b0);
                assign send_mul_index[i] = send_mul_index[i - 1] + ((iq_issue_data_valid[i - 1] && (iq_issue_data[i - 1].op_unit == op_unit_t::mul)) ? 'b1 : 'b0);
            end
        end
    endgenerate

    //redirect every instruction to corresponding execute unit input port
    generate
        for(i = 0;i < `ALU_UNIT_NUM;i++) begin: alu_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign alu_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::alu) && (available_alu_index[send_alu_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_alu_send_inst_inst(
                .data_in(alu_send_inst_cmp[i]),
                .index(alu_send_inst_index[i]),
                .index_valid(alu_send_inst_index_valid[i])
            );

            assign issue_alu_fifo_data_in[i] = iq_issue_data_converted[alu_send_inst_index[i]];
            assign issue_alu_fifo_push[i] = alu_send_inst_index_valid[i];
            assign issue_alu_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    generate
        for(i = 0;i < `BRU_UNIT_NUM;i++) begin: bru_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign bru_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::bru) && (available_bru_index[send_bru_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_bru_send_inst_inst(
                .data_in(bru_send_inst_cmp[i]),
                .index(bru_send_inst_index[i]),
                .index_valid(bru_send_inst_index_valid[i])
            );

            assign issue_bru_fifo_data_in[i] = iq_issue_data_converted[bru_send_inst_index[i]];
            assign issue_bru_fifo_push[i] = bru_send_inst_index_valid[i];
            assign issue_bru_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    generate
        for(i = 0;i < `CSR_UNIT_NUM;i++) begin: csr_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign csr_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::csr) && (available_csr_index[send_csr_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_csr_send_inst_inst(
                .data_in(csr_send_inst_cmp[i]),
                .index(csr_send_inst_index[i]),
                .index_valid(csr_send_inst_index_valid[i])
            );

            assign issue_csr_fifo_data_in[i] = iq_issue_data_converted[csr_send_inst_index[i]];
            assign issue_csr_fifo_push[i] = csr_send_inst_index_valid[i];
            assign issue_csr_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    generate
        for(i = 0;i < `DIV_UNIT_NUM;i++) begin: div_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign div_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::div) && (available_div_index[send_div_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_div_send_inst_inst(
                .data_in(div_send_inst_cmp[i]),
                .index(div_send_inst_index[i]),
                .index_valid(div_send_inst_index_valid[i])
            );

            assign issue_div_fifo_data_in[i] = iq_issue_data_converted[div_send_inst_index[i]];
            assign issue_div_fifo_push[i] = div_send_inst_index_valid[i];
            assign issue_div_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    generate
        for(i = 0;i < `LSU_UNIT_NUM;i++) begin: lsu_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign lsu_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::lsu) && (available_lsu_index[send_lsu_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_lsu_send_inst_inst(
                .data_in(lsu_send_inst_cmp[i]),
                .index(lsu_send_inst_index[i]),
                .index_valid(lsu_send_inst_index_valid[i])
            );

            assign issue_lsu_fifo_data_in[i] = iq_issue_data_converted[lsu_send_inst_index[i]];
            assign issue_lsu_fifo_push[i] = lsu_send_inst_index_valid[i];
            assign issue_lsu_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    generate
        for(i = 0;i < `MUL_UNIT_NUM;i++) begin: mul_send_inst_generate
            for(j = 0;j < `ISSUE_WIDTH;j++) begin
                assign mul_send_inst_cmp[i][j] = iq_issue_data_valid[j] && (iq_issue_data[j].op_unit == op_unit_t::mul) && (available_mul_index[send_mul_index[j]] == i);
            end

            parallel_finder #(
                .WIDTH(`ISSUE_WIDTH)
            )parallel_finder_mul_send_inst_inst(
                .data_in(mul_send_inst_cmp[i]),
                .index(mul_send_inst_index[i]),
                .index_valid(mul_send_inst_index_valid[i])
            );

            assign issue_mul_fifo_data_in[i] = iq_issue_data_converted[mul_send_inst_index[i]];
            assign issue_mul_fifo_push[i] = mul_send_inst_index_valid[i];
            assign issue_mul_fifo_flush[i] = issue_iq_flush;
        end
    endgenerate

    //AGU -- preload load addr
    assign issue_stbuf_read_addr = issue_lsu_fifo_data_in[0].lsu_addr;
    
    always_comb begin
        case(issue_lsu_fifo_data_in[0].sub_op.lsu_op)
            lsu_op_t::lb, lsu_op_t::lbu: begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 1);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 1) ? 
                                   riscv_exception_t::load_address_misaligned : 
                                   riscv_exception_t::load_access_fault;
                issue_stbuf_read_size = 'd1;
                issue_stbuf_rd = issue_lsu_fifo_push[0] && !issue_lsu_fifo_flush[0] && !lsu_has_exception;
            end

            lsu_op_t::lh, lsu_op_t::lhu: begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 2);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 2) ? 
                                   riscv_exception_t::load_address_misaligned : 
                                   riscv_exception_t::load_access_fault;
                issue_stbuf_read_size = 'd2;
                issue_stbuf_rd = issue_lsu_fifo_push[0] && !issue_lsu_fifo_flush[0] && !lsu_has_exception;
            end

            lsu_op_t::lw: begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 4);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 4) ? 
                                   riscv_exception_t::load_address_misaligned : 
                                   riscv_exception_t::load_access_fault;
                issue_stbuf_read_size = 'd4;
                issue_stbuf_rd = issue_lsu_fifo_push[0] && !issue_lsu_fifo_flush[0] && !lsu_has_exception;
            end

            lsu_op_t::sb:  begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 1);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 1) ? 
                                   riscv_exception_t::store_amo_address_misaligned : 
                                   riscv_exception_t::store_amo_access_fault;
                issue_stbuf_read_size = 'd0;
                issue_stbuf_rd = 'b0;
            end

            lsu_op_t::sh: begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 2);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 2) ? 
                                   riscv_exception_t::store_amo_address_misaligned : 
                                   riscv_exception_t::store_amo_access_fault;
                issue_stbuf_read_size = 'd0;
                issue_stbuf_rd = 'b0;
            end

            lsu_op_t::sw: begin
                lsu_has_exception = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 4);
                lsu_exception_id = !check_align(issue_lsu_fifo_data_in[0].lsu_addr, 4) ? 
                                   riscv_exception_t::store_amo_address_misaligned : 
                                   riscv_exception_t::store_amo_access_fault;
                issue_stbuf_read_size = 'd0;
                issue_stbuf_rd = 'b0;
            end

            default: begin
                lsu_has_exception = 'b0;
                lsu_exception_id = riscv_exception_t::load_access_fault;
                issue_stbuf_read_size = 'd0;
                issue_stbuf_rd = 'b0;
            end
        endcase
    end
endmodule