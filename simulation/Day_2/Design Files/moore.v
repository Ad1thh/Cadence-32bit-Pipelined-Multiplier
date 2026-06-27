`timescale 1ns / 1ps

module moore_01_det (
    input clk,
    input rst_n,
    input x,
    output reg y
);

    // State Encoding (3 states require 2 bits)
    parameter S0 = 2'b00, // IDLE / Reset State
              S1 = 2'b01, // Detected '0'
              S2 = 2'b10; // Detected '01' (Success State)

    reg [1:0] current_state, next_state;

    // 1. Sequential Block: State Transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // 2. Combinational Block: Next State Logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x == 1'b0) next_state = S1;
                else           next_state = S0;
            end
            S1: begin
                if (x == 1'b0) next_state = S1;
                else           next_state = S2; // Move to detection state on '1'
            end
            S2: begin
                if (x == 1'b0) next_state = S1; // Overlapping behavior (last '1' can start a new '01')
                else           next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // 3. Combinational Block: Output Logic (Strictly depends ONLY on Current State)
    always @(*) begin
        case (current_state)
            S0:      y = 1'b0;
            S1:      y = 1'b0;
            S2:      y = 1'b1; // Output goes high only when we are structurally inside S2
            default: y = 1'b0;
        endcase
    end

endmodule
