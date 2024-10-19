class g_smoke_test_c extends uvm_test;
  `uvm_component_utils(g_smoke_test_c)
  
  function new(string name="g_smoke_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TEST", "Hello, World!", UVM_NONE)
  endtask
endclass
