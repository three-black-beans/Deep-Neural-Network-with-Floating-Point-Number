/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : sigmoid.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Sigmoid
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


module sigmoid #(parameter ONE = 32'b00111111100000000000000000000000,
                 parameter TWO = 32'b01000000000000000000000000000000,
                 parameter LEARNING_CONSTANT = 32'b00111111000000000000000000000000)(
    input clk,
    input reset_n,
    input [31:0] x,
    output [31:0] out  // f(x) value
);

wire [31:0] y;
wire [31:0] add_result;
wire [31:0] dv_result;
wire [31:0] divadd_result;
wire [31:0] final_result;

// Set simoid function as f(x) = (x / (|x| + 1) + 1) / 2

assign y = {1'b0, x[30:0]}; // y = |x|

Fadder_Fsubtractor add1 (.A(ONE), .B(y), .IsSub(1'b0), .clk(clk), .reset_n(reset_n), .result(add_result)); // add_result=|x|+1
Fdivider dv1 (.A(x), .B(add_result), .clk(clk), .reset_n(reset_n), .result(dv_result)); // dv_result=1/(|x|+1)
Fadder_Fsubtractor add2 (.A(ONE), .B(dv_result), .IsSub(1'b0), .clk(clk), .reset_n(reset_n), .result(divadd_result)); // divadd_result=1/(|x|+1)+1
Fdivider dv2 (.A(divadd_result), .B(TWO), .clk(clk), .reset_n(reset_n), .result(final_result)); // final_result=(1/(|x|+1)+1)/2


assign out = final_result;
    
endmodule

