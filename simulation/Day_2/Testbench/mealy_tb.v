`timescale 1ns / 1ps

module tb_mealy_01_det;
    reg clk;
    reg rst_n;
    reg x;
    wire y;

    mealy_01_det uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y)
    );

    // 50MHz Clock Generation (20ns period)
    always #10 clk = ~clk;
      initial begin
        $dumpfile("mealy_01.vcd");
        $dumpvars(0, tb_mealy_01_det);

        // Initialize
        clk = 0;
        rst_n = 0;
        x = 0;
        #15;          // Release reset mid-cycle
        rst_n = 1; 
        
        // Feed the pattern 0 -> 1 using absolute delays 
        // to ensure they don't fight with the clock edges
        #15; x = 0;   // Hold 0 through the next clock edge
        #20; x = 1;   // Change to 1 and hold it through the following edge
        #20; x = 0;   // Go back to 0
        #20; x = 1;   // Go back to 1 (testing overlapping)
        
        #40;
        $finish;
    end
    
endmodule
