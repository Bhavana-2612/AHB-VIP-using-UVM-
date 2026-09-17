class master_agt extends uvm_agent;
        `uvm_component_utils(master_agt)

function new(string name = "master_agt",uvm_component parent);
        super.new(name,parent);
endfunction

master_cfg m_cfg;
virtual intf vif;
master_drv m_drvh;
master_seqr m_seqrh;
master_mon m_monh;



function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if(!uvm_config_db #(master_cfg)::get(this,"","m_cfg",m_cfg))
        `uvm_fatal("MASTER_AGT","CANT GET CFG IN MASTER_AGT")

uvm_config_db #(master_cfg)::set(this,"*","m_cfg",m_cfg);

if(m_cfg.is_active == UVM_ACTIVE)
   begin
        m_drvh  = master_drv::type_id::create("m_drvh",this);
        m_seqrh = master_seqr::type_id::create("m_seqrh",this);
   end
        m_monh  = master_mon::type_id::create("m_monh",this);
endfunction

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

if(m_cfg.is_active == UVM_ACTIVE)
        m_drvh.seq_item_port.connect(m_seqrh.seq_item_export);
endfunction

endclass

