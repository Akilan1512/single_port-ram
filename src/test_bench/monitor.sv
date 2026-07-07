class monitor_ram;
  transaction_ram mon_trans;
  mailbox#(transaction_ram)mbx_ms;
  virtual ram_if.MON vif;
  covergroup mon_cg;
    data_out:coverpoint mon_trans.dout{
      bins dout={[0:255]}; }
  endgroup
  function new(virtual ram_if.MON vif,mailbox#(transaction_ram)mbx_ms);
               this.vif=vif;
               this.mbx_ms=mbx_ms;
               mon_cg=new();
               endfunction
               task start();
                 repeat(4)@(vif.mon_cb);
                 for(int i=0;i<50;i++) begin
                   mon_trans=new();
                   repeat(1)@(vif.mon_cb) begin
                     mon_trans.dout=vif.mon_cb.dout;
                   end
                   $display("MONITOR PASSING THE DATA TO SCOREBOARD data_out=%0h", mon_trans.dout);
                   mbx_ms.put(mon_trans);
                   mon_cg.sample();
                   $display("OUTPUT FUNCTIONAL COVERAGE = %0d", mon_cg.get_coverage()); 
                   repeat(1) @(vif.mon_cb); 
                 end 
               endtask 
endclass
