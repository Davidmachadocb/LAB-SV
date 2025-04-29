interface _if (input bit clk);
    logic qout;
    logic qin;
    logic rst_n;

    clocking cb @(posedge clk);
        default input #1step output 4ns;
        input qout;
	    output qin, rst_n;
    endclocking

endinterface