class test_ram;
  virtual ram_if drv_vif;
  virtual ram_if mon_vif;
  virtual ram_if ref_vif;
  environment_ram env;
  function new(virtual ram_if drv_vif,virtual ram_if mon_vif,virtual ram_if ref_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
    this.ref_vif=ref_vif;
  endfunction
  virtual task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    env.start;
  endtask
endclass

