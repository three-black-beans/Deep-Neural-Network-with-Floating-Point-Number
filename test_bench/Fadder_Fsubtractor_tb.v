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
reg [2:0] rand1, rand2, rand7, rand8;
reg rand3, rand4;
reg [4:0] temp;
reg [19:0] temp2;

always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

always @(posedge clk) begin
    rand1 = $urandom%7;
    rand2 = $urandom%7;
    rand3 = $urandom%1;
    rand4 = $urandom%1;
    temp = 5'b10000;
    temp2 = 20'b10000000000000000000;
    rand7 = $urandom%7;
    rand8 = $urandom%7;
    A = {rand3, temp, rand1, temp2, rand7};
    B = {rand4, temp, rand2, temp2, rand8};
    IsSub = 0;
    reset_n = 1;
end

initial begin
    A = 32'b00000000000000000000000000000000; // 0
    B = 32'b00000000000000000000000000000000; // 0
    IsSub = 0;
    reset_n = 1;
end


Fadder_Fsubtractor adder_instance (.A(A), .B(B), .IsSub(IsSub), .clk(clk), .reset_n(reset_n), .result(result));

endmodule