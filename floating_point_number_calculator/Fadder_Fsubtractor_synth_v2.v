/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : Fadder_Fsubtractor.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 3.0
 *  Design     : Floating Point Number Adder and Subtractor
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 10, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 18, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 25, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *      * January 29, 2023 by Jin Hyeong Park
 *        version 3.0 released.
 * 
 *      * January 30, 2023 by Jin Hyeong Park
 *        version 4.0 synthesizable version released.
 * 
 *      * January 30, 2023 by Jin Hyeong Park
 *        version 5.0 synthesizable and reg minimized version released.
 *
 *  NOTE: Overflow and Underflow are not considered yet.
 *
 *---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
 * MODULE : Fadder_Fsubractor
 *
 * Description:
 *   'Fadder_Fsubractor' is a part of ALU(Arithmetic Logic Unit) which conducts
 *   addition and subtraction for every clock tick. Input A and B are floating 
 *   point numbers and result is also a floating point number.
 *   
 * Implementation:
 *   'Fadder_Fsubractor' is a adder slash subtractor with floating point numbers.
 *   we use behavioral model, not structural model.
 *   so we do not use instantiation.
 *   
 *   #1. Put floating point number input A and B
 *   #2. Put input IsSub as high when it's Subtraction, else low.
 *   #3. Make -(-B) form into +(+B) form.
 *   #4. Make -(+B) form into +(-B) form.
 *   (The rest are calculated as follows.
 *    (+A) + (+B) and (-A) + (-B) => +(X + Y) and -(X + Y)
 *    (+A) + (-B) and (-A) + (+B) => +(X - Y) and -(X - Y))
 *   #5. Set big and small number by comparing A[30:0] and B[30:0].
 *   #4. Concatenation of result_sign, temp_exponent and temp_fraction[22:0] 
 *       is pushed out and this is the output result.
 *   #5. With rising edge clock, Repeat #1 ~ #4. 
 *
 * Reset/Initialization:
 *   This 'Fadder_Fsubractor' cannot be initialized by synchronous load
 *   This 'Fadder_Fsubractor' cannot be initialized by asynchronous reset.

 *
 *---------------------------------------------------------------------------*/
module Fadder_Fsubtractor(
    input clk,
    input [31:0] A,
    input [31:0] B,
    input reset_n,
    input IsSub,
    output reg [31:0] result
);

// Sign
reg result_sign;
reg B_sign;
// Big and Small - sign, exponent, fraction
reg big_sign, small_sign;
reg [7:0] big_exponent, small_exponent;
reg [22:0] big_fraction, small_fraction;
// Difference
reg [7:0] exponent_diff;
reg input_diff;
// Temp Small Fraction & Temp Fraction
reg [23:0] ts_fraction, temp_fraction;
// Temp Exponent
reg [7:0] temp_exponent;
// Shift
reg right_shift;
reg [4:0] left_shift;
// Operator
reg operator;

always @ (posedge clk) begin
    if (!reset_n) begin
        temp_fraction = 0;
        temp_exponent = 0;
    end else begin
        B_sign = B[31];

        /* - (-B) to + (+B) */
        operator = (IsSub & B_sign) ? 1'b0 : IsSub; // addition -> 0, subtraction -> 1
        B_sign = (IsSub & B_sign) ? 1'b0 : B_sign; 
        /* - (+B) to + (-B) */
        B_sign = (!operator) ? B_sign : 1'b1;
        
        // If input_diff is high then |A| >= |B| else |A| < |B|.
        input_diff = ({A[30:23], A[22:0]} >= {B[30:23], B[22:0]}) ? 1'b1 : 1'b0;
        big_sign = (input_diff) ? A[31] : B_sign;
        big_exponent = (input_diff) ? A[30:23] : B[30:23];
        big_fraction = (input_diff) ? A[22:0] : B[22:0];
        small_sign = (input_diff) ? B_sign : A[31];
        small_exponent = (input_diff) ? B[30:23] : A[30:23];
        small_fraction = (input_diff) ? B[22:0] : A[22:0];
       
        // sign setting
        result_sign = big_sign;
        if (big_sign == small_sign) begin
            big_sign = 1'b0;
            small_sign = 1'b0;
        end
        
        exponent_diff = big_exponent - small_exponent;

        ts_fraction = {1'b1, small_fraction};
        ts_fraction = ts_fraction >> exponent_diff;
        
        {right_shift, temp_fraction} = (big_sign == small_sign) ? {1'b1, big_fraction} + ts_fraction : {1'b1, big_fraction} - ts_fraction;
        temp_exponent = big_exponent;
        
        if (right_shift) begin
            temp_fraction = temp_fraction >> 1'b1;
            temp_exponent = temp_exponent + 1'b1;
        end else begin
            left_shift = 0;
            casex (temp_fraction)
                24'b1xxx_xxxx_xxxx_xxxx_xxxx_xxxx :	    begin
                                                            temp_fraction = temp_fraction;
                                                            left_shift = 5'd0;
                                                        end
                24'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx :     begin
                                                            temp_fraction = temp_fraction << 1;
                                                            left_shift = 5'd1;
                                                        end
                24'b001x_xxxx_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 2;
                                                            left_shift = 5'd2;
                                                        end
                24'b0001_xxxx_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 3;
                                                            left_shift = 5'd3;
                                                        end
                24'b0000_1xxx_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 4;
                                                            left_shift = 5'd4;
                                                        end
                24'b0000_01xx_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 5;
                                                            left_shift = 5'd5;
                                                        end
                24'b0000_001x_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 6;
                                                            left_shift = 5'd6;
                                                        end
                24'b0000_0001_xxxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 7;
                                                            left_shift = 5'd7;
                                                        end
                24'b0000_0000_1xxx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 8;
                                                            left_shift = 5'd8;
                                                        end
                24'b0000_0000_01xx_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 9;
                                                            left_shift = 5'd9;
                                                        end
                24'b0000_0000_001x_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 10;
                                                            left_shift = 5'd10;
                                                        end
                24'b0000_0000_0001_xxxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 11;
                                                            left_shift = 5'd11;
                                                        end
                24'b0000_0000_0000_1xxx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 12;
                                                            left_shift = 5'd12;
                                                        end
                24'b0000_0000_0000_01xx_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 13;
                                                            left_shift = 5'd13;
                                                        end
                24'b0000_0000_0000_001x_xxxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 14;
                                                            left_shift = 5'd14;
                                                        end
                24'b0000_0000_0000_0001_xxxx_xxxx  : 	begin
                                                            temp_fraction = temp_fraction << 15;
                                                            left_shift = 5'd15;
                                                        end
                24'b0000_0000_0000_0000_1xxx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 16;
                                                            left_shift = 5'd16;
                                                        end
                24'b0000_0000_0000_0000_01xx_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 17;
                                                            left_shift = 5'd17;
                                                        end
                24'b0000_0000_0000_0000_001x_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 18;
                                                            left_shift = 5'd18;
                                                        end
                24'b0000_0000_0000_0000_0001_xxxx : 	begin
                                                            temp_fraction = temp_fraction << 19;
                                                            left_shift = 5'd19;
                                                        end
                24'b0000_0000_0000_0000_0000_1xxx :	begin
                                                            temp_fraction = temp_fraction << 20;
                                                            left_shift = 5'd20;
                                                        end
                24'b0000_0000_0000_0000_0000_01xx : 	begin
                                                            temp_fraction = temp_fraction << 21;
                                                            left_shift = 5'd21;
                                                        end
                24'b0000_0000_0000_0000_0000_001x : 	begin
                                                            temp_fraction = temp_fraction << 22;
                                                            left_shift = 5'd21;
                                                        end
                24'b0000_0000_0000_0000_0000_0001 : 	begin
                                                            temp_fraction = temp_fraction << 23;
                                                            left_shift = 5'd22;
                                                        end
                default : 	                            begin
                                                            temp_fraction = temp_fraction;
                                                            left_shift = 5'd0;
                                                        end
            endcase
	        temp_exponent = temp_exponent - left_shift;
        end
    end

    result = {result_sign, temp_exponent, temp_fraction[22:0]};
end

endmodule