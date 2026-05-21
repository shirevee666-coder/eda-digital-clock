// ============================================================
// clock_core.v
// Multifunction digital clock core.
// - 24-hour counting: 00:00:00 ~ 23:59:59
// - Adjust hour and minute by one-clock pulses
// - 12/24-hour display selection
// - Simple alarm compare output
// - Hourly chime LED pulse window
// ============================================================

module clock_core(
    input  wire       clk_1hz,
    input  wire       rst_n,
    input  wire       run_en,
    input  wire       adj_hour_pulse,
    input  wire       adj_min_pulse,
    input  wire       alarm_hour_pulse,
    input  wire       alarm_min_pulse,
    input  wire       alarm_en,
    input  wire       mode_12h,
    output wire [7:0] hour,
    output wire [7:0] minute,
    output wire [7:0] second,
    output reg  [7:0] disp_hour,
    output wire [7:0] alarm_hour,
    output wire [7:0] alarm_minute,
    output wire       alarm_match,
    output reg        hourly_flash
);
    wire sec_carry;
    wire min_carry;

    wire min_inc  = sec_carry;
    wire hour_inc = min_carry;

    counter60 u_second(
        .clk(clk_1hz),
        .rst_n(rst_n),
        .en(run_en),
        .inc(1'b0),
        .load(1'b0),
        .load_value(8'h00),
        .bcd(second),
        .carry(sec_carry)
    );

    counter60 u_minute(
        .clk(clk_1hz),
        .rst_n(rst_n),
        .en(run_en && min_inc),
        .inc(adj_min_pulse),
        .load(1'b0),
        .load_value(8'h00),
        .bcd(minute),
        .carry(min_carry)
    );

    counter24 u_hour(
        .clk(clk_1hz),
        .rst_n(rst_n),
        .en(run_en && hour_inc),
        .inc(adj_hour_pulse),
        .load(1'b0),
        .load_value(8'h00),
        .bcd(hour),
        .carry()
    );

    counter60 u_alarm_minute(
        .clk(clk_1hz),
        .rst_n(rst_n),
        .en(1'b0),
        .inc(alarm_min_pulse),
        .load(1'b0),
        .load_value(8'h00),
        .bcd(alarm_minute),
        .carry()
    );

    counter24 u_alarm_hour(
        .clk(clk_1hz),
        .rst_n(rst_n),
        .en(1'b0),
        .inc(alarm_hour_pulse),
        .load(1'b0),
        .load_value(8'h00),
        .bcd(alarm_hour),
        .carry()
    );

    assign alarm_match = alarm_en && (hour == alarm_hour) && (minute == alarm_minute) && (second < 8'h10);

    always @(*) begin
        if (!mode_12h) begin
            disp_hour = hour;
        end else begin
            case (hour)
                8'h00: disp_hour = 8'h12;
                8'h13: disp_hour = 8'h01;
                8'h14: disp_hour = 8'h02;
                8'h15: disp_hour = 8'h03;
                8'h16: disp_hour = 8'h04;
                8'h17: disp_hour = 8'h05;
                8'h18: disp_hour = 8'h06;
                8'h19: disp_hour = 8'h07;
                8'h20: disp_hour = 8'h08;
                8'h21: disp_hour = 8'h09;
                8'h22: disp_hour = 8'h10;
                8'h23: disp_hour = 8'h11;
                default: disp_hour = hour;
            endcase
        end
    end

    // Simple hourly chime indicator:
    // flash during the first 8 seconds when minute is 00.
    always @(*) begin
        if ((minute == 8'h00) && (second[7:4] == 4'd0) && (second[3:0] < 4'd8))
            hourly_flash = second[0];
        else
            hourly_flash = 1'b0;
    end
endmodule
