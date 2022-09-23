`include "config.svh"
`include "common.svh"

module fetch(
        input logic clk,
        input logic rst,
        
        output logic[`ADDR_WIDTH - 1:0] fetch_bp_update_pc,
        output logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_update_instruction,
        output logic fetch_bp_update_jump,
        output logic[`ADDR_WIDTH - 1:0] fetch_bp_update_next_pc,
        output logic fetch_bp_update_valid,
        
        output logic[`ADDR_WIDTH -1:0] fetch_bp_pc,
        output logic[`INSTRUCTION_WIDTH - 1:0] fetch_bp_instruction,
        output logic fetch_bp_valid,
        input logic bp_fetch_jump,
        input logic[`ADDR_WIDTH - 1:0] bp_fetch_next_pc,
        input logic bp_fetch_valid,
        input logic[`GSHARE_GLOBAL_HISTORY_WIDTH - 1:0] bp_fetch_global_history,
        input logic[`LOCAL_BHT_WIDTH - 1:0] bp_fetch_local_history, 
        
        output logic[`ADDR_WIDTH - 1:0] fetch_bus_addr,
        output logic fetch_bus_read_req,
        input logic[`INSTRUCTION_WIDTH * `FETCH_WIDTH - 1:0] bus_fetch_data,
        input logic bus_fetch_read_ack,
        
        output logic fetch_csrf_checkpoint_buffer_full_add,
        output logic fetch_csrf_fetch_not_full_add,
        output logic fetch_csrf_fetch_decode_fifo_full_add,
        
        input logic[`CHECKPOINT_ID_WIDTH - 1:0] cpbuf_fetch_new_id,
        input logic cpbuf_fetch_new_id_valid,
        output checkpoint_t fetch_cpbuf_data,
        output logic fetch_cpbuf_push,
        
        input logic stbuf_all_empty,
        
        input logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_enable,
        output fetch_decode_pack_t fetch_decode_fifo_data_in[0:`FETCH_WIDTH - 1],
        output logic[`FETCH_WIDTH - 1:0] fetch_decode_fifo_data_in_valid,
        output logic fetch_decode_fifo_push,
        output logic fetch_decode_fifo_flush,
        
        input decode_feedback_pack_t decode_feedback_pack,
        input rename_feedback_pack_t rename_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );

    logic[`ADDR_WIDTH - 1:0] pc;
    logic jump_wait;
    logic jump_wait_next;

    logic[`ADDR_WIDTH - 1:0] pc_next;

    fetch_decode_pack_t t_fetch_decode_pack[0:`FETCH_WIDTH - 1];
    logic[`ADDR_WIDTH - 1:0] cur_pc[0:`FETCH_WIDTH - 1];
    logic[`FETCH_WIDTH - 1:0] has_exception;
    logic[`INSTRUCTION_WIDTH - 1:0] opcode[0:`FETCH_WIDTH - 1];
    logic[`FETCH_WIDTH - 1:0] jump;
    logic[`FETCH_WIDTH - 1:0] fence_i;
    logic[`FETCH_WIDTH - 1:0] push_forbidden_fence_i;
    logic[`FETCH_WIDTH - 1:0] push_forbidden_jump;
    logic[`FETCH_WIDTH - 1:0] enable;
    logic[`FETCH_WIDTH - 1:0] should_send_inst;

    logic[$clog2(`FETCH_WIDTH) - 1:0] jump_index;
    logic jump_index_valid;

    logic[$clog2(`FETCH_WIDTH) - 1:0] enable_index;
    logic enable_index_valid;

    genvar i;

    assign fetch_decode_fifo_flush = commit_feedback_pack.enable & commit_feedback_pack.flush;

    always_ff @(posedge clk) begin
        if(rst) begin
            pc <= unsigned'(`INIT_PC);
        end
        else begin
            pc <= pc_next;
        end
    end

    always_ff @(posedge clk) begin
        if(rst) begin
            jump_wait <= 'b0;
        end
        else begin
            jump_wait <= jump_wait_next;
        end
    end

    generate
        assign push_forbidden_fence_i[0] = fence_i[0] && ((!decode_feedback_pack.idle) || (!rename_feedback_pack.idle) || commit_feedback_pack.enable || (!stbuf_all_empty));
        assign push_forbidden_jump[0] = 'b0;

        for(i = 1;i < `FETCH_WIDTH;i++) begin
            assign push_forbidden_fence_i[i] = push_forbidden_fence_i[i - 1] || fence_i[i];
            assign push_forbidden_jump[i] = jump[i - 1] || push_forbidden_jump[i - 1];
        end

        for(i = 0;i < `FETCH_WIDTH;i++) begin
            assign cur_pc[i] = pc + (i << 2);
            assign has_exception[i] = !check_align(cur_pc[i], 4);
            assign opcode[i] = has_exception[i] ? 'b0 : bus_fetch_data[`INSTRUCTION_WIDTH * i +: `INSTRUCTION_WIDTH];
            assign jump[i] = (((opcode[i] & 'h7f) == 'h6f) || ((opcode[i] & 'h7f) == 'h67) || ((opcode[i] & 'h7f) == 'h63) || (opcode[i] == 'h30200073)) && bus_fetch_read_ack;
            assign fence_i[i] = ((opcode[i] & 'h7f) == 'h0f) && (((opcode[i] >> 12) & 'h07) == 'h01) && bus_fetch_read_ack;
            assign enable[i] = fetch_decode_fifo_data_in_enable[i] & !push_forbidden_fence_i[i] & !push_forbidden_jump[i] & bus_fetch_read_ack;
            assign should_send_inst[i] = !push_forbidden_fence_i[i] & !push_forbidden_jump[i] & bus_fetch_read_ack;
            assign fetch_decode_fifo_data_in_valid[i] = enable[i];
            assign t_fetch_decode_pack[i].enable = enable[i];
            assign t_fetch_decode_pack[i].value = opcode[i];
            assign t_fetch_decode_pack[i].pc = cur_pc[i];
            assign t_fetch_decode_pack[i].has_exception = has_exception[i];
            assign t_fetch_decode_pack[i].exception_id = riscv_exception_t::instruction_address_misaligned;
            assign t_fetch_decode_pack[i].exception_value = cur_pc[i];
            assign t_fetch_decode_pack[i].predicted = (jump_index == i) && jump_index_valid && bp_fetch_valid && cpbuf_fetch_new_id_valid;
            assign t_fetch_decode_pack[i].predicted_jump = bp_fetch_jump;
            assign t_fetch_decode_pack[i].predicted_next_pc = bp_fetch_jump ? bp_fetch_next_pc : (cur_pc[i] + 'd4);
            assign t_fetch_decode_pack[i].checkpoint_id_valid = t_fetch_decode_pack[i].predicted;
            assign t_fetch_decode_pack[i].checkpoint_id = cpbuf_fetch_new_id;
            assign fetch_decode_fifo_data_in[i] = t_fetch_decode_pack[i];
        end
    endgenerate

    assign jump_wait_next = (commit_feedback_pack.enable && commit_feedback_pack.flush) ? 1'b0 : 
                            jump_wait ? !commit_feedback_pack.jump_enable : 
                            !bus_fetch_read_ack ? jump_wait : (jump_index_valid && !(bp_fetch_valid && cpbuf_fetch_new_id_valid));
    
    always_comb begin
        if(commit_feedback_pack.enable && commit_feedback_pack.flush) begin
            if(commit_feedback_pack.has_exception) begin
                pc_next = commit_feedback_pack.exception_pc;
            end
            else if(commit_feedback_pack.jump_enable) begin
                pc_next = commit_feedback_pack.next_pc;
            end
            else begin
                pc_next = pc;
            end
        end
        else if(jump_wait) begin
            if(commit_feedback_pack.jump_enable && commit_feedback_pack.jump) begin
                pc_next = commit_feedback_pack.next_pc;
            end
            else begin
                pc_next = pc;
            end
        end
        else begin
            if(jump_index_valid) begin
                if(bp_fetch_valid) begin
                    if(!cpbuf_fetch_new_id_valid) begin
                        pc_next = cur_pc[jump_index] + 'd4;
                    end
                    else begin
                        pc_next = bp_fetch_jump ? bp_fetch_next_pc : (cur_pc[jump_index] + 'd4);
                    end
                end
                else begin
                    pc_next = cur_pc[jump_index] + 'd4;
                end
            end
            else if(enable_index_valid) begin
                pc_next = cur_pc[enable_index] + 'd4;
            end
            else begin
                pc_next = pc;
            end
        end
    end

    priority_finder #(
        .FIRST_PRIORITY(1),
        .WIDTH(`FETCH_WIDTH)
    )priority_finder_jump_inst(
        .data_in({`FETCH_WIDTH{bus_fetch_read_ack}} & jump & enable),
        .index(jump_index),
        .index_valid(jump_index_valid)
    );

    priority_finder #(
        .FIRST_PRIORITY(0),
        .WIDTH(`FETCH_WIDTH)
    )priority_finder_enable_inst(
        .data_in({`FETCH_WIDTH{bus_fetch_read_ack}} & enable),
        .index(enable_index),
        .index_valid(enable_index_valid)
    );

    assign fetch_bp_pc = cur_pc[jump_index];
    assign fetch_bp_instruction = opcode[jump_index];
    assign fetch_bp_valid = fetch_decode_fifo_push && jump_index_valid && enable[jump_index];
    assign fetch_bp_update_pc = cur_pc[jump_index];
    assign fetch_bp_update_instruction = opcode[jump_index];
    assign fetch_bp_update_jump = bp_fetch_jump;
    assign fetch_bp_update_next_pc = bp_fetch_next_pc;
    assign fetch_bp_update_valid = bp_fetch_valid & jump_index_valid;

    assign fetch_bus_addr = pc_next;
    assign fetch_bus_read_req = !jump_wait_next;

    assign fetch_decode_fifo_push = bus_fetch_read_ack && !jump_wait && !fetch_decode_fifo_flush;

    assign fetch_cpbuf_data.global_history = bp_fetch_global_history;
    assign fetch_cpbuf_data.local_history = bp_fetch_local_history;
    assign fetch_cpbuf_data.rat_phy_map_table_valid = 'b0;
    assign fetch_cpbuf_data.rat_phy_map_table_visible = 'b0;
    assign fetch_cpbuf_push = jump_index_valid & bp_fetch_valid && fetch_decode_fifo_push;

    assign fetch_csrf_checkpoint_buffer_full_add = fetch_decode_fifo_push && jump_index_valid && bp_fetch_valid && !cpbuf_fetch_new_id_valid;
    assign fetch_csrf_fetch_not_full_add = fetch_decode_fifo_push && jump_index_valid;
    assign fetch_csrf_fetch_decode_fifo_full_add = fetch_decode_fifo_push && !jump_index_valid && ((fetch_decode_fifo_data_in_enable & should_send_inst) != should_send_inst);
endmodule