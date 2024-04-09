`timescale 1ns / 1ps

module tb_spi_master(

	input	wire	clk,
	input	wire	rst,
	input	wire	start,
	input	wire	stop,
	output	wire	start_status,
	output	wire	start_clear
    );

  
  state_control_bus		state_control_bus_tb();
  
assign		state_control_bus_tb.clk	=	clk;
assign		state_control_bus_tb.rst	=	rst;
assign		state_control_bus_tb.start	=	start;
assign		state_control_bus_tb.stop	=	stop;
assign		start_status	=	state_control_bus_tb.start_status;
assign		start_clear		=	state_control_bus_tb.start_clear;


	 spi_master spi_master_i(
		.state_control_bus_e(state_control_bus_tb) 
	 );
	

endmodule

/*
module tb_spi_master(
    );

  // Clock period definitions
  parameter clk_period = 10;

  //Inputs
  reg clk = 0;
  reg rst = 0;
  reg start = 0;
  reg stop = 0;
	
  //Output
  wire start_status;
  wire start_clear;

  initial begin
     $dumpfile("tb_spec_auto_1_1.vcd");
     $dumpvars(0,tb_spec_auto_1_1);   
	  
     # 0 rst = 0; 
	 # 10 rst = 1;
	 # 20 rst = 0; 
	 	 
	 # 20 start = 1;
	 # 20 start = 0;
	 
	 # 160 stop = 1;
	 # 20 stop = 0;
	  
     # 1000 $stop;
	 end
	 
	 always #clk_period clk = !clk;
	 
	 //always #clk_period start = !start;
	 
	 spi_master spi_master_i(
		  clk,			//sys clock
		  rst,			//sys reset
		  start,		//start pulse
		  stop, 		//stop pulse
		  start_status,	//start status 1-started, 0-stopped
		  start_clear	//one pulse appear if automat stopped 
	 );
	  

endmodule
*/
