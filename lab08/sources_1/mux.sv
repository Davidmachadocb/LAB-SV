`timescale 1ns/100ps


module mux #(parameter ADDR_WIDTH = 5)
(
    input logic  [ADDR_WIDTH-1:0] ir_addr,
    input logic  [ADDR_WIDTH-1:0] pc_addr,
    input logic                   fetch,
    output logic [ADDR_WIDTH-1:0] addr
    
);

    always_comb begin
        if(fetch==1)
            addr <= ir_addr;
        else
            addr <= pc_addr;
    end

endmodule
