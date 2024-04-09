`timescale 1ns / 1ps

/* verilator lint_off DECLFILENAME */

//run_type_automat = 1
//stop_type_automat = 1

interface state_control_bus ();
	logic		clk;			//system clock
	logic		rst;			//sys reset
	logic		start;			//start pulse
	logic		stop;			//stop pulse
	logic		start_status;	//start status 1-started, 0-stopped
	logic		start_clear;	//one pulse appear if automat stopped

// flash_qspi from module
modport ext (
	input		clk,
	input		rst,
	input		start,
	input		stop,
	output		start_status,
	output		start_clear
);

endinterface


module spi_master(
		
		state_control_bus.ext	state_control_bus_e
		 
	 );

   
reg [1:0] state;
   
 
   localparam _IDLE_ = 2'd0;        //default state
   localparam _RUN_ = 2'd1;			//run state
	 	 
   localparam C_CNT = 5;
   //localparam C_CNT_STOP = 1;
   
   reg [2:0] 		cnt ;
   reg 				run_flag;
   reg				clear_pulse;
   reg 				run_status;
   
   
   assign state_control_bus_e.start_clear = clear_pulse;
   assign state_control_bus_e.start_status = run_status;
   
   
   
   always @(posedge state_control_bus_e.clk) begin
				if (state_control_bus_e.start == 1) begin
					run_flag <= 1;
				end
				if (state_control_bus_e.stop == 1) begin
					run_flag <= 0; 
				end
   end
 
	 always @(posedge state_control_bus_e.clk) begin
		if (state_control_bus_e.rst) begin
			cnt <= 0;
			state <= _IDLE_;
			run_status <= 0;
			clear_pulse <= 0;
		end
		else 
			begin 
				
				case (state)	
	     
				_IDLE_:
						begin
							
							cnt <= 0;
						
							if (run_flag == 1) begin
									state <= _RUN_;
									run_status <= 1;
							end else
							begin
								run_status <= 0;
								clear_pulse <=0;
							end
							
						end
	 
				_RUN_:
						begin
							if (cnt > C_CNT-1) begin
								state <= _IDLE_;
								if (run_flag==0) clear_pulse <= 1;
							end else
								begin				
									cnt <= cnt + 1;
								end
							
						end
						
						
				default:
						begin	     
							state <= _IDLE_;
						end
	     
				endcase	
		  
		end
	end
	 
endmodule

