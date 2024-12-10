// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_BASE_SEQ_SV__
`define __UVME_MAPU_B_BASE_SEQ_SV__


/**
 * Abstract Sequence from which all Matrix APU Block Self-Test Environment Virtual Sequences extend.
 * @ingroup uvme_mapu_b_seq
 */
class uvme_mapu_b_base_seq_c extends uvmx_block_sb_env_seq_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c),
   .T_SQR  (uvme_mapu_b_sqr_c  )
);

   // pragma uvmx base_seq_fields begin
   // pragma uvmx base_seq_fields end


   `uvm_object_utils_begin(uvme_mapu_b_base_seq_c)
      // pragma uvmx base_seq_uvm_field_macros begin
      // pragma uvmx base_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx base_seq_constraints begin
   // pragma uvmx base_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_base_seq");
      super.new(name);
      // pragma uvmx base_seq_constructor begin
      // pragma uvmx base_seq_constructor end
   endfunction

   // pragma uvmx base_seq_methods begin
   task legal_item();
      uvma_mapu_b_seq_item_c  seq_item;
      int unsigned add_max_val, mult_max_val;
      if (cfg.data_width == 32) begin
         add_max_val  = 1_000_000_000;
         mult_max_val = 1_000;
      end
      else if (cfg.data_width == 64) begin
         add_max_val  = 1_000_000_000_000_000;
         mult_max_val = 1_000_000_000;
      end
      `uvmx_do_on_with(seq_item, agent_sequencer, {
         if (op == UVMA_MAPU_B_OP_ADD) {
            ma.max_val == add_max_val;
            mb.max_val == add_max_val;
         }
         else if (op == UVMA_MAPU_B_OP_MULT) {
            ma.max_val == mult_max_val;
            mb.max_val == mult_max_val;
         }
      })
   endtask

   task illegal_item();
      uvma_mapu_b_seq_item_c  seq_item;
      int unsigned add_max_val, mult_max_val;
      if (cfg.data_width == 32) begin
         add_max_val  = 1_000_000_000;
         mult_max_val = 1_000;
      end
      else if (cfg.data_width == 64) begin
         add_max_val  = 1_000_000_000_000_000;
         mult_max_val = 1_000_000_000;
      end
      `uvmx_do_on_with(seq_item, agent_sequencer, {
         if (op == UVMA_MAPU_B_OP_ADD) {
            ma.max_val == add_max_val;
            mb.max_val == add_max_val;
         }
         else if (op == UVMA_MAPU_B_OP_MULT) {
            ma.max_val == mult_max_val;
            mb.max_val == mult_max_val;
         }
      })
   endtask
   // pragma uvmx base_seq_methods end

endclass


`endif // __UVME_MAPU_B_BASE_SEQ_SV__