`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 15:32:32
// Design Name: 
// Module Name: backprop_step1_tb
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


module backprop_step1_tb #(parameter CLOCK_PERIOD = 20);
    
reg clk = 1'b0;
reg reset_n;
reg [31:0] target;
reg [31:0] output_sigmoid;
reg [31:0] hidden_layer_value_sigmoid;
reg [31:0] w_initial;
wire [31:0] w_update;

always begin : CLOCK_PULSE
    #(CLOCK_PERIOD / 2) clk = ~clk;
end

initial begin
    target = 32'b00111110100000000000000000000000; // 0.25
    output_sigmoid = 32'b00111111000000000000000000000000; // 0.5
    hidden_layer_value_sigmoid = 32'b00111110110000000000000000000000; // 0.75
    w_initial = 32'b00111111001000000000000000000000; // 0.625
    reset_n = 1;
end

backprop_step1 bps(.clk(clk), .reset_n(reset_n), .target(target), .output_sigmoid(output_sigmoid), .hidden_layer_value_sigmoid(hidden_layer_value_sigmoid), .w_initial(w_initial), .w_update(w_update));  

endmodule