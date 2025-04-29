`timescale 1ns/100ps
import typedefs::*;

module control 
(
    input opcode_t opcode,
    input  logic zero,
    input  logic clk,
    input  logic rst_,
    output logic fetch, //se liga no fetch aqui
    output logic mem_rd,
    output logic load_ir,
    output logic halt,
    output logic inc_pc,
    output logic load_ac,
    output logic load_pc,
    output logic mem_wr
);

    state_t state;

    always_ff @(posedge clk or negedge rst_) begin
        if (!rst_)
            state <= INST_ADDR;
        else
            state <= state.next();
    end

    logic aluop;
    assign aluop = (opcode inside {ADD, AND, XOR, LDA});

    always_comb begin
        case (state)
            INST_ADDR: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                fetch = 1'b0;
            end

            INST_FETCH: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                if (opcode == JMP)
                    fetch = 1'b1;
            end

            INST_LOAD: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            end

            IDLE: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            end

            OPP_ADDR: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {1'b0, 1'b0, (opcode == HLT), 1'b1, 1'b0, 1'b0, 1'b0};
            end

            OP_FETCH: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {aluop, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
                if (aluop)
                    fetch = 1'b1;
            end

            ALU_OP: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {aluop, 1'b0, 1'b0, ((SKZ == opcode) && zero), aluop, (opcode == JMP), 1'b0};
                if (aluop)
                    fetch = 1'b1;
            end

            STORE: begin
                {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = {aluop, 1'b0, 1'b0, (JMP == opcode), aluop, (opcode == JMP), (STO == opcode)};
            end
        endcase
    end

endmodule
