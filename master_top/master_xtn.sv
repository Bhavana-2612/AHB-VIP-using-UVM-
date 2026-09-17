
class master_xtn extends uvm_sequence_item;

  `uvm_object_utils(master_xtn)

  function new(string name = "master_xtn");
    super.new(name);
  endfunction

  bit        Hresetn;
  rand bit [1:0]  Htrans;
  rand bit [2:0]  Hburst;
  rand bit [2:0]  Hsize;  //32bit / 4 bytes
  rand bit [31:0] Haddr;
  rand bit [31:0] Hwdata;
  rand bit [9:0]  length;  //0 to 1023
  rand bit        Hwrite;

  bit             Hready;
  bit [31:0]      Hrdata;

  // Constraints
  constraint valid_size {
    Hsize inside {[0:2]};
  }

  constraint valid_addr {
    (Hsize == 1) -> (Haddr % 2 == 0);
    (Hsize == 2) -> (Haddr % 4 == 0);
  }

 
  constraint valid_burst {
    if(Hburst == 3'b000)
      length == 1;
    else if(Hburst == 3'b010 || Hburst == 3'b011)
      length == 4;
    else if(Hburst == 3'b100 || Hburst == 3'b101)
      length == 8;
    else if(Hburst == 3'b110 || Hburst == 3'b111)
      length == 16;
    else if(Hburst == 3'b001)
      length <= 1023;
  }

  // Print Method
  function void do_print(uvm_printer printer);
    super.do_print(printer);

//    printer.print_field("Hresetn", Hresetn, 1, UVM_DEC);
    printer.print_field("Htrans",  Htrans,  2, UVM_DEC);
    printer.print_field("Hburst",  Hburst,  3, UVM_DEC);
    printer.print_field("Hsize",   Hsize,   3, UVM_DEC);
    printer.print_field("Haddr",   Haddr,  32, UVM_HEX);
    printer.print_field("Hwdata",  Hwdata, 32, UVM_HEX);
    printer.print_field("Hrdata",  Hrdata, 32, UVM_HEX);
    printer.print_field("Hwrite",  Hwrite,  1, UVM_DEC);
    printer.print_field("Hready",  Hready,  1, UVM_DEC);
    printer.print_field("length",  length, 10, UVM_DEC);

  endfunction

endclass

 
