// -*- verilog -*-
`timescale 1 ns/ 10 ps

module fsm_tb;
   reg reset, ai, bi;
   wire [1:0] debugstate;
   wire out;
   reg clk;

   localparam period = 20;
   
   fsm UUT (.clk(clk), .reset(reset), .ai(ai), .bi(bi), .out(out), .debugstate(debugstate));
   
   always begin
      clk = 1'b1; 
      #(period/2);
      clk = 1'b0;
      #(period/2); 
   end
   
   task show(i);      
      $display("%2d |  %b    | %b  | %b  |  %b  |  %b%b ", i, reset, ai, bi, out, debugstate[0], debugstate[1]);
   endtask // show

   task err_out(i);
      $display("%2d |  %b    | %b  | %b  | (%b) |  %b%b ", i, reset, ai, bi, out, debugstate[0], debugstate[1]);
   endtask // show

   task done; $display("--- done ---"); endtask
   
   task step(i, a, b);
      begin
         reset = 0;
         ai <= a;
         bi <= b;
         #period;
         show(i);
      end      
   endtask // step
   
   task check([8:0] xs, [8:0] ys); 
      integer i;
      begin
         $display("   |=======+====+====+=====|");
         reset = 0; #period; // show(0);
         reset = 1; #period; // show(0);
         //$display("|-------+----+----+-----|");
         for(i = 8; i >= 0; i -= 1)
           begin
              step(i, xs[i], ys[i]);
              if (xs > ys && out != xs[i]) err_out(i);
              else if (xs < ys && out != ys[i]) err_out(i);
           end
         #period; show(0);
      end      
                  
   endtask // check
   
   
   initial begin      
      $dumpfile("test.vcd");
      $dumpvars(0, reset, ai, bi, out, clk, debugstate);
      $display(" i | reset | ai | bi | out |");

      // check(5'b11111, 5'b11111);
      // check(5'b00000, 5'b00000);
      // check(5'b11111, 5'b11111);
      check(8'b00111, 8'b11111);
      check(8'b11111, 8'b00111);
      check(8'b10110101, 8'b10110111);

      
      
      $stop;
   end // initial begin   
endmodule



