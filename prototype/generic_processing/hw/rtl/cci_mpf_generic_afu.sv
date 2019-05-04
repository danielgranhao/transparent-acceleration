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

	// We use CSR 0 to set the cipher address
	logic is_cipher_addr_csr_write;
	assign is_cipher_addr_csr_write = csrs.cpu_wr_csrs[0].en;
	// Memory address to which this AFU will write. (Cipher Text Address)
	//t_ccip_clAddr cipher_addr;
	t_byteAddr cipher_addr;
	t_cci_clAddr cipher_claddr;
	assign cipher_claddr = byteAddrToClAddr(cipher_addr);

	// MMIO address 2 to store plaintext address
	logic is_plain_addr_csr_write;
	assign is_plain_addr_csr_write = csrs.cpu_wr_csrs[1].en;
	// Plain Text Address
	//t_ccip_clAddr plain_addr;
	t_byteAddr plain_addr;
	t_cci_clAddr plain_claddr;
	assign plain_claddr = byteAddrToClAddr(plain_addr);

	// MMIO address 4 to store key address
	logic is_key_addr_csr_write;
	assign is_key_addr_csr_write = csrs.cpu_wr_csrs[2].en;
	// Plain Text Address
	//t_ccip_clAddr key_addr;
	t_byteAddr key_addr;
	t_cci_clAddr key_claddr;
	assign key_claddr = byteAddrToClAddr(key_addr);

	// MMIO address 6 to store IV
	logic is_iv_csr_write;
	assign is_iv_csr_write = csrs.cpu_wr_csrs[3].en;
	// Initialization vector
	logic [63:0] iv;

	// MMIO address 8 to store text length
	logic is_text_length_csr_write;
	assign is_text_length_csr_write = csrs.cpu_wr_csrs[4].en;
	// Text length
	logic [63:0] text_length;


	//
	// AES core Wires
	//

	// Key for AES
	logic [127:0] key_in;
	// State -> 64bit IV + 64bit Counter
	logic [127:0] state_in;
	// Output of AES core -> to XOR with plaintext
	logic [127:0] aes_out;
	// Run counter?
	logic counter_on;


	//
	// State input generation
	//

	// Build state_in for AES core
	/*counter_64bit counter_64bit_inst(
			.clk( clk ), 
			.reset( reset ), 
			.on( counter_on ),
			.count( state_in[63:0] )
		);*/

	assign state_in[127:64] = iv[63:0];

	//
	// AES-128 core
	//

	/*aes_128 aes_128_inst(
			.clk( clk ),
			.state( state_in ),
			.key( key_in ),
			.out( aes_out )
		);*/








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
		if (reset || afu_complete)
		begin
			//cipher_addr <= t_ccip_clAddr'(64'h0000_0000_0000_0000);
			//plain_addr <= t_ccip_clAddr'(64'h0000_0000_0000_0000);
			cipher_addr <= 64'h0000_0000_0000_0000;
			plain_addr <= 64'h0000_0000_0000_0000;
			key_addr <= 64'h0000_0000_0000_0000;
			iv <= 64'h0000_0000_0000_0000;
			text_length <= 64'h0000_0000_0000_0000;
		end
		else if (is_cipher_addr_csr_write)
		begin
			//cipher_addr <= t_ccip_clAddr'(csrs.cpu_wr_csrs[0].data);
			cipher_addr <= csrs.cpu_wr_csrs[0].data;
			$display("Received cipher address");
		end
		else if (is_plain_addr_csr_write)
		begin
			//plain_addr <= t_ccip_clAddr'(csrs.cpu_wr_csrs[1].data);
			plain_addr <= csrs.cpu_wr_csrs[1].data;
			$display("Received plaintext address");
		end
		else if (is_key_addr_csr_write)
		begin
			//key_addr <= t_ccip_clAddr'(csrs.cpu_wr_csrs[2].data);
			key_addr <= csrs.cpu_wr_csrs[2].data;
			$display("Received key address: %0h", csrs.cpu_wr_csrs[2].data);
		end
		else if (is_iv_csr_write)
		begin
			iv <= csrs.cpu_wr_csrs[3].data;
			$display("Received IV");
		end
		else if (is_text_length_csr_write)
		begin
			text_length <= csrs.cpu_wr_csrs[4].data;
			$display("Received text length");
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
			if ((state == STATE_IDLE) && cipher_addr)
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






	// =========================================================================
	//
	//   Read logic.
	//
	// =========================================================================

	//
	// READ REQUEST
	//

	//
	// Since back pressure may prevent an immediate read request, we must
	// record whether a read is needed and hold it until the request can
	// be sent to the FIU.
	//
	t_cci_clAddr rd_addr;
	logic rd_needed;

	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			rd_needed <= 1'b0;
		end
		else
		begin
			// If reads are allowed this cycle then we can safely clear
			// any previously requested reads.  This simple AFU has only
			// one read in flight at a time since it is walking a pointer
			// chain.
			if (rd_needed)
			begin
				rd_needed <= fiu.c0TxAlmFull;
			end
			else if( !key_in )
			begin
				// Need a read under two conditions:
				//   - Starting a new walk
				//   - A read response just arrived from a line containing
				//     a next pointer.
				//rd_needed <= (start_traversal || (addr_next_valid && ! rd_end_of_list));
				rd_needed <= (key_addr != 64'b0);
				//rd_addr <= (start_traversal ? start_traversal_addr : addr_next);
				rd_addr <= key_claddr;
			end
		end
	end


	//
	// Emit read requests to the FIU.
	//

	// Read header defines the request to the FIU
	t_cci_mpf_c0_ReqMemHdr rd_hdr;
	t_cci_mpf_ReqMemHdrParams rd_hdr_params;

	always_comb
	begin
		// Use virtual addresses
		rd_hdr_params = cci_mpf_defaultReqHdrParams(1);
		// Let the FIU pick the channel
		rd_hdr_params.vc_sel = eVC_VA;
		// Read 1 line (can read 1, 2 or 4)
		rd_hdr_params.cl_len = eCL_LEN_1;

		// Generate the header
		rd_hdr = cci_mpf_c0_genReqHdr(eREQ_RDLINE_I,
				rd_addr,
				t_cci_mdata'(0),
				rd_hdr_params);
	end

	// Send read requests to the FIU
	always_ff @(posedge clk)
	begin
		if (reset)
		begin
			fiu.c0Tx.valid <= 1'b0;
		end
		else
		begin
			// Generate a read request when needed and the FIU isn't full
			fiu.c0Tx <= cci_mpf_genC0TxReadReq(rd_hdr,
					(rd_needed && ! fiu.c0TxAlmFull));

			if (rd_needed && ! fiu.c0TxAlmFull)
			begin
				$display("  Reading from VA 0x%x", clAddrToByteAddr(rd_addr));
			end
		end
	end

	//
	// READ RESPONSE HANDLING
	//

	//
	// Registers requesting the addition of read data to the hash.
	//
	//logic hash_data_en;
	//logic [31:0] hash_data;
	// The cache-line number of the associated data is recorded in order
	// to figure out when reading is complete.  We will have read all
	// the data when the 4th beat of the final request is read.
	//t_cci_clNum hash_cl_num;

	logic [CL_BYTE_IDX_BITS-1:0] offset_addr;
	assign offset_addr = key_addr[CL_BYTE_IDX_BITS-1:0];

	//
	// Receive data (read responses).
	//
	always_ff @(posedge clk)
	begin
		// A read response is data if the cl_num is non-zero.  (When cl_num
		// is zero the response is a pointer to the next record.)
		//hash_data_en <= (cci_c0Rx_isReadRsp(fiu.c0Rx) &&
		//	(fiu.c0Rx.hdr.cl_num != t_cci_clNum'(0)));
		//hash_data <= fiu.c0Rx.data[31:0];
		//hash_cl_num <= fiu.c0Rx.hdr.cl_num;

		if( reset )
		begin
			key_in <= 128'h0;
		end
		//else if (cci_c0Rx_isReadRsp(fiu.c0Rx) &&
		//	(fiu.c0Rx.hdr.cl_num != t_cci_clNum'(0)))
		else if ( cci_c0Rx_isReadRsp(fiu.c0Rx) )
		begin

			if (offset_addr == 6'b00_0000)
			begin
				key_in <= fiu.c0Rx.data[127:0];
				$display("Read 512 bits: %0h", fiu.c0Rx.data[511:0]);
				$display("Key is: %0h", fiu.c0Rx.data[127:0]);
			end
			else if (offset_addr == 6'b01_0000)
			begin
				key_in <= fiu.c0Rx.data[255:128];
				$display("Read 512 bits: %0h", fiu.c0Rx.data[511:0]);
				$display("Key is: %0h", fiu.c0Rx.data[255:128]);
			end
			else if (offset_addr == 6'b10_0000)
			begin
				key_in <= fiu.c0Rx.data[383:256];
				$display("Read 512 bits: %0h", fiu.c0Rx.data[511:0]);
				$display("Key is: %0h", fiu.c0Rx.data[383:256]);
			end
			else if (offset_addr == 6'b11_0000)
			begin
				key_in <= fiu.c0Rx.data[511:384];
				$display("Read 512 bits: %0h", fiu.c0Rx.data[511:0]);
				$display("Key is: %0h", fiu.c0Rx.data[511:384]);
			end
			
		end
	end

















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

	buffer_512_to_64 buffer_inst(
			.clk(clk), 
			.rst(reset), 
			.clr(reset),
		
			.data_in(fiu.c0Rx.data[511:0]),
			.wr_enable(1'b1),

			.data_out(fiu.c1Tx.data[63:0]),
			.rd_enable(1'b1),
		
			.full(),
			.empty(),
			.full_n()
		);


endmodule // app_afu
