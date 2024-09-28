module arty_a7_wrapper
# (
    parameter clk_mhz = 100,
              w_key   = 4,
              w_sw    = 4,
              w_led   = 4,
              w_digit = 0,
              w_gpio  = 42
)
(
    input                  CLK100MHZ,
    input                  CPU_RESETN,

    input                  BTN_0,
    input                  BTN_1,
    input                  BTN_2,
    input                  BTN_3,

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
    // wires & inputs
    wire          clkIn     =  CLK100MHZ;
    wire          rst_n     =  CPU_RESETN;
    wire          clkEnable =  ~BTN_0;
    wire [  3:0 ] clkDivide =  4'b1000;
    wire [  4:0 ] regAddr   =  { 1'b0, SW [3:0] };
    wire [ 31:0 ] regData;
    
    
    wire          slow_clk;
    wire          clk_i = CLK100MHZ;
    
    slow_clk_gen # (.fast_clk_mhz (clk_mhz), .slow_clk_hz (500000))
    i_slow_clk_gen (.slow_clk (slow_clk), .*);

    //cores
    sm_top sm_top
    (
        .clkIn      ( clkIn     ),
        .rst_n      ( rst_n     ),
        .clkDivide  ( clkDivide ),
        .clkEnable  ( clkEnable ),
        .clk        ( clk       ),
        .regAddr    ( regAddr   ),
        .regData    ( regData   )
    );
    
    logic [7:0] abcdefgh;
    logic [3:0] digit;
    logic [3:0] dots = 4'b0000;
    
    logic [15:0] display_data = {digit,dots,~abcdefgh};
    
    seven_segment_display #(
        .w_digit(4),
        .clk_mhz(100),
        .update_hz(4)
    ) seven_segment_display(
        .clk(clkIn),
        .rst_n(rst_n),
        .number(regData[15:0]),
        .dots(dots),
        .abcdefgh(abcdefgh),
        .digit(digit) 
    );
    
    sr_driver sr_driver
    (
        .clk(slow_clk),
        .rst_n_i(rst_n),
        .data_in(display_data),
        .sclk(JA[1]),
        .rclk(JA[2]),
        .dio(JA[3]),
        .load_enable() //ready
    );
    assign JA[0] = 1'b1; // VDD
    
    //outputs
    assign LED[3:0] = regData[3:0];

endmodule
