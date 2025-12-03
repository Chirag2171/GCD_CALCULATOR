GCD_PROCESSOR (clk, reset, INPUT_X, INPUT_Y, DONE, OUTPUT);
	input wire clk, reset;
	input wire [7:0] INPUT_X, INPUT_Y;
	output wire DONE;
	output wire [7:0] OUTPUT;
	wire IN_X, IN_Y, LOAD_X, LOAD_Y, XY, OUT_DP, XEQY, XGTY;
	
	GCD_DP myGCD_DP (
		.clk(clk), 
		.reset(reset), 
		.INPUT_X(INPUT_X), 
		.INPUT_Y(INPUT_Y), 
		.IN_X(IN_X), 
		.IN_Y(IN_Y), 
		.LOAD_X(LOAD_X), 
		.LOAD_Y(LOAD_Y), 
		.XY(XY), 
		.OUT_DP(OUT_DP), 
		.XEQY(XEQY), 
		.XGTY(XGTY), 
		.OUTPUT(OUTPUT)
	);
	
	GCD_CU myGCD_CU (
		.clk(clk), 
		.reset(reset), 
		.XEQY(XEQY), 
		.XGTY(XGTY), 
		.IN_X(IN_X), 
		.IN_Y(IN_Y), 
		.LOAD_X(LOAD_X), 
		.LOAD_Y(LOAD_Y), 
		.XY(XY), 
		.OUT_DP(OUT_DP), 
		.DONE(DONE)
	);
	
endmodule
