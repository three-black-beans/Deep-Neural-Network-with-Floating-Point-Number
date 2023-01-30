module neu(
    input [31:0] x1, x2, x3,
    input [31:0] w1, w2, w3,
    input clk,
    input z_read, h_read,
    output[31:0] out,
    output [31:0] z_backout, h_backout
);

wire [31:0] sum;

z z1(.clk(clk), .x1(x1), .x2(x2), .x3(x3), .w1(w1), .w2(w2), .w3(w3), .out(sum), .z_read(z_read), .back_out(z_backout));
h1 h1(.clk(clk), .sum(sum), .out(out), .h_read(h_read), .back_out(h_backout));

endmodule