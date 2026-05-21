`timescale 1ns/1ps

module tb_clock_core;
    reg clk_1hz;
    reg rst_n;
    reg run_en;
    reg adj_hour_pulse;
    reg adj_min_pulse;
    reg alarm_hour_pulse;
    reg alarm_min_pulse;
    reg alarm_en;
    reg mode_12h;

    wire [7:0] hour;
    wire [7:0] minute;
    wire [7:0] second;
    wire [7:0] disp_hour;
    wire [7:0] alarm_hour;
    wire [7:0] alarm_minute;
    wire alarm_match;
    wire hourly_flash;

    clock_core dut(
        .clk_1hz(clk_1hz),
        .rst_n(rst_n),
        .run_en(run_en),
        .adj_hour_pulse(adj_hour_pulse),
        .adj_min_pulse(adj_min_pulse),
        .alarm_hour_pulse(alarm_hour_pulse),
        .alarm_min_pulse(alarm_min_pulse),
        .alarm_en(alarm_en),
        .mode_12h(mode_12h),
        .hour(hour),
        .minute(minute),
        .second(second),
        .disp_hour(disp_hour),
        .alarm_hour(alarm_hour),
        .alarm_minute(alarm_minute),
        .alarm_match(alarm_match),
        .hourly_flash(hourly_flash)
    );

    initial begin
        clk_1hz = 1'b0;
        forever #5 clk_1hz = ~clk_1hz;
    end

    task pulse_hour;
    begin
        adj_hour_pulse = 1'b1; #10; adj_hour_pulse = 1'b0; #10;
    end
    endtask

    task pulse_min;
    begin
        adj_min_pulse = 1'b1; #10; adj_min_pulse = 1'b0; #10;
    end
    endtask

    integer i;

    initial begin
        rst_n = 1'b0;
        run_en = 1'b0;
        adj_hour_pulse = 1'b0;
        adj_min_pulse = 1'b0;
        alarm_hour_pulse = 1'b0;
        alarm_min_pulse = 1'b0;
        alarm_en = 1'b0;
        mode_12h = 1'b0;

        #30;
        rst_n = 1'b1;
        run_en = 1'b1;

        // Run for 65 seconds, check second and minute carry.
        #650;

        // Adjust to 01:01:xx.
        pulse_hour();
        pulse_min();

        // Test 12-hour display mode.
        mode_12h = 1'b1;
        #50;
        mode_12h = 1'b0;

        // Set alarm to 01:01 by pulsing alarm hour/minute.
        alarm_hour_pulse = 1'b1; #10; alarm_hour_pulse = 1'b0; #10;
        alarm_min_pulse  = 1'b1; #10; alarm_min_pulse  = 1'b0; #10;
        alarm_en = 1'b1;

        #200;
        $stop;
    end
endmodule
