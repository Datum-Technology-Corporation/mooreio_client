// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_BASE_TEST_SV__
`define __UVMT_MPB_ST_BASE_TEST_SV__


/**
 * Abstract Test from which all other Matrix Peripheral Bus Agent Self-Tests must extend.
 * Subclasses must provide stimulus via sequencer by implementing UVM runtime phases.
 * @ingroup uvmt_mpb_st_tests
 */
class uvmt_mpb_st_base_test_c extends uvmx_agent_test_c #(
   .T_CFG      (uvmt_mpb_st_test_cfg_c),
   .T_ENV_CFG  (uvme_mpb_st_cfg_c     ),
   .T_ENV_CNTXT(uvme_mpb_st_cntxt_c   ),
   .T_ENV      (uvme_mpb_st_env_c     ),
   .T_ENV_SQR  (uvme_mpb_st_sqr_c     )
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


   `uvm_component_utils_begin(uvmt_mpb_st_base_test_c)
      // pragma uvmx base_test_uvm_field_macros begin
      // pragma uvmx base_test_uvm_field_macros end
   `uvm_component_utils_end
   `include "uvmt_mpb_st_base_test_workarounds.sv"


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
      env_cfg.data_width == `UVMT_MPB_ST_DATA_WIDTH;
      env_cfg.addr_width == `UVMT_MPB_ST_ADDR_WIDTH;
   }

   // pragma uvmx cfg_constraints begin
   // pragma uvmx cfg_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mpb_st_base_test", uvm_component parent=null);
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
      // pragma uvmx cfg_create_clk_reset_sequences begin
      // pragma uvmx cfg_create_clk_reset_sequences end
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
    * TODO Implement or remove uvmt_mpb_st_base_test_c::post_randomize_work()
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
      // pragma uvmx cfg_create_components begin
      // pragma uvmx cfg_create_components end
   endfunction

   /**
    * Connects the reset agent to the environment's reset port.
    */
   virtual function void connect_env_reset();
      rst_agent.reset_mon_trn_ap.connect(env.reset_mon_trn_export);
      // pragma uvmx cfg_connect_env_reset begin
      // pragma uvmx cfg_connect_env_reset end
   endfunction

   /**
    * Assigns configuration objects to agents.
    */
   virtual function void assign_cfg();
      uvm_config_db#(uvma_clk_cfg_c)::set(this, "clock_agent", "cfg", test_cfg.clock_agent_cfg);
      uvm_config_db#(uvma_reset_cfg_c)::set(this, "rst_agent", "cfg", test_cfg.rst_agent_cfg);
      // pragma uvmx cfg_assign_cfg begin
      // pragma uvmx cfg_assign_cfg end
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
    * TODO Implement or remove uvmt_mpb_st_base_test_c::check_phase()
    */
   virtual function void check_phase(uvm_phase phase);
      /* Example:
         if (env_cntxt.agent_m2s_scoreboard_cntxt.match_count == 0)) begin
            `uvm_error("TEST", "Scoreboard 'Agent Main-to-Secondary' did not observe any matches"))
         end
         if (env_cntxt.agent_s2m_scoreboard_cntxt.match_count == 0)) begin
            `uvm_error("TEST", "Scoreboard 'Agent Secondary-to-Main' did not observe any matches"))
         end
         if (env_cntxt.e2e_scoreboard_cntxt.match_count == 0)) begin
            `uvm_error("TEST", "Scoreboard 'End-to-end' did not observe any matches"))
         end
      */
   endfunction
   // pragma uvmx base_test_check_phase end

   // pragma uvmx base_test_report_phase begin
   /**
    * TODO Implement ore remove uvmt_mpb_st_base_test_c::report_phase()
    */
   virtual function void report_phase(uvm_phase phase);
   endfunction
   // pragma uvmx base_test_report_phase end

   // pragma uvmx base_test_methods begin
   // pragma uvmx base_test_methods end

endclass


`endif // __UVMT_MPB_ST_BASE_TEST_SV__