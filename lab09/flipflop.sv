module flipflop #(parameter DATA_WIDTH = 8)
(
    input logic                   clk,
    input logic                   rst_n,
    input logic  [DATA_WIDTH-1:0] d,
    output logic [DATA_WIDTH-1:0] q
);
    always_ff @(posedge clk or rst_n) begin
        if(!rst_n)  q <= 'b0;
        else        q <= d;
    end    
endmodule