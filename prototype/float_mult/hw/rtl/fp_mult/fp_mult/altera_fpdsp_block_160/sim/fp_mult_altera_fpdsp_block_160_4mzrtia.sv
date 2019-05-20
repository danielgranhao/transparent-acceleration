module fp_mult_altera_fpdsp_block_160_4mzrtia  (
    input  wire [1:0]                    aclr,
    input  wire [31:0]                   ay,
    input  wire [31:0]                   az,
    output wire [31:0]                   result

	);

twentynm_fp_mac  #(
    .ax_clock("NONE"),
    .ay_clock("NONE"),
    .az_clock("NONE"),
    .output_clock("NONE"),
    .accumulate_clock("NONE"),
    .ax_chainin_pl_clock("NONE"),
    .accum_pipeline_clock("NONE"),
    .mult_pipeline_clock("NONE"),
    .adder_input_clock("0"),
    .accum_adder_clock("NONE"),
    .use_chainin("false"),
    .operation_mode("sp_mult"),
    .adder_subtract("false")
) sp_mult (
    .clk({1'b0,1'b0,1'b0}),
    .ena({1'b0,1'b0,1'b0}),
    .aclr(aclr),
    .ay(ay),
    .az(az),

    .chainin(32'b0),
    .resulta(result),
    .chainout()
);
endmodule

