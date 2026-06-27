// 3-Stage Pipelined 32x32 -> 64-bit unsigned multiplier
//
// Decomposition strategy (schoolbook split on 'a'):
//   Split a into three 11-bit chunks + one 9-bit chunk to fill 32 bits:
//   Actually using two halves for clarity:
//     a = a_hi[15:0] * 2^16  +  a_lo[15:0]
//   So: a*b = a_lo*b  +  (a_hi*b) << 16
//
//   But that still puts a 48-bit adder on S2.
//   Better 3-stage plan — split a into 4 bytes:
//     pp0 = a[7:0]   * b          (8+32 = 40-bit result, shift 0)
//     pp1 = a[15:8]  * b          (40-bit result, shift 8)
//     pp2 = a[23:16] * b          (40-bit result, shift 16)
//     pp3 = a[31:24] * b          (40-bit result, shift 24)
//   product = pp0 + (pp1<<8) + (pp2<<16) + (pp3<<24)
//
// Pipeline stages:
//   S1: Compute all 4 partial products in parallel
//   S2: Sum pp0+(pp1<<8)  and  pp2+(pp3<<8)   -> two 49-bit partial sums
//       (split the 4-input add into two 2-input adds for timing)
//   S3: Final sum: psum_lo + (psum_hi << 16)  -> 64-bit product
//
// Latency:    3 cycles
// Throughput: 1 result/cycle
`timescale 1ns/1ps
module mul32_pipeline (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg         valid_out,
    output reg  [63:0] product
);

    // ─── Stage 1: 4 partial products ───────────────────────────
    // pp_i = a[8i+7:8i] * b  =>  8+32 = 40 bits each
    reg        valid_s1;
    reg [39:0] pp0_s1, pp1_s1, pp2_s1, pp3_s1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_s1 <= 1'b0;
            pp0_s1 <= 40'h0; pp1_s1 <= 40'h0;
            pp2_s1 <= 40'h0; pp3_s1 <= 40'h0;
        end else begin
            valid_s1 <= valid_in;
            pp0_s1   <= {8'h00,  a[7:0]}  * b;   // byte 0
            pp1_s1   <= {8'h00,  a[15:8]} * b;   // byte 1
            pp2_s1   <= {8'h00, a[23:16]} * b;   // byte 2
            pp3_s1   <= {8'h00, a[31:24]} * b;   // byte 3
        end
    end

    // ─── Stage 2: Pairwise partial sums ────────────────────────
    // psum_lo = pp0 + (pp1 << 8)  : covers a[15:0]*b
    // psum_hi = pp2 + (pp3 << 8)  : covers a[31:16]*b (needs << 16 in S3)
    // Both results are 49 bits max: 40 + 40 with 8-bit shift
    reg        valid_s2;
    reg [48:0] psum_lo_s2, psum_hi_s2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_s2    <= 1'b0;
            psum_lo_s2  <= 49'h0;
            psum_hi_s2  <= 49'h0;
        end else begin
            valid_s2   <= valid_s1;
            psum_lo_s2 <= {9'h0, pp0_s1} + {1'b0, pp1_s1, 8'h0};
            psum_hi_s2 <= {9'h0, pp2_s1} + {1'b0, pp3_s1, 8'h0};
        end
    end

    // ─── Stage 3: Final accumulation -> 64-bit output ──────────
    // product = psum_lo + (psum_hi << 16)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            product   <= 64'h0;
        end else begin
            valid_out <= valid_s2;
            product   <= {15'h0, psum_lo_s2} + {psum_hi_s2, 16'h0};
        end
    end

endmodule

