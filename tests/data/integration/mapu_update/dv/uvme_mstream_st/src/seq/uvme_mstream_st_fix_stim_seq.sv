// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_FIX_STIM_SEQ_SV__
`define __UVME_MSTREAM_ST_FIX_STIM_SEQ_SV__


/**
 * Fixed Stimulus: Generates fixed valid stimulus.
 * @ingroup uvme_mstream_st_seq_functional
 */
class uvme_mstream_st_fix_stim_seq_c extends uvme_mstream_st_base_seq_c;

   // pragma uvmx fix_stim_seq_fields begin
   // pragma uvmx fix_stim_seq_fields end


   `uvm_object_utils_begin(uvme_mstream_st_fix_stim_seq_c)
      // pragma uvmx fix_stim_seq_uvm_field_macros begin
      // pragma uvmx fix_stim_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx fix_stim_seq_constraints begin
   // pragma uvmx fix_stim_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_fix_stim_seq");
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
   // pragma uvmx fix_stim_seq_post_randomize_work end

   // pragma uvmx fix_stim_seq_body begin
   /**
    * TODO Implement uvme_mstream_st_fix_stim_seq_c::body()
    */
   virtual task body();
     uvma_mstream_pkt_seq_item_c  seq_item;
     const int unsigned  gap_size = 5;
     `uvmx_create_on(seq_item, p_sequencer.host_sequencer)
     seq_item.matrix.load('{
         '{1,0,2},
         '{3,2,1},
         '{2,1,0}
      });
     `uvm_info("FIX_STIM_SEQ", $sformatf("Starting item #1:\n%s", seq_item.sprint()), UVM_MEDIUM)
     `uvmx_send(seq_item)
     `uvm_info("FIX_STIM_SEQ", $sformatf("Finished item #1:\n%s", seq_item.sprint()), UVM_MEDIUM)
     `uvm_info("FIX_STIM_SEQ", $sformatf("Waiting %0d gap cycle(s) before item #2", gap_size), UVM_MEDIUM)
     repeat (gap_size) clk();
     `uvmx_create_on(seq_item, p_sequencer.card_sequencer)
     seq_item.matrix.load('{
         '{2,1,0},
         '{1,0,2},
         '{2,1,0}
      });
     `uvm_info("FIX_STIM_SEQ", $sformatf("Starting item #2:\n%s", seq_item.sprint()), UVM_MEDIUM)
     `uvmx_send(seq_item)
     `uvm_info("FIX_STIM_SEQ", $sformatf("Finished item #2:\n%s", seq_item.sprint()), UVM_MEDIUM)
   endtask
   // pragma uvmx fix_stim_seq_body end

   // pragma uvmx fix_stim_seq_methods begin
   // pragma uvmx fix_stim_seq_methods end

endclass


`endif // __UVME_MSTREAM_ST_FIX_STIM_SEQ_SV__