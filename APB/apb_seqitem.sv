///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////// APB Sequence Item //////////////////////////////

class apb_sequence_item extends uvm_sequence_item;
  
  //Constructor
  function new(string name = "apb_sequence_item");
          super.new(name);
  endfunction
  
  logic [(`ADDR_WIDTH-1):0]       PADDR;
  logic                           PWRITE;
  logic [(`DATA_WIDTH-1):0]       PWDATA;
  rand logic[(`DATA_WIDTH-1):0]   PRDATA;

  `uvm_object_utils_begin(apb_sequence_item)
          `uvm_field_int(PADDR,UVM_ALL_ON)
          `uvm_field_int(PWRITE,UVM_ALL_ON)
          `uvm_field_int(PWDATA,UVM_ALL_ON)
          `uvm_field_int(PRDATA,UVM_ALL_ON)
  `uvm_object_utils_end

endclass
