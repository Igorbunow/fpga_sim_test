#define OUTNAME "spi_master"
#define SIMM_CLASS Vspi_master

#include <stdlib.h>

#define VERILATOR5

#ifndef VERILATOR5
#include "./../simulation/obj_dir/Vspi_master.h"
#else
#include "./../obj_dir/Vspi_master.h"
#endif

#ifdef VM_TRACE
#include <verilated_vcd_c.h>
#endif

vluint64_t vtime = 0;
// Called by $time in Verilog
double sc_time_stamp()
{
	return (double)vtime;
}

int main(int argc, char **argv) {
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);

	// Create an instance of our module under test
	SIMM_CLASS *top_module = new SIMM_CLASS;

#ifdef VM_TRACE
	VerilatedVcdC* vcd = nullptr;
	const char* flag = Verilated::commandArgsPlusMatch("trace");
	if (flag && 0==strcmp(flag, "+trace"))
	{
		printf("VCD waveforms will be saved!\n");
		Verilated::traceEverOn(true);	// Verilator must compute traced signals
		vcd = new VerilatedVcdC;
		top_module->trace(vcd, 99);	// Trace 99 levels of hierarchy
		vcd->open(OUTNAME ".vcd");		// Open the dump file
	}
#endif
	// switch the clock
	int clock = 0;
	top_module->rst = 0;
	while( !Verilated::gotFinish() )
	{
		vtime+=1;
		if( vtime%8==0)
			clock ^= 1;
		if( vtime>45 && vtime<=49 )
			top_module->rst = 1;
		else
			top_module->rst = 0;
			
		if( vtime>55 && vtime<=61 )
			top_module->start = 1;
		else
			top_module->start = 0;
			
		if( vtime>500 && vtime<=505 )
			top_module->stop = 1;
		else
			top_module->stop = 0;
		
		top_module->clk = clock;
		top_module->eval();
#ifdef VM_TRACE
		if( vcd )
			vcd->dump( vtime );
#endif
		//printf("%d status:%d %02X\n", clock, top_module->state, top_module->cnt );
		if( vtime>600 )
			break;
	}
	top_module->final();
#ifdef VM_TRACE
	if( vcd )
		vcd->close();
#endif
	delete top_module;
	exit(EXIT_SUCCESS);
}

