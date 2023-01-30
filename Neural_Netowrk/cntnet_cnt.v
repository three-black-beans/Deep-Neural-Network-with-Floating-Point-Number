module cntnet_cnt(
    input clk, set, reset,
    output [2:0] cnt
);

reg [2:0] count = 0;


assign cnt = count;

always @(posedge clk) begin
    if (set) begin 
        count <= 3'b1;
    end else if (reset) begin
        count <= 3'b0;
    end else if (cnt == 3'd7) begin
        count <= 3'b0;
    end else if (count >= 3'd1) begin
        count <= count + 3'b1;
    end
end                   

endmodule

