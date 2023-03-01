///////////////////////////// Ashwin Alex George /////////////////////////////
/////////////////////////////// AHB Sequence /////////////////////////////////

class ahb_sequence extends uvm_sequence#(ahb_sequence_item);
`uvm_object_utils(ahb_sequence)

function new(string name = "ahb_sequence");
	super.new(name);
endfunction

task body();
ahb_sequence_item req;
req=ahb_sequence_item::type_id::create("req");
	repeat(`seq_size)
		begin 
		start_item(req);
		assert (req.randomize() with {req.HADDR%16 == 0;});
		finish_item(req);
		end
endtask

endclass
