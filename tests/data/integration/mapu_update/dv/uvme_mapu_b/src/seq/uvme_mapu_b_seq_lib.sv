// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MAPU_B_SEQ_LIB_SV__
`define __UVME_MAPU_B_SEQ_LIB_SV__


`include "uvme_mapu_b_base_seq.sv"
`include "uvme_mapu_b_fix_stim_seq.sv"
`include "uvme_mapu_b_fix_ill_stim_seq.sv"
`include "uvme_mapu_b_rand_stim_seq.sv"
`include "uvme_mapu_b_rand_ill_stim_seq.sv"

// pragma uvmx seq_lib_includes begin
// pragma uvmx seq_lib_includes end

/**
 * Sequence Library containing Sequences for Matrix APU Block Environment.
 * @ingroup uvme_mapu_b_seq
 */
class uvme_mapu_b_seq_lib_c extends uvmx_seq_lib_c #(
   .T_SEQ_ITEM(uvmx_seq_item_c)
);

   // pragma uvmx seq_lib_fields begin
   // pragma uvmx seq_lib_fields end


   `uvm_object_utils_begin(uvme_mapu_b_seq_lib_c)
      // pragma uvmx seq_lib_uvm_field_macros begin
      // pragma uvmx seq_lib_uvm_field_macros end
   `uvm_object_utils_end
   `uvm_sequence_library_utils(uvme_mapu_b_seq_lib_c)

   /**
    * Default constructor.
    */
   function new(string name="uvme_mapu_b_seq_lib");
      super.new(name);
      // pragma uvmx seq_lib_constructor begin
      // pragma uvmx seq_lib_constructor end
   endfunction

   /**
    * Adds sequences to library.
    */
   virtual function void add_lib_sequences();
      // pragma uvmx seq_lib_body begin
      add_sequence(uvme_mapu_b_fix_stim_seq_c::get_type());
      add_sequence(uvme_mapu_b_fix_ill_stim_seq_c::get_type());
      add_sequence(uvme_mapu_b_rand_stim_seq_c::get_type());
      add_sequence(uvme_mapu_b_rand_ill_stim_seq_c::get_type());
      // pragma uvmx seq_lib_body end
   endfunction

   // pragma uvmx seq_lib_methods begin
   // pragma uvmx seq_lib_methods end

endclass


`endif // __UVME_MAPU_B_SEQ_LIB_SV__