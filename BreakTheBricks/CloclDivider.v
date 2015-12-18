module clock_divider_4 (clk_out, clk_in);
   parameter COUNTER_DIV = 10;
   
   input clk_in;
   output clk_out;

   reg [COUNTER_DIV-1:0] counter;

   initial begin
      counter = 0;
      // clk_out = 0;
   end

   always @ (posedge clk_in) begin
      counter = counter + 1'b1;
   end

   assign clk_out = (counter == 0) ? ~clk_out : clk_out;

endmodule // clock_divider_4