module reg1(
    input [31:0] in,
    input clk,
    input load,
    input read,
    output [31:0] out,
    output [31:0] saved
);

reg [31:0] saved_out;


assign out = read ? saved_out : 32'bz ;

always @(posedge clk) begin
    if (load==1) begin
        saved_out <= in;
    end
end

endmodule