// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_BASE_TEST_SV__
`define __UVMT_MAPU_B_BASE_TEST_SV__


/**
 * Abstract Test from which all other Matrix APU Block Tests must extend.
 * Subclasses must provide stimulus via sequencer by implementing UVM runtime phases.
 * @ingroup uvmt_mapu_b_tests
 */
class uvmt_mapu_b_base_test_c extends uvmx_block_test_c #(
   .T_CFG      (uvmt_mapu_b_test_cfg_c),
   .T_ENV_CFG  (uvme_mapu_b_cfg_c     ),
   .T_ENV_CNTXT(uvme_mapu_b_cntxt_c   ),
   .T_ENV      (uvme_mapu_b_env_c     ),
   .T_ENV_SQR  (uvme_mapu_b_sqr_c     )
);

   /// @name Agents
   /// @{
   uvma_clk_agent_c  clock_agent; ///< Clock agent.
   uvma_reset_agent_c  rst_agent; ///< Reset agent.
   /// @}

   /// @name Default Sequences
   /// @{
   rand uvma_clk_start_seq_c  clock_seq; ///< Starts Clock generation during pre_reset_phase.
   rand uvma_reset_pulse_seq_c  rst_seq; ///< Asserts Reset during reset_phase.
   /// @}

   // pragma uvmx base_test_fields begin
   // pragma uvmx base_test_fields end


   `uvm_component_utils_begin(uvmt_mapu_b_base_test_c)
      // pragma uvmx base_test_uvm_field_macros begin
      // pragma uvmx base_test_uvm_field_macros end
   `uvm_component_utils_end
   `include "uvmt_mapu_b_base_test_workarounds.sv"


   /**
    * Sets clock frequency
    */
   constraint clk_cons {
      clock_seq.frequency == test_cfg.clock_frequency;
   }

   /**
    * Sets variable bus widths.
    */
   constraint parameter_cons {
      env_cfg.data_width == `UVMT_MAPU_B_DATA_WIDTH;
   }

   // pragma uvmx base_test_constraints begin
   // pragma uvmx base_test_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mapu_b_base_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx base_test_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx base_test_build_dox end
   virtual function void build();
      // pragma uvmx base_test_build begin
      // pragma uvmx base_test_build end
   endfunction

   /**
    * Creates Clock and Reset Sequences.
    */
   virtual function void create_clk_reset_sequences();
      clock_seq = uvma_clk_start_seq_c::type_id::create("clock_seq");
      rst_seq = uvma_reset_pulse_seq_c::type_id::create("rst_seq");
   endfunction

   // pragma uvmx base_test_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx base_test_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx base_test_create_sequences begin
      // pragma uvmx base_test_create_sequences end
   endfunction

   // pragma uvmx base_test_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mapu_b_base_test_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx base_test_post_randomize_work end

   /**
    * Creates agent components.
    */
   virtual function void create_components();
      clock_agent = uvma_clk_agent_c::type_id::create("clock_agent", this);
      rst_agent = uvma_reset_agent_c::type_id::create("rst_agent", this);
      // pragma uvmx base_test_create_components begin
      // pragma uvmx base_test_create_components end
   endfunction

   /**
    * Connects the reset agent to the environment's reset port.
    */
   virtual function void connect_env_reset();
      rst_agent.reset_mon_trn_ap.connect(env.reset_mon_trn_export);
      // pragma uvmx base_test_connect_env_reset begin
      // pragma uvmx base_test_connect_env_reset end
   endfunction

   /**
    * Assigns configuration objects to agents.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_clk_cfg_c)::set(this, "clock_agent", "cfg", test_cfg.clock_agent_cfg);
      uvm_config_db#(uvma_reset_cfg_c)::set(this, "rst_agent", "cfg", test_cfg.rst_agent_cfg);
      // pragma uvmx base_test_assign_cfg begin
      // pragma uvmx base_test_assign_cfg end
   endfunction

   /**
    * Runs clock_seq.
    */
   virtual task pre_reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'clock_seq':\n%s", clock_seq.sprint()), UVM_NONE)
      clock_seq.start(clock_agent.sequencer);
      `uvm_info("TEST", $sformatf("Finished 'clock_seq':\n%s", clock_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   /**
    * Runs rst_seq.
    */
   virtual task reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'rst_seq':\n%s", rst_seq.sprint()), UVM_NONE)
      rst_seq.start(rst_agent.sequencer);
      `uvm_info("TEST", $sformatf("Finished 'rst_seq':\n%s", rst_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   // pragma uvmx base_test_check_phase begin
   /**
    * Ensures that the number of overflow events observed and predicted match.
    */
   virtual function void check_phase(uvm_phase phase);
      if (env_cntxt.prd_overflow_count != env_cntxt.agent_cntxt.mon_overflow_count) begin
         `uvm_error("TEST", $sformatf("Number of predicte overflow events (%0d) and observed (%0d) do not match", env_cntxt.prd_overflow_count, env_cntxt.agent_cntxt.mon_overflow_count))
      end
   endfunction
   // pragma uvmx base_test_check_phase end

   // pragma uvmx base_test_report_phase begin
   // pragma uvmx base_test_report_phase end
   
   // pragma uvmx base_test_methods begin
   // pragma uvmx base_test_methods end

endclass


`endif // __UVMT_MAPU_B_BASE_TEST_SV__