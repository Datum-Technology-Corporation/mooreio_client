// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_BIT_BASH_SEQ_SV__
`define __UVME_MPB_ST_BIT_BASH_SEQ_SV__


/**
 * Bit Bash: Runs UVM Reg Bit Bash Sequence on reg block.
 * @ingroup uvme_mpb_st_seq_functional
 */
class uvme_mpb_st_bit_bash_seq_c extends uvme_mpb_st_base_seq_c;

   // pragma uvmx bit_bash_seq_fields begin
   // pragma uvmx bit_bash_seq_fields end


   `uvm_object_utils_begin(uvme_mpb_st_bit_bash_seq_c)
      // pragma uvmx bit_bash_seq_uvm_field_macros begin
      // pragma uvmx bit_bash_seq_uvm_field_macros end
   `uvm_object_utils_end


   // pragma uvmx bit_bash_seq_constraints begin
   /**
    * Restricts randomization space.
    */
   constraint rules_cons {
      // ...
   }
   // pragma uvmx bit_bash_seq_constraints end


   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_bit_bash_seq");
      super.new(name);
   endfunction

   // pragma uvmx functional_bit_bash_seq_build_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_bit_bash_seq_build_dox end
   virtual function void build();
      // pragma uvmx functional_bit_bash_seq_build begin
      // pragma uvmx functional_bit_bash_seq_build end
   endfunction

   // pragma uvmx functional_bit_bash_seq_create_sequences_dox begin
   /**
    * Empty
    */
   // pragma uvmx functional_bit_bash_seq_create_sequences_dox end
   virtual function void create_sequences();
      // pragma uvmx functional_bit_bash_seq_create_sequences begin
      // pragma uvmx functional_bit_bash_seq_create_sequences end
   endfunction

   // pragma uvmx bit_bash_seq_post_randomize_work begin
   /**
    * TODO Implement or remove uvme_mpb_st_bit_bash_seq_c::post_randomize_work()
    */
   virtual function void post_randomize_work();
   endfunction
   // pragma uvmx bit_bash_seq_post_randomize_work end

   // pragma uvmx bit_bash_seq_body begin
   /**
    * Creates and runs the UVM Bit Bash register sequence on MAIN Agent sequencer.
    */
   virtual task body();
      uvm_reg_bit_bash_seq  bit_bash_seq = uvm_reg_bit_bash_seq::type_id::create("bit_bash_seq");
      bit_bash_seq.model = cntxt.reg_model;
      bit_bash_seq.start(p_sequencer.main_sequencer);
   endtask
   // pragma uvmx bit_bash_seq_body end

   // pragma uvmx bit_bash_seq_methods begin
   // pragma uvmx bit_bash_seq_methods end

endclass


`endif // __UVME_MPB_ST_BIT_BASH_SEQ_SV__