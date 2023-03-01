///////////////////////////// Ashwin Alex George ////////////////////////////
///////////////////////////// AHB APB Base Test /////////////////////////////

`include "env.sv"
`include "ahb_sequence.sv"
`include "apb_sequence.sv"

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  environment env;
  
  //Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //Build Phase
  function void build_phase (uvm_phase phase);
    `uvm_info("ID","Build phase of base test",UVM_HIGH)
    env = environment::type_id::create("env", this);
  endfunction

endclass