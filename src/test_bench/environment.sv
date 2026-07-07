class environment_ram;
  virtual ram_if drv_vif;
  virtual ram_if mon_vif;
  virtual ram_if ref_vif;
  mailbox#(transaction_ram)mbx_gd;
  mailbox #(transaction_ram) mbx_dr;
  mailbox #(transaction_ram) mbx_rs;
  mailbox#(transaction_ram)mbx_ms;
  generator_ram gen;
  driver_ram drv;
  monitor_ram mon;
  reference_model_ram ref_sb;
  scoreboard_ram scb;
  function new(virtual ram_if drv_vif,virtual ram_if mon_vif,virtual ram_if ref_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
    this.ref_vif=ref_vif;
  endfunction
  task build(); begin
    mbx_gd=new();
    mbx_dr=new(); 
    mbx_rs=new();
    mbx_ms=new();
    gen=new(mbx_gd);
    drv=new(mbx_gd,mbx_dr,drv_vif);
    mon=new(mon_vif,mbx_ms);
    ref_sb=new(mbx_dr,mbx_rs,ref_vif);
    scb=new(mbx_rs,mbx_ms);
  end
  endtask
  task start();
    fork
      gen.start();
      drv.start();
      mon.start();
      scb.start();
      ref_sb.start();
    join
    scb.compare_report();
  endtask
endclass
  
