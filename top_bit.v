module top_bit(
    input i_Clk,

    // Board switches (left as available inputs for future use)
    input i_Switch_1,
    input i_Switch_2,
    input i_Switch_3,
    input i_Switch_4,

    // LEDs to observe CPU state
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4
);

    // Simple blink test with inverted outputs (active-low), independent of CPU.
    // This helps verify whether LEDs/pins are active-low on your board.
    // Increase width to slow down blink rate (tune these indices if still too fast)
    reg [27:0] blink_cnt = 0;
    always @(posedge i_Clk) begin
        blink_cnt <= blink_cnt + 1;
    end

    // Invert outputs to drive active-low LEDs (set to 0 to light an LED if board uses active-low)
    assign o_LED_1 = ~blink_cnt[27];
    assign o_LED_2 = ~blink_cnt[26];
    assign o_LED_3 = ~blink_cnt[25];
    assign o_LED_4 = ~blink_cnt[24];

endmodule
