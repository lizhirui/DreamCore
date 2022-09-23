`timescale 1ns/100ps
`include "tdb_reader.svh"
`include "config.svh"
`include "common.svh"

import tdb_reader::*;

import "DPI-C" function string getenv(input string env_name);

`define assert(condition) assert((condition)) else begin #10; $finish; end
`define assert_cycle(_cycle, condition) assert((condition)) else begin $display("cycle = %0d", (_cycle)); #10; $finish; end
`define assert_equal(_cycle, _expected, _actual) assert((_expected) == (_actual)) else begin $display("cycle = %0d, expected = %0x, actual = %0x", (_cycle), (_expected), (_actual)); assert_fail = 1; end

module top;
    tdb_reader tdb_fetch;
    tdb_reader tdb_decode;
    tdb_reader tdb_rename;
    tdb_reader tdb_readreg;
    tdb_reader tdb_issue;
    tdb_reader tdb_execute_alu[0:`ALU_UNIT_NUM - 1];
    tdb_reader tdb_execute_bru[0:`BRU_UNIT_NUM - 1];
    tdb_reader tdb_execute_csr[0:`CSR_UNIT_NUM - 1];
    tdb_reader tdb_execute_div[0:`DIV_UNIT_NUM - 1];
    tdb_reader tdb_execute_lsu[0:`LSU_UNIT_NUM - 1];
    tdb_reader tdb_execute_mul[0:`MUL_UNIT_NUM - 1];
    tdb_reader tdb_wb;
    tdb_reader tdb_commit;
    tdb_reader tdb_branch_predictor;
    tdb_reader tdb_bus;
    tdb_reader tdb_checkpoint_buffer;
    tdb_reader tdb_clint;
    tdb_reader tdb_csrfile;
    tdb_reader tdb_interrupt_interface;
    tdb_reader tdb_phy_regfile;
    tdb_reader tdb_ras;
    tdb_reader tdb_rat;
    tdb_reader tdb_rob;
    tdb_reader tdb_store_buffer;
    tdb_reader tdb_tcm;

    logic clk;
    logic rst;

    logic int_ext;
    logic rxd;
    logic txd;
    
    integer i, j;
    integer unsigned temp;
    string str;
    longint cur_cycle;
    logic result;
    logic assert_fail;
    logic[`ADDR_WIDTH - 1:0] bus_last_fetch_bus_addr;
    logic bus_last_fetch_bus_read_req;
    logic[`ADDR_WIDTH - 1:0] bus_last_stbuf_bus_read_addr;
    logic[`SIZE_WIDTH - 1:0] bus_last_stbuf_bus_read_size;
    logic bus_last_stbuf_bus_read_req;

    core_top #(
        .IMAGE_PATH(`SIM_IMAGE_NAME),
        .IMAGE_INIT(1)
    )core_top_inst(
        .*
    );
    
    task wait_clk;
        @(posedge clk);
        #0.1;
    endtask

    task eval;
        #0.1;
    endtask

    task all_tdb_move_to_next_row(output logic result);
        result = 1;

        tdb_fetch.move_to_next_row();
        tdb_decode.move_to_next_row();
        tdb_rename.move_to_next_row();
        tdb_readreg.move_to_next_row();
        tdb_issue.move_to_next_row();

        for (i = 0; i < `ALU_UNIT_NUM; i = i + 1) begin
            tdb_execute_alu[i].move_to_next_row();
        end

        for (i = 0; i < `BRU_UNIT_NUM; i = i + 1) begin
            tdb_execute_bru[i].move_to_next_row();
        end

        for (i = 0; i < `CSR_UNIT_NUM; i = i + 1) begin
            tdb_execute_csr[i].move_to_next_row();
        end

        for (i = 0; i < `DIV_UNIT_NUM; i = i + 1) begin
            tdb_execute_div[i].move_to_next_row();
        end

        for (i = 0; i < `LSU_UNIT_NUM; i = i + 1) begin
            tdb_execute_lsu[i].move_to_next_row();
        end

        for (i = 0; i < `MUL_UNIT_NUM; i = i + 1) begin
            tdb_execute_mul[i].move_to_next_row();
        end

        tdb_wb.move_to_next_row();
        tdb_commit.move_to_next_row();
        tdb_branch_predictor.move_to_next_row();
        tdb_bus.move_to_next_row();
        tdb_checkpoint_buffer.move_to_next_row();
        tdb_clint.move_to_next_row();
        tdb_csrfile.move_to_next_row();
        tdb_interrupt_interface.move_to_next_row();
        tdb_phy_regfile.move_to_next_row();
        tdb_ras.move_to_next_row();
        tdb_rat.move_to_next_row();
        tdb_rob.move_to_next_row();
        tdb_store_buffer.move_to_next_row();
        tdb_tcm.move_to_next_row();

        if(!tdb_fetch.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_decode.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_rename.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_readreg.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_issue.read_cur_row()) begin
            result = 0;
        end

        for (i = 0; i < `ALU_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_alu[i].read_cur_row()) begin
                result = 0;
            end
        end

        for (i = 0; i < `BRU_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_bru[i].read_cur_row()) begin
                result = 0;
            end
        end

        for (i = 0; i < `CSR_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_csr[i].read_cur_row()) begin
                result = 0;
            end
        end

        for (i = 0; i < `DIV_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_div[i].read_cur_row()) begin
                result = 0;
            end
        end

        for (i = 0; i < `LSU_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_lsu[i].read_cur_row()) begin
                result = 0;
            end
        end

        for (i = 0; i < `MUL_UNIT_NUM; i = i + 1) begin
            if(!tdb_execute_mul[i].read_cur_row()) begin
                result = 0;
            end
        end

        if(!tdb_wb.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_commit.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_branch_predictor.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_bus.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_checkpoint_buffer.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_clint.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_csrfile.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_interrupt_interface.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_phy_regfile.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_ras.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_rat.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_rob.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_store_buffer.read_cur_row()) begin
            result = 0;
        end

        if(!tdb_tcm.read_cur_row()) begin
            result = 0;
        end
    endtask

    task test;
        assert_fail = 0;
        bus_last_fetch_bus_addr = 0;
        bus_last_fetch_bus_read_req = 0;
        bus_last_stbuf_bus_read_addr = 0;
        bus_last_stbuf_bus_read_size = 0;
        bus_last_stbuf_bus_read_req = 0;
        rst = 1;
        int_ext = 0;
        rxd = 1;
        wait_clk();
        rst = 0;
        `assert(tdb_fetch.read_cur_row())
        `assert(tdb_decode.read_cur_row())
        `assert(tdb_rename.read_cur_row())
        `assert(tdb_readreg.read_cur_row())
        `assert(tdb_issue.read_cur_row())

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            `assert(tdb_execute_alu[i].read_cur_row())
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            `assert(tdb_execute_bru[i].read_cur_row())
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            `assert(tdb_execute_csr[i].read_cur_row())
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            `assert(tdb_execute_div[i].read_cur_row())
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            `assert(tdb_execute_lsu[i].read_cur_row())
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            `assert(tdb_execute_mul[i].read_cur_row())
        end

        `assert(tdb_wb.read_cur_row())
        `assert(tdb_commit.read_cur_row())
        `assert(tdb_branch_predictor.read_cur_row())
        `assert(tdb_bus.read_cur_row())
        `assert(tdb_checkpoint_buffer.read_cur_row())
        `assert(tdb_clint.read_cur_row())
        `assert(tdb_csrfile.read_cur_row())
        `assert(tdb_interrupt_interface.read_cur_row())
        `assert(tdb_phy_regfile.read_cur_row())
        `assert(tdb_ras.read_cur_row())
        `assert(tdb_rat.read_cur_row())
        `assert(tdb_rob.read_cur_row())
        `assert(tdb_store_buffer.read_cur_row())
        `assert(tdb_tcm.read_cur_row())

        cur_cycle = tdb_fetch.get_cur_row();

        while(1) begin
            `assert_equal(cur_cycle, tdb_fetch.get_uint32(DOMAIN_STATUS, "pc", 0), core_top_inst.fetch_inst.pc)
            `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_STATUS, "jump_wait", 0), core_top_inst.fetch_inst.jump_wait)
            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_STATUS, "gshare_global_history", 0), core_top_inst.branch_predictor_inst.gshare_global_history)
            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_STATUS, "gshare_global_history_retired", 0), core_top_inst.branch_predictor_inst.gshare_global_history_retired)
            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_STATUS, "call_global_history", 0), core_top_inst.branch_predictor_inst.call_global_history)
            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_STATUS, "normal_global_history", 0), core_top_inst.branch_predictor_inst.normal_global_history)

            if(assert_fail) begin
                #10; $finish; 
            end

            all_tdb_move_to_next_row(result);
            cur_cycle = tdb_fetch.get_cur_row();

            if(!result) begin
                break;
            end

            //branch predictor
            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "fetch_bp_valid", 0), core_top_inst.branch_predictor_inst.fetch_bp_valid)

            if(core_top_inst.branch_predictor_inst.fetch_bp_valid) begin
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "fetch_bp_pc", 0), core_top_inst.branch_predictor_inst.fetch_bp_pc)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "fetch_bp_instruction", 0), core_top_inst.branch_predictor_inst.fetch_bp_instruction)
            end

            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "fetch_bp_update_valid", 0), core_top_inst.branch_predictor_inst.fetch_bp_update_valid)

            if(core_top_inst.branch_predictor_inst.fetch_bp_update_valid) begin
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "fetch_bp_update_pc", 0), core_top_inst.branch_predictor_inst.fetch_bp_update_pc)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "fetch_bp_update_instruction", 0), core_top_inst.branch_predictor_inst.fetch_bp_update_instruction)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "fetch_bp_update_jump", 0), core_top_inst.branch_predictor_inst.fetch_bp_update_jump)

                if(core_top_inst.branch_predictor_inst.fetch_bp_update_jump) begin
                    `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "fetch_bp_update_next_pc", 0), core_top_inst.branch_predictor_inst.fetch_bp_update_next_pc)
                end
            end

            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "exbru_bp_valid", 0), core_top_inst.branch_predictor_inst.exbru_bp_valid)

            if(core_top_inst.branch_predictor_inst.exbru_bp_valid) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_branch_predictor, DOMAIN_INPUT, "exbru_bp_cp.rat_phy_map_table_valid", 0), core_top_inst.branch_predictor_inst.exbru_bp_cp.rat_phy_map_table_valid)
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_branch_predictor, DOMAIN_INPUT, "exbru_bp_cp.rat_phy_map_table_visible", 0), core_top_inst.branch_predictor_inst.exbru_bp_cp.rat_phy_map_table_visible)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_INPUT, "exbru_bp_cp.global_history", 0), core_top_inst.branch_predictor_inst.exbru_bp_cp.global_history)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint16(DOMAIN_INPUT, "exbru_bp_cp.local_history", 0), core_top_inst.branch_predictor_inst.exbru_bp_cp.local_history)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "exbru_bp_pc", 0), core_top_inst.branch_predictor_inst.exbru_bp_pc)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "exbru_bp_instruction", 0), core_top_inst.branch_predictor_inst.exbru_bp_instruction)
                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "exbru_bp_jump", 0), core_top_inst.branch_predictor_inst.exbru_bp_jump)

                if(core_top_inst.branch_predictor_inst.exbru_bp_jump) begin
                    `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "exbru_bp_next_pc", 0), core_top_inst.branch_predictor_inst.exbru_bp_next_pc)
                end

                `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "exbru_bp_hit", 0), core_top_inst.branch_predictor_inst.exbru_bp_hit)
            end

            `assert_equal(cur_cycle, tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "commit_bp_valid", 0), core_top_inst.branch_predictor_inst.commit_bp_valid)
            
            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(core_top_inst.branch_predictor_inst.commit_bp_valid & (1 << i)) begin
                    `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "commit_bp_pc", i), core_top_inst.branch_predictor_inst.commit_bp_pc[i])
                    `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "commit_bp_instruction", i), core_top_inst.branch_predictor_inst.commit_bp_instruction[i])
                    `assert_equal(cur_cycle, (tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "commit_bp_jump", 0) >> i) & 1, core_top_inst.branch_predictor_inst.commit_bp_jump[i])

                    if(core_top_inst.branch_predictor_inst.commit_bp_jump[i]) begin
                        `assert_equal(cur_cycle, tdb_branch_predictor.get_uint32(DOMAIN_INPUT, "commit_bp_next_pc", i), core_top_inst.branch_predictor_inst.commit_bp_next_pc[i])
                    end

                    `assert_equal(cur_cycle, (tdb_branch_predictor.get_uint8(DOMAIN_INPUT, "commit_bp_hit", 0) >> i) & 1, core_top_inst.branch_predictor_inst.commit_bp_hit[i])
                end
            end

            //bus
            if(!tdb_commit.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.enable", 0) || !tdb_commit.get_uint8(DOMAIN_OUTPUT, "commit_feedback_pack.flush", 0)) begin
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_INPUT, "fetch_bus_read_req_cur", 0), bus_last_fetch_bus_read_req)

                if(bus_last_fetch_bus_read_req) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "fetch_bus_addr_cur", 0), bus_last_fetch_bus_addr)
                end

                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_req_cur", 0), bus_last_stbuf_bus_read_req)

                if(bus_last_stbuf_bus_read_req) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "stbuf_bus_read_addr_cur", 0), bus_last_stbuf_bus_read_addr)
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0), bus_last_stbuf_bus_read_size)
                end

                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_write_req", 0), core_top_inst.bus_inst.stbuf_bus_write_req)

                if(core_top_inst.bus_inst.stbuf_bus_write_req) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "stbuf_bus_write_addr", 0), core_top_inst.bus_inst.stbuf_bus_write_addr)
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_write_size", 0), core_top_inst.bus_inst.stbuf_bus_write_size)
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "stbuf_bus_data", 0), core_top_inst.bus_inst.stbuf_bus_data)
                end
            end

            bus_last_fetch_bus_addr = core_top_inst.bus_inst.fetch_bus_addr;
            bus_last_fetch_bus_read_req = core_top_inst.bus_inst.fetch_bus_read_req;
            bus_last_stbuf_bus_read_addr = core_top_inst.bus_inst.stbuf_bus_read_addr;
            bus_last_stbuf_bus_read_size = core_top_inst.bus_inst.stbuf_bus_read_size;
            bus_last_stbuf_bus_read_req = core_top_inst.bus_inst.stbuf_bus_read_req;

            if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_fetch_read_ack", 0)) begin
                for(i = 0;i < `FETCH_WIDTH;i++) begin
                    if(((tdb_bus.get_uint32(DOMAIN_INPUT, "fetch_bus_addr_cur", 0) + i * `INSTRUCTION_WIDTH) >= `TCM_ADDR) && ((tdb_bus.get_uint32(DOMAIN_INPUT, "fetch_bus_addr_cur", 0) + i * `INSTRUCTION_WIDTH) < (`TCM_ADDR + `TCM_SIZE))) begin
                        `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "tcm_bus_fetch_data", i), core_top_inst.bus_inst.tcm_bus_fetch_data[i * `INSTRUCTION_WIDTH +: `INSTRUCTION_WIDTH])
                    end
                end
            end

            if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_rd_cur", 0)) begin
                case(tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0))
                    'h1: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "tcm_bus_stbuf_data", 0) & 'hff, core_top_inst.bus_inst.tcm_bus_stbuf_data[7:0])
                    'h2: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "tcm_bus_stbuf_data", 0) & 'hffff, core_top_inst.bus_inst.tcm_bus_stbuf_data[15:0])
                    'h4: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "tcm_bus_stbuf_data", 0), core_top_inst.bus_inst.tcm_bus_stbuf_data[31:0])
                    default: `assert(0)
                endcase
                
            end

            if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_rd_cur", 0)) begin
                case(tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0))
                    'h1: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "clint_bus_data", 0) & 'hff, core_top_inst.bus_inst.clint_bus_data[7:0])
                    'h2: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "clint_bus_data", 0) & 'hffff, core_top_inst.bus_inst.clint_bus_data[15:0])
                    'h4: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_INPUT, "clint_bus_data", 0), core_top_inst.bus_inst.clint_bus_data[31:0])
                    default: `assert(0)
                endcase
            end

            if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_fetch_read_ack", 0)) begin
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_fetch_read_ack", 0), core_top_inst.bus_inst.bus_fetch_read_ack)

                for(i = 0;i < `FETCH_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_fetch_data", i), core_top_inst.bus_inst.bus_fetch_data[i * `INSTRUCTION_WIDTH+:`INSTRUCTION_WIDTH])
                end
            end

            if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_stbuf_read_ack", 0)) begin
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_stbuf_read_ack", 0), core_top_inst.bus_inst.bus_stbuf_read_ack)
                
                case(tdb_bus.get_uint8(DOMAIN_INPUT, "stbuf_bus_read_size_cur", 0))
                    'd1: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0) & 'hff, core_top_inst.bus_inst.bus_stbuf_data[7:0])
                    'd2: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0) & 'hffff, core_top_inst.bus_inst.bus_stbuf_data[15:0])
                    'd4: `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_stbuf_data", 0), core_top_inst.bus_inst.bus_stbuf_data[31:0])
                    default: `assert(0)
                endcase
            end

            if(cur_cycle > 0) begin
                tdb_bus.move_to_prev_row();
                `assert(tdb_bus.read_cur_row())
                cur_cycle = tdb_bus.get_cur_row();
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_stbuf_write_ack_next", 0), core_top_inst.bus_inst.bus_stbuf_write_ack)
                tdb_bus.move_to_next_row();
                `assert(tdb_bus.read_cur_row())
                cur_cycle = tdb_bus.get_cur_row();
            end

            tdb_bus.move_to_next_row();

            if(tdb_bus.read_cur_row()) begin
                cur_cycle = tdb_bus.get_cur_row();
                
                if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_fetch_rd_cur", 0)) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_fetch_rd_cur", 0), core_top_inst.bus_inst.bus_tcm_fetch_rd)
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_tcm_fetch_addr_cur", 0), core_top_inst.bus_inst.bus_tcm_fetch_addr)
                end

                if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_rd_cur", 0)) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_rd_cur", 0), core_top_inst.bus_inst.bus_tcm_stbuf_rd)
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_read_addr_cur", 0), core_top_inst.bus_inst.bus_tcm_stbuf_read_addr)
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_read_size_cur", 0), core_top_inst.bus_inst.bus_tcm_stbuf_read_size)
                end
                
                if(tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_rd_cur", 0)) begin
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_rd_cur", 0), core_top_inst.bus_inst.bus_clint_rd)
                    `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_clint_read_addr_cur", 0), core_top_inst.bus_inst.bus_clint_read_addr)
                    `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_read_size_cur", 0), core_top_inst.bus_inst.bus_clint_read_size)
                end
            end

            tdb_bus.move_to_prev_row();
            `assert(tdb_bus.read_cur_row())
            cur_cycle = tdb_bus.get_cur_row();
            `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_wr", 0), core_top_inst.bus_inst.bus_tcm_stbuf_wr)

            if(core_top_inst.bus_inst.bus_tcm_stbuf_wr) begin
                `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_write_addr", 0), core_top_inst.bus_inst.bus_tcm_stbuf_write_addr)
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_tcm_stbuf_write_size", 0), core_top_inst.bus_inst.bus_tcm_stbuf_write_size)
                `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_tcm_stbuf_data", 0), core_top_inst.bus_inst.bus_tcm_stbuf_data)
            end    
            
            `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_wr", 0), core_top_inst.bus_inst.bus_clint_wr)

            if(core_top_inst.bus_inst.bus_clint_wr) begin
                `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_clint_write_addr", 0), core_top_inst.bus_inst.bus_clint_write_addr)
                `assert_equal(cur_cycle, tdb_bus.get_uint8(DOMAIN_OUTPUT, "bus_clint_write_size", 0), core_top_inst.bus_inst.bus_clint_write_size)
                `assert_equal(cur_cycle, tdb_bus.get_uint32(DOMAIN_OUTPUT, "bus_clint_data", 0), core_top_inst.bus_inst.bus_clint_data)
            end

            //csrfile
            if(tdb_csrfile.get_uint16(DOMAIN_INPUT, "excsr_csrf_addr", 0) != 65535) begin
                `assert_equal(cur_cycle, tdb_csrfile.get_uint16(DOMAIN_INPUT, "excsr_csrf_addr", 0), core_top_inst.csrfile_inst.excsr_csrf_addr)
            end

            for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
                if(tdb_csrfile.get_uint16(DOMAIN_INPUT, "commit_csrf_read_addr", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb_csrfile.get_uint16(DOMAIN_INPUT, "commit_csrf_read_addr", i), core_top_inst.csrfile_inst.commit_csrf_read_addr[i])
                end

                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_we", i), core_top_inst.csrfile_inst.commit_csrf_we[i])

                if(core_top_inst.csrfile_inst.commit_csrf_we[i]) begin
                    `assert_equal(cur_cycle, tdb_csrfile.get_uint16(DOMAIN_INPUT, "commit_csrf_write_addr", i), core_top_inst.csrfile_inst.commit_csrf_write_addr[i])
                    `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_INPUT, "commit_csrf_write_data", i), core_top_inst.csrfile_inst.commit_csrf_write_data[i])
                end

                `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_INPUT, "intif_csrf_mip_data", 0), core_top_inst.csrfile_inst.intif_csrf_mip_data)

                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "fetch_csrf_checkpoint_buffer_full_add", 0), core_top_inst.csrfile_inst.fetch_csrf_checkpoint_buffer_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "fetch_csrf_fetch_not_full_add", 0), core_top_inst.csrfile_inst.fetch_csrf_fetch_not_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "fetch_csrf_fetch_decode_fifo_full_add", 0), core_top_inst.csrfile_inst.fetch_csrf_fetch_decode_fifo_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "decode_csrf_decode_rename_fifo_full_add", 0), core_top_inst.csrfile_inst.decode_csrf_decode_rename_fifo_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "rename_csrf_phy_regfile_full_add", 0), core_top_inst.csrfile_inst.rename_csrf_phy_regfile_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "rename_csrf_rob_full_add", 0), core_top_inst.csrfile_inst.rename_csrf_rob_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "issue_csrf_issue_execute_fifo_full_add", 0), core_top_inst.csrfile_inst.issue_csrf_issue_execute_fifo_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "issue_csrf_issue_queue_full_add", 0), core_top_inst.csrfile_inst.issue_csrf_issue_queue_full_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_num_add", 0), core_top_inst.csrfile_inst.commit_csrf_branch_num_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_predicted_add", 0), core_top_inst.csrfile_inst.commit_csrf_branch_predicted_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_hit_add", 0), core_top_inst.csrfile_inst.commit_csrf_branch_hit_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_branch_miss_add", 0), core_top_inst.csrfile_inst.commit_csrf_branch_miss_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "commit_csrf_commit_num_add", 0), core_top_inst.csrfile_inst.commit_csrf_commit_num_add)
                `assert_equal(cur_cycle, tdb_csrfile.get_uint8(DOMAIN_INPUT, "ras_csrf_ras_full_add", 0), core_top_inst.csrfile_inst.ras_csrf_ras_full_add)
            end

            //interrupt_interface
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint8(DOMAIN_INPUT, "all_intif_int_ext_req", 0), core_top_inst.interrupt_interface_inst.all_intif_int_ext_req)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint8(DOMAIN_INPUT, "all_intif_int_software_req", 0), core_top_inst.interrupt_interface_inst.all_intif_int_software_req)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint8(DOMAIN_INPUT, "all_intif_int_timer_req", 0), core_top_inst.interrupt_interface_inst.all_intif_int_timer_req)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_INPUT, "csrf_all_mie_data", 0), core_top_inst.interrupt_interface_inst.csrf_all_mie_data)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_INPUT, "csrf_all_mstatus_data", 0), core_top_inst.interrupt_interface_inst.csrf_all_mstatus_data)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_INPUT, "csrf_all_mip_data", 0), core_top_inst.interrupt_interface_inst.csrf_all_mip_data)
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_INPUT, "commit_intif_ack_data", 0), core_top_inst.interrupt_interface_inst.commit_intif_ack_data)

            //phy_regfile
            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    if(tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "readreg_phyf_id", i * 2 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "readreg_phyf_id", i * 2 + j), core_top_inst.phy_regfile_inst.readreg_phyf_id[i][j])
                    end
                end
            end

            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    if(tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "issue_phyf_id", i * 2 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "issue_phyf_id", i * 2 + j), core_top_inst.phy_regfile_inst.issue_phyf_id[i][j])
                    end
                end
            end

            for(i = 0;i < `WB_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "wb_phyf_we", i), core_top_inst.phy_regfile_inst.wb_phyf_we[i])

                if(core_top_inst.phy_regfile_inst.wb_phyf_we[i]) begin
                    `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "wb_phyf_id", i), core_top_inst.phy_regfile_inst.wb_phyf_id[i])
                    `assert_equal(cur_cycle, tdb_phy_regfile.get_uint32(DOMAIN_INPUT, "wb_phyf_data", i), core_top_inst.phy_regfile_inst.wb_phyf_data[i])
                end
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "commit_phyf_invalid", i), core_top_inst.phy_regfile_inst.commit_phyf_invalid[i])

                if(core_top_inst.phy_regfile_inst.commit_phyf_invalid[i]) begin
                    `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "commit_phyf_id", i), core_top_inst.phy_regfile_inst.commit_phyf_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "commit_phyf_flush_invalid", 0), core_top_inst.phy_regfile_inst.commit_phyf_flush_invalid)

            if(core_top_inst.phy_regfile_inst.commit_phyf_flush_invalid) begin
                `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "commit_phyf_flush_id", 0), core_top_inst.phy_regfile_inst.commit_phyf_flush_id)
            end

            `assert_equal(cur_cycle, tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "commit_phyf_data_valid_restore", 0), core_top_inst.phy_regfile_inst.commit_phyf_data_valid_restore)

            if(core_top_inst.phy_regfile_inst.commit_phyf_data_valid_restore) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_phy_regfile, DOMAIN_INPUT, "commit_phyf_data_valid", 0), core_top_inst.phy_regfile_inst.commit_phyf_data_valid)
            end

            //ras
            `assert_equal(cur_cycle, tdb_ras.get_uint8(DOMAIN_INPUT, "bp_ras_push", 0), core_top_inst.ras_inst.bp_ras_push)

            if(core_top_inst.ras_inst.bp_ras_push) begin
                `assert_equal(cur_cycle, tdb_ras.get_uint32(DOMAIN_INPUT, "bp_ras_addr", 0), core_top_inst.ras_inst.bp_ras_addr)
            end

            `assert_equal(cur_cycle, tdb_ras.get_uint8(DOMAIN_INPUT, "bp_ras_pop", 0), core_top_inst.ras_inst.bp_ras_pop)

            if(core_top_inst.ras_inst.bp_ras_pop) begin
                `assert_equal(cur_cycle, tdb_ras.get_uint32(DOMAIN_OUTPUT, "ras_bp_addr", 0), core_top_inst.ras_inst.ras_bp_addr)
            end

            //rat
            temp = 0;

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                temp = temp | tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_phy_id_valid", i);
            end

            if(tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_map", 0) && temp) begin
                `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_map", 0), core_top_inst.rat_inst.rename_rat_map)

                if(core_top_inst.rat_inst.rename_rat_map) begin
                    for(i = 0;i < `RENAME_WIDTH;i++) begin
                        `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_phy_id_valid", i), core_top_inst.rat_inst.rename_rat_phy_id_valid[i])

                        if(core_top_inst.rat_inst.rename_rat_phy_id_valid[i]) begin
                            `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_phy_id", i), core_top_inst.rat_inst.rename_rat_phy_id[i])
                        end
                    end
                end
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                for(j = 0;j < 3;j++) begin
                    if(tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_read_arch_id", i * 3 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_read_arch_id", i * 3 + j), core_top_inst.rat_inst.rename_rat_read_arch_id[i][j])
                    end
                end
            end

            temp = 0;

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                temp = temp | tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_release_phy_id_valid", i);
            end

            if(tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_release_map", 0) && temp) begin
                `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_release_map", 0), core_top_inst.rat_inst.commit_rat_release_map)

                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_release_phy_id_valid", i), core_top_inst.rat_inst.commit_rat_release_phy_id_valid[i])

                    if(core_top_inst.rat_inst.commit_rat_release_phy_id_valid[i]) begin
                        `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_release_phy_id", i), core_top_inst.rat_inst.commit_rat_release_phy_id[i])
                    end
                end
            end

            temp = 0;

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                temp = temp | tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_commit_phy_id_valid", i);
            end

            if(tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_commit_map", 0) && temp) begin
                `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_commit_map", 0), core_top_inst.rat_inst.commit_rat_commit_map)

                for(i = 0;i < `COMMIT_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_commit_phy_id_valid", i), core_top_inst.rat_inst.commit_rat_commit_phy_id_valid[i])

                    if(core_top_inst.rat_inst.commit_rat_commit_phy_id_valid[i]) begin
                        `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_commit_phy_id", i), core_top_inst.rat_inst.commit_rat_commit_phy_id[i])
                    end
                end
            end

            if(tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_restore_map", 0)) begin
                `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_restore_map", 0), core_top_inst.rat_inst.commit_rat_restore_map)

                if(core_top_inst.rat_inst.commit_rat_restore_map) begin
                    `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_restore_new_phy_id", 0), core_top_inst.rat_inst.commit_rat_restore_new_phy_id)
                    `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_INPUT, "commit_rat_restore_old_phy_id", 0), core_top_inst.rat_inst.commit_rat_restore_old_phy_id)
                end
            end
            
            //fetch
            `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.fetch_inst.commit_feedback_pack.enable)

            if(core_top_inst.fetch_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.fetch_inst.commit_feedback_pack.flush)
            end

            if(!core_top_inst.fetch_inst.commit_feedback_pack.enable || !core_top_inst.fetch_inst.commit_feedback_pack.flush) begin
                `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "bp_fetch_valid", 0), core_top_inst.fetch_inst.bp_fetch_valid)
                
                if(core_top_inst.fetch_inst.bp_fetch_valid) begin
                    `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "bp_fetch_jump", 0), core_top_inst.fetch_inst.bp_fetch_jump)

                    if(core_top_inst.fetch_inst.bp_fetch_jump) begin
                        `assert_equal(cur_cycle, tdb_fetch.get_uint32(DOMAIN_INPUT, "bp_fetch_next_pc", 0), core_top_inst.fetch_inst.bp_fetch_next_pc)
                    end

                    if(tdb_branch_predictor.get_uint8(DOMAIN_OUTPUT, "fetch_is_branch", 0)) begin
                        `assert_equal(cur_cycle, tdb_fetch.get_uint16(DOMAIN_INPUT, "bp_fetch_global_history", 0), core_top_inst.fetch_inst.bp_fetch_global_history)
                        `assert_equal(cur_cycle, tdb_fetch.get_uint16(DOMAIN_INPUT, "bp_fetch_local_history", 0), core_top_inst.fetch_inst.bp_fetch_local_history)
                    end

                    `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "cpbuf_fetch_new_id_valid", 0), core_top_inst.fetch_inst.cpbuf_fetch_new_id_valid)

                    if(core_top_inst.fetch_inst.cpbuf_fetch_new_id_valid) begin
                        `assert_equal(cur_cycle, tdb_fetch.get_uint32(DOMAIN_INPUT, "cpbuf_fetch_new_id", 0), core_top_inst.fetch_inst.cpbuf_fetch_new_id)
                    end
                end

                `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "bus_fetch_read_ack", 0), core_top_inst.fetch_inst.bus_fetch_read_ack)

                if(core_top_inst.fetch_inst.bus_fetch_read_ack) begin
                    `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_data_in_valid", 0), core_top_inst.fetch_inst.fetch_decode_fifo_data_in_valid)

                    for(i = 0;i < `FETCH_WIDTH;i++) begin
                        if(core_top_inst.fetch_inst.fetch_decode_fifo_data_in_valid[i])
                        `assert_equal(cur_cycle, tdb_fetch.get_uint32(DOMAIN_INPUT, "bus_fetch_data", i), core_top_inst.fetch_inst.bus_fetch_data[i * `INSTRUCTION_WIDTH+:`INSTRUCTION_WIDTH])
                    end
                end
            end

            `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_INPUT, "stbuf_all_empty", 0), core_top_inst.fetch_inst.stbuf_all_empty)
            `assert_equal(cur_cycle, tdb_fetch.get_uint8(DOMAIN_OUTPUT, "fetch_decode_fifo_flush", 0), core_top_inst.fetch_decode_fifo_flush)

            //decode
            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.decode_inst.commit_feedback_pack.enable)

            if(core_top_inst.decode_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.decode_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out_valid", 0), core_top_inst.decode_inst.fetch_decode_fifo_data_out_valid)
            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_in_enable", 0), core_top_inst.decode_inst.decode_rename_fifo_data_in_enable)

            if(!core_top_inst.decode_inst.commit_feedback_pack.enable || !core_top_inst.decode_inst.commit_feedback_pack.flush) begin
                for(i = 0;i < `DECODE_WIDTH;i++) begin
                    if(core_top_inst.decode_inst.fetch_decode_fifo_data_out_valid[i] && core_top_inst.decode_inst.decode_rename_fifo_data_in_enable[i]) begin
                        `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.enable", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].enable)

                        if(core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].enable) begin
                            `assert_equal(cur_cycle, tdb_decode.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.value", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].value)
                            `assert_equal(cur_cycle, tdb_decode.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.pc", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].pc)
                            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.has_exception", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].has_exception)

                            if(core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].has_exception) begin
                                `assert_equal(cur_cycle, tdb_decode.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.exception_id", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].exception_id)
                                `assert_equal(cur_cycle, tdb_decode.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.exception_value", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].exception_value)
                            end

                            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].predicted)

                            if(core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].predicted) begin
                                `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted_jump", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].predicted_jump)
                                `assert_equal(cur_cycle, tdb_decode.get_uint32(DOMAIN_INPUT, "fetch_decode_fifo_data_out.predicted_next_pc", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].predicted_next_pc)
                            end
                            
                            `assert_equal(cur_cycle, tdb_decode.get_uint8(DOMAIN_INPUT, "fetch_decode_fifo_data_out.checkpoint_id_valid", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].checkpoint_id_valid)

                            if(core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb_decode.get_uint16(DOMAIN_INPUT, "fetch_decode_fifo_data_out.checkpoint_id", i), core_top_inst.decode_inst.fetch_decode_fifo_data_out[i].checkpoint_id)
                            end
                        end
                    end 
                end
            end

            //rename
            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.rename_inst.commit_feedback_pack.enable)

            if(core_top_inst.rename_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.rename_inst.commit_feedback_pack.flush)
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                if(tdb_checkpoint_buffer.get_uint16(DOMAIN_INPUT, "rename_cpbuf_id", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb_rename.get_uint16(DOMAIN_INPUT, "cpbuf_rename_data.global_history", i), core_top_inst.rename_inst.cpbuf_rename_data[i].global_history)
                    `assert_equal(cur_cycle, tdb_rename.get_uint16(DOMAIN_INPUT, "cpbuf_rename_data.local_history", i), core_top_inst.rename_inst.cpbuf_rename_data[i].local_history)
                end
            end
            
            for(i = 0;i < `RENAME_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_OUTPUT, "rat_rename_new_phy_id_valid", i), core_top_inst.rename_inst.rat_rename_new_phy_id_valid[i])

                if(core_top_inst.rename_inst.rat_rename_new_phy_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb_rat.get_uint8(DOMAIN_OUTPUT, "rat_rename_new_phy_id", i), core_top_inst.rename_inst.rat_rename_new_phy_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_rename, DOMAIN_INPUT, "rat_rename_map_table_valid", 0), core_top_inst.rename_inst.rat_rename_map_table_valid)
            `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_rename, DOMAIN_INPUT, "rat_rename_map_table_visible", 0), core_top_inst.rename_inst.rat_rename_map_table_visible)

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                for(j = 0;j < 3;j++) begin
                    if(tdb_rat.get_uint8(DOMAIN_INPUT, "rename_rat_read_arch_id", i * 3 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "rat_rename_read_phy_id", i * 3 + j), core_top_inst.rename_inst.rat_rename_read_phy_id[i][j])
                    end
                end
            end

            for(i = 0;i < `RENAME_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_rename_new_id_valid", i), core_top_inst.rename_inst.rob_rename_new_id_valid[i])

                if(core_top_inst.rename_inst.rob_rename_new_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_rename_new_id", i), core_top_inst.rename_inst.rob_rename_new_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out_valid", 0), tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out_valid", 0) & core_top_inst.rename_inst.decode_rename_fifo_data_out_valid)
            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_pop", 0), core_top_inst.rename_inst.decode_rename_fifo_pop)

            if(core_top_inst.rename_inst.decode_rename_fifo_pop) begin
                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_OUTPUT, "decode_rename_fifo_data_pop_valid", 0), core_top_inst.rename_inst.decode_rename_fifo_data_pop_valid)

                for(i = 0;i < `RENAME_WIDTH;i++) begin
                    if(core_top_inst.rename_inst.decode_rename_fifo_data_pop_valid[i]) begin
                        `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.enable", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].enable)

                        if(core_top_inst.rename_inst.decode_rename_fifo_data_out[i].enable) begin
                            `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.value", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].value)
                            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.valid", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].valid)

                            if(core_top_inst.rename_inst.decode_rename_fifo_data_out[i].valid) begin
                                `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.imm", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].imm)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs1", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rs1)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.arg1_src", i)), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].arg1_src)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs1_need_map", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rs1_need_map)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs2", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rs2)
                                `assert_equal(cur_cycle, arg_src_t::_type'(tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.arg2_src", i)), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].arg2_src)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rs2_need_map", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rs2_need_map)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rd", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rd)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.rd_enable", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].rd_enable)
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.need_rename", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].need_rename)
                                `assert_equal(cur_cycle, tdb_rename.get_uint16(DOMAIN_INPUT, "decode_rename_fifo_data_out.csr", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].csr)
                            end
                            
                            `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.pc", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].pc)
                            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.has_exception", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].has_exception)

                            if(core_top_inst.rename_inst.decode_rename_fifo_data_out[i].has_exception) begin
                                `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.exception_id", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].exception_id)
                                `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.exception_value", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].exception_value)
                            end

                            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].predicted)

                            if(core_top_inst.rename_inst.decode_rename_fifo_data_out[i].predicted) begin
                                `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted_jump", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].predicted_jump)
                                `assert_equal(cur_cycle, tdb_rename.get_uint32(DOMAIN_INPUT, "decode_rename_fifo_data_out.predicted_next_pc", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].predicted_next_pc)
                            end
                            
                            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.checkpoint_id_valid", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].checkpoint_id_valid)

                            if(core_top_inst.rename_inst.decode_rename_fifo_data_out[i].checkpoint_id_valid) begin
                                `assert_equal(cur_cycle, tdb_rename.get_uint16(DOMAIN_INPUT, "decode_rename_fifo_data_out.checkpoint_id", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].checkpoint_id)
                            end

                            `assert_equal(cur_cycle, op_t::_type'(tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.op", i)), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].op)
                            `assert_equal(cur_cycle, op_unit_t::_type'(tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.op_unit", i)), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].op_unit)
                            `assert_equal(cur_cycle, tdb_rename.get_uint8(DOMAIN_INPUT, "decode_rename_fifo_data_out.sub_op", i), core_top_inst.rename_inst.decode_rename_fifo_data_out[i].sub_op.raw_data)
                        end
                    end
                end
            end

            //readreg
            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "issue_feedback_pack.stall", 0), core_top_inst.readreg_inst.issue_feedback_pack.stall)

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.enable", i), core_top_inst.readreg_inst.execute_feedback_pack.channel[i].enable)

                if(core_top_inst.readreg_inst.execute_feedback_pack.channel[i].enable) begin
                    `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.phy_id", i), core_top_inst.readreg_inst.execute_feedback_pack.channel[i].phy_id)
                    `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "execute_feedback_pack.value", i), core_top_inst.readreg_inst.execute_feedback_pack.channel[i].value)

                    if(tdb_readreg.get_uint32(DOMAIN_INPUT, "execute_feedback_pack.value", i) != core_top_inst.readreg_inst.execute_feedback_pack.channel[i].value) begin
                        $display("i = %0d", i);
                        $display(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.send_pack.sub_op.lsu_op);
                    end
                end
            end

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.enable", i), core_top_inst.readreg_inst.wb_feedback_pack.channel[i].enable)

                if(tdb_readreg.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.enable", i) != core_top_inst.readreg_inst.wb_feedback_pack.channel[i].enable) begin
                    $display("i = %0d", i);
                end

                if(core_top_inst.readreg_inst.wb_feedback_pack.channel[i].enable) begin
                    `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.phy_id", i), core_top_inst.readreg_inst.wb_feedback_pack.channel[i].phy_id)
                    `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "wb_feedback_pack.value", i), core_top_inst.readreg_inst.wb_feedback_pack.channel[i].value)
                end
            end

            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.readreg_inst.commit_feedback_pack.enable)

            if(core_top_inst.readreg_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.readreg_inst.commit_feedback_pack.flush)
            end

            for(i = 0;i < `READREG_WIDTH;i++) begin
                for(j = 0;j < 2;j++) begin
                    if(tdb_phy_regfile.get_uint8(DOMAIN_INPUT, "readreg_phyf_id", i * 2 + j) != 255) begin
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "phyf_readreg_data_valid", i * 2 + j), core_top_inst.readreg_inst.phyf_readreg_data_valid[i][j])

                        if(core_top_inst.readreg_inst.phyf_readreg_data_valid[i][j]) begin
                            `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "phyf_readreg_data", i * 2 + j), core_top_inst.readreg_inst.phyf_readreg_data[i][j])
                        end
                    end
                end
            end

            if((!core_top_inst.readreg_inst.commit_feedback_pack.enable || !core_top_inst.readreg_inst.commit_feedback_pack.flush) && !core_top_inst.readreg_inst.issue_feedback_pack.stall) begin
                for(i = 0;i < `RENAME_WIDTH;i++) begin
                    `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.enable", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].enable)

                    if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].enable) begin
                        `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.value", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].value)
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.valid", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].valid)

                        if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].valid) begin
                            `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.imm", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].imm)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs1)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.arg1_src", i)), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].arg1_src)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1_need_map", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs1_need_map)

                            if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs1_phy", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs1_phy)
                            end
                            
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs2)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.arg2_src", i)), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].arg2_src)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2_need_map", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs2_need_map)

                            if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rs2_phy", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rs2_phy)
                            end

                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rd)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd_enable", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rd_enable)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.need_rename", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].need_rename)

                            if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rd_enable && core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].need_rename) begin
                                `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rd_phy", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rd_phy)
                            end

                            `assert_equal(cur_cycle, tdb_readreg.get_uint16(DOMAIN_INPUT, "rename_readreg_port_data_out.csr", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].csr)
                        end

                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.rob_id", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].rob_id)
                        `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.pc", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].pc)
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.has_exception", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].has_exception)

                        if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].has_exception) begin
                            `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.exception_id", i)), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].exception_id)
                            `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.exception_value", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].predicted)

                        if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].predicted) begin
                            `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted_jump", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].predicted_jump)

                            if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb_readreg.get_uint32(DOMAIN_INPUT, "rename_readreg_port_data_out.predicted_next_pc", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.checkpoint_id_valid", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].checkpoint_id_valid)

                        if(core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb_readreg.get_uint16(DOMAIN_INPUT, "rename_readreg_port_data_out.checkpoint_id", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].checkpoint_id)
                        end
                        
                        `assert_equal(cur_cycle, op_t::_type'(tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.op", i)), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].op)
                        `assert_equal(cur_cycle, op_unit_t::_type'(tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.op_unit", i)), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].op_unit)
                        `assert_equal(cur_cycle, tdb_readreg.get_uint8(DOMAIN_INPUT, "rename_readreg_port_data_out.sub_op", i), core_top_inst.readreg_inst.rename_readreg_port_data_out.op_info[i].sub_op.raw_data)
                    end
                end
            end

            //issue
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "stbuf_all_empty", 0), core_top_inst.issue_inst.stbuf_all_empty)

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.enable", i), core_top_inst.issue_inst.execute_feedback_pack.channel[i].enable)

                if(core_top_inst.issue_inst.execute_feedback_pack.channel[i].enable) begin
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "execute_feedback_pack.phy_id", i), core_top_inst.issue_inst.execute_feedback_pack.channel[i].phy_id)
                    `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "execute_feedback_pack.value", i), core_top_inst.issue_inst.execute_feedback_pack.channel[i].value)
                end
            end

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.enable", i), core_top_inst.issue_inst.wb_feedback_pack.channel[i].enable)

                if(core_top_inst.issue_inst.wb_feedback_pack.channel[i].enable) begin
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "wb_feedback_pack.phy_id", i), core_top_inst.issue_inst.wb_feedback_pack.channel[i].phy_id)
                    `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "wb_feedback_pack.value", i), core_top_inst.issue_inst.wb_feedback_pack.channel[i].value)
                end
            end

            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.issue_inst.commit_feedback_pack.enable)

            if(core_top_inst.issue_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.issue_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.next_handle_rob_id_valid", 0), core_top_inst.issue_inst.commit_feedback_pack.next_handle_rob_id_valid)

            if(core_top_inst.issue_inst.commit_feedback_pack.next_handle_rob_id_valid) begin
                `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.next_handle_rob_id", 0), core_top_inst.issue_inst.commit_feedback_pack.next_handle_rob_id)
            end

            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id_valid", 0), core_top_inst.issue_inst.commit_feedback_pack.committed_rob_id_valid)

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(core_top_inst.issue_inst.commit_feedback_pack.committed_rob_id_valid[i]) begin
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.committed_rob_id", i), core_top_inst.issue_inst.commit_feedback_pack.committed_rob_id[i])
                end
            end

            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_alu_fifo_full", 0), core_top_inst.issue_inst.issue_alu_fifo_full)
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_bru_fifo_full", 0), core_top_inst.issue_inst.issue_bru_fifo_full)
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_csr_fifo_full", 0), core_top_inst.issue_inst.issue_csr_fifo_full)
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_div_fifo_full", 0), core_top_inst.issue_inst.issue_div_fifo_full)
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_full", 0), core_top_inst.issue_inst.issue_lsu_fifo_full)
            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "issue_mul_fifo_full", 0), core_top_inst.issue_inst.issue_mul_fifo_full)

            for(i = 0;i < `READREG_WIDTH;i++) begin
                `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.enable", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].enable)

                if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].enable) begin
                    `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.value", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].value)
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.valid", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].valid)

                    if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].valid) begin
                        `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.imm", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].imm)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.arg1_src", i)), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].arg1_src)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1_need_map", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs1_need_map)

                        if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs1_phy", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.src1_value", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].src1_value)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.src1_loaded", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].src1_loaded)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.arg2_src", i)), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].arg2_src)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2_need_map", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs2_need_map)

                        if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rs2_phy", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.src2_value", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].src2_value)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.src2_loaded", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].src2_loaded)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rd)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd_enable", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rd_enable)
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.need_rename", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].need_rename)
                        
                        if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rd_enable && core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].need_rename) begin
                            `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rd_phy", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rd_phy)
                        end
                        
                        `assert_equal(cur_cycle, tdb_issue.get_uint16(DOMAIN_INPUT, "readreg_issue_port_data_out.csr", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].csr)
                    end

                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.rob_id", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].rob_id)
                    `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.pc", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].pc)
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.has_exception", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].has_exception)

                    if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.exception_id", i)), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].exception_id)
                        `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.exception_value", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].predicted)

                    if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].predicted) begin
                        `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted_jump", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].predicted_jump)

                        if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_issue.get_uint32(DOMAIN_INPUT, "readreg_issue_port_data_out.predicted_next_pc", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.checkpoint_id_valid", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].checkpoint_id_valid)

                    if(core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_issue.get_uint16(DOMAIN_INPUT, "readreg_issue_port_data_out.checkpoint_id", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.op", i)), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.op_unit", i)), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].op_unit)
                    `assert_equal(cur_cycle, tdb_issue.get_uint8(DOMAIN_INPUT, "readreg_issue_port_data_out.sub_op", i), core_top_inst.issue_inst.readreg_issue_port_data_out.op_info[i].sub_op.raw_data)
                end
            end

            //execute_alu_0     
            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_alu_generate[0].execute_alu_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out_valid", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out_valid)

            if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out_valid && (!core_top_inst.execute_alu_generate[0].execute_alu_inst.commit_feedback_pack.enable || !core_top_inst.execute_alu_generate[0].execute_alu_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.enable", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.enable)
                        
                if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.value", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.valid", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.valid)

                    if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.imm", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg1_src", 0)), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_phy", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_value", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_loaded", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg2_src", 0)), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_phy", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_value", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_loaded", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_enable", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.need_rename", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.need_rename)

                        if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rd_enable && core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_phy", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rd_phy)
                        end
                        
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.csr", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rob_id", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.pc", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.has_exception", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.has_exception)

                    if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_id", 0)), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_value", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.predicted)

                    if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_jump", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op", 0)), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op_unit", 0)), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_alu[0].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.sub_op", 0), core_top_inst.execute_alu_generate[0].execute_alu_inst.issue_alu_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_alu_1
            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_alu_generate[1].execute_alu_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out_valid", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out_valid)

            if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out_valid && (!core_top_inst.execute_alu_generate[1].execute_alu_inst.commit_feedback_pack.enable || !core_top_inst.execute_alu_generate[1].execute_alu_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.enable", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.enable)
                        
                if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.value", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.valid", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.valid)

                    if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.imm", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg1_src", 0)), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs1_phy", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_value", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src1_loaded", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.arg2_src", 0)), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rs2_phy", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_value", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.src2_loaded", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_enable", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.need_rename", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.need_rename)

                        if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rd_enable && core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rd_phy", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rd_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.csr", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.rob_id", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.pc", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.has_exception", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.has_exception)

                    if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_id", 0)), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.exception_value", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.predicted)

                    if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_jump", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint32(DOMAIN_INPUT, "issue_alu_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint16(DOMAIN_INPUT, "issue_alu_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op", 0)), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.op_unit", 0)), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_alu[1].get_uint8(DOMAIN_INPUT, "issue_alu_fifo_data_out.sub_op", 0), core_top_inst.execute_alu_generate[1].execute_alu_inst.issue_alu_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_bru_0
            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_bru_generate[0].execute_bru_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.commit_feedback_pack.flush)
            end

            if(tdb_checkpoint_buffer.get_uint16(DOMAIN_INPUT, "exbru_cpbuf_id", 0) != 65535) begin
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_checkpoint_buffer, DOMAIN_OUTPUT, "cpbuf_exbru_data.rat_phy_map_table_valid", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.cpbuf_exbru_data.rat_phy_map_table_valid)
                `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_checkpoint_buffer, DOMAIN_OUTPUT, "cpbuf_exbru_data.rat_phy_map_table_visible", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.cpbuf_exbru_data.rat_phy_map_table_visible)
                `assert_equal(cur_cycle, tdb_checkpoint_buffer.get_uint16(DOMAIN_OUTPUT, "cpbuf_exbru_data.global_history", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.cpbuf_exbru_data.global_history)
                `assert_equal(cur_cycle, tdb_checkpoint_buffer.get_uint16(DOMAIN_OUTPUT, "cpbuf_exbru_data.local_history", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.cpbuf_exbru_data.local_history)
            end

            `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_OUTPUT, "csrf_all_mepc_data", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.csrf_all_mepc_data)
            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out_valid", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out_valid)

            if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out_valid && (!core_top_inst.execute_bru_generate[0].execute_bru_inst.commit_feedback_pack.enable || !core_top_inst.execute_bru_generate[0].execute_bru_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.enable", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.enable)
                        
                if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.value", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.valid", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.valid)

                    if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.imm", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs1", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.arg1_src", 0)), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs1_phy", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.src1_value", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.src1_loaded", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs2", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.arg2_src", 0)), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rs2_phy", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.src2_value", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.src2_loaded", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rd", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rd_enable", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.need_rename", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.need_rename)

                        if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rd_enable && core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rd_phy", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rd_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint16(DOMAIN_INPUT, "issue_bru_fifo_data_out.csr", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.rob_id", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.pc", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.has_exception", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.has_exception)

                    if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.exception_id", 0)), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.exception_value", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.predicted", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.predicted)

                    if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.predicted_jump", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint32(DOMAIN_INPUT, "issue_bru_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint16(DOMAIN_INPUT, "issue_bru_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.op", 0)), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.op_unit", 0)), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_bru[0].get_uint8(DOMAIN_INPUT, "issue_bru_fifo_data_out.sub_op", 0), core_top_inst.execute_bru_generate[0].execute_bru_inst.issue_bru_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_csr_0
            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_csr_generate[0].execute_csr_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.commit_feedback_pack.flush)
            end

            if(tdb_csrfile.get_uint16(DOMAIN_INPUT, "excsr_csrf_addr", 0) != 65535) begin
                `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_OUTPUT, "csrf_excsr_data", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.csrf_excsr_data)
            end

            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out_valid", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out_valid)

            if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out_valid && (!core_top_inst.execute_csr_generate[0].execute_csr_inst.commit_feedback_pack.enable || !core_top_inst.execute_csr_generate[0].execute_csr_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.enable", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.enable)
                        
                if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.value", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.valid", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.valid)

                    if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.imm", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs1", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.arg1_src", 0)), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs1_phy", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.src1_value", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.src1_loaded", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs2", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.arg2_src", 0)), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs2_need_map)
                        
                        if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rs2_phy", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.src2_value", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.src2_loaded", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rd", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rd_enable", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.need_rename", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.need_rename)

                        if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rd_enable && core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rd_phy", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rd_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint16(DOMAIN_INPUT, "issue_csr_fifo_data_out.csr", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.rob_id", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.pc", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.has_exception", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.has_exception)

                    if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.exception_id", 0)), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.exception_value", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.predicted", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.predicted)

                    if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.predicted_jump", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint32(DOMAIN_INPUT, "issue_csr_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint16(DOMAIN_INPUT, "issue_csr_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.op", 0)), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.op_unit", 0)), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_csr[0].get_uint8(DOMAIN_INPUT, "issue_csr_fifo_data_out.sub_op", 0), core_top_inst.execute_csr_generate[0].execute_csr_inst.issue_csr_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_div_0     
            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_div_generate[0].execute_div_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_div_generate[0].execute_div_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_div_generate[0].execute_div_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out_valid", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out_valid)

            if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out_valid && (!core_top_inst.execute_div_generate[0].execute_div_inst.commit_feedback_pack.enable || !core_top_inst.execute_div_generate[0].execute_div_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.enable", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.enable)
                        
                if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.value", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.valid", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.valid)

                    if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.imm", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs1", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.arg1_src", 0)), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs1_phy", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.src1_value", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.src1_loaded", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs2", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.arg2_src", 0)), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rs2_phy", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.src2_value", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.src2_loaded", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rd", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rd_enable", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.need_rename", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.need_rename)

                        if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rd_enable && core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rd_phy", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rd_phy)
                        end
                        
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint16(DOMAIN_INPUT, "issue_div_fifo_data_out.csr", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.rob_id", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.pc", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.has_exception", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.has_exception)

                    if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.exception_id", 0)), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.exception_value", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.predicted", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.predicted)

                    if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.predicted_jump", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_div[0].get_uint32(DOMAIN_INPUT, "issue_div_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_div[0].get_uint16(DOMAIN_INPUT, "issue_div_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.op", 0)), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.op_unit", 0)), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_div[0].get_uint8(DOMAIN_INPUT, "issue_div_fifo_data_out.sub_op", 0), core_top_inst.execute_div_generate[0].execute_div_inst.issue_div_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_lsu_0
            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_store_buffer.get_uint8(DOMAIN_OUTPUT, "stbuf_exlsu_full", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.stbuf_exlsu_full)

            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out_valid", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out_valid)

            if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out_valid && (!core_top_inst.execute_lsu_generate[0].execute_lsu_inst.commit_feedback_pack.enable || !core_top_inst.execute_lsu_generate[0].execute_lsu_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.enable", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.enable)
                        
                if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.value", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.valid", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.valid)

                    if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.imm", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs1", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.arg1_src", 0)), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs1_phy", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.src1_value", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.src1_loaded", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs2", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.arg2_src", 0)), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rs2_phy", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.src2_value", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.src2_loaded", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rd", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rd_enable", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.need_rename", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.need_rename)

                        if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rd_enable && core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rd_phy", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rd_phy)
                        end
                        
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint16(DOMAIN_INPUT, "issue_lsu_fifo_data_out.csr", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.rob_id", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.pc", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.has_exception", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.has_exception)

                    if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.exception_id", 0)), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.exception_value", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.predicted", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.predicted)

                    if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.predicted_jump", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint32(DOMAIN_INPUT, "issue_lsu_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint16(DOMAIN_INPUT, "issue_lsu_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.op", 0)), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.op_unit", 0)), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_lsu[0].get_uint8(DOMAIN_INPUT, "issue_lsu_fifo_data_out.sub_op", 0), core_top_inst.execute_lsu_generate[0].execute_lsu_inst.issue_lsu_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_mul_0     
            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_mul_generate[0].execute_mul_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out_valid", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out_valid)

            if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out_valid && (!core_top_inst.execute_mul_generate[0].execute_mul_inst.commit_feedback_pack.enable || !core_top_inst.execute_mul_generate[0].execute_mul_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.enable", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.enable)
                        
                if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.value", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.valid", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.valid)

                    if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.imm", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.arg1_src", 0)), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1_phy", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.src1_value", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.src1_loaded", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.arg2_src", 0)), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2_phy", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.src2_value", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.src2_loaded", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd_enable", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.need_rename", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.need_rename)

                        if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rd_enable && core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd_phy", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rd_phy)
                        end
                        
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint16(DOMAIN_INPUT, "issue_mul_fifo_data_out.csr", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rob_id", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.pc", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.has_exception", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.has_exception)

                    if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.exception_id", 0)), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.exception_value", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.predicted)

                    if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted_jump", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint16(DOMAIN_INPUT, "issue_mul_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.op", 0)), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.op_unit", 0)), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_mul[0].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.sub_op", 0), core_top_inst.execute_mul_generate[0].execute_mul_inst.issue_mul_fifo_data_out.sub_op.raw_data)
                end
            end

            //execute_mul_1
            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.commit_feedback_pack.enable)

            if(core_top_inst.execute_mul_generate[1].execute_mul_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.commit_feedback_pack.flush)
            end

            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out_valid", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out_valid)

            if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out_valid && (!core_top_inst.execute_mul_generate[1].execute_mul_inst.commit_feedback_pack.enable || !core_top_inst.execute_mul_generate[1].execute_mul_inst.commit_feedback_pack.flush)) begin
                `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.enable", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.enable)
                        
                if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.enable) begin
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.value", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.value)
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.valid", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.valid)

                    if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.valid) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.imm", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.imm)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs1)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.arg1_src", 0)), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.arg1_src)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1_need_map", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs1_need_map)

                        if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs1_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs1_phy", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs1_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.src1_value", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.src1_value)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.src1_loaded", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.src1_loaded)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs2)
                        `assert_equal(cur_cycle, arg_src_t::_type'(tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.arg2_src", 0)), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.arg2_src)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2_need_map", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs2_need_map)

                        if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs2_need_map) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rs2_phy", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rs2_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.src2_value", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.src2_value)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.src2_loaded", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.src2_loaded)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rd)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd_enable", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rd_enable)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.need_rename", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.need_rename)

                        if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rd_enable && core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.need_rename) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rd_phy", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rd_phy)
                        end

                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint16(DOMAIN_INPUT, "issue_mul_fifo_data_out.csr", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.csr)
                    end

                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.rob_id", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.rob_id)
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.pc", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.pc)
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.has_exception", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.has_exception)

                    if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.has_exception) begin
                        `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.exception_id", 0)), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.exception_id)
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.exception_value", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.exception_value)
                    end
                        
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.predicted)

                    if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.predicted) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted_jump", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.predicted_jump)

                        if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint32(DOMAIN_INPUT, "issue_mul_fifo_data_out.predicted_next_pc", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.checkpoint_id_valid", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id_valid)

                    if(core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint16(DOMAIN_INPUT, "issue_mul_fifo_data_out.checkpoint_id", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.checkpoint_id)
                    end
                    
                    `assert_equal(cur_cycle, op_t::_type'(tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.op", 0)), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.op)
                    `assert_equal(cur_cycle, op_unit_t::_type'(tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.op_unit", 0)), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.op_unit)
                    `assert_equal(cur_cycle, tdb_execute_mul[1].get_uint8(DOMAIN_INPUT, "issue_mul_fifo_data_out.sub_op", 0), core_top_inst.execute_mul_generate[1].execute_mul_inst.issue_mul_fifo_data_out.sub_op.raw_data)
                end
            end

            //wb
            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.enable", 0), core_top_inst.wb_inst.commit_feedback_pack.enable)

            if(core_top_inst.wb_inst.commit_feedback_pack.enable) begin
                `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "commit_feedback_pack.flush", 0), core_top_inst.wb_inst.commit_feedback_pack.flush)
            end

            if(!core_top_inst.wb_inst.commit_feedback_pack.enable || !core_top_inst.wb_inst.commit_feedback_pack.flush) begin
                for(i = 0;i < `ALU_UNIT_NUM;i++) begin
                    `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.enable", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].enable)

                    if(core_top_inst.wb_inst.alu_wb_port_data_out[i].enable) begin
                        `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.value", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].value)
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.valid", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].valid)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].valid) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.imm", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].imm)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs1)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.arg1_src", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].arg1_src)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1_need_map", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs1_need_map)

                            if(core_top_inst.wb_inst.alu_wb_port_data_out[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs1_phy", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs1_phy)
                            end

                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.src1_value", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].src1_value)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.src1_loaded", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].src1_loaded)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs2)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.arg2_src", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].arg2_src)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2_need_map", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs2_need_map)

                            if(core_top_inst.wb_inst.alu_wb_port_data_out[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rs2_phy", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rs2_phy)
                            end
                            
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.src2_value", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].src2_value)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.src2_loaded", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].src2_loaded)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rd)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd_enable", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rd_enable)
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.need_rename", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].need_rename)

                            if(core_top_inst.wb_inst.alu_wb_port_data_out[i].rd_enable && core_top_inst.wb_inst.alu_wb_port_data_out[i].need_rename) begin
                                `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rd_phy", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rd_phy)
                            end

                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.rd_value", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rd_value)
                            `assert_equal(cur_cycle, tdb_wb.get_uint16(DOMAIN_INPUT, "execute_wb_port_data_out.csr", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].csr)
                        end

                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.rob_id", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].rob_id)
                        `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.pc", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].pc)
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.has_exception", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].has_exception)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].has_exception) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.exception_id", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].exception_id)
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.exception_value", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.predicted", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].predicted)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].predicted) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.predicted_jump", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].predicted_jump)

                            if(core_top_inst.wb_inst.alu_wb_port_data_out[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.predicted_next_pc", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.checkpoint_id_valid", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].checkpoint_id_valid)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint16(DOMAIN_INPUT, "execute_wb_port_data_out.checkpoint_id", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].checkpoint_id)
                        end

                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.bru_jump", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].bru_jump)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].bru_jump) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.bru_next_pc", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].bru_next_pc)
                        end

                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.csr_newvalue_valid", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].csr_newvalue_valid)

                        if(core_top_inst.wb_inst.alu_wb_port_data_out[i].csr_newvalue_valid) begin
                            `assert_equal(cur_cycle, tdb_wb.get_uint32(DOMAIN_INPUT, "execute_wb_port_data_out.csr_newvalue", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].csr_newvalue)
                        end
                        
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.op", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].op)
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.op_unit", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].op_unit)
                        `assert_equal(cur_cycle, tdb_wb.get_uint8(DOMAIN_INPUT, "execute_wb_port_data_out.sub_op", i), core_top_inst.wb_inst.alu_wb_port_data_out[i].sub_op)
                    end
                end
            end

            //commit
            `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint8(DOMAIN_OUTPUT, "intif_commit_has_interrupt", 0), core_top_inst.commit_inst.intif_commit_has_interrupt)
            
            if(core_top_inst.commit_inst.intif_commit_has_interrupt) begin
                `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_OUTPUT, "intif_commit_mcause_data", 0), core_top_inst.commit_inst.intif_commit_mcause_data)
                `assert_equal(cur_cycle, tdb_interrupt_interface.get_uint32(DOMAIN_OUTPUT, "intif_commit_ack_data", 0), core_top_inst.commit_inst.intif_commit_ack_data)
            end

            for(i = 0;i < `COMMIT_WIDTH;i++) begin
                if(tdb_checkpoint_buffer.get_uint16(DOMAIN_INPUT, "commit_cpbuf_id", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_checkpoint_buffer, DOMAIN_OUTPUT, "cpbuf_commit_data.rat_phy_map_table_valid", i), core_top_inst.commit_inst.cpbuf_commit_data[i].rat_phy_map_table_valid)
                    `assert_equal(cur_cycle, tdb_reader::get_vector#(`PHY_REG_NUM)::_do(tdb_checkpoint_buffer, DOMAIN_OUTPUT, "cpbuf_commit_data.rat_phy_map_table_visible", i), core_top_inst.commit_inst.cpbuf_commit_data[i].rat_phy_map_table_visible)
                    `assert_equal(cur_cycle, tdb_checkpoint_buffer.get_uint16(DOMAIN_OUTPUT, "cpbuf_commit_data.global_history", i), core_top_inst.commit_inst.cpbuf_commit_data[i].global_history)
                    `assert_equal(cur_cycle, tdb_checkpoint_buffer.get_uint16(DOMAIN_OUTPUT, "cpbuf_commit_data.local_history", i), core_top_inst.commit_inst.cpbuf_commit_data[i].local_history)
                end
            end

            for(i = 0;i < `COMMIT_CSR_CHANNEL_NUM;i++) begin
                if(tdb_csrfile.get_uint16(DOMAIN_INPUT, "commit_csrf_read_addr", i) != 65535) begin
                    `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_OUTPUT, "csrf_commit_read_data", i), core_top_inst.commit_inst.csrf_commit_read_data[i])
                end
            end

            `assert_equal(cur_cycle, tdb_csrfile.get_uint32(DOMAIN_OUTPUT, "csrf_all_mstatus_data", 0), core_top_inst.commit_inst.csrf_all_mstatus_data)

            if(tdb_rob.get_uint8(DOMAIN_INPUT, "commit_rob_next_id", 0) != 255) begin
                `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_next_id_valid", 0), core_top_inst.commit_inst.rob_commit_next_id_valid)
            end

            `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_tail_id_valid", 0), core_top_inst.commit_inst.rob_commit_flush_tail_id_valid)

            if(core_top_inst.commit_inst.rob_commit_flush_tail_id_valid) begin
                `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_flush_tail_id", 0), core_top_inst.commit_inst.rob_commit_flush_tail_id)
            end

            for(i = 0;i < `WB_WIDTH;i++) begin
                if(tdb_rob.get_uint8(DOMAIN_INPUT, "commit_rob_input_data_we", i)) begin
                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.old_phy_reg_id_valid", i), core_top_inst.commit_inst.rob_commit_input_data[i].old_phy_reg_id_valid)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].old_phy_reg_id_valid) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.old_phy_reg_id", i), core_top_inst.commit_inst.rob_commit_input_data[i].old_phy_reg_id)
                        `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.new_phy_reg_id", i), core_top_inst.commit_inst.rob_commit_input_data[i].new_phy_reg_id)
                    end

                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.finish", i), core_top_inst.commit_inst.rob_commit_input_data[i].finish)
                    `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.pc", i), core_top_inst.commit_inst.rob_commit_input_data[i].pc)
                    `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.inst_value", i), core_top_inst.commit_inst.rob_commit_input_data[i].inst_value)
                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.has_exception", i), core_top_inst.commit_inst.rob_commit_input_data[i].has_exception)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].has_exception) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.exception_id", i), core_top_inst.commit_inst.rob_commit_input_data[i].exception_id)
                        `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.exception_value", i), core_top_inst.commit_inst.rob_commit_input_data[i].exception_value)
                    end

                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.predicted", i), core_top_inst.commit_inst.rob_commit_input_data[i].predicted)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].predicted) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.predicted_jump", i), core_top_inst.commit_inst.rob_commit_input_data[i].predicted_jump)

                        if(core_top_inst.commit_inst.rob_commit_input_data[i].predicted_jump) begin
                            `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.predicted_next_pc", i), core_top_inst.commit_inst.rob_commit_input_data[i].predicted_next_pc)
                        end
                    end
                    
                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.checkpoint_id_valid", i), core_top_inst.commit_inst.rob_commit_input_data[i].checkpoint_id_valid)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].checkpoint_id_valid) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint16(DOMAIN_OUTPUT, "rob_commit_input_data.checkpoint_id", i), core_top_inst.commit_inst.rob_commit_input_data[i].checkpoint_id)
                    end

                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.bru_op", i), core_top_inst.commit_inst.rob_commit_input_data[i].bru_op)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].bru_op) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.bru_jump", i), core_top_inst.commit_inst.rob_commit_input_data[i].bru_jump)

                        if(core_top_inst.commit_inst.rob_commit_input_data[i].bru_jump) begin
                            `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.bru_next_pc", i), core_top_inst.commit_inst.rob_commit_input_data[i].bru_next_pc)
                        end
                    end

                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.is_mret", i), core_top_inst.commit_inst.rob_commit_input_data[i].is_mret)
                    `assert_equal(cur_cycle, tdb_rob.get_uint16(DOMAIN_OUTPUT, "rob_commit_input_data.csr_addr", i), core_top_inst.commit_inst.rob_commit_input_data[i].csr_addr)
                    `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_input_data.csr_newvalue_valid", i), core_top_inst.commit_inst.rob_commit_input_data[i].csr_newvalue_valid)

                    if(core_top_inst.commit_inst.rob_commit_input_data[i].csr_newvalue_valid) begin
                        `assert_equal(cur_cycle, tdb_rob.get_uint32(DOMAIN_OUTPUT, "rob_commit_input_data.csr_newvalue", i), core_top_inst.commit_inst.rob_commit_input_data[i].csr_newvalue)
                    end
                end
            end
            
            `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_head_id_valid", 0), core_top_inst.commit_inst.rob_commit_retire_head_id_valid)

            if (core_top_inst.commit_inst.rob_commit_retire_head_id_valid) begin
                `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_retire_head_id", 0), core_top_inst.commit_inst.rob_commit_retire_head_id)
            end

            for(i = 0;i < `EXECUTE_UNIT_NUM;i++) begin
                if(tdb_rob.get_uint8(DOMAIN_INPUT, "commit_rob_input_data_we", i)) begin
                    `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.enable", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].enable)
                    
                    if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].enable) begin
                        `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.value", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].value)
                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.valid", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].valid)

                        if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].valid) begin
                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.imm", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].imm)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs1)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.arg1_src", i)), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].arg1_src)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1_need_map", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs1_need_map)

                            if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs1_need_map) begin
                                `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs1_phy", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs1_phy)
                            end

                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.src1_value", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].src1_value)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.src1_loaded", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].src1_loaded)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs2)
                            `assert_equal(cur_cycle, arg_src_t::_type'(tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.arg2_src", i)), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].arg2_src)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2_need_map", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs2_need_map)

                            if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs2_need_map) begin
                                `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rs2_phy", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rs2_phy)
                            end

                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.src2_value", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].src2_value)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.src2_loaded", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].src2_loaded)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rd)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd_enable", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rd_enable)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.need_rename", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].need_rename)
                            
                            if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rd_enable && core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].need_rename) begin
                                `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rd_phy", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rd_phy)
                            end

                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.rd_value", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rd_value)
                            `assert_equal(cur_cycle, tdb_commit.get_uint16(DOMAIN_INPUT, "wb_commit_port_data_out.csr", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].csr)
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.csr_newvalue_valid", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].csr_newvalue_valid)

                            if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].csr_newvalue_valid) begin
                                 `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.csr_newvalue", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].csr_newvalue)
                            end
                        end

                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.rob_id", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].rob_id)
                        `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.pc", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].pc)
                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.has_exception", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].has_exception)

                        if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].has_exception) begin
                            `assert_equal(cur_cycle, riscv_exception_t::_type'(tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.exception_id", i)), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].exception_id)
                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.exception_value", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].exception_value)
                        end
                            
                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.predicted", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].predicted)

                        if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].predicted) begin
                            `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.predicted_jump", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].predicted_jump)

                            if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].predicted_jump) begin
                                `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.predicted_next_pc", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].predicted_next_pc)
                            end
                        end
                        
                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.checkpoint_id_valid", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].checkpoint_id_valid)

                        if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].checkpoint_id_valid) begin
                            `assert_equal(cur_cycle, tdb_commit.get_uint16(DOMAIN_INPUT, "wb_commit_port_data_out.checkpoint_id", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].checkpoint_id)
                        end

                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.bru_jump", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].bru_jump)

                        if(core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].bru_jump) begin
                            `assert_equal(cur_cycle, tdb_commit.get_uint32(DOMAIN_INPUT, "wb_commit_port_data_out.bru_next_pc", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].bru_next_pc)
                        end
                        
                        `assert_equal(cur_cycle, op_t::_type'(tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.op", i)), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].op)
                        `assert_equal(cur_cycle, op_unit_t::_type'(tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.op_unit", i)), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].op_unit)
                        `assert_equal(cur_cycle, tdb_commit.get_uint8(DOMAIN_INPUT, "wb_commit_port_data_out.sub_op", i), core_top_inst.commit_inst.wb_commit_port_data_out.op_info[i].sub_op.raw_data)
                    end
                end
            end

            `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_empty", 0), core_top_inst.commit_inst.rob_commit_empty)
            `assert_equal(cur_cycle, tdb_rob.get_uint8(DOMAIN_OUTPUT, "rob_commit_full", 0), core_top_inst.commit_inst.rob_commit_full)

            //output
            if(core_top_inst.csrfile_inst.csr_write_enable[`CSR_CHARFIFO] && !(core_top_inst.csrfile_inst.csr_write_data[`CSR_CHARFIFO] & 'h80000000)) begin
                $write("%c", core_top_inst.csrfile_inst.csr_write_data[`CSR_CHARFIFO]);
            end

            wait_clk();
        end
    endtask

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tdb_fetch = new;
        tdb_decode = new;
        tdb_rename = new;
        tdb_readreg = new;
        tdb_issue = new;

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            tdb_execute_alu[i] = new;
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            tdb_execute_bru[i] = new;
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            tdb_execute_csr[i] = new;
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            tdb_execute_div[i] = new;
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            tdb_execute_lsu[i] = new;
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            tdb_execute_mul[i] = new;
        end

        tdb_wb = new;
        tdb_commit = new;
        tdb_branch_predictor = new;
        tdb_bus = new;
        tdb_checkpoint_buffer = new;
        tdb_clint = new;
        tdb_csrfile = new;
        tdb_interrupt_interface = new;
        tdb_phy_regfile = new;
        tdb_ras = new;
        tdb_rat = new;
        tdb_rob = new;
        tdb_store_buffer = new;
        tdb_tcm = new;

        tdb_fetch.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/fetch.tdb"});
        tdb_decode.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/decode.tdb"});
        tdb_rename.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/rename.tdb"});
        tdb_readreg.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/readreg.tdb"});
        tdb_issue.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/issue.tdb"});

        for(i = 0;i < `ALU_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_alu[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_alu_", str, ".tdb"});
        end

        for(i = 0;i < `BRU_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_bru[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_bru_", str, ".tdb"});
        end

        for(i = 0;i < `CSR_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_csr[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_csr_", str, ".tdb"});
        end

        for(i = 0;i < `DIV_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_div[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_div_", str, ".tdb"});
        end

        for(i = 0;i < `LSU_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_lsu[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_lsu_", str, ".tdb"});
        end

        for(i = 0;i < `MUL_UNIT_NUM;i++) begin
            str.itoa(i);
            tdb_execute_mul[i].open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/execute_mul_", str, ".tdb"});
        end

        tdb_wb.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/wb.tdb"});
        tdb_commit.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/commit.tdb"});
        tdb_branch_predictor.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/branch_predictor.tdb"});
        tdb_bus.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/bus.tdb"});
        tdb_checkpoint_buffer.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/checkpoint_buffer.tdb"});
        tdb_clint.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/clint.tdb"});
        tdb_csrfile.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/csrfile.tdb"});
        tdb_interrupt_interface.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/interrupt_interface.tdb"});
        tdb_phy_regfile.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/phy_regfile.tdb"});
        tdb_ras.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/ras.tdb"});
        tdb_rat.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/rat.tdb"});
        tdb_rob.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/rob.tdb"});
        tdb_store_buffer.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/store_buffer.tdb"});
        tdb_tcm.open({getenv("SIM_ROOT_DIR"), "/trace_fast/", getenv("SIM_TRACE_NAME"), "/tcm.tdb"});
        test();
        $display("TEST PASSED");
        $finish;
    end

    `ifdef SIMULATOR_NOT_SUPPORT_SFORMATF_AS_CONSTANT_EXPRESSION
        genvar bank_index;

        generate
            for(bank_index = 0;bank_index < `BUS_DATA_WIDTH / 8;bank_index++) begin
                initial begin
                    $readmemh({`SIM_IMAGE_NAME, $sformatf(".%0d", bank_index)}, core_top_inst.tcm_inst.fetch_mem_generate[bank_index].fetch_mem.mem_copy, 0, core_top_inst.tcm_inst.fetch_mem_generate[bank_index].fetch_mem.DEPTH - 1);
                    $readmemh({`SIM_IMAGE_NAME, $sformatf(".%0d", bank_index)}, core_top_inst.tcm_inst.stbuf_mem_generate[bank_index].stbuf_mem.mem_copy, 0, core_top_inst.tcm_inst.stbuf_mem_generate[bank_index].stbuf_mem.DEPTH - 1);
                end
            end
        endgenerate
    `endif

    `ifdef FSDB_DUMP
        initial begin
            $fsdbDumpfile("top.fsdb");
            $fsdbDumpvars(0, 0, "+all");
            $fsdbDumpMDA();
        end
    `endif
endmodule