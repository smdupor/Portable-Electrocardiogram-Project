module mc_interface(input clock, 
					input reset, 
					
					input [15:0] data, // from hw 
					
					output reg [15:0] data_out
					);

always@(posedge clock)
begin
	if (~reset)
	begin
		data_out <= 0;
	end
	else
	begin
		data_out <= data;
	end
end

endmodule