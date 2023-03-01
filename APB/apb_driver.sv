///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////////// APB Driver /////////////////////////////////

class apb_driver extends uvm_driver #(apb_sequence_item);
  `uvm_component_utils(apb_driver)

  //Virtual interface and sequence item declaration
  apb_sequence_item req;
  virtual apb_intf vif;
  
  extern function new(string name="apb_driver", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive();

endclass
	
  //Constructor
  function apb_driver::new(string name, uvm_component parent);
      super.new(name,parent);
  endfunction

  //Build Phase
  function void apb_driver::build_phase(uvm_phase phase);
      `uvm_info("ID","Build phase of apb_driver",UVM_HIGH)
      if(!uvm_config_db #(virtual apb_intf) :: get(this, "","vifp", vif))
      `uvm_fatal ("NO_VIF", " Virtual interface not set for apb_driver")
      req = apb_sequence_item::type_id::create("apb_seqitem",this);
  endfunction

  //Run Phase
  task apb_driver::run_phase (uvm_phase phase);
    repeat(`seq_size)
          begin 
            seq_item_port.get_next_item(req);
            drive();
            seq_item_port.item_done();
          end
      `uvm_info("ID", "APB driving completed", UVM_MEDIUM)
  endtask

  //Drive Task
  task apb_driver::drive();
      vif.PSLVERR = 1'b0;
      vif.PREADY = 1;
      req.PADDR = vif.PADDR;

      //Write
      @(posedge vif.PCLK);
      if (vif.PWRITE) 
          begin
            @(posedge vif.PCLK);
            req.PWDATA = vif.PWDATA;
            `uvm_info("AHB2APB", $sformatf("RECEIVED (Write operation) - addr = %h data = %h", req.PADDR, req.PWDATA),UVM_MEDIUM)
          end

      // Read
     @(posedge vif.PCLK);
       wait (vif.PSEL);
     if(!vif.PWRITE)
          begin
            @(posedge vif.PCLK);
            wait(vif.PENABLE);
            vif.PRDATA = req.PRDATA;
            `uvm_info ("APB2AHB",$sformatf("TRANSMITTED (Read operation) - data = %h", req.PRDATA) , UVM_MEDIUM)
          end
    `uvm_info("ID","APB_DRIVER completed driving",UVM_MEDIUM)
  endtask