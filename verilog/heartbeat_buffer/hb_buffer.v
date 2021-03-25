module hb_buffer(input clock, input reset, input sample, input heartbeat_detect, output [13:0] beat, output [13:0] newbeat);

reg [13:0] hb_index [1:0];

assign beat = hb_index[0];
assign newbeat = hb_index[1];

always@(posedge clock)
begin
	if (reset)
	begin
		hb_index[0] <= 0;
		hb_index[1] <= 0;
	end
	else
	begin
		if (heartbeat_detect)
		begin
			hb_index[0] <= hb_index[1] - hb_index[0];
			hb_index[1] <= hb_index[1] - hb_index[0] + 1;
		end
		else if (sample)
		begin
			hb_index[1] <= hb_index[1] + 1;
		end
	end
end

endmodule