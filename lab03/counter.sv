`timescale 1ns / 1ps

module counter #(parameter DATA_WIDTH = 5)(
    input logic [DATA_WIDTH-1:0] data,
    input logic load,
    input logic enable,
    input logic clk,
    input logic rst_n,
    output logic [DATA_WIDTH-1:0] count
    );

    always_ff @( posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
            count <= 0;
        end else
            if (load)
                count <= data;
            else if (enable)
                count <= count + 1;
            else
                count <= count; 
    end

endmodule
