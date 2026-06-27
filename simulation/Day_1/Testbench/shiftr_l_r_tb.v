`timescale 1ns / 1ps

module tb_shift_registers;
    reg clk, rst_n, serial_in;
    wire [3:0] q_left, q_right;

    shift_registers uut (.clk(clk), .rst_n(rst_n), .serial_in(serial_in), .q_left(q_left), .q_right(q_right));
    always #5 clk = ~clk;

    initial begin
        $dumpfile("shift_reg.vcd"); 
        $dumpvars(0, tb_shift_registers);
        
        clk = 0; rst_n = 0; serial_in = 0; #10; rst_n = 1;
        @(posedge clk); serial_in = 1;
        @(posedge clk); serial_in = 1;
        @(posedge clk); serial_in = 0;
        @(posedge clk); serial_in = 1;
        repeat(4) @(posedge clk);
        $finish;
    end
endmodule
