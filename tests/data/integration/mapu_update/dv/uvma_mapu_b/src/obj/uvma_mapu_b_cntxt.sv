// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CNTXT_SV__
`define __UVMA_MAPU_B_CNTXT_SV__


/**
 * Object encapsulating all state variables for all Matrix APU Agent (uvma_mapu_b_agent_c) components.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_cntxt_c extends uvmx_block_sb_agent_cntxt_c #(
   .T_CFG(uvma_mapu_b_cfg_c     ),
   .T_VIF(virtual uvma_mapu_b_if)
);

   /// @name Fields
   /// @{
   bit  mon_overflow; ///< 
   int unsigned  mon_overflow_count; ///< 
   /// @}

   /// @name Sequences
   /// @{
   uvm_sequence_base  idle_drv_seq ; ///< Sequence driving data into the DUT.
   uvm_sequence_base  in_drv_seq ; ///< Sequence driving data into the DUT.
   uvm_sequence_base  out_drv_seq; ///< Sequence driving data out of the DUT.
   /// @}

   // pragma uvmx cntxt_fields begin
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvma_mapu_b_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      `uvm_field_int(mon_overflow, UVM_DEFAULT)
      `uvm_field_int(mon_overflow_count, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Creates event objects.
    */
   function new(string name="uvma_mapu_b_cntxt");
      super.new(name);
      // pragma uvmx cntxt_constructor begin
      // pragma uvmx cntxt_constructor end
   endfunction

   /**
    * Sets all state variables to initial values.
    */
   virtual function void do_reset(uvma_mapu_b_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      mon_overflow       = 0;
      mon_overflow_count = 0;
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVMA_MAPU_B_CNTXT_SV__