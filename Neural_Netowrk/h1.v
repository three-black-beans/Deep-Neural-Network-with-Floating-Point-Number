module h1(
    input [31:0] sum,
    input clk,
    input h_read,
    output [31:0] out,
    output load,
    output [31:0] back_out
);

reg  [31:0] sum1;
wire [31:0] out1;

assign load = out1[0] | ~out1[0];
assign out = out1;

reg1 register(.clk(clk), .load(load), .in(out1), .out(back_out), .read(h_read));

sigmoid sg(.x(sum1), .out(out1));

always @(posedge clk) begin
    sum1 <= sum;
end

endmodule