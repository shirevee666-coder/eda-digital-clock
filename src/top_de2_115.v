// ============================================================
// top_de2_115.v
// Top module for DE2-115 style board.
// ============================================================

module top_de2_115(
    input  wire        CLOCK_50,
    input  wire [3:0]  KEY,
    input  wire [17:0] SW,
    output wire [6:0]  HEX0,
    output wire [6:0]  HEX1,
    output wire [6:0]  HEX2,
    output wire [6:0]  HEX3,
    output wire [6:0]  HEX4,
    output wire [6:0]  HEX5,
    output wire [17:0] LEDR
);
    wire rst_n = KEY[0];
    wire clk_1hz;

    divider #(
        .CLK_FREQ(50_000_000),
        .OUT_FREQ(1)
    ) u_div_1hz(
        .clk(CLOCK_50),
        .rst_n(rst_n),
        .clk_out(clk_1hz)
    );

    wire adj_hour_pulse_fast;
    wire adj_min_pulse_fast;
    wire alarm_min_pulse_fast;

    key_pulse u_key_hour(
        .clk(CLOCK_50),
        .rst_n(rst_n),
        .key_n(KEY[1]),
        .pulse(adj_hour_pulse_fast)
    );

    key_pulse u_key_min(
        .clk(CLOCK_50),
        .rst_n(rst_n),
        .key_n(KEY[2]),
        .pulse(adj_min_pulse_fast)
    );

    key_pulse u_key_alarm_min(
        .clk(CLOCK_50),
        .rst_n(rst_n),
        .key_n(KEY[3]),
        .pulse(alarm_min_pulse_fast)
    );

    // Convert fast key pulses into level sampled by 1 Hz clock.
    // For course demo, this simple method is acceptable when pressing key longer than 1 second.
    // If faster setting is needed, use a single system clock architecture.
    reg adj_hour_req, adj_min_req, alarm_min_req, alarm_hour_req;
    always @(posedge CLOCK_50 or negedge rst_n) begin
        if (!rst_n) begin
            adj_hour_req  <= 1'b0;
            adj_min_req   <= 1'b0;
            alarm_min_req <= 1'b0;
            alarm_hour_req<= 1'b0;
        end else begin
            if (adj_hour_pulse_fast)  adj_hour_req  <= 1'b1;
            if (adj_min_pulse_fast)   adj_min_req   <= 1'b1;
            if (alarm_min_pulse_fast) alarm_min_req <= 1'b1;
            if (SW[2])               alarm_hour_req<= 1'b1;
            if (clk_1hz) begin
                adj_hour_req  <= 1'b0;
                adj_min_req   <= 1'b0;
                alarm_min_req <= 1'b0;
                alarm_hour_req<= 1'b0;
            end
        end
    end

    wire [7:0] hour;
    wire [7:0] minute;
    wire [7:0] second;
    wire [7:0] disp_hour;
    wire [7:0] alarm_hour;
    wire [7:0] alarm_minute;
    wire alarm_match;
    wire hourly_flash;

    clock_core u_core(
        .clk_1hz(clk_1hz),
        .rst_n(rst_n),
        .run_en(SW[0]),
        .adj_hour_pulse(adj_hour_req),
        .adj_min_pulse(adj_min_req),
        .alarm_hour_pulse(alarm_hour_req),
        .alarm_min_pulse(alarm_min_req),
        .alarm_en(SW[3]),
        .mode_12h(SW[1]),
        .hour(hour),
        .minute(minute),
        .second(second),
        .disp_hour(disp_hour),
        .alarm_hour(alarm_hour),
        .alarm_minute(alarm_minute),
        .alarm_match(alarm_match),
        .hourly_flash(hourly_flash)
    );

    bcd7seg u_hex0(.bcd(second[3:0]),    .seg(HEX0));
    bcd7seg u_hex1(.bcd(second[7:4]),    .seg(HEX1));
    bcd7seg u_hex2(.bcd(minute[3:0]),    .seg(HEX2));
    bcd7seg u_hex3(.bcd(minute[7:4]),    .seg(HEX3));
    bcd7seg u_hex4(.bcd(disp_hour[3:0]), .seg(HEX4));
    bcd7seg u_hex5(.bcd(disp_hour[7:4]), .seg(HEX5));

    assign LEDR[0]    = alarm_match;
    assign LEDR[1]    = hourly_flash;
    assign LEDR[9:2]  = alarm_minute;
    assign LEDR[17:10]= alarm_hour;
endmodule
