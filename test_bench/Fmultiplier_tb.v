`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/23 15:39:54
// Design Name: 
// Module Name: Fmultiplier_tb
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


module Fmultiplier_tb #(parameter CLOCK_PERIOD = 20);

reg clk = 1'b0;
reg [31:0] A;
reg [31:0] B;
reg reset_n;
wire [31:0] result;

always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    A = 32'b00111111000000000000000000000000; // 120
    B = 32'b11000000000010110100101101001011; // -10
    reset_n = 1;
end


Fmultiplier multiplier_instance (.A(A), .B(B), .clk(clk), .reset_n(reset_n), .exception(exception), .result(result));

endmodule
