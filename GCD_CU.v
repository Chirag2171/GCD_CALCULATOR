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
