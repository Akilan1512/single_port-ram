class transaction_ram;
  rand logic[7:0]din;
  rand logic[4:0]addr;
  rand logic ren,wen;
  logic[7:0]dout;
 /* constraint c1{
    {ren,wen}!=2'b11;
  } */ 
  virtual function transaction_ram copy();
    copy=new();
    copy.din=this.din;
    copy.addr=this.addr;
    copy.ren=this.ren;
    copy.wen=this.wen;
    return copy;
  endfunction
endclass

