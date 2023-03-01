///////////////////////////// Ashwin Alex George /////////////////////////////
///////////////////////////// AHB APB Scoreboard ////////////////////////////

`uvm_analysis_imp_decl(_ahb)
`uvm_analysis_imp_decl(_apb)
//Allows for a scoreboard to support input from many places

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  //Receives all transactions broadcasted by both "ahb_ap" and "apb_ap" (Analysis ports) with handles "ahb_export" and "apb_export"
  uvm_analysis_imp_ahb #(ahb_sequence_item, scoreboard) ahb_export;
  uvm_analysis_imp_apb #(apb_sequence_item, scoreboard) apb_export;

  //queue handle created for each sequence_item
  ahb_sequence_item ahb_seqitem_q[$];
  apb_sequence_item apb_seqitem_q[$];
  
  integer i;
  
  extern function new(string name="scoreboard", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern function void write_ahb (ahb_sequence_item ahb_item);
  extern function void write_apb (apb_sequence_item apb_item);
  extern function void compare(ahb_sequence_item exp, apb_sequence_item rcvd);
  extern function void report_phase(uvm_phase phase);
 
endclass
  
  //Constructor
  function scoreboard::new(string name="scoreboard", uvm_component parent);
      super.new(name,parent);
  endfunction : new
  
  //Build Phase
  function void scoreboard::build_phase(uvm_phase phase);
    ahb_export = new("ahb_export",this);
    apb_export = new("apb_export",this);
  endfunction : build_phase

  //Write function used in ahb_monitor
  function void scoreboard::write_ahb (ahb_sequence_item ahb_item);
      //Pushing ahb_item to queue
      ahb_seqitem_q.push_back(ahb_item);
  endfunction : write_ahb
  
  //Write function used in ahb_monitor
  function void scoreboard::write_apb (apb_sequence_item apb_item);
      //Pushing ahb_item to queue
      apb_seqitem_q.push_back(apb_item);
  endfunction : write_apb
  
  function void scoreboard::compare(ahb_sequence_item exp, apb_sequence_item rcvd);
      	if(exp.HADDR == rcvd.PADDR)
        `uvm_info("ADDRESS", $sformatf("Match Success (exp =%h rcvd=%h)", exp.HADDR, rcvd.PADDR), UVM_LOW)
      else
        `uvm_error("ADDRESS", $sformatf("Mis-match (exp =%h rcvd=%h)", exp.HADDR, rcvd.PADDR))
        
        if(exp.HWRITE == rcvd.PWRITE)
          `uvm_info("Read/Write", $sformatf("Match Success (exp =%h rcvd=%h)", exp.HWRITE, rcvd.PWRITE), UVM_LOW)
      else
        `uvm_error("Read/Write", $sformatf("Mis-match (exp =%h rcvd=%h)", exp.HWRITE, rcvd.PWRITE))

        if(exp.HWDATA == rcvd.PWDATA)begin
          if(exp.HWRITE == 1 && rcvd.PWRITE == 1)begin
            `uvm_info("WRITE", $sformatf("HWRITE = %h ,PWRITE = %h",exp.HWRITE, rcvd.PWRITE), UVM_LOW)
            `uvm_info("WDATA", $sformatf("Match Success (exp =%h rcvd=%h)\n", exp.HWDATA, rcvd.PWDATA), UVM_LOW)
          end
      else
        `uvm_error("WDATA", $sformatf("Mis-match (exp =%h rcvd=%h)\n", exp.HWDATA, rcvd.PWDATA))
        end

        if(exp.HRDATA == rcvd.PRDATA)begin
          if(exp.HWRITE == 0 && rcvd.PWRITE == 0)begin
            `uvm_info("READ", $sformatf("HWRITE = %h ,PWRITE = %h",exp.HWRITE, rcvd.PWRITE), UVM_LOW)
            `uvm_info("RDATA", $sformatf("Match Success (exp =%h rcvd=%h)\n", exp.HRDATA, rcvd.PRDATA), UVM_LOW)
          end
      else
        `uvm_error("RDATA", $sformatf("Mis-match (exp =%h rcvd=%h)\n", exp.HRDATA, rcvd.PRDATA))
        end
  endfunction : compare

  //Report Phase
  function void scoreboard::report_phase(uvm_phase phase);
      i=0;

      while(i<`seq_size)
          begin
            //Comparing items recieved from ahb_monitor and apb_monitor 
              compare (ahb_seqitem_q[i],apb_seqitem_q[i]);
              i++;
          end
  endfunction : report_phase