// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_CFG_SV__
`define __UVME_MPB_ST_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running the Matrix Peripheral Bus Agent Self-Test environment (uvme_mpb_st_env_c).
 * @ingroup uvme_mpb_st_obj
 */
class uvme_mpb_st_cfg_c extends uvmx_agent_env_cfg_c;

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width: Bus width for data
   rand int unsigned  addr_width; ///< Address Width: Bus width for address
   /// @}

    /// @name Objects
   /// @{
   rand uvma_mpb_cfg_c  main_agent_cfg; ///< MAIN Agent configuration.
   rand uvma_mpb_cfg_c  sec_agent_cfg; ///< SEC Agent configuration.
   rand uvma_mpb_cfg_c  passive_agent_cfg; ///< Passive Agent configuration.
   rand uvmx_sb_simplex_cfg_c  agent_m2s_scoreboard_cfg; ///< Agent Main-to-Secondary Scoreboard configuration
   rand uvmx_sb_simplex_cfg_c  e2e_scoreboard_cfg; ///< End-to-end Scoreboard configuration
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvme_mpb_st_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(scoreboarding_enabled, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(addr_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(main_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(sec_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(passive_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(agent_m2s_scoreboard_cfg, UVM_DEFAULT)
      `uvm_field_object(e2e_scoreboard_cfg, UVM_DEFAULT)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Assigns agent parameter fields.
    */
   constraint parameter_sync_cons {
     main_agent_cfg.data_width == data_width;
     sec_agent_cfg.data_width == data_width;
     passive_agent_cfg.data_width == data_width;
     main_agent_cfg.addr_width == addr_width;
     sec_agent_cfg.addr_width == addr_width;
     passive_agent_cfg.addr_width == addr_width;
   }

   // pragma uvmx cfg_constraints begin
   /**
    * Sets configuration fields for basic agent configuration.
    */
   constraint agent_basics_cons {
      main_agent_cfg.enabled     == enabled;
      main_agent_cfg.is_active   == is_active;
      main_agent_cfg.bypass_mode == 0;
      sec_agent_cfg.enabled     == enabled;
      sec_agent_cfg.is_active   == is_active;
      sec_agent_cfg.bypass_mode == 0;
      passive_agent_cfg.enabled     == enabled;
      passive_agent_cfg.is_active   == UVM_PASSIVE;
      passive_agent_cfg.bypass_mode == 0;
      main_agent_cfg.drv_mode == UVMA_MPB_DRV_MODE_MAIN;
      main_agent_cfg.reset_type == reset_type;
      sec_agent_cfg.drv_mode == UVMA_MPB_DRV_MODE_SEC;
      sec_agent_cfg.reset_type == reset_type;
      passive_agent_cfg.reset_type == reset_type;
   }

   /**
    * Sets all configuration fields for Agent Main-to-Secondary scoreboard.
    */
   constraint sb_agent_m2s_cons {
      agent_m2s_scoreboard_cfg.enabled     == scoreboarding_enabled;
      agent_m2s_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      agent_m2s_scoreboard_cfg.log_enabled == 1;
   }

   /**
    * Sets all configuration fields for End-to-end scoreboard.
    */
   constraint sb_e2e_cons {
      e2e_scoreboard_cfg.enabled     == scoreboarding_enabled;
      e2e_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      e2e_scoreboard_cfg.log_enabled == 1;
   }
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_cfg");
      super.new(name);
   endfunction

   // pragma uvmx cfg_build_dox begin
   /**
    * Initializes objects and arrays.
    */
   // pragma uvmx cfg_build_dox end
   virtual function void build();
      main_agent_cfg = uvma_mpb_cfg_c::type_id::create("main_agent_cfg");
      sec_agent_cfg = uvma_mpb_cfg_c::type_id::create("sec_agent_cfg");
      passive_agent_cfg = uvma_mpb_cfg_c::type_id::create("passive_agent_cfg");
      agent_m2s_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("agent_m2s_scoreboard_cfg");
      e2e_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("e2e_scoreboard_cfg");
      // pragma uvmx cfg_build begin
      // pragma uvmx cfg_build end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   /**
    * TODO Implement uvme_mpb_st_cfg_c::post_randomize() or remove altogether
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx cfg_post_randomize_work end

   /**
    * Adds transaction fields to scoreboard logs.
    */
   virtual function void cfg_sb_logs();
      // pragma uvmx cfg_cfg_sb_logs begin
      agent_m2s_scoreboard_cfg.add_to_log("op");
      agent_m2s_scoreboard_cfg.add_to_log("address");
      agent_m2s_scoreboard_cfg.add_to_log("data");
      e2e_scoreboard_cfg.add_to_log("op");
      e2e_scoreboard_cfg.add_to_log("address");
      e2e_scoreboard_cfg.add_to_log("data");
      // pragma uvmx cfg_cfg_sb_logs end
   endfunction

endclass


`endif // __UVME_MPB_ST_CFG_SV__