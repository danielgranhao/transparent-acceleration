// fp_mult.v

// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module fp_mult (
		input  wire [1:0]  aclr,   //   aclr.aclr
		input  wire [31:0] ay,     //     ay.ay
		input  wire [31:0] az,     //     az.az
		output wire [31:0] result  // result.result
	);

	fp_mult_altera_fpdsp_block_160_4mzrtia fpdsp_block_0 (
		.aclr   (aclr),   //   aclr.aclr
		.result (result), // result.result
		.ay     (ay),     //     ay.ay
		.az     (az)      //     az.az
	);

endmodule