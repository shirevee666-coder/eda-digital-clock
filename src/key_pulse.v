// ============================================================
// key_pulse.v
// Simple synchronizer + debounce + one-clock pulse generator.
// key_n is active-low, as on DE2-115 KEY buttons.
// ============================================================

module key_pulse #(
    parameter DEBOUNCE_MAX = 20'd999_999
)(
    input  wire clk,
    input  wire rst_n,
    input  wire key_n,
    output reg  pulse
);
    reg key_sync0, key_sync1;
    reg key_state;
    reg [19:0] cnt;

    wire key_pressed = ~key_sync1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_sync0 <= 1'b1;
            key_sync1 <= 1'b1;
        end else begin
            key_sync0 <= key_n;
            key_sync1 <= key_sync0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_state <= 1'b0;
            cnt       <= 20'd0;
            pulse     <= 1'b0;
        end else begin
            pulse <= 1'b0;
            if (key_pressed != key_state) begin
                if (cnt >= DEBOUNCE_MAX) begin
                    key_state <= key_pressed;
                    cnt <= 20'd0;
                    if (key_pressed)
                        pulse <= 1'b1;
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end else begin
                cnt <= 20'd0;
            end
        end
    end
endmodule
