///////////////////////////// Ashwin Alex George ////////////////////////////
///////////////////////////// AHB APB Testbench /////////////////////////////

import uvm_pkg::*;

//Including files
`include "uvm_macros.svh"
`include "definitions.sv"
`include "ahb_interface.sv"
`include "apb_interface.sv"
`include "base_test.sv"
`include "test.sv"

//Top Module
module top_testbench;

logic HCLK,HRESETn,PCLK,PRESETn;

  //Clock Generation
  initial begin
      HCLK = 1'b1;
      forever
          begin
          #`hc_duration HCLK = ~HCLK;
          end
      end

  initial begin
      PCLK = 1'b1;
      forever
          begin
          #`pc_duration PCLK = ~PCLK;
          end
      end

  //Reset
  initial begin
      HRESETn = 1'b0;
      #`hr_duration 
      HRESETn = 1'b1;
      end

  initial begin
      PRESETn = 1'b0;
      #`pr_duration 
      PRESETn = 1'b1;
      end

  //Instantiation of Interface
  ahb_intf intf_ahb(HCLK,HRESETn);
  apb_intf intf_apb(PCLK,PRESETn);
  
  //Instantiation of DUT
  AHBLite_APB_Bridge DUT (.HRESETn (intf_ahb.HRESETn), 
			.HCLK(intf_ahb.HCLK), 
			.HSEL(intf_ahb.HSEL), 
			.HADDR(intf_ahb.HADDR), 
			.HWDATA(intf_ahb.HWDATA), 
			.HWRITE(intf_ahb.HWRITE),
			.HSIZE(intf_ahb.HSIZE), 
			.HBURST(intf_ahb.HBURST), 
			.HPROT(intf_ahb.HPROT), 
			.HTRANS(intf_ahb.HTRANS), 
			.HMASTERLOCK(intf_ahb.HMASTERLOCK), 
			.HREADYIN(intf_ahb.HREADYIN), 
			.HREADYOUT(intf_ahb.HREADYOUT), 
			.HRDATA(intf_ahb.HRDATA), 
			.HRESP(intf_ahb.HRESP),
			.PRESETn(intf_apb.PRESETn), 
			.PSEL(intf_apb.PSEL), 
			.PCLK(intf_apb.PCLK), 
			.PENABLE(intf_apb.PENABLE), 
            .PPROT(intf_apb.PPROT), 
			.PWRITE(intf_apb.PWRITE), 
			.PSTRB(intf_apb.PSTRB),
			.PADDR(intf_apb.PADDR), 
			.PWDATA(intf_apb.PWDATA), 
			.PRDATA(intf_apb.PRDATA), 
			.PREADY(intf_apb.PREADY), 
			.PSLVERR(intf_apb.PSLVERR));

  initial begin
    //Setting config data base
    uvm_config_db#(virtual ahb_intf)::set(uvm_root::get(),"*","vifh",intf_ahb);
    uvm_config_db#(virtual apb_intf)::set(uvm_root::get(),"*","vifp",intf_apb);
    uvm_config_db#(uvm_active_passive_enum)::set(uvm_root::get(),"*","is_ahb_active",UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(uvm_root::get(),"*","is_apb_active",UVM_ACTIVE);

    //Running test file
    //Add class name of test file in quotes
    run_test("ahb_apb_test");
  end

  //Wave file
  initial begin
      $dumpfile("ahb_apb.vcd");
      $dumpvars();
  end

endmodule