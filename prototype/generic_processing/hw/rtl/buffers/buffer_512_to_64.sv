/****************************************************************************
 * buffer_512_to_64.sv
 ****************************************************************************/

/**
 * Module: buffer_512_to_64
 * 
 * TODO: Add module documentation
 */
module buffer_512_to_64(
		input clk, rst, clr,
		
		input [511:0] data_in,
		input wr_enable,

		output reg [63:0] data_out,
		input rd_enable,
		
		output full,
		output empty,
		output full_n
		);

	logic [2:0] select;
	
	genvar i;
	generate
		for(i = 0; i<8; i=i+1) begin : genfifos

			
			logic [63:0] dout;
			logic re;
			logic full;
			logic empty;
			logic full_n;
			
			assign re = (select[2:0] == i && rd_enable)? 1 : 0;
			
			generic_fifo_sc_a #(
					.dw(64),
					.aw(8),
					.n(40)) 
				generic_fifo_sc_a_inst  (
					.clk        (clk       ), 
					.rst        (rst       ), 
					.clr        (clr       ), 
					.din        (data_in[i*64+63 :i*64 ] ), 
					.we         (wr_enable ), 
					.dout       (dout      ), 
					.re         (re        ), 
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
		
	always @(*)
	begin
		case ( select )
			3'd0 : data_out = genfifos[0].dout[63:0];
			3'd1 : data_out = genfifos[1].dout[63:0];
			3'd2 : data_out = genfifos[2].dout[63:0];
			3'd3 : data_out = genfifos[3].dout[63:0];
			3'd4 : data_out = genfifos[4].dout[63:0];
			3'd5 : data_out = genfifos[5].dout[63:0];
			3'd6 : data_out = genfifos[6].dout[63:0];
			3'd7 : data_out = genfifos[7].dout[63:0];
		endcase
	end
	
	always @(posedge clk)
	begin
		if (rst || clr) begin
			select[2:0] <= 3'b000;
		end
		else begin
			if (rd_enable && select[2:0] < 3'd7) begin
				select[2:0] <= select[2:0] + 1'b1;
			end
			else if (rd_enable && select[2:0] == 3'd7) begin
				select[2:0] <= 3'b000;
			end
		end
	end
	
	assign full = genfifos[7].full;
	assign empty = genfifos[7].empty;
	assign full_n = genfifos[7].full_n;

endmodule


