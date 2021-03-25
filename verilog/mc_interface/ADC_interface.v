module ADC_interface(
	input clock,
	input reset,
	
	output reg [1:0] SC,
	output reg cal,
	output reg sleep_n,
	output reg cs_n,
	
	input drdy_n,
	output sclk,
	input sdata,
	
	output reg [15:0] data
	);

reg [2:0] state;

always@(posedge sclk)
begin
	if (reset)
		data	<= 0;
	else
	begin
		if (state == 1)
		begin
			data	<= {data[14:0], sdata};
		end
	end
end

always@(posedge clock)
begin
	if (reset)
	begin
		SC		<= 0;
		cal		<= 0;
		sleep_n	<= 1;
		cs_n	<= 1;
		
		state	<= 0;
	end
	else
	begin
		case (state)
		3'd0:
		begin
			if (~drdy_n)
			begin
				cs_n	<= 0;
				state	<= 1;
			end
		end
		3'd1:
		begin
			if (drdy_n)
			begin
				cs_n	<= 1;
				state	<= 0;
			end
		end
		endcase
	end
end

endmodule
