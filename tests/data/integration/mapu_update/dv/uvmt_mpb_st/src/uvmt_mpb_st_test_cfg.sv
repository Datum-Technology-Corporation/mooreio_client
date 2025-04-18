// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_TEST_CFG_SV__
`define __UVMT_MPB_ST_TEST_CFG_SV__


/**
 * Object encapsulating common configuration parameters for  UVM Agent Self-Tests.
 * @ingroup uvmt_mpb_st_tests
 */
class uvmt_mpb_st_test_cfg_c extends uvmx_agent_test_cfg_c #(
   .T_REG_MODEL(uvme_mpb_st_reg_block_c)
);

   /// @name Knobs
   /// @{
   rand int unsigned  clk_frequency; ///< Clock frequency (Hz).
   /// @}

   /// @name Agents
   /// @{
   rand uvma_clk_cfg_c  clk_agent_cfg  ; ///< Clock agent configuration.
   rand uvma_reset_cfg_c  reset_n_agent_cfg; ///<  Reset Agent configuration.
   /// @}

   // pragma uvmx test_cfg_fields begin
   // pragma uvmx test_cfg_fields end


   `uvm_object_utils_begin(uvmt_mpb_st_test_cfg_c)
      // pragma uvmx test_cfg_uvm_field_macros begin
      `uvm_field_int(clk_frequency, UVM_DEFAULT + UVM_DEC)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_int(startup_timeout, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(heartbeat_period, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(heartbeat_refresh_period, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(simulation_timeout, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(clk_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(reset_n_agent_cfg, UVM_DEFAULT)
      // pragma uvmx test_cfg_uvm_field_macros end
   `uvm_object_utils_end



   /**
    * Sets safe defaults parameters.
    */
   constraint defaults_cons {
      clk_frequency == uvmt_mpb_st_default_clk_frequency;
      startup_timeout == uvmt_mpb_st_default_startup_timeout;
      heartbeat_period == uvmt_mpb_st_default_heartbeat_period;
      heartbeat_refresh_period == uvmt_mpb_st_default_heartbeat_refresh_period;
      simulation_timeout == uvmt_mpb_st_default_simulation_timeout;
   }

   /**
    * Sets agents configuration.
    */
   constraint agents_cons {
      clk_agent_cfg.enabled == 1;
      clk_agent_cfg.is_active == UVM_ACTIVE;
      reset_type == UVMX_RESET_SYNC;
      reset_n_agent_cfg.reset_type == UVMX_RESET_SYNC;
      reset_n_agent_cfg.polarity == UVMX_RESET_ACTIVE_LOW;
      reset_n_agent_cfg.enabled == 1;
      reset_n_agent_cfg.is_active == UVM_ACTIVE;
   }

   // pragma uvmx test_cfg_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      // ...
   }
   // pragma uvmx test_cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mpb_st_test_cfg");
      super.new(name);
   endfunction

   // pragma uvmx test_cfg_build_dox begin
   /**
    * Creates objects and arrays.
    */
   // pragma uvmx test_cfg_build_dox end
   virtual function void build();
      clk_agent_cfg = uvma_clk_cfg_c::type_id::create("clk_agent_cfg");
      reset_n_agent_cfg = uvma_reset_cfg_c::type_id::create("reset_n_agent_cfg");
      // pragma uvmx test_cfg_build begin
      // pragma uvmx test_cfg_build end
   endfunction

   // pragma uvmx test_cfg_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mpb_st_test_cfg_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx test_cfg_post_randomize_work end

   // pragma uvmx test_cfg_methods begin
   // pragma uvmx test_cfg_methods end

endclass


`endif // __UVMT_MPB_ST_TEST_CFG_SV__