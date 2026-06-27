`timescale 1ns / 1ps

module tb_dff_async;
    reg clk, rst_n, d;
    wire q;

    dff_async_rst uut (.clk(clk), .rst_n(rst_n), .d(d), .q(q));
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dff_async.vcd"); 
        $dumpvars(0, tb_dff_async);
        
        clk = 0; rst_n = 1; d = 0; #3;
        rst_n = 0; #10; rst_n = 1; #5;
        d = 1; #10;
        #2 rst_n = 0; #5 rst_n = 1; #10; 
        $finish;
    end
endmodule
