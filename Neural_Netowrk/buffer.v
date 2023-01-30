module buffer(
    input clk,
    input [31:0] in,
    output reg [31:0] out
);

always @(posedge clk)

out <= in;

endmodule