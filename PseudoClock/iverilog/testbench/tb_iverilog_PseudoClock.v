`timescale 1ns / 1ps


module tb_iverilog_PseudoClock(
    );



   parameter C_REG_DLEN = 8;
   parameter C_REG_ALEN = 3;
   
   localparam C_SLV_DWIDTH = 32;

   
   // Clock period definitions
   parameter clk_period = 10;


    //Inputs
   reg clk = 0;
   reg sysRst = 0;
   //reg [31:0] Bus2IP_Data = 32'b0000_0000_1111_0000_0000_0000_0000_0000;
   reg enable;
   



    // inputs
    reg         Rst;

   
    // outputs

   

    reg op_start;

  

  reg 	emuRst;
   

  initial begin
     $dumpfile("tb_iverilog_PseudoClock.vcd");
     $dumpvars(0,tb_iverilog_PseudoClock);


    Rst = 1;

     
     
     

     //writes to ip regs

     op_start = 1;
     mrestartCnt = -1;
     
   
//     regAddr = 3;
//     regData <= 8'b10101011;
  
     # 0 sysRst = 1; //Bus2IP_RegWrCE = 0;
     #0 Rst = 1;
     #0 enable = 1;     
     #20 sysRst = 0;
//     # 20 Bus2IP_RegWrCE = 1; Bus2IP_Data = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
//     # 40 Bus2IP_RegWrCE = 0; Bus2IP_Data = 32'b0000_0000_0000_0000_0000_0000_0000_0000;     

     #10 Rst = 0; emuRst = 1;




     #20  Rst = 0;

     #200 emuRst = 0;

    




     #350000 $stop;
  end


  always #clk_period clk = !clk;






   

//-------------------------------------------------------------------------
wire 		  w1;
reg 		  r1;
 
always @(op_start_clear or mrestartCnt) begin
   r1 <= 1;
   assign r1 = 1;
   
end   
 

//-------------------------------------------------------------------------

   
wire op_start_clear;
reg signed [31:0] mrestartCnt;
   
   
always @(posedge sysClk) begin
   if(op_start_clear) 
     begin
	op_start <= 0;
	mrestartCnt = 3;     
     end
   else
     begin
	if(mrestartCnt > -1)
	  begin
	     mrestartCnt <= mrestartCnt - 1;	
	     if (mrestartCnt == 0 )
	       begin
		  op_start <= 1;		  
	       end
	  end
     end
end   
   



// Instantiate the Unit Under Test (UUT)
   wire gatedPseudoClock;
   wire rEdgePulse;   
   wire fEdgePulse;
   wire postREdgePulse;   
   wire postFEdgePulse;  


  

   assign regLen = 8;
   defparam is1Regs.C_CLK_HDIV_LEN = 32;
   defparam is1Regs.C_CLK_HDIV_N = 3;
   PseudoClock is1Regs(
		     sysClk,
		     sysRst, 		     

		     //
		     gatedPseudoClock,
		     rEdgePulse,   
		     fEdgePulse,
		     postREdgePulse,
		     postFEdgePulse		       
		     );

//-------------------------------------------------------------------------










   

   assign sysClk  = clk;
 
   


   wire emuClk;
   assign emuClk = emulated_clk; //TODO: !!!!!! pass it trhoght BUFG
   
//-------------------------------------------------------------------------
   reg emulated_clk;
   reg [7:0] emulated_clk_div_cnt;
   reg [7:0] emulated_clk_cnt;
   reg      emulatedY;
  
   
   
   always @(posedge sysClk) begin
      emulatedY <= 1;
      
      if (sysRst) begin
	 emulated_clk_div_cnt <= 0;
	 emulated_clk <= 0;
	 emulatedY <= 0;
	 emulated_clk_cnt <= 0;	 
      end
      else
      begin
	 emulated_clk_div_cnt <= emulated_clk_div_cnt + 1;	 
	 if(emulated_clk_div_cnt >= 3) begin
	    emulated_clk_cnt <= emulated_clk_cnt + 1;
	    //emulatedY <= emulated_clk_cnt[3] ^  emulated_clk_cnt[2] ^ emulated_clk_cnt[1] ^ emulated_clk_cnt[0];  
	    emulated_clk_div_cnt <= 0;	    
	    emulated_clk = !emulated_clk;	    
	 end   
      end
   end
//---------------------------------------------------------------------



   // Stimulus process
   //always
   //begin		
      // hold reset state for 100.
      //wait(100);	

	//		Bus2IP_RegWrCE	= 0;	
	//		IP2Bus_WrAck = 0;
  	//		Bus2IP_Data = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
			
      //wait(clk_period*10);
      // insert stimulus here
			
	//		Bus2IP_RegWrCE	= 1;	
	//		IP2Bus_WrAck = 1;
	//		Bus2IP_Data = 32'b0100_0000_0000_0000_0000_0000_0000_0000;
		//wait(100);	
	//		Bus2IP_RegWrCE	= 0;
	//		IP2Bus_WrAck = 0;
	//		Bus2IP_Data = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
			
      //wait;
   //end
  

endmodule
