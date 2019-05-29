// Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Altera and sold by Altera or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// VENDOR "Altera"
// PROGRAM "Quartus Prime"
// VERSION "Version 16.0.0 Build 211 04/27/2016 SJ Pro Edition"

// DATE "05/21/2019 14:30:38"

// 
// Device: Altera 10AS016C3U19E2LG Package UFBGA484
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module fp_mult_accumulate (
	result,
	accumulate,
	aclr,
	ay,
	az,
	clk,
	ena)/* synthesis synthesis_greybox=0 */;
output 	[31:0] result;
input 	accumulate;
input 	aclr;
input 	[31:0] ay;
input 	[31:0] az;
input 	clk;
input 	ena;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \fpdsp_block_0|result[0] ;
wire \fpdsp_block_0|result[1] ;
wire \fpdsp_block_0|result[2] ;
wire \fpdsp_block_0|result[3] ;
wire \fpdsp_block_0|result[4] ;
wire \fpdsp_block_0|result[5] ;
wire \fpdsp_block_0|result[6] ;
wire \fpdsp_block_0|result[7] ;
wire \fpdsp_block_0|result[8] ;
wire \fpdsp_block_0|result[9] ;
wire \fpdsp_block_0|result[10] ;
wire \fpdsp_block_0|result[11] ;
wire \fpdsp_block_0|result[12] ;
wire \fpdsp_block_0|result[13] ;
wire \fpdsp_block_0|result[14] ;
wire \fpdsp_block_0|result[15] ;
wire \fpdsp_block_0|result[16] ;
wire \fpdsp_block_0|result[17] ;
wire \fpdsp_block_0|result[18] ;
wire \fpdsp_block_0|result[19] ;
wire \fpdsp_block_0|result[20] ;
wire \fpdsp_block_0|result[21] ;
wire \fpdsp_block_0|result[22] ;
wire \fpdsp_block_0|result[23] ;
wire \fpdsp_block_0|result[24] ;
wire \fpdsp_block_0|result[25] ;
wire \fpdsp_block_0|result[26] ;
wire \fpdsp_block_0|result[27] ;
wire \fpdsp_block_0|result[28] ;
wire \fpdsp_block_0|result[29] ;
wire \fpdsp_block_0|result[30] ;
wire \fpdsp_block_0|result[31] ;
wire \~GND~combout ;

wire [31:0] \fpdsp_block_0|sp_mult_acc_RESULTA_bus ;

assign \fpdsp_block_0|result[0]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [0];
assign \fpdsp_block_0|result[1]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [1];
assign \fpdsp_block_0|result[2]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [2];
assign \fpdsp_block_0|result[3]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [3];
assign \fpdsp_block_0|result[4]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [4];
assign \fpdsp_block_0|result[5]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [5];
assign \fpdsp_block_0|result[6]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [6];
assign \fpdsp_block_0|result[7]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [7];
assign \fpdsp_block_0|result[8]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [8];
assign \fpdsp_block_0|result[9]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [9];
assign \fpdsp_block_0|result[10]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [10];
assign \fpdsp_block_0|result[11]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [11];
assign \fpdsp_block_0|result[12]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [12];
assign \fpdsp_block_0|result[13]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [13];
assign \fpdsp_block_0|result[14]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [14];
assign \fpdsp_block_0|result[15]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [15];
assign \fpdsp_block_0|result[16]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [16];
assign \fpdsp_block_0|result[17]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [17];
assign \fpdsp_block_0|result[18]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [18];
assign \fpdsp_block_0|result[19]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [19];
assign \fpdsp_block_0|result[20]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [20];
assign \fpdsp_block_0|result[21]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [21];
assign \fpdsp_block_0|result[22]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [22];
assign \fpdsp_block_0|result[23]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [23];
assign \fpdsp_block_0|result[24]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [24];
assign \fpdsp_block_0|result[25]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [25];
assign \fpdsp_block_0|result[26]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [26];
assign \fpdsp_block_0|result[27]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [27];
assign \fpdsp_block_0|result[28]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [28];
assign \fpdsp_block_0|result[29]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [29];
assign \fpdsp_block_0|result[30]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [30];
assign \fpdsp_block_0|result[31]  = \fpdsp_block_0|sp_mult_acc_RESULTA_bus [31];

twentynm_fp_mac \fpdsp_block_0|sp_mult_acc (
	.accumulate(accumulate),
	.chainin_overflow(gnd),
	.chainin_invalid(gnd),
	.chainin_underflow(gnd),
	.chainin_inexact(gnd),
	.ax(32'b00000000000000000000000000000000),
	.ay({ay[31],ay[30],ay[29],ay[28],ay[27],ay[26],ay[25],ay[24],ay[23],ay[22],ay[21],ay[20],ay[19],ay[18],ay[17],ay[16],ay[15],ay[14],ay[13],ay[12],ay[11],ay[10],ay[9],ay[8],ay[7],ay[6],ay[5],ay[4],ay[3],ay[2],ay[1],ay[0]}),
	.az({az[31],az[30],az[29],az[28],az[27],az[26],az[25],az[24],az[23],az[22],az[21],az[20],az[19],az[18],az[17],az[16],az[15],az[14],az[13],az[12],az[11],az[10],az[9],az[8],az[7],az[6],az[5],az[4],az[3],az[2],az[1],az[0]}),
	.clk({gnd,gnd,clk}),
	.aclr({aclr,aclr}),
	.ena({\~GND~combout ,\~GND~combout ,ena}),
	.chainin({gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd,gnd}),
	.overflow(),
	.invalid(),
	.underflow(),
	.inexact(),
	.chainout_overflow(),
	.chainout_invalid(),
	.chainout_underflow(),
	.chainout_inexact(),
	.dftout(),
	.resulta(\fpdsp_block_0|sp_mult_acc_RESULTA_bus ),
	.chainout());
defparam \fpdsp_block_0|sp_mult_acc .accum_adder_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .accum_pipeline_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .accumulate_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .adder_input_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .adder_subtract = "false";
defparam \fpdsp_block_0|sp_mult_acc .ax_chainin_pl_clock = "none";
defparam \fpdsp_block_0|sp_mult_acc .ax_clock = "none";
defparam \fpdsp_block_0|sp_mult_acc .ay_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .az_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .mult_pipeline_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .operation_mode = "sp_mult_acc";
defparam \fpdsp_block_0|sp_mult_acc .output_clock = "0";
defparam \fpdsp_block_0|sp_mult_acc .use_chainin = "false";

twentynm_lcell_comb \~GND (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(gnd),
	.datae(gnd),
	.dataf(gnd),
	.datag(gnd),
	.cin(gnd),
	.sharein(gnd),
	.combout(\~GND~combout ),
	.sumout(),
	.cout(),
	.shareout());
defparam \~GND .extended_lut = "off";
defparam \~GND .lut_mask = 64'h0000000000000000;
defparam \~GND .shared_arith = "off";

assign result[0] = \fpdsp_block_0|result[0] ;

assign result[1] = \fpdsp_block_0|result[1] ;

assign result[2] = \fpdsp_block_0|result[2] ;

assign result[3] = \fpdsp_block_0|result[3] ;

assign result[4] = \fpdsp_block_0|result[4] ;

assign result[5] = \fpdsp_block_0|result[5] ;

assign result[6] = \fpdsp_block_0|result[6] ;

assign result[7] = \fpdsp_block_0|result[7] ;

assign result[8] = \fpdsp_block_0|result[8] ;

assign result[9] = \fpdsp_block_0|result[9] ;

assign result[10] = \fpdsp_block_0|result[10] ;

assign result[11] = \fpdsp_block_0|result[11] ;

assign result[12] = \fpdsp_block_0|result[12] ;

assign result[13] = \fpdsp_block_0|result[13] ;

assign result[14] = \fpdsp_block_0|result[14] ;

assign result[15] = \fpdsp_block_0|result[15] ;

assign result[16] = \fpdsp_block_0|result[16] ;

assign result[17] = \fpdsp_block_0|result[17] ;

assign result[18] = \fpdsp_block_0|result[18] ;

assign result[19] = \fpdsp_block_0|result[19] ;

assign result[20] = \fpdsp_block_0|result[20] ;

assign result[21] = \fpdsp_block_0|result[21] ;

assign result[22] = \fpdsp_block_0|result[22] ;

assign result[23] = \fpdsp_block_0|result[23] ;

assign result[24] = \fpdsp_block_0|result[24] ;

assign result[25] = \fpdsp_block_0|result[25] ;

assign result[26] = \fpdsp_block_0|result[26] ;

assign result[27] = \fpdsp_block_0|result[27] ;

assign result[28] = \fpdsp_block_0|result[28] ;

assign result[29] = \fpdsp_block_0|result[29] ;

assign result[30] = \fpdsp_block_0|result[30] ;

assign result[31] = \fpdsp_block_0|result[31] ;

endmodule
