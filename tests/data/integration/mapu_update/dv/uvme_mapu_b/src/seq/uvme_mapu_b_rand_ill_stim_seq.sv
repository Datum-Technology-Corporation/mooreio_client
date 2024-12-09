// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_RAND_ILL_STIM_SEQ_SV__
`define __UVME_MAPU_B_RAND_ILL_STIM_SEQ_SV__


/**
 * Sequence for test 'rand_ill_stim'.
 * @ingroup uvme_mapu_b_seq
 */
class uvme_mapu_b_rand_ill_stim_seq_c extends uvme_mapu_b_base_seq_c;

   /// @name Knobs
   /// @{
   rand int unsigned  num_items ; ///< Number of legal items to generate.
   rand int unsigned  num_errors; ///< Number of illegal items to generate.
   rand int unsigned  min_gap   ; ///< Minimum number of cycles between items.
   rand int unsigned  max_gap   ; ///< Maximum number of cycles between items.
   /// @}

   /// @name Data
   /// @{
   bit           error_idx_q[$]; ///< Illegal item indices.
   int unsigned  error_count   ; ///< Tally for illegal items generated.
   /// @}

   // pragma uvmx rand_ill_stim_seq_fields begin
   // pragma uvmx rand_ill_stim_seq_fields end


   `uvm_object_utils_begin(uvme_mapu_b_rand_ill_stim_seq_c)
      // pragma uvmx rand_ill_stim_seq_uvm_field_macros begin
      `uvm_field_int(num_items , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(num_errors, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(min_gap   , UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(max_gap   , UVM_DEFAULT + UVM_DEC)
      `uvm_field_queue_int(error_idx_q, UVM_DEFAULT)
      `uvm_field_int(error_count, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx rand_ill_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Describes randomization space for knobs.
    */
   constraint space_cons {
      max_gap    inside {['d0:'d100]};
      num_errors inside {['d1:num_items]};
      min_gap    inside {['d0:max_gap  ]};
   }

   // pragma uvmx rand_ill_stim_seq_constraints begin
   // pragma uvmx rand_ill_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_rand_ill_stim_seq");
      super.new(name);
      // pragma uvmx rand_ill_stim_seq_constructor begin
      // pragma uvmx rand_ill_stim_seq_constructor end
   endfunction

   /**
    * Fills #error_idx_q with positions of illegal sequence items.
    */
   virtual function void post_randomize_work();
      `uvmx_rand_bit_q(error_idx_q, num_items, num_errors)
      // pragma uvmx rand_ill_stim_seq_post_randomize_work begin
      // pragma uvmx rand_ill_stim_seq_post_randomize_work end
   endfunction

   /**
    * Generates #num_items of random stimulus, #num_errors of which are illegal, using #error_idx_q for sequencing.
    */
   virtual task body();
      // pragma uvmx rand_ill_stim_seq_body begin
      uvma_mapu_b_seq_item_c  seq_item;
      int unsigned  gap_size;
      for (int unsigned ii=0; ii<num_items; ii++) begin
         gap_size = $urandom_range(min_gap, max_gap);
         if (error_idx_q[ii]) begin
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before ILLEGAL item #%0d/%0d (#%0d/%0d total items)", gap_size, (error_count+1), num_errors, (ii+1), num_items), UVM_NONE)
            clk(gap_size);
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Starting ILLEGAL item #%0d/%0d (#%0d/%0d total items) with gap size %0d", (error_count+1), num_errors, (ii+1), num_items, gap_size), UVM_NONE)
            `uvmx_do_on_with(seq_item, agent_sequencer, {
               // TODO Implement illegal stimulus sequence item constraint for uvme_mapu_b_rand_ill_stim_seq_c
            })
            error_count++;
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Finished ILLEGAL item #%0d/%0d (#%0d/%0d total items) with gap size %0d", error_count, num_errors, (ii+1), num_items, gap_size), UVM_NONE)
         end
         else begin
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before item #%0d/%0d - ", gap_size, (ii+1), num_items), UVM_HIGH)
            clk(gap_size);
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Starting item #%0d/%0d with gap size %0d", (ii+1), num_items, gap_size), UVM_MEDIUM)
            `uvmx_do_on(seq_item, agent_sequencer)
            `uvm_info("MAPU_B_RAND_ILL_STIM_SEQ", $sformatf("Finished item #%0d/%0d with gap size %0d", (ii+1), num_items, gap_size), UVM_HIGH)
         end
      end
      // pragma uvmx rand_ill_stim_seq_body end
   endtask

   // pragma uvmx fix_ill_stim_seq_methods begin
   // pragma uvmx fix_ill_stim_seq_methods end

endclass


`endif // __UVME_MAPU_B_RAND_ILL_STIM_SEQ_SV__