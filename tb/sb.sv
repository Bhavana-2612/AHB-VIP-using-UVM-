
class sb extends uvm_scoreboard;

  `uvm_component_utils(sb)

  env_cfg e_cfg;

  uvm_tlm_analysis_fifo #(master_xtn) source_fifo[];
  uvm_tlm_analysis_fifo #(slave_xtn) destination_fifo[];

  master_xtn m_xtn;
  slave_xtn s_xtn;
  master_xtn master_cov;
  slave_xtn slave_cov;

  int matched_count;
  int mismatched_count;
  int data_verified_count;

  // Master coverage
  covergroup ahb_M_cg;
    option.per_instance = 1;

    HSIZE : coverpoint master_cov.Hsize {
      bins size[] = {[0:2]};
    }

    HWRITE : coverpoint master_cov.Hwrite {
      bins read  = {0};
      bins write = {1};
    }

    HADDR : coverpoint master_cov.Haddr {
      bins low  = {[32'h0000_0000:32'h3FFF_FFFF]};
      bins mid1 = {[32'h4000_0000:32'h7FFF_FFFF]};
      bins mid2 = {[32'h8000_0000:32'hBFFF_FFFF]};
      bins high = {[32'hC000_0000:32'hFFFF_FFFF]};
    }

    HBURST : coverpoint master_cov.Hburst {
      bins single = {3'b000};
                                                            bins wrap4  = {3'b010};
      bins incr4  = {3'b011};
      bins wrap8  = {3'b100};
      bins incr8  = {3'b101};
      bins wrap16 = {3'b110};
      bins incr16 = {3'b111};
    }

    HTRANS : coverpoint master_cov.Htrans {
      bins nonseq = {2'b10};
      bins seq    = {2'b11};
    }

    HWDATA : coverpoint master_cov.Hwdata {
      bins zero = {32'h0000_0000};
      bins nonzero = default;
    }

//    SIZE_X_WRITE : cross HSIZE,HWRITE;
//    SIZE_X_BURST : cross HSIZE,HBURST;
//    WRITE_X_BURST : cross HWRITE,HBURST;
//     BURST_X_TRANS : cross HBURST,HTRANS { ignore_bins single_seq = binsof(HBURST.single ) && binsof(HTRANS.seq);}


  endgroup


  // Slave coverage
  covergroup ahb_S_cg;
    option.per_instance = 1;

    HSIZE : coverpoint slave_cov.Hsize {
      bins size[] = {[0:2]};
    }

    HWRITE : coverpoint slave_cov.Hwrite {
      bins read  = {0};
      bins write = {1};
    }

 HADDR : coverpoint slave_cov.Haddr {
      bins low  = {[32'h0000_0000:32'h3FFF_FFFF]};
      bins mid1 = {[32'h4000_0000:32'h7FFF_FFFF]};
      bins mid2 = {[32'h8000_0000:32'hBFFF_FFFF]};
      bins high = {[32'hC000_0000:32'hFFFF_FFFF]};
    }

    HBURST : coverpoint slave_cov.Hburst {
      bins single = {3'b000};
      bins wrap4  = {3'b010};
      bins incr4  = {3'b011};
      bins wrap8  = {3'b100};
      bins incr8  = {3'b101};
      bins wrap16 = {3'b110};
      bins incr16 = {3'b111};
    }

     HTRANS : coverpoint slave_cov.Htrans {

      bins nonseq = {2'b10};
      bins seq    = {2'b11};
    }

    HWDATA : coverpoint slave_cov.Hwdata {
      bins zero = {32'h0000_0000};
      bins nonzero = default;
    }

    HREADY : coverpoint slave_cov.Hready {
      bins ready = {1};
     // bins okay_wait  = {0};

    }

    HAD_WAIT : coverpoint slave_cov.had_wait {
       bins  no_wait ={0};
       bins  okay_wait    ={1};

      }
    HRESP : coverpoint slave_cov.Hresp {
      bins okay  = {2'b00};
                                           bins error = {2'b01};
    }

  //  SIZE_X_WRITE : cross HSIZE,HWRITE;
  //  SIZE_X_BURST : cross HSIZE,HBURST;
  //  WRITE_X_BURST : cross HWRITE,HBURST;
  //  BURST_X_TRANS : cross HBURST,HTRANS  { ignore_bins single_seq = binsof(HBURST.single ) && binsof(HTRANS.seq);}
  //  RESP_X_WAIT  : cross HRESP,HAD_WAIT;

  endgroup


  extern function new(string name="sb",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task scoreboard_process(int master_index,int slave_index);
  extern task compare_data(master_xtn m_req,slave_xtn s_req,int master_index,int slave_index);
  extern function void report_phase(uvm_phase phase);

endclass


// Constructor
function sb::new(string name="sb",uvm_component parent);
  super.new(name,parent);
  ahb_M_cg = new();
  ahb_S_cg = new();
  matched_count = 0;
  mismatched_count = 0;
  data_verified_count = 0;
endfunction


// Build phase
function void sb::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db #(env_cfg)::get(this,"","e_cfg",e_cfg))
    `uvm_fatal("SB","Cannot get env_cfg")

  if(e_cfg.no_of_masters <= 0)
                                                  `uvm_fatal("SB","Invalid number of masters")

  if(e_cfg.no_of_slaves <= 0)
    `uvm_fatal("SB","Invalid number of slaves")

  source_fifo = new[e_cfg.no_of_masters];
  for(int i=0;i<e_cfg.no_of_masters;i++)
    source_fifo[i] = new($sformatf("source_fifo[%0d]",i),this);

  destination_fifo = new[e_cfg.no_of_slaves];
  for(int i=0;i<e_cfg.no_of_slaves;i++)
    destination_fifo[i] = new($sformatf("destination_fifo[%0d]",i),this);

endfunction


// Run phase
task sb::run_phase(uvm_phase phase);
  int number_of_pairs;

  number_of_pairs = e_cfg.no_of_masters;
  if(e_cfg.no_of_slaves < number_of_pairs)
    number_of_pairs = e_cfg.no_of_slaves;

  fork
    begin
      for(int i=0;i<number_of_pairs;i++) begin
        automatic int master_index = i;
        automatic int slave_index = i;
        fork
          scoreboard_process(master_index,slave_index);
        join_none
      end
      wait fork;
    end
  join
endtask


// Scoreboard process
task sb::scoreboard_process(int master_index,int slave_index);
                                                                      master_xtn local_m_xtn;
  slave_xtn local_s_xtn;

  if(master_index < 0 || master_index >= source_fifo.size()) begin
    `uvm_error("SB",$sformatf("Invalid master index=%0d",master_index))
    return;
  end

  if(slave_index < 0 || slave_index >= destination_fifo.size()) begin
    `uvm_error("SB",$sformatf("Invalid slave index=%0d",slave_index))
    return;
  end

  forever begin
    source_fifo[master_index].get(local_m_xtn);

    master_cov = local_m_xtn;
    ahb_M_cg.sample();

    destination_fifo[slave_index].get(local_s_xtn);

    slave_cov = local_s_xtn;
    ahb_S_cg.sample();

    compare_data(local_m_xtn,local_s_xtn,master_index,slave_index);
  end
endtask


// Compare transactions
task sb::compare_data(master_xtn m_req,slave_xtn s_req,int master_index,int slave_index);
  bit match = 1'b1;

  if(m_req.Haddr !== s_req.Haddr) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HADDR MISMATCH : MASTER=%08h SLAVE=%08h",m_req.Haddr,s_req.Haddr))
  end

  if(m_req.Hwrite !== s_req.Hwrite) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HWRITE MISMATCH : MASTER=%0b SLAVE=%0b",m_req.Hwrite,s_req.Hwrite))
                                                                                   end

  if(m_req.Htrans !== s_req.Htrans) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HTRANS MISMATCH : MASTER=%0b SLAVE=%0b",m_req.Htrans,s_req.Htrans))
  end

  if(m_req.Hburst !== s_req.Hburst) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HBURST MISMATCH : MASTER=%0h SLAVE=%0h",m_req.Hburst,s_req.Hburst))
  end

  if(m_req.Hsize !== s_req.Hsize) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HSIZE MISMATCH : MASTER=%0h SLAVE=%0h",m_req.Hsize,s_req.Hsize))
  end

  if(m_req.length !== s_req.length) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("LENGTH MISMATCH : MASTER=%0d SLAVE=%0d",m_req.length,s_req.length))
  end

  if(m_req.Hresetn !== s_req.Hresetn) begin
    match = 1'b0;
    `uvm_error("SB",$sformatf("HRESETN MISMATCH : MASTER=%0b SLAVE=%0b",m_req.Hresetn,s_req.Hresetn))
  end

  if(m_req.Hwrite) begin
    if(m_req.Hwdata !== s_req.Hwdata) begin
      match = 1'b0;
      `uvm_error("SB",$sformatf("HWDATA MISMATCH : MASTER=%08h SLAVE=%08h",m_req.Hwdata,s_req.Hwdata))
    end
  end
  else begin
    if(m_req.Hrdata !== s_req.Hrdata) begin
      match = 1'b0;
      `uvm_error("SB",$sformatf("HRDATA MISMATCH : MASTER=%08h SLAVE=%08h",m_req.Hrdata,s_req.Hrdata))
    end
  end

  if(m_req.Hready !== s_req.Hready) begin
                                                             match = 1'b0;
    `uvm_error("SB",$sformatf("HREADY MISMATCH : MASTER=%0b SLAVE=%0b",m_req.Hready,s_req.Hready))
  end

  if(match) begin
    matched_count++;
    data_verified_count++;
    `uvm_info("SB",$sformatf("MATCH : MASTER[%0d] <-> SLAVE[%0d] | HADDR=%08h",master_index,slave_index,m_req.Haddr),UVM_LOW)
  end
  else begin
    mismatched_count++;
    `uvm_error("SB",$sformatf("MISMATCH : MASTER[%0d] <-> SLAVE[%0d] | HADDR=%08h",master_index,slave_index,m_req.Haddr))
  end

endtask


// Report phase
function void sb::report_phase(uvm_phase phase);
  super.report_phase(phase);

  if(mismatched_count == 0) begin
    `uvm_info("SB","================ SCOREBOARD : PASS ================",UVM_NONE)
    `uvm_info("SB",$sformatf("MATCHED = %0d",matched_count),UVM_NONE)
    `uvm_info("SB",$sformatf("MISMATCHED = %0d",mismatched_count),UVM_NONE)
    `uvm_info("SB",$sformatf("DATA VERIFIED = %0d",data_verified_count),UVM_NONE)
    `uvm_info("SB",$sformatf("AHB MASTER COVERAGE = %0.2f%%",ahb_M_cg.get_coverage()),UVM_NONE)
    `uvm_info("SB",$sformatf("AHB SLAVE COVERAGE = %0.2f%%",ahb_S_cg.get_coverage()),UVM_NONE)
  end
  else begin
    `uvm_error("SB","================ SCOREBOARD : FAIL ================")
    `uvm_error("SB",$sformatf("MATCHED = %0d",matched_count))
    `uvm_error("SB",$sformatf("MISMATCHED = %0d",mismatched_count))
    `uvm_error("SB",$sformatf("DATA VERIFIED = %0d",data_verified_count))
  end

endfunction
                        
