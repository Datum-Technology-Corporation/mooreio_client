// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MAPU_B_CFG_SV__
`define __UVMA_MAPU_B_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running all Matrix APU Agent (uvma_mapu_b_agent_c) components.
 * @ingroup uvma_mapu_b_obj
 */
class uvma_mapu_b_cfg_c extends uvmx_block_agent_cfg_c;

   /// @name Settings
   /// @{
   rand int unsigned eg_drv_ton_pct; ///< Egress driver TON percentage: Percentage of active clock cycles for egress.
   /// @}

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvma_mapu_b_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(enabled, UVM_DEFAULT)
      `uvm_field_int(bypass_mode, UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_int(drv_idle_random, UVM_DEFAULT)
      `uvm_field_enum(uvm_sequencer_arb_mode, sqr_arb_mode, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(eg_drv_ton_pct, UVM_DEFAULT + UVM_DEC)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Describes fields randomization space.
    */
   constraint settings_space_cons {
       eg_drv_ton_pct inside {[1:100]};
   }

   /**
    * Rules for parameters.
    */
   constraint parameter_space_cons {
      data_width inside {[`UVMA_MAPU_B_DATA_WIDTH_MIN:`UVMA_MAPU_B_DATA_WIDTH_MAX]};
   }

   // pragma uvmx cfg_constraints begin
   constraint rules_cons {
      soft eg_drv_ton_pct inside {[50:100]};
   }
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvma_mapu_b_cfg");
      super.new(name);
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   // pragma uvmx cfg_post_randomize_work end

   // pragma uvmx cfg_methods begin
   // pragma uvmx cfg_methods end

endclass


`endif // __UVMA_MAPU_B_CFG_SV__