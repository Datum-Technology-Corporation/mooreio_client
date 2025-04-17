// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_RAND_STIM_SEQ_SV__
`define __UVME_MAPU_B_RAND_STIM_SEQ_SV__


/**
 * Random Stimulus: Generates random valid stimulus.
 * @ingroup uvme_mapu_b_seq_functional
 */
class uvme_mapu_b_rand_stim_seq_c extends uvme_mapu_b_base_seq_c;

   /// @name Random Fields
   /// @{
   rand int unsigned  num_items; ///< Number of items
   rand int unsigned  min_gap; ///< Minimum gap
   rand int unsigned  max_gap; ///< Maximum gap
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
    * Sets randomization space for random fields.
    */
   constraint space_cons {
      num_items inside {[1:100]};
      min_gap inside {[0:100]};
      max_gap inside {[0:100]};
   }

   // pragma uvmx rand_stim_seq_constraints begin
   /**
    * Limits randomization space.
    */
   constraint limits_cons {
      min_gap <= max_gap;
   }
   // pragma uvmx rand_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_rand_stim_seq");
      super.new(name);
   endfunction

   // pragma uvmx functional_rand_stim_seq_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_rand_stim_seq_build_dox end
   virtual function void build();
      // pragma uvmx functional_rand_stim_seq_build begin
      // pragma uvmx functional_rand_stim_seq_build end
   endfunction

   // pragma uvmx functional_rand_stim_seq_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_rand_stim_seq_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx functional_rand_stim_seq_create_sequences begin
      // pragma uvmx functional_rand_stim_seq_create_sequences end
   endfunction

   // pragma uvmx rand_stim_seq_post_randomize_work begin
   // pragma uvmx rand_stim_seq_post_randomize_work end

   // pragma uvmx rand_stim_seq_body begin
   /**
    * TODO Describe uvme_mapu_b_rand_stim_seq_c::body()
    */
   virtual task body();
      uvma_mapu_b_op_seq_item_c  seq_item;
      int unsigned  gap_size;
      for (int unsigned ii=0; ii<num_items; ii++) begin
         gap_size = $urandom_range(min_gap, max_gap);
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before item %0d/%0d", gap_size, (ii+1), num_items), UVM_HIGH)
         clk(gap_size);
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Starting item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_MEDIUM)
         legal_item();
         `uvm_info("MAPU_B_RAND_STIM_SEQ", $sformatf("Finished item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_HIGH)
      end
   endtask
   // pragma uvmx rand_stim_seq_body end

   // pragma uvmx rand_stim_seq_methods begin
   // pragma uvmx rand_stim_seq_methods end

endclass


`endif // __UVME_MAPU_B_RAND_STIM_SEQ_SV__