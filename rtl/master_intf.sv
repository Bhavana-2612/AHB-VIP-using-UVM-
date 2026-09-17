interface intf (input bit clk);

        logic Hresetn;
        bit   [1:0] Htrans;
        logic [2:0] Hsize;
        logic [1:0] Hresp;
        logic [31:0]Haddr;
        logic [31:0]Hwdata;
        logic [2:0] Hburst;
        logic [31:0] Hrdata;
        logic [9:0] length;
        bit Hwrite;
        bit Hready;
        bit [1:0] resp;

clocking master_drv_cb@(posedge clk);
        default input #1 output #0;

        output Hresetn;
        output Htrans;
        output Hsize;
        output length;
        input Hresp;
        output Haddr;
        output Hwdata;
        output Hburst;
        input Hrdata;
        output Hwrite;
        input Hready;
endclocking

clocking master_mon_cb@(posedge clk);
        default input #1 output #0;

        input Hresetn;
        input Htrans;
        input Hsize;
        input length;
        input Hresp;
        input Haddr;
        input Hwdata;
        input Hburst;
        input Hrdata;
        input Hwrite;
        input Hready;
endclocking

clocking slave_drv_cb @(posedge clk);
        default input #1 output #0;

        input Hresetn;
        input Htrans;
        input Hsize;
        input length;
        output Hresp;
        input Haddr;
        input Hwdata;
        input Hburst;
        output Hrdata;
        input Hwrite;
        output Hready;
        output resp;
endclocking


clocking slave_mon_cb @(posedge clk);
        default input #1 output #0;

        input Hresetn;
        input Htrans;
        input Hsize;
        input length;
        input Hresp;
        input Haddr;
        input Hwdata;
        input Hburst;
        input Hrdata;
        input Hwrite;
        input Hready;
        input resp;
endclocking


modport M_DRV_MP (clocking master_drv_cb);
modport M_MON_MP (clocking master_mon_cb);
modport S_DRV_MP (clocking slave_drv_cb);
modport S_MON_MP (clocking slave_mon_cb);

endinterface

