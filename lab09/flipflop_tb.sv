`timescale 1ns/1ps
module flipflop_test;
  // ---------------------------------------------------------------------------
  // Signals
  // ---------------------------------------------------------------------------
  logic         clk;
  logic         rst_n;
  logic  [7:0]  qin;
  logic  [7:0]  qout;
  
  // ---------------------------------------------------------------------------
  // Instantiate the DUT (flipflop)
  // ---------------------------------------------------------------------------
  flipflop dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .d      (qin),
    .q      (qout)
  );
  
  // ---------------------------------------------------------------------------
  // Clock Generation
  // ---------------------------------------------------------------------------
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk; // 10 ns period (adjust as needed)
  end
  
  // ---------------------------------------------------------------------------
  // Clocking Block
  // ---------------------------------------------------------------------------
  clocking cb @(posedge clk);
    default input  #1ns;   // signals we read are sampled slightly after clock edge
    default output #3ns;    // signals we drive are driven 2ns after clock edge
    input  qout;            // read the DUT output
    output qin;             // drive the DUT input
  endclocking
  
  // ---------------------------------------------------------------------------
  // Test Stimulus
  // ---------------------------------------------------------------------------
  initial begin
    // 1) Drive rst_n = 1 initially
    rst_n = 1'b1;
    
    // 2) After 3 rising edges, drive rst_n high, then one more edge later drive it low
    @(posedge clk);  // 1st clock edge
    @(posedge clk);  // 2nd clock edge
    @(posedge clk);  // 3rd clock edge
    rst_n = 1'b0;   // set rst_n = 0 
    @(posedge clk);  // 4th clock edge
    rst_n = 1'b1;   // set rst_n = 1 again
    
    // 3) Create a loop that drives new data on qin in every cycle
    for (int i = 0; i < 16; i++) begin
      @cb;          // Wait for the next rising edge of clk (via clocking block)
      cb.qin <= i;   // Drive a new value on qin each cycle
    end
    
    // 4) Finish after a little delay
    #20;
    $finish;
  end
endmodule