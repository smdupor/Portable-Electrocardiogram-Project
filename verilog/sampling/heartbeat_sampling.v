module heartbeat_sampling(input clock, input reset, output sample);

reg [10:0] delay;

assign sample = (delay == 11'd999);

always@(posedge clock)
begin
	if (~reset)
	begin
		delay <= 11'd0;
	end
	else
	begin
		if (~sample)
		begin
			delay <= delay + 11'd1;
		end
		else
		begin
			delay <= 11'd0;
		end
	end
end

endmodule