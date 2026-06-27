`timescale 1ns / 1ps

module mealy_01_det (
    input clk,
    input rst_n,
    input x,
    output reg y
);

    // State Encoding
    parameter S0 = 1'b0,
              S1 = 1'b1;

    reg current_state, next_state;

    // 1. Sequential Block: State Transition
    always @(posedge clk) begin
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
                if (x == 1'b0) next_state = S1; // Overlapping behavior
                else           next_state = S0;
            end
            default: next_state = S0;
        endcase
    end

    // 3. Combinational Block: Output Logic (Depends on State and Input)
    always @(*) begin
        case (current_state)
            S0: y = 1'b0;
            S1: begin
                if (x == 1'b1) y = 1'b1; // Output goes high immediately when '1' arrives
                else           y = 1'b0;
            end
            default: y = 1'b0;
        endcase
    end

endmodule
