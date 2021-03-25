module counter(input clock, input toHigh, input toLow, input reset, input enable, output reg [3:0] count);

always@(posedge clock)
begin
	if (reset)
	begin
		count <= 4'd5; //center
	end
	else
	begin
		if (enable)
		begin
			if (count > 4'd0 && count < 4'd13)
			begin
			if (toHigh)
			begin
				count <= count - 1'd1;
			end
			else if (toLow)
			begin
				count <= count + 1'd1;
			end
			end
		end
	end	
end

endmodule