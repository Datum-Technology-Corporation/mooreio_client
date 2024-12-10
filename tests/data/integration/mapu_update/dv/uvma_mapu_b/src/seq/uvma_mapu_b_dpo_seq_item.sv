// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPO_SEQ_ITEM_SV__
`define __UVMA_MAPU_B_DPO_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for the Data Plane Output driver (uvma_mapu_b_drv_c).
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_dpo_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   rand uvma_mapu_b_i_rdy_b_t  i_rdy; ///< Output data Ready
   /// @}

   /// @name Metadata
   /// @{
   uvma_mapu_b_o_vld_l_t  o_vld; ///< Output Valid
   uvma_mapu_b_o_r0_l_t  o_r0; ///< Output Data Row 0
   uvma_mapu_b_o_r1_l_t  o_r1; ///< Output Data Row 1
   uvma_mapu_b_o_r2_l_t  o_r2; ///< Output Data Row 2
   /// @}

   // pragma uvmx dpo_seq_item_fields begin
   // pragma uvmx dpo_seq_item_fields end


   `uvm_object_utils_begin(uvma_mapu_b_dpo_seq_item_c)
      // pragma uvmx dpo_seq_item_uvm_field_macros begin
      `uvm_field_int(i_rdy, UVM_DEFAULT)
      `uvm_field_int(o_vld, UVM_DEFAULT)
      `uvm_field_int(o_r0, UVM_DEFAULT)
      `uvm_field_int(o_r1, UVM_DEFAULT)
      `uvm_field_int(o_r2, UVM_DEFAULT)
      // pragma uvmx dpo_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx dpo_seq_item_constraints begin
   // pragma uvmx dpo_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpo_seq_item");
      super.new(name);
      // pragma uvmx dpo_seq_item_constructor begin
      // pragma uvmx dpo_seq_item_constructor end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx dpo_seq_item_get_metadata begin
      string i_rdy_str;
      string o_r0_str;
      string o_r1_str;
      string o_r2_str;
      if (o_vld === 1) begin
         i_rdy_str = $sformatf("%h", i_rdy);
         o_r0_str = $sformatf("%h", o_r0);
         o_r1_str = $sformatf("%h", o_r1);
         o_r2_str = $sformatf("%h", o_r2);
         `uvmx_metadata_field("i_rdy", i_rdy_str)
         `uvmx_metadata_field("o_r0", o_r0_str)
         `uvmx_metadata_field("o_r1", o_r1_str)
         `uvmx_metadata_field("o_r2", o_r2_str)
      end
      // pragma uvmx dpo_seq_item_get_metadata end
   endfunction

   // pragma uvmx seq_item_methods begin
   // pragma uvmx seq_item_methods end

endclass


`endif // __UVMA_MAPU_B_DPO_SEQ_ITEM_SV__