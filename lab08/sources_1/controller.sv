`timescale 1ns/100ps
import typedefs::*;

module control 
(
    input  opcode_t opcode,
    input  logic    zero,
    input  logic    clk,
    input  logic    rst_n,
    output logic    fetch,    // se liga no fetch aqui
    output logic    mem_rd,
    output logic    load_ir,
    output logic    halt,
    output logic    inc_pc,
    output logic    load_ac,
    output logic    load_pc,
    output logic    mem_wr
);

    state_t state = INST_ADDR; 
    state_t next_state;
    logic   aluop;

    always_comb begin
        next_state = state;
        case (state)
            INST_ADDR: next_state = INST_FETCH;
            INST_FETCH: next_state = INST_LOAD;
            INST_LOAD: next_state = IDLE;
            IDLE: next_state = OP_ADDR;
            OP_ADDR: begin
                if (opcode == HLT)
                    next_state = state; // Stay in current state if HLT
                else
                    next_state = OP_FETCH;
            end
            OP_FETCH: next_state = ALU_OP;
            ALU_OP: next_state = STORE;
            STORE: next_state = INST_ADDR;
        endcase  
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= INST_ADDR;
        else        state <= next_state;
    end

    always_comb begin
        // Default assignments
        mem_rd   = 1'b0;
        load_ir  = 1'b0;
        halt     = 1'b0;
        inc_pc   = 1'b0;
        load_ac  = 1'b0;
        load_pc  = 1'b0;
        mem_wr   = 1'b0;
        fetch    = 1'b0;

        assign aluop = (opcode inside {ADD, AND, XOR, LDA});

        case (state)
            INST_ADDR: begin
                // All outputs already default to 0
            end

            INST_FETCH: begin
                mem_rd = 1'b1;
                if (opcode == JMP) fetch = 1'b1;
            end

            INST_LOAD: begin
                mem_rd  = 1'b1;
                load_ir = 1'b1;
            end

            IDLE: begin
                mem_rd  = 1'b1;
                load_ir = 1'b1;
            end


            OP_ADDR: begin
                halt = (opcode == HLT);
                inc_pc = (opcode != HLT); // Only increment PC if not HLT
            end



            OP_FETCH: begin
                mem_rd = aluop;
                if (aluop) fetch = 1'b1;
            end

            ALU_OP: begin
                mem_rd  = aluop;
                inc_pc  = ((SKZ == opcode) && zero);
                //load_ac = aluop;
                load_pc = (opcode == JMP);
                if (aluop) fetch = 1'b1;
            end
    
            STORE: begin
                mem_rd  = aluop;
                inc_pc  = (JMP == opcode);
                load_ac = aluop;
                load_pc = (opcode == JMP);
                fetch = (opcode == STO); // Ativa o fetch para capturar o endereço do IR
                mem_wr  = (STO == opcode);
            end 


        endcase
    end

endmodule