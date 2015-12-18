module vga_display(rst, clk, R, G, B, HS, VS, R_control, G_control, B_control, up, down, left, right,seven , AN);
//  output reg[7:0] debug;
    //..................
    // Define your parameters, inputs, regs, etc
    //..................
	 
	 
    input rst;  // global reset
    input clk;  // 100MHz clk
   


	 //Seven Segment Controller
	 output [6:0] seven;
	 output [3:0] AN;
	 reg [15:0] score;
	SevenSegmentController sev (.clk(clk), .seven(seven) , .AN(AN), .big_bin(score) );
    
	 //

    // color inputs for a given pixel
    input [2:0] R_control, G_control;
    input [1:0] B_control;

    // color outputs to show on display (current pixel)
    output reg [2:0] R, G;
    output reg [1:0] B;

    // Synchronization signals
    output HS;
    output VS;


    /////////////////////////////////////////
    // State machine parameters
    parameter S_IDLE = 0;   // 0000 - no button pushed
    parameter S_LEFT = 4;   // 0100 - and so on
    parameter S_RIGHT = 8;  // 1000 - and so on
                                  //{right, left, down , up}
    reg [3:0] state, next_state;
    ////////////////////////////////////////

    input up, down, left, right;    // 1 bit inputs
    reg [10:0] x, y;                      //currentposition variables for the paddle
    reg slow_clk;                         // clock for position update,
                                             // if it's too fast, every push
                                             // of a button willmake your object fly away.

    initial begin                         // initial position of the box
        x = 400; y= 445;
		  score = 16'b0;
    end

    ////////////////////////////////////////////
    // slow clock for position update - optional

    reg [21:0] slow_count;
    initial slow_count = 0;
    always @ (posedge clk) begin
        slow_count = slow_count + 1'b1;
        slow_clk = slow_count[19];
    end
    /////////////////////////////////////////

    ///////////////////////////////////////////
    // State Machine
    initial next_state = 0;
    always @ (posedge slow_clk)begin
        state = next_state;
    end

    always @ (posedge slow_clk) begin
        case (state)
            S_IDLE: next_state = {right,left,down,up}; // if input is 0000
            S_LEFT: begin
               x = (x - 3'd5);
                next_state = {right,left,down,up};
            end
            S_RIGHT: begin
               x = (x + 3'd5);
                next_state = {right,left,down,up};
            end
            default: begin
                next_state = {right, left, down, up};
            end
        endcase
    end


    // controls:
    wire [10:0] hcount, vcount; // coordinates for the current pixel
    wire blank; // signal to indicate the current coordinate is blank
	 //reg start = 0;


	//////////////
	//Define edges
	//define left_side = 
    /////////////////////////////////////////////////////
    // Begin clock division
    parameter N = 2;    // parameter for clock division
    reg clk_25Mhz;
    reg [N-1:0] count;
    initial count = 0;

    always @ (posedge clk) begin
        count <= count + 1'b1;
        clk_25Mhz <= count[N-1];
    end
    // End clock division
    /////////////////////////////////////////////////////

    // ..............................
        // Call driver
    vga_controller_640_60 vc(
        .rst(rst),
        .pixel_clk(clk_25Mhz),
        .HS(HS),
        .VS(VS),
        .hcounter(hcount),
        .vcounter(vcount),
        .blank(blank));
		  
		  
	// game_over_mem youLose(.clka (clk_25Mhz), .addra(), .douta());
    // .........................................
    //Complete the figure description
    // create a box:
     

    reg slow_clk_for_ball;
    ////////////////////////////////////////////
    // slow clock for ball position update - optional
    initial slow_count_for_ball = 0;
    reg [25:0] slow_count_for_ball;
    always @ (posedge clk) begin
        slow_count_for_ball = slow_count_for_ball + 1'b1;
        slow_clk_for_ball = slow_count_for_ball[23];
    end
    /////////////////////////////////////////
    wire rightBound, leftBound, upperBound, paddle, ball;//use these to draw
	 //reg hCollide, vCollide;

    parameter rightSide = 11'd611;
	 parameter leftSide = 11'd23;
	 parameter topSide= 11'd175;
	 parameter paddleTop = 11'd434;

	 reg start, checked, hCollide, vCollide, lose, reset;//this will have to change to zero for reset
	 initial begin
		start = 1;
		checked = 0;
		hCollide = 0;
		vCollide = 0;
		lose = 0;
		reset = 0;
	 end
	 
    reg [9:0] x_ball, y_ball, pre_y, new_y, pre_x, new_x;
	
    initial begin
        pre_y = 200;
        new_y = 300;
		  pre_x = 300;  
		  new_x = 400;
        x_ball = 0; 
		  y_ball = 0;
    end

//v = height , h = width;
	
    assign rightBound = ~blank & ( vcount >=  0      &  vcount <=  500      &  hcount >= 620        &  hcount <=   640     );
    assign leftBound  = ~blank & ( vcount >=  0      &  vcount <=  500      &  hcount >= 0          &  hcount <=   20      );
    assign upperBound = ~blank & ( vcount >=  0      &  vcount <=  50       &  hcount >= 0          &  hcount <=   640     );


    wire collision;
    assign paddle     = ( vcount >= (0 + y) &  vcount <= (16 + y)  &  hcount >= (-80 + x)  &  hcount <=  (0 + x) );
    assign ball       = ( vcount >= (0 + y_ball)& vcount <= (5 + y_ball) &  hcount >= (0 + x_ball) &  hcount <= (5 + x_ball));
    assign collision  = ball & ( vcount >= (y-5) &  vcount <= (6 + y)  &  hcount >= (-75 + x)  &  hcount <=  (5 + x) );
	 
   parameter rightDown = 3'b000, leftDown= 3'b001, rightUp = 3'b010, leftUp = 3'b011, stop = 3'b100;
	 reg[2:0] ballNow;
	 reg[2:0] ballNext;

	always @ (posedge slow_clk_for_ball) begin
		begin: resetTest
			if(rst | reset) begin
				//x_ball <= 250;
				//y_ball <= 250;
				ballNow <= stop;
				start <= 1;
				lose <= 0;
			end
			else if (lose) begin
				reset <= 1;
				start <= 1;
			end
			else ballNow <= ballNext;
		end
		begin: ballBouncingLogic
			if(!checked & start) begin
				y_ball <= 200;
				x_ball <= 250;
				start <= 0;
			end
			else if (!start & !rst & !lose) begin
				case(ballNow)
					stop:
					begin
						x_ball <= x_ball;
						y_ball <= y_ball;
						lose <= 1;
					end
					rightDown:
					begin
						x_ball <= x_ball + 11'd2;
						y_ball <= y_ball + 11'd5;
					end
					rightUp:
					begin
						x_ball <= x_ball + 11'd2;
						y_ball <= y_ball - 11'd5;
					end
					leftDown:
					begin
						x_ball <= x_ball - 11'd2;
						y_ball <= y_ball + 11'd5;
					end
					leftUp:
					begin
						x_ball <= x_ball - 11'd2;
						y_ball <= y_ball - 11'd5;
					end
				endcase
			end
			
			
		end
	end
		/*begin: breakBricks
			if (!rst) begin
				vCollide <= 0;
				hCollide <= 0;
				checked <= 1;
			end
			else begin
				if (y_ball >= topSide) vCollide <= 1;
				else if (y_ball <= paddleTop & hCollide)  vCollide <= 1;
				else vCollide <= 0;
				
				if (x_ball <= rightSide) hCollide <=1;
				else if (x_ball >= leftSide) hCollide <= 1;
				else hCollide <= 0;
			end	
		end*/

	
	always @ (ballNow or x_ball or y_ball or vCollide or hCollide) begin
		case (ballNow)
			stop:
				begin
					if (start == 1) ballNext <= leftDown;
					else begin
						ballNext <= stop;
						score <= 0;
					end
				end
			rightDown:
			//((0 + y) <= (205 + y_ball)) &((200 + y_ball) <= (0 +y)) & ((300 + x_ball) >= (-80 + x)) & ((0 + x) >= (305 + x_ball))
				begin
					if (y_ball >= paddleTop & ((x_ball) >= (-80 + x)) & ((0 + x) >= (5 + x_ball))) ballNext <= rightUp;
					else if (x_ball >= rightSide) ballNext <= leftDown;
					else if (hCollide) ballNext <= rightUp;
					else if (vCollide) ballNext <= leftDown;
					else begin
						ballNext <= rightDown; //loses
						//lose <= 1;
					end
				end
			rightUp:
				begin
					if (y_ball <= topSide) begin
						ballNext <= rightDown;
						score <= score + 16'b0000000000100000;
					end
					else if (x_ball >= rightSide) ballNext <= leftUp;
					else if (hCollide) ballNext <= leftUp;
					else if (vCollide) begin
						ballNext <= rightDown;
						//score <= score + 16'd1;
					end
					else ballNext <= rightUp;
				end
			leftDown:
				begin		
					if (y_ball >= paddleTop & ((x_ball) >= (-80 + x)) & ((0 + x) >= (5 + x_ball))) ballNext <= leftUp;
					else if (x_ball <= leftSide) ballNext <= rightDown;
					else if (hCollide) ballNext <= rightDown;
					else if (vCollide) ballNext <= leftUp;
					else begin
						ballNext <= leftDown; //loses
						//lose <= 1;
					end
				end
			leftUp:
				begin				
					if (y_ball <= topSide) begin
						ballNext <= leftDown;
						score <= score + 16'b0000000000000001;
					end
					else if (x_ball <= leftSide) ballNext <= rightUp;
					else if (hCollide) ballNext <= rightUp;
					else if (vCollide) begin
						ballNext <= leftDown;
						//score <= score + 16'd1;
					end
					else ballNext <= leftUp;
				end
		endcase
	end	


	 /*************************************BRICK CENTRAL*******************/

		 
	 wire brick1  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 20           &  hcount <=   60       ); 
	 wire brick2  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 60           &  hcount <=   100       ); 
	 wire brick3  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 100          &  hcount <=   140      ); 
	 wire brick4  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 140          &  hcount <=   180      ); 
	 wire brick5  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 180          &  hcount <=   220       ); 
	 wire brick6  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 220          &  hcount <=   260       ); 
	 wire brick7  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 260          &  hcount <=   300       ); 
	 wire brick8  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 300          &  hcount <=   340       ); 
	 wire brick9  = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 340          &  hcount <=   380       );
    wire brick10 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 380          &  hcount <=   420       ); 	 
	 wire brick11 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 420          &  hcount <=   460       ); 
	 wire brick12 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 460          &  hcount <=   500       ); 
	 wire brick13 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 500          &  hcount <=   540       ); 
	 wire brick14 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 540          &  hcount <=   580       ); 
	 wire brick15 = ~blank & ( vcount >=  50      &  vcount <=  80       &  hcount >= 580          &  hcount <=   620       ); 
	 
	 
	 
	 
	 wire brick16 = ~blank & ( vcount >=  80      &  vcount <=  110       &  hcount >= 20           &  hcount <=   80        ); 
	 wire brick17 = ~blank & ( vcount >=  80      &  vcount <=  110       &  hcount >= 80           &  hcount <=   140       ); 
	 wire brick18 = ~blank & ( vcount >=  80      &  vcount <=  110       &  hcount >= 140          &  hcount <=   200       ); 
	 wire brick19 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 200          &  hcount <=   260       ); 
	 wire brick20 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 260          &  hcount <=   320       );
	 wire brick21 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 320          &  hcount <=   380       ); 	 
	 wire brick22 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 380          &  hcount <=   440       ); 
	 wire brick23 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 440          &  hcount <=   500       ); 
	 wire brick24 = ~blank & ( vcount >=  80      &  vcount <=  110      &  hcount >= 500          &  hcount <=   560      ); 
	 wire brick25 = ~blank & ( vcount >=  80      &  vcount <=  110       &  hcount >= 560          &  hcount <=   620       ); 
	                                      
	                                                                        
	 wire brick26 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 20           &  hcount <=   120       );
    wire brick27 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 120          &  hcount <=   220       );
	 wire brick28 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 220          &  hcount <=   320       );
	 wire brick29 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 320          &  hcount <=   420       );	 
	 wire brick30 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 420          &  hcount <=   520       );
	 wire brick31 = ~blank & ( vcount >=  110      &  vcount <=  140       &  hcount >= 520          &  hcount <=   620       );
	 
	 
	 wire brick32 = ~blank & ( vcount >=  140      &  vcount <=  170       &  hcount >= 20           &  hcount <=   140       );
	 wire brick33 = ~blank & ( vcount >=  140      &  vcount <=  170       &  hcount >= 140          &  hcount <=   260       );
	 wire brick34 = ~blank & ( vcount >=  140      &  vcount <=  170       &  hcount >= 260          &  hcount <=   380       );
	 wire brick35 = ~blank & ( vcount >=  140      &  vcount <=  170       &  hcount >= 380          &  hcount <=   500       );
	 wire brick36 = ~blank & ( vcount >=  140      &  vcount <=  170       &  hcount >= 500          &  hcount <=   620       );
	 
	 
	 /********************/
	 
	 



// send colors:
    always @ (posedge clk_25Mhz) begin
        if (ball) begin  // if you are outside the valid region
            R <= 3'b111;
            G <= 3'b000;
            B <= 2'b01;
        end
        else if (paddle) begin  // if you are within the valid region
            R <= R_control;
            G <= G_control;
            B <= B_control;
				if (ball) begin
					R <= ~R_control;
					G <= ~G_control;
					B <= ~B_control;
				end
				
        end
        else if (rightBound) begin  // if you are outside the valid region
            R <= R_control;
            G <= G_control;
            B <= B_control;
        end
        else if (leftBound) begin   // if you are outside the valid region
            R <= R_control;
            G <= G_control;
            B <= B_control;
        end
        else if (upperBound) begin  // if you are outside the valid region
            R <= R_control;
            G <= G_control;
            B <= B_control;
        end
		  
		  else if (brick1) begin
				R <= 3'b000 ;
				G <= 3'b000 ;
				B <= 2'b11 ;
		  end
		
		  else if(brick2) begin 
			   R <= 3'b000 ;
				G <= 3'b110 ;
				B <= 2'b00 ;
		  end
		  else if (brick3) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick4) begin
			   R <= 3'b010 ;
				G <= 3'b000 ;
				B <= 2'b11 ; 
		  end
		  else if (brick5) begin
				R <= 3'b110 ;
				G <= 3'b100 ;
				B <= 2'b00 ;
		  end
		
		  else if(brick6) begin 
			   R <= 3'b111 ;
				G <= 3'b010 ;
				B <= 2'b10 ;
		  end
		  else if (brick7) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick8) begin
			   R <= 3'b001 ;
				G <= 3'b110 ;
				B <= 2'b10 ; 
		  end
		  else if (brick9) begin
				R <= 3'b000 ;
				G <= 3'b000 ;
				B <= 2'b11 ;
		  end
		
		  else if(brick10) begin 
			   R <= 3'b000 ;
				G <= 3'b110 ;
				B <= 2'b00 ;
		  end
		  else if (brick11) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick12) begin
			   R <= 3'b010 ;
				G <= 3'b000 ;
				B <= 2'b11 ; 
		  end
		  else if (brick13) begin
				R <= 3'b110 ;
				G <= 3'b100 ;
				B <= 2'b00 ;
		  end
		
		  else if(brick14) begin 
			   R <= 3'b111 ;
				G <= 3'b010 ;
				B <= 2'b10 ;
		  end
		  else if (brick15) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick16) begin
			   R <= 3'b001 ;
				G <= 3'b110 ;
				B <= 2'b10 ; 
		  end
		  else if (brick17) begin
				R <= 3'b000 ;
				G <= 3'b000 ;
				B <= 2'b11 ;
		  end
		
		  else if(brick18) begin 
			   R <= 3'b000 ;
				G <= 3'b110 ;
				B <= 2'b00 ;
		  end
		  else if (brick19) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick20) begin
			   R <= 3'b010 ;
				G <= 3'b000 ;
				B <= 2'b11 ; 
		  end
		  else if (brick21) begin
				R <= 3'b110 ;
				G <= 3'b100 ;
				B <= 2'b00 ;
		  end
		
		  else if(brick22) begin 
			   R <= 3'b111 ;
				G <= 3'b010 ;
				B <= 2'b10 ;
		  end
		  else if (brick23) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick24) begin
			   R <= 3'b001 ;
				G <= 3'b110 ;
				B <= 2'b10 ; 
		  end
		
		  else if (brick25) begin
				R <= 3'b000 ;
				G <= 3'b000 ;
				B <= 2'b11 ;
		  end
		
		  else if(brick26) begin 
			   R <= 3'b000 ;
				G <= 3'b110 ;
				B <= 2'b00 ;
		  end
		  else if (brick27) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick28) begin
			   R <= 3'b010 ;
				G <= 3'b000 ;
				B <= 2'b11 ; 
		  end
		  else if (brick29) begin
				R <= 3'b110 ;
				G <= 3'b100 ;
				B <= 2'b00 ;
		  end
		
		  else if(brick30) begin 
			   R <= 3'b111 ;
				G <= 3'b010 ;
				B <= 2'b10 ;
		  end
		  else if (brick31) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick32) begin
				if (ball) begin
					R <= 3'b000;
					G <= 3'b000 ;
					B <= 2'b00 ;
				end
				else begin
					R <= 3'b001 ;
				   G <= 3'b110 ;
				   B <= 2'b10 ; 
				end
		  end
		
		 else if (brick33) begin
				R <= 3'b000 ;
				G <= 3'b000 ;
				B <= 2'b11 ;
		  end
		
		  else if(brick34) begin 
			   R <= 3'b000 ;
				G <= 3'b110 ;
				B <= 2'b00 ;
		  end
		  else if (brick35) begin
				R <= 3'b111 ;
		      G <= 3'b000 ;
		      B <= 2'b00 ; 
		  end
		  else if (brick36) begin
			   R <= 3'b010 ;
				G <= 3'b000 ;
				B <= 2'b11 ; 
		  end
		  else begin
            R <= 0;
            G <= 0;
            B <= 0;
		  end
		    
		
	
      end

 

endmodule