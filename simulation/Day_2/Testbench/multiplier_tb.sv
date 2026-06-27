
`timescale 1ns / 1ps

module tb_mult_param;

    // We can easily test an 8-bit multiplier configuration by overriding the parameter here
    localparam TEST_WIDTH = 8; 

    // Simulation structural logic signals
    logic clk;
    logic st;
    logic [TEST_WIDTH-1:0] mplier;
    logic [TEST_WIDTH-1:0] mcand;
    logic done;
    logic [(2*TEST_WIDTH)-1:0] result;

    // Instantiate Parameterized Module using explicit SystemVerilog (. * ) mapping
    mult_param #(.WIDTH(TEST_WIDTH)) uut (.*);

    // Clock Generation: 50MHz (20ns period)
    always #10 clk = ~clk;

    // Safe procedural assertion checking block for Cadence 15.20
    always @(posedge clk) begin
        if (done) begin
            assert (result == (mplier * mcand))
            else $error("Multiplication Mismatch! Inputs: %d x %d | Expected: %d, Got: %d", 
                        mplier, mcand, (mplier * mcand), result);
        end
    end

    initial begin
        // Open simulation trace file for SimVision
        $dumpfile("multiplier_sim.vcd");
        $dumpvars(0, tb_mult_param);

        // System Initialization
        clk = 0;
        st = 0;
        mplier = 0;
        mcand = 0;
        #25;

        // Test Case 1: 8-bit multiplication (125 x 12 = 1500)
        mplier = 8'd125; mcand = 8'd12;
        st = 1; #20; st = 0; // Pulse start flag for a single cycle
        
        @(posedge done);
        $display("[%0tns] Test Case 1 Passed: %d x %d = %d", $time, mplier, mcand, result);
        #40;

        // Test Case 2: Boundary validation (255 x 255 = 65025)
        mplier = 8'd255; mcand = 8'd255;
        st = 1; #20; st = 0;
        
        @(posedge done);
        $display("[%0tns] Test Case 2 Passed: %d x %d = %d", $time, mplier, mcand, result);
        #40;

        $finish;
    end

endmodule
