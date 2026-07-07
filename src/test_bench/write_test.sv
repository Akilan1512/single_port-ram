class write_test extends test_ram;
  function new(virtual ram_if drv_vif,virtual ram_if mon_vif,virtual ram_if ref_vif);
    super.new(drv_vif,mon_vif,ref_vif);
  endfunction
   task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build();
    env.gen.mode=WRITE_ONLY;
    env.start();
  endtask
endclass
