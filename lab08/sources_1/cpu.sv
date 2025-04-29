`timescale 1ns/100ps

import typedefs::*;


module cpu #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 5)
(
    input logic  clk_,
    input logic  rst_n,
    output logic halt    
);

    logic zero, mem_rd, mem_wr, fetch;
    
    logic load_ac, load_ir, load_pc, inc_pc;
    
    logic [DATA_WIDTH-1:0] data_out;
    logic [DATA_WIDTH-1:0] accum;
    logic [DATA_WIDTH-1:0] alu_out;
    logic [DATA_WIDTH-1:0] ir_out;
    
    logic [ADDR_WIDTH-1:0] pc_addr;
    logic [ADDR_WIDTH-1:0] addr;
    
    memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) memory_ins
    (
        .clk_     (clk_),
        .mem_rd   (mem_rd),
        .mem_wr   (mem_wr), 
        .addr     (addr),
        .data_in  (alu_out),
        .data_out (data_out)
    );
    
    register #(.DATA_WIDTH(DATA_WIDTH)) accumulator_register
    (
        .clk_     (clk_),
        .rst_n    (rst_n),
        .load     (load_ac),
        .data_in  (alu_out),
        .data_out (accum)
    );
    
    register #(.DATA_WIDTH(DATA_WIDTH)) instruction_register
    (
        .clk_     (clk_),
        .rst_n    (rst_n),
        .load     (load_ir),
        .data_in  (data_out),
        .data_out (ir_out)
    );
    
    alu #(.DATA_WIDTH(DATA_WIDTH)) alu_ins
    (
        .clk_    (clk_),
        .rst_n   (rst_n),
        .data    (data_out),
        .accum   (accum),
        .opcode  (ir_out[7:5]),    
        .alu_out (alu_out),
        .zero    (zero)
    );
    
    pc #(.ADDR_WIDTH(ADDR_WIDTH)) pc_ins
    (
        .clk_    (clk_),
        .rst_n   (rst_n),
        .load_pc (load_pc),
        .inc_pc  (inc_pc),
        .ir_addr (ir_out[4:0]),
        .pc_addr (pc_addr)
    );
    
    mux #(.ADDR_WIDTH(ADDR_WIDTH)) mux_ins
    (
        .ir_addr (ir_out[4:0]),
        .pc_addr (pc_addr),
        .fetch   (fetch),
        .addr    (addr)
    );
   
    control controller(
        .clk        (clk_        ),
        .rst_n      (rst_n      ),
        .zero       (zero       ),
        .opcode     (ir_out[7:5]),
        .mem_rd     (mem_rd     ),
        .load_ir    (load_ir    ),
        .halt       (halt       ),
        .inc_pc     (inc_pc     ),
        .load_ac    (load_ac    ),
        .load_pc    (load_pc    ),
        .mem_wr     (mem_wr     ),
        .fetch      (fetch      )
    );   
    
endmodule