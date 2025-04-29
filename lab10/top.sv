`timescale 1ns/1ps

module top;
    // Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;
    
    // Clock signal
    logic clk;

    // Instantiate bus interface
    bus ahb_if (clk);

    // Instantiate sigma
    mem_tb #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) tb (
        .clk(clk),
        .ahb(ahb_if.master_ports)
    );

    // Instantiate beta
    mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .ahb(ahb_if.slave_ports)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

endmodule
