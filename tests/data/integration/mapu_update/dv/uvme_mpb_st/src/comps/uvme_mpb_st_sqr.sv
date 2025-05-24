// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_SQR_SV__
`define __UVME_MPB_ST_SQR_SV__


/**
 * Sequencer running Matrix Peripheral Bus Agent Self-Test Environment Sequences extending uvme_mpb_st_base_seq_c.
 * @ingroup uvme_mpb_st_comps
 */
class uvme_mpb_st_sqr_c extends uvmx_block_env_sqr_c #(
   .T_CFG  (uvme_mpb_st_cfg_c  ),
   .T_CNTXT(uvme_mpb_st_cntxt_c)
);

   /// @name Sequencers
   /// @{
   uvma_mpb_sqr_c  main_sequencer; ///< Handle to MAIN Agent's Sequencer.
   uvma_mpb_sqr_c  sec_sequencer; ///< Handle to SEC Agent's Sequencer.
   uvma_mpb_sqr_c  passive_sequencer; ///< Handle to passive Agent's Sequencer.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvme_mpb_st_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVME_MPB_ST_SQR_SV__