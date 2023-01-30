/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : backprop_step1.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Backpropagation step 1
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 15, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 22, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 26, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *---------------------------------------------------------------------------*/
 
module backprop_step1 #(parameter ONE = 32'b00111111100000000000000000000000,
                        parameter TWO = 32'b01000000000000000000000000000000,
                        parameter LEARNING_CONSTANT = 32'b00111111000000000000000000000000)(
    input clk,
    input reset_n,
    input [31:0] target, // t1 (target value)
    input [31:0] output_sigmoid, // h4 (Output's Sigmoid Value)
    input [31:0] hidden_layer_value_sigmoid, // h1, h2, h3 (hidden_layer's Simoid Value)
    input [31:0] w_initial, // w10, w11, w12 (Old Weight) 
    output [31:0] w_update // w10+, w11+. w12+ (New Weight) 
);

wire [31:0] output_sigmoid_cal; // 1-output_sigmoid
wire [31:0] learning_mult; // Weight Rate Change
wire [31:0] step1_add;
wire [31:0] step2_mult;
wire [31:0] step3_mult;
wire [31:0] step4_mult;
wire [31:0] step5_mult;

Fadder_Fsubtractor add1(.clk(clk), .reset_n(reset_n), .A(ONE), .B(output_sigmoid), .IsSub(1'b1), .result(output_sigmoid_cal)); // A - B
Fadder_Fsubtractor add2(.clk(clk), .reset_n(reset_n), .A(output_sigmoid), .B(target), .IsSub(1'b1), .result(step1_add)); // A - B
Fmultiplier mult1(.clk(clk), .reset_n(reset_n), .exception(exception), .A(step1_add), .B(TWO), .result(step2_mult));
Fmultiplier mult2(.clk(clk), .reset_n(reset_n), .exception(exception), .A(step2_mult), .B(output_sigmoid), .result(step3_mult));
Fmultiplier mult3(.clk(clk), .reset_n(reset_n), .exception(exception), .A(step3_mult), .B(output_sigmoid_cal), .result(step4_mult));
Fmultiplier mult4(.clk(clk), .reset_n(reset_n), .exception(exception), .A(step4_mult), .B(hidden_layer_value_sigmoid), .result(step5_mult));
Fmultiplier mult5(.clk(clk), .reset_n(reset_n), .exception(exception), .A(LEARNING_CONSTANT), .B(step5_mult), .result(learning_mult));

Fadder_Fsubtractor add3(.clk(clk), .reset_n(reset_n), .A(w_initial),.B(learning_mult), .IsSub(1'b1), .result(w_update)); // A - B

endmodule