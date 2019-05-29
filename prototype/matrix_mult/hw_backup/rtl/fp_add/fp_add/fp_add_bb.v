
module fp_add (
	aclr,
	ax,
	ay,
	clk,
	ena,
	result);	

	input		aclr;
	input	[31:0]	ax;
	input	[31:0]	ay;
	input		clk;
	input		ena;
	output	[31:0]	result;
endmodule
