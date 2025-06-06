`timescale 1ns/100ps

module counter_tb;

    logic           clk = 1'b1;
    logic           rst_n;
    logic           load;
    logic           enable;
    logic   [4:0]   data;
    logic   [4:0]   count;

    `define PERIOD 10
    always #(`PERIOD/2) clk = ~clk;

    // counter instance
    counter #(.DATA_WIDTH (5)) dut_counter(
        .clk    (clk    ),
        .rst_n  (rst_n ),
        .enable (enable ),
        .load   (load   ),
        .data   (data   ),
        .count  (count  )
    );

    // Monitor Results
    initial begin
        $timeformat(-9, 0, "ns", 6 );
        $monitor("time=%t clk=%b rst_n=%b load=%b enable=%b data=%5d count=%5d", $time, clk, rst_n ,load, enable, data, count);
        #(`PERIOD * 99)
        $display("COUNTER TEST TIMEOUT");
        $finish;
    end

    // Verify Results
    task expect_test;
        input [4:0] expects;
        if ( count !== expects ) begin
            $display ( "count=%b should be %b", count, expects );
            $display ( "COUNTER TEST FAILED" );
            $finish;
        end
    endtask

    initial begin
        @ ( negedge clk )                  
        // check reset
        { rst_n, load, enable, data } = 8'b0_X_X_XXXXX; @(negedge clk) expect_test ( 5'h00 );
        // count 4 enabled cycles
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h01 );
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h02 );
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h03 );
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h04 );
        // check disabled
        { rst_n, load, enable, data } = 8'b1_0_0_XXXXX; @(negedge clk) expect_test ( 5'h04 );
        { rst_n, load, enable, data } = 8'b1_0_0_XXXXX; @(negedge clk) expect_test ( 5'h04 );
        // check load
        { rst_n, load, enable, data } = 8'b1_1_0_10101; @(negedge clk) expect_test ( 5'h15 );
        // check load and enable (load should have precedence)
        { rst_n, load, enable, data } = 8'b1_1_1_11101; @(negedge clk) expect_test ( 5'h1D );
        // count from load
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h1E );
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h1F );
        // check roll-over count
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h00 );
        { rst_n, load, enable, data } = 8'b1_0_1_XXXXX; @(negedge clk) expect_test ( 5'h01 );
        $display ( "COUNTER TEST PASSED" );
        $finish;
    end

    initial begin
        $dumpfile("lab_03/lab_03.vcd");
        $dumpvars(0, counter_tb);
    end

endmodule