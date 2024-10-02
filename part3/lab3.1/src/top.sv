module top
# (
    parameter clk_mhz   = 50,
              pixel_mhz = 25,
              w_key     = 4,
              w_sw      = 8,
              w_led     = 8,
              w_digit   = 8,
              w_gpio    = 100,
              w_red     = 4,
              w_green   = 4,
              w_blue    = 4
)
(
    input                        clk,
    input                        slow_clk,
    input                        rst,

    // Keys, switches, LEDs

    input        [w_key   - 1:0] key,
    input        [w_sw    - 1:0] sw,
    output logic [w_led   - 1:0] led,

    // A dynamic seven-segment display

    output logic [          7:0] abcdefgh,
    output logic [w_digit - 1:0] digit,

    // VGA

    output logic                 vsync,
    output logic                 hsync,
    output logic [w_red   - 1:0] red,
    output logic [w_green - 1:0] green,
    output logic [w_blue  - 1:0] blue,
    output                       display_on,
    output                       pixel_clk,

    input                        uart_rx,
    output                       uart_tx,

    input        [         23:0] mic,
    output       [         15:0] sound,

    // General-purpose Input/Output

    inout        [w_gpio  - 1:0] gpio
);

    //------------------------------------------------------------------------

       assign led        = '0;
    // assign abcdefgh   = '0;
    // assign digit      = '0;
       assign vsync      = '0;
       assign hsync      = '0;
       assign red        = '0;
       assign green      = '0;
       assign blue       = '0;
       assign display_on = '0;
       assign pixel_clk  = '0;
       assign sound      = '0;
       assign uart_tx    = '1;

    //------------------------------------------------------------------------

    wire [ 4:0] regAddr;  // debug access reg address
    wire [31:0] regData;  // debug access reg data
    wire [31:0] imAddr;   // instruction memory address
    wire [31:0] imData;   // instruction memory data
    
    //------------------------------------------------------------------------
    
    wire cpu_slow_clk;
    
    slow_clk_gen # (.fast_clk_mhz (clk_mhz), .slow_clk_hz (2))
    cpu_slow_clk_i (.slow_clk (cpu_slow_clk), .*);

    //------------------------------------------------------------------------

    sr_cpu cpu
    (
        .clk     ( cpu_slow_clk ),
        .rst     ( rst          ),
        .regAddr ( regAddr      ),
        .regData ( regData      ),
        .imAddr  ( imAddr       ),
        .imData  ( imData       )
    );

    instruction_rom # (.SIZE (64)) rom
    (
        .a       ( imAddr   ),
        .rd      ( imData   )
    );

    //------------------------------------------------------------------------

    assign regAddr = { key[1], sw };  // a0

    localparam w_number = w_digit * 4;

    wire [w_number - 1:0] number
        = w_number' ( key [0] ? imAddr : regData );

    seven_segment_display
    # (
        .w_digit  ( w_digit  ),
        .clk_mhz  ( clk_mhz  )
    )
    display
    (
        .clk      ( clk      ),
        .rst      ( rst      ),

        .number   ( number   ),
        .dots     ( '0       ),

        .abcdefgh ( abcdefgh ),
        .digit    ( digit    )
    );

endmodule
