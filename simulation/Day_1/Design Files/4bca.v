`timescale 1ns / 1ps

module full_adder (
    input a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module ripple_carry_adder_4bit (
    input [3:0] A, B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire w1, w2, w3;
    
    full_adder fa0 (A[0], B[0], Cin, Sum[0], w1);
    full_adder fa1 (A[1], B[1], w1,  Sum[1], w2);
    full_adder fa2 (A[2], B[2], w2,  Sum[2], w3);
    full_adder fa3 (A[3], B[3], w3,  Sum[3], Cout);
endmodule
