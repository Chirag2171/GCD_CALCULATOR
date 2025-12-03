`timescale 1 ns/1 ps

module GCD_PROCESSOR_TB;
	// Defining the signals //
	reg clk, reset;
	reg [7:0] INPUT_X, INPUT_Y;
	wire DONE;
	wire [7:0] OUTPUT;

	// Instantiating the GCD Processor core //
	GCD_PROCESSOR DUT(clk, reset, INPUT_X, INPUT_Y, DONE, OUTPUT);

	// Generating the clock signal //
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	// Performing the simulation //
	initial begin
		reset = 1; #2;
		INPUT_X = 8'd4; INPUT_Y = 8'd12; reset = 0; #2000;
		$stop;
	end

	// Dumping the VCD file //
	initial begin 
		$dumpfile("GCD_PROCESSOR_SIM.vcd");
		$dumpvars();
	end 
	
endmodule
