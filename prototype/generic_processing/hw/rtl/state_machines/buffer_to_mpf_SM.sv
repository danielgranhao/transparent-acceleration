/****************************************************************************
 * mpf_to_buffer_SM.sv
 ****************************************************************************/

/**
 * Module: buffer_to_mpf_SM
 * 
 * TODO: Add module documentation
 */
 
`include "cci_mpf_if.vh"
 
module buffer_to_mpf_SM(
		input clk, reset, // Reset is active low
		
		input run,						// Assert high 1 clock cycle to start writing data to memory
		input [63:0] data_length,		// How many cache lines? Must be maintained during operation
		output done,					// Goes high when all data has been written to memory
		
		input t_cci_clAddr first_clAddr,	// First virtual address to write to - Must be maintained during operation
		
		// Connection toward the host.  
		input					c1TxAlmFull,
		output reg 				c1TxValid,
		output reg [CCI_MPF_C1TX_MEMHDR_WIDTH-1:0] 	reqMemHdr,

		input t_if_ccip_c1_Rx 			c1Rx,
		
		output buffer_rd_enable,		// Control signal for buffer
		input  buffer_empty				// Indicates if the buffer is empty
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
	//	Next addr to write to
	//
	t_cci_clAddr next_clAddr;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			next_clAddr <= 'd0;
		end
		else begin
			if( run ) begin
				next_clAddr <= first_clAddr;
			end
			else if (c1TxValid) begin
				next_clAddr <= next_clAddr + 1'd1;
			end
		end
	end
	
	// Done sending requests condition
	logic requests_done;
	assign requests_done = ( (next_clAddr - first_clAddr) >= data_length)? 1 : 0;
	
	//
	// Emit write requests to the FIU.
	//

	// Read header defines the request to the FIU
	t_cci_mpf_c1_ReqMemHdr wr_hdr;
	assign wr_hdr = cci_mpf_c1_genReqHdr(eREQ_WRLINE_I,
			next_clAddr,
			t_cci_mdata'(0),
			cci_mpf_defaultReqHdrParams(1));
	
	// Read from buffer when it isn't empty and it is possible to request write to memory
	assign buffer_rd_enable = (!c1TxAlmFull && 
			!buffer_empty && 
			state == STATE_RUN
			)? 1 : 0;
	
	// Send write requests to the FIU
	always_ff @(posedge clk)
	begin
		if (!reset)
		begin
			c1TxValid <= 1'b0;
		end
		else
		begin
			// Request write when we read from buffer
			c1TxValid <= buffer_rd_enable;

			if (buffer_rd_enable)
			begin
				$display("Sent write request to VA 0x%x", clAddrToByteAddr(next_clAddr));
			end
		end
		
		reqMemHdr <= wr_hdr;
	end
	
	//
	// WRITE RESPONSE HANDLING
	//
	
	// Check when all data has been written so that done condition can be detected
	t_cci_clAddr addr_to_be_received;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			addr_to_be_received <= 'd0;
		end
		else begin
			if (run) begin
				addr_to_be_received <= first_clAddr;
			end
			else if (cci_c1Rx_isWriteRsp(c1Rx)) begin
				addr_to_be_received <= addr_to_be_received + 1'b1;
				$display("Received a response for write request number %d", addr_to_be_received - first_clAddr + 1);
			end
		end
	end
	
	assign done_condition = ( (addr_to_be_received - first_clAddr) >= data_length )? 1 : 0;
	
endmodule


