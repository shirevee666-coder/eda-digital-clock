// ============================================================
// bcd7seg.v
// BCD to 7-segment decoder.
// seg[6:0] = {g, f, e, d, c, b, a}
// ACTIVE_LOW = 1 is suitable for DE2-115 HEX displays.
// ============================================================

module bcd7seg #(
    parameter ACTIVE_LOW = 1
)(
    input  wire [3:0] bcd,
    output wire [6:0] seg
);
    reg [6:0] seg_high; // active-high internal signal

    always @(*) begin
        case (bcd)
            4'd0: seg_high = 7'b0111111;
            4'd1: seg_high = 7'b0000110;
            4'd2: seg_high = 7'b1011011;
            4'd3: seg_high = 7'b1001111;
            4'd4: seg_high = 7'b1100110;
            4'd5: seg_high = 7'b1101101;
            4'd6: seg_high = 7'b1111101;
            4'd7: seg_high = 7'b0000111;
            4'd8: seg_high = 7'b1111111;
            4'd9: seg_high = 7'b1101111;
            default: seg_high = 7'b0000000;
        endcase
    end

    assign seg = ACTIVE_LOW ? ~seg_high : seg_high;
endmodule
