module counter(input clk, reset,
up_down, output reg [3:0] count);
always @(posedge clk or posedge reset)
begin
if (reset)
count <= 4'h0;
else if (up_down)
count <= count + 1;
else
count <= count - 1;
end
endmodule
