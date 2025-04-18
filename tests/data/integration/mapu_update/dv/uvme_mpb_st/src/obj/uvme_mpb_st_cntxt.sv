// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_CNTXT_SV__
`define __UVME_MPB_ST_CNTXT_SV__


/**
 * Object encapsulating all state variables for Matrix Peripheral Bus Agent Self-Test environment (uvme_mpb_st_env_c).
 * @ingroup uvme_mpb_st_obj
 */
class uvme_mpb_st_cntxt_c extends uvmx_agent_env_cntxt_c #(
   .T_CFG(uvme_mpb_st_cfg_c),
   .T_REG_MODEL(uvme_mpb_st_reg_block_c)
);

   /// @name Objects
   /// @{
   uvma_mpb_cntxt_c  main_agent_cntxt; ///< MAIN Agent context.
   uvma_mpb_cntxt_c  sec_agent_cntxt; ///< SEC Agent context.
   uvma_mpb_cntxt_c  passive_agent_cntxt; ///< Passive Agent context.
   uvmx_sb_simplex_cntxt_c  agent_m2s_scoreboard_cntxt; ///< Agent Main-to-Secondary Scoreboard context
   uvmx_sb_simplex_cntxt_c  e2e_scoreboard_cntxt; ///< End-to-end Scoreboard context
   /// @}

   // pragma uvmx cntxt_fields begin
   uvm_reg_data_t  memory[uvm_reg_addr_t]; ///< Memory model
   // pragma uvmx cntxt_fields end


   `uvm_object_utils_begin(uvme_mpb_st_cntxt_c)
      // pragma uvmx cntxt_uvm_field_macros begin
      `uvm_field_enum(uvmx_reset_state_enum, reset_state, UVM_DEFAULT)
      `uvm_field_object(main_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(sec_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(passive_agent_cntxt, UVM_DEFAULT)
      `uvm_field_object(agent_m2s_scoreboard_cntxt, UVM_DEFAULT)
      `uvm_field_object(e2e_scoreboard_cntxt, UVM_DEFAULT)
      // pragma uvmx cntxt_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_cntxt");
      super.new(name);
   endfunction

   // pragma uvmx cntxt_build_dox begin
   /**
    * Creates objects.
    */
   // pragma uvmx cntxt_build_dox end
   virtual function void build(uvme_mpb_st_cfg_c cfg);
      main_agent_cntxt = uvma_mpb_cntxt_c::type_id::create("main_agent_cntxt");
      sec_agent_cntxt = uvma_mpb_cntxt_c::type_id::create("sec_agent_cntxt");
      passive_agent_cntxt = uvma_mpb_cntxt_c::type_id::create("passive_agent_cntxt");
      agent_m2s_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("agent_m2s_scoreboard_cntxt");
      e2e_scoreboard_cntxt = uvmx_sb_simplex_cntxt_c::type_id::create("e2e_scoreboard_cntxt");
      // pragma uvmx cntxt_build begin
      // pragma uvmx cntxt_build end
   endfunction

   /**
    * Returns all state variables to initial values.
    */
   virtual function void do_reset(uvme_mpb_st_cfg_c cfg);
      // pragma uvmx cntxt_do_reset begin
      main_agent_cntxt.reset();
      sec_agent_cntxt.reset();
      passive_agent_cntxt.reset();
      // pragma uvmx cntxt_do_reset end
   endfunction

   // pragma uvmx cntxt_methods begin
   // pragma uvmx cntxt_methods end

endclass


`endif // __UVME_MPB_ST_CNTXT_SV__