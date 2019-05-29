/****************************************************************************
 * mpf_to_buffer_SM.sv
 ****************************************************************************/

/**
 * Module: mpf_to_buffer_SM_matrix
 * 
 * TODO: Add module documentation
 */
 
`include "cci_mpf_if.vh"
 
module mpf_to_buffer_SM_matrix(
		input clk, reset, // Reset is active low
		
		input run,						// Assert high 1 clock cycle to start reading data from memory
		input [31:0] M,					// lines of A
		input [31:0] N,					// cols of B (lines when transposed)
		input [31:0] K,					// cols of A and lins of B (cols of B also when transposed)
		output done,					// Goes high when all data has been written to buffer
		
		input t_cci_clAddr first_clAddr_A,	// First virtual address matrix A- Must be maintained during operation
		input t_cci_clAddr first_clAddr_B,	// First virtual address matrix B- Must be maintained during operation
		
		// Connection toward the host.
		input 				c0TxAlmFull,
		output reg			c0TxValid,
		output reg [CCI_MPF_C0TX_MEMHDR_WIDTH-1:0] reqMemHdr,

		input t_if_ccip_c0_Rx c0Rx,
		
		output buffer_wr_enable_A,		// Control signal for buffer A
		input  full_n_A,					// Indicates the buffer A as space for N entries (at the moment is set to 40)
		
		output buffer_wr_enable_B,		// Control signal for buffer B
		input  full_n_B					// Indicates the buffer B as space for N entries (at the moment is set to 40)
		);
	
	
	//
	// States
	//
	typedef enum logic [0:0]{
		STATE_IDLE,
		STATE_RUN
	}
	t_state;

	t_state state;
	
	// Output done simply shows internal state
	assign done = (state == STATE_IDLE)? 1 : 0;
	
	logic done_condition;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			state <= STATE_IDLE;
		end
		else begin
			if (run) begin
				state <= STATE_RUN;
			end
			else if (done_condition) begin
				state <= STATE_IDLE;
			end
		end
	end
	
	//
	//	Next addr to read from
	//
	t_cci_clAddr next_clAddr;
	
	logic [31:0] current_col;
	logic [31:0] current_line_A;
	logic [31:0] current_line_B;
	logic [63:0] current_line_A_offset;
	logic [63:0] current_line_B_offset;
	
	// Number of reads per line
	logic [27:0] K_cl;
	assign K_cl[27:0] = K >> 4;
	
	
	typedef enum logic [0:0]{
		MATRIX_A,
		MATRIX_B
	}
	t_next_matrix;
	
	t_next_matrix next_matrix;
	
	logic read_valid;
	
	// Alternated between requests for blocks of matrix A and B
	always_ff @(posedge clk) begin
		if (!reset)  begin
			next_matrix <= MATRIX_A;
		end
		else begin
			if( run ) begin
				next_matrix <= MATRIX_A;
			end
			else begin
				if (read_valid) begin
					if(next_matrix == MATRIX_A) begin
						next_matrix <= MATRIX_B;
					end
					else begin
						next_matrix <= MATRIX_A;
					end
				end
			end
		end
	end
	
	always_comb begin
		if(next_matrix == MATRIX_A) begin
			next_clAddr = first_clAddr_A + current_line_A_offset[63:0] + current_col[31:0];
		end
		else begin
			next_clAddr = first_clAddr_B + current_line_B_offset[63:0] + current_col[31:0];
		end
	end
	
	// Done sending requests condition
	logic requests_done;

	always_ff @(posedge clk) begin
		if (!reset)  begin
			requests_done   		<= 'd0;
			current_col 			<= 'd0;
			current_line_A 			<= 'd0;
			current_line_B 			<= 'd0;
			current_line_A_offset 	<= 'd0;
			current_line_B_offset 	<= 'd0;
		end
		else begin
			if( run ) begin
				requests_done   		<= 'd0;
				current_col 			<= 'd0;
				current_line_A 			<= 'd0;
				current_line_B 			<= 'd0;
				current_line_A_offset 	<= 'd0;
				current_line_B_offset 	<= 'd0;
			end
			else if (read_valid && next_matrix == MATRIX_B) begin
				
				if( current_col == K_cl - 1'd1 ) begin // Go through columns in 512 bit blocks
					if(current_line_B == N - 1'd1 ) begin // Go through lines (columns) of B
						if(current_line_A == M - 1'd1 ) begin // Go through lines of A
							requests_done <= 1'b1;
						end
						else begin
							current_line_A <= current_line_A + 1'd1;
							current_line_A_offset <= current_line_A_offset + K_cl[27:0];
						end
						current_line_B <= 'd0;
						current_line_B_offset <= 'd0;
					end
					else begin
						current_line_B <= current_line_B + 1'd1; 
						current_line_B_offset <= current_line_B_offset + K_cl[27:0]; 
					end
					current_col <= 'd0;
				end
				else begin
					current_col <= current_col + 1'd1;
				end
				
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
		// Read 1 lines (could read 1, 2 or 4)
		rd_hdr_params.cl_len = eCL_LEN_1;

		// Generate the header
		if( next_matrix == MATRIX_A ) begin
			rd_hdr = cci_mpf_c0_genReqHdr(eREQ_RDLINE_S,
					next_clAddr,
					t_cci_mdata'('d0),
					rd_hdr_params);
		end
		else begin
			rd_hdr = cci_mpf_c0_genReqHdr(eREQ_RDLINE_S,
					next_clAddr,
					t_cci_mdata'('d1),
					rd_hdr_params);
		end
	end
	
	// When to effectively request a read? This will drive fiu.c0Tx.valid
	assign read_valid = (/*rd_req_trigger && */
			! c0TxAlmFull && 
			! full_n_A &&
			! full_n_B &&
			! requests_done && 
			state == STATE_RUN)? 1 : 0;
	
	// Send read requests to the FIU
	always_ff @(posedge clk)
	begin
		if (!reset)
		begin
			c0TxValid <= 1'b0;
		end
		else
		begin
			// Generate a read request when needed and the FIU isn't full
			{ reqMemHdr , c0TxValid } <= cci_mpf_genC0TxReadReq(rd_hdr,
					read_valid);

			if (read_valid)
			begin
				if(next_matrix == MATRIX_A) begin
					$display("MATRIX A: Sent read request number %d for VA 0x%x", next_clAddr-first_clAddr_A+1 ,clAddrToByteAddr(next_clAddr));
				end
				else begin
					$display("MATRIX B: Sent read request number %d for VA 0x%x", next_clAddr-first_clAddr_B+1 ,clAddrToByteAddr(next_clAddr));
				end
			end
		end
	end
	
	// Count number of read reqs
	logic [31:0] nread_rq;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			nread_rq <= 'd0;
		end
		else begin
			if ( run ) begin
				nread_rq <= 'd0;
			end
			else if( c0TxValid ) begin
				nread_rq <= nread_rq + 1'd1;
			end
		end
	end
	
	
	//
	// READ RESPONSE HANDLING
	//
	
	logic readRspAvailable;
	assign readRspAvailable = cci_c0Rx_isReadRsp(c0Rx);
	
	assign buffer_wr_enable_A = readRspAvailable && (c0Rx.hdr.mdata == 'd0);
	assign buffer_wr_enable_B = readRspAvailable && (c0Rx.hdr.mdata == 'd1);
	
	// Check when all data has been received so that done condition can be detected
	logic [31:0] nread_resp;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			nread_resp <= 'd0;
		end
		else begin
			if (run) begin
				nread_resp <= 'd0;
			end
			else if (readRspAvailable) begin
				nread_resp <= nread_resp + 1'b1;
				$display("Received a response for read request number %d", nread_resp + 1);
			end
		end
	end
	
	assign done_condition = ( nread_resp == nread_rq && requests_done );
	
	
endmodule


