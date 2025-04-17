// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MSTREAM_ST_CNTXT_SV__
`define __UVME_MSTREAM_ST_CNTXT_SV__


/**
 * Object encapsulating all state variables for Matrix Stream Interface Agent Self-Test environment (uvme_mstream_st_env_c).
 * @ingroup uvme_mstream_st_obj
 */
class uvme_mstream_st_cntxt_c extends uvmx_agent_env_cntxt_c #(
   .T_CFG(uvme_mstream_st_cfg_c));

   /// @name Objects
   /// @{
   uvma_mstream_cntxt_c  host_agent_cntxt; ///< HOST Agent context.
   uvma_mstream_cntxt_c  card_agent_cntxt; ///< CARD Agent context.
   uvma_mstream_cntxt_c  passive_agent_cntxt; ///< Passive Agent context.
   uvmx_sb_simplex_cntxt_c  agent_ig_scoreboard_cntxt; ///< Agent Ingress Scoreboard context
   uvmx_sb_simplex_cntxt_c  agent_eg_scoreboard_cntxt; ///< Agent Egress Scoreboard context
   uvmx_sb_simplex_cntxt_c  e2e_eg_scoreboard_cntxt; ///< End-to-end Ingress Scoreboard context
   uvmx_sb_simplex_cntxt_c  e2e_ig_scoreboard_cntxt; ///< End-to-end Egress Scoreboard context
   /// @}

   // pragma uvmx cntxt_fields begin
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvme_mstream_st_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      `uvm_field_object(host_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(card_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(passive_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(agent_ig_scoreboard_cntxt, UVM_DEFAULT)
      `uvm_field_object(agent_eg_scoreboard_cntxt, UVM_DEFAULT)
      `uvm_field_object(e2e_eg_scoreboard_cntxt, UVM_DEFAULT)
      `uvm_field_object(e2e_ig_scoreboard_cntxt, UVM_DEFAULT)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mstream_st_cntxt");
      super.new(name);
   endfunction

   /**
    * Creates objects.
    */
   virtual function void build(uvme_mstream_st_cfg_c cfg);
      host_agent_cntxt = uvma_mstream_cntxt_c::type_id::create("host_agent_cntxt");
      card_agent_cntxt = uvma_mstream_cntxt_c::type_id::create("card_agent_cntxt");
      passive_agent_cntxt = uvma_mstream_cntxt_c::type_id::create("passive_agent_cntxt");
      agent_ig_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("agent_ig_scoreboard_cntxt");
      agent_eg_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("agent_eg_scoreboard_cntxt");
      e2e_eg_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("e2e_eg_scoreboard_cntxt");
      e2e_ig_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("e2e_ig_scoreboard_cntxt");
      // pragma uvmx cntxt_build begin
      // pragma uvmx cntxt_build end
   endfunction

   /**
    * Returns all state variables to initial values.
    */
   virtual function void do_reset(uvme_mstream_st_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      host_agent_cntxt.reset();
      card_agent_cntxt.reset();
      passive_agent_cntxt.reset();
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVME_MSTREAM_ST_CNTXT_SV__