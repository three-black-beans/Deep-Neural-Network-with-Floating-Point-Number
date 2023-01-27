/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : Fmultiplier.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Floating Point Number Multiplier
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 10, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 20, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 25, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *  NOTE: Overflow and Underflow are not considered yet.
 *
 *---------------------------------------------------------------------------*/


module Fmultiplier #(parameter BIAS = 127)(
    input clk,
    input reset_n,
    input [31:0] A,
    input [31:0] B,
    output reg exception,
    output reg [31:0] result
);

// A and B - sign, exponent, fraction 
reg A_sign, B_sign;
reg [7:0] A_exponent, B_exponent;
reg [22:0] A_fraction, B_fraction;
reg [23:0] ta_fraction, tb_fraction;
reg [7:0] temp_exponent;
reg [47:0] frac_prod, temp_fraction, normed_prod;
reg carry_exp, normed_carry, product_round, overflow, underflow;

reg result_sign;
reg [7:0] result_exp;
reg [22:0] result_frac;

always @ (posedge clk) begin
    if (!reset_n) begin
        result = result;
    end else begin
        A_sign = A[31];
        B_sign = B[31];
        
        A_exponent = A[30:23];
        B_exponent = B[30:23];
        
        A_fraction = A[22:0];
        B_fraction = B[22:0];
        
        result_sign = A[31] ^ B[31];
        
        if (A[30:0] == 31'b0) begin // if A is 0
            result = {result_sign, 31'b0};
            exception = 1'b0;
        end else if (B[30:0] == 31'b0) begin // if B is 0
            result = {result_sign, 31'b0};
            exception = 1'b0;
        end else if ((A_exponent == 8'b1) & (A_fraction != 23'b0)) begin // NAN case
            result = 32'b1;
            exception = 1'b1;
        end else if ((B_exponent == 8'b1) & (B_fraction != 23'b0)) begin // NAN case
            result = 32'b1;
            exception = 1'b1;
        end else begin // Normal case
            $display("hello");
            // If exponent is 0, hidden bit will be 0 or 1
            ta_fraction = (|A_exponent) ? {1'b1, A_fraction} : {1'b0, A_fraction};
            tb_fraction = (|B_exponent) ? {1'b1, B_fraction} : {1'b0, B_fraction};
            
            // fraction production
            frac_prod = ta_fraction * tb_fraction;
            $display("%b frac_prod", frac_prod);

            // fraction normarlize
            normed_carry = frac_prod[47] ? 1'b1 : 1'b0;
            normed_prod = normed_carry ? frac_prod : frac_prod << 1;
            $display("%b normed_prod", normed_prod);
            product_round = |normed_prod[22:0]; // Ending 23 bits are OR'ed for rounding operation.
	        result_frac = normed_prod[46:24]  + (normed_prod[23] & product_round);
	        $display("%b result_frac", result_frac);
            // exponent sum
            {carry_exp, result_exp} = A_exponent + B_exponent - BIAS + normed_carry;
            
            //If exponent is greater than 255
            overflow = carry_exp;
            //If exponent is less than 127
            underflow = (!carry_exp & !result_exp[7]);
            
            // result = overflow ? {result_sign,8'hFF,23'd0} : underflow ? {result_sign,31'b0} : {result_sign, result_exp, result_frac};
            result = {result_sign, result_exp, result_frac};
	        exception = 1'b0;
	    end 
    end
end
    
endmodule
