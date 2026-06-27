`timescale 1ns / 1ps

module shift_registers (
    input clk, rst_n,
    input serial_in,
    output reg [3:0] q_left,
    output reg [3:0] q_right
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_left  <= 4'b0000;
            q_right <= 4'b0000;
        end else begin
            q_left  <= {q_left[2:0], serial_in};  
            q_right <= {serial_in, q_right[3:1]}; 
        end
    end
endmodule
