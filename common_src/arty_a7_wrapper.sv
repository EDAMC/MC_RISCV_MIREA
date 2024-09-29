module arty_a7_wrapper
# (
    parameter clk_mhz = 100,
              w_key   = 4,
              w_sw    = 4,
              w_led   = 4,
              w_digit = 4,
              w_gpio  = 42
)
(
    input                  CLK100MHZ,
    input                  CPU_RESETN,

    input  [w_key  - 1:0]  BTN,

    input  [w_sw   - 1:0]  SW,
    output [w_led  - 1:0]  LED,

    output                 LED0_B,
    output                 LED0_G,
    output                 LED0_R,

    output                 LED1_B,
    output                 LED1_G,
    output                 LED1_R,

    output                 LED2_B,
    output                 LED2_G,
    output                 LED2_R,

    output                 LED3_B,
    output                 LED3_G,
    output                 LED3_R,

    input                  UART_TXD_IN,

    inout  [7:0]           JA,
    inout  [7:0]           JB,  // VGA_B and VGA_R
    inout  [7:0]           JC,  // VGA_G and VGA_HS, VGA, VS
    inout  [7:0]           JD,

    inout  [w_gpio - 1:0]  GPIO
);

    //------------------------------------------------------------------------

    assign LED0_B = 1'b0;
    assign LED0_G = 1'b0;
    assign LED0_R = 1'b0;

    assign LED1_B = 1'b0;
    assign LED1_G = 1'b0;
    assign LED1_R = 1'b0;

    assign LED2_B = 1'b0;
    assign LED2_G = 1'b0;
    assign LED2_R = 1'b0;

    assign LED3_B = 1'b0;
    assign LED3_G = 1'b0;
    assign LED3_R = 1'b0;
    
    //------------------------------------------------------------------------
    
    wire clk   =   CLK100MHZ;
    wire rst   = ~ CPU_RESETN;
    wire rst_n =   CPU_RESETN;

    //------------------------------------------------------------------------

    wire slow_clk;

    slow_clk_gen # (.fast_clk_mhz (clk_mhz), .slow_clk_hz (500000))
    sr_slow_clk_i  (.slow_clk (slow_clk), .*);

    //------------------------------------------------------------------------
    
    logic [3:0] digit;
    wire [$left (digit):0] reverse_digit;

    generate
        genvar i;

        for (i = 0; i < $bits (digit); i ++)
        begin : abc
            assign reverse_digit [i] = digit [$left (digit) - i];
        end
    endgenerate
    
    logic [7:0] abcdefgh;
    
    logic [3:0]  dots = 4'b1111;   
    logic [15:0] display_data = { reverse_digit, dots, ~abcdefgh };
    
    sr_driver sr_driver
    (
        .clk        (slow_clk    ),
        .rst_n_i    (rst_n       ),
        .data_in    (display_data),
        .sclk       (JA[1]       ),
        .rclk       (JA[2]       ),
        .dio        (JA[3]       ),
        .load_enable(            ) //ready
    );

    assign JA[0] = 1'b1; // VDD

    //------------------------------------------------------------------------

    top
    # (
        .clk_mhz ( clk_mhz ),
        .w_key   ( w_key   ),
        .w_sw    ( w_sw    ),
        .w_led   ( w_led   ),
        .w_digit ( w_digit ),
        .w_gpio  ( w_gpio  )
    )
    i_top
    (
        .clk      ( clk       ),
        .slow_clk ( slow_clk  ),
        .rst      ( rst       ),

        .key      ( BTN       ),
        .sw       ( SW        ),

        .led      ( LED       ),

        .abcdefgh ( abcdefgh  ),
        .digit    ( digit     ),

        .vsync    ( JC [1]    ),
        .hsync    ( JC [0]    ),

        .red      ( JB [7:4]  ),
        .green    ( JC [7:4]  ),
        .blue     ( JB [3:0]  ),

        .uart_rx  (UART_TXD_IN),
        .uart_tx  (UART_RXD_OUT),

        .mic      ( mic       ),
        .gpio     ( GPIO      )
    );
    

endmodule