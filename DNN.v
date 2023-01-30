/*---------------------------------------------------------------------------
 *
 *  Copyright (c) 2023 by Jin Hyeong Park, All rights reserved.
 *
 *  File name  : neural_network.v
 *  Written by : Park, Jin Hyoeng
 *               School of Electrical Engineering / Department of Biomechatronics
 *               Sungkyunkwan University
 *  Written on : January 18, 2023
 *  Version    : 2.0
 *  Design     : Deep Neural Network
 *  Target Devices: Zybo Z7-20
 *  Modification History:
 *      * January 20, 2023  Jin Hyeong Park
 *        version 1.0 released.
 *
 *      * January 23, 2023 by Jin Hyeong Park
 *        version 2.0 released.
 *
 *      * January 28, 2023 by Jin Hyeong Park
 *        version 2.0 code modified and comments added.
 *
 *---------------------------------------------------------------------------*/

// Start Back Propagation when cnt is 6
// Reset Back Propagation when cnt is 7
module neural_network(
    input clk,
    input [31:0] x1, x2, x3,
    input [31:0] target_out,
    input set,
    output [31:0] out,
    output [2:0] control
);

wire [31:0] out1, out2, out3, out4;
wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12;
wire [31:0] back_w1, back_w2, back_w3, back_w4, back_w5, back_w6, back_w7, back_w8, back_w9, back_w10, back_w11, back_w12;
wire [31:0] x11, x22, x33, x1b, x2b, x3b;
wire [31:0] target_out1, target_out2;
wire sign;
wire off;
wire off_control;
wire on;
wire on_control; 
wire [31:0] new_w1, new_w2, new_w3, new_w4, new_w5, new_w6, new_w7, new_w8, new_w9, new_w10, new_w11, new_w12;
wire weight_load;
wire control1;
wire xx;
wire weight_read;
wire [31:0] back_x1, back_x2, back_x3;
wire [31:0] back_target;
wire back_load;
wire [31:0] back_z1, back_z2, back_z3, back_z4;
wire [31:0] back_h1, back_h2, back_h3, back_h4;
wire bp_complete;
wire [3:0] w_control;


assign sign = |control;
assign off_control = x11[0] | ~x11[0];
assign back_load = target_out2[0] | ~target_out2[0];
assign bp_complete = new_w10[1] | ~new_w10[1];

tristate_buffer t1(.in(x1), .control(sign), .out(x11));
tristate_buffer t2(.in(x2), .control (sign), .out(x22));
tristate_buffer t3(.in(x3), .control(sign), .out(x33));
tristate_buffer t4(.in(target_out), .control(sign), .out(target_out1));
cntnet_cnt c(.clk(clk), .set(off_control), .reset(bp_complete), .cnt(control));
buffer target_buffer(.clk(clk), .in(target_out1), .out(target_out2));

reg1 target_reg(.clk(clk), .in(target_out2), .load(back_load), .out(back_target), .read(weight_read));

reg1 x1_reg(.clk(clk), .in(x11), .load(off_control), .out(back_x1), .read(weight_read));
reg1 x2_reg(.clk(clk), .in(x22), .load(off_control), .out(back_x2), .read(weight_read));
reg1 x3_reg(.clk(clk), .in(x33), .load(off_control), .out(back_x3), .read(weight_read));

weight_reg wr1(.clk(clk), .saved_w(w1), .read(weight_read), .w_out(back_w1), .load(bp_complete), .w(new_w1), .set(set));
weight_reg wr2(.clk(clk), .saved_w(w2), .read(weight_read), .w_out(back_w2), .load(bp_complete), .w(new_w2), .set(set));
weight_reg wr3(.clk(clk), .saved_w(w3), .read(weight_read), .w_out(back_w3), .load(bp_complete), .w(new_w3), .set(set));
weight_reg wr4(.clk(clk), .saved_w(w4), .read(weight_read), .w_out(back_w4), .load(bp_complete), .w(new_w4), .set(set));
weight_reg wr5(.clk(clk), .saved_w(w5), .read(weight_read), .w_out(back_w5), .load(bp_complete), .w(new_w5), .set(set));
weight_reg wr6(.clk(clk), .saved_w(w6), .read(weight_read), .w_out(back_w6), .load(bp_complete), .w(new_w6), .set(set));
weight_reg wr7(.clk(clk), .saved_w(w7), .read(weight_read), .w_out(back_w7), .load(bp_complete), .w(new_w7), .set(set));
weight_reg wr8(.clk(clk), .saved_w(w8), .read(weight_read), .w_out(back_w8), .load(bp_complete), .w(new_w8), .set(set));
weight_reg wr9(.clk(clk), .saved_w(w9), .read(weight_read), .w_out(back_w9), .load(bp_complete), .w(new_w9), .set(set));
weight_reg wr10(.clk(clk), .saved_w(w10), .read(weight_read), .w_out(back_w10), .load(bp_complete), .w(new_w10), .set(set));
weight_reg wr11(.clk(clk), .saved_w(w11), .read(weight_read), .w_out(back_w11), .load(bp_complete), .w(new_w11), .set(set));
weight_reg wr12(.clk(clk), .saved_w(w12), .read(weight_read), .w_out(back_w12), .load(bp_complete), .w(new_w12), .set(set));

neu hidden_neuron1(.x1(x11), .x2(x22), .x3(x33), .w1(w1), .w2(w2), .w3(w3), .out(out1), .z_read(weight_read), .h_read(weight_read), .z_backout(back_z1), .h_backout(back_h1), .clk(clk));
neu hidden_neuron2(.x1(x11), .x2(x22), .x3(x33), .w1(w4), .w2(w5), .w3(w6), .out(out2), .z_read(weight_read), .h_read(weight_read), .z_backout(back_z2), .h_backout(back_h2), .clk(clk));
neu hidden_neuron3(.x1(x11), .x2(x22), .x3(x33), .w1(w7), .w2(w8), .w3(w9), .out(out3), .z_read(weight_read), .h_read(weight_read), .z_backout(back_z3), .h_backout(back_h3), .clk(clk));

neu out_neuron(.x1(out1), .x2(out2), .x3(out3), .w1(w10), .w2(w11), .w3(w12), .out(out4), .z_read(weight_read), .h_read(weight_read), .z_backout(back_z4), .h_backout(back_h4), .clk(clk));

buffer out_buffer(.clk(clk), .in(out4), .out(out));

assign weight_read = out[0] | ~out[0];

back_p1 update_w10(.target(back_target), .output_sigmoid(back_h4), .hidden_layer_value_sigmoid(back_h1), .w_initial(back_w10), .w_update(new_w10));
back_p1 update_w11(.target(back_target), .output_sigmoid(back_h4), .hidden_layer_value_sigmoid(back_h2), .w_initial(back_w11), .w_update(new_w11));
back_p1 update_w12(.target(back_target), .output_sigmoid(back_h4), .hidden_layer_value_sigmoid(back_h3), .w_initial(back_w12), .w_update(new_w12));

back_p2 update_w1(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w10), .hidden_sigmoid_value(back_h1), .hidden_layer_value(back_z1), .initial_weight(back_w1), .w_new(new_w1), .initial_input(back_x1));
back_p2 update_w2(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w11), .hidden_sigmoid_value(back_h2), .hidden_layer_value(back_z2), .initial_weight(back_w2), .w_new(new_w2), .initial_input(back_x1));
back_p2 update_w3(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w12), .hidden_sigmoid_value(back_h3), .hidden_layer_value(back_z3), .initial_weight(back_w3), .w_new(new_w3), .initial_input(back_x1));
back_p2 update_w4(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w10), .hidden_sigmoid_value(back_h1), .hidden_layer_value(back_z1), .initial_weight(back_w4), .w_new(new_w4), .initial_input(back_x2));
back_p2 update_w5(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w11), .hidden_sigmoid_value(back_h2), .hidden_layer_value(back_z2), .initial_weight(back_w5), .w_new(new_w5), .initial_input(back_x2));
back_p2 update_w6(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w12), .hidden_sigmoid_value(back_h3), .hidden_layer_value(back_z3), .initial_weight(back_w6), .w_new(new_w6), .initial_input(back_x2));
back_p2 update_w7(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w10), .hidden_sigmoid_value(back_h1), .hidden_layer_value(back_z1), .initial_weight(back_w7), .w_new(new_w7), .initial_input(back_x3));
back_p2 update_w8(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w11), .hidden_sigmoid_value(back_h2), .hidden_layer_value(back_z2), .initial_weight(back_w8), .w_new(new_w8), .initial_input(back_x3));
back_p2 update_w9(.target(back_target), .sigmoid_out(back_h4), .layer2_weight(back_w12), .hidden_sigmoid_value(back_h3), .hidden_layer_value(back_z3), .initial_weight(back_w9), .w_new(new_w9), .initial_input(back_x3));
 
endmodule