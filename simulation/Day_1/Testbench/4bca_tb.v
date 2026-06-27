`timescale 1ns / 1ps

module tb_ripple_carry_adder;
    reg [3:0] A, B;
    reg cin;
    wire [3:0] Sum;
    wire Cout;

    ripple_carry_adder_4bit uut (.A(A), .B(B), .Cin(cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $dumpfile("rca.vcd"); 
        $dumpvars(0, tb_ripple_carry_adder);
        
        A = 4'd5;  B = 4'd3;  cin = 0; #10;
        A = 4'd12; B = 4'd6;  cin = 0; #10;
        A = 4'd15; B = 4'd15; cin = 1; #10;
        $finish;
    end
endmodule
