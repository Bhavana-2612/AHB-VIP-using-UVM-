class slave_agt extends uvm_agent;
        `uvm_component_utils(slave_agt)

function new(string name = "slave_agt",uvm_component parent);
        super.new(name,parent);
endfunction

slave_cfg s_cfg;
virtual intf vif;
slave_drv s_drvh;
slave_seqr s_seqrh;
slave_mon s_monh;



function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if(!uvm_config_db #(slave_cfg)::get(this,"","s_cfg",s_cfg))
        `uvm_fatal("SLAVE_AGT","CANT GET CFG SLAVE_AGT")

uvm_config_db #(slave_cfg)::set(this,"*","s_cfg",s_cfg);

if(s_cfg.is_active == UVM_ACTIVE)
   begin
        s_drvh  = slave_drv::type_id::create("s_drvh",this);
        s_seqrh = slave_seqr::type_id::create("s_seqrh",this);
   end
        s_monh  = slave_mon::type_id::create("s_monh",this);
endfunction

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

 if(s_cfg.is_active == UVM_ACTIVE)
        s_drvh.seq_item_port.connect(s_seqrh.seq_item_export);
endfunction

endclass

