

/* ****************************************************************************
 * Copyright(c) 2011-2016, Intel Corporation
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * * Neither the name of Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * **************************************************************************
 *
 * Module Info: ASE top-level
 *              (hides ASE machinery, makes finding cci_std_afu easy)
 * Language   : System{Verilog}
 * Owner      : Rahul R Sharma
 *              rahul.r.sharma@intel.com
 *              Intel Corporation
 *
 * **************************************************************************/

//
// platform_if.vh defines many required components, including both top-level
// SystemVerilog interfaces and the platform/AFU configuration parameters
// required to match the interfaces offered by the platform to the needs
// of the AFU. It is part of the platform database and imported using
// state generated by afu_platform_config.
//
// Most preprocessor variables used in this file come from this.
//
`include "platform_if.vh"

`timescale 1ps/1ps

module ase_top();


   logic pClkDiv4;
   logic pClkDiv2;
   logic pClk;
   logic pck_cp2af_softReset;

   logic uClk_usr;
   logic uClk_usrDiv2;

   t_if_ccip_Tx pck_af2cp_sTx;
   t_if_ccip_Rx pck_cp2af_sRx;

   logic [1:0] pck_cp2af_pwrState;   // CCI-P AFU Power State
   logic       pck_cp2af_error;      // CCI-P Protocol Error Detected

`ifdef PLATFORM_PROVIDES_LOCAL_MEMORY
 // Now many memory banks?
 `ifdef AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM_LEGACY_WIRES_2BANK
   localparam NUM_LOCAL_MEM_BANKS = 2;
 `else
   localparam NUM_LOCAL_MEM_BANKS = `AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM;
 `endif

   // The ddr4 array size must be an even number, whether or not NUM_LOCAL_MEM_BANKS
   // is even.  This is due to the way the emulator is structured in emif_ddr4
   // below.  When NUM_LOCAL_MEM_BANKS is odd an extra slot will be instantiated
   // but not passed to the AFU.
   localparam NUM_ALLOC_MEM_BANKS = (((NUM_LOCAL_MEM_BANKS + 1) >> 1) << 1);

   // DDR clock will come from the memory emulator
   logic ddr4_avmm_clk[NUM_ALLOC_MEM_BANKS];

   // Interfaces for all DDR memory banks
   avalon_mem_if#(.ENABLE_LOG(1), .NUM_BANKS(NUM_LOCAL_MEM_BANKS))
      ddr4[NUM_ALLOC_MEM_BANKS](ddr4_avmm_clk, pck_cp2af_softReset);

   logic ddr_reset_n;
   logic ddr_pll_ref_clk;
`else
   localparam NUM_LOCAL_MEM_BANKS = 0;
`endif

   // CCI-P emulator
   ccip_emulator ccip_emulator
     (
      .pClkDiv4               (pClkDiv4            ),
      .pClkDiv2               (pClkDiv2            ),
      .pClk                   (pClk                ),
      .uClk_usr               (uClk_usr            ),
      .uClk_usrDiv2           (uClk_usrDiv2        ),
      .pck_cp2af_softReset    (pck_cp2af_softReset ),
      .pck_cp2af_pwrState     (pck_cp2af_pwrState  ),
      .pck_cp2af_error        (pck_cp2af_error     ),
      .pck_af2cp_sTx          (pck_af2cp_sTx       ),
      .pck_cp2af_sRx          (pck_cp2af_sRx       )
      );


   // CCIP AFU
   `PLATFORM_SHIM_MODULE_NAME
`ifdef AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM
    #(
      // Avalon memory as a SystemVerilog interface.  The number
      // of banks is passed as a parameter.  The address size
      // is part of the type, so not needed here.
      .NUM_LOCAL_MEM_BANKS(`AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM)
     )
`endif
`ifdef AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM_LEGACY_WIRES_2BANK
    #(
      .DDR_ADDR_WIDTH(`PLATFORM_PARAM_LOCAL_MEMORY_ADDR_WIDTH)
     )
`endif
    `PLATFORM_SHIM_MODULE_NAME
     (
      .pClkDiv4               (pClkDiv4            ),
      .pClkDiv2               (pClkDiv2            ),
      .pClk                   (pClk                ),
      .uClk_usr               (uClk_usr            ),
      .uClk_usrDiv2           (uClk_usrDiv2        ),
      .pck_cp2af_softReset    (pck_cp2af_softReset ),
`ifdef AFU_TOP_REQUIRES_POWER_2BIT
      .pck_cp2af_pwrState     (pck_cp2af_pwrState  ),
`endif
`ifdef AFU_TOP_REQUIRES_ERROR_1BIT
      .pck_cp2af_error        (pck_cp2af_error     ),
`endif


      //
      // Local memory
      //   The platform offers two interfaces to the same
      //   Avalon memory: a SystemVerilog interface and a
      //   legacy, wire-based interface.  At most one
      //   will be active in a given compilation, based
      //   on AFU platform requests and configured by
      //   afu_platform_config.
      //
`ifdef AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM
      .local_mem              (ddr4[0:NUM_LOCAL_MEM_BANKS-1]),
`endif
`ifdef AFU_TOP_REQUIRES_LOCAL_MEMORY_AVALON_MM_LEGACY_WIRES_2BANK
      .DDR4a_USERCLK          (ddr4_avmm_clk[0]     ),
      .DDR4a_writedata        (ddr4[0].writedata    ),
      .DDR4a_readdata         (ddr4[0].readdata     ),
      .DDR4a_address          (ddr4[0].address      ),
      .DDR4a_waitrequest      (ddr4[0].waitrequest  ),
      .DDR4a_write            (ddr4[0].write        ),
      .DDR4a_read             (ddr4[0].read         ),
      .DDR4a_byteenable       (ddr4[0].byteenable   ),
      .DDR4a_burstcount       (ddr4[0].burstcount   ),
      .DDR4a_readdatavalid    (ddr4[0].readdatavalid),

      .DDR4b_USERCLK          (ddr4_avmm_clk[1]     ),
      .DDR4b_writedata        (ddr4[1].writedata    ),
      .DDR4b_readdata         (ddr4[1].readdata     ),
      .DDR4b_address          (ddr4[1].address      ),
      .DDR4b_waitrequest      (ddr4[1].waitrequest  ),
      .DDR4b_write            (ddr4[1].write        ),
      .DDR4b_read             (ddr4[1].read         ),
      .DDR4b_byteenable       (ddr4[1].byteenable   ),
      .DDR4b_burstcount       (ddr4[1].burstcount   ),
      .DDR4b_readdatavalid    (ddr4[1].readdatavalid),
`endif

      .pck_af2cp_sTx          (pck_af2cp_sTx       ),
      .pck_cp2af_sRx          (pck_cp2af_sRx       )
      );

   // t_ccip_c0_RspAtomicHdr DBG_C0RxAtomic;
   // assign DBG_C0RxAtomic = t_ccip_c0_RspAtomicHdr'(pck_cp2af_sRx.c0.hdr);

`ifdef PLATFORM_PROVIDES_LOCAL_MEMORY
   initial begin
      #0     ddr_reset_n = 0;
             ddr_pll_ref_clk = 0;
      #10000 ddr_reset_n = 1;
   end
   always #1875 ddr_pll_ref_clk = ~ddr_pll_ref_clk; // 266.666.. Mhz

   // emif model
   genvar b;
   generate
      for (b = 0; b < NUM_LOCAL_MEM_BANKS; b = b + 2)
      begin : b_emul
         emif_ddr4
          #(
            .DDR_ADDR_WIDTH(`PLATFORM_PARAM_LOCAL_MEMORY_ADDR_WIDTH),
            .DDR_DATA_WIDTH(`PLATFORM_PARAM_LOCAL_MEMORY_DATA_WIDTH),
            .INSTANCE_ID(b)
            )
          emif_ddr4
          (
            .ddr4a_avmm_waitrequest                (ddr4[b].waitrequest),
            .ddr4a_avmm_readdata                   (ddr4[b].readdata),
            .ddr4a_avmm_readdatavalid              (ddr4[b].readdatavalid),
            .ddr4a_avmm_burstcount                 (ddr4[b].burstcount),
            .ddr4a_avmm_writedata                  (ddr4[b].writedata),
            .ddr4a_avmm_address                    (ddr4[b].address),
            .ddr4a_avmm_write                      (ddr4[b].write),
            .ddr4a_avmm_read                       (ddr4[b].read),
            .ddr4a_avmm_byteenable                 (ddr4[b].byteenable),
            .ddr4a_avmm_clk_clk                    (ddr4_avmm_clk[b]),

            .ddr4a_global_reset_reset_sink_reset_n (ddr_reset_n),
            .ddr4a_pll_ref_clk_clock_sink_clk      (ddr_pll_ref_clk),

            .ddr4b_avmm_waitrequest                (ddr4[b+1].waitrequest),
            .ddr4b_avmm_readdata                   (ddr4[b+1].readdata),
            .ddr4b_avmm_readdatavalid              (ddr4[b+1].readdatavalid),
            .ddr4b_avmm_burstcount                 (ddr4[b+1].burstcount),
            .ddr4b_avmm_writedata                  (ddr4[b+1].writedata),
            .ddr4b_avmm_address                    (ddr4[b+1].address),
            .ddr4b_avmm_write                      (ddr4[b+1].write),
            .ddr4b_avmm_read                       (ddr4[b+1].read),
            .ddr4b_avmm_byteenable                 (ddr4[b+1].byteenable),
            .ddr4b_avmm_clk_clk                    (ddr4_avmm_clk[b+1])
         );

         // Mostly used for debugging
         assign ddr4[b].bank_number = b;
         assign ddr4[b+1].bank_number = b+1;
      end
   endgenerate

`endif

   t_ccip_c0_ReqMmioHdr DBG_C0RxMMIO;
   assign DBG_C0RxMMIO  = t_ccip_c0_ReqMmioHdr'(pck_cp2af_sRx.c0.hdr);

endmodule // ase_top
