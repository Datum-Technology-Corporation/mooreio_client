// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CP_SEQ_ITEM_SV__
`define __UVMA_MAPU_B_CP_SEQ_ITEM_SV__


/**
 * Sequence Item providing stimulus for the Control Plane driver (uvma_mapu_b_drv_c).
 * @ingroup uvma_mapu_b_seq
 */
class uvma_mapu_b_cp_seq_item_c extends uvmx_seq_item_c #(
   .T_CFG  (uvma_mapu_b_cfg_c  ),
   .T_CNTXT(uvma_mapu_b_cntxt_c)
);

   /// @name Data
   /// @{
   rand uvma_mapu_b_i_en_b_t  i_en; ///< Block enable
   rand uvma_mapu_b_i_op_b_t  i_op; ///< Matrix Operation
   /// @}

   /// @name Metadata
   /// @{
   uvma_mapu_b_o_of_l_t  o_of; ///< Overflow flag
   /// @}

   // pragma uvmx cp_seq_item_fields begin
   // pragma uvmx cp_seq_item_fields end


   `uvm_object_utils_begin(uvma_mapu_b_cp_seq_item_c)
      // pragma uvmx cp_seq_item_uvm_field_macros begin
      `uvm_field_int(i_en, UVM_DEFAULT)
      `uvm_field_int(i_op, UVM_DEFAULT)
      `uvm_field_int(o_of, UVM_DEFAULT)
      // pragma uvmx cp_seq_item_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx cp_seq_item_constraints begin
   // pragma uvmx cp_seq_item_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cp_seq_item");
      super.new(name);
      // pragma uvmx cp_seq_item_constructor begin
      // pragma uvmx cp_seq_item_constructor end
   endfunction

   /**
    * Describes transaction for logger.
    */
   virtual function uvmx_metadata_t get_metadata();
      // pragma uvmx cp_seq_item_get_metadata begin
      string i_en_str;
      string i_op_str;
      i_en_str = (i_en === 1) ? "Y " : "N ";
      case (i_op)
            2'b00  : i_op_str = "ADD ";
            2'b01  : i_op_str = "MULT";
            default: i_op_str = "????";
         endcase
      `uvmx_metadata_field("i_en", i_en_str)
      `uvmx_metadata_field("i_op", i_op_str)
      // pragma uvmx cp_seq_item_get_metadata end
   endfunction

   // pragma uvmx seq_item_methods begin
   // pragma uvmx seq_item_methods end

endclass


`endif // __UVMA_MAPU_B_CP_SEQ_ITEM_SV__