// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__
`define __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__


/**
 * Ensures robustness with a mix of valid and illegal, random stimulus with synchronized scoreboarding.
 * @ingroup uvmt_mapu_b_tests_error
 */
class uvmt_mapu_b_rand_ill_stim_test_c extends uvmt_mapu_b_base_test_c;

   /// @name Sequences
   /// @{
   rand uvme_mapu_b_rand_ill_stim_seq_c  rand_ill_stim_seq; ///< Executes during 'main_phase()'
   /// @}

   // pragma uvmx rand_ill_stim_seq_fields begin
   // pragma uvmx rand_ill_stim_seq_fields end


   `uvm_component_utils_begin(uvmt_mapu_b_rand_ill_stim_test_c)
      // pragma uvmx rand_ill_stim_seq_uvm_field_macros begin
      `uvm_field_object(rand_ill_stim_seq, UVM_DEFAULT)
      // pragma uvmx rand_ill_stim_seq_uvm_field_macros end
   `uvm_component_utils_end


   /**
    * Assigns Command Line Interface parsed values to knobs/sequences.
    */
   constraint cli_cons {
      if (test_cfg.cli_num_items_override) {
         rand_ill_stim_seq.num_items == test_cfg.cli_num_items;
      }
      else {
         rand_ill_stim_seq.num_items == test_cfg.num_items;
      }
      if (test_cfg.cli_num_errors_override) {
         rand_ill_stim_seq.num_errors == test_cfg.cli_num_errors;
      }
      else {
         rand_ill_stim_seq.num_errors == test_cfg.num_errors;
      }
      if (test_cfg.cli_min_gap_override) {
         rand_ill_stim_seq.min_gap == test_cfg.cli_min_gap;
      }
      else {
         rand_ill_stim_seq.min_gap == test_cfg.min_gap;
      }
      if (test_cfg.cli_max_gap_override) {
         rand_ill_stim_seq.max_gap == test_cfg.cli_max_gap;
      }
      else {
         rand_ill_stim_seq.max_gap == test_cfg.max_gap;
      }
   }

   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      env_cfg.scoreboarding_enabled == 1;
   }
   
   // pragma uvmx rand_ill_stim_seq_constraints begin
   // pragma uvmx rand_ill_stim_seq_constraints end
   
   
   /**
    * Default constructor.
    */
   function new(string name="uvmt_mapu_b_rand_ill_stim_test", uvm_component parent=null);
      super.new(name, parent);
      // pragma uvmx rand_ill_stim_seq_constructor begin
      // pragma uvmx rand_ill_stim_seq_constructor end
   endfunction

   /**
    * Creates sequence rand_ill_stim_seq.
    */
   virtual function void create_sequences();
      rand_ill_stim_seq = uvme_mapu_b_rand_ill_stim_seq_c::type_id::create("rand_ill_stim_seq");
      // pragma uvmx rand_ill_stim_seq_create_sequences begin
      // pragma uvmx rand_ill_stim_seq_create_sequences end
   endfunction

   /**
    * Runs rand_ill_stim_seq.
    */
   virtual task main_phase(uvm_phase phase);
      // pragma uvmx rand_ill_stim_seq_main_phase begin
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'rand_ill_stim_seq':\n%s", rand_ill_stim_seq.sprint()), UVM_NONE)
      rand_ill_stim_seq.start(sequencer);
      `uvm_info("TEST", $sformatf("Finished 'rand_ill_stim_seq':\n%s", rand_ill_stim_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
      // pragma uvmx rand_ill_stim_seq_main_phase end
   endtask

   /**
    * Ensures that test goals were met.
    */
   virtual function void check_phase(uvm_phase phase);
      // pragma uvmx rand_ill_stim_seq_check_phase begin
      if (!(env_cntxt.sb_cntxt.match_count == (test_cfg.num_items-test_cfg.num_errors))) begin
         `uvm_error("TEST", $sformatf("Scoreboard did not see %0d matches during simulation:  %0d matches", (test_cfg.num_items-test_cfg.num_errors), env_cntxt.sb_cntxt.match_count))
      end
      // pragma uvmx rand_ill_stim_seq_check_phase end
   endfunction

   /**
    * Prints end-of-test goals report.
    */
   virtual function void report_phase(uvm_phase phase);
      // pragma uvmx rand_ill_stim_seq_report_phase begin
      `uvmx_test_report({
         $sformatf("Scoreboard saw %0d matches during simulation", env_cntxt.sb_cntxt.match_count)
      })
      // pragma uvmx rand_ill_stim_seq_report_phase end
   endfunction

   // pragma uvmx rand_ill_stim_seq_methods begin
   // pragma uvmx rand_ill_stim_seq_methods end

endclass


`endif // __UVMT_MAPU_B_RAND_ILL_STIM_TEST_SV__