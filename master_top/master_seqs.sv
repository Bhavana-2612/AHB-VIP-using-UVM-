class master_seqs extends uvm_sequence #(master_xtn);

  `uvm_object_utils(master_seqs)

  master_xtn req;

  bit [31:0] haddr;
  bit        hwrite;
  bit [2:0]  hsize;
  bit [2:0]  hburst;
  int         len;
  bit [1:0]  htrans;
  bit [31:0] hrdata;
  bit [31:0] hwdata;
  bit [1:0]  hresp;
  bit        hready;

  function new(string name = "master_seqs");
    super.new(name);
  endfunction

endclass


// SINGLE TRANSFER
class m_seq1 extends master_seqs;

  `uvm_object_utils(m_seq1)

  function new(string name = "m_seq1");
    super.new(name);
  endfunction

  task body();

    begin
      req = master_xtn::type_id::create("req");

      start_item(req);

 assert(req.randomize() with {
        Htrans == 2'b10;
        Hburst == 3'b000;
     //   Hwrite == 1'b1;
      });

      finish_item(req);
    end

  endtask

endclass

class m_seq2 extends master_seqs;

  `uvm_object_utils(m_seq2)

  function new(string name = "m_seq2");
    super.new(name);
  endfunction

  task body();

    bit [2:0] burst_type[3] = {
      3'b011,   // INCR4
      3'b101,   // INCR8
      3'b111    // INCR16
    };

    for (int b = 0; b < 3; b++)
    begin

      // ---------------- FIRST BEAT ----------------

      req = master_xtn::type_id::create(
                    $sformatf("req_burst_%0d",b));

      start_item(req);

      assert(req.randomize() with {

        Hburst == burst_type[b];
        Htrans == 2'b10;

      })
      else
        `uvm_fatal("M_SEQ2",
                   "INCR BURST RANDOMIZATION FAILED");

      uvm_config_db #(bit[9:0])::set(
        null,"*","length",req.length);

      finish_item(req);

   // Save first beat information

      haddr  = req.Haddr;
      hwrite = req.Hwrite;
      hsize  = req.Hsize;
      hburst = req.Hburst;
      len    = req.length;

      // ---------------- REMAINING BEATS ----------------

      for (int i = 0; i < len-1; i++)
      begin

        req = master_xtn::type_id::create(
                    $sformatf("req_burst_%0d_beat_%0d",b,i));

        start_item(req);

        assert(req.randomize() with {

          Hwrite == local::hwrite;
          Hsize  == local::hsize;
          Hburst == local::hburst;
          Htrans == 2'b11;
          length == local::len;

          Haddr == local::haddr +
                   (2 ** local::hsize);

        })
        else
          `uvm_fatal("M_SEQ2",
                     "INCR SEQ TRANSACTION RANDOMIZATION FAILED");

        finish_item(req);

        haddr = req.Haddr;

      end

    end
                         endtask

endclass

class m_seq3 extends master_seqs;

  `uvm_object_utils(m_seq3)

  bit [31:0] s_addr;
  bit [31:0] b_addr;

  function new(string name = "m_seq3");
    super.new(name);
  endfunction

  task body();

    bit [2:0] burst_type[3] = {
      3'b010,   // WRAP4
      3'b100,   // WRAP8
      3'b110    // WRAP16
    };

    for (int b = 0; b < 3; b++)
    begin

      // ---------------- FIRST BEAT ----------------

      req = master_xtn::type_id::create(
                    $sformatf("req_burst_%0d",b));

      start_item(req);

      assert(req.randomize() with {

        Hburst == burst_type[b];
        Htrans == 2'b10;

      })
      else
        `uvm_fatal("M_SEQ3",
                   "WRAP BURST RANDOMIZATION FAILED");

      uvm_config_db #(bit[9:0])::set(
        null,"*","length",req.length);
                                                 finish_item(req);

      // Save first beat information

      haddr  = req.Haddr;
      hwrite = req.Hwrite;
      hsize  = req.Hsize;
      hburst = req.Hburst;
      len    = req.length;

      // Calculate wrap boundary

      s_addr = int'(req.Haddr /
               ((2 ** req.Hsize) * req.length))
               * ((2 ** req.Hsize) * req.length);

      b_addr = s_addr +
               ((2 ** req.Hsize) * req.length);

      $display("------------------------------------------");
      $display("Burst Type       = %0d", hburst);
      $display("Start Address    = %0h", s_addr);
      $display("Boundary Address = %0h", b_addr);
      $display("------------------------------------------");

      haddr = req.Haddr + (2 ** hsize);

      // ---------------- REMAINING BEATS ----------------

      for (int i = 1; i < len; i++)
      begin

        if (haddr == b_addr)
          haddr = s_addr;

        req = master_xtn::type_id::create(
                    $sformatf("req_burst_%0d_beat_%0d",b,i));

        start_item(req);

 
        assert(req.randomize() with {

          Hwrite == local::hwrite;
          Hsize  == local::hsize;
          Hburst == local::hburst;
          Htrans == 2'b11;
          length == local::len;

          Haddr == local::haddr;

        })
        else
          `uvm_fatal("M_SEQ3",
                     "WRAP SEQ TRANSACTION RANDOMIZATION FAILED");

        finish_item(req);

        haddr = req.Haddr + (2 ** hsize);

      end

    end

  endtask

endclass

 
