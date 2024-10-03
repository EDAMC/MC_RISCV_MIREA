`timescale 1ns / 1ps

module sr_driver
(
    input clk, rst_n_i,
    input [3:0] digit,
    input [7:0] abcdefgh,
    output logic sclk, rclk, dio, load_enable
);

// DIGIT 0001 = ACTIVE №1
//  
//  --a--      --a--      --a--      --a--
// |     |    |     |    |     |    |     |
// f     b    f     b    f     b    f     b
// |     |    |     |    |     |    |     |
//  --g--      --g--      --g--      --g--
// |     |    |     |    |     |    |     |
// e     c    e     c    e     c    e     c
// |     |    |     |    |     |    |     |
//  --d--  h   --d--  h   --d--  h   --d--  h
//
//    3          2          1          0

logic [$left (digit):0] reverse_digit;
generate
    genvar i;
    for (i = 0; i < $bits (digit); i ++)
    begin : abc
        assign reverse_digit [i] = digit [$left (digit) - i];
    end
endgenerate
    
logic [3:0]  dots = 4'b1111;  
     
logic [15:0] data_in;
logic [15:0] ser;
logic [3:0] cnt;

assign data_in = { reverse_digit, dots, ~abcdefgh };
assign sclk 		 = clk;
assign dio  		 = ser[0];
assign load_enable   = (cnt == 0);

always@ (posedge clk or negedge rst_n_i)
    if      (!rst_n_i)     cnt <= '0;
    else                   cnt <= cnt + 1'b1;

always@ (posedge clk or negedge rst_n_i)
    if      (!rst_n_i)     ser <= '0;
    else if (load_enable)  ser <= data_in;             // load parallel data
    else                   ser <= {ser[0], ser[15:1]}; // serialize parallel data

 always@ (posedge clk)
     if (cnt == 1) rclk <= !rclk;


endmodule
