// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMT_MPB_ST_BIT_BASH_TEST_SV__
`define __UVMT_MPB_ST_BIT_BASH_TEST_SV__


/**
 * Bit Bash: Checks thorough functionality for Read/Write across all kinds of register sizes and access policies.
 * @ingroup uvmt_mpb_st_tests_functional
 */
class uvmt_mpb_st_bit_bash_test_c extends uvmt_mpb_st_base_test_c;

   /// @name Sequences
   /// @{
   rand uvme_mpb_st_bit_bash_seq_c  bit_bash_seq; ///< Bit Bash
   /// @}

   // pragma uvmx bit_bash_test_fields begin
   // pragma uvmx bit_bash_test_fields end


   `uvm_component_utils_begin(uvmt_mpb_st_bit_bash_test_c)
      // pragma uvmx bit_bash_uvm_field_macros begin
      `uvm_field_object(bit_bash_seq, UVM_DEFAULT)
      // pragma uvmx bit_bash_uvm_field_macros end
   `uvm_component_utils_end


   // pragma uvmx bit_bash_test_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      env_cfg.scoreboarding_enabled == 1;
   }
   // pragma uvmx bit_bash_test_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvmt_mpb_st_bit_bash_test", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   // pragma uvmx bit_bash_test_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx bit_bash_test_build_dox end
   virtual function void build();
      // pragma uvmx bit_bash_test_build begin
      // pragma uvmx bit_bash_test_build end
   endfunction

   // pragma uvmx bit_bash_test_create_sequences_dox begin
   /**
    * Creates sequences bit_bash_seq.
    */
   // pragma uvmx bit_bash_test_create_sequences_dox end
   virtual function void create_sequences();
      bit_bash_seq = uvme_mpb_st_bit_bash_seq_c::type_id::create("bit_bash_seq");
      // pragma uvmx bit_bash_create_sequences begin
      // pragma uvmx bit_bash_create_sequences end
   endfunction

   // pragma uvmx bit_bash_test_post_randomize_work begin
   /**
    * TODO Implement or remove uvmt_mpb_st_bit_bash_test_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx bit_bash_test_post_randomize_work end

   /**
    * Runs bit_bash_seq.
    */
   virtual task main_phase(uvm_phase phase);
      phase.raise_objection(this);
      `uvm_info("TEST", $sformatf("Starting 'bit_bash_seq':\n%s", bit_bash_seq.sprint()), UVM_NONE)
      bit_bash_seq.start(sequencer);
      `uvm_info("TEST", $sformatf("Finished 'bit_bash_seq':\n%s", bit_bash_seq.sprint()), UVM_NONE)
      phase.drop_objection(this);
   endtask

   // pragma uvmx bit_bash_test_check_phase begin
   /**
    * TODO Implement or remove uvmt_mpb_st_bit_bash_test_c::check_phase()
    */
   virtual function void check_phase(uvm_phase phase);
   endfunction
   // pragma uvmx bit_bash_test_check_phase end

   // pragma uvmx bit_bash_test_report_phase begin
   /**
    * TODO Implement ore remove uvmt_mpb_st_bit_bash_test_c::report_phase()
    */
   virtual function void report_phase(uvm_phase phase);
      `uvmx_test_report({
         $sformatf("Scoreboard 'Agent Main-to-Secondary' observed %0d matches", env_cntxt.agent_m2s_scoreboard_cntxt.match_count),
         $sformatf("Scoreboard 'End-to-end' observed %0d matches", env_cntxt.e2e_scoreboard_cntxt.match_count)
      })
   endfunction
   // pragma uvmx bit_bash_test_report_phase end

   // pragma uvmx bit_bash_test_methods begin
   // pragma uvmx bit_bash_test_methods end

endclass


`endif // __UVMT_MPB_ST_BIT_BASH_TEST_SV__