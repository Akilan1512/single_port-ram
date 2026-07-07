interface ram_if(input bit clk,rst);
  logic[7:0]din,dout;
  logic wen,ren;
  logic[4:0]addr;
  clocking drv_cb@(posedge clk);
    default input#0 output#0;
    input rst;
    output wen,ren,din,addr;
  endclocking
  clocking mon_cb@(posedge clk);
    default input#0 output#0;
    input dout;
  endclocking
  clocking ref_cb@(posedge clk); 
    default input #0 output #0; 
  endclocking
  modport drv(clocking drv_cb);
  modport mon(clocking mon_cb);
  modport REF_SB(clocking ref_cb);
endinterface
      
