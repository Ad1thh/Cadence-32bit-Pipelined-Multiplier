`timescale 1ns / 1ps

module tb_moore_01_det;
    reg clk;
    reg rst_n;
    reg x;
    wire y;

    // Instantiate Moore Unit Under Test
    moore_01_det uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y)
    );

    // Clock Generation: 50MHz (20ns period)
    always #10 clk = ~clk;

    initial begin
        $dumpfile("moore_01.vcd");
        $dumpvars(0, tb_moore_01_det);

        // Initial Reset
        clk = 0;
        rst_n = 0;
        x = 0;
        #15 rst_n = 1; // Release reset cleanly

        // Injecting the identical sequence: 0 -> 1 -> 0 -> 1
        @(posedge clk); #2 x = 0; // Moves to S1 on next edge
        @(posedge clk); #2 x = 1; // Pattern completed! Next edge moves to S2.
        
        @(posedge clk); #2 x = 0; // FSM is in S2 here (y goes high!). Overlaps back to S1.
        @(posedge clk); #2 x = 1; // Next edge moves back to S2.
        
        @(posedge clk); #2 x = 1; // FSM is in S2 here (y goes high!). Moves to S0.
        
        repeat(3) @(posedge clk);
        $finish;
    end
endmodule
