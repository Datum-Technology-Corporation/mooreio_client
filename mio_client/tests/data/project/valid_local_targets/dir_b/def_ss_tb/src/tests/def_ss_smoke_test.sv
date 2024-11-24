class def_ss_smoke_test_c extends uvm_test;

  bit  sample_bit = 0;

  covergroup test_cg;
    coverpoint sample_bit;
  endgroup

  `uvm_component_utils(def_ss_smoke_test_c)
  
  function new(string name="def_ss_smoke_test", uvm_component parent=null);
    super.new(name, parent);
    test_cg = new();
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    int unsigned  data_width, my_number;
    if ($value$plusargs("MY_NUMBER=%0d", my_number)) begin
      `uvm_info("TB", $sformatf("My number is %0d", my_number), UVM_NONE)
    end
    data_width = `DATA_WIDTH;
    `uvm_info("TB", $sformatf("DATA_WIDTH is %0d", data_width), UVM_NONE)
    `ifdef ABC_BLOCK_ENABLED
      `uvm_info("TB", "ABC_BLOCK_ENABLED is true", UVM_NONE)
    `endif
    test_cg.sample();
    sample_bit = 1;
    test_cg.sample();
  endtask
endclass