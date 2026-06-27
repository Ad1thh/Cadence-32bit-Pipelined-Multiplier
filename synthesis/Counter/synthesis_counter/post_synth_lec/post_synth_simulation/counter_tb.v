`timescale 1 ns/10 ps
module counter_tb();
reg clk, reset, up_down;
wire [3:0] count;
counter dut(clk, reset, up_down, count);
always #5 clk = ~clk;

initial begin
clk = 0; reset = 1; up_down = 0;
#20 reset = 0;
#200 up_down = 1;
#200 reset = 1;
#50 reset = 0;
#200 up_down = 0;
$finish;
end
endmodule

