// Copyright 2024 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_BASE_TEST_SV__
`define __UVMT_MAPU_B_BASE_TEST_SV__


/**
 * Abstract Test from which all other Matrix APU Block Tests must extend.
 * Subclasses must provide stimulus via sequencer by implementing UVM runtime phases.
 * @ingroup uvmt_mapu_b_tests
 */
class uvmt_mapu_b_base_test_c extends uvmx_block_sb_test_c #(
   .T_CFG      (uvmt_mapu_b_test_cfg_c),
   .T_ENV_CFG  (uvme_mapu_b_cfg_c     ),
   .T_ENV_CNTXT(uvme_mapu_b_cntxt_c   ),
   .T_ENV      (uvme_mapu_b_env_c     ),
   .T_ENV_SQR  (uvme_mapu_b_sqr_c     )
);

   /// @name Agents
   /// @{
   uvma_clk_agent_c  clk_agent; ///< Clock agent.
   uvma_reset_agent_c  reset_n_agent; ///< Reset agent.
   /// @}

   /// @name Default Sequences
   /// @{
   rand uvma_clk_start_seq_c  clk_seq; ///< Starts Clock generation during pre_reset_phase.
   rand uvma_reset_pulse_seq_c  reset_n_seq; ///< Asserts Reset during reset_phase.
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
      clk_seq.frequency == test_cfg.clk_frequency;
   }

   /**
    * Sets variable bus widths.
    */
   constraint parameter_cons {
      env_cfg.data_width == `UVMT_MAPU_B_DATA_WIDTH;
   }

   // pragma uvmx cfg_constraints begin
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mapu_b_base_test", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx cfg_constructor begin
      // pragma uvmx cfg_constructor end
   endfunction

   /**
    * Creates agent components.
    */
   virtual function void create_components();
      clk_agent = uvma_clk_agent_c::type_id::create("clk_agent", this);
      reset_n_agent = uvma_reset_agent_c::type_id::create("reset_n_agent", this);
      // pragma uvmx cfg_create_components begin
      // pragma uvmx cfg_create_components end
   endfunction

   /**
    * Connects the reset agent to the environment's reset port.
    */
   virtual function void connect_env_reset();
      reset_n_agent.reset_mon_trn_ap.connect(env.reset_mon_trn_export);
      // pragma uvmx cfg_connect_env_reset begin
      // pragma uvmx cfg_connect_env_reset end
   endfunction

   /**
    * Assigns configuration objects to agents.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_clk_cfg_c)::set(this, "clk_agent", "cfg", test_cfg.clk_agent_cfg);
      uvm_config_db#(uvma_reset_cfg_c)::set(this, "reset_n_agent", "cfg", test_cfg.reset_n_agent_cfg);
      // pragma uvmx cfg_assign_cfg begin
      // pragma uvmx cfg_assign_cfg end
   endfunction

   /**
    * Creates Clock and Reset Sequences.
    */
   virtual function void create_clk_reset_sequences();
      clk_seq = uvma_clk_start_seq_c::type_id::create("clk_seq");
      reset_n_seq = uvma_reset_pulse_seq_c::type_id::create("reset_n_seq");
      // pragma uvmx cfg_create_clk_reset_sequences begin
      // pragma uvmx cfg_create_clk_reset_sequences end
   endfunction

/**
    * Runs clk_seq.
    */
   virtual task pre_reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'clk_seq':\n%s", clk_seq.sprint()), UVM_NONE)
      clk_seq.start(clk_agent.sequencer);
      `uvm_info("TEST", $sformatf("Finished 'clk_seq':\n%s", clk_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   /**
    * Runs reset_n_seq.
    */
   virtual task reset_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'reset_n_seq':\n%s", reset_n_seq.sprint()), UVM_NONE)
      reset_n_seq.start(reset_n_agent.sequencer);
      `uvm_info("TEST", $sformatf("Finished 'reset_n_seq':\n%s", reset_n_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   // pragma uvmx base_test_methods begin
   /**
    * Ensures that the number of overflow events observed and predicted match.
    */
   virtual function void check_phase(uvm_phase phase);
      if (env_cntxt.prd_overflow_count != env_cntxt.agent_cntxt.mon_overflow_count) begin
         `uvm_error("TEST", $sformatf("Number of predicte overflow events (%0d) and observed (%0d) do not match", env_cntxt.prd_overflow_count, env_cntxt.agent_cntxt.mon_overflow_count))
      end
   endfunction
   // pragma uvmx base_test_methods end

endclass


`endif // __UVMT_MAPU_B_BASE_TEST_SV__