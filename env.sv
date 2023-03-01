///////////////////////////// Ashwin Alex George ////////////////////////////
///////////////////////////// AHB APB Environment ////////////////////////////

`include "ahb_seqitem.sv"
`include "apb_seqitem.sv"
`include "ahb_agent.sv"
`include "apb_agent.sv"
`include "scoreboard.sv"

class environment extends uvm_env;
  `uvm_component_utils(environment)

  ahb_agent ahb_agnt;
  apb_agent apb_agnt;
  scoreboard scb;

  extern function new(string name="environment", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
    
endclass
  
  //Constructor
  function environment::new(string name="environment", uvm_component parent=null);
      super.new(name,parent);
  endfunction
    
  //Build Phase
  function void environment::build_phase(uvm_phase phase);
      //Instances of Agents, Scoreboard are created
      ahb_agnt = ahb_agent::type_id::create("ahb_agnt",this);
      apb_agnt = apb_agent::type_id::create("apb_agnt",this);
      scb = scoreboard::type_id::create("scb",this);
  endfunction

  //Connect Phase
  function void environment::connect_phase(uvm_phase phase);
      //Monitors are connected with scoreboard
      ahb_agnt.hmonitor.ahb_ap.connect(scb.ahb_export);
      apb_agnt.pmonitor.apb_ap.connect(scb.apb_export);
  endfunction