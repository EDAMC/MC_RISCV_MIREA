`timescale 1ns / 1ps

module sr_driver
(
    input clk, rst_n_i,
    input [15:0] data_in,
    output logic sclk, rclk, dio, load_enable
);

logic [15:0] ser;
logic [3:0] cnt;
//logic load_enable;

assign sclk 		 = clk;
assign dio  		 = ser[0];
//assign rclk 	    = (cnt == 1);
assign load_enable   = (cnt == 0);

always@ (posedge clk or negedge rst_n_i)
    if      (!rst_n_i)     cnt <= '0;
    else                   cnt <= cnt + 1'b1;

always@ (posedge clk or negedge rst_n_i)
    if      (!rst_n_i)     ser <= '0;
    else if (load_enable)  ser <= data_in;             // load parallel data
    else                   ser <= {ser[0], ser[15:1]}; // serialize parallel data

 always@ (posedge clk or negedge rst_n_i)
     if      (!rst_n_i)     rclk <= '0;
     else if (cnt == 1)     rclk <= !rclk;


endmodule
