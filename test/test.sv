class test extends uvm_test;

  `uvm_component_utils(test)

  int no_of_masters = 1;
  int no_of_slaves  = 1;

  bit has_master_agt = 1;
  bit has_slave_agt  = 1;
  bit has_sb         = 1;

  master_cfg m_cfg[];
  slave_cfg  s_cfg[];

  env_cfg e_cfg;
  env envh;

  virtual intf vif;


  function new(string name = "test",uvm_component parent);
    super.new(name,parent);
  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    e_cfg = env_cfg::type_id::create("e_cfg");

    e_cfg.no_of_masters = no_of_masters;
    e_cfg.no_of_slaves  = no_of_slaves;

    e_cfg.has_master_agt = has_master_agt;
    e_cfg.has_slave_agt  = has_slave_agt;
    e_cfg.has_sb         = has_sb;


  e_cfg.m_cfg = new[no_of_masters];
    e_cfg.s_cfg = new[no_of_slaves];

    m_cfg = new[no_of_masters];
    s_cfg = new[no_of_slaves];

    if(!uvm_config_db#(virtual intf)::get(this,"","m_if",vif))
      `uvm_fatal("TEST","CANT GET INTERFACE IN TEST")


    if(has_master_agt)
    begin

      foreach(m_cfg[i])
      begin

        m_cfg[i] = master_cfg::type_id::create(
                    $sformatf("m_cfg[%0d]",i));

        m_cfg[i].is_active = UVM_ACTIVE;
        m_cfg[i].m_if      = vif;

        e_cfg.m_cfg[i] = m_cfg[i];

      end

    end

    if(has_slave_agt)
    begin

      foreach(s_cfg[i])
      begin

        s_cfg[i] = slave_cfg::type_id::create( $sformatf("s_cfg[%0d]",i));

        s_cfg[i].is_active = UVM_ACTIVE;
        s_cfg[i].s_if      = vif;

        e_cfg.s_cfg[i] = s_cfg[i];

                                              end

    end


    // Pass e_cfg to environment

    uvm_config_db#(env_cfg)::set(this,"*","e_cfg",e_cfg);

    envh = env::type_id::create("envh",this);

  endfunction

endclass

///////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////TESTCASES/////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////

//single okay
class single_okay_test extends test;

  `uvm_component_utils(single_okay_test)

  m_seq1     mseq;
  s_seq_okay sseq;

  function new(string name = "single_okay_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq1::type_id::create("mseq");
    sseq = s_seq_okay::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);
                                                                     begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass

//single wait
class single_wait_test extends test;

  `uvm_component_utils(single_wait_test)

  m_seq1          mseq;
  s_seq_okay_wait sseq;

  function new(string name = "single_okay_wait_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq1::type_id::create("mseq");
    sseq = s_seq_okay_wait::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

 join
   #20;
    phase.drop_objection(this);

  endtask

endclass

//single error
class single_error_test extends test;

  `uvm_component_utils(single_error_test)

  m_seq1      mseq;
  s_seq_error sseq;

  function new(string name = "single_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq1::type_id::create("mseq");
    sseq = s_seq_error::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask
                                       endclass
//incr okay
class incr_okay_test extends test;

  `uvm_component_utils(incr_okay_test)

  m_seq2     mseq;
  s_seq_okay sseq;

  function new(string name = "incr_okay_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq2::type_id::create("mseq");
    sseq = s_seq_okay::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass

//incr wait
class incr_wait_test extends test;

  `uvm_component_utils(incr_wait_test)
                                                                m_seq2          mseq;
  s_seq_okay_wait sseq;

  function new(string name = "incr_okay_wait_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq2::type_id::create("mseq");
    sseq = s_seq_okay_wait::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass

//incr error
class incr_error_test extends test;

  `uvm_component_utils(incr_error_test)

  m_seq2      mseq;
  s_seq_error sseq;

  function new(string name = "incr_error_test", uvm_component parent);
    super.new(name, parent);
                                             endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq2::type_id::create("mseq");
    sseq = s_seq_error::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass
//wrap okay
class wrap_okay_test extends test;

  `uvm_component_utils(wrap_okay_test)

  m_seq3     mseq;
  s_seq_okay sseq;

  function new(string name = "wrap_okay_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

                                                mseq = m_seq3::type_id::create("mseq");
    sseq = s_seq_okay::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass



//wrap wait

class wrap_wait_test extends test;

  `uvm_component_utils(wrap_wait_test)

  m_seq3          mseq;
  s_seq_okay_wait sseq;

  function new(string name = "wrap_okay_wait_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq3::type_id::create("mseq");
    sseq = s_seq_okay_wait::type_id::create("sseq");
                                                                     fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);

      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass


//wrap error
class wrap_error_test extends test;

  `uvm_component_utils(wrap_error_test)

  m_seq3      mseq;
  s_seq_error sseq;

  function new(string name = "wrap_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    mseq = m_seq3::type_id::create("mseq");
    sseq = s_seq_error::type_id::create("sseq");

    fork

      mseq.start(envh.m_agt_toph.m_agth[0].m_seqrh);


      begin
        #20;
        sseq.start(envh.s_agt_toph.s_agth[0].s_seqrh);
      end

    join

    phase.drop_objection(this);

  endtask

endclass
                
