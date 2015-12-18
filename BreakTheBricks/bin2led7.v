//////////////////////////////////////////////////////////////////////////////////
// Company: 		Boston University
// Engineer:		Zafar Takhirov
// 
// Create Date:		11/18/2015
// Design Name: 	EC311 Support Files
// Module Name:    	binary_to_segment
// Project Name: 	Lab4 / Project
// Description:
//					This module receives a 4-bit input and converts it to 7-segment
//					LED (HEX)
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: INCOMPLETE CODE
//
//////////////////////////////////////////////////////////////////////////////////

module binary_to_segment(bin ,seven/*, clk*/);	
input [3:0] bin;
//input clk;
output reg [6:0] seven; //Assume MSB is A, and LSB is G	

initial	//Initial block, used for correct simulations	
	seven=0;

always @ (*)
	case(bin)	 // "a b c d e f g dp" 
		0:  seven =  7'b0000001; //0
		1:  seven =  7'b1001111; //1
		2:  seven =  7'b0010010; //2
		3:  seven =  7'b0000110; //3
		4:  seven =  7'b1001100; //4
		5:  seven =  7'b0100100; //5
		6:  seven =  7'b0100000; //6
		7:  seven =  7'b0001111; //7
		8:  seven =  7'b0000000; //8
		9:  seven =  7'b0001100; //9
		10: seven =  7'b0001000; //A
		11: seven =  7'b0000000; //B
		12: seven =  7'b0110001; //C
		13: seven =  7'b0000001; //D
		14: seven =  7'b0110000; //E 
		15: seven =  7'b0111000; // This will show F	
		//remember 0 means "light-up"
		default: //Something here
			seven = 7'b1111110;
	endcase
endmodule	