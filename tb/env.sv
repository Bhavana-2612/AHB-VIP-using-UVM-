class env extends uvm_env;

`uvm_component_utils(env)

        function new(string name = "env", uvm_component parent);
                super.new(name,parent);
        endfunction

env_cfg e_cfg;
master_agt_top m_agt_toph;
slave_agt_top s_agt_toph;
sb sbh;

function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if(!uvm_config_db #(env_cfg)::get(this,"","e_cfg",e_cfg))
        `uvm_fatal("ENV","CANT GET ENV_CFG IN ENV")

if(e_cfg.has_master_agt)
   begin
        uvm_config_db#(env_cfg)::set(this,"*","e_cfg",e_cfg);
        m_agt_toph = master_agt_top::type_id::create("m_agt_toph",this);
   end


if(e_cfg.has_slave_agt)
   begin
        uvm_config_db#(env_cfg)::set(this,"*","e_cfg",e_cfg);
        s_agt_toph = slave_agt_top::type_id::create("s_agt_toph",this);
   end

if(e_cfg.has_sb)
   begin
        sbh = sb::type_id::create("sbh",this);
   end

endfunction
  function void connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    if(e_cfg.has_sb)
    begin

        foreach(m_agt_toph.m_agth[i])
        begin
            m_agt_toph.m_agth[i].m_monh.monitor_port.connect(
                sbh.source_fifo[i].analysis_export
            );
        end

        foreach(s_agt_toph.s_agth[i])
        begin
            s_agt_toph.s_agth[i].s_monh.monitor_port.connect(
                sbh.destination_fifo[i].analysis_export
            );
        end

    end

endfunction

endclass
