// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_SQR_SV__
`define __UVME_MSTREAM_ST_SQR_SV__


/**
 * Sequencer running Matrix Stream Interface Agent Self-Test Environment Sequences extending uvme_mstream_st_base_seq_c.
 * @ingroup uvme_mstream_st_comps
 */
class uvme_mstream_st_sqr_c extends uvmx_block_env_sqr_c #(
   .T_CFG  (uvme_mstream_st_cfg_c  ),
   .T_CNTXT(uvme_mstream_st_cntxt_c)
);

   /// @name Sequencers
   /// @{
   uvma_mstream_sqr_c  host_sequencer; ///< Handle to HOST Agent's Sequencer.
   uvma_mstream_sqr_c  card_sequencer; ///< Handle to CARD Agent's Sequencer.
   uvma_mstream_sqr_c  passive_sequencer; ///< Handle to passive Agent's Sequencer.
   /// @}

   // pragma uvmx sqr_fields begin
   // pragma uvmx sqr_fields end


   `uvm_component_utils_begin(uvme_mstream_st_sqr_c)
      // pragma uvmx sqr_uvm_field_macros begin
      // pragma uvmx sqr_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_sqr", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx sqr_methods begin
   // pragma uvmx sqr_methods end

endclass


`endif // __UVME_MSTREAM_ST_SQR_SV__