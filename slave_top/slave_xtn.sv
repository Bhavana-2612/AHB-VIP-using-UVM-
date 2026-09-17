class slave_xtn extends uvm_sequence_item;

  `uvm_object_utils(slave_xtn)

  function new(string name = "slave_xtn");
    super.new(name);
  endfunction

  rand  bit        Hresetn;
  rand bit [1:0]  Htrans;
  rand bit [2:0]  Hburst;
  rand bit [2:0]  Hsize;
  rand bit [31:0] Haddr;
  rand bit [31:0] Hwdata;
  rand bit [9:0]  length;
  rand bit        Hwrite;

  bit             Hready;
  bit [1:0]       Hresp;
  bit [31:0]      Hrdata;

  rand int unsigned  wait_cycles;
  bit              had_wait;

  typedef enum {okay,okay_wait,error} resp_type;
  rand resp_type resp;

  constraint wait_range {
    wait_cycles inside {[0:5]};
  }

  function void do_print(uvm_printer printer);
    super.do_print(printer);

    printer.print_field("Hresetn",Hresetn,1,UVM_DEC);
    printer.print_field("Htrans",Htrans,2,UVM_DEC);
    printer.print_field("Hburst",Hburst,3,UVM_DEC);
    printer.print_field("Hsize",Hsize,3,UVM_DEC);
    printer.print_field("Haddr",Haddr,32,UVM_HEX);
    printer.print_field("Hwdata",Hwdata,32,UVM_HEX);
    printer.print_field("Hrdata",Hrdata,32,UVM_HEX);
  printer.print_field("Hwrite",Hwrite,1,UVM_DEC);
    printer.print_field("Hready",Hready,1,UVM_DEC);
    printer.print_field("Hresp",Hresp,2,UVM_DEC);
    printer.print_field("length",length,10,UVM_DEC);
    printer.print_field("wait_cycles",wait_cycles,10,UVM_DEC);
    printer.print_field("had_wait",had_wait,1,UVM_DEC);

  endfunction

endclass
                 
