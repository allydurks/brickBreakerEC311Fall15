`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:30:02 12/07/2015 
// Design Name: 
// Module Name:    SevenSegmentController 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SevenSegmentController(clk, seven , AN, big_bin);
   input [15:0] big_bin;
	input clk;
	output [6:0] seven;
	output [3:0] AN;
	
	//initial 
	//big_bin = 16'b0000010011000011;
	
	
	wire clko;
	clock_divider_4 divider(.clk_out(clko), .clk_in(clk));
	
	wire [3:0] small_bin;
	
	seven_alternate  SA   (.big_bin(big_bin) , .small_bin(small_bin) , .AN(AN), .clk(clko));
	
	binary_to_segment B2S  (.bin(small_bin)   , .seven(seven)/*         ,          .clk(clk)*/);

	
	

endmodule
