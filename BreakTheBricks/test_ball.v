`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:15:32 12/09/2015
// Design Name:   vga_display
// Module Name:   X:/My Documents/EC311/BreakTheBricks/BreakTheBricks/test_ball.v
// Project Name:  BreakTheBricks
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga_display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ball;

	// Inputs
	reg rst;
	reg clk;
	reg [2:0] R_control;
	reg [2:0] G_control;
	reg [1:0] B_control;
	reg up;
	reg down;
	reg left;
	reg right;

	// Outputs
	wire [2:0] R;
	wire [2:0] G;
	wire [1:0] B;
	wire HS;
	wire VS;

	// Instantiate the Unit Under Test (UUT)
	vga_display uut (
		.rst(rst), 
		.clk(clk), 
		.R(R), 
		.G(G), 
		.B(B), 
		.HS(HS), 
		.VS(VS), 
		.R_control(R_control), 
		.G_control(G_control), 
		.B_control(B_control), 
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		R_control = 0;
		G_control = 0;
		B_control = 0;
		up = 0;
		down = 0;
		left = 0;
		right = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always #1 clk = ~clk;
	
	always #20 down = ~down;
      
endmodule

