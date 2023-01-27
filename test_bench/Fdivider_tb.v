`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/24 23:27:17
// Design Name: 
// Module Name: Fdivider_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fdivider_tb #(parameter CLOCK_PERIOD = 20);

reg clk = 1'b0;
reg [31:0] A;
reg [31:0] B;
reg reset_n;
wire [31:0] result;

always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    A = 32'b01000010111100000000000000000000; // 120
    B = 32'b01000001001000000000000000000000; // 10
    reset_n = 1;
end


Fdivider divider_instance (.A(A), .B(B), .clk(clk), .reset_n(reset_n), .result(result));

endmodule
