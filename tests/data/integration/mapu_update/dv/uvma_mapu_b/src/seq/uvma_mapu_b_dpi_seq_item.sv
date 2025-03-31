// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPI_SEQ_ITEM_SV__
`define __UVMA_MAPU_B_DPI_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for the Data Plane Input driver (uvma_mapu_b_drv_c).
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_dpi_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   rand uvma_mapu_b_i_vld_b_t  i_vld; ///< Input Valid
   rand uvma_mapu_b_i_r0_b_t  i_r0; ///< Input Data Row 0
   rand uvma_mapu_b_i_r1_b_t  i_r1; ///< Input Data Row 1
   rand uvma_mapu_b_i_r2_b_t  i_r2; ///< Input Data Row 2
   /// @}

   /// @name Metadata
   /// @{
   uvma_mapu_b_o_rdy_l_t  o_rdy; ///< Input data Ready
   /// @}

   // pragma uvmx dpi_seq_item_fields begin
   // pragma uvmx dpi_seq_item_fields end


   `uvm_object_utils_begin(uvma_mapu_b_dpi_seq_item_c)
      // pragma uvmx dpi_seq_item_uvm_field_macros begin
      `uvm_field_int(i_vld, UVM_DEFAULT)
      `uvm_field_int(i_r0, UVM_DEFAULT)
      `uvm_field_int(i_r1, UVM_DEFAULT)
      `uvm_field_int(i_r2, UVM_DEFAULT)
      `uvm_field_int(o_rdy, UVM_DEFAULT)
      // pragma uvmx dpi_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx dpi_seq_item_constraints begin
   // pragma uvmx dpi_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpi_seq_item");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx dpi_seq_item_get_metadata begin
      string i_r0_str;
      string i_r1_str;
      string i_r2_str;
      if (i_vld === 1) begin
         i_r0_str = $sformatf("%h", i_r0);
         i_r1_str = $sformatf("%h", i_r1);
         i_r2_str = $sformatf("%h", i_r2);
         `uvmx_metadata_field("i_r0", i_r0_str)
         `uvmx_metadata_field("i_r1", i_r1_str)
         `uvmx_metadata_field("i_r2", i_r2_str)
      end
      // pragma uvmx dpi_seq_item_get_metadata end
   endfunction

   // pragma uvmx seq_item_methods begin
   // pragma uvmx seq_item_methods end

endclass


`endif // __UVMA_MAPU_B_DPI_SEQ_ITEM_SV__