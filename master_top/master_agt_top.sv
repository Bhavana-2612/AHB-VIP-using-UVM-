
class master_agt_top extends uvm_env;
        `uvm_component_utils(master_agt_top)

        function new(string name = "master_agt_top",uvm_component parent);
                super.new(name,parent);
        endfunction

env_cfg e_cfg;
master_agt m_agth[];

function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if(!uvm_config_db #(env_cfg)::get(this,"","e_cfg",e_cfg))
        `uvm_fatal("MASTER_AGT_TOP","CANT GET ENV_CONFIG IN MASTER_AGT_TOP")

        m_agth = new[e_cfg.no_of_masters];

        foreach(m_agth[i])
            begin
                uvm_config_db #(master_cfg)::set(this,$sformatf("m_agth[%0d]*",i),"m_cfg",e_cfg.m_cfg[i]);
                m_agth[i] = master_agt::type_id::create($sformatf("m_agth[%0d]",i),this);
            end
endfunction

endclass
