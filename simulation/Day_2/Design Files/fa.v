`timescale 1ns / 1ps

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output carry
);

    // Continuous assignments for combinational logic
    assign sum   = a ^ b ^ cin;
    assign carry = (a & b) | (cin & (a ^ b));

endmodule
