`timescale 1ns/100ps

module pc #(parameter ADDR_WIDTH = 5)
(
    input  logic                   clk_,
    input  logic                   rst_n,
    input  logic                   load_pc,
    input  logic                   inc_pc,
    input  logic [ADDR_WIDTH-1:0]  ir_addr,
    output logic [ADDR_WIDTH-1:0]  pc_addr
);

    always_ff @(posedge clk_ or negedge rst_n) begin
        if(!rst_n)
            pc_addr <= '0;
        else begin
            if (load_pc)
                pc_addr <= ir_addr;
            else if (inc_pc)
                pc_addr <= pc_addr + 1;
            else
                pc_addr <= pc_addr;
        end
    end

endmodule