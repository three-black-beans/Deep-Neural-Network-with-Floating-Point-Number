`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 15:32:32
// Design Name: 
// Module Name: sigmoid_deriv_tb
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


module sigmoid_deriv_tb #(parameter CLOCK_PERIOD = 20);

reg clk = 1'b0;
reg reset_n;
reg [31:0] a1234;
wire [31:0] b1234;

   
always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end


initial begin
   a1234 = 32'b00111111011001100110011001100110; // a1234 = 0.9
   reset_n = 1;
end

sigmoid_deriv sigmoid_derv1_test(.clk(clk), .reset_n(reset_n), .deriv_object(a1234),.out(b1234));     
    
endmodule