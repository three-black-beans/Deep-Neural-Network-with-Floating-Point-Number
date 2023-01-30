module weight_reg #(parameter w_1 =  32'b00111111001000000000000000000000)(
    input [31:0] w,
    input clk,
    input load,
    input read,
    input set,
    output [31:0] w_out,
    output reg [31:0] saved_w
);


assign w_out = read ? saved_w : 32'bz;

always @(posedge clk or posedge set) begin
    if (set == 1) begin
        saved_w <= w_1;
    end else if (load == 1)  begin
        saved_w <= w;
    end    
end

endmodule