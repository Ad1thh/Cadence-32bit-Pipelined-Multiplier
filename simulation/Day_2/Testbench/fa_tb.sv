`timescale 1ns / 1ps

module tb_full_adder;

    // SystemVerilog 'logic' data types
    logic a;
    logic b;
    logic cin;
    logic sum;
    logic carry;

    // Instantiate Unit Under Test (UUT)
    // '.*' automatically connects matching variable names to the module ports
    full_adder uut (.*);

    // Concurrent SystemVerilog Assertion (SVA)
    // This constantly monitors the inputs and ensures the hardware output matches the equation
    assert property (@(a or b or cin) (carry == ((a & b) | (cin & (a ^ b)))))
        else $error("Assertion Failed! Inputs: a=%b b=%b cin=%b | Expected Carry out mismatch!", a, b, cin);

    initial begin
        // Setup waveform dumping for Cadence SimVision
        $dumpfile("fa_sim.vcd");
        $dumpvars(0, tb_full_adder);

        // Display console header
        $display("Time\t a \t b \t cin \t sum \t carry");
        $monitor("%g\t %b \t %b \t  %b  \t  %b  \t   %b", $time, a, b, cin, sum, carry);

        // Apply all 8 input combinations
        a = 0; b = 0; cin = 0; #10;
        a = 0; b = 0; cin = 1; #10;
        a = 0; b = 1; cin = 0; #10;
        a = 0; b = 1; cin = 1; #10;
        a = 1; b = 0; cin = 0; #10;
        a = 1; b = 0; cin = 1; #10;
        a = 1; b = 1; cin = 0; #10;
        a = 1; b = 1; cin = 1; #10;

        $display("Full Adder Simulation Finished Successfully!");
        $finish;
    end

endmodule
