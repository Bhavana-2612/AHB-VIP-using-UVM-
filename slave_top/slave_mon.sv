class slave_mon extends uvm_monitor;

  `uvm_component_utils(slave_mon)

  virtual intf vif;
  slave_cfg s_cfg;

  slave_xtn xtn;

  uvm_analysis_port #(slave_xtn) monitor_port;


  function new(string name = "slave_mon",
               uvm_component parent);

    super.new(name, parent);

    monitor_port = new("monitor_port", this);

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if (!uvm_config_db #(slave_cfg)::get(this,
                                         "",
                                         "s_cfg",
                                         s_cfg))
      `uvm_fatal("SLAVE_MON",
                 "Cannot get slave_cfg")

  endfunction


  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    vif = s_cfg.s_if;
                               endfunction


  task run_phase(uvm_phase phase);

    forever begin
      collect_data();
    end

  endtask


  task collect_data();

    xtn = slave_xtn::type_id::create("xtn");


    //========================================================
    // ADDRESS PHASE
    //========================================================

    // IMPORTANT:
    // First synchronize to the clocking block.
    // Do not directly use wait() on Htrans.
    //
    @(vif.slave_mon_cb);


    // Wait for valid AHB transfer
    while (!(vif.slave_mon_cb.Htrans inside {2'b10,2'b11}))
      @(vif.slave_mon_cb);


    // Capture ADDRESS PHASE information
    xtn.Haddr   = vif.slave_mon_cb.Haddr;
    xtn.Hwrite  = vif.slave_mon_cb.Hwrite;
    xtn.Hsize   = vif.slave_mon_cb.Hsize;
    xtn.Hburst  = vif.slave_mon_cb.Hburst;
    xtn.Htrans  = vif.slave_mon_cb.Htrans;
    xtn.length  = vif.slave_mon_cb.length;
    xtn.Hresetn = vif.slave_mon_cb.Hresetn;
                                                     
    //========================================================
    // DATA / RESPONSE PHASE
    //========================================================

    // Move to data phase
    @(vif.slave_mon_cb);


    // Initialize wait information
    xtn.wait_cycles = 0;


    //========================================================
    // WAIT STATE
    //========================================================

    while (vif.slave_mon_cb.Hready == 1'b0) begin

      xtn.wait_cycles++;

      @(vif.slave_mon_cb);

    end


    //========================================================
    // FINAL RESPONSE
    //========================================================

    xtn.Hready = vif.slave_mon_cb.Hready;
    xtn.Hresp  = vif.slave_mon_cb.Hresp;


    // Record whether wait occurred
    if (xtn.wait_cycles > 0)
      xtn.had_wait = 1'b1;
    else
      xtn.had_wait = 1'b0;

  //========================================================
    // RESPONSE TYPE
    //========================================================

    if (xtn.Hresp == 2'b01)

      xtn.resp = slave_xtn::error;

    else if (xtn.had_wait)

      xtn.resp = slave_xtn::okay_wait;

    else

      xtn.resp = slave_xtn::okay;


    //========================================================
    // DATA
    //========================================================

    // IMPORTANT:
    // Use Hwrite captured during ADDRESS PHASE.
    //
    // Do not use current Hwrite because current address/control
    // signals can belong to the next pipelined transfer.

    if (xtn.Hwrite)

      xtn.Hwdata = vif.slave_mon_cb.Hwdata;

    else

      xtn.Hrdata = vif.slave_mon_cb.Hrdata;



    //========================================================
    // SEND TO SCOREBOARD
    //========================================================

    monitor_port.write(xtn);


    `uvm_info(get_type_name(),
              "================ SLAVE MONITOR ================",
              UVM_LOW)

    xtn.print();

  endtask

endclass
                    
