// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_RSP_BASE_SEQ_SV__
`define __UVMA_MPB_RSP_BASE_SEQ_SV__


/**
 * Responder: Responder sequences for secondary mode
 * @ingroup uvma_mpb_seq_rsp
 */
class uvma_mpb_rsp_base_seq_c extends uvma_mpb_base_seq_c;

   `uvm_object_utils(uvma_mpb_rsp_base_seq_c)
   // pragma uvmx rsp_rsp_handler_macro begin
   `uvmx_rsp_handler_seq(rsp_handlers)
   // pragma uvmx rsp_rsp_handler_macro end

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_rsp_base_seq");
      super.new(name);
   endfunction

   // pragma uvmx rsp_base_seq_drive_rsp_dox begin
   /**
    * TODO Define response handler method signature
    */
   // pragma uvmx rsp_base_seq_drive_rsp_dox end
   virtual task drive_rsp(output bit handled,
      // pragma uvmx rsp_base_seq_drive_rsp_sig begin
      ref uvma_mpb_p_mon_trn_c  trn
      // pragma uvmx rsp_base_seq_drive_rsp_sig end
   );
      `uvm_fatal("RSP_BASE_SEQ", "Call to pure virtual task")
   endtask

   // pragma uvmx rsp_base_seq_methods begin
   // pragma uvmx rsp_base_seq_methods end

endclass


`endif // __UVMA_MPB_RSP_BASE_SEQ_SV__