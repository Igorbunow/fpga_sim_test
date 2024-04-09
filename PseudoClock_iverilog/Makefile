IVERILOG = iverilog
IVERILOG_FLAGS = -Wtimescale
VVP = vvp
VVP_FLAGS = -n
GTKWAVE = gtkwave
GTKWAVE_FLAGS  =

DIR_SUMULATION = iverilog/simulation
DIR_TESTBENCH = iverilog/testbench
DIR_LIB = ../lib

IVL_FILE  = $(DIR_SUMULATION)/$(PROJNAME).ivl
VCD_FILE  = $(DIR_SUMULATION)/$(PROJNAME).vcd
GTW_FILE  = $(wildcard $(DIR_TESTBENCH)/*.gtkw)



PROJNAME     = $(notdir $(PWD))

SOURCES     = $(wildcard *.v  $(DIR_TESTBENCH)/*.v $(DIR_LIB)/*.v) 


SHOW_WAVE: $(DIR_SUMULATION)  $(IVL_FILE)  $(VCD_FILE)  
	gtkwave $(DIR_SUMULATION)/$(PROJNAME).vcd $(GTW_FILE)

$(IVL_FILE): $(SOURCES)
	iverilog $(IVERILOG_FLAGS) $(SOURCES) -o $(IVL_FILE)
	
	
$(VCD_FILE): $(IVL_FILE)
	rm -rf $(wildcard *.vcd $(DIR_SUMULATION)/*.vcd) `find *.vcd`
	vvp $(VVP_FLAGS) $(IVL_FILE) 
	mv -f  `find *.vcd` $(VCD_FILE) 

$(DIR_SUMULATION):
	mkdir $(DIR_SUMULATION) 

clean:
	rm -rf $(DIR_SUMULATION)

build: $(DIR_SUMULATION)  $(IVL_FILE) $(VCD_FILE)
	

