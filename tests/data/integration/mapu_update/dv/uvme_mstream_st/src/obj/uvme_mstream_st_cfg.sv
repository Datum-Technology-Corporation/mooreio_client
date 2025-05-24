// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_CFG_SV__
`define __UVME_MSTREAM_ST_CFG_SV__


/**
 * Object encapsulating all parameters for creating, connecting and running the Matrix Stream Interface Agent Self-Test environment (uvme_mstream_st_env_c).
 * @ingroup uvme_mstream_st_obj
 */
class uvme_mstream_st_cfg_c extends uvmx_agent_env_cfg_c;

   /// @name Bus Widths
   /// @{
   rand int unsigned  data_width; ///< Data Width: Matrix elements data width
   /// @}

    /// @name Objects
   /// @{
   rand uvma_mstream_cfg_c  host_agent_cfg; ///< HOST Agent configuration.
   rand uvma_mstream_cfg_c  card_agent_cfg; ///< CARD Agent configuration.
   rand uvma_mstream_cfg_c  passive_agent_cfg; ///< Passive Agent configuration.
   rand uvmx_sb_simplex_cfg_c  agent_ig_scoreboard_cfg; ///< Agent Ingress Scoreboard configuration
   rand uvmx_sb_simplex_cfg_c  agent_eg_scoreboard_cfg; ///< Agent Egress Scoreboard configuration
   rand uvmx_sb_simplex_cfg_c  e2e_ig_scoreboard_cfg; ///< End-to-end Ingress Scoreboard configuration
   rand uvmx_sb_simplex_cfg_c  e2e_eg_scoreboard_cfg; ///< End-to-end Egress Scoreboard configuration
   /// @}

   // pragma uvmx cfg_fields begin
   // pragma uvmx cfg_fields end


   `uvm_object_utils_begin(uvme_mstream_st_cfg_c)
      // pragma uvmx cfg_uvm_field_macros begin
      `uvm_field_int(scoreboarding_enabled, UVM_DEFAULT)
      `uvm_field_int(data_width, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(host_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(card_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(passive_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(agent_ig_scoreboard_cfg, UVM_DEFAULT)
      `uvm_field_object(agent_eg_scoreboard_cfg, UVM_DEFAULT)
      `uvm_field_object(e2e_eg_scoreboard_cfg, UVM_DEFAULT)
      `uvm_field_object(e2e_ig_scoreboard_cfg, UVM_DEFAULT)
      // pragma uvmx cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Assigns agent parameter fields.
    */
   constraint parameter_sync_cons {
     host_agent_cfg.data_width == data_width;
     card_agent_cfg.data_width == data_width;
     passive_agent_cfg.data_width == data_width;
   }

   // pragma uvmx cfg_constraints begin
   /**
    * Sets configuration fields for basic agent configuration.
    */
   constraint agent_basics_cons {
      host_agent_cfg.enabled     == enabled;
      host_agent_cfg.is_active   == is_active;
      host_agent_cfg.bypass_mode == 0;
      card_agent_cfg.enabled     == enabled;
      card_agent_cfg.is_active   == is_active;
      card_agent_cfg.bypass_mode == 0;
      passive_agent_cfg.enabled     == enabled;
      passive_agent_cfg.is_active   == UVM_PASSIVE;
      passive_agent_cfg.bypass_mode == 0;
      host_agent_cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_HOST;
      host_agent_cfg.reset_type == reset_type;
      card_agent_cfg.drv_mode == UVMA_MSTREAM_DRV_MODE_CARD;
      card_agent_cfg.reset_type == reset_type;
      passive_agent_cfg.reset_type == reset_type;
   }

   /**
    * Sets all configuration fields for Agent Ingress scoreboard.
    */
   constraint sb_agent_ig_cons {
      agent_ig_scoreboard_cfg.enabled     == scoreboarding_enabled;
      agent_ig_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      agent_ig_scoreboard_cfg.log_enabled == 1;
   }

   /**
    * Sets all configuration fields for Agent Egress scoreboard.
    */
   constraint sb_agent_eg_cons {
      agent_eg_scoreboard_cfg.enabled     == scoreboarding_enabled;
      agent_eg_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      agent_eg_scoreboard_cfg.log_enabled == 1;
   }

   /**
    * Sets all configuration fields for End-to-end Ingress scoreboard.
    */
   constraint sb_e2e_eg_cons {
      e2e_eg_scoreboard_cfg.enabled     == scoreboarding_enabled;
      e2e_eg_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      e2e_eg_scoreboard_cfg.log_enabled == 1;
   }

   /**
    * Sets all configuration fields for End-to-end Egress scoreboard.
    */
   constraint sb_e2e_ig_cons {
      e2e_ig_scoreboard_cfg.enabled     == scoreboarding_enabled;
      e2e_ig_scoreboard_cfg.mode        == UVMX_SB_MODE_IN_ORDER;
      e2e_ig_scoreboard_cfg.log_enabled == 1;
   }
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_cfg");
      super.new(name);
   endfunction

   // pragma uvmx cfg_build_dox begin
   /**
    * Initializes objects and arrays.
    */
   // pragma uvmx cfg_build_dox end
   virtual function void build();
      host_agent_cfg = uvma_mstream_cfg_c::type_id::create("host_agent_cfg");
      card_agent_cfg = uvma_mstream_cfg_c::type_id::create("card_agent_cfg");
      passive_agent_cfg = uvma_mstream_cfg_c::type_id::create("passive_agent_cfg");
      agent_ig_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("agent_ig_scoreboard_cfg");
      agent_eg_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("agent_eg_scoreboard_cfg");
      e2e_ig_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("e2e_ig_scoreboard_cfg");
      e2e_eg_scoreboard_cfg = uvmx_sb_simplex_cfg_c::type_id::create("e2e_eg_scoreboard_cfg");
      // pragma uvmx cfg_build begin
      // pragma uvmx cfg_build end
   endfunction

   // pragma uvmx cfg_post_randomize_work begin
   /**
    * TODO Implement uvme_mstream_st_cfg_c::post_randomize() or remove altogether
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx cfg_post_randomize_work end

   /**
    * Adds transaction fields to scoreboard logs.
    */
   virtual function void cfg_sb_logs();
      // pragma uvmx cfg_cfg_sb_logs begin
      agent_ig_scoreboard_cfg.add_to_log("dir");
      agent_eg_scoreboard_cfg.add_to_log("dir");
      e2e_eg_scoreboard_cfg.add_to_log("dir");
      e2e_ig_scoreboard_cfg.add_to_log("dir");
      // pragma uvmx cfg_cfg_sb_logs end
   endfunction

endclass


`endif // __UVME_MSTREAM_ST_CFG_SV__