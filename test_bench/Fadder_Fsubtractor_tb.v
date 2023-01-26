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
reg reset_n;
wire [31:0] result;
    
always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    A = 32'b11000010110010000000000000000000;
    B = 32'b01000001101000000000000000000000;
    reset_n = 1;
end


Fadder_Fsubtractor adder_instance (.A(A), .B(B), .clk(clk), .reset_n(reset_n), .result(result));

endmodule
