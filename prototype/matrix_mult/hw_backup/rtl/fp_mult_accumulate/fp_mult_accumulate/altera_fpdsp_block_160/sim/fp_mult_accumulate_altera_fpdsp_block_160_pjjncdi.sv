module fp_mult_accumulate_altera_fpdsp_block_160_pjjncdi  (
    input  wire                          clk,
    input  wire                          ena,
    input  wire                          aclr,
    input  wire                          accumulate,
    input  wire [31:0]                   ay,
    input  wire [31:0]                   az,
    output wire [31:0]                   result

	);
    wire [1-1:0] clk_vec;
    wire [1-1:0] ena_vec;
    wire [1:0]                   aclr_vec;
    assign clk_vec[0] = clk;
    assign ena_vec[0] = ena;
    assign aclr_vec[1] = aclr;
    assign aclr_vec[0] = aclr;

twentynm_fp_mac  #(
    .ax_clock("NONE"),
    .ay_clock("0"),
    .az_clock("0"),
    .output_clock("0"),
    .accumulate_clock("0"),
    .ax_chainin_pl_clock("NONE"),
    .accum_pipeline_clock("0"),
    .mult_pipeline_clock("0"),
    .adder_input_clock("0"),
    .accum_adder_clock("0"),
    .use_chainin("false"),
    .operation_mode("sp_mult_acc"),
    .adder_subtract("false")
) sp_mult_acc (
    .clk({1'b0,1'b0,clk_vec[0]}),
    .ena({1'b0,1'b0,ena_vec[0]}),
    .aclr(aclr_vec),
    .accumulate(accumulate),
    .ay(ay),
    .az(az),

    .chainin(32'b0),
    .resulta(result),
    .chainout()
);
endmodule

