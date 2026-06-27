`timescale 1ns / 1ps
module tb_mux21;
    reg in0, in1, sel;
    wire out;

    mux21 uut (.in0(in0), .in1(in1), .sel(sel), .out(out));

    initial begin
        $dumpfile("mux21.vcd"); 
        $dumpvars(0, tb_mux21);
        
        in0 = 0; in1 = 0; sel = 0; #10;
        in0 = 1; in1 = 0; sel = 0; #10;
        sel = 1; #10;
        in1 = 1; #10;
        $finish;
    end
endmodule
