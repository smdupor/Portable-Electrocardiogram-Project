module heartrate(input clock, input reset, input hb_detect, output d, input q, input full, output wen, output reg ren, output reg [7:0] rate);

assign d = hb_detect;
assign wen = !reset;

always@(posedge clock)
begin
	if (reset)
	begin
		rate <= 8'd0;
		ren <= 1'd0;
	end
	else
	begin
		if (full && !ren)
			ren <= 1'd1;
		
		if (ren)
			rate <= rate + hb_detect - q;
		else
			rate <= rate + hb_detect;
	end
end

endmodule