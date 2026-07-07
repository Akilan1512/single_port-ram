module top();
import package_ram::*;
  logic clk;
  logic rst;
  reset_test t0;
  write_test t1;
   read_test t2;
  write_read_test t3;
  boundary_test t4;
  sequential_test t5;
  random_rw_test t6;
  full_memory_test t7;
  initial begin
    clk=0;
    forever #10 clk=~clk;
  end
  initial begin
    @(posedge clk);
    rst=0;
    repeat(1)@(posedge clk);
    rst=1;
  end
  ram_if intrf(clk,rst);
  ram dut(.din(intrf.din),.wen(intrf.wen),.ren(intrf.ren),.dout(intrf.dout),.addr(intrf.addr),.clk(clk),.rst(rst));
          test_ram test;
          initial begin

               t0 = new(intrf.drv,intrf.mon,intrf.REF_SB);
                t1 = new(intrf.drv,intrf.mon,intrf.REF_SB);
                t2 = new(intrf.drv,intrf.mon,intrf.REF_SB);
              t3 = new(intrf.drv,intrf.mon,intrf.REF_SB);
           t4 = new(intrf.drv,intrf.mon,intrf.REF_SB);
             t5 = new(intrf.drv,intrf.mon,intrf.REF_SB);
                t6 = new(intrf.drv,intrf.mon,intrf.REF_SB);
             t7 = new(intrf.drv,intrf.mon,intrf.REF_SB);

   t0.run();
   t1.run();
   t2.run();
   t3.run();
   t4.run();
   t5.run();
   t6.run();
   t7.run();

   $finish;

end
          endmodule
          
          
  
