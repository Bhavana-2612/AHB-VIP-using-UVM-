
class master_drv extends uvm_driver #(master_xtn);

  `uvm_component_utils(master_drv)

  virtual intf vif;
  master_cfg m_cfg;

  function new(string name = "master_drv", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(master_cfg)::get(this,"","m_cfg",m_cfg))
      `uvm_fatal("MASTER_DRIVER","Cannot get master_cfg")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.m_if;
  endfunction

  task run_phase(uvm_phase phase);
    @(vif.master_drv_cb);
    vif.master_drv_cb.Hresetn <= 1'b0;

    @(vif.master_drv_cb);
    vif.master_drv_cb.Hresetn <= 1'b1;

    forever begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask

  
  task send_to_dut(master_xtn xtn);

    // Address Phase
    wait(vif.master_drv_cb.Hready);

    vif.master_drv_cb.Haddr   <= xtn.Haddr;
    vif.master_drv_cb.Hwrite  <= xtn.Hwrite;
    vif.master_drv_cb.Hsize   <= xtn.Hsize;
    vif.master_drv_cb.Hburst  <= xtn.Hburst;
    vif.master_drv_cb.Htrans  <= xtn.Htrans;
    vif.master_drv_cb.length  <= xtn.length;

    @(vif.master_drv_cb);
    wait(vif.master_drv_cb.Hready);

    if(xtn.Hwrite)
      vif.master_drv_cb.Hwdata <= xtn.Hwdata;
    else
      xtn.Hrdata <= vif.master_drv_cb.Hrdata;

    `uvm_info(get_type_name(),"MASTER-DRIVER",UVM_LOW)
  xtn.Hready = vif.master_drv_cb.Hready;
    xtn.print();

  endtask

endclass
               
