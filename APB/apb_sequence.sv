///////////////////////////// Ashwin Alex George /////////////////////////////
/////////////////////////////// APB Sequence /////////////////////////////////

class apb_sequence extends uvm_sequence#(apb_sequence_item);
`uvm_object_utils(apb_sequence)

  apb_sequence_item req;

  function new(string name = "apb_sequence");
          super.new(name);
  endfunction

  task body();
      req = apb_sequence_item::type_id::create("req");

          repeat(`seq_size)
                  begin
                  start_item(req);
                  assert(req.randomize());
                  finish_item(req);
                  end
  endtask

endclass
