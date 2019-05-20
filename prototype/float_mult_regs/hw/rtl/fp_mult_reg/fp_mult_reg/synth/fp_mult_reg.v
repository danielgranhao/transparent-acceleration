// fp_mult_reg.v

// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module fp_mult_reg (
		input  wire        aclr,   //   aclr.aclr
		input  wire [31:0] ay,     //     ay.ay
		input  wire [31:0] az,     //     az.az
		input  wire        clk,    //    clk.clk
		input  wire        ena,    //    ena.ena
		output wire [31:0] result  // result.result
	);

	fp_mult_reg_altera_fpdsp_block_160_e4wbm5a fpdsp_block_0 (
		.clk    (clk),    //    clk.clk
		.ena    (ena),    //    ena.ena
		.aclr   (aclr),   //   aclr.aclr
		.result (result), // result.result
		.ay     (ay),     //     ay.ay
		.az     (az)      //     az.az
	);

endmodule
