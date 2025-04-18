// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_FIX_STIM_TEST_SV__
`define __UVMT_MPB_ST_FIX_STIM_TEST_SV__


/**
 * Fixed Stimulus: Checks basic agent functionality in both directions.
 * @ingroup uvmt_mpb_st_tests_functional
 */
class uvmt_mpb_st_fix_stim_test_c extends uvmt_mpb_st_base_test_c;

   /// @name Sequences
   /// @{
   rand uvme_mpb_st_fix_stim_seq_c  fix_stim_seq; ///< Fixed Stimulus
   /// @}

   // pragma uvmx fix_stim_test_fields begin
   // pragma uvmx fix_stim_test_fields end


   `uvm_component_utils_begin(uvmt_mpb_st_fix_stim_test_c)
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
   function new(string name="uvmt_mpb_st_fix_stim_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx fix_stim_test_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx fix_stim_test_build_dox end
   virtual function void build();
      // pragma uvmx fix_stim_test_build begin
      // pragma uvmx fix_stim_test_build end
   endfunction

   // pragma uvmx fix_stim_test_create_sequences_dox begin
   /**
    * Creates sequences fix_stim_seq.
    */
   // pragma uvmx fix_stim_test_create_sequences_dox end
   virtual function void create_sequences();
      fix_stim_seq = uvme_mpb_st_fix_stim_seq_c::type_id::create("fix_stim_seq");
      // pragma uvmx fix_stim_create_sequences begin
      // pragma uvmx fix_stim_create_sequences end
   endfunction

   // pragma uvmx fix_stim_test_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mpb_st_fix_stim_test_c::post_randomize_work()
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

   // pragma uvmx fix_stim_test_check_phase begin
   // pragma uvmx fix_stim_test_check_phase end

   // pragma uvmx fix_stim_test_report_phase begin
   /**
    * TODO Implement ore remove uvmt_mpb_st_fix_stim_test_c::report_phase()
    */
   virtual function void report_phase(uvm_phase phase);
      `uvmx_test_report({
         $sformatf("Scoreboard 'Agent Main-to-Secondary' observed %0d matches", env_cntxt.agent_m2s_scoreboard_cntxt.match_count),
         $sformatf("Scoreboard 'End-to-end' observed %0d matches", env_cntxt.e2e_scoreboard_cntxt.match_count)
      })
   endfunction
   // pragma uvmx fix_stim_test_report_phase end

   // pragma uvmx fix_stim_test_methods begin
   // pragma uvmx fix_stim_test_methods end

endclass


`endif // __UVMT_MPB_ST_FIX_STIM_TEST_SV__