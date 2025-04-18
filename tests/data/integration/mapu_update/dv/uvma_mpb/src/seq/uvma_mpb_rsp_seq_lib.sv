// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_RSP_SEQ_LIB_SV__
`define __UVMA_MPB_RSP_SEQ_LIB_SV__


`include "uvma_mpb_rsp_base_seq.sv"
`include "uvma_mpb_rsp_mem_seq.sv"

// pragma uvmx seq_lib_includes begin
// pragma uvmx seq_lib_includes end

/**
 * Sequence Library containing Responder Sequences.
 * @ingroup uvma_mpb_seq_rsp
 */
class uvma_mpb_rsp_seq_lib_c extends uvmx_seq_lib_c #(
   .T_SEQ_ITEM(uvmx_seq_item_c)
);

   // pragma uvmx seq_lib_fields begin
   // pragma uvmx seq_lib_fields end


   `uvm_object_utils_begin(uvma_mpb_rsp_seq_lib_c)
      // pragma uvmx seq_lib_uvm_field_macros begin
      // pragma uvmx seq_lib_uvm_field_macros end
   `uvm_object_utils_end
   `uvm_sequence_library_utils(uvma_mpb_rsp_seq_lib_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_rsp_seq_lib");
      super.new(name);
   endfunction

   /**
    * Adds sequences to library.
    */
   virtual function void add_lib_sequences();
      // pragma uvmx seq_lib_add_lib_sequences begin
      add_sequence(uvma_mpb_rsp_mem_seq_c::get_type());
      // pragma uvmx seq_lib_add_lib_sequences end
   endfunction

   // pragma uvmx seq_lib_methods begin
   // pragma uvmx seq_lib_methods end

endclass


`endif // __UVMA_MPB_RSP_SEQ_LIB_SV__