/****************************************************************************
 * buffer_512_to_64_tb.sv
 ****************************************************************************/

/**
 * Module: buffer_64_to_512_tb
 * 
 * TODO: Add module documentation
 */

//`timescale 1ns / 100ps; 
 
`include "cci_mpf_if.vh"
 
module mpf_to_buffer_SM_tb;

	// general parameters 
	parameter CLOCK_PERIOD = 10;              // Clock period in ns
	parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)
	
	
	// Registers for driving the inputs:
	reg clk, rst, clr;
	reg run;
	reg [63:0] data_length;
	t_cci_clAddr first_clAddr;
	cci_mpf_if.to_fiu.c0Tx c0Tx;
	cci_mpf_if.to_fiu.c0TxAlmFull 	c0TxAlmFull;	// When high we stop sending requests
	cci_mpf_if.to_fiu.c0Rx 			c0Rx;
	reg full_n;
	
	// Wires to connect to the outputs:
	logic done;
	logic buffer_wr_enable;
	
	// Instantiate the module under verification:
	mpf_to_buffer_SM mpf_to_buffer_SM_inst (
			.clk               (clk              ), 
			.reset             (reset            ), 
			.run               (run              ), 
			.data_length       (data_length      ), 
			.done              (done             ), 
			.first_clAddr      (first_clAddr     ), 
			.c0Tx              (c0Tx             ), 
			.c0TxAlmFull       (c0TxAlmFull      ), 
			.c0Rx              (c0Rx             ), 
			.buffer_wr_enable  (buffer_wr_enable ), 
			.full_n            (full_n           )
			);
	
	
	//---------------------------------------------------
	// Setup initial signals
	// generate 50% duty-cycle clock signal
	initial
	begin
		clk = 1'b0;
		rst = 1'b1;
		clr = 1'b0;
		run = 1'b0;
		data_length = 64'd0;
		first_clAddr = 'd0;
		wr_enable = 1'b0;
		rd_enable = 1'b0;
		full_m = 1'b0;
  
		forever
			# (CLOCK_PERIOD / 2 ) clk = ~clk;
	end
	
	//---------------------------------------------------
	// Apply the initial reset for 1.5 clock cycles:
	initial
	begin
		# 23 // wait 23 ns to misalign the reset pulse with the clock edges:
			rst = 0;
		# (2 * CLOCK_PERIOD ) // wait 2 clock periods
			rst = 1;
	end

	//---------------------------------------------------
	// Set the maximum simulation time:
	initial
	begin
		# ( MAX_SIM_TIME )
			$stop;
	end
	
	//---------------------------------------------------
	// Verification program
	initial
	begin
  
		#( 10*CLOCK_PERIOD );
		
		for(int i = 1; i <= 24; i++) begin
			exec_write( i );
		end
	
		exec_read(3);
  
		#( 10*CLOCK_PERIOD );
		$stop;  
	end

	// Write to the buffer
	task exec_write;
		input [63:0] data;
		begin
			data_in = data;   // Apply data
			@(negedge clk);
			wr_enable = 1'b1;       // Assert write enable
			@(negedge clk );
			wr_enable = 1'b0;  
			//repeat (32) @(posedge clk);  // Execute division
  
			// Print the results:
			//$display("%d / %d : quotient=%d,  rest=%d", dividend, divisor, quotient, rest );
		end  
	endtask
	
	// Write to the buffer
	task exec_read;
		input [63:0] n;
		begin
			@(negedge clk);
			rd_enable = 1'b1;       // Assert write enable
			# (n * CLOCK_PERIOD );
			rd_enable = 1'b0;  
			//repeat (32) @(posedge clk);  // Execute division
  
			// Print the results:
			//$display("%d / %d : quotient=%d,  rest=%d", dividend, divisor, quotient, rest );
		end  
	endtask

endmodule


