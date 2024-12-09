// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CP_MON_TRN_SV__
`define __UVMA_MAPU_B_CP_MON_TRN_SV__


/**
 * Control Plane monitor transaction sampled by uvma_mapu_b_cp_mon_c.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_cp_mon_trn_c extends uvmx_mon_trn_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   uvma_mapu_b_i_en_l_t  i_en; ///< Block enable
   uvma_mapu_b_i_op_l_t  i_op; ///< Matrix Operation
   uvma_mapu_b_o_of_l_t  o_of; ///< Overflow flag
   /// @}

   // pragma uvmx cp_mon_trn_fields begin
   // pragma uvmx cp_mon_trn_fields end


   `uvm_object_utils_begin(uvma_mapu_b_cp_mon_trn_c)
      // pragma uvmx cp_mon_trn_uvm_field_macros begin
      // pragma uvmx cp_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cp_mon_trn");
      super.new(name);
      // pragma uvmx cp_mon_trn_uvm_field_macros begin
      // pragma uvmx cp_mon_trn_uvm_field_macros end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx cp_mon_trn_get_metadata begin
      string i_en_str;
      string i_op_str;
      string o_of_str;
      i_en_str = $sformatf("%h", i_en);
      i_op_str = $sformatf("%h", i_op);
      o_of_str = $sformatf("%h", o_of);
      `uvmx_metadata_field("i_en", i_en_str)
      `uvmx_metadata_field("i_op", i_op_str)
      `uvmx_metadata_field("o_of", o_of_str)
      // pragma uvmx cp_mon_trn_get_metadata end
   endfunction

  // pragma uvmx custom cp_mon_trn_methods begin
  // pragma uvmx custom cp_mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_CP_MON_TRN_SV__