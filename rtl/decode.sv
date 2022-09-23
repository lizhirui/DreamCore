`include "config.svh"
`include "common.svh"

module decode(
        input logic clk,
        input logic rst,
        
        output logic decode_csrf_decode_rename_fifo_full_add,
        
        input fetch_decode_pack_t fetch_decode_fifo_data_out[0:`DECODE_WIDTH - 1],
        input logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_out_valid,
        output logic[`DECODE_WIDTH - 1:0] fetch_decode_fifo_data_pop_valid,
        output logic fetch_decode_fifo_pop,
        
        input logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_enable,
        output decode_rename_pack_t decode_rename_fifo_data_in[0:`DECODE_WIDTH - 1],
        output logic[`DECODE_WIDTH - 1:0] decode_rename_fifo_data_in_valid,
        output logic decode_rename_fifo_push,
        output logic decode_rename_fifo_flush,
        
        output decode_feedback_pack_t decode_feedback_pack,
        input commit_feedback_pack_t commit_feedback_pack
    );
    
    fetch_decode_pack_t rev_pack[0:`DECODE_WIDTH - 1];
    decode_rename_pack_t send_pack[0:`DECODE_WIDTH - 1];

    logic[`DECODE_WIDTH - 1:0] data_in_enable;

    logic[`INSTRUCTION_WIDTH - 1:0] op_data[0:`DECODE_WIDTH - 1];
    logic[6:0] opcode[0:`DECODE_WIDTH - 1];
    logic[4:0] rd[0:`DECODE_WIDTH - 1];
    logic[2:0] funct3[0:`DECODE_WIDTH - 1];
    logic[4:0] rs1[0:`DECODE_WIDTH - 1];
    logic[4:0] rs2[0:`DECODE_WIDTH - 1];
    logic[6:0] funct7[0:`DECODE_WIDTH - 1];
    logic[11:0] imm_i[0:`DECODE_WIDTH - 1];
    logic[11:0] imm_s[0:`DECODE_WIDTH - 1];
    logic[12:0] imm_b[0:`DECODE_WIDTH - 1];
    logic[31:0] imm_u[0:`DECODE_WIDTH - 1];
    logic[20:0] imm_j[0:`DECODE_WIDTH - 1];

    genvar i;

    assign decode_feedback_pack.idle = !fetch_decode_fifo_data_out_valid;
    assign decode_rename_fifo_flush = commit_feedback_pack.enable & commit_feedback_pack.flush;
    assign decode_rename_fifo_push = 'b1;
    assign data_in_enable = fetch_decode_fifo_data_out_valid & decode_rename_fifo_data_in_enable;
    assign decode_rename_fifo_data_in_valid = data_in_enable;
    assign fetch_decode_fifo_data_pop_valid = data_in_enable;
    assign fetch_decode_fifo_pop = 'b1;

    assign rev_pack = fetch_decode_fifo_data_out;
    assign decode_rename_fifo_data_in = send_pack;

    assign decode_csrf_decode_rename_fifo_full_add = !decode_rename_fifo_flush && ((decode_rename_fifo_data_in_enable & fetch_decode_fifo_data_out_valid) != fetch_decode_fifo_data_out_valid);

    generate
        for(i = 0;i < `DECODE_WIDTH;i++) begin
            assign op_data[i] = rev_pack[i].value;
            assign opcode[i] = op_data[i][0+:7];
            assign rd[i] = op_data[i][7+:5];
            assign funct3[i] = op_data[i][12+:3];
            assign rs1[i] = op_data[i][15+:5];
            assign rs2[i] = op_data[i][20+:5];
            assign funct7[i] = op_data[i][25+:7];
            assign imm_i[i] = op_data[i][20+:12];
            assign imm_s[i] = {op_data[i][25+:7], op_data[i][7+:5]};
            assign imm_b[i] = {op_data[i][31], op_data[i][7], op_data[i][25+:6], op_data[i][8+:4], 1'b0};
            assign imm_u[i] = {op_data[i][31:12], 12'b0};
            assign imm_j[i] = {op_data[i][31], op_data[i][12+:8], op_data[i][20], op_data[i][21+:10], 1'b0};

            assign send_pack[i].enable = rev_pack[i].enable;
            assign send_pack[i].pc = rev_pack[i].pc;
            assign send_pack[i].rs1_need_map = (send_pack[i].arg1_src == arg_src_t::_reg) && (send_pack[i].rs1 != 0);
            assign send_pack[i].rs2_need_map = (send_pack[i].arg2_src == arg_src_t::_reg) && (send_pack[i].rs2 != 0);
            assign send_pack[i].need_rename = send_pack[i].rd_enable && (send_pack[i].rd != 0);
            assign send_pack[i].value = rev_pack[i].value;
            assign send_pack[i].has_exception = rev_pack[i].has_exception;
            assign send_pack[i].exception_id = rev_pack[i].exception_id;
            assign send_pack[i].exception_value = rev_pack[i].exception_value;
            assign send_pack[i].predicted = rev_pack[i].predicted;
            assign send_pack[i].predicted_jump = rev_pack[i].predicted_jump;
            assign send_pack[i].predicted_next_pc = rev_pack[i].predicted_next_pc;
            assign send_pack[i].checkpoint_id_valid = rev_pack[i].checkpoint_id_valid;
            assign send_pack[i].checkpoint_id = rev_pack[i].checkpoint_id;

            always_comb begin
                send_pack[i].op = op_t::_type'('b0);
                send_pack[i].op_unit = op_unit_t::alu;
                send_pack[i].sub_op.raw_data = 'b0;
                send_pack[i].arg1_src = arg_src_t::_disable;
                send_pack[i].rs1 = 'b0;
                send_pack[i].arg2_src = arg_src_t::_disable;
                send_pack[i].rs2 = 'b0;
                send_pack[i].imm = 'b0;
                send_pack[i].rd = 'b0;
                send_pack[i].rd_enable = 'b0;
                send_pack[i].valid = !rev_pack[i].has_exception;
                send_pack[i].csr = 'b0;

                case(opcode[i])
                    'h37: begin//lui
                        send_pack[i].op = op_t::lui;
                        send_pack[i].op_unit = op_unit_t::alu;
                        send_pack[i].sub_op.alu_op = alu_op_t::lui;
                        send_pack[i].arg1_src = arg_src_t::_disable;
                        send_pack[i].arg2_src = arg_src_t::_disable;
                        send_pack[i].imm = imm_u[i];
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;
                    end
                        

                    'h17: begin//auipc
                        send_pack[i].op = op_t::auipc;
                        send_pack[i].op_unit = op_unit_t::alu;
                        send_pack[i].sub_op.alu_op = alu_op_t::auipc;
                        send_pack[i].arg1_src = arg_src_t::_disable;
                        send_pack[i].arg2_src = arg_src_t::_disable;
                        send_pack[i].imm = imm_u[i];
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;
                    end

                    'h6f: begin//jal
                        send_pack[i].op = op_t::jal;
                        send_pack[i].op_unit = op_unit_t::bru;
                        send_pack[i].sub_op.bru_op = bru_op_t::jal;
                        send_pack[i].arg1_src = arg_src_t::_disable;
                        send_pack[i].arg2_src = arg_src_t::_disable;
                        send_pack[i].imm = sign_extend#(21)::_do(imm_j[i]);
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;
                    end

                    'h67: begin//jalr
                        send_pack[i].op = op_t::jalr;
                        send_pack[i].op_unit = op_unit_t::bru;
                        send_pack[i].sub_op.bru_op = bru_op_t::jalr;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::_disable;
                        send_pack[i].imm = sign_extend#(12)::_do(imm_i[i]);
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;
                    end

                    'h63: begin//beq bne blt bge bltu bgeu
                        send_pack[i].op_unit = op_unit_t::bru;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::_reg;
                        send_pack[i].rs2 = rs2[i];
                        send_pack[i].imm = sign_extend#(13)::_do(imm_b[i]);

                        case(funct3[i])
                            'h0: begin//beq
                                send_pack[i].op = op_t::beq;
                                send_pack[i].sub_op.bru_op = bru_op_t::beq;
                            end

                            'h1: begin//bne
                                send_pack[i].op = op_t::bne;
                                send_pack[i].sub_op.bru_op = bru_op_t::bne;
                            end

                            'h4: begin//blt
                                send_pack[i].op = op_t::blt;
                                send_pack[i].sub_op.bru_op = bru_op_t::blt;
                            end

                            'h5: begin//bge
                                send_pack[i].op = op_t::bge;
                                send_pack[i].sub_op.bru_op = bru_op_t::bge;
                            end

                            'h6: begin//bltu
                                send_pack[i].op = op_t::bltu;
                                send_pack[i].sub_op.bru_op = bru_op_t::bltu;
                            end

                            'h7: begin//bgeu
                                send_pack[i].op = op_t::bgeu;
                                send_pack[i].sub_op.bru_op = bru_op_t::bgeu;
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h03: begin//lb lh lw lbu lhu
                        send_pack[i].op_unit = op_unit_t::lsu;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::_disable;
                        send_pack[i].imm = sign_extend#(12)::_do(imm_i[i]);
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;

                        case(funct3[i])
                            'h0: begin//lb
                                send_pack[i].op = op_t::lb;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::lb;
                            end

                            'h1: begin//lh
                                send_pack[i].op = op_t::lh;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::lh;
                            end

                            'h2: begin//lw
                                send_pack[i].op = op_t::lw;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::lw;
                            end

                            'h4: begin//lbu
                                send_pack[i].op = op_t::lbu;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::lbu;
                            end

                            'h5: begin//lhu
                                send_pack[i].op = op_t::lhu;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::lhu;
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h23: begin//sb sh sw
                        send_pack[i].op_unit = op_unit_t::lsu;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::_reg;
                        send_pack[i].rs2 = rs2[i];
                        send_pack[i].imm = sign_extend#(12)::_do(imm_s[i]);

                        case(funct3[i])
                            'h0: begin//sb
                                send_pack[i].op = op_t::sb;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::sb;
                            end

                            'h1: begin//sh
                                send_pack[i].op = op_t::sh;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::sh;
                            end

                            'h2: begin//sw
                                send_pack[i].op = op_t::sw;
                                send_pack[i].sub_op.lsu_op = lsu_op_t::sw;
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h13: begin//addi slti sltiu xori ori andi slli srli srai
                        send_pack[i].op_unit = op_unit_t::alu;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::imm;
                        send_pack[i].imm = sign_extend#(12)::_do(imm_i[i]);
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;

                        case(funct3[i])
                            'h0: begin//addi
                                send_pack[i].op = op_t::addi;
                                send_pack[i].sub_op.alu_op = alu_op_t::add;
                            end

                            'h2: begin//slti
                                send_pack[i].op = op_t::slti;
                                send_pack[i].sub_op.alu_op = alu_op_t::slt;
                            end

                            'h3: begin//sltiu
                                send_pack[i].op = op_t::sltiu;
                                send_pack[i].sub_op.alu_op = alu_op_t::sltu;
                            end

                            'h4: begin//xori
                                send_pack[i].op = op_t::xori;
                                send_pack[i].sub_op.alu_op = alu_op_t::_xor;
                            end

                            'h6: begin//ori
                                send_pack[i].op = op_t::ori;
                                send_pack[i].sub_op.alu_op = alu_op_t::_or;
                            end

                            'h7: begin//andi
                                send_pack[i].op = op_t::andi;
                                send_pack[i].sub_op.alu_op = alu_op_t::_and;
                            end

                            'h1: begin//slli
                                if(funct7[i] == 'h00) begin//slli
                                    send_pack[i].op = op_t::slli;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sll;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h5: begin//srli srai
                                if(funct7[i] == 'h00) begin//srli
                                    send_pack[i].op = op_t::srli;
                                    send_pack[i].sub_op.alu_op = alu_op_t::srl;
                                end
                                else if(funct7[i] == 'h20) begin//srai
                                    send_pack[i].op = op_t::srai;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sra;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h33: begin//add sub sll slt sltu xor srl sra or and mul mulh mulhsu mulhu div divu rem remu
                        send_pack[i].op_unit = op_unit_t::alu;
                        send_pack[i].arg1_src = arg_src_t::_reg;
                        send_pack[i].rs1 = rs1[i];
                        send_pack[i].arg2_src = arg_src_t::_reg;
                        send_pack[i].rs2 = rs2[i];
                        send_pack[i].rd = rd[i];
                        send_pack[i].rd_enable = 'b1;

                        case(funct3[i])
                            'h0: begin//add sub mul
                                if(funct7[i] == 'h00) begin//add
                                    send_pack[i].op = op_t::add;
                                    send_pack[i].sub_op.alu_op = alu_op_t::add;
                                end
                                else if(funct7[i] == 'h20) begin//sub
                                    send_pack[i].op = op_t::sub;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sub;
                                end
                                else if(funct7[i] == 'h01) begin//mul
                                    send_pack[i].op = op_t::mul;
                                    send_pack[i].op_unit = op_unit_t::mul;
                                    send_pack[i].sub_op.mul_op = mul_op_t::mul;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h1: begin//sll mulh
                                if(funct7[i] == 'h00) begin//sll
                                    send_pack[i].op = op_t::sll;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sll;
                                end
                                else if(funct7[i] == 'h01) begin//mulh
                                    send_pack[i].op = op_t::mulh;
                                    send_pack[i].op_unit = op_unit_t::mul;
                                    send_pack[i].sub_op.mul_op = mul_op_t::mulh;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h2: begin//slt mulhsu
                                if(funct7[i] == 'h00) begin//slt
                                    send_pack[i].op = op_t::slt;
                                    send_pack[i].sub_op.alu_op = alu_op_t::slt;
                                end
                                else if(funct7[i] == 'h01) begin//mulhsu
                                    send_pack[i].op = op_t::mulhsu;
                                    send_pack[i].op_unit = op_unit_t::mul;
                                    send_pack[i].sub_op.mul_op = mul_op_t::mulhsu;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h3: begin//sltu mulhu
                                if(funct7[i] == 'h00) begin//sltu
                                    send_pack[i].op = op_t::sltu;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sltu;
                                end
                                else if(funct7[i] == 'h01) begin//mulhu
                                    send_pack[i].op = op_t::mulhu;
                                    send_pack[i].op_unit = op_unit_t::mul;
                                    send_pack[i].sub_op.mul_op = mul_op_t::mulhu;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h4: begin//xor div
                                if(funct7[i] == 'h00) begin//xor
                                    send_pack[i].op = op_t::_xor;
                                    send_pack[i].sub_op.alu_op = alu_op_t::_xor;
                                end
                                else if(funct7[i] == 'h01) begin//div
                                    send_pack[i].op = op_t::div;
                                    send_pack[i].op_unit = op_unit_t::div;
                                    send_pack[i].sub_op.div_op = div_op_t::div;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h5: begin//srl sra divu
                                if(funct7[i] == 'h00) begin//srl
                                    send_pack[i].op = op_t::srl;
                                    send_pack[i].sub_op.alu_op = alu_op_t::srl;
                                end
                                else if(funct7[i] == 'h20) begin//sra
                                    send_pack[i].op = op_t::sra;
                                    send_pack[i].sub_op.alu_op = alu_op_t::sra;
                                end
                                else if(funct7[i] == 'h01) begin//divu
                                    send_pack[i].op = op_t::divu;
                                    send_pack[i].op_unit = op_unit_t::div;
                                    send_pack[i].sub_op.div_op = div_op_t::divu;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end             

                            'h6: begin//or rem
                                if(funct7[i] == 'h00) begin//or
                                    send_pack[i].op = op_t::_or;
                                    send_pack[i].sub_op.alu_op = alu_op_t::_or;
                                end
                                else if(funct7[i] == 'h01) begin//rem
                                    send_pack[i].op = op_t::rem;
                                    send_pack[i].op_unit = op_unit_t::div;
                                    send_pack[i].sub_op.div_op = div_op_t::rem;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h7: begin//and remu
                                if(funct7[i] == 'h00) begin//and
                                    send_pack[i].op = op_t::_and;
                                    send_pack[i].sub_op.alu_op = alu_op_t::_and;
                                end
                                else if(funct7[i] == 'h01) begin//remu
                                    send_pack[i].op = op_t::remu;
                                    send_pack[i].op_unit = op_unit_t::div;
                                    send_pack[i].sub_op.div_op = div_op_t::remu;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h0f: begin//fence fence.i
                        case(funct3[i])
                            'h0: begin//fence
                                if((rd[i] == 'h00) && (rs1[i] == 'h00) && (op_data[i][31:28] == 'h00)) begin//fence
                                    send_pack[i].op = op_t::fence;
                                    send_pack[i].op_unit = op_unit_t::alu;
                                    send_pack[i].sub_op.alu_op = alu_op_t::fence;
                                    send_pack[i].arg1_src = arg_src_t::_disable;
                                    send_pack[i].arg2_src = arg_src_t::_disable;
                                    send_pack[i].imm = imm_i[i];
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h1: begin//fence.i
                                if((rd[i] == 'h00) && (rs1[i] == 'h00) && (imm_i[i] == 'h00)) begin//fence.i
                                    send_pack[i].op = op_t::fence_i;
                                    send_pack[i].op_unit = op_unit_t::alu;
                                    send_pack[i].sub_op.alu_op = alu_op_t::fence_i;
                                    send_pack[i].arg1_src = arg_src_t::_disable;
                                    send_pack[i].arg2_src = arg_src_t::_disable;
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    'h73: begin//ecall ebreak csrrw csrrs csrrc csrrwi csrrsi csrrci mret
                        case(funct3[i])
                            'h0: begin//ecall ebreak mret
                                if((rd[i] == 'h00) && (rs1[i] == 'h00)) begin//ecall ebreak mret
                                    case(funct7[i])
                                        'h00: begin//ecall ebreak
                                            case(rs2[i])
                                                'h00: begin//ecall
                                                    send_pack[i].op = op_t::ecall;
                                                    send_pack[i].op_unit = op_unit_t::alu;
                                                    send_pack[i].sub_op.alu_op = alu_op_t::ecall;
                                                    send_pack[i].arg1_src = arg_src_t::_disable;
                                                    send_pack[i].arg2_src = arg_src_t::_disable;
                                                end

                                                'h01: begin//ebreak
                                                    send_pack[i].op = op_t::ebreak;
                                                    send_pack[i].op_unit = op_unit_t::alu;
                                                    send_pack[i].sub_op.alu_op = alu_op_t::ebreak;
                                                    send_pack[i].arg1_src = arg_src_t::_disable;
                                                    send_pack[i].arg2_src = arg_src_t::_disable;
                                                end

                                                default: begin//invalid
                                                    send_pack[i].valid = 'b0;
                                                end
                                            endcase
                                        end

                                        'h18: begin//mret
                                            case(rs2[i])
                                                'h02: begin//mret
                                                    send_pack[i].op = op_t::mret;
                                                    send_pack[i].op_unit = op_unit_t::bru;
                                                    send_pack[i].sub_op.bru_op = bru_op_t::mret;
                                                    send_pack[i].arg1_src = arg_src_t::_disable;
                                                    send_pack[i].arg2_src = arg_src_t::_disable;
                                                end

                                                default: begin//invalid
                                                    send_pack[i].valid = 'b0;
                                                end
                                            endcase
                                        end
                            
                                        default: begin//invalid
                                            send_pack[i].valid = 'b0;
                                        end
                                    endcase
                                end
                                else begin//invalid
                                    send_pack[i].valid = 'b0;
                                end
                            end

                            'h1: begin//csrrw
                                send_pack[i].op = op_t::csrrw;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrw;
                                send_pack[i].arg1_src = arg_src_t::_reg;
                                send_pack[i].rs1 = rs1[i];
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            'h2: begin//csrrs
                                send_pack[i].op = op_t::csrrs;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrs;
                                send_pack[i].arg1_src = arg_src_t::_reg;
                                send_pack[i].rs1 = rs1[i];
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            'h3: begin//csrrc
                                send_pack[i].op = op_t::csrrc;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrc;
                                send_pack[i].arg1_src = arg_src_t::_reg;
                                send_pack[i].rs1 = rs1[i];
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            'h5: begin//csrrwi
                                send_pack[i].op = op_t::csrrwi;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrw;
                                send_pack[i].arg1_src = arg_src_t::imm;
                                send_pack[i].imm = rs1[i];//zimm
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            'h6: begin//csrrsi
                                send_pack[i].op = op_t::csrrsi;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrs;
                                send_pack[i].arg1_src = arg_src_t::imm;
                                send_pack[i].imm = rs1[i];//zimm
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            'h7: begin//csrrci
                                send_pack[i].op = op_t::csrrci;
                                send_pack[i].op_unit = op_unit_t::csr;
                                send_pack[i].sub_op.csr_op = csr_op_t::csrrc;
                                send_pack[i].arg1_src = arg_src_t::imm;
                                send_pack[i].imm = rs1[i];//zimm
                                send_pack[i].arg2_src = arg_src_t::_disable;
                                send_pack[i].csr = imm_i[i];
                                send_pack[i].rd = rd[i];
                                send_pack[i].rd_enable = 'b1;
                            end

                            default: begin//invalid
                                send_pack[i].valid = 'b0;
                            end
                        endcase
                    end

                    default: begin//invalid
                        send_pack[i].valid = 'b0;
                    end
                endcase
            end
        end
    endgenerate
endmodule