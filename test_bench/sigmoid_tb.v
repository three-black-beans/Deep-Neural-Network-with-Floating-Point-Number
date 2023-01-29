`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/26 16:51:35
// Design Name: 
// Module Name: sigmoid_tb
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


module sigmoid_tb #(parameter CLOCK_PERIOD = 20);
    reg clk = 1'b0;
    reg reset_n;
    reg [31:0] a12;
    wire [31:0] a34;
    
always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
   a12=32'b00111111000110011001100110011010; // a12 = 0.6
   reset_n = 1;
end

sigmoid sig_moid (.clk(clk), .reset_n(reset_n), .x(a12), .out(a34));

endmodule