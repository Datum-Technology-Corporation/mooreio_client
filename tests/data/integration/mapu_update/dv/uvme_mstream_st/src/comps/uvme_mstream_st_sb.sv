// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_SB_SV__
`define __UVME_MSTREAM_ST_SB_SV__


/**
 * Component encapsulating scoreboarding components for Matrix Stream Interface Agent Self-Testing.
 * @ingroup uvme_mstream_st_comps
 */
class uvme_mstream_st_sb_c extends uvmx_block_sb_c #(
   .T_CFG  (uvme_mstream_st_cfg_c  ),
   .T_CNTXT(uvme_mstream_st_cntxt_c)
);

   /// @name Components
   /// @{
   uvme_mstream_st_agent_ig_sb_c  agent_ig_scoreboard; ///< Agent Ingress: Compares ingress sequence item against egress monitored transaction
   uvme_mstream_st_agent_eg_sb_c  agent_eg_scoreboard; ///< Agent Egress: Compares egress sequence item against egress monitored transaction
   uvme_mstream_st_e2e_eg_sb_c  e2e_eg_scoreboard; ///< End-to-end Ingress: Compares monitored ingress transactions from transmitter and receiver
   uvme_mstream_st_e2e_ig_sb_c  e2e_ig_scoreboard; ///< End-to-end Egress: Compares monitored egress transactions from transmitter and receiver
   /// @}

   // pragma uvmx sb_fields begin
   // pragma uvmx sb_fields end


   `uvm_component_utils_begin(uvme_mstream_st_sb_c)
      // pragma uvmx sb_uvm_field_macros begin
      // pragma uvmx sb_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Creates covergroups.
    */
   function new(string name="uvme_mstream_st_sb", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "agent_ig_scoreboard", "cfg", cfg.agent_ig_scoreboard_cfg);
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "agent_eg_scoreboard", "cfg", cfg.agent_eg_scoreboard_cfg);
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "e2e_eg_scoreboard", "cfg", cfg.e2e_eg_scoreboard_cfg);
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "e2e_ig_scoreboard", "cfg", cfg.e2e_ig_scoreboard_cfg);
      // pragma uvmx sb_assign_cfg begin
      // pragma uvmx sb_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "agent_ig_scoreboard", "cntxt", cntxt.agent_ig_scoreboard_cntxt);
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "agent_eg_scoreboard", "cntxt", cntxt.agent_eg_scoreboard_cntxt);
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "e2e_eg_scoreboard", "cntxt", cntxt.e2e_eg_scoreboard_cntxt);
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "e2e_ig_scoreboard", "cntxt", cntxt.e2e_ig_scoreboard_cntxt);
      // pragma uvmx sb_assign_cntxt begin
      // pragma uvmx sb_assign_cntxt end
   endfunction

   /**
    * Creates scoreboard components.
    */
   virtual function void create_components();
      agent_ig_scoreboard = uvme_mstream_st_agent_ig_sb_c::type_id::create("agent_ig_scoreboard", this);
      agent_eg_scoreboard = uvme_mstream_st_agent_eg_sb_c::type_id::create("agent_eg_scoreboard", this);
      e2e_eg_scoreboard = uvme_mstream_st_e2e_eg_sb_c::type_id::create("e2e_eg_scoreboard", this);
      e2e_ig_scoreboard = uvme_mstream_st_e2e_ig_sb_c::type_id::create("e2e_ig_scoreboard", this);
      // pragma uvmx sb_create_components begin
      // pragma uvmx sb_create_components end
   endfunction

   // pragma uvmx sb_methods begin
   // pragma uvmx sb_methods end

endclass


`endif // __UVME_MSTREAM_ST_SB_SV__