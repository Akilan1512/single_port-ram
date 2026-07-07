module ram(clk,rst,din,dout,ren,wen,addr);
  input wire clk,rst;
  input wire[7:0]din;
  input[4:0]addr;
  input wire ren,wen;
  output reg[7:0]dout;
  reg[7:0]mem[32];
  
  always @(posedge clk)
 begin 
   if(!rst)
   mem[addr] <= 8'bz;
   else if(wen && !ren) 
     mem[addr] <= din;
 end 
 
always @(posedge clk)
 begin
   if(!rst) 
    dout <= 8'bz;
   else if(ren && !wen)
    dout <= mem[addr];
  else
    dout <= 8'bz;
 end
endmodule 


