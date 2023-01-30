module z(
    input [31:0] x1, x2, x3,
    input [31:0] w1, w2, w3,
    input clk,
    input z_read,
    output[31:0] out,
    output load,
    output [31:0] back_out
);

wire [31:0] sum;
reg [31:0] x11, x22, x33, w11, w22, w33;


assign load = sum[0] | ~sum[0];
assign out = sum;
reg1 register(.clk(clk), .load(load), .in(sum), .out(back_out), .read(z_read));
sum sm(.x1(x11), .x2(x22), .x3(x33), .w1(w11), .w2(w22), .w3(w33), .out(sum));

always @(posedge clk) begin
    x11 <= x1;
    x22 <= x2;
    x33 <= x3;
    w11 <= w1;
    w22 <= w2;
    w33 <= w3;
end

endmodule