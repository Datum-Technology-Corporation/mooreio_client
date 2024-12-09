// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_CFG_SV__
`define __UVME_MAPU_B_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running the Matrix APU Block environment (uvme_mapu_b_env_c).
 * @ingroup uvme_mapu_b_obj
 */
class uvme_mapu_b_cfg_c extends uvmx_block_sb_env_cfg_c;

   /// @name Settings
   /// @{
   /// @}

   // @name Bus Widths
   /// @{
   rand int unsigned data_width; ///< Data Width
   /// @}

    /// @name Objects
   /// @{
   rand uvma_mapu_b_cfg_c  agent_cfg; ///< Block Agent configuration
   rand uvmx_sb_simplex_cfg_c  sb_cfg; ///< Scoreboard configuration
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvme_mapu_b_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(enabled, UVM_DEFAULT)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_int(drv_idle_random, UVM_DEFAULT)
      `uvm_field_int(scoreboarding_enabled, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(agent_cfg, UVM_DEFAULT)
      `uvm_field_object(sb_cfg, UVM_DEFAULT)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Assigns agent parameter fields.
    */
   constraint parameter_sync_cons {
     agent_cfg.data_width == data_width;
   }

   /**
    * Sets configuration fields for basic agent configuration.
    */
   constraint agent_basics_cons {
      agent_cfg.enabled         == enabled;
      agent_cfg.is_active       == is_active;
      agent_cfg.drv_idle_random == drv_idle_random;
      agent_cfg.bypass_mode     == 0;
   }

   /**
    * Sets all configuration fields for scoreboard.
    */
   constraint sb_cons {
      sb_cfg.enabled     == scoreboarding_enabled;
      sb_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      sb_cfg.log_enabled == 1;
   }

   // pragma uvmx cfg_constraints begin
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_cfg");
      super.new(name);
      // pragma uvmx cfg_constructor begin
      // pragma uvmx cfg_constructor end
   endfunction

   /**
    * Initializes objects and arrays.
    */
   virtual function void build();
      agent_cfg = uvma_mapu_b_cfg_c::type_id::create("agent_cfg");
      sb_cfg = uvmx_sb_simplex_cfg_c::type_id::create("sb_cfg");
      // pragma uvmx cfg_build begin
      // pragma uvmx cfg_build end
   endfunction

   /**
    * Adds transaction fields to scoreboard logs.
    */
   virtual function void cfg_sb_logs();
      // pragma uvmx cfg_cfg_sb_logs begin
      // pragma uvmx cfg_cfg_sb_logs end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   /**
    * TODO Implement uvme_mapu_b_cfg_c::post_randomize() or remove altogether
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx cfg_post_randomize_work end
   
endclass


`endif // __UVME_MAPU_B_CFG_SV__