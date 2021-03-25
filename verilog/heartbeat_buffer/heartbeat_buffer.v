module heartbeat_buffer(input clock, input reset, input sample, input [15:0] data, input read, output full, output reg [15:0] dataout, output reg done);

reg [15:0] buffer [0:99];
reg [6:0] read_index;
reg [6:0] write_index;

assign full = (write_index == 7'd100);

always@(posedge clock)
begin
	if (~reset)
	begin
		read_index <= 0;
		write_index <= 0;
	end
	else
	begin
		if (sample)
		begin
			write_index <= write_index + 1'd1;
			buffer[write_index] <= data;
		end
		
		if (read)
		begin
			read_index <= read_index + 1'd1;
			dataout <= buffer[read_index];
		end
		else
			read_index <= 0;
	end
end

endmodule