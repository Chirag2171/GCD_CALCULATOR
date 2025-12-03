module MUX2TO1_8BIT (A, B, sel, Y);
	input [7:0] A, B;
	input sel;
	output [7:0] Y;
	
	assign Y = (sel == 1) ? B : A;
	
endmodule
