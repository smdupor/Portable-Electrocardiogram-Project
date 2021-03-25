module heartbeat_detect(input clock, input toLow, output reg detected);

reg past;

always@(posedge clock)
begin
	if (past != toLow)
	begin
		if (!toLow)
			detected <= 1;
	end
	else
		detected <= 0;
		
	past <= toLow;
end

endmodule