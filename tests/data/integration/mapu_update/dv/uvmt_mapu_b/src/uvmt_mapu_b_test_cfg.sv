// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_TEST_CFG_SV__
`define __UVMT_MAPU_B_TEST_CFG_SV__


/**
 * Object encapsulating common configuration parameters for Matrix APU Block Tests.
 * @ingroup uvmt_mapu_b_tests
 */
class uvmt_mapu_b_test_cfg_c extends uvmx_block_test_cfg_c;

   /// @name Knobs
   /// @{
   rand int unsigned  num_items; ///< Number of items
   rand int unsigned  num_errors; ///< Number of errors
   rand int unsigned  min_gap; ///< Minimum inter-item gap
   rand int unsigned  max_gap; ///< Maximum inter-item gap
   rand int unsigned  clock_frequency; ///< Clock frequency (Hz).
   /// @}

   /// @name Command Line Interface arguments
   /// @{
   bit  cli_num_items_override; ///< Set to '1' if argument was found for 'NUM_ITEMS'
   int unsigned  cli_num_items; ///< Parsed CLI value for 'NUM_ITEMS'
   bit  cli_num_errors_override; ///< Set to '1' if argument was found for 'NUM_ERRORS'
   int unsigned  cli_num_errors; ///< Parsed CLI value for 'NUM_ERRORS'
   bit  cli_min_gap_override; ///< Set to '1' if argument was found for 'MIN_GAP'
   int unsigned  cli_min_gap; ///< Parsed CLI value for 'MIN_GAP'
   bit  cli_max_gap_override; ///< Set to '1' if argument was found for 'MAX_GAP'
   int unsigned  cli_max_gap; ///< Parsed CLI value for 'MAX_GAP'
   /// @}

   /// @name Agents
   /// @{
   rand uvma_clk_cfg_c  clock_agent_cfg; ///< Clock agent configuration.
   rand uvma_reset_cfg_c  rst_agent_cfg; ///<  Reset Agent configuration.
   /// @}

   // pragma uvmx test_cfg_fields begin
   // pragma uvmx test_cfg_fields end


   `uvm_object_utils_begin(uvmt_mapu_b_test_cfg_c)
      // pragma uvmx test_cfg_uvm_field_macros begin
      `uvm_field_int(num_items, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(num_errors, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(min_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(max_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(clock_frequency, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(cli_num_items_override, UVM_DEFAULT)
      `uvm_field_int(cli_num_items, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(cli_num_errors_override, UVM_DEFAULT)
      `uvm_field_int(cli_num_errors, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(cli_min_gap_override, UVM_DEFAULT)
      `uvm_field_int(cli_min_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(cli_max_gap_override, UVM_DEFAULT)
      `uvm_field_int(cli_max_gap, UVM_DEFAULT + UVM_DEC)
      `uvm_field_enum(uvmx_reset_type_enum, reset_type, UVM_DEFAULT)
      `uvm_field_int(simulation_timeout, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(startup_timeout, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(heartbeat_period, UVM_DEFAULT + UVM_DEC)
      `uvm_field_int(heartbeat_refresh_period, UVM_DEFAULT + UVM_DEC)
      `uvm_field_object(clock_agent_cfg, UVM_DEFAULT)
      `uvm_field_object(rst_agent_cfg, UVM_DEFAULT)
      // pragma uvmx test_cfg_uvm_field_macros end
   `uvm_object_utils_end


   /**
    * Sets randomization space for random fields.
    */
   constraint knobs_cons {
      num_items inside {[1:100]};
      num_errors inside {[0:100]};
      min_gap inside {[0:100]};
      max_gap inside {[0:100]};
   }

   /**
    * Sets safe defaults parameters.
    */
   constraint defaults_cons {
      soft clock_frequency == uvmt_mapu_b_default_clock_frequency;
      soft simulation_timeout == uvmt_mapu_b_default_simulation_timeout;
      soft startup_timeout == uvmt_mapu_b_default_startup_timeout;
      soft heartbeat_period == uvmt_mapu_b_default_heartbeat_period;
      soft heartbeat_refresh_period == uvmt_mapu_b_default_heartbeat_refresh_period;
   }

   /**
    * Sets agents configuration.
    */
   constraint agents_cons {
      clock_agent_cfg.enabled == 1;
      clock_agent_cfg.is_active == UVM_ACTIVE;
      reset_type == UVMX_RESET_SYNC;
      rst_agent_cfg.reset_type == UVMX_RESET_SYNC;
      rst_agent_cfg.polarity == UVMX_RESET_ACTIVE_LOW;
      rst_agent_cfg.enabled == 1;
      rst_agent_cfg.is_active == UVM_ACTIVE;
   }

   // pragma uvmx test_cfg_constraints begin
   /**
    * Restricts randomization space for knobs.
    */
   constraint rules_cons {
      num_errors inside {['d1:num_items]};
      min_gap    inside {['d0:max_gap  ]};
      soft max_gap inside {[0:10]};
      soft num_items inside {[10:50]};
   }
   // pragma uvmx test_cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mapu_b_test_cfg");
      super.new(name);
   endfunction

   // pragma uvmx test_cfg_build_dox begin
   /**
    * Creates objects and arrays.
    */
   // pragma uvmx test_cfg_build_dox end
   virtual function void build();
      clock_agent_cfg = uvma_clk_cfg_c::type_id::create("clock_agent_cfg");
      rst_agent_cfg = uvma_reset_cfg_c::type_id::create("rst_agent_cfg");
      // pragma uvmx test_cfg_build begin
      // pragma uvmx test_cfg_build end
   endfunction

   /**
    * Processes Command Line Interface arguments.
    */
   virtual function void process_cli_args();
      `uvmx_cli_arg_parse("NUM_ITEMS", cli_num_items_override)
      if (cli_num_items_override) begin
         `uvmx_cli_int_val(cli_arg_str, cli_num_items)
      end
      `uvmx_cli_arg_parse("NUM_ERRORS", cli_num_errors_override)
      if (cli_num_errors_override) begin
         `uvmx_cli_int_val(cli_arg_str, cli_num_errors)
      end
      `uvmx_cli_arg_parse("MIN_GAP", cli_min_gap_override)
      if (cli_min_gap_override) begin
         `uvmx_cli_int_val(cli_arg_str, cli_min_gap)
      end
      `uvmx_cli_arg_parse("MAX_GAP", cli_max_gap_override)
      if (cli_max_gap_override) begin
         `uvmx_cli_int_val(cli_arg_str, cli_max_gap)
      end
      // pragma uvmx test_cfg_process_cli_args begin
      // pragma uvmx test_cfg_process_cli_args end
   endfunction

   // pragma uvmx test_cfg_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mapu_b_test_cfg_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx test_cfg_post_randomize_work end

   // pragma uvmx test_cfg_methods begin
   // pragma uvmx test_cfg_methods end

endclass


`endif // __UVMT_MAPU_B_TEST_CFG_SV__