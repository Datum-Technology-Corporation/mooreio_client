// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_PKT_RAND_STIM_SEQ_SV__
`define __UVMA_MSTREAM_PKT_RAND_STIM_SEQ_SV__


/**
 * Random Stimulus: Generates random valid packets.
 * @ingroup uvma_mstream_seq_pkt
 */
class uvma_mstream_pkt_rand_stim_seq_c extends uvma_mstream_pkt_base_seq_c;

   /// @name Random Fields
   /// @{
   rand int unsigned  num_items; ///< Number of items
   rand int unsigned  min_gap; ///< Minimum gap
   rand int unsigned  max_gap; ///< Maximum gap
   /// @}

   // pragma uvmx pkt_rand_stim_seq_fields begin
   // pragma uvmx pkt_rand_stim_seq_fields end


   `uvm_object_utils_begin(uvma_mstream_pkt_rand_stim_seq_c)
      // pragma uvmx pkt_rand_stim_seq_uvm_field_macros begin
      `uvm_field_int(num_items, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(min_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(max_gap, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx pkt_rand_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Sets randomization space for random fields.
    */
   constraint space_cons {
      num_items inside {[1:100]};
      min_gap inside {[0:100]};
      max_gap inside {[0:100]};
   }

   // pragma uvmx pkt_rand_stim_seq_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      min_gap <= max_gap;
   }
   // pragma uvmx pkt_rand_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_pkt_rand_stim_seq");
      super.new(name);
   endfunction

   // pragma uvmx pkt_rand_stim_seq_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx pkt_rand_stim_seq_build_dox end
   virtual function void build();
      // pragma uvmx pkt_rand_stim_seq_build begin
      // pragma uvmx pkt_rand_stim_seq_build end
   endfunction

   // pragma uvmx pkt_rand_stim_seq_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx pkt_rand_stim_seq_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx pkt_rand_stim_seq_create_sequences begin
      // pragma uvmx pkt_rand_stim_seq_create_sequences end
   endfunction

   // pragma uvmx pkt_rand_stim_seq_post_randomize_work begin
   /**
    * TODO Implement or remove uvma_mstream_pkt_rand_stim_seq_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx pkt_rand_stim_seq_post_randomize_work end

   // pragma uvmx pkt_rand_stim_seq_body begin
   /**
    * TODO Implement uvma_mstream_pkt_rand_stim_seq_c::body()
    */
   virtual task body();
      uvma_mstream_pkt_seq_item_c  pkt;
      int unsigned  gap_size, max_val;
      if (cfg.data_width == 32) begin
         max_val = 1_000;
      end
      else if (cfg.data_width == 64) begin
         max_val = 1_000_000_000;
      end
      for (int unsigned ii=0; ii<num_items; ii++) begin
         gap_size = $urandom_range(min_gap, max_gap);
         `uvm_info("MSTREAM_RAND_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before item %0d/%0d", gap_size, (ii+1), num_items), UVM_HIGH)
         clk(gap_size);
         `uvm_info("MSTREAM_RAND_STIM_SEQ", $sformatf("Starting item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_MEDIUM)
          `uvmx_do_with(pkt, {
             matrix.max_val == max_val;
          })
         `uvm_info("MSTREAM_RAND_STIM_SEQ", $sformatf("Finished item #%0d of %0d with gap size %0d", (ii+1), num_items, gap_size), UVM_HIGH)
      end
   endtask
   // pragma uvmx pkt_rand_stim_seq_body end

   // pragma uvmx pkt_rand_stim_seq_methods begin
   // pragma uvmx pkt_rand_stim_seq_methods end

endclass


`endif // __UVMA_MSTREAM_PKT_RAND_STIM_SEQ_SV__