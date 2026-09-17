class master_cfg extends uvm_object;
        `uvm_object_utils(master_cfg)

        function new(string name = "master_cfg");
                super.new(name);
        endfunction

        uvm_active_passive_enum is_active;
        virtual intf m_if;

endclass
