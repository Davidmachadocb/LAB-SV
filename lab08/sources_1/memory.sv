`timescale 1ns/100ps

module memory #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 5) 
(
    input logic                   clk_,
    input logic                   mem_rd,
    input logic                   mem_wr,
    input logic [ADDR_WIDTH-1:0]  addr,
    input logic [DATA_WIDTH-1:0]  data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    logic [DATA_WIDTH-1:0] mem_block [0:(2**ADDR_WIDTH)-1];

    always_ff @(posedge clk_) begin
    
        if(mem_wr==1 && mem_rd == 0)
            mem_block[addr] <= data_in;
        else if(mem_wr == 0 && mem_rd == 1)
            data_out <= mem_block[addr];
    end

endmodule