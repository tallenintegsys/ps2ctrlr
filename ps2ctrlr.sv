`timescale 10ns/10ps
module ps2ctrlr (
    input	CLOCK_50,
	input	strobe;
    output  logic [7:0]q;
	output	logic [17:0]LEDR,
	output	logic [8:0]LEDG,
    input   PS2_DAT,
    input   PS2_CLK);

logic [16-1:0] dat_buffer;
logic [16-1:0] clk_buffer;
logic [3:0] buffer_count;
logic ps2_clk, ps2_dat;
logic [3:0]kb_count;
logic [15:0]kb_dat;

initial begin
    dat_buffer = 16'd0;
    clk_buffer = 16'd0;
    buffer_count = 4'd0;
    ps2_clk = 0;
    ps2_dat = 0;
    kb_count = 4'hf;
    kb_dat = 8'd0;
end

assign	LEDR[15:0] = clk_buffer;
assign 	LEDG[7:0] = kb_dat;

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

always @ (negedge ps2_clk, negedge KEY[1]) begin
    if (KEY[1] == 0) begin
		kb_count = 4'hf;
        kb_dat = 0;
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
            default: kb_count = 4'hf; // stop
        endcase
	end //if else
end //always

endmodule

