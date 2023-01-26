/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : sigmoid_deriv.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Sigmoid Derivation
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 10, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 22, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 26, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *---------------------------------------------------------------------------*/

module sigmoid_deriv(
    input clk,
    input reset_n,
    input [31:0] deriv_object,
    output [31:0] out
    );
 
wire [31:0] abs_value;
wire [31:0] add_value;
wire [31:0] square_value;
wire [31:0] final_value;

assign abs_value = {1'b0, deriv_object[30:0]};

Fadder_Fsubtractor add1 (.A(32'b00111111100000000000000000000000), .B(abs_value), .clk(clk), .reset_n(reset_n), .result(add_value)); //A+B

Fmultiplier m10 (.A(add_value), .B(add_value), .clk(clk), .reset_n(reset_n), .result(square_value));
Fmultiplier m20 (.A(square_value), .B(32'b01000000000000000000000000000000), .clk(clk), .reset_n(reset_n), .result(final_value));

Fdivider div1 (.A(32'b00111111100000000000000000000000), .B(final_value), .clk(clk), .reset_n(reset_n), .result(out));


endmodule