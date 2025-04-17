// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_RAND_STIM_SEQ_SV__
`define __UVME_MSTREAM_ST_RAND_STIM_SEQ_SV__


/**
 * Random Stimulus: Generates random valid stimulus.
 * @ingroup uvme_mstream_st_seq_functional
 */
class uvme_mstream_st_rand_stim_seq_c extends uvme_mstream_st_base_seq_c;

   /// @name Random Fields
   /// @{
   rand int unsigned  num_items; ///< Number of items
   rand int unsigned  min_gap; ///< Minimum gap
   rand int unsigned  max_gap; ///< Maximum gap
   /// @}

   // pragma uvmx rand_stim_seq_fields begin
   rand uvma_mstream_pkt_rand_stim_seq_c  ig_seq; ///< Packet Sequence for Ingress.
   rand uvma_mstream_pkt_rand_stim_seq_c  eg_seq; ///< Packet Sequence for Egress.
   // pragma uvmx rand_stim_seq_fields end


   `uvm_object_utils_begin(uvme_mstream_st_rand_stim_seq_c)
      // pragma uvmx rand_stim_seq_uvm_field_macros begin
      `uvm_field_int(num_items, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(min_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(max_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(ig_seq, UVM_DEFAULT)
      `uvm_field_object(eg_seq, UVM_DEFAULT)
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
    * Restricts randomization space.
    */
   constraint rules_cons {
      min_gap <= max_gap;
      ig_seq.num_items == num_items;
      eg_seq.num_items == num_items;
      ig_seq.min_gap == min_gap;
      eg_seq.min_gap == min_gap;
      ig_seq.max_gap == max_gap;
      eg_seq.max_gap == max_gap;
   }
   // pragma uvmx rand_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_rand_stim_seq");
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
   /**
    * TODO Implement or remove uvme_mstream_st_rand_stim_seq_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx rand_stim_seq_post_randomize_work end

   // pragma uvmx rand_stim_seq_body begin
   /**
    * TODO Implement uvme_mstream_st_rand_stim_seq_c::body()
    */
   virtual task body();
      fork
         begin
            `uvm_info("RAND_STIM_SEQ", $sformatf("Starting ingress traffic sequence:\n%s", ig_seq.sprint()), UVM_MEDIUM)
            ig_seq.start(p_sequencer.host_sequencer);
            `uvm_info("RAND_STIM_SEQ", $sformatf("Finished ingress traffic sequence:\n%s", ig_seq.sprint()), UVM_MEDIUM)
         end
         begin
            `uvm_info("RAND_STIM_SEQ", $sformatf("Starting egress traffic sequence:\n%s", eg_seq.sprint()), UVM_MEDIUM)
            eg_seq.start(p_sequencer.card_sequencer);
            `uvm_info("RAND_STIM_SEQ", $sformatf("Finished egress traffic sequence:\n%s", eg_seq.sprint()), UVM_MEDIUM)
         end
      join
   endtask
   // pragma uvmx rand_stim_seq_body end

   // pragma uvmx rand_stim_seq_methods begin
   // pragma uvmx rand_stim_seq_methods end

endclass


`endif // __UVME_MSTREAM_ST_RAND_STIM_SEQ_SV__