// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MSTREAM_CARD_IG_SEQ_ITEM_SV__
`define __UVMA_MSTREAM_CARD_IG_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for CARD Ingress driver (uvma_mstream_drv_c).
 * @ingroup uvma_mstream_seq
 */
class uvma_mstream_card_ig_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mstream_cfg_c  ),
   .T_CNTXT(uvma_mstream_cntxt_c)
);

   /// @name Driven Signals
   /// @{
   rand uvma_mstream_ig_rdy_b_t  ig_rdy; ///< Ingress Ready
   /// @}

   /// @name Monitored Signals (following edge)
   /// @{
   uvma_mstream_ig_vld_l_t  ig_vld; ///< Ingress Valid
   uvma_mstream_ig_r0_l_t  ig_r0; ///< Ingress Data Row 0
   uvma_mstream_ig_r1_l_t  ig_r1; ///< Ingress Data Row 1
   uvma_mstream_ig_r2_l_t  ig_r2; ///< Ingress Data Row 2
   /// @}

   // pragma uvmx card_ig_seq_item_fields begin
   // pragma uvmx card_ig_seq_item_fields end


   `uvm_object_utils_begin(uvma_mstream_card_ig_seq_item_c)
      // pragma uvmx card_ig_seq_item_uvm_field_macros begin
      `uvm_field_int(ig_rdy, UVM_DEFAULT)
      `uvm_field_int(ig_vld, UVM_DEFAULT)
      `uvm_field_int(ig_r0, UVM_DEFAULT)
      `uvm_field_int(ig_r1, UVM_DEFAULT)
      `uvm_field_int(ig_r2, UVM_DEFAULT)
      // pragma uvmx card_ig_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx card_ig_seq_item_constraints begin
   // pragma uvmx card_ig_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mstream_card_ig_seq_item");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx card_ig_seq_item_get_metadata begin
      string ig_vld_str;
      string ig_rdy_str;
      string ig_r0_str;
      string ig_r1_str;
      string ig_r2_str;
      ig_vld_str = $sformatf("%h", ig_vld);
      ig_rdy_str = $sformatf("%h", ig_rdy);
      ig_r0_str = $sformatf("%h", ig_r0);
      ig_r1_str = $sformatf("%h", ig_r1);
      ig_r2_str = $sformatf("%h", ig_r2);
      `uvmx_metadata_field("ig_vld", ig_vld_str)
      `uvmx_metadata_field("ig_rdy", ig_rdy_str)
      `uvmx_metadata_field("ig_r0", ig_r0_str)
      `uvmx_metadata_field("ig_r1", ig_r1_str)
      `uvmx_metadata_field("ig_r2", ig_r2_str)
      // pragma uvmx card_ig_seq_item_get_metadata end
   endfunction

   // pragma uvmx card_ig_seq_item_methods begin
   // pragma uvmx card_ig_seq_item_methods end

endclass


`endif // __UVMA_MSTREAM_CARD_IG_SEQ_ITEM_SV__