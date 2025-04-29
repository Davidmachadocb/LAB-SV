module mem_tb #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 5
) (
    input logic                  clk,
    bus.master_ports ahb
);


    initial begin
        $timeformat(-9, 0, " ns", 9);
        #40000ns $display("MEMORY TEST TIMEOUT");
        $finish;
    end

    initial begin
        int error_status = 0;
        int debug = 0;
        logic [7:0] temp_data;

        $display("Clear Memory Test");

        for (int i = 0; i < 32; i++) begin
            write_mem(i, 'b0, 'b0);
        end
        for (int i = 0; i < 32; i++) begin
            read_mem(i, temp_data, debug);
            error_status = checkit(i, temp_data, 8'h00);
        end 

        printstatus(error_status);

        $display("Data = Address Test");
        for (int i = 0; i < 32; i++)
            write_mem(i, i, debug);
        for (int i = 0; i < 32; i++) begin
            read_mem(i, temp_data, debug);
            error_status = checkit(i, temp_data, i);
        end

        printstatus(error_status);
        $finish;
    end

    // TASKS
    task write_mem(input logic [ADDR_WIDTH-1:0] in_addr, input logic [DATA_WIDTH-1:0] in_data, input logic debug);
        @(negedge clk);
        ahb.write   <= 1'b1;
        ahb.read    <= 1'b0;
        ahb.addr    <= in_addr;
        ahb.data_in <= in_data;
        @(negedge clk);
        ahb.write   <= 1'b0;
        if(debug)
            $display("Write Data | Address= %d  Data= %h", in_addr, in_data);
    endtask

    task read_mem(input logic [ADDR_WIDTH-1:0] in_addr, output logic [DATA_WIDTH-1:0] out_data, input logic debug);
        @(negedge clk);
        ahb.write   <= 1'b0;
        ahb.read    <= 1'b1;
        ahb.addr    <= in_addr;
        @(negedge clk);
        #1; // Small delay
        out_data = ahb.data_out;
        ahb.read <= 1'b0;
        if(debug)
            $display("Read Data | Address= %d  Data= %h", in_addr, out_data);
    endtask

    // FUNCTIONS
    function int checkit(input [ADDR_WIDTH-1:0] address, input [DATA_WIDTH-1:0] actual, input [DATA_WIDTH-1:0] expected);
        static int error_status = 0;
        if (actual !== expected) begin
            $display("ERROR: Address:%h Data:%h Expected:%h", address, actual, expected);
            error_status++;
        end
        return error_status;
    endfunction

    function void printstatus(input int status);
        if (status == 0)
            $display("Test Passed - No Errors!");
        else
            $display("Test Failed with %d Errors", status);
    endfunction

endmodule