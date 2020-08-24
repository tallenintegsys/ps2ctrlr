`timescale 10ns/10ps
module ps2ctrlr (
    input   CLOCK_50,
    output  logic [7:0] q,
    input   clr,
    input   PS2_DAT,
    input   PS2_CLK);

logic [16-1:0] dat_buffer;
logic [16-1:0] clk_buffer;
logic [3:0] buffer_count;
logic ps2_clk, ps2_dat;
logic [3:0]kb_count;
logic [7:0]kb_dat;
logic lift, shift;
logic kbs;

initial begin
    dat_buffer = 16'd0;
    clk_buffer = 16'd0;
    buffer_count = 4'd0;
    ps2_clk = 0;
    ps2_dat = 0;
    kb_count = 4'hf;
    kb_dat = 8'd0;
    lift = 0;
    shift = 0;
    q = 0;
end

// Module Item(s)
always @ (posedge CLOCK_50) begin
    buffer_count++;
    clk_buffer[buffer_count] = PS2_CLK;
    dat_buffer[buffer_count] = PS2_DAT;
    if (clk_buffer == 16'hffff)
        ps2_clk = 1;
    if (clk_buffer == 16'h0000)
        ps2_clk = 0;
    if (dat_buffer == 16'hffff)
        ps2_dat = 1;
    if (dat_buffer == 16'h0000)
        ps2_dat = 0;
end //always

always @ (negedge ps2_clk , posedge clr) begin
    if (clr) begin
        q[7] = 0;
    end else begin
        kb_count = kb_count + 1;
        case (kb_count)
            0: ; // start
            1: kb_dat[0] = ps2_dat;
            2: kb_dat[1] = ps2_dat;
            3: kb_dat[2] = ps2_dat;
            4: kb_dat[3] = ps2_dat;
            5: kb_dat[4] = ps2_dat;
            6: kb_dat[5] = ps2_dat;
            7: kb_dat[6] = ps2_dat;
            8: kb_dat[7] = ps2_dat;
            9: ; // XXX parity
            default: begin //stop
                kb_count = 4'hf; //get ready for next key
                if (kb_dat == 8'hf0) begin // F0
                    lift = 1; //lift
                end else if (kb_dat == 8'he0) begin
                    shift = 1;
                end else if (lift) begin
                    lift = 0; //lift (break) key
                    case (kb_dat)
                        8'h12: shift = 0; // Shift (Left)
                        8'h59: shift = 0; // Shift (Right)
                    endcase
                end else if (shift) begin // shiftted
                    case (kb_dat)
                        8'h16 : q = 8'ha1; // "!"
                        8'h1e : q = 8'hc0; // "@"
                        8'h26 : q = 8'ha3; // "#"
                        8'h24 : q = 8'ha4; // "$"
                        8'h2e : q = 8'ha5; // "%"
                        8'h36 : q = 8'hde; // "^"
                        8'h3d : q = 8'ha6; // "&"
                        8'h46 : q = 8'ha8; // "("
                        8'h45 : q = 8'ha9; // ")"
                        8'h3e : q = 8'haa; // "*"
                        8'h55 : q = 8'hab; // "+"
                        8'h41 : q = 8'hbc; // "<"
                        8'h49 : q = 8'hbe; // ">"
                        8'h4a : q = 8'hbf; // "?"
                        8'h4c : q = 8'hba; // ":"
                    endcase
                end else begin // unshifted
                    case (kb_dat)
                        8'h52: q = 8'ha7; // "'"
                        8'h55: q = 8'hbd; // "="
                        8'h4C: q = 8'hbb; // ";"
                        8'h41: q = 8'hac; // ","
                        8'h4E: q = 8'had; // "-"
                        8'h49: q = 8'hae; // "."
                        8'h4A: q = 8'haf; // "/"
                        8'h45: q = 8'hb0; // "0"
                        8'h16: q = 8'hb1; // "1"
                        8'h1e: q = 8'hb2; // "2"
                        8'h26: q = 8'hb3; // "3"
                        8'h25: q = 8'hb4; // "4"
                        8'h2E: q = 8'hb5; // "5"
                        8'h36: q = 8'hb6; // "6"
                        8'h3D: q = 8'hb7; // "7"
                        8'h3E: q = 8'hb8; // "8"
                        8'h46: q = 8'hb9; // "9"
                        8'h1C: q = 8'hc1; // "A"
                        8'h32: q = 8'hc2; // "B"
                        8'h21: q = 8'hc3; // "C"
                        8'h23: q = 8'hc4; // "D"
                        8'h24: q = 8'hc5; // "E"
                        8'h2B: q = 8'hc6; // "F"
                        8'h34: q = 8'hc7; // "G"
                        8'h33: q = 8'hc8; // "H"
                        8'h43: q = 8'hc9; // "I"
                        8'h3B: q = 8'hca; // "J"
                        8'h42: q = 8'hcb; // "K"
                        8'h4b: q = 8'hcc; // "L"
                        8'h3A: q = 8'hcd; // "M"
                        8'h31: q = 8'hce; // "N"
                        8'h44: q = 8'hcf; // "O"
                        8'h4D: q = 8'hd0; // "P"
                        8'h15: q = 8'hd1; // "Q"
                        8'h2D: q = 8'hd2; // "R"
                        8'h1B: q = 8'hd3; // "S"
                        8'h2C: q = 8'hd4; // "T"
                        8'h3C: q = 8'hd5; // "U"
                        8'h2A: q = 8'hd6; // "V"
                        8'h1D: q = 8'hd7; // "W"
                        8'h22: q = 8'hd8; // "X"
                        8'h35: q = 8'hd9; // "Y"
                        8'h1A: q = 8'hda; // "Z"
                        8'h29: q = 8'ha0; // Spacebar
                        //E06B: q = 8'h95; // Left Arrow
                        //E074: q = 8'h88; // Right Arrow
                        //8'h58: q = 8'h; // Caps Lock
                        //8'h14: q = 8'h; // Ctrl (left)
                        8'h5A: q = 8'h8d; // Enter
                        8'h76: q = 8'h9b; // ESC
                        8'h12: shift = 1; // Shift (Left)
                        8'h59: shift = 1; // Shift (Right)
                        //E014: q = 8'h; // Ctrl (right)
                        //E075: q = 8'h; // Up Arrow
                        //E072: q = 8'h; // Down Arrow
                    endcase
                end
            end
        endcase
    end
end //always
endmodule

