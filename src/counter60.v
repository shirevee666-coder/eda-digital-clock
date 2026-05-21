// ============================================================
// counter60.v
// BCD counter: 00~59
// ones digit counts 0~9, tens digit counts 0~5.
// ============================================================

module counter60(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       en,
    input  wire       inc,
    input  wire       load,
    input  wire [7:0] load_value,
    output reg  [7:0] bcd,
    output wire       carry
);
    wire tick;
    assign tick  = en | inc;
    assign carry = tick && (bcd[7:4] == 4'd5) && (bcd[3:0] == 4'd9);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bcd <= 8'h00;
        end else if (load) begin
            if ((load_value[7:4] <= 4'd5) && (load_value[3:0] <= 4'd9))
                bcd <= load_value;
            else
                bcd <= 8'h00;
        end else if (tick) begin
            if (bcd[3:0] == 4'd9) begin
                bcd[3:0] <= 4'd0;
                if (bcd[7:4] == 4'd5)
                    bcd[7:4] <= 4'd0;
                else
                    bcd[7:4] <= bcd[7:4] + 1'b1;
            end else begin
                bcd[3:0] <= bcd[3:0] + 1'b1;
            end
        end
    end
endmodule
