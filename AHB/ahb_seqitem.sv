///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////// AHB Sequence Item //////////////////////////////

class ahb_sequence_item extends uvm_sequence_item;

function new(string name = "ahb_sequence_item");
	super.new(name);
endfunction

rand logic [(`ADDR_WIDTH-1):0] 	HADDR;
rand logic 			HWRITE;
rand logic [(`DATA_WIDTH-1):0] 	HWDATA;
logic [(`DATA_WIDTH-1):0] 	HRDATA;

`uvm_object_utils_begin(ahb_sequence_item)
	`uvm_field_int(HADDR,UVM_ALL_ON)
	`uvm_field_int(HWRITE,UVM_ALL_ON)
	`uvm_field_int(HWDATA,UVM_ALL_ON)
	`uvm_field_int(HRDATA,UVM_ALL_ON)
`uvm_object_utils_end

endclass
