
package test_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"


  // ahb files
  `include "../master_top/master_xtn.sv"
  `include "../master_top/master_cfg.sv"
  `include "../slave_top/slave_cfg.sv"
  `include "../tb/env_cfg.sv"
  `include "../master_top/master_drv.sv"
  `include "../master_top/master_mon.sv"
  `include "../master_top/master_seqr.sv"
  `include "../master_top/master_agt.sv"
   `include "../master_top/master_agt_top.sv"
  `include "../master_top/master_seqs.sv"
  // Slave files
  `include "../slave_top/slave_xtn.sv"
  `include "../slave_top/slave_drv.sv"
  `include "../slave_top/slave_mon.sv"
  `include "../slave_top/slave_seqr.sv"
  `include "../slave_top/slave_agt.sv"
  `include "../slave_top/slave_agt_top.sv"
  `include "../slave_top/slave_seqs.sv"


  // TB files
//  `include "../tb/vseqr.sv"
//  `include "../tb/vseq.sv"
  `include "../tb/sb.sv"

   `include "../tb/env.sv"

   `include "test.sv"

endpackage
                          
