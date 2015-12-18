//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	seven_alternate
// Project Name: 	Lab4 / Project
// Description: 	This module takes a 16-bit binary and releases it in chunks of
//					4-bits (nibbles) while synchronizing them with the AN signal.
//					This file is to be used with 7-segment LED 4-displays
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module seven_alternate (big_bin, small_bin, AN, clk);	
	input[15:0] big_bin;		// This receives a huge 16 bit number
	output reg [3:0] small_bin;	// And returns one 4-bit number at a time (this goes into bin2bcd7)
	output reg [3:0] AN;		// While synchronizing it with the Anode signal
	input clk;  				// 1kHz clk	

	reg [1:0] count;  			// we need to iterate through the displays	

	initial begin // Initial block, used for correct simulations	
		AN = 0;
		small_bin = 0;	
		count= 0;
	end	
 
	always @ (posedge clk) begin	
		count= count+ 1'b1;
		case (count)	
			0: begin
				AN = 4'b1110;	
				small_bin = big_bin[3:0];
			end	
			1: begin
				AN = 4'b1101;	
				small_bin = big_bin[7:4];
			end	
			2: begin
				AN = 4'b1011;
				small_bin = big_bin[11:8];
			end
			3: begin
				AN = 4'b0111;
				small_bin = big_bin[15:12];
			end
			default:
				begin
				AN = 4'b0000;
				small_bin = 4'b0000;
			end
		endcase	
	end
endmodule	
