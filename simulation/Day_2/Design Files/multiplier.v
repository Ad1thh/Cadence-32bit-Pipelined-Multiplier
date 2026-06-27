
`timescale 1ns / 1ps

// Macro to look at the LSB of the Accumulator (the current multiplier bit)
`define M ACC[0]

module mult_param #(
    parameter WIDTH = 4  // Default bit-width is set to 4
)(
    input clk,
    input st,
    input  [WIDTH-1:0] mplier,
    input  [WIDTH-1:0] mcand,
    output done,
    output [(2*WIDTH)-1:0] result
);

    // Dynamic state register tracking setup
    reg [$clog2(WIDTH + 2)-1:0] state;
    
    // Accumulator register: Upper part holds sum/carry, lower part holds multiplier bits
    reg [(2*WIDTH):0] ACC;

    // FSM State boundaries
    localparam IDLE = 0;
    localparam DONE = WIDTH + 1;

    initial begin
        state = IDLE;
        ACC   = 0;
    end

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (st == 1'b1) begin
                    ACC[(2*WIDTH):WIDTH] <= 0;       // Clear upper product and carry bits
                    ACC[WIDTH-1:0]       <= mplier;  // Load multiplier into lower bits
                    state                <= 1;       // Move to first operational state
                end
            end

            // Operational multiplication steps loop
            default: begin
                if (state >= 1 && state <= WIDTH) begin
                    if (`M == 1'b1) begin
                        // Parallel Addition and Right Shift in 1 clock cycle
                        ACC <= {1'b0, (ACC[(2*WIDTH):WIDTH] + mcand), ACC[WIDTH-1:1]};
                    end else begin
                        // Plain Right Shift when multiplier bit is 0
                        ACC <= {1'b0, ACC[(2*WIDTH):1]};
                    end
                    
                    state <= state + 1;
                end else begin
                    state <= IDLE;
                end
            end

            DONE: begin
                state <= IDLE;
            end
        endcase
    end

    // Assign outputs based on calculation state
    assign done   = (state == DONE) ? 1'b1 : 1'b0;
    assign result = (state == DONE) ? ACC[(2*WIDTH)-1:0] : 0;

endmodule
