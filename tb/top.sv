module top;

  import uvm_pkg::*;
  import test_pkg::*;

  bit clk = 0;

  // Interface instances
  intf m_if(clk);

  // Clock generation
  always #5 clk = ~clk;


  initial
  begin
    // Set virtual interface handles
    uvm_config_db #(virtual intf)::set(null,"*","m_if",m_if);

    run_test();
  end

endmodule

