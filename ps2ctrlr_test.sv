`timescale 10ns/10ps
module ps2ctrlr_test (
    input   CLOCK_50,
    output  [8:0] LEDG,
    input   [3:0] KEY,
    input   PS2_DAT,
    input   PS2_CLK);

assign  LEDG[8] = !KEY[1];

ps2ctrlr ps2ctrlr(
    .CLOCK_50,
    .q (LEDG[7:0]),
    .clr (!KEY[1]),
    .PS2_DAT,
    .PS2_CLK);


endmodule
