///////////////////////////// Ashwin Alex George /////////////////////////////
//////////////////////////////// APB Monitor /////////////////////////////////

class apb_monitor extends uvm_monitor;
`uvm_component_utils (apb_monitor)
  
  //Virtual interface and sequence item declaration
  virtual apb_intf vif;
  apb_sequence_item seq;
  
  //Analysis port created with name "apb_ap" that can broadcast "apb_sequence_item"
  uvm_analysis_port #(apb_sequence_item) apb_ap;
  
  extern function new(string name="apb_driver", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  endclass
  
  //Constructor
  function apb_monitor::new(string name, uvm_component parent);
      super.new(name,parent);
    apb_ap = new("apb_ap", this);
  endfunction
    
  //Build Phase
  function void apb_monitor::build_phase(uvm_phase phase);
      `uvm_info("ID","Build phase of apb_monitor",UVM_HIGH)
      //Getting virtual interface instance from "top"
      if(!uvm_config_db #(virtual apb_intf) :: get(this, "","vifp", vif))
        `uvm_fatal ("NO_VIF_MONITOR", " Virtual interface not set for apb_driver")
  endfunction

  //Run Phase
  task apb_monitor::run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("ID", "RUN_PHASE of apb_monitor",UVM_HIGH)

      repeat(`seq_size)
        begin
          seq = apb_sequence_item::type_id::create("seq");

          @(posedge vif.PCLK);
              wait(vif.PSEL);
          
          //Addr and R/W opertion info sent from interface to seqitem of monitor
          @(posedge vif.PCLK);
              seq.PWRITE = vif.PWRITE;
              seq.PADDR = vif.PADDR;
          
          @(posedge vif.PCLK);
		  //Write
          if (vif.PWRITE)
              begin
                seq.PWDATA = vif.PWDATA;
                @(posedge vif.PCLK);
                wait(vif.PENABLE);
              end

          //Read 
          else
              begin
                @(posedge vif.PCLK);
                wait(vif.PENABLE); 
                seq.PRDATA = vif.PRDATA;
              end
          //Sending the packet "seq" to other components (scoreboard here) via analysis port write method()
          apb_ap.write(seq);
        end

    `uvm_info ("ID","APB monitoring completed",UVM_MEDIUM)
      phase.drop_objection(this);
  endtask