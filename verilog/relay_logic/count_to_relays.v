module count_to_relays(input [3:0] count, output [2:0] pin3, output [2:0] pin11, output pin12, output pin13);

reg [7:0] relays;

assign {pin3, pin11, pin12, pin13} = relays;

always@(*)
begin
	case(count)
	4'd0:  relays = 8'b000_000_0_0;
	4'd1:  relays = 8'b001_000_0_0;
	4'd2:  relays = 8'b001_001_0_0;
	4'd3:  relays = 8'b001_100_0_0;
	4'd4:  relays = 8'b001_101_0_0;
	4'd5:  relays = 8'b010_000_0_0;
	4'd6:  relays = 8'b010_000_0_0;
	4'd7:  relays = 8'b010_001_0_0;
	4'd8:  relays = 8'b010_010_0_1;
	4'd9:  relays = 8'b100_000_0_0;
	4'd10: relays = 8'b100_000_0_1;
	4'd11: relays = 8'b100_000_0_1;
	4'd12: relays = 8'b100_100_1_0;	
	4'd13: relays = 8'b100_010_1_0;	
	default: relays = 8'b000_000_0_0;
	endcase
end

endmodule