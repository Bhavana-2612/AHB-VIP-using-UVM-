class env_cfg extends uvm_object;
        `uvm_object_utils(env_cfg)

function new (string name = "env_cfg");
        super.new(name);
endfunction

bit has_master_agt;
bit has_slave_agt;
bit has_sb;

int no_of_masters;
int no_of_slaves;

master_cfg m_cfg[];
slave_cfg s_cfg[];
endclass
