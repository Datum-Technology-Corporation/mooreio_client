// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_FIX_STIM_SEQ_SV__
`define __UVME_MAPU_B_FIX_STIM_SEQ_SV__


/**
 * Sequence for test 'fix_stim'.
 * @ingroup uvme_mapu_b_seq_functional
 */
class uvme_mapu_b_fix_stim_seq_c extends uvme_mapu_b_base_seq_c;

   // pragma uvmx fix_stim_seq_fields begin
   // pragma uvmx fix_stim_seq_fields end
   

   `uvm_object_utils_begin(uvme_mapu_b_fix_stim_seq_c)
      // pragma uvmx fix_stim_seq_uvm_field_macros begin
      // pragma uvmx fix_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx fix_stim_seq_constraints begin
   // pragma uvmx fix_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_fix_stim_seq");
      super.new(name);
      // pragma uvmx fix_stim_seq_constructor begin
      // pragma uvmx fix_stim_seq_constructor end
   endfunction

   /**
    * TODO Describe uvme_mapu_b_fix_stim_seq_c::body()
    */
   virtual task body();
      // pragma uvmx fix_stim_seq_body begin
      uvma_mapu_b_seq_item_c  seq_item;
      // TODO Implement uvme_mapu_b_fix_stim_seq_c::body()
      //      Ex: `uvmx_create_on(seq_item, agent_sequencer)
      //          `uvmx_rand_send_with(seq_item, {
      //             abc == 123;
      //          })
      // pragma uvmx fix_stim_seq_body end
   endtask

   // pragma uvmx fix_stim_seq_methods begin
   // pragma uvmx fix_stim_seq_methods end

endclass


`endif // __UVME_MAPU_B_FIX_STIM_SEQ_SV__