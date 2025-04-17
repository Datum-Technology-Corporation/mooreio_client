// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_FIX_STIM_SEQ_SV__
`define __UVME_MAPU_B_FIX_STIM_SEQ_SV__


/**
 * Fixed Stimulus: Generates fixed valid stimulus.
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
    * TODO Implement uvme_mapu_b_fix_stim_seq_c::body()
    */
   virtual task body();
      add();
      mult();
   endtask
   // pragma uvmx fix_stim_seq_body end

   // pragma uvmx fix_stim_seq_methods begin
      /**
    * Runs 2 additions.
    */
   virtual task add();
      uvma_mapu_b_op_seq_item_c  seq_item;
      `uvmx_create_on(seq_item, agent_sequencer)
      seq_item.ton_pct = 100;
      seq_item.op  = UVMA_MAPU_B_OP_ADD;
      seq_item.ma.load('{
         '{1,0,2},
         '{3,2,1},
         '{2,1,0}
      });
      seq_item.mb.load('{
         '{1,0,2},
         '{3,2,1},
         '{2,1,0}
      });
      `uvmx_send(seq_item)

      `uvmx_create_on(seq_item, agent_sequencer)
      seq_item.ton_pct = 100;
      seq_item.op  = UVMA_MAPU_B_OP_ADD;
      seq_item.ma.load('{
         '{2,1,0},
         '{1,0,2},
         '{2,1,0}
      });
      seq_item.mb.load('{
         '{2,1,0},
         '{1,0,2},
         '{2,1,0}
      });
      `uvmx_send(seq_item)
   endtask

   /**
    * Runs 2 multiplications.
    */
   virtual task mult();
      uvma_mapu_b_op_seq_item_c  seq_item;
      `uvmx_create_on(seq_item, agent_sequencer)
      seq_item.ton_pct = 100;
      seq_item.op  = UVMA_MAPU_B_OP_MULT;
      seq_item.ma.load('{
         '{1,0,2},
         '{3,2,1},
         '{2,1,0}
      });
      seq_item.mb.load('{
         '{1,0,2},
         '{3,2,1},
         '{2,1,0}
      });
      `uvmx_send(seq_item)

      `uvmx_create_on(seq_item, agent_sequencer)
      seq_item.ton_pct = 100;
      seq_item.op  = UVMA_MAPU_B_OP_MULT;
      seq_item.ma.load('{
         '{2,1,0},
         '{1,0,2},
         '{2,1,0}
      });
      seq_item.mb.load('{
         '{2,1,0},
         '{1,0,2},
         '{2,1,0}
      });
      `uvmx_send(seq_item)
   endtask
   // pragma uvmx fix_stim_seq_methods end

endclass


`endif // __UVME_MAPU_B_FIX_STIM_SEQ_SV__