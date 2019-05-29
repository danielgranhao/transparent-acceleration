
module fp_mult_accumulate (
	accumulate,
	aclr,
	ay,
	az,
	clk,
	ena,
	result);	

	input		accumulate;
	input		aclr;
	input	[31:0]	ay;
	input	[31:0]	az;
	input		clk;
	input		ena;
	output	[31:0]	result;
endmodule
