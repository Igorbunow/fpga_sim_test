`timescale 1ns / 1ps



//IS1C5Regs

module PseudoClock(
   clk,               // functional and interface clock 
   rst,           // reset, must be clk synchronous  
		 

   //
   gatedPseudoClock, // Gated clock.
		     //  DO NOT USE DIRECTLY FOR CLOCKING always @(pos/negedge ..)
   rEdgePulse,   
   fEdgePulse,

   postREdgePulse,
   postFEdgePulse


);

parameter C_CLK_HDIV_N = 3;// halve of divider value (must be>0, due to emulate falling edge)
parameter C_CLK_HDIV_LEN = 32;

   


input clk;   
input rst;



output gatedPseudoClock;
output rEdgePulse;   
output fEdgePulse;
output postREdgePulse; 
output postFEdgePulse;      

assign gatedPseudoClock = gatedClkDelayed;
   

//--------------------------------------------------------------
// pseudo clock
////wire gatedClk;   
////assign gatedClk = clk;


reg gatedClk;   
reg [C_CLK_HDIV_LEN - 1:0] scDivCnt;
  
always @(posedge clk) begin
   if(rst)begin
      scDivCnt <= 0;
      gatedClk <= 0;      
   end
   else begin
      if (C_CLK_HDIV_N > 0) begin
	 if(scDivCnt >= C_CLK_HDIV_N-1) begin
	    scDivCnt <= 0;
	    gatedClk <= ~gatedClk;	 
	 end
	 else begin
	    scDivCnt <= scDivCnt + 1;
	 end
      end
	 
   end     
end
       
reg gatedClkDelayed;   

always @(posedge clk) begin
   if(rst)begin
      gatedClkDelayed <= 0;      
   end
   else begin
      gatedClkDelayed <= gatedClk; 
   end
end 


// rEdgePulse,fEdgePulse - modifier signals marking rising and falling edge of
//    delayesd clock gatedClkDelayed, so namely gatedClkDelayed is used as
//    pseudoclock for clocking at rate of clk divided
//    at 2*C_CLK_HDIV_N
   
wire rEdgePulse;   
assign rEdgePulse = (C_CLK_HDIV_N > 0)?(gatedClk & (!gatedClkDelayed)):1;

wire fEdgePulse;   
assign fEdgePulse = (C_CLK_HDIV_N > 0)?((!gatedClk) & gatedClkDelayed):1;


wire gatedClkOut;
assign gatedClkOut = (C_CLK_HDIV_N > 0)?gatedClkDelayed:clk;
   



//----------------------------------------------------------
reg postREdgePulse; 
reg postFEdgePulse;
     

always @(posedge clk) begin
   /*if(rst)begin
      gatedClkDelayed <= 0;     
   end
   else */begin 
      postREdgePulse <= rEdgePulse; 
      postFEdgePulse <= fEdgePulse;
   end
end 


endmodule

