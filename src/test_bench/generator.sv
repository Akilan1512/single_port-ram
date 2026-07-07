typedef enum {RESET_TEST,WRITE_ONLY,READ_ONLY,WRITE_READ,BOUNDARY,SEQUENTIAL,RANDOM_RW,
    FULL_MEMORY
} test_mode_t;
class generator_ram;
  transaction_ram t1;
  mailbox#(transaction_ram)mbx_gd;
  test_mode_t mode;

  //---------------------------------------------------
  // Constructor
  //---------------------------------------------------
  function new(mailbox #(transaction_ram) mbx_gd);
    this.mbx_gd = mbx_gd;
    t1 = new();
    mode = RANDOM_RW;       // Default testcase
  endfunction


  //---------------------------------------------------
  // Generator Task
  //---------------------------------------------------
  task start();

    case(mode)

    //-------------------------------------------------
    // RESET TEST
    //-------------------------------------------------
    RESET_TEST:
    begin
      $display("\n******** RESET TEST ********");

      repeat(5)
      begin
        assert(t1.randomize() with
        {
          wen==0;
          ren==0;
        });

        mbx_gd.put(t1.copy());

        $display("GEN : RESET -> addr=%0d din=%0h",
                  t1.addr,t1.din);
      end
    end


    //-------------------------------------------------
    // WRITE ONLY TEST
    //-------------------------------------------------
    WRITE_ONLY:
    begin
      $display("\n******** WRITE ONLY TEST ********");

      repeat(50)
      begin

        assert(t1.randomize() with
        {
          wen==1;
          ren==0;
        });

        mbx_gd.put(t1.copy());

        $display("GEN : WRITE addr=%0d data=%0h",
                  t1.addr,t1.din);

      end
    end


    //-------------------------------------------------
    // READ ONLY TEST
    //-------------------------------------------------
    READ_ONLY:
    begin

      $display("\n******** READ ONLY TEST ********");

      repeat(50)
      begin

        assert(t1.randomize() with
        {
          wen==0;
          ren==1;
        });

        mbx_gd.put(t1.copy());

        $display("GEN : READ addr=%0d",
                  t1.addr);

      end

    end


    //-------------------------------------------------
    // WRITE FOLLOWED BY READ
    //-------------------------------------------------
    WRITE_READ:
    begin

      $display("\n******** WRITE READ TEST ********");

      repeat(25)
      begin

        bit [4:0] addr;
        bit [7:0] data;

        addr = $urandom_range(0,31);
        data = $urandom;

        //---------------- WRITE ----------------

        t1.addr = addr;
        t1.din  = data;
        t1.wen  = 1;
        t1.ren  = 0;

        mbx_gd.put(t1.copy());

        //---------------- READ ----------------

        t1.addr = addr;
        t1.wen  = 0;
        t1.ren  = 1;

        mbx_gd.put(t1.copy());

        $display("GEN : WRITE->READ addr=%0d data=%0h",
                  addr,data);

      end

    end


    //-------------------------------------------------
    // BOUNDARY TEST
    //-------------------------------------------------
    BOUNDARY:
    begin

      $display("\n******** BOUNDARY TEST ********");

      //---------------- Address 0 ----------------

      t1.addr = 0;
      t1.din  = 8'hAA;
      t1.wen  = 1;
      t1.ren  = 0;

      mbx_gd.put(t1.copy());

      //---------------- Address 31 ----------------

      t1.addr = 31;
      t1.din  = 8'h55;
      t1.wen  = 1;
      t1.ren  = 0;

      mbx_gd.put(t1.copy());

    end


    //-------------------------------------------------
    // SEQUENTIAL ADDRESS TEST
    //-------------------------------------------------
    SEQUENTIAL:
    begin

      $display("\n******** SEQUENTIAL TEST ********");

      for(int i=0;i<32;i++)
      begin

        t1.addr=i;
        t1.din=i;
        t1.wen=1;
        t1.ren=0;

        mbx_gd.put(t1.copy());

        $display("GEN : addr=%0d data=%0h",
                  i,i);

      end

    end


    //-------------------------------------------------
    // RANDOM TEST
    //-------------------------------------------------
    RANDOM_RW:
    begin

      $display("\n******** RANDOM TEST ********");

      repeat(100)
      begin

        assert(t1.randomize());

        mbx_gd.put(t1.copy());

        $display("GEN : din=%0h addr=%0d wen=%0b ren=%0b",
                  t1.din,
                  t1.addr,
                  t1.wen,
                  t1.ren);

      end

    end


    //-------------------------------------------------
    // FULL MEMORY TEST
    //-------------------------------------------------
    FULL_MEMORY:
    begin

      $display("\n******** FULL MEMORY TEST ********");

      //---------------- WRITE ----------------

      for(int i=0;i<32;i++)
      begin

        t1.addr=i;
        t1.din=$urandom;
        t1.wen=1;
        t1.ren=0;

        mbx_gd.put(t1.copy());

      end

      //---------------- READ ----------------

      for(int i=0;i<32;i++)
      begin

        t1.addr=i;
        t1.wen=0;
        t1.ren=1;

        mbx_gd.put(t1.copy());

      end

    end

    endcase

  endtask

endclass

