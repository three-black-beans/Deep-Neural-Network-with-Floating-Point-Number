module sum(
    input [31:0] x1, x2, x3,
    input [31:0] w1, w2, w3,
    output[31:0] out
);

wire [31:0] wx1;
wire [31:0] wx2;
wire [31:0] wx3;
wire [31:0] sum_wx1, sum_wx2;
wire [31:0] final_result;

Fmultiplier mult1(.A(w1), .B(x1), .result(wx1));
Fmultiplier mult2(.A(w2), .B(x2), .result(wx2));
Fmultiplier mult3(.A(w3), .B(x3), .result(wx3));

Fadder_Fsubtractor add3(.IsSub(1'b0), .A(wx1), .B(wx2), .result(sum_wx1));
Fadder_Fsubtractor add4(.IsSub(1'b0), .A(sum_wx1), .B(wx3), .result(final_result));

assign out = final_result;

endmodule