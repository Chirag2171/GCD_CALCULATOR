`timescale 1 ns/1 ps

module BUFFER (OUTEN, IN, OUT);
	input OUTEN;
	input [7:0] IN;
	output [7:0] OUT;
	
	assign OUT = (OUTEN == 1) ? IN : 8'bz;
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module COMPARATOR (X, Y, XeqY, XgtY);
	input [7:0] X, Y;
	output XeqY, XgtY;
	
	assign XeqY = (X == Y) ? 1 : 0;
	assign XgtY = (X > Y) ? 1 : 0;
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module GCD_CU (clk, reset, XEQY, XGTY, IN_X, IN_Y, LOAD_X, LOAD_Y, XY, OUT_DP, DONE);
	input clk, reset, XEQY, XGTY;
	output IN_X, IN_Y, LOAD_X, LOAD_Y, XY, OUT_DP, DONE;
	reg [2:0] y, Y;
	wire [1:0] XEQY_OR_XGTY;	
	parameter [2:0] S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;
	
	assign XEQY_OR_XGTY = {XEQY, XGTY};

	always @(posedge clk, posedge reset)
	begin
		if (reset)
			y <= S0;
		else
			y <= Y;
	end
	
	// State Table Implementation //
	always @(XEQY_OR_XGTY, y)
	begin
		case(y)
			S0: Y = S1;
			
			S1: begin
				case(XEQY_OR_XGTY)
					2'b00: Y = S3;
					2'b01: Y = S2;
					2'b10: Y = S4;
					2'b11: Y = S4;
				endcase
			end
			
			S2: Y = S1;
			
			S3: Y = S1;
			
			S4: Y = S4;
			
			default: Y = S0;
		endcase
	end
	
	// Output Table Implementation //
	assign IN_X = (y == S0);
	assign IN_Y = (y == S0);
	assign LOAD_X = (y == S0) | (y == S2);
	assign LOAD_Y = (y == S0) | (y == S3);
	assign XY = (y == S2);
	assign OUT_DP = (y == S4);
	assign DONE = (y == S4);
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module MUX2TO1_8BIT (A, B, sel, Y);
	input [7:0] A, B;
	input sel;
	output [7:0] Y;
	
	assign Y = (sel == 1) ? B : A;
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module REGISTER (clk, reset, LOAD, D, Q);
	input clk, reset, LOAD;
	input [7:0] D;
	output reg [7:0] Q;
	
	always @(posedge clk, posedge reset)
	begin
		if (reset)
			Q <= 8'b0;
		else if (LOAD)
			Q <= D;
	end
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module SUBTRACTOR (A, B, Y);
	input [7:0] A, B;
	output [7:0] Y;
	
	assign Y = A - B;
	
endmodule



// -------------------------------------------------------------------
// -------------------------------------------------------------------

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



// -------------------------------------------------------------------
// -------------------------------------------------------------------

module GCD_PROCESSOR (clk, reset, INPUT_X, INPUT_Y, DONE, OUTPUT);
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
