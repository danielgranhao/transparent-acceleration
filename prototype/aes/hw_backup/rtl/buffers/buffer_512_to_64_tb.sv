/****************************************************************************
 * buffer_512_to_64_tb.sv
 ****************************************************************************/

/**
 * Module: buffer_512_to_64_tb
 * 
 * TODO: Add module documentation
 */

//`timescale 1ns / 100ps; 
 
module buffer_512_to_64_tb;

	// general parameters 
	parameter CLOCK_PERIOD = 10;              // Clock period in ns
	parameter MAX_SIM_TIME = 100_000_000;     // Set the maximum simulation time (time units=ns)
	
	
	// Registers for driving the inputs:
	reg clk, rst, clr;
	reg [511:0] data_in;
	reg wr_enable;
	reg rd_enable;
	
	// Wires to connect to the outputs:
	wire [63:0] data_out;
	wire full, empty, full_n;
	
	// Instantiate the module under verification:
	buffer_512_to_64 buffer_512_to_64 (
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
		data_in = 512'd0;
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
  
		exec_write( {64'd8, 64'd7, 64'd6, 64'd5, 64'd4, 64'd3, 64'd2, 64'd1} );
		exec_write( {64'd16, 64'd15, 64'd14, 64'd13, 64'd12, 64'd11, 64'd10, 64'd9} );
		exec_write( {64'd24, 64'd23, 64'd22, 64'd21, 64'd20, 64'd19, 64'd18, 64'd17} );
		
		//repeat (24) exec_read(1);
		exec_read(24);
  
		#( 10*CLOCK_PERIOD );
		$stop;  
	end

	// Write to the buffer
	task exec_write;
		input [511:0] data;
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


