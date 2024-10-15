class def_ss_smoke_test_c extends uvm_test;
  `uvm_component_utils(def_ss_smoke_test_c)
  
  function new(string name="def_ss_smoke_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    int lucky_number;
    `uvm_info("TB", $sformatf("Hello, World! DATA_WIDTH=%0d", `DATA_WIDTH), UVM_NONE)
    `ifdef ABC_BLOCK_ENABLED
    `uvm_info("TB", "ABC_BLOCK is enabled", UVM_NONE)
    `endif
    if ($test$plusargs("INCLUDE_SECOND_MESSAGE") && $value$plusargs("LUCKY_NUMBER=%0d", lucky_number)) begin
      `uvm_info("TB", $sformatf("Your lucky number is %0d", lucky_number), UVM_NONE)
    end
  endtask
endclass