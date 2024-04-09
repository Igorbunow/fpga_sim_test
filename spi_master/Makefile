# https://github.com/Igorbunow
# Autor igor@gorbunov.tel

IVERILOG = iverilog
IVERILOG_FLAGS = -Wtimescale -g2012
VERILATOR = verilator
VERILATOR_FLAGS = -Wall --trace -cc  +1800-2017ext+v  --build --build-jobs $(shell nproc)
VERILATOR_FLAGS5 = --cc +1800-2017ext+v --trace --exe --build
VERILATOR_OBJDIR = obj_dir
VERILATOR_INCLUDE = /usr/share/verilator/include
VVP = vvp
VVP_FLAGS = -n
GTKWAVE = gtkwave
GTKWAVE_FLAGS  =

#DIR_TOOL = iverilog
DIR_TOOL = verilator
DIR_SUMULATION = $(DIR_TOOL)/simulation
DIR_TESTBENCH  = $(DIR_TOOL)/testbench
DIR_LIB = ../lib

IVL_FILE  = $(DIR_SUMULATION)/$(PROJNAME).ivl
VCD_FILE  = $(DIR_SUMULATION)/$(PROJNAME).vcd
GTW_FILE  = $(wildcard $(DIR_TESTBENCH)/*.gtkw)



PROJNAME     = $(notdir $(PWD))

SOURCES_VERILOG  = $(wildcard *.v  $(DIR_TESTBENCH)/*.v $(DIR_LIB)/*.v) 

SOURCES_CPP = $(DIR_TESTBENCH)/*.cpp

all:
	@echo "Please, use follow commands:"
	@echo "build  - build in verilator 4"
	@echo "build5 - build in verilator 5"
	@echo "wave   - build and show wave in verilator 4"
	@echo "wave5  - build and show wave in verilator 5"

build: clean $(DIR_SUMULATION) 
	$(VERILATOR) $(VERILATOR_FLAGS) $(SOURCES_VERILOG)
	mkdir $(DIR_SUMULATION)/$(VERILATOR_OBJDIR)
	mv -f $(VERILATOR_OBJDIR) $(DIR_SUMULATION)
	cd $(DIR_SUMULATION)/$(VERILATOR_OBJDIR) && make -f V$(PROJNAME).mk
	g++ -o $(DIR_SUMULATION)/$(PROJNAME) -DVM_TRACE -I$(VERILATOR_INCLUDE) $(SOURCES_CPP) $(VERILATOR_INCLUDE)/verilated.cpp $(VERILATOR_INCLUDE)/verilated_vcd_c.cpp $(DIR_SUMULATION)/$(VERILATOR_OBJDIR)/V$(PROJNAME)__ALL.a
	$(DIR_SUMULATION)/$(PROJNAME) +trace
	mv -f $(PROJNAME).vcd ./$(DIR_SUMULATION)

build5: clean $(DIR_SUMULATION)
	echo ${VERILATOR_FLAGS}
	$(VERILATOR) $(VERILATOR_FLAGS5) -j $(SOURCES_VERILOG) $(SOURCES_CPP)
	mv -f $(VERILATOR_OBJDIR) $(DIR_SUMULATION)
	mv -f $(DIR_SUMULATION)/$(VERILATOR_OBJDIR)/V$(PROJNAME) $(DIR_SUMULATION)/$(PROJNAME)
	$(DIR_SUMULATION)/$(PROJNAME) +trace
	mv -f $(PROJNAME).vcd ./$(DIR_SUMULATION)


wave: build
	$(GTKWAVE) $(DIR_SUMULATION)/$(PROJNAME).vcd $(GTW_FILE)

wave5: build5
	$(GTKWAVE) $(DIR_SUMULATION)/$(PROJNAME).vcd $(GTW_FILE)



SHOW_WAVE: $(DIR_SUMULATION)  $(IVL_FILE)  $(VCD_FILE)  
	$(GTKWAVE) $(DIR_SUMULATION)/$(PROJNAME).vcd $(GTW_FILE)

$(IVL_FILE): $(SOURCES_VERILOG)
	iverilog $(IVERILOG_FLAGS) $(SOURCES_VERILOG) -o $(IVL_FILE)
	
	
$(VCD_FILE): $(IVL_FILE)
	rm -rf $(wildcard *.vcd $(DIR_SUMULATION)/*.vcd) `find *.vcd`
	vvp $(VVP_FLAGS) $(IVL_FILE) 
	mv -f  `find *.vcd` $(VCD_FILE) 

$(DIR_SUMULATION):
	mkdir $(DIR_SUMULATION) 

clean:
	rm -rf $(DIR_SUMULATION)
	rm -rf $(VERILATOR_OBJDIR)

#build: $(DIR_SUMULATION)  $(IVL_FILE) $(VCD_FILE)
	

