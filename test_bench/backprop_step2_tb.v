`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/25 18:28:54
// Design Name: 
// Module Name: backprop_step2_tb
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


module backprop_step2_tb #(parameter CLOCK_PERIOD = 20);

    
reg clk = 1'b0;
reg reset_n;
reg [31:0] a;
reg [31:0] b;
reg [31:0] c;
reg [31:0] d;
reg [31:0] e;
reg [31:0] f;
reg [31:0] g;
wire [31:0] r_oper;

always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    a = 32'b00111111010011001100110011001101;//정답값 = 0.8
    b = 32'b00111111001101001011010010101111;//최종 output값인 0.705882
    c = 32'b00111111001100110011001100110011;//output 값=0.7
    d = 32'b00111111000000000000000000000000;//w10 가중치 = 0.5
    e = 32'b00111111011001100110011001100110;//hidden_layer value=0.9
    f = 32'b00111111000101000111101011100001;//처음 input = 0.58
    g = 32'b00111111000110011001100110011010;//처음 가중치 = 0.6
    reset_n = 1;
end

backprop_step2 bps(.clk(clk), .reset_n(reset_n), .target(a), .sigmoid_out(b), .out_value(c), .layer2_weight(d), .hidden_layer_value(e), .initial_input(f), .initial_weight(g), .w_new(r_oper));

endmodule
