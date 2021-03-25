`define ADDRESS_RANGE 13'd8190

module hb_mem(input clock, 
			input reset, 
			input read, 
			input heartbeat_detect, 
			input [11:0] data, 
			output [12:0] w_address,
			output [12:0] r_address,
			output wren,
			output [15:0] data_out,
			output done);

reg [12:0] index [2:0];
reg [12:0] w_index;
reg [12:0] r_index[1:0];

reg [12:0] center [1:0];

always@(*)
begin
	if (index[0] < index[1])
		center[0] = (index[0] + index[1])>>1;
	else
	begin
		if ((index[0] + `ADDRESS_RANGE + 1 + index[1])>>1 > `ADDRESS_RANGE)
			center[0] = ((index[0] + `ADDRESS_RANGE + 1'd1 + index[1])>>1) - `ADDRESS_RANGE - 1'd1;
		else
			center[0] = (index[0] + `ADDRESS_RANGE + 1'd1 + index[1])>>1;
	end

	if (index[1] > index[2])
	begin
		if ((index[1] + `ADDRESS_RANGE + 1 + index[2])>>1 > `ADDRESS_RANGE)
			center[1] = ((index[1] + `ADDRESS_RANGE + 1'd1 + index[2])>>1) - `ADDRESS_RANGE - 1'd1;
		else
			center[1] = (index[1] + `ADDRESS_RANGE + 1'd1 + index[2])>>1;
	end
	else
		center[1] = (index[1] + index[2])>>1;
end

assign w_address = w_index;
assign r_address = r_index[0];
assign wren = !reset;
assign data_out = data;

assign done = (read)?(r_index[0] == r_index[1]):1'd0;

//assign c0 = center[0];
//assign c1 = center[1];

always@(posedge clock)
begin
	if (reset)
	begin
		index[0] <= 0;
		index[1] <= 0;
		index[2] <= 0;
		w_index  <= 0;
		r_index[0] <= 0;
		r_index[1] <= 0;
	end
	else
	begin
		if (heartbeat_detect)
		begin
			index[0] <= index[1];
			index[1] <= index[2];
			index[2] <= w_index;
		end
		
		if (w_index == `ADDRESS_RANGE)
			w_index <= 0;
		else
			w_index <= w_index + 1'd1;
		
		if (!read)
		begin
			r_index[0] <= center[0];
			r_index[1] <= center[1];
		end
		
		if (read)
		begin
			if (r_index[0] != r_index[1])
			begin
				if (r_index[0] == `ADDRESS_RANGE)
					r_index[0] <= 0;
				else
					r_index[0] <= r_index[0] + 1'd1;
			end
		end
	end
end

endmodule