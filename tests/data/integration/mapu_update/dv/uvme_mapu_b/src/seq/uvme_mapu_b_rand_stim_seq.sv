// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_RAND_STIM_SEQ_SV__
`define __UVME_MAPU_B_RAND_STIM_SEQ_SV__


/**
 * Sequence for test 'rand_stim'.
 * @ingroup uvme_mapu_b_seq_functional
 */
class uvme_mapu_b_rand_stim_seq_c extends uvme_mapu_b_base_seq_c;

   /// @name Knobs
   /// @{
   rand int unsigned  num_items; ///< Number of sequence items to be generated.
   rand int unsigned  min_gap  ; ///< Minimum number of cycles between items.
   rand int unsigned  max_gap  ; ///< Maximum number of cycles between items.
   /// @}

   // pragma uvmx rand_stim_seq_fields begin
   // pragma uvmx rand_stim_seq_fields end


   `uvm_object_utils_begin(uvme_mapu_b_rand_stim_seq_c)
      // pragma uvmx rand_stim_seq_uvm_field_macros begin
      `uvm_field_int(num_items, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(min_gap  , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(max_gap  , UVM_DEFAULT + UVM_DEC)
      // pragma uvmx rand_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Describes randomization space for knobs.
    */
   constraint space_cons {
      max_gap inside {['d0:'d10]};
      min_gap inside {['d0:max_gap]};
   }

   // pragma uvmx rand_stim_seq_constraints begin
   // pragma uvmx rand_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_rand_stim_seq");
      super.new(name);
      // pragma uvmx rand_stim_seq_constructor begin
      // pragma uvmx rand_stim_seq_constructor end
   endfunction

   /**
    * Generates #num_items of random stimulus.
    */
   virtual task body();
      // pragma uvmx rand_stim_seq_body begin
      uvma_mapu_b_seq_item_c  seq_item;
      int unsigned  gap_size;
      for (int unsigned ii=0; ii<num_items; ii++) begin
         gap_size = $urandom_range(min_gap, max_gap);
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before item %0d/%0d", gap_size, (ii+1), num_items), UVM_HIGH)
         clk(gap_size);
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Starting item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_MEDIUM)
         legal_item();
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Finished item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_HIGH)
      end
      // pragma uvmx rand_stim_seq_body end
   endtask

   // pragma uvmx rand_stim_seq_methods begin
   // pragma uvmx rand_stim_seq_methods end

endclass


`endif // __UVME_MAPU_B_RAND_STIM_SEQ_SV__