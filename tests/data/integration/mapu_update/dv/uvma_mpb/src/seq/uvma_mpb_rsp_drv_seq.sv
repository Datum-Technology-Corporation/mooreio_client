// Copyright 2025 Datron Limited Partnership
// SPDX-License-Identifier: MIT
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`ifndef __UVMA_MPB_RSP_DRV_SEQ_SV__
`define __UVMA_MPB_RSP_DRV_SEQ_SV__


/**
 * Response: Drives secondary response
 * @ingroup uvma_mpb_seq
 */
class uvma_mpb_rsp_drv_seq_c extends uvma_mpb_base_seq_c;

   `uvm_object_utils(uvma_mpb_rsp_drv_seq_c)
   `uvmx_drv_seq(uvma_mpb_rsp_drv_seq_c)

   /**
    * Default constructor.
    */
   function new(string name="uvma_mpb_rsp_drv_seq");
      super.new(name);
   endfunction

   // pragma uvmx rsp_drv_seq_dox begin
   /**
    * TODO Implement uvma_mpb_rsp_drv_seq_c::drive()
    */
   // pragma uvmx rsp_drv_seq_dox end
   virtual task drive();
      // pragma uvmx rsp_drv_seq_drive begin
      uvma_mpb_p_mon_trn_c  p_trn;
      bit  handled;
      forever begin
         do begin
            `uvmx_peek_mon_trn(p_trn, p_mon_trn_fifo)
         end while (p_trn.vld !== 1);
         `uvmx_rsp_dispatch(rsp_handlers, p_trn, handled)
      end
      // pragma uvmx rsp_drv_seq_drive end
   endtask

   // pragma uvmx rsp_drv_seq_methods begin
   // pragma uvmx rsp_drv_seq_methods end

endclass


`endif // __UVMA_MPB_RSP_DRV_SEQ_SV__