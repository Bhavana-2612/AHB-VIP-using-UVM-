
class slave_seqs extends uvm_sequence #(slave_xtn);

  `uvm_object_utils(slave_seqs)

  slave_xtn req;

  bit [9:0] length;

  function new(string name = "slave_seqs");
    super.new(name);
  endfunction

endclass


// OKAY

class s_seq_okay extends slave_seqs;

  `uvm_object_utils(s_seq_okay)

  function new(string name = "s_seq_okay");
    super.new(name);
  endfunction


  task body();

    if(!uvm_config_db #(bit[9:0])::get(null, "*", "length", length))
    begin
      length = 1;
      $display("Length not found - assuming SINGLE transfer");
    end

    repeat(length)
    begin

      req = slave_xtn::type_id::create("req");


      start_item(req);

      assert(req.randomize() with {

        resp == slave_xtn::okay;
        wait_cycles == 0;

      })
      else
        `uvm_fatal("SLAVE_OKAY", "OKAY TRANSACTION RANDOMIZATION FAILED")

      finish_item(req);

    end

  endtask

endclass

// OKAY WAIT

class s_seq_okay_wait extends slave_seqs;

  `uvm_object_utils(s_seq_okay_wait)

  function new(string name = "s_seq_okay_wait");
    super.new(name);
  endfunction


  task body();

    if(!uvm_config_db #(bit[9:0])::get(null, "*", "length", length))
    begin
     length = 1;
      $display("Length not found - assuming SINGLE transfer");
    end

    $display("Length in slave OKAY_WAIT seq = %0d", length);

                                                            repeat(length)
    begin

      req = slave_xtn::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {

        resp == slave_xtn::okay_wait;
        wait_cycles inside {[1:5]};

      })
      else
        `uvm_fatal("SLAVE_OKAY_WAIT", "OKAY_WAIT TRANSACTION RANDOMIZATION FAILED")

      finish_item(req);

    end

  endtask

endclass


// ERROR

class s_seq_error extends slave_seqs;

  `uvm_object_utils(s_seq_error)

  function new(string name = "s_seq_error");
    super.new(name);
  endfunction


  task body();

    if(!uvm_config_db #(bit[9:0])::get(null, "*", "length", length))
    begin
      length = 1;
                                                $display("Length not found - assuming SINGLE transfer");
    end

    $display("Length in slave ERROR seq = %0d", length);


    repeat(length)
    begin

      req = slave_xtn::type_id::create("req");

      start_item(req);

      assert(req.randomize() with {

        resp == slave_xtn::error;
        wait_cycles == 0;

      })
      else
        `uvm_fatal("SLAVE_ERROR",
                   "ERROR TRANSACTION RANDOMIZATION FAILED")

      finish_item(req);

    end

  endtask

endclass
                
