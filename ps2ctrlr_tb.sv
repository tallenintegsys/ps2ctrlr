`timescale 10ns/10ps
module ps2ctrlr_tb;
    // Input Ports
    reg     CLOCK_50;
    reg     [3:0]KEY;
    reg     PS2_CLK;
    reg     PS2_DAT;

    // Output Ports
    wire    [17:0]LEDR;
    wire    [8:0]LEDG;
    wire    [7:0]LCD_DATA;

initial begin
    $dumpfile("ps2ctrlr.vcd");
    $dumpvars(0, uut);
    //$dumpoff;
    #0
    CLOCK_50 = 0;
    KEY[0] = 1;
    KEY[1] = 1;
    KEY[2] = 1;
    KEY[3] = 1;
    PS2_CLK <= 0;
    #50
    PS2_CLK <= 1;
    #50
    PS2_CLK <= 0;
    #50
    PS2_CLK <= 1;
    #50
    PS2_CLK <= 0;
    #50
    PS2_CLK <= 1;
    #50
    PS2_CLK <= 0;
    #50
    PS2_CLK <= 1;
    //#500000
    // $dumpon;
    $finish;
end

always begin
    #1
    CLOCK_50 = !CLOCK_50;
end

ps2ctrlr uut (
    .CLOCK_50,
    .KEY,
    .LEDR,
    .LEDG,
    .PS2_DAT,
    .PS2_CLK);

endmodule
