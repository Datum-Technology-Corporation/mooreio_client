// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_CFG_SV__
`define __UVME_MAPU_B_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running the Matrix APU Block environment (uvme_mapu_b_env_c).
 * @ingroup uvme_mapu_b_obj
 */
class uvme_mapu_b_cfg_c extends uvmx_block_env_cfg_c;

   /// @name Settings
   /// @{
   rand int unsigned  eg_drv_ton_pct; ///< Egress driver TON percentage: Percentage of active clock cycles for egress.
   /// @}

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width: Matrix elements data width
   /// @}

    /// @name Objects
   /// @{
   rand uvma_mapu_b_cfg_c  agent_cfg; ///< Block Agent configuration
   rand uvmx_sb_simplex_cfg_c  egress_scoreboard_cfg; ///< Egress Scoreboard configuration
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
      `uvm_field_int(eg_drv_ton_pct, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(agent_cfg, UVM_DEFAULT)
      `uvm_field_object(egress_scoreboard_cfg, UVM_DEFAULT)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Assigns agent settings.
    */
   constraint fields_sync_cons {
      agent_cfg.eg_drv_ton_pct == eg_drv_ton_pct;
   }

   /**
    * Assigns agent parameter fields.
    */
   constraint parameter_sync_cons {
     agent_cfg.data_width == data_width;
   }

   /**
    * Sets configuration fields for basic agent configuration.
    */
   constraint agent_cons {
      soft agent_cfg.enabled     == enabled;
      soft agent_cfg.is_active   == is_active;
      soft agent_cfg.bypass_mode == 0;
   }

   /**
    * Sets all configuration fields for Egress scoreboard.
    */
   constraint egress_sb_cons {
      soft egress_scoreboard_cfg.enabled     == scoreboarding_enabled;
      soft egress_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      soft egress_scoreboard_cfg.log_enabled == 1;
   }

   // pragma uvmx cfg_constraints begin
   /**
    * Sets configuration fields for basic agent configuration.
    */
   constraint agent_basics_cons {
      agent_cfg.enabled     == enabled;
      agent_cfg.is_active   == is_active;
      agent_cfg.bypass_mode == 0;
   }

   /**
    * Sets all configuration fields for Egress scoreboard.
    */
   constraint sb_cons {
      egress_scoreboard_cfg.enabled     == scoreboarding_enabled;
      egress_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      egress_scoreboard_cfg.log_enabled == 1;
   }
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_cfg");
      super.new(name);
   endfunction

   // pragma uvmx cfg_build_dox begin
   /**
    * Initializes objects and arrays.
    */
   // pragma uvmx cfg_build_dox end
   virtual function void build();
      agent_cfg = uvma_mapu_b_cfg_c::type_id::create("agent_cfg");
      egress_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("egress_scoreboard_cfg");
      // pragma uvmx cfg_build begin
      // pragma uvmx cfg_build end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   // pragma uvmx cfg_post_randomize_work end

   /**
    * Adds transaction fields to scoreboard logs.
    */
   virtual function void cfg_sb_logs();
      // pragma uvmx cfg_cfg_sb_logs begin
      egress_scoreboard_cfg.add_to_log("of"     );
      egress_scoreboard_cfg.add_to_log("m[0][0]");
      egress_scoreboard_cfg.add_to_log("m[0][1]");
      egress_scoreboard_cfg.add_to_log("m[0][2]");
      egress_scoreboard_cfg.add_to_log("m[1][0]");
      egress_scoreboard_cfg.add_to_log("m[1][1]");
      egress_scoreboard_cfg.add_to_log("m[1][2]");
      egress_scoreboard_cfg.add_to_log("m[2][0]");
      egress_scoreboard_cfg.add_to_log("m[2][1]");
      egress_scoreboard_cfg.add_to_log("m[2][2]");
      // pragma uvmx cfg_cfg_sb_logs end
   endfunction

endclass


`endif // __UVME_MAPU_B_CFG_SV__