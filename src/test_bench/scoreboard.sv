class scoreboard_ram;
  transaction_ram mon2sb_trans,ref2sb_trans;
  mailbox#(transaction_ram)mbx_ms;
  mailbox#(transaction_ram)mbx_rs;
  logic[7:0]mon_mem[31:0];
  logic[7:0]ref_mem[31:0];
  int MATCH = 0;
  int MISMATCH = 0;
  function new(mailbox#(transaction_ram)mbx_rs,mailbox#(transaction_ram)mbx_ms);
    this.mbx_ms=mbx_ms;
    this.mbx_rs=mbx_rs;
  endfunction
  task start();
    for(int i=0;i<50;i++) begin
      ref2sb_trans=new();
      mon2sb_trans=new();
      fork
        begin 
          mbx_rs.get(ref2sb_trans); 
          ref_mem[ref2sb_trans.addr]=ref2sb_trans.dout; 
          $display("############SCOREBOARD REF data_out=%0h, ADDRESS=%0h ###############", ref_mem[ref2sb_trans.addr], ref2sb_trans.addr); end
      begin
        mbx_ms.get(mon2sb_trans);
        mon_mem[mon2sb_trans.addr]=mon2sb_trans.dout;
        $display("!!!!!!!!!!!!!SCOREBOARD MON data_out=%0h, ADDRESS=%0h !!!!!!!!!!!!!!", mon_mem[mon2sb_trans.addr], mon2sb_trans.addr);
      end
      join
    end
  endtask
        
     task compare_report(); 
       if(ref_mem[ref2sb_trans.addr] === mon_mem[mon2sb_trans.addr]) begin
         $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", ref_mem[ref2sb_trans.addr], mon_mem[mon2sb_trans.addr]); 
         ++MATCH; 
         $display("DATA MATCH SUCCESSFUL. MATCH count = %0d",MATCH); 
       end 
       else begin
         $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", ref_mem[ref2sb_trans.addr], mon_mem[mon2sb_trans.addr]); 
         ++MISMATCH; 
         $display("DATA MATCH FAILURE. MISMATCH count = %0d",MISMATCH); 
       end 
     endtask 
        endclass
        
  
  
