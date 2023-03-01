///////////////////////////// Ashwin Alex George /////////////////////////////
//////////////////////////////// AHB Monitor /////////////////////////////////

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)

  //Virtual interface and sequence item declaration
  virtual ahb_intf vif;
  ahb_sequence_item seq;
  
  //Analysis port created with name "ahb_ap" that can broadcast "ahb_sequence_item"
  uvm_analysis_port #(ahb_sequence_item) ahb_ap;
  
  extern function new(string name="ahb_monitor", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
        
endclass
    
  function ahb_monitor::new(string name, uvm_component parent);
      super.new(name,parent);
    ahb_ap = new("ahb_ap", this);
  endfunction

  //Build_phase
  function void ahb_monitor::build_phase (uvm_phase phase);
      `uvm_info("ID","Build_phase of monitor",UVM_HIGH)
      //Getting virtual interface instance from "top"
      if(!uvm_config_db #(virtual ahb_intf)::get(this,"","vifh",vif)) 
       `uvm_fatal("NO_VIFH_MONITOR","Virtual interface must be set")
  endfunction

  //run_phase
  task ahb_monitor::run_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("ID","Run_phase of monitor",UVM_HIGH)
      repeat(`seq_size)
        begin
          seq=ahb_sequence_item::type_id::create("seq");
          
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

         //Addr and R/W opertion info sent from interface to seqitem of monitor
         @(posedge vif.HCLK);
         seq.HADDR = vif.HADDR;
         seq.HWRITE = vif.HWRITE;

         @(posedge vif.HCLK);
         //Write
         if(vif.HWRITE)
          begin
            seq.HWDATA = vif.HWDATA;
          end
            
		 //Read
         else
          begin
            fork
              begin
                  wait(vif.HREADYOUT == 1 && vif.HRESP ==0);
              end
              begin
                  repeat(16) @(posedge vif.HCLK);
              end
            join_any
            disable fork;
            seq.HRDATA = vif.HRDATA;
          end
		  //Sending the packet "seq" to other components (scoreboard here) via analysis port write method()
          ahb_ap.write(seq);
        end
        `uvm_info ("ID","AHB monitor completed",UVM_MEDIUM)
        phase.drop_objection(this);

  endtask