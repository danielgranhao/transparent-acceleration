//
// Copyright (c) 2017, Intel Corporation
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
//
// Neither the name of the Intel Corporation nor the names of its contributors
// may be used to endorse or promote products derived from this software
// without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

`include "cci_mpf_if.vh"
`include "csr_mgr.vh"
`include "afu_json_info.vh"


module app_afu
		(
		input  logic clk,

		// Connection toward the host.  Reset comes in here.
		cci_mpf_if.to_fiu fiu,

		// CSR connections
		app_csrs.app csrs,

		// MPF tracks outstanding requests.  These will be true as long as
		// reads or unacknowledged writes are still in flight.
		input  logic c0NotEmpty,
		input  logic c1NotEmpty
		);

	// Local reset to reduce fan-out
	logic reset = 1'b1;
	always @(posedge clk)
	begin
		reset <= fiu.reset;
	end

	//
	// Convert between byte addresses and line addresses.  The conversion
	// is simple: adding or removing low zero bits.
	//

	localparam CL_BYTE_IDX_BITS = 6;
	typedef logic [$bits(t_cci_clAddr) + CL_BYTE_IDX_BITS - 1 : 0] t_byteAddr;

	function automatic t_cci_clAddr byteAddrToClAddr(t_byteAddr addr);
		return addr[CL_BYTE_IDX_BITS +: $bits(t_cci_clAddr)];
	endfunction

	function automatic t_byteAddr clAddrToByteAddr(t_cci_clAddr addr);
		return {addr, CL_BYTE_IDX_BITS'(0)};
	endfunction


	// ====================================================================
	//
	//  CSRs (simple connections to the external CSR management engine)
	//
	// ====================================================================

	always_comb
	begin
		// The AFU ID is a unique ID for a given program.  Here we generated
		// one with the "uuidgen" program and stored it in the AFU's JSON file.
		// ASE and synthesis setup scripts automatically invoke afu_json_mgr
		// to extract the UUID into afu_json_info.vh.
		csrs.afu_id = `AFU_ACCEL_UUID;

		// Default
		for (int i = 0; i < NUM_APP_CSRS; i = i + 1)
		begin
			csrs.cpu_rd_csrs[i].data = 64'(0);
		end
	end


	//
	// Consume configuration CSR writes
	//

	// MMIO address 0 to store source address
	logic is_src_addr_csr_write;
	assign is_src_addr_csr_write = csrs.cpu_wr_csrs[0].en;
	t_byteAddr src_addr;
	t_cci_clAddr src_clAddr;
	assign src_clAddr = byteAddrToClAddr(src_addr);

	// MMIO address 2 to store destination address
	logic is_dest_addr_csr_write;
	assign is_dest_addr_csr_write = csrs.cpu_wr_csrs[1].en;
	t_byteAddr dest_addr;
	t_cci_clAddr dest_clAddr;
	assign dest_clAddr = byteAddrToClAddr(dest_addr);

	// MMIO address 4 to store data length 
	logic is_data_length_addr_csr_write;
	assign is_data_length_addr_csr_write = csrs.cpu_wr_csrs[2].en;
	logic [63:0] data_length;

	// MMIO address 6 receive run order
	logic is_run_csr_write;
	assign is_run_csr_write = csrs.cpu_wr_csrs[3].en;
	// Initialization vector
	logic [63:0] run;
	
	
	//
	// States in our simple example.
	//
	typedef enum logic [0:0]
		{
		STATE_IDLE,
		STATE_RUN
	}
	t_state;

	t_state state;

	// CHANGE THIS
	logic afu_complete;
	assign afu_complete =  ((state == STATE_RUN) && ! fiu.c1TxAlmFull);

	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			src_addr <= 64'h0000_0000_0000_0000;
			dest_addr <= 64'h0000_0000_0000_0000;
			data_length <= 64'h0000_0000_0000_0000;
			run <= 64'h0000_0000_0000_0000;
		end
		else if (is_src_addr_csr_write)
		begin
			src_addr <= csrs.cpu_wr_csrs[0].data;
			$display("Received source address: %0h", csrs.cpu_wr_csrs[0].data);
		end
		else if (is_dest_addr_csr_write)
		begin
			dest_addr <= csrs.cpu_wr_csrs[1].data;
			$display("Received destination address: %0h", csrs.cpu_wr_csrs[1].data);
		end
		else if (is_data_length_addr_csr_write)
		begin
			data_length <= csrs.cpu_wr_csrs[2].data;
			$display("Received data length: %0d", csrs.cpu_wr_csrs[2].data);
		end
		else if (is_run_csr_write)
		begin
			run <= csrs.cpu_wr_csrs[3].data;
			$display("Received run order: %0d", csrs.cpu_wr_csrs[3].data);
		end
	end


	// =========================================================================
	//
	//   Main AFU logic
	//
	// =========================================================================

	//
	// State machine
	//
	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			state <= STATE_IDLE;
		end
		else
		begin
			// Trigger the AFU when mem_addr is set above.  (When the CPU
			// tells us the address to which the FPGA should write a message.)
			if ((state == STATE_IDLE) && run)
			begin
				state <= STATE_RUN;
				$display("AFU running...");
			end

			// The AFU completes its task by writing a single line.  When
			// the line is written return to idle.  The write will happen
			// as long as the request channel is not full.
			if (afu_complete)
			begin
				state <= STATE_IDLE;
				$display("AFU done...");
			end
		end
	end


	logic read_buffer_wr_enable;
	logic [63:0] read_buffer_data_out;
	logic read_buffer_rd_enable;
	logic read_buffer_empty;
	logic read_buffer_full_n;
	
	// For testing purposes 
	assign read_buffer_rd_enable = ( ! read_buffer_empty )? 1 : 0;
	
	buffer_512_to_64 buffer_512_to_64_inst(
			.clk			(clk					), 
			.rst			(!reset					), 
			.clr			(reset					),
		
			.data_in		(fiu.c0Rx.data[511:0]	),
			.wr_enable		(read_buffer_wr_enable	),

			.data_out		(read_buffer_data_out	),
			.rd_enable		(read_buffer_rd_enable	),
		
			.full			(						),
			.empty			(read_buffer_empty		),
			.full_n			(read_buffer_full_n 	)
		);

	// TODO: drive the run signal
	logic mpf_to_buffer_run;
	logic mpf_to_buffer_done;
	
	
	mpf_to_buffer_SM mpf_to_buffer_SM_inst (
			.clk               (clk              		), 
			.reset             (!reset           		), 
			.run               (mpf_to_buffer_run		), 
			.data_length       (data_length      		), 
			.done              (mpf_to_buffer_done		), 
			.first_clAddr      (src_clAddr       		), 
			.c0Tx              (fiu.c0Tx         		), 
			.c0TxAlmFull       (fiu.c0TxAlmFull  		), 
			.c0Rx              (fiu.c0Rx         		), 
			.buffer_wr_enable  (read_buffer_wr_enable 	), 
			.full_n            (read_buffer_full_n 		)
		);



	

	//
	// Write "Hello world!" to memory when in STATE_RUN.
	//

	// Construct a memory write request header.  For this AFU it is always
	// the same, since we write to only one address.
	t_cci_mpf_c1_ReqMemHdr wr_hdr;
	assign wr_hdr = cci_mpf_c1_genReqHdr(eREQ_WRLINE_I,
			plain_addr,
			t_cci_mdata'(0),
			cci_mpf_defaultReqHdrParams());

	// Data to write to memory: little-endian ASCII encoding of "Hello world!"
	//assign fiu.c1Tx.data = t_ccip_clData'('h0021646c726f77206f6c6c6548);	
	logic [63:0] sum;
	assign sum[63:0] = 0;

	// Control logic for memory writes
	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			fiu.c1Tx.valid <= 1'b0;
			//fiu.c1Tx.data <= t_ccip_clData'(64'h0000_0000_0000_0000);
		end
		else if (afu_complete)
		begin
			// Request the write as long as the channel isn't full.
			fiu.c1Tx.valid <= 1'b1;
			//fiu.c1Tx.data <= t_ccip_clData'(sum[63:0]);
			$display("Write requested! sum = %d", sum);
			$display("Destination address = %p", plain_addr);
		end
		else
		begin
			fiu.c1Tx.valid <= 1'b0;
		end
		fiu.c1Tx.hdr <= wr_hdr;
	end


	//
	// This AFU never makes a read request or handles MMIO reads.
	//
	//assign fiu.c0Tx.valid = 1'b0;
	assign fiu.c2Tx.mmioRdValid = 1'b0;


endmodule // app_afu
