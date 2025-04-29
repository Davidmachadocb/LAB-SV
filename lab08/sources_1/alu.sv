`timescale 1ns/100ps
import typedefs ::*;

module alu #(parameter DATA_WIDTH =8) (
    input logic                   clk_,
    input logic                   rst_n,
    input logic  [DATA_WIDTH-1:0] accum,
    input logic  [DATA_WIDTH-1:0] data,
    input opcode_t                opcode,
    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero
);

    always_ff @( negedge clk_ ) begin

        case (opcode)
            HLT:     alu_out <= accum;
            SKZ:     alu_out <= accum;
            ADD:     alu_out <= data + accum;
            AND:     alu_out <= data & accum;
            XOR:     alu_out <= data ^ accum;
            LDA:     alu_out <= data;
            STO:     alu_out <= accum;
            JMP:     alu_out <= accum;
        endcase

    end 

    // alu.sv (corrected)
    always_comb begin
        if (accum == 8'b0)  zero = 1'b1;
        else                  zero = 1'b0;
    end 

endmodule