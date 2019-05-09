/****************************************************************************
 * buffer_512_to_128.sv
 ****************************************************************************/

/**
 * Module: buffer_512_to_128
 * 
 * TODO: Add module documentation
 */
module buffer_512_to_128(
		input clk, rst, clr,
		
		input [511:0] data_in,
		input wr_enable,

		output reg [127:0] data_out,
		input rd_enable,
		
		output full,
		output empty,
		output full_n
		);

	logic [1:0] select;
	logic [1:0] select_shifted;
	
	genvar i;
	generate
		for(i = 0; i<4; i=i+1) begin : genfifos

			
			logic [127:0] dout;
			logic re;
			logic full;
			logic empty;
			logic full_n;
			
			assign re = (select_shifted[1:0] == i && rd_enable)? 1 : 0;
			
			generic_fifo_sc_a #(
					.dw(128),
					.aw(9),
					.n(256)) 
				generic_fifo_sc_a_inst  (
					.clk        (clk       ), 
					.rst        (rst       ), 
					.clr        (clr       ), 
					.din        (data_in[i*128+127 :i*128 ] ), 
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
			3'd0 : data_out = genfifos[0].dout[127:0];
			3'd1 : data_out = genfifos[1].dout[127:0];
			3'd2 : data_out = genfifos[2].dout[127:0];
			3'd3 : data_out = genfifos[3].dout[127:0];
		endcase
	end
	
	always @(posedge clk)
	begin
		if (!rst || clr) begin
			select[1:0] <= 2'b11;
		end
		else begin
			if (rd_enable && select [1:0] == 2'b11) begin // start up
				select[1:0] <= 2'b00;
			end
			else if (rd_enable && select[1:0] < 2'b11) begin
				select[1:0] <= select[1:0] + 1'b1;
			end
		end
	end
	
	always @(posedge clk)
	begin
		if (!rst || clr) begin
			select_shifted[1:0] <= 2'b00;
		end
		else begin
			if (rd_enable && select_shifted[1:0] == 2'b11) begin // start up
				select_shifted[1:0] <= 2'b00;
			end
			else if (rd_enable && select_shifted[1:0] < 2'b11) begin
				select_shifted[1:0] <= select_shifted[1:0] + 1'b1;
			end
		end
	end
	
	
	assign full = genfifos[3].full;
	assign empty = genfifos[3].empty;
	assign full_n = genfifos[3].full_n;

endmodule


