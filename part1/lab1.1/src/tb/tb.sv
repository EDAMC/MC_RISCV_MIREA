
module tb;

    localparam clk_mhz = 1,
               w_key   = 4,
               w_sw    = 4,
               w_led   = 4,
               w_digit = 4,
               w_gpio  = 42;

    //------------------------------------------------------------------------

    logic       clk;
    logic       rst;
    logic [3:0] key;
    logic [3:0] sw;
    logic [3:0] led;
    
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
    top_module
    (
        .clk      ( clk ),
        .slow_clk ( clk ),
        .rst      ( rst ),
        .key      ( key ),
        .sw       ( sw  ),
        .led      ( led )
    );

    //------------------------------------------------------------------------

    initial
    begin

        repeat (8)
        begin
             # 10
             key <= $urandom ();
             sw  <= $urandom ();
        end

        $finish;
    end

endmodule
