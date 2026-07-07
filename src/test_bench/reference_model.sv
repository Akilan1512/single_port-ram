class reference_model_ram;
  transaction_ram ref_trans; 
  mailbox #(transaction_ram) mbx_rs; 
  mailbox #(transaction_ram) mbx_dr;
  virtual ram_if.REF_SB vif; 
  reg [7:0] MEM [31:0]; 
  function new(mailbox #(transaction_ram) mbx_dr, mailbox #(transaction_ram) mbx_rs, virtual ram_if.REF_SB vif); 
    this.mbx_dr=mbx_dr;
    this.mbx_rs=mbx_rs; 
    this.vif=vif; 
  endfunction
  task start(); 
    for(int i=0;i<50;i++) begin 
      ref_trans=new(); 
      mbx_dr.get(ref_trans); 
      repeat(1) @(vif.ref_cb) begin 
        if(ref_trans.wen)
          MEM[ref_trans.addr]=ref_trans.din; 
        $display("REFERENCE MODEL DATA IN MEMORY MEM[%0h]=%0h", ref_trans.addr,MEM[ref_trans.addr],$time); if(ref_trans.ren) ref_trans.dout=MEM[ref_trans.addr]; 
        $display("REFERENCE MODEL DATA OUT FROM MEMORY data_out=%0h",ref_trans.dout); 
      end 
      mbx_rs.put(ref_trans); 
    end 
  endtask
endclass
