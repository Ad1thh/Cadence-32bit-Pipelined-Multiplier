`timescale 1ns / 1ps

module mux21 (
    input in0, in1,
    input sel,
    output out
);
    assign out = sel ? in1 : in0;
endmodule
