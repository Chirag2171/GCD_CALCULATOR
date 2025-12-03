
module GCD_DP (clk, reset, INPUT_X, INPUT_Y, IN_X, IN_Y, LOAD_X, LOAD_Y, XY, OUT_DP, XEQY, XGTY, OUTPUT);
	input wire clk, reset, IN_X, IN_Y, LOAD_X, LOAD_Y, XY, OUT_DP;
	input wire [7:0] INPUT_X, INPUT_Y;
	output wire XEQY, XGTY;
	output wire [7:0] OUTPUT;
	wire [7:0] SUBTRACTOR_OUT, MUX_X, MUX_Y, X, Y, SUBT_A, SUBT_B;
	
	MUX2TO1_8BIT UNIT_1 (
		.A(SUBTRACTOR_OUT), 
		.B(INPUT_X), 
		.sel(IN_X), 
		.Y(MUX_X)
	);
	
	MUX2TO1_8BIT UNIT_2 (
		.A(SUBTRACTOR_OUT), 
		.B(INPUT_Y), 
		.sel(IN_Y), 
		.Y(MUX_Y)
	);
	
	REGISTER UNIT_3 (
		.clk(clk), 
		.reset(reset), 
		.LOAD(LOAD_X), 
		.D(MUX_X), 
		.Q(X)
	);
	
	REGISTER UNIT_4 (
		.clk(clk), 
		.reset(reset), 
		.LOAD(LOAD_Y), 
		.D(MUX_Y), 
		.Q(Y)
	);
	
	COMPARATOR UNIT_5 (
		.X(X), 
		.Y(Y), 
		.XeqY(XEQY), 
		.XgtY(XGTY)
	);
	
	MUX2TO1_8BIT UNIT_6 (
		.A(Y), 
		.B(X), 
		.sel(XY), 
		.Y(SUBT_A)
	);
	
	MUX2TO1_8BIT UNIT_7 (
		.A(X), 
		.B(Y), 
		.sel(XY), 
		.Y(SUBT_B)
	);
	
	SUBTRACTOR UNIT_8 (
		.A(SUBT_A), 
		.B(SUBT_B), 
		.Y(SUBTRACTOR_OUT)
	);
	
	BUFFER UNIT_9 (
		.OUTEN(OUT_DP), 
		.IN(X), 
		.OUT(OUTPUT)
	);
	
endmodule
