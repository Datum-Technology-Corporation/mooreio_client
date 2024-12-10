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
      `uvm_field_int(i_en, UVM_DEFAULT)
      `uvm_field_int(i_op, UVM_DEFAULT)
      `uvm_field_int(o_of, UVM_DEFAULT)
      // pragma uvmx cp_mon_trn_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cp_mon_trn");
      super.new(name);
      // pragma uvmx cp_mon_trn_constructor begin
      // pragma uvmx cp_mon_trn_constructor end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx cp_mon_trn_get_metadata begin
      string i_op_str;
      string o_of_str;
      if (i_en === 1) begin
         case (i_op)
            2'b00  : i_op_str = "ADD ";
            2'b01  : i_op_str = "MULT";
            default: i_op_str = "????";
         endcase
         o_of_str = (o_of === 1) ? "OF" : "";
         `uvmx_metadata_field("i_op", i_op_str)
         `uvmx_metadata_field("o_of", o_of_str)
      end
      // pragma uvmx cp_mon_trn_get_metadata end
   endfunction

  // pragma uvmx custom cp_mon_trn_methods begin
  // pragma uvmx custom cp_mon_trn_methods end

endclass


`endif // __UVMA_MAPU_B_CP_MON_TRN_SV__