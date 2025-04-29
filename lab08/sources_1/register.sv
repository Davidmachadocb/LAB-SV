`timescale 1ns/100ps

module register #(parameter DATA_WIDTH = 8)
(
    input  logic clk_,
    input  logic rst_n,
    input  logic load,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    always_ff @(posedge clk_ or negedge rst_n) begin
        if (!rst_n)      
            data_out <= 'b0;
        else if (load)   
            data_out <= data_in;
    end

endmodule