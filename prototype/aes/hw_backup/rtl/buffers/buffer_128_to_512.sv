/****************************************************************************
 * buffer_128_to_512.sv
 ****************************************************************************/

/**
 * Module: buffer_128_to_512
 * 
 * TODO: Add module documentation
 */
module buffer_128_to_512(
		input clk, rst, clr,
		
		input [127:0] data_in,
		input wr_enable,

		output [511:0] data_out,
		input rd_enable,
		
		output full,
		output empty,
		output full_n
		);
	
	logic [1:0] select_shifted;
	
	genvar i;
	generate
		for(i = 0; i<4; i=i+1) begin : genfifos

			logic [127:0] dout;
			logic we;
			logic full;
			logic empty;
			logic full_n;
			
			assign we = (select_shifted[1:0] == i && wr_enable)? 1 : 0;
			
			assign data_out[i*128+127 : i*128] = dout[127:0];
			
			generic_fifo_sc_a #(
					.dw(128),
					.aw(9),
					.n(256)) 
				generic_fifo_sc_a_inst  (
					.clk        (clk       ), 
					.rst        (rst       ), 
					.clr        (clr       ), 
					.din        (data_in   ), 
					.we         (we        ), 
					.dout       (dout      ), 
					.re         (rd_enable ), 
					.full       (full      ), 
					.empty      (empty     ), 
					.full_r     ( ), 
					.empty_r    ( ), 
					.full_n     (full_n ), 
					.empty_n    ( ), 
					.full_n_r   ( ), 
					.empty_n_r  ( ), 
					.level      ( ));
		end
	endgenerate
	
	always @(posedge clk)
	begin
		if (!rst || clr) begin
			select_shifted[1:0] <= 2'b00;
		end
		else begin
			if (wr_enable && select_shifted[1:0] == 2'b11) begin // start up
				select_shifted[1:0] <= 2'b00;
			end
			else if (wr_enable && select_shifted[1:0] < 2'b11) begin
				select_shifted[1:0] <= select_shifted[1:0] + 1'b1;
			end
		end
	end
	
	
	assign full = genfifos[3].full;
	assign empty = genfifos[3].empty;
	assign full_n = genfifos[3].full_n;

endmodule


