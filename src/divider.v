// ============================================================
// divider.v
// Clock divider for EDA digital clock project.
// Verilog-2001, synthesizable.
// ============================================================

module divider #(
    parameter CLK_FREQ = 50_000_000,
    parameter OUT_FREQ = 1
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_out
);
    localparam integer HALF_COUNT = CLK_FREQ / (2 * OUT_FREQ);
    reg [31:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 32'd0;
            clk_out <= 1'b0;
        end else begin
            if (cnt >= HALF_COUNT - 1) begin
                cnt     <= 32'd0;
                clk_out <= ~clk_out;
            end else begin
                cnt <= cnt + 1'b1;
            end
        end
    end
endmodule
