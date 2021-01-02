// -*- verilog -*-

module fsm(clk, reset, ai, bi, out, debugstate);
   input clk;
   input reset;
   input ai, bi;
   output out;
   output reg [1:0] debugstate;
   
   parameter SAME = 2'b00;
   parameter A_GREATER = 2'b01;
   parameter B_GREATER = 2'b10;
   
   reg [1:0]        state;
   reg [1:0]        next_state;
           
   // Next State Logic
   always @(*) begin
      if (reset) next_state = SAME;
      else begin
         case (state)
           SAME: next_state <= (ai == bi) ? SAME :
                               (bi >  ai) ? B_GREATER :
                               (ai >  bi) ? A_GREATER : 0;
         endcase 
         debugstate <= next_state;
      end
   end 
   
   always @(posedge clk) state <= next_state;
   
   // Output Logic
   assign out = (next_state == SAME)      ? ai :
                (next_state == A_GREATER) ? ai :
                (next_state == B_GREATER) ? bi : 0;

endmodule

