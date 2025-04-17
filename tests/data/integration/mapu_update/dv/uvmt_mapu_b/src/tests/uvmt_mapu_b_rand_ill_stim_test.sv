// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__
`define __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__


/**
 * Random Illegal Stimulus: Ensures robustness with a mix of valid and illegal, random stimulus with synchronized scoreboarding.
 * @ingroup uvmt_mapu_b_tests_error
 */
class uvmt_mapu_b_rand_ill_stim_test_c extends uvmt_mapu_b_base_test_c;

   /// @name Sequences
   /// @{
   rand uvme_mapu_b_rand_ill_stim_seq_c  rand_ill_stim_seq; ///< Random Illegal Stimulus
   /// @}

   // pragma uvmx rand_ill_stim_test_fields begin
   // pragma uvmx rand_ill_stim_test_fields end


   `uvm_component_utils_begin(uvmt_mapu_b_rand_ill_stim_test_c)
      // pragma uvmx rand_ill_stim_uvm_field_macros begin
      `uvm_field_object(rand_ill_stim_seq, UVM_DEFAULT)
      // pragma uvmx rand_ill_stim_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Assigns Command Line Interface parsed values to knobs/sequences.
    */
   constraint cli_args_cons {
      if (test_cfg.cli_num_items_override) { rand_ill_stim_seq.num_items == test_cfg.cli_num_items; }
      else { rand_ill_stim_seq.num_items == test_cfg.num_items; }
      if (test_cfg.cli_num_errors_override) { rand_ill_stim_seq.num_errors == test_cfg.cli_num_errors; }
      else { rand_ill_stim_seq.num_errors == test_cfg.num_errors; }
      if (test_cfg.cli_min_gap_override) { rand_ill_stim_seq.min_gap == test_cfg.cli_min_gap; }
      else { rand_ill_stim_seq.min_gap == test_cfg.min_gap; }
      if (test_cfg.cli_max_gap_override) { rand_ill_stim_seq.max_gap == test_cfg.cli_max_gap; }
      else { rand_ill_stim_seq.max_gap == test_cfg.max_gap; }
   }

   // pragma uvmx rand_ill_stim_test_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      env_cfg.scoreboarding_enabled == 1;
   }
   // pragma uvmx rand_ill_stim_test_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mapu_b_rand_ill_stim_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx rand_ill_stim_test_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx rand_ill_stim_test_build_dox end
   virtual function void build();
      // pragma uvmx rand_ill_stim_test_build begin
      // pragma uvmx rand_ill_stim_test_build end
   endfunction

   // pragma uvmx rand_ill_stim_test_create_sequences_dox begin
   /**
    * Creates sequences rand_ill_stim_seq.
    */
   // pragma uvmx rand_ill_stim_test_create_sequences_dox end
   virtual function void create_sequences();
      rand_ill_stim_seq = uvme_mapu_b_rand_ill_stim_seq_c::type_id::create("rand_ill_stim_seq");
      // pragma uvmx rand_ill_stim_test_create_sequences begin
      // pragma uvmx rand_ill_stim_test_create_sequences end
   endfunction

   // pragma uvmx rand_ill_stim_test_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mapu_b_rand_ill_stim_test_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx rand_ill_stim_test_post_randomize_work end

   /**
    * Runs rand_ill_stim_seq.
    */
   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'rand_ill_stim_seq':\n%s", rand_ill_stim_seq.sprint()), UVM_NONE)
      rand_ill_stim_seq.start(sequencer);
      `uvm_info("TEST", $sformatf("Finished 'rand_ill_stim_seq':\n%s", rand_ill_stim_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   // pragma uvmx rand_ill_stim_test_check_phase begin
   /**
    * Ensures that test goals were met.
    */
   virtual function void check_phase(uvm_phase phase);
      if (!(env_cntxt.egress_scoreboard_cntxt.match_count == (test_cfg.num_items-test_cfg.num_errors))) begin
         `uvm_error("TEST", $sformatf("Scoreboard 'Egress' did not observe %0d matches:  %0d matches", (test_cfg.num_items-test_cfg.num_errors), env_cntxt.egress_scoreboard_cntxt.match_count))
      end
   endfunction
   // pragma uvmx rand_ill_stim_test_check_phase end

   // pragma uvmx rand_ill_stim_test_report_phase begin
   /**
    * Prints end-of-test goals report.
    */
   virtual function void report_phase(uvm_phase phase);
      `uvmx_test_report({
         $sformatf("Scoreboard 'Egress' observed %0d matches", env_cntxt.egress_scoreboard_cntxt.match_count)
      })
   endfunction
   // pragma uvmx rand_ill_stim_test_report_phase end

   // pragma uvmx rand_ill_stim_test_methods begin
   // pragma uvmx rand_ill_stim_test_methods end

endclass


`endif // __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__