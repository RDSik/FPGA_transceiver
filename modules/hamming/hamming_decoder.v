module hamming_decoder (
    input  wire        clk, 
    input  wire        arstn,
    input  wire        rden,
    input  wire [11:0] hc_in,
    output reg  [7:0 ] q
);

    wire g0_error; 
    wire g1_error; 
    wire g2_error;
    wire g3_error;

    assign g0_error = hc_in[10] ^ hc_in[8] ^ hc_in[6] ^ hc_in[4] ^ hc_in[2] ^ hc_in[0];
    assign g1_error = hc_in[10] ^ hc_in[9] ^ hc_in[6] ^ hc_in[5] ^ hc_in[2] ^ hc_in[1];
    assign g2_error = hc_in[11] ^ hc_in[6] ^ hc_in[5] ^ hc_in[4] ^ hc_in[3];
    assign g3_error = hc_in[11] ^ hc_in[10] ^ hc_in[9] ^ hc_in[8] ^ hc_in[7];

    always @ (posedge clk or negedge arstn) begin
        if (~arstn) begin
            q <= 0;
        end else if (rden) begin
            case ({g3_error, g2_error, g1_error, g0_error})
                4'b0000 : q <= {hc_in[11:8], hc_in[6:4], hc_in[2]};
                4'b0001 : q <= {hc_in[11:8], hc_in[6:4], hc_in[2]};
                4'b0010 : q <= {hc_in[11:8], hc_in[6:4], hc_in[2]};
                4'b0011 : q <= {hc_in[11:8], hc_in[6:4], ~hc_in[2]};
                4'b0100 : q <= {hc_in[11:8], hc_in[6:4], hc_in[2]};
                4'b0101 : q <= {hc_in[11:8], hc_in[6:5], ~hc_in[4], hc_in[2]};
                4'b0110 : q <= {hc_in[11:8], hc_in[6], ~hc_in[5], hc_in[4], hc_in[2]};
                4'b0111 : q <= {hc_in[11:8], ~hc_in[6], hc_in[5], hc_in[4], hc_in[2]};
                4'b1000 : q <= {hc_in[11:8], hc_in[6], hc_in[5], hc_in[4], hc_in[2]};
                4'b1001 : q <= {hc_in[11:9], ~hc_in[8], hc_in[6:4], hc_in[2]};
                4'b1010 : q <= {hc_in[11:10], ~hc_in[9], hc_in[8], hc_in[6:4], hc_in[2]};
                4'b1011 : q <= {hc_in[11], ~hc_in[10], hc_in[9], hc_in[8], hc_in[6:4], hc_in[2]};
                4'b1100 : q <= {~hc_in[11], hc_in[10], hc_in[9], hc_in[8], hc_in[6:4], hc_in[2]};
                default : q <= 0;
            endcase
        end else begin
            q <= 0;
        end
    end

endmodule
