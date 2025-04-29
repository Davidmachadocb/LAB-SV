`timescale 1ns/100ps

interface bus(
    input logic clk
        
);
    
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 5;    

    logic read;
    logic write;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
    
    modport leader_ports (
        input data_out,
        output read, write, addr, data_in
    );
    
    modport follower_ports(
        input read, write, addr, data_in,
        output data_out
    );
    
endinterface: bus