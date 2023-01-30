/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : backprop_step2.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 3.0
 *  Design     : Backpropagation step 2
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 16, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 22, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 26, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *      * January 29, 2023 by Jin Hyeong Park
 *        version 3.0 released.
 *
 *---------------------------------------------------------------------------*/
 

module backprop_step2  #(parameter ONE = 32'b00111111100000000000000000000000)(
    input clk,
    input reset_n,
    input [31:0] target,             // 정답값
    input [31:0] sigmoid_out,        // so1, 
    input [31:0] out_value,          // o1,     output_layer의 시그모이드 전 값
    input [31:0] layer2_weight,      // w10,     hidden_layer와 output_layer사이의 가중치
    input [31:0] hidden_sigmoid_value,//h1,   hidden_layer의 시그모이드 값
    input [31:0] hidden_layer_value, // z1,    hidden_layer의 시그모이드 전 값
    input [31:0] initial_input,      // x1,   처음 input값
    input [31:0] initial_weight,     // w1,   hidden_layer와 input_layer사이의 가중치
    output [31:0] w_new              //w1+,    새로 업데이트 되는 가중치
);

wire [31:0] loss;
wire [31:0] rev_so;
wire [31:0] rev_h;
wire [31:0] derv1_out;
wire [31:0] hidden_out;
wire [31:0] learning_mult;

wire [31:0] step1_mult;
wire [31:0] step2_mult;
wire [31:0] step3_mult;
wire [31:0] step4_mult;

// partial derivation start

Fadder_Fsubtractor sub1 (.A(sigmoid_out), .B(target), .clk(clk), .IsSub(1'b1),.reset_n(reset_n), .result(loss)); // so1 - target
Fadder_Fsubtractor sub2 (.A(ONE), .B(sigmoid_out),.IsSub(1'b1), .clk(clk), .reset_n(reset_n), .result(rev_so)); // 1 - so1     of    so1*(1-so1)
Fadder_Fsubtractor sub3 (.A(ONE), .B(hidden_sigmoid_value),.IsSub(1'b1), .clk(clk), .reset_n(reset_n), .result(rev_h)); // 1 - h1  of  h1*(1-h1)

Fmultiplier m01 (.A(sigmoid_out), .B(rev_so), .clk(clk), .reset_n(reset_n), .result(derv1_out)); // derv1_out = so1*(1-so1)
Fmultiplier m02 (.A(hidden_sigmoid_value), .B(rev_h), .clk(clk), .reset_n(reset_n), .result(hidden_out)); // hidden_out = h*(1-h)

Fmultiplier m1 (.A(loss), .B(derv1_out), .clk(clk), .reset_n(reset_n), .result(step1_mult));
Fmultiplier m2 (.A(step1_mult), .B(layer2_weight), .clk(clk), .reset_n(reset_n), .result(step2_mult));
Fmultiplier m3 (.A(step2_mult), .B(hidden_out), .clk(clk), .reset_n(reset_n), .result(step3_mult));
Fmultiplier m4 (.A(step3_mult), .B(initial_input), .clk(clk), .reset_n(reset_n), .result(step4_mult));

Fmultiplier m5 (.A(32'b00111111000000000000000000000000), .B(step4_mult), .clk(clk), .reset_n(reset_n), .result(learning_mult)); // learning rate 0.5

Fadder_Fsubtractor sub4 (.A(initial_weight), .B(learning_mult),.IsSub(1'b1), .clk(clk), .reset_n(reset_n), .result(w_new)); // A - B
// partial derivation end


endmodule