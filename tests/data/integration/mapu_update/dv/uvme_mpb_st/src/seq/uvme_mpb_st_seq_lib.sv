// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVME_MPB_ST_SEQ_LIB_SV__
`define __UVME_MPB_ST_SEQ_LIB_SV__


`include "uvme_mpb_st_base_seq.sv"
`include "uvme_mpb_st_fix_stim_seq.sv"
`include "uvme_mpb_st_bit_bash_seq.sv"

// pragma uvmx seq_lib_includes begin
// pragma uvmx seq_lib_includes end

/**
 * Sequence Library containing Sequences for Matrix Peripheral Bus Agent Self-Test Environment.
 * @ingroup uvme_mpb_st_seq
 */
class uvme_mpb_st_seq_lib_c extends uvmx_seq_lib_c #(
   .T_SEQ_ITEM(uvmx_seq_item_c)
);

   // pragma uvmx seq_lib_fields begin
   // pragma uvmx seq_lib_fields end


   `uvm_object_utils_begin(uvme_mpb_st_seq_lib_c)
      // pragma uvmx seq_lib_uvm_field_macros begin
      // pragma uvmx seq_lib_uvm_field_macros end
   `uvm_object_utils_end
   `uvm_sequence_library_utils(uvme_mpb_st_seq_lib_c)

   /**
    * Default constructor.
    */
   function new(string name="uvme_mpb_st_seq_lib");
      super.new(name);
   endfunction

   /**
    * Adds sequences to library.
    */
   virtual function void add_lib_sequences();
      // pragma uvmx seq_lib_add_lib_sequences begin
      add_sequence(uvme_mpb_st_fix_stim_seq_c::get_type());
      add_sequence(uvme_mpb_st_bit_bash_seq_c::get_type());
      // pragma uvmx seq_lib_add_lib_sequences end
   endfunction

   // pragma uvmx seq_lib_methods begin
   // pragma uvmx seq_lib_methods end

endclass


`endif // __UVME_MPB_ST_SEQ_LIB_SV__