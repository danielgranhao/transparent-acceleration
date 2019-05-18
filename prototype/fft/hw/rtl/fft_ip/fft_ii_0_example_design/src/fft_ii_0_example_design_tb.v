// fft_ii_0_example_design_tb.v

// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module fft_ii_0_example_design_tb (
	);

	wire         fft_ii_0_example_design_inst_core_source_valid;               // fft_ii_0_example_design_inst:core_source_valid -> fft_ii_0_example_design_inst_core_source_bfm:sink_valid
	wire  [82:0] fft_ii_0_example_design_inst_core_source_data;                // fft_ii_0_example_design_inst:core_source_data -> fft_ii_0_example_design_inst_core_source_bfm:sink_data
	wire         fft_ii_0_example_design_inst_core_source_ready;               // fft_ii_0_example_design_inst_core_source_bfm:sink_ready -> fft_ii_0_example_design_inst:core_source_ready
	wire         fft_ii_0_example_design_inst_core_source_startofpacket;       // fft_ii_0_example_design_inst:core_source_startofpacket -> fft_ii_0_example_design_inst_core_source_bfm:sink_startofpacket
	wire   [1:0] fft_ii_0_example_design_inst_core_source_error;               // fft_ii_0_example_design_inst:core_source_error -> fft_ii_0_example_design_inst_core_source_bfm:sink_error
	wire         fft_ii_0_example_design_inst_core_source_endofpacket;         // fft_ii_0_example_design_inst:core_source_endofpacket -> fft_ii_0_example_design_inst_core_source_bfm:sink_endofpacket
	wire   [0:0] fft_ii_0_example_design_inst_core_sink_bfm_src_valid;         // fft_ii_0_example_design_inst_core_sink_bfm:src_valid -> fft_ii_0_example_design_inst:core_sink_valid
	wire  [83:0] fft_ii_0_example_design_inst_core_sink_bfm_src_data;          // fft_ii_0_example_design_inst_core_sink_bfm:src_data -> fft_ii_0_example_design_inst:core_sink_data
	wire         fft_ii_0_example_design_inst_core_sink_bfm_src_ready;         // fft_ii_0_example_design_inst:core_sink_ready -> fft_ii_0_example_design_inst_core_sink_bfm:src_ready
	wire   [0:0] fft_ii_0_example_design_inst_core_sink_bfm_src_startofpacket; // fft_ii_0_example_design_inst_core_sink_bfm:src_startofpacket -> fft_ii_0_example_design_inst:core_sink_startofpacket
	wire   [0:0] fft_ii_0_example_design_inst_core_sink_bfm_src_endofpacket;   // fft_ii_0_example_design_inst_core_sink_bfm:src_endofpacket -> fft_ii_0_example_design_inst:core_sink_endofpacket
	wire   [1:0] fft_ii_0_example_design_inst_core_sink_bfm_src_error;         // fft_ii_0_example_design_inst_core_sink_bfm:src_error -> fft_ii_0_example_design_inst:core_sink_error
	wire         fft_ii_0_example_design_inst_core_clk_bfm_clk_clk;            // fft_ii_0_example_design_inst_core_clk_bfm:clk -> [fft_ii_0_example_design_inst:core_clk_clk, fft_ii_0_example_design_inst_core_rst_bfm:clk, fft_ii_0_example_design_inst_core_sink_bfm:clk, fft_ii_0_example_design_inst_core_source_bfm:clk]
	wire         fft_ii_0_example_design_inst_core_rst_bfm_reset_reset;        // fft_ii_0_example_design_inst_core_rst_bfm:reset -> [fft_ii_0_example_design_inst:core_rst_reset_n, fft_ii_0_example_design_inst_core_sink_bfm:reset, fft_ii_0_example_design_inst_core_source_bfm:reset]

	fft_ii_0_example_design fft_ii_0_example_design_inst (
		.core_clk_clk              (fft_ii_0_example_design_inst_core_clk_bfm_clk_clk),            //    core_clk.clk
		.core_rst_reset_n          (fft_ii_0_example_design_inst_core_rst_bfm_reset_reset),        //    core_rst.reset_n
		.core_sink_valid           (fft_ii_0_example_design_inst_core_sink_bfm_src_valid),         //   core_sink.valid
		.core_sink_ready           (fft_ii_0_example_design_inst_core_sink_bfm_src_ready),         //            .ready
		.core_sink_error           (fft_ii_0_example_design_inst_core_sink_bfm_src_error),         //            .error
		.core_sink_startofpacket   (fft_ii_0_example_design_inst_core_sink_bfm_src_startofpacket), //            .startofpacket
		.core_sink_endofpacket     (fft_ii_0_example_design_inst_core_sink_bfm_src_endofpacket),   //            .endofpacket
		.core_sink_data            (fft_ii_0_example_design_inst_core_sink_bfm_src_data),          //            .data
		.core_source_valid         (fft_ii_0_example_design_inst_core_source_valid),               // core_source.valid
		.core_source_ready         (fft_ii_0_example_design_inst_core_source_ready),               //            .ready
		.core_source_error         (fft_ii_0_example_design_inst_core_source_error),               //            .error
		.core_source_startofpacket (fft_ii_0_example_design_inst_core_source_startofpacket),       //            .startofpacket
		.core_source_endofpacket   (fft_ii_0_example_design_inst_core_source_endofpacket),         //            .endofpacket
		.core_source_data          (fft_ii_0_example_design_inst_core_source_data)                 //            .data
	);

	altera_avalon_clock_source #(
		.CLOCK_RATE (50000000),
		.CLOCK_UNIT (1)
	) fft_ii_0_example_design_inst_core_clk_bfm (
		.clk (fft_ii_0_example_design_inst_core_clk_bfm_clk_clk)  // clk.clk
	);

	altera_avalon_reset_source #(
		.ASSERT_HIGH_RESET    (0),
		.INITIAL_RESET_CYCLES (50)
	) fft_ii_0_example_design_inst_core_rst_bfm (
		.reset (fft_ii_0_example_design_inst_core_rst_bfm_reset_reset), // reset.reset_n
		.clk   (fft_ii_0_example_design_inst_core_clk_bfm_clk_clk)      //   clk.clk
	);

	altera_avalon_st_source_bfm #(
		.USE_PACKET       (1),
		.USE_CHANNEL      (0),
		.USE_ERROR        (1),
		.USE_READY        (1),
		.USE_VALID        (1),
		.USE_EMPTY        (0),
		.ST_SYMBOL_W      (84),
		.ST_NUMSYMBOLS    (1),
		.ST_CHANNEL_W     (1),
		.ST_ERROR_W       (2),
		.ST_EMPTY_W       (1),
		.ST_READY_LATENCY (0),
		.ST_BEATSPERCYCLE (1),
		.ST_MAX_CHANNELS  (0),
		.VHDL_ID          (0)
	) fft_ii_0_example_design_inst_core_sink_bfm (
		.clk               (fft_ii_0_example_design_inst_core_clk_bfm_clk_clk),            //       clk.clk
		.reset             (~fft_ii_0_example_design_inst_core_rst_bfm_reset_reset),       // clk_reset.reset
		.src_data          (fft_ii_0_example_design_inst_core_sink_bfm_src_data),          //       src.data
		.src_valid         (fft_ii_0_example_design_inst_core_sink_bfm_src_valid),         //          .valid
		.src_ready         (fft_ii_0_example_design_inst_core_sink_bfm_src_ready),         //          .ready
		.src_startofpacket (fft_ii_0_example_design_inst_core_sink_bfm_src_startofpacket), //          .startofpacket
		.src_endofpacket   (fft_ii_0_example_design_inst_core_sink_bfm_src_endofpacket),   //          .endofpacket
		.src_error         (fft_ii_0_example_design_inst_core_sink_bfm_src_error),         //          .error
		.src_empty         (),                                                             // (terminated)
		.src_channel       ()                                                              // (terminated)
	);

	altera_avalon_st_sink_bfm #(
		.USE_PACKET       (1),
		.USE_CHANNEL      (0),
		.USE_ERROR        (1),
		.USE_READY        (1),
		.USE_VALID        (1),
		.USE_EMPTY        (0),
		.ST_SYMBOL_W      (83),
		.ST_NUMSYMBOLS    (1),
		.ST_CHANNEL_W     (1),
		.ST_ERROR_W       (2),
		.ST_EMPTY_W       (1),
		.ST_READY_LATENCY (0),
		.ST_BEATSPERCYCLE (1),
		.ST_MAX_CHANNELS  (0),
		.VHDL_ID          (0)
	) fft_ii_0_example_design_inst_core_source_bfm (
		.clk                (fft_ii_0_example_design_inst_core_clk_bfm_clk_clk),      //       clk.clk
		.reset              (~fft_ii_0_example_design_inst_core_rst_bfm_reset_reset), // clk_reset.reset
		.sink_data          (fft_ii_0_example_design_inst_core_source_data),          //      sink.data
		.sink_valid         (fft_ii_0_example_design_inst_core_source_valid),         //          .valid
		.sink_ready         (fft_ii_0_example_design_inst_core_source_ready),         //          .ready
		.sink_startofpacket (fft_ii_0_example_design_inst_core_source_startofpacket), //          .startofpacket
		.sink_endofpacket   (fft_ii_0_example_design_inst_core_source_endofpacket),   //          .endofpacket
		.sink_error         (fft_ii_0_example_design_inst_core_source_error),         //          .error
		.sink_empty         (1'b0),                                                   // (terminated)
		.sink_channel       (1'b0)                                                    // (terminated)
	);

endmodule
