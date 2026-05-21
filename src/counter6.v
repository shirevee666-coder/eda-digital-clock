// ============================================================
// counter6.v
// BCD counter: 0~5
// ============================================================

module counter6(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    input  wire       load,
    input  wire [3:0] load_value,
    output reg  [3:0] q,
    output wire       carry
);
    assign carry = en && (q == 4'd5);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 4'd0;
        end else if (load) begin
            q <= (load_value > 4'd5) ? 4'd0 : load_value;
        end else if (en) begin
            if (q == 4'd5)
                q <= 4'd0;
            else
                q <= q + 1'b1;
        end
    end
endmodule
