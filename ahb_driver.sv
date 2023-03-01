///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////////// AHB Driver /////////////////////////////////

class ahb_driver extends uvm_driver#(ahb_sequence_item);
  `uvm_component_utils(ahb_driver)
  
  ahb_sequence_item req;
  virtual ahb_intf vif;
  
  extern function new(string name="ahb_driver", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive();

endclass

	//Construtor
      function ahb_driver::new(string name, uvm_component parent);
          super.new(name,parent);
      endfunction

	//Build_phase
      function void ahb_driver::build_phase(uvm_phase phase);
          `uvm_info("ID","Build_phase of AHB driver",UVM_HIGH)
          if(!uvm_config_db #(virtual ahb_intf)::get(this,"","vifh",vif)) 
           `uvm_fatal("NO_VIFH_DRIVER","Virtual interface must be set")
           req= ahb_sequence_item::type_id::create("AHB_SEQ_ITEM",this);
      endfunction

	//run_phase
      task ahb_driver::run_phase(uvm_phase phase);
          `uvm_info("ID","Run_phase of AHB driver",UVM_HIGH)
        repeat(`seq_size)
            begin
              seq_item_port.get_next_item(req);
              drive();
              seq_item_port.item_done();
            end
      endtask

	//drive
      task ahb_driver::drive();
	  @(posedge vif.HCLK);
	  fork
	    begin
		wait(vif.HREADYOUT == 1 && vif.HRESP ==0);
	    end
	    begin
		repeat(16) @(posedge vif.HCLK);
	    end
	  join_any
	  disable fork;

      vif.HSIZE = 3'b010; // 32 bit word
      vif.HBURST = 3'b000; // single burst
      vif.HTRANS = 2'b10; //non-sequential
      vif.HSEL = 1'b1; //default slave selection
      vif.HREADYIN = 1'b1; // 1 - Indicates the previous trasfer is completed
      vif.HMASTERLOCK = 1'b0; //0 - non locking sequence transfer
      vif.HPROT = 4'b0011; //The Manager sets HPROT to 0b0011 to correspond to a Non-cacheable, Non-bufferable, privileged, data access

      vif.HWRITE = req.HWRITE;
      vif.HADDR = req.HADDR;

	  @(posedge vif.HCLK);

		//Write
		if (vif.HWRITE)
		  begin 
		    vif.HWDATA = req.HWDATA;
            `uvm_info("AHB2APB",$sformatf("WRITE OPERATION (Transmitted) --> addr = %h data = %h", req.HADDR, req.HWDATA), UVM_MEDIUM)
		  end
  		
        if(!vif.HWRITE)
		//Read
		begin
          //Wait for 16 cycles or "HREADYOUT" to be 1 and "HRESP" to be 0
          //Every slave must have a predetermined maximum number of wait states that it will insert before it backs off the bus
          fork
	        begin
	    	    wait(vif.HREADYOUT == 1 && vif.HRESP ==0);
	        end

	        begin
		        repeat(16) @(posedge vif.HCLK);
	        end
	      join_any
	      disable fork;
		req.HRDATA = vif.HRDATA;
            `uvm_info("APB2AHB",$sformatf("READ OPERATION (Received) from addr: %h  --> data = %h",req.HADDR,req.HRDATA),UVM_MEDIUM)
		end
		`uvm_info("ID","AHB_DRIVER completed driving",UVM_MEDIUM)
endtask