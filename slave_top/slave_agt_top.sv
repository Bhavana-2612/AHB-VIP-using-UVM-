class slave_agt_top extends uvm_env;
        `uvm_component_utils(slave_agt_top)

        function new(string name = "slave_agt_top",uvm_component parent);
                super.new(name,parent);
        endfunction

env_cfg e_cfg;
slave_agt s_agth[];

function void build_phase(uvm_phase phase);
        super.build_phase(phase);

if(!uvm_config_db #(env_cfg)::get(this,"","e_cfg",e_cfg))
        `uvm_fatal("SLAVE_AGT_TOP","CANT GET ENV_CONFIG IN SLAVE_AGT_TOP ")

        s_agth = new[e_cfg.no_of_slaves];

        foreach(s_agth[i])
            begin
                uvm_config_db #(slave_cfg)::set(this,$sformatf("s_agth[%0d]*",i),"s_cfg",e_cfg.s_cfg[i]);
                s_agth[i] = slave_agt::type_id::create($sformatf("s_agth[%0d]",i),this);
            end
endfunction

endclass

