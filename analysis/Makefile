WORK = work
VIVADO = LM_LICENSE_FILE=2100@license /opt/Xilinx/Vivado/2014.4/bin/vivado

all: $(WORK)/synth.log

$(WORK)/synth.log: synth.tcl qam_mod.v clk.xdc
	mkdir -p $(WORK)
	$(VIVADO) -log $@ -m64 -mode batch -messageDb $(WORK)/vivado.pb -source $< -nojournal -tempDir $(WORK)
