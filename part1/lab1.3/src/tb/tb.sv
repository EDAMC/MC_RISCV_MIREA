
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
        clk = 1'b0;

        forever
            # 5 clk = ~ clk;
    end

    //------------------------------------------------------------------------

    initial
    begin
        rst <= 1'bx;
        repeat (2) @ (posedge clk);
        rst <= 1'b1;
        repeat (2) @ (posedge clk);
        rst <= 1'b0;
    end

    //------------------------------------------------------------------------

    initial
    begin


        key <= '0;
        sw  <= '0;

        @ (negedge rst);

        repeat (50)
        begin
            @ (posedge clk);

            key <= $urandom ();
            sw  <= $urandom ();
        end

        // To change only one key

        key <= '0;

        repeat (50)
        begin
            @ (posedge clk);
            key [0] <= $urandom ();
        end

        $finish;
    end


endmodule
