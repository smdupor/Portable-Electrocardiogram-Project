module relay_logic(input clock, input toHigh, input toLow, input reset, input sample, output [2:0] pin3, output [2:0] pin11, output pin12, output pin13, output [3:0] gain);

wire [3:0] count;
assign gain = count;

counter			LEVEL(clock, toHigh, toLow, reset, sample, count);
count_to_relays MAP(count, pin3, pin11, pin12, pin13);

endmodule