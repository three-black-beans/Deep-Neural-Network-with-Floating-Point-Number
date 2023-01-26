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

`include "Fadder.v"
`include "Fmultiplier.v"
module Fdivider(
    input [31:0] A,
    input [31:0] B,
    input clk,
    input reset_n,
    output reg [31:0] result
    );
wire [31:0] temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11;
wire [31:0] x0, x1, x2, x3, x4, x5, x6;
wire [31:0] reciprocal;
wire [7:0] exponent;

Fmultiplier init_multi (.A({1'b0, 8'd126, B[22:0]}), .B(32'b11000000000010110100101101001011), .reset_n(reset_n), .clk(clk), .result(temp1)); //verified
Fadder init_sub (.A(32'h4034B4B5), .B({1'b1, temp1[30:0]}), .reset_n(reset_n), .clk(clk), .result(x0));

Fmultiplier iterate_m1 (.A({{1'b0,8'd126,B[22:0]}}), .B(x0), .reset_n(reset_n), .clk(clk), .result(temp2));
Fadder iterate_a1 (.A(32'h40000000), .B({!temp2[31], temp2[30:0]}), .reset_n(reset_n), .clk(clk), .result(temp3));
Fmultiplier iterate_m2 (.A(x0), .B(temp3), .reset_n(reset_n), .clk(clk), .result(x1));

Fmultiplier iterate_m3 (.A({1'b0,8'd126,B[22:0]}), .B(x1), .reset_n(reset_n),.clk(clk), .result(temp4));
Fadder iterate_a2 (.A(32'h40000000), .B({!temp4[31], temp4[30:0]}), .reset_n(reset_n), .clk(clk), .result(temp5));
Fmultiplier iterate_m4 (.A(x1), .B(temp5), .reset_n(reset_n), .clk(clk), .result(x2));

Fmultiplier iterate_m5 (.A({1'b0,8'd126,B[22:0]}), .B(x2), .reset_n(reset_n), .clk(clk), .result(temp6));
Fadder iterate_a3 (.A(32'h40000000), .B({!temp6[31],temp6[30:0]}), .reset_n(reset_n), .clk(clk), .result(temp7));
Fmultiplier iterate_m6 (.A(x2), .B(temp7), .reset_n(reset_n), .clk(clk), .result(x3));

//Fmultiplier iterate_m7 (.A({1'b0,8'd126,B[22:0]}), .B(x3), .reset_n(reset_n), .clk(clk), .result(temp8));
//Fadder iterate_a4 (.A(32'h40000000), .B({!temp8[31],temp8[30:0]}), .reset_n(reset_n), .clk(clk), .result(temp9));
//Fmultiplier iterate_m8 (.A(x3), .B(temp9), .reset_n(reset_n), .clk(clk), .result(x4));

//Fmultiplier iterate_m9 (.A({1'b0,8'd126,B[22:0]}), .B(x4), .reset_n(reset_n), .clk(clk), .result(tmp10));
//Fadder iterate_a5 (.A(32'h40000000), .B({!temp10[31],temp10[30:0]}), .reset_n(reset_n), .clk(clk), .result(temp11));
//Fmultiplier iterate_m10 (.A(x4), .B(temp11), .reset_n(reset_n), .clk(clk), .result(x5));

/*----Reciprocal : 1/B----*/
assign exponent = x3[30:23] + 8'd126 - B[30:23];
assign reciprocal = {B[31], exponent, x3[22:0]};


/*----Multiplication A*1/B----*/
Fmultiplier multi_result (.A(A), .B(reciprocal), .reset_n(reset_n), .clk(clk), .result(x4));

always @ (posedge clk) begin
    $display("%b x0", x0);
    $display("%b temp1", temp1);
    $display("%b x1", x1);
    $display("%b temp2", temp2);
    $display("%b temp3", temp3);
    $display("%b x2", x2);
    $display("%b temp4", temp4);
    $display("%b temp5", temp5);
    $display("%b x3", x3);
    $display("%b temp6", temp6);
    $display("%b temp7", temp7);
    $display("%b x4", x4);
    $display("%b reciprocal", reciprocal);
    result = x4;
end

endmodule
