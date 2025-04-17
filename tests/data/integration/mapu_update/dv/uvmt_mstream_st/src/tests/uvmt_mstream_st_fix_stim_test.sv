// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MSTREAM_ST_FIX_STIM_TEST_SV__
`define __UVMT_MSTREAM_ST_FIX_STIM_TEST_SV__


/**
 * Fixed Stimulus: Checks basic functionality with fixed valid stimulus and scoreboarding.
 * @ingroup uvmt_mstream_st_tests_functional
 */
class uvmt_mstream_st_fix_stim_test_c extends uvmt_mstream_st_base_test_c;

   /// @name Sequences
   /// @{
   rand uvme_mstream_st_fix_stim_seq_c  fix_stim_seq; ///< 
   /// @}

   // pragma uvmx fix_stim_test_fields begin
   // pragma uvmx fix_stim_test_fields end


   `uvm_component_utils_begin(uvmt_mstream_st_fix_stim_test_c)
      // pragma uvmx fix_stim_uvm_field_macros begin
      `uvm_field_object(fix_stim_seq, UVM_DEFAULT)
      // pragma uvmx fix_stim_uvm_field_macros end
   `uvm_component_utils_end


   // pragma uvmx fix_stim_test_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      env_cfg.scoreboarding_enabled == 1;
   }
   // pragma uvmx fix_stim_test_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mstream_st_fix_stim_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   /**
    * Creates sequences fix_stim_seq.
    */
   virtual function void create_sequences();
      fix_stim_seq = uvme_mstream_st_fix_stim_seq_c::type_id::create("fix_stim_seq");
   endfunction

   // pragma uvmx fix_stim_test_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mstream_st_fix_stim_test_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx fix_stim_test_post_randomize_work end

   /**
    * Runs fix_stim_seq.
    */
   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'fix_stim_seq':\n%s", fix_stim_seq.sprint()), UVM_NONE)
      fix_stim_seq.start(sequencer);
      `uvm_info("TEST", $sformatf("Finished 'fix_stim_seq':\n%s", fix_stim_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   // pragma uvmx fix_stim_test_methods begin
   /**
    * Ensures that test goals were met.
    */
   virtual function void check_phase(uvm_phase phase);
      if (env_cntxt.agent_ig_scoreboard_cntxt.match_count == 0) begin
         `uvm_error("TEST", "Scoreboard 'agent_ig' did not see any matches during simulation")
      end
      if (env_cntxt.agent_eg_scoreboard_cntxt.match_count == 0) begin
         `uvm_error("TEST", "Scoreboard 'agent_eg' did not see any matches during simulation")
      end
      if (env_cntxt.e2e_ig_scoreboard_cntxt.match_count == 0) begin
         `uvm_error("TEST", "Scoreboard 'e2e_ig' did not see any matches during simulation")
      end
      if (env_cntxt.e2e_eg_scoreboard_cntxt.match_count == 0) begin
         `uvm_error("TEST", "Scoreboard 'e2e_eg' did not see any matches during simulation")
      end
   endfunction

   /**
    * Prints end-of-test goals report.
    */
   virtual function void report_phase(uvm_phase phase);
      `uvmx_test_report({
         $sformatf("Scoreboard 'agent_ig' saw %0d matches during simulation", env_cntxt.agent_ig_scoreboard_cntxt.match_count),
         $sformatf("Scoreboard 'agent_eg' saw %0d matches during simulation", env_cntxt.agent_eg_scoreboard_cntxt.match_count),
         $sformatf("Scoreboard 'e2e_ig' saw %0d matches during simulation", env_cntxt.e2e_ig_scoreboard_cntxt.match_count),
         $sformatf("Scoreboard 'e2e_eg' saw %0d matches during simulation", env_cntxt.e2e_eg_scoreboard_cntxt.match_count)
      })
   endfunction
   // pragma uvmx fix_stim_test_methods end

endclass


`endif // __UVMT_MSTREAM_ST_FIX_STIM_TEST_SV__