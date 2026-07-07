class driver_ram;
  transaction_ram drv_trans;
  mailbox#(transaction_ram)mbx_gd;
  mailbox#(transaction_ram)mbx_dr;
  virtual ram_if.DRV vif;
  covergroup drv_cg;
    write:coverpoint drv_trans.wen{bins wr[]={0,1};}
    read:coverpoint drv_trans.ren{bins rd[]={0,1};}
    data_in:coverpoint drv_trans.din{bins data={[0:255]};}
    address:coverpoint drv_trans.addr{bins addr={[0:31]};}
    write_read:cross write,read;
  endgroup
  function new(mailbox#(transaction_ram)mbx_gd,mailbox#(transaction_ram)mbx_dr,virtual ram_if.DRV vif);
    this.mbx_gd=mbx_gd;
    this.mbx_dr=mbx_dr;
    this.vif=vif;
    drv_cg=new();
  endfunction
  task start();
    repeat(1)@(vif.drv_cb);
    for(int i=0;i<50;i++) begin
      drv_trans=new();
      $display("[%0t] Driver waiting for mailbox", $time);
mbx_gd.get(drv_trans);
$display("[%0t] Driver received transaction", $time);
      if(vif.drv_cb.rst==1)
        repeat(1)@(vif.drv_cb) begin
          vif.drv_cb.wen<=0;
          vif.drv_cb.ren<=0;
          vif.drv_cb.din<=8'bz;
          vif.drv_cb.addr<=0;
          mbx_dr.put(drv_trans);
          repeat(1)@(vif.drv_cb);
          $display("DRIVER DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", vif.drv_cb.din, vif.drv_cb.wen, vif.drv_cb.ren, vif.drv_cb.addr); 
        end 
      else 
        repeat(1) @(vif.drv_cb) begin 
          vif.drv_cb.wen<=drv_trans.wen; 
          vif.drv_cb.ren<=drv_trans.ren; 
          vif.drv_cb.din<=drv_trans.din; 
          vif.drv_cb.addr<=drv_trans.addr; 
          repeat(1)
            @(vif.drv_cb); 
          $display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", vif.drv_cb.din, vif.drv_cb.wen, vif.drv_cb.ren, vif.drv_cb.addr); 
          vif.drv_cb.wen<=0; 
          mbx_dr.put(drv_trans);
          drv_cg.sample();
          $display("INPUT FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
end 
    end 
  endtask
endclass
          
      
