module BUFFER (OUTEN, IN, OUT);
	input OUTEN;
	input [7:0] IN;
	output [7:0] OUT;
	
	assign OUT = (OUTEN == 1) ? IN : 8'bz;
	
endmodule
