// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_SB_SV__
`define __UVME_MPB_ST_SB_SV__


/**
 * Component encapsulating scoreboarding components for Matrix Peripheral Bus Agent Self-Testing.
 * @ingroup uvme_mpb_st_comps
 */
class uvme_mpb_st_sb_c extends uvmx_block_sb_c #(
   .T_CFG  (uvme_mpb_st_cfg_c  ),
   .T_CNTXT(uvme_mpb_st_cntxt_c)
);

   /// @name Components
   /// @{
   uvme_mpb_st_agent_m2s_sb_c  agent_m2s_scoreboard; ///< Agent Main-to-Secondary: Compares main sequence item against passive monitored transaction
   uvme_mpb_st_e2e_sb_c  e2e_scoreboard; ///< End-to-end: Compares monitored ingress transactions from main and secondary
   /// @}

   // pragma uvmx sb_fields begin
   // pragma uvmx sb_fields end


   `uvm_component_utils_begin(uvme_mpb_st_sb_c)
      // pragma uvmx sb_uvm_field_macros begin
      // pragma uvmx sb_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_sb", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Assigns configuration handles to components using UVM Configuration Database.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "agent_m2s_scoreboard", "cfg", cfg.agent_m2s_scoreboard_cfg);
      uvm_config_db#(uvmx_sb_simplex_cfg_c)::set(this, "e2e_scoreboard", "cfg", cfg.e2e_scoreboard_cfg);
      // pragma uvmx sb_assign_cfg begin
      // pragma uvmx sb_assign_cfg end
   endfunction

   /**
    * Assigns context handles to components using UVM Configuration Database.
    */
   virtual function void assign_cntxt();
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "agent_m2s_scoreboard", "cntxt", cntxt.agent_m2s_scoreboard_cntxt);
      uvm_config_db#(uvmx_sb_simplex_cntxt_c)::set(this, "e2e_scoreboard", "cntxt", cntxt.e2e_scoreboard_cntxt);
      // pragma uvmx sb_assign_cntxt begin
      // pragma uvmx sb_assign_cntxt end
   endfunction

   /**
    * Creates scoreboard components.
    */
   virtual function void create_components();
      agent_m2s_scoreboard = uvme_mpb_st_agent_m2s_sb_c::type_id::create("agent_m2s_scoreboard", this);
      e2e_scoreboard = uvme_mpb_st_e2e_sb_c::type_id::create("e2e_scoreboard", this);
      // pragma uvmx sb_create_components begin
      // pragma uvmx sb_create_components end
   endfunction

   // pragma uvmx sb_methods begin
   // pragma uvmx sb_methods end

endclass


`endif // __UVME_MPB_ST_SB_SV__