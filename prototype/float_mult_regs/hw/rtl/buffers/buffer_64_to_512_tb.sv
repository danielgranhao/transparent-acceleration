/****************************************************************************
 * buffer_512_to_64_tb.sv
 ****************************************************************************/

/**
 * Module: buffer_64_to_512_tb
 * 
 * TODO: Add module documentation
 */

//`timescale 1ns / 100ps; 
 
module buffer_64_to_512_tb;

	// general parameters 
	parameter CLOCK_PERIOD = 10;              // Clock period in ns
	parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)
	
	
	// Registers for driving the inputs:
	reg clk, rst, clr;
	reg [63:0] data_in;
	reg wr_enable;
	reg rd_enable;
	
	// Wires to connect to the outputs:
	wire [511:0] data_out;
	wire full, empty, full_n;
	
	// Instantiate the module under verification:
	buffer_64_to_512 buffer_64_to_512 (
			.clk        (clk       ), 
			.rst        (rst       ), 
			.clr        (clr       ), 
			.data_in    (data_in   ), 
			.wr_enable  (wr_enable ), 
			.data_out   (data_out  ), 
			.rd_enable  (rd_enable ), 
			.full       (full      ), 
			.empty      (empty     ), 
			.full_n     (full_n    ));
	
	
	//---------------------------------------------------
	// Setup initial signals
	// generate 50% duty-cycle clock signal
	initial
	begin
		clk = 1'b0;
		rst = 1'b1;
		clr = 1'b0;
		data_in = 64'd0;
		wr_enable = 1'b0;
		rd_enable = 1'b0;
  
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


