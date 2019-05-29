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
	
	// MMIO address 8 to store initialization vector
	logic is_iv_0_csr_write;
	assign is_iv_0_csr_write = csrs.cpu_wr_csrs[4].en;
	// Initialization vector
	logic [63:0] iv_0;
	
	// MMIO address 10 to store initialization vector
	logic is_iv_1_csr_write;
	assign is_iv_1_csr_write = csrs.cpu_wr_csrs[5].en;
	// Initialization vector
	logic [63:0] iv_1;
	
	// MMIO address 12 receive key 0
	logic is_key_0_csr_write;
	assign is_key_0_csr_write = csrs.cpu_wr_csrs[6].en;
	// Initialization vector
	logic [63:0] key_0;
	
	// MMIO address 14 receive key 1
	logic is_key_1_csr_write;
	assign is_key_1_csr_write = csrs.cpu_wr_csrs[7].en;
	// Initialization vector
	logic [63:0] key_1;
	
	// MMIO address 16 receive key 2
	logic is_key_2_csr_write;
	assign is_key_2_csr_write = csrs.cpu_wr_csrs[8].en;
	// Initialization vector
	logic [63:0] key_2;
	
	// MMIO address 18 receive key 3
	logic is_key_3_csr_write;
	assign is_key_3_csr_write = csrs.cpu_wr_csrs[9].en;
	// Initialization vector
	logic [63:0] key_3;
	
	// Build key
	logic [255:0] key;
	assign key = { key_3 , key_2 , key_1 , key_0 };

	always_ff @(posedge clk)
	begin
		if (reset) begin
			src_addr <= 64'h0000_0000_0000_0000;
			dest_addr <= 64'h0000_0000_0000_0000;
			data_length <= 64'h0000_0000_0000_0000;
			run <= 64'h0000_0000_0000_0000;
			iv_0 <= 64'h0000_0000_0000_0000;
			iv_1 <= 64'h0000_0000_0000_0000;
			key_0 <= 64'h0000_0000_0000_0000;
			key_1 <= 64'h0000_0000_0000_0000;
			key_2 <= 64'h0000_0000_0000_0000;
			key_3 <= 64'h0000_0000_0000_0000;
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
				else if (is_iv_0_csr_write) begin
					iv_0 <= csrs.cpu_wr_csrs[4].data;
					$display("Received iv_0: %0h", csrs.cpu_wr_csrs[4].data);
				end
				else if (is_iv_1_csr_write) begin
					iv_1 <= csrs.cpu_wr_csrs[5].data;
					$display("Received iv_1: %0h", csrs.cpu_wr_csrs[5].data);
				end
				else if (is_key_0_csr_write) begin
					key_0 <= csrs.cpu_wr_csrs[6].data;
					$display("Received key_0: %0h", csrs.cpu_wr_csrs[6].data);
				end
				else if (is_key_1_csr_write) begin
					key_1 <= csrs.cpu_wr_csrs[7].data;
					$display("Received key_1: %0h", csrs.cpu_wr_csrs[7].data);
				end
				else if (is_key_2_csr_write) begin
					key_2 <= csrs.cpu_wr_csrs[8].data;
					$display("Received key_2: %0h", csrs.cpu_wr_csrs[8].data);
				end
				else if (is_key_3_csr_write) begin
					key_3 <= csrs.cpu_wr_csrs[9].data;
					$display("Received key_3: %0h", csrs.cpu_wr_csrs[9].data);
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
	logic [127:0] read_buffer_data_out;
	logic read_buffer_rd_enable;
	logic read_buffer_empty;
	logic read_buffer_full_n;
	
	logic [127:0] write_buffer_data_in;
	logic write_buffer_wr_enable;
	logic [511:0] write_buffer_data_out;
	logic write_buffer_rd_enable;
	logic write_buffer_empty;
	logic write_buffer_full_n;
	
	assign read_buffer_data_in[511:0] = fiu.c0Rx.data[511:0];
	
	// Read from read buffer as long as there is something to read and there is space for it to be written on the write buffer
	assign read_buffer_rd_enable = (! write_buffer_full_n && ! read_buffer_empty)? 1 : 0;
	
	buffer_512_to_128 buffer_512_to_128_inst(
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
	logic mpf_to_buffer_done;
	
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
	
	//
	// AES Kernel
	//
	
	logic aes_valid_input;
	logic [127:0] aes_state;
	logic [127:0] out;
	
	always_ff @(posedge clk) begin
		if (reset)  begin
			aes_state <= 128'd0;
			aes_valid_input <= 1'b0;
		end
		else begin
			if ( run ) begin
				aes_state[127:64] <= iv_1[63:0];
				aes_state[63:0] <= iv_0[63:0];
			end
			else begin
				if(aes_valid_input) begin
					aes_state <= aes_state + 1'b1;				
				end
			end
			aes_valid_input <= read_buffer_rd_enable;
		end
	end
		
	// out is valid 29 clk cycles after state and key are valid
	aes_256 aes_256 (
			.clk    (clk   ), 
			.state  (aes_state ), 
			.key    (key   ), 
			.out    (out   )
		);
	
	// Shift register to delay data before it is Xor'ed
	logic [127:0] data_shift_reg[0:29];
	logic valid_shift_reg[0:29];
	
	//assign data_shift_reg[127:0][0] = read_buffer_data_out[127:0];
	assign data_shift_reg[0] = read_buffer_data_out[127:0];
	assign valid_shift_reg[0]		= aes_valid_input;
	
	always_ff @(posedge clk) begin
		for(int i = 1; i<=29; i++) begin
			//data_shift_reg[127:0][i] 	<= data_shift_reg[127:0][i-1];
			data_shift_reg[i] 	<= data_shift_reg[i-1];
			valid_shift_reg[i]			<= valid_shift_reg[i-1];
		end
	end

	assign write_buffer_wr_enable 		= valid_shift_reg[29];
	// XOR output of AES kernel with data
	//assign write_buffer_data_in[127:0]	= data_shift_reg[127:0][29] ^ out[127:0];
	assign write_buffer_data_in[127:0]	= data_shift_reg[29] ^ out[127:0];
	
	//
	// Write buffer
	//
	
	buffer_128_to_512 buffer_128_to_512_inst (
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
	
	//assign fiu.c1Tx.data[511:0] = write_buffer_data_out[511:0];
	genvar i;
	for(i = 0; i < 4; i++) begin
		assign fiu.c1Tx.data[127+i*128:0+i*128] = { 
			write_buffer_data_out[7+i*128:0+i*128],
			write_buffer_data_out[15+i*128:8+i*128],
			write_buffer_data_out[23+i*128:16+i*128],
			write_buffer_data_out[31+i*128:24+i*128],
			write_buffer_data_out[39+i*128:32+i*128],
			write_buffer_data_out[47+i*128:40+i*128],
			write_buffer_data_out[55+i*128:48+i*128],
			write_buffer_data_out[63+i*128:56+i*128],
			write_buffer_data_out[71+i*128:64+i*128],
			write_buffer_data_out[79+i*128:72+i*128],
			write_buffer_data_out[87+i*128:80+i*128],
			write_buffer_data_out[95+i*128:88+i*128],
			write_buffer_data_out[103+i*128:96+i*128],
			write_buffer_data_out[111+i*128:104+i*128],
			write_buffer_data_out[119+i*128:112+i*128],
			write_buffer_data_out[127+i*128:120+i*128]
			};
	end

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
