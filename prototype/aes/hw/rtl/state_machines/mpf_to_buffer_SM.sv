/****************************************************************************
 * mpf_to_buffer_SM.sv
 ****************************************************************************/

/**
 * Module: mpf_to_buffer_SM
 * 
 * TODO: Add module documentation
 */
 
`include "cci_mpf_if.vh"
 
module mpf_to_buffer_SM(
		input clk, reset, // Reset is active low
		
		input run,				// Assert high 1 clock cycle to start reading data from memory
		input [63:0] data_length,		// How many cache lines? Must be maintained during operation
		output done,			// Goes high when all data has been written to buffer
		
		input t_cci_clAddr first_clAddr,	// First virtual address - Must be maintained during operation
		
		// Connection toward the host.
		input 				c0TxAlmFull,
		output reg			c0TxValid,
		output reg [CCI_MPF_C0TX_MEMHDR_WIDTH-1:0] reqMemHdr,

		input t_if_ccip_c0_Rx c0Rx,
		
		output buffer_wr_enable,		// Control signal for buffer
		input  full_n					// Indicates the buffer as space for N entries (at the moment is set to 40)
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
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			next_clAddr <= 'd0;
		end
		else begin
			if( run ) begin
				next_clAddr <= first_clAddr;
			end
			else if (c0TxValid) begin
				next_clAddr <= next_clAddr + 1'd1;
			end
		end
	end
	
	// Done sending requests condition
	logic requests_done;
	assign requests_done = ( (next_clAddr - first_clAddr) >= data_length)? 1 : 0;
	
	
	//
	//	Counter so that read requests are made only at the consumption rate
	//
	logic [2:0] read_counter;
	logic rd_req_trigger;
	assign rd_req_trigger = (read_counter[2:0] == 3'd1)? 1 : 0;
	
	always_ff @(posedge clk) begin
		if(!reset) begin
			read_counter <= 3'd0;
		end
		else begin
			if( read_counter[2:0] < 3'd7 ) begin
				read_counter[2:0] <= read_counter[2:0] + 1'b1;
			end
			else begin
				read_counter[2:0] <= 3'd0;
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
		rd_hdr = cci_mpf_c0_genReqHdr(eREQ_RDLINE_I,
				next_clAddr,
				t_cci_mdata'(0),
				rd_hdr_params);
	end
	
	// When to effectively request a read? This will drive fiu.c0Tx.valid
	logic read_valid;
	assign read_valid = (//rd_req_trigger && 
			! c0TxAlmFull && 
			! full_n && 
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
			//fiu.c0Tx <= cci_mpf_genC0TxReadReq(rd_hdr,
			//		read_valid);

			{ reqMemHdr , c0TxValid } <= cci_mpf_genC0TxReadReq(rd_hdr,
					read_valid);

			if (read_valid)
			begin
				$display("Sent read request number %d for VA 0x%x", next_clAddr-first_clAddr+1 ,clAddrToByteAddr(next_clAddr));
			end
		end
	end
	
	
	
	//
	// READ RESPONSE HANDLING
	//
	
	assign buffer_wr_enable = cci_c0Rx_isReadRsp(c0Rx);
	
	// Check when all data has been received so that done condition can be detected
	t_cci_clAddr addr_to_be_received;
	
	always_ff @(posedge clk) begin
		if (!reset)  begin
			addr_to_be_received <= 'd0;
		end
		else begin
			if (run) begin
				addr_to_be_received <= first_clAddr;
			end
			else if (cci_c0Rx_isReadRsp(c0Rx)) begin
				addr_to_be_received <= addr_to_be_received + 1'b1;
				$display("Received a response for read request number %d", addr_to_be_received - first_clAddr + 1);
			end
		end
	end
	
	assign done_condition = ( (addr_to_be_received - first_clAddr) >= data_length )? 1 : 0;
	
	
endmodule


