module tristate_buffer(
    input control,
    input [31:0] in,
    output [31:0] out
);

assign out = (~control) ? in : 32'bz;

endmodule
