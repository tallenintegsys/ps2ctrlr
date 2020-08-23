ALTERA=$(HOME)/altera/13.1/quartus/bin/
INTEL=$(HOME)/intelFPGA_lite/20.1/quartus/bin/
MAP=$(INTEL)quartus_map
FIT=$(INTEL)quartus_fit
ASM=$(INTEL)quartus_asm
STA=$(INTEL)quartus_sta
EDA=$(INTEL)quartus_eda
PGM=$(ALTERA)quartus_pgm
VFLAGS= -Wall -g2012

all: sim

xlat:

.PHONY: syn sim pgm clean distclean run
syn:
	$(MAP) --read_settings_files=on --write_settings_files=off ps2ctrlr -c ps2ctrlr
	$(FIT) --read_settings_files=off --write_settings_files=off ps2ctrlr -c ps2ctrlr
	$(ASM) --read_settings_files=off --write_settings_files=off ps2ctrlr -c ps2ctrlr
#	$(STA) ps2ctrlr -c ps2ctrlr
	$(EDA) --read_settings_files=off --write_settings_files=off ps2ctrlr -c ps2ctrlr

sim:
	iverilog $(VFLAGS)  ps2ctrlr_tb.sv ps2ctrlr.sv
	./a.out

pgm:
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/ps2ctrlr.sof'

run: syn pgm


clean:
	rm *.vcd a.out

distclean:
	rm -rf *.vcd a.out db incremental_db output_files simulation
