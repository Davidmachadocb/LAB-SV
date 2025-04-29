module mem #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 5) (
    input  logic clk,
    bus.slave_ports ahb
);

    logic [(2**ADDR_WIDTH)-1:0] [DATA_WIDTH-1:0] mem_block;

    always_ff @( posedge clk ) begin
        if(ahb.write && !ahb.read)
            mem_block[ahb.addr] <= ahb.data_in;
        if(!ahb.write && ahb.read)
            ahb.data_out <= mem_block[ahb.addr];
    end    

endmodule