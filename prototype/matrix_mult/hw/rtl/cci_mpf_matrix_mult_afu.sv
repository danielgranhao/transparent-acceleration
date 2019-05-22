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
		input  logic pClk,
		input  logic clk, // pClkDiv2

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

	// MMIO address 0 to store source address A
	logic is_src_addr_A_csr_write;
	assign is_src_addr_A_csr_write = csrs.cpu_wr_csrs[0].en;
	t_byteAddr src_addr_A;
	t_cci_clAddr src_clAddr_A;
	assign src_clAddr_A = byteAddrToClAddr(src_addr_A);
	
	// MMIO address 2 to store source address B
	logic is_src_addr_B_csr_write;
	assign is_src_addr_B_csr_write = csrs.cpu_wr_csrs[1].en;
	t_byteAddr src_addr_B;
	t_cci_clAddr src_clAddr_B;
	assign src_clAddr_B = byteAddrToClAddr(src_addr_B);

	// MMIO address 4 to store destination address
	logic is_dest_addr_csr_write;
	assign is_dest_addr_csr_write = csrs.cpu_wr_csrs[2].en;
	t_byteAddr dest_addr;
	t_cci_clAddr dest_clAddr;
	assign dest_clAddr = byteAddrToClAddr(dest_addr);

	// MMIO address 6 receive run order
	logic is_run_csr_write;
	assign is_run_csr_write = csrs.cpu_wr_csrs[3].en;
	// Initialization vector
	logic [63:0] run;
	
	// MMIO address 8 to store M  // lines of A
	logic is_M_csr_write;
	assign is_M_csr_write = csrs.cpu_wr_csrs[4].en;
	logic [63:0] M;
	
	// MMIO address 10 to store N // cols of B (lines when transposed)
	logic is_N_csr_write;
	assign is_N_csr_write = csrs.cpu_wr_csrs[5].en;
	logic [63:0] N;
	
	// MMIO address 12 to store K // cols of A and lins of B (cols of B also when transposed)
	logic is_K_csr_write;
	assign is_K_csr_write = csrs.cpu_wr_csrs[6].en;
	logic [63:0] K;
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			src_addr_A <= 64'h0000_0000_0000_0000;
			src_addr_B <= 64'h0000_0000_0000_0000;
			dest_addr <= 64'h0000_0000_0000_0000;
			run <= 64'h0000_0000_0000_0000;
			M <= 64'h0000_0000_0000_0000;
			N <= 64'h0000_0000_0000_0000;
			K <= 64'h0000_0000_0000_0000;
		end
		else begin
			if (run) begin
				run <= 64'h0000_0000_0000_0000;
			end
			else begin
				if (is_src_addr_A_csr_write) begin
					src_addr_A <= csrs.cpu_wr_csrs[0].data;
					$display("Received source A address: %0h", csrs.cpu_wr_csrs[0].data);
				end
				if (is_src_addr_B_csr_write) begin
					src_addr_B <= csrs.cpu_wr_csrs[1].data;
					$display("Received source B address: %0h", csrs.cpu_wr_csrs[1].data);
				end
				else if (is_dest_addr_csr_write) begin
					dest_addr <= csrs.cpu_wr_csrs[2].data;
					$display("Received destination address: %0h", csrs.cpu_wr_csrs[2].data);
				end
				else if (is_run_csr_write) begin
					run <= csrs.cpu_wr_csrs[3].data;
					$display("Received run order: %0d", csrs.cpu_wr_csrs[3].data);
				end
				else if (is_M_csr_write) begin
					M <= csrs.cpu_wr_csrs[4].data;
					$display("Received M: %0d", csrs.cpu_wr_csrs[4].data);
				end
				else if (is_N_csr_write) begin
					N <= csrs.cpu_wr_csrs[5].data;
					$display("Received N: %0d", csrs.cpu_wr_csrs[5].data);
				end
				else if (is_K_csr_write) begin
					K <= csrs.cpu_wr_csrs[6].data;
					$display("Received K: %0d", csrs.cpu_wr_csrs[6].data);
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
	
	logic [511:0] read_buffer_data_in_A;
	logic read_buffer_wr_enable_A;
	logic [511:0] read_buffer_data_out_A;
	logic read_buffer_rd_enable_A;
	logic read_buffer_empty_A;
	logic read_buffer_full_n_A;
	
	logic [511:0] read_buffer_data_in_B;
	logic read_buffer_wr_enable_B;
	logic [511:0] read_buffer_data_out_B;
	logic read_buffer_rd_enable_B;
	logic read_buffer_empty_B;
	logic read_buffer_full_n_B;

	
	logic [511:0] write_buffer_data_in;
	logic write_buffer_wr_enable;
	logic [511:0] write_buffer_data_out;
	logic write_buffer_rd_enable;
	logic write_buffer_empty;
	logic write_buffer_full_n;
	
	assign read_buffer_data_in_A[511:0] = fiu.c0Rx.data[511:0];
	assign read_buffer_data_in_B[511:0] = fiu.c0Rx.data[511:0];
	
	generic_fifo_sc_a #(
			.dw(512),
			.aw(8),
			.n(128)) 
		generic_fifo_sc_a_read_A  (
			.clk        (clk       					), 
			.rst        (!reset       				), 
			.clr        (reset       				), 
			.din        (read_buffer_data_in_A 		), 
			.we         (read_buffer_wr_enable_A 	), 
			.dout       (read_buffer_data_out_A     ), 
			.re         (read_buffer_rd_enable_A    ), 
			.full       (      						), 
			.empty      (read_buffer_empty_A     	), 
			.full_r     ( 							), 
			.empty_r    ( 							), 
			.full_n     (read_buffer_full_n_A 		), 
			.empty_n    ( 							), 
			.full_n_r   ( 							), 
			.empty_n_r  ( 							), 
			.level      ( 							)
		);
	
	generic_fifo_sc_a #(
			.dw(512),
			.aw(8),
			.n(128)) 
		generic_fifo_sc_a_read_B  (
			.clk        (clk       					), 
			.rst        (!reset       				), 
			.clr        (reset       				), 
			.din        (read_buffer_data_in_B 		), 
			.we         (read_buffer_wr_enable_B 	), 
			.dout       (read_buffer_data_out_B     ), 
			.re         (read_buffer_rd_enable_B    ), 
			.full       (      						), 
			.empty      (read_buffer_empty_B     	), 
			.full_r     ( 							), 
			.empty_r    ( 							), 
			.full_n     (read_buffer_full_n_B 		), 
			.empty_n    ( 							), 
			.full_n_r   ( 							), 
			.empty_n_r  ( 							), 
			.level      ( 							)
		);

	logic mpf_to_buffer_run;
	logic mpf_to_buffer_done;
	
	assign mpf_to_buffer_run = run[0:0];
	
	mpf_to_buffer_SM_matrix mpf_to_buffer_SM_matrix_inst (
			.clk                 (clk                	), 
			.reset               (!reset             	),
			
			.run                 (mpf_to_buffer_run  	), 
			.M                   (M[31:0]            	), 
			.N                   (N[31:0]            	),  
			.K                   (K[31:0]            	),  
			.done                (mpf_to_buffer_done 	), 
			.first_clAddr_A      (src_clAddr_A		 	), 
			.first_clAddr_B      (src_clAddr_B   	 	),
			
			.c0TxAlmFull         (fiu.c0TxAlmFull    	), 
			.c0TxValid           (fiu.c0Tx.valid     	), 
			.reqMemHdr           (fiu.c0Tx.hdr       	), 
			
			.c0Rx                (fiu.c0Rx           	),
			
			.buffer_wr_enable_A  (read_buffer_wr_enable_A	), 
			.full_n_A            (read_buffer_full_n_A		), 
			.buffer_wr_enable_B  (read_buffer_wr_enable_B 	), 
			.full_n_B            (read_buffer_full_n_B		)
		);
	
	// Read from read buffers as long as there is something to read and there is space for it to be written on the write buffer
	assign read_buffer_rd_enable_A = (! write_buffer_full_n && ! read_buffer_empty_A && ! read_buffer_empty_B)? 1 : 0;
	assign read_buffer_rd_enable_B = (! write_buffer_full_n && ! read_buffer_empty_A && ! read_buffer_empty_B)? 1 : 0;
	
	//
	// FFT Kernel
	//
	
	/*logic aes_valid_input;
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
	
	// Shift register to delay data
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
	end*/
	
	//
	// Multiply add 512 bits of data (floats)
	//
	
	logic mults_input_valid;
	always_ff @(posedge clk) begin
		mults_input_valid <= read_buffer_rd_enable_A;
	end
	
	// How many cols_cl?
	logic [27:0] K_cl;
	assign K_cl = K >> 4; 
	
	// Which col_cl is being computed?
	logic [31:0] current_col_cl;
	
	always_ff @(posedge clk) begin
		if (reset)  begin
			current_col_cl <= 'd0;
		end
		else begin
			if( run ) begin
				current_col_cl <= 'd0;
			end
			else begin
				if( mults_input_valid ) begin
					if( current_col_cl == K_cl - 1'd1) begin
						current_col_cl <= 'd0;
					end
					else begin
						current_col_cl <= current_col_cl + 1'd1;
					end
				end
			end
		end
	end
	
	logic start_line;
	assign start_line = (current_col_cl == 'd0);
	
	logic end_line;
	assign end_line = (current_col_cl == K_cl - 1'd1);
	
	// Shift register to delay valid signal
	logic signal_shift_reg[0:16];
	assign signal_shift_reg[0]	= (end_line && mults_input_valid); // At the end of this cycle the last 512 bits of data of the line enters the mults
	
	always_ff @(posedge clk) begin
		for(int i = 1; i<=16; i++) begin
			signal_shift_reg[i]	<= signal_shift_reg[i-1];
		end
	end
	
	// Mults
	genvar i;
	generate
		for(i = 0; i<16; i=i+1) begin : genmults
			
			logic accumulate;
			logic [31:0] fp_mult_result;
			
			assign accumulate = (!start_line);
			
			fp_mult_accumulate fp_mult_accumulate_inst (
					.clk		(clk										),		//    clk.clk
					.aclr   	(reset										),   	//   aclr.aclr
					.ena		(mults_input_valid							),		//    ena.ena
					.accumulate	(accumulate									),		// accumulate or not
					.ay     	(read_buffer_data_out_A[ 31 + i*32 : i*32 ]	),     	//     ay.ay
					.az     	(read_buffer_data_out_B[ 31 + i*32 : i*32 ]	),     	//     az.az
					.result 	(fp_mult_result								)  		// result.result
				);
			
		end
	endgenerate
	
	generate
		for(i = 0; i<8; i=i+1) begin : genadds1
			
			logic [31:0] fp_add_result;
			
			fp_add fp_add_inst (
					.clk    (clk								),    	//    clk.clk
					.aclr   (reset								),   	//   aclr.aclr
					.ena    (signal_shift_reg[4]				),    	//    ena.ena
					.ax     (genmults[i*2].fp_mult_result		),     	//     ax.ax
					.ay     (genmults[i*2+1].fp_mult_result		),     	//     ay.ay
					.result (fp_add_result						)  		// result.result
				);
			
		end
	endgenerate
	
	generate
		for(i = 0; i<4; i=i+1) begin : genadds2
			
			logic [31:0] fp_add_result;
			
			fp_add fp_add_inst (
					.clk    (clk								),    	//    clk.clk
					.aclr   (reset								),   	//   aclr.aclr
					.ena    (signal_shift_reg[7]				),    	//    ena.ena
					.ax     (genadds1[i*2].fp_add_result		),     	//     ax.ax
					.ay     (genadds1[i*2+1].fp_add_result		),     	//     ay.ay
					.result (fp_add_result						)  		// result.result
				);
			
		end
	endgenerate
	
	generate
		for(i = 0; i<2; i=i+1) begin : genadds3
			
			logic [31:0] fp_add_result;
			
			fp_add fp_add_inst (
					.clk    (clk								),    	//    clk.clk
					.aclr   (reset								),   	//   aclr.aclr
					.ena    (signal_shift_reg[10]				),    	//    ena.ena
					.ax     (genadds2[i*2].fp_add_result		),     	//     ax.ax
					.ay     (genadds2[i*2+1].fp_add_result		),     	//     ay.ay
					.result (fp_add_result						)  		// result.result
				);
			
		end
	endgenerate
	
	logic [31:0] fp_add_result;
	
	fp_add fp_add_inst (
			.clk    (clk								),    	//    clk.clk
			.aclr   (reset								),   	//   aclr.aclr
			.ena    (signal_shift_reg[13]				),    	//    ena.ena
			.ax     (genadds3[0].fp_add_result			),     	//     ax.ax
			.ay     (genadds3[1].fp_add_result			),     	//     ay.ay
			.result (fp_add_result						)  		// result.result
		);
	
	logic fp_add_result_valid;
	assign fp_add_result_valid = signal_shift_reg[16];
	
	logic [3:0] write_position;
	always_ff @(posedge clk) begin
		if (reset)  begin
			write_position <= 'd0;
		end
		else begin
			if( run ) begin
				write_position <= 'd0;
			end
			else begin
				if(fp_add_result_valid) begin
					if( write_position == 4'b1111 ) begin
						write_position <= 'd0;
					end
					else begin
						write_position <= write_position + 1'd1;
					end
				end
			end
		end
	end
	
	logic [511:0] cl_buffer;
	
	always_ff @(posedge clk) begin
		if (reset)  begin
			cl_buffer <= 'd0;
		end
		else begin
			if(fp_add_result_valid) begin
				case (write_position)
					4'd0 : cl_buffer[31:0] <= fp_add_result;
					4'd1 : cl_buffer[63:32] <= fp_add_result;
					4'd2 : cl_buffer[95:64] <= fp_add_result;
					4'd3 : cl_buffer[127:96] <= fp_add_result;
					4'd4 : cl_buffer[159:128] <= fp_add_result;
					4'd5 : cl_buffer[192:160] <= fp_add_result;
					4'd6 : cl_buffer[223:192] <= fp_add_result;
					4'd7 : cl_buffer[255:224] <= fp_add_result;
					4'd8 : cl_buffer[287:256] <= fp_add_result;
					4'd9 : cl_buffer[319:288] <= fp_add_result;
					4'd10 : cl_buffer[351:320] <= fp_add_result;
					4'd11 : cl_buffer[383:352] <= fp_add_result;
					4'd12 : cl_buffer[415:384] <= fp_add_result;
					4'd13 : cl_buffer[447:416] <= fp_add_result;
					4'd14 : cl_buffer[479:448] <= fp_add_result;
					4'd15 : cl_buffer[511:480] <= fp_add_result;
				endcase
			end
		end
	end
	
	logic cl_ready;
	
	always_ff @(posedge clk) begin
		if (reset)  begin
			cl_ready <= 1'b0;
		end
		else begin
			cl_ready <= (write_position == 4'd15 && fp_add_result_valid);
		end
	end
		
	assign write_buffer_wr_enable 		= cl_ready;
	assign write_buffer_data_in[511:0] 	= cl_buffer[511:0];
	
	//
	// Write buffer
	//
	
	generic_fifo_sc_a #(
			.dw(512),
			.aw(8),
			.n(128)) 
		generic_fifo_sc_a_write  (
			.clk        (clk       					), 
			.rst        (!reset       				), 
			.clr        (reset       				), 
			.din        (write_buffer_data_in 		), 
			.we         (write_buffer_wr_enable 	), 
			.dout       (write_buffer_data_out      ), 
			.re         (write_buffer_rd_enable     ), 
			.full       (      						), 
			.empty      (write_buffer_empty     	), 
			.full_r     ( 							), 
			.empty_r    ( 							), 
			.full_n     (write_buffer_full_n 		), 
			.empty_n    ( 							), 
			.full_n_r   ( 							), 
			.empty_n_r  ( 							), 
			.level      ( 							)
		);
	
	assign fiu.c1Tx.data[511:0] = write_buffer_data_out[511:0];
	

	logic buffer_to_mpf_run;
	logic buffer_to_mpf_done;
	
	assign buffer_to_mpf_run = run[0:0];
	
	buffer_to_mpf_SM_matrix buffer_to_mpf_SM_matrix_inst (
			.clk               	(clk              		), 
			.reset             	(!reset           		),
			
			.run               	(buffer_to_mpf_run   	), 
			.M					(M[15:0]				),
			.N					(N[15:0]				),
			.K					(K[15:0]				),
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
