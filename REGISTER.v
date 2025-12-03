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
