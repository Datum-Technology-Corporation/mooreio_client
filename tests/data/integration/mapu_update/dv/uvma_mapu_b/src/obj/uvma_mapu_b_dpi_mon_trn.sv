// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_DPI_MON_TRN_SV__
`define __UVMA_MAPU_B_DPI_MON_TRN_SV__


/**
 * Data Plane Input monitor transaction sampled by uvma_mapu_b_dpi_mon_c.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_dpi_mon_trn_c extends uvmx_mon_trn_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   uvma_mapu_b_i_vld_t  i_vld; ///< Input Valid
   uvma_mapu_b_o_rdy_t  o_rdy; ///< Input data Ready
   uvma_mapu_b_i_r0_t  i_r0; ///< Input Data Row 0
   uvma_mapu_b_i_r1_t  i_r1; ///< Input Data Row 1
   uvma_mapu_b_i_r2_t  i_r2; ///< Input Data Row 2
   /// @}

   // pragma uvmx dpi_mon_trn_fields begin
   // pragma uvmx dpi_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mapu_b_dpi_mon_trn_c)
      // pragma uvmx dpi_mon_trn_uvm_field_macros begin
      `uvm_field_int(i_vld, UVM_DEFAULT)
      `uvm_field_int(i_r0, UVM_DEFAULT)
      `uvm_field_int(i_r1, UVM_DEFAULT)
      `uvm_field_int(i_r2, UVM_DEFAULT)
      `uvm_field_int(o_rdy, UVM_DEFAULT)
      // pragma uvmx dpi_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_dpi_mon_trn");
      super.new(name);
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx dpi_mon_trn_get_metadata begin
      string o_rdy_str;
      string i_r0_str;
      string i_r1_str;
      string i_r2_str;
      if (i_vld === 1) begin
         o_rdy_str = $sformatf("%h", o_rdy);
         i_r0_str = $sformatf("%h", i_r0);
         i_r1_str = $sformatf("%h", i_r1);
         i_r2_str = $sformatf("%h", i_r2);
         `uvmx_metadata_field("o_rdy", o_rdy_str)
         `uvmx_metadata_field("i_r0", i_r0_str)
         `uvmx_metadata_field("i_r1", i_r1_str)
         `uvmx_metadata_field("i_r2", i_r2_str)
      end
      // pragma uvmx dpi_mon_trn_get_metadata end
   endfunction

  // pragma uvmx custom dpi_mon_trn_methods begin
  // pragma uvmx custom dpi_mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_DPI_MON_TRN_SV__