// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_SQR_SV__
`define __UVME_MAPU_B_SQR_SV__


/**
 * Sequencer running Matrix APU Block Environment Sequences extending uvme_mapu_b_base_seq_c.
 * @ingroup uvme_mapu_b_comps
 */
class uvme_mapu_b_sqr_c extends uvmx_block_env_sqr_c #(
   .T_CFG  (uvme_mapu_b_cfg_c  ),
   .T_CNTXT(uvme_mapu_b_cntxt_c)
);

   /// @name Sequencers
   /// @{
   uvma_mapu_b_sqr_c  agent_sequencer; ///< Block Agent Sequencer.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvme_mapu_b_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVME_MAPU_B_SQR_SV__