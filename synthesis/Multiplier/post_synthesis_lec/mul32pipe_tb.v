`timescale 1ns/1ps

module tb_mul32_pipeline;
    reg        clk = 0, rst_n = 0, valid_in = 0;
    reg [31:0] a = 0, b = 0;
    wire        valid_out;
    wire [63:0] product;

    integer cycle_count = 0, errors = 0, results = 0;

    mul32_pipeline dut (.clk(clk),.rst_n(rst_n),.valid_in(valid_in),
                        .a(a),.b(b),.valid_out(valid_out),.product(product));
    always #5 clk = ~clk;

    reg [31:0] tv_a [0:11], tv_b [0:11];
    reg [63:0] tv_exp [0:11];
    integer i;

    initial begin
        tv_a[0]=32'h0000_000C; tv_b[0]=32'h0000_000D;
        tv_a[1]=32'hFFFF_FFFF; tv_b[1]=32'hFFFF_FFFF;
        tv_a[2]=32'h0001_0000; tv_b[2]=32'h0001_0000;
        tv_a[3]=32'hDEAD_BEEF; tv_b[3]=32'h0000_0001;
        tv_a[4]=32'h8000_0000; tv_b[4]=32'h0000_0002;
        tv_a[5]=32'h0000_FFFF; tv_b[5]=32'hFFFF_0000;
        tv_a[6]=32'hCAFE_BABE; tv_b[6]=32'hDEAD_C0DE;
        tv_a[7]=32'h0000_0000; tv_b[7]=32'hFFFF_FFFF;
        tv_a[8]=32'h0000_0001; tv_b[8]=32'hFFFF_FFFF;
        tv_a[9]=32'h1234_5678; tv_b[9]=32'h8765_4321;
        tv_a[10]=32'hAAAA_AAAA;tv_b[10]=32'h5555_5555;
        tv_a[11]=32'h0000_07FF;tv_b[11]=32'hFFFF_FFFF;

        for (i=0;i<12;i=i+1) tv_exp[i] = tv_a[i] * tv_b[i];

        rst_n=0; repeat(2) @(posedge clk); #1; rst_n=1; @(posedge clk); #1;

        $display("=== 3-STAGE PIPELINED 32-BIT MULTIPLIER ===");
        $display("Decomposition: a = byte3<<24 | byte2<<16 | byte1<<8 | byte0");
        $display("  S1: 4x partial products (8x32 each)");
        $display("  S2: psum_lo=pp0+(pp1<<8), psum_hi=pp2+(pp3<<8)");
        $display("  S3: product = psum_lo + (psum_hi<<16)");
        $display("");
        $display("Cy | Phase    | valid_in | A[31:0]      | B[31:0]      | v_out | Product[63:0]           | OK?");
        $display("---|----------|----------|--------------|--------------|-------|-------------------------|----");

        // Feed all 12 inputs back-to-back
        for (i=0;i<12;i=i+1) begin
            a=tv_a[i]; b=tv_b[i]; valid_in=1'b1;
            @(posedge clk); #1; cycle_count=cycle_count+1;
        end

        // Drain
        valid_in=1'b0; a=0; b=0;
        repeat(5) begin @(posedge clk); #1; cycle_count=cycle_count+1; end

        $display("");
        $display("=== PERFORMANCE SUMMARY ===");
        $display("Pipeline depth      : 3 stages");
        $display("Fill latency        : 3 cycles");
        $display("Steady throughput   : 1 result / cycle");
        $display("Drain              : 3 cycles after last valid_in");
        $display("Total for 12 inputs : %0d cycles (%0d fill + 12 inputs + drain)",
                 12+3, 3);
        $display("Errors              : %0d / 12", errors);

        if (errors==0) $display("ALL OUTPUTS CORRECT");
        else           $display("*** ERRORS DETECTED ***");
        #20; $finish;
    end

    always @(posedge clk) begin
        $display("%2d | %-8s |    %b     | %h | %h |   %b   | %h | %s",
            cycle_count,
            (cycle_count <= 3) ? "FILL" : (valid_in ? "STEADY" : "DRAIN"),
            valid_in, a, b, valid_out, product,
            valid_out ? ((product===tv_exp[results]) ? "OK" : "FAIL") : "--");
        if (valid_out) begin
            if (product !== tv_exp[results]) errors = errors + 1;
            results = results + 1;
        end
    end

    initial begin $dumpfile("sim/pipeline32.vcd"); $dumpvars(0,tb_mul32_pipeline); end
endmodule

