///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////////// APB Agent //////////////////////////////////

`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

  apb_driver pdriver;
  apb_monitor pmonitor;
  apb_sequencer psequencer;
  
  extern function new(string name="apb_agent", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass

  function apb_agent::new(string name, uvm_component parent);
      super.new(name,parent);
      uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_apb_active",is_active);
  endfunction

  function void apb_agent::build_phase(uvm_phase phase);
      if(is_active == UVM_ACTIVE)
          begin
              pdriver = apb_driver::type_id::create("pdriver",this);
              psequencer = apb_sequencer::type_id::create("psequencer",this);
          `uvm_info("ID","APB sequencer and driver instance created",UVM_MEDIUM)
          end
              pmonitor = apb_monitor::type_id::create("pmonitor",this);
          `uvm_info("ID","APB monitor instance created",UVM_MEDIUM)
  endfunction

  function void apb_agent::connect_phase(uvm_phase phase);
  if(is_active == UVM_ACTIVE)
      begin
          pdriver.seq_item_port.connect(psequencer.seq_item_export);
      `uvm_info("ID","APB sequencer and driver are connected",UVM_MEDIUM)
      end
  endfunction
