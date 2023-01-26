/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : backprop_step2.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Backpropagation step 2
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 10, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 22, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 25, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *  NOTE: Overflow and Underflow are not considered yet.
 *
 *---------------------------------------------------------------------------*/


module backprop_step2(
    input clk,
    input reset_n,
    input [31:0] target, // 정답값
    input [31:0] sigmoid_out, // 최종 output
    input [31:0] out_value, // output_layer의 시그모이드 전 값
    input [31:0] layer2_weight, // hidden_layer와 output_layer사이의 가중치
    input [31:0] hidden_layer_value, // hidden_layer의 시그모이드 전 값
    input [31:0] initial_input, // 처음 input값
    input [31:0] initial_weight, // hidden_layer와 input_layer사이의 가중치
    output [31:0] w_new //새로 업데이트 되는 가중치
);

wire [31:0] loss;
wire [31:0] derv1_out;
wire [31:0] hidden_out;
wire [31:0] learning_mult;

wire [31:0] step1_mult;
wire [31:0] step2_mult;
wire [31:0] step3_mult;
wire [31:0] step4_mult;

// partial derivation start
Fadder sub1 (.A(sigmoid_out), .B({1'b0, target[30:0]}), .clk(clk), .reset_n(reset_n), .result(loss)); // A - B
sigmoid_deriv deriv1 (.deriv_object(out_value), .clk(clk), .reset_n(reset_n), .out(derv1_out));
sigmoid_deriv deriv2 (.deriv_object(hidden_layer_value), .clk(clk), .reset_n(reset_n), .out(hidden_out));


Fmultiplier m1 (.A(loss), .B(derv1_out), .clk(clk), .reset_n(reset_n), .result(step1_mult));
Fmultiplier m2 (.A(step1_mult), .B(layer2_weight), .clk(clk), .reset_n(reset_n), .result(step2_mult));
Fmultiplier m3 (.A(step2_mult), .B(hidden_out), .clk(clk), .reset_n(reset_n), .result(step3_mult));
Fmultiplier m4 (.A(step3_mult), .B(initial_input), .clk(clk), .reset_n(reset_n), .result(step4_mult));

Fmultiplier m5 (.A(32'b00111110010011001100110011001101), .B(step4_mult), .clk(clk), .reset_n(reset_n), .result(learning_mult));

Fadder sub2 (.A(initial_weight), .B({1'b0, learning_mult[30:0]}), .clk(clk), .reset_n(reset_n), .result(w_new)); // A - B
// partial derivation end


endmodule
