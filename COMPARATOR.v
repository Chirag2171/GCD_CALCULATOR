module COMPARATOR (X, Y, XeqY, XgtY);
	input [7:0] X, Y;
	output XeqY, XgtY;
	
	assign XeqY = (X == Y) ? 1 : 0;
	assign XgtY = (X > Y) ? 1 : 0;
	
endmodule
