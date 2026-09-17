class slave_drv extends uvm_driver #(slave_xtn);

  `uvm_component_utils(slave_drv)

  virtual intf  vif;
  slave_cfg     s_cfg;


  //===========================================================
  // Constructor
  //===========================================================

  function new(string name = "slave_drv",
               uvm_component parent);

    super.new(name, parent);

  endfunction


  //===========================================================
  // Build Phase
  //===========================================================

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(slave_cfg)::get(this, "", "s_cfg", s_cfg))
    begin

      `uvm_fatal("SLAVE_DRV",
                 "Cannot get slave_cfg")

    end

    vif = s_cfg.s_if;

  endfunction


  //===========================================================
  // Run Phase
  //===========================================================

  task run_phase(uvm_phase phase);

    // Slave idle values

    vif.slave_drv_cb.Hready <= 1'b1;
    vif.slave_drv_cb.Hresp  <= 2'b00;
    vif.slave_drv_cb.Hrdata <= 32'b0;
    vif.slave_drv_cb.resp   <= 1'b0;

    @(vif.slave_drv_cb);


    forever
    begin

      // Get slave response transaction

      seq_item_port.get_next_item(req);

      // Generate response

      send_to_dut(req);

      // Transaction completed

      seq_item_port.item_done();

    end

  endtask


  //===========================================================
  // Send Response to DUT
  //===========================================================

  task send_to_dut(slave_xtn xtn);

    logic        pending_write;
    logic [31:0] pending_addr;


    //=========================================================
    // STEP 1 : Wait for Address Phase
    //
    // NONSEQ = 2'b10
    // SEQ    = 2'b11
    //=========================================================

    while (!(vif.slave_drv_cb.Htrans inside {2'b10,2'b11}))
    begin
      @(vif.slave_drv_cb);
    end


    //=========================================================
    // STEP 2 : Capture Address / Control Information
    //=========================================================

    pending_addr  = vif.slave_drv_cb.Haddr;
    pending_write = vif.slave_drv_cb.Hwrite;


    `uvm_info("SLAVE_DRV",
              $sformatf(
              "ADDRESS PHASE : HADDR=%08h HWRITE=%0b HTRANS=%0b",
              pending_addr,
              pending_write,
              vif.slave_drv_cb.Htrans),
              UVM_LOW)


    //=========================================================
    // OKAY RESPONSE
    //=========================================================

    if (xtn.resp == slave_xtn::okay)
    begin

      // Address is captured in current cycle.
      // Response/data is driven in the NEXT cycle.

      @(vif.slave_drv_cb);


      // Zero wait-state response

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b00;
      vif.slave_drv_cb.resp   <= 1'b0;


      //=======================================================
      // WRITE
      //=======================================================

      if (pending_write)
      begin

        vif.slave_drv_cb.Hrdata <= 32'b0;

        `uvm_info("SLAVE_DRV",
                  $sformatf(
                  "OKAY WRITE RESPONSE : ADDR=%08h HREADY=1 HRESP=00",
                  pending_addr),
                  UVM_LOW)

      end

 //=======================================================
      // READ
      //=======================================================

      else
      begin

        // Generate the read data in a temporary variable
        // so that we can print exactly what is driven.

        logic [31:0] read_data;

        read_data = $urandom;

        vif.slave_drv_cb.Hrdata <= read_data;

        `uvm_info("SLAVE_DRV",
                  $sformatf(
                  "OKAY READ RESPONSE : ADDR=%08h HRDATA=%08h",
                  pending_addr,
                  read_data),
                  UVM_LOW)

      end


      //=======================================================
      // Keep response valid for this clock cycle
      //=======================================================

      @(vif.slave_drv_cb);


      //=======================================================
      // Return to idle
      //=======================================================

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b00;
      vif.slave_drv_cb.resp   <= 1'b0;

 // Keep Hrdata as it is for debugging.
      // vif.slave_drv_cb.Hrdata <= 32'b0;

    end


    //=========================================================
    // OKAY WAIT RESPONSE
    //=========================================================

    else if (xtn.resp == slave_xtn::okay_wait)
    begin

      `uvm_info("SLAVE_DRV",
                $sformatf(
                "OKAY_WAIT : ADDR=%08h WAIT_CYCLES=%0d HWRITE=%0b",
                pending_addr,
                xtn.wait_cycles,
                pending_write),
                UVM_LOW)


      //=======================================================
      // DATA / WAIT PHASE
      //
      // HREADY remains LOW during every wait cycle.
      //=======================================================

      repeat (xtn.wait_cycles)
      begin

        vif.slave_drv_cb.Hready <= 1'b0;
        vif.slave_drv_cb.Hresp  <= 2'b00;
        vif.slave_drv_cb.resp   <= 1'b0;

        // Keep Hrdata unchanged during wait.
        // vif.slave_drv_cb.Hrdata <= 32'b0;

        `uvm_info("SLAVE_DRV",
                  $sformatf(
                  "WAIT STATE : ADDR=%08h HREADY=0",
                                                               pending_addr),
                  UVM_HIGH)

        @(vif.slave_drv_cb);

      end


      //=======================================================
      // FINAL RESPONSE
      //=======================================================

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b00;
      vif.slave_drv_cb.resp   <= 1'b0;


      //=======================================================
      // WRITE
      //=======================================================

      if (pending_write)
      begin

        vif.slave_drv_cb.Hrdata <= 32'b0;

      end


      //=======================================================
      // READ
      //=======================================================

      else
      begin

        logic [31:0] read_data;

        read_data = $urandom;

        vif.slave_drv_cb.Hrdata <= read_data;
                                                     `uvm_info("SLAVE_DRV",
                  $sformatf(
                  "OKAY_WAIT READ RESPONSE : ADDR=%08h HRDATA=%08h",
                  pending_addr,
                  read_data),
                  UVM_LOW)

      end


      `uvm_info("SLAVE_DRV",
                $sformatf(
                "OKAY_WAIT RESPONSE : ADDR=%08h HREADY=1 HRESP=00",
                pending_addr),
                UVM_LOW)


      // Do not wait here for now.

      // Return to idle

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b00;
      vif.slave_drv_cb.resp   <= 1'b0;

      // Keep Hrdata for debugging.
      // vif.slave_drv_cb.Hrdata <= 32'b0;

    end


    //=========================================================
    // ERROR RESPONSE
    //=========================================================

    else if (xtn.resp == slave_xtn::error)
    begin

      `uvm_info("SLAVE_DRV",
                $sformatf(
                "ERROR RESPONSE : ADDR=%08h",
                                                         pending_addr),
                UVM_LOW)


      //=======================================================
      // ERROR RESPONSE - FIRST CYCLE
      //
      // HREADY = 0
      // HRESP  = ERROR
      //=======================================================

      vif.slave_drv_cb.Hready <= 1'b0;
      vif.slave_drv_cb.Hresp  <= 2'b01;
      vif.slave_drv_cb.resp   <= 1'b1;

      // vif.slave_drv_cb.Hrdata <= 32'b0;


      `uvm_info("SLAVE_DRV",
                "ERROR CYCLE 1 : HREADY=0 HRESP=01",
                UVM_LOW)


      @(vif.slave_drv_cb);


      //=======================================================
      // ERROR RESPONSE - SECOND CYCLE
      //
      // HREADY = 1
      // HRESP  = ERROR
      //=======================================================

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b01;
      vif.slave_drv_cb.resp   <= 1'b1;

      // vif.slave_drv_cb.Hrdata <= 32'b0;


      `uvm_info("SLAVE_DRV",
                                                  "ERROR CYCLE 2 : HREADY=1 HRESP=01",
                UVM_LOW)


      @(vif.slave_drv_cb);


      //=======================================================
      // Return to Normal
      //=======================================================

      vif.slave_drv_cb.Hready <= 1'b1;
      vif.slave_drv_cb.Hresp  <= 2'b00;
      vif.slave_drv_cb.resp   <= 1'b0;

      // vif.slave_drv_cb.Hrdata <= 32'b0;


      `uvm_info("SLAVE_DRV",
                "ERROR COMPLETE : HREADY=1 HRESP=00",
                UVM_LOW)

    end


    //=========================================================
    // Print Transaction
    //=========================================================

    `uvm_info("SLAVE_DRV",
              "================ SLAVE-DRIVER ================",
              UVM_LOW)

    xtn.print();

  endtask

endclass
                               
