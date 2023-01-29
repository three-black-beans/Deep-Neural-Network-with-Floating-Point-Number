`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/21 17:01:44
// Design Name: 
// Module Name: Fadder_Fsubtractor_tb
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


module Fadder_Fsubtractor_tb #(parameter CLOCK_PERIOD = 20);
    
reg clk = 1'b0;
reg [31:0] A;
reg [31:0] B;
reg IsSub;
reg reset_n;
wire [31:0] result;
    
always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    A = 32'b11000000010011001100110011001101; // -3.2
    B = 32'b00111111001100110011001100110011; // 0.7
    IsSub = 0;
    reset_n = 1;
end


Fadder_Fsubtractor adder_instance (.A(A), .B(B), .IsSub(IsSub), .clk(clk), .reset_n(reset_n), .result(result));

endmodule