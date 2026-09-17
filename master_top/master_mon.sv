
class master_mon extends uvm_monitor;

  `uvm_component_utils(master_mon)

  virtual intf vif;
  master_cfg m_cfg;

  uvm_analysis_port #(master_xtn) monitor_port;

  master_xtn xtn;

  function new(string name = "master_mon", uvm_component parent);
    super.new(name, parent);

    monitor_port = new("monitor_port", this);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(master_cfg)::get(this, "", "m_cfg", m_cfg))
      `uvm_fatal("MASTER_MON", "Cannot get master_cfg")

  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    vif = m_cfg.m_if;

  endfunction


  task run_phase(uvm_phase phase);

    forever begin
      collect_data();
    end

    
  endtask


  task collect_data();

    xtn = master_xtn::type_id::create("xtn");

    // ------------------------------------------------
    // ADDRESS PHASE
    // ------------------------------------------------

    // Synchronize with clocking block
    @(vif.master_mon_cb);

    // Wait for a valid AHB transfer
    while (!(vif.master_mon_cb.Htrans inside {2'b10, 2'b11}))
      @(vif.master_mon_cb);

    // Capture address phase information
    xtn.Haddr   = vif.master_mon_cb.Haddr;
    xtn.Hwrite  = vif.master_mon_cb.Hwrite;
    xtn.Hsize   = vif.master_mon_cb.Hsize;
    xtn.Hburst  = vif.master_mon_cb.Hburst;
    xtn.Htrans  = vif.master_mon_cb.Htrans;
    xtn.length  = vif.master_mon_cb.length;
    xtn.Hresetn = vif.master_mon_cb.Hresetn;


    // ------------------------------------------------
    // DATA PHASE
    // ------------------------------------------------

    // Move to data phase
    @(vif.master_mon_cb);

  // Wait until the transfer is completed
    while (vif.master_mon_cb.Hready != 1'b1)
      @(vif.master_mon_cb);


    // IMPORTANT:
    // Use the Hwrite value captured during ADDRESS PHASE.
    // Do NOT use current Hwrite because it may belong
    // to the next pipelined transfer.

    if (xtn.Hwrite)
      xtn.Hwdata = vif.master_mon_cb.Hwdata;
    else
      xtn.Hrdata = vif.master_mon_cb.Hrdata;

    xtn.Hready = vif.master_mon_cb.Hready;


    // ------------------------------------------------
    // SEND TRANSACTION TO SCOREBOARD
    // ------------------------------------------------

    monitor_port.write(xtn);


    `uvm_info(get_type_name(),
              "================ MASTER MONITOR ================",
              UVM_LOW)

    xtn.print();

  endtask

endclass

