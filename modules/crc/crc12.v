// Description : x^12 + x^11 + x^3 + x^2 + x + 1
// Algorithm   : CRC-12
// Polynomial  : 0x80F
// Init value  : 0xFFF

module crc12 #(
    parameter DATA_WIDHT = 8,
    parameter CRC_WIDTH  = 12
) (
    input  wire                  clk,
    input  wire                  arstn,
    input  wire                  en,
    input  wire [DATA_WIDHT-1:0] data,
    output reg  [CRC_WIDTH-1:0 ] crc12
);
  
    always @(posedge clk or negedge arstn) begin
        if (~arstn) begin
            crc12 <= 12'hfff;
        end else begin
            crc12 <= en ? crc12_byte(crc12, data) : crc12;
        end
    end

    function [CRC_WIDTH-1:0] crc12_bit;
        input [CRC_WIDTH-1:0] crc;
        input                 data;
        begin
            // crc12_bit     = crc << 1;
            feedback      = crc[11] ^ data;
            crc12_bit[0]  = feedback;
            crc12_bit[1]  = crc[0] ^ feedback;
            crc12_bit[2]  = crc[1] ^ feedback;
            crc12_bit[3]  = crc[2] ^ feedback;
            crc12_bit[4]  = crc[3];
            crc12_bit[5]  = crc[4];
            crc12_bit[6]  = crc[5];
            crc12_bit[7]  = crc[6];
            crc12_bit[8]  = crc[7];
            crc12_bit[9]  = crc[8];
            crc12_bit[10] = crc[9];
            crc12_bit[11] = crc[10] ^ feedback;
        end
    endfunction

    function [CRC_WIDTH-1:0] crc12_byte;
        input [CRC_WIDTH-1:0 ] crc;
        input [DATA_WIDHT-1:0] data;
        integer                i;
        begin
            crc12_byte = crc;
            for (i = DATA_WIDHT - 1; i >= 0; i = i - 1) begin
                crc12_byte = crc12_bit(crc12_byte, data[i]);
            end
        end
    endfunction

endmodule
