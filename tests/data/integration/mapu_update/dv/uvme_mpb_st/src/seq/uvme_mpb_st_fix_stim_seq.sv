// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_FIX_STIM_SEQ_SV__
`define __UVME_MPB_ST_FIX_STIM_SEQ_SV__


/**
 * Fixed Stimulus: Runs read/write/read operations to address x0.
 * @ingroup uvme_mpb_st_seq_functional
 */
class uvme_mpb_st_fix_stim_seq_c extends uvme_mpb_st_base_seq_c;

   // pragma uvmx fix_stim_seq_fields begin
   // pragma uvmx fix_stim_seq_fields end


   `uvm_object_utils_begin(uvme_mpb_st_fix_stim_seq_c)
      // pragma uvmx fix_stim_seq_uvm_field_macros begin
      // pragma uvmx fix_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx fix_stim_seq_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      // ...
   }
   // pragma uvmx fix_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_fix_stim_seq");
      super.new(name);
   endfunction

   // pragma uvmx functional_fix_stim_seq_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_fix_stim_seq_build_dox end
   virtual function void build();
      // pragma uvmx functional_fix_stim_seq_build begin
      // pragma uvmx functional_fix_stim_seq_build end
   endfunction

   // pragma uvmx functional_fix_stim_seq_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_fix_stim_seq_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx functional_fix_stim_seq_create_sequences begin
      // pragma uvmx functional_fix_stim_seq_create_sequences end
   endfunction

   // pragma uvmx fix_stim_seq_post_randomize_work begin
   /**
    * TODO Implement or remove uvme_mpb_st_fix_stim_seq_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx fix_stim_seq_post_randomize_work end

   // pragma uvmx fix_stim_seq_body begin
   /**
    * Generates a read, write and readback on MAIN Agent sequencer.
    */
   virtual task body();
      uvm_reg_data_t  read_data;
      const int unsigned  gap_size = 5;
      `uvm_info("FIX_STIM_SEQ", "Starting read", UVM_MEDIUM)
      `uvmx_read_reg(read_data, "full")
      `uvm_info("FIX_STIM_SEQ", "Finished read", UVM_MEDIUM)
      `uvm_info("FIX_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before write", gap_size), UVM_MEDIUM)
      repeat (gap_size) cntxt.passive_agent_cntxt.clk();
      `uvm_info("FIX_STIM_SEQ", "Starting write", UVM_MEDIUM)
      `uvmx_write_reg("full", 'h1234_5678)
      `uvm_info("FIX_STIM_SEQ", "Finished write", UVM_MEDIUM)
      `uvm_info("FIX_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before readback", gap_size), UVM_MEDIUM)
      repeat (gap_size) cntxt.passive_agent_cntxt.clk();
      `uvm_info("FIX_STIM_SEQ", "Starting readback", UVM_MEDIUM)
      `uvmx_read_reg(read_data, "full")
      `uvm_info("FIX_STIM_SEQ", "Finished readback", UVM_MEDIUM)
   endtask
   // pragma uvmx fix_stim_seq_body end

   // pragma uvmx fix_stim_seq_methods begin
   // pragma uvmx fix_stim_seq_methods end

endclass


`endif // __UVME_MPB_ST_FIX_STIM_SEQ_SV__