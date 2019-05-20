/****************************************************************************
 * buffer_512_to_64.sv
 ****************************************************************************/

/**
 * Module: buffer_64_to_512
 * 
 * TODO: Add module documentation
 */
module buffer_64_to_512(
		input clk, rst, clr,
		
		input [63:0] data_in,
		input wr_enable,

		output [511:0] data_out,
		input rd_enable,
		
		output full,
		output empty,
		output full_n
		);
	
	logic [2:0] select_shifted;
	
	genvar i;
	generate
		for(i = 0; i<8; i=i+1) begin : genfifos

			logic [63:0] dout;
			logic we;
			logic full;
			logic empty;
			logic full_n;
			
			assign we = (select_shifted[2:0] == i && wr_enable)? 1 : 0;
			
			assign data_out[i*64+63 : i*64] = dout[63:0];
			
			generic_fifo_sc_a #(
					.dw(64),
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
			select_shifted[2:0] <= 3'b000;
		end
		else begin
			if (wr_enable && select_shifted[2:0] == 3'b111) begin // start up
				select_shifted[2:0] <= 3'b000;
			end
			else if (wr_enable && select_shifted[2:0] < 3'd7) begin
				select_shifted[2:0] <= select_shifted[2:0] + 1'b1;
			end
			else if (wr_enable && select_shifted[2:0] == 3'd7) begin
				select_shifted[2:0] <= 3'b000;
			end
		end
	end
	
	
	assign full = genfifos[7].full;
	assign empty = genfifos[7].empty;
	assign full_n = genfifos[7].full_n;

endmodule


