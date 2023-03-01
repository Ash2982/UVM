///////////////////////////// Ashwin Alex George /////////////////////////////
/////////////////////////////// AHB APB Test /////////////////////////////////

class ahb_apb_test extends base_test;
`uvm_component_utils(ahb_apb_test)

  ahb_sequence hseq;
  apb_sequence pseq;
  uvm_active_passive_enum is_h_active;
  uvm_active_passive_enum is_p_active;
  
  extern function new(string name="ahb_apb_test", uvm_component parent=null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

      function ahb_apb_test::new(string name, uvm_component parent);
      super.new(name,parent);
      uvm_config_db #(uvm_active_passive_enum)::get(this,"","is_ahb_active",is_h_active);
      uvm_config_db #(uvm_active_passive_enum)::get(this,"","is_apb_active",is_p_active);
  endfunction

  function void ahb_apb_test::build_phase(uvm_phase phase);
      super.build_phase(phase);
  endfunction

  task ahb_apb_test::run_phase(uvm_phase phase);
      phase.raise_objection(this);

      if(is_h_active == UVM_ACTIVE)
          hseq = ahb_sequence::type_id::create("hseq",this);
      if(is_p_active == UVM_ACTIVE)
          pseq = apb_sequence::type_id::create("pseq",this);

      fork
          begin
              if(is_h_active == UVM_ACTIVE)
                  begin
                  hseq.start(env.ahb_agnt.hsequencer);
                  end
          end

          begin
              if(is_p_active == UVM_ACTIVE)
                  begin
                  pseq.start(env.apb_agnt.psequencer);
                  end
          end
      join
      phase.drop_objection(this);
  endtask