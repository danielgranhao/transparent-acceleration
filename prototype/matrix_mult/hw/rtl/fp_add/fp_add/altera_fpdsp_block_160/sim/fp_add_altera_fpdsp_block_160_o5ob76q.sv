module fp_add_altera_fpdsp_block_160_o5ob76q  (
    input  wire                          clk,
    input  wire                          ena,
    input  wire                          aclr,
    input  wire [31:0]                   ax,
    input  wire [31:0]                   ay,
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
    .ax_clock("0"),
    .ay_clock("0"),
    .az_clock("NONE"),
    .output_clock("0"),
    .accumulate_clock("NONE"),
    .ax_chainin_pl_clock("NONE"),
    .accum_pipeline_clock("NONE"),
    .mult_pipeline_clock("NONE"),
    .adder_input_clock("0"),
    .accum_adder_clock("NONE"),
    .use_chainin("false"),
    .operation_mode("sp_add"),
    .adder_subtract("false")
) sp_add (
    .clk({1'b0,1'b0,clk_vec[0]}),
    .ena({1'b0,1'b0,ena_vec[0]}),
    .aclr(aclr_vec),
    .ax(ax),
    .ay(ay),

    .chainin(32'b0),
    .resulta(result),
    .chainout()
);
endmodule

