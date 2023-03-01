///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////////// AHB Agent //////////////////////////////////

`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "ahb_monitor.sv"

class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)

  ahb_driver hdriver;
  ahb_sequencer hsequencer;
  ahb_monitor hmonitor;

  extern function new(string name="ahb_agent", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass
    
  function ahb_agent::new(string name, uvm_component parent);
      super.new(name,parent);
      uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_ahb_active",is_active);
  endfunction

  function void ahb_agent::build_phase(uvm_phase phase);
      if(is_active == UVM_ACTIVE)
      begin
          //Instance of driver and sequencer created
          hdriver = ahb_driver::type_id::create("hdriver",this);
          hsequencer = ahb_sequencer::type_id::create("hsequencer",this);
      end
    	  //Instance of monitor
      	  hmonitor = ahb_monitor::type_id::create("hmonitor",this);
  endfunction

  function void ahb_agent::connect_phase(uvm_phase phase);
      if(is_active == UVM_ACTIVE)
      begin
          //Connect sequencer and driver
          hdriver.seq_item_port.connect(hsequencer.seq_item_export);
      end
  endfunction