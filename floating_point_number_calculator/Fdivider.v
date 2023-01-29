/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : Fdivider.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Floating Point Number Divider
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
 *        Iteration will be added more.
 *
 *---------------------------------------------------------------------------*/

module Fdivider(
    input [31:0] A,
    input [31:0] B,
    input clk,
    input reset_n,
    output [31:0] result
    );
wire [31:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7;
wire [31:0] x0, x1, x2, x3;
wire [31:0] reciprocal;
wire [7:0] exponent;

// Initial value setting
Fmultiplier init_multi (.A({1'b0, 8'd126, B[22:0]}), .B(32'b01000000000010110100101101001011), .reset_n(reset_n), .clk(clk), .result(temp1)); //verified
Fadder_Fsubtractor init_sub (.A(32'h4034B4B5), .B(temp1), .IsSub(1'b1), .reset_n(reset_n), .clk(clk), .result(x0));

// Iteration step 1
Fmultiplier iterate_m1 (.A({{1'b0,8'd126,B[22:0]}}), .B(x0), .reset_n(reset_n), .clk(clk), .result(temp2));
Fadder_Fsubtractor iterate_a1 (.A(32'h40000000), .B(temp2), .IsSub(1'b1), .reset_n(reset_n), .clk(clk), .result(temp3));
Fmultiplier iterate_m2 (.A(x0), .B(temp3), .reset_n(reset_n), .clk(clk), .result(x1));

// Iteration step 2
Fmultiplier iterate_m3 (.A({1'b0,8'd126,B[22:0]}), .B(x1), .reset_n(reset_n),.clk(clk), .result(temp4));
Fadder_Fsubtractor iterate_a2 (.A(32'h40000000), .B(temp4), .IsSub(1'b1), .reset_n(reset_n), .clk(clk), .result(temp5));
Fmultiplier iterate_m4 (.A(x1), .B(temp5), .reset_n(reset_n), .clk(clk), .result(x2));

// Iteration step 3
Fmultiplier iterate_m5 (.A({1'b0,8'd126,B[22:0]}), .B(x2), .reset_n(reset_n), .clk(clk), .result(temp6));
Fadder_Fsubtractor iterate_a3 (.A(32'h40000000), .B(temp6), .IsSub(1'b1), .reset_n(reset_n), .clk(clk), .result(temp7));
Fmultiplier iterate_m6 (.A(x2), .B(temp7), .reset_n(reset_n), .clk(clk), .result(x3));

// Reciprocal : 1/B
assign exponent = x3[30:23] + 8'd126 - B[30:23];
assign reciprocal = {B[31], exponent, x3[22:0]};

// Multiplication : A * (1/B)
Fmultiplier multi_result (.A(A), .B(reciprocal), .reset_n(reset_n), .clk(clk), .result(result));

endmodule