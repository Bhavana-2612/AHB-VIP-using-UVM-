class slave_cfg extends uvm_object;
        `uvm_object_utils(slave_cfg)

        function new(string name = "slave_cfg");
                super.new(name);
        endfunction

        uvm_active_passive_enum is_active;
        virtual intf s_if;

endclass

