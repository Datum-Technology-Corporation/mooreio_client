// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_CNTXT_SV__
`define __UVME_MAPU_B_CNTXT_SV__


/**
 * Object encapsulating all state variables for Matrix APU Block environment (uvme_mapu_b_env_c).
 * @ingroup uvme_mapu_b_obj
 */
class uvme_mapu_b_cntxt_c extends uvmx_block_sb_env_cntxt_c #(
   .T_CFG(uvme_mapu_b_cfg_c)
);

   /// @name Integrals
   /// @{
   int unsigned  prd_overflow_count; ///< 
   /// @}

   /// @name Objects
   /// @{
   uvma_mapu_b_cntxt_c  agent_cntxt; ///< Block Agent context.
   uvmx_sb_simplex_cntxt_c  sb_cntxt; ///< Scoreboard context
   /// @}

   // pragma uvmx cntxt_fields begin
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvme_mapu_b_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      `uvm_field_object(agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(sb_cntxt, UVM_DEFAULT)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_cntxt");
      super.new(name);
      // pragma uvmx cntxt_constructor begin
      // pragma uvmx cntxt_constructor end
   endfunction

   /**
    * Creates objects.
    */
   virtual function void build(uvme_mapu_b_cfg_c cfg);
      agent_cntxt = uvma_mapu_b_cntxt_c::type_id::create("agent_cntxt");
      sb_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("sb_cntxt");
      // pragma uvmx cntxt_build begin
      // pragma uvmx cntxt_build end
   endfunction

   /**
    * Returns all state variables to initial values.
    */
   virtual function void do_reset(uvme_mapu_b_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      agent_cntxt.reset();
      prd_overflow_count = 0;
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVME_MAPU_B_CNTXT_SV__