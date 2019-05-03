module counter_64bit(
	input 			clk, 
	input 			reset, 
	input 			on,
	output reg 	[63:0]	count
);
	
always_ff @(posedge clk)
begin
	if(reset)
	begin
		count <= 'h0; 
	end
	else if (on && (count == 64'hffff_ffff_ffff_ffff))
	begin
		count <= 64'h0;
	end
	else if (on)
	begin
		count <= count + 1'b1;
	end
end

endmodule
