class slave_seqr extends uvm_sequencer #(slave_xtn);
        `uvm_component_utils(slave_seqr)

        function new(string name = "slave_seqr",uvm_component parent);
                super.new(name,parent);
        endfunction
endclass

