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
		for (int i = 1; i < NUM_APP_CSRS; i = i + 1)
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
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			src_addr <= 64'h0000_0000_0000_0000;
			dest_addr <= 64'h0000_0000_0000_0000;
			data_length <= 64'h0000_0000_0000_0000;
			run <= 64'h0000_0000_0000_0000;
		end
		else begin
			if (run) begin
				run <= 64'h0000_0000_0000_0000;
			end
			else begin
				if (is_src_addr_csr_write) begin
					src_addr <= csrs.cpu_wr_csrs[0].data;
					$display("Received source address: %0h", csrs.cpu_wr_csrs[0].data);
				end
				else if (is_dest_addr_csr_write) begin
					dest_addr <= csrs.cpu_wr_csrs[1].data;
					$display("Received destination address: %0h", csrs.cpu_wr_csrs[1].data);
				end
				else if (is_data_length_addr_csr_write) begin
					data_length <= csrs.cpu_wr_csrs[2].data;
					$display("Received data length: %0d", csrs.cpu_wr_csrs[2].data);
				end
				else if (is_run_csr_write) begin
					run <= csrs.cpu_wr_csrs[3].data;
					$display("Received run order: %0d", csrs.cpu_wr_csrs[3].data);
				end
			end
		end
	end


	// =========================================================================
	//
	//   Main AFU logic
	//
	// =========================================================================

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
			if ((state == STATE_IDLE) && run)
			begin
				state <= STATE_RUN;
				$display("AFU running...");
			end

			if (afu_complete)
			begin
				state <= STATE_IDLE;
				$display("AFU done...");
			end
		end
	end
	
	assign csrs.cpu_rd_csrs[0].data = (state == STATE_IDLE)? 64'd1 : 64'd0;
	
	//----------------------------------------
		
	//
	// Read buffer
	//
	
	logic [511:0] read_buffer_data_in;
	logic read_buffer_wr_enable;
	logic [63:0] read_buffer_data_out;
	logic read_buffer_rd_enable;
	logic read_buffer_empty;
	logic read_buffer_full_n;
	
	logic [63:0] write_buffer_data_in;
	logic write_buffer_wr_enable;
	logic [511:0] write_buffer_data_out;
	logic write_buffer_rd_enable;
	logic write_buffer_empty;
	logic write_buffer_full_n;
	
	assign read_buffer_data_in[511:0] = fiu.c0Rx.data[511:0];
	
	// Read from read buffer as long as there is something to read and there is space for it to be written on the write buffer
	assign read_buffer_rd_enable = (! write_buffer_full_n && ! read_buffer_empty)? 1 : 0;
	
	buffer_512_to_64 buffer_512_to_64_inst(
			.clk			(clk					), 
			.rst			(!reset					), 
			.clr			(reset					),
		
			.data_in		(read_buffer_data_in	),
			.wr_enable		(read_buffer_wr_enable	),

			.data_out		(read_buffer_data_out	),
			.rd_enable		(read_buffer_rd_enable	),
		
			.full			(						),
			.empty			(read_buffer_empty		),
			.full_n			(read_buffer_full_n 	)
		);

	logic mpf_to_buffer_run;
	// TODO: check done signal
	logic mpf_to_buffer_done;

	//assign fiu.c1Tx.data[63:0] = read_buffer_data_out[63:0];
	
	assign mpf_to_buffer_run = run[0:0];
	
	mpf_to_buffer_SM mpf_to_buffer_SM_inst (
			.clk               (clk              		), 
			.reset             (!reset           		),
			
			.run               (mpf_to_buffer_run		), 
			.data_length       (data_length      		), 
			.done              (mpf_to_buffer_done		), 
			.first_clAddr      (src_clAddr       		),
			
			.c0TxAlmFull	   (fiu.c0TxAlmFull		),
			.c0TxValid	   (fiu.c0Tx.valid		),
			.reqMemHdr	   (fiu.c0Tx.hdr		),

			.c0Rx		   (fiu.c0Rx			),

			.buffer_wr_enable  (read_buffer_wr_enable 	), 
			.full_n            (read_buffer_full_n 		)
		);

	fp_mult_reg u0 (
		.aclr   (1'b0),   //   aclr.aclr
		.ay     (read_buffer_data_out[31:0]),     //     ay.ay
		.az     (read_buffer_data_out[31:0]),     //     az.az
		.clk    (clk),    //    clk.clk
		.ena    (1'b1),    //    ena.ena
		.result (write_buffer_data_in[31:0])  // result.result
	);
	fp_mult_reg u1 (
		.aclr   (1'b0),   //   aclr.aclr
		.ay     (read_buffer_data_out[63:32]),     //     ay.ay
		.az     (read_buffer_data_out[63:32]),     //     az.az
		.clk    (clk),    //    clk.clk
		.ena    (1'b1),    //    ena.ena
		.result (write_buffer_data_in[63:32])  // result.result
	);

	//assign write_buffer_data_in[63:0] = read_buffer_data_out[63:0] * 2;

	/*
	// Enable write 1 clock cycle after read enable 
	always_ff @(posedge clk) begin
		if (reset)  begin
			write_buffer_wr_enable <= 1'b0;
		end
		else begin
			write_buffer_wr_enable <= read_buffer_rd_enable;
		end
	end	*/

	logic valid_shift_reg[0:4];
	assign valid_shift_reg[0] = read_buffer_rd_enable;

	// Enable write 4 clock cycle after read enable 
	always_ff @(posedge clk) begin
		for(int i = 1; i<=4; i++) begin
			valid_shift_reg[i] <= valid_shift_reg[i-1];
		end
	end

	assign write_buffer_wr_enable = valid_shift_reg[4];

	
	//
	// Write buffer
	//

	buffer_64_to_512 buffer_64_to_512_inst (
			.clk        (clk       				), 
			.rst        (!reset    				), 
			.clr        (reset     				), 
		
			.data_in    (write_buffer_data_in 	), 
			.wr_enable  (write_buffer_wr_enable	), 
		
			.data_out   (write_buffer_data_out	), 
			.rd_enable  (write_buffer_rd_enable	), 
		
			.full       (	      				), 
			.empty      (write_buffer_empty		), 
			.full_n     (write_buffer_full_n	)
		);
	
	assign fiu.c1Tx.data[511:0] = write_buffer_data_out[511:0];

	logic buffer_to_mpf_run;
	logic buffer_to_mpf_done;
	
	assign buffer_to_mpf_run = run[0:0];
	
	buffer_to_mpf_SM buffer_to_mpf_SM_inst (
			.clk               	(clk              		), 
			.reset             	(!reset           		),
			
			.run               	(buffer_to_mpf_run   	), 
			.data_length       	(data_length      		), 
			.done              	(buffer_to_mpf_done  	), 
			.first_clAddr      	(dest_clAddr     		),
			
			.c1TxAlmFull	   	(fiu.c1TxAlmFull		),
			.c1TxValid			(fiu.c1Tx.valid			),
			.reqMemHdr	   		(fiu.c1Tx.hdr			),

			.c1Rx		   		(fiu.c1Rx				),
			
			.buffer_rd_enable  (write_buffer_rd_enable 	), 
			.buffer_empty      (write_buffer_empty 		)
		);

	assign afu_complete =  ((state == STATE_RUN) && mpf_to_buffer_done && buffer_to_mpf_done);

	//
	// This AFU never handles MMIO reads.
	//
	assign fiu.c2Tx.mmioRdValid = 1'b0;


endmodule // app_afu
